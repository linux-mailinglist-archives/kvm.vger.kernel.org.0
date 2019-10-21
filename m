Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD60DF855
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 00:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbfJUW6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 18:58:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:50811 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730405AbfJUW6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 18:58:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 15:58:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="209539352"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 21 Oct 2019 15:58:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Add separate helper for putting borrowed reference to kvm
Date:   Mon, 21 Oct 2019 15:58:42 -0700
Message-Id: <20191021225842.23941-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new helper, kvm_put_kvm_no_destroy(), to handle putting a borrowed
reference[*] to the VM when installing a new file descriptor fails.  KVM
expects the refcount to remain valid in this case, as the in-progress
ioctl() has an explicit reference to the VM.  The primary motiviation
for the helper is to document that the 'kvm' pointer is still valid
after putting the borrowed reference, e.g. to document that doing
mutex(&kvm->lock) immediately after putting a ref to kvm isn't broken.

[*] When exposing a new object to userspace via a file descriptor, e.g.
    a new vcpu, KVM grabs a reference to itself (the VM) prior to making
    the object visible to userspace to avoid prematurely freeing the VM
    in the scenario where userspace immediately closes file descriptor.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c |  2 +-
 arch/powerpc/kvm/book3s_64_vio.c    |  2 +-
 include/linux/kvm_host.h            |  1 +
 virt/kvm/kvm_main.c                 | 16 ++++++++++++++--
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 9a75f0e1933b..68678e31c84c 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -2000,7 +2000,7 @@ int kvm_vm_ioctl_get_htab_fd(struct kvm *kvm, struct kvm_get_htab_fd *ghf)
 	ret = anon_inode_getfd("kvm-htab", &kvm_htab_fops, ctx, rwflag | O_CLOEXEC);
 	if (ret < 0) {
 		kfree(ctx);
-		kvm_put_kvm(kvm);
+		kvm_put_kvm_no_destroy(kvm);
 		return ret;
 	}
 
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 5834db0a54c6..883a66e76638 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -317,7 +317,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 	if (ret >= 0)
 		list_add_rcu(&stt->list, &kvm->arch.spapr_tce_tables);
 	else
-		kvm_put_kvm(kvm);
+		kvm_put_kvm_no_destroy(kvm);
 
 	mutex_unlock(&kvm->lock);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 719fc3e15ea4..90a2102605ef 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -622,6 +622,7 @@ void kvm_exit(void);
 
 void kvm_get_kvm(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
+void kvm_put_kvm_no_destroy(struct kvm *kvm);
 
 static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67ef3f2e19e8..b8534c6b8cf6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -772,6 +772,18 @@ void kvm_put_kvm(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_put_kvm);
 
+/*
+ * Used to put a reference that was taken on behalf of an object associated
+ * with a user-visible file descriptor, e.g. a vcpu or device, if installation
+ * of the new file descriptor fails and the reference cannot be transferred to
+ * its final owner.  In such cases, the caller is still actively using @kvm and
+ * will fail miserably if the refcount unexpectedly hits zero.
+ */
+void kvm_put_kvm_no_destroy(struct kvm *kvm)
+{
+	WARN_ON(refcount_dec_and_test(&kvm->users_count));
+}
+EXPORT_SYMBOL_GPL(kvm_put_kvm_no_destroy);
 
 static int kvm_vm_release(struct inode *inode, struct file *filp)
 {
@@ -2679,7 +2691,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	kvm_get_kvm(kvm);
 	r = create_vcpu_fd(vcpu);
 	if (r < 0) {
-		kvm_put_kvm(kvm);
+		kvm_put_kvm_no_destroy(kvm);
 		goto unlock_vcpu_destroy;
 	}
 
@@ -3117,7 +3129,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 	kvm_get_kvm(kvm);
 	ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR | O_CLOEXEC);
 	if (ret < 0) {
-		kvm_put_kvm(kvm);
+		kvm_put_kvm_no_destroy(kvm);
 		mutex_lock(&kvm->lock);
 		list_del(&dev->vm_node);
 		mutex_unlock(&kvm->lock);
-- 
2.22.0


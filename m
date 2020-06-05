Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D59B1EFE7A
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 19:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgFERGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 13:06:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30282 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726252AbgFERGp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 13:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591376803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fn51+xgx98oZsB/D59Na1SLBQWdWeTshRNoFGM9XJVg=;
        b=FhIg8aK56SkWujMQEK4whbCDaJv8+sxO+NEfmxd731g4gbcn72SBl9D2cpsK/gDnS9fj4E
        2gyDWOaLue9JO31OkapiBcTUV3F9COhHqBP4mi2PuPO1nUtK33c/XbtruZq5ND4jJf6zu1
        pohJdYFF4SHWuJP0fqHYBLtlUCf5S/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-NfHEDjfTMZS_9-9DlOrH2w-1; Fri, 05 Jun 2020 13:06:42 -0400
X-MC-Unique: NfHEDjfTMZS_9-9DlOrH2w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2514E106B208;
        Fri,  5 Jun 2020 17:06:35 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EEAE707C7;
        Fri,  5 Jun 2020 17:06:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com,
        syzbot+705f4401d5a93a59b87d@syzkaller.appspotmail.com
Subject: [PATCH] KVM: let kvm_destroy_vm_debugfs clean up vCPU debugfs directories
Date:   Fri,  5 Jun 2020 13:06:33 -0400
Message-Id: <20200605170633.16766-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After commit 63d0434 ("KVM: x86: move kvm_create_vcpu_debugfs after
last failure point") we are creating the pre-vCPU debugfs files
after the creation of the vCPU file descriptor.  This makes it
possible for userspace to reach kvm_vcpu_release before
kvm_create_vcpu_debugfs has finished.  The vcpu->debugfs_dentry
then does not have any associated inode anymore, and this causes
a NULL-pointer dereference in debugfs_create_file.

The solution is simply to avoid removing the files; they are
cleaned up when the VM file descriptor is closed (and that must be
after KVM_CREATE_VCPU returns).  We can stop storing the dentry
in struct kvm_vcpu too, because it is not needed anywhere after
kvm_create_vcpu_debugfs returns.

Reported-by: syzbot+705f4401d5a93a59b87d@syzkaller.appspotmail.com
Fixes: 63d04348371b ("KVM: x86: move kvm_create_vcpu_debugfs after last failure point")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kvm/arm.c     |  5 -----
 arch/x86/kvm/debugfs.c   | 10 +++++-----
 include/linux/kvm_host.h |  3 +--
 virt/kvm/kvm_main.c      |  8 ++++----
 4 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7a57381c05e8..45276ed50dd6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -144,11 +144,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 }
 
-int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
 vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
 	return VM_FAULT_SIGBUS;
diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 018aebce33ff..7e818d64bb4d 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -43,22 +43,22 @@ static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
 
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits, NULL, "%llu\n");
 
-void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
+void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
 {
-	debugfs_create_file("tsc-offset", 0444, vcpu->debugfs_dentry, vcpu,
+	debugfs_create_file("tsc-offset", 0444, debugfs_dentry, vcpu,
 			    &vcpu_tsc_offset_fops);
 
 	if (lapic_in_kernel(vcpu))
 		debugfs_create_file("lapic_timer_advance_ns", 0444,
-				    vcpu->debugfs_dentry, vcpu,
+				    debugfs_dentry, vcpu,
 				    &vcpu_timer_advance_ns_fops);
 
 	if (kvm_has_tsc_control) {
 		debugfs_create_file("tsc-scaling-ratio", 0444,
-				    vcpu->debugfs_dentry, vcpu,
+				    debugfs_dentry, vcpu,
 				    &vcpu_tsc_scaling_fops);
 		debugfs_create_file("tsc-scaling-ratio-frac-bits", 0444,
-				    vcpu->debugfs_dentry, vcpu,
+				    debugfs_dentry, vcpu,
 				    &vcpu_tsc_scaling_frac_fops);
 	}
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f43b59b1294c..d38d6b9c24be 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -318,7 +318,6 @@ struct kvm_vcpu {
 	bool preempted;
 	bool ready;
 	struct kvm_vcpu_arch arch;
-	struct dentry *debugfs_dentry;
 };
 
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
@@ -888,7 +887,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
 
 #ifdef __KVM_HAVE_ARCH_VCPU_DEBUGFS
-void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu);
+void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry);
 #endif
 
 int kvm_arch_hardware_enable(void);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7fa1e38e1659..3577eb84eac0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2973,7 +2973,6 @@ static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
 
-	debugfs_remove_recursive(vcpu->debugfs_dentry);
 	kvm_put_kvm(vcpu->kvm);
 	return 0;
 }
@@ -3000,16 +2999,17 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
 #ifdef __KVM_HAVE_ARCH_VCPU_DEBUGFS
+	struct dentry *debugfs_dentry;
 	char dir_name[ITOA_MAX_LEN * 2];
 
 	if (!debugfs_initialized())
 		return;
 
 	snprintf(dir_name, sizeof(dir_name), "vcpu%d", vcpu->vcpu_id);
-	vcpu->debugfs_dentry = debugfs_create_dir(dir_name,
-						  vcpu->kvm->debugfs_dentry);
+	debugfs_dentry = debugfs_create_dir(dir_name,
+					    vcpu->kvm->debugfs_dentry);
 
-	kvm_arch_create_vcpu_debugfs(vcpu);
+	kvm_arch_create_vcpu_debugfs(vcpu, debugfs_dentry);
 #endif
 }
 
-- 
2.26.2


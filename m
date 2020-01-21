Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE5E14478F
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 23:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbgAUWdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 17:33:00 -0500
Received: from mga07.intel.com ([134.134.136.100]:44237 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728913AbgAUWcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 17:32:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 14:32:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,347,1574150400"; 
   d="scan'208";a="244845168"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 21 Jan 2020 14:32:04 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v5 16/19] KVM: Ensure validity of memslot with respect to kvm_get_dirty_log()
Date:   Tue, 21 Jan 2020 14:31:54 -0800
Message-Id: <20200121223157.15263-17-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200121223157.15263-1-sean.j.christopherson@intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework kvm_get_dirty_log() so that it "returns" the associated memslot
on success.  A future patch will rework memslot handling such that
id_to_memslot() can return NULL, returning the memslot makes it more
obvious that the validity of the memslot has been verified, i.e.
precludes the need to add validity checks in the arch code that are
technically unnecessary.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/kvm/book3s_pr.c |  6 +-----
 arch/s390/kvm/kvm-s390.c     | 12 ++----------
 include/linux/kvm_host.h     |  2 +-
 virt/kvm/kvm_main.c          | 27 +++++++++++++++++++--------
 4 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index c6d1fc3be91c..eb41e897e693 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1884,7 +1884,6 @@ static int kvmppc_vcpu_run_pr(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 static int kvm_vm_ioctl_get_dirty_log_pr(struct kvm *kvm,
 					 struct kvm_dirty_log *log)
 {
-	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 	struct kvm_vcpu *vcpu;
 	ulong ga, ga_end;
@@ -1894,15 +1893,12 @@ static int kvm_vm_ioctl_get_dirty_log_pr(struct kvm *kvm,
 
 	mutex_lock(&kvm->slots_lock);
 
-	r = kvm_get_dirty_log(kvm, log, &is_dirty);
+	r = kvm_get_dirty_log(kvm, log, &is_dirty, &memslot);
 	if (r)
 		goto out;
 
 	/* If nothing is dirty, don't bother messing with page tables. */
 	if (is_dirty) {
-		slots = kvm_memslots(kvm);
-		memslot = id_to_memslot(slots, log->slot);
-
 		ga = memslot->base_gfn << PAGE_SHIFT;
 		ga_end = ga + (memslot->npages << PAGE_SHIFT);
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index dacc13bb4465..3ca1a784590c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -610,9 +610,8 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 {
 	int r;
 	unsigned long n;
-	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int is_dirty = 0;
+	int is_dirty;
 
 	if (kvm_is_ucontrol(kvm))
 		return -EINVAL;
@@ -623,14 +622,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	if (log->slot >= KVM_USER_MEM_SLOTS)
 		goto out;
 
-	slots = kvm_memslots(kvm);
-	memslot = id_to_memslot(slots, log->slot);
-	r = -ENOENT;
-	if (!memslot->dirty_bitmap)
-		goto out;
-
-	kvm_arch_sync_dirty_log(kvm, memslot);
-	r = kvm_get_dirty_log(kvm, log, &is_dirty);
+	r = kvm_get_dirty_log(kvm, log, &is_dirty, &memslot);
 	if (r)
 		goto out;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a56ba1a3c8d0..f05be99dc44a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -823,7 +823,7 @@ void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm,
 #else /* !CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
 int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
-		      int *is_dirty);
+		      int *is_dirty, struct kvm_memory_slot **memslot);
 #endif
 
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 60692588f0fc..190c065da48d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1198,31 +1198,42 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 }
 
 #ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-int kvm_get_dirty_log(struct kvm *kvm,
-			struct kvm_dirty_log *log, int *is_dirty)
+/**
+ * kvm_get_dirty_log - get a snapshot of dirty pages
+ * @kvm:	pointer to kvm instance
+ * @log:	slot id and address to which we copy the log
+ * @is_dirty:	set to '1' if any dirty pages were found
+ * @memslot:	set to the associated memslot, always valid on success
+ */
+int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
+		      int *is_dirty, struct kvm_memory_slot **memslot)
 {
 	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
 	int i, as_id, id;
 	unsigned long n;
 	unsigned long any = 0;
 
+	*memslot = NULL;
+	*is_dirty = 0;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
 		return -EINVAL;
 
 	slots = __kvm_memslots(kvm, as_id);
-	memslot = id_to_memslot(slots, id);
-	if (!memslot->dirty_bitmap)
+	*memslot = id_to_memslot(slots, id);
+	if (!(*memslot)->dirty_bitmap)
 		return -ENOENT;
 
-	n = kvm_dirty_bitmap_bytes(memslot);
+	kvm_arch_sync_dirty_log(kvm, *memslot);
+
+	n = kvm_dirty_bitmap_bytes(*memslot);
 
 	for (i = 0; !any && i < n/sizeof(long); ++i)
-		any = memslot->dirty_bitmap[i];
+		any = (*memslot)->dirty_bitmap[i];
 
-	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
+	if (copy_to_user(log->dirty_bitmap, (*memslot)->dirty_bitmap, n))
 		return -EFAULT;
 
 	if (any)
-- 
2.24.1


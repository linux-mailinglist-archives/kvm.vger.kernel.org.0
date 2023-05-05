Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEDB6F85B8
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 17:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbjEEP3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 11:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbjEEP3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 11:29:39 -0400
Received: from smtp-8fa8.mail.infomaniak.ch (smtp-8fa8.mail.infomaniak.ch [83.166.143.168])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36AC150F8
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 08:29:30 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QCZD938BPzMq1NC;
        Fri,  5 May 2023 17:22:01 +0200 (CEST)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QCZD85V0tzMpt9P;
        Fri,  5 May 2023 17:22:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1683300121;
        bh=dkHjbqpuvSBmD/ZCnBFFFKsFtN1g9PxpijWtwL2weO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FR+pYomIgtrTj0WI3JRDUSbHVrdlibfnwQU30RKu6bstMqwIWNnbYH/f3efnA/++Y
         PVW9ePmH83Lzuo5sF3eA8Zxiu6x5s8zasun6j41FzXtbI7LfAbR7ieVBarIcdhpBG1
         xrxpuSnVobX97umCLQuu/zofOq0RUrhcLMOWIHuk=
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v1 4/9] KVM: x86: Add new hypercall to set EPT permissions
Date:   Fri,  5 May 2023 17:20:41 +0200
Message-Id: <20230505152046.6575-5-mic@digikod.net>
In-Reply-To: <20230505152046.6575-1-mic@digikod.net>
References: <20230505152046.6575-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new KVM_HC_LOCK_MEM_PAGE_RANGES hypercall that enables a guest to
set EPT permissions on a set of page ranges.

This hypercall takes three arguments.  The first contains the GPA
pointing to an array of struct heki_pa_range.  The second argument is
the size of the array, not the number of elements.  The third argument
is for future proofness and is designed to contains optional flags (e.g.
to change the array type), but must be zero for now.

The struct heki_pa_range contains a GFN that starts the range and
another that is the indicate the last (included) page.  A bit field of
attributes are tied to this range.

The HEKI_ATTR_MEM_NOWRITE attribute is interpreted as a removal of the
EPT write permission to deny any write access from the guest through its
lifetime.  We choose "nowrite" because "read-only" exclude
execution, it follows a deny-list approach, and most importantly because
it is an incremental addition to the status quo (i.e., everything is
allowed from the TDP point of view).  This is implemented thanks to the
KVM_PAGE_TRACK_PREWRITE mode previously introduced.

The page ranges recording is currently implemented with a static array
of 16 elements to make it simple, but this mechanism will be dynamic in
a follow-up.

Define a kernel command line parameter "heki" to turn the feature on or
off.  By default, Heki is turned on.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20230505152046.6575-5-mic@digikod.net
---
 Documentation/virt/kvm/x86/hypercalls.rst |  17 +++
 arch/x86/kvm/x86.c                        | 169 ++++++++++++++++++++++
 include/linux/kvm_host.h                  |  13 ++
 include/uapi/linux/kvm_para.h             |   1 +
 virt/kvm/kvm_main.c                       |   4 +
 5 files changed, 204 insertions(+)

diff --git a/Documentation/virt/kvm/x86/hypercalls.rst b/Documentation/virt/kvm/x86/hypercalls.rst
index 10db7924720f..0ec79cc77f53 100644
--- a/Documentation/virt/kvm/x86/hypercalls.rst
+++ b/Documentation/virt/kvm/x86/hypercalls.rst
@@ -190,3 +190,20 @@ the KVM_CAP_EXIT_HYPERCALL capability. Userspace must enable that capability
 before advertising KVM_FEATURE_HC_MAP_GPA_RANGE in the guest CPUID.  In
 addition, if the guest supports KVM_FEATURE_MIGRATION_CONTROL, userspace
 must also set up an MSR filter to process writes to MSR_KVM_MIGRATION_CONTROL.
+
+9. KVM_HC_LOCK_MEM_PAGE_RANGES
+------------------------------
+
+:Architecture: x86
+:Status: active
+:Purpose: Request memory page ranges to be restricted.
+
+- a0: physical address of a struct heki_pa_range array
+- a1: size of the array
+- a2: optional flags, must be 0 for now
+
+The hypercall lets a guest request memory permissions to be removed for itself,
+identified with set of physical page ranges (GFNs).  The HEKI_ATTR_MEM_NOWRITE
+memory page range attribute forbids related modification to the guest.
+
+Returns 0 on success or a KVM error code otherwise.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd05f42c9913..ffab64d08de3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -59,6 +59,7 @@
 #include <linux/mem_encrypt.h>
 #include <linux/entry-kvm.h>
 #include <linux/suspend.h>
+#include <linux/heki.h>
 
 #include <trace/events/kvm.h>
 
@@ -9596,6 +9597,161 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 	return;
 }
 
+#ifdef CONFIG_HEKI
+
+static int heki_page_track_add(struct kvm *const kvm, const gfn_t gfn,
+			       const enum kvm_page_track_mode mode)
+{
+	struct kvm_memory_slot *slot;
+	int idx;
+
+	BUILD_BUG_ON(!IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING));
+
+	idx = srcu_read_lock(&kvm->srcu);
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot) {
+		srcu_read_unlock(&kvm->srcu, idx);
+		return -EINVAL;
+	}
+
+	write_lock(&kvm->mmu_lock);
+	kvm_slot_page_track_add_page(kvm, slot, gfn, mode);
+	write_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+	return 0;
+}
+
+static bool
+heki_page_track_prewrite(struct kvm_vcpu *const vcpu, const gpa_t gpa,
+			 struct kvm_page_track_notifier_node *const node)
+{
+	const gfn_t gfn = gpa_to_gfn(gpa);
+	const struct kvm *const kvm = vcpu->kvm;
+	size_t i;
+
+	/* Checks if it is our own tracked pages, or those of someone else. */
+	for (i = 0; i < HEKI_GFN_MAX; i++) {
+		if (gfn >= kvm->heki_gfn_no_write[i].start &&
+		    gfn <= kvm->heki_gfn_no_write[i].end)
+			return false;
+	}
+
+	return true;
+}
+
+static int kvm_heki_init_vm(struct kvm *const kvm)
+{
+	struct kvm_page_track_notifier_node *const node =
+		kzalloc(sizeof(*node), GFP_KERNEL);
+
+	if (!node)
+		return -ENOMEM;
+
+	node->track_prewrite = heki_page_track_prewrite;
+	kvm_page_track_register_notifier(kvm, node);
+	return 0;
+}
+
+static bool is_gfn_overflow(unsigned long val)
+{
+	const gfn_t gfn_mask = gpa_to_gfn(~0);
+
+	return (val | gfn_mask) != gfn_mask;
+}
+
+#define HEKI_PA_RANGE_MAX_SIZE	(sizeof(struct heki_pa_range) * HEKI_GFN_MAX)
+
+static int heki_lock_mem_page_ranges(struct kvm *const kvm, gpa_t mem_ranges,
+				     unsigned long mem_ranges_size)
+{
+	int err;
+	size_t i, ranges_num;
+	struct heki_pa_range *ranges;
+
+	if (mem_ranges_size > HEKI_PA_RANGE_MAX_SIZE)
+		return -KVM_E2BIG;
+
+	if ((mem_ranges_size % sizeof(struct heki_pa_range)) != 0)
+		return -KVM_EINVAL;
+
+	ranges = kzalloc(mem_ranges_size, GFP_KERNEL);
+	if (!ranges)
+		return -KVM_E2BIG;
+
+	err = kvm_read_guest(kvm, mem_ranges, ranges, mem_ranges_size);
+	if (err) {
+		err = -KVM_EFAULT;
+		goto out_free_ranges;
+	}
+
+	ranges_num = mem_ranges_size / sizeof(struct heki_pa_range);
+	for (i = 0; i < ranges_num; i++) {
+		const u64 attributes_mask = HEKI_ATTR_MEM_NOWRITE;
+		const gfn_t gfn_start = ranges[i].gfn_start;
+		const gfn_t gfn_end = ranges[i].gfn_end;
+		const u64 attributes = ranges[i].attributes;
+
+		if (is_gfn_overflow(ranges[i].gfn_start)) {
+			err = -KVM_EINVAL;
+			goto out_free_ranges;
+		}
+		if (is_gfn_overflow(ranges[i].gfn_end)) {
+			err = -KVM_EINVAL;
+			goto out_free_ranges;
+		}
+		if (ranges[i].gfn_start > ranges[i].gfn_end) {
+			err = -KVM_EINVAL;
+			goto out_free_ranges;
+		}
+		if (!ranges[i].attributes) {
+			err = -KVM_EINVAL;
+			goto out_free_ranges;
+		}
+		if ((ranges[i].attributes | attributes_mask) !=
+		    attributes_mask) {
+			err = -KVM_EINVAL;
+			goto out_free_ranges;
+		}
+
+		if (attributes & HEKI_ATTR_MEM_NOWRITE) {
+			unsigned long gfn;
+			size_t gfn_i;
+
+			gfn_i = atomic_dec_if_positive(
+				&kvm->heki_gfn_no_write_num);
+			if (gfn_i == 0) {
+				err = -KVM_E2BIG;
+				goto out_free_ranges;
+			}
+
+			gfn_i--;
+			kvm->heki_gfn_no_write[gfn_i].start = gfn_start;
+			kvm->heki_gfn_no_write[gfn_i].end = gfn_end;
+
+			for (gfn = gfn_start; gfn <= gfn_end; gfn++)
+				WARN_ON_ONCE(heki_page_track_add(
+					kvm, gfn, KVM_PAGE_TRACK_PREWRITE));
+		}
+
+		pr_warn("heki-kvm: Locking GFN 0x%llx-0x%llx with %s\n",
+			gfn_start, gfn_end,
+			(attributes & HEKI_ATTR_MEM_NOWRITE) ? "[nowrite]" : "");
+	}
+
+out_free_ranges:
+	kfree(ranges);
+	return err;
+}
+
+#else /* CONFIG_HEKI */
+
+static int kvm_heki_init_vm(struct kvm *const kvm)
+{
+	return 0;
+}
+
+#endif /* CONFIG_HEKI */
+
 static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 {
 	u64 ret = vcpu->run->hypercall.ret;
@@ -9694,6 +9850,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
 		return 0;
 	}
+#ifdef CONFIG_HEKI
+	case KVM_HC_LOCK_MEM_PAGE_RANGES:
+		/* No flags for now. */
+		if (a2)
+			ret = -KVM_EINVAL;
+		else
+			ret = heki_lock_mem_page_ranges(vcpu->kvm, a0, a1);
+		break;
+#endif /* CONFIG_HEKI */
 	default:
 		ret = -KVM_ENOSYS;
 		break;
@@ -12126,6 +12291,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_page_track;
 
+	ret = kvm_heki_init_vm(kvm);
+	if (ret)
+		goto out_page_track;
+
 	ret = static_call(kvm_x86_vm_init)(kvm);
 	if (ret)
 		goto out_uninit_mmu;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4f26b244f6d0..39a1bdc2ba42 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -699,6 +699,13 @@ struct kvm_memslots {
 	int node_idx;
 };
 
+#ifdef CONFIG_HEKI
+struct heki_gfn_range {
+	gfn_t start;
+	gfn_t end;
+};
+#endif /* CONFIG_HEKI */
+
 struct kvm {
 #ifdef KVM_HAVE_MMU_RWLOCK
 	rwlock_t mmu_lock;
@@ -801,6 +808,12 @@ struct kvm {
 	bool vm_bugged;
 	bool vm_dead;
 
+#ifdef CONFIG_HEKI
+#define HEKI_GFN_MAX 16
+	atomic_t heki_gfn_no_write_num;
+	struct heki_gfn_range heki_gfn_no_write[HEKI_GFN_MAX];
+#endif /* CONFIG_HEKI */
+
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
 #endif
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 960c7e93d1a9..d7512a10880e 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -30,6 +30,7 @@
 #define KVM_HC_SEND_IPI		10
 #define KVM_HC_SCHED_YIELD		11
 #define KVM_HC_MAP_GPA_RANGE		12
+#define KVM_HC_LOCK_MEM_PAGE_RANGES	13
 
 /*
  * hypercalls use architecture specific
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9c60384b5ae0..4aea936dfe73 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1230,6 +1230,10 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	list_add(&kvm->vm_list, &vm_list);
 	mutex_unlock(&kvm_lock);
 
+#ifdef CONFIG_HEKI
+	atomic_set(&kvm->heki_gfn_no_write_num, HEKI_GFN_MAX + 1);
+#endif /* CONFIG_HEKI */
+
 	preempt_notifier_inc();
 	kvm_init_pm_notifier(kvm);
 
-- 
2.40.1


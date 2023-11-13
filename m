Return-Path: <kvm+bounces-1558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40B157E9509
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:34:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 92AA6B212B1
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C91881DA5B;
	Mon, 13 Nov 2023 02:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="X7pEw2w5"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC3D1BDE3
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:32:36 +0000 (UTC)
Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [IPv6:2001:1600:4:17::8faa])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D03010C6
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:32:29 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCst2fcPzMpvWb;
	Mon, 13 Nov 2023 02:24:02 +0000 (UTC)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCss1MkLz3X;
	Mon, 13 Nov 2023 03:24:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842242;
	bh=vhzaT58poP5okVAXmEebxmQ9WRq+VZ+aXO32eUAzlaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7pEw2w51SkJJzAlrXjs8JOCbu2+ngtUoK310kXjccKuEe8o7gDyzceYr3iwHfDCI
	 6YZB4h6J3uY7B1p5cJbUODXmpzLQyLmqczUCEmD5HyT3UGnHxGOqFyygyEea1ipbc6
	 rprruE1hn5ZjbMnPK33x06IEzkmtAjdE/mMhNDU4=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alexander Graf <graf@amazon.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Forrest Yuan Yu <yuanyu@google.com>,
	James Gowans <jgowans@amazon.com>,
	James Morris <jamorris@linux.microsoft.com>,
	John Andersen <john.s.andersen@intel.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marian Rotariu <marian.c.rotariu@gmail.com>,
	=?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
	=?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Wei Liu <wei.liu@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	=?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
	dev@lists.cloudhypervisor.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	qemu-devel@nongnu.org,
	virtualization@lists.linux-foundation.org,
	x86@kernel.org,
	xen-devel@lists.xenproject.org
Subject: [RFC PATCH v2 02/19] KVM: x86: Add new hypercall to lock control registers
Date: Sun, 12 Nov 2023 21:23:09 -0500
Message-ID: <20231113022326.24388-3-mic@digikod.net>
In-Reply-To: <20231113022326.24388-1-mic@digikod.net>
References: <20231113022326.24388-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

This enables guests to lock their CR0 and CR4 registers with a subset of
X86_CR0_WP, X86_CR4_SMEP, X86_CR4_SMAP, X86_CR4_UMIP, X86_CR4_FSGSBASE
and X86_CR4_CET flags.

The new KVM_HC_LOCK_CR_UPDATE hypercall takes three arguments.  The
first is to identify the control register, the second is a bit mask to
pin (i.e. mark as read-only), and the third is for optional flags.

These register flags should already be pinned by Linux guests, but once
compromised, this self-protection mechanism could be disabled, which is
not the case with this dedicated hypercall.

Once the CRs are pinned by the guest, if it attempts to change them,
then a general protection fault is sent to the guest.

This hypercall may evolve and support new kind of registers or pinning.
The optional KVM_LOCK_CR_UPDATE_VERSION flag enables guests to know the
supported abilities by mapping the returned version with the related
features.

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
---

Changes since v1:
* Guard KVM_HC_LOCK_CR_UPDATE hypercall with CONFIG_HEKI.
* Move extern cr4_pinned_mask to x86.h (suggested by Kees Cook).
* Move VMX CR checks from vmx_set_cr*() to handle_cr() to make it
  possible to return to user space (see next commit).
* Change the heki_check_cr()'s first argument to vcpu.
* Don't use -KVM_EPERM in heki_check_cr().
* Generate a fault when the guest requests a denied CR update.
* Add a flags argument to get the version of this hypercall. Being able
  to do a preper version check was suggested by Wei Liu.
---
 Documentation/virt/kvm/x86/hypercalls.rst | 17 +++++
 arch/x86/include/uapi/asm/kvm_para.h      |  2 +
 arch/x86/kernel/cpu/common.c              |  4 +-
 arch/x86/kvm/vmx/vmx.c                    |  5 ++
 arch/x86/kvm/x86.c                        | 84 +++++++++++++++++++++++
 arch/x86/kvm/x86.h                        | 22 ++++++
 include/linux/kvm_host.h                  |  5 ++
 include/uapi/linux/kvm_para.h             |  1 +
 8 files changed, 139 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/hypercalls.rst b/Documentation/virt/kvm/x86/hypercalls.rst
index 10db7924720f..3178576f4c47 100644
--- a/Documentation/virt/kvm/x86/hypercalls.rst
+++ b/Documentation/virt/kvm/x86/hypercalls.rst
@@ -190,3 +190,20 @@ the KVM_CAP_EXIT_HYPERCALL capability. Userspace must enable that capability
 before advertising KVM_FEATURE_HC_MAP_GPA_RANGE in the guest CPUID.  In
 addition, if the guest supports KVM_FEATURE_MIGRATION_CONTROL, userspace
 must also set up an MSR filter to process writes to MSR_KVM_MIGRATION_CONTROL.
+
+9. KVM_HC_LOCK_CR_UPDATE
+------------------------
+
+:Architecture: x86
+:Status: active
+:Purpose: Request some control registers to be restricted.
+
+- a0: identify a control register
+- a1: bit mask to make some flags read-only
+- a2: optional KVM_LOCK_CR_UPDATE_VERSION flag that will return the version of
+      this hypercall. Version 1 supports CR0 and CR4 pinning.
+
+The hypercall lets a guest request control register flags to be pinned for
+itself.
+
+Returns 0 on success or a KVM error code otherwise.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 6e64b27b2c1e..efc5ccc0060f 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -150,4 +150,6 @@ struct kvm_vcpu_pv_apf_data {
 #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
 #define KVM_PV_EOI_DISABLED 0x0
 
+#define KVM_LOCK_CR_UPDATE_VERSION (1 << 0)
+
 #endif /* _UAPI_ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4e5ffc8b0e46..f18ee7ce0496 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -400,9 +400,11 @@ static __always_inline void setup_umip(struct cpuinfo_x86 *c)
 }
 
 /* These bits should not change their value after CPU init is finished. */
-static const unsigned long cr4_pinned_mask =
+const unsigned long cr4_pinned_mask =
 	X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP |
 	X86_CR4_FSGSBASE | X86_CR4_CET;
+EXPORT_SYMBOL_GPL(cr4_pinned_mask);
+
 static DEFINE_STATIC_KEY_FALSE_RO(cr_pinning);
 static unsigned long cr4_pinned_bits __ro_after_init;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6e502ba93141..f487bf16dd96 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5452,6 +5452,11 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 	case 0: /* mov to cr */
 		val = kvm_register_read(vcpu, reg);
 		trace_kvm_cr_write(cr, val);
+
+		ret = heki_check_cr(vcpu, cr, val);
+		if (ret)
+			return ret;
+
 		switch (cr) {
 		case 0:
 			err = handle_set_cr0(vcpu, val);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e3eb608b6692..4e6c4c21f12c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8054,11 +8054,86 @@ static unsigned long emulator_get_cr(struct x86_emulate_ctxt *ctxt, int cr)
 	return value;
 }
 
+#ifdef CONFIG_HEKI
+
+#define HEKI_ABI_VERSION 1
+
+static int heki_lock_cr(struct kvm_vcpu *const vcpu, const unsigned long cr,
+			unsigned long pin, unsigned long flags)
+{
+	if (flags) {
+		if ((flags == KVM_LOCK_CR_UPDATE_VERSION) && !cr && !pin)
+			return HEKI_ABI_VERSION;
+		return -KVM_EINVAL;
+	}
+
+	if (!pin)
+		return -KVM_EINVAL;
+
+	switch (cr) {
+	case 0:
+		/* Cf. arch/x86/kernel/cpu/common.c */
+		if (!(pin & X86_CR0_WP))
+			return -KVM_EINVAL;
+
+		if ((pin & read_cr0()) != pin)
+			return -KVM_EINVAL;
+
+		atomic_long_or(pin, &vcpu->kvm->heki_pinned_cr0);
+		return 0;
+	case 4:
+		/* Checks for irrelevant bits. */
+		if ((pin & cr4_pinned_mask) != pin)
+			return -KVM_EINVAL;
+
+		/* Ignores bits not present in host. */
+		pin &= __read_cr4();
+		atomic_long_or(pin, &vcpu->kvm->heki_pinned_cr4);
+		return 0;
+	}
+	return -KVM_EINVAL;
+}
+
+int heki_check_cr(struct kvm_vcpu *const vcpu, const unsigned long cr,
+		  const unsigned long val)
+{
+	unsigned long pinned;
+
+	switch (cr) {
+	case 0:
+		pinned = atomic_long_read(&vcpu->kvm->heki_pinned_cr0);
+		if ((val & pinned) != pinned) {
+			pr_warn_ratelimited(
+				"heki: Blocked CR0 update: 0x%lx\n", val);
+			kvm_inject_gp(vcpu, 0);
+			return 1;
+		}
+		return 0;
+	case 4:
+		pinned = atomic_long_read(&vcpu->kvm->heki_pinned_cr4);
+		if ((val & pinned) != pinned) {
+			pr_warn_ratelimited(
+				"heki: Blocked CR4 update: 0x%lx\n", val);
+			kvm_inject_gp(vcpu, 0);
+			return 1;
+		}
+		return 0;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(heki_check_cr);
+
+#endif /* CONFIG_HEKI */
+
 static int emulator_set_cr(struct x86_emulate_ctxt *ctxt, int cr, ulong val)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	int res = 0;
 
+	res = heki_check_cr(vcpu, cr, val);
+	if (res)
+		return res;
+
 	switch (cr) {
 	case 0:
 		res = kvm_set_cr0(vcpu, mk_cr_64(kvm_read_cr0(vcpu), val));
@@ -9918,6 +9993,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
 		return 0;
 	}
+#ifdef CONFIG_HEKI
+	case KVM_HC_LOCK_CR_UPDATE:
+		if (a0 > U32_MAX) {
+			ret = -KVM_EINVAL;
+		} else {
+			ret = heki_lock_cr(vcpu, a0, a1, a2);
+		}
+		break;
+#endif /* CONFIG_HEKI */
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1e7be1f6ab29..193093112b55 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -290,6 +290,26 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
 	return !(kvm->arch.disabled_quirks & quirk);
 }
 
+#ifdef CONFIG_HEKI
+
+int heki_check_cr(struct kvm_vcpu *vcpu, unsigned long cr, unsigned long val);
+
+#else /* CONFIG_HEKI */
+
+static inline int heki_check_cr(struct kvm_vcpu *vcpu, unsigned long cr,
+				unsigned long val)
+{
+	return 0;
+}
+
+static inline int heki_lock_cr(struct kvm_vcpu *const vcpu, unsigned long cr,
+			       unsigned long pin)
+{
+	return 0;
+}
+
+#endif /* CONFIG_HEKI */
+
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
 u64 get_kvmclock_ns(struct kvm *kvm);
@@ -325,6 +345,8 @@ extern u64 host_xcr0;
 extern u64 host_xss;
 extern u64 host_arch_capabilities;
 
+extern const unsigned long cr4_pinned_mask;
+
 extern struct kvm_caps kvm_caps;
 
 extern bool enable_pmu;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 687589ce9f63..6864c80ff936 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -835,6 +835,11 @@ struct kvm {
 	bool vm_bugged;
 	bool vm_dead;
 
+#ifdef CONFIG_HEKI
+	atomic_long_t heki_pinned_cr0;
+	atomic_long_t heki_pinned_cr4;
+#endif /* CONFIG_HEKI */
+
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
 #endif
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 960c7e93d1a9..2ed418704603 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -30,6 +30,7 @@
 #define KVM_HC_SEND_IPI		10
 #define KVM_HC_SCHED_YIELD		11
 #define KVM_HC_MAP_GPA_RANGE		12
+#define KVM_HC_LOCK_CR_UPDATE		13
 
 /*
  * hypercalls use architecture specific
-- 
2.42.1



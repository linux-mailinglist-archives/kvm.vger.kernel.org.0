Return-Path: <kvm+bounces-1556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D7917E9505
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:34:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AB661F2118C
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80A241D6B0;
	Mon, 13 Nov 2023 02:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="lCCpGzLo"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088F71B278
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:32:36 +0000 (UTC)
Received: from smtp-8fac.mail.infomaniak.ch (smtp-8fac.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fac])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E27B18C
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:32:29 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCsy1PsbzMpvSP;
	Mon, 13 Nov 2023 02:24:06 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCsw4qBmzMpnPj;
	Mon, 13 Nov 2023 03:24:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842246;
	bh=14gESsZbdf4eGyL7ckyTON/9RCrFW/bTzWgKvh9Y1QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCCpGzLomRxznCOR/eHwVydQZR5isgftfHk7I92gfDtAO6CX5RswyL7i2tobhTzAE
	 apr2Ceo33clgylfofcyYQRC+1ikfzHy4nOQYn3bmJlbss06S6fk2V+z1J7nyoxgujZ
	 p/uhukd50aRDJnnIXpcjdg1Yj4GNzxC2Wp5ETI6s=
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
Subject: [RFC PATCH v2 03/19] KVM: x86: Add notifications for Heki policy configuration and violation
Date: Sun, 12 Nov 2023 21:23:10 -0500
Message-ID: <20231113022326.24388-4-mic@digikod.net>
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

Add an interface for user space to be notified about guests' Heki policy
and related violations.

Extend the KVM_ENABLE_CAP IOCTL with KVM_CAP_HEKI_CONFIGURE and
KVM_CAP_HEKI_DENIAL. Each one takes a bitmask as first argument that can
contains KVM_HEKI_EXIT_REASON_CR0 and KVM_HEKI_EXIT_REASON_CR4. The
returned value is the bitmask of known Heki exit reasons, for now:
KVM_HEKI_EXIT_REASON_CR0 and KVM_HEKI_EXIT_REASON_CR4.

If KVM_CAP_HEKI_CONFIGURE is set, a VM exit will be triggered for each
KVM_HC_LOCK_CR_UPDATE hypercalls according to the requested control
register. This enables to enlighten the VMM with the guest
auto-restrictions.

If KVM_CAP_HEKI_DENIAL is set, a VM exit will be triggered for each
pinned CR violation. This enables the VMM to react to a policy
violation.

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
* New patch. Making user space aware of Heki properties was requested by
  Sean Christopherson.
---
 arch/x86/kvm/vmx/vmx.c   |   5 +-
 arch/x86/kvm/x86.c       | 114 +++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.h       |   7 +--
 include/linux/kvm_host.h |   2 +
 include/uapi/linux/kvm.h |  22 ++++++++
 5 files changed, 136 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f487bf16dd96..b631b1d7ba30 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5444,6 +5444,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 	int reg;
 	int err;
 	int ret;
+	bool exit = false;
 
 	exit_qualification = vmx_get_exit_qual(vcpu);
 	cr = exit_qualification & 15;
@@ -5453,8 +5454,8 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		val = kvm_register_read(vcpu, reg);
 		trace_kvm_cr_write(cr, val);
 
-		ret = heki_check_cr(vcpu, cr, val);
-		if (ret)
+		ret = heki_check_cr(vcpu, cr, val, &exit);
+		if (exit)
 			return ret;
 
 		switch (cr) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4e6c4c21f12c..43c28a6953bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -119,6 +119,10 @@ static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
 
 #define KVM_CAP_PMU_VALID_MASK KVM_PMU_CAP_DISABLE
 
+#define KVM_HEKI_EXIT_REASON_VALID_MASK ( \
+	KVM_HEKI_EXIT_REASON_CR0 | \
+	KVM_HEKI_EXIT_REASON_CR4)
+
 #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 
@@ -4644,6 +4648,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (kvm_is_vm_type_supported(KVM_X86_SW_PROTECTED_VM))
 			r |= BIT(KVM_X86_SW_PROTECTED_VM);
 		break;
+	case KVM_CAP_HEKI_CONFIGURE:
+	case KVM_CAP_HEKI_DENIAL:
+		r = KVM_HEKI_EXIT_REASON_VALID_MASK;
+		break;
 	default:
 		break;
 	}
@@ -6518,6 +6526,22 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+#ifdef CONFIG_HEKI
+	case KVM_CAP_HEKI_CONFIGURE:
+		r = -EINVAL;
+		if (cap->args[0] & ~KVM_HEKI_EXIT_REASON_VALID_MASK)
+			break;
+		kvm->heki_configure_exit_reason = cap->args[0];
+		r = 0;
+		break;
+	case KVM_CAP_HEKI_DENIAL:
+		r = -EINVAL;
+		if (cap->args[0] & ~KVM_HEKI_EXIT_REASON_VALID_MASK)
+			break;
+		kvm->heki_denial_exit_reason = cap->args[0];
+		r = 0;
+		break;
+#endif
 	default:
 		r = -EINVAL;
 		break;
@@ -8056,11 +8080,60 @@ static unsigned long emulator_get_cr(struct x86_emulate_ctxt *ctxt, int cr)
 
 #ifdef CONFIG_HEKI
 
+static int complete_heki_configure_exit(struct kvm_vcpu *const vcpu)
+{
+	kvm_rax_write(vcpu, 0);
+	++vcpu->stat.hypercalls;
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
+static int complete_heki_denial_exit(struct kvm_vcpu *const vcpu)
+{
+	kvm_inject_gp(vcpu, 0);
+	return 1;
+}
+
+/* Returns true if the @exit_reason is handled by @vcpu->kvm. */
+static bool heki_exit_cr(struct kvm_vcpu *const vcpu, const __u32 exit_reason,
+			 const u64 heki_reason, unsigned long value)
+{
+	switch (exit_reason) {
+	case KVM_EXIT_HEKI_CONFIGURE:
+		if (!(vcpu->kvm->heki_configure_exit_reason & heki_reason))
+			return false;
+
+		vcpu->run->heki_configure.reason = heki_reason;
+		memset(vcpu->run->heki_configure.reserved, 0,
+		       sizeof(vcpu->run->heki_configure.reserved));
+		vcpu->run->heki_configure.cr_pinned = value;
+		vcpu->arch.complete_userspace_io = complete_heki_configure_exit;
+		break;
+	case KVM_EXIT_HEKI_DENIAL:
+		if (!(vcpu->kvm->heki_denial_exit_reason & heki_reason))
+			return false;
+
+		vcpu->run->heki_denial.reason = heki_reason;
+		memset(vcpu->run->heki_denial.reserved, 0,
+		       sizeof(vcpu->run->heki_denial.reserved));
+		vcpu->run->heki_denial.cr_value = value;
+		vcpu->arch.complete_userspace_io = complete_heki_denial_exit;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return false;
+	}
+
+	vcpu->run->exit_reason = exit_reason;
+	return true;
+}
+
 #define HEKI_ABI_VERSION 1
 
 static int heki_lock_cr(struct kvm_vcpu *const vcpu, const unsigned long cr,
-			unsigned long pin, unsigned long flags)
+			unsigned long pin, unsigned long flags, bool *exit)
 {
+	*exit = false;
+
 	if (flags) {
 		if ((flags == KVM_LOCK_CR_UPDATE_VERSION) && !cr && !pin)
 			return HEKI_ABI_VERSION;
@@ -8080,6 +8153,8 @@ static int heki_lock_cr(struct kvm_vcpu *const vcpu, const unsigned long cr,
 			return -KVM_EINVAL;
 
 		atomic_long_or(pin, &vcpu->kvm->heki_pinned_cr0);
+		*exit = heki_exit_cr(vcpu, KVM_EXIT_HEKI_CONFIGURE,
+				     KVM_HEKI_EXIT_REASON_CR0, pin);
 		return 0;
 	case 4:
 		/* Checks for irrelevant bits. */
@@ -8089,24 +8164,37 @@ static int heki_lock_cr(struct kvm_vcpu *const vcpu, const unsigned long cr,
 		/* Ignores bits not present in host. */
 		pin &= __read_cr4();
 		atomic_long_or(pin, &vcpu->kvm->heki_pinned_cr4);
+		*exit = heki_exit_cr(vcpu, KVM_EXIT_HEKI_CONFIGURE,
+				     KVM_HEKI_EXIT_REASON_CR4, pin);
 		return 0;
 	}
 	return -KVM_EINVAL;
 }
 
+/*
+ * Sets @exit to true if the caller must exit (i.e. denied access) with the
+ * returned value:
+ * - 0 when kvm_run is configured;
+ * - 1 when there is no user space handler.
+ */
 int heki_check_cr(struct kvm_vcpu *const vcpu, const unsigned long cr,
-		  const unsigned long val)
+		  const unsigned long val, bool *exit)
 {
 	unsigned long pinned;
 
+	*exit = false;
+
 	switch (cr) {
 	case 0:
 		pinned = atomic_long_read(&vcpu->kvm->heki_pinned_cr0);
 		if ((val & pinned) != pinned) {
 			pr_warn_ratelimited(
 				"heki: Blocked CR0 update: 0x%lx\n", val);
-			kvm_inject_gp(vcpu, 0);
-			return 1;
+			*exit = true;
+			if (heki_exit_cr(vcpu, KVM_EXIT_HEKI_DENIAL,
+					 KVM_HEKI_EXIT_REASON_CR0, val))
+				return 0;
+			return complete_heki_denial_exit(vcpu);
 		}
 		return 0;
 	case 4:
@@ -8114,8 +8202,11 @@ int heki_check_cr(struct kvm_vcpu *const vcpu, const unsigned long cr,
 		if ((val & pinned) != pinned) {
 			pr_warn_ratelimited(
 				"heki: Blocked CR4 update: 0x%lx\n", val);
-			kvm_inject_gp(vcpu, 0);
-			return 1;
+			*exit = true;
+			if (heki_exit_cr(vcpu, KVM_EXIT_HEKI_DENIAL,
+					 KVM_HEKI_EXIT_REASON_CR4, val))
+				return 0;
+			return complete_heki_denial_exit(vcpu);
 		}
 		return 0;
 	}
@@ -8129,9 +8220,10 @@ static int emulator_set_cr(struct x86_emulate_ctxt *ctxt, int cr, ulong val)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	int res = 0;
+	bool exit = false;
 
-	res = heki_check_cr(vcpu, cr, val);
-	if (res)
+	res = heki_check_cr(vcpu, cr, val, &exit);
+	if (exit)
 		return res;
 
 	switch (cr) {
@@ -9998,7 +10090,11 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		if (a0 > U32_MAX) {
 			ret = -KVM_EINVAL;
 		} else {
-			ret = heki_lock_cr(vcpu, a0, a1, a2);
+			bool exit = false;
+
+			ret = heki_lock_cr(vcpu, a0, a1, a2, &exit);
+			if (exit)
+				return ret;
 		}
 		break;
 #endif /* CONFIG_HEKI */
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 193093112b55..f8f5c32bedd9 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -292,18 +292,19 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
 
 #ifdef CONFIG_HEKI
 
-int heki_check_cr(struct kvm_vcpu *vcpu, unsigned long cr, unsigned long val);
+int heki_check_cr(struct kvm_vcpu *vcpu, unsigned long cr, unsigned long val,
+		  bool *exit);
 
 #else /* CONFIG_HEKI */
 
 static inline int heki_check_cr(struct kvm_vcpu *vcpu, unsigned long cr,
-				unsigned long val)
+				unsigned long val, bool *exit)
 {
 	return 0;
 }
 
 static inline int heki_lock_cr(struct kvm_vcpu *const vcpu, unsigned long cr,
-			       unsigned long pin)
+			       unsigned long pin, bool *exit)
 {
 	return 0;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6864c80ff936..ec32af17add8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -838,6 +838,8 @@ struct kvm {
 #ifdef CONFIG_HEKI
 	atomic_long_t heki_pinned_cr0;
 	atomic_long_t heki_pinned_cr4;
+	u64 heki_configure_exit_reason;
+	u64 heki_denial_exit_reason;
 #endif /* CONFIG_HEKI */
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5b5820d19e71..2477b4a16126 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -279,6 +279,8 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_MEMORY_FAULT     38
+#define KVM_EXIT_HEKI_CONFIGURE   39
+#define KVM_EXIT_HEKI_DENIAL      40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -532,6 +534,24 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_HEKI_CONFIGURE */
+		struct {
+#define KVM_HEKI_EXIT_REASON_CR0	(1ULL << 0)
+#define KVM_HEKI_EXIT_REASON_CR4	(1ULL << 1)
+			__u64 reason;
+			union {
+				__u64 cr_pinned;
+				__u64 reserved[7]; /* ignored */
+			};
+		} heki_configure;
+		/* KVM_EXIT_HEKI_DENIAL */
+		struct {
+			__u64 reason;
+			union {
+				__u64 cr_value;
+				__u64 reserved[7]; /* ignored */
+			};
+		} heki_denial;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1219,6 +1239,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_MEMORY_ATTRIBUTES 232
 #define KVM_CAP_GUEST_MEMFD 233
 #define KVM_CAP_VM_TYPES 234
+#define KVM_CAP_HEKI_CONFIGURE 235
+#define KVM_CAP_HEKI_DENIAL 236
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.42.1



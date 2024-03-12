Return-Path: <kvm+bounces-11665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C0C879580
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 15:00:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D94B1F2185C
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 14:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 723877AE54;
	Tue, 12 Mar 2024 14:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IZdFpZcg"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A43757307;
	Tue, 12 Mar 2024 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710252011; cv=none; b=FlU03gRVGMhhvs+v7FGn2Pm5B1DGx61mlYqBBoK3ObI4nIPCz26mBzPBvV9kgBXKv05HDjeDm0FsaTTxKIMGoHK1n1zq++v+jE5KbHijpvZnjYHQg/YA3cMFIKo/j+DjQDoqhnxR9Y3AO+vsQwUeNFI9sGvAR68RWxCtpbT5IFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710252011; c=relaxed/simple;
	bh=ipiEa/4hYs81YL1NCON8A27cXU/Gl4GG4P1F97KPzxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZ0kicoGyEPC5LzMroN6HjTHXdW4MpuE0DF8YuM2j1TUgcTtcpSXeC9noCGe/uIaKJiofkCEAh+/mf63IjxdLBbz7DRjY0ZOP0he59oC9T3CjF8ZYGADPUKadgAGdtnYkS7edtt4UUuBUiL32/cqGhpvTuVx/rvJwrSUrXd2rIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IZdFpZcg; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=J8D2/RR5NDsKyR9vPX1dyPBbhkzHwPA16hqD1lGKcas=; b=IZdFpZcgdL976bGkCAqTQtEsZw
	2GlI7sGEbb2FlQqS2QGQFdqrNZbPc1kaMVficZRolMJQWOT1ONhRd5uhLjgFSKeEOMxiB60v3sJb7
	S3Sz+yiJbMLi3Yb6JCRE7TAO5f768NJtXXn6HcDNXw1qcLJeQ1ZRDVcmub6IC3qrok5xdEK/YyNNz
	FybEog/xU3jbJ1RFC8GozTBK8jbI/3jbkQyUI9BNfeZDowX33MXOnO40V3kbkFq7sXm5Xfp6HkiK+
	pyk9y5a9AJ0PlYf3Yy1WPWPb77/vp+/+3wIH8hgvTfawnk7xCPoC0U/YT7/68BpkhC4IkQxHjG6N7
	9F+myMdA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk2fh-000000039pS-126X;
	Tue, 12 Mar 2024 14:00:01 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk2fg-000000033N5-33PU;
	Tue, 12 Mar 2024 14:00:00 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <len.brown@intel.com>,
	Pavel Machek <pavel@ucw.cz>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Mostafa Saleh <smostafa@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-pm@vger.kernel.org
Subject: [RFC PATCH 1/2] KVM: arm64: Add PSCI SYSTEM_OFF2 function for hibernation
Date: Tue, 12 Mar 2024 13:51:28 +0000
Message-ID: <20240312135958.727765-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240312135958.727765-1-dwmw2@infradead.org>
References: <20240312135958.727765-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The PSCI v1.3 specification (alpha) adds support for a SYSTEM_OFF2 function
which is analogous to ACPI S4 state. This will allow hosting environments
to determine that a guest is hibernated rather than just powered off, and
ensure that they preserve the virtual environment appropriately to allow
the guest to resume safely (or bump the hardware_signature in the FACS to
trigger a clean reboot instead).

The beta version will be changed to say that PSCI_FEATURES returns a bit
mask of the supported hibernate types, which is implemented here.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst       | 11 +++++++++
 arch/arm64/include/asm/kvm_host.h    |  2 ++
 arch/arm64/include/uapi/asm/kvm.h    |  6 +++++
 arch/arm64/kvm/arm.c                 |  5 ++++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  2 ++
 arch/arm64/kvm/psci.c                | 37 ++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h             |  1 +
 include/uapi/linux/psci.h            |  5 ++++
 8 files changed, 69 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bd93cafd3e4e..f5963c3770a5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6761,6 +6761,10 @@ the first `ndata` items (possibly zero) of the data array are valid.
    the guest issued a SYSTEM_RESET2 call according to v1.1 of the PSCI
    specification.
 
+ - for arm64, data[0] is set to KVM_SYSTEM_EVENT_SHUTDOWN_FLAG_PSCI_OFF2
+   if the guest issued a SYSTEM_OFF2 call according to v1.3 of the PSCI
+   specification.
+
  - for RISC-V, data[0] is set to the value of the second argument of the
    ``sbi_system_reset`` call.
 
@@ -6794,6 +6798,13 @@ either:
  - Deny the guest request to suspend the VM. See ARM DEN0022D.b 5.19.2
    "Caller responsibilities" for possible return values.
 
+Hibernation using the PSCI SYSTEM_OFF2 call is enabled with the
+KVM_CAP_ARM_SYSTEM_OFF2 VM capability. If a guest invokes the PSCI
+SYSTEM_OFF2 function, KVM will exit to userspace with the
+KVM_SYSTEM_EVENT_SHUTDOWN event type and with data[0] set to
+KVM_SYSTEM_EVENT_SHUTDOWN_FLAG_PSCI_OFF2. The only supported hibernate
+type for the SYSTEM_OFF2 function is HIBERNATE_OFF (0x0).
+
 ::
 
 		/* KVM_EXIT_IOAPIC_EOI */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 21c57b812569..d6da0eb1c236 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -274,6 +274,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		6
 	/* Initial ID reg values loaded */
 #define KVM_ARCH_FLAG_ID_REGS_INITIALIZED		7
+	/* PSCI SYSTEM_OFF2 (hibernate) enabled for the guest */
+#define KVM_ARCH_FLAG_SYSTEM_OFF2_ENABLED		8
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 964df31da975..66736ff04011 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -484,6 +484,12 @@ enum {
  */
 #define KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2	(1ULL << 0)
 
+/*
+ * Shutdown caused by a PSCI v1.3 SYSTEM_OFF2 call.
+ * Valid only when the system event has a type of KVM_SYSTEM_EVENT_SHUTDOWN.
+ */
+#define KVM_SYSTEM_EVENT_SHUTDOWN_FLAG_PSCI_OFF2	(1ULL << 0)
+
 /* run->fail_entry.hardware_entry_failure_reason codes. */
 #define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED	(1ULL << 0)
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a25265aca432..1c58762272eb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -98,6 +98,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
 		break;
+	case KVM_CAP_ARM_SYSTEM_OFF2:
+		r = 0;
+		set_bit(KVM_ARCH_FLAG_SYSTEM_OFF2_ENABLED, &kvm->arch.flags);
+		break;
 	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
 		new_cap = cap->args[0];
 
@@ -238,6 +242,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+	case KVM_CAP_ARM_SYSTEM_OFF2:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
 		r = 1;
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index d57bcb6ab94d..0d4bea0b9ca2 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -264,6 +264,8 @@ static unsigned long psci_1_0_handler(u64 func_id, struct kvm_cpu_context *host_
 	switch (func_id) {
 	case PSCI_1_0_FN_PSCI_FEATURES:
 	case PSCI_1_0_FN_SET_SUSPEND_MODE:
+	case PSCI_1_3_FN_SYSTEM_OFF2:
+	case PSCI_1_3_FN64_SYSTEM_OFF2:
 	case PSCI_1_1_FN64_SYSTEM_RESET2:
 		return psci_forward(host_ctxt);
 	case PSCI_1_0_FN64_SYSTEM_SUSPEND:
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 1f69b667332b..59570eea8aa7 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -194,6 +194,12 @@ static void kvm_psci_system_off(struct kvm_vcpu *vcpu)
 	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_SHUTDOWN, 0);
 }
 
+static void kvm_psci_system_off2(struct kvm_vcpu *vcpu)
+{
+	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_SHUTDOWN,
+				 KVM_SYSTEM_EVENT_SHUTDOWN_FLAG_PSCI_OFF2);
+}
+
 static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
 {
 	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET, 0);
@@ -353,6 +359,11 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			if (test_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags))
 				val = 0;
 			break;
+		case PSCI_1_3_FN_SYSTEM_OFF2:
+		case PSCI_1_3_FN64_SYSTEM_OFF2:
+			if (test_bit(KVM_ARCH_FLAG_SYSTEM_OFF2_ENABLED, &kvm->arch.flags))
+				val = 1UL << PSCI_1_3_HIBERNATE_TYPE_OFF;
+			break;
 		case PSCI_1_1_FN_SYSTEM_RESET2:
 		case PSCI_1_1_FN64_SYSTEM_RESET2:
 			if (minor >= 1)
@@ -374,6 +385,32 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			return 0;
 		}
 		break;
+	case PSCI_1_3_FN_SYSTEM_OFF2:
+		kvm_psci_narrow_to_32bit(vcpu);
+		fallthrough;
+	case PSCI_1_3_FN64_SYSTEM_OFF2:
+		if (!test_bit(KVM_ARCH_FLAG_SYSTEM_OFF2_ENABLED, &kvm->arch.flags))
+			break;
+
+		arg = smccc_get_arg1(vcpu);
+		if (arg != PSCI_1_3_HIBERNATE_TYPE_OFF) {
+			val = PSCI_RET_INVALID_PARAMS;
+			break;
+		}
+		kvm_psci_system_off2(vcpu);
+		/*
+		 * We shouldn't be going back to guest VCPU after
+		 * receiving SYSTEM_OFF2 request.
+		 *
+		 * If user space accidentally/deliberately resumes
+		 * guest VCPU after SYSTEM_OFF request then guest
+		 * VCPU should see internal failure from PSCI return
+		 * value. To achieve this, we preload r0 (or x0) with
+		 * PSCI return value INTERNAL_FAILURE.
+		 */
+		val = PSCI_RET_INTERNAL_FAILURE;
+		ret = 0;
+		break;
 	case PSCI_1_1_FN_SYSTEM_RESET2:
 		kvm_psci_narrow_to_32bit(vcpu);
 		fallthrough;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..caa3845b80d6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -917,6 +917,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_ARM_SYSTEM_OFF2 236
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/include/uapi/linux/psci.h b/include/uapi/linux/psci.h
index 42a40ad3fb62..f9a015ebe221 100644
--- a/include/uapi/linux/psci.h
+++ b/include/uapi/linux/psci.h
@@ -59,6 +59,7 @@
 #define PSCI_1_1_FN_SYSTEM_RESET2		PSCI_0_2_FN(18)
 #define PSCI_1_1_FN_MEM_PROTECT			PSCI_0_2_FN(19)
 #define PSCI_1_1_FN_MEM_PROTECT_CHECK_RANGE	PSCI_0_2_FN(20)
+#define PSCI_1_3_FN_SYSTEM_OFF2			PSCI_0_2_FN(21)
 
 #define PSCI_1_0_FN64_CPU_DEFAULT_SUSPEND	PSCI_0_2_FN64(12)
 #define PSCI_1_0_FN64_NODE_HW_STATE		PSCI_0_2_FN64(13)
@@ -68,6 +69,7 @@
 
 #define PSCI_1_1_FN64_SYSTEM_RESET2		PSCI_0_2_FN64(18)
 #define PSCI_1_1_FN64_MEM_PROTECT_CHECK_RANGE	PSCI_0_2_FN64(20)
+#define PSCI_1_3_FN64_SYSTEM_OFF2		PSCI_0_2_FN64(21)
 
 /* PSCI v0.2 power state encoding for CPU_SUSPEND function */
 #define PSCI_0_2_POWER_STATE_ID_MASK		0xffff
@@ -100,6 +102,9 @@
 #define PSCI_1_1_RESET_TYPE_SYSTEM_WARM_RESET	0
 #define PSCI_1_1_RESET_TYPE_VENDOR_START	0x80000000U
 
+/* PSCI v1.3 hibernate type for SYSTEM_OFF2 */
+#define PSCI_1_3_HIBERNATE_TYPE_OFF		0
+
 /* PSCI version decoding (independent of PSCI version) */
 #define PSCI_VERSION_MAJOR_SHIFT		16
 #define PSCI_VERSION_MINOR_MASK			\
-- 
2.44.0



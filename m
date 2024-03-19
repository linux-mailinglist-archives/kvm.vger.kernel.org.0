Return-Path: <kvm+bounces-12136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7747A87FE65
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1C01B22F41
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54112839FB;
	Tue, 19 Mar 2024 13:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eeXJ04Y4"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE8358230;
	Tue, 19 Mar 2024 13:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710853816; cv=none; b=khlPt2BJ9li+S5hAxHrKIOsCZraLLqEk62cureIPXpx4dq/Ifvp8bYt+LDe9Lriw4zbfwxe0yZeez0NeeJzbph2fAykZBqHsjW/A8MW+y6Hc3uIfvL2JSemWdKe8T+Dj0i2ZIIJsi2NWXldcej+ZHRSB0+qpEn5w/Vho0bcbz0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710853816; c=relaxed/simple;
	bh=hJhgWkLohJdvACTnHkCzjlvaAU9vl52G+i074OtHDzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/3VYGxj44wXDaWDxeJwPpstliYd8qzOzrAyWfPadkQk6H9FDx3Fv+1Wgunb7az7ISFdHJf3AWjxZ51Ycx2YsM2DxtgQuKv1V6UagoNUTyiMYZinKWenof2tisDqjdSpE/LMmcb39PLWYlifgEoc9kLhEQYSRHDvUlONwWtONac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eeXJ04Y4; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YTLpMmpkNGuhvFQgvKQCItGbMWw/zhTL9LcZsBFvYlg=; b=eeXJ04Y4UGErDaAsaqfUJbLl4K
	DUih3BS9hCsOyVYqkk7c9t9dIklm52DZm5P6xD57GpMiGVUoRi4pBTSH4jOi8aUa3viuJ9niE9Ej2
	JC2LUuE2qmK6PqqUJo03dlv7wxIao/pLl02KvjoqhoPjrgemoR3FYESgeea3EgBBqMzVb0EtbpVJ5
	gNwx1/F1bc0apsELDOBSl6CsayQladUWU/fR1h3laY0Tqzw2EwzeCP5iGP3atrColPgnrFeNRO4fx
	dLSpKiTOLiwjBPn7jIJZIhoZv3aQo2y6vv8P571SOUSQ84q7hy1lDRiyhkBhstJfX823Pp9pInVfF
	tTN96Ejw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmZEA-0000000DDlx-1inm;
	Tue, 19 Mar 2024 13:10:03 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmZE9-00000004PMy-0Gs2;
	Tue, 19 Mar 2024 13:10:01 +0000
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
Subject: [RFC PATCH v3 3/5] KVM: arm64: Add PSCI v1.3 SYSTEM_OFF2 function for hibernation
Date: Tue, 19 Mar 2024 12:59:04 +0000
Message-ID: <20240319130957.1050637-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240319130957.1050637-1-dwmw2@infradead.org>
References: <20240319130957.1050637-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The PSCI v1.3 specification (alpha) adds support for a SYSTEM_OFF2 function
which is analogous to ACPI S4 state. This will allow hosting environments
to determine that a guest is hibernated rather than just powered off, and
ensure that they preserve the virtual environment appropriately to allow
the guest to resume safely (or bump the hardware_signature in the FACS to
trigger a clean reboot instead).

The beta version will be changed to say that PSCI_FEATURES returns a bit
mask of the supported hibernate types, which is implemented here.

Although this new feature is inflicted unconditionally on unexpecting
userspace, it ought to be mostly OK because it still results in the same
KVM_SYSTEM_EVENT_SHUTDOWN event, just with a new flag which hopefully
won't cause userspace to get unhappy.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst    | 11 +++++++++
 arch/arm64/include/uapi/asm/kvm.h |  6 +++++
 arch/arm64/kvm/psci.c             | 37 +++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..ba4ddb13e253 100644
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
 
+Hibernation using the PSCI SYSTEM_OFF2 call is enabled when PSCI v1.3
+is enabled. If a guest invokes the PSCI SYSTEM_OFF2 function, KVM will
+exit to userspace with the KVM_SYSTEM_EVENT_SHUTDOWN event type and with
+data[0] set to KVM_SYSTEM_EVENT_SHUTDOWN_FLAG_PSCI_OFF2. The only
+supported hibernate type for the SYSTEM_OFF2 function is HIBERNATE_OFF
+0x0).
+
 ::
 
 		/* KVM_EXIT_IOAPIC_EOI */
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
 
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index f689ef3f2f10..7acf07900c08 100644
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
+			if (minor >= 3)
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
+		if (minor < 3)
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
+		 * guest VCPU after SYSTEM_OFF2 request then guest
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
-- 
2.44.0



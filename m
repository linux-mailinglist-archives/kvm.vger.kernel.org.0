Return-Path: <kvm+bounces-54832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C23B7B28CBA
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 12:14:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D39885E76E0
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 10:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCB3E291C02;
	Sat, 16 Aug 2025 10:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e331t86n"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D51E230270;
	Sat, 16 Aug 2025 10:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755339210; cv=none; b=buGGETtymuaH+nkvTA3CnoTQ2+5OYUkKwP+q41jitouFv5S/VT7wl1fZwkSnm4MF/tqvT8xjIFc3+9uYmgYXAfUr+qy5UG/qZgwxcpmdAOD5eXWFrWT9EdxTgd6w3w0aAjkFGJqbGbIgO4SEEupPdtwzuT735OT2cE2jfrXdhqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755339210; c=relaxed/simple;
	bh=VISw+hcde9qZ1n3g0CEwLcclTN2nmaRHfPekI3FOWQg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTLGHG2tuzHuTjq+YIYRuvhAx/3NdWLJQ/WGQokzNGFKxe4DVcaT3GjhwEy3BGknYXw+yiUbzrAMgHGAsd35VR1OFa3eAEkljsoC26KhOphtOztui1ccgf49b1zJMO8Gq9sB7W45VibaZ62kGu2UenputOj6QIx1fxoJlZSqNjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e331t86n; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:To:From:Reply-To:
	Cc:Content-Type:Content-ID:Content-Description;
	bh=BjEXtZI4JMihCuWWOH01u+3jFj7nMQzbdSm5sr6kODQ=; b=e331t86nkQIGqZjbnjC/FtEuRz
	QpUntS9viav/Qbas202Ugi1IehJxtxvAwY1CU7cZEkFxi194YMPtvVPWEG+drwSPyhWaFzbTgUWH3
	gxw5MGcMghG0/RV37OEk45bjN49UNFpto8UIYENjt6wGi2rMgTk/hwGJt1XKlot/MLajI8J+k7PjZ
	r++ddsdeYOZ0tnoaQZu+eh1zvoZi7jp37Z1asV+f3dnALpBiIyGbSq0972HsPJwtYToP8shXk/qWn
	bJn5tzFvuBF6cAJuASWOoOMQoxir0kreQ5dP/H0Ya+Ponx+WTiao0J1LMIP6G8Y86wT2oIgMiYPDp
	frGd6B5w==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unDuT-0000000GxZs-1ptY;
	Sat, 16 Aug 2025 10:13:13 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1unDuQ-0000000AsuC-1HD3;
	Sat, 16 Aug 2025 11:13:10 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	graf@amazon.de,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Colin Percival <cperciva@tarsnap.com>
Subject: [PATCH v2 2/3] KVM: x86: Provide TSC frequency in "generic" timing infomation CPUID leaf
Date: Sat, 16 Aug 2025 11:10:01 +0100
Message-ID: <20250816101308.2594298-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250816101308.2594298-1-dwmw2@infradead.org>
References: <20250816101308.2594298-1-dwmw2@infradead.org>
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

In https://lkml.org/lkml/2008/10/1/246 a proposal was made for generic
CPUID leaves, of which only 0x40000010 was defined, to contain the TSC
and local APIC frequencies. The proposal from VMware was mostly shot
down in flames, *but* XNU does unconditionally assume that this leaf
contains the frequency information, if it's present on any hypervisor:
https://github.com/apple/darwin-xnu/blob/main/osfmk/i386/cpuid.c

So does FreeBSD: https://github.com/freebsd/freebsd-src/commit/4a432614f68

So at this point it would be daft for a hypervisor to expose 0x40000010
for any *other* content. KVM might as well adopt it, and fill in the
accurate TSC frequency just as it does for the Xen TSC leaf.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/uapi/asm/kvm_para.h | 11 +++++++++++
 arch/x86/kvm/cpuid.c                 |  7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index a1efa7907a0b..1597c4a2a24a 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -44,6 +44,17 @@
  */
 #define KVM_FEATURE_CLOCKSOURCE_STABLE_BIT	24
 
+
+/*
+ * Proposed by VMware in https://lkml.org/lkml/2008/10/1/246 the timing
+ * information leaf provides the TSC and local APIC timer frequencies:
+ *
+ *  # EAX: (Virtual) TSC frequency in kHz.
+ *  # EBX: (Virtual) Bus (local apic timer) frequency in kHz.
+ *  # ECX, EDX: RESERVED (reserved fields are set to zero).
+ */
+#define KVM_CPUID_TIMING_INFO	0x40000010
+
 #define MSR_KVM_WALL_CLOCK  0x11
 #define MSR_KVM_SYSTEM_TIME 0x12
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index bcce3a75c3f2..1bd69d9c86b7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -2029,6 +2029,13 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 			} else if (index == 2) {
 				*eax = vcpu->arch.hw_tsc_khz;
 			}
+		} else if (vcpu->arch.kvm_cpuid.base &&
+			   function <= vcpu->arch.kvm_cpuid.limit &&
+			   function == (vcpu->arch.kvm_cpuid.base | KVM_CPUID_TIMING_INFO)) {
+			if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcpu))
+				kvm_guest_time_update(vcpu);
+
+			*eax = vcpu->arch.hw_tsc_khz;
 		}
 	} else {
 		*eax = *ebx = *ecx = *edx = 0;
-- 
2.49.0



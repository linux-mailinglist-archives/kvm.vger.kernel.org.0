Return-Path: <kvm+bounces-54670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AEFEB264F5
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 14:05:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E7E57B7600
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 12:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A679B2FE06A;
	Thu, 14 Aug 2025 12:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q7DJ5d3l"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BAE2EBBAC;
	Thu, 14 Aug 2025 12:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755172999; cv=none; b=V3lMM2ckHp9NuGXxOo77BRN2wbd9cnNdfdxy9HtVenCrnZOs3QPlaXiv9w7ibRACp+2GCCER7suEMYg0tTzhQVLKPtf7hEkIWbc/gGZAfLPWIFXF/RvdF6kr4HArNUy5T4eytYykudr3o/QRPOPdj0jgBYaM6VIxWOTPyvXfGKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755172999; c=relaxed/simple;
	bh=VISw+hcde9qZ1n3g0CEwLcclTN2nmaRHfPekI3FOWQg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZ/l+BgOHNWzYZvlIG7He+KO7mYl/S/umD0CAOF/BfRYsG+skqOuB9Y3GbPdDsE2fWdrk/ubn2LxU2cecWdHbU9TMm/OqAc/CgY1Cbyqs6CwtPNJ13uzVVT/4la+uxI80D/6Azvk9Q5jdF4L9KijDLn8deDOk9/SEEvjdczpxak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q7DJ5d3l; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:To:From:Reply-To:
	Cc:Content-Type:Content-ID:Content-Description;
	bh=BjEXtZI4JMihCuWWOH01u+3jFj7nMQzbdSm5sr6kODQ=; b=Q7DJ5d3lPW78Q+RjTZY0LfCfNk
	x038+qg8PLaZgBpT47tbxxyXWPXIYg/fnzbqvspRACaaNCzoD+FlkfsWUoM0/NbrlpnP/1qsIQ+rG
	ppQDR0nipYQPzZi37vMPlJV83m7OIn9dSysEYgAVsZFXk2G92MgU8VC5CeEmLylg5A423KLdL5c+P
	enFkBCpv0ThvaXDt7xLfWXy48YgOaySJWVNRsT822Knt9GSLHOPAEHRZu9LC/63HTgbBDAXpz8WPE
	tAiJNlxRPpkR/Gsea1jL8n70fRqD8k4PNW7JkH1sggrfgFvMWwppylj4t8+j8ap2q3O3RKYLVAnyv
	YymTjasQ==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umWfe-0000000GNRJ-3vse;
	Thu, 14 Aug 2025 12:03:03 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1umWfd-0000000AMTn-1aWA;
	Thu, 14 Aug 2025 13:03:01 +0100
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
	Alok N Kataria <akataria@vmware.com>
Subject: [PATCH 2/3] KVM: x86: Provide TSC frequency in "generic" timing infomation CPUID leaf
Date: Thu, 14 Aug 2025 12:56:04 +0100
Message-ID: <20250814120237.2469583-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250814120237.2469583-1-dwmw2@infradead.org>
References: <20250814120237.2469583-1-dwmw2@infradead.org>
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



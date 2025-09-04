Return-Path: <kvm+bounces-56847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4259AB44589
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 20:36:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04E81189B189
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0479430BBBC;
	Thu,  4 Sep 2025 18:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qw3brj2t"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E5E224AE6
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 18:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757010994; cv=none; b=uRmqf+5dkun4/IU8+NZTpnn70Ju2D0sve3j8UwCiHa6snyjWKIsADi49GHSE6msvz3DEZjkOOuJQrYXpQSZ3hRuFMOMT92l/osbKYd0/qGHzGEQTx41lSPX4JH1aUlGDnaWpeZWiVam9uz05NdwV33dm36nVJQE18UxomLhqz84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757010994; c=relaxed/simple;
	bh=AGw2xKpv/tyfwIG/SQpOwIOoH2TKN2ZA8FjMvcb4Ue0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0jPv7XhvibuWU9qsYR+rj6QsiGfnhW9Eh+qu46W6qBppdTxgjh46oO9IyNPtmAxBFgeGww1ox7zjySLjahW77VtRyBmVpagQgIyGXcxFqFyzmi9MfVuylV2wnffT2AJnJ4JLp/O2v18iXi3M4foowvx0eMICOTAJ1QXQ8eQSh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qw3brj2t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73D2C4CEF0;
	Thu,  4 Sep 2025 18:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757010993;
	bh=AGw2xKpv/tyfwIG/SQpOwIOoH2TKN2ZA8FjMvcb4Ue0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qw3brj2t8UbID/+WoDY/uRW1yFhQvX+22HwSEC/wJzRfTqQr1VvvFUhS6EAuq1xYb
	 k5bqmvLHa9pzBWrw5L6Rj4r+ZgiPKL0kowU2jHN0EGXDuT9JuWeXDbKlMtEpC9DbG0
	 1Zr9vgpOgzpmhEizFYXURkmjh+QxLgtMWusWCs1e/6GIz026AAi42/CtW1m2NYymNm
	 pyc4h/5YzhbcTBSm//s29BMszwKwAnWGSfI3Uondydi+c3Mvc0u9yJbrKgHSKVSbXy
	 oRVNlEO+jKXe67cCD3VRTc4HVKbQvpjCetnH6/+XkMFqhJlf5Tza3DWOMIChO7sjZe
	 XW5JwCCTrKA0g==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: <x86@kernel.org>,
	<kvm@vger.kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [RESEND v4 6/7] x86/cpufeatures: Add X86_FEATURE_X2AVIC_EXT
Date: Fri,  5 Sep 2025 00:03:06 +0530
Message-ID: <e5c9c471ab99a130bf9b728b77050ab308cf8624.1757009416.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1757009416.git.naveen@kernel.org>
References: <cover.1757009416.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add CPUID feature bit for x2AVIC extension that enables AMD SVM to
support up to 4096 vCPUs in x2AVIC mode. The primary change is in the
size of the AVIC Physical ID table, which can now go up to 8 contiguous
4k pages. The number of pages allocated is controlled by the maximum
APIC ID for a guest, and that controls the number of pages to allocate
for the AVIC Physical ID table. AVIC hardware is enhanced to look up
Physical ID table entries for vCPUs > 512 for locating the target APIC
backing page and the host APIC ID of the physical core on which the
guest vCPU is running.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 8738bd783de2..92cbf2d8d7b1 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -497,6 +497,7 @@
 #define X86_FEATURE_TSA_L1_NO		(21*32+12) /* AMD CPU not vulnerable to TSA-L1 */
 #define X86_FEATURE_CLEAR_CPU_BUF_VM	(21*32+13) /* Clear CPU buffers using VERW before VMRUN */
 #define X86_FEATURE_MSR_IMM		(21*32+14) /* MSR immediate form instructions */
+#define X86_FEATURE_X2AVIC_EXT		(21*32+15) /* AMD SVM x2AVIC support for 4k vCPUs */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index cf4ae822bcc0..c6908c08aa55 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -49,6 +49,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PROC_FEEDBACK,		CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_AMD_FAST_CPPC,		CPUID_EDX, 15, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,			CPUID_EBX,  6, 0x80000008, 0 },
+	{ X86_FEATURE_X2AVIC_EXT,		CPUID_ECX,  6, 0x8000000a, 0 },
 	{ X86_FEATURE_COHERENCY_SFW_NO,		CPUID_EBX, 31, 0x8000001f, 0 },
 	{ X86_FEATURE_SMBA,			CPUID_EBX,  2, 0x80000020, 0 },
 	{ X86_FEATURE_BMEC,			CPUID_EBX,  3, 0x80000020, 0 },
-- 
2.50.1



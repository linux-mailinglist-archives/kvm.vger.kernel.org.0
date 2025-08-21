Return-Path: <kvm+bounces-55336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A833AB301F3
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:24:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4378CAE00EC
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 18:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E357F34AAEA;
	Thu, 21 Aug 2025 18:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YlQ3VuCb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108342E62B3;
	Thu, 21 Aug 2025 18:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755800606; cv=none; b=TuoIpZgy5PVDgvdGltvQ0AJ4WwQjBUAyrO6SRKbcmanlinnBkz81XtTCdKWH6Vk4j6RmpVUPpH9BX07W6O091MhBm9QTSReT+DRv/+jYhNouERNKO43yj0MdtRmemSJUipN4pqzsQ7q4flZtk1S378EGMDAZNVaJrhN0KkVPTc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755800606; c=relaxed/simple;
	bh=0Yj5JZHjaWiDqMSbt1goY4h+cOWdrnslXbKQElQVKlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=najsLoZMkmO2r274Si+BHzLUzq/g4HYqmHcgh9uNLaglZOu3GtgysXhwMmn7IFsoc7z3PCtuQSR2aPBXsfrjHVtpAqfIEoHCEcjrnNivCa1su68bWa2sWOxRB4DQFI8cvNosOzPGUW4lej/X9xYQe2G99qbKcccJTxjcFD2y2GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YlQ3VuCb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E13C4CEEB;
	Thu, 21 Aug 2025 18:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755800605;
	bh=0Yj5JZHjaWiDqMSbt1goY4h+cOWdrnslXbKQElQVKlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlQ3VuCbfpU49jDZop9TSOTAWVHLDsoakVzrq6slMV4Ey8rDWxJYDcZL3qKTO/anU
	 lYpuyjVSBf3HBb9Glu3VDqrsGWDHeUMZEsbqi0kDJGUSFrj8Qvv+4RvETrH5RzCOwu
	 thO8CTwZwogDwwaMlBJLiM502Pe7G+qCeAQnVuSCvpHD2oOeF9bXv7ua6HhdSRRCx5
	 03VVNw96zJUW4kap+HklKSdZsHi6Kr2dd/7LPtmNrFZPIzqWvcDKA2yKh87OBJ7x9m
	 9N7dresuXVdYd0Boopdc9xEACBQkdc7Q5vWXuzt2IkKqcoDfXipNY6NKrYMm3kyZ8h
	 oBsZGYYBTIzeQ==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH v4 6/7] x86/cpufeatures: Add X86_FEATURE_X2AVIC_EXT
Date: Thu, 21 Aug 2025 23:48:37 +0530
Message-ID: <cee06ad5fbe214942fdc0bbe7faab379008c03e5.1755797611.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755797611.git.naveen@kernel.org>
References: <cover.1755797611.git.naveen@kernel.org>
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
index eb859299d514..9ba97459579f 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -496,6 +496,7 @@
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



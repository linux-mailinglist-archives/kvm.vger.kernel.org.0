Return-Path: <kvm+bounces-38877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB979A3FBBF
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 17:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D238F8817CA
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 16:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C169211A00;
	Fri, 21 Feb 2025 16:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FMvuTohp"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D3620E32D
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 16:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740155653; cv=none; b=qLsWMg64/0z17JE6+hLrNZ7hnBc9qdu3isKs9MDBqHJziX7uDmAiaDnMo5RlsqrXQDruwqhnmUbEkvml/3LL/MirQ2tvVM9+ZCMg9gtDoxvBqxkonYRqPW8ROAXsBYzNrTt0uDhi3fldj74RjFiqXS5BMMIHY5GDnulBwyWnz24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740155653; c=relaxed/simple;
	bh=LiLn0i9Td7SClEMbhcgHHlr9u1P2brpGX9PYN01puA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzMo6VGcidYC7g8uenZN1m6L2PKXxOHqIV91OErxGgBWzjySk8rtRZIHAHG1rwuezoY88esSfeETbRIu7TXb6WwTPlb6J3SIPlDL5kiBfTKeJ7xIzku/sZHM1qFzz4Sdg4tZP+pTCtbuW3isdGuuxxxwtLJghoo3AZvBF2EwlMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FMvuTohp; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740155647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQc/HabnpnH39zEM1pbLYGL57sbgP/YZ4LZE9qk3CJM=;
	b=FMvuTohpaxe+k1t6UCOb4B9HgZInrJ5KvveooB2AZc9ii1bmM4KjYZxmWuevwfEEpDfCA9
	OHZYKqICITLZOULcpgUxviQKDBONTyiRko6mrCNxZ29WCWjTmpo/g1LENmUoCm+r2ugZ4u
	Yk5DjawysYP1rBnlAxZb1BGQBnextKE=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: x86@kernel.org,
	Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	"Kaplan, David" <David.Kaplan@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 1/3] x86/cpufeatures: Define X86_FEATURE_AMD_IBRS_SAME_MODE
Date: Fri, 21 Feb 2025 16:33:50 +0000
Message-ID: <20250221163352.3818347-2-yosry.ahmed@linux.dev>
In-Reply-To: <20250221163352.3818347-1-yosry.ahmed@linux.dev>
References: <20250221163352.3818347-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Per the APM [1]:

  Some processors, identified by CPUID Fn8000_0008_EBX[IbrsSameMode]
  (bit 19) = 1, provide additional speculation limits. For these
  processors, when IBRS is set, indirect branch predictions are not
  influenced by any prior indirect branches, regardless of mode (CPL
  and guest/host) and regardless of whether the prior indirect branches
  occurred before or after the setting of IBRS. This is referred to as
  Same Mode IBRS.

Define this feature bit, which will be used by KVM to determine if an
IBPB is required on nested VM-exits in SVM.

[1] AMD64 Architecture Programmer's Manual Pub. 40332, Rev 4.08 - April
    2024, Volume 2, 3.2.9 Speculation Control MSRs

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/cpufeatures.h       | 1 +
 tools/arch/x86/include/asm/cpufeatures.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 645aa360628da..46af88357ac89 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -344,6 +344,7 @@
 #define X86_FEATURE_AMD_IBRS		(13*32+14) /* Indirect Branch Restricted Speculation */
 #define X86_FEATURE_AMD_STIBP		(13*32+15) /* Single Thread Indirect Branch Predictors */
 #define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
+#define X86_FEATURE_AMD_IBRS_SAME_MODE	(13*32+19) /* Indirect Branch Restricted Speculation same mode protection*/
 #define X86_FEATURE_AMD_PPIN		(13*32+23) /* "amd_ppin" Protected Processor Inventory Number */
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* "virt_ssbd" Virtualized Speculative Store Bypass Disable */
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 17b6590748c00..c99d626357c1e 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -344,6 +344,7 @@
 #define X86_FEATURE_AMD_IBRS		(13*32+14) /* Indirect Branch Restricted Speculation */
 #define X86_FEATURE_AMD_STIBP		(13*32+15) /* Single Thread Indirect Branch Predictors */
 #define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
+#define X86_FEATURE_AMD_IBRS_SAME_MODE (13*32+19) /* Indirect Branch Restricted Speculation same mode protection*/
 #define X86_FEATURE_AMD_PPIN		(13*32+23) /* "amd_ppin" Protected Processor Inventory Number */
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* "virt_ssbd" Virtualized Speculative Store Bypass Disable */
-- 
2.48.1.601.g30ceb7b040-goog



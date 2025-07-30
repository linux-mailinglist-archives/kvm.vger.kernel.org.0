Return-Path: <kvm+bounces-53743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CCE9B165C4
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 19:47:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1849D1AA49D1
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 17:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27702E266D;
	Wed, 30 Jul 2025 17:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="v81jOrED"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835572E0B48;
	Wed, 30 Jul 2025 17:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753897628; cv=none; b=ciUEKcTx0PSqRlPC/ngN3dGCD7sgvwb7nepHOwRjtgDs43g/a1MayjUgGgXSYAEII1pF92OcO8g1gAMK8/I5q2uGJxnbT3bBv7LltDH/0xvCbUKjU5MTmpPZZ0AJ8YwzskEoLuZgY3B7oFezuxdYObgfpcolX8pf319X37CqSmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753897628; c=relaxed/simple;
	bh=YkaTqbIa0Lhu6eQvvxFvCSIWv25wLG3CI3TsmldTmkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DK4EdqYC1V/O0T9TS6nbf3aZhtZ2Ql8a8l4H5AUGpxf0+vBcFYSOik9TMT3/5/DmbB/K36lpz5qNeHOF8CXtPEJdwFY7bySJxb/b/H+K6Ny7UXZMRQyUiFqiPzgop31PClqSVUMD0p9ZYMQ0yzrA8pfpzs8PPQtDH/+AYgYq+To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=v81jOrED; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56UHk6n91614815
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 30 Jul 2025 10:46:30 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56UHk6n91614815
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753897591;
	bh=AtjLVGdDRTprzlOEJ8gLfOLK0WV5tl2DOGR7MTz83Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v81jOrED/wlg+g4Wk9T47fvskf9RsIsoHwa5H0viJZ9Z6LKYJLSeMWI0PhctO8WY5
	 zyBAKbqaxawXTL6cjqJTLszWOyJ/dNNs5VaBIBbjw0BOk9B/FRvRt/5TFuHIX6fv2B
	 Ni2A3FNtm8F00yvoAJ6l/qVPoEJbGVyZWWWANQ99XCdmhVS/KhYfHFoX+wksAxDWFc
	 mptXmHgzyoDMFYdEme/Ew4KSG35Zb4Qbc2wC69/FKQHCTk2ZF/aqRmPW7wQGly9Zfe
	 rXUAw1hggZXlMdoqkvXWDRPhKQcRPS8uRE+xjOM0oeounFWN5VXfZvzvjCA72bvah5
	 eLHHpU/2VCc0w==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, chao.gao@intel.com
Subject: [PATCH v1 1/4] x86/cpufeatures: Add a CPU feature bit for MSR immediate form instructions
Date: Wed, 30 Jul 2025 10:46:02 -0700
Message-ID: <20250730174605.1614792-2-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730174605.1614792-1-xin@zytor.com>
References: <20250730174605.1614792-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The immediate form of MSR access instructions are primarily motivated
by performance, not code size: by having the MSR number in an immediate,
it is available *much* earlier in the pipeline, which allows the
hardware much more leeway about how a particular MSR is handled.

Use a scattered CPU feature bit for MSR immediate form instructions.

Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 286d509f9363..75b43bbe2a6d 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -491,6 +491,7 @@
 #define X86_FEATURE_TSA_SQ_NO		(21*32+11) /* AMD CPU not vulnerable to TSA-SQ */
 #define X86_FEATURE_TSA_L1_NO		(21*32+12) /* AMD CPU not vulnerable to TSA-L1 */
 #define X86_FEATURE_CLEAR_CPU_BUF_VM	(21*32+13) /* Clear CPU buffers using VERW before VMRUN */
+#define X86_FEATURE_MSR_IMM		(21*32+14) /* MSR immediate form instructions */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index b4a1f6732a3a..5fe19bbe538e 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -27,6 +27,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_APERFMPERF,		CPUID_ECX,  0, 0x00000006, 0 },
 	{ X86_FEATURE_EPB,			CPUID_ECX,  3, 0x00000006, 0 },
 	{ X86_FEATURE_INTEL_PPIN,		CPUID_EBX,  0, 0x00000007, 1 },
+	{ X86_FEATURE_MSR_IMM,			CPUID_ECX,  5, 0x00000007, 1 },
 	{ X86_FEATURE_APX,			CPUID_EDX, 21, 0x00000007, 1 },
 	{ X86_FEATURE_RRSBA_CTRL,		CPUID_EDX,  2, 0x00000007, 2 },
 	{ X86_FEATURE_BHI_CTRL,			CPUID_EDX,  4, 0x00000007, 2 },
-- 
2.50.1



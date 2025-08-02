Return-Path: <kvm+bounces-53865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E69AB189D1
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 02:16:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 074EA626D37
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 00:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A86E6BB5B;
	Sat,  2 Aug 2025 00:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JJyjY/O/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A12946A;
	Sat,  2 Aug 2025 00:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754093766; cv=none; b=lia9dveluDs3X8QzdOghdlNzRoYooSayeCyxuNlNb30p+M66MCrqEHCN3B2o3juVNbyPvj/yOnlKpG9YDUAV7PsZ82tguXsJDclWuz5BmSVw7wvDtTZcQh7/Fqkcn0Y4Jsh1eGNEijncoiwZD/HUaQGV7uJs2Pxx7n15TydCneI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754093766; c=relaxed/simple;
	bh=YkaTqbIa0Lhu6eQvvxFvCSIWv25wLG3CI3TsmldTmkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQxFGxIt7gR+2NzQMvRYIVL5FxZTt9K2VKFuPHBVOhz1cgr0znVCoHEQWPmbDluhx6zdXx5zqX4Q8xJoFHcAcWfEK+EXB9/FLuINX3SFXkVWWMmmR0GfzsJrSlsn9REhYbZ3t6SdQnsh7VMGaypvlwhyczIxyJqJxGRMhJYPOqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JJyjY/O/; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5720FKpG3142596
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 1 Aug 2025 17:15:28 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5720FKpG3142596
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1754093728;
	bh=AtjLVGdDRTprzlOEJ8gLfOLK0WV5tl2DOGR7MTz83Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJyjY/O/5i/jdQiDEs0IRFT0+Ci3n+LUhBlr9VVD/duJAd/Ae4c1jDvT9lYD8iju2
	 s5lHmqRKgAq8x8dGxzgB0+7doiaYciq/vQI2FPIvH7iC7LDw1qmODdVjRBXyo4zvmf
	 WlppOC/ds7HoYnqoKxyCeFACkmXlW4zzARWVKt/q6cp5xxQycKDZRV5QRQordwrQW7
	 CAUI3atVsn4uMQu5gLDIgR1u5YfC91JA+3DJPYf5rAxkOMzlv5tLKJjKT/jtij2RQl
	 wj+/y2cKfAlx884YiNKLB0cjRRywJ3KMGSojnj/Jvr6FeD2P6aBjl0SBE+jl21fla1
	 VdJFjSX6W7Egg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, chao.gao@intel.com
Subject: [PATCH v2 1/4] x86/cpufeatures: Add a CPU feature bit for MSR immediate form instructions
Date: Fri,  1 Aug 2025 17:15:17 -0700
Message-ID: <20250802001520.3142577-2-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250802001520.3142577-1-xin@zytor.com>
References: <20250802001520.3142577-1-xin@zytor.com>
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



Return-Path: <kvm+bounces-43780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD52DA961C3
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:33:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC83C7A7457
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B5726B087;
	Tue, 22 Apr 2025 08:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JPM2elO1"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730B224EF8D;
	Tue, 22 Apr 2025 08:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310240; cv=none; b=brghxfg7WhApiaxsdfIICtCLlFtjSfbXYtXdmJNDtPKYcaRPFBrzLSXTDNuEOoQnjYoUk1uXMoHO9Y3COyKY0VtTqSBs6k2l7ur4BzsEonQYJMcNWdPTd01F8jmAAxruN7CWZG7DN9MpVpdLKrobQ626jJ6C1OiLq/LnyKzSRbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310240; c=relaxed/simple;
	bh=8d5UABKEfLWVGcf/63whVhelSFhl7HVKn2G3+ZvDOSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDI0M3Yn2rz5lS3aqBEu53iD1devY44vPEQqBRhQqEpWkSm4k4K4n4VSY64gV4mLnn63ma96/fDh8KKRdoqLrIdbwgZwUQhx/TyUo5m13ROc1Z2+/xSXhRxdRp4jBg7Igq6cW3G9uHURS5xsk7O9f7vwJhbl6uSPLtKjQmUp2Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JPM2elO1; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9f1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:23:15 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9f1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310197;
	bh=n9SvQ+6gLfKPeJxZo0ixRWTtLNf7Ind1ig8lOaFKHRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPM2elO1cKqKRmNOT5WRj7ojg2yaJuuZ/6RneSxHgf10deYK+Y7ngp9qNQakxHc9b
	 Wsg8uG8q6cSmvwlgeJ6PFS2VwvUlEZwd/LO3Y7lH/odwkiDSFGchLPsgqm7UgOwPwJ
	 YL8xps4uREMf97Zc12/2mrarAGPeDrtCw6ugZUk9/MOAoIHZN1WY5EuwEHgXjpSz51
	 yJfDvs/7rmfx8C8y4FtDWPthXdwtb2hgw7mwPRlXoqWQ2O75Ak43Bzdjii0ltr0hKy
	 e46ml6+1ZMMn436GDY7jbddaePt9Y4Kf4BrvAyZWkwflLKHZSQPDgePwOQ5ZUW2rNp
	 VpBDzdmZF41qA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 27/34] x86/msr: Rename native_write_msr() to native_wrmsrq()
Date: Tue, 22 Apr 2025 01:22:08 -0700
Message-ID: <20250422082216.1954310-28-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/msr.h | 4 ++--
 arch/x86/kernel/kvmclock.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 2a62a899f7a5..72a1c3301d46 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -369,7 +369,7 @@ static __always_inline int rdmsrq_safe(u32 msr, u64 *val)
  *        native_wrmsrq_no_trace()    native_write_msr_safe()        |
  *                   /        \                                      |
  *                  /          \                                     |
- * native_wrmsr_no_trace()    native_write_msr()                     |
+ * native_wrmsr_no_trace()    native_wrmsrq()                        |
  *                                                                   |
  *                                                                   |
  *                                                                   |
@@ -472,7 +472,7 @@ static __always_inline void native_wrmsr_no_trace(u32 msr, u32 low, u32 high)
 	native_wrmsrq_no_trace(msr, (u64)high << 32 | low);
 }
 
-static inline void notrace native_write_msr(u32 msr, u64 val)
+static inline void notrace native_wrmsrq(u32 msr, u64 val)
 {
 	native_wrmsrq_no_trace(msr, val);
 
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index ca0a49eeac4a..36417fed7f18 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -196,7 +196,7 @@ static void kvm_setup_secondary_clock(void)
 void kvmclock_disable(void)
 {
 	if (msr_kvm_system_time)
-		native_write_msr(msr_kvm_system_time, 0);
+		native_wrmsrq(msr_kvm_system_time, 0);
 }
 
 static void __init kvmclock_init_mem(void)
-- 
2.49.0



Return-Path: <kvm+bounces-43765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 55B4EA9615C
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:26:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C1E67A7A63
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B9925DCE9;
	Tue, 22 Apr 2025 08:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="awo00TyT"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26AC254B11;
	Tue, 22 Apr 2025 08:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310232; cv=none; b=X8vAyMUlWRY3hMdW6AzaFXoSGsekdLaPLC+d+ubacifs+UcGCs1FDoDHhJCJhhjrbrYEv9+kyD/VWj9iHi4PB67Fq2iIMK9Ovu+TSyWEbb3wdg6MVi+lj1WGjEzYjl2fqEEeHXMJrjeQOWe4uRRr64SdBAIix3+XCGPDyRHQQCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310232; c=relaxed/simple;
	bh=RZGiVx8WnrXBUkKKqZvIFcRKk/LzQAvMyRlpdcQCCUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghXKwzflKQEhJN96/sUO7P1usBFZDN26j/UdOBKLvmaAuTZmPQrW7qJJWjboYxf91WASGBNoXtOHNlZbh78AqC10ery6o+VPyXwhtwYqVGyfhzLk4WLLE29VwQVXjzbBze8X3NqcfpL4QzKnWNYl0q2Ct5dwGf8eam+KWWNngpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=awo00TyT; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9P1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:22:42 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9P1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310164;
	bh=DiJ//ZCDdr9jGcfbSpj9Ofv6WJfHxK1CVTdlWhlF0ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awo00TyT4cngwFyInD7AfuKbrTVw6bBZi3n6QyYwm0hfsJ7d5DOK6ryUYZ3uscVVA
	 FF+/ZckvDC7vJBMN9CfhH0oB+rd6uUZellPGM3U8hSIrlyK6PBfkibWxmrGRbllYd1
	 mE2ZFVrjThdSNLdX6irdbeka6A0ak4pjCNrLUx38kXIvxj25yQ4iJCUhdh/khFEnXG
	 zYoEbXMPDWF9GI7E0m8RnYVRjYYkqS5swH1ZyZ2jVOmguT3He0hBROzSc2OnEczHY3
	 OzNunzBKTcjX5LDne8JZTMzyp65l9t4ZqXugbpDnuQ/AfCTDwojG2MrD7a94yT3wHk
	 joHUW+H9AE6gw==
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
Subject: [RFC PATCH v2 11/34] x86/msr: Remove calling native_{read,write}_msr{,_safe}() in pmu_msr_{read,write}()
Date: Tue, 22 Apr 2025 01:21:52 -0700
Message-ID: <20250422082216.1954310-12-xin@zytor.com>
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

hpa found that pmu_msr_write() is actually a completely pointless
function [1]: all it does is shuffle some arguments, then calls
pmu_msr_chk_emulated() and if it returns true AND the emulated flag
is clear then does *exactly the same thing* that the calling code
would have done if pmu_msr_write() itself had returned true.  And
pmu_msr_read() does the equivalent stupidity.

Remove the calls to native_{read,write}_msr{,_safe}() within
pmu_msr_{read,write}().  Instead reuse the existing calling code
that decides whether to call native_{read,write}_msr{,_safe}() based
on the return value from pmu_msr_{read,write}().  Consequently,
eliminate the need to pass an error pointer to pmu_msr_{read,write}().

While at it, refactor pmu_msr_write() to take the MSR value as a u64
argument, replacing the current dual u32 arguments, because the dual
u32 arguments were only used to call native_write_msr{,_safe}(), which
has now been removed.

[1]: https://lore.kernel.org/lkml/0ec48b84-d158-47c6-b14c-3563fd14bcc4@zytor.com/

Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Sign-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/xen/enlighten_pv.c |  6 +++++-
 arch/x86/xen/pmu.c          | 27 ++++-----------------------
 arch/x86/xen/xen-ops.h      |  4 ++--
 3 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 9fbe187aff00..1418758b57ff 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1132,6 +1132,8 @@ static void set_seg(unsigned int which, unsigned int low, unsigned int high,
 static void xen_do_write_msr(unsigned int msr, unsigned int low,
 			     unsigned int high, int *err)
 {
+	u64 val;
+
 	switch (msr) {
 	case MSR_FS_BASE:
 		set_seg(SEGBASE_FS, low, high, err);
@@ -1158,7 +1160,9 @@ static void xen_do_write_msr(unsigned int msr, unsigned int low,
 		break;
 
 	default:
-		if (!pmu_msr_write(msr, low, high, err)) {
+		val = (u64)high << 32 | low;
+
+		if (!pmu_msr_write(msr, val)) {
 			if (err)
 				*err = native_write_msr_safe(msr, low, high);
 			else
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index 9c1682af620a..95caae97a394 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -313,37 +313,18 @@ static bool pmu_msr_chk_emulated(unsigned int msr, uint64_t *val, bool is_read,
 	return true;
 }
 
-bool pmu_msr_read(unsigned int msr, uint64_t *val, int *err)
+bool pmu_msr_read(u32 msr, u64 *val)
 {
 	bool emulated;
 
-	if (!pmu_msr_chk_emulated(msr, val, true, &emulated))
-		return false;
-
-	if (!emulated) {
-		*val = err ? native_read_msr_safe(msr, err)
-			   : native_read_msr(msr);
-	}
-
-	return true;
+	return pmu_msr_chk_emulated(msr, val, true, &emulated) && emulated;
 }
 
-bool pmu_msr_write(unsigned int msr, uint32_t low, uint32_t high, int *err)
+bool pmu_msr_write(u32 msr, u64 val)
 {
-	uint64_t val = ((uint64_t)high << 32) | low;
 	bool emulated;
 
-	if (!pmu_msr_chk_emulated(msr, &val, false, &emulated))
-		return false;
-
-	if (!emulated) {
-		if (err)
-			*err = native_write_msr_safe(msr, low, high);
-		else
-			native_write_msr(msr, low, high);
-	}
-
-	return true;
+	return pmu_msr_chk_emulated(msr, &val, false, &emulated) && emulated;
 }
 
 static u64 xen_amd_read_pmc(int counter)
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index dc886c3cc24d..a1875e10be31 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -271,8 +271,8 @@ void xen_pmu_finish(int cpu);
 static inline void xen_pmu_init(int cpu) {}
 static inline void xen_pmu_finish(int cpu) {}
 #endif
-bool pmu_msr_read(unsigned int msr, uint64_t *val, int *err);
-bool pmu_msr_write(unsigned int msr, uint32_t low, uint32_t high, int *err);
+bool pmu_msr_read(u32 msr, u64 *val);
+bool pmu_msr_write(u32 msr, u64 val);
 int pmu_apic_update(uint32_t reg);
 u64 xen_read_pmc(int counter);
 
-- 
2.49.0



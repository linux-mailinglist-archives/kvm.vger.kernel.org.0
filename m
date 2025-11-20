Return-Path: <kvm+bounces-63999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E4E63C769F9
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:32:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A0F12358876
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E883093CD;
	Thu, 20 Nov 2025 23:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E9OwWVbZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776A930BB8A
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763681528; cv=none; b=fr9NaZSnXKd81uA4VakAGHICmcJmmfo7mp1tsbhRZkGzEjoGmwnaE8Q5efOGEIZW45axutYz0IPXNrfIecNbqjwH74oKQkm+lVABE9TmAxxd543nUPv4VzZg9PzAoi1pgDisGvWlOh/y6/RIRJI1HTfjQWhndXh09p/jJ5sIKXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763681528; c=relaxed/simple;
	bh=5ZD06AI7zWxET9vAGhukhzeSly5h9OphZxmRgnz1qdU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h25KcQVPruZuBfwBc255mooUkzTRk5+Ole0kpViRDLyqO/FyDonsCvXVxcRFeBIkF4bY/OcMmRfQIf1ZRJxA590VkpzcwQCMDkpMEyaAP6ZiQfSeMunrkvwdVTHjdv1zSoSsUOh/T0sj708+cjI3lxXPcA4rk44L3QeMx9BLkpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E9OwWVbZ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3416dc5754fso3287158a91.1
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763681526; x=1764286326; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jyNN0DXXgpzqGWdpOnw2jjdiDkCh9pfualLy36FZJCQ=;
        b=E9OwWVbZAeLAXHLgnqbHBaHUTQhxN0g7cQY2kIEasc9fnvN119gmOWhs/8CHEqZh8j
         6vh/UsEBBJwzswieaXn5Uxr3X7ppK1CdfbzYkfReUvusUmszncg4EOsvyYI2U01fJq6V
         ClPW/5408LErTNIK2vNwAAOb2O5rHdyplGekWIqdQKAtI7OxNvcQRxxdq0WZ8hK5ioD6
         +3VbG+Rkm2kCCOlxh98b57oX8nuPL1xztrW8Qqbv0JHh04P6MiBXoE+ZJaex2uy3CPXS
         SR4KIpLCnWuApM5/rVx0jRofvWB0CGaVgs2HaevTVzyzdQscwv+2XUyLLxFWZWFGKZVB
         LnMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763681526; x=1764286326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jyNN0DXXgpzqGWdpOnw2jjdiDkCh9pfualLy36FZJCQ=;
        b=WfAyXtSDFj9V9IkXgZqE7h0x5T5xa2mOiIegJb7eKe1yeG2xMxFRMYrEptMEOHZCD2
         bjorxLfamxKKjYb8ItNrK3tamG5zz0zskEf9g4G3l+PSMmBij7mF68I0AgrHa6Oc7rkw
         n9twNQFUrEv93gcTyRS9Kzvm2mUX9dnMDmoAxoAK5I4bHhpbxRLk0dyOBDrdhS1zIsy7
         VGr+aUJwPCsg3tOtA1a0RSfjYYIrd9kAWzCvreatVqF9B4w3n7A3INJ+mtVgxnwt6RPA
         U1/0GoXrKfqkHWlMfhYrfNx262vnlAdEsIRIarc3xOZHKW5No+PtygyPAc/pCeGTYuxA
         dC5Q==
X-Gm-Message-State: AOJu0YzcSFFyi/dAzO+KURe6ILiLaTiTmHqBz68Zrzqlw/UZg41NxQmw
	PixH+zurAc2ODanML9XAS5MSksbmBhCEwWLObrE9t/mdDgIJKqsbwj8qCHMLIQf07llokvAzoQJ
	Oa69IaA==
X-Google-Smtp-Source: AGHT+IF1OjbBh3fJhT4HiEIhAVO+Z0OlQvlRr/VYLL186xobvzzWOegRQZ5YADW/dRDjLNmUX4MWihbGkcQ=
X-Received: from pjtv10.prod.google.com ([2002:a17:90a:c90a:b0:340:3e18:b5c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b42:b0:341:8b2b:43c
 with SMTP id 98e67ed59e1d1-34733f236d3mr227432a91.18.1763681525979; Thu, 20
 Nov 2025 15:32:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Nov 2025 15:31:49 -0800
In-Reply-To: <20251120233149.143657-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120233149.143657-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251120233149.143657-9-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 8/8] x86: pmu_pebs: Support to validate
 timed PEBS record on GNR/SRF
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Yi Lai <yi1.lai@intel.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

On Intel GNR/SRF platform, timed PEBS is introduced. Timed PEBS adds
a new "retired latency" field in basic info group to show the timing
info. IA32_PERF_CAPABILITIES.PEBS_TIMING_INFO[bit 17] is introduced to
indicate whether timed PEBS is supported.

After introducing timed PEBS, the PEBS record format field shrinks to
bits[31:0] and  the bits[47:32] is used to record retired latency.

Thus shrink the record format to bits[31:0] accordingly and avoid the
retired latency field is recognized a part of record format to compare
and cause failure on GNR/SRF.

Please find detailed information about timed PEBS in section 8.4.1
"Timed Processor Event Based Sampling" of "Intel Architecture
Instruction Set Extensions and Future Features".

Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.h  | 6 ++++++
 x86/pmu_pebs.c | 8 +++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index e84b37dc..cd6091af 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -20,6 +20,7 @@
 #define PMU_CAP_LBR_FMT	  0x3f
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
 #define PMU_CAP_PEBS_BASELINE	(1ULL << 14)
+#define PMU_CAP_PEBS_TIMING_INFO	(1ULL << 17)
 #define PERF_CAP_PEBS_FORMAT           0xf00
 
 #define EVNSEL_EVENT_SHIFT	0
@@ -193,4 +194,9 @@ static inline bool pmu_has_pebs_baseline(void)
 	return pmu.perf_cap & PMU_CAP_PEBS_BASELINE;
 }
 
+static inline bool pmu_has_pebs_timing_info(void)
+{
+	return pmu.perf_cap & PMU_CAP_PEBS_TIMING_INFO;
+}
+
 #endif /* _X86_PMU_H_ */
diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index 2848cc1e..bc37e8e3 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -277,6 +277,7 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
 	unsigned int count = 0;
 	bool expected, pebs_idx_match, pebs_size_match, data_cfg_match;
 	void *cur_record;
+	u64 format_mask;
 
 	expected = (ds->pebs_index == ds->pebs_buffer_base) && !pebs_rec->format_size;
 	if (!(rdmsr(MSR_CORE_PERF_GLOBAL_STATUS) & GLOBAL_STATUS_BUFFER_OVF)) {
@@ -289,6 +290,8 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
 		return;
 	}
 
+	/* Record format shrinks to bits[31:0] after timed PEBS is introduced. */
+	format_mask = pmu_has_pebs_timing_info() ? GENMASK_ULL(31, 0) : GENMASK_ULL(47, 0);
 	expected = ds->pebs_index >= ds->pebs_interrupt_threshold;
 	cur_record = (void *)pebs_buffer;
 	do {
@@ -296,8 +299,7 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
 		pebs_record_size = pebs_rec->format_size >> RECORD_SIZE_OFFSET;
 		pebs_idx_match = pebs_rec->applicable_counters & bitmask;
 		pebs_size_match = pebs_record_size == get_pebs_record_size(pebs_data_cfg, use_adaptive);
-		data_cfg_match = (pebs_rec->format_size & GENMASK_ULL(47, 0)) ==
-				 (use_adaptive ? pebs_data_cfg : 0);
+		data_cfg_match = (pebs_rec->format_size & format_mask) == (use_adaptive ? pebs_data_cfg : 0);
 		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
 		report(expected,
 		       "PEBS record (written seq %d) is verified (including size, counters and cfg).", count);
@@ -327,7 +329,7 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
 			       pebs_record_size, get_pebs_record_size(pebs_data_cfg, use_adaptive));
 		if (!data_cfg_match)
 			printf("FAIL: The pebs_data_cfg (0x%lx) doesn't match with the effective MSR_PEBS_DATA_CFG (0x%lx).\n",
-			       pebs_rec->format_size & 0xffffffffffff, use_adaptive ? pebs_data_cfg : 0);
+			       pebs_rec->format_size & format_mask, use_adaptive ? pebs_data_cfg : 0);
 	}
 }
 
-- 
2.52.0.rc2.455.g230fcf2819-goog



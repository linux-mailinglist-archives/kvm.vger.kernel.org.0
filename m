Return-Path: <kvm+bounces-11216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E16C7874360
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:02:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CA34281D5E
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 027981C6AD;
	Wed,  6 Mar 2024 23:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="glNqYTFu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A878E1C2A0
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 23:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709766122; cv=none; b=Y3xOy07D95orUDC5m3XkJdX/TVaSlFHx5dpH1645snXtZWzOQYY1PaKSHB3PlyvdqAJSjMSN6Xva32VxrI5xKaWzlgz2mwW33XK+SkH2mO4tfLVJkZ1dheUbwxBgTL+b+b9biIXKLDjLRS4xbax0TOxnKonCLfYlkSwH51UBABQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709766122; c=relaxed/simple;
	bh=SwHxfOycCP7l73Ua6N7SntjltzKr4z2VaIxOwTa9P6k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V0/y+oVTGAHjj1ayNT9JmbmOBJ/3/9h2b71Vj8IiIIh4u/1lEINV/MvNI8x/U4WggeoB79WbILzFt2eK8laAAVBm46BAnBpTZGnQyi1BMxZ3XDm7mq2wbBEIAL/FTfLjGpjgOTXF5iIOuui1VHRZGeekgm6Mc1c6Def/fIe9VkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=glNqYTFu; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-607e613a1baso5745117b3.1
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 15:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709766120; x=1710370920; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fa2zMucoeAAaF4S6HB/f4EAIj2WdAuLvHX8LoJcbTAA=;
        b=glNqYTFuvcIzC3AdHdZ7S6DfYCB296wZQQ4FarnM3Y4PTdzR6xJS5ssgd1c08Z9G7d
         byHsTIQM8cbVqE95Y8AdFPa5u0L2V+mQl94jr9U/ZxXPGrvOuUCMbGzJWMbex+HXS9Er
         d2p2lzosYChXS61W0m7hVkUsJ9ZvKrHDUoCmjHp7NTB+xdLq4caRP8AEOD7bLqXlSnC0
         LecNDHSiLvcf6pzxK/OElREQCe+9KWnQy8w0xzAzLPRtgG5kCTSKf/2V5TH2D+bjaUmw
         5jqOy59FnuBA2qDW8bIqCEHpOPRLHe2RIMUIS4+/JBCqLjnku0d0NstQAasM2BoF7A3L
         GE6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709766120; x=1710370920;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fa2zMucoeAAaF4S6HB/f4EAIj2WdAuLvHX8LoJcbTAA=;
        b=r35R5fHiuaPPB1kRKYSxm0LD529ebsGUV+jWLIkUt/2UOLZmdlSY3qvq0h1vuNeXmN
         Q75lw/L0dY7NR21aV1mdjQE73+KfBP0EWtfrOBuoZN7vbDvmJGQGQ0y4Rs8f0ZhMq05V
         l4hNH2WcNWVf+UoijTwUKjmRI6NuC1eBMamyzPanx8n/vyFRdn7lEbpg4CZOCqkQ4pEE
         UIpvJDXlkITQz04C5WvXLM0nmWQ9oWm3lST5kRvJXttCo1MOypzVDCt4dSwmDZ+wgyk4
         Dcln7WCgp9gLVwaJOg2SV5WT1j2QZCFoPbx6wlLH3Ec3OSaswHBQ+UismPlGXjNwdqAh
         uPdQ==
X-Gm-Message-State: AOJu0YxyOXiV1wI+ovt7UzfWvYp+8JyBY1hR56lrm9FWcbUugHTG7PMe
	oJq0rIUkZGKv81m37I9br9EWBgARrQWtdbZ6d4GmUr3JTQ+LVeBLr621G9yIQImxNOLVT25aLK/
	hNg==
X-Google-Smtp-Source: AGHT+IGzLmSL0E4VOxUDVo+RclJ5kCHNKIH5Bf5kYUHkwQYOrrykzQFiZR39JNMWEknFJRsnfEwZEfUsVvY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:ec5:b0:609:247a:fd3c with SMTP id
 cs5-20020a05690c0ec500b00609247afd3cmr5001630ywb.2.1709766119789; Wed, 06 Mar
 2024 15:01:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Mar 2024 15:01:51 -0800
In-Reply-To: <20240306230153.786365-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240306230153.786365-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240306230153.786365-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/4] x86/pmu: Iterate over adaptive PEBS flag combinations
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong <xiong.y.zhang@intel.com>, 
	Lv Zhiyuan <zhiyuan.lv@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"

Iterate over all possible combinations of adaptive PEBS flags, instead of
simply testing each flag individually.  There are currently only 16
possible combinations, i.e. there's no reason not to exhaustively test
every one.

Opportunistically rename PEBS_DATACFG_GP to PEBS_DATACFG_GPRS to
differentiate it from general purposes *counters*, which KVM also tends to
abbreviate as "GP".

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.h  |  6 +++++-
 x86/pmu_pebs.c | 20 +++++++++-----------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index 8465e3c9..f07fbd93 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -44,9 +44,13 @@
 #define GLOBAL_STATUS_BUFFER_OVF	BIT_ULL(GLOBAL_STATUS_BUFFER_OVF_BIT)
 
 #define PEBS_DATACFG_MEMINFO	BIT_ULL(0)
-#define PEBS_DATACFG_GP	BIT_ULL(1)
+#define PEBS_DATACFG_GPRS	BIT_ULL(1)
 #define PEBS_DATACFG_XMMS	BIT_ULL(2)
 #define PEBS_DATACFG_LBRS	BIT_ULL(3)
+#define PEBS_DATACFG_MASK	(PEBS_DATACFG_MEMINFO | \
+				 PEBS_DATACFG_GPRS | \
+				 PEBS_DATACFG_XMMS | \
+				 PEBS_DATACFG_LBRS)
 
 #define ICL_EVENTSEL_ADAPTIVE				(1ULL << 34)
 #define PEBS_DATACFG_LBR_SHIFT	24
diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index 050617cd..dff1ed26 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -78,13 +78,6 @@ static uint32_t intel_arch_events[] = {
 	0x412e, /* PERF_COUNT_HW_CACHE_MISSES */
 };
 
-static u64 pebs_data_cfgs[] = {
-	PEBS_DATACFG_MEMINFO,
-	PEBS_DATACFG_GP,
-	PEBS_DATACFG_XMMS,
-	PEBS_DATACFG_LBRS | ((MAX_NUM_LBR_ENTRY -1) << PEBS_DATACFG_LBR_SHIFT),
-};
-
 /* Iterating each counter value is a waste of time, pick a few typical values. */
 static u64 counter_start_values[] = {
 	/* if PEBS counter doesn't overflow at all */
@@ -105,7 +98,7 @@ static unsigned int get_adaptive_pebs_record_size(u64 pebs_data_cfg)
 
 	if (pebs_data_cfg & PEBS_DATACFG_MEMINFO)
 		sz += sizeof(struct pebs_meminfo);
-	if (pebs_data_cfg & PEBS_DATACFG_GP)
+	if (pebs_data_cfg & PEBS_DATACFG_GPRS)
 		sz += sizeof(struct pebs_gprs);
 	if (pebs_data_cfg & PEBS_DATACFG_XMMS)
 		sz += sizeof(struct pebs_xmm);
@@ -419,9 +412,14 @@ int main(int ac, char **av)
 		if (!has_baseline)
 			continue;
 
-		for (j = 0; j < ARRAY_SIZE(pebs_data_cfgs); j++) {
-			report_prefix_pushf("Adaptive (0x%lx)", pebs_data_cfgs[j]);
-			check_pebs_counters(pebs_data_cfgs[j]);
+		for (j = 0; j <= PEBS_DATACFG_MASK; j++) {
+			u64 pebs_data_cfg = j;
+
+			if (pebs_data_cfg & PEBS_DATACFG_LBRS)
+				pebs_data_cfg |= ((MAX_NUM_LBR_ENTRY -1) << PEBS_DATACFG_LBR_SHIFT);
+
+			report_prefix_pushf("Adaptive (0x%lx)", pebs_data_cfg);
+			check_pebs_counters(pebs_data_cfg);
 			report_prefix_pop();
 		}
 	}
-- 
2.44.0.278.ge034bb2e1d-goog



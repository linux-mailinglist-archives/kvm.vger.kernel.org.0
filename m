Return-Path: <kvm+bounces-63995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 581FAC769E6
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:32:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 66B3329E93
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2ECB307481;
	Thu, 20 Nov 2025 23:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fize4IND"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A980301463
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763681522; cv=none; b=CHel+YIPiNsL3Ne0DB4BuGW6Zjz+NpCWXHvkgJkyptVjNvU+/I1B3k1TyY5WamTL+R1RvDmbIuHLrWyfL+waENR9PVQ83LADlCdMOYYJ2ArLFp3h9ZBYNqzQIo74U/4KdX9RvZWxdS8K25/5d5UMWSLaJJHkIRM6vbyiukWN8SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763681522; c=relaxed/simple;
	bh=qunOBvHVh3nv7bsNEXQtxwMLhnwN6O1lkaHx7uPjx7k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=THCynYaFcHEXPZvf19qLTlTGqVcnWwJFh4YmtZfUAKiBJFcVc4sfixqd3wLiMSjxtutMk2jhrA0roiMQdGchyqFsEUcmv+a06wcy4PL4JV3zNBbt7JcTXrhHc9Hem+hmCdl2sv0ySzY01EQpmP3saeuzt35EO4iTG4c7Cjap5IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fize4IND; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3416dc5754fso3286913a91.1
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763681520; x=1764286320; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=m5Hwqhe1el3NTEVc1dKjHOc6l4YQW122FYhd1b/J1Tg=;
        b=fize4IND35GHB+Fo4YJwuMThDDXXvoU/nyCfyni9KutwYPt60IkthhHohoFOiXw2aA
         U0QfxNb/g6qmoEEP2DVjqA1T+02P6jpXbEIhxTLl8eV1+a4loL3pKPiPgnPBbXuoYSry
         Yr+eGeXmemEnGPhLRcaqVfD1YKYRNt3bimgAP5kAn4rL+/0ubuvume+Nu5I8Wsn2vdeC
         BD4XuDwbI3zna0UMN/9Zr19DQDRad199n6YXWBxmNsGgRE0Z6pwxnn5pPEmIuNgxbZ1J
         uKRZOVjVm4EHXzD7BG69dQJZ5qQ5wsEkI4Dx4vfKaNWN2mh+LIvS+lhGpX/UDf3vGm1f
         4YPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763681520; x=1764286320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m5Hwqhe1el3NTEVc1dKjHOc6l4YQW122FYhd1b/J1Tg=;
        b=FeJJOzeY6NNcYoOQdsBzqCMy9hYJXdofIDUyxcGBbqUcT2COCBvLz4aofVLZ6w7u4F
         bTMMPL1uSFKDm6d05l4u2/4DmlI3rlEBqlssfXQ26KuShphcDu23Rdb7b/la3DCi/I1F
         0c/DlXCmANbOBQdqmId4kjvR5ncOLrlDQyfUPj+3FQU+fTsiq9sIUvYK8xZmcLsCtUPv
         tgHxCypIwUoz+PUfoLgNTDLArYIRpXh8iJt6ko/wnhylyObBPeUD2Kep2BM/3IiZKPB+
         BFh+JVgjiiz4sNaOHyqe/lLRMXTRqLo5adBRrUm6FwfkdTIcEZ8wxJN5K9nwKRG9Gl3C
         wEvw==
X-Gm-Message-State: AOJu0YyngZr4kkPnrIMN6GWaY35XHJ3QuDRUeJAOaOqZvbLHj/WV5Eza
	OuuZ3xJaTTvDQlCauuJ6BU4mRgPDyBxow8tjajWdMonGlPIpZzKuWHDrMN5xUjqalu0KtMJ9EJu
	o05V6gA==
X-Google-Smtp-Source: AGHT+IE0CXTeRrYV5Dwl7GYXwx0jAAvo8DcFMbM0hDEfZPJ6lC5ihVH7zSgREyVFne+Lqj7NX0U6CygMdR8=
X-Received: from pjbqd12.prod.google.com ([2002:a17:90b:3ccc:b0:340:b1b5:eb5e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5183:b0:32e:9f1e:4ee4
 with SMTP id 98e67ed59e1d1-34733f2278bmr252428a91.17.1763681519750; Thu, 20
 Nov 2025 15:31:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Nov 2025 15:31:45 -0800
In-Reply-To: <20251120233149.143657-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120233149.143657-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251120233149.143657-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 4/8] x86/pmu: Handle instruction overcount
 issue in overflow test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Yi Lai <yi1.lai@intel.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: dongsheng <dongsheng.x.zhang@intel.com>

During the execution of __measure(), VM exits (e.g., due to
WRMSR/EXTERNAL_INTERRUPT) may occur. On systems affected by the
instruction overcount issue, each VM-Exit/VM-Entry can erroneously
increment the instruction count by one, leading to false failures in
overflow tests.

To address this, the patch introduces a range-based validation in place
of precise instruction count checks. Additionally, overflow_preset is
now statically set to 1 - LOOP_INSNS, rather than being dynamically
determined via measure_for_overflow().

These changes ensure consistent and predictable behavior aligned with the
intended loop instruction count, while avoiding modifications to the
subsequent status and status-clear testing logic.

The chosen validation range is empirically derived to maintain test
reliability across hardware variations.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 96b76d04..e1e98959 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -510,6 +510,21 @@ static void check_counters_many(void)
 
 static uint64_t measure_for_overflow(pmu_counter_t *cnt)
 {
+	/*
+	 * During the execution of __measure(), VM exits (e.g., due to
+	 * WRMSR/EXTERNAL_INTERRUPT) may occur. On systems affected by the
+	 * instruction overcount issue, each VM-Exit/VM-Entry can erroneously
+	 * increment the instruction count by one, leading to false failures
+	 * in overflow tests.
+	 *
+	 * To mitigate this, if the overcount issue is detected, hardcode the
+	 * overflow preset to (1 - LOOP_INSNS) instead of calculating it
+	 * dynamically. This ensures that an overflow will reliably occur,
+	 * regardless of any overcounting caused by VM exits.
+	 */
+	if (pmu.errata.instructions_retired_overcount)
+		return 1 - LOOP_INSNS;
+
 	__measure(cnt, 0);
 	/*
 	 * To generate overflow, i.e. roll over to '0', the initial count just
@@ -568,8 +583,12 @@ static void check_counter_overflow(void)
 			cnt.config &= ~EVNTSEL_INT;
 		idx = event_to_global_idx(&cnt);
 		__measure(&cnt, cnt.count);
-		if (pmu.is_intel)
-			report(cnt.count == 1, "cntr-%d", i);
+		if (pmu.is_intel) {
+			if (pmu.errata.instructions_retired_overcount)
+				report(cnt.count < 14, "cntr-%d", i);
+			else
+				report(cnt.count == 1, "cntr-%d", i);
+		}
 		else
 			report(cnt.count == 0xffffffffffff || cnt.count < 7, "cntr-%d", i);
 
-- 
2.52.0.rc2.455.g230fcf2819-goog



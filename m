Return-Path: <kvm+bounces-38269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F8D7A36B27
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:39:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3AB13B2AC7
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 568A617BEC6;
	Sat, 15 Feb 2025 01:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bXPsaCcD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A16E15198A
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583425; cv=none; b=BRTdxvebgixlIT6nPaxr2pYx+Jlgy1XMikrnXFhOS80DVpSjNdwwxOQOv01CcsNxJR8h9YZz/W5iaDz3s31dgYXVf3S/gaER39t02VaV+b4An1dzMxo41bXHFW70UhPzGoHvyeO0TynRY2N6cKtV+ChhnpB3OF2KoyYKBNvgurU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583425; c=relaxed/simple;
	bh=S7CO/iKqFHEdL32uzja5YKRUX33DYHfOGWv+QmDOPwI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D90MswGSSsAKHgXoefobSnojbmKVZUJ6y+zQteN8PvdaEDlU2mrgpcRemFygz6fHJXWM/1aQQQbVrMLK2qOpSSr5ahoLHzKM3x35wNjjjL+Pe/PRhGGwJuCFIl8NmI+OzXu57cbB+4uegFJ9Ec197dy4G8ccjD6oahR0qizlcUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bXPsaCcD; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa440e16ddso5642063a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583424; x=1740188224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=a61ZnPmFLsKKWXfA3ZRiEGw5ITXWWK1ErNz2wu8KXuM=;
        b=bXPsaCcDb3plpqib2o7Y58Kp6GjRTpAXsXZGtFLZYYboSdfoEMKOQfwIVVBsgd6k7m
         w44SjPrNzlxlNPxWBTnnFG+rb5hwOMqA/rEo5iZ/R69E7v9byQji0t4shmkvRyIiaXfr
         fCNP1G8R7qZiED9uroHMRysAzJoW6g/NJ+cayB0bUjC+1Md2mV0hkQUpyI/jInl5mB1G
         0MIrDUPjIFESgM2hJnhsFNbrptERfIx/bllXzh1E4o5hMj13bVZJjh/xVh5y7p4c0VZJ
         784bKOOOgMjEdtY1RnDa2N8cpUG5D78ZtJ4wExRvXTK2DLYgqgeOWmKvFE+Oia0SvelJ
         02aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583424; x=1740188224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a61ZnPmFLsKKWXfA3ZRiEGw5ITXWWK1ErNz2wu8KXuM=;
        b=ITHY2z5+rjTjd00MAgwZJc/RdGkbOe7yRz5y6lTxOc2XMS7BLBb9HjCpvdPvKCSk+p
         DosrF/qw8YlN/7mf0zG88Zu3XtLgvq0MeuEZKBLi7PLMCniteHOBbizTC0HcUIlR/xXm
         v5C+fvaWH5lvDWqvGhKcgcrp+sg30UCrg7EE5YBPoudgs5PV+mQs+gtRiujc7tgOaw95
         argVsnrV6Ct1MV5tihe+u1WfAASqBeHih3hfLEz6vtUsl9B8DxLi2VIj8MZMKJ17zafy
         H6MJHGtBXNIUJ9CI0rNXosvrqIB9pA7HPsNSqR3wFewE8/FM/J7fKfvSduAbvfFYANhr
         STsQ==
X-Gm-Message-State: AOJu0Ywjtk0lsf9nnDMGuJBHUa69nMJ2X7tQ5KzbqASYIiBA+065M0N0
	STwzLwjpAs3767P5Frwq2Su7RSD4d/K9jZDxzhN4ZoiL5TzLCYo5kIB/MjCLYKdF/C6SGqc37sU
	Qng==
X-Google-Smtp-Source: AGHT+IFSFLGmNpbzkdcNyLxEQduOgHebq0wASZdVtImhdGH+NyEkYYooBzo9hjJQT2ZNH+lu/4pEgSNz/cQ=
X-Received: from pjbok16.prod.google.com ([2002:a17:90b:1d50:b0:2ea:46ed:5d3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c8e:b0:2ee:741c:e9f4
 with SMTP id 98e67ed59e1d1-2fc40f104e7mr2013560a91.11.1739583423697; Fri, 14
 Feb 2025 17:37:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:32 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-16-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 15/18] x86: pmu: Adjust lower boundary of
 llc-misses event to 0 for legacy CPUs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

For these legacy Intel CPUs without clflush/clflushopt support, there is
on way to force to trigger a LLC miss and the measured llc misses is
possible to be 0. Thus adjust the lower boundary of llc-misses event to
0 to avoid possible false positive.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 97c05177..1fc94f26 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -81,6 +81,7 @@ struct pmu_event {
 enum {
 	INTEL_INSTRUCTIONS_IDX  = 1,
 	INTEL_REF_CYCLES_IDX	= 2,
+	INTEL_LLC_MISSES_IDX	= 4,
 	INTEL_BRANCHES_IDX	= 5,
 };
 
@@ -889,6 +890,15 @@ int main(int ac, char **av)
 		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
 		instruction_idx = INTEL_INSTRUCTIONS_IDX;
 		branch_idx = INTEL_BRANCHES_IDX;
+
+		/*
+		 * For legacy Intel CPUS without clflush/clflushopt support,
+		 * there is no way to force to trigger a LLC miss, thus set
+		 * the minimum value to 0 to avoid false positives.
+		 */
+		if (!this_cpu_has(X86_FEATURE_CLFLUSH))
+			gp_events[INTEL_LLC_MISSES_IDX].min = 0;
+
 		report_prefix_push("Intel");
 		set_ref_cycle_expectations();
 	} else {
-- 
2.48.1.601.g30ceb7b040-goog



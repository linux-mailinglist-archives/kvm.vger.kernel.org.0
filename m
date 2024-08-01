Return-Path: <kvm+bounces-22848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0DE94425C
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8AA38B23289
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C769014A0AA;
	Thu,  1 Aug 2024 04:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FlxFcygg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918EA149C4B
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488381; cv=none; b=YIoySkQrNqEBz1OIdVDS1xkJ6hblgf6bwFqR/Byp84cQQuzLpsq+sPpI2XskuM7feLJsQyTcrokr3AieiBpLsYgvqiEmvW2F5n9S3/kAdKNNgRD5byjNrUlTftokZ9z89bLusZ47/c4tNgZiqE3z9M8j0WtbGd9ZPQwO8WjtNCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488381; c=relaxed/simple;
	bh=EFtuBGgmb/ySfNg1lLBNQXQnQVSSdGAckiedsEFvN8M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IWdp9rFduksrSav6AN36aAbyX7XJ0wIb4dGMFnYBHYvvyqBhjUrp2114NTpa5c7LAdexwjX46YiYnm1vLKAkpkc/Cbij7XP1+pxw7JQ5e6miQpT3Fci0tkb94zzEo/9dv5FRKVjzN/7NLWr453v5ECm/JsD3RsnPHV5XwBmuar8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FlxFcygg; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-64b70c4a269so121799267b3.1
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488379; x=1723093179; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w7uRuuJLWNcIJX8XquVv1gmL4i5q3RaqambFEsShWAg=;
        b=FlxFcyggeevJ+sTlFpLPseM7g1KX1TG9XAAt2WTKvgwdcGd7MblmXZNqNb6YeFuwSJ
         2DHbeSjKhVDQgzRwayvuV0eVqXOQLIw7lkI0bYjbPyWj8AJaGJQt8i/W+WKiLu7HjWUQ
         M8OrwQwDd7QQ2kdNlEJhDi9iatOuzLQdkhbi/Po8bhAWE1+jGOtvo25hiIouw+yOMnVy
         eaA4LL6uGIab9jSggmKawineORuMK9x3XbndKvNhujJz14y8LBWA0r3as4o7UFEOd6hv
         NCLOkC3GlHM5s3t4OiJ8vCQAANG5QQH81vVgic9HtMlB12aCLqbcHP5gypSWMUdBbnjv
         St3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488379; x=1723093179;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w7uRuuJLWNcIJX8XquVv1gmL4i5q3RaqambFEsShWAg=;
        b=gpuV3JGVks/eY3UMT3DI0bHOdlq9AuVnvPYmij1v+7VOeN3S43Cszw0uWaymDrGYar
         JvC1pAZHm/GwvhsOlHKeRMDZvsWYr3xi6FfRq9eFtvPl5XpIrVZgsRlcyKs9qJkLRoiK
         XtBhY/OY7wyJBNu62YEUTczTc9QO24xp40MROnKbjDYZgGy14Lq8K0BI0U5ngoeXWvBP
         Trcr8j3pmw5myQ1/bLgQXL4VONMU1KB7BfMJs4o6/ipY/v3vFWOhz68JO1C+m1V9VW4g
         GE8XponUwbWPimx0cdXfEANwUopZ9EdYE6veYS8S8cKhUblay46FG7nfQADY687x8tnd
         ex3A==
X-Forwarded-Encrypted: i=1; AJvYcCXdYMP3N1eWJcnfdhFQGeCso/CE5HuZBkSQzsXUO1QgsL4RnV5aslsb138mH9OZaFfNbNJMR0T8gSL9f4KN8HhFTYOg
X-Gm-Message-State: AOJu0YxsVvYIiKaQ1bHogNgbW+9jx0uObrGAwsaBpGbqU/9f+Hf9dsLN
	xgUMtvS6PPAMgKxGeLg/MUNj4Dn0+RuBumxWqVDpJnFYKhCf6ucl51h+5weywMxB0Ddw/+qbmBZ
	iStykPA==
X-Google-Smtp-Source: AGHT+IHOUzg+IUPvsg1EhMzy5wRuwEGHHgmUm7eoY+LS5vO9f74Mpw915QluvDl83oVdZltRnH9hWIucwB8U
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:690c:ed2:b0:64b:5dc3:e4fe with SMTP id
 00721157ae682-6874abdc89cmr263197b3.1.1722488378564; Wed, 31 Jul 2024
 21:59:38 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:24 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-16-mizhang@google.com>
Subject: [RFC PATCH v3 15/58] perf/x86: Support switch_interrupt interface
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Kan Liang <kan.liang@linux.intel.com>

Implement switch_interrupt interface for x86 PMU, switch PMI to dedicated
KVM_GUEST_PMI_VECTOR at perf guest enter, and switch PMI back to
NMI at perf guest exit.

Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/events/core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 5bf78cd619bf..b17ef8b6c1a6 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2673,6 +2673,15 @@ static bool x86_pmu_filter(struct pmu *pmu, int cpu)
 	return ret;
 }
 
+static void x86_pmu_switch_interrupt(bool enter, u32 guest_lvtpc)
+{
+	if (enter)
+		apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
+			   (guest_lvtpc & APIC_LVT_MASKED));
+	else
+		apic_write(APIC_LVTPC, APIC_DM_NMI);
+}
+
 static struct pmu pmu = {
 	.pmu_enable		= x86_pmu_enable,
 	.pmu_disable		= x86_pmu_disable,
@@ -2702,6 +2711,8 @@ static struct pmu pmu = {
 	.aux_output_match	= x86_pmu_aux_output_match,
 
 	.filter			= x86_pmu_filter,
+
+	.switch_interrupt	= x86_pmu_switch_interrupt,
 };
 
 void arch_perf_update_userpage(struct perf_event *event,
-- 
2.46.0.rc1.232.g9752f9e123-goog



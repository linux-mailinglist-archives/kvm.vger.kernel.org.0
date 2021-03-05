Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8674732F5EE
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 23:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhCEWew (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 17:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhCEWev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 17:34:51 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2F9C06175F
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 14:34:50 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id p136so4089653ybc.21
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 14:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=sVxveq/IidC6Dcg/UZ54CWSyr4b2i4eGAQesD0hdFkc=;
        b=LRZoIR5yWsUk6WnZgHh7btUexV20WDm2A/1mUk7p+kzq+cOKMTlybMhdxBGQjG4iju
         ytP+lxSryqNRr5sap0oL6YuOcb2nbFYujBKFRDV+nulGq7eq1AJRQEY8Qx0Mqm9rpX4X
         WZ2fRI3IcOkbUvCCxJ0M4htnF94hCQwrMAH2pL/hSXW0EieVCSFC1gK1fqcaIsq7DSkL
         3Gh8MkUXVlTBLD1D6oZwFfhBQlKOh7iQcFiuwKhLFBPHm+NNQDKmGyGPWced1yoi/zIm
         wsSKmjlg3u77Lrqjo98iAo9/yZtAT8JBoZXMKnhUZSeX6zQDyxO7fUp1+uQs2xae1xws
         Qzuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=sVxveq/IidC6Dcg/UZ54CWSyr4b2i4eGAQesD0hdFkc=;
        b=LehggFU59EAReWxUFap1Z37FJvC/vcW77E0IGnsSuC4KhxFBj2w+OwClIUNq25AHym
         QQ7fKvU6xkAyjfapdrTmnE9+gDH3yv3FpmOkEjWeS4Tyh+gOYDW/M85H/O3Di58aRED+
         ZdmEQDtKxlxxxk2zVSB9ot8ugSRqmjt8FxVrFwqxVDjvXUJY0iPtJGhPDSblF3GH7ghO
         pCfaJu5aL/XuNxQYSuN/n2g7buypQ4F08sznQhU1Rt7461YTVNm58sqTz4m7M3WGDRQy
         jytViWegOjB7dvlzdgiQ7mOuee01qaJo9aexUD8gbfbRWIqB8o698Db52CWqMY5OdLXf
         +5aA==
X-Gm-Message-State: AOAM531ZBMVbULu7zjN2Zjv0G4qqOe8KU+22//rceIjGss+/W1NrXMSS
        tuTplRCY92XFwnQHr00xPjvejmOUCWg=
X-Google-Smtp-Source: ABdhPJw3RQaY2hVP255sL6Sod8e/1piSX8ViPZaVrYSHDVS58LYHZPjCYhIgFyZ3p5QjKmztlFjECkzZvt8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:ad5c:: with SMTP id l28mr15617451ybe.307.1614983689946;
 Fri, 05 Mar 2021 14:34:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 14:33:31 -0800
Message-Id: <20210305223331.4173565-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH] x86/perf: Fix guest_get_msrs static call if there is no PMU
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handle a NULL x86_pmu.guest_get_msrs at invocation instead of patching
in perf_guest_get_msrs_nop() during setup.  If there is no PMU, setup
bails before updating the static calls, leaving x86_pmu.guest_get_msrs
NULL and thus a complete nop.  Ultimately, this causes VMX abort on
VM-Exit due to KVM putting random garbage from the stack into the MSR
load list.

Fixes: abd562df94d1 ("x86/perf: Use static_call for x86_pmu.guest_get_msrs")
Cc: Like Xu <like.xu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/core.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 6ddeed3cd2ac..ff874461f14c 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -671,7 +671,11 @@ void x86_pmu_disable_all(void)
 
 struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
-	return static_call(x86_pmu_guest_get_msrs)(nr);
+	if (x86_pmu.guest_get_msrs)
+		return static_call(x86_pmu_guest_get_msrs)(nr);
+
+	*nr = 0;
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
 
@@ -1944,13 +1948,6 @@ static void _x86_pmu_read(struct perf_event *event)
 	x86_perf_event_update(event);
 }
 
-static inline struct perf_guest_switch_msr *
-perf_guest_get_msrs_nop(int *nr)
-{
-	*nr = 0;
-	return NULL;
-}
-
 static int __init init_hw_perf_events(void)
 {
 	struct x86_pmu_quirk *quirk;
@@ -2024,9 +2021,6 @@ static int __init init_hw_perf_events(void)
 	if (!x86_pmu.read)
 		x86_pmu.read = _x86_pmu_read;
 
-	if (!x86_pmu.guest_get_msrs)
-		x86_pmu.guest_get_msrs = perf_guest_get_msrs_nop;
-
 	x86_pmu_static_call_update();
 
 	/*
-- 
2.30.1.766.gb4fecdf3b7-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0057332CEB
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 18:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhCIRKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 12:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhCIRK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 12:10:27 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382B8C06175F
        for <kvm@vger.kernel.org>; Tue,  9 Mar 2021 09:10:27 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id p136so17960498ybc.21
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 09:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=DoRgiyLjNklM6rtntPUZIImM3ULIR10XzAP+GnWM3ms=;
        b=jFhPiOfq/F44oTP4XYhhXZGvFEC5azXnCZH7dJWpHw1NutprxD5MKr8aXhx4dZgsfp
         N8aNwN1P6Hh2br5dchmerKJXmsuj3c1YFzX7ftRqXdUngf1SrqNsYwTxKAYyFKtyz9Zb
         lHTE3jdBXC6amjPxtjswpxEpXAjvcdT8Ly3tpMhLMhBfS5q+GuPjkOjf+99KuN2HKi0q
         3FyQs0KHmAWGrj6BSngs6oc3g2AAlXJC7dS+uROeBAcRxrrg4epyk5nNsAnRtUaEk8AP
         FurA1Lbd1Yi5LjuwFE5i+465qyid0YtqpWB4FGswR9T69qa1Sjid82hs7vKawfOUOlS3
         Iaqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=DoRgiyLjNklM6rtntPUZIImM3ULIR10XzAP+GnWM3ms=;
        b=XhWrgybiH7U6NejOfzLM2kPLBwQaW0crsMQFdgZuOUCpyVOdr6NBJ+EbNyITrlJVdO
         2fZ6ZipsFqG3iPgQGN3O9zutQDMkE3O/GEoTYlE8ylseH4uetY0WQdntgbE8AnpHI32z
         l3/ObhWW8uWUw3LOP/XnWQLDby7Flp4Q0qTXSphCCugk+EKWGXBxJGgUb6Vxpl2185g6
         nCBdhBdTlEAdmb2sC//PmgvkT7exfWU24EpeaUWHESyCHCEtAG1M0G0aYro7zGz5Xaip
         pQ4ujGKS7u2g5EFx7+w9I8+7qGBx+T/VfttnPh1Ed3/3hj1TEh5oS3Uj3ncEUDgtq6Su
         Fdcw==
X-Gm-Message-State: AOAM532aEJ9Rki5fKnnJQyxFJd53FMQA2OdOk57eMwNrH1y84KlDJ1k1
        TN/J6B3xvQa46NfWzWCCNyXVZmM2RG0=
X-Google-Smtp-Source: ABdhPJyDJdVqKyWdxn0RWpoIwEArWFLUrCd9SVeGL7GSkVtsoUdPxf3VAk2FbtSI6aq3FCMSiY26zWBtKhU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8:847a:d8b5:e2cc])
 (user=seanjc job=sendgmr) by 2002:a25:bfc1:: with SMTP id q1mr39194688ybm.89.1615309826442;
 Tue, 09 Mar 2021 09:10:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Mar 2021 09:10:19 -0800
Message-Id: <20210309171019.1125243-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2] x86/perf: Use RET0 as default for guest_get_msrs to handle
 "no PMU" case
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu@linux.intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot+cce9ef2dd25246f815ee@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Initialize x86_pmu.guest_get_msrs to return 0/NULL to handle the "nop"
case.  Patching in perf_guest_get_msrs_nop() during setup does not work
if there is no PMU, as setup bails before updating the static calls,
leaving x86_pmu.guest_get_msrs NULL and thus a complete nop.  Ultimately,
this causes VMX abort on VM-Exit due to KVM putting random garbage from
the stack into the MSR load list.

Add a comment in KVM to note that nr_msrs is valid if and only if the
return value is non-NULL.

Fixes: abd562df94d1 ("x86/perf: Use static_call for x86_pmu.guest_get_msrs")
Cc: Like Xu <like.xu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: syzbot+cce9ef2dd25246f815ee@syzkaller.appspotmail.com
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v2:
 - Use __static_call_return0 to return NULL instead of manually checking
   the hook at invocation.  [Peter]
 - Rebase to tip/sched/core, commit 4117cebf1a9f ("psi: Optimize task
   switch inside shared cgroups").


 arch/x86/events/core.c | 16 +++++-----------
 arch/x86/kvm/vmx/vmx.c |  2 +-
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 6ddeed3cd2ac..7bb056151ecc 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -81,7 +81,11 @@ DEFINE_STATIC_CALL_NULL(x86_pmu_swap_task_ctx, *x86_pmu.swap_task_ctx);
 DEFINE_STATIC_CALL_NULL(x86_pmu_drain_pebs,   *x86_pmu.drain_pebs);
 DEFINE_STATIC_CALL_NULL(x86_pmu_pebs_aliases, *x86_pmu.pebs_aliases);
 
-DEFINE_STATIC_CALL_NULL(x86_pmu_guest_get_msrs,  *x86_pmu.guest_get_msrs);
+/*
+ * This one is magic, it will get called even when PMU init fails (because
+ * there is no PMU), in which case it should simply return NULL.
+ */
+DEFINE_STATIC_CALL_RET0(x86_pmu_guest_get_msrs, *x86_pmu.guest_get_msrs);
 
 u64 __read_mostly hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
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
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 50810d471462..32cf8287d4a7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6580,8 +6580,8 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	int i, nr_msrs;
 	struct perf_guest_switch_msr *msrs;
 
+	/* Note, nr_msrs may be garbage if perf_guest_get_msrs() returns NULL. */
 	msrs = perf_guest_get_msrs(&nr_msrs);
-
 	if (!msrs)
 		return;
 
-- 
2.30.1.766.gb4fecdf3b7-goog


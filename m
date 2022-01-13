Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410DD48D006
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 02:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiAMBPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 20:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiAMBPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 20:15:00 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F85DC061748
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 17:15:00 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id v8-20020a17090a778800b001b2e6d08cd1so4987864pjk.8
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 17:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=q9VW1SY3M4Wp4rDuFqdCRQzOdTgyhpZocVWqSUFUUpg=;
        b=UvzGJYhFh31ca7osy4R/W/PVnuB5JPSErZBFTnG8XxdXjNnOPSSrhRdVu8caSEQOAx
         RiBNg9l4BDr+AqHy0hWXVOeZ/fLrE7jpj1eTsbEozm5NoB0DYfmJY/K5DH/cVN0/e/UZ
         o4C9leN7RaYsFDW8yQpV9MT4DhlbF3udgi2I9tTWhWBpd4B2FgCV5Ik/KZTllLgCnekX
         GfxpeVipxeliZgOKp0Iie6ihGhgrIjEBCFPP3A+hGkVtF+T+qlPrw28OWPy2yXXP80e3
         x4WIljnF08B1pUtz/3HZ4UOp4QzlF8cE0a8CU3F50wVDWq4ccQZxE20uFHyuDOX0+MMe
         1rdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q9VW1SY3M4Wp4rDuFqdCRQzOdTgyhpZocVWqSUFUUpg=;
        b=kJRZLU+3C1Xva5zoy9ccHs32/W1XhNqysiv77Lvto/yw+xsGMUCDZPaiq2prx/7YVL
         6fUN48kBqeqZCbPET03/iUA2j/9AcHW0/v00bZlvaa+vp/d6sFcyO02+033vL0M7M6ro
         cT1jMhBYapyJDNvI697n0wEa63/vTRrasW8XoRGehhQvQ+b4m1DmbnAZuURRDBuJvw+1
         iWhvP/A7o0Sb2ZV/xm3UmPezJROY7/QtGoY/GDYzY7QOs+BvJvdI6/H/ky+5qve20ZAu
         fIgl9mQa4k2liScAnHuvKc8lW2i6bCjPM1OgkjYdL9/CFjlNOU4pp2CwcDSHio00kA2X
         F1VQ==
X-Gm-Message-State: AOAM530EY+YlCOwg8+OgbSStyw9XNGQRvDyHqTqDrOS2aLSAoepazT+9
        XStXjVCNf9eE1NOuvuIIeKY8DffclkTeY28xJgJCJoO7hmITAAoRcEXK/chY5IU8XT+QrayDNlg
        65tHIdhwqCY7yGZcea2aqwQPdytEYk+5IHgogXhQ3s3mZa5ClS6HO14EF8mrIVek=
X-Google-Smtp-Source: ABdhPJzhCOaSt9PmMGSgJyzAf0pcZCHJLLFKf2aQwWJPDe09wcEjysV42tFcFWwF8h1dHpgSnmP76reK2LLk1g==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90a:2a4e:: with SMTP id
 d14mr229262pjg.0.1642036499183; Wed, 12 Jan 2022 17:14:59 -0800 (PST)
Date:   Wed, 12 Jan 2022 17:14:48 -0800
In-Reply-To: <20220113011453.3892612-1-jmattson@google.com>
Message-Id: <20220113011453.3892612-2-jmattson@google.com>
Mime-Version: 1.0
References: <20220113011453.3892612-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH 1/6] KVM: x86/pmu: Use binary search to check filtered events
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PMU event filter may contain up to 300 events. Replace the linear
search in reprogram_gp_counter() with a binary search.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/pmu.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e632693a2266..2c98f3ee8df4 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -13,6 +13,8 @@
 #include <linux/types.h>
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
+#include <linux/bsearch.h>
+#include <linux/sort.h>
 #include <asm/perf_event.h>
 #include "x86.h"
 #include "cpuid.h"
@@ -172,12 +174,16 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 	return true;
 }
 
+static int cmp_u64(const void *a, const void *b)
+{
+	return *(__u64 *)a - *(__u64 *)b;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 {
 	unsigned config, type = PERF_TYPE_RAW;
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
-	int i;
 	bool allow_event = true;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
@@ -192,16 +198,13 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (filter) {
-		for (i = 0; i < filter->nevents; i++)
-			if (filter->events[i] ==
-			    (eventsel & AMD64_RAW_EVENT_MASK_NB))
-				break;
-		if (filter->action == KVM_PMU_EVENT_ALLOW &&
-		    i == filter->nevents)
-			allow_event = false;
-		if (filter->action == KVM_PMU_EVENT_DENY &&
-		    i < filter->nevents)
-			allow_event = false;
+		__u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
+
+		if (bsearch(&key, filter->events, filter->nevents,
+			    sizeof(__u64), cmp_u64))
+			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
+		else
+			allow_event = filter->action == KVM_PMU_EVENT_DENY;
 	}
 	if (!allow_event)
 		return;
@@ -576,6 +579,11 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	/* Ensure nevents can't be changed between the user copies. */
 	*filter = tmp;
 
+	/*
+	 * Sort the in-kernel list so that we can search it with bsearch.
+	 */
+	sort(&filter->events, filter->nevents, sizeof(__u64), cmp_u64, NULL);
+
 	mutex_lock(&kvm->lock);
 	filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
 				     mutex_is_locked(&kvm->lock));
-- 
2.34.1.575.g55b058a8bb-goog


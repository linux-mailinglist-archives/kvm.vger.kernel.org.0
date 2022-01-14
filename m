Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F126A48E215
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 02:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbiANBVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 20:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiANBVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 20:21:20 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCF5C061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:21:20 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id a22-20020a17090abe1600b001b39929b5fdso8020550pjs.0
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jeO9F3WI9S80Ci5R46EtVlwqG1Ul3dTIO9SoeO2/dfQ=;
        b=F3qc9DYeDzwjD+FOTdItblDqp8qElTBILBOSqzp8tW9oBSOFwISeIk3CUn7gTpBVDl
         ZYVt9DRMjjLNxiDMTQAO97EzVIGgcYC04PJHQktwYhtwd34PGP1Mu01+Z30hl5BKYrP1
         mXjxOG2MR3P8iWM/rwTWT+rvtPb4qHYGJHEO/ChHOVk/gJLZja0rr/wjXig7kI5u89Xv
         Y7rMKfCW5BRLPJ3IlyDAnJn6BiF6cWZiS4EFB7fgfjAAh2qRyg1KOBoG/xZOhu7dpiSE
         EbwyqiIDL0leB2x8w7xWzHsxcaWOkT6RKxDeObMCmuMiZKqkkq0Onzn2BHGK10MD51KP
         ZkNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jeO9F3WI9S80Ci5R46EtVlwqG1Ul3dTIO9SoeO2/dfQ=;
        b=B6KnoWmOtSQfU++hQRZsXcnA6M+FhGyH++J+RIl3bg2qAQrK0opj9nTBDAORvFyqu7
         NdfM9U8jbsboquEnzGnRATjsJNkuxx1gXdcPoOjaYMlPsurIZ8M4+ZDOsRnv6AT3F9zf
         hCVt9BbIqv1nrtd1spI4Lymsen84S/hmXVGxI6vWErehrbdC3ETxZ68NvYR2FRywQy0+
         X5SwmcWlaPNLEVJERvxUFDYUaUWPB+AarIeZthFNxdC9QxOGpocuQvzOrknQENhBPboF
         5ES3bZbHb+iE64RIERGYUURKh9A1RjNYvDS2jgkw4v4NUAQAFRqyaxQbd8qrXn1LRmnn
         iIgA==
X-Gm-Message-State: AOAM530bzzthHmk9lTIy6fGnpt+rfTbfOoS10G2XWols6vr/A6p+hjin
        MS/1OLv4r4g5wLvKPqOs1i/MDwKoa0cXZ3vknLNiyafEAMqcZTAN5ElPkHPDRNUCL8QledvO7y9
        rplOAc00W9uzK8v5iu+qmU6X4S+RqGuNYJKQQXNwDp9co4ZGXbYwQI612f4FHpeU=
X-Google-Smtp-Source: ABdhPJwKss8rf59F/MQUL9Zkyhbz61gfGlkv0Ig8tOIt714355SPLr19ltVTVV0MKQQj8zR/IsiO0L3F9Q+f1g==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90a:cc0d:: with SMTP id
 b13mr17413793pju.236.1642123279549; Thu, 13 Jan 2022 17:21:19 -0800 (PST)
Date:   Thu, 13 Jan 2022 17:21:04 -0800
In-Reply-To: <20220114012109.153448-1-jmattson@google.com>
Message-Id: <20220114012109.153448-2-jmattson@google.com>
Mime-Version: 1.0
References: <20220114012109.153448-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 1/6] KVM: x86/pmu: Use binary search to check filtered events
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        daviddunn@google.com, cloudliang@tencent.com
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
2.34.1.703.g22d0c6ccf7-goog


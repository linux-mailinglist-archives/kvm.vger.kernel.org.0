Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D7D48F4ED
	for <lists+kvm@lfdr.de>; Sat, 15 Jan 2022 06:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiAOFYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jan 2022 00:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiAOFYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jan 2022 00:24:44 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DBEC061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 21:24:44 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id r9-20020a6560c9000000b00343fa9529e5so3119628pgv.18
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 21:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jeO9F3WI9S80Ci5R46EtVlwqG1Ul3dTIO9SoeO2/dfQ=;
        b=ciP6AZ7D+dqxz8y2EneYJWr45reR4t9S8rM8w3MSrvabQihO2MibBGgpZ6xowIjPQx
         LOfxnjTxyeE63n4NyuFoKKf+Dnc382E1n8B8P7e2saACe9IPGdpHtRhIZWoSry1FXgu0
         EpX1YxGrm9IOhHb/CBNPlR7Xw8ejYQeN50eq9PCDd1aCcHQjPaqgsejSdhghwZCGw+l8
         PoxWc+h/VxtRBDk+qUUy73I2pEtEkm10ED4NFQXyYyOUCOZ0vJlLEHu2+dj1MOYTBZfh
         3QgPIW0ybFKwLIKCVOEVKxa/geztuJGaEOCV9yosCXBifZyXzQzt4Vmc1dLNpt24SWgW
         YV0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jeO9F3WI9S80Ci5R46EtVlwqG1Ul3dTIO9SoeO2/dfQ=;
        b=VITP+EEp3d8TpTnhigK2SaO5TbzGeu8nEyuJbbcnNT3yskPhmzQmilmLquE6TyTvAQ
         vNLfPg0jwjriDrDFC3v1yrcEnCtOu1PWqT14TL2lUamMR1wVcqlNwDJc3cXXsP0jXXuM
         9NAEtW2ahrNpU8/kHVB368MH/WJfV+2Cvifwc+Ofq+o7SsZeTc6msy0WCnTL4i9vLeQX
         dcGdIBVIf6r2A3OfoZzZBbIDKFXaclgj6/4nqLi6mM1XJQIBiYjORGo3fO/oDjArkH+A
         LzXHNt1TfaaGx0L7Ip1+daqPG/auxCMah3nddIF7lyB/hx6XJO7e8FB7SXkS/Bo8+IQB
         KFxw==
X-Gm-Message-State: AOAM531N+RkDxojCf2NetLIkYafc3PkBDDVCIMrecqnKQWwMN8PW8wJP
        1qU/gWLy9FahxmVuJf38KpkeB5648ktwzeXCCHwwCxYUCTCeOvKbhDcBMljwLZoKdR6/7IqWJr7
        Dq3KZtU5WxPM5jH4sMX3buRzazl6YOasZN6j12aVqKbOGtMRsyFbn8QrDDZKU6KQ=
X-Google-Smtp-Source: ABdhPJxMzi8y3wHi+EI3am51I6ZP9yHei2qscYod9QbesxjVbvetYasI8wpfSppbDGAUCycx2WpU+JTZkeUAKg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a63:8543:: with SMTP id
 u64mr8252942pgd.474.1642224283689; Fri, 14 Jan 2022 21:24:43 -0800 (PST)
Date:   Fri, 14 Jan 2022 21:24:26 -0800
In-Reply-To: <20220115052431.447232-1-jmattson@google.com>
Message-Id: <20220115052431.447232-2-jmattson@google.com>
Mime-Version: 1.0
References: <20220115052431.447232-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v3 1/6] KVM: x86/pmu: Use binary search to check filtered events
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


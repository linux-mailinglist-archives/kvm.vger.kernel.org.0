Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3456652475
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 17:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbiLTQMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 11:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiLTQMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 11:12:50 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0462219280
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:12:49 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id h2-20020a170902f54200b0018e56572a4eso9287906plf.9
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=49r8duawQcPgxiy2ktnD3Yp39ut/sdqqAgMXrTiLnXw=;
        b=ebZh3tUC4p2U/ddSGQcLHIAz2VgPwje9mmLHDd4KZBdVGgWLQeC+yNXtcKBgRMEgH/
         pjefHnbkgjVaUZKKeSp2gOKsmyr9aNio0UQ+NVql4MpV60GLCOD2KV6JfOO/3PVyGV9E
         Z60w+qXjN9ZfCMgfiFanzI9PZdpsXhIyhf9BnYGzSgYZxrDIFsZPlGVTnAlKlM4dzlC3
         fu/w/pOhSQcZMalqooyJnlaZm3QjhSLMRHx+WXsaAMHa5XUOrl2WUiXLZYqEOTgvkzXb
         u0sV9gtHp+FPv9/clP+mKooUHs6jvJrm/hjX0/sZOZtmOe05RQ8mOuGET/RJiZcnLjrW
         sYWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=49r8duawQcPgxiy2ktnD3Yp39ut/sdqqAgMXrTiLnXw=;
        b=DbcLk/Y93iJcv5PCyeoxkEEROsxYB51Rwt3WCqHXg1ZCE0vMPc/LDejm27hdiG7frc
         +RupoR9MRYUX75h3/sn/qXCU6NPpNAs031GgYz7aNcx0k+TH9LTb2r576mj1uS6eTVt4
         7FCuSdRZzjAWsYKyb8tjIZ9yO76d+nvHfyOxpE77XG6SLtboSqxB/0nJp1UBsKh6YcVH
         GSAiMWIxhXVHXJAtbGWpPE6NjdcDPhvyW36pUYdTpIKRA+byzCChih7b5FaOJ70FkVGO
         zlSAd5R3Ms7F3SnDQx/d05IWtwnuOisJCVGe7Ok5LXslNC8wuGBc4FL1zg+q2KMfBTcE
         l6gA==
X-Gm-Message-State: ANoB5pm/OCuchX0JHzNGJCGpvDDqDRfT1K6JMNExZWnB20dOGRrq+Y8J
        6tkBBExU98jQh4MwpnYQexlxDVvtBZKWTZlv8R/fFlTkXQpBbC/sErUZ7C3fT+st4HK99WVGcVG
        WcPaxuzjo6VCffUQYxEpR8LAohjOh6YXK0/AsQwGBVXQUPXTeDdRgMrDtcm8j7czj9Kmd
X-Google-Smtp-Source: AMrXdXvWVbg5NC254v2E/O1WBfAIJInE/Sm5/E2d85CTkHhg505/pjXd5SNVladQp5w2Dl3GsIWSO4TeEgUv7LBf
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a63:5219:0:b0:481:b6:374c with SMTP id
 g25-20020a635219000000b0048100b6374cmr1456664pgb.538.1671552768329; Tue, 20
 Dec 2022 08:12:48 -0800 (PST)
Date:   Tue, 20 Dec 2022 16:12:31 +0000
In-Reply-To: <20221220161236.555143-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221220161236.555143-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220161236.555143-3-aaronlewis@google.com>
Subject: [PATCH v8 2/7] kvm: x86/pmu: Remove impossible events from the pmu
 event filter
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If it's not possible for an event in the pmu event filter to match a
pmu event being programmed by the guest, it's pointless to have it in
the list.  Opt for a shorter list by removing those events.

Because this is established uAPI the pmu event filter can't outright
rejected these events as garbage and return an error.  Instead, play
nice and remove them from the list.

Also, opportunistically rewrite the comment when the filter is set to
clarify that it guards against *all* TOCTOU attacks on the verified
data.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/pmu.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 760a09ff65cd..51aac749cb5f 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -592,6 +592,21 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
 
+static void remove_impossible_events(struct kvm_pmu_event_filter *filter)
+{
+	int i, j;
+
+	for (i = 0, j = 0; i < filter->nevents; i++) {
+		if (filter->events[i] & ~(kvm_pmu_ops.EVENTSEL_EVENT |
+					  ARCH_PERFMON_EVENTSEL_UMASK))
+			continue;
+
+		filter->events[j++] = filter->events[i];
+	}
+
+	filter->nevents = j;
+}
+
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_pmu_event_filter tmp, *filter;
@@ -622,9 +637,11 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(filter, argp, size))
 		goto cleanup;
 
-	/* Ensure nevents can't be changed between the user copies. */
+	/* Restore the verified state to guard against TOCTOU attacks. */
 	*filter = tmp;
 
+	remove_impossible_events(filter);
+
 	/*
 	 * Sort the in-kernel list so that we can search it with bsearch.
 	 */
-- 
2.39.0.314.g84b9a713c41-goog


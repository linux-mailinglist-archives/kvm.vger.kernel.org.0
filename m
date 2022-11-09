Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF23B623451
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 21:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiKIUOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 15:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbiKIUOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 15:14:53 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3EB1DA67
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 12:14:52 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id pq17-20020a17090b3d9100b0020a4c65c3a9so8236883pjb.0
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 12:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qWhuPRw1tHQft4Uo+tbKyFMV7MLhXkDII18o5BFJnx4=;
        b=VkH40g3SsOnM6t3f4hReoTZD2lUw5gyYuXHUBK9ID1umoUoNzX9f9hAr2LYcU66Rcz
         OdCBPopJACkJ1freIcu/Ds5xFOyNuWp9VwaDVOdDzCMCyZucg2Sh/1cLcC6RpngQwPmv
         kA2zMpFIR2A6JN2/LzXwHXobkkq9JP7gn74rResDOdqqLGHs8SYPD/wsvQggmw3dAg/S
         8/8ttxr9uvzBzrlfQx+SOhS6y8rlk6DszuxAIAQO4LCEzzs2KXrKChqdi2v5avU6MdLE
         MZaUf24u1Xpti+86k4tXWtSBsr/jPM231TG1h+a2mKjTsEMRMnnhSeESD2eG3eZUd9zs
         9ClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qWhuPRw1tHQft4Uo+tbKyFMV7MLhXkDII18o5BFJnx4=;
        b=nyOWdeJoUSTCVw52I+59NhOyG4R+qeTjFWa9nHvdLt22WrSkX3RVvS13W7B9zBBxin
         jkhzhVqopHsaKRWsaZT11eedffykKNHJgcwMCJ2PY8ID05YplaXytYMR9jBQLf3XlmUq
         9JHhgA33y44GybZW/vommk5BXP8BMUYpU9bBzMCnBlquByMpsdpjqQwwXQitHYzXxTnE
         ffToIp4fIQrcPOcScvR8tpP0zxfi5avb9zE/ZkR0ULGcVcm35xh8uko8bpa5IxHNjKTA
         5cI81fw3suz5GiBCxiybQnL5GL7n3qMxiWsKMpov/GGUZAFGwnIHp5A/fy/D1L+jzG6S
         7Axg==
X-Gm-Message-State: ACrzQf0eYjT4teS86xzGzNJzHhHvOebt9KFaNgNglsC/5jITTmd1Ueoi
        FdYVjvHl1cCU7mgS1Ol0rSApfdM3S6ihQRI3Z1wp/qcJLA7epQs6ubln6VOBgUfSWBWU68J1xDt
        JqUy3/ywGitYV0yQmsIdmu2W8+Va55N8vMG+s/L7MuLVj/ktSklGUD0GFkwbAHLRh2sHE
X-Google-Smtp-Source: AMsMyM6qUv16QoXD2g22SWBezRuzJIeckhsTYyjOGkeRVFujUCkcnqUoZunP5uGnMjOmBnvZOfVt4kcYumWnEhsg
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:b89:b0:56d:2a21:a6b3 with SMTP
 id g9-20020a056a000b8900b0056d2a21a6b3mr57979228pfj.56.1668024891559; Wed, 09
 Nov 2022 12:14:51 -0800 (PST)
Date:   Wed,  9 Nov 2022 20:14:39 +0000
In-Reply-To: <20221109201444.3399736-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221109201444.3399736-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221109201444.3399736-3-aaronlewis@google.com>
Subject: [PATCH v7 2/7] kvm: x86/pmu: Remove impossible events from the pmu
 event filter
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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
index 5cf687196ce8..0a6ad955fc21 100644
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
2.38.1.431.g37b22c650d-goog


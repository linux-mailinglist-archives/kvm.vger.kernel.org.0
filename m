Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B6B5298FD
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 07:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbiEQFMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 01:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbiEQFMr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 01:12:47 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB4A275CB
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 22:12:45 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id oa7-20020a17090b1bc700b001df2567933eso830473pjb.4
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 22:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=R36IoqSA3bTnOPJSIj3DsiTgEbLUYpqJ32CuuasMrcg=;
        b=cXWdf8MLXcFdqeqPzf8n2yhaHkyDuIm5x2tVPerG2JjF3hGIT4i423dis+Z34+yH20
         mkeFUfqW9hR3SVXkbMoFVB6g7yE5w8DOcq9gJNzAtJJysElbMXrQcyFu8snTmSzgWAc6
         jbSQlhA5Z4uZCI93zdrc8Y/JEhticOYZZMyk9dgvE/yGPom9ZVB0cn5NdCRM5vbRD3BE
         ZO+2N6ysgwkpQZbMYCZHTtMlIZgygN1+VrlKeg01w0n9ZHcqgN63lcxmuu9bF1Ce1ZC9
         qUWSz/75AK6IobIVBsW3fNzf3zI8VbvmJI9gJdyinKnHsHDHxTuCfufS1FPwryxhcU5p
         SFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=R36IoqSA3bTnOPJSIj3DsiTgEbLUYpqJ32CuuasMrcg=;
        b=6d8n9iJgirqmSb/pKr6cqA+YK+6mgzlNgg5WkgWfDzSgFVuxxW+RCrxQwmW479qaR4
         sR9l3DyvkvVR/Jyz9ABmccV1WZQhBcaEf2ta/NynPnV1KcsC+L2blqkDY4vahtlGzns2
         bWN++03fsp44DcblIljgDQlTLzxQjNB9VtfFpRvc4j2WbS/RGRec5YE/cAll4/AWT6Ol
         8lGDz4clcPoJblhlXw/Hpp7BPQrwdd1fnl84zvw33WKgVPSJu/ENocXoND8KHWUW6DzO
         cqW3gj0rK/dpHWLcy7Wy92YwHKGL99lZXsuWS5WezBFMUF7dukKmw7h81zTZWa236xb3
         3E+w==
X-Gm-Message-State: AOAM530gj846ZknkttbXlMO6IFnDnT3GVrgosnnloS4G/J3KaubNmBSR
        31FJ1yWZWfibs1dn4+zH/tn4u75KqRyAq0X0iS0tc4fEQ5GuD7ZAfACl1m3K75NvpdqZUBs1gY6
        y4YHh18NYV/tJx+GBnQb89ge+hslDQzUvjnPMd13japEk2CH7NIvSVYwpNpP18uz0ECym
X-Google-Smtp-Source: ABdhPJy+O9W4KSwVw1b2UCMp98AuWm3r3ZRo/EOwHy8xgEmmsNY+Lbv/Jhqj+NQtDVj2+ziCdE9hovDYjn+6+T5r
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:f20d:0:b0:50d:6961:7b75 with SMTP
 id m13-20020a62f20d000000b0050d69617b75mr20604098pfh.19.1652764365223; Mon,
 16 May 2022 22:12:45 -0700 (PDT)
Date:   Tue, 17 May 2022 05:12:37 +0000
In-Reply-To: <20220517051238.2566934-1-aaronlewis@google.com>
Message-Id: <20220517051238.2566934-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220517051238.2566934-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 2/3] selftests: kvm/x86: Add the helper function create_pmu_event_filter
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper function that creates a pmu event filter given an event
list.  Currently, a pmu event filter can only be created with the same
hard coded event list.  Add a way to create one given a different event
list.

Also, rename make_pmu_event_filter to alloc_pmu_event_filter to clarify
it's purpose given the introduction of create_pmu_event_filter.

No functional changes intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c         | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 0d06ffa95d9d..30c1a5804210 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -208,7 +208,7 @@ static bool sanity_check_pmu(struct kvm_vm *vm)
 	return success;
 }
 
-static struct kvm_pmu_event_filter *make_pmu_event_filter(uint32_t nevents)
+static struct kvm_pmu_event_filter *alloc_pmu_event_filter(uint32_t nevents)
 {
 	struct kvm_pmu_event_filter *f;
 	int size = sizeof(*f) + nevents * sizeof(f->events[0]);
@@ -220,19 +220,29 @@ static struct kvm_pmu_event_filter *make_pmu_event_filter(uint32_t nevents)
 	return f;
 }
 
-static struct kvm_pmu_event_filter *event_filter(uint32_t action)
+
+static struct kvm_pmu_event_filter *
+create_pmu_event_filter(const uint64_t event_list[],
+			int nevents, uint32_t action)
 {
 	struct kvm_pmu_event_filter *f;
 	int i;
 
-	f = make_pmu_event_filter(ARRAY_SIZE(event_list));
+	f = alloc_pmu_event_filter(nevents);
 	f->action = action;
-	for (i = 0; i < ARRAY_SIZE(event_list); i++)
+	for (i = 0; i < nevents; i++)
 		f->events[i] = event_list[i];
 
 	return f;
 }
 
+static struct kvm_pmu_event_filter *event_filter(uint32_t action)
+{
+	return create_pmu_event_filter(event_list,
+				       ARRAY_SIZE(event_list),
+				       action);
+}
+
 /*
  * Remove the first occurrence of 'event' (if any) from the filter's
  * event list.
-- 
2.36.1.124.g0e6072fb45-goog


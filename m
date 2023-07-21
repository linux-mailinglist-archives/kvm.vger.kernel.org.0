Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3011B75D7B8
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 01:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjGUXAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 19:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjGUXAP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 19:00:15 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADAB3A96
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:00:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-570553a18deso25397357b3.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689980413; x=1690585213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8LvdkVE4wBNN35/JnHy3xytlSvey6H90m9oi4YFPLDo=;
        b=Fnz97LFPQsOkL23SslhD1HyDQozbiC0iTemf6PytzyfHmiWMkLWDmrnORTlidFilW6
         Q1dU/fSVtlP1Gqa8eMttlJq6eZUwnmB5Y8NlHnYcwA0mULuVDp3rO8XjF4yTNQYYy16C
         50kD5kw/uOe8RqgFAeYEp5qfy6nV2vcHihVXs2YYbf+jDO6HwW6iEg52Cr+KgxC1Auq0
         Bu5iPbYSRPVZ6QRFMTF+mDaRK22Hur/lxqKqp4l7H/hFdfBJap8KzbiE0NWh51EIAjEp
         k1nM1hJEfkkIvsIdMdrjOyUJR/VF530ZcddIe8/vYZfyUjTKijFdsb+gSNuCX5IraY4t
         XORw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689980413; x=1690585213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8LvdkVE4wBNN35/JnHy3xytlSvey6H90m9oi4YFPLDo=;
        b=NTq+aqJykGiJCcSsNjKff84gyIlQkPr9BLnZtvBtWE0fqEcCc3I0pNyxBmviKKcgXm
         uzGfELcI1AL3fK+mpTkX5HVWifiyI3KbNFycfr1XoBxa4le7B6rvM44KcGj3sCKlBA2L
         CGwe7+JmslUxEVGBfLTbeiI2ehwM8LTbkFRPRIj1YIt1yHA/W9EruCOw7MpVBQzacQqJ
         liG28QhB93hZ9smIK8RsCm4yRgQElmZwyNZmqIX4ur2+oO95Q9p+JmAWnaJp72g5/0/y
         brBo45AYZRQFWwdq6coIy/wpUUF/bGuum4W7NpOGlxkoS2jYv/BShVGQZ19YM9Ptok0X
         5mYQ==
X-Gm-Message-State: ABy/qLbKSLVQgc9QokcMNyEBU4ghxjNJJQpOqjptg9pqaM89DXDQSibI
        aCJhQv487HeVmoD7+ZO6KoZ0KoJqtsE=
X-Google-Smtp-Source: APBJJlE0+AmIQUxDszBHL9JMrn1F2wLbO9Yj1xoL8dFyCqS6LOUsHHVNIxJsyAolCWQqdaUwXps0Le+Ibf8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:707:b0:580:841e:a06a with SMTP id
 bs7-20020a05690c070700b00580841ea06amr13275ywb.2.1689980413619; Fri, 21 Jul
 2023 16:00:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 15:59:59 -0700
In-Reply-To: <20230721230006.2337941-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721230006.2337941-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721230006.2337941-3-seanjc@google.com>
Subject: [PATCH v2 2/9] KVM: x86/mmu: Delete the "dbg" module param
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delete KVM's "dbg" module param now that its usage in KVM is gone (it
used to guard pgprintk() and rmap_printk()).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 5 -----
 arch/x86/kvm/mmu/mmu_internal.h | 2 --
 2 files changed, 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8e36e07719bf..b16092d71d3f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -115,11 +115,6 @@ static int max_huge_page_level __read_mostly;
 static int tdp_root_level __read_mostly;
 static int max_tdp_level __read_mostly;
 
-#ifdef MMU_DEBUG
-bool dbg = 0;
-module_param(dbg, bool, 0644);
-#endif
-
 #define PTE_PREFETCH_NUM		8
 
 #include <trace/events/kvm.h>
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 9c9dd9340c63..9ea80e4d463c 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -9,8 +9,6 @@
 #undef MMU_DEBUG
 
 #ifdef MMU_DEBUG
-extern bool dbg;
-
 #define MMU_WARN_ON(x) WARN_ON(x)
 #else
 #define MMU_WARN_ON(x) do { } while (0)
-- 
2.41.0.487.g6d72f3e995-goog


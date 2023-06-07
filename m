Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D176725158
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 03:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240414AbjFGBCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 21:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240386AbjFGBCO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 21:02:14 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEB710EA
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 18:02:13 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-51f7638a56fso6218058a12.3
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 18:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686099733; x=1688691733;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GdxTpX9Spmnpfwqe75ekBKH+Ldw87KCa0RRFcAselmo=;
        b=f3El6h4m5J8UNxRj4A3Eoe7PFYBiRVvCRS7XcW3t5c08Z3ub3hWjb5iqnmgk+kAqJ6
         OCB9HveaWmu7txC0/3bapAUlHQAV7dnXwgqCC6ZTEpyPZEgS9yryjImgtqwNOYzHb++Q
         2eX5upC9ARA+s2JKqAvyakW6S48rXgVswrhpWugfB3KHwjchSpZ4e+oKV3L1WDhfuEpn
         F9W82WDmGKAZg7LF1qNA2aH2i59k7UmicNdZATpGNgij8p6+t9m65K+wsLWJyveegdYP
         IlrmJGwMoGVPukj6ZMn9+cml7v6SBNm+ZnJ31oEyJMCF2dZHJCncUB4CpFo7Skez72MP
         MrQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686099733; x=1688691733;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GdxTpX9Spmnpfwqe75ekBKH+Ldw87KCa0RRFcAselmo=;
        b=j4VGcriBTnxLRcV0uLJhozg0cDM554T2QB9WUhFUlrYNY1NDqBjgnHLFNBGlvi6Iuy
         cce7Oj/wDU2Nj9EA1CLC0jZO5srskKEyfe/UIKPGj92DnQoCwW5XwIIIaCRJ2FkCHcet
         KKp03Rce+w2bEQGUPCwvvgj3wAPO4OKBXRp0R+AdOGXuBPzbvtjCSLLrsA+ZKSW/IZiZ
         gj23Gk8+FMY2B1APiZDx1D9mVzRkkEoFd+cQKj806dXiGn0XArrB8QirmY0WMxKWxlJz
         Yd2541fhrcr408eFBO+bJ3eBnqwBSyOi/WxrUUgEqMcJgluoeJHUR5/UhuksNz+uicKu
         QhTA==
X-Gm-Message-State: AC+VfDyaOhDnMnXyUzwQ+5uKy6mo8Uo2hzjysgyVz+mFF4tMZ0snNJEY
        xJbXeEhzlYFMsmq3vRj8+gq43KPIdOw=
X-Google-Smtp-Source: ACHHUZ4oC1kUgVxWFiIo/95OlQu9U0TYB1bjBRCbryG3OehS1nQ1msVcE1xkdm7mCLPE3mpSxP/Qos6YgK8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:68c6:0:b0:528:c2cd:9b42 with SMTP id
 k6-20020a6568c6000000b00528c2cd9b42mr761868pgt.3.1686099732871; Tue, 06 Jun
 2023 18:02:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Jun 2023 18:02:04 -0700
In-Reply-To: <20230607010206.1425277-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607010206.1425277-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607010206.1425277-3-seanjc@google.com>
Subject: [PATCH 2/4] KVM: x86/pmu: Simplify intel_hw_event_available()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Walk only the "real", i.e. non-pseudo, architectural events when checking
if a hardware event is available, i.e. isn't disabled by guest CPUID.
Skipping pseudo-arch events in the loop body is unnecessarily convoluted,
especially now that KVM has enums that delineate between real and pseudo
events.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 0050d71c9c01..f281e634af3c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -122,17 +122,16 @@ static bool intel_hw_event_available(struct kvm_pmc *pmc)
 
 	BUILD_BUG_ON(ARRAY_SIZE(intel_arch_events) != NR_INTEL_ARCH_EVENTS);
 
-	for (i = 0; i < NR_INTEL_ARCH_EVENTS; i++) {
+	/*
+	 * Disallow events reported as unavailable in guest CPUID.  Note, this
+	 * doesn't apply to pseudo-architectural events.
+	 */
+	for (i = 0; i < NR_REAL_INTEL_ARCH_EVENTS; i++) {
 		if (intel_arch_events[i].eventsel != event_select ||
 		    intel_arch_events[i].unit_mask != unit_mask)
 			continue;
 
-		/* disable event that reported as not present by cpuid */
-		if ((i < PSEUDO_ARCH_REFERENCE_CYCLES) &&
-		    !(pmu->available_event_types & (1 << i)))
-			return false;
-
-		break;
+		return pmu->available_event_types & BIT(i);
 	}
 
 	return true;
-- 
2.41.0.162.gfafddb0af9-goog


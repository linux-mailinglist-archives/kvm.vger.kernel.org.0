Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F27767AB3
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237455AbjG2BS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237522AbjG2BRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:17:50 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FFF4EF3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d1ebc896bd7so2518845276.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593414; x=1691198214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Td1GH9IlHvpXHIHUDo3By6hiD1XsWn1I7aZZNe6DB5w=;
        b=4Af6FshVFsrgrFsPJc4IthqUvttt1ICUmFLNLWtLZE5xK3kzxiG/xG13Xua1xOPAG/
         qsi+BpFoCzlp0VqIdOlZQTdc+VAwJpYpajeNm0aL+x2sNusxHJ/vlU7DAgRyh5rmbLaZ
         WiAqQcKmtSK4GPhYMEy5RsN9vB29UAhXPElyy3PHh1U4dOm6r1eZgY8xnD3/RvIcv/bn
         lxqE7kbzbGxs9WqU0pdeayYujblF5h2ScPpYWgTeS5EU3IHTWmT+NIX0KnUD0CHtrTJV
         kLsfo4Pxhv3CCog7OEi23/z3x7p5Ec3EYwTHO7qsM2gZaKo6owxQ+L33ziSVxQGlz6qK
         zKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593414; x=1691198214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Td1GH9IlHvpXHIHUDo3By6hiD1XsWn1I7aZZNe6DB5w=;
        b=BSbTh6DUdRAy5/YpZvR+IEIwC3kXZx6CqwgxHKKkwAdUVt1++tkadzrWHXA2S/GLft
         moMXFIAGo+aFOEbK8qaAwWlHn1OjI/gU41CfdTtEfJR+uvYk4WYsk6Wn1BUKKSn2tCPe
         tXOktE8HoonKCGvKtAy7PxoNDBQ4vlqGRv5AZo3KJ6NoaP0MXP43bYyEe2G9M1V8uhN4
         rtkUEA3q5Hl+7MgUiVWzVDWjCZK5YXN2MEb6+kwj8wWuPqO2sPOzbL0BhEHvkCSryDLQ
         PuYQtz/aKiQGIO8bku7t8WrimMwkTc8Gzarl76by1GfK84Gl8KXXvLdEP3Gh4jdBJI//
         8UGg==
X-Gm-Message-State: ABy/qLYIymZABk5hPDb28uj6WNGoz4MBwjBpR29+am2TLC5kMzVpJTrG
        bCrPNn/6o6jV1VrxLRwkvAfIXhH9ZAE=
X-Google-Smtp-Source: APBJJlFP2d5RvtjZ9pjPB+7KOrkaTgp7g+JNH10ugdM7iZq8xOgChgQ4IeHH9mcrUrSucyrbppH+IZqcT8s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:69c7:0:b0:d07:f1ed:521a with SMTP id
 e190-20020a2569c7000000b00d07f1ed521amr17972ybc.4.1690593414398; Fri, 28 Jul
 2023 18:16:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:16:08 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-22-seanjc@google.com>
Subject: [PATCH v2 21/21] KVM: x86: Disallow guest CPUID lookups when IRQs are disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
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

Now that KVM has a framework for caching guest CPUID feature flags, add
a "rule" that IRQs must be enabled when doing guest CPUID lookups, and
enforce the rule via a lockdep assertion.  CPUID lookups are slow, and
within KVM, IRQs are only ever disabled in hot paths, e.g. the core run
loop, fast page fault handling, etc.  I.e. querying guest CPUID with IRQs
disabled, especially in the run loop, should be avoided.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f74d6c404551..4b14bd9c5637 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kvm_host.h>
+#include "linux/lockdep.h"
 #include <linux/export.h>
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
@@ -84,6 +85,18 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	struct kvm_cpuid_entry2 *e;
 	int i;
 
+	/*
+	 * KVM has a semi-arbitrary rule that querying the guest's CPUID model
+	 * with IRQs disabled is disallowed.  The CPUID model can legitimately
+	 * have over one hundred entries, i.e. the lookup is slow, and IRQs are
+	 * typically disabled in KVM only when KVM is in a performance critical
+	 * path, e.g. the core VM-Enter/VM-Exit run loop.  Nothing will break
+	 * if this rule is violated, this assertion is purely to flag potential
+	 * performance issues.  If this fires, consider moving the lookup out
+	 * of the hotpath, e.g. by caching information during CPUID updates.
+	 */
+	lockdep_assert_irqs_enabled();
+
 	for (i = 0; i < nent; i++) {
 		e = &entries[i];
 
-- 
2.41.0.487.g6d72f3e995-goog


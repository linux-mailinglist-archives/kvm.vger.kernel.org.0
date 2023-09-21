Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0C57AA552
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 00:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbjIUW4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 18:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjIUWzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 18:55:45 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9321F6E44D
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:40 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59bdac026f7so20896907b3.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695328420; x=1695933220; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MoKhLmBudHFsqVub0iZnr0qo3mrdYvg37SqAKaFM83k=;
        b=wacm37VVEAoOBFG9ghqEMvSqQOsqj2uX+efwm1Kt9mu4xfpI4eBbzRd28dN6+kwnbx
         gbjMsrKrA/az3kHsFFv75Pnpvq8QZeVN+1hPcWnI8aftMXlfGumWnzs8egptFzpeL6xd
         6SkuW6gB4bTQJ0laoVIAFd/0TWq5uT4ohszUAQ63ON2mjLUp222i2rIb9wA6X7sqOfwx
         YPhXb5y9pnZ5l21FdyrmLMZcX6kQAa0zo5Hesdi2jATItiQQG9JTUbTm3Uc0RB7DgQIb
         WUdsxwgaUGmn+EcCIjRcL6WkWkWN77/Nz3uOuYld23IMCYG+6Pr6WO7aNbbQ8RcYycsm
         hxAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695328420; x=1695933220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MoKhLmBudHFsqVub0iZnr0qo3mrdYvg37SqAKaFM83k=;
        b=ciJyih9G7lb3G17W8IoyeJVe5lxt1IOuSbBI//fxnbjocSMCnx13PiaRCvaQdjI/bG
         xo6+mAf6Lh+LRVEVw3f8kb5R7sqO1bPiMVWYeJm9PChu961k2u6Ml46454vCT/QtAPXA
         ZLN2+tS40olLx21dE212dIako83RVqjYvE+Vwya3faZcBbva6yxN/Nbwm0Ro2KjvKxj8
         2g8u1YycVvx2O/+WkR0e7SwoCxNhuMZM1cK1u0nM43PUKXsKVU5upi/1Hq9KeaQTUPWM
         qQ4X4VCTURV0WUiy1RKnT/JjZH63hQjkNmHGcIgZKbYGfDINP8YwBVWscFwfImRWUhFN
         1f/Q==
X-Gm-Message-State: AOJu0YxfMqmXz6aUxg7/06hQohUVxbe5ZWcug66p2zdJChBE/C5DM8aV
        jLC8b6IbAK4EIEXZdSHvtLkKslZE2DA=
X-Google-Smtp-Source: AGHT+IEYG8/hrFY0O/v1dhWCGuKqtsz5qSqkYbmrQr34bAdR9bPEuoVobXgQyPT7lOV22JgARaBCkSNMs4U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b726:0:b0:59b:ccba:124f with SMTP id
 v38-20020a81b726000000b0059bccba124fmr93086ywh.9.1695328419949; Thu, 21 Sep
 2023 13:33:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Sep 2023 13:33:20 -0700
In-Reply-To: <20230921203331.3746712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230921203331.3746712-4-seanjc@google.com>
Subject: [PATCH 03/13] KVM: WARN if *any* MMU invalidation sequence doesn't
 add a range
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tweak the assertion in kvm_mmu_invalidate_end() to unconditionally require
a range to be added between start() and end().  Asserting if and only if
kvm->mmu_invalidate_in_progress is non-zero makes the assertion all but
useless as it would fire only when there are multiple invalidations in
flight, which is not common and would also get a false negative if one or
more sequences, but not all, added a range.

Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
Fixes: 145725d1542a ("KVM: Use gfn instead of hva for mmu_notifier_retry")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 30708e460568..54480655bcce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -873,11 +873,10 @@ void kvm_mmu_invalidate_end(struct kvm *kvm)
 	KVM_BUG_ON(kvm->mmu_invalidate_in_progress < 0, kvm);
 
 	/*
-	 * Assert that at least one range must be added between start() and
-	 * end().  Not adding a range isn't fatal, but it is a KVM bug.
+	 * Assert that at least one range was added between start() and end().
+	 * Not adding a range isn't fatal, but it is a KVM bug.
 	 */
-	WARN_ON_ONCE(kvm->mmu_invalidate_in_progress &&
-		     kvm->mmu_invalidate_range_start == INVALID_GPA);
+	WARN_ON_ONCE(kvm->mmu_invalidate_range_start == INVALID_GPA);
 }
 
 static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
-- 
2.42.0.515.g380fc7ccd1-goog


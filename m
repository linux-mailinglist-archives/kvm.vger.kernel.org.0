Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC647AA300
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjIUVpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjIUVp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:45:28 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97ED5FEF
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:42 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59c0dd156e5so20149087b3.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695328422; x=1695933222; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GXnfKvHXTg+GXCkfuzsuluimpzEK7TKl935+HXdmmVk=;
        b=LbW7OvmzGYx86t/DB1TIa4aie8OrmSOTIMtNm/JXLP6Hddgey1cj0Cdt8bNQpoziRB
         RL5lL7FoxOClWdH1c3CxdW6z2mh6lLSlLONUPzMcqlpjQRgivq8mBkQQPScxlABXbNTZ
         0slD7P+iOjHIPOutQ1BeA26IYGi7ufkcODf4uA1xKARXC0/tneDwOmjmFb44mD7R8MFk
         Na7m2dTmOCp7qZDDihuHQ63wAUZoyObMFkVwGRVNuBV1CJrDKPFZuhoPgnxHLrxfgmDM
         +imtx0lw7GWFXxbScIR5pllKVWHQGpzrWfKYi538KiG8TwBlmfnsZl+mEHIldlQwH9CT
         8zeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695328422; x=1695933222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GXnfKvHXTg+GXCkfuzsuluimpzEK7TKl935+HXdmmVk=;
        b=l/WEV7q4QsWDC9+dTBdh/2Sq/Xdtoru3BGuJ6o9YGndm0KN98NxhVQu8LxnfX05jq6
         qu0RWjSqY5DbIu11bEmRnCIL07IPWaQZFO6EbSO9QlGOeD8eyRVuReebpmcKjf+umjyZ
         LegbG9Ru3/Eq82FUmi25+h9FjvTUa4d7GrRfxhgkrJkDkTpi/PHfTjJodZgOgTnQCs1h
         nuehPWdAV70jdz6z8+T81FCNawXX30AFqFK0WdZC4XleDrGjGPvEAkrG6Pdsco3CdNIN
         Lj8KCYRis9ttBtkD3QUvuedKtUkWFRihfNOqWzl2ocWwW1IzsN9xFKSzeZjFybvUnRVg
         0gYg==
X-Gm-Message-State: AOJu0YxJkfBhMUtH0o1KWMggRo5aM8Ye0fwHBagqZ4QqSjOU7AIwgE3G
        g9zNn9jlsLNDBwjqXEqpBezXxods90s=
X-Google-Smtp-Source: AGHT+IEi/fpx5qwnyQazg0USr1DHbY5reNhmjREs+J+LHxISH07TrHV0vwV7RrUiPSmPNiZfUH6GP2uptjE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:77d8:0:b0:d81:bb31:d2fa with SMTP id
 s207-20020a2577d8000000b00d81bb31d2famr91450ybc.3.1695328421812; Thu, 21 Sep
 2023 13:33:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Sep 2023 13:33:21 -0700
In-Reply-To: <20230921203331.3746712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230921203331.3746712-5-seanjc@google.com>
Subject: [PATCH 04/13] KVM: WARN if there are danging MMU invalidations at VM destruction
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

Add an assertion that there are no in-progress MMU invalidations when a
VM is being destroyed, with the exception of the scenario where KVM
unregisters its MMU notifier between an .invalidate_range_start() call and
the corresponding .invalidate_range_end().

KVM can't detect unpaired calls from the mmu_notifier due to the above
exception waiver, but the assertion can detect KVM bugs, e.g. such as the
bug that *almost* escaped initial guest_memfd development.

Link: https://lore.kernel.org/all/e397d30c-c6af-e68f-d18e-b4e3739c5389@linux.intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 54480655bcce..277afeedd670 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1381,9 +1381,16 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	 * No threads can be waiting in kvm_swap_active_memslots() as the
 	 * last reference on KVM has been dropped, but freeing
 	 * memslots would deadlock without this manual intervention.
+	 *
+	 * If the count isn't unbalanced, i.e. KVM did NOT unregister between
+	 * a start() and end(), then there shouldn't be any in-progress
+	 * invalidations.
 	 */
 	WARN_ON(rcuwait_active(&kvm->mn_memslots_update_rcuwait));
-	kvm->mn_active_invalidate_count = 0;
+	if (kvm->mn_active_invalidate_count)
+		kvm->mn_active_invalidate_count = 0;
+	else
+		WARN_ON(kvm->mmu_invalidate_in_progress);
 #else
 	kvm_flush_shadow_all(kvm);
 #endif
-- 
2.42.0.515.g380fc7ccd1-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023A05F5D53
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 01:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiJEXwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 19:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJEXwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 19:52:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A7B754B4
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 16:52:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p5-20020a25bd45000000b006beafa0d110so339879ybm.1
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RODDzKFk74UsrDJsxsQ30C3qJ+rwL/o4YC7pgWAk06Y=;
        b=eLXwgGYkY971uZ9PXYhgBb67qVd5MT858p3B+rkssN76HT/x9xDF7O2RtpBzJbOx7H
         enowh7jZkjEHOT6gpBjrYm2fmb01VMeX9Woj2yoZFEekB9bomGP548lJKM7bSqhRuxR7
         D1lkqLhgwmyX+qvgX1UyBjXU8CX47fk03yOnalvPXDOz/0A9TNThqYZAqv/eJlyPo1ON
         4td1LIbDEvzn9GVXRIQRZoSi9vm3wMBsOIM9pDHp4BaD8JQAduQjuzpDqBtY30wio4ci
         CU6tgGLxuvFdEfvrXxyL0XkJ3nwd5phj+aqmZyg9U7h+C9OeKTe1JsMuzT6XfswFMg25
         aMtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RODDzKFk74UsrDJsxsQ30C3qJ+rwL/o4YC7pgWAk06Y=;
        b=41yQNXzCM8OPtp65g5SEXL+dQobmf3qx8bJULiZPyp7aPktmHWskQmmO8sZidzUH6y
         VmXCvexMiJlgAc1zcjI5CAoT4PDk2CuC/6Zs32YlUjLhNwaZnWD0z6IzpJ7a1Z3SNFRU
         4YvJlnMpnUIVPLVupxlCwNmiB3BJ1+bi5X7favQ+8fdqSnuRd2eymQzbN+qp9sbIFnb4
         XIIttI/IB44uuY3jd61URHexk0+Y7DgVauVv4QT/lhCCEWXnCy9CtK0/4iVWy04Xq6ch
         ERW2FApyzQgQOn54QSZFmzdNOT4PWD9nfCmpZhupWx3a1o1Nf5NdCTN2gPOYUxGWMqk8
         o2CA==
X-Gm-Message-State: ACrzQf2YpKMM0PnY3W1ED82XwAb/cvsr1EalDqBAP8dQKkmc4ZTyygKp
        lmTfG8WrHMYGSNql5sSjSctGu/xKKc8=
X-Google-Smtp-Source: AMsMyM5akGay8XEoOj3C9IELvmekpkKPgqFtG2VgGjPfLEZ8prAT+kJNU6U1NdJWUNP09k2f+npdHU3kUQA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:583:0:b0:68a:6dc1:dddc with SMTP id
 l3-20020a5b0583000000b0068a6dc1dddcmr2453967ybp.189.1665013936269; Wed, 05
 Oct 2022 16:52:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Oct 2022 23:52:04 +0000
In-Reply-To: <20221005235212.57836-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221005235212.57836-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221005235212.57836-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 1/9] nVMX: Add "nop" after setting EFLAGS.TF
 to guarantee single-step #DB
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Manali Shukla <manali.shukla@amd.com>
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

Add a "nop" after enabling single-stepping in vmx_l2_db_test() to ensure
a #DB is generated in the scope of the function even if the helper is
inlined.  Enabling single-step #DBs have a one-instruction delay, e.g. if
the function were inlined and the caller generated a "terminal" VM-Exit
immediately after invoking the helper, then no #DB would be generated.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index aa2ecbb..3e3d699 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10745,6 +10745,7 @@ static void vmx_l2_bp_test(void)
 static void vmx_l2_db_test(void)
 {
 	write_rflags(read_rflags() | X86_EFLAGS_TF);
+	asm volatile("nop");
 }
 
 static uint64_t usermode_callback(void)
-- 
2.38.0.rc1.362.ged0d419d3c-goog


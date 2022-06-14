Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A490854BB92
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357616AbiFNULE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357364AbiFNUKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:10:36 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1F711A30
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:34 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id j4-20020a170902da8400b00168b0b2341dso5354475plx.5
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GcnQGtIgWgA8fnCOJZ2NC0z3fNMByJKLtilK+3LRet8=;
        b=UUtRfLBdt6WVEsGg8pTCK6naNVhi6UmL2mpQWCl4tgb+SWxp688YfD43lVCKfntZtp
         ulzBd3n3DXfhY32sqPSq40Uo8lgJ2qnSVRsBRN/OswminfCDsUmo8WOzC3xnw6s2nQ/q
         0dDOIAinhyxAs6/Lq9gY5rAhptG1Mz8jcWsyPLBMz2EQb66gZlz3QFYnaLHAcEYoXwS7
         Dnwv7Qe7yRYZ2lVH9FTCVwXKXYpHIWub63SuXvefqgHcw785Ez7TKcdYSM5xIy7cr4L5
         8NMLQ2m+hy+43ld5vGxlvk5tWwo9B9gGRE8po6sm6g6mvdSSQHfExeqUkQE06XrYY96M
         5Msg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GcnQGtIgWgA8fnCOJZ2NC0z3fNMByJKLtilK+3LRet8=;
        b=ha57LJM6tfPpc83XgZ4N1HwNfYwoOEUNQIy/QnvOhF8a7LUfOqT0UJfUP3Gd/aSssW
         BuqNOo73sj4YmyN3QWsTt3/Iat2BFnLn/LMN7mEzt7YTQdP5V0/yElcYKxsC/SvFFEiC
         jfCVjigiZiDCIZeftC+pe4zIqrbx8SgfGCW5gjXYfDJsM+b8/O1GqqT+wL9DZh71Zj/W
         yw/2q3Bdp/Ren2KL5VWX/Ct6o2waqiGzizUG5qSPz0YouODTM2ASP+UKqv9LEaa+Ltw/
         kHGT4ylmcBh8MDFEqXZ8akkp1HwH6JG7h/5RG6x2g5JzqUJdo64qhZAxoMnOe0VhPJTe
         J+zg==
X-Gm-Message-State: AJIora8gcRXB9NRpwt1b+Zf5mqid+j5vc+C//0QLDnc5gbFyJTc/QywR
        x+jQTxiOtsz/cOib72cgbEvsw2aZGqI=
X-Google-Smtp-Source: AGRyM1tbmRuWodF0xUlWN6zVml/CAWJNtDGr7rzGXaVv3e5/LmimEj98XorvzTGzIlQDPkTO0GS2+EyRaz4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1d02:b0:1e6:961d:d56f with SMTP id
 on2-20020a17090b1d0200b001e6961dd56fmr6287808pjb.225.1655237302377; Tue, 14
 Jun 2022 13:08:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:07:04 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-40-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 39/42] KVM: selftests: Skip AMX test if ARCH_REQ_XCOMP_GUEST_PERM
 isn't supported
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Skip the AMX test instead of silently returning if the host kernel
doesn't support ARCH_REQ_XCOMP_GUEST_PERM.  KVM didn't support XFD until
v5.17, so it's extremely unlikely allowing the test to run on a pre-v5.15
kernel is the right thing to do.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index c7fe584c71ed..ee346a280482 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -601,14 +601,7 @@ void vm_xsave_req_perm(int bit)
 
 	TEST_REQUIRE(bitmask & (1ULL << bit));
 
-	rc = syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM, bit);
-
-	/*
-	 * The older kernel version(<5.15) can't support
-	 * ARCH_REQ_XCOMP_GUEST_PERM and directly return.
-	 */
-	if (rc)
-		return;
+	TEST_REQUIRE(!syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM, bit));
 
 	rc = syscall(SYS_arch_prctl, ARCH_GET_XCOMP_GUEST_PERM, &bitmask);
 	TEST_ASSERT(rc == 0, "prctl(ARCH_GET_XCOMP_GUEST_PERM) error: %ld", rc);
-- 
2.36.1.476.g0c4daa206d-goog


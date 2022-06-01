Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A86953AB0D
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 18:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355748AbiFAQaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 12:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243359AbiFAQaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 12:30:20 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842D1941B5
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 09:30:19 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id d12-20020a17090a628c00b001dcd2efca39so1279776pjj.2
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 09:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Yx4JXZUxRwe0yWzq6ZJhBAWxkFR15xP4rqVJcbYeyXI=;
        b=D3Po/n4ramBUo6knCT96tSu8BEyrVgKG42RurWB79jAgWeUeAx3499SiaxqI/rXDyX
         AHHoMSx6z970HFX/sj5IXvGdw1eQKGLgS0ycEDVvCTWHa5QbXcalMFI/BTkTrnfZlJnP
         QjVmLR5iGLxmcabAVscsvZfc2sYqQE6u61vWt3kIHXosbQKzPYfuYBzIetrVhEVbptJs
         TQtHPt0EgNBkOeAqlNQZaUsWSXaVWX3edgrNFhmJKguYkFPHpzume2WXP7R29LJrisxG
         sohRVoOa2jTj9bvbPz3M0vUF4Fa5YKtUUJP3YPuXMIrufssBR1n9/ABP1drxlYhLyx/S
         FNYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Yx4JXZUxRwe0yWzq6ZJhBAWxkFR15xP4rqVJcbYeyXI=;
        b=p78dWTsNXP3+xLqSSjo7iQhA02VcEceQ4Z2FWL+ITpzpkRL6RHakS81E5qsWCWvpAv
         rInJ1lBfs6WZYNWq3TvURBYKOvtu154RE4SxwsvlrlrMTQSR7Dbi22u1WzFmuEomO2Zb
         cYZ+M0k6V+GVzoh3ZLPMQfz3BdEDOfo3+E9b4J07LMM5hOGxfbnhlMpLIcGU5XCwjZsP
         kmZRDoeZ7pBPtu+oCbfIQKQc6xz9rBFUxG/4VMfpk5mPQakvAhGfWjphwXQkLPnPSpbf
         2ikn4SyfTj3MIXSTBgH8bXQf0Q7tl0Z+d0X+91lv0o3ouXYyu3OskTUSQwg8ZlOAuHD9
         xybw==
X-Gm-Message-State: AOAM531b4lom8QDvwwY22qikaI8AYCuEKOXfO3dUo5o+Y2vymW756op8
        Xj5bPJ3ZcgHImsmIzc7VmD6A1FUInYULazBoes3MFTDixsjKpwzu1i0FLhFQaXvrdpeR3pqRwcj
        /2rQ3hmDLcrQuuRN9afjPXe/FvJZfUGqMBRqMATPGHlGJt/QAxcub/Q==
X-Google-Smtp-Source: ABdhPJz2Li+WFtTy8oRY10LHxmCH96VkmhzgfNR1hv4/h+ObQJWK69EJsAQIAwXym0j9qFunF5MQKMyUqg==
X-Received: from fawn.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5795])
 (user=morbo job=sendgmr) by 2002:a05:6a00:13a5:b0:518:b4c7:c475 with SMTP id
 t37-20020a056a0013a500b00518b4c7c475mr344304pfg.75.1654101018827; Wed, 01 Jun
 2022 09:30:18 -0700 (PDT)
Date:   Wed,  1 Jun 2022 16:30:12 +0000
Message-Id: <20220601163012.3404212-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH] x86/pmu: Disable inlining of measure()
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Bill Wendling <isanbard@gmail.com>,
        Jim Mattson <jmattson@google.com>,
        Bill Wendling <morbo@google.com>
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

From: Bill Wendling <isanbard@gmail.com>

Clang can be more aggressive at inlining than GCC and will fully inline
calls to measure(). This can mess with the counter overflow check. To
set up the PMC overflow, check_counter_overflow() first records the
number of instructions retired in an invocation of measure() and checks
to see that subsequent calls to measure() retire the same number of
instructions. If inlining occurs, those numbers can be different and the
overflow test fails.

  FAIL: overflow: cntr-0
  PASS: overflow: status-0
  PASS: overflow: status clear-0
  PASS: overflow: irq-0
  FAIL: overflow: cntr-1
  PASS: overflow: status-1
  PASS: overflow: status clear-1
  PASS: overflow: irq-1
  FAIL: overflow: cntr-2
  PASS: overflow: status-2
  PASS: overflow: status clear-2
  PASS: overflow: irq-2
  FAIL: overflow: cntr-3
  PASS: overflow: status-3
  PASS: overflow: status clear-3
  PASS: overflow: irq-3

Disabling inlining of measure() keeps the assumption that all calls to
measure() retire the same number of instructions.

Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index a46bdbf4788c..bbfd268aafa4 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -211,7 +211,7 @@ static void stop_event(pmu_counter_t *evt)
 	evt->count = rdmsr(evt->ctr);
 }
 
-static void measure(pmu_counter_t *evt, int count)
+static noinline void measure(pmu_counter_t *evt, int count)
 {
 	int i;
 	for (i = 0; i < count; i++)
-- 
2.36.1.255.ge46751e96f-goog


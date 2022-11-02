Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396796170E8
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiKBWvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiKBWvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:42 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68E5DEE9
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:32 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id h16-20020a170902f55000b001871b770a83so180909plf.9
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7OQ0aq6fqWkjpQc6CYW2iggh4cn3SVYLURqvDWd8PBw=;
        b=Bsn4YKOwJlwX0xthSJdV1gjvleljWOngLREP5heofkDjIXItr2pHN09LTOziKJT2zq
         vDUcy/D5oVXSPZuwo0wyCCcSK7jhJhZRiF6YIgfoZTDtmm6vd5EqCFMaa8IMXW8PQSYn
         uU2MKby1ZdKilCRoeA14bCIYoxUDSsFmhxij/BziYdqF1UYwuImFwdixbjXJgUcBqv5I
         PLDEWk4Q+LBzUgwwD0awylQb2aK+qv4UejAQzJlpXVouUoPzmjTbbDVmQAc5tXG1K80Z
         bY8QbJUlxy/9aHp7xaH0Srx3rh5Vm8uOHj2MHq8Hdznjul/KaDUDxiPI23CS3segVeGl
         HxXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7OQ0aq6fqWkjpQc6CYW2iggh4cn3SVYLURqvDWd8PBw=;
        b=gQmAeJSKC4+BXa17jsW6pp9+hMP5iWp5erUWf7ifhqEF5DMGNGwLx3eZFQDqc51kCR
         VXeVwgbLRZa7lp9xQR762z2KN6xvR8STp5tNzihPfHTs0Dfw+BduBhxCgA57WC9MOor9
         wQ2QHkXILzvKVAPiEgm1fOGtMzqQFT1A4YDdb5MsVQJS9kG5D21F7JMlBkuzPqZ2Mf4B
         0EvuO8bhKfN/EnHMcSoE75DHPY0MJq/6tFtjVh/iGB9NSt/b/hWswMthH9dDmgPEsM6D
         UzWQhqNC9Hlqm2Q48WIFZW+8WuFcvAmVe1lhQAR0x9f4Xeq9elatbkmgR+zHGn54Tzc5
         a8eQ==
X-Gm-Message-State: ACrzQf1hM+Ih8qX/+Ax5b7iKA4rGPtm+gOmbDferxv7+csyM+G0tJDb7
        1IG4UpRxxpG5m0fte6g4bHnC4hLjCcs=
X-Google-Smtp-Source: AMsMyM49bkkd2vfthEQhUOXiMpGJbBwhJfUSS7DTML3wKPQIJbn1fekVAspPDwEwxmdD051T8l2o7e1IWNY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2344:b0:186:e357:f3ac with SMTP id
 c4-20020a170903234400b00186e357f3acmr27347416plh.110.1667429492459; Wed, 02
 Nov 2022 15:51:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:53 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-11-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 10/27] x86/pmu: Refine info to clarify the
 current support
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
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

From: Like Xu <likexu@tencent.com>

Existing unit tests do not cover AMD pmu, nor Intel pmu that is not
architecture (on some obsolete cpu's). AMD's PMU support will be
coming in subsequent commits.

Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index ddbc0cf9..5fa6a952 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -658,7 +658,7 @@ int main(int ac, char **av)
 	buf = malloc(N*64);
 
 	if (!pmu_version()) {
-		report_skip("No pmu is detected!");
+		report_skip("No Intel Arch PMU is detected!");
 		return report_summary();
 	}
 
-- 
2.38.1.431.g37b22c650d-goog


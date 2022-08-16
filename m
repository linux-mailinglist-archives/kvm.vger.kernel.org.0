Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F285956C9
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 11:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbiHPJmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 05:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbiHPJlg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 05:41:36 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47E7754B7
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 01:10:16 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so8938235pjf.2
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 01:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=zwlyMaIPE/ZQcE6GaGrSuAnRcD4WM7g6M4tfIXe6WN0=;
        b=l7g2h4EsRNGSBv6qEGZ1DdRSH9HdIoTan09B6E38n7VuvjOh2Hcy8aaqlQ3x9NbG00
         pYTJNciYdZIthcc+ds+ESg25gjQgKXwMVxiUJmZdmScY8eOJdVjnJpum27Hrpi/3ixmg
         cgorwDuLZehu46z5raD/iYlufplXhk07MRhvRaT4eU34huzwRuyBbikKN9gBPu1nXWl/
         IOjE9am40SgtDcF4DYQd7Y5/zX6OBoMt3Mj/2n5JSraI5c4FUM4YCdGjNHtpuraZawm8
         N6uWNn/yakWq3P8D/zXCR47wj5ysvyuSOv2+4qjLiLePwPH4Xnw2ikO7naSv5ywiXyTC
         ZZcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=zwlyMaIPE/ZQcE6GaGrSuAnRcD4WM7g6M4tfIXe6WN0=;
        b=HHkxe0Gv+Ohhr7p5TssJL4W7KtepghbERYlGE8tOJf1L4fK7VwDXW0xDx9L62IRsk9
         HtE9KWwjyrGWFVU7r1nUGW6rNt0N5m+8HYIasbrlz4e9B0PP0e5uu3VqniztgR/VXUyH
         q62FIK/j3rRhSzcJVi8Xjg02dMR+K2r9O4bYbSJnMEX9caPtmIRzP5uELO19wnibg5Uo
         VbFk131e6NcUl0eZf7pDkFkrTYT6bTh2tlLHAbzXqDlzjDsN45PNstC8vDi3OFuCXXGN
         3hLSqoT9PupxGMcNb0s8ZgkB385TI4tf6hkEbygbyDD6pmty8Fo6tAZJr9TIq7CxnZvv
         Atfw==
X-Gm-Message-State: ACgBeo2Ahf0fYxpOhsvpUh2SLCJkanPUKVdMW8U5IySwfkUhPPsIkft0
        WZS2TlEeUvTfZ5IDbLj/Gjs=
X-Google-Smtp-Source: AA6agR51pXnu7RFs1qM3f5uQ9+ai85wf6R0X60X0jFGNinQFzAS1PifHTXOng3MuyGC+wSS0ZgIm7Q==
X-Received: by 2002:a17:90b:1c0b:b0:1f5:7bda:143a with SMTP id oc11-20020a17090b1c0b00b001f57bda143amr32757594pjb.139.1660637416255;
        Tue, 16 Aug 2022 01:10:16 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902db0c00b0016d7b2352desm8400920plx.244.2022.08.16.01.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 01:10:16 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 3/5] x86/pmu: Reset the expected count of the fixed counter 0 when i386
Date:   Tue, 16 Aug 2022 16:09:07 +0800
Message-Id: <20220816080909.90622-4-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816080909.90622-1-likexu@tencent.com>
References: <20220816080909.90622-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The pmu test check_counter_overflow() always fails with the "./configure
--arch=i386". The cnt.count obtained from the latter run of measure()
(based on fixed counter 0) is not equal to the expected value (based
on gp counter 0) and there is a positive error with a value of 2.

The two extra instructions come from inline wrmsr() and inline rdmsr()
inside the global_disable() binary code block. Specifically, for each msr
access, the i386 code will have two assembly mov instructions before
rdmsr/wrmsr (mark it for fixed counter 0, bit 32), but only one assembly
mov is needed for x86_64 and gp counter 0 on i386.

Fix the expected init cnt.count for fixed counter 0 overflow based on
the same fixed counter 0, not always using gp counter 0.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 277fa6c..0ed2890 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -315,6 +315,9 @@ static void check_counter_overflow(void)
 
 		if (i == nr_gp_counters) {
 			cnt.ctr = fixed_events[0].unit_sel;
+			__measure(&cnt, 0);
+			count = cnt.count;
+			cnt.count = 1 - count;
 			cnt.count &= (1ull << pmu_fixed_counter_width()) - 1;
 		}
 
-- 
2.37.2


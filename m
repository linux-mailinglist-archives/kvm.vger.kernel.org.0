Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957BB599AB5
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348697AbiHSLKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348690AbiHSLKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:10:05 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23237F4936
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:05 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id w14so3845626plp.9
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=aL8+SDZqeWF3T/aB/Kb64Lwk2O30Tk1xfGSb8fxuAVE=;
        b=G+sno3vnow+YodYZroFF2qqOvm1JCKl5i/iKDUJ4ydQS8KFDncTfRA5KtkZkvoVXAo
         MVhBx129Wo3dK6tvhq0nxaD95fz1EH6PoUtl13WaSXM4P3g+dDZs9fo4G2n/75flvTfx
         7h7qezo1woREySsybT0PwXcI2OH/khIKi8ycu816MumKKruxuGijLwSRDEamQzXLwafs
         JRTd29MEygOpTmlUoMtKYCpz4/C1/zBJk/E4gn/VhaLiB1XOASNcTBr5mgHUowvTXMCC
         JFd0KNLeeH3EXI1iUqNCVW7cIeA9wcgUwfjrLkD75j7Ijzrz8hWQ4x//VuxAW0VhF7CR
         tQNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=aL8+SDZqeWF3T/aB/Kb64Lwk2O30Tk1xfGSb8fxuAVE=;
        b=iPx+qrxMafiRbpjVDI4Bdlk+wW/skw2Dw4VIBy1X9kdemANqfRQVi6Rh+upq0tLUFa
         YISIudk7v64b+O+zbcp9k7flomYz+7MFJRKIyTBh4RS/DBYanzEg2WM2Kn0xft1oYQFD
         QSMA6dD2A7O+Wx9p882uQlmrr3DwOUmaNM9dQdo96gEQsL5yFSK5NKnlKe/qwH+ugoE8
         wCk8Xj/Nn0QFz49Ou+HA4aCTvXbaehaSZst98252uC0GshjUNk+uKzYcMLaSovvjnnXF
         KRKz+1wvd6AdBpLrig8pFMGVA3D17QPQ09o0ZbfxLnONffvFjAWBgLA0+44BjzJFC6TY
         iyLA==
X-Gm-Message-State: ACgBeo3UKo3ILLzZNxHYn0dJXWh2dvWFI/TmIcLpBz2kugTSGWmgM3C6
        hHESBvwZJp+RAJVeA1zSsq4=
X-Google-Smtp-Source: AA6agR4E/PpX1YcAHi8iRo/aAs4LCNj5CTm2iIuKLB4ggu721jmEJPnvVQoSMNJOzyn+d3E4EjCSbg==
X-Received: by 2002:a17:90b:3803:b0:1fa:ebea:e90e with SMTP id mq3-20020a17090b380300b001faebeae90emr1448936pjb.111.1660907404075;
        Fri, 19 Aug 2022 04:10:04 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jd7-20020a170903260700b0016bfbd99f64sm2957778plb.118.2022.08.19.04.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:10:03 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 03/13] x86/pmu: Reset the expected count of the fixed counter 0 when i386
Date:   Fri, 19 Aug 2022 19:09:29 +0800
Message-Id: <20220819110939.78013-4-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819110939.78013-1-likexu@tencent.com>
References: <20220819110939.78013-1-likexu@tencent.com>
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
index 45ca2c6..057fd4a 100644
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


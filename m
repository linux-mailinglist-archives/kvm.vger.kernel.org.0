Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19314C8B36
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 13:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbiCAMDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 07:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiCAMDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 07:03:07 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BF61177;
        Tue,  1 Mar 2022 04:02:27 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id j10-20020a17090a94ca00b001bc2a9596f6so2002192pjw.5;
        Tue, 01 Mar 2022 04:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eEwHxHUP77Rnt3Krvi9zolaYyiYlU8Dwhm1yGbdoRcI=;
        b=f+xNslvVfega+6DFbO9VXrfSi5fZYSM+tbwkPxp+hAiqOxr9INLHnOBYw9mEZaW6jZ
         ul7JhPUxbbDJoBNBKQSJ39/c6D/8AHYtsSgBaezMzqWiTOVx8Jg7+ScwmI0pjyoZ5pjY
         Ao4WrCWKmqpsQH861MzUxctDJ/fIaE4iZrRez8JcHQWPRfPungkhZafecFq9ZCQMEkIf
         7ehLXMySU+4WEepwC6oiS2EkIGPhpIY0KfslJukvl+0M9szSSOQ2PZ3wGTsx8jYlZRjQ
         jvmsIkXXjjgXtXKcpU/paIslfBFJk6D9PCBFntzMcXmC/m3/0lEZCRuBLwgYXYf3sM0A
         sL7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eEwHxHUP77Rnt3Krvi9zolaYyiYlU8Dwhm1yGbdoRcI=;
        b=8JjeNNrUausDCcxsvh6li1hSGja929Z9bADu94KKJm1ocw9kbMiHEcte28p3K/nxAf
         e/59EQ5sCVk4j6xOjvW0VjVyO2uQX+cTyMFdkO9AI04EBRahtf5dwao2B31522houlXD
         OlADpE/sqc20FnVZr3yxeD4LvgK842Hr6I9zRkNVpYvA6dvoWYwswMkSLV8vFvARAZpT
         jTb7EVVxWpTiA4iGpR3RHl6/uptcU2/qv0lwqzXEfwp38JmzD3zpBkKQDyDjpJnJbYY8
         sudk4lNPbn3tQbcbPjAymfGiL9cc7CauZTvqymoG0GjQVy4/xG5syrn9+KxLqe65WVLu
         ng+g==
X-Gm-Message-State: AOAM532zOzoxJ9Kd2927lElTxfAiV9JADUdaAw5Eic314bnL0RRhi+MV
        xb0e+jZezGEN6QRlfRIAHj6Q5CWp+0s6wZQyo6I=
X-Google-Smtp-Source: ABdhPJwy4cAeNOciAltdNl1OefjQA/ex8Y3klkwQWzzWHJ+WX1XLPWUVj0wqkfev3lVcRWkdQDk7Jg==
X-Received: by 2002:a17:902:bf07:b0:150:9b8a:a14f with SMTP id bi7-20020a170902bf0700b001509b8aa14fmr20431268plb.127.1646136146910;
        Tue, 01 Mar 2022 04:02:26 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g10-20020a056a000b8a00b004de9129eb80sm17210294pfj.85.2022.03.01.04.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 04:02:26 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/i8259: Remove a dead store of irq in a conditional block
Date:   Tue,  1 Mar 2022 20:02:17 +0800
Message-Id: <20220301120217.38092-1-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
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

The [clang-analyzer-deadcode.DeadStores] helper reports
that the value stored to 'irq' is never read.

Signed-off-by: Like Xu <likexu@tencent.com>
---
Note: not sure if "irq2 + 8" should be needed for "s->pics[0].irq_base + irq"

 arch/x86/kvm/i8259.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index be99dc86293d..e1bb6218bb96 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -252,7 +252,6 @@ int kvm_pic_read_irq(struct kvm *kvm)
 				 */
 				irq2 = 7;
 			intno = s->pics[1].irq_base + irq2;
-			irq = irq2 + 8;
 		} else
 			intno = s->pics[0].irq_base + irq;
 	} else {
-- 
2.35.1


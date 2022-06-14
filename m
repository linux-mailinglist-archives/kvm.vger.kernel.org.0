Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFD654BC29
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344914AbiFNUsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344091AbiFNUr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:47:56 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABE9205E9
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:47:49 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id c11-20020a17090a4d0b00b001e4e081d525so48328pjg.7
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=445Dxm/hWO1uMPB0/Sj36VMrqtqiEZcdCSofMfSvzg0=;
        b=QIeMVjypij7Jbov+vsynuCjBPOeV2JgUxvXQ+Q6BM/JpYzzCaELEmT8KYTEjCeF9C4
         1ciFMdR1wsxiDFtQDGQriGsed+I/bgBs5Si4mhyepQUTwBBfNe3ZpMA9CyEifZ1urvK3
         ssJDLnoulidAAVYeMXU9fEwGa0KUd7+GWsro8qafeo2y8g2H5C9Ystb/Jpw/Ha6oBiDH
         j4Yf6heS7003xruz58J9xmnXClYXjLCBdKiY+Exj2om5Klgy7vQYzoAghDlRrItKTMgw
         +uyOb08PjDALTJerL8/81X8a16K5wTJcxTmmXyMvrFw6M8zzlQvPmUuB7kODDJ41b/VG
         nyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=445Dxm/hWO1uMPB0/Sj36VMrqtqiEZcdCSofMfSvzg0=;
        b=HXZNPQA+nUXz9Rc9e0WPdQamz6zENQcgBm/uNEPnYlPDGGBEH9ta1D8mqwch3OpNAG
         q2kEHR9Bj32EZ7O+xzpxpFX7ulvapnDBA1Fwi8/zjwh2t3Ry7bgMr3CYfF2t3qkLEvSC
         Qsd1vaz6EXvrPWEFYqCPu1Z76gHYQWcN3WfqTE5DVVdipFF1b8Rn22fvzz5a7l51OV0D
         qmhW7563LR0N0BfTUh6sTOcDn8ruL5R6sTtf99bJtQQuhwyojgoOYVldNwZBECFxvf5i
         1ArSSEee4gfdNd2CS9qtckpx5dhPZOrhEuuYAiMP0q5Rfbe4j8uch8OwHsy9x+Vkc9eD
         lwGg==
X-Gm-Message-State: AJIora+Re470+c0oqdlLeJG+HpRUt/tjCVuAMOSEI1csasT0uO4GEj1f
        PAMG7T8dxF0v2P4S4/YJmicRPKFje0s=
X-Google-Smtp-Source: AGRyM1sQpwauLumNzBDFhO1lN0ASWBmfeO9ruXIiKyQ8/AfhJ7QVRCvYsl7ijU+PfLdl0YVa7J/XI1FPT0Y=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185 with SMTP id
 q15-20020a17090a178f00b001e303bac185mr194296pja.1.1655239668728; Tue, 14 Jun
 2022 13:47:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:47:16 +0000
In-Reply-To: <20220614204730.3359543-1-seanjc@google.com>
Message-Id: <20220614204730.3359543-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 07/21] KVM: x86: Use DR7_GD macro instead of open coding
 check in emulator
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

Use DR7_GD in the emulator instead of open coding the check, and drop a
comically wrong comment.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 39ea9138224c..bf499716d9d3 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4182,8 +4182,7 @@ static int check_dr7_gd(struct x86_emulate_ctxt *ctxt)
 
 	ctxt->ops->get_dr(ctxt, 7, &dr7);
 
-	/* Check if DR7.Global_Enable is set */
-	return dr7 & (1 << 13);
+	return dr7 & DR7_GD;
 }
 
 static int check_dr_read(struct x86_emulate_ctxt *ctxt)
-- 
2.36.1.476.g0c4daa206d-goog


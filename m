Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C646CB5BC
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 07:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbjC1FCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 01:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbjC1FCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 01:02:37 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5411FEC
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 22:02:35 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id k1-20020a170902c40100b001a20f75cd40so7102993plk.22
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 22:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679979755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9QQzDi7GpVjFTFh6qcWiIai3J9NNhOIoGlEpKZ27RWs=;
        b=mY/v2nMrskLnaRdL8PxIyDkfpE+DoOrXOIaNKRXjjXcQ5+mNG01/1daVWGMxdZUbSz
         0X/zauNZwcX+8Zm3k68BG+RGNSdcyja88BeVBd5qr9clHstWPdC6E7QVdA/CzEJZ3x6e
         aNudBITsYYg6UWwx1hrbkk+0mqd9EcKbdQmwwLj+dhUC8xU7ewgY0AqEWLGdweSzFFOE
         RlCChVoMdONyXjxUodKiUa3YIxd3ObzDHBijJwUohG2hYQGaPZ73c4xVzEzbyljm1jCs
         gdlwBUkkHSYErzPUdO72NgBVOJcd9Ne+qcospZAp7J8A9l0/aUPU6bXD4zIzGv/f+o5d
         zMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679979755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9QQzDi7GpVjFTFh6qcWiIai3J9NNhOIoGlEpKZ27RWs=;
        b=pU0QshBMUFQ9P5pNNg0Uclrrduc9NnWwxWbQXkr6ecLMoWmwYb6tOlfMsDOaPf1hOS
         ZQtcHQbprPDpjeZx7mP4V+ApSx0Wjbi5gVf03txxcaSJ1lTaznWFXiGRLViz/4kENf8J
         w/ZXE8A24dUk4WNe7V6DixJjhSK3mULb4dH5s638X44VsbJAvlnJ46d0O4gl4t3E//Mm
         CN+ccr5WqjIN7D7vuSsN98Ij0hOUkDfH5stOu62MjmWE9n/rKY7djPlfBj/3gRG31HGM
         hrhqDjzrBiLfImBlJz863bD7quPovVpeda4vDrP9uD6X4khImHXtRsOfNlh4YN5JP5hI
         JoiQ==
X-Gm-Message-State: AAQBX9fojkd3Io9/RBdRCgm+Fdv7wpwHIQ656WeYSAiLhNxjZlBfhhc5
        iSsmfoz8VfOOkyz+qPPPfl/S+y6SzQo=
X-Google-Smtp-Source: AKy350Yz7WS3QMyCF1aufF2zTNYE4rEN3mngWZaZW0opNdJiV8W0yrSQVhWQ4SOZ/hvkC1C8UkUl6PsoecI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1714:0:b0:50b:18ac:fbea with SMTP id
 x20-20020a631714000000b0050b18acfbeamr3778876pgl.9.1679979755205; Mon, 27 Mar
 2023 22:02:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 27 Mar 2023 22:02:29 -0700
In-Reply-To: <20230328050231.3008531-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230328050231.3008531-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230328050231.3008531-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/3] x86: Add define for MSR_IA32_PRED_CMD's
 PRED_CMD_IBPB (bit 0)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a define for PRED_CMD_IBPB and use it to replace the open coded '1' in
the nVMX library.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/msr.h | 1 +
 x86/vmexit.c  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index c9869be5..29fff553 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -34,6 +34,7 @@
 /* Intel MSRs. Some also available on other CPUs */
 #define MSR_IA32_SPEC_CTRL              0x00000048
 #define MSR_IA32_PRED_CMD               0x00000049
+#define PRED_CMD_IBPB			BIT(0)
 
 #define MSR_IA32_PMC0                  0x000004c1
 #define MSR_IA32_PERFCTR0		0x000000c1
diff --git a/x86/vmexit.c b/x86/vmexit.c
index b1eed8d1..2e8866e1 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -463,7 +463,7 @@ static int has_spec_ctrl(void)
 
 static void wr_ibpb_msr(void)
 {
-	wrmsr(MSR_IA32_PRED_CMD, 1);
+	wrmsr(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
 }
 
 static void toggle_cr0_wp(void)
-- 
2.40.0.348.gf938b09366-goog


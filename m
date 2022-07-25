Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8572E580553
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 22:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbiGYUPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 16:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236900AbiGYUOy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 16:14:54 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCBE22B27
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 13:13:42 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b17-20020a170903229100b0016d3e892112so5624424plh.6
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 13:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JHVVEG+MppVPv9YMCBO9GV6xd0sX4BJVP9qlD8DC6ZE=;
        b=nHfLu5QLAumy2Xh3TBsU3IOJG1tRIYUyaU84j8Fk7QARs7//ZdluYtipUsg4RbImIA
         E34gZ7OBAjKdM03dV9iFRA5IIUmDuDbTUzNB7oPCY+S2DqyRiGbORkcct4OanAcMBVdi
         78TEMg3DWmT+v4l/iNMgO27iNPphcZBuEE88A6fws8nFgpOO3Y3HcRpTlKQXMEVbolgw
         IR4bh2V2KdkQcZtcJiEfLndrzjD8pR2jrLc6LEBTqJUpDMnrgpo+Eypz28pUoyCFXMIm
         Xn5hYV47VEEnqjkn2Zmpfnh0BNo531iMvhOE3XdKyM48bi4hBGcDcPsmpWJpOEHd8KgL
         tFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JHVVEG+MppVPv9YMCBO9GV6xd0sX4BJVP9qlD8DC6ZE=;
        b=S70GBfF5oGKZtMfB4Owf9rKsRxo6QrtPNqtE0heucI+2r7i6zrdfWoM0n8TVlckhAj
         XizcOAPP5v7VdeoKtHLyeea+eIho0SjNHU65cjsLcOEXbQymd+7E/ebMK4NZkXJd6k7T
         SLAxQfZTEdyhgGanpUv8kMUdQSFQUb0cy/ie/tH6ZuW9VHd84JlitlvNYSDMFxvEubpO
         K9N/8WNSaVwoyeVo0QM8FDi2DB9NYhKxWGqMyug48P8nnASPZQevRiho2i71jvCMEWh7
         5b7sXnQTg/hjW/FVPN0T/DD5nGIgAbTuUhYDJWb1Oy0nYLMXAB8LzcWSLyWucpl7Shiw
         KeVg==
X-Gm-Message-State: AJIora8YHWdS5hgCf7HNDmawGekERXgXVyATPNA4aT6FIVBzY1OHRl7y
        lt+juQkFsk33mIhaDszd4ORxfd1Gb0c=
X-Google-Smtp-Source: AGRyM1tYsPmrGTW2goNDKR08FrVJYxuwJ2OBLMiNvBEUl1qF7J2CLDFUt3IMF87WJoWzc6TZwe8sHSc8qnM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:760f:b0:16c:ae59:c9b2 with SMTP id
 k15-20020a170902760f00b0016cae59c9b2mr13885686pll.0.1658780022201; Mon, 25
 Jul 2022 13:13:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 25 Jul 2022 20:13:36 +0000
In-Reply-To: <20220725201336.2158604-1-seanjc@google.com>
Message-Id: <20220725201336.2158604-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220725201336.2158604-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [kvm-unit-tests PATCH 2/2] x86: cstart64: Put APIC into xAPIC after
 loading TSS
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
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

Now that pre_boot_apic_id() works with either xAPIC or x2APIC, "reset"
the APIC after configuring loading the TSS.  Previously, load_tss() =>
setup_tss() needed to run after forcing the vCPU into xAPIC mode due to
pre_boot_apic_id() assuming xAPIC.

The order doesn't truly matter at this point, but loading the TSS first
will allow sharing code with the EFI boot flow, which "needs" to load the
TSS (more specifically, needs to configure GS.base) prior to forcing the
vCPU into xAPIC (and thus setting the per-vCPU APIC ops).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cstart64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/cstart64.S b/x86/cstart64.S
index 7272452..5269424 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -188,8 +188,8 @@ save_id:
 	retq
 
 ap_start64:
-	call reset_apic
 	load_tss
+	call reset_apic
 	call enable_apic
 	call save_id
 	call enable_x2apic
@@ -201,8 +201,8 @@ ap_start64:
 	jmp 1b
 
 start64:
-	call reset_apic
 	load_tss
+	call reset_apic
 	call mask_pic_interrupts
 	call enable_apic
 	call save_id
-- 
2.37.1.359.gd136c6c3e2-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588314C0BFE
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238283AbiBWF0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238220AbiBWFZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:25:53 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5286E2A8
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:53 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id k10-20020a056902070a00b0062469b00335so10829507ybt.14
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qiOY3I7MTzDOyydGuOsoL3kibVHTWqt/T8NonRDSdjI=;
        b=gHD/ZzZ2afDsPzQ43uzTfHDeNudIA9BOq9xrr9L14+jP+dH61iVLZ9hzKNk6oCuBOI
         frJ4Y/pMW9lHMFuHIDT5LntquphVA/hdUftBkeKzRimB/OZsUvqrqt+OTldNL/5M2dvF
         +PIjZDytqBI9qNUICzwPtZ9WZreG3la5anScSUKXP0fumh99WG+FQaCeyfbwMohmDN9Z
         TqQY1Ne53dTgZlticBLJ/nLFoMZJ6npZslQ1FhKLNnIG+gBpH+SHHrgjBmREZgI8pcKn
         GtFQ6xyENvmtRWa1WOq2159X/570g6HXWtqzHRNADNoxBQZmRvsc5EkR5xI3zImo/8Xk
         CC5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qiOY3I7MTzDOyydGuOsoL3kibVHTWqt/T8NonRDSdjI=;
        b=5K7kV1L/1norlOP74jTBaUkGBE1DEVX1o5NYI354uGjhzxMvFFRtSpEcCVmey/+nXf
         /IhTt2DMmOJjqh1uGTM/clhkb+yYNT11Utyr5UcCFplo5lBPaCKrlujFVJ7O+p7R/Ia/
         JLOxRgMzwGx/SojnEjHpvQ7GnvsxUD2OWZ40l8HIdsnVhrLp/uKdouJGQEAlGgwHGdSB
         QBev9P4UtrAE5oyncPPWBRrJ8yvgn6mxDrQ2+xwpqTvNBl7rquGFyNuacvMXx3dMxxoR
         PpO1ROiQfEsWnvOmLHMvsRSjBAFrbY08VTZ9fxh/qLWOySS6I7Kib1/SloW6DXTZaQkO
         sEtg==
X-Gm-Message-State: AOAM533Qnwaf3NBH+Iyn11sGaFhUgmH5m0owOZD3JeH3X6fOxHrJlpYA
        aWg4WsFoRbyMKzVEtHhX26EVjgRp6Gm2
X-Google-Smtp-Source: ABdhPJz0RUH+JeSNvxcFS2t+PaXJsk2Yx25dJd/bxX+okavoC9VlrjteMlukvkj4zkv9eNKI+iSQhOk6jOMd
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:bad2:0:b0:620:fe28:ff53 with SMTP id
 a18-20020a25bad2000000b00620fe28ff53mr26732357ybk.340.1645593881600; Tue, 22
 Feb 2022 21:24:41 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:01 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-26-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 25/47] mm: asi: Avoid warning from NMI userspace accesses
 in ASI context
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
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

nmi_uaccess_okay() emits a warning if current CR3 != mm->pgd.
Limit the warning to only when ASI is not active.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/mm/tlb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 25bee959d1d3..628f1cd904ac 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -1292,7 +1292,8 @@ bool nmi_uaccess_okay(void)
 	if (loaded_mm != current_mm)
 		return false;
 
-	VM_WARN_ON_ONCE(current_mm->pgd != __va(read_cr3_pa()));
+	VM_WARN_ON_ONCE(current_mm->pgd != __va(read_cr3_pa()) &&
+			!is_asi_active());
 
 	return true;
 }
-- 
2.35.1.473.g83b2b277ed-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B144E32E0
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 23:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiCUWtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 18:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiCUWt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 18:49:29 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C42527D6
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:14 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id mw8-20020a17090b4d0800b001c717bb058eso363594pjb.0
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ry/V9YKDNiv2vz1hDLgo+eFR8ahO5mH8znmtscP7EmE=;
        b=WwG2u7IpZgea5H5GWN2LQKdFaBLk/jfiid/ciXEV7lby07wuiAKU6CWpErdYgWG7sP
         Lq9m3DglPE2OgHasPd0SOuZRh6xLkbOVphpN8n7QhTel+9/yHIWA/OF/h3k0RTWKvtK5
         LCmwhOoEcyWdhm7pIsyZNK1zFE48KkJ3cQ3iGs1kxoPhqrSltqaFF3ndiHec8jrw9rL7
         QQ3VC+90lgaePJAYPmsOQHCoNnvx0bWeXFxGMDPONKufR5xvjS0AicLVUpPTXzcPGCDP
         J6fb+pbaKjzLeRtijlSnOhYcKKAp7eIKHWTxaf3ubt3Fw73UqC1kOHgS3I+xHF1oxRPC
         BkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ry/V9YKDNiv2vz1hDLgo+eFR8ahO5mH8znmtscP7EmE=;
        b=hdXHXfpvwIDpvzVU4yYbROgIQNdVxRH83jbpvdmyFCAi0090VMWrNzuVsAm3CpG1Du
         /3u7kYZLTNHelP3YUs44kXob6pF1do7Ho04v0dSdQvCtoInGnCIMU4hs++T65z3TPXjO
         2xTWRjw8KDQufOMr1OaSrhUsWPkh0pXSVpv9uBTmBIi0EPGNrGkL/HOnPN4GQOWWyPGi
         /FjGju7gX4RTHO4GyEfkMbE/RT2a1w7Weh4b4qX5+JlIKMAo9fo+G3S5mcIPzHPnYW5g
         7RQAfQ10x6P1yARpLJMrLYptw32bVcB8Xv63YMg7UuKdR2Gtd+NDB7avhWAk4pRdNJJ4
         y+bQ==
X-Gm-Message-State: AOAM531whoQnz8xrinjcUTOSeWZ6JjGGmvB0dwOC8P+zrgtoj0qvJz/s
        a5GbgBchCqlv22p0cOhTsF5XZ0OAGswB
X-Google-Smtp-Source: ABdhPJzvtJaDirlNw2N/gfEsXwwJ07X/ORBgROWSzoIs87S3gs5eF48UAvimJequA6LLUN827xFgWpELHZ2N
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a17:902:6b89:b0:154:623c:9517 with SMTP id
 p9-20020a1709026b8900b00154623c9517mr5803835plk.45.1647902654448; Mon, 21 Mar
 2022 15:44:14 -0700 (PDT)
Date:   Mon, 21 Mar 2022 15:43:54 -0700
In-Reply-To: <20220321224358.1305530-1-bgardon@google.com>
Message-Id: <20220321224358.1305530-6-bgardon@google.com>
Mime-Version: 1.0
References: <20220321224358.1305530-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 5/9] KVM: x86/mmu: Factor out the meat of reset_tdp_shadow_zero_bits_mask
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

Factor out the implementation of reset_tdp_shadow_zero_bits_mask to a
helper function which does not require a vCPU pointer. The only element
of the struct kvm_mmu context used by the function is the shadow root
level, so pass that in too instead of the mmu context.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3b8da8b0745e..6f98111f8f8b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4487,16 +4487,14 @@ static inline bool boot_cpu_is_amd(void)
  * possible, however, kvm currently does not do execution-protection.
  */
 static void
-reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
+build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
+				int shadow_root_level)
 {
-	struct rsvd_bits_validate *shadow_zero_check;
 	int i;
 
-	shadow_zero_check = &context->shadow_zero_check;
-
 	if (boot_cpu_is_amd())
 		__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
-					context->shadow_root_level, false,
+					shadow_root_level, false,
 					boot_cpu_has(X86_FEATURE_GBPAGES),
 					false, true);
 	else
@@ -4507,12 +4505,19 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
 	if (!shadow_me_mask)
 		return;
 
-	for (i = context->shadow_root_level; --i >= 0;) {
+	for (i = shadow_root_level; --i >= 0;) {
 		shadow_zero_check->rsvd_bits_mask[0][i] &= ~shadow_me_mask;
 		shadow_zero_check->rsvd_bits_mask[1][i] &= ~shadow_me_mask;
 	}
 }
 
+static void
+reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
+{
+	build_tdp_shadow_zero_bits_mask(&context->shadow_zero_check,
+					context->shadow_root_level);
+}
+
 /*
  * as the comments in reset_shadow_zero_bits_mask() except it
  * is the shadow page table for intel nested guest.
-- 
2.35.1.894.gb6a874cedc-goog


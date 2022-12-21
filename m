Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15EC265388F
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 23:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbiLUWZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 17:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbiLUWZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 17:25:02 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E23A27178
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:37 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id l7-20020a170902f68700b00192495b1f10so153401plg.2
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BoetL47dMtSYpyhZbJzKl1EqSh6TREkVR0ldKUR5DTE=;
        b=B2Il06BXZ5r75uO6Eh6VbInYjOxKdKJBrLZcwxld+Hj9NTKOaFJ4tEln9Ebd43HD3V
         XGsxjryczXGgpPcb9lEHqJHq6iSZOJDDZYCR9sJdtAcozqn8ZhJQBFnBtQAGVb8fs88i
         tS4KjdO/CHK6ygrF/kxg+BGf1GBeSdrqZz1Bs1DCwuZ4ALwelH4arRjImcrNksCQH0PJ
         fre2RUTACKiTUUq7uDfxqdnR50CEEj1LXW0xeHx730J4o2IACZ+mv8pTROJWGX0w8D/f
         digzIkmHy7fIFib/DTm+CSnIbYO09B6k8GNnVK//AhuZ3XugZ2+LvEEfUXboUxjCh8cR
         TbTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BoetL47dMtSYpyhZbJzKl1EqSh6TREkVR0ldKUR5DTE=;
        b=XTtoeWDBKVqWl2OFHZI6VySvNRRU2Fh4M0mYDQYXjEElmOvn3hickuNQH0dxSIwgfd
         QgMK1JIYiZ78kKCYNCNiirpqHAhXNH50iBsdQ20AVqwGZ3GAoaTWEXDJcvVMbuJolROg
         htpok9niYcHc5oSuKIhMd4Q1e4H9pGTMkTSEbgnebg4zE4fiL+M7JDIJiISzhCZwUi2G
         RSjACZ6PSyIvuQ2uoVRu8EFnm8i1WVOmv8u4r9XrdFLJUWEyoG8Jn9Rrc6S27Sk/EtGh
         ibkpfFVL2S8VJQJDm59nyepTHIp0HmlbXYXbaSEP4WvaStzdtcFq+Ct9M09++6/rV21q
         ZGIg==
X-Gm-Message-State: AFqh2krV8kn1E1ZBhLNvgDJ1lgpRx9TwsUlN4y6qIvfoUOn4P/yH4277
        OEFTkTSdRuJmHu6npA7T7DslMUmk0fxB
X-Google-Smtp-Source: AMrXdXvcPw/batAzM2ubwgjdBVty+O9txrpne8GQWWnHTUKRra0t6kSK2wryQb6O1CIF9FnsBgLoCAGFiI5U
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a63:9359:0:b0:478:bc15:bf28 with SMTP id
 w25-20020a639359000000b00478bc15bf28mr148390pgm.542.1671661477243; Wed, 21
 Dec 2022 14:24:37 -0800 (PST)
Date:   Wed, 21 Dec 2022 22:24:13 +0000
In-Reply-To: <20221221222418.3307832-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221221222418.3307832-10-bgardon@google.com>
Subject: [RFC 09/14] KVM: x86/MMU: Only make pages available on Shadow MMU fault
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Nagareddy Reddy <nspreddy@google.com>,
        Ben Gardon <bgardon@google.com>
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

Now that the Shadow MMU has been factored out of mmu.c and the naming
sheme has been cleaned up, it's clear that there's an unnecessary
operation in direct_page_fault(). Since the MMU page quota is only
applied to the Shadow MMU, there's no point to calling
kvm_shadow_mmu_make_pages_available on a fault where the TDP MMU is
going to handle installing new TDP PTEs.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bacb519ba7b4..568b36de9eeb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1469,14 +1469,14 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (is_page_fault_stale(vcpu, fault, mmu_seq))
 		goto out_unlock;
 
-	r = kvm_shadow_mmu_make_pages_available(vcpu);
-	if (r)
-		goto out_unlock;
-
 	if (is_tdp_mmu_fault)
 		r = kvm_tdp_mmu_map(vcpu, fault);
-	else
+	else {
+		r = kvm_shadow_mmu_make_pages_available(vcpu);
+		if (r)
+			goto out_unlock;
 		r = kvm_shadow_mmu_direct_map(vcpu, fault);
+	}
 
 out_unlock:
 	if (is_tdp_mmu_fault)
-- 
2.39.0.314.g84b9a713c41-goog


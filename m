Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C606153DA6F
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350033AbiFEGdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349900AbiFEGdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:33:45 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F7938DAA;
        Sat,  4 Jun 2022 23:33:43 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r71so10516667pgr.0;
        Sat, 04 Jun 2022 23:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UIh9uECf7BlKLTjyvtoYPpgqACtGyu4JH9Y3de5XW28=;
        b=ir2lWXdIQD45DVM1rRbVnulolV3JKpfOvofww+NQvf1uScmMZC3enik0NMazaVRtpg
         td/HMuaY/BRnO6+AXURoYJCyqKRAzMDgtrvSB5+MPqo7Qy5gWRClvtNYF0c6JT4pna62
         G47j3FIK6ZJY86WXtV6ZPF3H8Fh+s1ACMUzsU9dENPSMys0tiC0pN0gnxol9F0eVnDjP
         QL8pa7KLlVDZoHTXl//HAHhixJNVhKnlbsI96L+ABiVQVgMzOPao3FIXIdHPsYZ1jo3I
         SRTWb+V4Q7Qz+Gqdl3Aq10s0h44BVOLqGvyQNsia49hqQAYYBtZWE2+e2dkoEMkC6JWn
         ulUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UIh9uECf7BlKLTjyvtoYPpgqACtGyu4JH9Y3de5XW28=;
        b=vISY+hSk37Y+Doxp96Mq9iC0baYviHGNEOuQEu3LyIgz3wrJXAKLMIp+tlYLjrHu8q
         /FOYe47s1CgvFB8l14Kkee8hkGeKHzBHQXv81hoDlKNiM209sv6ObxyUTlK4ZCHWZXFG
         ShS35Xxt+vd5CAMvpqTXVA9yaZ573k9fd+RR3WX9Ih/7YL+k5ByVE7lr9QpdsmupkR86
         FbxD2vaUp6w4Fv1S3iIi2dLJC3c0n9yRbVPtQef8fJU/vO9jyk3uERb0wCPR1PBe+YLI
         LFnliNszgq+mDSwi77Vf5OdBG0oCi07TnLDFxoy9ZuxSGBnfgip/3jVWwWla/aagpNrT
         KigQ==
X-Gm-Message-State: AOAM533fM9/DiRfsj9NtwO/TXm3eZbE8ZAkxEFZRXLTS0X7yA8jFufj9
        OH1SqSc/zHwxW4vaMNPVROMl1wsI8Hc=
X-Google-Smtp-Source: ABdhPJzmXVU3G5U9LXZb8gIuFkBNh5lZxpPavH1Px2YvEZrIBM8jdWoDaVMDeNowjmKay9nSHwiPiQ==
X-Received: by 2002:a65:6786:0:b0:3fc:e1c0:7bbc with SMTP id e6-20020a656786000000b003fce1c07bbcmr14211150pgr.65.1654410822390;
        Sat, 04 Jun 2022 23:33:42 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id h2-20020a635742000000b003db580384d6sm8092270pgm.60.2022.06.04.23.33.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:33:42 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 4/6] KVM: Rename ack_flush() to ack_kick()
Date:   Sun,  5 Jun 2022 14:34:15 +0800
Message-Id: <20220605063417.308311-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220605063417.308311-1-jiangshanlai@gmail.com>
References: <20220605063417.308311-1-jiangshanlai@gmail.com>
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Make it use the same verb as in kvm_kick_many_cpus().

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e089db822c12..00c899393418 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -235,7 +235,7 @@ static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned req)
 	return mode == IN_GUEST_MODE;
 }
 
-static void ack_flush(void *_completed)
+static void ack_kick(void *_completed)
 {
 }
 
@@ -244,7 +244,7 @@ static inline bool kvm_kick_many_cpus(struct cpumask *cpus, bool wait)
 	if (cpumask_empty(cpus))
 		return false;
 
-	smp_call_function_many(cpus, ack_flush, NULL, wait);
+	smp_call_function_many(cpus, ack_kick, NULL, wait);
 	return true;
 }
 
-- 
2.19.1.6.gb485710b


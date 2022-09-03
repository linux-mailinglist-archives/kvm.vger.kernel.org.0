Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B705ABBCE
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbiICAXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiICAXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:18 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B0FF63E5
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:16 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y21-20020a056a001c9500b0053817f57e8dso1721939pfw.6
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=Rs+EzK2PrcvX75yfJJ7NsfNpP39FoXTyChrPXJ3Dyu4=;
        b=svQxp/Dk1xxER24u/HvVfK52iBH7DF4YoJEpJhEFJDsvOOH1Qtk/hMBcizYU7vF/Ou
         8ecN9f9/le3c74WqGDy8zb3fitBGXAODsCbpJFQKZMBeyE2CHezHQZgDZU3ZJkE5L0vn
         gtVXJfeKQrJEmLq6Oj+bNe/cThL2jXtOY/de52ZY8TB1qfmu4KFBm2Wox+6U+BR+MAMg
         kaKkOVRC8XD7E0UixuHKk05kwRnKdlOpWt7UuvYmFzWAKWCRuqBI8zvoSu6JMmX2/uwI
         q7Q4BAHkRbWLKBe1cRGpijR7j00TXZnb3WZ0q9YSp65fKULni0SybLtiECYFmdSU6Qju
         GsLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=Rs+EzK2PrcvX75yfJJ7NsfNpP39FoXTyChrPXJ3Dyu4=;
        b=sECRGsZvw9Mfme8vSoIs3Sjy53bTYf1/D8FsrNMTY99tOj/tsu5UCEDCyaEt67Lj2C
         u0WFudcM6F0Hfpzk089xWVZIJY4thh2V97QS/nJHcJsBAB84BOGXXHfp7n0u4xYUsaF1
         QRNgKkZxBT53GAFUlvIVmyJS69Jad5BE3e578SjFTlOM6DdTSAd9SuTEeL/ZVHUHDnUn
         ZU7YuhA1Klkl8fEUy2lr7H1pYIms0ivV6G9amkODv1PzquWiYeM8QtZCAzhbwWGWKODV
         yYktYULrWCBytJ8NMh1gnOd5jseWvH2w8W3oMSbPQEnab8yYFgM9H5javlptlB5Mwnkq
         MP9A==
X-Gm-Message-State: ACgBeo1g9z11LOThYZrG6TV9IE4Plim59OcMYD/FN2ztlxVKQGVtF+vs
        jupTQ1Sb2zI5Y5d+Kc3lAth8ER7+cUA=
X-Google-Smtp-Source: AA6agR5aQ2I+MmONVolgNKJQhCEoOadjOqwmb1ME9GZ2SRe7UhK/yd06TRHsklSl8ULfFfu7fx0vexIihUE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9e4d:0:b0:537:fc95:b736 with SMTP id
 z13-20020aa79e4d000000b00537fc95b736mr31435090pfq.25.1662164596313; Fri, 02
 Sep 2022 17:23:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:41 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-11-seanjc@google.com>
Subject: [PATCH v2 10/23] KVM: SVM: Document that vCPU ID == APIC ID in AVIC
 kick fastpatch
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

Document that AVIC is inhibited if any vCPU's APIC ID diverges from its
vCPU ID, i.e. that there's no need to check for a destination match in
the AVIC kick fast path.

Opportunistically tweak comments to remove "guest bug", as that suggests
KVM is punting on error handling, which is not the case.  Targeting a
non-existent vCPU or no vCPUs _may_ be a guest software bug, but whether
or not it's a guest bug is irrelevant.  Such behavior is architecturally
legal and thus needs to faithfully emulated by KVM (and it is).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 8259a64c99d6..b4b5f1422db7 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -395,8 +395,8 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 			cluster = (dest >> 4) << 2;
 		}
 
+		/* Nothing to do if there are no destinations in the cluster. */
 		if (unlikely(!bitmap))
-			/* guest bug: nobody to send the logical interrupt to */
 			return 0;
 
 		if (!is_power_of_2(bitmap))
@@ -424,7 +424,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 			if (WARN_ON_ONCE(index != logid_index))
 				return -EINVAL;
 
-			/* guest bug: non existing/reserved logical destination */
+			/* Nothing to do if the logical destination is invalid. */
 			if (unlikely(!(logid_entry & AVIC_LOGICAL_ID_ENTRY_VALID_MASK)))
 				return 0;
 
@@ -433,9 +433,13 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 		}
 	}
 
+	/*
+	 * KVM inhibits AVIC if any vCPU ID diverges from the vCPUs APIC ID,
+	 * i.e. APIC ID == vCPU ID.  Once again, nothing to do if the target
+	 * vCPU doesn't exist.
+	 */
 	target_vcpu = kvm_get_vcpu_by_id(kvm, l1_physical_id);
 	if (unlikely(!target_vcpu))
-		/* guest bug: non existing vCPU is a target of this IPI*/
 		return 0;
 
 	target_vcpu->arch.apic->irr_pending = true;
-- 
2.37.2.789.g6183377224-goog


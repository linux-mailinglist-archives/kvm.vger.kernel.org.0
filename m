Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2CF5A72C3
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbiHaAiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiHaAhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:37:08 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AF558513
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:59 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id lw13-20020a17090b180d00b001fb2be14a3dso11945725pjb.8
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=wFaEqzZozhtqmNn0e7C55y4Mw9837tqb72zXdm7HEXg=;
        b=m47lnlh0bMmxDPeqAWzcjqHjbiSUGITV4W62KnmVkp+F4sJvmaiZr0PaxYPdNcRASE
         nfyxSE+Ok0LjqmRY6SHPU55wwO7mJD4DlI6mrWXAR8UZCaYwjMrapALQRt8BG4Yw6xaZ
         y1/mdec3bxaxkPKLwau1WZIhrjbO83hQK8PnryVscEJuYA6A/BkInijkJKJb38Be4u7u
         ZVNV3NugVSVZel2HPBphgnE8Tx+oN00qjydm+OLGKmkjA9GU4Poc/plMsVhqIM1SDDUq
         /ZduO/vVAG1EWinEnK52wdNUkeI7eGcLjIFlwgKbrdJ5v0MR/z3xqd740f7ccQl5D31h
         Txhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=wFaEqzZozhtqmNn0e7C55y4Mw9837tqb72zXdm7HEXg=;
        b=6GxlGQC3dzP3Fe41bwfiaY4fFvouQ9JA1TnodQlLv6sj42y/l66544NHYKRMi4O/z6
         pMpvodQL9mvDqT+uMsjhqSrhVb1HvP5PpueTTYNvEJncNiKE9XLoHLRBDVDieNf/vmVc
         NwLWiePx+OIDPXsl8MIWDsy6ILZC5RP8lbJaQxCbJTHGcD7bVKXe1q3PGhpJ7t/VgOfG
         WN9eK6carsbhlB02CO+yrNgWjYBe6T/fSnImVsXrCTkKvVh5+F7TRXyx42uz2dJJRDeK
         w5ApZMjaIgJToAvA93j4KbOzxc8Vi2IWQiShlx1HiC164TET7hcIb6gVpc6igUST7Tgs
         l4tQ==
X-Gm-Message-State: ACgBeo0dqSF/ZeCpbgdwtefVAJS9KD2488m9Tl836SneyiSIHz+ER6wM
        IllX26Ti8aHqMO1FbMswAkuwsChKN1I=
X-Google-Smtp-Source: AA6agR6LhPKafXpIoPCYpbT1uDPrPxv+h9/n6jWQhQwWZHcFZ4OoDPz98WMIfVahlZOQnfqziyguccqBl2s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:760c:b0:172:adc5:fc9 with SMTP id
 k12-20020a170902760c00b00172adc50fc9mr23592405pll.102.1661906126398; Tue, 30
 Aug 2022 17:35:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:34:57 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-11-seanjc@google.com>
Subject: [PATCH 10/19] KVM: SVM: Document that vCPU ID == APIC ID in AVIC kick fastpatch
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
---
 arch/x86/kvm/svm/avic.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 05a1cde8175c..3959d4766911 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -380,8 +380,8 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 			cluster = (dest >> 4) << 2;
 		}
 
+		/* Nothing to do if there are no destinations in the cluster. */
 		if (unlikely(!bitmap))
-			/* guest bug: nobody to send the logical interrupt to */
 			return 0;
 
 		if (!is_power_of_2(bitmap))
@@ -399,7 +399,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 			if (WARN_ON_ONCE(index != logid_index))
 				return -EINVAL;
 
-			/* guest bug: non existing/reserved logical destination */
+			/* Nothing to do if the logical destination is invalid. */
 			if (unlikely(!(logid_entry & AVIC_LOGICAL_ID_ENTRY_VALID_MASK)))
 				return 0;
 
@@ -418,9 +418,13 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
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
2.37.2.672.g94769d06f0-goog


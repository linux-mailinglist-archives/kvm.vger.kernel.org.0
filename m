Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804AA5BF130
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiITXck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiITXcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:32:08 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01930786EE
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:00 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id a6-20020a17090abe0600b00200303ba903so7300001pjs.2
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=skon94oxKuHPyrSCQoqZBUe63SjQdco2L+TbbL4uBCU=;
        b=Hjp5g7m53/Dp91nmfe9aQvSSNCbSbLS48fRz6LVQD2ydP8OXIfzIUK1tUakIx5EKft
         qfTTKIJcO3HY41/Pzswr910irQbCD7Tat2fl1zSM5/d67ufO5XF9mXgjMrLg3DaYK63D
         ImyCFmQ8Z4EX6ExTelVtXumWpd3yWus80WizoQPv9NdS09OZVbimaQ1wgDOGZtMpv+LM
         KDd24x5tdembE2fpMbCxFockYMcaNTK2CekzpPtgRvVCKYE98YxKnoEBTHzA+hA9/gpK
         VGDw9iW9WdsjpqbZhJoYFTor86nTVAyUCGGtIzkL5TStsn2pTS2yfsrPqPJ4jOzfyuKI
         0NMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=skon94oxKuHPyrSCQoqZBUe63SjQdco2L+TbbL4uBCU=;
        b=vBIZVqszjHFATkS8TX1CVR7LlqnIasp+2cRYtv+6YxZWU6EEidNB0OKH6do9DySCxI
         +pbBd22mG/lBgN1Jo9Lo7faIKUoaQ4ua9fkVT/xVAfbS+g2xNK9KoTt9NPZnQNBssfWa
         l6c3wn0rWttCfLTGD048YDEeM9DImwc8x/KPY/LYLND5eqaDghYiuSbdURJSmG9aBlnh
         z0v156WRzsVbYdlmuZjBaCKp86GL6y+GxE6PFIBx96zGqOb4ODmMpBneSwP1h3Pjyp5P
         I4cSC8BJ0Hg8m/Iid8IoyF+MQ+abXNNJTgXVnoRJtga8Io37DwnJkCCryodqhClDqDsu
         8CdQ==
X-Gm-Message-State: ACrzQf0ADTqJT56n03w+huMWkNJUso5Vtz6DXFxEpIN/Nrd3u5qXRcck
        25BOVisILeOnQVLH8pekZZ0tpUiMsik=
X-Google-Smtp-Source: AMsMyM6dxZVAHo63ijsllpicyTPhfqV0yiHEH8OlJFbFOU4rMaDxHlrLk7dkWcMJdTG4jA0OB93KEwVbFkE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:24d:0:b0:439:3804:d0ff with SMTP id
 74-20020a63024d000000b004393804d0ffmr22380275pgc.414.1663716720540; Tue, 20
 Sep 2022 16:32:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:20 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-15-seanjc@google.com>
Subject: [PATCH v3 14/28] KVM: SVM: Add helper to perform final AVIC "kick" of
 single vCPU
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

Add a helper to perform the final kick, two instances of the ICR decoding
is one too many.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 40a1ea21074d..dd0e41d454a7 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -317,6 +317,16 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
 	put_cpu();
 }
 
+
+static void avic_kick_vcpu(struct kvm_vcpu *vcpu, u32 icrl)
+{
+	vcpu->arch.apic->irr_pending = true;
+	svm_complete_interrupt_delivery(vcpu,
+					icrl & APIC_MODE_MASK,
+					icrl & APIC_INT_LEVELTRIG,
+					icrl & APIC_VECTOR_MASK);
+}
+
 /*
  * A fast-path version of avic_kick_target_vcpus(), which attempts to match
  * destination APIC ID to vCPU without looping through all vCPUs.
@@ -415,11 +425,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 	if (unlikely(!target_vcpu))
 		return 0;
 
-	target_vcpu->arch.apic->irr_pending = true;
-	svm_complete_interrupt_delivery(target_vcpu,
-					icrl & APIC_MODE_MASK,
-					icrl & APIC_INT_LEVELTRIG,
-					icrl & APIC_VECTOR_MASK);
+	avic_kick_vcpu(target_vcpu, icrl);
 	return 0;
 }
 
@@ -443,13 +449,8 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
-					dest, icrl & APIC_DEST_MASK)) {
-			vcpu->arch.apic->irr_pending = true;
-			svm_complete_interrupt_delivery(vcpu,
-							icrl & APIC_MODE_MASK,
-							icrl & APIC_INT_LEVELTRIG,
-							icrl & APIC_VECTOR_MASK);
-		}
+					dest, icrl & APIC_DEST_MASK))
+			avic_kick_vcpu(vcpu, icrl);
 	}
 }
 
-- 
2.37.3.968.ga6b4b080e4-goog


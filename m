Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A5865F8D3
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbjAFBOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236887AbjAFBNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:13:43 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E825F755C5
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:13:41 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id bk2-20020a056a02028200b004a7e2a790d2so196094pgb.18
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oP9W5uEc0+NE0fVZ2qt9BCyCXd37G2flkZxHxmfC/SM=;
        b=lhDl+F1m6Gb0QU4uj7oQnM7HxwxTzwFuUmvYMgYeFyh51hje6BROAa43BG6gPCKOQ9
         mXg2BNy7HNWgQnFTSvJ76inFBvNiKBUNM0ekR9tSNdfBgbsItS8r2eW55T0KiR1lleuO
         zsJ9gMXPeJOJK5DofJFUl3QAHW4fOodnMdMud/78Ky9bo0+QlOyU9O3SDaD0baeAJl0Y
         AzBavAYI+JEMNEG286Nwgd1wgNkre5V0hbGrdGe7ilPJLhohyfPUElcrdiyPGfEy5PHM
         FHwabkbcnCagvLjwMnmj03+7Yo4DoX9huXkkR2rNhT6nmkfz1ecQ2jnLi4jXTswKTZu7
         h6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oP9W5uEc0+NE0fVZ2qt9BCyCXd37G2flkZxHxmfC/SM=;
        b=OZICZOOq5K/bPAPnOcJnIVGef7LnQKZsBFALDOo4DiuuS4d+Bxkrv60iAt8zMErK0y
         0UYnkVw3FesHlkGZ6h9wUDkY13euqEqiseC3d4AoNxhTA48ZV52IzH/1fJH0XSWuQOEl
         c1KvZEdKvE+XAzf+Rye8dLJnhSYjlD4uOFPSJL54gtH+gaS6tNwyToQ00R49fa7nw0hR
         Di52ugNIKSEREJccWVM2yps1bs4LKbOfWngfmu03a7SPy/6kMOdLkqQVY4xP58KPIFFi
         2JouWP4vNKl+HP+PfR8XuREIMfmdjlZchhdx22yMqX1dgBAFSQP05pb/yCT2Yd2r39NR
         OR5g==
X-Gm-Message-State: AFqh2kqsk+iV/P/AONSHpelnZ+syttt7aXBEGiI2OUDh4+2filCZe9K2
        wsZPZ0YeRaHk95UttW1bUKwA0gcInZk=
X-Google-Smtp-Source: AMrXdXuo9NMFxPPxTioFXxvW8HWI9616amHLNe3R+YqEc09hS3vc70SRtVnQtbxqS1unCUr1aTSKNQ062xM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a98a:b0:189:bf5d:c968 with SMTP id
 bh10-20020a170902a98a00b00189bf5dc968mr2459776plb.118.1672967621397; Thu, 05
 Jan 2023 17:13:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:12:49 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-17-seanjc@google.com>
Subject: [PATCH v5 16/33] KVM: SVM: Add helper to perform final AVIC "kick" of
 single vCPU
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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
index eb2ad5b54877..76da9f19272e 100644
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
2.39.0.314.g84b9a713c41-goog


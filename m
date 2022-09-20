Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1CB5BF12D
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiITXci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiITXcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:32:08 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25426F256
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:59 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id oc9-20020a17090b1c0900b00202843f7057so1516982pjb.1
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=JZAIYdYCg9gsJwY7eA6nzFlm6TxDyiq9Q8zzDq9WamE=;
        b=YWQAzjFU7mSAIBBpEEMWNuvmnTzsVnLRyJUTxMVfGlsNBLNsFJUVfUtCDdinXRigaJ
         gVdC/cngA61DrktBfUbUfLX2SzrWuJHBNCLwJVao1un1TWgVyLjRPtcFZw8ripVlXLpN
         c7K89ctFLKrGZUrs9+sAd7uESaXChOv/OxlbdQmr3UokDONz/mdLB2VYGGLE8GaLZTcO
         7jPWJs4U6+Cn32RK0pQ+SvLmErOAvnm36xXjVrfKkSIA9or/61NEwLQZFcRsOEqqxjZz
         am78kmZ7SGGos06HNVUWtmSBL7iwinEvHfTFiDspb7LhE9lTz0+KP4OAIDtFuQhRksPJ
         3gwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=JZAIYdYCg9gsJwY7eA6nzFlm6TxDyiq9Q8zzDq9WamE=;
        b=nXJmL5D0HLtJjl2B7NGnMNqTSuuCnpldJczm5umU/Iz3l727Bzl4BH30tDXwmExqlM
         +XB2eE9Qd1SuzLz3RXrrIrTbeRGH9/wsH49gB6YPyvI5Jpz/Lp3RzHr6QQ0ou78E9k0l
         8oWpq+EovmRJGhXJdJ60jjpXZIbFSYzBdk5kddc3cofFXdcjUvWS/Q/lHzsPhbl6pivP
         u4v9v5E5OpHaAWtKzvq7+krJ7PfI4Hs3u+llMN6HsEZHVOisaMc+SDNQrOj9KMecy2SI
         iSgUTdxYsJXYsRc/Zlv9gs+88yILDXAyUqg2AznuZZtccEt7i/EWI5rDAwY8fArkHbSr
         0t6w==
X-Gm-Message-State: ACrzQf3xAIRbkEfzFaNLfat5BZJ/ZYjtH1UvK4aygohgYltbWUPiAhec
        hhg7Muyb1xpZ08nmvjDu8NZsZQS/vFw=
X-Google-Smtp-Source: AMsMyM4yevkG6l/25iock09o1aq13GNFSNZvnc9fYRAIPe6BtvBXT9K4Kv0/+u9/xt/5TQZE4hv5DTDMD/Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:23d0:b0:550:d950:c03e with SMTP id
 g16-20020a056a0023d000b00550d950c03emr7166520pfc.16.1663716719135; Tue, 20
 Sep 2022 16:31:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:19 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-14-seanjc@google.com>
Subject: [PATCH v3 13/28] KVM: SVM: Document that vCPU ID == APIC ID in AVIC
 kick fastpatch
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
index 605c36569ddf..40a1ea21074d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -368,8 +368,8 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 			cluster = (dest >> 4) << 2;
 		}
 
+		/* Nothing to do if there are no destinations in the cluster. */
 		if (unlikely(!bitmap))
-			/* guest bug: nobody to send the logical interrupt to */
 			return 0;
 
 		if (!is_power_of_2(bitmap))
@@ -397,7 +397,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 			if (WARN_ON_ONCE(index != logid_index))
 				return -EINVAL;
 
-			/* guest bug: non existing/reserved logical destination */
+			/* Nothing to do if the logical destination is invalid. */
 			if (unlikely(!(logid_entry & AVIC_LOGICAL_ID_ENTRY_VALID_MASK)))
 				return 0;
 
@@ -406,9 +406,13 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
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
2.37.3.968.ga6b4b080e4-goog


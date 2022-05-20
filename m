Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39C452EE66
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350357AbiETOrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbiETOrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:47:10 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093396D848;
        Fri, 20 May 2022 07:47:09 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id s3so11064173edr.9;
        Fri, 20 May 2022 07:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SWTQFgB8L0HOjZtQc1uTglM1zJk6QTSSIlavXmQwbTw=;
        b=kqbsM/w2QOwGxf2UjEnlVOncYqn2rwW8vphGroA5HeE2AtSamnO3PFv5sXcDBpwLr1
         rrc4DEABL98OCWqPpH0vVGcgyJxmzR/HtoUmRpAOOgMJGnCAWo5EO69SXfO5ZrPU9Bj/
         eP1vGtB9z20A6qW/OeA04MVbY8EF+E/1jW5Er72EmdxngcDfXQXR2pcdezafWxvrDRWt
         D0SfozJgFeLbto3IiK2QzSe3rueCMiD9qh/EYguwxQe1sqTuik0T/NninI2M3oQAsxLK
         gNYbmcR2Xv0ZHG9bgB4t3fU58kU+E5pm2+nB/HW6YjAdTRhUBtP8LQuK8FGnkkUuC2Sz
         vbIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SWTQFgB8L0HOjZtQc1uTglM1zJk6QTSSIlavXmQwbTw=;
        b=UQGkEyXSzxRUKXzrnCI/No6Uu8rb+CTs09cjSxSKAoEoF1UqBI62q69gTZOdCpX0rH
         DYs6TZswWOhbScKbDqBSDyJAxeg7kx1+JWxYGL9QrplIzxF4hys6XPZWYr5C5Kny16CT
         sm+qh3qZ0zzVZo4CGZmNkcKB7gDxO4QGJcGD0HPfP59tcN9MjHsj7bl67JyjN84GKNbR
         dn5PMFRLfL/WC2xSCTioUl0PhNTZFP4FwnCN1fArfyDqIMhGpQnN0ZtABCNEyi2eQw3H
         Q1AYXs7o/tHb/59Gb2PIVmEnKMdm7q+lCr2mOrc4wpCpDOYqOBt5pGPAo2772Sz1G3eN
         MdxQ==
X-Gm-Message-State: AOAM533a/gjExsUBt2V9T/zagToEdKTet1HpZuBMtJqu05Z1G/OpxSOy
        ZYQ+gCOgkoC3ds6s0rwNEU/twPfIQLc=
X-Google-Smtp-Source: ABdhPJwoFRUDuX17QRDGhaE8MUYmI9XsJtewhQ+/m1a98o+oddwFTlmOHJFPz4XvmG2vEgnGz46+jw==
X-Received: by 2002:a05:6402:3447:b0:42a:a449:ebb with SMTP id l7-20020a056402344700b0042aa4490ebbmr11130353edc.75.1653058027304;
        Fri, 20 May 2022 07:47:07 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id zp26-20020a17090684fa00b006f3ef214e2fsm3345013ejb.149.2022.05.20.07.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 07:47:07 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: x86/mmu: Use try_cmpxchg64 in fast_pf_fix_direct_spte
Date:   Fri, 20 May 2022 16:46:35 +0200
Message-Id: <20220520144635.63134-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.35.3
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

Use try_cmpxchg64 instead of cmpxchg64 (*ptr, old, new) != old in
fast_pf_fix_direct_spte. cmpxchg returns success in ZF flag, so this
change saves a compare after cmpxchg (and related move instruction
in front of cmpxchg).

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
---

The patch is against tip tree.
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 311e4e1d7870..347bfd8bc5a3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3073,7 +3073,7 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	 *
 	 * Compare with set_spte where instead shadow_dirty_mask is set.
 	 */
-	if (cmpxchg64(sptep, old_spte, new_spte) != old_spte)
+	if (!try_cmpxchg64(sptep, &old_spte, new_spte))
 		return false;
 
 	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
-- 
2.35.3


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFEB570FC6
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 03:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbiGLB4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 21:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbiGLB4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 21:56:09 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017D23E76D
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 18:56:09 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d13-20020a170903230d00b0016c1efef9ecso4750892plh.6
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 18:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=PC+WzugTfmpy8a4WKm922TF8iM8VxRFbGcTUFeFJFUA=;
        b=dRcboDDcrZAYrd71m94Ycc8GP++lO01Mw65EabvxrzY7DT+fBpk8CpGN5DPjGFBWB2
         N7spNflEsIhcmfmRVNeu4wibUWR2Y4Rc1SMDcZnhN01IEwiYUgCSRumePuJidX2VEV1n
         puIU/gdKRMH0estJWRyFYszf52cJvBZLBfh2m/+YGZ7Z83lPVaJjmLmKKMW8vjC1zaaU
         vR0RxBCADn9X70kittmw8EZ4sul5azpQGWOXOheC1aWrSKwrKB7xh2m2qZq79SxJPbmp
         c0xRTHzdhHMyxFpVYio32OHKeuFtsiNPcUQA8PlK8PFA8tXn2W5nxUPAQh2GQvIg5yl4
         W/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=PC+WzugTfmpy8a4WKm922TF8iM8VxRFbGcTUFeFJFUA=;
        b=6xIxiZx0Xcmp/4WfdxxGL5i/QuVcwt4mOoGDG8lna3lU0a+yNwIpjDLAGVIMoSaSa7
         96V5mRDnmt7JTSNXlFaiZPiMJUvnyfdiPsZgYiAL7W7DakV4Ez3GDx6iUChB1Nl0ViXF
         BJmxIzTEYhYeimCSmyoD4X+uvWKG9RcOpzHkFWd4KqVr0LnvS2aRkxlGwQ9XcjLSVRl8
         Lpj8Mt1cXHmbrLbRS6wgIhzMHRvoHbMmrzjcoZiOwb4TUKHj/6evy9XtwIuG6OUbbteT
         +udZQdzB1ppE4XaNlIcedrosM3Bgv35ucfe9FYY81mHtDmfW/9hNgvMn4Rp9w4Axiw+O
         ySFw==
X-Gm-Message-State: AJIora/zTGnpc5uBN3I1Fm88KWHSRrCcOOBI5TBzSCYNVRbs+p7lXql7
        kmeynyuZXxVJsQeQ/cdqUbVJfXNpsuw=
X-Google-Smtp-Source: AGRyM1tbvpN8xCTuIoKBvGHUKvfp9hDoKb+F2XgNGjI8r5pEWBxxOjE85vknj97IAgTR2/GMvXnUWEZOuN8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c94e:b0:16c:4d5e:5dfc with SMTP id
 i14-20020a170902c94e00b0016c4d5e5dfcmr7252805pla.56.1657590968548; Mon, 11
 Jul 2022 18:56:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Jul 2022 01:55:57 +0000
In-Reply-To: <20220712015558.1247978-1-seanjc@google.com>
Message-Id: <20220712015558.1247978-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220712015558.1247978-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 4/5] KVM: x86/mmu: Use innermost rmap zap helper when
 recycling rmaps
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Use ____kvm_zap_rmaps() directly when recycling rmaps instead of bouncing
through kvm_zap_rmaps() and __kvm_zap_rmaps().  Calling kvm_zap_rmaps()
is unnecessary and odd as it requires passing dummy parameters; passing
NULL for @slot when __rmap_add() already has a valid slot is especially
weird and confusing.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fbe808bb0ce1..496672ffaf46 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1596,7 +1596,7 @@ static void __rmap_add(struct kvm *kvm,
 	rmap_count = pte_list_add(cache, spte, rmap_head);
 
 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
-		kvm_zap_rmaps(kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
+		____kvm_zap_rmaps(kvm, rmap_head);
 		kvm_flush_remote_tlbs_with_address(
 				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
 	}
-- 
2.37.0.144.g8ac04bfd2-goog


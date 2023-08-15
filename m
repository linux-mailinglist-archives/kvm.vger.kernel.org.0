Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3551077D53D
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 23:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240326AbjHOVgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 17:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240336AbjHOVgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 17:36:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B821FCE
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:54 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c8f360a07a2so4739854276.2
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692135354; x=1692740154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PakTUVCPT5RglwMpqqLace7eQ/bk2K7iwBZe/rVtlVs=;
        b=5rLK6uTTx0ExsbLfIixDo7od8tbQaS4kXbrmtgrAvOiSx66zMkL0PbeN8cCO3GmcET
         rQfJDOFy2SKfMk/vtb/AALMSNoJTG5bAo3AKUoAhK76FiiD4f5wBluvY/NmVU7/Knp5X
         4jsJimcYPRNr/ZLa/k+ME8OQVgCjtP7dLlMplcjjToWJxQ0vWbi5zYk08mCd+/wOf53g
         KCYyjN0tRxykyQUuNoQK/Y7V23OE4vuYeccDSAAnIMA5ucLUapfi/t0Md05tZ9Q+D1V6
         0vWqH9BF/OC4Ce5aKiKt3s+fHLlyZQlzkrwwYYImjSrE61q9wggw7dmrXCp77o0mh3Vz
         Kgjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692135354; x=1692740154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PakTUVCPT5RglwMpqqLace7eQ/bk2K7iwBZe/rVtlVs=;
        b=DVSfj4xc7wno60yCXWzfI1xrmoQbV0DEa2i1Jojz7oO8GL5BHtq221V2e8MglqJFay
         YYol4jq6JfdwjwdIjWTyz1kBFKEWlcJh5wxwSn9Q/4V2scRCqkXnpz93CxpmOJcFO6wX
         g3kerOSbSIXPQj68f/5fl0+gb4t8nxUg1iCGyyRVbMKkz0I1aF6nJo4R/S3Iws1ecpOI
         UU4uE26jS/5DZWbivMtUQsHW8mx7zLJroWYvQkrY9wpBcgCWYvhREuEWKH6mc9+BI2dY
         YPOxHTcSQ37ItbUsaK/9aee2PnihhRvgsdlAnG30XooPndemc+om/L9M55M13obVPC3j
         dVew==
X-Gm-Message-State: AOJu0YzcC1PrRbZKScuWxWaCkrjb7UHyGl4P4guGJ1MgTwujIgd+xb4X
        9aFv3jdjiRMCvBX/vQhaWhVDoSlnES0=
X-Google-Smtp-Source: AGHT+IHTFzi+EmSO3knDI1gLm28+MBww8MUDQX629AwYVZWFBhP3uZRswmmdR81NdMuUAnbgxq8ugbnzpzU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab08:0:b0:c61:7151:6727 with SMTP id
 u8-20020a25ab08000000b00c6171516727mr23ybi.10.1692135353782; Tue, 15 Aug 2023
 14:35:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 14:35:31 -0700
In-Reply-To: <20230815213533.548732-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815213533.548732-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815213533.548732-9-seanjc@google.com>
Subject: [PATCH 08/10] KVM: SVM: WARN if KVM attempts to create AVIC backing
 page with user APIC
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN if KVM attempts to allocate a vCPU's AVIC backing page without an
in-kernel local APIC.  avic_init_vcpu() bails early if the APIC is not
in-kernel, and KVM disallows enabling an in-kernel APIC after vCPUs have
been created, i.e. it should be impossible to reach
avic_init_backing_page() without the vAPIC being allocated.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 522feaa711b4..3b2d00d9ca9b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -300,7 +300,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (!vcpu->arch.apic->regs)
+	if (WARN_ON_ONCE(!vcpu->arch.apic->regs))
 		return -EINVAL;
 
 	if (kvm_apicv_activated(vcpu->kvm)) {
-- 
2.41.0.694.ge786442a9b-goog


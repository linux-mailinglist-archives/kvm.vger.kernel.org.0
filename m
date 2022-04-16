Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35276503334
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 07:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiDPDp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 23:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiDPDp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 23:45:27 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C04AA76F5
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 20:42:57 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 78-20020a630651000000b0039d993c3c55so4929290pgg.14
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 20:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=fTlZCEAeKXElMirgnXEOUiISDvu4kIw+3K3+/YC0tjY=;
        b=esGDB+uQK+XlvOzeTwh0mtq3egMCIieRH3ZRiipmzTx5/a4pNJQ2RmB2E4uDA2bNdy
         cnM+1TL1FiXBdKb+jMG/sq91sq/ZAxb3wtrUF1MYxoPD8QdpNqZr1rP1Cx9qI81Q9vX9
         0VvWDxR8uRdpFT4pDstEyo/1RsBVBu+4tTPe/vhS0Ny19ZUSiiMUkOYzr4y2Vk7aKc02
         YZB6PrlB5kKuiNM/RZ2jeeYKzMdHmYjycfKvMgpJKi5J17GZuRAjL5FMlFZewOu1c2BU
         +uL+WlGMzWHmlkrJ9FeEzj3aCBMHDlcyIJlegtO1tfNTBXJ2P7X4LWBPyExsQ9DS9nAr
         Gt7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=fTlZCEAeKXElMirgnXEOUiISDvu4kIw+3K3+/YC0tjY=;
        b=k2YUNani9myl66GduFdh0/du9ewi840ZnyEhoQJpyLH98gCJK74pQ6SJRueqh5cNOq
         WgI4xNbeeuourQLJNaBySpxQst+8Mkl4WXrKdRJHYJq7k2lKtJKyKc/mtwWr515+6y+k
         tMEZNsBuQ09CUiObBSLX9VuyfWyvB5e7UwtRjPbTCUdVAr5W94ii040k7kHd1NJgh/Ir
         xpxAhvqQaMXbV+rVlGmvw/SccLczWB6ufktY9c5E682AmkE3jaLljCMq5BCKfF6Bf9h0
         pBPNjdQ7JQddXLLLRkZ2M7U6IH3jJHQTwsJQpJIpQRjHJ+U5r4tiGXR24dvgIAyDjqlZ
         8Q9g==
X-Gm-Message-State: AOAM532KCHKLQCpFAVT8WGN5Leo7dnua1eY+D3qNuD7nPSI6yGXgILmi
        O6kxBW96yGu/zAJxCFqWoSL9DOpxt34=
X-Google-Smtp-Source: ABdhPJwEvVzDPrTPEf7YMvmW/Px6daHU99c/ZLJCjUTC4jIXd4UhIM6/elOLB9r2p6vwqsgODRXNCYRQI9g=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:ad0:b0:4e1:2d96:2ab0 with SMTP id
 c16-20020a056a000ad000b004e12d962ab0mr1879483pfl.3.1650080576657; Fri, 15 Apr
 2022 20:42:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 16 Apr 2022 03:42:46 +0000
In-Reply-To: <20220416034249.2609491-1-seanjc@google.com>
Message-Id: <20220416034249.2609491-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220416034249.2609491-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 1/4] KVM: x86: Tag APICv DISABLE inhibit, not ABSENT, if APICv
 is disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gaoning Pan <pgn@zju.edu.cn>,
        Yongkang Jia <kangel@zju.edu.cn>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the DISABLE inhibit, not the ABSENT inhibit, if APICv is disabled via
module param.  A recent refactoring to add a wrapper for setting/clearing
inhibits unintentionally changed the flag, probably due to a copy+paste
goof.

Fixes: 4f4c4a3ee53c ("KVM: x86: Trace all APICv inhibit changes and capture overall status")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab336f7c82e4..753296902535 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9159,7 +9159,7 @@ static void kvm_apicv_init(struct kvm *kvm)
 
 	if (!enable_apicv)
 		set_or_clear_apicv_inhibit(inhibits,
-					   APICV_INHIBIT_REASON_ABSENT, true);
+					   APICV_INHIBIT_REASON_DISABLE, true);
 }
 
 static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
-- 
2.36.0.rc0.470.gd361397f0d-goog


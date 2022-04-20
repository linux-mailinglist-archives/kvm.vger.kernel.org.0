Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7424F507E43
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 03:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358809AbiDTBka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 21:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358788AbiDTBk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 21:40:26 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97774377C4
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:37:41 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id t127-20020a628185000000b005060c388ff7so292560pfd.21
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YggvXc76kD9hmqmKWmhy8VV9X8fOiVEtam3hP4xSjGM=;
        b=maxPT6Mp0MgvU206GcEL0romWQqaLaog8y/UrpuifwgoME9aLjLO4W/X8VprbMLDY/
         GCSQlblwz0+h33sONAnLzlWMj/r58kxHJad6WpW/6XBcaaatIvts2ncRNxYLCqBJWpUr
         ImtXvtRkpsHVKpb5ik7Sk63AW8Lt5YOldBjgPgWy8Rz/Q6hppA8iI0lOXtEo4Ro4bBSw
         GAmva/jjL32/Z9oBcosfTomF6CKA4cQhGQsyAn+2g0racOBoXBAL9cd7IRXXaUgWzGoY
         tjB4OS9UP7vgxAY43mpIA/Vb4eqHyVhaHglyhi9LD29Ul0kOA+7DG2iA7Dq6ZRAdXaVn
         ZzSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YggvXc76kD9hmqmKWmhy8VV9X8fOiVEtam3hP4xSjGM=;
        b=XV9L+Rd6XYFxz2ajPdkl9iDoMlynUpcuMANvd8O0BioVdqA9SJT37K1u40tBgyx/F3
         J37DmTq7ZJWsuZX4wJ7c/7R4TczimfTgFtGSRgrIikk2rVbDGHIgaVjmw5NMl+HsW+RO
         nk6fHDOFn6eIwRZRIfQvWa91N/N8FoeAhFdr5VDJNBMkaIHXZBb4DvKAOmz03fPdMJKJ
         GSJ1pAfEGiK4ZiT0bgJljXmzQRRjtj8DDtXe0k384GyiVm6GPtU1kMRd0nPx51NJuQDn
         BQ0R/6jmH1uWwC6+HCYXDlkSl6fH0gfKiH8H8bWqWCC9du29bigR9YnlXJcp1xt1G9wH
         /ixA==
X-Gm-Message-State: AOAM531eRy0Ckz4ABCCXHr3wwBidXjec1sv7gSZXGnwYB08rCGlG0Pft
        iErIsht8aG/uBlukKaXqYFhHla8rkYw=
X-Google-Smtp-Source: ABdhPJxmdbTe3X4Jl9yDGni826ymwia/p9HVgg/n6ca6j5LdEaWE5XZFyQ+yI2r9ValnG5yrTGpnbVg5h+U=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:7448:b0:158:f93f:bc0c with SMTP id
 e8-20020a170902744800b00158f93fbc0cmr12947007plt.8.1650418661056; Tue, 19 Apr
 2022 18:37:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 20 Apr 2022 01:37:32 +0000
In-Reply-To: <20220420013732.3308816-1-seanjc@google.com>
Message-Id: <20220420013732.3308816-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220420013732.3308816-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v2 4/4] KVM: x86: Skip KVM_GUESTDBG_BLOCKIRQ APICv update if
 APICv is disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Gaoning Pan <pgn@zju.edu.cn>, Yongkang Jia <kangel@zju.edu.cn>
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

Skip the APICv inhibit update for KVM_GUESTDBG_BLOCKIRQ if APICv is
disabled at the module level to avoid having to acquire the mutex and
potentially process all vCPUs. The DISABLE inhibit will (barring bugs)
never be lifted, so piling on more inhibits is unnecessary.

Fixes: cae72dcc3b21 ("KVM: x86: inhibit APICv when KVM_GUESTDBG_BLOCKIRQ active")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09a270cc1c8f..16c5fa7d165d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11048,6 +11048,9 @@ static void kvm_arch_vcpu_guestdbg_update_apicv_inhibit(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 
+	if (!enable_apicv)
+		return;
+
 	down_write(&kvm->arch.apicv_update_lock);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-- 
2.36.0.rc0.470.gd361397f0d-goog


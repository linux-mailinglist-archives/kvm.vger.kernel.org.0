Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7BF3257FE
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhBYUur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233804AbhBYUtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:49:46 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBD4C061794
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:09 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id s187so7591550ybs.22
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=pbM28BHLIyqF+U9LVhQDetEAuxQQswZqlZ+qqRnfJZY=;
        b=P2ZLY8h8Xh4NvOW/x+fYK9ngo9lS/nkoY5I4NoOtKeNzZC6RhLRNFb0eaF+JTID9ap
         GBOErYkXcD/12i/vznQpJXkGC0QTe/qUTUUmDP7UyewOQ+x3xhBemn3MkSOZLuXojMd4
         iTqVxirAhLka54wKDdjGO1LlT/iIJZXOisni1mEYNy7Nm9Dj1akep1BctMOtSND7hrcc
         kIZJAHE9/ZOpzVtvG9oPLJvcM6nEfuCY+oGI4wencG4cfLLDmTEfDCPL+2yzLGz6qD2x
         BFlb3PmQI1gnZvRd2aAACB5TSl8tKqlSurYHj39Jv2Xc7xZM17RW8VfX3dZNBgDTmAek
         htFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=pbM28BHLIyqF+U9LVhQDetEAuxQQswZqlZ+qqRnfJZY=;
        b=gXRWM+0/HQujStewIwLWRLQzikqqGYuQsmNCfpE08+Nc+2TzYbDPJ7ekTrW1xfsHgM
         TeXlGyZBXpRfc7Efzhh9Mco247hBZJ+64CSXb+eKvIeo8jPDbmtbH4sVEhBGRn3bcyGS
         olr+RskCJuf4WL3/y7cj/cXOdwKQoGFIIExTo/+dQjiU4iNA1xhPayF/rEhH3OGF4JQ7
         /uyAJU4rSDXKGiCYQyXrTgeE52uNHbLNM9G14uUbMOcWs9e4jC1TgOErpnPh4nOH80U8
         S2H6WYDfl2F5Bsf+viL1HCM26w2KJZYkhTDIz+nvv9ujoZHvIrTklkO2c/l2dysBSBmL
         G/Cw==
X-Gm-Message-State: AOAM530TUiMdoubgiVByskDI1CaTVAI+O3WpoVmsbB4tOvFr/ZmvxZ2h
        Nigonday1mj/ZmuI4/poK0j8tn0b/Mk=
X-Google-Smtp-Source: ABdhPJwTeHoOevHnPLS4CMbZXa+vqrLd+HRLHc6bCi0lKTvxqOECNcALAMhkrjGYhubrMBs3bURPmSJHcks=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a25:c503:: with SMTP id v3mr6741053ybe.397.1614286088591;
 Thu, 25 Feb 2021 12:48:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:29 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 04/24] KVM: x86/mmu: Disable MMIO caching if MMIO value
 collides with L1TF
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable MMIO caching if the MMIO value collides with the L1TF mitigation
that usurps high PFN bits.  In practice this should never happen as only
CPUs with SME support can generate such a collision (because the MMIO
value can theoretically get adjusted into legal memory), and no CPUs
exist that support SME and are susceptible to L1TF.  But, closing the
hole is trivial.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index ef55f0bc4ccf..9ea097bcb491 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -245,8 +245,19 @@ u64 mark_spte_for_access_track(u64 spte)
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask)
 {
 	BUG_ON((u64)(unsigned)access_mask != access_mask);
-	WARN_ON(mmio_value & (shadow_nonpresent_or_rsvd_mask << SHADOW_NONPRESENT_OR_RSVD_MASK_LEN));
 	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
+
+	/*
+	 * Disable MMIO caching if the MMIO value collides with the bits that
+	 * are used to hold the relocated GFN when the L1TF mitigation is
+	 * enabled.  This should never fire as there is no known hardware that
+	 * can trigger this condition, e.g. SME/SEV CPUs that require a custom
+	 * MMIO value are not susceptible to L1TF.
+	 */
+	if (WARN_ON(mmio_value & (shadow_nonpresent_or_rsvd_mask <<
+				  SHADOW_NONPRESENT_OR_RSVD_MASK_LEN)))
+		mmio_value = 0;
+
 	shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
 	shadow_mmio_access_mask = access_mask;
 }
-- 
2.30.1.766.gb4fecdf3b7-goog


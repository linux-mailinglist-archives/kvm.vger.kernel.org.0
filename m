Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E2846CA9F
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243885AbhLHB7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243651AbhLHB7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:59:06 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E18BC07E5C3
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:29 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id w5-20020a634745000000b0030a5bee70e8so426924pgk.15
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=etoB+YRcMf7Ew/pZhl7cqvSO7EaRAoODrPxvLsV0z+Y=;
        b=abdsZBN8AulwfhpgxPD+fgtZW/OszFybglG7I8YRmtY7jsOfHDVEx09Lnku4UA955k
         ygBEaurFeMMSLJx27MmrK/PzcasdeMNUItLZLxFC6PoPTOdqjNFWj5pviZrAKowSRgJa
         BZRu/Z3d4oB33ANMuQCaoRn07LBKczKYvcneWRW7/QyAxRlbFMF1i0HHAd8rn33iOQVD
         KPpXUBvskSE3vCwkI2VuZW2t6vCz57WbRCoOQbnHiReBty2TU1rSPxDXZ9f2mG5EfT5e
         kH25/9G+rtGAnb0qyHV2Q8ZvYoUy0TZoPaMLVk4tjhpAPay2215OyvJxjU4Ob2M+DqZ5
         8N5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=etoB+YRcMf7Ew/pZhl7cqvSO7EaRAoODrPxvLsV0z+Y=;
        b=NndK2CWOUDPvpIFk4xERs1gEnonK9sNE2RKHgxn+M/FNJdUrH8emVe+GbDU613JYTy
         wJLs36Wn7251weViRUHx3SLjJdP3iqGOVjvPXh2GlAhDipmaLHHK4HPz++y6d+6+hR63
         y9QxcE2/um6R9yZkLPcqxw/GWHhONyt4if2dch4bUXDjLE1gpGsoCUW8oQXYUDRmAXZM
         Bl0r9ZnkixcZHDp0RAGmV45Gkjzdb6Vxl7OGMRQlJsi18F7+E8S2V6DkLp8NbjrINBch
         4J1Pgs8Sk4NdNBfzhyVfhT7rgBj9R6/8DKbSc6+5xjSAUU7ZDVFayKHIcAwQsVN9uRKt
         JXVg==
X-Gm-Message-State: AOAM533Vc5rTSFyMc4VfPPtUkMg6Z1fKk+1/l9NqpeVYpmpT+PEl17CO
        R0Ii+2rNood7444WRRkaILgLRDTMqyQ=
X-Google-Smtp-Source: ABdhPJxcULKyDqDzC4JHXW6P7xwo5S92TmpNNZDY8LH9XdQvp4jfLUO34zv8xNRKjk81H5IFvofKgTYBoNA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:8f09:: with SMTP id n9mr10821495pgd.38.1638928528800;
 Tue, 07 Dec 2021 17:55:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:35 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-26-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 25/26] KVM: x86: Drop NULL check on kvm_x86_ops.check_apicv_inhibit_reasons
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the useless NULL check on kvm_x86_ops.check_apicv_inhibit_reasons
when handling an APICv update, both VMX and SVM unconditionally implement
the helper and leave it non-NULL even if APICv is disabled at the module
level.  The latter is a moot point now that __kvm_request_apicv_update()
is called if and only if enable_apicv is true.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c804cc39c90d..fc52b97d6aa1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9564,8 +9564,7 @@ void __kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 
 	lockdep_assert_held_write(&kvm->arch.apicv_update_lock);
 
-	if (!kvm_x86_ops.check_apicv_inhibit_reasons ||
-	    !static_call(kvm_x86_check_apicv_inhibit_reasons)(bit))
+	if (!static_call(kvm_x86_check_apicv_inhibit_reasons)(bit))
 		return;
 
 	old = new = kvm->arch.apicv_inhibit_reasons;
-- 
2.34.1.400.ga245620fadb-goog


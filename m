Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B884A7D1E
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348669AbiBCBBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348674AbiBCBBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:17 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4617CC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:17 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id o194-20020a62cdcb000000b004c9d2b4bfd8so498348pfg.7
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=F59SUfYeyQQX4JGyCTCS3BzaOvVCAmTejwx5MdGi9kw=;
        b=Zd79YR7yD03r949tweioi1h5+KsJuhg6GQeEcUDAh279Dp0qozn3z3pcg734+eh/QO
         rsC+CVpIGjs/adJvxbK8c0ewUboamc9f8VU8YGYDtMFZP48uGua7sqK6njjfn6MZ0wdL
         vLbAI787BTO1CnhGaYH5P8SWQsNPi4JEdgnQmdrOF3dJ0ursY4gp9jkh/lStC34cwyTz
         DKvDc2owlUaAXcIPhfitDkB35PTTMNrX+pNwz+Oqf7fZQU7fijH9mKvieoyJ+/fmSA/n
         0F9g+/qSCKJcoe2asIC1w5PbFgz9Dp+MVLvtPAPEeqWNEUtXKJxn0ACuBamVie0oocIR
         zvhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=F59SUfYeyQQX4JGyCTCS3BzaOvVCAmTejwx5MdGi9kw=;
        b=ApNzK8die+Q2U1P6Uf9pB1VguQnMajz/KIlYOe3rz5AdtVGNWuVx9y1yxGi0ZlYpRZ
         Z1Vuja9U45KL1C6NaW/gX15LSAwSEYG9RPLyE/Y3yzPgIF9v7nlr5ah10jQbAOyvQxC8
         axLkQuUo8W3E0XxEMUWKw3/ZfMu+8NWkVOFyw9pfK+o4KZo5MvcKNKEnfv9Cp+mdjH/R
         keupVKWQjF8S1n7PJZEduM7rikQcBfpmqJYHJ2RtbE1ssZEO6xGedxBloUHVnV0ba+ip
         U+SKYj0dYRo9kMvGLh7bqjfUF+EfDb/k+7ajI0gOiQYcFBIuLHFvNF8NcyWCNunhu2jO
         FQwg==
X-Gm-Message-State: AOAM532/JyvkQ6CGI16FH8c9baRDiBO1QMmUkTwc7wIjImDEwYO06fyr
        DXzwvU2n/IsqkLXRfTcOkYF5q3nloqzqkw==
X-Google-Smtp-Source: ABdhPJyqSi4+szrsiGV1cLDxSa67FA1zO/dVXnKSXmq3y/nqbXIin8wubkV9XZLHyxOwoLwuBYx7HA9HcksXgg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1009:: with SMTP id
 gm9mr10872570pjb.223.1643850076760; Wed, 02 Feb 2022 17:01:16 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:38 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 10/23] KVM: x86/mmu: Pass const memslot to rmap_add()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

rmap_add() only uses the slot to call gfn_to_rmap() which takes a const
memslot.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 48ebf2bebb90..a5e3bb632542 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1607,7 +1607,7 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_add(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
 		     u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
-- 
2.35.0.rc2.247.g8bbb082509-goog


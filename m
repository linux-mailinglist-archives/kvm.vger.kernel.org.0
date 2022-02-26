Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BB94C527E
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240678AbiBZARC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240356AbiBZAQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:16:52 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC3C2255A3
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:13 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id b9-20020a17090aa58900b001b8b14b4aabso4096199pjq.9
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Woj2Bw+oml/iasKr9ZaRbac+/ftGLH0xOnzbgL1A7dk=;
        b=Qc+tUkr6gYwZ0XsOSuNXU7xpgIing1CxAj5rs++waMqJEzVClUQdpUouf6Qt2rl1ol
         vOWyv9mL3UgLXppAyVZC96Yc/Lrw/ldLrVMXmjVLugkwxdOXizRLOv1CMgfTRMprPriF
         LEEYfdtQbBo2m2mh86pMjWbhd282X+lOMJ/GSWqjH9CpyoGKiSsUJk5vcIf6V8YO7TdK
         LK2FRoMOm2vFXsKXYmgueEECx5xv+zJuInoHleR13aEgu6lz5OhzcsOzDSGUj/NTrtLp
         2h8JtOzzt4KAcE8dZmU7wjrpQrp6j8k53yXXzQ6CFEa0l0mZRmqAWirOD9wVur1toO7L
         i4ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Woj2Bw+oml/iasKr9ZaRbac+/ftGLH0xOnzbgL1A7dk=;
        b=NuwgMC+Q6xuqXQo4NJ78nrgdLsJzA63eNpiEXHydifE/RthLfN3brAGpFPuycs562w
         PJXz8EyxtORZQ3sRf4hibyrQuKT/ggB3xjw/2m4wsG0m0aamjSnD7oziFnem8hSLxEB1
         sIvR6Jm5A6NlCrxWUWscSbGQcoAomqNOb512vMko/mkTnXHqbLNDZCA1CwNByvpIZVRL
         Nlh6pE6Tb+8Avgcb87VRaNwqrTzQT1lAnn7ilv0KCK1U3PJl8NEdieaOX/fP0EyzBe99
         bp5vLyWX6GCUtHxEpj1GmrS8hIHPogn8aodxbW2cXy6K942o8URT7KH/0NGMXXGrYx1F
         WUHw==
X-Gm-Message-State: AOAM533K41AdhLyQ6BQXuZ2yHcWWwmjd0NzxdGAglPEJA47jPJ/uf36z
        9141D6UiItk/KcX1HFjZKuflyMdwb/0=
X-Google-Smtp-Source: ABdhPJyUX5t0pyzj0U7YymUOkbyXueWsC8h5DQRNC1MHthdGoUFXbAdU/nG2klZ1iOz8qYIOT4ryBLb1KLQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:85c2:0:b0:4cb:b95a:887f with SMTP id
 z2-20020aa785c2000000b004cbb95a887fmr10094149pfn.74.1645834573211; Fri, 25
 Feb 2022 16:16:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:25 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 07/28] KVM: x86/mmu: Check for !leaf=>leaf, not PFN change,
 in TDP MMU SP removal
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

Look for a !leaf=>leaf conversion instead of a PFN change when checking
if a SPTE change removed a TDP MMU shadow page.  Convert the PFN check
into a WARN, as KVM should never change the PFN of a shadow page (except
when its being zapped or replaced).

From a purely theoretical perspective, it's not illegal to replace a SP
with a hugepage pointing at the same PFN.  In practice, it's impossible
as that would require mapping guest memory overtop a kernel-allocated SP.
Either way, the check is odd.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 189f21e71c36..848448b65703 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -505,9 +505,12 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
-	 * the paging structure.
+	 * the paging structure.  Note the WARN on the PFN changing without the
+	 * SPTE being converted to a hugepage (leaf) or being zapped.  Shadow
+	 * pages are kernel allocations and should never be migrated.
 	 */
-	if (was_present && !was_leaf && (pfn_changed || !is_present))
+	if (was_present && !was_leaf &&
+	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
 }
 
-- 
2.35.1.574.g5d30c73bfb-goog


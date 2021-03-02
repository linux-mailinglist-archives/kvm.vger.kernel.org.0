Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C85A32B582
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379939AbhCCHR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381232AbhCBS4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 13:56:38 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B98C0611BD
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 10:46:06 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id h126so17687863qkd.4
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 10:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=pDw5a8xkwlwJrFheedicuJ7ZkUuVv2t+v7LNaWJm4Dw=;
        b=Ygk5jcCgeatzea90Rb8bzEwERdMBWJFL7meF/8n+9C1z76ccYNoc3o2KHJs49c9YS9
         +rED1LRhDhhfZQrVJkSnnRdejrl1l/JXRTuDtcFlvwFXdsr6wWnOW/xNRcHG8+WBe4Yb
         WSUWTNcl7oNaDRe8m2fCdRaYBmA1vX0xKIJA/cCqU1oHZ8fnhVJPmR7yDURMfrk9M0z0
         bTdi/oemt2W0JE3Qu6l2YHFXzLd5nJ84yxHKqXrQfB/seJYeJ1osrih0tN+q0gmF6i1r
         1RzQGwI6nk4DVdJ6a1GDGTSLqYs/gkZ2qFom4DxeaJDP3wDuxXgXxo1D0vc0eT6FZ0+L
         byLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=pDw5a8xkwlwJrFheedicuJ7ZkUuVv2t+v7LNaWJm4Dw=;
        b=NRDSSjQ+LzyJ40Wp+yc1N39NVkkn2Od5bN0bdr8kicggPlEmX1zJ9XcOYH0Rhp0Tsi
         J9F7LfhazsCR3fvCNi/wdJgw4dkb86t/kdm5DssTA03uHUnAjcUOL3zp3Bvam3zdHQE3
         hFEmfq9XHVqxon4XV6/PtzNmC9guzz6Q8l5qY1Pe/P8gyLMj0nb70K/G1lKcJp/TIflP
         2m+8t4gGjFJezljBFoHivOZtEvf2+tKxGDKEVWALK7kbexwlR2tSkzMldwUApYlwnu+P
         /5MrcGA0ueQ1hHxbSc+J9EV9iIb4+Ikrw0SS1ko358BQYU/VjEv+PlB/kNhLY1XuAYHA
         XF1w==
X-Gm-Message-State: AOAM533Pc1TJJme9l76q+jCMy3OihiTNOK9kJc9fu7BSDqIlfTWuOBKV
        id6ur8T8dB7qhYKyoB4fGQxP2W+VNRE=
X-Google-Smtp-Source: ABdhPJy3aPjJhvDHE+DIXi6sA+MkP5OXW5n7T3/Tf9elJsyZ3fz2ZUT3gXs7k0/Itw25dW+LTYzmWA5qGC4=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:805d:6324:3372:6183])
 (user=seanjc job=sendgmr) by 2002:a0c:b7a1:: with SMTP id l33mr20824163qve.17.1614710766083;
 Tue, 02 Mar 2021 10:46:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  2 Mar 2021 10:45:33 -0800
In-Reply-To: <20210302184540.2829328-1-seanjc@google.com>
Message-Id: <20210302184540.2829328-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210302184540.2829328-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 08/15] KVM: x86/mmu: Set the C-bit in the PDPTRs and LM pseudo-PDPTRs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the C-bit in SPTEs that are set outside of the normal MMU flows,
specifically the PDPDTRs and the handful of special cased "LM root"
entries, all of which are shadow paging only.

Note, the direct-mapped-root PDPTR handling is needed for the scenario
where paging is disabled in the guest, in which case KVM uses a direct
mapped MMU even though TDP is disabled.

Fixes: d0ec49d4de90 ("kvm/x86/svm: Support Secure Memory Encryption within KVM")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 59b1709a55b4..ddf1845f072e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3251,7 +3251,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
 					      i << 30, PT32_ROOT_LEVEL, true);
-			vcpu->arch.mmu->pae_root[i] = root | PT_PRESENT_MASK;
+			vcpu->arch.mmu->pae_root[i] = root | PT_PRESENT_MASK |
+						      shadow_me_mask;
 		}
 		vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
 	} else
@@ -3303,7 +3304,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * or a PAE 3-level page table. In either case we need to be aware that
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
-	pm_mask = PT_PRESENT_MASK;
+	pm_mask = PT_PRESENT_MASK | shadow_me_mask;
 	if (vcpu->arch.mmu->shadow_root_level == PT64_ROOT_4LEVEL)
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
-- 
2.30.1.766.gb4fecdf3b7-goog


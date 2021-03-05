Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BF432DEE0
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCEBLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhCEBLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:30 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31966C061756
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:30 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v62so660711ybb.15
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=n1g7YcfBRqOyuIXQ+DlBk/rdIXAZ4MTBjh9mK1MAaXk=;
        b=LDFQJveapvxPIH8Hc01b156PY3r2JYw4k5ngF4S8WpkiyW1fiJXfMwTHSjeIJ1dAms
         f1Qwk0mF3tIAx4iBI9PnlYNVQr4ypv/40b5dbfPwpD92HUUq7fo4WOz345/HU+tDgdut
         budOqXEnUTo6uW/OGFgHRI5PwPzBCEx46YugRPKfO6QCOGsyK7Cp6zRYZ6WCrYsRvEPp
         da/4mqv1rdMjid+3mXZfuXYK8IK2eB0s6L/A3XVBNFemGAdAzHV6C+T9WCyumhypTdlq
         vwrjeDg7U3Qe3X12eCPsvQp5Xg5Asc5mzO0ibxXxtzvlxjQs2/4+OVYWgsjf9MCmXkeM
         RGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=n1g7YcfBRqOyuIXQ+DlBk/rdIXAZ4MTBjh9mK1MAaXk=;
        b=qfcg/bzzbv1TSbe5TQ8C9IcTP/CXpVX6TSqTMtM4P9xxdUXlpliy1sdJ1e6y9tMcj9
         NNPYrB5T0/OnFVMIbFG1ZdGP0zIMtw+ZMyUZflI7JZjfcDa2X30Zpk+wzYGMFW5r2lj+
         ClJY6+wqfF/PNidmCpEvutCVhf6+SEVX7NjwHEG3FCqITl0Gw/AYi5rXrzyv83MAJ85F
         RK9FG4fpDG9JzdLdx4goYmpmjq5MyILq/xA2TCkRw0R9LR83IotJ0QSrm7CJnzUZY/SW
         nvwyBapqZrDac5cZ258v0g6Ijy7LiWN3gQTXVES+w3l7WsIeyUtgEdyhlHTjl+1xwfqf
         wONw==
X-Gm-Message-State: AOAM530c3qzcO0PMn79jzywscrRSNtuhtAkayS4FNoVTzt3aQvueifJ4
        z6vgd/YcP5sRYX8WEVunLp6+VuMjVJQ=
X-Google-Smtp-Source: ABdhPJxgkDxhai+YpmKJqz17AH7bQtZteIjFGAKP9YfF8FUCjyTPQoPpaAozUutt5kH0YAiYyfyaTn+NGUE=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:9706:: with SMTP id d6mr10302184ybo.139.1614906689458;
 Thu, 04 Mar 2021 17:11:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:10:54 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 10/17] KVM: x86/mmu: Set the C-bit in the PDPTRs and LM pseudo-PDPTRs
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
index dbf7f0395e4b..09310c35fcf4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3257,7 +3257,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
 					      i << 30, PT32_ROOT_LEVEL, true);
-			mmu->pae_root[i] = root | PT_PRESENT_MASK;
+			mmu->pae_root[i] = root | PT_PRESENT_MASK |
+					   shadow_me_mask;
 		}
 		mmu->root_hpa = __pa(mmu->pae_root);
 	} else
@@ -3310,7 +3311,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * or a PAE 3-level page table. In either case we need to be aware that
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
-	pm_mask = PT_PRESENT_MASK;
+	pm_mask = PT_PRESENT_MASK | shadow_me_mask;
 	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
-- 
2.30.1.766.gb4fecdf3b7-goog


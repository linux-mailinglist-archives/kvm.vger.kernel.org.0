Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A8B45C4A1
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 14:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354371AbhKXNu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 08:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354190AbhKXNs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 08:48:58 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DF8C04CCA6;
        Wed, 24 Nov 2021 04:22:14 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id o4so2412614pfp.13;
        Wed, 24 Nov 2021 04:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OXQJ/Hg7JktHdh34i19iwQxJ93YDj8UHhHLVZ7kWpcY=;
        b=XEi4y/CAQgVlQVCvCubc1j39iVAT/KctP+Zr+IKXxwujt30nlQVOPkresY6/jtkF2t
         f4AfqIJLxHQ0czBKFg7m9gAOPskFijLKFcO21vfPmhsCZ6pHbnrU5Sp9ug4RdqTIfgY3
         iCpYXt8C6CpnC3gwuIFK4bG7D8bdayvB/Kg0dmfemjZpCg6zm3FrjpBhkvb47j73NDd0
         QU6ZaHr+YraYS/I9lYWdV7RE4O2Z9cLJ+JUY1IUjf8zHEMWkoICsFbhI5GF6RmCNi98O
         pV7aI1BpjBB1SiBXG5MZvWngcbKliSX4E3tdGR/ZzIl5eHV6GNhU5aWVf+xXaC2KSEqX
         1MLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OXQJ/Hg7JktHdh34i19iwQxJ93YDj8UHhHLVZ7kWpcY=;
        b=6/QnUzx0eJScdTl7fnOYOblLLGqJQtXWbrsxDZlxzfGynwCWw+gs40SN3KMjdha1Lj
         ZPM/sIau2OuuKnjx4DytAlpB8PmPIVhs/PBhLvGxgV1EFv5tACfc36yIpltbm/cMGZqm
         HGoKKzsKyZF9yjPX6nG89PP2VDgVHEysSTo0qfMvmGBAPhYQbmOmshxw9Yv1vP2WCDRw
         TQF9B8DuXrHaUWKUq8iGGq7vSdXx9xxZiybwkTHWZYyDNgAktFR/Vm1W0NWSpj0lr7Sr
         LjmDMGIxLPEU/JTNhDWLHEY8OW1aDEVrFXs5yKaPexNYmsqjik5d6RZ7JSYnUBmsVdl6
         s3dw==
X-Gm-Message-State: AOAM530jgPAoGTGkNIC4EhS55BBqavKImev6bK3y2AMZf8Ts/dfgBTT7
        teuiYrfDQFSUcgNkeMLK9jvVip+gyjI=
X-Google-Smtp-Source: ABdhPJxxXqJmN5iCp4ZmgmlA4C44r8063lAnHxAVKEynSAwi+2QYkAON4RiveU4qNwQM6ZOj2W+XjQ==
X-Received: by 2002:a05:6a00:1584:b0:49f:e5dd:f904 with SMTP id u4-20020a056a00158400b0049fe5ddf904mr5654163pfk.55.1637756533595;
        Wed, 24 Nov 2021 04:22:13 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id t13sm16416367pfl.98.2021.11.24.04.22.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 04:22:13 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 12/12] KVM: X86: Walk shadow page starting with shadow_root_level
Date:   Wed, 24 Nov 2021 20:20:54 +0800
Message-Id: <20211124122055.64424-13-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211124122055.64424-1-jiangshanlai@gmail.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Walking from the root page of the shadow page table should start with
the level of the shadow page table: shadow_root_level.

Also change a small defect in audit_mappings(), it is believed
that the current walking level is more valuable to print.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu_audit.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
index 9e7dcf999f08..6bbbf85b3e46 100644
--- a/arch/x86/kvm/mmu/mmu_audit.c
+++ b/arch/x86/kvm/mmu/mmu_audit.c
@@ -63,7 +63,7 @@ static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
 		hpa_t root = vcpu->arch.mmu->root_hpa;
 
 		sp = to_shadow_page(root);
-		__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->root_level);
+		__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->shadow_root_level);
 		return;
 	}
 
@@ -119,8 +119,7 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 	hpa =  pfn << PAGE_SHIFT;
 	if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
 		audit_printk(vcpu->kvm, "levels %d pfn %llx hpa %llx "
-			     "ent %llxn", vcpu->arch.mmu->root_level, pfn,
-			     hpa, *sptep);
+			     "ent %llxn", level, pfn, hpa, *sptep);
 }
 
 static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
-- 
2.19.1.6.gb485710b


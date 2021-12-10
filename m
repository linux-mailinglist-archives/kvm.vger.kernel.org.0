Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FF446FDA7
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 10:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239276AbhLJJ2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 04:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239302AbhLJJ2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 04:28:41 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEADC061746;
        Fri, 10 Dec 2021 01:25:06 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so9012899pja.1;
        Fri, 10 Dec 2021 01:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OXQJ/Hg7JktHdh34i19iwQxJ93YDj8UHhHLVZ7kWpcY=;
        b=fU2nXCsApe/3mCyooya6n0VD2eRdIXO2pUNaXsJi7xEWVoO831aGa4kaRjjQnGGd01
         SVWcOZ2eVdEakq92lJyRqLHA5ccAMIEIFq7Yt0zciUksBgH260IVa23EO8UZ08PJ6KfY
         m3CmJgFrZgysYcsS992yB5Z1+7tIjHhtnSl+7VGwpnrYodk823R3gBeO9uPJM/DCzdew
         H0QSAIPf0MH8bowQ05O1gHU4yYCeG19WQDt/NNQLLdZKU7IolEE39X1qbnKbxCcZLRdZ
         j17AXI/mSOdNiecVsO7U1xJhj0KhkFlnIqPN9OORiQLQlQxWQ6YsjNcfWKqtMCD9iP4H
         FbrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OXQJ/Hg7JktHdh34i19iwQxJ93YDj8UHhHLVZ7kWpcY=;
        b=aqh9VNKUE4zhAJ6uErwrbCl4/4nBrQ/JVPhHRjyS+Z8InXMk3R/zQ9+5lFuKMNz3M1
         SDYaiy1ku81S7TBziFmULEO4B/2wMHo7RgzrPBH5B14TaWwrIEvjmw66dX4LrgjTySOg
         FQAOew/qkASzRd0BT7Bjh1NbXWDnmXaJlB+ozfkQpOSDmBIm1X27MqxnexIC+T0yOP3y
         o3dANeMTN74eiMHVWbKaDua0xf4IrPTwn1Kb1PrtE+DoTTyheMVOlsRqgcwVokdT9xJC
         rFtWisyP6J1dbqcbXH7nTIiT6HAK5lzuctoInzdQ7RR/FQMYXb/jNEcguda1mQTg1gnM
         xmZw==
X-Gm-Message-State: AOAM5307/BPlXewCy17VScaD3uQAR5kbYtcn9PQnYDJ6cyyG0Y/dyv3s
        d18/tUbr906d/7rkpBQydDdaA/H25pA=
X-Google-Smtp-Source: ABdhPJwU+aBVNFa/r7juu0zc9fpwzSgkply/NwhH6eXjyaJq2j5gXQxwO507ZXLkQAu+n0wR4Ta+1A==
X-Received: by 2002:a17:903:24d:b0:143:beb5:b6b1 with SMTP id j13-20020a170903024d00b00143beb5b6b1mr74487937plh.54.1639128306355;
        Fri, 10 Dec 2021 01:25:06 -0800 (PST)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id f4sm2657482pfj.61.2021.12.10.01.25.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 01:25:06 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 2/6] KVM: X86: Walk shadow page starting with shadow_root_level
Date:   Fri, 10 Dec 2021 17:25:04 +0800
Message-Id: <20211210092508.7185-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211210092508.7185-1-jiangshanlai@gmail.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
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


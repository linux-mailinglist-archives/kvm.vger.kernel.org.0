Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3886C3EA674
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 16:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237971AbhHLOWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 10:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237968AbhHLOWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 10:22:08 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEDAC061756;
        Thu, 12 Aug 2021 07:21:43 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d1so7502241pll.1;
        Thu, 12 Aug 2021 07:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sfjh2TOrUQjWKK1WuaUcVyTMXiq8ArXgrYRkmZfmijU=;
        b=FhCvezG0085J3wxcSiEtYzUXKlFc5dQ0hhlsg9IzzwYxm6PyVzWBfvD0MyZ+KWh7HB
         Kyqoyddjar3UeuL+cpRXbIApFYRqd0gaFZaDgAudKc3UY625P7GXW2iTi/pmFaTXH7o5
         iTMwNhRZLZgkqylizFg740UQxaP5flSrJW007zDgERXEREMxeG8J2lH/fTEsVxwnmzu0
         jm38Ke/bNRBb8JoAoSH/TGR/VLXVN+CqMzuGJj9U9Fn+u1Ht52961SVp0bYp4byNwdlv
         0yD1vQwlvnA/vr1ZS95F3RSMgXIE0D7yDAtw763uTbsacHpl0P7QR7bXcdoTN4vmqIra
         E5Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sfjh2TOrUQjWKK1WuaUcVyTMXiq8ArXgrYRkmZfmijU=;
        b=tX17akt4arQJ5PdLPiMoSECUXGhgqmI75UBSP8DqZDBYym50ERRCUvoygm8DqL1W7L
         WqK2BLxR6FYm7D93oeB7UGgWXxw1DjyjOZAMsEUVLIhKo3OoRb+3D17ekFbympi0P+QI
         ZFmar37sWSVLHBXSFJpyV+eJ5hqpLd5iBNFUStr6JdTa0hw555DLeepoCW2gsurZbJrg
         1GN1AWzWXPX6lVyI4y/19comw2XzQJ9/07VDyFhB30e9LAt5EKouAOXHYoECEd4cOsRK
         usAZuu1OXqXSPY6Ff/RkO1gUI4jiCYYxWThsOhNvRHWk5LRJEuOr7jqB6+3iqhvQu8Wv
         IMwg==
X-Gm-Message-State: AOAM531kCBDFEn/q1X/gNGah2AhvsNkmvJMN4A++YTlziY3JxpHYWMDN
        lFfLwK9M8XbGviJho5MgfuNwa/FWhY8=
X-Google-Smtp-Source: ABdhPJySJPZUuNQ6WNcFx1/Dn2zORy43XMmZhsxk3EmGeYBs8yTi58i/+NjWG7JrUlAauljrBHgJcA==
X-Received: by 2002:a17:90a:d711:: with SMTP id y17mr4560278pju.74.1628778102743;
        Thu, 12 Aug 2021 07:21:42 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id g3sm3582841pfi.197.2021.08.12.07.21.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Aug 2021 07:21:42 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH 2/2] KVM: X86: Remove the present check from for_each_shadow_entry* loop body
Date:   Thu, 12 Aug 2021 12:36:30 +0800
Message-Id: <20210812043630.2686-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210812043630.2686-1-jiangshanlai@gmail.com>
References: <20210812043630.2686-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The function __shadow_walk_next() for the for_each_shadow_entry* looping
has the check and propagates the result to shadow_walk_okay().

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c48ecb25d5f8..42eebba6782e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3152,9 +3152,6 @@ static u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
 	for_each_shadow_entry_lockless(vcpu, gpa, iterator, old_spte) {
 		sptep = iterator.sptep;
 		*spte = old_spte;
-
-		if (!is_shadow_present_pte(old_spte))
-			break;
 	}
 
 	return sptep;
@@ -3694,9 +3691,6 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
 		spte = mmu_spte_get_lockless(iterator.sptep);
 
 		sptes[leaf] = spte;
-
-		if (!is_shadow_present_pte(spte))
-			break;
 	}
 
 	return leaf;
@@ -3811,11 +3805,8 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
 	u64 spte;
 
 	walk_shadow_page_lockless_begin(vcpu);
-	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte) {
+	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte)
 		clear_sp_write_flooding_count(iterator.sptep);
-		if (!is_shadow_present_pte(spte))
-			break;
-	}
 	walk_shadow_page_lockless_end(vcpu);
 }
 
-- 
2.19.1.6.gb485710b


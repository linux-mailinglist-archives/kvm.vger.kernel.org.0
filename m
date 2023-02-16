Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B711F69A2AD
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 00:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjBPXwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 18:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjBPXwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 18:52:42 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E626E595B6;
        Thu, 16 Feb 2023 15:52:37 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id m2so3845156plg.4;
        Thu, 16 Feb 2023 15:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W618oeFBR26jFkCOGW2ktI8DuH0UezwdqqlJmNvjLzY=;
        b=W8Wgzlc5HTDOQZd3tXWZTJ1tVwWTSqV2FA/0SkeXX3P+Ec3FBA2DrpvHPha60g7OVi
         CZd6pNFACqU1zxZgUFAN/4g/qFH+TIotx5ub40Fx049NbGnSTeLzQg+p6oiQaqbc5dO/
         wUd/Wu01jZp8pEi8EFB69Qt6DmfuRPeqFpBWYFPMwmbs0chvwPiGADZEHP6d8DhULJkV
         4sm+ExbagRV0dQ4qlarHsvdqEPuKXssuJxT5sV1UVYsWdigVv11i2TBolVLD4c3vH2kM
         JW1w7IeTiqUxLs4RKJ2B/1TLjTrP4U2c32WTJMyJij4q4XVrfO/7xff37MZIwL9wDQsQ
         RfEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W618oeFBR26jFkCOGW2ktI8DuH0UezwdqqlJmNvjLzY=;
        b=S1aIf/7ccC0Hx5iNSVGdQNsY1uJxYasIhT6KlfvTiO6sUsd8A16ZHqeqY/VenYjwrS
         eh9o70bfjg0EUGOruEVyzUQrBdFqpeS+SrjGwRvOtsIvwT6GSQHFfdA8Qc9xFmj+Y7AW
         utm7LL8ZexQxh3w4v2ktVmGT9xEZzoqJgk3Ae6Yu5l2dyXL513K/i5ZiIj+OuqiJmaDD
         utPnoamd+9RCsjERWw7/cEQQp9SZlVFt7sqdff0tUwvIsRrpjcic5hgeP+DghTb4zNOe
         s6loVhliLquIB4zGrJPP2YGoBjkyWmMbw4n3XBmI+Mb0UZ3ArosxxD6vK85bt0KDy4u4
         DUtQ==
X-Gm-Message-State: AO0yUKXXUBQOPBfPMvqJ3MA7RFipvpLVPj4RRy/5Pu3YJ/oaP4f6o6vq
        kzr/5+eA1X8Bo6F7Zf0zg0pk7F19Bww=
X-Google-Smtp-Source: AK7set/aWiGJ0dUGJCFPTjIYBIEXTk7bEenkR3qz9ZJyaZqfTVdFKlnQ4suDVT1bGqaKq4a9EU7Msw==
X-Received: by 2002:a17:902:e888:b0:198:e1b8:9476 with SMTP id w8-20020a170902e88800b00198e1b89476mr9154576plg.15.1676591556678;
        Thu, 16 Feb 2023 15:52:36 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id 6-20020a170902c10600b0019a8530c063sm1848175pli.102.2023.02.16.15.52.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2023 15:52:35 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V3 13/14] kvm: x86/mmu: Remove @no_dirty_log from FNAME(prefetch_gpte)
Date:   Fri, 17 Feb 2023 07:53:20 +0800
Message-Id: <20230216235321.735214-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230216235321.735214-1-jiangshanlai@gmail.com>
References: <20230216154115.710033-1-jiangshanlai@gmail.com>
 <20230216235321.735214-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

FNAME(prefetch_gpte) is always called with @no_dirty_log=true.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index fca5ce349d9d..e04950015dc4 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -519,7 +519,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 
 static bool
 FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-		     u64 *spte, pt_element_t gpte, bool no_dirty_log)
+		     u64 *spte, pt_element_t gpte)
 {
 	struct kvm_memory_slot *slot;
 	unsigned pte_access;
@@ -535,8 +535,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
 	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
 
-	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn,
-			no_dirty_log && (pte_access & ACC_WRITE_MASK));
+	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, pte_access & ACC_WRITE_MASK);
 	if (!slot)
 		return false;
 
@@ -605,7 +604,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 		if (is_shadow_present_pte(*spte))
 			continue;
 
-		if (!FNAME(prefetch_gpte)(vcpu, sp, spte, gptep[i], true))
+		if (!FNAME(prefetch_gpte)(vcpu, sp, spte, gptep[i]))
 			break;
 	}
 }
-- 
2.19.1.6.gb485710b


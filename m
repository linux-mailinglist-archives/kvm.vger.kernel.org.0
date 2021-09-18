Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E528841027F
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 02:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244946AbhIRA6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 20:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243226AbhIRA6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 20:58:49 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B4EC061766;
        Fri, 17 Sep 2021 17:57:26 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id g14so10782644pfm.1;
        Fri, 17 Sep 2021 17:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vCtWUpjznOPCx64IjyJAYKRRtTFfsaLvDBezHp1+q7w=;
        b=ESQnvmjKaGYPzGqT4QgPrYFVgNh0VBSC9I962/dp8hme/0f1lpDyK3YbMWGW1ljrTO
         vv5EVHDbJvzjOeECMO+WLoBTf+vFizuNbp6BdGp52f/IRBErU8/Bpa30brmiqax4TWrt
         YhB98ytQUgUcJlkDXRJXuxixWgDkR+CMDY2zVUPJKFyKvK7anEc37Ov+79bhVdq7bphP
         VUsMaZjn64uskcfHMekLAXQXbxRzacjURuvVGj0u7p2oJmJqCaZg8wNehasVOpMPOjNa
         BqhEGL4Ctp0gg3jCGmNI2YcNAscxeHtJbexReeUu4hhkyOaRFVMvG0b2FNeaPvIPyU0j
         w9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vCtWUpjznOPCx64IjyJAYKRRtTFfsaLvDBezHp1+q7w=;
        b=pyA29+t57Mn1ncl882TThF+AOUTK7BK96/ctnXDE1+k2CT9KqqPirrSIDJ5OPH5DON
         mV9+FVwy5Z1DKk1o6zCOY9If/MNUSA444OeyGa+GNfqFx7RhTBZTOCJ2IhBW1lkiyASU
         /epahvJYhTlJW7p0FMVzn7VSSUmEfYXzANO9Hv+iY9f8vL0NdADLvLVz0hev582v1ty3
         5R3xj7dAhuVS9UGjd15UdjCnE3jEZCqeeZuZKWrpVDR7ujvrhEEXy8kHzyPZpfliEOF4
         eXCJjH8hEIH8udiqzhV6G/dp8EvKZcZssmRGVWfcjCjfVOiGQi2EueaElb0B9m/3GcVJ
         74RQ==
X-Gm-Message-State: AOAM530mhRmb+2mYM9K1MdEQKu3+d937Cj8GzQzXtny45lJcQyLhcLEX
        YDmPFF2+KIF37pp81+lgb0Uzlp6Z9i0=
X-Google-Smtp-Source: ABdhPJy7X8mZJQnJbufUi7d86Ijo7iELmpnS9ALzzkNy89/yA05fNTrEpr1LZiWak3Qg/lBUHrlnnw==
X-Received: by 2002:a63:1f45:: with SMTP id q5mr12136728pgm.385.1631926646013;
        Fri, 17 Sep 2021 17:57:26 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id g13sm7402390pfi.176.2021.09.17.17.57.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Sep 2021 17:57:25 -0700 (PDT)
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
Subject: [PATCH V2 08/10] KVM: X86: Remove FNAME(update_pte)
Date:   Sat, 18 Sep 2021 08:56:34 +0800
Message-Id: <20210918005636.3675-9-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210918005636.3675-1-jiangshanlai@gmail.com>
References: <20210918005636.3675-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Its solo caller is changed to use FNAME(prefetch_gpte) directly.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c3edbc0f06b3..ca5fdd07cfa2 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -589,14 +589,6 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	return true;
 }
 
-static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			      u64 *spte, const void *pte)
-{
-	pt_element_t gpte = *(const pt_element_t *)pte;
-
-	FNAME(prefetch_gpte)(vcpu, sp, spte, gpte, false);
-}
-
 static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
 				struct guest_walker *gw, int level)
 {
@@ -1001,7 +993,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 						       sizeof(pt_element_t)))
 				break;
 
-			FNAME(update_pte)(vcpu, sp, sptep, &gpte);
+			FNAME(prefetch_gpte)(vcpu, sp, sptep, gpte, false);
 		}
 
 		if (!sp->unsync_children)
-- 
2.19.1.6.gb485710b


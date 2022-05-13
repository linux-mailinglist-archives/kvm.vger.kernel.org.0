Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D5A526AC0
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 21:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383944AbiEMTuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 15:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383922AbiEMTuJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 15:50:09 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97247F06
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 12:50:07 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id u18-20020a170902e21200b0015e5e660618so4820748plb.5
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 12:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=51ScGZpVXrpwP8zcndNZCQ8uZliM4Ji/XP53Uo8OU7c=;
        b=j65xlD3FgP3cwD6jdEtK/k0irKvl3u34nvb+fENpKx7/Pcs7SzxyfhDiSwPYBcvHxJ
         HYJ2voD13w7N6L1l6I69WEiM5Hrozw8ivVZPMHKXjOIe90SuRgU4IXtBJThlMjw+eyPD
         P6wrRsq4YlPMIx2IgQcJPGlGjEMQqR1x9oEbDulKOTO4JtU+TWvysOrILvewjIxNUIyw
         p9aMG6UykrJiH4/mYigct6kjHbDAcucevzWrBePGB6+GNPHLxiY8Mum/B0/ZNJo2gwYw
         /+SmiSE2cflOGmeZEobDDchNTXi6SqwOpaA5d/NPZair8IqZocIdW0pwx7tkYMUlkkjS
         5i6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=51ScGZpVXrpwP8zcndNZCQ8uZliM4Ji/XP53Uo8OU7c=;
        b=dMz+3o3dEkVRywp3p2oKCUEJRvt93HZ99F1xjoVf4XzkICyJbzvzwjvMLcNTCDqnkw
         COH2YRPZo1SSDCqsUgt8zEqHFl7KDzuPfLaeHvA41082g46EjRIJXUNWIgUzOY5bq4zN
         7ySajSeeDIfybwl4NgJQX5kMkkbkp//EFPZrBIIPZMThwIohHuaL2I1ALVjxWvNCMn4K
         vaGvUIFtMzjt/hY4kPCIh++P7IFNOdAqmjnqliu/4Zm0TwVr9yWth73oYIjsVnSEzawa
         DQXWxEa8rK2BGwsGnk+XDGfBzWKP/GGAJmtqadPFthyB1ULhQ+pkN0nVqnYvoyxXlEV0
         wlNA==
X-Gm-Message-State: AOAM533NcXhAnNjjy7xHFO3q5vln8TIVu9GN1scDGa9ItP370Y5StjuG
        85m/Cpb8Km3Sps7wr2YFOJCVz3rzgww=
X-Google-Smtp-Source: ABdhPJz/h/xLSJx/qn1O26fEwkmhQHGdtzjlcAYDoxIRSXTdCQEW9PB+Gzzlt3ezB+fSJoVioL9GOBDPTXU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP id
 t16-20020a17090ae51000b001d9ee239fa1mr250408pjy.0.1652471406612; Fri, 13 May
 2022 12:50:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 13 May 2022 19:50:00 +0000
In-Reply-To: <20220513195000.99371-1-seanjc@google.com>
Message-Id: <20220513195000.99371-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220513195000.99371-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH 2/2] KVM: x86/mmu: Comment FNAME(sync_page) to document TLB
 flushing logic
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
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

Add a comment to FNAME(sync_page) to explain why the TLB flushing logic
conspiculously doesn't handle the scenario of guest protections being
reduced.  Specifically, if synchronizing a SPTE drops execute protections,
KVM will not emit a TLB flush, whereas dropping writable or clearing A/D
bits does trigger a flush via mmu_spte_update().  Architecturally, until
the GPTE is implicitly or explicitly flushed from the guest's perspective,
KVM is not required to flush any old, stale translations.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index d9f98f9ed4a0..d39706e46ad9 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1076,6 +1076,15 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		flush |= mmu_spte_update(sptep, spte);
 	}
 
+	/*
+	 * Note, any flush is purely for KVM's correctness, e.g. when dropping
+	 * an existing SPTE or clearing W/A/D bits to ensure an mmu_notifier
+	 * unmap or dirty logging event doesn't fail to flush.  The guest is
+	 * responsible for flushing the TLB to ensure any changes in protection
+	 * bits are recognized, i.e. until the guest flushes or page faults on
+	 * a relevant address, KVM is architecturally allowed to let vCPUs use
+	 * cached translations with the old protection bits.
+	 */
 	return flush;
 }
 
-- 
2.36.0.550.gb090851708-goog


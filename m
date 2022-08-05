Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4774558B29E
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 01:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241585AbiHEXFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 19:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241537AbiHEXF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 19:05:29 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F971147A
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 16:05:27 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e15-20020a17090301cf00b0016dc94ddcc5so2321362plh.3
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 16:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=WLuSlvIJZlcnazsELn/bSEkU+G0vGBR7V6zPFbRjYl0=;
        b=lf0DhdSASK1h/vy4nEBEmemTayzmtWDsnzYMSZwpBW9myRUV58cgyU8eR0d0pC7jTg
         2mepqFjjY6zRmUMexsuN1ybaJtRpI+dCTQ1O1smEHwP03qsrKRWnlfG+6rLsgIS37O3F
         3m9r2tO1Gm4Rrzt4pKZaG0E53Z5YYde4MiY6FylL498tj1bzL+FYjGGdtEA6UngKbnCU
         xvW/iwSC7BT7Hxj1A/WVBFfAgEijmvt5sfhQjHrNuGu+2mIubdVpPQyoijWZjF2im8Tj
         sLAqQAQNOaVcPGkw5MQ+AYfkErKbepIjtd3H77szTo6fZ8ZDMIKAjAH3vr4Us5q/RGwe
         xjRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=WLuSlvIJZlcnazsELn/bSEkU+G0vGBR7V6zPFbRjYl0=;
        b=Ll/No8oC9Q5z0dhve5v7hdmQ3+/+oUZ/+eLtUhjIwHrLXNhr37bEO6BtxC4LwAaOse
         xZXwO1eq9VVT0Kr7XFqjqapUhB7dX/EPJrfDaRm2RcFftYplyhNhAtgQ6Zi4TmuvYqP3
         0UN/FOFBaPYMU1tmV6aqEe12Y3XUOohBNcv0ekzGq+FZEow/xhBGiYHXTVyehfMTh2Wy
         ivn+Bm0NPqL0HSlOX4av6En5x1On1fUQ/zGfimKDs0Qcih63kH48B4TXHhe1+JSAt6hf
         mmKG+rV25IMSXH0b7MPre7N5m7IbMhQepNWhLNhuu8pOQZI7nnDKdv32mVoi6ffpiqVw
         0V8g==
X-Gm-Message-State: ACgBeo0kFhZz1IvLEsbe4E0BQQ7dBHTVz4L/U2I9sAxGepicc6Rv4U8L
        ewpCLw03VEPC3ArFzcjMwacEiriWQK8=
X-Google-Smtp-Source: AA6agR432WEnrCUzqIvmpkhvNwROdM1p7cqZaz4OmRA8YYmCaKpLSXfFcLCkyxy4lyZWKWcPig9qP215a3s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4cc5:b0:1f5:395:6c71 with SMTP id
 nd5-20020a17090b4cc500b001f503956c71mr18623544pjb.132.1659740727212; Fri, 05
 Aug 2022 16:05:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Aug 2022 23:05:09 +0000
In-Reply-To: <20220805230513.148869-1-seanjc@google.com>
Message-Id: <20220805230513.148869-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220805230513.148869-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 4/8] KVM: x86/mmu: Properly account NX huge page workaround
 for nonpaging MMUs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Account and track NX huge pages for nonpaging MMUs so that a future
enhancement to precisely check if a shadow page can't be replaced by a NX
huge page doesn't get false positives.  Without correct tracking, KVM can
get stuck in a loop if an instruction is fetching and writing data on the
same huge page, e.g. KVM installs a small executable page on the fetch
fault, replaces it with an NX huge page on the write fault, and faults
again on the fetch.

Alternatively, and perhaps ideally, KVM would simply not enforce the
workaround for nonpaging MMUs.  The guest has no page tables to abuse
and KVM is guaranteed to switch to a different MMU on CR0.PG being
toggled so there's no security or performance concerns.  However, getting
make_spte() to play nice now and in the future is unnecessarily complex.

In the current code base, make_spte() can enforce the mitigation if TDP
is enabled or the MMU is indirect, but make_spte() may not always have a
vCPU/MMU to work with, e.g. if KVM were to support in-line huge page
promotion when disabling dirty logging.

Without a vCPU/MMU, KVM could either pass in the correct information
and/or derive it from the shadow page, but the former is ugly and the
latter subtly non-trivial due to the possibility of direct shadow pages
in indirect MMUs.  Given that using shadow paging with an unpaged guest
is far from top priority _and_ has been subjected to the workaround since
its inception, keep it simple and just fix the accounting glitch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c  |  2 +-
 arch/x86/kvm/mmu/spte.c | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 53d0dafa68ff..345b6b22ab68 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3123,7 +3123,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			continue;
 
 		link_shadow_page(vcpu, it.sptep, sp);
-		if (fault->is_tdp && fault->huge_page_disallowed)
+		if (fault->huge_page_disallowed)
 			account_nx_huge_page(vcpu->kvm, sp,
 					     fault->req_level >= it.level);
 	}
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 7314d27d57a4..52186b795bce 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -147,6 +147,18 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (!prefetch)
 		spte |= spte_shadow_accessed_mask(spte);
 
+	/*
+	 * For simplicity, enforce the NX huge page mitigation even if not
+	 * strictly necessary.  KVM could ignore the mitigation if paging is
+	 * disabled in the guest, as the guest doesn't have an page tables to
+	 * abuse.  But to safely ignore the mitigation, KVM would have to
+	 * ensure a new MMU is loaded (or all shadow pages zapped) when CR0.PG
+	 * is toggled on, and that's a net negative for performance when TDP is
+	 * enabled.  When TDP is disabled, KVM will always switch to a new MMU
+	 * when CR0.PG is toggled, but leveraging that to ignore the mitigation
+	 * would tie make_spte() further to vCPU/MMU state, and add complexity
+	 * just to optimize a mode that is anything but performance critical.
+	 */
 	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
 	    is_nx_huge_page_enabled(vcpu->kvm)) {
 		pte_access &= ~ACC_EXEC_MASK;
-- 
2.37.1.559.g78731f0fdb-goog


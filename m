Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E53759523E
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 07:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiHPFyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 01:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiHPFxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 01:53:55 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92338307E
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:31 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31f5d66fcdeso80008927b3.21
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=MB2NvgCLGG0Emc0fClW8tEIWowRIBHh6WAc+fwkMqOo=;
        b=fw3dsGJiizlT87PGi7CWs8waLh23OiU+/jFxQMDg05iObRfLw8gFerHxoeY3EHInoP
         KjD0V1AXeA1u5NRT3ykcR85cfK5LEHs6r3STW5pW+r0XTHNV31mICy0YKRdEuIR8BXRA
         i999d6OJEKFZ6F/PkzLj2oxn0ALU5R1ETQTDgjgGUigcsOjrHLa2jYGO8I2EmLEjLxZs
         TbcXPVC1HzieuQQSLtYmt7DfKbTmbQlck0G006jia1cOhSxhAE/pFXUXYYlk/yOgOi/b
         1LQGn4N3jIYqgkR4Zb1dwPAzPJ15+S2I8WKZWrN0h1ukhLvLe3hTK6au7V4pgzk+QwHJ
         hAgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=MB2NvgCLGG0Emc0fClW8tEIWowRIBHh6WAc+fwkMqOo=;
        b=w4S2rK5AQ0sWtj85YeQTt3HQAbhD4MdlFyDM0cVpw/uCZhSJ1jQLPrnBzeUQYscJMY
         mChY/sr2MZA3cW0Ne0afoLYLjSkjWVudgpUeSqPMUUOzihbcoegEYwKJgo3+aR7Ar/se
         rhbulVpuoi+QX+pd9GV+Np+EPJhOO4BBDHsGsYMFGjns1QCgqnvnFd2yrpTqX8paith2
         WXk37RRwF2kgZDWWcYQgKTVmuAhEGuhjRcu39wkV5w8np/5V1tgmTly9McqSdTqYuY+O
         Xgb/IMzxcMTQumxIOcsUTxvSPQSlgo+aNFv+E+uvuOqIyi5ZXge2DPcTdKaPCRraqFdr
         mO2A==
X-Gm-Message-State: ACgBeo11UImXpEHcFAz9WdL4lCh+0EgKBbSx5/CtTwsg5jVgbo5vkUb6
        HBfvfIDGpp9BQ/kaf7tQVouDTkM54aA+sA==
X-Google-Smtp-Source: AA6agR7xXoeUjLWPnarbCguv+OcBx++tQ2t5hCUrN4FcKn9SKMUA622h/1Vmjfe1kjw21jphho2EY1Q/3y3eaw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:1245:b0:676:dd76:e07f with SMTP
 id t5-20020a056902124500b00676dd76e07fmr13909816ybu.333.1660604491042; Mon,
 15 Aug 2022 16:01:31 -0700 (PDT)
Date:   Mon, 15 Aug 2022 16:01:09 -0700
In-Reply-To: <20220815230110.2266741-1-dmatlack@google.com>
Message-Id: <20220815230110.2266741-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 8/9] KVM: x86/mmu: Avoid memslot lookup during
 KVM_PFN_ERR_HWPOISON handling
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
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

Pass the kvm_page_fault struct down to kvm_handle_error_pfn() to avoid a
memslot lookup when handling KVM_PFN_ERR_HWPOISON. Opportunistically
move the gfn_to_hva_memslot() call and @current down into
kvm_send_hwpoison_signal() to cut down on line lengths.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 36960ea0d4ef..47f4d1e81db1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3129,23 +3129,25 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return ret;
 }
 
-static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *tsk)
+static void kvm_send_hwpoison_signal(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, PAGE_SHIFT, tsk);
+	unsigned long hva = gfn_to_hva_memslot(slot, gfn);
+
+	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva, PAGE_SHIFT, current);
 }
 
-static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
+static int kvm_handle_error_pfn(struct kvm_page_fault *fault)
 {
 	/*
 	 * Do not cache the mmio info caused by writing the readonly gfn
 	 * into the spte otherwise read access on readonly gfn also can
 	 * caused mmio page fault and treat it as mmio access.
 	 */
-	if (pfn == KVM_PFN_ERR_RO_FAULT)
+	if (fault->pfn == KVM_PFN_ERR_RO_FAULT)
 		return RET_PF_EMULATE;
 
-	if (pfn == KVM_PFN_ERR_HWPOISON) {
-		kvm_send_hwpoison_signal(kvm_vcpu_gfn_to_hva(vcpu, gfn), current);
+	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
+		kvm_send_hwpoison_signal(fault->slot, fault->gfn);
 		return RET_PF_RETRY;
 	}
 
@@ -4177,7 +4179,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 out:
 	if (unlikely(is_error_pfn(fault->pfn)))
-		return kvm_handle_error_pfn(vcpu, fault->gfn, fault->pfn);
+		return kvm_handle_error_pfn(fault);
 
 	return RET_PF_CONTINUE;
 }
-- 
2.37.1.595.g718a3a8f04-goog


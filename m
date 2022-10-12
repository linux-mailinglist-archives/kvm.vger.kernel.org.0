Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170435FCA60
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 20:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJLSRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 14:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiJLSRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 14:17:25 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6D727FD1
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:17 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id s2-20020aa78282000000b00561ba8f77b4so9190853pfm.1
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UcVvkDQBBHipi7B9bc9w9EXjqJE1fFNcFSTj++h2wVs=;
        b=QkHR2nWKcX4fk382uPwPldcRQqjFRAey2CHttSccJdRNJsDzASiGBLZma3s8fgFwmK
         MPC2y+wVmpuFeM9PgB6jB8hbl+3JliNqQSjdpvYHGZDj2AeAFrWh/dlqtwmDflksZw+8
         zChiYaPDsdA6SyO0YKD4tc/D0n2NdJyGoBXY9ozL8wJzWo7AKgogmmoNLJGKtX75uJid
         YZHjqVB8ZThf0XVWDUjszIJL2WMI8R6gLOnnrB3A9jMbqh2h5VtqprIKbsUEjJAUWns+
         E2y684CDnfAzdbgV7Mug7sVXg/iSOHFHaVDXNovV0gZobyyYa649/V760naGZ/GqaciV
         CTBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UcVvkDQBBHipi7B9bc9w9EXjqJE1fFNcFSTj++h2wVs=;
        b=3reRak1ZOf4lHIbbVVPDjY3nseUX+s8RU6zvb2YoPE49DLcrZtStzffbXx70zpieE0
         hZCJLJf0dmcus+6WAMOVYsDtfpyYewVZ4KQaVMtUvq+w2FFvEGNUhPw3to5RiwNcfPs8
         O6A3SsFyYErtLtR0JfgF1AWC5CvsGwZX4Mffj9+7gQO/U4I2kVFagYtcJDCO+Qi2vjPJ
         RIUNJrSEFNk41iUmPfhRxSQu5/09VIDSIH05figKznaflsdxfVu8OeKtobr0imo5aQ9N
         eoFSA2G9ettSiHrAEvWsED0KmN5FKT8JcO5Qimcz4jmP41I6BWnxxJeuqbEyMZDYMjhQ
         YcAg==
X-Gm-Message-State: ACrzQf2dtMCpZFGh8hSKN/Pq3VUttve4GkFPJ4ISshjnAjo78/2t/gqB
        HNfJ4xMSrDYVgggIU4KejsZTLwd/cag=
X-Google-Smtp-Source: AMsMyM6tFuF6KpvADH5ubFcQPbqpoqffWf9m6rAN+DG10+8ZPvAr4c5f85Ii1WQeXWz6bSfoOnmWTNVm+Oc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ba8f:b0:17f:9b1b:6634 with SMTP id
 k15-20020a170902ba8f00b0017f9b1b6634mr31226126pls.171.1665598635998; Wed, 12
 Oct 2022 11:17:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 12 Oct 2022 18:16:56 +0000
In-Reply-To: <20221012181702.3663607-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221012181702.3663607-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221012181702.3663607-6-seanjc@google.com>
Subject: [PATCH v4 05/11] KVM: x86/mmu: Avoid memslot lookup during
 KVM_PFN_ERR_HWPOISON handling
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

Pass the kvm_page_fault struct down to kvm_handle_error_pfn() to avoid a
memslot lookup when handling KVM_PFN_ERR_HWPOISON. Opportunistically
move the gfn_to_hva_memslot() call and @current down into
kvm_send_hwpoison_signal() to cut down on line lengths.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6417a909181c..07c3f83b3204 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3150,23 +3150,25 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
 
@@ -4207,7 +4209,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		return ret;
 
 	if (unlikely(is_error_pfn(fault->pfn)))
-		return kvm_handle_error_pfn(vcpu, fault->gfn, fault->pfn);
+		return kvm_handle_error_pfn(fault);
 
 	return RET_PF_CONTINUE;
 }
-- 
2.38.0.rc1.362.ged0d419d3c-goog


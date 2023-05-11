Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5726FFD56
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 01:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbjEKXeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 19:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239589AbjEKXeE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 19:34:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5515976B7
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:34:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba2526a8918so11799324276.1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683848041; x=1686440041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AFwpP1qaMZwSk6fg6R/6MjpXxVjL9zg4kzfgxnB0LR8=;
        b=gRE1sRBKIQ5Ra7bt0VwwSFM1mECWSD6F7GBLdTQMnjyjyz8bVZQXjUUNykSsjOnHuu
         +DPx8I/98NIdwNReplgbGD8Pe4SLS4bNBIRHM4gOXin2tZgfjZbLvP0lQ7m/81NBpHWy
         F1x3/3gSRp52FDkcPBt0yQIAEiOkjInBwg/L/DjKZdNVfADwiRx19khBIXCCDzv44m/9
         Zrk1iRstbv28z3bqnmhI9Y2P41ZvnHWKVvkYZ/0QPgMyjRyIYgcvNOmwIj79x1Bw68cK
         xfq+4rShX9qITK3fhum5rLU0WtYbvVGmGFzXr9LUCneg6ctC44jqlRF0UNCLnKdZ7JSz
         4M4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683848041; x=1686440041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AFwpP1qaMZwSk6fg6R/6MjpXxVjL9zg4kzfgxnB0LR8=;
        b=ZNYdDAcEcFgE0inerDrFEYt1Yjv6s/Z+DIe9GpQSWupuBmAMGVcFhi1Ti9cPPLG5pc
         4xkixOBVpmpjydYtTTVvPkSpd77bthyWJpJ14T5Pc6sN0cCcSyN1buvqQw2BJqqf2fL9
         RfwhIlOay0ZHX29YNUa81m5tv9Fkb9HC6u2932GKRrRtwrxwDI3Zgg4+nIOp+8W+yiG9
         ywO5W9xq0XUwRkl36PrwPQvWx6ZGZypw/uKKNHPqKJc6+DSR8UKfprTBQxTuwzMGI3Vo
         Xhg7juQ+rGW2c3b4G2ncXoDBKjGuX1xAToy5EBTX75GXLT0QxqlsTRLZZGz3hF5/QEtT
         f1xw==
X-Gm-Message-State: AC+VfDxLMxOVbD9RPkoz1Bp0O1HmBxLY9A9Gp+Ohlp8BL1fe1vk8qVu5
        t8bkuY2uyZgUzSHbrUV7H5q3lWbWxcA=
X-Google-Smtp-Source: ACHHUZ4x7Q6rzUq3yBfEBW59YBCelyJ2qS+ssWWkdWnuGyiULCmChSNOGNfpRXomIMuUB0gZfLCqetL0JGk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2283:0:b0:ba5:38b:fbbe with SMTP id
 i125-20020a252283000000b00ba5038bfbbemr5912969ybi.3.1683848041456; Thu, 11
 May 2023 16:34:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 May 2023 16:33:47 -0700
In-Reply-To: <20230511233351.635053-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230511233351.635053-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230511233351.635053-5-seanjc@google.com>
Subject: [PATCH v2 4/8] KVM: x86: Add helper to get variable MTRR range from
 MSR index
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Wenyao Hai <haiwenyao@uniontech.com>,
        Ke Guo <guoke@uniontech.com>
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

Add a helper to dedup the logic for retrieving a variable MTRR range
structure given a variable MTRR MSR index.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mtrr.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index f65ce4b3980f..59851dbebfea 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -31,6 +31,14 @@ static bool is_mtrr_base_msr(unsigned int msr)
 	return !(msr & 0x1);
 }
 
+static struct kvm_mtrr_range *var_mtrr_msr_to_range(struct kvm_vcpu *vcpu,
+						    unsigned int msr)
+{
+	int index = (msr - 0x200) / 2;
+
+	return &vcpu->arch.mtrr_state.var_ranges[index];
+}
+
 static bool msr_mtrr_valid(unsigned msr)
 {
 	switch (msr) {
@@ -314,7 +322,6 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
 	gfn_t start, end;
-	int index;
 
 	if (msr == MSR_IA32_CR_PAT || !tdp_enabled ||
 	      !kvm_arch_has_noncoherent_dma(vcpu->kvm))
@@ -332,8 +339,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
 		end = ~0ULL;
 	} else {
 		/* variable range MTRRs. */
-		index = (msr - 0x200) / 2;
-		var_mtrr_range(&mtrr_state->var_ranges[index], &start, &end);
+		var_mtrr_range(var_mtrr_msr_to_range(vcpu, msr), &start, &end);
 	}
 
 	kvm_zap_gfn_range(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));
@@ -348,14 +354,12 @@ static void set_var_mtrr_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
 	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
 	struct kvm_mtrr_range *tmp, *cur;
-	int index;
 
-	index = (msr - 0x200) / 2;
-	cur = &mtrr_state->var_ranges[index];
+	cur = var_mtrr_msr_to_range(vcpu, msr);
 
 	/* remove the entry if it's in the list. */
 	if (var_mtrr_range_is_valid(cur))
-		list_del(&mtrr_state->var_ranges[index].node);
+		list_del(&cur->node);
 
 	/*
 	 * Set all illegal GPA bits in the mask, since those bits must
@@ -423,11 +427,10 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	else if (msr == MSR_IA32_CR_PAT)
 		*pdata = vcpu->arch.pat;
 	else {	/* Variable MTRRs */
-		index = (msr - 0x200) / 2;
 		if (is_mtrr_base_msr(msr))
-			*pdata = vcpu->arch.mtrr_state.var_ranges[index].base;
+			*pdata = var_mtrr_msr_to_range(vcpu, msr)->base;
 		else
-			*pdata = vcpu->arch.mtrr_state.var_ranges[index].mask;
+			*pdata = var_mtrr_msr_to_range(vcpu, msr)->mask;
 
 		*pdata &= ~kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 	}
-- 
2.40.1.606.ga4b1b128d6-goog


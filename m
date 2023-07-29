Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05AD0767A5F
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237312AbjG2Ay3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236942AbjG2Axf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:53:35 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA53949FA
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:53:08 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-563fc38db94so1618007a12.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591929; x=1691196729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=um0JUlmUESKdJimio+8DNUJWds66RsQougy5ghLTK+M=;
        b=r48oWTbmRTUWH3Z3twYcBmYDoGqgbAjjPqBmvui4nkkBegzbN6TfRQJYzbz5xJX0KK
         X9ZgKU6wFEwfylQNRownUXs6PJOB5Zz9LybqmE4Jq/UoiIhkKrzX5Dsf7A70vL1+afVG
         C4ifTpOrE/gja7r+0dRTQldVXd2mxVS+I4xcVPQgeGTjtGx0oky4JpuQpiVUt7s3EBid
         bPu5gqi8jKk1wp5vFmVU7LMTdXVrtPJ9Zbugk1qr8arQBbFqIvrye52e7QP0UQRIr+Rr
         NypmxslReFidTdyPqTe6dxxdhbgiOBtb20No55FnjNInlGL/tdCxerGILm33QsLb/W7A
         OUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591929; x=1691196729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=um0JUlmUESKdJimio+8DNUJWds66RsQougy5ghLTK+M=;
        b=cTGhCI2pPBXAzon77cxkur7LErNNB313LKG99mTZeXHUhkvtBdAqlyqKHpJrgdPEaP
         N2Iflbo1Qtntun3f/SC8RexcR5zkNmObku5KalATDk8vHechR/0mFKAU2z5THPsEq2PT
         /XQNNUBoPLaL3ewn1InqH17cuNZKIc6RSUNfKFZlq/D6ULSKM9+KkbpsnT5QS/G7RyM3
         rWZf0f9WaZYG+QhevM7f5Z4AvoSkXoTp3Zz38NoQwjLE/cO8t/ydk1g89sguIoSSSckq
         F57vwWUEPqX2kVHEheJu1ttjuZNbwYAt8RNIPahsbq3/aPYsJq9rQydI+lC4sNlzTJm1
         iZXA==
X-Gm-Message-State: ABy/qLby33Vd6DzWk3jKEAPDOE6WOZRrvgRdpimH++Whyc+X7vIhv8Y0
        tR6Lb8XvG4tMSMsrt38BE406z+I5yS8=
X-Google-Smtp-Source: APBJJlHaCnyOvaOuQmYbyQ9la+ROl01FCWEIQ8XPUaxuc9zsIiTRf8wHa71yILd6Ha7nYIjT40QJatljl9w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c951:b0:1ae:6895:cb96 with SMTP id
 i17-20020a170902c95100b001ae6895cb96mr13176pla.5.1690591929667; Fri, 28 Jul
 2023 17:52:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:51:59 -0700
In-Reply-To: <20230729005200.1057358-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729005200.1057358-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729005200.1057358-5-seanjc@google.com>
Subject: [PATCH v2 4/5] KVM: x86/mmu: Disallow guest from using !visible slots
 for page tables
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
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

Explicitly inject a page fault if guest attempts to use a !visible gfn
as a page table.  kvm_vcpu_gfn_to_hva_prot() will naturally handle the
case where there is no memslot, but doesn't catch the scenario where the
gfn points at a KVM-internal memslot.

Letting the guest backdoor its way into accessing KVM-internal memslots
isn't dangerous on its own, e.g. at worst the guest can crash itself, but
disallowing the behavior will simplify fixing how KVM handles !visible
guest root gfns (immediately synthesizing a triple fault when loading the
root is architecturally wrong).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0662e0278e70..122bfc0124d3 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -351,6 +351,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	++walker->level;
 
 	do {
+		struct kvm_memory_slot *slot;
 		unsigned long host_addr;
 
 		pt_access = pte_access;
@@ -381,7 +382,11 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		if (unlikely(real_gpa == INVALID_GPA))
 			return 0;
 
-		host_addr = kvm_vcpu_gfn_to_hva_prot(vcpu, gpa_to_gfn(real_gpa),
+		slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(real_gpa));
+		if (!kvm_is_visible_memslot(slot))
+			goto error;
+
+		host_addr = gfn_to_hva_memslot_prot(slot, gpa_to_gfn(real_gpa),
 					    &walker->pte_writable[walker->level - 1]);
 		if (unlikely(kvm_is_error_hva(host_addr)))
 			goto error;
-- 
2.41.0.487.g6d72f3e995-goog


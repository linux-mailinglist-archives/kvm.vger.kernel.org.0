Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211D277D531
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 23:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240278AbjHOVgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 17:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240296AbjHOVfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 17:35:53 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49781FD4
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:42 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-686e29cb7a0so6703931b3a.3
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692135342; x=1692740142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SFpi+WGuvYcTqc5iutU3gDOga20tlCn0kmKYiGzba1s=;
        b=74tVcNm00OZaHpD1xVuPf4Jjj8KBDUlS++wNuw6IOr9Xww7JLEHfMfpDin20hyekXn
         UAZzdeOvKkgZUS6btGqtbj1EtOcbudgfP8uunjSwa10kl53dOsD2H4PMXQQ7CpyOKOA0
         fFJjtiO9IkGgau4YpenIfY616mMKNSNOk/KybhEQhb/R1OBjzFS1FxAE5sc0kRQ+eebR
         f+hPBPVTsmtcKA98ubnfVz6rHszpNxsmqCasREoyiC8y1zLZQWM3maIi8g+mst+1jtCV
         qq4sZhxyR+JYTtYagySkZoMNAZfN36FpIVb+Q3rAOdXkc6+JefuhcRoK+Iwm0FGQTYOH
         wB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692135342; x=1692740142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SFpi+WGuvYcTqc5iutU3gDOga20tlCn0kmKYiGzba1s=;
        b=acXKmDBksOQ68npLDxK8J6wAE6kcOo+rsZ+p3CM6LaMCo6KEj/Ia0kzssIQs8Ww919
         swVy1rwdJXVi3nMo+cwYAjCEX0y4QNyMiLxOG3yttD4eb0mJZbX/HMNt2f1QdNfkfpxu
         9ZHgA8xakMl46UJ3amnVN10PFHKPHGHtVUiGLvcwRo/wliVsJewPxfq2OJWAZg8Lsak/
         EFM1M+QpshuJkLU9APYZ2fSnHwRkzTd7ZjPJtp2ncO7CwOa3tZV/9oI4Co+n3sND1EmQ
         n/NhG4B+SKHd2Oc78kyC/jUwvkYBZHc/XNttWMVhVyA01QMhZSfdFkMd9BlnvG5ddccu
         fiUQ==
X-Gm-Message-State: AOJu0YyufaaTuIxdojIGjNul1zBSkk66lpbdA7mxMTR/v6op93rgjrxU
        M1lfgp9gUOjNFLxoQndRQDLSrj8c/bg=
X-Google-Smtp-Source: AGHT+IG5MHzZLav8gJ1/MnkDQMEocS8Nk95fglVaOP6iG8M0zB5pJMu3CTRFZ48wrIVfKHX4OCFGKU3C7d8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a17:b0:682:24c1:2951 with SMTP id
 p23-20020a056a000a1700b0068224c12951mr8029pfh.0.1692135342319; Tue, 15 Aug
 2023 14:35:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 14:35:25 -0700
In-Reply-To: <20230815213533.548732-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815213533.548732-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815213533.548732-3-seanjc@google.com>
Subject: [PATCH 02/10] KVM: SVM: Use AVIC_HPA_MASK when initializing vCPU's
 Physical ID entry
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use AVIC_HPA_MASK instead of AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK when
initializing a vCPU's Physical ID table entry, the two masks are identical.
Keep both #defines for now, along with a few new static asserts.  A future
change will clean up the entire mess (spoiler alert, the masks are
pointless).

Opportunisitically move the bitwise-OR of AVIC_PHYSICAL_ID_ENTRY_VALID_MASK
outside of the call to __sme_set(), again to pave the way for code
deduplication.  __sme_set() is purely additive, i.e. ORing in the valid
bit before or after the C-bit does not change the end result.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/svm.h | 2 ++
 arch/x86/kvm/svm/avic.c    | 5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 1e70600e84f7..609c9b596399 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -285,6 +285,8 @@ static_assert((AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == AVIC_MAX_
 static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_MAX_PHYSICAL_ID);
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
+static_assert(AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK == AVIC_HPA_MASK);
+static_assert(AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK == GENMASK_ULL(51, 12));
 
 #define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 7062164e4041..442c58ef8158 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -308,9 +308,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	if (!entry)
 		return -EINVAL;
 
-	new_entry = __sme_set((page_to_phys(svm->avic_backing_page) &
-			      AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK) |
-			      AVIC_PHYSICAL_ID_ENTRY_VALID_MASK);
+	new_entry = __sme_set(page_to_phys(svm->avic_backing_page) & AVIC_HPA_MASK) |
+		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
 	WRITE_ONCE(*entry, new_entry);
 
 	svm->avic_physical_id_cache = entry;
-- 
2.41.0.694.ge786442a9b-goog


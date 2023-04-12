Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC2D6E0106
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 23:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjDLVfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 17:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjDLVfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 17:35:41 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2657883C0
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:33 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54f9df9ebc5so27949227b3.13
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335332; x=1683927332;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fW2lVHfchp9UgxlQ0eqx0Qnt2L2yZQNT4SVI95DvpSs=;
        b=RbgkvGcRLIPqOOdYTNLhCUUYpP5u2hdsGoV9tBjd/zi1IjMKBqiqA4sTOeL9bmoW81
         3H6Qawu5hfjaOHdrZKYJjjAR5wQ054U3LXNw8S1hT7BxcGUsYoBb3c/5ycAOlZhoOdIt
         dgXzaicpEJwGYoy9qsWynR9W7h9/m4Ym8cnWfYm6bzs75oxhyzRFVeyTI27Ln42QTX+R
         ETbJEewsFQeSLQ5tUo7roL1hW8q9eBwsa+gSY8ErXEcwEVuBQJ6YFyvwi3NQ8sUBj7jR
         AoxcJZMbiDGNw5e335EAnuUNdSYzaovS6U4EKDLMkQBvIw6z8nn7Dxs2OReIS8YFbH7v
         2ODA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335332; x=1683927332;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fW2lVHfchp9UgxlQ0eqx0Qnt2L2yZQNT4SVI95DvpSs=;
        b=XflZFsA6zefkBWkBKRH8RHF10TCG8HyEBI7IqVkqfev7q/N/uTjjpM6InVO6NIbfuM
         Tp6ba45xQXqtkLSfUWARJzkYVdxZZpWE6TYPg2u/+i87GGbSQjpyoJJyQ3GTSgo2aXtg
         2/4bmFImlxNjFUpbL8JriDjrXQwQ/luhVOmGfnVi3Dxy6sta3qPPN82bIUntquebalVL
         Ba0O0isGonmHRlYwsjNBSl41lhKwjp9Lv8Kzw3mOOXvLfmUNzmi3rCD7zJqsd/ta7IEy
         KmQICrztvmEQzS0xDRZFY+LMKw9ozjSoDT3GQFXsQoeK6sWy34RzkWA3ktDk4D56zywg
         +wtg==
X-Gm-Message-State: AAQBX9eTO7u1YIxOiFgel0NMJ2hr7RD+RLJTzQOiLfA//1J9SsZlJ+AN
        joh9+wE7P+fOzQ1fZ4sq9h590ThNIworhg==
X-Google-Smtp-Source: AKy350YH5KZy2ouOBNOYXjh55lIcz9SLFEFUhOyUV8JCny7/1ROofC6xXNHF+9m2d578/vmRjDjHN/WG7mo03Q==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:30c2:0:b0:b8f:553a:ddfd with SMTP id
 w185-20020a2530c2000000b00b8f553addfdmr2164ybw.5.1681335332195; Wed, 12 Apr
 2023 14:35:32 -0700 (PDT)
Date:   Wed, 12 Apr 2023 21:35:07 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-20-amoorthy@google.com>
Subject: [PATCH v3 19/22] KVM: arm64: Annotate (some) -EFAULTs from user_mem_abort()
From:   Anish Moorthy <amoorthy@google.com>
To:     pbonzini@redhat.com, maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        amoorthy@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement KVM_CAP_MEMORY_FAULT_INFO for at least some -EFAULTs returned
by user_mem_abort(). Other EFAULTs returned by this function come from
before the guest physical address of the fault is calculated: leave
those unannotated.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/arm64/kvm/mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7113587222ffe..d5ae636c26d62 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1307,8 +1307,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
 	}
-	if (is_error_noslot_pfn(pfn))
+	if (is_error_noslot_pfn(pfn)) {
+		kvm_populate_efault_info(vcpu, round_down(gfn * PAGE_SIZE, vma_pagesize),
+				vma_pagesize);
 		return -EFAULT;
+	}
 
 	if (kvm_is_device_pfn(pfn)) {
 		/*
@@ -1357,6 +1360,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (kvm_vma_mte_allowed(vma)) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
 		} else {
+			kvm_populate_efault_info(vcpu,
+					round_down(gfn * PAGE_SIZE, vma_pagesize), vma_pagesize);
 			ret = -EFAULT;
 			goto out_unlock;
 		}
-- 
2.40.0.577.gac1e443424-goog


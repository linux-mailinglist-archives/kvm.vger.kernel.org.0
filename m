Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFD47D4382
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 01:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjJWX7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 19:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbjJWXkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 19:40:16 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BA7D7E
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 16:40:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9a5836ab12so4532594276.2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 16:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698104411; x=1698709211; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kKpVqTewUTpqij+D7Vj0c8pKvN0oprp2NzBGTWeq1ms=;
        b=s7VJKKgHcoYFE5Dij2QE/tI8xY6NlFHhPB8tUg99k3JQGa1yD4DLHcm5ihnc1CvgAm
         P9w+Yk5uxYwxu5yCn7I3LYIHj+JnYHDqzChw5FLLtXHxwhs7OAATvWkTeO8zMQKdFTRo
         HLdGlx716GGnCaMCiqsYrHeZd1bctuyd+NQc3rZPh3p+GfuG2eGYCYcalf21ufCu8R4D
         UM7ZSV9+DtIikBty260LyZ0JP5damI9soG2bgTfjiqhN9WiW0LDQC2t8IvS7A7f551R3
         1Ej7LuCHWsXzRWI3n7vrf3Zdn1xNujVTg4PBmNL0M6sa2dDcsspIKUiqXVC/PkU9oQB5
         lUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698104411; x=1698709211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kKpVqTewUTpqij+D7Vj0c8pKvN0oprp2NzBGTWeq1ms=;
        b=XPhVAjAeiKZ03ss9hWr2BP5KJa6VnSBTBFNNkvFKRxuYrKR5I+ZgX1za9gg+DCK76K
         H7+S89IOEwynjzf4tBzg1XIpuppOGWNs5dEuWtV7RShLUq0MPoVw9LWPswG0mIO7oiX0
         uAmmAjetUY/9FwRTP0h3x5q3A35WIx7sUChnghATu3xue6Wcwnq0lV4+kGtZ5EhPw2wt
         rag+dmBQFoADNdUl9TdNEGHMsoHMVifK3CVPJ5PDLd/LIoq+nDGGeJO5E14z0n4tVe4Y
         R5AhHBhEJd3WBY5PwJfm9g71GLgkdT6zLmld9cRboSWZrISRkwBWLV/sKmV8yFapUz7h
         p3MA==
X-Gm-Message-State: AOJu0Yw95VGx5L+uIKuSn5KALi+lz4ErOmKCGy1I0vt4q2wQGpIVof3S
        F3XQSjol1Om0wHkm/9lke50HSpDKpvg=
X-Google-Smtp-Source: AGHT+IG/UQLvAHopvlX3+fTkoIXCZSG5C6SXuHDql5k5q4ixhxWwZSrg8qKFxtMws9CheBH+5kxBTEGrXKQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b951:0:b0:da0:1ba4:6fa2 with SMTP id
 s17-20020a25b951000000b00da01ba46fa2mr52717ybm.4.1698104410953; Mon, 23 Oct
 2023 16:40:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 16:39:58 -0700
In-Reply-To: <20231023234000.2499267-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231023234000.2499267-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231023234000.2499267-5-seanjc@google.com>
Subject: [PATCH 4/6] KVM: x86/pmu: Remove manual clearing of fields in kvm_pmu_init()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Jim Mattson <jmattson@google.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove code the unnecessarily clears event_count and need_cleanup in
kvm_pmu_init(), the entire kvm_pmu is zeroed just a few lines earlier.
Vendor code doesn't set event_count or need_cleanup during .init(), and
if either VMX or SVM did set those fields it would be a flagrant bug.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 458e836c6efe..c06090196b00 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -710,8 +710,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 
 	memset(pmu, 0, sizeof(*pmu));
 	static_call(kvm_x86_pmu_init)(vcpu);
-	pmu->event_count = 0;
-	pmu->need_cleanup = false;
 	kvm_pmu_refresh(vcpu);
 }
 
-- 
2.42.0.758.gaed0368e0e-goog


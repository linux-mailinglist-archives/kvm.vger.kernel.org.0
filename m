Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2769F4C5275
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240424AbiBZARM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240350AbiBZARA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:00 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A882255B1
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:20 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id w3-20020a17090ac98300b001b8b914e91aso4136753pjt.0
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=mkmQ6MFrlZy4eKd/Q3wbeOobNp7CN8W6giifpouEK3Q=;
        b=HNIMRDG1beTnwyz26v1dtXmdSZhkkNIT50ZAUvd6nR9l9tMgyyLfGhzlV+OqJCPEHw
         TiL7s2zfof/Z0d7TYvcEljJ0Z5/Rlzqge6Cu2y6WB6ZEdqWGgH9Del7NJBRv9vdYGZlG
         ROSoidAZmK6YDct2cNe23Qz5WbKtSXyHAPHDu4a1VCAgcib73hMUvWeBlkIljaSMzrGe
         kePNhRjQ0u4Z+bNIpQUXw5KynJ8w7BCfpUeXOeq6brTm1zXLiRPEgsDhf4QiDt7kx+So
         cJyGEZ46LlQfjFZ+eUlOlAveINLeZxzBEKSBRJlkE06aDrtbOo5uGcxLK97/LpUa6ped
         0dlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=mkmQ6MFrlZy4eKd/Q3wbeOobNp7CN8W6giifpouEK3Q=;
        b=MK8Uw9IbkDg8P9vzv3K4fTl7aUSa7ngi0RC/zj6vaCc2/v7BiBisqc8Aed2P7VMGkF
         A2BguUxFUibs7BAMjP49VhF/6AfPBxxUO6Q0XujoYdo/9zA6XNWRZSYL8ZgFnpBL8TtU
         rFWL+CBYyAvPeW0J6RVv7bQFwlKpftjanFq239/HoCFWT3dynQUn6PWPQY7D1VJ+evCa
         UC8sFPsKjJOBRoShHYphsRvBCR5prGfUbmYh0h2nrZ/vyLqvidL+F/7R5oNSE9HKKESr
         DoISAYuRIlnQRekQ8z+O8/4lYEwQtClAmkCGmvoZ02zqDWhTpQ6W4lBNvHmf7fsm7Du6
         Or/A==
X-Gm-Message-State: AOAM531ASYX9Hnb5Bs/wBrIullkc4ROxTUn5pObW2pxESiX7wKqlqfH9
        HLFqbMAt7A9ozuO6qQFGcyuf5P4NJ34=
X-Google-Smtp-Source: ABdhPJyWCyvm2sgSjm0RwiuidMtkOSbJaGbyT+NiwBP55uKTx1afDWW6MyIdn7+BA//anx1BPN3Dk9lol4Y=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:124f:b0:4c0:6242:c14e with SMTP id
 u15-20020a056a00124f00b004c06242c14emr10089164pfi.83.1645834580082; Fri, 25
 Feb 2022 16:16:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:29 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-12-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 11/28] KVM: x86/mmu: WARN if old _or_ new SPTE is REMOVED
 in non-atomic path
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

WARN if the new_spte being set by __tdp_mmu_set_spte() is a REMOVED_SPTE,
which is called out by the comment as being disallowed but not actually
checked.  Keep the WARN on the old_spte as well, because overwriting a
REMOVED_SPTE in the non-atomic path is also disallowed (as evidence by
lack of splats with the existing WARN).

Fixes: 08f07c800e9d ("KVM: x86/mmu: Flush TLBs after zap in TDP MMU PF handler")
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8fbf3364f116..1dcdf1a4fcc1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -640,13 +640,13 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
-	 * No thread should be using this function to set SPTEs to the
+	 * No thread should be using this function to set SPTEs to or from the
 	 * temporary removed SPTE value.
 	 * If operating under the MMU lock in read mode, tdp_mmu_set_spte_atomic
 	 * should be used. If operating under the MMU lock in write mode, the
 	 * use of the removed SPTE should not be necessary.
 	 */
-	WARN_ON(is_removed_spte(iter->old_spte));
+	WARN_ON(is_removed_spte(iter->old_spte) || is_removed_spte(new_spte));
 
 	kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
 
-- 
2.35.1.574.g5d30c73bfb-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA16618D83
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 02:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiKDBL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 21:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiKDBLT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 21:11:19 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B06233A4
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 18:11:16 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-348608c1cd3so34003217b3.10
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 18:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZNLPTbSTlYPZjBY9HcgmDn5JBJ/klYO2bN4Z3HIMVZY=;
        b=bwqOOb8Qn4eAWyxn4R+vdMrp7z+X9MlDWhtS2hi7whYYdWkf5FJmAUT0M76zNFvK5c
         GyzhxZ5ilEPl4VxyNPOGGI5u87KZWaJ1KVssckoBO832LOf4XmVPYHCNIjRZdotM/F0J
         qj1sLHsNomzmqZ/nB59WTDwW3KcDU6htZGJrewk9dIdhjOkArVUQSeDtjaXhXp/5erjH
         pGMeBPkgMHqGoItOyxvfZeHzrb0m0uG0h2Zw+/go7QH1C0Uwo43havjN/hLRO/V/Inez
         e9WWTq8U9kdPOCNEajZfZcONdmtEe3Q8gQJwu+MfMee3ynkyU1T5t0Zg2llvErCGZsqA
         Tb1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZNLPTbSTlYPZjBY9HcgmDn5JBJ/klYO2bN4Z3HIMVZY=;
        b=saD3hp8HPRGMlPhLcuPDbSfuYWHHIgl6x3CI/CW15hZJS+JY/8vn6dJ8SY1iUQ25nK
         T6XksR8LX2j3yBLnBk5ZnY748y0CMgvA+/j558cGOR5Jx+l3qG66L4UBSTI6VKGCB7KY
         IZMkzqp4BAc4umehqG9hTdlM0D4sRd8ei+H0G3Jpz7qX0d+U0bp23VMeEdT/ofsK8PUb
         /e+LchdirBX66tOazPMbgCx+IXaO9EV58O+7rP6phYeaQMgIHfhMlKrE2i8UsSUpHLmi
         EoIbUWb1mZp7onYixMiXM1A1rN6rg1Cdm0Id4FFqIf7bX7FZHpLSrS3SYEX3oTbWcDWl
         ASKQ==
X-Gm-Message-State: ACrzQf3gifgspxy/LZ2qhUkeggO4Ps9Wpsfq46BTFz2Bb1LHacvx9dS6
        Ji0zIyWIZdwajuZi4uPSHZyTsvU=
X-Google-Smtp-Source: AMsMyM6nmXxJ8Gq+/aWVuDapWKSZFcWfvUUDZ0UKrzoV1+beR/aXVD1kiZHnxs3uVYWp1mJAGj9lGKM=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:2844:b0ec:e556:30d8])
 (user=pcc job=sendgmr) by 2002:a0d:d705:0:b0:36f:f574:49a2 with SMTP id
 z5-20020a0dd705000000b0036ff57449a2mr32986451ywd.442.1667524276250; Thu, 03
 Nov 2022 18:11:16 -0700 (PDT)
Date:   Thu,  3 Nov 2022 18:10:40 -0700
In-Reply-To: <20221104011041.290951-1-pcc@google.com>
Message-Id: <20221104011041.290951-8-pcc@google.com>
Mime-Version: 1.0
References: <20221104011041.290951-1-pcc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH v5 7/8] KVM: arm64: permit all VM_MTE_ALLOWED mappings with
 MTE enabled
From:   Peter Collingbourne <pcc@google.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
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

Certain VMMs such as crosvm have features (e.g. sandboxing) that depend
on being able to map guest memory as MAP_SHARED. The current restriction
on sharing MAP_SHARED pages with the guest is preventing the use of
those features with MTE. Now that the races between tasks concurrently
clearing tags on the same page have been fixed, remove this restriction.

Note that this is a relaxation of the ABI.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/mmu.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ff9a271cf01..b9402d8b5a90 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1110,14 +1110,6 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 
 static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 {
-	/*
-	 * VM_SHARED mappings are not allowed with MTE to avoid races
-	 * when updating the PG_mte_tagged page flag, see
-	 * sanitise_mte_tags for more details.
-	 */
-	if (vma->vm_flags & VM_SHARED)
-		return false;
-
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
-- 
2.38.1.431.g37b22c650d-goog


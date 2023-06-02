Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7359C720756
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235298AbjFBQUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236865AbjFBQT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:19:59 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543CDD3
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:19:58 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id af79cd13be357-75b3b759217so319059985a.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722797; x=1688314797;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FXT5aMAcAtW/D2yhSA+7CF5prLM3G5exI8idyNJeqlQ=;
        b=MrEIIigb/YWqQ92xzazuzi8enjhLzSd+deyqUfxtAuxGcNqxPI1zoRqcgcPsZY0in6
         qI3YYemk7dYSuAVwReP578ivZLe/S+Vb2LcuohJjUFeOTbSYeRByh+dDUtwGlWd7bqiJ
         DaF+LJTYubD/Il4ugc/2AikpfHGkcDTqSnLD7Au/SIooTtUGWzqZ8jw3NAlmur2U5N5F
         Gi8UEFQVo81bXlMd3kDzyQgcnjMyuxHFAHBtWhXgkIj1fL4mmWbKeGkw5tRZomR5ScUp
         oRXjUOSbG4XMo5NR2eWkCn9pKDfIrWQE8UmzWf7SrW9kbXzhzgVc13lSDq1ZHIf25HIU
         1OEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722797; x=1688314797;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FXT5aMAcAtW/D2yhSA+7CF5prLM3G5exI8idyNJeqlQ=;
        b=QQ4ao1SplAp3NsOnVZ2VKPNzeuVHmjUS0fuHdPRDkj+zQ0MkLkvzWQHBTflBwLDYrJ
         lKV7Hvjk2q0QK/3WN3V59r2dR1oXzj+cIDTxitgeZpKLtsTMbSD3KMfUJ8bxk4ylUOKU
         hCJPfAYwURnpGtsq4TZMuZ9HPtLWAXRfw+dzXnGJTJLmf304OUN694H2XgZdztVM7MI5
         3KCsYJuFBvMmASwFdiO155V566l9qWArCZf7ozBnvNU0UJM6+3R8EJKFJge6C/tAe7uj
         L4oRUaW4Rbx4X6O182qo+M++Z8p1oXkw80LfpKnFAI3edrY0Poa2aHWkyucTjCiUaAfc
         1J9g==
X-Gm-Message-State: AC+VfDykOljjopeCvLyBzmDbONkTX/B0Z98qVKh0Ro4G2E90MQ9Amp7n
        A9hxY5LdSFZu5LEVMeYOH6yMG/lKnwMzHA==
X-Google-Smtp-Source: ACHHUZ59szArc2J5yzRQ+OH/b4av8GVrQhCDas0t1JFvDETpn96b9hqdXPaAc3D2wV6P4OkT5+sVUxvqNLjTZg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:620a:3950:b0:75b:3839:7176 with SMTP
 id qs16-20020a05620a395000b0075b38397176mr3883333qkn.13.1685722797500; Fri,
 02 Jun 2023 09:19:57 -0700 (PDT)
Date:   Fri,  2 Jun 2023 16:19:12 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-8-amoorthy@google.com>
Subject: [PATCH v4 07/16] KVM: Simplify error handling in __gfn_to_pfn_memslot()
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
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

KVM_HVA_ERR_RO_BAD satisfies kvm_is_error_hva(), so there's no need to
duplicate the "if (writable)" block. Fix this by bringing all
kvm_is_error_hva() cases under one conditional.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b9d2606f9251..05d6e7e3994d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2711,16 +2711,14 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 	if (hva)
 		*hva = addr;
 
-	if (addr == KVM_HVA_ERR_RO_BAD) {
-		if (writable)
-			*writable = false;
-		return KVM_PFN_ERR_RO_FAULT;
-	}
-
 	if (kvm_is_error_hva(addr)) {
 		if (writable)
 			*writable = false;
-		return KVM_PFN_NOSLOT;
+
+		if (addr == KVM_HVA_ERR_RO_BAD)
+			return KVM_PFN_ERR_RO_FAULT;
+		else
+			return KVM_PFN_NOSLOT;
 	}
 
 	/* Do not map writable pfn in the readonly memslot. */
-- 
2.41.0.rc0.172.g3f132b7071-goog


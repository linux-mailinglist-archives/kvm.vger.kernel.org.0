Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E27A786989
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 10:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240533AbjHXIGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 04:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240500AbjHXIGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 04:06:22 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F6E1997
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:05:44 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-564cd28d48dso3762269a12.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692864329; x=1693469129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hI/ttp/wxMkRYZ+oyQ2NmS2HxwoQO77IewL5mtwNCh0=;
        b=Vrd5G9upmFX23Dc2l1UOiVR7mwQuxLdJALTe566riReLawye0Iez9RByru+Lw1LGHs
         +bLoUARoikkBnCqoL1flcVwqreaLS334iX1gCgyZpEjqUf218Tus3zznhtCtfSXcIQ+Z
         YpZi1+Q5+CVa8tvqM3unr1KQ1huvUG9hP9dD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692864329; x=1693469129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hI/ttp/wxMkRYZ+oyQ2NmS2HxwoQO77IewL5mtwNCh0=;
        b=RGEjSIKDUlYd4OGMEh35KDRLBJRUa6e4Ckvj5sWdCBqOfWTIHf+gghSZmqAQrrgcpS
         tW8Qao6M5RH2msGXPbQYmIjx9TqpWDGka7sAKbnrL5lLuua/fnEeEjEkUaFadmX0tMH+
         4BqB7bTVutzzZkJUvY90sqlV4rMkJ/grxvHksHOW9w9He+YW723aRpCtNtg45PFjDLW2
         ZLd8jR8sHGf0TRlX411BL9cLG73D9G9s3gNIbstINuWhoMAyRHfr8xgk334XSUHfZIE0
         Qpp+1qyynou4HejR2ROYUbnQilKZqOhNyDmOAZwxXJdNwr0qx2Et8TC3wilBKIU7IHLS
         w6FA==
X-Gm-Message-State: AOJu0YwCTvfsG3csDtEGDw982kMe28wcaQHYzZkTj/0Vh1EOUHg+nG1l
        8kVT0E/9bBoXVrdufXKADdaxQ9QMByku9BYV//Y=
X-Google-Smtp-Source: AGHT+IGr4o4edi/X3Imw/dOG9514f6ovvLqJxfkblt2y6pWdfKpxCplBDdHZn5gaAedd/iurfPc6oA==
X-Received: by 2002:a17:90b:3590:b0:267:f094:afcf with SMTP id mm16-20020a17090b359000b00267f094afcfmr11065174pjb.12.1692864328780;
        Thu, 24 Aug 2023 01:05:28 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:515:8b2a:90c3:b79e])
        by smtp.gmail.com with UTF8SMTPSA id g2-20020a17090adac200b0026d034f6badsm967988pjx.38.2023.08.24.01.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 01:05:28 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, David Stevens <stevensd@chromium.org>
Subject: [PATCH v8 8/8] KVM: mmu: remove __gfn_to_pfn_memslot
Date:   Thu, 24 Aug 2023 17:04:08 +0900
Message-ID: <20230824080408.2933205-9-stevensd@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230824080408.2933205-1-stevensd@google.com>
References: <20230824080408.2933205-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

All callers have been migrated to __kvm_follow_pfn.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 virt/kvm/kvm_main.c | 33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fa1848c6c84f..aebaf4a7340e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2728,39 +2728,6 @@ kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll)
 }
 EXPORT_SYMBOL_GPL(__kvm_follow_pfn);
 
-kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool interruptible, bool *async,
-			       bool write_fault, bool *writable, hva_t *hva)
-{
-	kvm_pfn_t pfn;
-	struct kvm_follow_pfn foll = {
-		.slot = slot,
-		.gfn = gfn,
-		.flags = FOLL_GET,
-		.atomic = atomic,
-		.try_map_writable = !!writable,
-	};
-
-	if (write_fault)
-		foll.flags |= FOLL_WRITE;
-	if (async)
-		foll.flags |= FOLL_NOWAIT;
-	if (interruptible)
-		foll.flags |= FOLL_INTERRUPTIBLE;
-
-	pfn = __kvm_follow_pfn(&foll);
-	if (pfn == KVM_PFN_ERR_NEEDS_IO) {
-		*async = true;
-		pfn = KVM_PFN_ERR_FAULT;
-	}
-	if (hva)
-		*hva = foll.hva;
-	if (writable)
-		*writable = foll.writable;
-	return pfn;
-}
-EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
-
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
-- 
2.42.0.rc1.204.g551eb34607-goog


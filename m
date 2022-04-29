Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E344E514005
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 03:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353714AbiD2BHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 21:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353698AbiD2BHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 21:07:39 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9408BC875
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id w3-20020a17090ac98300b001b8b914e91aso3413660pjt.0
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=iAfBavwbsHQb7nUtWPmITw7texHIRzXx3genh74Wrm4=;
        b=d4B9ajRP0cdRUOdbpcrENwHCKJkDs3tQ5IHjndd9KvxYQ/7SOn0yIM78dzq5kyT1Nd
         M0pxUa87fybMap7EXy0g6Q2dzahdlYQCHNzaMbjOX11TvJju71dPepLRrPh53k+2YnMl
         EnjrGxBJnTCkDTRSvATHYreY/CvYVr9s9L56paGcBTUPU4X9uDWh+Hlb5+mlHpS4rUDe
         wee+clVpxgdHIJ2JqmMlMcxtR8V7kdiCEd+qCf5FFdazGj7pN34Ei0weBZaPUyQuANaO
         7YRgwLB/iW0tih0KgEQOaDGGZL8NclWvsJc5EygBZTI0gnxG9sMFJFZ3dPrn9mJLosJX
         jS9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=iAfBavwbsHQb7nUtWPmITw7texHIRzXx3genh74Wrm4=;
        b=xJ+n8Cd7l7NTcfW+gwL94mZWz99kgO9jr+j3qdxEz3IbJVKNk1IrKo/Tu06SI9EFsI
         FuP7ctQDoLDDECG+g8MlKml4gwZSY9hAlKsnahS9xOyncdL7c1/ROsxLITkt2hCby4e9
         DCn3YOqdlt2RyPz/aZn5214IEatsvh+PtEYk2Hg1gDH3FxE5idwevKWS1OnSUnZxqivn
         cxaUG7r1iVcyR/RY21emSOlfBAEkcy9nO4ScN7AXDER4KtcQorm0CSIT0EWGNTERAOnY
         FEebhU/luqBgSjeYl6sQReLQcZrnRzQQpV2VER/rDYIs+WNRJ6fQ6WkWNk6618QT9DlP
         sIXw==
X-Gm-Message-State: AOAM5311wXaM+Gnysp/Ibd7wIoA0DDr6BDRSX/F7dsf/9DmRydWqddzc
        tpS+7prxWLSQ4bbo6xDNEJHYprRJyPg=
X-Google-Smtp-Source: ABdhPJyExsvWbr+aCzXd9ADsT+u2WdLcxHUGXGu6s7gm+EXhhn3Fb9B0jU9fQPr7QbfeFO0iu8TIXA9Sf30=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce11:b0:15b:4232:e5e7 with SMTP id
 k17-20020a170902ce1100b0015b4232e5e7mr36162290plg.39.1651194262244; Thu, 28
 Apr 2022 18:04:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 29 Apr 2022 01:04:08 +0000
In-Reply-To: <20220429010416.2788472-1-seanjc@google.com>
Message-Id: <20220429010416.2788472-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220429010416.2788472-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 02/10] KVM: Drop bogus "pfn != 0" guard from kvm_release_pfn()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Remove a check from kvm_release_pfn() to bail if the provided @pfn is
zero.  Zero is a perfectly valid pfn on most architectures, and should
not be used to indicate an error or an invalid pfn.  The bogus check was
added by commit 917248144db5 ("x86/kvm: Cache gfn to pfn translation"),
which also did the bad thing of zeroing the pfn and gfn to mark a cache
invalid.  Thankfully, that bad behavior was axed by commit 357a18ad230f
("KVM: Kill kvm_map_gfn() / kvm_unmap_gfn() and gfn_to_pfn_cache").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 04ed4334473c..154c3dda7010 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2723,9 +2723,6 @@ EXPORT_SYMBOL_GPL(gfn_to_page);
 
 void kvm_release_pfn(kvm_pfn_t pfn, bool dirty)
 {
-	if (pfn == 0)
-		return;
-
 	if (dirty)
 		kvm_release_pfn_dirty(pfn);
 	else
-- 
2.36.0.464.gb9c8b46e94-goog


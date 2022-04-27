Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AE0510E3A
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 03:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356857AbiD0Bnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 21:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356861AbiD0Bn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 21:43:27 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2984E016
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:16 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id z5-20020a170902ccc500b0015716eaec65so219517ple.14
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rawRdx79XoHw8u43omV3BLmCVZwqFd6EN+RncnsvFlQ=;
        b=Wy77UfIaH1Mz9LQ3+COp24Uf6HTFpZN3jikhvs5fDCb3iOPjgt5BDq5JW28/5uZEgW
         EfhDviZS9N2Rj9bFTfA2iNGMgNU0M9nHiAUnW16ps6fAaocJBj1JFneqZOYBNnH0/D2o
         v0RwN8ACclFIH5cHcM4vRBa3fTFlm1cgcGo6O+BP0xyTbp0LHTVecQhWa/mX7GfSj9s9
         WL8GrinfpesY+cgz5KFFUpm76wbH4242+dMvlTM5l9y/Flz4ffOG+o7khGfNHZDpAKFH
         Y8F4dIVBmZOPCGCR1dxkxSNv93kBBXZZSnt1urN6U1Mk0+7lpfW1wI0RETVqjnc5Ut8i
         M2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rawRdx79XoHw8u43omV3BLmCVZwqFd6EN+RncnsvFlQ=;
        b=TwOF6YP6LfiQsOP35ArEtk5+tcQ3WwHk9oDv8i/sjXib7oz8lhSVb5UNk8g1px7OSa
         G56hrJ/yXERIR40CcMDP1nkcuMAminOXIENSy7UqLcJsG2hiG6XOgT2/wQ6G8aDqKB7/
         a+dSCe4J6WLBrx7Pw2P2ZZJiJFpcxbZzY6zLwhWfkRoY+E9kOFjMaqj5LTOJo/R+qFCF
         1E88oKhom3xGCPT4U+Ec4EiSpDBoPncNhB0OI3GN3t1qsPM5/zRQ3YBWMuJuHN8RYW+W
         fiRqpZxkaA1RHtHyDt9GAp86Pxn8JELM7d0DHsTHStt1k2E/rf7cmdYD92P2yRkZnSEU
         BaIw==
X-Gm-Message-State: AOAM532Iy1IO9adRp3qlt+1/tUpNISTeYus5y5PbXWT3KiF5QwMriQNo
        Zk8OU5PqMHCuILBqNQs5ClMaOH4e9Qo=
X-Google-Smtp-Source: ABdhPJxHu98OqKrbCDEoXrAFUU0bOj8alASiiDJ2JP3PBWJVsUZI7J3kcLtf88ASn3gUX5Vp4RckwrphTes=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cf:b0:1d9:44ad:2607 with SMTP id
 v15-20020a17090a00cf00b001d944ad2607mr20399981pjd.25.1651023616264; Tue, 26
 Apr 2022 18:40:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 27 Apr 2022 01:40:00 +0000
In-Reply-To: <20220427014004.1992589-1-seanjc@google.com>
Message-Id: <20220427014004.1992589-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220427014004.1992589-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 4/8] KVM: Put the extra pfn reference when reusing a pfn in
 the gpc cache
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
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

Put the struct page reference to pfn acquired by hva_to_pfn() when the
old and new pfns for a gfn=>pfn cache match.  The cache already has a
reference via the old/current pfn, and will only put one reference when
the cache is done with the pfn.

Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation support")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index e05a6a1b8eff..40cbe90d52e0 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -206,6 +206,14 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 
 		if (gpc->usage & KVM_HOST_USES_PFN) {
 			if (new_pfn == old_pfn) {
+				/*
+				 * Reuse the existing pfn and khva, but put the
+				 * reference acquired hva_to_pfn_retry(); the
+				 * cache still holds a reference to the pfn
+				 * from the previous refresh.
+				 */
+				gpc_release_pfn_and_khva(kvm, new_pfn, NULL);
+
 				new_khva = old_khva;
 				old_pfn = KVM_PFN_ERR_FAULT;
 				old_khva = NULL;
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9F8510E3E
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 03:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356907AbiD0Bni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 21:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356882AbiD0Bnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 21:43:33 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC21D13DFF
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:18 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q91-20020a17090a756400b001d951f4846cso2500920pjk.8
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oIuDd5cR02hrHErNclDHZMSuVoVOazN+F6VIuRriZDA=;
        b=LFic/f7rom8f+3sEzUp8LncT/ayhH/Id71SNRHr2XaRLR2TbdzmR7eBMyTACE8hyLO
         ehKTK6h/Lhd8ADH+GgmSkM8ZI5l2RI5D/Sr1w2R9Fo4qiNoukbb0Pt5HG+B7izJylETm
         Da65BQ/6ZDweC74dSvEtERft9mGiw1Di4/rDH9iBUEfIhIzsl1/iQBcOAfdjjzCfcfz7
         QTPKsdtKcTHeJqvRJ8XGFdXuKOcqt6FxOVglXcNzxlQ/f9d2srgft2g74XGwV6O9AFE8
         rgi4nBW4G5S+qS2cHwgngAHUlWvaHOKRHYoltuU16p0yhfj8ilCCvLgBifuxns3S9LPX
         Sjig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oIuDd5cR02hrHErNclDHZMSuVoVOazN+F6VIuRriZDA=;
        b=co0CI6iQhTOHUq+zk0vRcg1+ZCRt5TH1COC4JIqysOyhldigxmTROjGEkdVK6+LKZ6
         EMMqw5fCtMrHmadnUowJ0tlPlg7LRXsXIThDWBFPCWXPtwgMuLNDyttHbB6d1DbSFAkh
         Y6hAynyjFzyQnkB/d6GrgRHdbimhx3ZAAnrWgrAJB1gROBRaqLuzQ1IW1DerYKgYKzKd
         qcfPm+eh05FZT/iiCBXRLUIv2IfI7KF403CDVx75eaunz3QRXZlgqPtig4VHXeoYAAV7
         GtHa3JJsHa1twuU3WKoVicqZrakAtZEIAD9i/GMq/EUf6xF+pUMHBLLoRTB97jWFiaX4
         5/ug==
X-Gm-Message-State: AOAM532E33aaeKqGiUdU4yXUDl/o/FTFUvUK5gV6SzIjVVoORvug2LXW
        udhHoa76cPxDD/E3ts9gGvuTTq/g7v4=
X-Google-Smtp-Source: ABdhPJxL0wfOOjc+DR3645JlGmw0wdarGu9sglFlqvJiGN+pgAEHoaVjWlH4Mk4mSs95mgr4A1GI9T4GYnY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:b78d:b0:1d9:4f4f:bc2a with SMTP id
 m13-20020a17090ab78d00b001d94f4fbc2amr19717628pjr.155.1651023617849; Tue, 26
 Apr 2022 18:40:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 27 Apr 2022 01:40:01 +0000
In-Reply-To: <20220427014004.1992589-1-seanjc@google.com>
Message-Id: <20220427014004.1992589-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220427014004.1992589-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 5/8] KVM: Do not incorporate page offset into gfn=>pfn
 cache user address
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

Don't adjust the userspace address in the gfn=>pfn cache by the page
offset from the gpa.  KVM should never use the user address directly, and
all KVM operations that translate a user address to something else
require the user address to be page aligned.  Ignoring the offset will
allow the cache to reuse a gfn=>hva translation in the unlikely event
that the page offset of the gpa changes, but the gfn does not.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 40cbe90d52e0..05cb0bcbf662 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -179,8 +179,6 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 			ret = -EFAULT;
 			goto out;
 		}
-
-		gpc->uhva += page_offset;
 	}
 
 	/*
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog


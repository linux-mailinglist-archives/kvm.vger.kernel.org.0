Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED0F513FF4
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 03:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353759AbiD2BHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 21:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353702AbiD2BHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 21:07:40 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C9DBC864
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:24 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id d127-20020a633685000000b003ab20e589a8so3187678pga.22
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+c4kuAeaVpJbT9SeG2Y2z8NNvzs3pnH/Z0LBmJvTN5A=;
        b=g8Kk4kb1zRPfAmwfq190ewZE78OEB/To/C1WROecCUOzvO+V3UkZ1lKuMx7SdGTej3
         A5PnrAq/SMMG4W54y3jV6ul9BcQxuAKrGsYxCmLg8LeFDGumYlz2lMSdDRes2OQ5L/+8
         HWDw6PMMIPs1r0e93ntUbRaqWL+r/gjkFryZvUimq2p2qW0GrDzjbs0JON4ZYjiz/wWm
         u9SS5HdqDlWJJE/5TbHy6oAH6xR/e3CeXlUjDUg39QHOukwib533BNft8OdFDVXbPoOb
         aB/3MryJse88GOvZg3DQXk03/oD2Sss8lvAgxrorp0B9irNC+wYPi2eWLYEHaaPwnr7S
         vNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+c4kuAeaVpJbT9SeG2Y2z8NNvzs3pnH/Z0LBmJvTN5A=;
        b=BlCzYAUdQmQyU/PxxAZTCTdaZMLWGPUpcUQ1rCa/7f1Ft+bo+a1DENBjpgCzgf30oH
         RA1QBY4mTXr8JmTIDYODk61JPsD/sZv1YHvX1GMnQgk8SzMv68kx96Nt9FtAmfoNqLhs
         U0sZiJgrLtGKFj9H4N9Mh5iewc9twFZH+QRfdNMcBN7TtwUzakfLY9tnYVknh/aeJIH4
         m1w+v4p8SBn5kL/qywRn5+EBtbfi8dFvRW3hybrq3xHcUdo7ojs7B9pvCpm8JYinHKM6
         MgyTDIlhcDc/yxMysVK03CfPPZd6HLSRd1ZRGyCzict7euiDNUXIrW0RadSoXGTCxteu
         0/qg==
X-Gm-Message-State: AOAM533TMjbqEWovJpl2/IT0hWEug16kOShCwNrX2v/YNtS8M0aX5x5Y
        jph4eCZd8+dYFxCpgNqZU38UOjei/YM=
X-Google-Smtp-Source: ABdhPJyTGZSZaFMkbQsKd4UoidwtkFlyObqzGBxtSKoDdfJjb9PJPZZV4vy+Y+PEPbINE0XzKfUaVj73ldU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:dacd:b0:15e:75e6:da26 with SMTP id
 q13-20020a170902dacd00b0015e75e6da26mr1810973plx.61.1651194263858; Thu, 28
 Apr 2022 18:04:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 29 Apr 2022 01:04:09 +0000
In-Reply-To: <20220429010416.2788472-1-seanjc@google.com>
Message-Id: <20220429010416.2788472-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220429010416.2788472-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 03/10] KVM: Don't set Accessed/Dirty bits for ZERO_PAGE
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

Don't set Accessed/Dirty bits for a struct page with PG_reserved set,
i.e. don't set A/D bits for the ZERO_PAGE.  The ZERO_PAGE (or pages
depending on the architecture) should obviously never be written, and
similarly there's no point in marking it accessed as the page will never
be swapped out or reclaimed.  The comment in page-flags.h is quite clear
that PG_reserved pages should be managed only by their owner, and
strictly following that mandate also simplifies KVM's logic.

Fixes: 7df003c85218 ("KVM: fix overflow of zero page refcount with ksm running")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 154c3dda7010..46d12998732e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2828,16 +2828,28 @@ void kvm_release_pfn_dirty(kvm_pfn_t pfn)
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
 
+static bool kvm_is_ad_tracked_pfn(kvm_pfn_t pfn)
+{
+	if (!pfn_valid(pfn))
+		return false;
+
+	/*
+	 * Per page-flags.h, pages tagged PG_reserved "should in general not be
+	 * touched (e.g. set dirty) except by its owner".
+	 */
+	return !PageReserved(pfn_to_page(pfn));
+}
+
 void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+	if (kvm_is_ad_tracked_pfn(pfn))
 		SetPageDirty(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
 
 void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+	if (kvm_is_ad_tracked_pfn(pfn))
 		mark_page_accessed(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
-- 
2.36.0.464.gb9c8b46e94-goog


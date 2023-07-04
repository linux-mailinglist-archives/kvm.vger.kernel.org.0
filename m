Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2DC746B19
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 09:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbjGDHvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 03:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjGDHvh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 03:51:37 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286DFAD
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 00:51:36 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id 006d021491bc7-56344354e2cso3629260eaf.1
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 00:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688457095; x=1691049095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kK+di2LH2O2PIVMiKS4D/tuGXEaFYURT1f0nc5afMRA=;
        b=AN1PbDYID8uXga3qYegkFGjesKwc0Hlh/fi8AmJAU1/smu162cLbw0Y60BCvXS/NQa
         xxi7dK9Xc3uBscDPa3brvsKzNqz2xE6KDB/zQ94CKEkYBMGicId1sub8nxB7zvTwk449
         5jItIUUfNJdzEetuDKpMFg599Q6jMYqYE5Ygc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688457095; x=1691049095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kK+di2LH2O2PIVMiKS4D/tuGXEaFYURT1f0nc5afMRA=;
        b=NoH53G/yqFKw8p4IUKq4Czu2dhqk6giOLzLLqehEXFnGsUo1/2j05juTA9WMfuKJDF
         trDb5+njjohQrndde36spb2zIrAlMjVpN13zuKRCDSlbJVF8w6iUVCyZJAw4vwz+irna
         5eoyMphZFj7l3pWTRu11BvjA/eJBFX84G14CquKcXviyUMc0NIFJXrtU1OOOGYL7FhNb
         nHQBvMdCEi6+2XYBa+JtHd3/tQCJbAQp6gYW2VeNohsy3GHxHyeLT7TZVHGHKfg+xj/4
         qoennMUcPi2OkEi+DGCclazSUoOj1idqcRHZmqvAgOysaXpMTG28BRYHbB1IRzUSkMPz
         AEVA==
X-Gm-Message-State: AC+VfDzwBBcoIQ+ctoEhi0LIzUasJzZZZkWEV48nx4/OInWPVlTBjEUe
        k9yqz7A/pz+2zRJ1Mb2+HL3LAg==
X-Google-Smtp-Source: ACHHUZ6QINB9a6PnyEez1WUpngKCHju6pHXnmFm3K1Dg70QA+/T/oNbclZKeG1lrixsFr0eCuXP5Nw==
X-Received: by 2002:a05:6808:238d:b0:3a3:61fc:f913 with SMTP id bp13-20020a056808238d00b003a361fcf913mr15281455oib.0.1688457095409;
        Tue, 04 Jul 2023 00:51:35 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:a11b:bff7:d8ae:bb0])
        by smtp.gmail.com with UTF8SMTPSA id px4-20020a17090b270400b0024e37e0a67dsm10734152pjb.20.2023.07.04.00.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 00:51:35 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Subject: [PATCH v7 1/8] KVM: Assert that a page's refcount is elevated when marking accessed/dirty
Date:   Tue,  4 Jul 2023 16:50:46 +0900
Message-ID: <20230704075054.3344915-2-stevensd@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
In-Reply-To: <20230704075054.3344915-1-stevensd@google.com>
References: <20230704075054.3344915-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Assert that a page's refcount is elevated, i.e. that _something_ holds a
reference to the page, when KVM marks a page as accessed and/or dirty.
KVM typically doesn't hold a reference to pages that are mapped into the
guest, e.g. to allow page migration, compaction, swap, etc., and instead
relies on mmu_notifiers to react to changes in the primary MMU.

Incorrect handling of mmu_notifier events (or similar mechanisms) can
result in KVM keeping a mapping beyond the lifetime of the backing page,
i.e. can (and often does) result in use-after-free.  Yelling if KVM marks
a freed page as accessed/dirty doesn't prevent badness as KVM usually
only does A/D updates when unmapping memory from the guest, i.e. the
assertion fires well after an underlying bug has occurred, but yelling
does help detect, triage, and debug use-after-free bugs.

Note, the assertion must use page_count(), NOT page_ref_count()!  For
hugepages, the returned struct page may be a tailpage and thus not have
its own refcount.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b838c8f71349..371bd783ff2b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2885,6 +2885,19 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
 static bool kvm_is_ad_tracked_page(struct page *page)
 {
+	/*
+	 * Assert that KVM isn't attempting to mark a freed page as Accessed or
+	 * Dirty, i.e. that KVM's MMU doesn't have a use-after-free bug.  KVM
+	 * (typically) doesn't pin pages that are mapped in KVM's MMU, and
+	 * instead relies on mmu_notifiers to know when a mapping needs to be
+	 * zapped/invalidated.  Unmapping from KVM's MMU must happen _before_
+	 * KVM returns from its mmu_notifier, i.e. the page should have an
+	 * elevated refcount at this point even though KVM doesn't hold a
+	 * reference of its own.
+	 */
+	if (WARN_ON_ONCE(!page_count(page)))
+		return false;
+
 	/*
 	 * Per page-flags.h, pages tagged PG_reserved "should in general not be
 	 * touched (e.g. set dirty) except by its owner".
-- 
2.41.0.255.g8b1d071c50-goog


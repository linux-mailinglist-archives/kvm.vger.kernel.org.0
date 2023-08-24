Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C6D786977
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 10:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbjHXIFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 04:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240507AbjHXIF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 04:05:28 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BDF1734
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:04:55 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1bf3a2f44ffso48059815ad.1
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692864294; x=1693469094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iV3LzITJwv11zEQaTKqycZRD5Ms/f2qTTnP9Z8Na2Dc=;
        b=hTSVm1KpsiVl32iXwZgDBmPH+embp/HaAL1ZLu2uR7cF3H6hTl34Q9JKEmO30iZR28
         vaejshZyHwxBtl2bVKV19vbjkB/8FGyJFYPLkrisnF9qRlAILfqlwg9vcKyHYNMNE+7T
         4vD6MFlPiDmwbS1FIANXvqkYrzJusW2+2tYbA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692864294; x=1693469094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iV3LzITJwv11zEQaTKqycZRD5Ms/f2qTTnP9Z8Na2Dc=;
        b=i5jq3WyjhcUxS6uDCdkSwkZGtJbQe6DjriZJHlYQk57aajb71E2kV7cNsXip7a1ots
         CnvRlk+/OPz/zDxDuow8T5vT2YA8oMpNi5+rugIGMPTQ84e1OoZtO3eCqjsDEYicRPK+
         rGdUPPKFpFpgKj6Q7uzCol4d2F4l7b9p3L0bbt967mm3O1sWuOGLBHYwyfmZSnjge0n/
         zrueS1B43CgRJge6jzm4ySEg0rYLOtVyk354g9iBg6h6UCc3rRSwKWj50NULWkdo6+UT
         FshjfqpOibMpUyo35VjigIt9NzYAF0RGwd7oFsfT572X/0R1AURMBlQDhojmCwGKvp83
         WFTA==
X-Gm-Message-State: AOJu0YzgSqrk0UljnsXncpYDyY69PlXS2VjRCBwgOEPx/czVRLzOiGen
        xOWsc1hmKyiOVxHCH8+KTfX/Ug==
X-Google-Smtp-Source: AGHT+IHagCrEiCSTUeawSO2RaSCgtKrRoyrdFRSlC2mm085LYzwbHRTmVonAanytbmYPqEcAnMXU/A==
X-Received: by 2002:a17:902:ab4f:b0:1be:f53c:7d1d with SMTP id ij15-20020a170902ab4f00b001bef53c7d1dmr14752623plb.23.1692864293682;
        Thu, 24 Aug 2023 01:04:53 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:515:8b2a:90c3:b79e])
        by smtp.gmail.com with UTF8SMTPSA id g12-20020a1709026b4c00b001bdb167f6ebsm12152992plt.94.2023.08.24.01.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 01:04:53 -0700 (PDT)
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
        kvm@vger.kernel.org
Subject: [PATCH v8 1/8] KVM: Assert that a page's refcount is elevated when marking accessed/dirty
Date:   Thu, 24 Aug 2023 17:04:01 +0900
Message-ID: <20230824080408.2933205-2-stevensd@google.com>
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
index 5bbb5612b207..1e4586aaa6cb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2888,6 +2888,19 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
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
2.42.0.rc1.204.g551eb34607-goog


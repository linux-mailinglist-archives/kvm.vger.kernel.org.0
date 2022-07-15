Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF212576A0A
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 00:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiGOWnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 18:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiGOWmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 18:42:39 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC7182F9B
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 15:42:39 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d10-20020a170902ceca00b0016bea2dc145so2715371plg.7
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 15:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YUNiTgLPlTD8QV7YwB9Lsk9uX244WLJ/qPBCKSza37Q=;
        b=IEIzxaU10/GgaiEDgvEaEQUdhsFDRh726RllkQBTvaIzeUYiYjOq9O/4cKSO3yn1av
         fjwH3yERNl2ZmXcYEB3qpBbLg/4GYMzC+lEQ8X4D0FxzjlRyExjLfSrJh18dIHgs9KQ9
         +IZCQyxjPSJWnHpauWOjHmGeLLQYHXmmm2hnJfEP9L0J3qyq1i92wVYnfgaYwt1PODDB
         dtONou66ojHYah8BSF1Dk+tphN285ve7P7oKJEIpR0mBL4SkFy7ibQhNIeMAuVJz2v+g
         0USILFSaWh46CBozYPJQz+HteVHmIU5KXBf/foany0yNV2QvMdDpW3nEySBhFbDCpqfE
         eWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YUNiTgLPlTD8QV7YwB9Lsk9uX244WLJ/qPBCKSza37Q=;
        b=XD5XoJV0ZS/JmSSAUOExlbhjJ3Bv4I6y3YQFmwsdaO+ClQFm3eA7iayoVnQ2Thwxtx
         juapXyHRk1Xyv+lfdOGEDcXC9v9Se7g45eVR6G0P9u2BQzM/XLTxwag7Uozn77BWMuMc
         3uiklB4gAbLxoYGxImLjOs0LtBJo/I+gwU0nDviONRupzdIZLW6zjqIkSVEg9X9FZ6N8
         5SCh9melp3Dh2MVMfMesecuKOU5BfrJIB8of0GlrHlc5jGtwHbKAneqxDFccPuE+/RZM
         W5wGFnSvTEXU2RvRVXRBRCOMrYyj9QKrOrIsEbzezpcpIW2rOvleWYV8lYE1ve/8MIvW
         YL1A==
X-Gm-Message-State: AJIora/lL0+rVW0qpoqxqFUhcEhJrDoA8zsqXNTbGPf95QBo/G9bpgBF
        93g79VJL6EpGT1wD5KdYfWzzJ+O2dlg=
X-Google-Smtp-Source: AGRyM1sXZxYSvsaFGZilN07gFLC+EzEuB3h5XG2oq27eh58j9hdmAtoxmikPALQXg9NtxhdEJXKodqTUEHo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b785:b0:16b:d978:3899 with SMTP id
 e5-20020a170902b78500b0016bd9783899mr15693788pls.109.1657924958641; Fri, 15
 Jul 2022 15:42:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 22:42:23 +0000
In-Reply-To: <20220715224226.3749507-1-seanjc@google.com>
Message-Id: <20220715224226.3749507-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220715224226.3749507-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 4/7] KVM: x86/mmu: Rename __kvm_zap_rmaps() to align with
 other nomenclature
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Rename __kvm_zap_rmaps() to kvm_rmap_zap_gfn_range() to avoid future
confusion with a soon-to-be-introduced __kvm_zap_rmap().  Using a plural
"rmaps" is somewhat ambiguous without additional context, as it's not
obvious whether it's referring to multiple rmap lists, versus multiple
rmap entries within a single list.

Use kvm_rmap_zap_gfn_range() to align with the pattern established by
kvm_rmap_zap_collapsible_sptes(), without losing the information that it
zaps only rmap-based MMUs, i.e. don't rename it to __kvm_zap_gfn_range().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fec999d2fc13..61c32d8d1f6d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5982,7 +5982,7 @@ void kvm_mmu_uninit_vm(struct kvm *kvm)
 	mmu_free_vm_memory_caches(kvm);
 }
 
-static bool __kvm_zap_rmaps(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
+static bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 {
 	const struct kvm_memory_slot *memslot;
 	struct kvm_memslots *slots;
@@ -6029,7 +6029,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	kvm_inc_notifier_count(kvm, gfn_start, gfn_end);
 
-	flush = __kvm_zap_rmaps(kvm, gfn_start, gfn_end);
+	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-- 
2.37.0.170.g444d1eabd0-goog


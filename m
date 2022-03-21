Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1084E3304
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 23:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiCUWtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 18:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiCUWsv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 18:48:51 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755763DE8C7
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id rm11-20020a17090b3ecb00b001c713925e58so334020pjb.6
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZLPE95jpMe8lV+T0TCTfToINWj+s4+K7bgD6GOm8guA=;
        b=CajaE6dlLX8Yr8WIk2KWXbrjn53KC91j1SdU00qweOisaskCK3aHgMjE1CRdyXzLHZ
         C5fKlRw9g7ow1hrQ3B4/846IJpwUt4SSvFLkn+TgoJ+23GpNU3R09NAccrh38bLASLTs
         3V/Hgcx9TMY4ZuMziFaD1v5ypRe4VVHA/yy+7aBDikhuEKgExP6hMjh2Ja7ua/TmVe4q
         f19e/dhTvg9tc52yHUU20EsiLLmcSRgflIDx9skeIvJzqRydezTEy6qRBWrA8hdPjXey
         Swr4Hc6pa0cHv9jXCLFWH6ffZaEIDHDGXPjLtLFofGzs05REbJTpHmLqPDrWZeJfrsNB
         Wpgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZLPE95jpMe8lV+T0TCTfToINWj+s4+K7bgD6GOm8guA=;
        b=IxouyiSCzqrvDI2CRIulqwnFdIny2NfbdLSSVcxpEk88FoKHHL79utoXV1u/fN73Y4
         uWx/f4JHYrqcVUKRIl/xoYARU1Adxal+JVaUPdnwiGu93evtQHmnACn0Rj+5Skao8j9y
         ptTRMws/igZFi8RDKvXRFNd/b6ALSJYkq/ZN81yKhszfeumL6KvJEBXdkafCw3yebtRs
         WkkusIPBffH8xSE8ivXHCM6we82cVZ5fo7szhqIdpVkO7myxaKMvgZC2tHbBpzWe12af
         XzlTW92+1ZKbv0STqJR9SGeZtrE+3tA56DnFDOEfj7P352/ITXcpH6oqHr25GfEAuT82
         KVtw==
X-Gm-Message-State: AOAM530j00xm7ngYeolG+po95wQ0T7gDw2OGRBk3+OE7zu09Ek3KPKzH
        E/i/sKncDW+OxTv0EtzWHx56aga+m8Sf
X-Google-Smtp-Source: ABdhPJx1NaHm335/J0Bcq4TpBTZou5NEHOeWgQqSdDOymCWGceNCKVwWAFHgIFAtBMbqfmtWLOi/tH5lmHwn
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a17:90b:4f92:b0:1bf:25e2:f6af with SMTP id
 qe18-20020a17090b4f9200b001bf25e2f6afmr1480613pjb.98.1647902661983; Mon, 21
 Mar 2022 15:44:21 -0700 (PDT)
Date:   Mon, 21 Mar 2022 15:43:57 -0700
In-Reply-To: <20220321224358.1305530-1-bgardon@google.com>
Message-Id: <20220321224358.1305530-9-bgardon@google.com>
Mime-Version: 1.0
References: <20220321224358.1305530-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 8/9] KVM: x86/mmu: Make kvm_is_mmio_pfn usable outside of spte.c
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

Export kvm_is_mmio_pfn from spte.c. It will be used in a subsequent
commit for in-place lpage promotion when disabling dirty logging.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/spte.c | 2 +-
 arch/x86/kvm/mmu/spte.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 45e9c0c3932e..8e9b827c4ed5 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -69,7 +69,7 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	return spte;
 }
 
-static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
+bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 {
 	if (pfn_valid(pfn))
 		return !is_zero_pfn(pfn) && PageReserved(pfn_to_page(pfn)) &&
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index cee02fe63429..e058a85e6c66 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -443,4 +443,5 @@ u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn);
 
 void kvm_mmu_reset_all_pte_masks(void);
 
+bool kvm_is_mmio_pfn(kvm_pfn_t pfn);
 #endif
-- 
2.35.1.894.gb6a874cedc-goog


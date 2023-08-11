Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678397786C9
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 06:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbjHKEwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 00:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbjHKEwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 00:52:22 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A63E30DC
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:49 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d66c957e1b2so397373276.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691729509; x=1692334309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ceh3/nJpRP3LCUTMqceYFYfxrY0H2MNGDIBSz6bT86E=;
        b=lHqWfp61VXzWhun3liSCo1CSCBHiEyU47FTCxsnQq8PbPrZVJoSsWVZ4fEX98C2DkW
         5tek7XQP9mJy7NeheveiRehPOgCFv2062IYZFMuFBJd/9R8dr0dmve4e4xKZzUd6v89o
         VeSHW0hjn2DbsqdsgVscCVTcn0H4yM4N/0YEqjJ196nf8SdcTQtyOZZaVghqfh6h34Re
         E0oHw2Y6uHdjAkl15YMtMg9Z6P8rco3KWSpUtvl1TY8Fm49+r+1TuIERD17QjTEoKmLD
         O3fI87xp18xcDlB5HLBTUsrTm5rIbVZpwNSq52s4Abs8Cp3fKn2aFj26qWXruJf9eih2
         dIFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691729509; x=1692334309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ceh3/nJpRP3LCUTMqceYFYfxrY0H2MNGDIBSz6bT86E=;
        b=KLoriG3oqp8LdaSVfyMChpuBUHxM8vyhmauExfEIxo0SbyXEe35dpAdjpBoZuvcdLE
         8KJHGbblvxPPRa0cO3FFETpoZBYAZIbei9DQza7buGwQjX4SBQKYz4yQ7IC8NlglqQQr
         Vyr3AUg3vIN9KYh3q7RFX/HRRDWvqdRydxglEucxJTmEQ9nw0uztRhDY9od2xBLaY+05
         d0ibuIDKTjPAAy7tNmdKzAfe1LwtnkvrnHZ5AVBMt/2pqd8+MbUE1u2jM/UDkHynkxBV
         GHo9qatjgcootoaFATgm/JiImWsngtPONECG+/oQC1VQk29nLd+VRM+yuPdG+0Hg3zuR
         XjyQ==
X-Gm-Message-State: AOJu0YwRZumt8BFD7kcEvwsknwGb792pflns0TSFZ2yN+HT91AKnTYpE
        2JqlSjS5UPKzvDgTBuSGTL2tElKzah5m
X-Google-Smtp-Source: AGHT+IGOJteWPd/cnLBRhVwGynPlFvhmV8TWzRZj/7clA/O6mEkppvIui53pAv4SPGvWg3HXNvX6L5O7yhJy
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:d814:0:b0:d48:c04:f256 with SMTP id
 p20-20020a25d814000000b00d480c04f256mr8024ybg.11.1691729509090; Thu, 10 Aug
 2023 21:51:49 -0700 (PDT)
Date:   Fri, 11 Aug 2023 04:51:26 +0000
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811045127.3308641-14-rananta@google.com>
Subject: [PATCH v9 13/14] KVM: arm64: Invalidate the table entries upon a range
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, during the operations such as a hugepage collapse,
KVM would flush the entire VM's context using 'vmalls12e1is'
TLBI operation. Specifically, if the VM is faulting on many
hugepages (say after dirty-logging), it creates a performance
penalty for the guest whose pages have already been faulted
earlier as they would have to refill their TLBs again.

Instead, leverage kvm_tlb_flush_vmid_range() for table entries.
If the system supports it, only the required range will be
flushed. Else, it'll fallback to the previous mechanism.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 5d14d5d5819a1..5ef098af17362 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -806,7 +806,8 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 		 * evicted pte value (if any).
 		 */
 		if (kvm_pte_table(ctx->old, ctx->level))
-			kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
+			kvm_tlb_flush_vmid_range(mmu, ctx->addr,
+						kvm_granule_size(ctx->level));
 		else if (kvm_pte_valid(ctx->old))
 			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
 				     ctx->addr, ctx->level);
-- 
2.41.0.640.ga95def55d0-goog


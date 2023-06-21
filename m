Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4204D738DC3
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 19:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjFURvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 13:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbjFURu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 13:50:56 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AC42685
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 10:50:32 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id ca18e2360f4ac-77d89a08a50so573457439f.1
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 10:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687369831; x=1689961831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=txSuZoJcjD5pcccV63ogAXj6R+ImdzOqCpjUFBogFls=;
        b=tr43CcP/8i342v5/9Ct1YrQsldyO50OPcRiuSq6sRQko5jigiWaQUhv5W5PI7oLr3p
         sC4wmp8EhlAUZ+KM6y+uwTC1qr1H0WPEZTRKESbsiL9VpbH4vqRV36avGePKj3Nxx7Y8
         1NCjmb6o2QsoVVBbkLqu7Hd7yyeHbyGs10Eaul2ycHCksKhyKsW++ZrSeFsO0m3sGcP9
         IorLAPs+osOx+RwQUutNQUN5JBQDyYVVUHApYkDisryzVRTt5RItCml0Gj7t46jh9yBn
         c1L5nKOs2o/qlzL7Vn1WKPUAr4Q9Cug2flxP+m8kS6WYBpop3Qeyht2U29DIWx6nHfNq
         vDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687369831; x=1689961831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=txSuZoJcjD5pcccV63ogAXj6R+ImdzOqCpjUFBogFls=;
        b=OVu2XLcw+bEgCbx92sNgu9VB+XjWABwrbzibBc3VkrsVow1ReDvePs+6Emaxfb92Xx
         SLd68M9+DUcedNCcgKbNuW054j8Up2AwtyyEpPOmQTjjT4D4OPKIiYOc2tiXUx3m1o3+
         +yvXdTcTg3sbFmJkgxS2Foas+u5fXJ2vmVYjfTgn6HjEWn0M3QDnBvE6dXCUHKhIid7D
         Pu5XSpXyaoD+iLn98qlD7TkNg2BFLdZtEBJH9BV5I6W1XtZDXl9LAfLcK11MxoaR913W
         KYWcLskKfYbVT8Qw1JGsPSxn9mtuP8KtRxYURJPKtAkLARF5Uy0tdjD1KiOHEJxFiNX6
         nNVg==
X-Gm-Message-State: AC+VfDzLh8TbZj3WO+blt4MGve2sa5r782uWzVETZbgqSDZW+DYxScAu
        tbQLfpcp8SFtstuOYSHwui6ajG/boll6
X-Google-Smtp-Source: ACHHUZ68VfUE9LrG5crOF7yNQz1Mp6rxMXDaLofQZc3ceY9MQM5/rteSPwnUZE8mHUTdjrcj+99o5c8geD0l
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a5e:a908:0:b0:77e:4866:5c0c with SMTP id
 c8-20020a5ea908000000b0077e48665c0cmr3257495iod.0.1687369831367; Wed, 21 Jun
 2023 10:50:31 -0700 (PDT)
Date:   Wed, 21 Jun 2023 17:50:01 +0000
In-Reply-To: <20230621175002.2832640-1-rananta@google.com>
Mime-Version: 1.0
References: <20230621175002.2832640-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230621175002.2832640-11-rananta@google.com>
Subject: [RESEND PATCH v5 10/11] KVM: arm64: Invalidate the table entries upon
 a range
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
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
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
---
 arch/arm64/kvm/hyp/pgtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index df8ac14d9d3d4..50ef7623c54db 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -766,7 +766,8 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	 * value (if any).
 	 */
 	if (kvm_pte_table(ctx->old, ctx->level))
-		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
+		kvm_tlb_flush_vmid_range(mmu, ctx->addr,
+					kvm_granule_size(ctx->level));
 	else if (kvm_pte_valid(ctx->old))
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
 
-- 
2.41.0.162.gfafddb0af9-goog


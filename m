Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19C1674015
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 18:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjASRgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 12:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjASRgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 12:36:17 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02868F7D2
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:36:15 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id i16-20020a17090332d000b00194a7b146b2so1743890plr.20
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3hAJU+LzPVf19y36Q9+8Vrf4nbiTPQzZyGa0NnmG2s0=;
        b=LncMkMbkcAIyGue9Im85wp+qazsdtyG2pD4++o+icy0IPMJV8lI9tX9+PjLo1kQmni
         Wo+qI4Pu/FDbulB075D7Bj5uVWpVwH11jl25Huz5SLadFPRwmt96/0kohdgBj2mHfVzm
         6vWEUZ5pdB/9lln0z/nXIlf+Ecwo1NSULAcY5mtcAXKtSLUjsKYxOpKOfvtpVDpwT+73
         zOyEADFpuPCZGJcbFi84wZfVws4tYTcDGmGejoC0EpWJU3GE4xj88gsVLKDwHZ+ih/U9
         mQJa2/FrlPiG/iljAp6TojZYVq7sxazNWHXO0HAp4VvA9tA2c11CBVsQchii7nqhnOA5
         kToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3hAJU+LzPVf19y36Q9+8Vrf4nbiTPQzZyGa0NnmG2s0=;
        b=KJlQyPGRCm0o+4xiN4tVfvrWCzEFf7vYvYzFZQz79Gl9TmbRk+TSkdQfFDuRITKrUu
         K+XoqP60MMihdv8/8z8V65wJuoknqn76ne33fTXyCnPgYAFQdRGNyMv9qIbDgatm1ml5
         nI96yvM/x1hM+ulXaNB8Oy3neggHZkr3XPDRXegcDB+K1QLDwjFIC3TSIu77/BU4IAY5
         4DoSKssWknvQk4nBzi7FIbmT4xEow+iwJdRxOWy0bNT37fx5ARsJlz3Aeu4TsF8hwo5I
         ZvVncO39qhjosByLH7t33K+0/yTtKto+irz+SPY6NNAxk/UCWCvkjka+m8B7y6etOR9a
         4Lbg==
X-Gm-Message-State: AFqh2kr66nX0QvoP/c5AsRZhPLoT3d/GLULZVj72D37rah3D7NyH46gK
        2pI8MiXojA4IkxwSa4iwK2EK0FFVldHQyg==
X-Google-Smtp-Source: AMrXdXu2MvoeQqs801JuzBUZypqlRJrB9v2DrqnXy2L/ej84ncugCrPjhb3Yc6QUXlCd6vDUHuGhT1biHplZRQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a63:2f04:0:b0:479:1797:4893 with SMTP id
 v4-20020a632f04000000b0047917974893mr1012500pgv.86.1674149775261; Thu, 19 Jan
 2023 09:36:15 -0800 (PST)
Date:   Thu, 19 Jan 2023 09:35:55 -0800
In-Reply-To: <20230119173559.2517103-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230119173559.2517103-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119173559.2517103-4-dmatlack@google.com>
Subject: [PATCH 3/7] KVM: x86/mmu: Collapse kvm_flush_remote_tlbs_with_{range,address}()
 together
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        David Matlack <dmatlack@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

Collapse kvm_flush_remote_tlbs_with_range() and
kvm_flush_remote_tlbs_with_address() into a single function. This
eliminates some lines of code and a useless NULL check on the range
struct.

Opportunistically switch from ENOTSUPP to EOPNOTSUPP to make checkpatch
happy.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index aeb240b339f5..7740ca52dab4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -246,27 +246,20 @@ static inline bool kvm_available_flush_tlb_with_range(void)
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
-		struct kvm_tlb_range *range)
-{
-	int ret = -ENOTSUPP;
-
-	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
-		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
-
-	if (ret)
-		kvm_flush_remote_tlbs(kvm);
-}
-
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 		u64 start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
+	int ret = -EOPNOTSUPP;
 
 	range.start_gfn = start_gfn;
 	range.pages = pages;
 
-	kvm_flush_remote_tlbs_with_range(kvm, &range);
+	if (kvm_x86_ops.tlb_remote_flush_with_range)
+		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, &range);
+
+	if (ret)
+		kvm_flush_remote_tlbs(kvm);
 }
 
 static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
-- 
2.39.0.246.g2a6d74b583-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717EF75D905
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 04:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjGVCXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 22:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbjGVCXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 22:23:06 -0400
Received: from mail-oi1-x249.google.com (mail-oi1-x249.google.com [IPv6:2607:f8b0:4864:20::249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA631FFE
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 19:23:05 -0700 (PDT)
Received: by mail-oi1-x249.google.com with SMTP id 5614622812f47-3a4484a79a9so5568359b6e.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 19:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689992584; x=1690597384;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hJ4NFtSWgiMEwLg284CgQ5sPMcVW/iV/DNVpISC4B6I=;
        b=GFxwOMS7lRvlirAPbgAXoia3hbfdBq/xXx+dPhEh60FkKxGu7B/WsAv4yltvyZMVho
         ayvOW6s1YcZiNyAeIXC+jpj/2vCxd3q82OtgQJz+XpyvXHucFODQlnCPQmqcuGPZ5W5R
         zuUSN6iaEJpeVh0U45tQgiZHk6Waq7ZcGgZZneJmGA0M0l4nRWgk3qM8M5TeVUwIjAEY
         2bZ60w8i8oirvpfuPwCQIf5Q33UzWX1OmgiUg42nriPrsftxK5Dz/ynTGl93S8KOsCz7
         pj9VukTC7HRns0kEBNO/TDdV3GuxkNlEOZWCoEn4gJwYrxWQ+HnXAJAvWFI7DGXjcMBb
         WhIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689992584; x=1690597384;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hJ4NFtSWgiMEwLg284CgQ5sPMcVW/iV/DNVpISC4B6I=;
        b=Numxr7JkN3SQjcdsoBye7KkffkjQWkdOw3lm8Y4PfUHliI5wFMm/Xwbgd2c+KQkomb
         ExmhRrIuBY/8Vhl7cCintuYHqbIbR9+DqQY5yC+zqSrJncDI6vhyNsRxkFGHrcUhLtJW
         sDOq8ZbqlDS+CSxbFAgR1OSsDUHKVKdLZKxtqtvaY8JziB+kBRySXpy6f0fNefOs5vF1
         7WC3i/96IioLvCPxP856pZX0IjGxhbzuvApWg5Fq0UDvCF/h/e6va0s0Jz1OUcb/dkfN
         Blq7wxwhDceTR8rMb8AEMwRRX57y4GMXpZfEjN8GbNaZMItlIiYK3E8oX+r3/kK9h2aG
         K1YA==
X-Gm-Message-State: ABy/qLZG6eTuaFxVnBLjeva0E6P44eyWVFsuZ7NK11yKuO6ZGNG1qXIn
        7xZlF0jeVrsbpCIFLzh60VwGj5jkVloM
X-Google-Smtp-Source: APBJJlGAW+6/JrIYJI2JdLwtGX1LjNoUSmksaPTMtdqVT4U713h6cuykvY/ueRKWB3kJQ1QCRmdAmt+/OBPn
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6808:15a1:b0:3a1:e58d:aae0 with SMTP
 id t33-20020a05680815a100b003a1e58daae0mr8380023oiw.3.1689992584760; Fri, 21
 Jul 2023 19:23:04 -0700 (PDT)
Date:   Sat, 22 Jul 2023 02:22:49 +0000
In-Reply-To: <20230722022251.3446223-1-rananta@google.com>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230722022251.3446223-11-rananta@google.com>
Subject: [PATCH v7 10/12] KVM: arm64: Flush only the memslot after write-protect
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
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After write-protecting the region, currently KVM invalidates
the entire TLB entries using kvm_flush_remote_tlbs(). Instead,
scope the invalidation only to the targeted memslot. If
supported, the architecture would use the range-based TLBI
instructions to flush the memslot or else fallback to flushing
all of the TLBs.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 387f2215fde7..985f605e2abc 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1082,7 +1082,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	write_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
 	write_unlock(&kvm->mmu_lock);
-	kvm_flush_remote_tlbs(kvm);
+	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 /**
-- 
2.41.0.487.g6d72f3e995-goog


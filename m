Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B55567D469
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 19:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjAZSks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 13:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjAZSkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 13:40:47 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4F465F03
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:40:46 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id y66-20020a253245000000b007cb4f1e3e57so2771230yby.8
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oU7ZUJurLYW9x4bI+Kv9L/ycv+6RmeYBTA8gNQPNdxA=;
        b=ohWzxXZXsPNzIlyvbd2s071SX35P1VzikIV3cViCxs5y1YHT/pXpmwUq69QUARfOwl
         5xpWEPV3frrTxbrENM94ILfJNgZrXEL2IjmpWp1DxNwI9qrLO4dKQuRk9PzwDWImtPyR
         Lk3f6aRh4odIMYbsNnLv2UD3/TnGwSDwS2AI+1V+TxrxS87O96yqM/hYTby0ynaKJd6O
         L7HVsqOMlTVY4A2GM7lHg4/A08IsUEWDci+BGqQ/3831Lo00XtjCZ6nJ+s8atP/kXqV+
         ohnH/yDepl7Ib/4UcjUjvOIaSPVNLjRcPDpZJ9CfqQXTqu9euBWqOxllWJYH4e/mfSPT
         rVQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oU7ZUJurLYW9x4bI+Kv9L/ycv+6RmeYBTA8gNQPNdxA=;
        b=uDaU5FRL+atjvRbJiNeb0F3IufF1wyH21ry9PV/gdZMGcjq1kkMsVYFARTEIhI8Zsh
         DYDf0yAkk3fPfuk9H5cGy4+Ry3xmnn+NL0arpuikWBFhqMsOR3lXdi5kE3xmLv+CYI+9
         JuruzoiBEZtKoUu5gVHBUByKmegIUec4mfGb4kbpyvvJLx7lECxItEkexImdwHLQJLIg
         3gSw5bkEwB4JMcw/xwwSWErQUCZRSiDmXKVzRAKC8Q5U3Pf+bPa56a/tntvD8u8zj8Tl
         oMJ3edlUNxtR1qhOOlK7gFRjbvjcOTqnn38G/hbebJ0Us7p7MOVquG1S9FcHnP8YGZQj
         ZptA==
X-Gm-Message-State: AFqh2kqt3oPxXJhevX1a05WRyDG/HGEiNAJK3Dlqzee940AXZuylvD3/
        HnV3jKi7Y9YOzJZp5LUSr7jl78YPuYeXpg==
X-Google-Smtp-Source: AMrXdXu5cLu4gFuBX1mnOKYjOBTz2sSt6Jx7ftPu6Qft6goAkZI+WSVaQSuC1LB3Rt3uakEq2UJXO3GeP/tSSg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:c057:0:b0:802:898f:6e73 with SMTP id
 c84-20020a25c057000000b00802898f6e73mr2703455ybf.411.1674758445572; Thu, 26
 Jan 2023 10:40:45 -0800 (PST)
Date:   Thu, 26 Jan 2023 10:40:21 -0800
In-Reply-To: <20230126184025.2294823-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230126184025.2294823-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126184025.2294823-4-dmatlack@google.com>
Subject: [PATCH v2 3/7] KVM: x86/mmu: Collapse kvm_flush_remote_tlbs_with_{range,address}()
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
index c91ee2927dd7..b257f937d8a4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -247,27 +247,20 @@ static inline bool kvm_available_flush_tlb_with_range(void)
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
 
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index);
-- 
2.39.1.456.gfc5497dd1b-goog


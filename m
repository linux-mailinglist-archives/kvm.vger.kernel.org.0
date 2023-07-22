Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BC275D911
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 04:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjGVCX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 22:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjGVCXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 22:23:05 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955E21BF4
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 19:23:04 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c6dd0e46a52so2546925276.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 19:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689992584; x=1690597384;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=akm4rYoa5SWJwDL1p07vXyqImi8p1ZVsCq+MNzl6DtA=;
        b=gD47/RM4uIWWB198/JeUALJq9RfWDqhNJ9T5fekg0gN1CVJhZjOmQC08507malSUwO
         o8ec3lTUjSjfYC2IbUqRVy/vilrsVI8K95GVPsWlQt/qMh/hSichPIFf1Wekk8S82QaE
         aVRm06MJGxxB3ZyI2EnZn9V/QdvXIJ8ab6Dhuw8+FQ47EWQsWa9EmDNplWPwsPvOynXC
         jScOlOR/WNZmECtmPX+CzDPzHwrYlcah9TbaF8K5Alw1WCy7ukloCqn7xLelXXi0WAXJ
         ELXUAYxDpW3SIEct6UF/c4gbo3AktDz7eTG5eF/V+xS8z5st6Vf5lBWUrNNu9Q2slUD4
         LXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689992584; x=1690597384;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=akm4rYoa5SWJwDL1p07vXyqImi8p1ZVsCq+MNzl6DtA=;
        b=kjmB0W6Mgp7Oht+fLQW8jg2Afy2T5vU/GuODe25fxCForMwJ5DRHCiVrtEp3Xz1It6
         k19gUwIyuLSNNpSp4D8042JfFKulwXNYUd7ZeqLuMwVz1MvyiYYn7j7eRYM0ntGuH//d
         x/xech6KWNEUtzTHPy08fuX6kVQptYGeKHtxCfrFn+3SAg4p0yc4S2iUTL7ckHyc8lnU
         SOkwyWaqsFDc/ZKt2t98Nq5OzXInxJpcTL7+XksfnC/qB+YsSabPJ15KOLFszkVQIQpm
         8ieQSDFeX6u92xVgjw7OVJumt3Atb7RS0PdioaTmRM41UmfeOtNGn6fiRplLA1gIYQU8
         fsSw==
X-Gm-Message-State: ABy/qLbxdcOsk0t2/Q0RvnWvy7Kj5rkw0fRXV2LmQoQlhADeWfXUCKcn
        4MbHERIlxUQfvAvi6m5t8JGesTQn2hU8
X-Google-Smtp-Source: APBJJlFexiNbjtr9UnRFqoiOgPpMB6cQsXecNSzI+a2TM+h9ESr77gcH7b0vgVuv18SKk9XbnT1XiXcZKWub
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:aa05:0:b0:cf0:e2a2:eb3b with SMTP id
 s5-20020a25aa05000000b00cf0e2a2eb3bmr22446ybi.4.1689992583856; Fri, 21 Jul
 2023 19:23:03 -0700 (PDT)
Date:   Sat, 22 Jul 2023 02:22:48 +0000
In-Reply-To: <20230722022251.3446223-1-rananta@google.com>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230722022251.3446223-10-rananta@google.com>
Subject: [PATCH v7 09/12] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm_arch_flush_remote_tlbs_range() for arm64
to invalidate the given range in the TLB.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/mmu.c              | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7281222f24ef..52d3ed918893 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1114,6 +1114,9 @@ struct kvm *kvm_arch_alloc_vm(void);
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
 int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0ac721fa27f1..387f2215fde7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -172,6 +172,13 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 	return 0;
 }
 
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
+{
+	kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
+				start_gfn << PAGE_SHIFT, pages << PAGE_SHIFT);
+	return 0;
+}
+
 static bool kvm_is_device_pfn(unsigned long pfn)
 {
 	return !pfn_is_map_memory(pfn);
-- 
2.41.0.487.g6d72f3e995-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02B1738DB9
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 19:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjFURvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 13:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjFURuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 13:50:40 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEA2211F
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 10:50:30 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id e9e14a558f8ab-340c149231fso49108005ab.2
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 10:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687369829; x=1689961829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dtGUI04cZLcqHqfVph3GLMvS0CVYqac6sXI/vA3EN9c=;
        b=wUCfp8LIVxVyw9rOjJ+xxvqYiNhrMKEQGqZAIrYsflCWYaL7sMIjnn5LDzBF8HHkci
         fU6aqWxAcgnmVfiz4UwopUTnDAafaCROX3yoC8OfXmrNVemh4RlpXriU2kIUlflYJXHw
         uMCeKHy/l1FGUBNLLAGrP3KIWF3x8c8QA6lH15hhdrXNCDtmipcd1fYAZABG46exGlSO
         gFSuHconOaa66m/06jG0Ro0iy0bHzhaKM98M74q46S68x0wg14fu0205JCX28SDxNDoC
         IeVohMieqPadYlEk/nIWyWNaXHuxsT0P5qiOFBg+yGi/qLEjpv50H3iXe5QJF2vkwCpH
         B3PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687369829; x=1689961829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dtGUI04cZLcqHqfVph3GLMvS0CVYqac6sXI/vA3EN9c=;
        b=lOO9c3wvYl/xFnnze70yG4t+XIAawFfev86pcYgQ1Fd50S+IitfZuoSGcuKraFLiIM
         QjicJuy7GEjgAEePNbEM9xOJPa//txnRqrwe631eK31GT5N6vZq7J3M4ZYXnz2QFnF2S
         gp6PAJB6wrrqt0kexfkUpZCgFbTSMX2D0Rc6sKy3p8r26iacubPMKuDzb2FMU4W7mJ+U
         BVqDHJFytH9w1cqLJVdA2h1k+w+adY7DmosopSx16E1X08w/n6y7x3ZlhWAZR9auy6xA
         krCyh4My3uAYT9iEwUVRoU8EbVG9PH1Wv/QSXcTYuFAemcipXAun4uoPQ0yZxvwVSzK6
         jeOw==
X-Gm-Message-State: AC+VfDyk9BZ0/ie5FH8XCVi/N141++BSpN9i/7r6yLyuMQAlGfqljzor
        TjkKS6xDo3snmAvk863r0INX7n+akDVq
X-Google-Smtp-Source: ACHHUZ6E9qc4T7u9+yG0bI7LCSWrNIIprVuEXDN8tL08Gxqy8ruadzAtjVxDCW2tLBKnP2MlbqXA+k7+GwdZ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a92:c9cb:0:b0:33e:6230:aa65 with SMTP id
 k11-20020a92c9cb000000b0033e6230aa65mr6242404ilq.0.1687369829258; Wed, 21 Jun
 2023 10:50:29 -0700 (PDT)
Date:   Wed, 21 Jun 2023 17:49:59 +0000
In-Reply-To: <20230621175002.2832640-1-rananta@google.com>
Mime-Version: 1.0
References: <20230621175002.2832640-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230621175002.2832640-9-rananta@google.com>
Subject: [RESEND PATCH v5 08/11] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm_arch_flush_remote_tlbs_range() for arm64
to invalidate the given range in the TLB.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/mmu.c              | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 81ab41b84f436..343fb530eea9c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1081,6 +1081,9 @@ struct kvm *kvm_arch_alloc_vm(void);
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
 int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d0a0d3dca9316..c3ec2141c3284 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -92,6 +92,13 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
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
2.41.0.162.gfafddb0af9-goog


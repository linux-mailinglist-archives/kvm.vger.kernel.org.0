Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1E27786AD
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 06:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbjHKEvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 00:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbjHKEvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 00:51:42 -0400
Received: from mail-oo1-xc4a.google.com (mail-oo1-xc4a.google.com [IPv6:2607:f8b0:4864:20::c4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981812D61
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:39 -0700 (PDT)
Received: by mail-oo1-xc4a.google.com with SMTP id 006d021491bc7-56d2636c132so1709134eaf.3
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691729498; x=1692334298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ASzbcsqwIIPxgx+XyAMT2G1wf8WK9Z2hf5Cip/a2faA=;
        b=uAabUmiZLe4MoUbS9wWG4jcqfN0u7QlPThTWrmHmQHgIqkO2BufLaqzmmlZnIyCOO+
         T/L4kbkpAFt+ZBdM8kowjgzj6ukuum0CjGTGLYU3iRP5tAAb3o0Ntc7xlF3UR3cHB4tn
         DeUzU/obpskCQQfPFVk0wKOJHfy6VGzilCBOqGZ4AzgEZ8gbc7vfKZNsMiDf+Mnw4tyT
         6nipzycm7kXiOKYibxHOYUWZ2mkVxSRxc5NUa35+yCEee1ubON6GL22QYtP7OtxRf/u6
         JsUs87W8hFKFBeYOzN3POKlGxAmYSwY+LebXiY8Q3ZfGJNrmkf5yu6H0xJ2oAOGtMDcq
         RlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691729498; x=1692334298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ASzbcsqwIIPxgx+XyAMT2G1wf8WK9Z2hf5Cip/a2faA=;
        b=i7q+9A5a2Ijr4HzgYt6Xyf2zOv4CooMNVdCNjUFknmQXTXM7rXroOA7LdZrjdJXOuT
         kB9u+3v1z3T0cP1nk4AGC4jdxUOdcPZdLj2L8A7eHZWGhHNNQC2paEMpezOvIhUS9fQg
         QCm3USicTQPO22fh9cmzdVVfyJCaRLY643gExCViAp//ZHk/WzzEHHGrmsv8625otu5z
         kHrotkdM0kpYtscCG/apBf2x2IYkicvfS2taMygnj37AhRpCO/30E0shMY9Ehn9Mrns1
         tPyzaS79/mKzhDpbe6hXkxqqtZp69sQPUXpC8UahuxZNn+8Ij1Xah8nYrB4UQ+ApkXAe
         jkjQ==
X-Gm-Message-State: AOJu0Ywn0lJBXirmygA8UtZ/rye3YOLTiQ/h4jX8Kj//XwsMmpK0Zid5
        punD0mE3dxWW6UcVXWqOLYtLCNUakBrH
X-Google-Smtp-Source: AGHT+IE/nnO7E1ywpn5IoMTUCGRwpLBu6xlqSUrvCHD1gTpM15da9wapCOhtsOAsZCjiWO4g5dJl7qthkafm
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6870:a8a8:b0:1bf:d3b8:5cae with SMTP
 id eb40-20020a056870a8a800b001bfd3b85caemr12117oab.10.1691729498753; Thu, 10
 Aug 2023 21:51:38 -0700 (PDT)
Date:   Fri, 11 Aug 2023 04:51:16 +0000
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811045127.3308641-4-rananta@google.com>
Subject: [PATCH v9 03/14] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
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
        kvm@vger.kernel.org, Shaoqin Huang <shahuang@redhat.com>,
        Gavin Shan <gshan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stop depending on CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL and opt to
standardize on kvm_arch_flush_remote_tlbs() since it avoids
duplicating the generic TLB stats across architectures that implement
their own remote TLB flush.

This adds an extra function call to the ARM64 kvm_flush_remote_tlbs()
path, but that is a small cost in comparison to flushing remote TLBs.

In addition, instead of just incrementing remote_tlb_flush_requests
stat, the generic interface would also increment the
remote_tlb_flush stat.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/Kconfig            | 1 -
 arch/arm64/kvm/mmu.c              | 6 +++---
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8b6096753740c..20f2ba149c70c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1111,6 +1111,8 @@ int __init kvm_set_ipa_limit(void);
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index f531da6b362e9..6b730fcfee379 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -25,7 +25,6 @@ menuconfig KVM
 	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
-	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_XFER_TO_GUEST_WORK
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6db9ef288ec38..0ac721fa27f18 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -161,15 +161,15 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
 }
 
 /**
- * kvm_flush_remote_tlbs() - flush all VM TLB entries for v7/8
+ * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
  * @kvm:	pointer to kvm structure.
  *
  * Interface to HYP function to flush all VM TLB entries
  */
-void kvm_flush_remote_tlbs(struct kvm *kvm)
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
-	++kvm->stat.generic.remote_tlb_flush_requests;
 	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
+	return 0;
 }
 
 static bool kvm_is_device_pfn(unsigned long pfn)
-- 
2.41.0.640.ga95def55d0-goog


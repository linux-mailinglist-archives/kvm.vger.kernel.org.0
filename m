Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F71A67400E
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 18:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjASRgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 12:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjASRgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 12:36:11 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA6048A05
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:36:10 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id h8-20020a170902f54800b00194b9e80861so1723954plf.9
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YXwKcERxaLuVKb5nhPV+CPBgH/1CDOfYUJatcNI9Lps=;
        b=OTqsYX12neD7rYwEWRn8ph1+Ivtv7Ny3gNRUzRN4gpl2Eo4fWlPbPU6In/4jxn719a
         2slMyQuQUGYeMW/mBJE87s2KFofWL2A+b2t0AGtJWafNEsGMAYWeQipZoQ1wuc/AwP98
         q6x1X0TMG1Ad+kT9cWeSraqE2aVQjTFYY8XrvpXdV5XrOCH5Z0/4P8kT8Gk2C8Whx2FG
         81gR4+aJciehqPLB3q7y9lYytTmBxQ2kqUF/pcLWKVy8x5Z3rc4oYcrFbsLGgX3dj310
         jjv6aYJuXYmn/PCkMZw8+4RuZGYn5ZS3Cw5swhmMDgbV/Bu5G0pBJ9SOJXuv6t7ZXXHT
         rVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YXwKcERxaLuVKb5nhPV+CPBgH/1CDOfYUJatcNI9Lps=;
        b=d6JOrIiS8SgOGCEoxp8kH/JtyGPKX6J/USwmFuRXxz2TcZZVKi79c6JATKfzVe5GqQ
         hpSCyXQYYo1QWXJlB/2vq+iWS9BwJthrISCTpb6vTUfO4Q38NVcT1hF7So/jTBSiH9xo
         ZJAQdMyT0Y6/CoeLBPmj9sJllcIGCd3e7958j1b4ldo9Yozn5gX7xZXBg+jQFJAbx9JU
         YAi+FM4c0t3VUqbR9muxRFJGM36afpD7M3+g/6W6+7+9OsOYTMLzgW1BMlgTLE3rmwOb
         YiHaBdnGd7a8l57SjKITtQ3we6to+ehwFTDEcVO+ZUjVKxiy14FmzzetSF3QTrE1ajPG
         zgjQ==
X-Gm-Message-State: AFqh2koLKb62b+eAnsztSO0HIMbuUwxsBFunnFLOnvohDcD91z/KfPLU
        8KAh9zw+snnKgbcR7eqD50ZgXBMfCST5BA==
X-Google-Smtp-Source: AMrXdXuXExC+O9r6ly79uchmV3y9bAojfkYhjynfBp2nNUiPyiTU/esa3EM+EgTfMCGZFP3dGppk25OULxh7DA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:24d4:b0:58b:a320:29b9 with SMTP
 id d20-20020a056a0024d400b0058ba32029b9mr1062701pfv.38.1674149769306; Thu, 19
 Jan 2023 09:36:09 -0800 (PST)
Date:   Thu, 19 Jan 2023 09:35:52 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119173559.2517103-1-dmatlack@google.com>
Subject: [PATCH 0/7] KVM: Add a common API for range-based TLB invalidation
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

This series introduces a common API for performing range-based TLB
invalidation. This is then used to supplant
kvm_arch_flush_remote_tlbs_memslot() and pave the way for two other
patch series:

1. https://lore.kernel.org/kvm/20230109215347.3119271-1-rananta@google.com/

  Adds ARM support for range-based TLB invalidation and needs a
  mechanism to invoke it from common code. This series provides such a
  mechanism via kvm_arch_flush_remote_tlbs_range().

2. https://lore.kernel.org/kvm/20221208193857.4090582-1-dmatlack@google.com/

  Refactors the TDP MMU into common code, which requires an API for
  range-based TLB invaliation.

This series is based on patches 29-33 from (2.), but I made some further
cleanups after looking at it a second time.

Tested on x86_64 and ARM64 using KVM selftests.

Cc: Raghavendra Rao Ananta <rananta@google.com>

David Matlack (7):
  KVM: Rename kvm_arch_flush_remote_tlb() to
    kvm_arch_flush_remote_tlbs()
  KVM: arm64: Use kvm_arch_flush_remote_tlbs()
  KVM: x86/mmu: Collapse kvm_flush_remote_tlbs_with_{range,address}()
    together
  KVM: x86/mmu: Rename kvm_flush_remote_tlbs_with_address()
  KVM: x86/MMU: Use gfn_t in kvm_flush_remote_tlbs_range()
  KVM: Allow range-based TLB invalidation from common code
  KVM: Move kvm_arch_flush_remote_tlbs_memslot() to common code

 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/Kconfig            |  1 -
 arch/arm64/kvm/arm.c              |  6 ---
 arch/arm64/kvm/mmu.c              |  6 +--
 arch/mips/include/asm/kvm_host.h  |  4 +-
 arch/mips/kvm/mips.c              | 12 ++----
 arch/riscv/kvm/mmu.c              |  6 ---
 arch/x86/include/asm/kvm_host.h   |  7 +++-
 arch/x86/kvm/mmu/mmu.c            | 68 ++++++++++---------------------
 arch/x86/kvm/mmu/mmu_internal.h   |  2 -
 arch/x86/kvm/mmu/paging_tmpl.h    |  4 +-
 arch/x86/kvm/mmu/tdp_mmu.c        |  7 ++--
 arch/x86/kvm/x86.c                |  2 +-
 include/linux/kvm_host.h          | 20 ++++++---
 virt/kvm/kvm_main.c               | 35 +++++++++++++---
 15 files changed, 87 insertions(+), 96 deletions(-)


base-commit: de60733246ff4545a0483140c1f21426b8d7cb7f
prerequisite-patch-id: 42a76ce7cec240776c21f674e99e893a3a6bee58
prerequisite-patch-id: c5ef6bbef252706b7e65b76dc9bd92cf320828f5
prerequisite-patch-id: c6e662cb6c369a47a027c25d3ccc7138a19b17f5
prerequisite-patch-id: 15a58bec64bf1537e6c9e2f52179fac652d441f7
prerequisite-patch-id: d5b6fea4724f4f2c3408b95d7ce5acdd4b528b10
-- 
2.39.0.246.g2a6d74b583-goog


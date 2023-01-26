Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F9367D463
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 19:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjAZSkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 13:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjAZSkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 13:40:41 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0019F402D8
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:40:40 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4fa63c84621so29783567b3.20
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ie07OawPNI+tJK8/hFSWiI7XFoX01SxG+4YwTEZViLQ=;
        b=D1zilxz/MrFwcNOLMT1LAITkqOyJHoIg1OvmdTgNrSXt2+8bKehEyhZdJ83wWYuURL
         Y0TlzIojPMrAY/CU2EgKBxKy8Nx8rmheh1GkuQRsxJHJN2NAKEqwzghdwiLNFihCDWAp
         xAqgswB2O5bVSkkHVOV/HJM6lOVfZSqt9ReqdJP9r1WG6enSrRiCbP2umw7Iz+8nswUx
         YO7YdtyP+HTlvOTCLKBJfy3cdltcIpQzviK1n84DUaBgb2qM5tqpM8I9zoSX/91t7Yqw
         jiFcfGub83bVeaJzvdpdizULguQj8McM0NB0eAlP96DiLVznXsRzwRYQJ3xMSNQhmSRM
         +wUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ie07OawPNI+tJK8/hFSWiI7XFoX01SxG+4YwTEZViLQ=;
        b=XkCSBjgek0ZNtJ/R+saYfDBNhIuzMpuPG6EtpLBUiclRxTEAhdg3ESKRcYY7H7wObd
         zrVkWoaUxvzfztfbYECzhmmEAlShstUe9ZOjsh0Y/OeZzwogexGLiKQahmceNPAgA8rc
         Mz8bs/H7hMGWoO4/0lXN96fQGy510c6oJevOqj5IkLZ/7FfRuz+l/x0uNSfA2YsXh3ca
         wkLiPo3+SBVS4aG6pCTmfRE6jZoCC4yyN/RE5bZL3l5nDEP0WQR1BXttRIrbSLjqCmw8
         ahYNRIN58/HbwhgrVSJlVnl42Uo1KB7EYdl++rxx3jycJh4BvM9fgDOvtHbfAQV+61Ys
         0Srw==
X-Gm-Message-State: AFqh2kq0tjYzMabE0VBScYPWOyPUl34Q0b4jumeHxSYc6KIXIBLJgxys
        iTeYbtCnkVAxfndqNd8w9aG0OyOU1ZCVUw==
X-Google-Smtp-Source: AMrXdXvYhsT+DA2KA1c/9P+wVBnv1OdnS37rNGakXvNF40eWFc5OqICy7ZZvOWGpLhibmaIEJb5soSQRpzz3bA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:4f81:0:b0:502:92ae:5123 with SMTP id
 d123-20020a814f81000000b0050292ae5123mr2486176ywb.99.1674758440211; Thu, 26
 Jan 2023 10:40:40 -0800 (PST)
Date:   Thu, 26 Jan 2023 10:40:18 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126184025.2294823-1-dmatlack@google.com>
Subject: [PATCH v2 0/7] KVM: Add a common API for range-based TLB invalidation
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

v2:
 - Rebased on top of kvm-x86/next to resolve conflicts in changes slated
   for 6.3 [Sean]
 - Drop CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL from virt/kvm/Kconfig
   [Oliver]

v1: https://lore.kernel.org/kvm/20230119173559.2517103-1-dmatlack@google.com/

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
 arch/arm64/kvm/arm.c              |  6 ----
 arch/arm64/kvm/mmu.c              |  6 ++--
 arch/mips/include/asm/kvm_host.h  |  4 +--
 arch/mips/kvm/mips.c              | 12 ++------
 arch/riscv/kvm/mmu.c              |  6 ----
 arch/x86/include/asm/kvm_host.h   |  7 +++--
 arch/x86/kvm/mmu/mmu.c            | 46 +++++++------------------------
 arch/x86/kvm/mmu/mmu_internal.h   |  7 ++---
 arch/x86/kvm/x86.c                |  2 +-
 include/linux/kvm_host.h          | 20 ++++++++++----
 virt/kvm/Kconfig                  |  3 --
 virt/kvm/kvm_main.c               | 35 +++++++++++++++++++----
 14 files changed, 73 insertions(+), 85 deletions(-)


base-commit: 503f0315c97739d3f8e645c500d81757dfbf76be
prerequisite-patch-id: 42a76ce7cec240776c21f674e99e893a3a6bee58
prerequisite-patch-id: c5ef6bbef252706b7e65b76dc9bd92cf320828f5
prerequisite-patch-id: c6e662cb6c369a47a027c25d3ccc7138a19b17f5
prerequisite-patch-id: 15a58bec64bf1537e6c9e2f52179fac652d441f7
prerequisite-patch-id: d5b6fea4724f4f2c3408b95d7ce5acdd4b528b10
-- 
2.39.1.456.gfc5497dd1b-goog


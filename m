Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31093B25C4
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 05:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhFXEBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 00:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhFXEBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 00:01:37 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1852BC061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 20:59:18 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id y14so3588041pgs.12
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 20:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BxIaFDPbAuZHR6J/S83W0A67K8R9coNY4bId9HsipsE=;
        b=RBtU16Scd9URJKreXZFwanEfHJ1XRZJXhO4qEt4uU8YvBtSRsG8M0Msq7z7U3gBGbw
         UdDX7s8F5odJ8nqB9b8EVGbHLmPHB74/ZvZg8RK4YeZb6UMq7MIYumlvjDcfnL6WHIaV
         l3qHnUTf57CgLtDUOfr/2EStz1LFXjnziJK6o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BxIaFDPbAuZHR6J/S83W0A67K8R9coNY4bId9HsipsE=;
        b=c3ag2gFcBCUCQ0noeZ01gejVtWjVmsNQ2xcyU+yYnJNthKDQZ3PjTpcwTk1ULtQn3T
         TToHsQDBT8C1dzpU6r5M+ii7OozT87eaU6cN9MmuSO+zSl2II5uHy+zSirM2gahLtlIh
         ZUdvf5LjoW4GqaB8vyoYCToJls3G1FULTLsg4B/8XifR4fjodEdwsuOXz736clp7kmXK
         N1PPO72/Jy9CGPkI/45dqmVMmUW5hc+8InB3vXOweyrnaH5bnO6ikz5170SOmBSZRaJM
         11RHYn/k2F0BSocf533SvAXi6z30bG0e1xAtKwV2hrlSN8y1hyDsgx+w17LVkmzRQL9V
         Whig==
X-Gm-Message-State: AOAM531dIiH5dg62jO6Y2zare54MSy1oWwh6aFGrxsBL4x9rIYBCVLqI
        DErtCua1AqhErfO0qRWHtVIx6Q==
X-Google-Smtp-Source: ABdhPJw/0bUD4wxiHYbbe+W1J6aaPXVUUYjx3vGkULT22ezX3dEs1tG4sWixYLws/tdmOS++kmqsRg==
X-Received: by 2002:aa7:96fc:0:b029:2e9:e827:928f with SMTP id i28-20020aa796fc0000b02902e9e827928fmr2818805pfq.49.1624507157546;
        Wed, 23 Jun 2021 20:59:17 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:5038:6344:7f10:3690])
        by smtp.gmail.com with UTF8SMTPSA id j15sm1163260pfh.194.2021.06.23.20.59.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 20:59:16 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        David Stevens <stevensd@google.com>
Subject: [PATCH 0/6] KVM: Remove uses of struct page from x86 and arm64 MMU
Date:   Thu, 24 Jun 2021 12:57:43 +0900
Message-Id: <20210624035749.4054934-1-stevensd@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM supports mapping VM_IO and VM_PFNMAP memory into the guest by using
follow_pte in gfn_to_pfn. However, the resolved pfns may not have
assoicated struct pages, so they should not be passed to pfn_to_page.
This series removes such calls from the x86 and arm64 secondary MMU. To
do this, this series modifies gfn_to_pfn to return a struct page in
addition to a pfn, if the hva was resolved by gup. This allows the
caller to call put_page only when necessated by gup.

This series provides a helper function that unwraps the new return type
of gfn_to_pfn to provide behavior identical to the old behavior. As I
have no hardware to test powerpc/mips changes, the function is used
there for minimally invasive changes. Additionally, as gfn_to_page and
gfn_to_pfn_cache are not integrated with mmu notifier, they cannot be
easily changed over to only use pfns.

This addresses CVE-2021-22543 on x86 and arm64.

David Stevens (6):
  KVM: x86/mmu: release audited pfns
  KVM: mmu: also return page from gfn_to_pfn
  KVM: x86/mmu: avoid struct page in MMU
  KVM: arm64/mmu: avoid struct page in MMU
  KVM: mmu: remove over-aggressive warnings
  drm/i915/gvt: use gfn_to_pfn's page instead of pfn

 arch/arm64/kvm/mmu.c                   |  42 +++++----
 arch/mips/kvm/mmu.c                    |   3 +-
 arch/powerpc/kvm/book3s.c              |   3 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |   5 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |   5 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c     |   4 +-
 arch/powerpc/kvm/e500_mmu_host.c       |   2 +-
 arch/x86/kvm/mmu/mmu.c                 |  60 ++++++------
 arch/x86/kvm/mmu/mmu_audit.c           |  13 ++-
 arch/x86/kvm/mmu/mmu_internal.h        |   3 +-
 arch/x86/kvm/mmu/paging_tmpl.h         |  36 +++++---
 arch/x86/kvm/mmu/tdp_mmu.c             |   7 +-
 arch/x86/kvm/mmu/tdp_mmu.h             |   4 +-
 arch/x86/kvm/x86.c                     |   9 +-
 drivers/gpu/drm/i915/gvt/gtt.c         |  12 ++-
 drivers/gpu/drm/i915/gvt/hypercall.h   |   3 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c       |  12 +--
 drivers/gpu/drm/i915/gvt/mpt.h         |   8 +-
 include/linux/kvm_host.h               |  27 ++++--
 include/linux/kvm_types.h              |   5 +
 virt/kvm/kvm_main.c                    | 123 +++++++++++++------------
 21 files changed, 212 insertions(+), 174 deletions(-)

-- 
2.32.0.93.g670b81a890-goog


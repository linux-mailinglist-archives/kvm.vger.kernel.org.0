Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B644141BE3B
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 06:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244002AbhI2EbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 00:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243938AbhI2EbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 00:31:12 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D974FC061745
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 21:29:31 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id m21so1339892pgu.13
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 21:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QkzreDQI8QXcNj6KF3HsvP+QbXFPHw1Mmnt63rKUKkA=;
        b=SUgnMZX/AWTndTbWHhZMsZ/Q8rq2mha6o26G7OvAkCmtpgykvlWgC91PFYQimoCXyV
         v8PubmTDiQJMqehVuvd15V+PbUnLDyYAlOhEqLeGTkimABHe/8DNH5GMjyR3wqkwUf4N
         LrwHmT0opEc0XBq0yUrUiNhN23ksP4p5EJqgE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QkzreDQI8QXcNj6KF3HsvP+QbXFPHw1Mmnt63rKUKkA=;
        b=hMiW/+peuGv6CgL7CG67LmdTYkZcpLg6Qd8NXLXeCRrL21GB0xt8XtbnAj5IARIW07
         JmwtjstdmQeMH/gGiYwyyAa1Uu24RL+xyuYSOeduWv564JBi36YT2MLpsUcp9MFlUnXY
         sx/axs6zXEf8imupIYzoXYZJlmpiOgxu6j5V1RLU9c4/1edrgI5xcX3N3WiUujdd4l26
         h4nivETlV6y1S8zEkPt6fkFO/pPeqi4zGBtEW6bxsh+zLuVOc3KNCzsrTQcOnF2BAh/o
         bRlP019kGxBdaq7H6nfAnTKpGNA+nuZGG7BjREhu9se3OJDSMchUMc3hvKVSvWt9zKdo
         oIzw==
X-Gm-Message-State: AOAM533whfqgA416Jy1rHZSNM5COq/PeRSMPca+E4kkgtUWJMJ6KWTTW
        TEVsNwpzXKA5fPYIATRUaweHTg==
X-Google-Smtp-Source: ABdhPJwdVPiqe25K8PElzE9sWsXwBxyck9GIaCUbQQkjXlHvGKR9mvFoORzocViMa6RYiKVWceOf5A==
X-Received: by 2002:a63:e741:: with SMTP id j1mr7938740pgk.86.1632889771324;
        Tue, 28 Sep 2021 21:29:31 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:f818:368:93ef:fa36])
        by smtp.gmail.com with UTF8SMTPSA id b5sm261924pjk.18.2021.09.28.21.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 21:29:30 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v4 0/4] KVM: allow mapping non-refcounted pages
Date:   Wed, 29 Sep 2021 13:29:04 +0900
Message-Id: <20210929042908.1313874-1-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

This patch series adds support for mapping non-refcount VM_IO and
VM_PFNMAP memory into the guest.

Currently, the gfn_to_pfn functions require being able to pin the target
pfn, so they will fail if the pfn returned by follow_pte isn't a
ref-counted page.  However, the KVM secondary MMUs do not require that
the pfn be pinned, since they are integrated with the mmu notifier API.
This series adds a new set of gfn_to_pfn_page functions which parallel
the gfn_to_pfn functions but do not pin the pfn. The new functions
return the page from gup if it was present, so callers can use it and
call put_page when done.

The gfn_to_pfn functions should be depreciated, since as they are unsafe
due to relying on trying to obtain a struct page from a pfn returned by
follow_pte. I added new functions instead of simply adding another
optional parameter to the existing functions to make it easier to track
down users of the deprecated functions.

This series updates x86 and arm64 secondary MMUs to the new API.

v3 -> v4:
 - rebase on kvm next branch again
 - Add some more context to a comment in ensure_pfn_ref
v2 -> v3:
 - rebase on kvm next branch
v1 -> v2:
 - Introduce new gfn_to_pfn_page functions instead of modifying the
   behavior of existing gfn_to_pfn functions, to make the change less
   invasive.
 - Drop changes to mmu_audit.c
 - Include Nicholas Piggin's patch to avoid corrupting refcount in the
   follow_pte case, and use it in depreciated gfn_to_pfn functions.
 - Rebase on kvm/next

David Stevens (4):
  KVM: mmu: introduce new gfn_to_pfn_page functions
  KVM: x86/mmu: use gfn_to_pfn_page
  KVM: arm64/mmu: use gfn_to_pfn_page
  KVM: mmu: remove over-aggressive warnings

 arch/arm64/kvm/mmu.c            |  27 +++--
 arch/x86/kvm/mmu/mmu.c          |  50 ++++----
 arch/x86/kvm/mmu/mmu_internal.h |   3 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  23 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |   6 +-
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
 arch/x86/kvm/x86.c              |   6 +-
 include/linux/kvm_host.h        |  17 +++
 virt/kvm/kvm_main.c             | 198 +++++++++++++++++++++++---------
 9 files changed, 231 insertions(+), 103 deletions(-)

-- 
2.33.0.685.g46640cef36-goog


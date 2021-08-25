Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88213F6D83
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 04:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237002AbhHYCvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 22:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhHYCv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 22:51:29 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB115C061764
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 19:50:44 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso3139977pjh.5
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 19:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G+VFbxZv56JqJJvHvZfxmdl5/mMwzz6LNS7nJgyEuFg=;
        b=PuRuwB6GpTZkYLCohD7vc5rbOm294HWMBPOKGiKyMcID0d/cqaUomfm4BIGY/jgOL3
         IGabpTvdWyYabHtI4zlkTEsxa3btaZbdtY8jO5jSGxiFSrKVrc7KOS8a7z3HapC8BNcS
         QGRYo/m43G5PNg6mhJEEn7nooJHKIHnJPb7/Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G+VFbxZv56JqJJvHvZfxmdl5/mMwzz6LNS7nJgyEuFg=;
        b=H2dwWF27gSQ3gx91/ff8Y7WWJ3IEdlEl97vA4+2KLQZKhRm5LXJhz0Cj66CqFP8zIz
         xS97dxBRvzcEfAwxJ5qV11Jgh6aa6JmH9J3O2i2JGhulZMgcimi5sYge4f5/hm9Zkgev
         3V0Lh4B0oXAL5ik2LS2mXhCK6/X55li9SgZFqVISbdlhUQETi1/zIr6lxbC3IJl6tF4X
         H5oKliIfULQAJNE8TMxrXM27y50cHAS7ucW34ZMVF3HzCLY/WOZI6xBh/++ED+loOKVt
         SPd9M7MZV7xByaddBERfHMGsy1SeuAmwcgyia6JZaovh8CvszW6w/ygjgDYIpAT9GELd
         wtzA==
X-Gm-Message-State: AOAM530Gom19R258eGNZaPiQez1BseglXHPb7jOXRZWzeqHFlXwAagVH
        Q3bLKRMVdRbbv7sFy/Dzr3z9QQ==
X-Google-Smtp-Source: ABdhPJw71JeKXknXk4vWPDjxlltZQjqQ6fdlXY/CarzMWUi3FciPU9uv5juBIo+m4zTlv2vl32DI8A==
X-Received: by 2002:a17:90a:b00e:: with SMTP id x14mr7953567pjq.155.1629859844343;
        Tue, 24 Aug 2021 19:50:44 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:d273:c78c:fce8:a0e2])
        by smtp.gmail.com with UTF8SMTPSA id j6sm20237041pfn.107.2021.08.24.19.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 19:50:44 -0700 (PDT)
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
Subject: [PATCH v3 0/4] KVM: allow mapping non-refcounted pages
Date:   Wed, 25 Aug 2021 11:50:05 +0900
Message-Id: <20210825025009.2081060-1-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
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

 arch/arm64/kvm/mmu.c            |  26 +++--
 arch/x86/kvm/mmu/mmu.c          |  50 +++++----
 arch/x86/kvm/mmu/mmu_internal.h |   3 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  23 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |   6 +-
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
 arch/x86/kvm/x86.c              |   6 +-
 include/linux/kvm_host.h        |  17 +++
 virt/kvm/kvm_main.c             | 188 +++++++++++++++++++++++---------
 9 files changed, 220 insertions(+), 103 deletions(-)

-- 
2.33.0.rc2.250.ged5fa647cd-goog


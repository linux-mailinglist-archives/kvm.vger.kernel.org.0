Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FF7460DBC
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 04:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377117AbhK2Dt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 22:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352168AbhK2Dr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 22:47:58 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67018C0613F7
        for <kvm@vger.kernel.org>; Sun, 28 Nov 2021 19:43:38 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id k4so11042767plx.8
        for <kvm@vger.kernel.org>; Sun, 28 Nov 2021 19:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g1AjNx0u4QsH0ydDfhoNnZaeQc7rEh0mvCty4L4f7eQ=;
        b=Wt8FaLZ08KUnARUpfZuFUX8/aWHCXUzDWW38X2tieklC/DI06HFADNTel2urdcLghd
         6xuwD96bktbINCX1L48Tnqrgt/rnLZX0XjKzef2OqinmBYRmyB92QmVHjIXnsa4D3adc
         Ewoo7Xso2SY8bIPCIsveHyTJlUKvgLq1OWVdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g1AjNx0u4QsH0ydDfhoNnZaeQc7rEh0mvCty4L4f7eQ=;
        b=0l0Z/EKgzQQ7lA3OaAO0EWE9/L8hYHa5/SqPFMTDJEp7YOppBqYVSqsaFcc+V3XXts
         CI9o7VfdRHjVOM9KLVkVAMvFbUn2jlpibjhKtGnh1HccP6FcmuEJ3o4QSybURhQ6QNXp
         91KuwFRc3/F10a1BnnWB5QLUmKcI6tqXiuIL75VAj8Gr6647Pw1sgmkV5g0HoCjswdGo
         cd6NGTsvoji3g9Bc9K81hK7ghePTJ3N6FjosbfI7tW3B/poymD9uVDsG9kLCUoejvDEj
         cHdtMiMXsdD48B9tjR+dNmiW87cVgywkJ+OynG9tf3GoljnndRzUNLqfENaV0rOW5mph
         eexQ==
X-Gm-Message-State: AOAM533qa6Cbv1ys9atJbGvD6bhi1E5TP9WSml8K5A65JImhVE/qLxLk
        mn1+E1RTYVZl366NKM29oyJn9g==
X-Google-Smtp-Source: ABdhPJxLhGhNYMx62P8hwpiqGSK0LeOGFyNZHJnZlg3ztGeJOu1G+77rZi203d7zD5d/O00+rTeohw==
X-Received: by 2002:a17:902:ee95:b0:141:f28f:7296 with SMTP id a21-20020a170902ee9500b00141f28f7296mr58161089pld.50.1638157417973;
        Sun, 28 Nov 2021 19:43:37 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:72d1:80f6:e1c9:ed0a])
        by smtp.gmail.com with UTF8SMTPSA id r14sm6895238pgj.64.2021.11.28.19.43.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 19:43:37 -0800 (PST)
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
Subject: [PATCH v5 0/4] KVM: allow mapping non-refcounted pages
Date:   Mon, 29 Nov 2021 12:43:13 +0900
Message-Id: <20211129034317.2964790-1-stevensd@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
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

v4 -> v5:
 - rebase on kvm next branch again
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

 arch/arm64/kvm/mmu.c           |  27 +++--
 arch/x86/kvm/mmu.h             |   1 +
 arch/x86/kvm/mmu/mmu.c         |  25 ++---
 arch/x86/kvm/mmu/paging_tmpl.h |   9 +-
 arch/x86/kvm/x86.c             |   6 +-
 include/linux/kvm_host.h       |  17 +++
 virt/kvm/kvm_main.c            | 198 ++++++++++++++++++++++++---------
 7 files changed, 202 insertions(+), 81 deletions(-)

-- 
2.34.0.rc2.393.gf8c9666880-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9343DC160
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 01:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbhG3W7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbhG3W7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 18:59:49 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75320C0613C1
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:59:44 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id w19-20020a170902d113b029012c1505a89fso1045641plw.13
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=Lbc7sqdkn0ZF7q/zL1zy+BZt85TGXNNC6j+dLXsHB30=;
        b=ABuyA90o4Rfv0gzWABXk1bFOn0wAMNeb7lswrtyy4kTA8yKt04WtaVefJfFSfKWBd+
         U/lNa9oIrhkWA883+nSUV6HbAUTFAmvDdD0/j7vmGvCO0/WoEv2vYAu6tJIx5xrVsVak
         3gUSVJFJ6193JwCZeXc+CnLLNiVuNBMG5vP/WRUPMxHkR88+I/52GlVZIzjij1bWuOJS
         +Ky/Svl/BLJQus7AX0lDBgKtHyojq49tQCDTXREOjxCSEXkNgiViRd3Ub0s+LBnwocAV
         eiAfHXKreb3xeWqWI3dDZr+QuEV0RLUrPTuZ+SbIk4b/kJJ5v+TGGPVcVIawdvEOw9tD
         +kXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=Lbc7sqdkn0ZF7q/zL1zy+BZt85TGXNNC6j+dLXsHB30=;
        b=ucejyme2Y7tW/OmQD/vXZXWRRpZAOk3sWBMdr0G9PGfIYw4yNjExh7SIjg7ytVM1/j
         ee60OHObOZmu1XHpobtYxE1kqtiIBTyplkQD8saT6olIEF3yo1UQhekkhJ3jb0ZJ9L0y
         fB15j0zvrIVCJFetiFvqoxIaW5yG89bN9s3mVSODYqo2hiUCv3wnssgUcdZsMbtfoeDN
         o3CO6ab7NWs1pURp2m5pUpDy1DrmwoVoJunclFxlqBHwYgQcHCCCWmRIY2oYZ/t/h2Kc
         N3c8Tvu9dffT4q32O1T4vFSIRhB9SiOpvlKMNIaWx+jMjO3BPJeuD7Z4IWQVv04vZsoN
         eMBQ==
X-Gm-Message-State: AOAM533kUMCffcEYBC54GPc0qvUJhTmwxOHZBx98q97qzoEjFWHXXbOb
        c4jcEEwWGojVWIEjLnfrWSnyj22phM6i
X-Google-Smtp-Source: ABdhPJwvSUjcF/nenM4qr4VcNEtPQB86OCURhK9iR4YwszYBEH9gvVxRbSJBpcXzw85ov8SxlvX8BiCdEDvA
X-Received: from mihenry-linux-desktop.kir.corp.google.com ([2620:15c:29:204:a198:4c3e:b951:58e3])
 (user=mizhang job=sendgmr) by 2002:aa7:8148:0:b029:31b:10b4:f391 with SMTP id
 d8-20020aa781480000b029031b10b4f391mr4714934pfn.69.1627685984030; Fri, 30 Jul
 2021 15:59:44 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Fri, 30 Jul 2021 15:59:36 -0700
Message-Id: <20210730225939.3852712-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 0/3] Add detailed page size stats in KVM stats
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit basically adds detailed (large and regular) page size info to
KVM stats and deprecate the old one: lpages.

To support legacy MMU and TDP mmu, we use atomic type for all page stats.

v2 -> v3:
 - move kvm_update_page_stats to mmu.h as a static inline function. [sean]
 - remove is_last_spte check in mmu_spte_clear_track_bits. [bgardon]
 - change page_stats union by making it anonymous. [dmatlack]

v1 -> v2:
 - refactor kvm_update_page_stats and remove 'spte' argument. [sean]
 - remove 'lpages' as it can be aggregated by user level [sean]
 - fix lpages stats update issue in __handle_change_pte [sean]
 - fix style issues and typos. [ben/sean]

pre-v1 (internal reviewers):
 - use atomic in all page stats and use 'level' as index. [sean]
 - use an extra argument in kvm_update_page_stats for atomic/non-atomic.
   [bgardon]
 - should be careful on the difference between legacy mmu and tdp mmu.
   [jingzhangos]


Mingwei Zhang (3):
  kvm: mmu/x86: Remove redundant spte present check in mmu_set_spte
  KVM: x86/mmu: Avoid collision with !PRESENT SPTEs in TDP MMU lpage
    stats
  kvm: mmu/x86: Add detailed page size stats

 arch/x86/include/asm/kvm_host.h | 10 +++++++-
 arch/x86/kvm/mmu.h              |  2 ++
 arch/x86/kvm/mmu/mmu.c          | 42 ++++++++++++++++++---------------
 arch/x86/kvm/mmu/tdp_mmu.c      |  9 ++-----
 arch/x86/kvm/x86.c              |  7 ++++--
 5 files changed, 41 insertions(+), 29 deletions(-)

--
2.32.0.432.gabb21c7263-goog


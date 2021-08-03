Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AA43DE5A8
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 06:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbhHCEqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 00:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbhHCEqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 00:46:39 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5ECAC06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 21:46:26 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c1-20020a170902aa41b02901298fdd4067so12698179plr.0
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 21:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=xUAn1SFGSbX/PJThgRvGPBeZbin4ckymuiwWI24odS0=;
        b=KXs30yTrLMEs8DkxavYlwKUkhA5CDXu64qEWjOwtd6o4pU+YkrmTj7ND9fGObVR/kj
         EyxCauAxgXdmXNp/24JOMoqDzR+NycY5h8p/EAc4VmT7fw3b4L5fmtZwPadGEj+qlKBv
         Xb0Fieh9GkbPEssAKEIwFKSfFfIQf6Fd/g4ypU2qk/PYZeYpRU4eSLqGcs55WBCoY5uE
         20cvGSbZzYEvJ2fjwKIHSkDMEEkf7HVECDyOm0BRCHrzXDAoLKLhaUUN9ClEIIahR8XY
         QAyo0J9/aI41Z7NEis3m6u5w2zHC0M18ZvFRMRTuoV8noykj826MRJ1/ffSHsAjX7P4M
         5KPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=xUAn1SFGSbX/PJThgRvGPBeZbin4ckymuiwWI24odS0=;
        b=UCrExczBJQXjHMXbNp1cqhZuPb9WuHVQzLtZMwC1eAllFkXxNbYbs4odA4L4CfXVQK
         j/fDOPMxHYSVn86oTQdNXiyI63yBMzQsseORwHt/a0syHI82yatG+eoE9uyg4ajhmErT
         uxdchjC7m0UgkV5HqOZYEziWKWiNeYMoqp2hCQ+5FcSxWqWb/+KeM7WGZXzIOnMdG/NJ
         8hT3h8UOsiNyDLZ60w92CrfOZSEZpIl9c7X92vaY4YHhqDRr5OWua5WVgsZOAKxYhfYd
         W+k1FeSVxroyBk73N9JOFcqkL93qOVMePeXirUPsKEuHy2sd3YvNfDY3c8Wdo6Zl5tEL
         UZSg==
X-Gm-Message-State: AOAM531Tlk2VJc9TWkI/WUBr/33+Jhqu3aRE5AAMqk9pz5iVyD8ghRsa
        VingCaz7PGsJnR1lZ+1Pb67ZrYip6hhf
X-Google-Smtp-Source: ABdhPJzLOemLPvttklhl7Nf0PGlbyIbiTejqsfedLe8XBlBvpa565iLT+bJIB/hirHjUug1G/1tTDwzfUUL/
X-Received: from mihenry-linux-desktop.kir.corp.google.com ([2620:15c:29:204:4304:2e3e:d2f5:48c8])
 (user=mizhang job=sendgmr) by 2002:a17:90a:5205:: with SMTP id
 v5mr2457851pjh.206.1627965986347; Mon, 02 Aug 2021 21:46:26 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon,  2 Aug 2021 21:46:04 -0700
Message-Id: <20210803044607.599629-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v4 0/3] Add detailed page size stats in KVM stats
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit basically adds detailed (large and regular) page size info to
KVM stats and deprecate the old one: lpages.

To support legacy MMU and TDP mmu, we use atomic type for all page stats.

v3 -> v4:
 - rebase to origin/queue. [sean]
 - replace the lpages with page stats in place to avoid conflicts. [sean]

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

Mingwei Zhang (2):
  KVM: x86/mmu: Remove redundant spte present check in mmu_set_spte
  KVM: x86/mmu: Add detailed page size stats

Sean Christopherson (1):
  KVM: x86/mmu: Avoid collision with !PRESENT SPTEs in TDP MMU lpage
    stats

 arch/x86/include/asm/kvm_host.h | 10 ++++++-
 arch/x86/kvm/mmu.h              |  4 +++
 arch/x86/kvm/mmu/mmu.c          | 50 +++++++++++++++------------------
 arch/x86/kvm/mmu/tdp_mmu.c      |  9 ++----
 arch/x86/kvm/x86.c              |  5 +++-
 5 files changed, 42 insertions(+), 36 deletions(-)

--
2.32.0.554.ge1b32706d8-goog


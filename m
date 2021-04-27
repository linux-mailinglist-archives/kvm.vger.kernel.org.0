Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA9936CE9A
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 00:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbhD0Wh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 18:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbhD0WhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 18:37:24 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05D8C061574
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:36:39 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id s143-20020a3745950000b029028274263008so24058401qka.9
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=tTxyuPdn4rgY+Ver4IyXpo1lEOrhYEkf7++g5p9MMkg=;
        b=Em3n9hB7Hvpo19frVT+W+lf6YpZN5+Lr/0LqsFFv0gNvnZnCBzxm85s0fMMnF+6ztv
         NKgRvI3OiEknf83jl0j/hk084leCvhzoTUmE9ZrF/gymP1jb4V1UkbftHvSRYXenOpQz
         3Xg3YuF6ncGvV2eV2iUfGUECxCAnkHYkMCrmgkfCT81klWMmMVFOzQ+LSDHr9+9E0D4L
         CYpXFr3jJ9XUcovYwMVuaNobPazmLKJ0LwIbuHRlQ7+LH4yLe5Y8lKXzpd8nbtsTr8hD
         LRqSj7wVd8no/fUL/noDSo5qeP4INm6gbF8Xr4kp0LuBnnSUr09Jbcik3UTksPFUmrB3
         2BLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=tTxyuPdn4rgY+Ver4IyXpo1lEOrhYEkf7++g5p9MMkg=;
        b=BSTueGlKffopAFRmg1VZ7onDPeSYYdX45N0U6mVniXIKO2POw/JdzJ9BJXNXGjQtHN
         tol4JOggq9Q38x4ZIBKYN7E8pUM1M8X9nx3ZyVWCIkgf+9D1DwGoRtZ++AmRhMq9ymhf
         MrdsMcH/M4eGFyb/SHrtuKTQDCQj0VyR0USny9ItjwH45fLYK6yPYasBgBibDUVZqPh1
         Dsn/uwF3YdMXjE2asNrjrjs6RN1tECUC/WCs5CCDGbvplTSV96G4cr6av3S4oIyOFIuL
         aPfos6RH9nUns8ybsPkRkubvPBREtjOLvxG+yAdJvEiEmyproBJ4sgh4yMgHV2+JLnTA
         to/w==
X-Gm-Message-State: AOAM533yCt4rma6l+TB+neMhaVQIO2Y07L+hZ6fCZtqFvukBjzWtNAWS
        ns9S6QRkCc9Dz3FA/APUtxvcCsnds99K
X-Google-Smtp-Source: ABdhPJyBV1BpEZC1fi84zDfcUk6+MVZdQs5cnGvWQPszmzv2+tAOFaBcUjcAEo/m2GY/QPZ2WqzP5avG/frm
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:d0b5:c590:c6b:bd9c])
 (user=bgardon job=sendgmr) by 2002:a05:6214:246a:: with SMTP id
 im10mr25700282qvb.7.1619562998354; Tue, 27 Apr 2021 15:36:38 -0700 (PDT)
Date:   Tue, 27 Apr 2021 15:36:29 -0700
Message-Id: <20210427223635.2711774-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 0/6] Lazily allocate memslot rmaps
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series enables KVM to save memory when using the TDP MMU by waiting
to allocate memslot rmaps until they are needed. To do this, KVM tracks
whether or not a shadow root has been allocated. In order to get away
with not allocating the rmaps, KVM must also be sure to skip operations
which iterate over the rmaps. If the TDP MMU is in use and we have not
allocated a shadow root, these operations would essentially be op-ops
anyway. Skipping the rmap operations has a secondary benefit of avoiding
acquiring the MMU lock in write mode in many cases, substantially
reducing MMU lock contention.

This series was tested on an Intel Skylake machine. With the TDP MMU off
and on, this introduced no new failures on kvm-unit-tests or KVM selftests.

Ben Gardon (6):
  KVM: x86/mmu: Track if shadow MMU active
  KVM: x86/mmu: Skip rmap operations if shadow MMU inactive
  KVM: x86/mmu: Deduplicate rmap freeing in allocate_memslot_rmap
  KVM: x86/mmu: Factor out allocating memslot rmap
  KVM: x86/mmu: Protect kvm->memslots with a mutex
  KVM: x86/mmu: Lazily allocate memslot rmaps

 arch/x86/include/asm/kvm_host.h |  20 +++++
 arch/x86/kvm/mmu/mmu.c          | 153 +++++++++++++++++++++-----------
 arch/x86/kvm/mmu/mmu_internal.h |   2 +
 arch/x86/kvm/mmu/tdp_mmu.c      |   6 +-
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
 arch/x86/kvm/x86.c              | 133 +++++++++++++++++++++++----
 include/linux/kvm_host.h        |   2 +
 virt/kvm/kvm_main.c             |  48 +++++++---
 8 files changed, 283 insertions(+), 85 deletions(-)

-- 
2.31.1.498.g6c1eba8ee3d-goog


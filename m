Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3F33D6610
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 19:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhGZRNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 13:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbhGZRNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 13:13:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9217EC061757
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 10:54:05 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v4-20020a2583c40000b029055bc7fcfebdso14880475ybm.12
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 10:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=iNYVBs0AlyXj+Pf0K8g701Ap0orIY/meGZcAzDBxrDo=;
        b=miNHBH7hW6kovC9YoXVCmEdbzW6eUBOxsUtgNC4b4MUvD8pPcWEruRp8oeVgH1Skv1
         dkWtMY7BRyi+AuFvN58gaTYjrNZ10owOzNdVhhybXi6vd/yQ4bICtHj6X68Brc4DeS65
         zn5VDwtZTvQneWEWiA2q9cax/fV998DIpP4VxrdR14uIVxe25nxAJvDQrX/XAFb4C5/e
         gf9r05QYo3lQ/EOR794XMEBqFLjBWsYcDcETYC05fNoSWbMV7RRH+FMP0EihEoLXvJYm
         J/bV6x/rsFZ7lTZ6k7MMvea8dwxU6KHhDCGX/F4+N6EJjRrBa64R0WHJaDjVo9RMGTg7
         +fIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=iNYVBs0AlyXj+Pf0K8g701Ap0orIY/meGZcAzDBxrDo=;
        b=nt1G45ye0XHLXQGAWF6ktHpyZV18xI7WBUB4mp+M94iqVFRHe4F9YqYXxQAOyUvieA
         5RBu9pHntAGhZJkuDoJIeKS949iw6J3gIhevQcsTEN+5YEil83nbxUAzjGpdVr3XkzF+
         r5+zFn8U+EcCKYeigv2j6hfYUYRXSPKK8Ud9ZnagFlJyY7jc/s8/r9oi++mREnRS2VWv
         fS4dYlXZE8pSmiVDnGv03FUgZWd/1aH7d/z5EVqgwH9p5c5FkDXnBqa2v/EVHAv+q+al
         /3CgHEddG3qhl46ww4jCAkV5XCgv2MOV+1KyNoUP6QWAUJXYepG0cXPMKv+jwHuLJakr
         PRdQ==
X-Gm-Message-State: AOAM5302CnBQQymjsmK4GEHpOAGYmXSl7s5Q43RZI0oPxyPeLqtDMC+9
        Js+ZjsrqxarX8vk2UtrIFV5x42gqVSwN
X-Google-Smtp-Source: ABdhPJzBRwQ5cz8oPwaWPe/0CHP+jy8rc7ewZVqFa91UsySUdk/6f43vkM/EVwWiu8a1sdoYQy9KnvTLMOb0
X-Received: from mihenry-linux-desktop.kir.corp.google.com ([2620:15c:29:204:93c5:105:4dbc:13cf])
 (user=mizhang job=sendgmr) by 2002:a25:7685:: with SMTP id
 r127mr4507241ybc.30.1627322044744; Mon, 26 Jul 2021 10:54:04 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 26 Jul 2021 10:53:54 -0700
Message-Id: <20210726175357.1572951-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 0/3] Add detailed page size stats in KVM stats
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit basically adds detailed (large and regular) page size info to
KVM stats and deprecate the old one: lpages.

To support legacy MMU and TDP mmu, we use atomic type for all page stats.

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


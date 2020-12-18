Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A552DDC64
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 01:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgLRAcd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 19:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgLRAcd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 19:32:33 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B529EC061794
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 16:31:52 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id f33so549040qtb.1
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 16:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=2tzta+SNMsYxKKonR8VaQ9Msx9ezDvobAtQZxP1CmTo=;
        b=amSSz5zGcCHdNrtCi5FrIruhHpn5OoUl6IA1/X5JxM4N7MvhDZqrXJM2eyE1xgR8Rr
         2QaQDE8gdcMULMMy6eI97mlfZY1x2Bspoba0n9tpQJ/S3IHiVUSz51ZWcN/+iUgAFwUI
         1DhsZWhpwetS7/vedXEQ4ILtQYKUVeHMfJNWvXviUwWirkQw6fXeP5iWOcZ6bn5KoQra
         T+d6Q/TwEw+2FMgQ8SJFBZvemoXfGI/t6hZJkw3+NNSrTy5l+KYoKENttqfPB+d2ixgZ
         UV6fdyoL7wn5XxXyBBukMU2qMPBhzHmOn/Wfupuci1GTBphgBB8GXVJxjtVlsXgIUHrj
         ueSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=2tzta+SNMsYxKKonR8VaQ9Msx9ezDvobAtQZxP1CmTo=;
        b=Vspablg+puhN+qikOwspso5K9WOfN3j0gbK7HBEHWPw1s/29x6KPiF/gLQuv9r5Eyy
         07i/DEvL6/JpIPXfm+cA0X3ppEKr2uU3P9rXUw9IGaipX1lN5EogP9j+CFM1xaTla31k
         EXMao31CIlMMiyXcm/bhyAbU5BrvxEB/wH3RwUtKV9DBLT9enHh9MFruyRnpDoPrFsYM
         CXFzI9Fafhd4F7ZxvzUJSUXXPp/nuAZ4OLsxd4wWUOcqEuQO/sjSw6FKolzj5hpZRB5C
         ND4TjcllcFUfDZj1bGmgCOeOomHxjSiCz8a0He7WNtSFyNa2BiExZlOlZH6iQmDABPmF
         SbAg==
X-Gm-Message-State: AOAM5319ASM0GbQ0xqBR8Uz8VOopdDhJ2FBXYnN6tnE74SkfjbcKANFa
        kG6+r/mw4C3BKxuqs1HynznuZ2XAqzc=
X-Google-Smtp-Source: ABdhPJyP8JnZK9FrE2u34potBYnzNLsxVsqEiU4W380aT+tsp9or0rO/5iX8TOjLzl9M1V6ApI50oqRNUWk=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a05:6214:184a:: with SMTP id
 d10mr1855912qvy.41.1608251511737; Thu, 17 Dec 2020 16:31:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 17 Dec 2020 16:31:35 -0800
Message-Id: <20201218003139.2167891-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH 0/4] KVM: x86/mmu: Bug fixes and cleanups in get_mmio_spte()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Richard Herbert <rherbert@sympatico.ca>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two fixes for bugs that were introduced along with the TDP MMU (though I
strongly suspect only the one reported by Richard, fixed in patch 2/4, is
hittable in practice).  Two additional cleanup on top to try and make the
code a bit more readable and shave a few cycles.

Sean Christopherson (4):
  KVM: x86/mmu: Use -1 to flag an undefined spte in get_mmio_spte()
  KVM: x86/mmu: Get root level from walkers when retrieving MMIO SPTE
  KVM: x86/mmu: Use raw level to index into MMIO walks' sptes array
  KVM: x86/mmu: Optimize not-present/MMIO SPTE check in get_mmio_spte()

 arch/x86/kvm/mmu/mmu.c     | 53 +++++++++++++++++++++-----------------
 arch/x86/kvm/mmu/tdp_mmu.c |  9 ++++---
 arch/x86/kvm/mmu/tdp_mmu.h |  4 ++-
 3 files changed, 39 insertions(+), 27 deletions(-)

-- 
2.29.2.684.gfbc64c5ab5-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA56448E0E2
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 00:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiAMXa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 18:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiAMXaZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 18:30:25 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F638C061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 15:30:25 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id y70-20020a626449000000b004bf3f4ba1c2so672509pfb.11
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 15:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fgKi8noT9m71/gy2AHENiHdELX/TtkUqXaIX+FSHkl4=;
        b=H/onoM3HP4UL1nkcx+LIqYUBdaNcTOIjnciDcGsNNBCDC8GEDtCx0pEJ+L5d5auxuz
         1tV32uiWtRhgjDvRYdW9kIuI5/GskD64UywLh7GJH8hNTeWSjjyd0P67r4N9ooMdNmi1
         275leehPGOxk5XswC5vnzzlRh+T4+KI09xHzUIzI57UxmbvELR/jAVZa4JTpKB4/oQIR
         lSA7+rrchgRR2tB41P9YGDL0BFPEJ5dex+NN0+S8BfCG4O+Ozv3d6wJaTEgp7I2Fh3Fw
         t2NKIHMPzLkbagcQwA3CopDf9rwZzavBoiCCWcPwWlj63bLFYCzACe1nHlYexK83gCCM
         l37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fgKi8noT9m71/gy2AHENiHdELX/TtkUqXaIX+FSHkl4=;
        b=cJoQb1pGQvl18SKyyNGEOLqOY5/TVSwphHLqMyl8WNW/mtdlxJHctAB94gttf/X+Hm
         9Jcw4zKh+iFBD2bN2nwCGLLKfeJouuluUg/N/slDbtb/jk2Wp3WzSHisxn6D6odB/f6e
         FHpCHKn3IE2rtHEnB5X9jiMG4WHBWRETYYzn9dq9jmcTp6b8KfgOr9d1xqBJ6f+TWgAQ
         vqpN+433onHjZDeKnn6D6RXFgvEt0DbH0nvU+d7/PC7QtM6kxk+zpvfGjr3nM145p2lN
         1PHIMEMb1pIV1LkALjN9AGx4GLThCTDVvit2OeDyU+wIpf0pYbcdQWJ5qra5lDKfdZ5v
         0Pdw==
X-Gm-Message-State: AOAM531k1A/OAMbhzHt/WYL2xV022Uy8WDmqTqPJab+B/fC8XG6p4eft
        QyUTzMiJ9h7qShWD0ZvSWsF/A3XDLfKbuQ==
X-Google-Smtp-Source: ABdhPJxHJekMj2sUgWGpCkLWHhd1lCvDnspGH/52PixfogUqR1SHPbY3q8cLSwxOP82rrGCSNOhAPt8ugiFpdg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e847:b0:149:1fdc:71de with SMTP
 id t7-20020a170902e84700b001491fdc71demr7036473plg.55.1642116624748; Thu, 13
 Jan 2022 15:30:24 -0800 (PST)
Date:   Thu, 13 Jan 2022 23:30:16 +0000
Message-Id: <20220113233020.3986005-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 0/4] KVM: x86/mmu: Fix write-protection bug in the TDP MMU
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While attempting to understand the big comment in
kvm_mmu_slot_remove_write_access() about TLB flushing, I discovered a
bug in the way the TDP MMU write-protects GFNs. I have not managed to
reproduce the bug as it requires a rather complex set up of live
migrating a VM that is using nested virtualization while the TDP MMU is
enabled.

Patch 1 fixes the bug and is CC'd to stable.
Patch 2-3 fix, document, and enforce invariants around MMU-writable
and Host-writable bits.
Patch 4 fixes up the aformentioned comment to be more readable.

Tested using the kvm-unit-tests and KVM selftests.

v2:
 - Skip setting the SPTE when MMU-writable is already clear [Sean]
 - Add patches for {MMU,Host}-writable invariants [Sean]
 - Fix inaccuracies in kvm_mmu_slot_remove_write_access() comment [Sean]

v1: https://lore.kernel.org/kvm/20220112215801.3502286-1-dmatlack@google.com/

David Matlack (4):
  KVM: x86/mmu: Fix write-protection of PTs mapped by the TDP MMU
  KVM: x86/mmu: Clear MMU-writable during changed_pte notifier
  KVM: x86/mmu: Document and enforce MMU-writable and Host-writable
    invariants
  KVM: x86/mmu: Improve TLB flush comment in
    kvm_mmu_slot_remove_write_access()

 arch/x86/kvm/mmu/mmu.c     | 31 ++++++++++++++++++++--------
 arch/x86/kvm/mmu/spte.c    |  1 +
 arch/x86/kvm/mmu/spte.h    | 42 ++++++++++++++++++++++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.c |  6 +++---
 4 files changed, 62 insertions(+), 18 deletions(-)


base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
-- 
2.34.1.703.g22d0c6ccf7-goog


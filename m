Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A3765387E
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 23:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbiLUWY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 17:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLUWYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 17:24:24 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C22627145
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:22 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id z4-20020a17090ab10400b002195a146546so1946350pjq.9
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rWzzIrNyBxl6K1Wmf8xg2ejoEVKHkFTBcNTwucyj8kQ=;
        b=PSJRwbSnsNcxTt2a7kGfBsa53ywG8CvZCyUeep/UJNa1YKxBVFh2K6jTqJDpjWN1Q3
         9m12S0+6tVDsvpDtVBQ4Z/S+9mwzHFMPaB12kQM6ta4XlqCnwfW0VM+jU79DGBP38Pk9
         Zkfh6hfwcJhHxLJOqq//z95MGveDlVI+T0clIEInlhJ2yNJn58GNd9yBb7H4CPvT8J6Z
         v3Ls9alYEMiM3KroqNS1i71pdZMFrd1QQ90W/DwuDUasqrPmwITVFcSim166jG2z8lH4
         UpHYu9wAT5oziSgP6GGTRGMz7H8Qa+KwQKO4ft71NeEFPO9B1imJC0D9OJ5UeifL2tQ3
         p2RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rWzzIrNyBxl6K1Wmf8xg2ejoEVKHkFTBcNTwucyj8kQ=;
        b=B4u3WxYGj4aDUc6P7lTLitlYnZT2DaLlHhEbbx8Uj55xEj+qtnePty0FW5PhhmQEVL
         BEZ6Q3MDd1kvd2BDjMnjDSwn0bq+SrIG7D1NAXXG2UzGEoXZIVCRzA0FNQNyE7hTTHLY
         iGIdtHu+1Y+9q+Gip/Rq7jGiik98rEbbaRhOMiP9p9QVt8ld/rcZx5u+XnqXfgNeFx74
         QDJSOnNsR/9EyuYNJfYeFh/LzejS6U2uDGd4CnONjaEqFWrhPJdkKCNcnHKVc/azKONx
         Ajt+v53m/1fcfDttwv71DQogzc+1oyT1E3lMwRVuKyY5ucK70fwLduk4E32oDRQO6dNr
         fxgg==
X-Gm-Message-State: AFqh2kqbEEUWK3Z1uvC4QRgy9sYn3zDO0x1mYSeAMjxVk5NHdXKG/XHU
        O5Wq2DrlOqskGQeQ46HYroPGH+eRCSfv
X-Google-Smtp-Source: AMrXdXvnh5ZYZK406EYEWlI9Co6WQF2og6iGH9EsXs6DrN0zdZBsSXIHix/z4+NRxutGNfWmEW8mSniovH/j
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90a:540f:b0:219:c40:e5f with SMTP id
 z15-20020a17090a540f00b002190c400e5fmr352508pjh.49.1671661462067; Wed, 21 Dec
 2022 14:24:22 -0800 (PST)
Date:   Wed, 21 Dec 2022 22:24:04 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221221222418.3307832-1-bgardon@google.com>
Subject: [RFC 00/14] KVM: x86/MMU: Formalize the Shadow MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Nagareddy Reddy <nspreddy@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series makes the Shadow MMU a distinct part of the KVM x86 MMU,
implemented in separate files, with a defined interface to common code.

When the TDP (Two Dimensional Paging) MMU was added to x86 KVM, it came in
a separate file with a (reasonably) clear interface. This lead to many points
in the KVM MMU like this:

if (tdp_mmu_on())
	kvm_tdp_mmu_do_stuff()

if (memslots_have_rmaps())
	/* Do whatever was being done before */

The implementations of various functions which preceded the TDP MMU have
remained scattered around mmu.c with no clear identity or interface. Over the
last couple years, the KVM x86 community has settled on calling the KVM MMU
implementation which preceded the TDP MMU the "Shadow MMU", as it grew
from shadow paging, which supported virtualization on hardware pre-TDP.

Splitting it out into separate files will give a clear interface and make it
easier to distinguish common x86 MMU code from the code specific to the two
implementations.

This series is almost all pure refactors, with just one functional
change to clean up unnecessary work in the page fault handler, revealed
by the refactors.

Patches 1 and 2 prepare for the refactor by adding files and exporting
functions.
(I'm not familiar with the current rules about copyright notices and
authorship credit, so I didn't put anything at the top of shadow_mmu.c,
but since it's going to be filled with code from mmu.c please let me
know if that should change.)

Patch 3 is the big move, transferring 3.5K lines from mmu.c to
shadow_mmu.c
(It may be best if whoever ends up preparing the pull request with
this patch just dumps my version and re-does the move so that no code is
lost.)

Patches 4-6 move the includes for paging_tmpl.h to shadow_mmu.c

Patch 9 is the only functional change, removing an unnecessary operation
from the TDP MMU PF path.

The remaining patches clean up the interface between the Shadow MMU and
common MMU code.

Patch 3 is an enormous change, and doing it all at once in a single
commit all but guarantees merge conflicts and makes it hard to review. I
don't have a good answer to this problem as there's no easy way to move
3.5K lines between files. I tried moving the code bit-by-bit but the
intermediate steps added complexity and ultimately the 50+ patches it
created didn't seem any easier to review.
Doing the big move all at once at least makes it easier to get past when
doing Git archeology, and doing it at the beggining of the series allows the
rest of the commits to still show up in Git blame.

I've tested this series on an Intel Skylake host with kvm-unit-tests and
selftests.

This series builds on 9352e7470a1b4edd2fa9d235420ecc7bc3971bdc. Sean
Christopherson suggested I send out another version right before the
beginning of a merge window so that we can merge this onto the queue early
and have time to pile everything else on top of it. I'll do that once we've
flushed out reviews and feedback.

Please consider this a replacement for the previous series of rmap
refactors I sent out. This replaces all that code movement but does not
preclude any of the great pte_list refactor / rename ideas which were
discussed there.

Thanks everyone for your feedback and happy holidays.

Ben Gardon (14):
  KVM: x86/MMU: Add shadow_mmu.(c|h)
  KVM: x86/MMU: Expose functions for the Shadow MMU
  KVM: x86/MMU: Move the Shadow MMU implementation to shadow_mmu.c
  KVM: x86/MMU: Expose functions for paging_tmpl.h
  KVM: x86/MMU: Move paging_tmpl.h includes to shadow_mmu.c
  KVM: x86/MMU: Clean up Shadow MMU exports
  KVM: x86/MMU: Cleanup shrinker interface with Shadow MMU
  KVM: x86/MMU: Clean up naming of exported Shadow MMU functions
  KVM: x86/MMU: Only make pages available on Shadow MMU fault
  KVM: x86/MMU: Fix naming on prepare / commit zap page functions
  KVM: x86/MMU: Factor Shadow MMU wrprot / clear dirty ops out of mmu.c
  KVM: x86/MMU: Remove unneeded exports from shadow_mmu.c
  KVM: x86/MMU: Wrap uses of kvm_handle_gfn_range in mmu.c
  KVM: x86/MMU: Add kvm_shadow_mmu_ to the last few functions in
    shadow_mmu.h

 arch/x86/kvm/Makefile           |    2 +-
 arch/x86/kvm/debugfs.c          |    1 +
 arch/x86/kvm/mmu/mmu.c          | 4671 ++++---------------------------
 arch/x86/kvm/mmu/mmu_internal.h |   44 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |   13 +-
 arch/x86/kvm/mmu/shadow_mmu.c   | 3538 +++++++++++++++++++++++
 arch/x86/kvm/mmu/shadow_mmu.h   |  114 +
 7 files changed, 4296 insertions(+), 4087 deletions(-)
 create mode 100644 arch/x86/kvm/mmu/shadow_mmu.c
 create mode 100644 arch/x86/kvm/mmu/shadow_mmu.h

-- 
2.39.0.314.g84b9a713c41-goog


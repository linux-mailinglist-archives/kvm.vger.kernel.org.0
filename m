Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0458688654
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbjBBS2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjBBS2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:28:14 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4B715CA0
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:12 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id y5-20020aa78545000000b00593b071cb99so1368183pfn.4
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0+SBcx6MVrgVk2LoIRaHLt69jku4c6rTYPgXbWSbqGk=;
        b=Q5aRqr2sxq2uX4adungANbB3rre1+leu5U94x534oEHG3jQYGfB1uazHzkIWOlqGpy
         /z4TBMvW1Svu0LZamqE7g5s3jlKbKuih5/C6XwBaJgE5AW9xerqakVfbN2FEm9JY1XhN
         I9TTllwSDjMN9g01dh7skwySOK78XhJuXdQKMSt4lj/gaYH8lsKeWYVhZydc70p64JrM
         J8YMri7UEGb4yA+G3KTzc5QYpzSKlsBqTcS/qgCCEb8sipemc3wWQwlLDFBd9upsjfQY
         SPUmZBRLkxrcgFgKGCjTIAtoeJXKWV+eihHSlIHTkLcfyvL/yZfmlKnrr+d/1+B2kgDK
         GeDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0+SBcx6MVrgVk2LoIRaHLt69jku4c6rTYPgXbWSbqGk=;
        b=TQxwbtOkZVxojW1aUzE5r17xy9gLsWuuRg42CYNlYQHZ+3J7A0Z1AxM+9xxWrJ/Zi1
         Nqbw9GgdLziAxYrQma2GC11z+5Su9eet9GnZlg3m6XaXC7wszZFBozMrJtfOUKZDB8nd
         XOkZHetPxdXcKrN8fri5nmAkZbCi/UJBmH4OrqIe9NhvtLoa6/uNhAUEMOyoazqZRN81
         csRH2XPk9qYirQsB9M39j51NJvMYdhMoq9Bz/n7CDf0GRj75VpbCuxP71W1JTaCCCwHd
         B+m5vEb6sjfAwUDkqh7rXXyRzZEV2Y2u4tDkzVILqpgM3yzzXNRo0SbP6BJAyNPFeaQD
         +cCQ==
X-Gm-Message-State: AO0yUKVdmXSgP+S5DoERM00U3SpKO7TUXARVsxMk6ZLXwxjYIRWdbODv
        iL5lz4J31z8/SMqhCt0TSqzCuWAHw1kP
X-Google-Smtp-Source: AK7set91y1jj7PTgsJ5vCMdecR8eG7ZR8ipAA11/zzQ08GevhxMRiFrc6z6IefELTRiYqRf+6XlVagoBGRU4
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90b:ec2:b0:22c:4751:82b2 with SMTP id
 gz2-20020a17090b0ec200b0022c475182b2mr726051pjb.56.1675362491780; Thu, 02 Feb
 2023 10:28:11 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:27:48 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182809.1929122-1-bgardon@google.com>
Subject: [PATCH 00/21] KVM: x86/MMU: Formalize the Shadow MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>,
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
a separate file with a (reasonably) clear interface. This lead to many
points in the KVM MMU like this:

if (tdp_mmu_on())
	kvm_tdp_mmu_do_stuff()

if (memslots_have_rmaps())
	/* Do whatever was being done before */

The implementations of various functions which preceded the TDP MMU have
remained scattered around mmu.c with no clear identity or interface. Over the
last couple years, the KVM x86 community has settled on calling the KVM MMU
implementation which preceded the TDP MMU the "Shadow MMU", as it grew
from shadow paging, which supported virtualization on hardware pre-TDP.
(Note that the Shadow MMU can also build TDP page tables, and doesn't
only do shadow paging, so the meaning is a bit overloaded.)

Splitting it out into separate files will give a clear interface and make it
easier to distinguish common x86 MMU code from the code specific to the two
MMU implementations.

Patches 1-3 are cleanups from Sean

Patches 4-6 prepare for the refactor by adding files and exporting
functions.

Patch 7 the big move, transferring 3.5K lines from mmu.c to
shadow_mmu.c
(It may be best if whoever ends up preparing the pull request with
this patch just dumps my version and re-does the move so that no code is
lost.)

Patches 8 and 9 move the includes for paging_tmpl.h to shadow_mmu.c

Patches 10-17 clean up the interface between the Shadow MMU and
common MMU code.

The last few patches are in response to feedback on the RFC and move
additional code to the Shadow MMU.

Patch 7 is an enormous change, and doing it all at once in a single
commit all but guarantees merge conflicts and makes it hard to review. I
don't have a good answer to this problem as there's no easy way to move
3.5K lines between files. I tried moving the code bit-by-bit but the
intermediate steps added complexity and ultimately the 50+ patches it
created didn't seem any easier to review.
Doing the big move all at once at least makes it easier to get past when
doing Git archeology, and doing it at the beginning of the series allows the
rest of the commits to still show up in Git blame.

I've tested this series on an Intel Skylake host with kvm-unit-tests and
selftests.

RFC -> v1:
 - RFC: https://lore.kernel.org/all/20221221222418.3307832-1-bgardon@google.com/
 - Moved some more Shadow MMU content to shadow_mmu.c. David Matlack
   pointed out some code I'd missed in the first pass. Added commits
   to the end of the series to achieve this.
 - Dropped is_cpuid_PSE36 and moved all the BUILD_MMU_ROLE*() macros
   to mmu_internal, also as suggested by David Matlack.
 - Added copyright comments to the tops of shadow_mmu.c and .h
 - Tacked some cleanups from Sean onto the beginning of the series.

Ben Gardon (18):
  KVM: x86/MMU: Add shadow_mmu.(c|h)
  KVM: x86/MMU: Expose functions for the Shadow MMU
  KVM: x86/mmu: Get rid of is_cpuid_PSE36()
  KVM: x86/MMU: Move the Shadow MMU implementation to shadow_mmu.c
  KVM: x86/MMU: Expose functions for paging_tmpl.h
  KVM: x86/MMU: Move paging_tmpl.h includes to shadow_mmu.c
  KVM: x86/MMU: Clean up Shadow MMU exports
  KVM: x86/MMU: Cleanup shrinker interface with Shadow MMU
  KVM: x86/MMU: Clean up naming of exported Shadow MMU functions
  KVM: x86/MMU: Fix naming on prepare / commit zap page functions
  KVM: x86/MMU: Factor Shadow MMU wrprot / clear dirty ops out of mmu.c
  KVM: x86/MMU: Remove unneeded exports from shadow_mmu.c
  KVM: x86/MMU: Wrap uses of kvm_handle_gfn_range in mmu.c
  KVM: x86/MMU: Add kvm_shadow_mmu_ to the last few functions in
    shadow_mmu.h
  KVM: x86/mmu: Move split cache topup functions to shadow_mmu.c
  KVM: x86/mmu: Move Shadow MMU part of kvm_mmu_zap_all() to
    shadow_mmu.h
  KVM: x86/mmu: Move Shadow MMU init/teardown to shadow_mmu.c
  KVM: x86/mmu: Split out Shadow MMU lockless walk begin/end

Sean Christopherson (3):
  KVM: x86/mmu: Rename slot rmap walkers to add clarity and clean up
    code
  KVM: x86/mmu: Replace comment with an actual lockdep assertion on
    mmu_lock
  KVM: x86/mmu: Clean up mmu.c functions that put return type on
    separate line

 arch/x86/kvm/Makefile           |    2 +-
 arch/x86/kvm/debugfs.c          |    1 +
 arch/x86/kvm/mmu/mmu.c          | 4834 ++++---------------------------
 arch/x86/kvm/mmu/mmu_internal.h |   87 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |   15 +-
 arch/x86/kvm/mmu/shadow_mmu.c   | 3692 +++++++++++++++++++++++
 arch/x86/kvm/mmu/shadow_mmu.h   |  132 +
 7 files changed, 4498 insertions(+), 4265 deletions(-)
 create mode 100644 arch/x86/kvm/mmu/shadow_mmu.c
 create mode 100644 arch/x86/kvm/mmu/shadow_mmu.h


base-commit: 7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f
-- 
2.39.1.519.gcb327c4b5f-goog


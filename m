Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9127264AC0C
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 01:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbiLMARA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 19:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbiLMAQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 19:16:58 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBBB1B1DB
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:16:57 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3bd1ff8fadfso150519617b3.18
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rrmKIRMf4Mq2msGAMjuH9G/DlO6PhwIb4et9Vyytf0s=;
        b=Y/SoLe17F+HoJZwya7YFOMVPVWxIyS8YXDXAdkZKURoZhYboc1qqDhxRYkM8qd/fyn
         zV4AKnvonZDIf4kBxS6BbqKkYvK++Z8SlakM9rrpZf/WnJthiD/WaPvC4mId1Hi85VXx
         HEnTLJKfq/AiMkE+A1lvFD7n5RUyEVn7KE12qMAkazwYdkxp/onbTYKAwGSZxx/+wvCu
         AkCHnFjwsiycANQDr7f8nJl13jr3Aq6KbcvSvBjixq+cK42hwQ3dC8wgvpt4LO7Wo9ul
         DCX6EzwtU8238LHHvhH1M16EyNBESvafX2Bsjx0/y3efzS0Lla4Z0vEPMEkwmHimVswS
         SmYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rrmKIRMf4Mq2msGAMjuH9G/DlO6PhwIb4et9Vyytf0s=;
        b=dpgjzwuUUay5XCF6vmBsr1uhiGNYNhLGD1tRp+ql/S1hSv4honkQ1JFL6Lce251L2Q
         +fYVJvEySPruELQ2TCr8AFoqLthfqnAf42LnCTmfl1RswAjEExf8nC7jsg8Re6BGWcCD
         MIiXoyZSRVb437ZVgL6FcOAb6tAuzuGWLg4+ggxQdrGJ5gzInMBT9qe3c6VBzw0/ANlE
         FFqZdv9EThZonwkDXSaFrbxaSYXQFlPn/xeaL4cyckSysU4Mvglb+qNW92QxWR2lVuNl
         o4l2dMmJtmceLn2MHuyQVUWSlMWaY58NqIzvyrU2yitnAuyfqghrGOeRbb1nNIwKHGQO
         yRUg==
X-Gm-Message-State: ANoB5pn98fZEjPUrUFVvmVfwKQCKF6jsdgEFv1AYi7vy2NJAhug79eFf
        bHzWvZbN/LhoUgpLrTZU93NBM29fKG0=
X-Google-Smtp-Source: AA0mqf6/pKu0pWWW1KBsbsV+bRwkpXaD3AJngXQVdm+DqVUnownROWyJFsvs/+l4EXLP/kxHJtplxf44+Wk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2397:0:b0:724:2a55:aadb with SMTP id
 j145-20020a252397000000b007242a55aadbmr1005565ybj.576.1670890616579; Mon, 12
 Dec 2022 16:16:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 00:16:39 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-1-seanjc@google.com>
Subject: [PATCH 00/14] KVM: selftests: Clang fixes, Makefile cleanup
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

Fix a variety of KVM selftests issues exposed by clang, and rework the
Makefile and .gitignore to reduce the maintenance burden of selftests.

For the Makefile, programmatically generate the list of targets by
looking for .c files, and opt-out via a dummy macro in the source
instead of forcing architectures to opt-in.  The opt-out approach is
less error prone (harder to forget to add an arch), doesn't generate
unnecessary conflicts if multiple tests are added simultanesouly, and
makes it much easier to understand which tests aren't supported, e.g.

  $ git grep TEST_UNSUPPORTED | grep aarch64
  hardware_disable_test.c:TEST_UNSUPPORTED(aarch64);
  max_guest_memory_test.c:TEST_UNSUPPORTED(aarch64);
  system_counter_offset_test.c:TEST_UNSUPPORTED(aarch64);

This all started when trying to reproduce clang build errors reported by
Raghu and Aaron that were introduced by commit 6b6f71484bf4 ("KVM:
selftests: Implement memcmp(), memcpy(), and memset() for guest use").
Just getting selftests to compile with clang was a nightmare, as it took
me several hours to realize that "CC=clang make" and "make CC=clang"
aren't equivalent, and that the "include ../lib.mak" buried halfway through
the Makefile was overriding "CC=clang make".

After too many hours fighting to get clang working, my frustration with
the Makefile boiled over a bit...

Note, I have fixes for the RISC-V RSEQ bugs (outside of selftests/kvm) that
I'll post separately.

Tested on x86 and arm, build tested on s390x and RISC-V, all with both gcc
and clang.

Sean Christopherson (14):
  KVM: selftests: Define literal to asm constraint in aarch64 as
    unsigned long
  KVM: selftests: Delete dead code in x86_64/vmx_tsc_adjust_test.c
  KVM: selftests: Fix divide-by-zero bug in memslot_perf_test
  KVM: selftests: Use pattern matching in .gitignore
  KVM: selftests: Fix a typo in x86-64's kvm_get_cpu_address_width()
  KVM: selftests: Rename UNAME_M to ARCH_DIR, fill explicitly for x86
  KVM: selftests: Use proper function prototypes in probing code
  KVM: selftests: Probe -no-pie with actual CFLAGS used to compile
  KVM: selftests: Explicitly disable builtins for mem*() overrides
  KVM: selftests: Include lib.mk before consuming $(CC)
  KVM: selftests: Disable "gnu-variable-sized-type-not-at-end" warning
  KVM: selftests: Use wildcards to find library source files
  KVM: selftests: Use wildcards to find targets and test source files
  KVM: selftests: Enable RSEQ test for RISC-V

 tools/testing/selftests/kvm/.gitignore        |  91 +------
 tools/testing/selftests/kvm/Makefile          | 229 +++---------------
 .../selftests/kvm/aarch64/page_fault_test.c   |   2 +-
 .../selftests/kvm/access_tracking_perf_test.c |   3 +
 .../selftests/kvm/dirty_log_perf_test.c       |   3 +
 .../selftests/kvm/hardware_disable_test.c     |   4 +
 .../testing/selftests/kvm/include/test_util.h |  11 +
 .../selftests/kvm/lib/x86_64/processor.c      |   2 +-
 .../selftests/kvm/max_guest_memory_test.c     |   4 +
 .../kvm/memslot_modification_stress_test.c    |   3 +
 .../testing/selftests/kvm/memslot_perf_test.c |   6 +
 tools/testing/selftests/kvm/steal_time.c      |   3 +
 .../kvm/system_counter_offset_test.c          |   4 +
 .../kvm/x86_64/vmx_tsc_adjust_test.c          |   5 -
 14 files changed, 80 insertions(+), 290 deletions(-)


base-commit: f1a1d3aff0cc2e68a9ebbd8810d7dcd8cfe2714b
-- 
2.39.0.rc1.256.g54fd8350bd-goog


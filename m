Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562F740EA70
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345629AbhIPS6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245717AbhIPS5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:30 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E48C05BD0E
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:59 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id n17-20020a922611000000b0023db5ee1cafso13956555ile.10
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=bscRkoWhCmUqrdoE9Uy2kjhDd+L+Bo5wsdZYDj09NRA=;
        b=Omp+Kv8GsfsAlwd+15EkIN211lfCDN3xwS6/TjRxp1OFnDfl7A1eIes+NME14D5zkU
         SU1gHUL1v8E0n6cZMsL67wo8sqvGKsD9s7SAvNOZvGDLm6Q71CQQNHuWGokA8r1XgKgi
         AWItSWtYPx3zSkTSuimrx+ZsyhJJ3hwcJ9swS7QpIrDUpLoqkYvpi8/q45gdHgnABxyx
         MaVI1gl2p9k3pMHxCvAHnnwwDnruhyqoLrzOHHz9CXJjJldYYy7dVW9PIPmPfTyYbr1g
         /wa+qgJuAp4V2Z5IFkM7m9vs2beY/BcmGVV8PiWC9wd/8DN0Z7vNI+gLLJXM+LKExJim
         Nktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=bscRkoWhCmUqrdoE9Uy2kjhDd+L+Bo5wsdZYDj09NRA=;
        b=Vo8qsZsw/td/YkEvnR9n+VcqNBA3kknjeilOgd+mTonwyGyou+di4GdToI9HIynSfm
         ap21qtuKRJeUYBEiRtXB3vyJJVgNCzyDBcX4fO7tc5ltuA1vZkFbQzQm1frWokOza728
         ouYugq2zwicfgeWI65DCfG+OyZ/e9+9Fk5nOkmspeWSchcBaXz/2Amzae5Pf1tqA9gtC
         7VtmY2TyKudZ56aTc5iPJjurtdOGPGrJ3H1R9gF+lnROB3/oBFStEIWleRqRY3aoXWKd
         itAuxycIhf4TjUpzOgUZkxdmtkdXg1c9dbLcTKFg5AKl1CxEy006qqxbzyJmDZKv+vvt
         hD5g==
X-Gm-Message-State: AOAM532yx7tOJ6a2suCSK1BV/ncHd0YRpPNwwf1RURP8LeluaUpxurL5
        2082UIXlBcgE9re3Cp1W1s7vjBgq4nZY9ctxl1bC82IZpdOvSXZoR4mb8P3kVk9+hu9WynKE5CY
        jcbMBkAgVeUZqtPvPCoYrVgOl1OPgfmmFXEK1NZJBDCTDkialE4RnEfq/oQ==
X-Google-Smtp-Source: ABdhPJw7P9q6ohfaLCYYiJQsfCZ5CUJm5aQJkALSzTzedA418ocdFUdRDhmRlqyMXq3CYS/vrg37QpBFSCc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:2167:: with SMTP id
 s7mr4906857ilv.314.1631816158433; Thu, 16 Sep 2021 11:15:58 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:46 +0000
Message-Id: <20210916181555.973085-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 0/9] selftests: KVM: Test offset-based counter controls
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series implements new tests for the x86 and arm64 counter migration
changes that I've mailed out. These are sent separately as a dependent
change since there are cross-arch dependencies here.

Patch 1 yanks the pvclock headers into the tools/ directory so we can
make use of them within a KVM selftest guest.

Patch 2 tests the new capabilities of the KVM_*_CLOCK ioctls, ensuring
that the kernel accounts for elapsed time when restoring the KVM clock.

Patches 3-4 add some device attribute helpers and clean up some mistakes
in the assertions thereof.

Patch 5 implements a test for the KVM_VCPU_TSC_OFFSET attribute,
asserting that manipulation of the offset results in correct TSC values
within the guest.

Patch 6 adds basic arm64 support to the counter offset test, checking
that the virtual counter-timer offset works correctly. Patch 7 does the
same for the physical counter-timer offset.

Patch 8 adds a benchmark for physical counter offsetting, since most
implementations available right now will rely on emulation.

Lastly, patch 9 extends the get-reg-list test to check for
KVM_REG_ARM_TIMER_OFFSET if userspace opts-in to the kernel capability.

This series applies cleanly to 5.15-rc1

Tests were ran against the respective architecture changes on the
following systems:

 - Haswell (x86)
 - Ampere Mt. Jade (non-ECV, nVHE and VHE)

v7: https://lore.kernel.org/r/20210816001246.3067312-1-oupton@google.com

v7 -> v8:
 - Rebased to 5.15-rc1
 - Dropped helper for checking if reg exists in reg list (no longer
   necessary)
 - Test and enable KVM_CAP_ARM_VTIMER_OFFSET
 - Add get-reg-list changes

Oliver Upton (9):
  tools: arch: x86: pull in pvclock headers
  selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
  selftests: KVM: Fix kvm device helper ioctl assertions
  selftests: KVM: Add helpers for vCPU device attributes
  selftests: KVM: Introduce system counter offset test
  selftests: KVM: Add support for aarch64 to system_counter_offset_test
  selftests: KVM: Test physical counter offsetting
  selftests: KVM: Add counter emulation benchmark
  selftests: KVM: Test vtimer offset reg in get-reg-list

 tools/arch/x86/include/asm/pvclock-abi.h      |  48 ++++
 tools/arch/x86/include/asm/pvclock.h          | 103 ++++++++
 tools/testing/selftests/kvm/.gitignore        |   3 +
 tools/testing/selftests/kvm/Makefile          |   4 +
 .../kvm/aarch64/counter_emulation_benchmark.c | 207 ++++++++++++++++
 .../selftests/kvm/aarch64/get-reg-list.c      |  42 ++++
 .../selftests/kvm/include/aarch64/processor.h |  24 ++
 .../testing/selftests/kvm/include/kvm_util.h  |  11 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  44 +++-
 .../kvm/system_counter_offset_test.c          | 220 ++++++++++++++++++
 .../selftests/kvm/x86_64/kvm_clock_test.c     | 204 ++++++++++++++++
 11 files changed, 907 insertions(+), 3 deletions(-)
 create mode 100644 tools/arch/x86/include/asm/pvclock-abi.h
 create mode 100644 tools/arch/x86/include/asm/pvclock.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
 create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c

-- 
2.33.0.464.g1972c5931b-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A6D3ECBFE
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhHPANX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbhHPANX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:13:23 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88C6C061764
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:52 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id j14-20020a92c20e000000b00224641b3943so2920420ilo.23
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=F1Y2ySdU0qjQ/StQ1vR0ljtsbrXHDEZds9hmCSWeblg=;
        b=YcIkqrtnhORfqMQT0ShO4+KDFWoE1MjJea43Id/Vgb1S7RsPZL/xQQxfRS0DOXF8aa
         1uPDKwX9ByY5tMfkADf2SLiHa9FBzqehpAN4eW2U/aOwB13l6UGFDvS/c7ErHcpK1WlU
         xE+VeUjHHNw3qXydHD+ImzixbQRKIM5GssHpzrEEbfeYH5uAoxJADmH3VT0eh2pzQHJd
         Oaeu4jDRxoe5StYHRUo2RwbOineqAti8tOQAIGi3RqLDURfN3j6ipgMkXV59i8eM6zlB
         0rUm9v6qZsDAx5K7lvqrLPKuf/uON4DMsB/U0wgoWtLmle/tKkVoFMyutxtZL6JElcGa
         vR4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=F1Y2ySdU0qjQ/StQ1vR0ljtsbrXHDEZds9hmCSWeblg=;
        b=f6SekuDPn4/G1cahy26pYAvBpdoIHZf7wx7WZ30ycj/Huv+FtUYGp5GkYM4H/9ZhyW
         rw42H8U3rDseLghPKYnMjaktH1PoPpdcGF/hs+/fE3KtFsiZPb7tZCtisOmU11SfGMXF
         qVe1zY7Vp5ZoWks6Y7IYeALhKkBLObTePZp2GXnlc4BfP488FRR0ceSrkGZgIynQmjIw
         fVwG1RzD/5nFLk35zQcmiMnDVcp0S14VsMwveyaS66LerhdWmQ6zRT1i7XBc9CyJEbJ/
         rre8BNGRxfbVRRgKemKXjO+KcjTdwhJsuNE1uEix8jTyCoLyr0y0sR1tDBesuH3Tc7XI
         ALHA==
X-Gm-Message-State: AOAM532U4nL3vl2RGruP8dQunNcuKAiAeX1Sv71Zm/NggeHdrjNSIVXC
        JGB6B6k4ZrDhmC3c6Y3gPWRIlfPg3l/erUXTCqz96Kio7NyEPOSAiXZlMnZClCnnV0phc0tvAjD
        L9GuvtcVsdhpNaUqT04ZbkIDXjUzL7Q2+GZcuBaXF00BrQ06TCGmZFUjIJQ==
X-Google-Smtp-Source: ABdhPJzV58r8h0YFfNOivf1Fn8bXACngdOE1Ug6pupFWuSHobJwQrkpGDE51X8HKwmWt2BX0OShiuEIguSk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:296:: with SMTP id 144mr8121137ioc.114.1629072772063;
 Sun, 15 Aug 2021 17:12:52 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:12:37 +0000
Message-Id: <20210816001246.3067312-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 0/9] selftests: KVM: Test offset-based counter controls
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

Patch 6 adds a helper to check if KVM supports a given register in the
KVM_*_REG ioctls.

Patch 7 adds basic arm64 support to the counter offset test, checking
that the virtual counter-timer offset works correctly. Patch 8 does the
same for the physical counter-timer offset.

Patch 9 adds a benchmark for physical counter offsetting, since most
implementations available right now will rely on emulation.

This series applies cleanly to kvm/queue at the following commit:

3e0b8bd99ab ("KVM: MMU: change tracepoints arguments to kvm_page_fault")

Tests were ran against the respective architecture changes on the
following systems:

 - Haswell (x86)
 - Ampere Mt. Jade (non-ECV, nVHE and VHE)
 - ARM Base RevC FVP (ECV, nVHE and VHE)

*NOTE*: Though this tests changes between both x86 and arm64, these
tests check for capabilities and skip if missing, so its OK if they're
merged in trees that lack the patches for both architectures.

v6: https://lore.kernel.org/r/20210804085819.846610-1-oupton@google.com

v6 -> v7:
 - adapted to UAPI renaming for physical counter offsetting on arm64

Oliver Upton (9):
  tools: arch: x86: pull in pvclock headers
  selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
  selftests: KVM: Fix kvm device helper ioctl assertions
  selftests: KVM: Add helpers for vCPU device attributes
  selftests: KVM: Introduce system counter offset test
  selftests: KVM: Add helper to check for register presence
  selftests: KVM: Add support for aarch64 to system_counter_offset_test
  selftests: KVM: Test physical counter offsetting
  selftests: KVM: Add counter emulation benchmark

 tools/arch/x86/include/asm/pvclock-abi.h      |  48 ++++
 tools/arch/x86/include/asm/pvclock.h          | 103 +++++++++
 tools/testing/selftests/kvm/.gitignore        |   3 +
 tools/testing/selftests/kvm/Makefile          |   4 +
 .../kvm/aarch64/counter_emulation_benchmark.c | 207 +++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  24 ++
 .../testing/selftests/kvm/include/kvm_util.h  |  13 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  63 +++++-
 .../kvm/system_counter_offset_test.c          | 211 ++++++++++++++++++
 .../selftests/kvm/x86_64/kvm_clock_test.c     | 204 +++++++++++++++++
 10 files changed, 877 insertions(+), 3 deletions(-)
 create mode 100644 tools/arch/x86/include/asm/pvclock-abi.h
 create mode 100644 tools/arch/x86/include/asm/pvclock.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
 create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c

-- 
2.33.0.rc1.237.g0d66db33f3-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB9638B9F2
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 01:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbhETXFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 19:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbhETXFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 19:05:14 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEB0C061574
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:03:52 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id r16-20020a63a5500000b02902155900cc63so11290779pgu.9
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=wbC2cNuvOY0Fvz7k6wrIFNf1FDqBrInvyLLv8Cl9Ass=;
        b=s5ET1RhD8zSF0k0IGpIp+htQwYfcaI+iVVwWU174XRmw4/pG6hWTMsH23w1I6COS01
         qdNS1wJs8QJmEQk2FIlG3rV1Qj/nLKPTE0+ViEI/VHajaY/qjau2Y1R+wx5t8l7nkWAy
         03VNw1HwZI5USgpvAqxns5Hl/3eRF+VvGWMMX0HLSl+rsAnhAao9QfCHEUUpF1ort5dJ
         9g1Jkel2e45gwZyEveG+KZWOCnEiiKEpfX3NxzZbvHmDTEsKJDT9sB20c7LeMa/OD1za
         DMl1s6qkWNPKd/oR0SXu/FzhBZHc61aap36FaUqgqXcpP8cMR8H9AyXeKwIDVM5sXbtk
         /g0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=wbC2cNuvOY0Fvz7k6wrIFNf1FDqBrInvyLLv8Cl9Ass=;
        b=U6PN5tAEwuVJAm2tcnLdiISRBWKFHrv+TN3QcgTT4zD/wDqHvZf+XWi6M3xYdce5b+
         q3Rx8J23unRuljjgQrPBUgWau0i/6PN8hSsw6s/wxwm2pVoaPJk+HqJRZpfk2KIfzKJB
         Xg//47TqrDAHhf/sDThPxFcVIjOlsOVDm4zenxmuY6KjdXTIdBOhRSIF1Aifmr8qWdZd
         9ecQEX0B6TKeareJL7WZAVEI32y3YVlPfMpdLOgK6Cfh6nlfH/vHd+ayl4Ut4LqAm6s6
         aM/b1KfSeoLckeSIpseV6accOuOiqhxov3Wb+2V/fQEa72CO/ruliH6xZPqAEiIHvQ5A
         sb7g==
X-Gm-Message-State: AOAM533oAugk3qP1bmGDru9iWihZOe3+Bkpp2RsLQAedZYT9aiND+IXf
        GLXfYc/+LdQ29/XkVRYKzvyDQdyzCdZDO3BVkwJiyLvGXqgmbNktkMM9h65B07deDGk4ZHqUEPJ
        5T2RGRxl9kCR/vNdLgCexx6nktm8ZMtVlZ9KnO9Cl9JUmAz/+xtclxoqwceS9RWA=
X-Google-Smtp-Source: ABdhPJzZ+EB9QwHG/LHPlajLrgQZgAZ/gN5+7ULzYr/QPfeVAuIZkWn9AVreTs+PvXxoc53wsjOJTVhH4yGcaA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a62:bd14:0:b029:2de:8bf7:2df8 with SMTP
 id a20-20020a62bd140000b02902de8bf72df8mr7025478pff.60.1621551831872; Thu, 20
 May 2021 16:03:51 -0700 (PDT)
Date:   Thu, 20 May 2021 16:03:27 -0700
Message-Id: <20210520230339.267445-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 00/12] KVM: nVMX: Fix vmcs02 PID use-after-free issue
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the VMCS12 posted interrupt descriptor isn't backed by an L1
memslot, kvm will launch vmcs02 with a stale posted interrupt
descriptor. Before commit 6beb7bd52e48 ("kvm: nVMX: Refactor
nested_get_vmcs12_pages()"), kvm would have silently disabled the
VMCS02 "process posted interrupts" VM-execution control. Both
behaviors are wrong, though the use-after-free is more egregious.

Empirical tests on actual hardware reveal that a posted interrupt
descriptor without any backing memory/device has PCI bus error
semantics (reads return all 1's and writes are discarded). However,
kvm can't tell an unbacked address from an MMIO address. Normally, kvm
would ask userspace for an MMIO completion, but that's complicated for
a posted interrupt descriptor access. There are already a number of
cases where kvm bails out to userspace with KVM_INTERNAL_ERROR via
kvm_handle_memory_failure, so that seems like the best route to take.

It would be relatively easy to invoke kvm_handle_memory_failure at
emulated VM-entry, but that approach would break existing
kvm-unit-tests. Moreover, the issue doesn't really come up until the
vCPU--in virtualized VMX non-root operation--received the posted
interrupt notification vector indicated in its VMCS12.

Sadly, it's really hard to arrange for an exit to userspace from
vmx_complete_nested_posted_interrupt, which is where kvm actually
needs to access the unbacked PID. Initially, I added a new kvm request
for a userspace exit on the next guest entry, but Sean hated that
approach. Based on his suggestion, I added the plumbing to get back
out to userspace in the event of an error in
vmx_complete_nested_posted_interrupt. This works in the case of an
unbacked PID, but it doesn't work quite as well in the case of an
unbacked virtual APIC page (another case where kvm was happy to just
silently ignore the problem and attempt to muddle its way through.) In
that case, this series is an incremental improvement, but it's not a
complete fix.

Jim Mattson (12):
  KVM: x86: Remove guest mode check from kvm_check_nested_events
  KVM: x86: Wake up a vCPU when kvm_check_nested_events fails
  KVM: nVMX: Add a return code to vmx_complete_nested_posted_interrupt
  KVM: x86: Add a return code to inject_pending_event
  KVM: x86: Add a return code to kvm_apic_accept_events
  KVM: nVMX: Fail on MMIO completion for nested posted interrupts
  KVM: nVMX: Disable vmcs02 posted interrupts if vmcs12 PID isn't
    mappable
  KVM: selftests: Move APIC definitions into a separate file
  KVM: selftests: Hoist APIC functions out of individual tests
  KVM: selftests: Introduce x2APIC register manipulation functions
  KVM: selftests: Introduce prepare_tpr_shadow
  KVM: selftests: Add a test of an unbacked nested PI descriptor

 arch/x86/kvm/lapic.c                          |  11 +-
 arch/x86/kvm/lapic.h                          |   2 +-
 arch/x86/kvm/vmx/nested.c                     |  31 ++-
 arch/x86/kvm/x86.c                            |  56 ++--
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/include/x86_64/apic.h       |  91 +++++++
 .../selftests/kvm/include/x86_64/processor.h  |  49 +---
 .../selftests/kvm/include/x86_64/vmx.h        |   6 +
 tools/testing/selftests/kvm/lib/x86_64/apic.c |  45 ++++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   8 +
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  11 +-
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |   6 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c |   4 +-
 .../selftests/kvm/x86_64/vmx_pi_mmio_test.c   | 252 ++++++++++++++++++
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |  59 +---
 16 files changed, 488 insertions(+), 147 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/apic.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/apic.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_pi_mmio_test.c

-- 
2.31.1.818.g46aad6cb9e-goog


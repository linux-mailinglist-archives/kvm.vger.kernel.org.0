Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C60E39BEA3
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhFDR2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhFDR2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:28:17 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8AFC061766
        for <kvm@vger.kernel.org>; Fri,  4 Jun 2021 10:26:30 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id q3-20020aa784230000b02902ea311f25e2so4499040pfn.1
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jBTKgYCJEYQNLnCTehTXH5L9rVbS+fbxuXCQ+6C7ZFA=;
        b=vs8Jz8YB1WLYxFdeEWQirfhstG76tZHjpo46ntgNxYNWuCcdtG9noazDsPiz0lyt+H
         9HryY7BMu6i7eMcMxbLEYjPXPWEsHC4JGEc9Ry/5ORVDI/dAgOZGqeWMlialQUid9kC9
         ofjeHGj91jGpjxrHeTnS57Bl2wrbb0V5leNTMp4A3JuKd8Nky7xQ4AQj9derCVTzhH8u
         dbRcDTGdXgUy+M8AV8Y6gBkTjB6jWJfgI9R5i56TizKjjmT6y309t8OuTu8ghlodHte4
         jHJxxtRdhgodoxXZcQ45TN784561jtYHwsNH6PN7dJe/C15T+LsPdM0/GqJFf5ZL89mc
         btdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jBTKgYCJEYQNLnCTehTXH5L9rVbS+fbxuXCQ+6C7ZFA=;
        b=hBcEO/i8F2qreLjPkqI8zPbglaDzW/12FdwpKNQt/Pkk45t7fFa3uHiFRxVjNmqwYF
         6kKteR/zOfxbG2CwWqbK6gJSG1z4MjW+Rou+YtXWWLD9vXz8d13W80UC5zlpLBMF2xYN
         hYsJob8G/E3gynRAnTzGPNnqTMAOUhAaBzhYRWM/0LPFOc8zRCYLEIpEkxvZpL1TfjhJ
         4N8K18ZzBO9Ehz0LV8mU/HXbv4VffD6sJk/0gp+7un6Xk3++CI46W/BNuGoDqq0tdzGd
         VdaXX2R4g/MLZ1M6ejRRyci2n5JDFusrQ+y0dyU65hSv6owioLE0e4qX7uPMdCTV12NI
         C2Ig==
X-Gm-Message-State: AOAM532Drv6sA+VI9+tSvRgXQhMsuwEZ5TpWfkaiVEnvhliCduyz7Yey
        GSURnadiEWFbSu5dDBsUaup97c/+pMFuOU0qgBkWikvj+oj17t87+hDDsMFIxyKlKCefow3Gf6U
        ZHrRhZphLJXxc4dWh+fukAKR8u9nw6HMcQTfhDY8gRk1RyDM2D8lBEJLasuYsrf8=
X-Google-Smtp-Source: ABdhPJzcX0mPcCmALp2H6Xl3TM5jQNq/mcDsGSFRK9ZzdcCkmDVhrJ1uWBTfVzTTlNXvTMatazq6HfGJ3bMEdQ==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:aa7:9885:0:b029:2ea:25ce:3ad2 with SMTP
 id r5-20020aa798850000b02902ea25ce3ad2mr5378346pfl.76.1622827587001; Fri, 04
 Jun 2021 10:26:27 -0700 (PDT)
Date:   Fri,  4 Jun 2021 10:25:59 -0700
Message-Id: <20210604172611.281819-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v2 00/12] KVM: nVMX: Fix vmcs02 PID use-after-free issue
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

v1 -> v2:
  05/12: Modified kvm_arch_vcpu_ioctl_get_mpstate() so that it
         returns the error code from kvm_apic_accept_events() if
	 said error code is less than 0.
  07/12: Changed a comment based on Sean's feedback.

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
 arch/x86/kvm/x86.c                            |  59 ++--
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
 16 files changed, 490 insertions(+), 148 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/apic.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/apic.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_pi_mmio_test.c

-- 
2.32.0.rc1.229.g3e70b5a671-goog


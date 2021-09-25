Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B12417EB6
	for <lists+kvm@lfdr.de>; Sat, 25 Sep 2021 02:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345113AbhIYA5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 20:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237193AbhIYA5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 20:57:05 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0353C06161E
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 17:55:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m16-20020a25d410000000b005ab243aaaf4so5837440ybf.20
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 17:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=7raooij+tUym7W5s5WPrsLkrWPVticCVkKY3RWsiNDM=;
        b=DXmlShHbjvZa1JvxxvOqKfYKe30mtQRur87j+123oY2dFsBNlIAv8O9qEBNpSOGVM0
         b5Sl+lbCoTOZX+zxJ51FQGhzcy9kOU+kuN3HT7C+f5nB6pN5R9AkQ8rfnjTjbSc6y1L3
         1xXBLePNa9IJaU5EZa6ilhTbqnfNBkXudDaPUTNvEb8RjoCOqehEtkbp9fcq+twCr1dj
         7pQFp14KUjSeBu0Lomx7YgO5vlp+0uTYliIei7NH6p2gACqnEuNLOy869NtJ5XSjME8N
         QoN0wBA2Bv2bcnfhLjSPkQbfYQGKsKIy45up5bnYKrvy1J3XDWY6xOjC4rNSR6s7vMuY
         cddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=7raooij+tUym7W5s5WPrsLkrWPVticCVkKY3RWsiNDM=;
        b=p/qZvHGXoZjGewk79TsozWbrepFXxVLoH7FVnmDjHWCCzpEf/1CVaUPOPJ49CbqGK8
         D2ChpJps5cfWGfneaYpNVJlSXFfr7KihzhmvlCVNG/y11jSFYL/I+DLvkLqJoBCfwAa6
         9DJFrprXSBMG5D+lHllVeO71n7iBYVH79/7kSOA8qPm2TiEmmnqbrmCAinguEkYArsNL
         aGby9A+3XThhcrJkZk/RYdkkWypEfa2TKhLkmOsGPiuygQvUt+i2l2ymjAxgMGBdxEwN
         aUhliPhnRlkb+lE8hR0OcMi8UAAFDq9WbauDLatNgCGtPV9Ik48d+CEqMHWDz6ZE6OZP
         OvlA==
X-Gm-Message-State: AOAM532WHBluMU2rIWrzdpm5iOU7fESpg1HnGIXSO8exJk7XIg0qv1HL
        tC5YtibFX5dXIewlH7KAX3IEN+8NjTs=
X-Google-Smtp-Source: ABdhPJz8Y4bPpJ9bNnOFRpqK33tyNqeaLzwcsIjpAg9bIC4dVS+lANHryvRV962R2bWiwjuBZB41gPX4lxc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a25:d482:: with SMTP id m124mr15615049ybf.73.1632531330879;
 Fri, 24 Sep 2021 17:55:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Sep 2021 17:55:14 -0700
Message-Id: <20210925005528.1145584-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 00/14] KVM: Halt-polling fixes, cleanups and a new stat
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The main purpose of this series is differentiate between "halt" and a more
generic "block", where "halt" aligns with x86's HLT instruction, the
halt-polling mechanisms, and associated stats, and "block" means any guest
action that causes the vCPU to block/wait.

This series arose out of a discussion over adding a stat to track if a
vCPU is blocked/halted[*].  The TL;DR of the discussion is that x86 has
several non-halt "wait" states, and arguably those states should not
participate in halt-polling.  In practice, it really doesn't matter from
a functionality perspective because there are typically so few occurences
of the non-halt waits that they're in the noise compared to the number of
actual HLTs, especially for a long-running VM.  So, my justification for
the rename is that because it doesn't truly affect functionality, KVM
might as well be technically correct and only use halt-polling for HLT.

The other annoyance this series addresses is that KVM mixes "halt" and
"block", e.g. the existing function is kvm_vcpu_block(), but all the stats
and the tracepoint use "halt".  Ideally, KVM would probably avoid "block"
altogether as people often think of "blocked" as meaning the vCPU is
blocked due to _host_ activity.  But I don't have a better alternative,
e.g. "halt" is obviously taken, "wait" is equivalent to "halt" on arm64,
"stop" has specific meaning on s390, etc...  I tried to address the host
vs. guest issue by naming the new stat "blocking" instead of "blocked",
e.g. to convey that the vCPU is "actively blocking" instead of "being
blocked".

Patch 01 fixes a theoretical, benign s390 bug, and sets the stage for
additional cleanups.

Patches 02-04 reconcile discrepancies in when KVM considers halt-polling
to be "successful".  Some stats consider it a success so long as KVM
doesn't schedule() away, others consider it a success if and only if a
wake event is detected in the halt-polling loop.

Patches 05-06 are prep cleanup to split out the core "block" routine.

Patch 07 is more prep, and should also be a small perf optimization for
halt-polling on arm64.

Patch 08 is x86 cleanup to free up the name kvm_vcpu_halt().

Patches 09-10 rename the existing kvm_vcpu_block() to kvm_vcpu_halt(), and
split out the core "block" routine to a new helper.

Patches 11-12 are minor cleanups to avoid unnecessary ktime_get().

Patches 13-14 convert non-HLT x86 flows to use kvm_vcpu_block().

[*] https://lkml.kernel.org/r/20210817230508.142907-1-jingzhangos@google.com

Jing Zhang (1):
  KVM: stats: Add stat to detect if vcpu is currently blocking

Sean Christopherson (13):
  KVM: s390: Ensure kvm_arch_no_poll() is read once when blocking vCPU
  KVM: Update halt-polling stats if and only if halt-polling was
    attempted
  KVM: Refactor and document halt-polling stats update helper
  KVM: Reconcile discrepancies in halt-polling stats
  KVM: s390: Clear valid_wakeup in kvm_s390_handle_wait(), not in arch
    hook
  KVM: Drop obsolete kvm_arch_vcpu_block_finish()
  KVM: Don't block+unblock when halt-polling is successful
  KVM: x86: Tweak halt emulation helper names to free up kvm_vcpu_halt()
  KVM: Rename kvm_vcpu_block() => kvm_vcpu_halt()
  KVM: Split out a kvm_vcpu_block() helper from kvm_vcpu_halt()
  KVM: Don't redo ktime_get() when calculating halt-polling
    stop/deadline
  KVM: x86: Directly block (instead of "halting") UNINITIALIZED vCPUs
  KVM: x86: Invoke kvm_vcpu_block() directly for non-HALTED wait states

 arch/arm64/include/asm/kvm_host.h   |   1 -
 arch/arm64/kvm/arch_timer.c         |   2 +-
 arch/arm64/kvm/handle_exit.c        |   4 +-
 arch/arm64/kvm/psci.c               |   2 +-
 arch/mips/include/asm/kvm_host.h    |   1 -
 arch/mips/kvm/emulate.c             |   2 +-
 arch/powerpc/include/asm/kvm_host.h |   1 -
 arch/powerpc/kvm/book3s_pr.c        |   2 +-
 arch/powerpc/kvm/book3s_pr_papr.c   |   2 +-
 arch/powerpc/kvm/booke.c            |   2 +-
 arch/powerpc/kvm/powerpc.c          |   2 +-
 arch/s390/include/asm/kvm_host.h    |   2 -
 arch/s390/kvm/interrupt.c           |   3 +-
 arch/s390/kvm/kvm-s390.c            |   7 +-
 arch/x86/include/asm/kvm_host.h     |   4 +-
 arch/x86/kvm/vmx/nested.c           |   2 +-
 arch/x86/kvm/vmx/vmx.c              |   4 +-
 arch/x86/kvm/x86.c                  |  25 ++++--
 include/linux/kvm_host.h            |   6 +-
 include/linux/kvm_types.h           |   1 +
 virt/kvm/kvm_main.c                 | 131 +++++++++++++++++-----------
 21 files changed, 118 insertions(+), 88 deletions(-)

-- 
2.33.0.685.g46640cef36-goog


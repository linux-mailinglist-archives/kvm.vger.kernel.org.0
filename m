Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D0D3524BA
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 02:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhDBA5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 20:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbhDBA5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 20:57:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48B1C061788
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 17:57:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o129so7549930ybg.23
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 17:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=FViJNMuAQXVG92IcJ9ASyfw+gqYDqmookinTy4APMz8=;
        b=tM5HW6/xk4O5sMn2fgKiWu76aEhiiETLruJpg/eDqJDR4WtSvS9+XoKICGLJgo/aR9
         PHUygm3nt6Iyd9H+hRkE+aN2uWXSniHsrGAukhueCHEWKNiGLvDdvm/C35c51KL7qq/J
         fgt3utJuyw2N+OiFjKc36bNdeTZMCG2OXJjHEkQxFIqyXipTvjAOsKRQR3H93WpjXiTJ
         zZlKgCHu1/48AstcZ0TNb2v8J6l74NmyyCG68O3osE84/6JpVuFsdO2EgEGawRt1qn/R
         MTRQMS94V9rHBAev+i0CHpGE75U1N9vbPoIhstygJ3ud1d//b6oFND6DleWTsUfEpKQo
         REdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=FViJNMuAQXVG92IcJ9ASyfw+gqYDqmookinTy4APMz8=;
        b=BltyHRAR3NEHbnoM6pKRF++1ivOZryQ40sqHPcKmXbGYjbepPXbfhzbN5QwZ3eGJI/
         RguuBwRjak3nf9jU9P6PNilhqZCQL+F/KFVIt4ugXAuA+7iaIJtB1RKOgfTNi3/46dXh
         J+dhJUT2CMgUwNahL2KVRJ1xT9o+eyQwfKIeYRff4+9O/+MB4pHlgzayFD2PwAbUg6S3
         HF+cS6EDRqMwxf8gDphiaN2aa7NZfxfrfqAsC0Gk0K8z0L5eoP9rnnusAiVDBslEY2XD
         vdCGs4EKWmoJjtTxWo56S6MeLFLHdr+iNGpCQAoGLDHnudADNI6CyyZSopiENFtmG74L
         Z6cQ==
X-Gm-Message-State: AOAM532AvSm4Fde09CBhrvV6TxhAqYj4K3tn2tMa0rRU9zA/nl+01zwp
        RNFxLVZ0c1VxWjPFKHS7cFwMrOFy2fg=
X-Google-Smtp-Source: ABdhPJzX9kzo85wBh2DvMcR2Y9UxX/gVfIA/wY1qXyxNt7lm9J3jjA4HAyWrYbcDrQf6yDOm390BaT3pn8k=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:c0b4:8b8:bb34:6a56])
 (user=seanjc job=sendgmr) by 2002:a25:a187:: with SMTP id a7mr8464267ybi.377.1617325020964;
 Thu, 01 Apr 2021 17:57:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Apr 2021 17:56:48 -0700
Message-Id: <20210402005658.3024832-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 00/10] KVM: Consolidate and optimize MMU notifiers
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The end goal of this series is to optimize the MMU notifiers to take
mmu_lock if and only if the notification is relevant to KVM, i.e. the hva
range overlaps a memslot.   Large VMs (hundreds of vCPUs) are very
sensitive to mmu_lock being taken for write at inopportune times, and
such VMs also tend to be "static", e.g. backed by HugeTLB with minimal
page shenanigans.  The vast majority of notifications for these VMs will
be spurious (for KVM), and eliding mmu_lock for spurious notifications
avoids an otherwise unacceptable disruption to the guest.

To get there without potentially degrading performance, e.g. due to
multiple memslot lookups, especially on non-x86 where the use cases are
largely unknown (from my perspective), first consolidate the MMU notifier
logic by moving the hva->gfn lookups into common KVM.

Based on kvm/queue, commit 5f986f748438 ("KVM: x86: dump_vmcs should
include the autoload/autostore MSR lists").

Well tested on Intel and AMD.  Compile tested for arm64, MIPS, PPC,
PPC e500, and s390.  Absolutely needs to be tested for real on non-x86,
I give it even odds that I introduced an off-by-one bug somewhere.

v2:
 - Drop the patches that have already been pushed to kvm/queue.
 - Drop two selftest changes that had snuck in via "git commit -a".
 - Add a patch to assert that mmu_notifier_count is elevated when
   .change_pte() runs. [Paolo]
 - Split out moving KVM_MMU_(UN)LOCK() to __kvm_handle_hva_range() to a
   separate patch.  Opted not to squash it with the introduction of the
   common hva walkers (patch 02), as that prevented sharing code between
   the old and new APIs. [Paolo]
 - Tweak the comment in kvm_vm_destroy() above the smashing of the new
   slots lock. [Paolo]
 - Make mmu_notifier_slots_lock unconditional to avoid #ifdefs. [Paolo]

v1:
 - https://lkml.kernel.org/r/20210326021957.1424875-1-seanjc@google.com

Sean Christopherson (10):
  KVM: Assert that notifier count is elevated in .change_pte()
  KVM: Move x86's MMU notifier memslot walkers to generic code
  KVM: arm64: Convert to the gfn-based MMU notifier callbacks
  KVM: MIPS/MMU: Convert to the gfn-based MMU notifier callbacks
  KVM: PPC: Convert to the gfn-based MMU notifier callbacks
  KVM: Kill off the old hva-based MMU notifier callbacks
  KVM: Move MMU notifier's mmu_lock acquisition into common helper
  KVM: Take mmu_lock when handling MMU notifier iff the hva hits a
    memslot
  KVM: Don't take mmu_lock for range invalidation unless necessary
  KVM: x86/mmu: Allow yielding during MMU notifier unmap/zap, if
    possible

 arch/arm64/kvm/mmu.c                   | 117 +++------
 arch/mips/kvm/mmu.c                    |  97 ++------
 arch/powerpc/include/asm/kvm_book3s.h  |  12 +-
 arch/powerpc/include/asm/kvm_ppc.h     |   9 +-
 arch/powerpc/kvm/book3s.c              |  18 +-
 arch/powerpc/kvm/book3s.h              |  10 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  98 ++------
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  25 +-
 arch/powerpc/kvm/book3s_hv.c           |  12 +-
 arch/powerpc/kvm/book3s_pr.c           |  56 ++---
 arch/powerpc/kvm/e500_mmu_host.c       |  27 +-
 arch/x86/kvm/mmu/mmu.c                 | 127 ++++------
 arch/x86/kvm/mmu/tdp_mmu.c             | 245 +++++++------------
 arch/x86/kvm/mmu/tdp_mmu.h             |  14 +-
 include/linux/kvm_host.h               |  22 +-
 virt/kvm/kvm_main.c                    | 325 +++++++++++++++++++------
 16 files changed, 552 insertions(+), 662 deletions(-)

-- 
2.31.0.208.g409f899ff0-goog


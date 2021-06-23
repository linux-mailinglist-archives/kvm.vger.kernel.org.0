Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7983B23BD
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 01:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhFWXIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 19:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWXIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 19:08:18 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59256C061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:05:59 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id es19-20020a0562141933b029023930e98a57so4630427qvb.18
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=XfVXHKeEwKS6iZ0DHXHeo0Qo09QuL9XzgavzaDfpho4=;
        b=RQkfnKz5rYet9tNbokVuMowTizNEfSKL++7S3EuKiG4Rino1iF57Fpie3kF3jGZgFD
         dZB2YhdaWBWDAJfiCaeYBAz3XEo5WxEXXFI8qhIII2jaTVd5mcTqU/cyz5V3x0YhmT0f
         LxtEesR6BZ4Dcz4DwV54H7VfhE8C3yWqZt5cvANBWXtGyGdEflRRiHQNQqNyQb1nCjSu
         MQ/wI+LtjljQQ7J/PvR0YmPoZ4Dkssz+y90omcYSip1KC33zjXehSdCkOztzMPHIM0cO
         jc9ckwBiK86k4m4aePC06Cxve7y9KQoKgp+iuSQ1pHkChNYaoveYwHvDgzm5hV1GLA3u
         OiEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=XfVXHKeEwKS6iZ0DHXHeo0Qo09QuL9XzgavzaDfpho4=;
        b=cFBRFn0LMX08uFvi9iH8vQkyX4EWzea5tPtfuflu1KvbQalbUgtub08SPbiAYR54f1
         +v6nIl/vQ5K6q/ule2PJ3oN6zqajMFmuOWBMPBEjPNpoY7BVOTz76mnJRIO/h72tiCcp
         4xd/3O2AR2vwliiwH/kfqvR9D9GXsHxodw7zAD2KTOa/U02gYazDAmieZfW61S/+lyLB
         ElWUHR5nbMBg7olBD7YgMr7CnWWWZ8h4EeCK+ahjWkJObIAadfbEY18gVd2ERwHyZaHo
         kLau33qRV2Avsb4OH5s4iJmIoGSKlh72epYF+gW+uq1NEKkwPJ12We9ZwfvPyKohyluB
         45YQ==
X-Gm-Message-State: AOAM530hRdsSbHGfODq7J9pSRwRc8HAEe1hV50CHkD+hD4EsxUCRorp9
        T403imutNfuJI/rp773W7GrrrqVELL0=
X-Google-Smtp-Source: ABdhPJyEU6qwB4nJApfEcVGmi+jb9w0T4FSK3sG9yEAxPiYVbusZ4/enmtlqA2npkvLigZaOIqONJfT7bNw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e9e:5b86:b4f2:e3c9])
 (user=seanjc job=sendgmr) by 2002:a25:e803:: with SMTP id k3mr668644ybd.268.1624489558343;
 Wed, 23 Jun 2021 16:05:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 23 Jun 2021 16:05:45 -0700
Message-Id: <20210623230552.4027702-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 0/7] KVM: x86: guest MAXPHYADDR and C-bit fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A few fixes centered around enumerating guest MAXPHYADDR and handling the
C-bit in KVM.

DISCLAIMER: I have no idea if patch 04, "Truncate reported guest
MAXPHYADDR to C-bit if SEV is" is architecturally correct.  The APM says
the following about the C-bit in the context of SEV, but I can't for the
life of me find anything in the APM that clarifies whether "effectively
reduced" is supposed to apply to _only_ SEV guests, or any guest on an
SEV enabled platform.

  Note that because guest physical addresses are always translated through
  the nested page tables, the size of the guest physical address space is
  not impacted by any physical address space reduction indicated in
  CPUID 8000_001F[EBX]. If the C-bit is a physical address bit however,
  the guest physical address space is effectively reduced by 1 bit.

In practice, I have observed that Rome CPUs treat the C-bit as reserved for
non-SEV guests (another disclaimer on this below).  Long story short, commit
ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
exposed the issue by inadvertantly causing selftests to start using GPAs
with bit 47 set.

That said, regardless of whether or not the behavior is intended, it needs
to be addressed by KVM.  I think the only difference is whether this is
KVM's _only_ behavior, or whether it's gated by an erratum flag.

The second disclaimer is that I haven't tested with memory encryption
disabled in hardware.  I wrote the patch assuming/hoping that only CPUs
that report SEV=1 treat the C-bit as reserved, but I haven't actually
tested the SEV=0 case on e.g. CPUs with only SME (we might have these
platforms, but I've no idea how to access/find them), or CPUs with SME/SEV
disabled in BIOS (again, I've no idea how to do this with our BIOS).

Sean Christopherson (7):
  KVM: x86: Use guest MAXPHYADDR from CPUID.0x8000_0008 iff TDP is
    enabled
  KVM: x86: Use kernel's x86_phys_bits to handle reduced MAXPHYADDR
  KVM: x86: Truncate reported guest MAXPHYADDR to C-bit if SEV is
    supported
  KVM: x86/mmu: Do not apply HPA (memory encryption) mask to GPAs
  KVM: VMX: Refactor 32-bit PSE PT creation to avoid using MMU macro
  KVM: x86/mmu: Bury 32-bit PSE paging helpers in paging_tmpl.h
  KVM: x86/mmu: Use separate namespaces for guest PTEs and shadow PTEs

 arch/x86/kvm/cpuid.c            | 38 +++++++++++++++++---
 arch/x86/kvm/mmu.h              | 11 ++----
 arch/x86/kvm/mmu/mmu.c          | 63 ++++++++-------------------------
 arch/x86/kvm/mmu/mmu_audit.c    |  6 ++--
 arch/x86/kvm/mmu/mmu_internal.h | 14 ++++++++
 arch/x86/kvm/mmu/paging_tmpl.h  | 52 ++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/spte.c         |  2 +-
 arch/x86/kvm/mmu/spte.h         | 34 +++++++-----------
 arch/x86/kvm/mmu/tdp_iter.c     |  6 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 arch/x86/kvm/svm/svm.c          | 37 ++++++++++++++-----
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/x86.c              |  3 ++
 arch/x86/kvm/x86.h              |  1 +
 14 files changed, 170 insertions(+), 101 deletions(-)

-- 
2.32.0.288.g62a8d224e6-goog


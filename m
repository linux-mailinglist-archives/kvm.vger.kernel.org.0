Return-Path: <kvm+bounces-58923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2566BA59C0
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 08:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B529160944
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 06:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 241A8284663;
	Sat, 27 Sep 2025 06:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3wkoNR9i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2267280330
	for <kvm@vger.kernel.org>; Sat, 27 Sep 2025 06:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758953373; cv=none; b=l5TyE42n2pVrHl1CCfwsBqmzlhhdGTex17aix/cN4z7qGwffkJZtclENsIp0xZACouZLK36d9myer7nuGElD5+/DhRQDAjDiCdvM6rnl6PJUctp8mR7JtO70F7Ye3HcyURBLvaNlN3/waW7S9gYd0U8/Oyul4mGCiRQrGFvjmDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758953373; c=relaxed/simple;
	bh=0Vb/mK7tmCJhFTWefrGXGNYHFyjEGtXS8pNsHcfbRVg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nd4Bf3ijSsRnxOOV6Y+q/6WFnjDvQotX7sJCupeuB6TADrK54dveAcW9P0QfQV+v21pi/NearWgDhGZrjGXPe4DBsU1vizj2Hh6j7Xe3ZSQIjStsfQb4Hb9zj/6nu/tZhcOu0j77MwfeHESvgFWTa9YSHruXb/doLi0xE4YgXFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3wkoNR9i; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befd39so5182297a91.0
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 23:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758953371; x=1759558171; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4nfCukCOjTKBbX17kjTUtgyEmCtT5j5WUGq581i06Rk=;
        b=3wkoNR9iT6c7XIbGPIKlCjxp0oilt14IduEohWLT7Hcs5tkSJCPGNUVtDs82jJVMLm
         bV8HIJluk7n1sVNwsc7wtScBQqq5oGNdR+SFYWdYkEKv3nU41ElBB/CkAnd6ehHyx7bq
         vOw4l/EUtMSZFj374hO7aeNWWzws+wPZRBkTp3dS+beE+wW5F5WAjWOPtc2WBh7T1ZTo
         yfDXJoR1j8H8m+oMAbsVAyEoGrqJOs+QbuVxP7msh5lF3eS8nmKm3VdSlBZRJtL570TN
         zQdZZtzV100B3UzYrmKshxw3HZqN9SC28waauAITeWveMbxI9/gO6rA5mo/Rz6sYHMBk
         xKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758953371; x=1759558171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4nfCukCOjTKBbX17kjTUtgyEmCtT5j5WUGq581i06Rk=;
        b=QcK5xCXbk52tDeoI3gjvxWqFZIYNxMFCVqPnnZjGMPOw+KIw3bRSAuKdivLjzImoua
         CThvyUd9LIa9QFZWPXRAtgNjC+E5eysbXQZbbYP+gI2UfSHD3kU+7X4Ogydv2zTIkNvq
         KpF69n1+lyxzPu/trucoY/Pl+36aOajf/MuJSpRPg9W4LiSVNyTPwdC4ZA/dtKIZktp/
         WkNBpVs6jvFxWzQ2NKi6FT/1C39B6HPMMa6KJg3jpDQIgmW2fnJYcF7CRXVxFNTIDkY0
         yPMG03lP7zpA6eUY/Z+c7qi3VdKFe/5MZzX5ZGsT7W0ZPBg3XU7AwgoBAcfrCQ2dCwio
         NudQ==
X-Gm-Message-State: AOJu0Yykuken6ZHllNcFimJ2bnsmGvN+/BnrbTbSLQXwvBn68rA21Xfz
	oU94L0uh0AvTAE3s8YCpxg5XPuTBWRT/RgTND6+SRNvpgRERbpmA0jjv2eh/k34CqHEzlll6Bw5
	80dKNtA==
X-Google-Smtp-Source: AGHT+IHInN0XXrsVYcs2pmvpa43+3t7ExR39ZdBaGHVwMt0+ljeiTqzCG967MCRxjJMzZNeqZRdOZKQW9yc=
X-Received: from pjnu2.prod.google.com ([2002:a17:90a:8902:b0:327:e172:e96])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3885:b0:32e:3e2c:8ad8
 with SMTP id 98e67ed59e1d1-3342a2d9bdemr11248258a91.20.1758953370964; Fri, 26
 Sep 2025 23:09:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Sep 2025 23:09:10 -0700
In-Reply-To: <20250927060910.2933942-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250927060910.2933942-11-seanjc@google.com>
Subject: [GIT PULL] KVM: Symbol export restrictions for 6.18
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Note!  If possible, and you're feeling generous, please merge this dead last
and manually convert any new KVM exports to EXPORT_SYMBOL_FOR_KVM_INTERNAL so
that there are no unwanted exports.

Three new exports are coming in via other kvm-x86 pull requests; I've been
"fixing" them as part of the merge into kvm-x86/next (see diff below), so those
at least have gotten coverage in -next.

Note #2, this is based on the "misc" branch/pull, but includes a backmerge of
v6.17-rc3.  I posted the patches against kvm-x86/next to avoid an annoying
conflict (which I can't even remember at this point), and then didn't realize
I needed v6.17-rc3 to pick up the EXPORT_SYMBOL_GPL_FOR_MODULES =>
EXPORT_SYMBOL_FOR_MODULES rename that snuck in until the 0-day bot yelled
because the branch didn't compile (I only tested when merged on top of
kvm/next, doh).

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e96080cba540..3d4ec1806d3e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -695,7 +695,7 @@ u64 kvm_get_user_return_msr(unsigned int slot)
 {
        return this_cpu_ptr(user_return_msrs)->values[slot].curr;
 }
-EXPORT_SYMBOL_GPL(kvm_get_user_return_msr);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_get_user_return_msr);
 
 static void drop_user_return_notifiers(void)
 {
@@ -1304,7 +1304,7 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
                vcpu->arch.cpuid_dynamic_bits_dirty = true;
        return 0;
 }
-EXPORT_SYMBOL_GPL(__kvm_set_xcr);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(__kvm_set_xcr);
 
 int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b99eb34174af..83a1b4dbbbd8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2661,7 +2661,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 
        return NULL;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {

The following changes since commit 1b237f190eb3d36f52dffe07a40b5eb210280e00:

  Linux 6.17-rc3 (2025-08-24 12:04:12 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-exports-6.18

for you to fetch changes up to aca2a0fa7796cf026a39a49ef9325755a9ead932:

  KVM: x86: Export KVM-internal symbols for sub-modules only (2025-09-24 07:01:30 -0700)

----------------------------------------------------------------
KVM symbol export restrictions for 6.18

Use the newfangled EXPORT_SYMBOL_FOR_MODULES() along with some macro
shenanigans to export KVM-internal symbols if and only if KVM has one or
more sub-modules, and only for those sub-modules, e.g. x86's kvm-amd.ko
and/or kvm-intel.ko, and PPC's many varieties of sub-modules.

Define the macros in the kvm_types.h so that the core logic is visible outside
of KVM, so that the logic can be reused in the future to further restrict
kernel exports that exist purely for KVM (x86 in particular has a _lot_ of
exports that are used only by KVM).

----------------------------------------------------------------
Sean Christopherson (6):
      Merge 'v6.17-rc3' into 'exports' to EXPORT_SYMBOL_FOR_MODULES rename
      KVM: s390/vfio-ap: Use kvm_is_gpa_in_memslot() instead of open coded equivalent
      KVM: Export KVM-internal symbols for sub-modules only
      KVM: x86: Move kvm_intr_is_single_vcpu() to lapic.c
      KVM: x86: Drop pointless exports of kvm_arch_xxx() hooks
      KVM: x86: Export KVM-internal symbols for sub-modules only

 arch/powerpc/include/asm/Kbuild      |   1 -
 arch/powerpc/include/asm/kvm_types.h |  15 +++++++++
 arch/s390/include/asm/kvm_host.h     |   2 ++
 arch/s390/kvm/priv.c                 |   8 +++++
 arch/x86/include/asm/kvm_host.h      |   3 --
 arch/x86/include/asm/kvm_types.h     |  10 ++++++
 arch/x86/kvm/cpuid.c                 |  10 +++---
 arch/x86/kvm/hyperv.c                |   4 +--
 arch/x86/kvm/irq.c                   |  34 ++------------------
 arch/x86/kvm/kvm_onhyperv.c          |   6 ++--
 arch/x86/kvm/lapic.c                 |  71 +++++++++++++++++++++++++++++-------------
 arch/x86/kvm/lapic.h                 |   4 +--
 arch/x86/kvm/mmu/mmu.c               |  36 ++++++++++-----------
 arch/x86/kvm/mmu/spte.c              |  10 +++---
 arch/x86/kvm/mmu/tdp_mmu.c           |   2 +-
 arch/x86/kvm/pmu.c                   |  10 +++---
 arch/x86/kvm/smm.c                   |   2 +-
 arch/x86/kvm/x86.c                   | 219 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------
 drivers/s390/crypto/vfio_ap_ops.c    |   2 +-
 include/linux/kvm_types.h            |  25 ++++++++++-----
 virt/kvm/eventfd.c                   |   2 +-
 virt/kvm/guest_memfd.c               |   4 +--
 virt/kvm/kvm_main.c                  | 126 +++++++++++++++++++++++++++++++++++++-------------------------------------
 23 files changed, 323 insertions(+), 283 deletions(-)
 create mode 100644 arch/powerpc/include/asm/kvm_types.h


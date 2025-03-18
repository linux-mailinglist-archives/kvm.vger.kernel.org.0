Return-Path: <kvm+bounces-41424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E100A67B8F
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:06:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FCCC88340B
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1DBD2135B1;
	Tue, 18 Mar 2025 18:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jFWwKe1d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB17A212B05
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742320994; cv=none; b=Z+86obzbpPyYQwqEEleV7IVyB254e/gkwwQeJee834BUkBlbn/g+Ru3dE1NExo1j14fOYealf3Yw3Qy2Jz8dSc2bzGxDxkscSC4Ic4Rs9nMfWV2lKa3FHEpEhtol/hKVyO4RjDdYVBj8gb4Ys/qN1Zqe3JoC3f8kZaKbwrF/dOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742320994; c=relaxed/simple;
	bh=GK/Jq82TjnTyp0ZDk6HXhisugMDOk6munK5wzO9dtw0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XViPctzqpJQEda+ckGLWE8VU8q9/i3HzwLHj7eRcmcHIpAb6w6cRm8Aqv8e2ADqT6C0zjnC46tiL/CoYq3ZLrQqUhjO5pqs/x0rnVMECX6kMmAwUzpb9Z4kQZpTlfStHH1zDITlXsXzPG0oh/tprafZnh3j/O+J7AZ9F5+wtLmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jFWwKe1d; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22403329f9eso91916825ad.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 11:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742320991; x=1742925791; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hfhGZI1wf8iWTOyCG90KTDrGIGyW4OXH3t2Rrrzll5M=;
        b=jFWwKe1dpVcKYWoU47VE6U6OUBHV1lISjuVw0bvBc5VEZ0aE4KruXhzS3ktjeyxb4q
         jakVj6yXiAwp6yIkmrg390dj6LH73011eFT8vQgIxr50QQj3Z5dEJ45KTFXZWSEN8i8x
         eNrffB2ksQzIc6Uc9qCzrlItOvVKQCPJazAL37AoAPDp+Ec6gPCgSbamzpJoo7G8Yfh+
         +1mkznkTk7HLwCm0jnYRga3kaww5ce75b9t7Dh5r6zeKe+wPCwuBDwbuOo9L6X4gbQxx
         Rf6dNt1F/zHU20L93hyKajB0xbwXNtw3CjWixV8Kq15+xr6PKPYjKXPAiTz8pSZzZXn7
         dwZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742320991; x=1742925791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hfhGZI1wf8iWTOyCG90KTDrGIGyW4OXH3t2Rrrzll5M=;
        b=eRw9S5nUOAVi+Z3pPTx8nwk1lZeVMjtGl5Dg6FjfsA3FkzfrdG8ho8EH1MuNAcs8kQ
         1MtIK/NGOqx/TZodebfVxeyD+sZG0XbYMjUMA9ZmHa171I254KvufcrP65y45uvPv9Zf
         MtyJ8ndWEVBCwzh8u0Vxhmul+3FNgQQx6aUbu3PveBa/jrCB5q+YhzMId+0jQOCbmRiJ
         dvedblV1O39ep59w57hHgo06zorYvhaES6QZBcIVm0lvqReMJ4TaY+7XFpmh8YQVq9pY
         INQTSmuTY5+LEYPYDOKHAAorRjbXn2/1KkoVCReFPol0XecFHIdQDbQ8uy4M4T2y5jOW
         7xbw==
X-Gm-Message-State: AOJu0Yx+DoW8won1uQn/xbPO7g+xHsBv3NUbKR4ZNg0HxedTlQqT6goN
	6gotoa24RjTBh1mrJV+K7mNrToZUr2P155dQ8gcpovou0J2i1d5GqZcQmGrs6VCOOJ7cQt4G17C
	X0Q==
X-Google-Smtp-Source: AGHT+IHZyJniuUGJb80kY6TBDAKitKRZc4VUdJYUBBNt6eCyhq66AFnESWyFZkAGJ3I6GiaAO5I1FnvE9Zs=
X-Received: from pfpk14.prod.google.com ([2002:aa7:9d0e:0:b0:734:f775:648f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:431e:b0:1f5:6f61:a0c2
 with SMTP id adf61e73a8af0-1f5c12ec629mr28938766637.34.1742320991112; Tue, 18
 Mar 2025 11:03:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Mar 2025 11:02:57 -0700
In-Reply-To: <20250318180303.283401-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318180303.283401-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318180303.283401-3-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.15
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Except for a minor cleanup, the MMU changes for 6.15 are all about adding
support for aging SPTEs without holding mmu_lock.  Details in the tag.

The following changes since commit a64dcfb451e254085a7daee5fe51bf22959d52d3:

  Linux 6.14-rc2 (2025-02-09 12:45:03 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.15

for you to fetch changes up to 0dab791f05ce2c9f0215f50cb46ed0c3126fe211:

  KVM: x86/tdp_mmu: Remove tdp_mmu_for_each_pte() (2025-02-28 09:14:20 -0800)

----------------------------------------------------------------
KVM x86/mmu changes for 6.15

Add support for "fast" aging of SPTEs in both the TDP MMU and Shadow MMU, where
"fast" means "without holding mmu_lock".  Not taking mmu_lock allows multiple
aging actions to run in parallel, and more importantly avoids stalling vCPUs,
e.g. due to holding mmu_lock for an extended duration while a vCPU is faulting
in memory.

For the TDP MMU, protect aging via RCU; the page tables are RCU-protected and
KVM doesn't need to access any metadata to age SPTEs.

For the Shadow MMU, use bit 1 of rmap pointers (bit 0 is used to terminate a
list of rmaps) to implement a per-rmap single-bit spinlock.  When aging a gfn,
acquire the rmap's spinlock with read-only permissions, which allows hardening
and optimizing the locking and aging, e.g. locking an rmap for write requires
mmu_lock to also be held.  The lock is NOT a true R/W spinlock, i.e. multiple
concurrent readers aren't supported.

To avoid forcing all SPTE updates to use atomic operations (clearing the
Accessed bit out of mmu_lock makes it inherently volatile), rework and rename
spte_has_volatile_bits() to spte_needs_atomic_update() and deliberately exclude
the Accessed bit.  KVM (and mm/) already tolerates false positives/negatives
for Accessed information, and all testing has shown that reducing the latency
of aging is far more beneficial to overall system performance than providing
"perfect" young/old information.

----------------------------------------------------------------
James Houghton (6):
      KVM: Rename kvm_handle_hva_range()
      KVM: Allow lockless walk of SPTEs when handing aging mmu_notifier event
      KVM: x86/mmu: Factor out spte atomic bit clearing routine
      KVM: x86/mmu: Don't force atomic update if only the Accessed bit is volatile
      KVM: x86/mmu: Skip shadow MMU test_young if TDP MMU reports page as young
      KVM: x86/mmu: Only check gfn age in shadow MMU if indirect_shadow_pages > 0

Nikolay Borisov (1):
      KVM: x86/tdp_mmu: Remove tdp_mmu_for_each_pte()

Sean Christopherson (6):
      KVM: x86/mmu: Always update A/D-disabled SPTEs atomically
      KVM: x86/mmu: Age TDP MMU SPTEs without holding mmu_lock
      KVM: x86/mmu: Refactor low level rmap helpers to prep for walking w/o mmu_lock
      KVM: x86/mmu: Add infrastructure to allow walking rmaps outside of mmu_lock
      KVM: x86/mmu: Add support for lockless walks of rmap SPTEs
      KVM: x86/mmu: Walk rmaps (shadow MMU) without holding mmu_lock when aging gfns

 Documentation/virt/kvm/locking.rst |   4 +-
 arch/x86/include/asm/kvm_host.h    |   4 +-
 arch/x86/kvm/Kconfig               |   1 +
 arch/x86/kvm/mmu/mmu.c             | 363 +++++++++++++++++++++++++++----------
 arch/x86/kvm/mmu/spte.c            |  31 ++--
 arch/x86/kvm/mmu/spte.h            |   2 +-
 arch/x86/kvm/mmu/tdp_iter.h        |  34 ++--
 arch/x86/kvm/mmu/tdp_mmu.c         |  45 +++--
 include/linux/kvm_host.h           |   1 +
 virt/kvm/Kconfig                   |   4 +
 virt/kvm/kvm_main.c                |  53 +++---
 11 files changed, 373 insertions(+), 169 deletions(-)


Return-Path: <kvm+bounces-23776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C74D894D782
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4905C1F22D1C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16B4F1607B7;
	Fri,  9 Aug 2024 19:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pmwlJHrB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B3E101E6
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232622; cv=none; b=ZO0bdocDHThZg6USPjebEknFzN9vjUdc3vAxt0E4nF9ZZ54QNeF1AvZMiQnq37iiB9e5rzP9cfOyDnk96TZi3VehFs1sLcBGxlCrRKB+b8Ne1UQVXtYdm5s40HPiG3WBFbB63aCbBjsbmQMUgoBydmXb0sJjlMesgSBshtFnAYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232622; c=relaxed/simple;
	bh=1XlkVjHo+suzkHDpODakK3YnPz0xLR07kWNXlLZwdNY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DPHaaPEtGubbqS5M0fcY/ZRG+MW2lA0lxWg9wuIQE2VdehnfVJBk/OJZ3h/uK3Y/bkT/mnPeV3fOCetPJ9fJziIlUMdBgGe1RITkPbxR7tlccWXR2i/YSdS9XFKZtgBh5ilVcj0i7b8CIQpmRh9Q4iw3olJJ0KEDYljdjmGIlLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pmwlJHrB; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-66890dbb7b8so55870647b3.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723232619; x=1723837419; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EgnPdPJ37XkRkd0MNy853KicoIlpIy484NkRqLT7dIc=;
        b=pmwlJHrBVaVp24Bda74go0FLWflaT/2/GqFiWP7+PbPum0y20CoeyhmDhTKjqTmvuH
         aW9H+5wGQ6+l07UCgLx9mH07f0RV4Hl9tfxK/uvbQHTBYDpvfz1imsBkellhb0I73RYN
         Rf/44kj5RJTu9v7A9GYvhdwGh1XyFKI/ItCnYzSsGDLnv4hINTsLDIqJF8N34TYuJicQ
         hIQwjbcJewlX6lPD7QsNDIAMOH7gS6hayxwp5pvFYZE6LCjWHNFwUM1Ruwzv0ClfYweY
         iN5xB70PjpgysZmHRuMhU9NxX59Hlon6mVeDgTvvxDjJ3/ocGYMuoYt7sGhABAchNG4N
         IgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723232619; x=1723837419;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EgnPdPJ37XkRkd0MNy853KicoIlpIy484NkRqLT7dIc=;
        b=RHNUaoUBV7vO8GMyxOCGFzH+czvKvFL0sWg6GC9EDcj/ShDKBsFITkd9hr/Q1iAkU4
         1ILY3X7LFH2rraEfsgn0UI6meJcY6QfzYCMMM1dFVBfBBXaeTZ42eNt9XAe8bajq2I7h
         jFxMbPPidtS3NnxDgocmoSJJ979IlvfBo0RfCni/E4oWoVghCS6ykvGZqlqUKT5b3FjR
         LoQtqoEIbmuR2u1sjDJuCdCqvEJqaDz26/Oet3BUg2+KmmLnugtbZzegWYXklwY4R1/E
         h+tc1RmqgtNYVMs69HlZ+QdwPLs6MTYyS/h4wM1IwEdzOrrfHtNWWdHeu1wM84Nj2hIM
         q8Sg==
X-Gm-Message-State: AOJu0YzYq2vUD6UBMe934suEqpdXdNYAd6PiMgRe70eoIzPSyvLg1zk9
	OcV0Z4dMFRjqhFOpu3meJQ1NIZhP/vi7HwQ9eoBxRPKhQpM3bv7lAhSw00dvAE+IUh1/3mkXQHs
	0cA==
X-Google-Smtp-Source: AGHT+IHSbQtzYx2tkfW7590mmdt6dl9zn2glE7iKVYY/9v60Qq7jrhPhZwoWuWBhDE6LSdVzbuCPHHbm6x0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:f4c3:0:b0:62c:ff73:83f with SMTP id
 00721157ae682-69ec9637eefmr863697b3.8.1723232619634; Fri, 09 Aug 2024
 12:43:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-1-seanjc@google.com>
Subject: [PATCH 00/22] KVM: x86/mmu: Allow yielding on mmu_notifier zap
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

The main intent of this series is to allow yielding, i.e. cond_resched(),
when unmapping memory in shadow MMUs in response to an mmu_notifier
invalidation.  There is zero reason not to yield, and in fact I _thought_
KVM did yield, but because of how KVM grew over the years, the unmap path
got left behind.

The first half of the series is reworks max_guest_memory_test into
mmu_stress_test, to give some confidence in the mmu_notifier-related
changes.

Oliver and Marc, there's on patch lurking in here to enable said test on
arm64.  It's as well tested as I can make it (and that took much longer
than anticipated because arm64 hit races in the test that x86 doesn't
for whatever reason).

The middle of the series reworks x86's shadow MMU logic to use the
zap flow that can yield.

The last third or so is a wee bit adventurous, and is kinda of an RFC, but
well tested.  It's essentially prep/post work for James' MGLRU, and allows
aging SPTEs in x86's shadow MMU to run outside of mmu_lock, e.g. so that
nested TDP (stage-2) MMUs can participate in MGLRU.

If everything checks out, my goal is to land the selftests and yielding
changes in 6.12.  The aging stuff is incomplete and meaningless without
James' MGLRU, I'm posting it here purely so that folks can see the end
state when the mmu_notifier invalidation paths also moves to a different
API.

James, the aging stuff is quite well tested (see below).  Can you try
working into/on-top of your MGLRU series?  And if you're feeling very
kind, hammer it a bit more? :-)  I haven't looked at the latest ideas
and/or discussion on the MGLRU series, but I'm hoping that being able to
support the shadow MMU (absent the stupid eptad=0 case) in MGLRU will
allow for few shenanigans, e.g. no need to toggle flags during runtime.

As for testing, I spun up a VM and ran a compilation loop and `stress` in
the VM, while simultaneously running a small userspace program to age the
VM's memory (also in an infinite loop), using the same basic methodology as
access_tracking_perf_test.c (I put almost all of guest memory into a
memfd and then aged only that range of memory).

I confirmed that the locking does work, e.g. that there was (infrequent)
contention, and am fairly confident that the idea pans out.  E.g. I hit
the BUG_ON(!is_shadow_present_pte()) using that setup, which is the only
reason those patches exist :-)

Sean Christopherson (22):
  KVM: selftests: Check for a potential unhandled exception iff KVM_RUN
    succeeded
  KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
  KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
  KVM: selftests: Compute number of extra pages needed in
    mmu_stress_test
  KVM: selftests: Enable mmu_stress_test on arm64
  KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
  KVM: selftests: Precisely limit the number of guest loops in
    mmu_stress_test
  KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
  KVM: selftests: Verify KVM correctly handles mprotect(PROT_READ)
  KVM: x86/mmu: Move walk_slot_rmaps() up near
    for_each_slot_rmap_range()
  KVM: x86/mmu: Plumb a @can_yield parameter into __walk_slot_rmaps()
  KVM: x86/mmu: Add a helper to walk and zap rmaps for a memslot
  KVM: x86/mmu: Honor NEED_RESCHED when zapping rmaps and blocking is
    allowed
  KVM: x86/mmu: Morph kvm_handle_gfn_range() into an aging specific
    helper
  KVM: x86/mmu: Fold mmu_spte_age() into kvm_rmap_age_gfn_range()
  KVM: x86/mmu: Add KVM_RMAP_MANY to replace open coded '1' and '1ul'
    literals
  KVM: x86/mmu: Refactor low level rmap helpers to prep for walking w/o
    mmu_lock
  KVM: x86/mmu: Use KVM_PAGES_PER_HPAGE() instead of an open coded
    equivalent
  KVM: x86/mmu: Add infrastructure to allow walking rmaps outside of
    mmu_lock
  KVM: x86/mmu: Add support for lockless walks of rmap SPTEs
  KVM: x86/mmu: Support rmap walks without holding mmu_lock when aging
    gfns
  ***HACK*** KVM: x86: Don't take mmu_lock when aging gfns

 arch/x86/kvm/mmu/mmu.c                        | 527 +++++++++++-------
 arch/x86/kvm/svm/svm.c                        |   2 +
 arch/x86/kvm/vmx/vmx.c                        |   2 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   3 +-
 ..._guest_memory_test.c => mmu_stress_test.c} | 144 ++++-
 virt/kvm/kvm_main.c                           |   7 +-
 7 files changed, 482 insertions(+), 206 deletions(-)
 rename tools/testing/selftests/kvm/{max_guest_memory_test.c => mmu_stress_test.c} (65%)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.76.ge559c4bf1a-goog



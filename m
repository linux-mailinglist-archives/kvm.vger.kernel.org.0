Return-Path: <kvm+bounces-26883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88FED978C5C
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 03:14:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADE5D1C22814
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 01:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE6AC18049;
	Sat, 14 Sep 2024 01:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UnN4JQw8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B196168B8
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 01:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726276439; cv=none; b=dpe7kWRiz25CWbWISD/37VPQKOdhUNNfAjARUtwhc+zl6U7IeHV1Y7P+LiFTmNGuC4Y/qyjNUs2Pz5iIduZ/IUu3pDI7VtKhzJwbD4c2DLYMJaq0yw2GJy+eubt4tiA9tghtedxaJgOUAZNyxaMUdqNkcg868FQeX7P/OnThKWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726276439; c=relaxed/simple;
	bh=JhQjvHU4nlyd0cPtYHleziW0WDbsr6+EQ8xZwOs1dHc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c2qd3B5slg28F7lMMjJLwUzfQoLZpHEQE9HEEdRw2TKHi2VjZHFw7OqaIIr6ovJoR+AyhYmzAW81WGb3uwFlVrWBbrUG9AHjdw5WZgan8Advc6DAYNdSDoKTyGfNujjd+mHZawtrkaHigu6DvI5jGgF5U8KK6/RVhEH2THmRbiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UnN4JQw8; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6818fa37eecso3120992a12.1
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 18:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726276437; x=1726881237; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aacdJw8TNmRgJZleOUeRazwv02Hn4nA2W9oH/j73FzM=;
        b=UnN4JQw8+hTScOdL40L26QDQThpK13Dh9HdBxRsKRXGzWMYnYbAJKNEc3dweOZ9HAk
         Sqi3URjmo3OzTVEXahhFC62O6U6VQzJ2SK350iJPgasbuD9Uy2s5vjoEp+XH95WscGN5
         Xw7Fg2jkAYYHPvI33RWSH9CBS6UusKiTFdQlHppXgKfntTT3gc046q6cx9qfcirSQmsl
         3N/4hZzgaSGBcRttj7sZOIDeysDpkQYg/d8GGJOqOggajvOvii63DOhZMfst9hOZZYJ5
         gUz6yJRvtQFvfB9xwfV7624TG3gEcH+beRuIHCYvTg33zQ3IEZ1KM0YxFxP+zhF6OVME
         D7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726276437; x=1726881237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aacdJw8TNmRgJZleOUeRazwv02Hn4nA2W9oH/j73FzM=;
        b=Eb9bMLEMsdHk4QowtgE5/UPlGO4PVlv1aDezYjqwyCUCzjP7zL7Yc0e5zMo7YdZMPQ
         G6pEDI0ffe0tdH8hoAZ2iz47q04/zocN7uV3AXS7Wd944bagM4cdC9OC7UAywZn/ZXEC
         jUds4fHNC+UR/cgFcLLip2gCq4ika2bIMUi3PlempBRyeJUggsG2845leEWnfAgq3HCr
         HClOp0JqK2d90DuKUA2dwkGg5ljJG1JQcuQOswTlkY/+CTk0hdWcBjcknRNSUxIRNZAO
         E7F8ra481Wp3WvWhgL024O2plPzE14nShmAAbOGlJXVlWoiIMVRwTaLbtwa++GSuzNea
         +7Fw==
X-Gm-Message-State: AOJu0YytSAekZGYpY0tWX0zBRf5sEfcsMFlGEgw46nNO9NJHOaiqrQiw
	msyrjLHCBAHaa5tUEWJT0+JN3fdf4j96W8hqWoJRNIV2ZFcWErGgJlo2f2VahsPJOIbEzR5+n68
	pzw==
X-Google-Smtp-Source: AGHT+IGlEsXZ2dgj+PLxZlYHIQ0vi4apKgGfQ/Win3919G8dju4lDWtoWfN0fO9U+MC+ECnEqlqFjWVZvbc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6859:0:b0:7d6:66fb:3da7 with SMTP id
 41be03b00d2f7-7db2057ef03mr22911a12.3.1726276436690; Fri, 13 Sep 2024
 18:13:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Sep 2024 18:13:44 -0700
In-Reply-To: <20240914011348.2558415-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240914011348.2558415-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240914011348.2558415-4-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.12
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The bulk of the changes are to clean up the thorny "unprotect and retry" mess
that grew over time.  The other notable change is to support yielding in the
shadow MMU when zapping rmaps (simply a historic oversight, AFAICT).

The following changes since commit 47ac09b91befbb6a235ab620c32af719f8208399:

  Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.12

for you to fetch changes up to 9a5bff7f5ec2383e3edac5eda561b52e267ccbb5:

  KVM: x86/mmu: Use KVM_PAGES_PER_HPAGE() instead of an open coded equivalent (2024-09-09 20:22:08 -0700)

----------------------------------------------------------------
KVM x86 MMU changes for 6.12:

 - Overhaul the "unprotect and retry" logic to more precisely identify cases
   where retrying is actually helpful, and to harden all retry paths against
   putting the guest into an infinite retry loop.

 - Add support for yielding, e.g. to honor NEED_RESCHED, when zapping rmaps in
   the shadow MMU.

 - Refactor pieces of the shadow MMU related to aging SPTEs in prepartion for
   adding MGLRU support in KVM.

 - Misc cleanups

----------------------------------------------------------------
Sean Christopherson (33):
      KVM: x86/mmu: Clean up function comments for dirty logging APIs
      KVM: x86/mmu: Decrease indentation in logic to sync new indirect shadow page
      KVM: x86/mmu: Drop pointless "return" wrapper label in FNAME(fetch)
      KVM: x86/mmu: Reword a misleading comment about checking gpte_changed()
      KVM: x86/mmu: Replace PFERR_NESTED_GUEST_PAGE with a more descriptive helper
      KVM: x86/mmu: Trigger unprotect logic only on write-protection page faults
      KVM: x86/mmu: Skip emulation on page fault iff 1+ SPs were unprotected
      KVM: x86: Retry to-be-emulated insn in "slow" unprotect path iff sp is zapped
      KVM: x86: Get RIP from vCPU state when storing it to last_retry_eip
      KVM: x86: Store gpa as gpa_t, not unsigned long, when unprotecting for retry
      KVM: x86/mmu: Apply retry protection to "fast nTDP unprotect" path
      KVM: x86/mmu: Try "unprotect for retry" iff there are indirect SPs
      KVM: x86: Move EMULTYPE_ALLOW_RETRY_PF to x86_emulate_instruction()
      KVM: x86: Fold retry_instruction() into x86_emulate_instruction()
      KVM: x86/mmu: Don't try to unprotect an INVALID_GPA
      KVM: x86/mmu: Always walk guest PTEs with WRITE access when unprotecting
      KVM: x86/mmu: Move event re-injection unprotect+retry into common path
      KVM: x86: Remove manual pfn lookup when retrying #PF after failed emulation
      KVM: x86: Check EMULTYPE_WRITE_PF_TO_SP before unprotecting gfn
      KVM: x86: Apply retry protection to "unprotect on failure" path
      KVM: x86: Update retry protection fields when forcing retry on emulation failure
      KVM: x86: Rename reexecute_instruction()=>kvm_unprotect_and_retry_on_failure()
      KVM: x86/mmu: Subsume kvm_mmu_unprotect_page() into the and_retry() version
      KVM: x86/mmu: Detect if unprotect will do anything based on invalid_list
      KVM: x86/mmu: WARN on MMIO cache hit when emulating write-protected gfn
      KVM: x86/mmu: Move walk_slot_rmaps() up near for_each_slot_rmap_range()
      KVM: x86/mmu: Plumb a @can_yield parameter into __walk_slot_rmaps()
      KVM: x86/mmu: Add a helper to walk and zap rmaps for a memslot
      KVM: x86/mmu: Honor NEED_RESCHED when zapping rmaps and blocking is allowed
      KVM: x86/mmu: Morph kvm_handle_gfn_range() into an aging specific helper
      KVM: x86/mmu: Fold mmu_spte_age() into kvm_rmap_age_gfn_range()
      KVM: x86/mmu: Add KVM_RMAP_MANY to replace open coded '1' and '1ul' literals
      KVM: x86/mmu: Use KVM_PAGES_PER_HPAGE() instead of an open coded equivalent

 arch/x86/include/asm/kvm_host.h |  14 +-
 arch/x86/kvm/mmu/mmu.c          | 522 ++++++++++++++++++++++------------------
 arch/x86/kvm/mmu/mmu_internal.h |   3 +
 arch/x86/kvm/mmu/mmutrace.h     |   1 +
 arch/x86/kvm/mmu/paging_tmpl.h  |  63 ++---
 arch/x86/kvm/mmu/tdp_mmu.c      |   6 +-
 arch/x86/kvm/x86.c              | 133 +++-------
 7 files changed, 368 insertions(+), 374 deletions(-)


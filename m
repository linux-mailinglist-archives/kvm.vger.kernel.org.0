Return-Path: <kvm+bounces-42045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0101A71F3A
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:36:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4369A16DECC
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E299253B52;
	Wed, 26 Mar 2025 19:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tDN+t+tw"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCBF28F4
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017807; cv=none; b=rSv7bGh7PyvKpVKz305CWbiEGd082E8c36CxsgMfArk11upEejRfoiDVAGcjF3fBt5+bJhi0SiqN0iP3LXuGmo6Ar4gvPbYdUcsrtrsrIK9jesWfDwTfu5esNLew0WjaCWMq90CCgusdG4JYHGueA5JduvFDU76eyt3JGBI6nEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017807; c=relaxed/simple;
	bh=iCe3vUWCBZUscHGadsB2mhM5FSdOlIOoCRbZGDBBFXU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rbVma9w073HnPWhg2t2uRBVpl1tuGiDMTCL5G6IclNdO406blGsYpDGmuiAgIGu5sy0Gqa/L3e0DDXGd+7vQv19+wk+FPYw169wWfdCKPW+SX0Fg4SpP0Tyiy8tYRndfYZlPKwNZVLu3WvIaFDg1G2o3FNhKnazWdT6BcEsydF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tDN+t+tw; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743017802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=igHLlAUF2gg1w7BHyUZ6DJF3h/gY/QKuvdzyLucTTqE=;
	b=tDN+t+twdMmkjLuCk3tm/HIvlqQET1WVA7LBxX25XeIxkDt4TBPs29Qc0QKgk1z19TtVgp
	rEo6tBq+8kdzL0fRYZvQgzTDfCPmW9+0wYHx0iN1Du7+p0dbsQxzM0bq8H1AYiTEuinkQZ
	eooCDG4CfxM+lLuwCMV3MxPP08KiCzw=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 00/24] KVM: SVM: Rework ASID management
Date: Wed, 26 Mar 2025 19:35:55 +0000
Message-ID: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This series reworks how SVM manages ASIDs by:
(a) Allocating a single static ASID for each L1 VM, instead of
    dynamically allocating ASIDs. This simplifies the logic and allow
    for more unifications between SVM and SEV, as the latter already
    uses per-VM ASIDs as required for other purposes.

    This is patches 1 to 10.

(b) Using a separate ASID for L2 VMs. Instead of using the same ASID for
    L1 and L2 guests, and doing a TLB flush and MMU sync on every nested
    transition, a separate ASID is used and TLB flushes are done
    conditionally as needed.

    This is patches 11 till the end.

The advantages of this are:
- Simplifying the logic by dropping dynamic ASID allocations.
- Unifying some logic between SVM and SEV, as the latter already uses
  per-VM ASIDs as required for other purposes.
- Enabling INVLPGB virtualization [1].
- Improving the performance of nested guests by avoiding some TLB
  flushes.

The series was tested by running a L2 and L3 Linux guests with some
simple workloads in them (mmap()/munmap() stress, netperf, etc). I also
ran the KVM selftests in both L0 and L1.

I believe some of the patches are in mergeable state, but this series is
still an RFC for a few reasons:
- I haven't done as much testing as I initially planned. Mainly I wanted
  to test with a Windows guest running WSL to get Linux and Windows L2
  VMs running side-by-side. I couldn't get it done due to some
  testing infrastructure hiccups.

- The SEV changes are generally untested beyond build testing, and I
  would like to get more feedback on them before moving forward. Namely,
  I think there is room for further unification. SEV should probably use
  the new kvm_tlb_tags infrastructure to allocate its ASIDs as well. The
  way I think about it is by optionally having a bitmap of "pending"
  ASIDs in kvm_tlb_tags, and make unused SEV ASIDs "pending" until we
  run out of space and do the necessary flushes to make them free.

- I want to get general feedback about the direction this is heading in,
  and things like generalizing the ASID tracking in SEV to work for SVM,
  thoughts on using an xarray for that, etc.

- Some things can/should be cleaned up, although they can be followups
  too. For example, the current logic will allocate a "normal" ASID for
  an SEV VM upon creation, then allocate an SEV-friendly ASID to it when
  SEV is initialized. The "normal" ASID remains allocated though, and
  kvm_svm->asid and kvm_svm->sev_info.asid remain different. It seems
  like we should not allocate the "normal" ASID to begin with, or free
  it if the VM uses SEV. However, I am not sure what's the best way to
  do any of this because I am not clear on the life cycle of a SEV VM.

This series started as two separate series, one to optimize nested TLB
flushes by using a separate ASID for L2 VMs [2], and one to use a single
ASID per-VM [3]. However, there is a lot of dependency and interaction
among both series that I think it's useful to combine them, at least for
now so that the big picture is clear. The series can be later split
again into 2 or more series, or merged incrementally.

I am sending this out now to get feedback, and also to "checkpoint" my
work as I won't be picking this up again for a few months. I will remain
able to respond to discussion and reviews, although at a lower capacity.
If anyone wants to pick up this series in the meantime, partially or
fully, please feel free to do so. Just let me know so that we can
coordinate.

Rik and Tom, I CC'd you due to the previous discussion you had with Sean
about INVLPGB virtualization. I can drop you from following versions if
you'd like to avoid the noise.

Here is a brief walkthrough of the series:

Part 1: Use a single ASID per-VM
- Patch 1 generalizes the VPID allocation into a generic kvm_tlb_tags
  factory to be used by SVM.
- Patches 2-3 are cleanups and/or refactoring.
- Patches 4-5 get rid of the cases where we currently allocate a new
  ASID dynamically by just flushing the existing ASID or falling back to
  full flush if flushing an ASID is not supported.
- Patches 6-9 generalize SEV's per-CPU ASID -> vCPU tracking to make it
  work for SVM.
- Patch 10 finally drops the dynamic ASID allocation logic and uses a
  single per-VM ASID.

Part 2: Optimize nSVM TLB flushes
- Patch 11 starts by using a separate ASID for L2 guests, although
  it is initially the same as the L1 ASID. It's essentially just laying
  the groundwork.
- Patches 12 - 16 are refactoring groundwork.
- Patches 17 - 22 add the needed handling of the L2 ASID TLB flushing.
- Patch 23 starts allocating a new ASID for L2 as using the same ASID is
  no longer needed.
- Patch 24 drops the unconditional TLB flushes on nested transitions,
  which are no longer necessary after L2 is using a separate
  well-maintained ASID.

Diff from the initial versions of series [2] and [3]:
- Generalized the SEV tracking of ASID->vCPU to use it for SVM, to make
  sure the TLB is flushed when a new vCPU with the same ASID is run on
  the same physical CPU.
- Made sure kvm_hv_vcpu_purge_flush_tlb() is handled correctly by
  passing in is_guest_mode to purge the correct queue when doing L1 vs
  L2 TLB flushes (Maxim).
- Improved the commentary in nested_svm_entry_tlb_flush() (Maxim).
- Handle INVLPGA from the guest even nested NPT is used (Maxim).
- Improved some commit logs.

[1]https://lore.kernel.org/all/Z8HdBg3wj8M7a4ts@google.com/
[2]https://lore.kernel.org/lkml/20250205182402.2147495-1-yosry.ahmed@linux.dev/
[3]https://lore.kernel.org/lkml/20250313215540.4171762-1-yosry.ahmed@linux.dev/


Yosry Ahmed (24):
  KVM: VMX: Generalize VPID allocation to be vendor-neutral
  KVM: SVM: Use cached local variable in init_vmcb()
  KVM: SVM: Add helpers to set/clear ASID flush in VMCB
  KVM: SVM: Flush everything if FLUSHBYASID is not available
  KVM: SVM: Flush the ASID when running on a new CPU
  KVM: SEV: Track ASID->vCPU instead of ASID->VMCB
  KVM: SEV: Track ASID->vCPU on vCPU load
  KVM: SEV: Drop pre_sev_run()
  KVM: SEV: Generalize tracking ASID->vCPU with xarrays
  KVM: SVM: Use a single ASID per VM
  KVM: nSVM: Use a separate ASID for nested guests
  KVM: x86: hyper-v: Pass is_guest_mode to kvm_hv_vcpu_purge_flush_tlb()
  KVM: nSVM: Parameterize svm_flush_tlb_asid() by is_guest_mode
  KVM: nSVM: Split nested_svm_transition_tlb_flush() into entry/exit fns
  KVM: x86/mmu: rename __kvm_mmu_invalidate_addr()
  KVM: x86/mmu: Allow skipping the gva flush in
    kvm_mmu_invalidate_addr()
  KVM: nSVM: Flush both L1 and L2 ASIDs on KVM_REQ_TLB_FLUSH
  KVM: nSVM: Handle nested TLB flush requests through TLB_CONTROL
  KVM: nSVM: Flush the TLB if L1 changes L2's ASID
  KVM: nSVM: Do not reset TLB_CONTROL in VMCB02 on nested entry
  KVM: nSVM: Service local TLB flushes before nested transitions
  KVM: nSVM: Handle INVLPGA interception correctly
  KVM: nSVM: Allocate a new ASID for nested guests
  KVM: nSVM: Stop bombing the TLB on nested transitions

 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/include/asm/svm.h      |   5 -
 arch/x86/kvm/hyperv.h           |   8 +-
 arch/x86/kvm/mmu/mmu.c          |  22 ++-
 arch/x86/kvm/svm/nested.c       |  68 ++++++---
 arch/x86/kvm/svm/sev.c          |  60 +-------
 arch/x86/kvm/svm/svm.c          | 257 +++++++++++++++++++++++---------
 arch/x86/kvm/svm/svm.h          |  43 ++++--
 arch/x86/kvm/vmx/nested.c       |   4 +-
 arch/x86/kvm/vmx/vmx.c          |  38 +----
 arch/x86/kvm/vmx/vmx.h          |   4 +-
 arch/x86/kvm/x86.c              |  60 +++++++-
 arch/x86/kvm/x86.h              |  13 ++
 13 files changed, 378 insertions(+), 206 deletions(-)

-- 
2.49.0.395.g12beb8f557-goog



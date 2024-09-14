Return-Path: <kvm+bounces-26921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BCEC9790FD
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 15:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A0AA1C21751
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 13:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 280471CF5DE;
	Sat, 14 Sep 2024 13:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ah/zh0yP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DB8749A
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 13:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726320816; cv=none; b=OSJ+cjGNLrhti1NsXrmgBqDUNKF6cv+Asetgll+4OmBOwNv5ZVlMbH2fqsMJJ1c49KapD858xRmpy3pHPNd2Ju5oMV7Xm45sE5V08zeY7fPKU+lyCXBIiqPAk0DBO/mnxsM+X0vKHPbwBc3Hk7ANYcCwfFTm6O1RhsHSCZaYzdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726320816; c=relaxed/simple;
	bh=nEalzy27zk/YSi5fgf0C2owdqi+2nj23AXN7KcjZveQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uP/qNvGXfJ+tE8zjMSudlxbhG+Rr8dDlZy6QJPLVW1UvYnnMnb0QlILy/+ADws+ogZG+Oc8VbjuecVFnYijw4lA7KaJqA8RPhEo6iZqUPos8/KZ2wiSCKlayXT62D3ZCijVfXK+t4sgE8vipy20HWwAcew48fqhqtHJyTk/vJj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ah/zh0yP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726320813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yw/3v0pyN1c3bG0UyeyuDqJoRgJLCqQw8Hl/RgHrtic=;
	b=ah/zh0yPLnHsI5jFvFxv+smbr7OZCJSGO2FYblzef3xw8Y/VyDB79eV0Bt9eCvhL/AH205
	wNyuuk7vl69gze6WS0mtHhk1ZDP75xzJ/pRUxhiBpz7O6GloHkmgu1fI1qgabHDh44HQMj
	0BQ7Benjj/0PR0q9q8k+tKbh74XKiuE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2--AZcufPuOQWErDTaosQNNA-1; Sat, 14 Sep 2024 09:33:32 -0400
X-MC-Unique: -AZcufPuOQWErDTaosQNNA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42cceb06940so21140135e9.0
        for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 06:33:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726320810; x=1726925610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yw/3v0pyN1c3bG0UyeyuDqJoRgJLCqQw8Hl/RgHrtic=;
        b=dGxUl79tp71NcZK9lmaC3f/Cs0qM7HVrpIP6XiTG4x1U/KeAgToFBFjZ9pPXFQ0pDF
         t699u9P3YoGEisu+Uj8QNlDf1or+pwl59AnGl5pCyXimvDCS/x0Tp7A+GX6rZy136721
         y/zA7kLIhiof0ooH4oXRR/zOjV8jVgIsSG41gz9FmelzD8/XCosgwagfxHS8q1iPpvO7
         HWHqM4FuU1Gm41rUTTFDIVTAzWqV8jO0O+Ij5BLXhHrlwOvAYD7bthLSoVmuJ87FPy52
         wN1FLy7F6BX8bx6dlTDrs0DBp94HKB6qxB+n1stOS5UyQsCwZIBWGSWj3WkaHBBGlHA4
         27oA==
X-Forwarded-Encrypted: i=1; AJvYcCVkrIDGix+5pp9WJSZKrA8h3X5FKbL1cm80qJUiAXhXGbpjaxbFh1QWw7LsyVII+8tm9ow=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE4Yy9hIoJzWYRiniTEOw8/MTUH8a8lHNT2KacePjLwkElg8Bt
	4WCHQ2zNhDKkKW7O6xX/dT/BhRodsodoxK07T8bRe92yxMKkEYN6gtlJRmtw07xtoq40SSOSsZB
	tdWvN8HL77Pu3ck3x4EU+PU++BZYntGkO+TiyP19TnthKh8o0x9ArMl7OnIoffwY0FJ7VajuSPA
	S4m9r+l/IlEzAfAu64TRZTuCybzGWa+7m1Yjk=
X-Received: by 2002:a05:6000:18c2:b0:374:ce15:998c with SMTP id ffacd0b85a97d-378c2d1345dmr5018347f8f.30.1726320809494;
        Sat, 14 Sep 2024 06:33:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHE3qhF2g+GhRAgw64aSy4Wxia/p7Zl18KZBvqbkrabGbZDAq18qSQ2kgRHi+JkeIrk3kd1UQYlYEB8asmVRLs=
X-Received: by 2002:a05:6000:18c2:b0:374:ce15:998c with SMTP id
 ffacd0b85a97d-378c2d1345dmr5018332f8f.30.1726320808897; Sat, 14 Sep 2024
 06:33:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912091229.411782-1-maz@kernel.org>
In-Reply-To: <20240912091229.411782-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 14 Sep 2024 15:33:17 +0200
Message-ID: <CABgObfagG0mjDQrmxMydwxr_m45d2W+RQyioQrgc2=fHoPRo3Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.12
To: Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Colton Lewis <coltonlewis@google.com>, 
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, Mark Brown <broonie@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Ricardo Koller <ricarkol@google.com>, 
	Sean Christopherson <seanjc@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Snehal Koukuntla <snehalreddy@google.com>, Steven Price <steven.price@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2024 at 11:12=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Hi Paolo,
>
> Here's the set of KVM/arm64 changes 6.12. The only two user-visible
> features are FP8 support and the new Stage-2 page-table dumper. The NV
> onslaught continues with the addition of the address translation
> instruction emulation, and we have a bunch of fixes all over the
> place (details in the tag text below).
>
> Note that there is a very minor conflict with arm64 in -next, which is
> trivially resolved as [1].

Pulled, thanks.

Paolo

> Please pull,
>
>         M.
>
> [1] https://lore.kernel.org/linux-next/20240905160856.14e95d14@canb.auug.=
org.au
>
> The following changes since commit 5be63fc19fcaa4c236b307420483578a56986a=
37:
>
>   Linux 6.11-rc5 (2024-08-25 19:07:11 +1200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-6.12
>
> for you to fetch changes up to 17a0005644994087794f6552d7a5e105d6976184:
>
>   Merge branch kvm-arm64/visibility-cleanups into kvmarm-master/next (202=
4-09-12 08:38:17 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 updates for 6.12
>
> * New features:
>
>   - Add a Stage-2 page table dumper, reusing the main ptdump
>     infrastructure, and allowing easier debugging of the our
>     page-table infrastructure
>
>   - Add FP8 support to the KVM/arm64 floating point handling.
>
>   - Add NV support for the AT family of instructions, which mostly
>     results in adding a page table walker that deals with most of the
>     complexity of the architecture.
>
> * Improvements, fixes and cleanups:
>
>   - Add selftest checks for a bunch of timer emulation corner cases
>
>   - Fix the multiple of cases where KVM/arm64 doesn't correctly handle
>     the guest trying to use a GICv3 that isn't advertised
>
>   - Remove REG_HIDDEN_USER from the sysreg infrastructure, making
>     things little more simple
>
>   - Prevent MTE tags being restored by userspace if we are actively
>     logging writes, as that's a recipe for disaster
>
>   - Correct the refcount on a page that is not considered for MTE tag
>     copying (such as a device)
>
>   - Relax the synchronisation when walking a page table to split block
>     mappings, moving it at the end the walk, as there is no need to
>     perform it on every store.
>
>   - Fix boundary check when transfering memory using FFA
>
>   - Fix pKVM TLB invalidation, only affecting currently out of tree
>     code but worth addressing for peace of mind
>
> ----------------------------------------------------------------
> Colton Lewis (3):
>       KVM: arm64: Move data barrier to end of split walk
>       KVM: arm64: selftests: Ensure pending interrupts are handled in arc=
h_timer test
>       KVM: arm64: selftests: Add arch_timer_edge_cases selftest
>
> Joey Gouly (1):
>       KVM: arm64: Make kvm_at() take an OP_AT_*
>
> Marc Zyngier (47):
>       KVM: arm64: Move SVCR into the sysreg array
>       KVM: arm64: Add predicate for FPMR support in a VM
>       KVM: arm64: Move FPMR into the sysreg array
>       KVM: arm64: Add save/restore support for FPMR
>       KVM: arm64: Honor trap routing for FPMR
>       KVM: arm64: Expose ID_AA64FPFR0_EL1 as a writable ID reg
>       KVM: arm64: Enable FP8 support when available and configured
>       KVM: arm64: Expose ID_AA64PFR2_EL1 to userspace and guests
>       Merge branch kvm-arm64/tlbi-fixes-6.12 into kvmarm-master/next
>       KVM: arm64: Move GICv3 trap configuration to kvm_calculate_traps()
>       KVM: arm64: Force SRE traps when SRE access is not enabled
>       KVM: arm64: Force GICv3 trap activation when no irqchip is configur=
ed on VHE
>       KVM: arm64: Add helper for last ditch idreg adjustments
>       KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to =
the guest
>       KVM: arm64: Add ICH_HCR_EL2 to the vcpu state
>       KVM: arm64: Add trap routing information for ICH_HCR_EL2
>       KVM: arm64: Honor guest requested traps in GICv3 emulation
>       KVM: arm64: Make most GICv3 accesses UNDEF if they trap
>       KVM: arm64: Unify UNDEF injection helpers
>       KVM: arm64: Add selftest checking how the absence of GICv3 is handl=
ed
>       arm64: Add missing APTable and TCR_ELx.HPD masks
>       arm64: Add PAR_EL1 field description
>       arm64: Add system register encoding for PSTATE.PAN
>       arm64: Add ESR_ELx_FSC_ADDRSZ_L() helper
>       KVM: arm64: nv: Enforce S2 alignment when contiguous bit is set
>       KVM: arm64: nv: Turn upper_attr for S2 walk into the full descripto=
r
>       KVM: arm64: nv: Honor absence of FEAT_PAN2
>       KVM: arm64: nv: Add basic emulation of AT S1E{0,1}{R,W}
>       KVM: arm64: nv: Add basic emulation of AT S1E1{R,W}P
>       KVM: arm64: nv: Add basic emulation of AT S1E2{R,W}
>       KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}
>       KVM: arm64: nv: Make ps_to_output_size() generally available
>       KVM: arm64: nv: Add SW walker for AT S1 emulation
>       KVM: arm64: nv: Sanitise SCTLR_EL1.EPAN according to VM configurati=
on
>       KVM: arm64: nv: Make AT+PAN instructions aware of FEAT_PAN3
>       KVM: arm64: nv: Plumb handling of AT S1* traps from EL2
>       KVM: arm64: nv: Add support for FEAT_ATS1A
>       KVM: arm64: Simplify handling of CNTKCTL_EL12
>       KVM: arm64: Simplify visibility handling of AArch32 SPSR_*
>       KVM: arm64: Get rid of REG_HIDDEN_USER visibility qualifier
>       Merge branch kvm-arm64/mmu-misc-6.12 into kvmarm-master/next
>       Merge branch kvm-arm64/fpmr into kvmarm-master/next
>       Merge branch kvm-arm64/vgic-sre-traps into kvmarm-master/next
>       Merge branch kvm-arm64/selftests-6.12 into kvmarm-master/next
>       Merge branch kvm-arm64/nv-at-pan into kvmarm-master/next
>       Merge branch kvm-arm64/s2-ptdump into kvmarm-master/next
>       Merge branch kvm-arm64/visibility-cleanups into kvmarm-master/next
>
> Oliver Upton (1):
>       KVM: arm64: selftests: Cope with lack of GICv3 in set_id_regs
>
> Sean Christopherson (2):
>       KVM: arm64: Release pfn, i.e. put page, if copying MTE tags hits ZO=
NE_DEVICE
>       KVM: arm64: Disallow copying MTE to guest memory while KVM is dirty=
 logging
>
> Sebastian Ene (5):
>       KVM: arm64: Move pagetable definitions to common header
>       arm64: ptdump: Expose the attribute parsing functionality
>       arm64: ptdump: Use the ptdump description from a local context
>       arm64: ptdump: Don't override the level when operating on the stage=
-2 tables
>       KVM: arm64: Register ptdump with debugfs on guest creation
>
> Snehal Koukuntla (1):
>       KVM: arm64: Add memory length checks and remove inline in do_ffa_me=
m_xfer
>
> Will Deacon (2):
>       KVM: arm64: Invalidate EL1&0 TLB entries for all VMIDs in nvhe hyp =
init
>       KVM: arm64: Ensure TLBI uses correct VMID after changing context
>
>  arch/arm64/include/asm/esr.h                       |    5 +-
>  arch/arm64/include/asm/kvm_arm.h                   |    1 +
>  arch/arm64/include/asm/kvm_asm.h                   |    6 +-
>  arch/arm64/include/asm/kvm_host.h                  |   22 +-
>  arch/arm64/include/asm/kvm_mmu.h                   |    6 +
>  arch/arm64/include/asm/kvm_nested.h                |   40 +-
>  arch/arm64/include/asm/kvm_pgtable.h               |   42 +
>  arch/arm64/include/asm/pgtable-hwdef.h             |    9 +
>  arch/arm64/include/asm/ptdump.h                    |   43 +-
>  arch/arm64/include/asm/sysreg.h                    |   22 +
>  arch/arm64/kvm/Kconfig                             |   17 +
>  arch/arm64/kvm/Makefile                            |    3 +-
>  arch/arm64/kvm/arm.c                               |   15 +-
>  arch/arm64/kvm/at.c                                | 1101 ++++++++++++++=
++++++
>  arch/arm64/kvm/emulate-nested.c                    |   81 +-
>  arch/arm64/kvm/fpsimd.c                            |    5 +-
>  arch/arm64/kvm/guest.c                             |    6 +
>  arch/arm64/kvm/hyp/include/hyp/fault.h             |    2 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h            |    3 +
>  arch/arm64/kvm/hyp/nvhe/ffa.c                      |   21 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |    2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |    9 +
>  arch/arm64/kvm/hyp/nvhe/switch.c                   |    9 +
>  arch/arm64/kvm/hyp/nvhe/tlb.c                      |    6 +-
>  arch/arm64/kvm/hyp/pgtable.c                       |   48 +-
>  arch/arm64/kvm/hyp/vgic-v3-sr.c                    |   97 +-
>  arch/arm64/kvm/hyp/vhe/switch.c                    |    3 +
>  arch/arm64/kvm/nested.c                            |   55 +-
>  arch/arm64/kvm/ptdump.c                            |  268 +++++
>  arch/arm64/kvm/sys_regs.c                          |  386 ++++---
>  arch/arm64/kvm/sys_regs.h                          |   23 +-
>  arch/arm64/kvm/vgic/vgic-v3.c                      |   12 +
>  arch/arm64/kvm/vgic/vgic.c                         |   14 +-
>  arch/arm64/kvm/vgic/vgic.h                         |    6 +-
>  arch/arm64/mm/ptdump.c                             |   70 +-
>  tools/testing/selftests/kvm/Makefile               |    2 +
>  .../selftests/kvm/aarch64/arch_timer_edge_cases.c  | 1062 ++++++++++++++=
+++++
>  tools/testing/selftests/kvm/aarch64/no-vgic-v3.c   |  175 ++++
>  tools/testing/selftests/kvm/aarch64/set_id_regs.c  |    1 +
>  tools/testing/selftests/kvm/aarch64/vgic_irq.c     |   11 +-
>  .../selftests/kvm/include/aarch64/arch_timer.h     |   18 +-
>  .../selftests/kvm/include/aarch64/processor.h      |    3 +
>  .../testing/selftests/kvm/lib/aarch64/processor.c  |    6 +
>  43 files changed, 3405 insertions(+), 331 deletions(-)
>  create mode 100644 arch/arm64/kvm/at.c
>  create mode 100644 arch/arm64/kvm/ptdump.c
>  create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_c=
ases.c
>  create mode 100644 tools/testing/selftests/kvm/aarch64/no-vgic-v3.c
>



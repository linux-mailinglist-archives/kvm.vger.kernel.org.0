Return-Path: <kvm+bounces-42333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 096BFA77FDA
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:11:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 363B63A9749
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F45720CCDC;
	Tue,  1 Apr 2025 16:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="auuBmgUE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D721189F56
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523875; cv=none; b=iyafMSX0bemljpFlQVFjwcA4Gb5fZO4kJk/2WVvsbvPV8y2+DDf4hJZfylzvKY+f3UrsmZSKY8UGPuqrdSHOlq9OoTn6IuNfNvKljEJB5mBE5+pDAgnDMkEH3EEgMTME+V7C+9r/LKOHMjdocEnAXjUyadMYWEZ1AZvRktnCdic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523875; c=relaxed/simple;
	bh=X1Kt7capH49OXRVgvIsROIBkJs6Ohjt5LS1eLpQ140Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GP5uBhY92QzHKOkIk5SDYvzHSQGLU2i6i5NZIT7h+TCB+mq2kIHGr/GsDnVlYlEDOQjZBVWr41Nb5Qs66wd9dH3PpcNsF3nOk3+Mxo7pDHx9DY9mNcRtMrDWhpmrdiFXdQ0rhL0neoLmgplp63cFbHcAgB7pmqwlBvdBPDF4CLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=auuBmgUE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uLF3r2cxjhjSLuZwWHW6vMjv1CuEadneqLY/dm35BHE=;
	b=auuBmgUE4ucFDSbZXHPtVK1NpBB4Qf7nSFlA3I/qevGIvgIs+CyH0LrYe6hrKiUcEoBE12
	+tdY4GZiSm2Jn5hnts+BySLbfOASyT6tZszvm2nPjhLNEcYDNQzh+V2XlevjWjMFbgxnE0
	WAcGlPTggnXj991E5NfC2Y3vC+gg81U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-w9sPQy4uP-OijaYVgVyMlg-1; Tue, 01 Apr 2025 12:11:11 -0400
X-MC-Unique: w9sPQy4uP-OijaYVgVyMlg-1
X-Mimecast-MFC-AGG-ID: w9sPQy4uP-OijaYVgVyMlg_1743523870
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3912e4e2033so2463560f8f.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523870; x=1744128670;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uLF3r2cxjhjSLuZwWHW6vMjv1CuEadneqLY/dm35BHE=;
        b=VbEFsYIG70ib3//yofrX8lSrdDSgErYlReTVrhjch0e5aVO0SsHARW4Q3ottJE/oNu
         K4KXxCh+Z+2rS49rrkly7Zu5nc6gSxH1XYdr3wW2HpVTdkaaTHzBWuma5DzZ8lnmC9Qc
         5Wep16BnPx+r4dmyF2pGjGMmzWLt3Tv919ehX1Og3bYLiEXXlLh2fF92wkMjw1JzE5HW
         KiDTvQ30W1yClK/SzSw+VYuoxAzcqAoJhZGcItT3YeRtx48zUMWIE3mEKADN2QBk65fq
         lMdSKwVloIrKY+vSLBypOriBFWg/jz6C3cnz53ZjHv5NmG1czuL5LNCv6o5aYrxBcWos
         RExg==
X-Forwarded-Encrypted: i=1; AJvYcCXaDMuBlcE5MeOBkKjVkahVwmY4RGmKkhuiJmdNVMvjeql6AYO3/LeQC/tMDbDgoKPTRSU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwLqxPNqcUXqsp2rzvR8Y5zpOdYPous0HtLAQdEyPsearKgP93
	V/OZHyz0WBM8SfYD0mbwaTrEe/iBZGnLWvTKXjGvqsEFe91F+/4H1NrCd4NU8JJ8Fwxpz7QNBo+
	5EsJvXv6H7OhVB0JyxPx83OycP8bgd1XbDgfC25yFTIeKO1lT4g==
X-Gm-Gg: ASbGncvFR6BciM0SjkQtAQBAZYFBry1bvfvLcJasCaU53Ja0SW02GNe3Hn8xU3zeD00
	+1akkfEqFKrg85uIGgeDYea13A585hC7i/ViGnJE5SCU2EQ2288KAZm+LxZeriFbiv5DIqwHLyD
	7LpbrXHftNEAMZb+ZcZqW6Oc1nygVCF5jD1Zc4ptiVh9AFdYZXSB/ZfEvuc/HIhVklMmaMd4yP/
	PrbmDI+6QcPW3bGuDgC5lMz2oRoJEaCoLGlbpyOxFtnCkWHkbkEOe617zv1fbwbC+FqxPU8dUlM
	4/dVOLhx4+ZLRo9FyrBOcQ==
X-Received: by 2002:a05:6000:2512:b0:39c:1efc:b02 with SMTP id ffacd0b85a97d-39c1efc0b5amr6390357f8f.28.1743523869568;
        Tue, 01 Apr 2025 09:11:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEU9d1rPXQwDFjFPLQ9UfbTij1dLS04c6ZUWP+/nNhLOBclgu0Hb7YrK57FUDJLISetTxaodQ==
X-Received: by 2002:a05:6000:2512:b0:39c:1efc:b02 with SMTP id ffacd0b85a97d-39c1efc0b5amr6390286f8f.28.1743523869049;
        Tue, 01 Apr 2025 09:11:09 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b7a41a9sm14863655f8f.90.2025.04.01.09.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:07 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [RFC PATCH 00/29] KVM: VM planes
Date: Tue,  1 Apr 2025 18:10:37 +0200
Message-ID: <20250401161106.790710-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I guess April 1st is not the best date to send out such a large series
after months of radio silence, but here we are.

AMD VMPLs, Intel TDX partitions, Microsoft Hyper-V VTLs, and ARM CCA planes.
are all examples of virtual privilege level concepts that are exclusive to
guests.  In all these specifications the hypervisor hosts multiple
copies of a vCPU's register state (or at least of most of it) and provides
hypercalls or instructions to switch between them.

This is the first draft of the implementation according to the sketch that
was prepared last year between Linux Plumbers and KVM Forum.  The initial
version of the API was posted last October, and the implementation only
needed small changes.

Attempts made in the past, mostly in the context of Hyper-V VTLs and SEV-SNP
VMPLs, fell into two categories:

- use a single vCPU file descriptor, and store multiple copies of the state
  in a single struct kvm_vcpu.  This approach requires a lot of changes to
  provide multiple copies of affected fields, especially MMUs and APICs;
  and complex uAPI extensions to direct existing ioctls to a specific
  privilege level.  While more or less workable for SEV-SNP VMPLs, that
  was only because the copies of the register state were hidden
  in the VMSA (KVM does not manage it); it showed all its problems when
  applied to Hyper-V VTLs.

  The main advantage was that KVM kept the knowledge of the relationship
  between vCPUs that have the same id but belong to different privilege
  levels.  This is important in order to accelerate switches in-kernel.

- use multiple VM and vCPU file descriptors, and handle the switch entirely
  in userspace.  This got gnarly pretty fast for even more reasons than
  the previous case, for example because VMs could not share anymore
  memslots, including dirty bitmaps and private/shared attributes (a
  substantial problem for SEV-SNP since VMPLs share their ASID).

  Opposite to the other case, the total lack of kernel-level sharing of
  register state, and lack of control that vCPUs do not run in parallel,
  is what makes this approach problematic for both kernel and userspace.
  In-kernel implementation of privilege level switch becomes from
  complicated to impossible, and userspace needs a lot of complexity
  as well to ensure that higher-privileged VTLs properly interrupted a
  lower-privileged one.

This design sits squarely in the middle: it gives the initial set of
VM and vCPU file descriptors the full set of ioctls + struct kvm_run,
whereas other privilege levels ("planes") instead only support a small
part of the KVM API.  In fact for the vm file descriptor it is only three
ioctls: KVM_CHECK_EXTENSION, KVM_SIGNAL_MSI, KVM_SET_MEMORY_ATTRIBUTES.
For vCPUs it is basically KVM_GET/SET_*.

Most notably, memslots and KVM_RUN are *not* included (the choice of
which plane to run is done via vcpu->run), which solves a lot of
the problems in both of the previous approaches.  Compared to the
multiple-file-descriptors solution, it gets for free the ability to
avoid parallel execution of the same vCPUs in different privilege levels.
Compared to having a single file descriptor churn is more limited, or
at least can be attacked in small bites.  For example in this series
only per-plane interrupt controllers are switched to use the new struct
kvm_plane in place of struct kvm, and that's more or less enough in
the absence of complex interrupt delivery scenarios.

Changes to the userspace API are also relatively small; they boil down
to the introduction of a single new kind of file descriptor and almost
entirely fit in common code.  Reviewing these VM-wide and architecture-
independent changes should be the main purpose of this RFC, since 
there are still some things to fix:

- I named some fields "plane" instead of "plane_id" because I expected no
  fields of type struct kvm_plane*, but in retrospect that wasn't a great
  idea.

- online_vcpus counts across all planes but x86 code is still using it to
  deal with TSC synchronization.  Probably I will try and make kvmclock
  synchronization per-plane instead of per-VM.

- we're going to need a struct kvm_vcpu_plane similar to what Roy had in
  https://lore.kernel.org/kvm/cover.1726506534.git.roy.hopkins@suse.com/
  (probably smaller though).  Requests are per-plane for example, and I'm
  pretty sure any simplistic solution would have some corner cases where
  it's wrong; but it's a high churn change and I wanted to avoid that
  for this first posting.

There's a handful of locking TODOs where things should be checked more
carefully, but clearly identifying vCPU data that is not per-plane will
also simplify locking, thanks to having a single vcpu->mutex for the
whole plane.  So I'm not particularly worried about that; the TDX saga
hopefully has taught everyone to move in baby steps towards the intended
direction.

The handling of interrupt priorities is way more complicated than I
anticipated, unfortunately; everything else seems to fall into place
decently well---even taking into account the above incompleteness,
which anyway should not be a blocker for any VTL or VMPL experiments.
But do shout if anything makes you feel like I was too lazy, and/or you
want to puke.

Patches 1-2 are documentation and uAPI definitions.

Patches 3-9 are the common code for VM planes, while patches 10-14
are the common code for vCPU file descriptors on non-default planes.

Patches 15-26 are the x86-specific code, which is organized as follows:

- 15-20: convert APIC code to place its data in the new struct
kvm_arch_plane instead of struct kvm_arch.

- 21-24: everything else except the new userspace exit, KVM_EXIT_PLANE_EVENT

- 25: KVM_EXIT_PLANE_EVENT, which is used when one plane interrupts another.

- 26: finally make the capability available to userspace

Patches 27-29 finally are the testcases.  More are possible and planned,
but these are enough to say that, despite the missing bits, what exits
is not _completely_ broken.  I also didn't want to write dozens of tests
before committing to a selftests API.

Available for now at https://git.kernel.org/pub/scm/virt/kvm/kvm.git
branch planes-20250401.  I plan to place it in kvm-coco-queue, for lack
of a better place, as soon as TDX is merged into kvm/next and I test it
with the usual battery of kvm-unit-tests and real world guests.

Thanks,

Paolo

Paolo Bonzini (29):
  Documentation: kvm: introduce "VM plane" concept
  KVM: API definitions for plane userspace exit
  KVM: add plane info to structs
  KVM: introduce struct kvm_arch_plane
  KVM: add plane support to KVM_SIGNAL_MSI
  KVM: move mem_attr_array to kvm_plane
  KVM: do not use online_vcpus to test vCPU validity
  KVM: move vcpu_array to struct kvm_plane
  KVM: implement plane file descriptors ioctl and creation
  KVM: share statistics for same vCPU id on different planes
  KVM: anticipate allocation of dirty ring
  KVM: share dirty ring for same vCPU id on different planes
  KVM: implement vCPU creation for extra planes
  KVM: pass plane to kvm_arch_vcpu_create
  KVM: x86: pass vcpu to kvm_pv_send_ipi()
  KVM: x86: split "if" in __kvm_set_or_clear_apicv_inhibit
  KVM: x86: block creating irqchip if planes are active
  KVM: x86: track APICv inhibits per plane
  KVM: x86: move APIC map to kvm_arch_plane
  KVM: x86: add planes support for interrupt delivery
  KVM: x86: add infrastructure to share FPU across planes
  KVM: x86: implement initial plane support
  KVM: x86: extract kvm_post_set_cpuid
  KVM: x86: initialize CPUID for non-default planes
  KVM: x86: handle interrupt priorities for planes
  KVM: x86: enable up to 16 planes
  selftests: kvm: introduce basic test for VM planes
  selftests: kvm: add plane infrastructure
  selftests: kvm: add x86-specific plane test

 Documentation/virt/kvm/api.rst                | 245 +++++++--
 Documentation/virt/kvm/locking.rst            |   3 +
 Documentation/virt/kvm/vcpu-requests.rst      |   7 +
 arch/arm64/include/asm/kvm_host.h             |   5 +
 arch/arm64/kvm/arm.c                          |   4 +-
 arch/arm64/kvm/handle_exit.c                  |   6 +-
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c          |   4 +-
 arch/arm64/kvm/mmio.c                         |   4 +-
 arch/loongarch/include/asm/kvm_host.h         |   5 +
 arch/loongarch/kvm/exit.c                     |   8 +-
 arch/loongarch/kvm/vcpu.c                     |   4 +-
 arch/mips/include/asm/kvm_host.h              |   5 +
 arch/mips/kvm/emulate.c                       |   2 +-
 arch/mips/kvm/mips.c                          |  32 +-
 arch/mips/kvm/vz.c                            |  18 +-
 arch/powerpc/include/asm/kvm_host.h           |   5 +
 arch/powerpc/kvm/book3s.c                     |   2 +-
 arch/powerpc/kvm/book3s_hv.c                  |  46 +-
 arch/powerpc/kvm/book3s_hv_rm_xics.c          |   8 +-
 arch/powerpc/kvm/book3s_pr.c                  |  22 +-
 arch/powerpc/kvm/book3s_pr_papr.c             |   2 +-
 arch/powerpc/kvm/powerpc.c                    |   6 +-
 arch/powerpc/kvm/timing.h                     |  28 +-
 arch/riscv/include/asm/kvm_host.h             |   5 +
 arch/riscv/kvm/vcpu.c                         |   4 +-
 arch/riscv/kvm/vcpu_exit.c                    |  10 +-
 arch/riscv/kvm/vcpu_insn.c                    |  16 +-
 arch/riscv/kvm/vcpu_sbi.c                     |   2 +-
 arch/riscv/kvm/vcpu_sbi_hsm.c                 |   2 +-
 arch/s390/include/asm/kvm_host.h              |   5 +
 arch/s390/kvm/diag.c                          |  18 +-
 arch/s390/kvm/intercept.c                     |  20 +-
 arch/s390/kvm/interrupt.c                     |  48 +-
 arch/s390/kvm/kvm-s390.c                      |  10 +-
 arch/s390/kvm/priv.c                          |  60 +--
 arch/s390/kvm/sigp.c                          |  50 +-
 arch/s390/kvm/vsie.c                          |   2 +-
 arch/x86/include/asm/kvm_host.h               |  46 +-
 arch/x86/kvm/cpuid.c                          |  57 +-
 arch/x86/kvm/cpuid.h                          |   2 +
 arch/x86/kvm/debugfs.c                        |   2 +-
 arch/x86/kvm/hyperv.c                         |   7 +-
 arch/x86/kvm/i8254.c                          |   7 +-
 arch/x86/kvm/ioapic.c                         |   4 +-
 arch/x86/kvm/irq_comm.c                       |  14 +-
 arch/x86/kvm/kvm_cache_regs.h                 |   4 +-
 arch/x86/kvm/lapic.c                          | 147 +++--
 arch/x86/kvm/mmu/mmu.c                        |  41 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-
 arch/x86/kvm/svm/sev.c                        |   4 +-
 arch/x86/kvm/svm/svm.c                        |  21 +-
 arch/x86/kvm/vmx/tdx.c                        |   8 +-
 arch/x86/kvm/vmx/vmx.c                        |  20 +-
 arch/x86/kvm/x86.c                            | 319 ++++++++---
 arch/x86/kvm/xen.c                            |   1 +
 include/linux/kvm_host.h                      | 130 +++--
 include/linux/kvm_types.h                     |   1 +
 include/uapi/linux/kvm.h                      |  28 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../testing/selftests/kvm/include/kvm_util.h  |  48 ++
 .../selftests/kvm/include/x86/processor.h     |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  65 ++-
 .../testing/selftests/kvm/lib/x86/processor.c |  15 +
 tools/testing/selftests/kvm/plane_test.c      | 103 ++++
 tools/testing/selftests/kvm/x86/plane_test.c  | 270 ++++++++++
 virt/kvm/dirty_ring.c                         |   5 +-
 virt/kvm/guest_memfd.c                        |   3 +-
 virt/kvm/irqchip.c                            |   5 +-
 virt/kvm/kvm_main.c                           | 500 ++++++++++++++----
 69 files changed, 1991 insertions(+), 614 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/plane_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/plane_test.c

-- 
2.49.0



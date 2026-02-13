Return-Path: <kvm+bounces-71065-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oD4XKJNPj2nnPgEAu9opvQ
	(envelope-from <kvm+bounces-71065-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 17:21:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 008DC137E87
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 17:21:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3C94F305129A
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96E4258EE0;
	Fri, 13 Feb 2026 16:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D8GJ4KZ+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQgHxU3g"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A4222126D
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 16:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770999670; cv=none; b=sGZfKk/uwQgBb5mp+d2/ePnSs1ShrdF7swBYBiHq0Av3YYn5fRv/b7IZbVq1khYwoN5b9vYHuJQMSIRhz8JZtBoeeCiHXLSK9IRhalZ6KHw9InChUWl0DhREMUTG1geF+aPCMdMifZLYRgZdQYRBOQEvSXiIansqewGyEmH4T5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770999670; c=relaxed/simple;
	bh=hsfuQAp3ORLt8N+dskzBqyI7p4/ZlzzPiahkOFY1dl0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Xn/a5XpFQs63Kde+sG65WXLIIMeKcC1qv2p1wwQMZbjOT+cu+zNrXexmma2/hH1/8IATPm7dhxWo+BZUV1d8ByRo0ENt9LnhTJOJCrhn/FxzoFb+xbhJ5QHBN2DFj6aKeLQnLeazxmE76CaRM1WemZLjhEB011RU4xXiAbiCU2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D8GJ4KZ+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HQgHxU3g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770999667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CLSaisnoY9cPlNvrcPioYQFDWJGR9BaUtTAHkjOWjn4=;
	b=D8GJ4KZ+8qfvXQf0INhtp5KJ74b4ZF6XUgCqgBSjGR4lSqGAlXqxtVNeXpHiTpjBKk32sE
	7z1rUCdaskuUqNQc565tS2ECwa0sCCQQb00rXfze5zQ41djyMta4VmXYPv0HAMW9qZAu8U
	5HoeNwwMLzerAjQfuWG1zIpqg3W8y8s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-nIR9llNoOp2cPQeODk98Eg-1; Fri, 13 Feb 2026 11:21:04 -0500
X-MC-Unique: nIR9llNoOp2cPQeODk98Eg-1
X-Mimecast-MFC-AGG-ID: nIR9llNoOp2cPQeODk98Eg_1770999664
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43768e2aa4dso1066795f8f.0
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 08:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770999663; x=1771604463; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CLSaisnoY9cPlNvrcPioYQFDWJGR9BaUtTAHkjOWjn4=;
        b=HQgHxU3gtuv8GQoK3VyPD7lJeSCXEVIS8FR6QF3NRgGBt2WcI548QFilPKYjc9gHcp
         hUKsA/tRmokrVp/stELNUw9SA6m4x8D0fIt7SunHo3XOnUsq1hdmlTuWTjJZ1ELLZ3K1
         uFcSCoA4683zE9cgbyTXscNNQw2Pf7xYb28HL6TeGTvBTrxdIY7PFG2AIscFrM8UDoWA
         3ev3iu0QXF7sWB9evQKm2Ej1DSV1oix2va0ejaCpwVEroFuB+cfcpaeHs387ToIdGf0x
         NiwJT3kurXNrDCkwFtkR34HpjxKxpZVVBieACSC1ykSrofzibTuOGUu1x08nhbfKqwmg
         M+vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770999663; x=1771604463;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CLSaisnoY9cPlNvrcPioYQFDWJGR9BaUtTAHkjOWjn4=;
        b=Vzo30DBJk8QK3utzLL8MyQ5OKF8E9flUG+//q3ubiRdYeIswSL9VHBuo4qhdtl13G2
         gSYxPTCinDpvbssAwxkZzwYHqtoYmM8lCKFOYAOYoTlg9fpcD7c7FlxXL9sxCZOkxTHk
         TKmjj3UIiZG5EvMWkZnL+3imzZGvjPW9N0SvxYX3djLHzcWs0gG788eaYidR13z359rD
         LaR3bBAD3hzuOFFW9CJ9+H9IXCrFsbrMzja/NV3R3yXjTw4kpPVSpyY+Z9q1PzMsNlg4
         gFkLzNC8cVCpiIOzBLEK/Fz4jE/WWErNB2nvhIZaorZl/mCj1+1oQB8KCshEFjb9NIm0
         HO/g==
X-Forwarded-Encrypted: i=1; AJvYcCW6B6NGn/oO44RX/HiNMBMe28TiHaxtn773jZhjx4n6FnFiq66Z8TVuuybEnLbO0R6U0jk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfF4prQ1p2RWRLUOct+uVx6R/StNDh83XKoHsbuaXEMwUj4xjF
	OK3Eykxo4pDAqlcg6FZ4EIby2j14iGRyoitctv78Aj9+4pSjkQBqs8NTgdcQD9zj5J/LDfJgJzH
	RtSh9/YXErHbBSLmv+7ii8BuNp79w3IEejvxJ5Anr+jQoRK6avJOwxZDASeK5dA==
X-Gm-Gg: AZuq6aJtkFD9jRy7hotVhdn5Fa0uwrt+xA+N7c9J+fwaK5xIIaMTo4CQt/wtlixRk2o
	9TU6SdW/FHzhdVVzr1YjmbVic0eWjUCpWCsN8yT1VvwwUdb95teughGUu6YmnqHo75hFiFm+moW
	tZ/1k9FMfOATB5IlVETCIMFc3ivuDih/dUrBw5zZa1lNhLz9zoj6QXFBJVN1qDYzhTPqa8zIlVv
	C1ZyiwVOwy48/h/vmLrMyt7bhKig04pRTUQhysjUAjdHZy7/2vJ6qSJQ3N6Xe6ejE/rCEmxfedZ
	0n/LMGlb7xJDuMip3TZhlECCz237ben88c0leA+lEr8ZG278lMVhkXCYMhuFqzUNI/nWMKJRPkF
	kQQx4rQnRxRvgCzWIzNp1jkQ4IppFV3Q0e4gEXD6ewp9T6z4pwJNv8V96jkRNKVGjcWMheJOPTj
	qHSYVYJbeu3BKUulz1sMWfI8jyig==
X-Received: by 2002:a05:6000:230b:b0:435:fb84:1c87 with SMTP id ffacd0b85a97d-43797942c1emr4548914f8f.61.1770999662394;
        Fri, 13 Feb 2026 08:21:02 -0800 (PST)
X-Received: by 2002:a05:6000:230b:b0:435:fb84:1c87 with SMTP id ffacd0b85a97d-43797942c1emr4548816f8f.61.1770999661470;
        Fri, 13 Feb 2026 08:21:01 -0800 (PST)
Received: from [192.168.10.48] ([151.61.26.160])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796abd259sm6504938f8f.24.2026.02.13.08.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 08:21:00 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 7.0
Date: Fri, 13 Feb 2026 17:20:58 +0100
Message-ID: <20260213162059.22230-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-71065-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,hcr_el2.rw:url]
X-Rspamd-Queue-Id: 008DC137E87
X-Rspamd-Action: no action

Linus,

The following changes since commit 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b:

  Linux 6.19 (2026-02-08 13:03:27 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to b1195183ed42f1522fae3fe44ebee3af437aa000:

  Merge tag 'kvm-s390-next-7.0-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2026-02-11 18:52:27 +0100)

----------------------------------------------------------------
Loongarch:

- Add more CPUCFG mask bits.

- Improve feature detection.

- Add lazy load support for FPU and binary translation (LBT) register state.

- Fix return value for memory reads from and writes to in-kernel devices.

- Add support for detecting preemption from within a guest.

- Add KVM steal time test case to tools/selftests.

ARM:

- Add support for FEAT_IDST, allowing ID registers that are not
  implemented to be reported as a normal trap rather than as an UNDEF
  exception.

- Add sanitisation of the VTCR_EL2 register, fixing a number of
  UXN/PXN/XN bugs in the process.

- Full handling of RESx bits, instead of only RES0, and resulting in
  SCTLR_EL2 being added to the list of sanitised registers.

- More pKVM fixes for features that are not supposed to be exposed to
  guests.

- Make sure that MTE being disabled on the pKVM host doesn't give it
  the ability to attack the hypervisor.

- Allow pKVM's host stage-2 mappings to use the Force Write Back
  version of the memory attributes by using the "pass-through'
  encoding.

- Fix trapping of ICC_DIR_EL1 on GICv5 hosts emulating GICv3 for the
  guest.

- Preliminary work for guest GICv5 support.

- A bunch of debugfs fixes, removing pointless custom iterators stored
  in guest data structures.

- A small set of FPSIMD cleanups.

- Selftest fixes addressing the incorrect alignment of page
  allocation.

- Other assorted low-impact fixes and spelling fixes.

RISC-V:

- Fixes for issues discoverd by KVM API fuzzing in
  kvm_riscv_aia_imsic_has_attr(), kvm_riscv_aia_imsic_rw_attr(),
  and kvm_riscv_vcpu_aia_imsic_update()

- Allow Zalasr, Zilsd and Zclsd extensions for Guest/VM

- Transparent huge page support for hypervisor page tables

- Adjust the number of available guest irq files based on MMIO
  register sizes found in the device tree or the ACPI tables

- Add RISC-V specific paging modes to KVM selftests

- Detect paging mode at runtime for selftests

s390:

- Performance improvement for vSIE (aka nested virtualization)

- Completely new memory management.  s390 was a special snowflake that enlisted
  help from the architecture's page table management to build hypervisor
  page tables, in particular enabling sharing the last level of page
  tables.  This however was a lot of code (~3K lines) in order to support
  KVM, and also blocked several features.  The biggest advantages is
  that the page size of userspace is completely independent of the
  page size used by the guest: userspace can mix normal pages, THPs and
  hugetlbfs as it sees fit, and in fact transparent hugepages were not
  possible before.  It's also now possible to have nested guests and
  guests with huge pages running on the same host.

- Maintainership change for s390 vfio-pci

- Small quality of life improvement for protected guests

x86:

- Add support for giving the guest full ownership of PMU hardware (contexted
  switched around the fastpath run loop) and allowing direct access to data
  MSRs and PMCs (restricted by the vPMU model).  KVM still intercepts
  access to control registers, e.g. to enforce event filtering and to
  prevent the guest from profiling sensitive host state.  This is more
  accurate, since it has no risk of contention and thus dropped events, and
  also has significantly less overhead.

  For more information, see the commit message for merge commit bf2c3138ae36
  ("Merge tag 'kvm-x86-pmu-6.20' of https://github.com/kvm-x86/linux into HEAD").

- Disallow changing the virtual CPU model if L2 is active, for all the same
  reasons KVM disallows change the model after the first KVM_RUN.

- Fix a bug where KVM would incorrectly reject host accesses to PV MSRs
  when running with KVM_CAP_ENFORCE_PV_FEATURE_CPUID enabled, even if those
  were advertised as supported to userspace,

- Fix a bug with protected guest state (SEV-ES/SNP and TDX) VMs, where KVM
  would attempt to read CR3 configuring an async #PF entry.

- Fail the build if EXPORT_SYMBOL_GPL or EXPORT_SYMBOL is used in KVM (for x86
  only) to enforce usage of EXPORT_SYMBOL_FOR_KVM_INTERNAL.  Only a few exports
  that are intended for external usage, and those are allowed explicitly.

- When checking nested events after a vCPU is unblocked, ignore -EBUSY instead
  of WARNing.  Userspace can sometimes put the vCPU into what should be an
  impossible state, and spurious exit to userspace on -EBUSY does not really
  do anything to solve the issue.

- Also throw in the towel and drop the WARN on INIT/SIPI being blocked when vCPU
  is in Wait-For-SIPI, which also resulted in playing whack-a-mole with syzkaller
  stuffing architecturally impossible states into KVM.

- Add support for new Intel instructions that don't require anything beyond
  enumerating feature flags to userspace.

- Grab SRCU when reading PDPTRs in KVM_GET_SREGS2.

- Add WARNs to guard against modifying KVM's CPU caps outside of the intended
  setup flow, as nested VMX in particular is sensitive to unexpected changes
  in KVM's golden configuration.

- Add a quirk to allow userspace to opt-in to actually suppress EOI broadcasts
  when the suppression feature is enabled by the guest (currently limited to
  split IRQCHIP, i.e. userspace I/O APIC).  Sadly, simply fixing KVM to honor
  Suppress EOI Broadcasts isn't an option as some userspaces have come to rely
  on KVM's buggy behavior (KVM advertises Supress EOI Broadcast irrespective
  of whether or not userspace I/O APIC supports Directed EOIs).

- Clean up KVM's handling of marking mapped vCPU pages dirty.

- Drop a pile of *ancient* sanity checks hidden behind in KVM's unused
  ASSERT() macro, most of which could be trivially triggered by the guest
  and/or user, and all of which were useless.

- Fold "struct dest_map" into its sole user, "struct rtc_status", to make it
  more obvious what the weird parameter is used for, and to allow fropping
  these RTC shenanigans if CONFIG_KVM_IOAPIC=n.

- Bury all of ioapic.h, i8254.h and related ioctls (including
  KVM_CREATE_IRQCHIP) behind CONFIG_KVM_IOAPIC=y.

- Add a regression test for recent APICv update fixes.

- Handle "hardware APIC ISR", a.k.a. SVI, updates in kvm_apic_update_apicv()
  to consolidate the updates, and to co-locate SVI updates with the updates
  for KVM's own cache of ISR information.

- Drop a dead function declaration.

- Minor cleanups.

x86 (Intel):

- Rework KVM's handling of VMCS updates while L2 is active to temporarily
  switch to vmcs01 instead of deferring the update until the next nested
  VM-Exit.  The deferred updates approach directly contributed to several
  bugs, was proving to be a maintenance burden due to the difficulty in
  auditing the correctness of deferred updates, and was polluting
  "struct nested_vmx" with a growing pile of booleans.

- Fix an SGX bug where KVM would incorrectly try to handle EPCM page faults,
  and instead always reflect them into the guest.  Since KVM doesn't shadow
  EPCM entries, EPCM violations cannot be due to KVM interference and
  can't be resolved by KVM.

- Fix a bug where KVM would register its posted interrupt wakeup handler even
  if loading kvm-intel.ko ultimately failed.

- Disallow access to vmcb12 fields that aren't fully supported, mostly to
  avoid weirdness and complexity for FRED and other features, where KVM wants
  enable VMCS shadowing for fields that conditionally exist.

- Print out the "bad" offsets and values if kvm-intel.ko refuses to load (or
  refuses to online a CPU) due to a VMCS config mismatch.

x86 (AMD):

- Drop a user-triggerable WARN on nested_svm_load_cr3() failure.

- Add support for virtualizing ERAPS.  Note, correct virtualization of ERAPS
  relies on an upcoming, publicly announced change in the APM to reduce the
  set of conditions where hardware (i.e. KVM) *must* flush the RAP.

- Ignore nSVM intercepts for instructions that are not supported according to
  L1's virtual CPU model.

- Add support for expedited writes to the fast MMIO bus, a la VMX's fastpath
  for EPT Misconfig.

- Don't set GIF when clearing EFER.SVME, as GIF exists independently of SVM,
  and allow userspace to restore nested state with GIF=0.

- Treat exit_code as an unsigned 64-bit value through all of KVM.

- Add support for fetching SNP certificates from userspace.

- Fix a bug where KVM would use vmcb02 instead of vmcb01 when emulating VMLOAD
  or VMSAVE on behalf of L2.

- Misc fixes and cleanups.

x86 selftests:

- Add a regression test for TPR<=>CR8 synchronization and IRQ masking.

- Overhaul selftest's MMU infrastructure to genericize stage-2 MMU support,
  and extend x86's infrastructure to support EPT and NPT (for L2 guests).

- Extend several nested VMX tests to also cover nested SVM.

- Add a selftest for nested VMLOAD/VMSAVE.

- Rework the nested dirty log test, originally added as a regression test for
  PML where KVM logged L2 GPAs instead of L1 GPAs, to improve test coverage
  and to hopefully make the test easier to understand and maintain.

guest_memfd:

- Remove kvm_gmem_populate()'s preparation tracking and half-baked hugepage
  handling.  SEV/SNP was the only user of the tracking and it can do it via
  the RMP.

- Retroactively document and enforce (for SNP) that KVM_SEV_SNP_LAUNCH_UPDATE
  and KVM_TDX_INIT_MEM_REGION require the source page to be 4KiB aligned, to
  avoid non-trivial complexity for something that no known VMM seems to be
  doing and to avoid an API special case for in-place conversion, which
  simply can't support unaligned sources.

- When populating guest_memfd memory, GUP the source page in common code and
  pass the refcounted page to the vendor callback, instead of letting vendor
  code do the heavy lifting.  Doing so avoids a looming deadlock bug with
  in-place due an AB-BA conflict betwee mmap_lock and guest_memfd's filemap
  invalidate lock.

Generic:

- Fix a bug where KVM would ignore the vCPU's selected address space when
  creating a vCPU-specific mapping of guest memory.  Actually this bug
  could not be hit even on x86, the only architecture with multiple
  address spaces, but it's a bug nevertheless.

----------------------------------------------------------------
Amit Shah (1):
      KVM: SVM: Virtualize and advertise support for ERAPS

Arnd Bergmann (1):
      KVM: s390: Add explicit padding to struct kvm_s390_keyop

Ben Dooks (1):
      KVM: arm64: Fix missing <asm/stackpage/nvhe.h> include

Bibo Mao (13):
      LoongArch: KVM: Add more CPUCFG mask bits
      LoongArch: KVM: Move feature detection in kvm_vm_init_features()
      LoongArch: KVM: Add msgint registers in kvm_init_gcsr_flag()
      LoongArch: KVM: Check VM msgint feature during interrupt handling
      LoongArch: KVM: Handle LOONGARCH_CSR_IPR during vCPU context switch
      LoongArch: KVM: Move LSX capability check in exception handler
      LoongArch: KVM: Move LASX capability check in exception handler
      LoongArch: KVM: Move LBT capability check in exception handler
      LoongArch: KVM: Add FPU/LBT delay load support
      LoongArch: KVM: Set default return value in KVM IO bus ops
      LoongArch: KVM: Add paravirt preempt feature in hypervisor side
      LoongArch: KVM: Add paravirt vcpu_is_preempted() support in guest side
      KVM: LoongArch: selftests: Add steal time test case

Binbin Wu (1):
      KVM: VMX: Remove declaration of nested_mark_vmcs12_pages_dirty()

Claudio Imbrenda (32):
      KVM: s390: Refactor pgste lock and unlock functions
      KVM: s390: Add P bit in table entry bitfields, move union vaddress
      s390: Make UV folio operations work on whole folio
      s390: Move sske_frame() to a header
      KVM: s390: Add gmap_helper_set_unused()
      KVM: s390: Introduce import_lock
      KVM: s390: Export two functions
      s390/mm: Warn if uv_convert_from_secure_pte() fails
      KVM: s390: vsie: Pass gmap explicitly as parameter
      KVM: s390: Enable KVM_GENERIC_MMU_NOTIFIER
      KVM: s390: Rename some functions in gaccess.c
      KVM: s390: KVM-specific bitfields and helper functions
      KVM: s390: KVM page table management functions: allocation
      KVM: s390: KVM page table management functions: clear and replace
      KVM: s390: KVM page table management functions: walks
      KVM: s390: KVM page table management functions: storage keys
      KVM: s390: KVM page table management functions: lifecycle management
      KVM: s390: KVM page table management functions: CMMA
      KVM: s390: New gmap code
      KVM: s390: Add helper functions for fault handling
      KVM: s390: Add some helper functions needed for vSIE
      KVM: s390: Stop using CONFIG_PGSTE
      KVM: s390: Storage key functions refactoring
      KVM: s390: Switch to new gmap
      KVM: s390: Remove gmap from s390/mm
      KVM: S390: Remove PGSTE code from linux/s390 mm
      KVM: s390: Enable 1M pages for gmap
      KVM: s390: Storage key manipulation IOCTL
      KVM: s390: selftests: Add selftest for the KVM_S390_KEYOP ioctl
      KVM: s390: Use guest address to mark guest page dirty
      KVM: s390: vsie: Fix race in walk_guest_tables()
      KVM: s390: vsie: Fix race in acquire_gmap_shadow()

Dapeng Mi (11):
      KVM: x86/pmu: Start stubbing in mediated PMU support
      KVM: x86/pmu: Implement Intel mediated PMU requirements and constraints
      KVM: x86/pmu: Disable RDPMC interception for compatible mediated vPMU
      KVM: x86/pmu: Load/save GLOBAL_CTRL via entry/exit fields for mediated PMU
      KVM: x86/pmu: Disable interception of select PMU MSRs for mediated vPMUs
      KVM: x86/pmu: Bypass perf checks when emulating mediated PMU counter accesses
      KVM: x86/pmu: Reprogram mediated PMU event selectors on event filter updates
      KVM: x86/pmu: Load/put mediated PMU context when entering/exiting guest
      KVM: x86/pmu: Handle emulated instruction for mediated vPMU
      KVM: nVMX: Add macros to simplify nested MSR interception setting
      KVM: x86/pmu: Expose enable_mediated_pmu parameter to user space

Eric Farman (2):
      KVM: s390: vsie: retry SIE when unable to get vsie_page
      MAINTAINERS: Replace backup for s390 vfio-pci

Fred Griffoul (1):
      KVM: nVMX: Mark APIC access page dirty when syncing vmcs12 pages

Fuad Tabba (22):
      KVM: arm64: selftests: Disable unused TTBR1_EL1 translations
      KVM: arm64: selftests: Fix incorrect rounding in page_align()
      KVM: riscv: selftests: Fix incorrect rounding in page_align()
      KVM: selftests: Move page_align() to shared header
      KVM: selftests: Fix typos and stale comments in kvm_util
      KVM: arm64: Fix Trace Buffer trapping for protected VMs
      KVM: arm64: Fix Trace Buffer trap polarity for protected VMs
      KVM: arm64: Fix MTE flag initialization for protected VMs
      KVM: arm64: Introduce helper to calculate fault IPA offset
      KVM: arm64: Include VM type when checking VM capabilities in pKVM
      KVM: arm64: Do not allow KVM_CAP_ARM_MTE for any guest in pKVM
      KVM: arm64: Track KVM IOCTLs and their associated KVM caps
      KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
      KVM: arm64: Prevent host from managing timer offsets for protected VMs
      KVM: arm64: Remove dead code resetting HCR_EL2 for pKVM
      KVM: arm64: Trap MTE access and discovery when MTE is disabled
      KVM: arm64: Inject UNDEF when accessing MTE sysregs with MTE disabled
      KVM: arm64: Use kvm_has_mte() in pKVM trap initialization
      KVM: arm64: Use standard seq_file iterator for idregs debugfs
      KVM: arm64: Reimplement vgic-debug XArray iteration
      KVM: arm64: Use standard seq_file iterator for vgic-debug debugfs
      KVM: arm64: nv: Avoid NV stage-2 code when NV is not supported

Hou Wenlong (1):
      KVM: VMX: Don't register posted interrupt wakeup handler if alloc_kvm_area() fails

Jessica Liu (1):
      RISC-V: KVM: Transparent huge page support

Jiakai Xu (3):
      RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_has_attr()
      RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_rw_attr()
      RISC-V: KVM: Skip IMSIC update if vCPU IMSIC state is not initialized

Jim Mattson (2):
      KVM: SVM: Don't set GIF when clearing EFER.SVME
      KVM: SVM: Allow KVM_SET_NESTED_STATE to clear GIF when SVME==0

Jun Miao (1):
      KVM: x86: align the code with kvm_x86_call()

Kevin Cheng (1):
      KVM: SVM: Don't allow L1 intercepts for instructions not advertised

Khushit Shah (1):
      KVM: x86: Add x2APIC "features" to control EOI broadcast suppression

Kornel Dulęba (1):
      KVM: arm64: Fix error checking for FFA_VERSION

MJ Pooladkhay (1):
      KVM: selftests: Fix sign extension bug in get_desc64_base()

Maciej S. Szmigiero (1):
      KVM: selftests: Test TPR / CR8 sync and interrupt masking

Marc Zyngier (53):
      Merge branch kvmarm-fixes-6.19-1 into kvm-arm64/vtcr
      arm64: Convert ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2 to UnsignedEnum
      arm64: Convert VTCR_EL2 to sysreg infratructure
      KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co
      KVM: arm64: Convert VTCR_EL2 to config-driven sanitisation
      KVM: arm64: Honor UX/PX attributes for EL2 S1 mappings
      arm64: Repaint ID_AA64MMFR2_EL1.IDS description
      KVM: arm64: Add trap routing for GMID_EL1
      KVM: arm64: Add a generic synchronous exception injection primitive
      KVM: arm64: Handle FEAT_IDST for sysregs without specific handlers
      KVM: arm64: Handle CSSIDR2_EL1 and SMIDR_EL1 in a generic way
      KVM: arm64: Force trap of GMID_EL1 when the guest doesn't have MTE
      KVM: arm64: pkvm: Add a generic synchronous exception injection primitive
      KVM: arm64: pkvm: Report optional ID register traps with a 0x18 syndrome
      KVM: arm64: selftests: Add a test for FEAT_IDST
      KVM: arm64: Always populate FGT masks at boot time
      Merge branch arm64/for-next/cpufeature into kvmarm-master/next
      Merge branch kvm-arm64/vtcr into kvmarm-master/next
      Merge branch kvm-arm64/selftests-6.20 into kvmarm-master/next
      Merge branch kvm-arm64/feat_idst into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-features-6.20 into kvmarm-master/next
      arm64: Add MT_S2{,_FWB}_AS_S1 encodings
      KVM: arm64: Add KVM_PGTABLE_S2_AS_S1 flag
      KVM: arm64: Switch pKVM host S2 over to KVM_PGTABLE_S2_AS_S1
      KVM: arm64: Kill KVM_PGTABLE_S2_NOFWB
      KVM: arm64: Simplify PAGE_S2_MEMATTR
      arm64: Convert SCTLR_EL2 to sysreg infrastructure
      KVM: arm64: Remove duplicate configuration for SCTLR_EL1.{EE,E0E}
      KVM: arm64: Introduce standalone FGU computing primitive
      KVM: arm64: Introduce data structure tracking both RES0 and RES1 bits
      KVM: arm64: Extend unified RESx handling to runtime sanitisation
      KVM: arm64: Inherit RESx bits from FGT register descriptors
      KVM: arm64: Allow RES1 bits to be inferred from configuration
      KVM: arm64: Correctly handle SCTLR_EL1 RES1 bits for unsupported features
      KVM: arm64: Convert HCR_EL2.RW to AS_RES1
      KVM: arm64: Simplify FIXED_VALUE handling
      KVM: arm64: Add REQUIRES_E2H1 constraint as configuration flags
      KVM: arm64: Add RES1_WHEN_E2Hx constraints as configuration flags
      KVM: arm64: Move RESx into individual register descriptors
      KVM: arm64: Simplify handling of HCR_EL2.E2H RESx
      KVM: arm64: Get rid of FIXED_VALUE altogether
      KVM: arm64: Simplify handling of full register invalid constraint
      KVM: arm64: Remove all traces of FEAT_TME
      KVM: arm64: Remove all traces of HCR_EL2.MIOCNCE
      KVM: arm64: Add sanitisation to SCTLR_EL2
      KVM: arm64: Add debugfs file dumping computed RESx values
      Merge branch kvm-arm64/pkvm-no-mte into kvmarm-master/next
      Merge branch kvm-arm64/fwb-for-all into kvmarm-master/next
      Merge branch kvm-arm64/gicv3-tdir-fixes into kvmarm-master/next
      Merge branch kvm-arm64/gicv5-prologue into kvmarm-master/next
      Merge branch kvm-arm64/debugfs-fixes into kvmarm-master/next
      Merge branch kvm-arm64/resx into kvmarm-master/next
      Merge branch kvm-arm64/misc-6.20 into kvmarm-master/next

Mark Rutland (3):
      KVM: arm64: Fix comment in fpsimd_lazy_switch_to_host()
      KVM: arm64: Shuffle KVM_HOST_DATA_FLAG_* indices
      KVM: arm64: Remove ISB after writing FPEXC32_EL2

Michael Roth (7):
      KVM: guest_memfd: Remove partial hugepage handling from kvm_gmem_populate()
      KVM: guest_memfd: Remove preparation tracking
      KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
      KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
      KVM: guest_memfd: GUP source pages prior to populating guest memory
      KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
      KVM: SEV: Add KVM_SEV_SNP_ENABLE_REQ_CERTS command

Mingwei Zhang (2):
      KVM: x86/pmu: Introduce eventsel_hw to prepare for pmu event filtering
      KVM: nVMX: Disable PMU MSR interception as appropriate while running L2

Paolo Bonzini (11):
      Merge tag 'loongarch-kvm-6.20' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD
      Merge tag 'kvmarm-7.0' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-selftests-6.20' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.20' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.20' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.20' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-riscv-6.20-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvm-x86-gmem-6.20' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-apic-6.20' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-pmu-6.20' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-s390-next-7.0-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

Petteri Kangaslampi (1):
      KVM: arm64: Calculate hyp VA size only once

Pincheng Wang (2):
      riscv: KVM: allow Zilsd and Zclsd extensions for Guest/VM
      KVM: riscv: selftests: add Zilsd and Zclsd extension to get-reg-list test

Qiang Ma (1):
      RISC-V: KVM: Remove unnecessary 'ret' assignment

Sandipan Das (1):
      KVM: x86/pmu: Always stuff GuestOnly=1,HostOnly=0 for mediated PMCs on AMD

Sascha Bischoff (6):
      KVM: arm64: gic: Enable GICv3 CPUIF trapping on GICv5 hosts if required
      KVM: arm64: Correct test for ICH_HCR_EL2_TDIR cap for GICv5 hosts
      KVM: arm64: gic-v3: Switch vGIC-v3 to use generated ICH_VMCR_EL2
      arm64/sysreg: Drop ICH_HFGRTR_EL2.ICC_HAPR_EL1 and make RES1
      KVM: arm64: gic: Set vgic_model before initing private IRQs
      irqchip/gic-v5: Check if impl is virt capable

Sean Christopherson (69):
      KVM: x86: Disallow setting CPUID and/or feature MSRs if L2 is active
      KVM: VMX: Always reflect SGX EPCM #PFs back into the guest
      KVM: Add a simplified wrapper for registering perf callbacks
      KVM: x86/pmu: Implement AMD mediated PMU requirements
      KVM: x86/pmu: Disallow emulation in the fastpath if mediated PMCs are active
      KVM: nSVM: Disable PMU MSR interception as appropriate while running L2
      KVM: x86/pmu: Elide WRMSRs when loading guest PMCs if values already match
      KVM: VMX: Drop intermediate "guest" field from msr_autostore
      KVM: nVMX: Don't update msr_autostore count when saving TSC for vmcs12
      KVM: VMX: Dedup code for removing MSR from VMCS's auto-load list
      KVM: VMX: Drop unused @entry_only param from add_atomic_switch_msr()
      KVM: VMX: Bug the VM if either MSR auto-load list is full
      KVM: VMX: Set MSR index auto-load entry if and only if entry is "new"
      KVM: VMX: Compartmentalize adding MSRs to host vs. guest auto-load list
      KVM: VMX: Dedup code for adding MSR to VMCS's auto list
      KVM: VMX: Initialize vmcs01.VM_EXIT_MSR_STORE_ADDR with list address
      KVM: VMX: Add mediated PMU support for CPUs without "save perf global ctrl"
      KVM: Use vCPU specific memslots in __kvm_vcpu_map()
      KVM: x86: Mark vmcs12 pages as dirty if and only if they're mapped
      KVM: nVMX: Precisely mark vAPIC and PID maps dirty when delivering nested PI
      KVM: VMX: Move nested_mark_vmcs12_pages_dirty() to vmx.c, and rename
      KVM: x86: Return "unsupported" instead of "invalid" on access to unsupported PV MSR
      KVM: selftests: Add "struct kvm_mmu" to track a given MMU instance
      KVM: selftests: Plumb "struct kvm_mmu" into x86's MMU APIs
      KVM: selftests: Add a "struct kvm_mmu_arch arch" member to kvm_mmu
      KVM: selftests: Add a stage-2 MMU instance to kvm_vm
      KVM: selftests: Move TDP mapping functions outside of vmx.c
      KVM: selftests: Rename vm_get_page_table_entry() to vm_get_pte()
      KVM: nSVM: Remove a user-triggerable WARN on nested_svm_load_cr3() succeeding
      KVM: SVM: Rename "fault_address" to "gpa" in npf_interception()
      KVM: SVM: Add support for expedited writes to the fast MMIO bus
      KVM: x86: Enforce use of EXPORT_SYMBOL_FOR_KVM_INTERNAL
      KVM: x86: Drop ASSERT()s on APIC/vCPU being non-NULL
      KVM: x86: Drop guest/user-triggerable asserts on IRR/ISR vectors
      KVM: x86: Drop ASSERT() on I/O APIC EOIs being only for LEVEL_to WARN_ON_ONCE
      KVM: x86: Drop guest-triggerable ASSERT()s on I/O APIC access alignment
      KVM: x86: Drop MAX_NR_RESERVED_IOAPIC_PINS, use KVM_MAX_IRQ_ROUTES directly
      KVM: x86: Add a wrapper to handle common case of IRQ delivery without dest_map
      KVM: x86: Fold "struct dest_map" into "struct rtc_status"
      KVM: x86: Bury ioapic.h definitions behind CONFIG_KVM_IOAPIC
      KVM: x86: Hide KVM_IRQCHIP_KERNEL behind CONFIG_KVM_IOAPIC=y
      KVM: selftests: Add a test to verify APICv updates (while L2 is active)
      KVM: nVMX: Switch to vmcs01 to update PML controls on-demand if L2 is active
      KVM: nVMX: Switch to vmcs01 to update TPR threshold on-demand if L2 is active
      KVM: nVMX: Switch to vmcs01 to update SVI on-demand if L2 is active
      KVM: nVMX: Switch to vmcs01 to refresh APICv controls on-demand if L2 is active
      KVM: nVMX: Switch to vmcs01 to update APIC page on-demand if L2 is active
      KVM: nVMX: Switch to vmcs01 to set virtual APICv mode on-demand if L2 is active
      KVM: x86: Update APICv ISR (a.k.a. SVI) as part of kvm_apic_update_apicv()
      KVM: SVM: Drop the module param to control SEV-ES DebugSwap
      KVM: SVM: Tag sev_supported_vmsa_features as read-only after init
      KVM: x86: Ignore -EBUSY when checking nested events from vcpu_block()
      KVM: SVM: Add a helper to detect VMRUN failures
      KVM: SVM: Open code handling of unexpected exits in svm_invoke_exit_handler()
      KVM: SVM: Check for an unexpected VM-Exit after RETPOLINE "fast" handling
      KVM: SVM: Filter out 64-bit exit codes when invoking exit handlers on bare metal
      KVM: SVM: Treat exit_code as an unsigned 64-bit value through all of KVM
      KVM: SVM: Limit incorrect check on SVM_EXIT_ERR to running as a VM
      KVM: SVM: Harden exit_code against being used in Spectre-like attacks
      KVM: SVM: Assert that Hyper-V's HV_SVM_EXITCODE_ENL == SVM_EXIT_SW
      KVM: SVM: Fix an off-by-one typo in the comment for enabling AVIC by default
      KVM: nVMX: Setup VMX MSRs on loading CPU during nested_vmx_hardware_setup()
      KVM: VMX: Add a wrapper around ROL16() to get a vmcs12 from a field encoding
      KVM: selftests: Test READ=>WRITE dirty logging behavior for shadow MMU
      KVM: x86: Drop WARN on INIT/SIPI being blocked when vCPU is in Wait-For-SIPI
      KVM: nVMX: Disallow access to vmcs12 fields that aren't supported by "hardware"
      KVM: nVMX: Remove explicit filtering of GUEST_INTR_STATUS from shadow VMCS fields
      KVM: VMX: Print out "bad" offsets+value on VMCS config mismatch
      KVM: x86: Harden against unexpected adjustments to kvm_cpu_caps

Steffen Eiden (1):
      KVM: s390: Increase permitted SE header size to 1 MiB

Vasiliy Kovalev (1):
      KVM: x86: Add SRCU protection for reading PDPTRs in __get_sregs2()

Wu Fei (1):
      KVM: riscv: selftests: Add riscv vm satp modes

Xiaoyao Li (1):
      KVM: x86: Don't read guest CR3 when doing async pf while the MMU is direct

Xiong Zhang (1):
      KVM: x86/pmu: Register PMI handler for mediated vPMU

Xu Lu (3):
      RISC-V: KVM: Allow Zalasr extensions for Guest/VM
      RISC-V: KVM: selftests: Add Zalasr extensions to get-reg-list test
      irqchip/riscv-imsic: Adjust the number of available guest irq files

Yan Zhao (1):
      KVM: SVM: Fix a missing kunmap_local() in sev_gmem_post_populate()

Yosry Ahmed (21):
      KVM: selftests: Make __vm_get_page_table_entry() static
      KVM: selftests: Stop passing a memslot to nested_map_memslot()
      KVM: selftests: Rename nested TDP mapping functions
      KVM: selftests: Kill eptPageTablePointer
      KVM: selftests: Stop setting A/D bits when creating EPT PTEs
      KVM: selftests: Move PTE bitmasks to kvm_mmu
      KVM: selftests: Use a TDP MMU to share EPT page tables between vCPUs
      KVM: selftests: Stop passing VMX metadata to TDP mapping functions
      KVM: selftests: Reuse virt mapping functions for nested EPTs
      KVM: selftests: Allow kvm_cpu_has_ept() to be called on AMD CPUs
      KVM: selftests: Add support for nested NPTs
      KVM: selftests: Set the user bit on nested NPT PTEs
      KVM: selftests: Extend vmx_dirty_log_test to cover SVM
      KVM: selftests: Extend memstress to run on nested SVM
      KVM: selftests: Use TEST_ASSERT_EQ() in test_vmx_nested_state()
      KVM: selftests: Extend vmx_set_nested_state_test to cover SVM
      KVM: selftests: Slightly simplify memstress_setup_nested()
      KVM: nSVM: Drop redundant/wrong comment in nested_vmcb02_prepare_save()
      KVM: nSVM: Always use vmcb01 in VMLOAD/VMSAVE emulation
      KVM: SVM: Stop toggling virtual VMSAVE/VMLOAD on intercept recalc
      KVM: selftests: Add a selftests for nested VMLOAD/VMSAVE

Zenghui Yu (Huawei) (3):
      KVM: arm64: nv: Return correct RES0 bits for FGT registers
      KVM: arm64: nv: Add trap config for DBGWCR<15>_EL1
      KVM: arm64: Fix various comments

Zhao Liu (4):
      KVM: x86: Advertise MOVRS CPUID to userspace
      KVM: x86: Advertise AMX CPUIDs in subleaf 0x1E.0x1 to userspace
      KVM: x86: Advertise AVX10.2 CPUID to userspace
      KVM: x86: Advertise AVX10_VNNI_INT CPUID to userspace

 Documentation/admin-guide/kernel-parameters.txt    |   49 +
 Documentation/virt/kvm/api.rst                     |  114 +-
 .../virt/kvm/x86/amd-memory-encryption.rst         |   54 +-
 Documentation/virt/kvm/x86/intel-tdx.rst           |    2 +-
 MAINTAINERS                                        |    5 +-
 arch/arm64/include/asm/el2_setup.h                 |    1 -
 arch/arm64/include/asm/kvm_arm.h                   |   56 +-
 arch/arm64/include/asm/kvm_asm.h                   |    2 -
 arch/arm64/include/asm/kvm_emulate.h               |    1 +
 arch/arm64/include/asm/kvm_host.h                  |   58 +-
 arch/arm64/include/asm/kvm_mmu.h                   |    3 +-
 arch/arm64/include/asm/kvm_pgtable.h               |   19 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |   32 +-
 arch/arm64/include/asm/memory.h                    |   11 +-
 arch/arm64/include/asm/pgtable-prot.h              |    4 +-
 arch/arm64/include/asm/sysreg.h                    |   29 -
 arch/arm64/kernel/cpufeature.c                     |    8 +-
 arch/arm64/kernel/head.S                           |    2 +-
 arch/arm64/kernel/image-vars.h                     |    1 -
 arch/arm64/kvm/arch_timer.c                        |   18 +-
 arch/arm64/kvm/arm.c                               |   65 +-
 arch/arm64/kvm/config.c                            |  511 ++--
 arch/arm64/kvm/emulate-nested.c                    |  103 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |    6 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |    4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |    5 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   67 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |    4 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |   20 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   39 +-
 arch/arm64/kvm/hyp/pgtable.c                       |   58 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c           |    2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |   69 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |    2 +-
 arch/arm64/kvm/inject_fault.c                      |   12 +-
 arch/arm64/kvm/mmu.c                               |   32 +-
 arch/arm64/kvm/nested.c                            |  172 +-
 arch/arm64/kvm/sys_regs.c                          |  122 +-
 arch/arm64/kvm/sys_regs.h                          |   10 +
 arch/arm64/kvm/va_layout.c                         |   61 +-
 arch/arm64/kvm/vgic/vgic-debug.c                   |  108 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |    8 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c               |   10 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   73 +-
 arch/arm64/kvm/vgic/vgic-v5.c                      |    2 +
 arch/arm64/kvm/vgic/vgic.h                         |    1 +
 arch/arm64/tools/sysreg                            |  154 +-
 arch/loongarch/include/asm/kvm_host.h              |    9 +
 arch/loongarch/include/asm/kvm_para.h              |    4 +-
 arch/loongarch/include/asm/loongarch.h             |    1 +
 arch/loongarch/include/asm/qspinlock.h             |    4 +
 arch/loongarch/include/uapi/asm/kvm.h              |    1 +
 arch/loongarch/include/uapi/asm/kvm_para.h         |    1 +
 arch/loongarch/kernel/paravirt.c                   |   21 +-
 arch/loongarch/kvm/exit.c                          |   21 +-
 arch/loongarch/kvm/intc/eiointc.c                  |   43 +-
 arch/loongarch/kvm/intc/ipi.c                      |   26 +-
 arch/loongarch/kvm/intc/pch_pic.c                  |   31 +-
 arch/loongarch/kvm/interrupt.c                     |    4 +-
 arch/loongarch/kvm/main.c                          |   10 +-
 arch/loongarch/kvm/vcpu.c                          |  125 +-
 arch/loongarch/kvm/vm.c                            |   39 +-
 arch/riscv/include/uapi/asm/kvm.h                  |    3 +
 arch/riscv/kvm/aia.c                               |    2 +-
 arch/riscv/kvm/aia_imsic.c                         |   13 +-
 arch/riscv/kvm/main.c                              |    2 +-
 arch/riscv/kvm/mmu.c                               |  140 ++
 arch/riscv/kvm/vcpu_onereg.c                       |    4 +
 arch/riscv/kvm/vcpu_pmu.c                          |    5 +-
 arch/riscv/mm/pgtable.c                            |    2 +
 arch/s390/Kconfig                                  |    3 -
 arch/s390/include/asm/dat-bits.h                   |   32 +-
 arch/s390/include/asm/gmap.h                       |  174 --
 arch/s390/include/asm/gmap_helpers.h               |    1 +
 arch/s390/include/asm/hugetlb.h                    |    6 -
 arch/s390/include/asm/kvm_host.h                   |    7 +
 arch/s390/include/asm/mmu.h                        |   13 -
 arch/s390/include/asm/mmu_context.h                |    6 +-
 arch/s390/include/asm/page.h                       |    4 -
 arch/s390/include/asm/pgalloc.h                    |    4 -
 arch/s390/include/asm/pgtable.h                    |  171 +-
 arch/s390/include/asm/tlb.h                        |    3 -
 arch/s390/include/asm/uaccess.h                    |   70 +-
 arch/s390/include/asm/uv.h                         |    3 +-
 arch/s390/kernel/uv.c                              |  142 +-
 arch/s390/kvm/Kconfig                              |    2 +
 arch/s390/kvm/Makefile                             |    3 +-
 arch/s390/kvm/dat.c                                | 1391 +++++++++++
 arch/s390/kvm/dat.h                                |  970 ++++++++
 arch/s390/kvm/diag.c                               |    2 +-
 arch/s390/kvm/faultin.c                            |  148 ++
 arch/s390/kvm/faultin.h                            |   92 +
 arch/s390/kvm/gaccess.c                            |  973 ++++----
 arch/s390/kvm/gaccess.h                            |   20 +-
 arch/s390/kvm/gmap-vsie.c                          |  141 --
 arch/s390/kvm/gmap.c                               | 1244 ++++++++++
 arch/s390/kvm/gmap.h                               |  244 ++
 arch/s390/kvm/intercept.c                          |   15 +-
 arch/s390/kvm/interrupt.c                          |   12 +-
 arch/s390/kvm/kvm-s390.c                           |  966 +++-----
 arch/s390/kvm/kvm-s390.h                           |   27 +-
 arch/s390/kvm/priv.c                               |  213 +-
 arch/s390/kvm/pv.c                                 |  177 +-
 arch/s390/kvm/vsie.c                               |  202 +-
 arch/s390/lib/uaccess.c                            |  184 +-
 arch/s390/mm/Makefile                              |    1 -
 arch/s390/mm/fault.c                               |    4 +-
 arch/s390/mm/gmap.c                                | 2436 --------------------
 arch/s390/mm/gmap_helpers.c                        |   96 +-
 arch/s390/mm/hugetlbpage.c                         |   24 -
 arch/s390/mm/page-states.c                         |    1 +
 arch/s390/mm/pageattr.c                            |    7 -
 arch/s390/mm/pgalloc.c                             |   24 -
 arch/s390/mm/pgtable.c                             |  814 +------
 arch/x86/include/asm/cpufeatures.h                 |    2 +
 arch/x86/include/asm/kvm-x86-pmu-ops.h             |    4 +
 arch/x86/include/asm/kvm_host.h                    |   22 +
 arch/x86/include/asm/msr-index.h                   |    1 +
 arch/x86/include/asm/svm.h                         |    9 +-
 arch/x86/include/asm/vmx.h                         |    1 +
 arch/x86/include/uapi/asm/kvm.h                    |    8 +-
 arch/x86/include/uapi/asm/svm.h                    |   32 +-
 arch/x86/kvm/Makefile                              |   49 +
 arch/x86/kvm/cpuid.c                               |   84 +-
 arch/x86/kvm/cpuid.h                               |   12 +-
 arch/x86/kvm/hyperv.c                              |    2 +-
 arch/x86/kvm/ioapic.c                              |   45 +-
 arch/x86/kvm/ioapic.h                              |   38 +-
 arch/x86/kvm/irq.c                                 |    4 +-
 arch/x86/kvm/lapic.c                               |  174 +-
 arch/x86/kvm/lapic.h                               |   23 +-
 arch/x86/kvm/mmu/mmu.c                             |   11 +-
 arch/x86/kvm/pmu.c                                 |  271 ++-
 arch/x86/kvm/pmu.h                                 |   37 +-
 arch/x86/kvm/reverse_cpuid.h                       |   19 +
 arch/x86/kvm/svm/avic.c                            |    4 +-
 arch/x86/kvm/svm/hyperv.c                          |    7 +-
 arch/x86/kvm/svm/nested.c                          |  100 +-
 arch/x86/kvm/svm/pmu.c                             |   44 +
 arch/x86/kvm/svm/sev.c                             |  243 +-
 arch/x86/kvm/svm/svm.c                             |  170 +-
 arch/x86/kvm/svm/svm.h                             |   49 +-
 arch/x86/kvm/trace.h                               |    6 +-
 arch/x86/kvm/vmx/capabilities.h                    |    9 +-
 arch/x86/kvm/vmx/hyperv_evmcs.c                    |    2 +-
 arch/x86/kvm/vmx/hyperv_evmcs.h                    |    2 +-
 arch/x86/kvm/vmx/nested.c                          |  229 +-
 arch/x86/kvm/vmx/nested.h                          |    1 -
 arch/x86/kvm/vmx/pmu_intel.c                       |   92 +-
 arch/x86/kvm/vmx/pmu_intel.h                       |   15 +
 arch/x86/kvm/vmx/tdx.c                             |   16 +-
 arch/x86/kvm/vmx/vmcs.h                            |    9 +
 arch/x86/kvm/vmx/vmcs12.c                          |   74 +-
 arch/x86/kvm/vmx/vmcs12.h                          |    8 +-
 arch/x86/kvm/vmx/vmx.c                             |  409 +++-
 arch/x86/kvm/vmx/vmx.h                             |   18 +-
 arch/x86/kvm/x86.c                                 |  158 +-
 arch/x86/kvm/x86.h                                 |   16 +-
 arch/x86/kvm/xen.c                                 |    2 +-
 drivers/irqchip/irq-gic-v5-irs.c                   |    2 +
 drivers/irqchip/irq-gic-v5.c                       |   10 +
 drivers/irqchip/irq-riscv-imsic-state.c            |   12 +-
 include/hyperv/hvgdk.h                             |    2 +-
 include/kvm/arm_vgic.h                             |    4 -
 include/linux/irqchip/arm-gic-v5.h                 |    4 +
 include/linux/irqchip/riscv-imsic.h                |    3 +
 include/linux/kvm_host.h                           |   26 +-
 include/uapi/linux/kvm.h                           |   21 +
 mm/khugepaged.c                                    |    9 -
 tools/arch/arm64/include/asm/sysreg.h              |    6 -
 tools/perf/Documentation/perf-arm-spe.txt          |    1 -
 tools/testing/selftests/kvm/Makefile.kvm           |   10 +-
 tools/testing/selftests/kvm/arm64/idreg-idst.c     |  117 +
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |    1 -
 .../selftests/kvm/include/arm64/kvm_util_arch.h    |    2 +
 .../selftests/kvm/include/arm64/processor.h        |    4 +
 tools/testing/selftests/kvm/include/kvm_util.h     |   44 +-
 .../kvm/include/loongarch/kvm_util_arch.h          |    1 +
 .../selftests/kvm/include/riscv/kvm_util_arch.h    |    1 +
 .../selftests/kvm/include/riscv/processor.h        |    2 +
 .../selftests/kvm/include/s390/kvm_util_arch.h     |    1 +
 tools/testing/selftests/kvm/include/x86/apic.h     |    7 +
 .../selftests/kvm/include/x86/kvm_util_arch.h      |   22 +
 .../testing/selftests/kvm/include/x86/processor.h  |   65 +-
 tools/testing/selftests/kvm/include/x86/svm.h      |    3 +-
 tools/testing/selftests/kvm/include/x86/svm_util.h |    9 +
 tools/testing/selftests/kvm/include/x86/vmx.h      |   16 +-
 tools/testing/selftests/kvm/lib/arm64/processor.c  |   47 +-
 tools/testing/selftests/kvm/lib/guest_modes.c      |   41 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |   63 +-
 .../selftests/kvm/lib/loongarch/processor.c        |   28 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c  |  101 +-
 tools/testing/selftests/kvm/lib/s390/processor.c   |   16 +-
 tools/testing/selftests/kvm/lib/x86/memstress.c    |   65 +-
 tools/testing/selftests/kvm/lib/x86/processor.c    |  233 +-
 tools/testing/selftests/kvm/lib/x86/svm.c          |   27 +
 tools/testing/selftests/kvm/lib/x86/vmx.c          |  251 +-
 tools/testing/selftests/kvm/riscv/get-reg-list.c   |   12 +
 tools/testing/selftests/kvm/s390/keyop.c           |  299 +++
 tools/testing/selftests/kvm/steal_time.c           |   96 +
 tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c |    2 +-
 .../selftests/kvm/x86/nested_dirty_log_test.c      |  293 +++
 ...nested_state_test.c => nested_set_state_test.c} |  128 +-
 .../selftests/kvm/x86/nested_vmsave_vmload_test.c  |  197 ++
 .../kvm/x86/smaller_maxphyaddr_emulation_test.c    |    4 +-
 .../kvm/x86/svm_nested_soft_inject_test.c          |    4 +-
 .../selftests/kvm/x86/vmx_apicv_updates_test.c     |  155 ++
 .../testing/selftests/kvm/x86/vmx_dirty_log_test.c |  179 --
 .../selftests/kvm/x86/vmx_nested_la57_state_test.c |    2 +-
 tools/testing/selftests/kvm/x86/xapic_tpr_test.c   |  276 +++
 virt/kvm/guest_memfd.c                             |  141 +-
 virt/kvm/kvm_main.c                                |    7 +-
 212 files changed, 11541 insertions(+), 7834 deletions(-)
 delete mode 100644 arch/s390/include/asm/gmap.h
 create mode 100644 arch/s390/kvm/dat.c
 create mode 100644 arch/s390/kvm/dat.h
 create mode 100644 arch/s390/kvm/faultin.c
 create mode 100644 arch/s390/kvm/faultin.h
 delete mode 100644 arch/s390/kvm/gmap-vsie.c
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h
 delete mode 100644 arch/s390/mm/gmap.c
 create mode 100644 tools/testing/selftests/kvm/arm64/idreg-idst.c
 create mode 100644 tools/testing/selftests/kvm/s390/keyop.c
 create mode 100644 tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
 rename tools/testing/selftests/kvm/x86/{vmx_set_nested_state_test.c => nested_set_state_test.c} (70%)
 create mode 100644 tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c
 delete mode 100644 tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/xapic_tpr_test.c



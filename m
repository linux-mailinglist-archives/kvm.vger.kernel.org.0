Return-Path: <kvm+bounces-40838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 212D2A5E33B
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 18:58:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 359BF17A605
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 17:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C922256C62;
	Wed, 12 Mar 2025 17:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fryafOxH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B70D1D5176
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 17:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741802309; cv=none; b=nd9r1plsA8DW+zkVm79LLCaOz759eRuGB4L5fHT1w1D2aKTw2V8fwLMILkZbR/l5laZSwPJRJ+DTC62mEa006xszmoJbm4b5nMpo1FboUo9M66vMq0u27t/ExpcKx421lKky7gHOq324gnwOLbiY5vrmFPhW3vStfWdE987IeuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741802309; c=relaxed/simple;
	bh=6TBWjN9ZeClCAfaN9rn5ug3szeuRnJZuKdZ871e0shE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Qz70KZNSabFX80r65IB4aMHkoGvcQ5WvykGeg13bdoTpkeGcnIclT0CMa1II46eE0ETtHRGhacB7OicCUYPG26I/z+BV6P1gggSwxGwP9K7A5O9mfLU/WRWtATvctYXk06BV/RmjexiuC8gPDi41Bd0jtLJoZxATg4+zMts4KtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fryafOxH; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4394c747c72so625345e9.1
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 10:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741802306; x=1742407106; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T+kF5w3og5RX654YVuAmymqDU+eQn2jhpTLFEYKtVFM=;
        b=fryafOxHb3qOviHZAGUjMqaKoV1mE0EfHR9sMa5IwEDdpB6QtGFG9HvJk6fdk4UEjw
         0rtX/ZYRiPlMwjsa1dpnUFR/uFhgm6DQOxCYsWciHtXgVusCZR6zt5bsxpO4XTo04LOS
         kq3WBc9e/GKsaPYH6H+dommqzj8Um1KFRNBfnACTz/GWNS8LvLw6Pn/xgJ+TX7mnBzCP
         lw32XMTN937S2e4lczd+aM5hUVFEd0C7tVW99SnSAN8WaDm6ObAthzh3wH6542WrT2OP
         FmMPL3mYMf+VpIbxfGQC9Q4abebgSughjDHslivN03DZrJpm/QKHx5+UFhLveDbvfyET
         4ODw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741802306; x=1742407106;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T+kF5w3og5RX654YVuAmymqDU+eQn2jhpTLFEYKtVFM=;
        b=pyXx5F1VfuBMxImyiJ5SKmuKa3/u5KIEAsVu0fWvP7fBTqTBpDrFbkyk+W71S2G6PN
         Td77lBcbEy7BXtm17M2bK1VpNiYyy8yYn1qqD5yDn+vwqIynPpQERYNOQd91Hl0QG03g
         bngiOzfdi27UjxpQRQRPfnGBUeJOHco/xHzBjmJhZ0CDuo6mk9ZJlx9ZDIotKEllLYcT
         JtU6QbgbVkgJstdLcMuWukQ5fPQAhuY2IR0T3bOo+e+9gU8I+tlEF4hMu0c6LcxrHM5G
         IFARFl0Hr5dk4lCpvY2b2oCMCznKIaapJplhg4wVPwpjkNLG+Fvk6L/jZ7+R3nYlZZI5
         mVZg==
X-Gm-Message-State: AOJu0Yz7u5pjwTH2ekW4bJ+wb1aRlx/RWt7N5DrrKg7J8IuwRthIZBJ+
	vPeNSnxQIrbCiDxbEoqBuvM1R3dtv+7LL31QCdi72HGpqBdhwODDs6BivbiZhT53Lvpf3zs6Syl
	C8dwyVNm6Q9JXoQgBYm3aYxhd+DgJNVLL+YNuHoOKPuLDAPuN8hvI2qBcUi45LNRO09Usr9g9iB
	ZkfY0IGWmBwn+aK1s6t6qTYzY=
X-Google-Smtp-Source: AGHT+IGKQg3O4SCw85tnpOl0usGIncjUMzcuT/BH9Y2E5wJm1iFi5IZwbAkFv8L1tYWF+lXsTpj6WD6wJQ==
X-Received: from wmbgz9-n2.prod.google.com ([2002:a05:600c:8889:20b0:43c:fcbd:f2eb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3658:b0:43c:f1b8:16ad
 with SMTP id 5b1f17b1804b1-43d09ecf46dmr33038605e9.30.1741802305683; Wed, 12
 Mar 2025 10:58:25 -0700 (PDT)
Date: Wed, 12 Mar 2025 17:58:13 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250312175824.1809636-1-tabba@google.com>
Subject: [PATCH v6 00/10] KVM: Mapping guest_memfd backed memory at the host
 for software protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Main changes since v5 [1]:
- Added handling of folio_put() when KVM is configured as a module
- KVM_GMEM_SHARED_MEM is orthogonal to KVM_GENERIC_MEMORY_ATTRIBUTES
  (Ackerley)
- kvm_gmem_offset_is_shared() takes folio as parameter to check locking
  (Kirill)
- Refactoring and fixes from comments on previous version
- Rebased on Linux 6.14-rc6

The purpose of this series is to serve as a base for _restricted_
mmap() support for guest_memfd backed memory at the host [2]. It
allows experimentation with what that support would be like in
the safe environment of software and non-confidential VM types.

For more background and for how to test this series, please refer
to v2 [3]. Note that an updated version of kvmtool that works
with this series is available here [4].

I'm working on respinning the series that tracks folio sharing [5]. I'll
post that one soon.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250303171013.3548775-1-tabba@google.com/
[2] https://lore.kernel.org/all/20250117163001.2326672-1-tabba@google.com/
[3] https://lore.kernel.org/all/20250129172320.950523-1-tabba@google.com/
[4] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/guestmem-6.14
[5] https://lore.kernel.org/all/20250117163001.2326672-1-tabba@google.com/

Fuad Tabba (10):
  mm: Consolidate freeing of typed folios on final folio_put()
  KVM: guest_memfd: Handle final folio_put() of guest_memfd pages
  KVM: guest_memfd: Handle kvm_gmem_handle_folio_put() for KVM as a
    module
  KVM: guest_memfd: Allow host to map guest_memfd() pages
  KVM: guest_memfd: Handle in-place shared memory as guest_memfd backed
    memory
  KVM: x86: Mark KVM_X86_SW_PROTECTED_VM as supporting guest_memfd
    shared memory
  KVM: arm64: Refactor user_mem_abort() calculation of force_pte
  KVM: arm64: Handle guest_memfd()-backed guest page faults
  KVM: arm64: Enable mapping guest_memfd in arm64
  KVM: guest_memfd: selftests: guest_memfd mmap() test when mapping is
    allowed

 arch/arm64/include/asm/kvm_host.h             |  10 ++
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/mmu.c                          |  76 +++++++-----
 arch/x86/include/asm/kvm_host.h               |   5 +
 arch/x86/kvm/Kconfig                          |   3 +-
 include/linux/kvm_host.h                      |  23 +++-
 include/linux/page-flags.h                    |  31 +++++
 include/uapi/linux/kvm.h                      |   1 +
 mm/debug.c                                    |   1 +
 mm/swap.c                                     |  50 +++++++-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  |  75 +++++++++++-
 virt/kvm/Kconfig                              |   4 +
 virt/kvm/guest_memfd.c                        | 110 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |   9 +-
 15 files changed, 354 insertions(+), 46 deletions(-)


base-commit: 80e54e84911a923c40d7bee33a34c1b4be148d7a
-- 
2.49.0.rc0.332.g42c0ae87b1-goog



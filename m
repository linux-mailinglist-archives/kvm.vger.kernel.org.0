Return-Path: <kvm+bounces-38461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25261A3A435
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 18:26:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CE8C3A24B2
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 17:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81C826FD81;
	Tue, 18 Feb 2025 17:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bGwI2YX5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4933126FA61
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739899506; cv=none; b=SqvcFOa44D1wlC02m823JL2EXJLH2H7aG2I9WHFeukpEcNsRHvux6NlRW+TR0Q01S+jnMCN4HEPE5CEskglzvOkwt4fSECaGgAW6zngPUzBiuEOnWlFgR6mBep4EHI/zsm57rVHeYKuH8qtUbLCI1PuMbJmeUPHdCcl65T8EGMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739899506; c=relaxed/simple;
	bh=724LBeOw97SBCd0HqCvRngUXVsKZ1KahYxtHV0cw4w0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SRU+dYu5d3nILyItSMVqUssBQ0V1pVVSUqAfefSv1QoxUPktYhyWT+JIBXZSm+yIiEmFLbwpUCYd47bfXOS1gaAMCCZn7nqMg5YJA/MDWdVqQq6NH4eCGJeuRwUmkKdYE4c6hMEeDMoSdzWOP16iaa329qMj9dSTRDRsUibla+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bGwI2YX5; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43933b8d9b1so30506985e9.3
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739899503; x=1740504303; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7xgjd7p2cH7Jkx3lMPKKABpxo/3WsWOTo+AToLqEa/4=;
        b=bGwI2YX5Qar1HmZ6Wu4t1KeEhzrhkDk3wsl79jd7MU6ZQuEOuKGxNSShtS+5LqgtVG
         xnpZ5NUq0Yj7z3+lMOvtFgOVAT3wHv/yvfFJ91n9s7crmHQGWlY/tCcvrIhpFhR/uR3b
         SU/XLXZVOHDWeWzrOSSTISAQ2WqrVml3UhdAuMbyON7NmL/tbWY0fxgNwyICHvntYXdv
         qzk+WG6sB5P+UW+IU5JvXPa3FLEw1Dt+d1IfQaaWwQWvc3iFx8bPOpQSsAnykanHaR/D
         uk0CA7gCWOsnEIf2hK+OT4PyuQWCRs0MNIIyKYVbR72JC1l+pUY9S1qZ2NLTWQlqhb5m
         7FBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739899503; x=1740504303;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7xgjd7p2cH7Jkx3lMPKKABpxo/3WsWOTo+AToLqEa/4=;
        b=NNgCHDVa/+HSjEksDagic6dD6VVr4AReFJxe3Ege/X9GLCpC4cSKy6BaaZhQjKKXBz
         WMrNrYLnwMK6rY71Z+xBCZJVkFEMisyKYRgu7DHacHEwmAf139SbT/VzOuZOrMi22JLW
         gSATpXsjWQvT+HgjGUp1ttFl/XP1g3/qav5yyXyJ08mdy7ldue1JwUlFPqEy1jsOnWZt
         na2OBQHtVU5LJ0tCUsFqj+LMOp1DjBkm6eoGPo85275vdJMFvjkeQwfLhdSvxfl7/xg3
         Ovi5di4yp361iMBed6Ooc0QgpJMZ0NXW2/vQQaAj0GiV/XOPOmhKeuMyewPBTEuPc6mw
         KIkw==
X-Gm-Message-State: AOJu0Yz3AnC4fm+R9Z760Z6t6RlwoF/X/Y6NrTY4IW5LFBL3P+rwZ9OF
	UcrQYD67KFfAGSQTFGA5DF2O++xSgX6UOBJwxNeuJvoaW51Hg974B+r5ovlaeGvX/HlcUfAcupB
	6K9NhTDDM9BcUDbGd/w5ANaiAWhu6bM9f+Tt/uAaTOZ6T9wrl0P9L5Bet1bj0MB2oqredwM8FxT
	z56Xb+8c0bNk8mZYFKNtA4Tis=
X-Google-Smtp-Source: AGHT+IF4FwEANaZuFb7keZxJvx6HX2jKyjZf3e+2kOQ7nOgLoCxBtVbIZRgZLFZAieehz0UrBgr1vKr+gw==
X-Received: from wmbjg22.prod.google.com ([2002:a05:600c:a016:b0:439:624a:c297])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a0d:b0:439:4a2a:f318
 with SMTP id 5b1f17b1804b1-4396e750870mr119296885e9.28.1739899502697; Tue, 18
 Feb 2025 09:25:02 -0800 (PST)
Date: Tue, 18 Feb 2025 17:24:50 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250218172500.807733-1-tabba@google.com>
Subject: [PATCH v4 00/10] KVM: Mapping guest_memfd backed memory at the host
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
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Main changes since v3 [1]:
- Dropped the arm64 sw protected vm type. Instead,
non-confidential arm64 VM types support guest_memfd with sharing
in place when the configuration option is enabled. Future VM
types can restrict that.
- Expand the guest_memfd host fault error return values to cover
more cases.
- Fixes to faulting in guest_memfd pages in arm64.
- Rebased on Linux 6.14-rc3.

The purpose of this series is to serve as a base for _restricted_
mmap() support for guest_memfd backed memory at the host [2]. It
allows experimentation with what that support would be like in
the safe environment of software and non-confidential VM types.

For more background and for how to test this series, please refer
to v2 [3]. Note that an updated version of kvmtool that works
with this series is available here [4].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250211121128.703390-1-tabba@google.com/
[2] https://lore.kernel.org/all/20250117163001.2326672-1-tabba@google.com/
[3] https://lore.kernel.org/all/20250129172320.950523-1-tabba@google.com/
[4] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/guestmem-6.14

Fuad Tabba (10):
  mm: Consolidate freeing of typed folios on final folio_put()
  KVM: guest_memfd: Handle final folio_put() of guest_memfd pages
  KVM: guest_memfd: Allow host to map guest_memfd() pages
  KVM: guest_memfd: Add KVM capability to check if guest_memfd is shared
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
 arch/arm64/kvm/mmu.c                          |  83 ++++++++-----
 arch/x86/include/asm/kvm_host.h               |   5 +
 arch/x86/kvm/Kconfig                          |   3 +-
 include/linux/kvm_host.h                      |  23 +++-
 include/linux/page-flags.h                    |  32 +++++
 include/uapi/linux/kvm.h                      |   1 +
 mm/debug.c                                    |   1 +
 mm/swap.c                                     |  32 ++++-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  |  75 +++++++++++-
 virt/kvm/Kconfig                              |   5 +
 virt/kvm/guest_memfd.c                        | 110 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |   9 +-
 15 files changed, 345 insertions(+), 46 deletions(-)


base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
-- 
2.48.1.601.g30ceb7b040-goog



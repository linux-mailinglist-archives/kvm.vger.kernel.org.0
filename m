Return-Path: <kvm+bounces-37846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BE2AA30B63
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:13:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 215A2162626
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B65E21D00B;
	Tue, 11 Feb 2025 12:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n/95aNbI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4FC1FCFE3
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 12:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739275893; cv=none; b=Ipz8ed1dKUBwZKONBnOZD1Jbj+tAi6Acolru71g86rCVGFqGNfj0NRDpd020P8S/O/QTQ0TW/zUtuE5WRDY+kqzK0Bx/cLvYoRQovvlMZKcEXmscRtS7tO4gz8hedPwR4zUyDRfIz+y86X8N3wYoidKDxU6s8Pgh2nsw5bTe37U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739275893; c=relaxed/simple;
	bh=JSrXPPELBYFDg9Ee8WTaY4hT2UgxTA4pQ+IsVkSX0kM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Dc77psrqo//o5S1G06J0mHESmgdB32NHvrbjJ5JysfvL0TZcNSI/OaPiUuqIrt4XsyrFM73PFJcJeP1iw65ZRuA2c0+tILBze4WXtay6LzjN7lDf619odK8ldbgC0irJMbPm8S0daCPK0shm6eO3MfLp7rdyuHrW8eUFJCZdIL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n/95aNbI; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4394b8bd4e1so6865565e9.0
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 04:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739275890; x=1739880690; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mSGC99esy4K1gjCxU9uriveObd85avu291zHKaN+p7Y=;
        b=n/95aNbITiAqL+7wE3FDHrJtMfw3oZ87DVtxH4KWn7EoexPJmAY5eCJqAzsFUq6ZcC
         21aH6jiDG3jzSkV2sD4VUfxJR4DItDKvBIUVcVCBITkTE1FNGy9SBBYGOnj+Jnueo0c1
         J2aveKLeKvpMWO2czPzvfoxnLuPRdKhJrBZdm7z8sdqA+QpeJ6dLkVlj0kPtzjj4xyCi
         +SdgOzaklrHDiBR6KOUK96wKPZdWD311S0Mb9+iv/Y7K9XseJVMaRpco4vmXlYgWVe2l
         1TddZ9PZo97nCKDWJnUvMa0PB3kz3RIoGpQqey/AYer1UdwAOmftOoSvM3FTcNHma/K0
         EyIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739275890; x=1739880690;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mSGC99esy4K1gjCxU9uriveObd85avu291zHKaN+p7Y=;
        b=rXdCgr+76lMsLlHzVaUA6sAF7kk0WKLxezxY/1zqRoEPDi5ldJYLFEu0Ez/1T6QOO3
         U1aoSBTQlgAgaFmiGM9FGXhX2vysLDDwYhx4bGefZsPea1gx4FGRqmODJKThDTk4eukX
         SbnGspZL4i2Sj3oYLYj65SYC1H6PirQtuvY03ID7YnjPnPhtuHpVHwxMKl2QqfKHAR3U
         ChHjlXTJWzypmhIwPSW3HmgKjEJvzAXwOeFYnpRiyOeXjk9ZPzoDrcEh7pPVs6LtXjkI
         15CeD0JUBPXLN8zP8uprYk/a30bi4nKAW5FJ7k/tVHKbiBjfibgYZnNRaiFM0g1XQwhA
         O0Ag==
X-Gm-Message-State: AOJu0YxsUzTM+3yL21vKdsOWBLX+jzCnzgNVo6saAm0uuVq6+IqFvc/i
	4p2SPA/hBO1rESCFI43q8We5UkD9u/5hEcST5YaVb/wAEuMrDRkWKh0tDVg9XxvvXMdZQixYv5f
	pXA+uSyPV//7p+CxWX8w+t9WUIPIjZ52d0sUrbiElF/ZcQtd8fU6jmj62wU1nk4/ipJINKyogxn
	aquWRHLf6akNcCZ+d4Sglyahs=
X-Google-Smtp-Source: AGHT+IHGdelySS321A7XGIZkPN+94Y1egduUALJqfYnuOURIB5+SNjscxlIvh3DTSN8Ige7cFiCeTK5+5w==
X-Received: from wmbbe15.prod.google.com ([2002:a05:600c:1e8f:b0:439:4525:5eb8])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3d97:b0:439:34f0:cf86
 with SMTP id 5b1f17b1804b1-43934f0d067mr96833635e9.20.1739275890091; Tue, 11
 Feb 2025 04:11:30 -0800 (PST)
Date: Tue, 11 Feb 2025 12:11:16 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250211121128.703390-1-tabba@google.com>
Subject: [PATCH v3 00/11] KVM: Mapping guest_memfd backed memory at the host
 for software protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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

Changes since v2 [1]:
- Added more documentation
- Hook the folio_put callback as a stub with a warning
- Tidying up and refactoring
- Rebased on Linux 6.14-rc2

The purpose of this series is to serve as a base for _restricted_
mmap() support for guest_memfd backed memory at the host [2]. It
would allow experimentation with what that support would be like
in the safe environment of the software VM types, which are meant
for testing and experimentation.

For more background and how to test this series, please refer to v2 [1].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250129172320.950523-1-tabba@google.com/
[2] https://lore.kernel.org/all/20250117163001.2326672-1-tabba@google.com/

Fuad Tabba (11):
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
  KVM: arm64: Introduce KVM_VM_TYPE_ARM_SW_PROTECTED machine type
  KVM: arm64: Enable mapping guest_memfd in arm64
  KVM: guest_memfd: selftests: guest_memfd mmap() test when mapping is
    allowed

 Documentation/virt/kvm/api.rst                |   5 +
 arch/arm64/include/asm/kvm_host.h             |  10 ++
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/arm.c                          |   5 +
 arch/arm64/kvm/mmu.c                          |  91 ++++++++++------
 arch/x86/include/asm/kvm_host.h               |   5 +
 arch/x86/kvm/Kconfig                          |   3 +-
 include/linux/kvm_host.h                      |  28 ++++-
 include/linux/page-flags.h                    |  32 ++++++
 include/uapi/linux/kvm.h                      |   7 ++
 mm/debug.c                                    |   1 +
 mm/swap.c                                     |  32 +++++-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  |  75 +++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    |   3 +-
 virt/kvm/Kconfig                              |   4 +
 virt/kvm/guest_memfd.c                        | 100 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |   9 +-
 18 files changed, 360 insertions(+), 52 deletions(-)


base-commit: a64dcfb451e254085a7daee5fe51bf22959d52d3
-- 
2.48.1.502.g6dc24dfdaf-goog



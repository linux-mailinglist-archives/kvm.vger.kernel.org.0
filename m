Return-Path: <kvm+bounces-36256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 491A0A19524
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:27:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DC113ACA45
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AA862144CA;
	Wed, 22 Jan 2025 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QBhs5p1M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBCA156F53
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 15:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737559663; cv=none; b=FmtVzaYdb39kN4rvKQGumD/uEEmWcL3L//KwniaSHPUobkhG1f+noJmnFe5z6gx/+/c4jttBvy/m8yjRITYCgmLYHvhYKYrFn5hkYTHXfX6JMjvLrPTUHXz6GjFAcWH32fvTZXeNaFMSldN/F1CNyoUL5eYdTCXb4pIS1Vcyn7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737559663; c=relaxed/simple;
	bh=n8HZ959Pb33lc2cWkLJS11lyJ+Ico0KKCxsvD4x4J84=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qcDW7/hC6SrcF9HRnXI30Wdh706ydGfIzV85NoHZZXQILrvMBfhk0t7BhyhD3Gu6cyUrDugEyQX03VpiaPN20R/9s9qmsP6zzWAJVr9Do+/bHAY91Vp5LL2Y03Pn4mRExtvmnPcBMLgAsF8PJ7Qj7AWJLjdygx5kL3pGK/QepUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QBhs5p1M; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4362552ce62so36459995e9.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 07:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737559660; x=1738164460; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hUlZwtZNQ+0WbUZT+N6HTTUa81FjTajN+tozduRl9ck=;
        b=QBhs5p1MycZYmtrQQODxevKBsKfCY3MPEYTu8gVbNEWflhXCKUFCYA5DHgHstrJ5up
         R6Aqvg11AsrtfjQM1CCET5Tc1jtHEzAo0ayPXYKLxOvGFufUuxl1WxUXVjzzYuWw/vCm
         dPuVFS0RR3YtonMAlwQYQ1guhPKd0UB4RXPRpTCSVp4UQttAvypuWAHkcUehgdJ04BIv
         XYxvQ2CTvxTeelKrjpMim1Wc1WgFJpYDUCiJ/4MyfQwQ0k4LZsNqX60XkS3DBsHld7E9
         VQotSjLpldqWbKjPAIvlRZK+GrUGg3pgsxnlmO4MtAN1IIBIB3ElUNKB1+q5/sGyjBxV
         dQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737559660; x=1738164460;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hUlZwtZNQ+0WbUZT+N6HTTUa81FjTajN+tozduRl9ck=;
        b=bDe8hQGiQGcBQpmVoq8rxCJ8nd2kjJVn+g1PxNaDaenGs+X154L+Xh8UOuTtXxIy8K
         QtGFl6/mbVv8klIpH+oxT4b4IDkmgrKm5C8QsbV1rV9/5Etz/PN8iJolQH4njvG4uHq4
         t4THC2EV9i1faoHlkh6bNUHhGlLRbLoHoxpDgSFEDzlJ+I0x7oUyQqoF0X2X2+uNx60H
         S+FML5xhRGwfq7F0N5qpau0ayHLWXzYpeRYKUYu5WHiBHtDqKAfVqG5Yk4dSE5ybSkfc
         s0cpi1zjyRqoAkCetJnqHFCnqaTWl0yjBe2qHLM3P0ykMfRxgnQfSqtE/+leDX29uTdJ
         tbbA==
X-Gm-Message-State: AOJu0YwfhztKY0FbH74QJ+6g51Gspuf1SNaWRtDw7cvezIiddpP7i2mZ
	EFmI3kw8FY2Y0oTndwUkjuN4YzPO+ysl2GeAWJlrZ0G4QffNU5Kb54xwi3p4nyh79gFWXy3er5u
	CNUTVYzHmewZzAh7SrDdZIM5XQuFpZajXkbUX1TNAwlospiBlKn0B8g4oLkyfW/3fmtfmbtwYwr
	BxMuDYgAUEI7Zm2e4OiCw2dEw=
X-Google-Smtp-Source: AGHT+IGlxCTs9CCgxMjMw6rARxYZ9Zc0l91dOQzdNksXlO8dehmJjHKu3LgJYvypsZ2Om7YcLwpnK3FMEA==
X-Received: from wmqp4.prod.google.com ([2002:a05:600c:3584:b0:436:d819:e4eb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1da8:b0:434:a711:ace4
 with SMTP id 5b1f17b1804b1-4389eca3ca1mr207276765e9.17.1737559660568; Wed, 22
 Jan 2025 07:27:40 -0800 (PST)
Date: Wed, 22 Jan 2025 15:27:29 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250122152738.1173160-1-tabba@google.com>
Subject: [RFC PATCH v1 0/9] KVM: Mapping of guest_memfd at the host and a
 software protected VM type
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

The purpose of this series is to serve as a potential base for
restricted mmap() support for guest_memfd [1]. It would allow
experimentation with what that support would be like, in the safe
environment of a new VM type used for testing.

This series adds a new VM type for arm64,
KVM_VM_TYPE_ARM_SW_PROTECTED, analogous to the x86
KVM_X86_SW_PROTECTED_VM. This type is to serve as a development
and testing vehicle for Confidential (CoCo) VMs.

Similar to the x86 type, this is currently only for development
and testing. It's not meant to be used for "real" VMs, and
especially not in production. The behavior and effective ABI for
software-protected VMs is unstable.

This series enables mmap() support for guest_memfd specifically
for the new software-protected VM type, only when explicitly
enabled in the config.

The series is based on Linux 6.13-rc7 and much of the code within
is a subset of the latest series I sent [1], with the addition of
the new software protected vm type.

To test this series, there's a kvmtool branch with support for
guest_memfd for arm64 and the new runtime options of
--guest_memfd and --sw_protected, which marks the VM as software
protected [2]. I plan on upstreaming this kvmtool branch after
more testing and tidying up.

Please let me know if this series is useful as a stand-alone
series, or if I should merge it with the other guest_memfd for
future respins [1].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250117163001.2326672-1-tabba@google.com/
[2] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/guestmem-6.13

Fuad Tabba (9):
  KVM: guest_memfd: Allow host to mmap guest_memfd() pages
  KVM: guest_memfd: Add guest_memfd support to
    kvm_(read|/write)_guest_page()
  KVM: guest_memfd: Add KVM capability to check if guest_memfd is host
    mappable
  KVM: arm64: Skip VMA checks for slots without userspace address
  KVM: arm64: Refactor user_mem_abort() calculation of force_pte
  KVM: arm64: Handle guest_memfd()-backed guest page faults
  KVM: arm64: Introduce KVM_VM_TYPE_ARM_SW_PROTECTED machine type
  KVM: guest_memfd: selftests: guest_memfd mmap() test when mapping is
    allowed
  KVM: arm64: Enable mapping guest_memfd in arm64

 Documentation/virt/kvm/api.rst                |   5 +
 arch/arm64/include/asm/kvm_host.h             |  10 ++
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/arm.c                          |   5 +
 arch/arm64/kvm/mmu.c                          | 101 ++++++++++----
 arch/x86/include/asm/kvm_host.h               |   2 +
 include/linux/kvm_host.h                      |  16 +++
 include/uapi/linux/kvm.h                      |   7 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  |  60 ++++++++-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   3 +-
 virt/kvm/Kconfig                              |   4 +
 virt/kvm/guest_memfd.c                        |  71 ++++++++++
 virt/kvm/kvm_main.c                           | 127 ++++++++++++++----
 14 files changed, 353 insertions(+), 60 deletions(-)


base-commit: 5bc55a333a2f7316b58edc7573e8e893f7acb532
-- 
2.48.0.rc2.279.g1de40edade-goog



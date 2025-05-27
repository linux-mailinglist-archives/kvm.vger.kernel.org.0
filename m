Return-Path: <kvm+bounces-47805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61534AC59B9
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 20:02:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D02143BFB5D
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 944AA280008;
	Tue, 27 May 2025 18:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NcxlA0oF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD9E7263B
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 18:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368970; cv=none; b=Qfe/B2R2PT4+A6PefobLzgs1wWcyTT7RDqsccdEezKw9fntnalJybCUVL1+fp5yi0HJ/1OqRQinRbtetlS9YqAQzndy3iskGRrVDAywWQn4UlWW1E7TYfZ5uGOFZ4u7xJvll+6bIo1KLt54y0vpZh8gR6NLCOxEVFUn6joh5TuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368970; c=relaxed/simple;
	bh=Sm1I0qjv0WFmWLqz/GOx3PymTDQtXKqLTWNdnqZj7FY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qP6GCiAC3azLb43UZh54jqY5lOW0xRGSfkVYT3Spt/Uh8g3wX5SEdPo8rPHG7aCGnzsRr6VriVO1B6mmzMDCNX6Gt0/1RJeL2bkx4iuk0vVsEwwU+4N1k/SqXyLUG1j21YCRQHqB93B8SEJqVW10hPqEdnhy63tJfmFSkKBMKOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NcxlA0oF; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a36bbfbd96so1331930f8f.0
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748368967; x=1748973767; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yeWOp4WhMkR/uhA6IMasO9HAB3EQxbOq+nJdYJuMOOs=;
        b=NcxlA0oFKu88QG2TzHI7uixHSf2XUckCd0yTBn99rbRw2V2P4eHUHdZWq9x2PB3fTI
         72V/OWs5Ll9juqs8IOWixSnVinR1BQusSYqV4q3SvqDFTFrmoBn96t5jJJyiSFyDvmvt
         e08qjFR7fUB+wDmMLb44GmYowvh8RpgNQejupsDpf0kmTu2anjnkhj+2vRPMIf8JP2yY
         ptpYLRcRj2lDmCAE05fRBHch0r2NBoaRcyWrBCeT82q7SwZp9yB1dcxUU37xeO9PI0jU
         KeHJxeSv/kFs88fukR0w0Gfc+jVLuRcJ1qKJLzrrNVcKA8y9Lz2oqxqkq4XwCFRl+KIO
         W/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748368967; x=1748973767;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yeWOp4WhMkR/uhA6IMasO9HAB3EQxbOq+nJdYJuMOOs=;
        b=Ip9YqcHbFMOZ9U0oNgBfzmYUlPjHyTEBYkLC6YnnR8s5XJPUWsn6f1Z6dLfovVnOjr
         OfHdrPfT5MmSJ10oNymLRBwNJ9hsIa45SRERFX2XGY2tcZtZsnLbZL2VUTzqCePT3vE8
         vo0PH3ame4KZtifrfT2zgbShGIZot7NXd2VDAg918lmRQDAjocCbJjlbDgMSvFWgNf0d
         7PXN5CMYW/QEcDwRoAqgWIZnV8h+qxNhTBzS85HD7dYbQ5kOXPJ7PiN1HSnPPeIXdNJq
         ig5eOyVxqoWplWjkJxebh+V1NCoZrALGsDt5DK8ESst4of2GjkOG7cI79av+OIz5/iRx
         0GAw==
X-Gm-Message-State: AOJu0YwkurAJsdbM18yKCuXrnw3MmC5JdfnQ5loB9IoCylxv0m1CfoCp
	kHLEkwh9SfeSxtBS4dzbPWWLyu4qD5y8fgLaMk+h5HXhaijp2sPNhH/x8SaRGm0aPSP9oFzaO5R
	92uwwcY/asQsXsAZVnOnyhCsnZ/PhWM6C8l2veiBUpb8Lq+iP8pug3mMf/jL5oEMN6MwJFguUn+
	/2HRlrC+0Clrxn2Chpfp5UH/qyqjE=
X-Google-Smtp-Source: AGHT+IH6MWlL+bi1wtMWhfaRgnBm7DwkYwaoCXiVuDNzIw1XammwVFhl/9HSAal93pEVTgO63FzRgg6Hlw==
X-Received: from wmbdr21.prod.google.com ([2002:a05:600c:6095:b0:440:595d:fba9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:584f:0:b0:3a4:d6aa:1277
 with SMTP id ffacd0b85a97d-3a4d6aa16f5mr8033685f8f.37.1748368966828; Tue, 27
 May 2025 11:02:46 -0700 (PDT)
Date: Tue, 27 May 2025 19:02:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1164.gab81da1b16-goog
Message-ID: <20250527180245.1413463-1-tabba@google.com>
Subject: [PATCH v10 00/16] KVM: Mapping guest_memfd backed memory at the host
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Main changes since v9 [1]:
- Dropped best-effort validation that the userspace memory address range
  matches the shared memory backed by guest_memfd
- Rework handling faults for shared guest_memfd memory in arm64
- Track in the memslot whether it's backed by guest_memfd with shared
  memory support
- Various fixes based on feedback from v9
- Rebase on Linux 6.15

The purpose of this series is to allow mapping guest_memfd backed memory
at the host. This support enables VMMs like Firecracker to run guests
backed completely by guest_memfd [2]. Combined with Patrick's series for
direct map removal in guest_memfd [3], this would allow running VMs that
offer additional hardening against Spectre-like transient execution
attacks.

This series will also serve as a base for _restricted_ mmap() support
for guest_memfd backed memory at the host for CoCos that allow sharing
guest memory in-place with the host [4].

Patches 1 to 7 are mainly about decoupling the concept of guest memory
being private vs guest memory being backed by guest_memfd. They are
mostly refactoring and renaming.

Patches 8 and 9 add support for in-place shared memory, as well as the
ability to map it by the host as long as it is shared, gated by a new
configuration option, toggled by a new flag, and advertised to userspace
by a new capability (introduced in patch 15).

Patches 10 to 14 add x86 and arm64 support for in-place shared memory.

Patch 15 introduces the capability that advertises support for in-place
shared memory, and updates the documentation.

Patch 16 adds selftests for the new features.

For details on how to test this patch series, and on how to boot a guest
has uses the new features, please refer to v8 [5].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250513163438.3942405-1-tabba@google.com/
[2] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[3] https://lore.kernel.org/all/20250221160728.1584559-1-roypat@amazon.co.uk/
[4] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com/
[5] https://lore.kernel.org/all/20250430165655.605595-1-tabba@google.com/

Ackerley Tng (2):
  KVM: x86/mmu: Handle guest page faults for guest_memfd with shared
    memory
  KVM: x86: Compute max_mapping_level with input from guest_memfd

Fuad Tabba (14):
  KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
  KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
    CONFIG_KVM_GENERIC_GMEM_POPULATE
  KVM: Rename kvm_arch_has_private_mem() to kvm_arch_supports_gmem()
  KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
  KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
  KVM: Fix comments that refer to slots_lock
  KVM: Fix comment that refers to kvm uapi header path
  KVM: guest_memfd: Allow host to map guest_memfd pages
  KVM: guest_memfd: Track shared memory support in memslot
  KVM: arm64: Refactor user_mem_abort() calculation of force_pte
  KVM: arm64: Handle guest_memfd-backed guest page faults
  KVM: arm64: Enable mapping guest_memfd in arm64
  KVM: Introduce the KVM capability KVM_CAP_GMEM_SHARED_MEM
  KVM: selftests: guest_memfd mmap() test when mapping is allowed

 Documentation/virt/kvm/api.rst                |   9 +
 arch/arm64/include/asm/kvm_host.h             |   5 +
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/mmu.c                          | 109 ++++++++++--
 arch/x86/include/asm/kvm_host.h               |  22 ++-
 arch/x86/kvm/Kconfig                          |   4 +-
 arch/x86/kvm/mmu/mmu.c                        | 135 +++++++++------
 arch/x86/kvm/svm/sev.c                        |   4 +-
 arch/x86/kvm/svm/svm.c                        |   4 +-
 arch/x86/kvm/x86.c                            |   4 +-
 include/linux/kvm_host.h                      |  80 +++++++--
 include/uapi/linux/kvm.h                      |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 162 +++++++++++++++---
 virt/kvm/Kconfig                              |  15 +-
 virt/kvm/Makefile.kvm                         |   2 +-
 virt/kvm/guest_memfd.c                        | 101 ++++++++++-
 virt/kvm/kvm_main.c                           |  16 +-
 virt/kvm/kvm_mm.h                             |   4 +-
 19 files changed, 553 insertions(+), 127 deletions(-)


base-commit: 0ff41df1cb268fc69e703a08a57ee14ae967d0ca
-- 
2.49.0.1164.gab81da1b16-goog



Return-Path: <kvm+bounces-46120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C30DFAB27EF
	for <lists+kvm@lfdr.de>; Sun, 11 May 2025 13:22:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E23B170F1B
	for <lists+kvm@lfdr.de>; Sun, 11 May 2025 11:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 525861D7995;
	Sun, 11 May 2025 11:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IwCVRfs6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EE04315E
	for <kvm@vger.kernel.org>; Sun, 11 May 2025 11:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746962553; cv=none; b=fI0UHn8J5es62rHAEmzy5wXdoBZM8NWTXkfjjBMq15GqCla1kQYm8Z1rH9BEPjE2tIJxSqlSxF/WvZByxIxpcoVk2gZGwhw2A+/76nqMFnBYAP/FHK8px5BpzzXO7MclYKznyOid5An/H4IDIr1ABku3VRNLKPlVYa9vhTTDIYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746962553; c=relaxed/simple;
	bh=xMg4bh+bQA+IPFAhVKIA/zhq5G+/gV3IsMQRSnrn8ng=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KM0pJNt7UJuOXTeevpo1fA78GU5F2GlzofNmATug9kHNpGhxaQHTjXQ1AbbFqNMMv741imJZxjDXfJLK50/EFMcNZMbw6WhvcoRVf7zRd/tsnb+7+j7++hLmfup1QbWUD/KRMaD2nsZ0cTjqIAc5NVfr6LxnbEbzjwiODKcFi/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IwCVRfs6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746962550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/EODiwMTIGjE0ilIelFQY+bLRs3QQynzSkDS0Rn1VtM=;
	b=IwCVRfs6e+ycK7wCu5IDDa4tQV3S7MLZKZs0q34ChjRyJ3z9ap0ebruUS7zp1JR2sbK+30
	Cdch1UxKU4SW/EVeoGV98avvZnaVtJbBQKWM59J6CEE7ji5Cd6i++Cf1Cwd6XoK9CdNEEM
	1yNzNnwlMWvRDb0pYdRCdU06Qc96gWI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-yF2Ngt7fOAK_1booxGB0sw-1; Sun, 11 May 2025 07:22:28 -0400
X-MC-Unique: yF2Ngt7fOAK_1booxGB0sw-1
X-Mimecast-MFC-AGG-ID: yF2Ngt7fOAK_1booxGB0sw_1746962548
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ad240e3f501so70011566b.1
        for <kvm@vger.kernel.org>; Sun, 11 May 2025 04:22:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746962547; x=1747567347;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/EODiwMTIGjE0ilIelFQY+bLRs3QQynzSkDS0Rn1VtM=;
        b=OPnKohzbOJDO+9O0tdJghwuZdaRKleEzUYoFREaPzkhUwvkh4sXDeeNcDbKLBkMQy+
         mhflR0ia2Bev9KmNvYziYNp61fp8EiJB2XLvcDjxGOO6+8xIzAwhA8tFKhV2hWehz4Ev
         hcI0j2gxMzGxk57KRGWe/TQmoommVqV1oMbTBMX7Q6QQN6UPt1jl7A5t9AV2LQo+1hbd
         UpKvltNQhugnzj3DEkurjANOdj5edMlFT9j3FrjOvnJIu2bbs+eu5Y5LpeYKB2rO1yZA
         4c7zZ9XARFiYm2hCzfr/y/GjMi/NOiOR69OXATLXOFUnBpbqHaeuXiGgYeTyNFRehJtC
         4R0w==
X-Forwarded-Encrypted: i=1; AJvYcCXnZIIVY0e+ZChDysI2H3xUsdNDLk8cuqrZhYl1HacGo3aqMkdK6HppUMCzyGnflYlqk00=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl9MS28T+VTQQt/VpneXU3xUGkuKEKX2uBpbFD78BTlTehiEqp
	NomrnuWOjHWL0znch0Jvjt/Lo3uYcEnOZnOv0l7MydJoZYDqcCBPRrWxOdKB2VZklA8HD/Xr8fB
	e7BGqrY6NmmWCyttGwYqV3489Niataw3EL/4w0Bf1WDWss4Dp7Q==
X-Gm-Gg: ASbGnctwNScJc3YSy1gvN7j0tg3yP5/47c8arPtf8Xo/rFhN5jcx42JMKk9ayZu8B4b
	m3XEN6qMu74rYJ9GyLgAi+g4SFNKkMbOMEK8J178d4tSRE2XDMxX+ieBpXzyYo7QfTL6Z6TLbRr
	gPHdq92sxcQ4jbgIUhxY1m22pVrTBligLl+uWFU4Al0f4ezvMKeLhetVjCQCz90x7CjQT/D2ejO
	CMn0kkEyrUiW9PmuiVnv/+J7sW6QVyrNNgqd+D7/5FwSZHoxRDxkCa6SR+EQPxcwURNZklMXnfV
	GS3TviK1nSwZw2E=
X-Received: by 2002:a17:907:9444:b0:ad2:532e:abde with SMTP id a640c23a62f3a-ad2532eafffmr47907566b.1.1746962547494;
        Sun, 11 May 2025 04:22:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYeSjy1KdQYUnm++WAgswDRuwlIqOy1LMznzsEtnEw1htUbIqZluyhKPquF82ELDvFe7A6HQ==
X-Received: by 2002:a17:907:9444:b0:ad2:532e:abde with SMTP id a640c23a62f3a-ad2532eafffmr47904966b.1.1746962547048;
        Sun, 11 May 2025 04:22:27 -0700 (PDT)
Received: from [192.168.122.1] ([151.62.197.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad23da570desm232018466b.118.2025.05.11.04.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 May 2025 04:22:26 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.15-rc6
Date: Sun, 11 May 2025 13:22:23 +0200
Message-ID: <20250511112225.47328-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Linus,

The following changes since commit 92a09c47464d040866cf2b4cd052bc60555185fb:

  Linux 6.15-rc5 (2025-05-04 13:55:04 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to add20321af2f882ad18716a2fb7b2ce861963f76:

  Merge tag 'kvm-x86-fixes-6.15-rcN' of https://github.com/kvm-x86/linux into HEAD (2025-05-10 11:11:06 -0400)

----------------------------------------------------------------
ARM:

* Avoid use of uninitialized memcache pointer in user_mem_abort()

* Always set HCR_EL2.xMO bits when running in VHE, allowing interrupts
  to be taken while TGE=0 and fixing an ugly bug on AmpereOne that
  occurs when taking an interrupt while clearing the xMO bits
  (AC03_CPU_36)

* Prevent VMMs from hiding support for AArch64 at any EL virtualized by
  KVM

* Save/restore the host value for HCRX_EL2 instead of restoring an
  incorrect fixed value

* Make host_stage2_set_owner_locked() check that the entire requested
  range is memory rather than just the first page

RISC-V:

* Add missing reset of smstateen CSRs

x86:

* Forcibly leave SMM on SHUTDOWN interception on AMD CPUs to avoid causing
  problems due to KVM stuffing INIT on SHUTDOWN (KVM needs to sanitize the
  VMCB as its state is undefined after SHUTDOWN, emulating INIT is the
  least awful choice).

* Track the valid sync/dirty fields in kvm_run as a u64 to ensure KVM
  KVM doesn't goof a sanity check in the future.

* Free obsolete roots when (re)loading the MMU to fix a bug where
  pre-faulting memory can get stuck due to always encountering a stale
  root.

* When dumping GHCB state, use KVM's snapshot instead of the raw GHCB page
  to print state, so that KVM doesn't print stale/wrong information.

* When changing memory attributes (e.g. shared <=> private), add potential
  hugepage ranges to the mmu_invalidate_range_{start,end} set so that KVM
  doesn't create a shared/private hugepage when the the corresponding
  attributes will become mixed (the attributes are commited *after* KVM
  finishes the invalidation).

* Rework the SRSO mitigation to enable BP_SPEC_REDUCE only when KVM has at
  least one active VM.  Effectively BP_SPEC_REDUCE when KVM is loaded led
  to very measurable performance regressions for non-KVM workloads.

----------------------------------------------------------------
Dan Carpenter (1):
      KVM: x86: Check that the high 32bits are clear in kvm_arch_vcpu_ioctl_run()

Marc Zyngier (5):
      KVM: arm64: Force HCR_EL2.xMO to 1 at all times in VHE mode
      KVM: arm64: Prevent userspace from disabling AArch64 support at any virtualisable EL
      KVM: arm64: selftest: Don't try to disable AArch64 support
      KVM: arm64: Properly save/restore HCRX_EL2
      KVM: arm64: Kill HCRX_HOST_FLAGS

Mikhail Lobanov (1):
      KVM: SVM: Forcibly leave SMM mode on SHUTDOWN interception

Mostafa Saleh (1):
      KVM: arm64: Fix memory check in host_stage2_set_owner_locked()

Paolo Bonzini (3):
      Merge tag 'kvm-riscv-fixes-6.15-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvmarm-fixes-6.15-3' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-fixes-6.15-rcN' of https://github.com/kvm-x86/linux into HEAD

Radim Krčmář (1):
      KVM: RISC-V: reset smstateen CSRs

Sean Christopherson (2):
      KVM: x86/mmu: Prevent installing hugepages when mem attributes are changing
      KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1 VM count transitions

Sebastian Ott (1):
      KVM: arm64: Fix uninitialized memcache pointer in user_mem_abort()

Tom Lendacky (1):
      KVM: SVM: Update dump_ghcb() to use the GHCB snapshot fields

Yan Zhao (1):
      KVM: x86/mmu: Check and free obsolete roots in kvm_mmu_reload()

 arch/arm64/include/asm/el2_setup.h              |  2 +-
 arch/arm64/include/asm/kvm_arm.h                |  3 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h         | 13 ++--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c           |  2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                 | 36 +++++-----
 arch/arm64/kvm/mmu.c                            | 13 ++--
 arch/arm64/kvm/sys_regs.c                       |  6 ++
 arch/riscv/kvm/vcpu.c                           |  2 +
 arch/x86/kvm/mmu.h                              |  3 +
 arch/x86/kvm/mmu/mmu.c                          | 90 ++++++++++++++++++-------
 arch/x86/kvm/smm.c                              |  1 +
 arch/x86/kvm/svm/sev.c                          | 32 +++++----
 arch/x86/kvm/svm/svm.c                          | 75 +++++++++++++++++++--
 arch/x86/kvm/svm/svm.h                          |  2 +
 arch/x86/kvm/x86.c                              |  4 +-
 tools/testing/selftests/kvm/arm64/set_id_regs.c |  8 +--
 16 files changed, 210 insertions(+), 82 deletions(-)



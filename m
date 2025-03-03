Return-Path: <kvm+bounces-39901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D1BA4C962
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:28:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0B8C1892D6A
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:22:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4E022DF95;
	Mon,  3 Mar 2025 17:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kyqqExB8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742FE22CBED
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 17:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741021820; cv=none; b=DA0bnA2dQM0a1xy4Hh6vRFDEXNWAQPQQKHieq5ASmRGUQDGdIZB58ydSqFvs/SRQ3Z8dnND3u9CiZ5lowEgy8nGpfcjVQ3i6HEL1kWApVVBWFitd2DKilky1kkjO8qUWXbnBREzv8juvjUwgpNmonOO06b5DOKJTbQmxC6p00XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741021820; c=relaxed/simple;
	bh=1IoTnb/EA0BuX5qBEHCFmbuYRYlRErB/BLVTaNIcYjA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QEC9cd1AoY1wwQgKes88i2UaSh2mPvF7m0ugAftKK0xyCB3sT4W8cQyH1e6MlqdmyENfX8sNgm32N3VcnVadWyIP+WRVBS2MeL+X4A3FlmJQbwrJ0mEAcXWdcdUM0zITVkXVLujWnpc2eHYVLeRuK+ZQHRehcqYZNO0/f0THwLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kyqqExB8; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-390e27150dbso4422234f8f.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 09:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741021816; x=1741626616; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DOkmxQVDZmf5yeUI4pgYD3v63NeFP1axKGGtiw1qeSI=;
        b=kyqqExB88SlmXhOXJ9nYtOWI/dFdUwp4lsQmU5vLJ67dutluMh10ekvO1CM/uBYY1E
         IWDN3fR0t6AcuSrvFVizdtln9E+7E9XSgb0ALPDIr6N6sYXgQamYq+Sxk7n4ecXRafln
         G4mjs87KXXNpa89yeZZmT+axoNGQblwRaDWPtF6gSfGb3UWMiNlI+ktbTPf5R+695sFD
         xjrspfcxSo+Dy8yjNhJsMZrXUSinpP3FPWrUg827JBpcpQqTjySOIc6fMqANcJWvx59k
         5cWdB8/1bMse2JNzzWqt9jEVHCeSRWUxh3cFImMK9+m76A2AjOBJ7EnPsSxwQNMyPoar
         pyhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741021816; x=1741626616;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DOkmxQVDZmf5yeUI4pgYD3v63NeFP1axKGGtiw1qeSI=;
        b=dPui8+B2GiIsIWDqeC6yWO/IpVuDrtKmhAt0oXsnexXUE7wNBn3s2dizp/1EbHrnIk
         oWqhUqq5A/wrapAyCYXXr7MTaihKR8LydHGRrjenkJv6JqG84BvBSW+9BkqtYGwcWAcl
         8oodYY95nm1/K56C9Hy25tpMB0X03eDDb4UToi7cqHhWQAH5TkCAts28Kt4kVQk8aCjx
         7NMxMQdEUcAVXQVbMTOvY/b8tEgSSHJO9I4NhhXZFfAGLRpP0kbj/CM9bw3eVaTCU0rL
         V0aWyCRSriFPG30uI9gajxHGGWnjglEgWaaaBG/j98FUSUCsfn2qhhD7d/PVeFFdXRLB
         /CEw==
X-Gm-Message-State: AOJu0Yyh977vVuMzEnG7+PN29PL7T/xuxtXEQK70E1hZwqAdLdmbzkSq
	VoNWE5mTzFYVsI1szOMQ7adWujAJtDubLwCHXs2DipbSp8QaJypvYA4Z7f6P+VNDnW2Rp+1Y/Xg
	yCtVcCm2p40HAOZpxcABAyLvXzuexROfNvJHXyz8tirp7/jxivy5+X9T+Q3j9e9L6G3a9AyPxfd
	LEDFfIkpP6/vzCTrCZ3im2+oY=
X-Google-Smtp-Source: AGHT+IHlZbmRfE9yAqMi2uyKLmIqF5PJRQLGxvjj7yWMHBHhuKMjhOU/JFXUOXTZEuWFst+HfN614kZRvg==
X-Received: from wmbbh25.prod.google.com ([2002:a05:600c:3d19:b0:439:8e81:fd03])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2a2:b0:390:f9a5:bd79
 with SMTP id ffacd0b85a97d-390f9a5bf4amr8750587f8f.26.1741021815641; Mon, 03
 Mar 2025 09:10:15 -0800 (PST)
Date: Mon,  3 Mar 2025 17:10:04 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250303171013.3548775-1-tabba@google.com>
Subject: [PATCH v5 0/9] KVM: Mapping guest_memfd backed memory at the host for
 software protected VMs
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

Changes since v4 [1]:
- Refactoring and fixes from comments on v4.
- Rebased on Linux 6.14-rc5.

The purpose of this series is to serve as a base for _restricted_
mmap() support for guest_memfd backed memory at the host [2]. It
allows experimentation with what that support would be like in
the safe environment of software and non-confidential VM types.

For more background and for how to test this series, please refer
to v2 [3]. Note that an updated version of kvmtool that works
with this series is available here [4].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250218172500.807733-1-tabba@google.com/
[2] https://lore.kernel.org/all/20250117163001.2326672-1-tabba@google.com/
[3] https://lore.kernel.org/all/20250129172320.950523-1-tabba@google.com/
[4] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/guestmem-6.14

Fuad Tabba (9):
  mm: Consolidate freeing of typed folios on final folio_put()
  KVM: guest_memfd: Handle final folio_put() of guest_memfd pages
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
 arch/arm64/kvm/mmu.c                          |  76 ++++++++-----
 arch/x86/include/asm/kvm_host.h               |   5 +
 arch/x86/kvm/Kconfig                          |   3 +-
 include/linux/kvm_host.h                      |  26 ++++-
 include/linux/page-flags.h                    |  31 ++++++
 include/uapi/linux/kvm.h                      |   1 +
 mm/debug.c                                    |   1 +
 mm/swap.c                                     |  32 +++++-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  |  75 ++++++++++++-
 virt/kvm/Kconfig                              |   5 +
 virt/kvm/guest_memfd.c                        | 105 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |   9 +-
 15 files changed, 335 insertions(+), 46 deletions(-)


base-commit: 7eb172143d5508b4da468ed59ee857c6e5e01da6
-- 
2.48.1.711.g2feabab25a-goog



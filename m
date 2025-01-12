Return-Path: <kvm+bounces-35228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4240A0A8E1
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 13:02:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63DC2166C87
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 12:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03FA21B0F30;
	Sun, 12 Jan 2025 12:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RzF1lKPB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91144C9A
	for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 12:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736683342; cv=none; b=BpOtSamLH6IQp0InudAFJkLkWtHKqwBIHXVgWslmibymKC7BnIQF0G1y+TjCt4KwqHGUyEd6XJvR4raHMS4Mn4O8jj6tmat9C5naFMljFqMRj7YVrLeN+5U4ShSzOq9RRECtMVt0WzMQPqPW3tT4p1Qaivra8lam443RokE47Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736683342; c=relaxed/simple;
	bh=pe8+uRW2MsPJJR+cMHLPb4/Tp50FVUexA78hpV2jfXg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nMd72U8JM78YrXRaRLGCBGsu79Cr2S0AqAwFNzm1vh+RxfyK0qhGM9Ztz2amtCEuBoe/gnkQFW1ldmKk9uJkVkqpCJqH1cVeVttzDxw7bwoGAttt05+mGjVGV1GkeiE3M+3oNEaJ92bb/PBi+ASC6qxeloZwitiW4nmSnK6hDlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RzF1lKPB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736683338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OvlgjQkGD8RO2wkiLsRtHlqQCQpwARNsjKnf3XqGk6k=;
	b=RzF1lKPBo5bAWEdk7AT96rvPkR8PPppG0ICPUHdtt/9FRcOBYk9fsyrtc1kmFRi84013k/
	SR3SfStdD1Zc+bIIwp40MMu5qQN9cKSLt5ID1vbhQKkFJLC7TIIbBTO04Bjri23T70+k7V
	fahtybDZtDpxM6pqSItlOfpKQ7mHUhE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-8lbI5EGiMl24xc2FpvjPIw-1; Sun, 12 Jan 2025 07:02:17 -0500
X-MC-Unique: 8lbI5EGiMl24xc2FpvjPIw-1
X-Mimecast-MFC-AGG-ID: 8lbI5EGiMl24xc2FpvjPIw
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa66bc3b46dso261653066b.3
        for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 04:02:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736683335; x=1737288135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OvlgjQkGD8RO2wkiLsRtHlqQCQpwARNsjKnf3XqGk6k=;
        b=SBC6jvz8Cp+BXTOR45SPmr5hsRBC8XoYJ6oAvk3UsyvvOkcrnl9I4oQtffc2zOWiti
         +YiIEw/VH4ds4m9eSRzXhPsQvgEwLpBvAc5lO3fSanPgoTheZGi6mhJkstkkEsnxJigq
         A1rcYbVOo9TBvNDf8oy7Qo10Ex9rl8rSuzJ77+5BqWFrkLbw/IKaJiH+RLHm9+rDUQBO
         KZ6s5U3N0Oc9FwPd6mVCYU5yLn1LuOogW5Uimrw8/Z2EtuHCT8yFooBX9pnsey78NuP4
         g9VAs4dg2bd8ucIVMzKhwlZjVDuVvwjW0phHDq/5OSxBB0JWJMAX1KAm4cg5XT+au0dS
         wc5w==
X-Forwarded-Encrypted: i=1; AJvYcCVX3CLqANqSoeY71WJ6EqnrkT3mev6CZXOtZZWuGTja/aY7lTrCSVW52WvN4N+IWHDuKvU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8E8rWVhX4q3vV136GZADKC4wGWriBb2Z3tm8uhx9bN3eEFBqm
	UoTqID25NjfNNMBs7RDDPrXmXv4Sg3Zy0fdnaqSbb2i1cjYul9VxI6XOIpksxCSkXRL83gjMdcB
	xeaVQ1LU1uvaPRh0S8lL4VhqpIwMSAADf7DOT/tVQQrWlLzE24nY+C/xKMqi1
X-Gm-Gg: ASbGncuVaFSVwW7JoqA1MNxms7+cITxe4a7vETYXR/GzUiYCwz7DK5n2RqfBQTf4DnW
	vb07eyI+zRxZF5W+T/N0K2Jpwui8EkFozvxf3rCTskMq+9tfKs+jqdI2Aq5Fnub2mrC6qF11Xke
	gSK1zy15LIbAIk4xyz/KH5XroonoFOLdJO1nKgwjjBez1ruoZaGuMk1ucs1HpFJ2J8uE7AKk2gp
	TKxwkLfMY9HK4DpDniG+MSumcnIbNJnxC9JuP12xqgJkzPkQNxeW/PQfIE=
X-Received: by 2002:a05:6402:1eca:b0:5d6:688d:b683 with SMTP id 4fb4d7f45d1cf-5d972e0b18bmr38391437a12.9.1736683335011;
        Sun, 12 Jan 2025 04:02:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG4iw+C6RyEvPLlraXbotmvzO3Xf9zB4jeehu6nupahlXVWk16R1eRilYnECuJSc8hcT3RZGA==
X-Received: by 2002:a05:6402:1eca:b0:5d6:688d:b683 with SMTP id 4fb4d7f45d1cf-5d972e0b18bmr38391373a12.9.1736683334621;
        Sun, 12 Jan 2025 04:02:14 -0800 (PST)
Received: from [192.168.10.3] ([151.62.105.73])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c964924bsm370007266b.179.2025.01.12.04.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2025 04:02:14 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 6.13-rc7
Date: Sun, 12 Jan 2025 13:02:12 +0100
Message-ID: <20250112120212.440133-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linus,

The following changes since commit 9d89551994a430b50c4fffcb1e617a057fa76e20:

  Linux 6.13-rc6 (2025-01-05 14:13:40 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to a5546c2f0dc4f84727a4bb8a91633917929735f5:

  Merge tag 'kvm-s390-master-6.13-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2025-01-12 12:51:05 +0100)

The largest part here is for KVM/PPC, where a NULL pointer
dereference was introduced in the 6.13 merge window and is
now fixed.  There's some "holiday-induced lateness", as the
s390 submaintainer put it, but otherwise things looks fine.

----------------------------------------------------------------
s390:

* fix a latent bug when the kernel is compiled in debug mode

* two small UCONTROL fixes and their selftests

arm64:

* always check page state in hyp_ack_unshare()

* align set_id_regs selftest with the fact that ASIDBITS field is RO

* various vPMU fixes for bugs that only affect nested virt

PPC e500:

* Fix a mostly impossible (but just wrong) case where IRQs were
  never re-enabled

* Observe host permissions instead of mapping readonly host pages as
  guest-writable.  This fixes a NULL-pointer dereference in 6.13

* Replace brittle VMA-based attempts at building huge shadow TLB entries
  with PTE lookups.

----------------------------------------------------------------
Christoph Schlameuss (5):
      KVM: s390: Reject setting flic pfault attributes on ucontrol VMs
      KVM: s390: selftests: Add ucontrol flic attr selftests
      KVM: s390: Reject KVM_SET_GSI_ROUTING on ucontrol VMs
      KVM: s390: selftests: Add ucontrol gis routing test
      KVM: s390: selftests: Add has device attr check to uc_attr_mem_limit selftest

Claudio Imbrenda (1):
      KVM: s390: vsie: fix virtual/physical address in unpin_scb()

Mark Brown (1):
      KVM: arm64: Fix set_id_regs selftest for ASIDBITS becoming unwritable

Oliver Upton (4):
      KVM: arm64: Add unified helper for reprogramming counters by mask
      KVM: arm64: Use KVM_REQ_RELOAD_PMU to handle PMCR_EL0.E change
      KVM: arm64: nv: Reload PMU events upon MDCR_EL2.HPME change
      KVM: arm64: Only apply PMCR_EL0.P to the guest range of counters

Paolo Bonzini (8):
      KVM: e500: always restore irqs
      KVM: e500: use shadow TLB entry as witness for writability
      KVM: e500: track host-writability of pages
      KVM: e500: map readonly host pages for read
      KVM: e500: perform hugepage check after looking up the PFN
      Merge branch 'kvm-e500-check-writable-pfn' into HEAD
      Merge tag 'kvmarm-fixes-6.13-3' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-s390-master-6.13-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

Quentin Perret (1):
      KVM: arm64: Always check the state from hyp_ack_unshare()

 Documentation/virt/kvm/api.rst                    |   3 +
 Documentation/virt/kvm/devices/s390_flic.rst      |   4 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c             |   3 -
 arch/arm64/kvm/pmu-emul.c                         |  91 ++++------
 arch/arm64/kvm/sys_regs.c                         |  32 +++-
 arch/powerpc/kvm/e500.h                           |   2 +
 arch/powerpc/kvm/e500_mmu_host.c                  | 199 +++++++++-------------
 arch/s390/kvm/interrupt.c                         |   6 +
 arch/s390/kvm/vsie.c                              |   2 +-
 include/kvm/arm_pmu.h                             |   6 +-
 tools/testing/selftests/kvm/aarch64/set_id_regs.c |   1 -
 tools/testing/selftests/kvm/s390x/ucontrol_test.c | 172 ++++++++++++++++++-
 12 files changed, 333 insertions(+), 188 deletions(-)



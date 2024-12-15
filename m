Return-Path: <kvm+bounces-33827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B0219F22A5
	for <lists+kvm@lfdr.de>; Sun, 15 Dec 2024 09:43:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A46901885DCD
	for <lists+kvm@lfdr.de>; Sun, 15 Dec 2024 08:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79F113BAC6;
	Sun, 15 Dec 2024 08:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W+KD4AtY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A66C13AA3F
	for <kvm@vger.kernel.org>; Sun, 15 Dec 2024 08:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734252228; cv=none; b=Hc0BvLQXpjRWlteCAlBJL4LbaBdcV/gviHPM57mMjzcf0oQCzrbZsUdIoSNIhyZM1DdMbFPbtAZLFPcexPuuDhgD1BeJq9ixGn9ywA/fbe68/ze8tArrGRWjWG6PoHX0Q5WuzMld+XtooK2Mg/E/kX92lnQVyv6Npwxyrdqagn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734252228; c=relaxed/simple;
	bh=EjBvzeibEUJbBXQWIN5pQJ8KCUkfTes+hyKAGtN6VS4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dr9TIlvK5U8e0lGTWp+SZRpXTiFHIxNVem073vn2/ffqQ+FewrND0SOJoMYV+2HoMTr4jaHn0Hoe2BWd4VnZ85q+dPsu1J9l2JuHlqZRKwDLhhTr5yAfOIJSSWnCz1ENiumOfWOAzBqPG31mjdNBFGOzNDkvEGNK70SHf+HjFy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W+KD4AtY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734252224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NHSkf91Gzqfu89F4IjlCBqVWZEt45j1DUKW4GlMiyxY=;
	b=W+KD4AtY84FZ39hgFIatURjbxe8+YWHp6mn0PxCkRmhbZYx+phiZYLRBLlG8BMjV2RmNB2
	YhwzBJ1XIwv/uaQpsUzKkAA3KSfjmDq7ryr25wTm7I3/RFu186fEV56vAeZhMiI2g1cY1E
	pIIhimdYszCmqXyEjxmHTTQH9e/1+fU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-101-kwJDJYmPPk6dVo0D4rrDIw-1; Sun,
 15 Dec 2024 03:43:42 -0500
X-MC-Unique: kwJDJYmPPk6dVo0D4rrDIw-1
X-Mimecast-MFC-AGG-ID: kwJDJYmPPk6dVo0D4rrDIw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67C3719560A3;
	Sun, 15 Dec 2024 08:43:41 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C28AC1955F40;
	Sun, 15 Dec 2024 08:43:40 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.13-rc3
Date: Sun, 15 Dec 2024 03:43:39 -0500
Message-ID: <20241215084339.319122-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Linus,

The following changes since commit fac04efc5c793dccbd07e2d59af9f90b7fc0dca4:

  Linux 6.13-rc2 (2024-12-08 14:03:39 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 3522c419758ee8dca5a0e8753ee0070a22157bc1:

  Merge tag 'kvm-riscv-fixes-6.13-1' of https://github.com/kvm-riscv/linux into HEAD (2024-12-13 13:59:20 -0500)

----------------------------------------------------------------
ARM64:

* Fix confusion with implicitly-shifted MDCR_EL2 masks breaking
  SPE/TRBE initialization.

* Align nested page table walker with the intended memory attribute
  combining rules of the architecture.

* Prevent userspace from constraining the advertised ASID width,
  avoiding horrors of guest TLBIs not matching the intended context in
  hardware.

* Don't leak references on LPIs when insertion into the translation
  cache fails.

RISC-V:

* Replace csr_write() with csr_set() for HVIEN PMU overflow bit.

x86:

* Cache CPUID.0xD XSTATE offsets+sizes during module init - On Intel's
  Emerald Rapids CPUID costs hundreds of cycles and there are a lot of
  leaves under 0xD.  Getting rid of the CPUIDs during nested VM-Enter and
  VM-Exit is planned for the next release, for now just cache them: even
  on Skylake that is 40% faster.

----------------------------------------------------------------
James Clark (1):
      arm64: Fix usage of new shifted MDCR_EL2 values

Keisuke Nishimura (1):
      KVM: arm64: vgic-its: Add error handling in vgic_its_cache_translation

Marc Zyngier (2):
      KVM: arm64: Fix S1/S2 combination when FWB==1 and S2 has Device memory type
      KVM: arm64: Do not allow ID_AA64MMFR0_EL1.ASIDbits to be overridden

Michael Neuling (1):
      RISC-V: KVM: Fix csr_write -> csr_set for HVIEN PMU overflow bit

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-6.13-2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-riscv-fixes-6.13-1' of https://github.com/kvm-riscv/linux into HEAD

Sean Christopherson (1):
      KVM: x86: Cache CPUID.0xD XSTATE offsets+sizes during module init

 arch/arm64/include/asm/el2_setup.h |  4 ++--
 arch/arm64/kernel/hyp-stub.S       |  4 ++--
 arch/arm64/kvm/at.c                | 11 +++++++++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  4 ++--
 arch/arm64/kvm/sys_regs.c          |  3 ++-
 arch/arm64/kvm/vgic/vgic-its.c     | 12 +++++++++++-
 arch/riscv/kvm/aia.c               |  2 +-
 arch/x86/kvm/cpuid.c               | 31 ++++++++++++++++++++++++++-----
 arch/x86/kvm/cpuid.h               |  1 +
 arch/x86/kvm/x86.c                 |  2 ++
 10 files changed, 58 insertions(+), 16 deletions(-)



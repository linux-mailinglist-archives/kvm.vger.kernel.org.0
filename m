Return-Path: <kvm+bounces-24194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CEDEF952214
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 20:34:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37BC21F23A44
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 18:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCFAC1BBBDA;
	Wed, 14 Aug 2024 18:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M7zDYGsp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990D8B679
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 18:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723660437; cv=none; b=qF2kRBba8h/Wr1s/aJUp+u4RJ8o6wiJXggFTbiJ0QcG/ptGxrVvDO56TrLewO5hatOSTTcXL/B8urdM7Rr+jJvwdYOc47bdQF4SZv1LCD0havHuulhLS2QOwk2Wf/Q2lG+xHmp4/tczJFv6GWVmPzdD9+sPayMdSpagHfy24Png=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723660437; c=relaxed/simple;
	bh=5Ce1/H9Ux655K9UiP++aF7o997PoE3Y0IQkw/iyPbAA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M+oa6z38SntxyroY1gkhcwHgq7/jM4vVhi011lL+1oEQ5tfzpalKl48GZteaMITdK1ihekw4A20VFqspCpnSP75h4hlSMCjwC+6UkkWZZj1T6Zte7kTVCmiJp1CXUbp8iZ2dqkY1pnrhIRAB+1H9tRZpYAmlnNbVbFUMyUnKIEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M7zDYGsp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723660433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VcmqJGRF+dA2IAlaAzlNRKtjmnsV6SFx5m9u5O7ZuJE=;
	b=M7zDYGspSyBx2vScbW/AwV1cbpDVQ6WhD2mq0mGiuU1BQDDNZZHCig3fFjQMW6hLeE30BP
	326/8GqfwNXZQH2V+7AO5LYCucXEMzYP8LJGEFtAmVWP3EDp0rv3xYeqzLBiPWGEVoDE7o
	F4yqBuu91dYQZyLo2rv7sD8ag+CmbAI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-141-sKSjAJoIPlKhoSq9UupV4g-1; Wed,
 14 Aug 2024 14:33:51 -0400
X-MC-Unique: sKSjAJoIPlKhoSq9UupV4g-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A3C918EA8E1;
	Wed, 14 Aug 2024 18:33:50 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D048419560AA;
	Wed, 14 Aug 2024 18:33:49 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.11-rc4
Date: Wed, 14 Aug 2024 14:33:48 -0400
Message-ID: <20240814183348.148233-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Linus,

The following changes since commit 7c626ce4bae1ac14f60076d00eafe71af30450ba:

  Linux 6.11-rc3 (2024-08-11 14:27:14 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 1c0e5881691a787a9399a99bff4d56ead6e75e91:

  KVM: SEV: uapi: fix typo in SEV_RET_INVALID_CONFIG (2024-08-14 13:05:42 -0400)

Another largish pull request; this time though it's more the number
of patches than the size, and there's nothing scary in it.

----------------------------------------------------------------
s390:

* Fix failure to start guests with kvm.use_gisa=0

* Panic if (un)share fails to maintain security.

ARM:

* Use kvfree() for the kvmalloc'd nested MMUs array

* Set of fixes to address warnings in W=1 builds

* Make KVM depend on assembler support for ARMv8.4

* Fix for vgic-debug interface for VMs without LPIs

* Actually check ID_AA64MMFR3_EL1.S1PIE in get-reg-list selftest

* Minor code / comment cleanups for configuring PAuth traps

* Take kvm->arch.config_lock to prevent destruction / initialization
  race for a vCPU's CPUIF which may lead to a UAF

x86:

* Disallow read-only memslots for SEV-ES and SEV-SNP (and TDX)

* Fix smatch issues

* Small cleanups

* Make x2APIC ID 100% readonly

* Fix typo in uapi constant

Generic:

* Use synchronize_srcu_expedited() on irqfd shutdown

----------------------------------------------------------------
Amit Shah (1):
      KVM: SEV: uapi: fix typo in SEV_RET_INVALID_CONFIG

Claudio Imbrenda (1):
      s390/uv: Panic for set and remove shared access UVC errors

Dan Carpenter (2):
      KVM: SVM: Fix uninitialized variable bug
      KVM: SVM: Fix an error code in sev_gmem_post_populate()

Danilo Krummrich (1):
      KVM: arm64: free kvm->arch.nested_mmus with kvfree()

Fuad Tabba (1):
      KVM: arm64: Tidying up PAuth code in KVM

Isaku Yamahata (1):
      KVM: x86: Use this_cpu_ptr() instead of per_cpu_ptr(smp_processor_id())

Li RongQing (1):
      KVM: eventfd: Use synchronize_srcu_expedited() on shutdown

Marc Zyngier (2):
      KVM: arm64: Enforce dependency on an ARMv8.4-aware toolchain
      KVM: arm64: vgic: Hold config_lock while tearing down a CPU interface

Mark Brown (1):
      KVM: selftests: arm64: Correct feature test for S1PIE in get-reg-list

Michael Mueller (1):
      KVM: s390: fix validity interception issue when gisa is switched off

Michal Luczaj (1):
      KVM: selftests: Add a testcase to verify x2APIC is fully readonly

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-6.11-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-s390-master-6.11-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

Sean Christopherson (2):
      KVM: x86: Make x2APIC ID 100% readonly
      KVM: x86: Disallow read-only memslots for SEV-ES and SEV-SNP (and TDX)

Sebastian Ott (3):
      KVM: arm64: fix override-init warnings in W=1 builds
      KVM: arm64: fix kdoc warnings in W=1 builds
      KVM: arm64: vgic: fix unexpected unlock sparse warnings

Takahiro Itazuri (1):
      docs: KVM: Fix register ID of SPSR_FIQ

Yue Haibing (1):
      KVM: x86: hyper-v: Remove unused inline function kvm_hv_free_pa_page()

Zenghui Yu (1):
      KVM: arm64: vgic-debug: Exit the iterator properly w/o LPI

 Documentation/virt/kvm/api.rst                     |  2 +-
 arch/arm64/include/asm/kvm_ptrauth.h               |  2 +-
 arch/arm64/kvm/Kconfig                             |  1 +
 arch/arm64/kvm/Makefile                            |  3 +++
 arch/arm64/kvm/arm.c                               | 15 ++++--------
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  1 -
 arch/arm64/kvm/hyp/nvhe/Makefile                   |  2 ++
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  5 ++--
 arch/arm64/kvm/hyp/vhe/Makefile                    |  2 ++
 arch/arm64/kvm/nested.c                            |  2 +-
 arch/arm64/kvm/vgic/vgic-debug.c                   |  5 ++--
 arch/arm64/kvm/vgic/vgic-init.c                    |  3 +--
 arch/arm64/kvm/vgic/vgic-irqfd.c                   |  7 +++---
 arch/arm64/kvm/vgic/vgic-its.c                     | 18 ++++++++------
 arch/arm64/kvm/vgic/vgic-v3.c                      |  2 +-
 arch/arm64/kvm/vgic/vgic.c                         |  2 +-
 arch/arm64/kvm/vgic/vgic.h                         |  2 +-
 arch/s390/include/asm/uv.h                         |  5 +++-
 arch/s390/kvm/kvm-s390.h                           |  7 +++++-
 arch/x86/include/asm/kvm_host.h                    |  2 ++
 arch/x86/kvm/hyperv.h                              |  1 -
 arch/x86/kvm/lapic.c                               | 22 +++++++++++------
 arch/x86/kvm/svm/sev.c                             |  7 +++---
 arch/x86/kvm/x86.c                                 |  6 ++---
 include/linux/kvm_host.h                           |  7 ++++++
 include/uapi/linux/psp-sev.h                       |  1 +
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |  4 ++--
 .../selftests/kvm/x86_64/xapic_state_test.c        | 28 ++++++++++++++++++++++
 virt/kvm/eventfd.c                                 | 13 +++++-----
 virt/kvm/kvm_main.c                                |  5 ++--
 30 files changed, 120 insertions(+), 62 deletions(-)



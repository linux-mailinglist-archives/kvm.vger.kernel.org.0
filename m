Return-Path: <kvm+bounces-50254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EABCAE2EBF
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 09:33:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46FB61735FE
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 07:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8177919938D;
	Sun, 22 Jun 2025 07:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OSbBJ8vR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509AE17BD9
	for <kvm@vger.kernel.org>; Sun, 22 Jun 2025 07:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750577618; cv=none; b=ZT2QY/xCeFV7tTG9G/MRJ4Dmii5WIjdc/Trdh3yaVxrXVfTuZA+ms/Ou+Yzroo0Foqq/bPJrzbdnkoroZB6vvoXS9kF7EtDK1rOd6jXifm/QObL+4FL/LLudnegsBbJBjQCwHntzHhOOB2MQWhR4UBu+bgLT/S1N+i6ecHhtpkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750577618; c=relaxed/simple;
	bh=ttk4p5ZNsuNzgopje2fCSLrP+J3UO2Rb5/z/LyPrpvo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yvj93ealH01LpLRx03/1jxhLUPsVXuO8kxZXRZ5t4DE/oMTGJhUTVKpXUCCmZ/q0A50PNtwo/yV1vmA3Bih8DTkIixyQLqKwn/gybeLzQ4F0sVSe55EQFlujYxUE3eDWTc/F4BZcyR7eyds+c2Ey9B5i9dyq6+4Y0+j+u5JYGoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OSbBJ8vR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750577615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Y5pdd4ctwYcaaGQFvw2NaWDN5HrejVg7fXPGMyHvQQI=;
	b=OSbBJ8vRk7gemONZ6YKrTGiJLQdnwe9ZFt//eUpDiwDXlevkJGV93NVxCCIeKT4j2GHA1Z
	ERb6aTvvPDEn9oCgnYhy14F8o9Ft1IqAsqYgXDiunPiTNqetGtaKrlTOF4qj/TctzadJjL
	+a+nW3IBJO5+aJ/68PyFsZ0ZvuO5XRU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-132-rVPQqZIKNtGHlybOXmZHsg-1; Sun,
 22 Jun 2025 03:33:31 -0400
X-MC-Unique: rVPQqZIKNtGHlybOXmZHsg-1
X-Mimecast-MFC-AGG-ID: rVPQqZIKNtGHlybOXmZHsg_1750577610
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65957180034E;
	Sun, 22 Jun 2025 07:33:30 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 90E11180045C;
	Sun, 22 Jun 2025 07:33:29 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.16-rc3
Date: Sun, 22 Jun 2025 03:33:28 -0400
Message-ID: <20250622073328.201148-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Linus,

The following changes since commit e04c78d86a9699d136910cfc0bdcf01087e3267e:

  Linux 6.16-rc2 (2025-06-15 13:49:41 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 25e8b1dd4883e6c251c3db5b347f3c8ae4ade921:

  KVM: TDX: Exit to userspace for GetTdVmCallInfo (2025-06-20 13:55:47 -0400)

----------------------------------------------------------------
ARM:

- Fix another set of FP/SIMD/SVE bugs affecting NV, and plugging some
  missing synchronisation

- A small fix for the irqbypass hook fixes, tightening the check and
  ensuring that we only deal with MSI for both the old and the new
  route entry

- Rework the way the shadow LRs are addressed in a nesting
  configuration, plugging an embarrassing bug as well as simplifying
  the whole process

- Add yet another fix for the dreaded arch_timer_edge_cases selftest

RISC-V:

- Fix the size parameter check in SBI SFENCE calls

- Don't treat SBI HFENCE calls as NOPs

x86 TDX:

- Complete API for handling complex TDVMCALLs in userspace.  This was
  delayed because the spec lacked a way for userspace to deny supporting
  these calls; the new exit code is now approved.

----------------------------------------------------------------
Anup Patel (2):
      RISC-V: KVM: Fix the size parameter check in SBI SFENCE calls
      RISC-V: KVM: Don't treat SBI HFENCE calls as NOPs

Binbin Wu (3):
      KVM: TDX: Add new TDVMCALL status code for unsupported subfuncs
      KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
      KVM: TDX: Exit to userspace for GetTdVmCallInfo

Marc Zyngier (1):
      KVM: arm64: nv: Fix tracking of shadow list registers

Mark Rutland (7):
      KVM: arm64: VHE: Synchronize restore of host debug registers
      KVM: arm64: VHE: Synchronize CPTR trap deactivation
      KVM: arm64: Reorganise CPTR trap manipulation
      KVM: arm64: Remove ad-hoc CPTR manipulation from fpsimd_sve_sync()
      KVM: arm64: Remove ad-hoc CPTR manipulation from kvm_hyp_handle_fpsimd()
      KVM: arm64: Remove cpacr_clear_set()
      KVM: arm64: VHE: Centralize ISBs when returning to host

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-6.16-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-riscv-fixes-6.16-1' of https://github.com/kvm-riscv/linux into HEAD

Sean Christopherson (1):
      KVM: arm64: Explicitly treat routing entry type changes as changes

Zenghui Yu (1):
      KVM: arm64: selftests: Close the GIC FD in arch_timer_edge_cases

 Documentation/virt/kvm/api.rst                     |  59 ++++++++-
 arch/arm64/include/asm/kvm_emulate.h               |  62 ---------
 arch/arm64/include/asm/kvm_host.h                  |   6 +-
 arch/arm64/kvm/arm.c                               |   3 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            | 147 +++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   5 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  59 ---------
 arch/arm64/kvm/hyp/vhe/switch.c                    | 107 ++-------------
 arch/arm64/kvm/vgic/vgic-v3-nested.c               |  81 ++++++------
 arch/riscv/kvm/vcpu_sbi_replace.c                  |   8 +-
 arch/x86/include/asm/shared/tdx.h                  |   1 +
 arch/x86/kvm/vmx/tdx.c                             |  83 +++++++++++-
 include/uapi/linux/kvm.h                           |  22 +++
 .../selftests/kvm/arm64/arch_timer_edge_cases.c    |  16 ++-
 14 files changed, 376 insertions(+), 283 deletions(-)



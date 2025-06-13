Return-Path: <kvm+bounces-49461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEE93AD9316
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:46:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9259E1783D7
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF87B224B10;
	Fri, 13 Jun 2025 16:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VnREP7yZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D9A1E8338
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 16:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749833172; cv=none; b=NlO70z7cqdSPJB5JryHwvw3iugNfWzIpXOlarfqw8tt9rk08ayjPRQ/ONLJLupJnVi52dZxoM2SSk8+SheNWQHnrPlehCKaNvSaudpuPQtxJLJ8q7nxQVv1JmGJabJemSwEMdgGTex0kHLVAo7tqkbMVK1rp+UPsy6PPvt7pWvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749833172; c=relaxed/simple;
	bh=i4hm9CHKm/3oJOWsJxscFqz/8Ylt/YD/hMzaFSn5rPs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jVj0RHptfGrZs75nvEQ6UepXLTPEmZN0C8bvg0utkitQBOhDOR3NwR/Lc0SpcMZm4qzTzEg4JaaTJ84+qiG1X2lGWxvLngXuyIhy7ytTkUi4RfCfLe1B5kadZ9UPQYuYzwVxox5So0XrDLiQAGJqxAtJLQ5DdaX7His8h9aUe/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VnREP7yZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749833167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bbROYjb4mdQOqht6aHh/H9xfCrTcRr7mEK6Oc+kCnJc=;
	b=VnREP7yZI9d9E3/y4D3KLjCvH4c6qcsaenYRTaqc7y+t1GddyH3ctqsYIyAJMxpK/O+TED
	0tlpBHjrWjCa7am8GwZixn5R0F+wh4eCfh8bZTu27CHkJzqjF+6KvltUPTk+f2xBTG8Un1
	Twnacdp4nDa0mXyP+B8pOly/RmB3e0s=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-7I_JWVqIOZirAbcsISAQpw-1; Fri,
 13 Jun 2025 12:46:06 -0400
X-MC-Unique: 7I_JWVqIOZirAbcsISAQpw-1
X-Mimecast-MFC-AGG-ID: 7I_JWVqIOZirAbcsISAQpw_1749833165
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E088E1800343;
	Fri, 13 Jun 2025 16:46:04 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4D1491956050;
	Fri, 13 Jun 2025 16:46:04 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.16-rc2
Date: Fri, 13 Jun 2025 12:46:03 -0400
Message-ID: <20250613164603.163319-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Linus,

The following changes since commit 19272b37aa4f83ca52bdf9c16d5d81bdd1354494:

  Linux 6.16-rc1 (2025-06-08 13:44:43 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 8046d29dde17002523f94d3e6e0ebe486ce52166:

  KVM: x86/mmu: Reject direct bits in gpa passed to KVM_PRE_FAULT_MEMORY (2025-06-12 00:51:42 -0400)

----------------------------------------------------------------
ARM:

- Rework of system register accessors for system registers that are
  directly writen to memory, so that sanitisation of the in-memory
  value happens at the correct time (after the read, or before the
  write). For convenience, RMW-style accessors are also provided.

- Multiple fixes for the so-called "arch-timer-edge-cases' selftest,
  which was always broken.

x86:

- Make KVM_PRE_FAULT_MEMORY stricter for TDX, allowing userspace to pass
  only the "untouched" addresses and flipping the shared/private bit
  in the implementation.

- Disable SEV-SNP support on initialization failure

----------------------------------------------------------------
Ashish Kalra (1):
      KVM: SEV: Disable SEV-SNP support on initialization failure

Marc Zyngier (4):
      KVM: arm64: Add assignment-specific sysreg accessor
      KVM: arm64: Add RMW specific sysreg accessor
      KVM: arm64: Don't use __vcpu_sys_reg() to get the address of a sysreg
      KVM: arm64: Make __vcpu_sys_reg() a pure rvalue operand

Paolo Bonzini (3):
      Merge tag 'kvmarm-fixes-6.16-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      KVM: x86/mmu: Embed direct bits into gpa for KVM_PRE_FAULT_MEMORY
      KVM: x86/mmu: Reject direct bits in gpa passed to KVM_PRE_FAULT_MEMORY

Sebastian Ott (4):
      KVM: arm64: selftests: Fix help text for arch_timer_edge_cases
      KVM: arm64: selftests: Fix thread migration in arch_timer_edge_cases
      KVM: arm64: selftests: Fix xVAL init in arch_timer_edge_cases
      KVM: arm64: selftests: Determine effective counter width in arch_timer_edge_cases

 arch/arm64/include/asm/kvm_host.h                  | 34 +++++++++---
 arch/arm64/kvm/arch_timer.c                        | 18 +++----
 arch/arm64/kvm/debug.c                             |  4 +-
 arch/arm64/kvm/fpsimd.c                            |  4 +-
 arch/arm64/kvm/hyp/exception.c                     |  4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  4 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  6 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  4 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |  4 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 | 46 ++++++++---------
 arch/arm64/kvm/nested.c                            |  2 +-
 arch/arm64/kvm/pmu-emul.c                          | 24 ++++-----
 arch/arm64/kvm/sys_regs.c                          | 60 +++++++++++-----------
 arch/arm64/kvm/sys_regs.h                          |  4 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c               | 10 ++--
 arch/x86/kvm/mmu/mmu.c                             |  9 +++-
 arch/x86/kvm/svm/sev.c                             | 44 ++++++++++++----
 .../selftests/kvm/arm64/arch_timer_edge_cases.c    | 39 +++++++++-----
 18 files changed, 194 insertions(+), 126 deletions(-)



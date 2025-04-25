Return-Path: <kvm+bounces-44336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6798A9CE22
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 18:29:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7207F4C630E
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 16:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BF1219E98A;
	Fri, 25 Apr 2025 16:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GnJ8P/SF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1E618C02E
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745598574; cv=none; b=VY9ksNFGPjgbC70zC6C8tpqyrPEFWK3EXFZl4UMfMOblPy7JNFXcM6IFATyRV+Tmv6+ttb5aj4LNYWoz0/89UfgRkGsXc84bRaSgsPGGnsVHNqfqraOaK93abbdFFJBx5N+79dSjLTZkxGPsq22uz9MCj18L76GwPitELdB46W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745598574; c=relaxed/simple;
	bh=dNOEF3deb1Hli7ypZNkU8omKQmciXb9+hWXBOwVIgw8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GFVoYpJnhxi55XEZPC4cscO+TNeuVaKuIYoQ8NCuzvxDWphd/uOOIYg+eohYxsHEyU9GMK6lujSBKQho5eoD7xuPywZgISrMRvvK0IeYx2GgMEJH4YSmmEQNDO06aBByTAOIyaenRItDa83z/wj/0nItS/KRZ2LCRTtb4ylnGeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GnJ8P/SF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745598571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hPhE2xp2EJWLrFm/riS/NVNoWM3TbNL/Rtdl7+CGpZI=;
	b=GnJ8P/SFVgesYY0kYbAb16fZNRniKqGlGOSHnIdipQY/FeWF1jOz8VOdFDP0Jr0tmyTELr
	kA1LOzVwyV1iCfI61Hb0VnjlUNDWMXJm0JHGp5MqIE0tRMy+Js/yDkiEJ+k0JGxaShg3J/
	ql8b+0tS5ue+DnYjt/tPqAj6YwImq10=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-vkm8F_U0NriBp0kIqjty5Q-1; Fri,
 25 Apr 2025 12:29:30 -0400
X-MC-Unique: vkm8F_U0NriBp0kIqjty5Q-1
X-Mimecast-MFC-AGG-ID: vkm8F_U0NriBp0kIqjty5Q_1745598569
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CBF5F1800264;
	Fri, 25 Apr 2025 16:29:28 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3F551180045C;
	Fri, 25 Apr 2025 16:29:28 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.15-rc4
Date: Fri, 25 Apr 2025 12:29:27 -0400
Message-ID: <20250425162927.404532-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Linus,

The following changes since commit 8ffd015db85fea3e15a77027fda6c02ced4d2444:

  Linux 6.15-rc2 (2025-04-13 11:54:49 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 2d7124941a273c7233849a7a2bbfbeb7e28f1caa:

  Merge tag 'kvmarm-fixes-6.15-2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2025-04-24 13:28:53 -0400)

Compared to last week's botched attempt, this includes your suggestion
to make kvm_arch_has_irq_bypass() inline and a new ARM fix.

Paolo

----------------------------------------------------------------
ARM:

* Single fix for broken usage of 'multi-MIDR' infrastructure in PI
  code, adding an open-coded erratum check for everyone's favorite pile
  of sand: Cavium ThunderX

x86:

* Bugfixes from a planned posted interrupt rework

* Do not use kvm_rip_read() unconditionally to cater for guests
  with inaccessible register state.

----------------------------------------------------------------
Adrian Hunter (2):
      KVM: x86: Do not use kvm_rip_read() unconditionally in KVM tracepoints
      KVM: x86: Do not use kvm_rip_read() unconditionally for KVM_PROFILING

Marc Zyngier (1):
      arm64: Rework checks for broken Cavium HW in the PI code

Paolo Bonzini (2):
      KVM: arm64, x86: make kvm_arch_has_irq_bypass() inline
      Merge tag 'kvmarm-fixes-6.15-2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Sean Christopherson (8):
      KVM: SVM: Don't update IRTEs if APICv/AVIC is disabled
      KVM: SVM: Allocate IR data using atomic allocation
      KVM: x86: Reset IRTE to host control if *new* route isn't postable
      KVM: x86: Explicitly treat routing entry type changes as changes
      KVM: x86: Take irqfds.lock when adding/deleting IRQ bypass producer
      iommu/amd: Return an error if vCPU affinity is set for non-vCPU IRTE
      iommu/amd: WARN if KVM attempts to set vCPU affinity without posted intrrupts
      KVM: SVM: WARN if an invalid posted interrupt IRTE entry is added

 arch/arm64/include/asm/kvm_host.h |  5 +++
 arch/arm64/include/asm/mmu.h      | 11 -------
 arch/arm64/kernel/cpu_errata.c    |  2 +-
 arch/arm64/kernel/image-vars.h    |  4 ---
 arch/arm64/kernel/pi/map_kernel.c | 25 +++++++++++++-
 arch/arm64/kvm/arm.c              |  5 ---
 arch/x86/include/asm/kvm_host.h   |  6 ++++
 arch/x86/kvm/svm/avic.c           | 68 +++++++++++++++++++++------------------
 arch/x86/kvm/trace.h              | 13 ++++++--
 arch/x86/kvm/vmx/posted_intr.c    | 28 ++++++----------
 arch/x86/kvm/x86.c                | 28 ++++++++++------
 drivers/iommu/amd/iommu.c         | 15 +++------
 12 files changed, 116 insertions(+), 94 deletions(-)



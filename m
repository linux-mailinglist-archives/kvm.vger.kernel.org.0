Return-Path: <kvm+bounces-4750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C973817AD7
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 20:17:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C45B1F25D10
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 19:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA01F5D759;
	Mon, 18 Dec 2023 19:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WfgZ/xOn"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B350A5BFBC
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 19:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 18 Dec 2023 11:17:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702927050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=RCNTVgShRnFY0wpkW908oaU4F/q2PRK/4k+6ZuwoIrU=;
	b=WfgZ/xOnUgyIKurbvPDMQfjl/NVTnT3LQSb7nJoE4uUIP2uUuEsQIqOG3OqQGWDFSGc3mP
	2De2Mv2bKUQZZH0XH6oZDedQ3DXe+919sAihydqKEgB+sH07rhdk6iMnJHXQD9doM7aw6N
	yWQ1fOSOoWcpooJlEehHZXWKZ8E7WXo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.7, part #2
Message-ID: <ZYCaxOtefkuvBc3Z@thinky-boi>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Paolo,

Here's the second batch of fixes for 6.7. Please note that this pull
is based on -rc4 instead of my first fixes tag as the KVM selftests
breakage was introduced by one of my changes that went through the
perf tree.

Please pull.

-- 
Thanks,
Oliver

The following changes since commit 33cc938e65a98f1d29d0a18403dbbee050dcad9a:

  Linux 6.7-rc4 (2023-12-03 18:52:56 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.7-2

for you to fetch changes up to 0c12e6c8267f831e491ee64ac6f216601cea3eee:

  KVM: selftests: Ensure sysreg-defs.h is generated at the expected path (2023-12-12 16:49:43 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.7, part #2

 - Ensure a vCPU's redistributor is unregistered from the MMIO bus
   if vCPU creation fails

 - Fix building KVM selftests for arm64 from the top-level Makefile

----------------------------------------------------------------
Marc Zyngier (5):
      KVM: arm64: vgic: Simplify kvm_vgic_destroy()
      KVM: arm64: vgic: Add a non-locking primitive for kvm_vgic_vcpu_destroy()
      KVM: arm64: vgic: Force vcpu vgic teardown on vcpu destroy
      KVM: arm64: vgic: Ensure that slots_lock is held in vgic_register_all_redist_iodevs()
      KVM: Convert comment into an assertion in kvm_io_bus_register_dev()

Oliver Upton (1):
      KVM: selftests: Ensure sysreg-defs.h is generated at the expected path

 arch/arm64/kvm/arm.c                 |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c      | 47 ++++++++++++++++++++++--------------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c   |  4 ++-
 arch/arm64/kvm/vgic/vgic.h           |  1 +
 tools/testing/selftests/kvm/Makefile | 26 ++++++++++++--------
 virt/kvm/kvm_main.c                  |  3 ++-
 6 files changed, 52 insertions(+), 31 deletions(-)


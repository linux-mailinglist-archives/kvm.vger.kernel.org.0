Return-Path: <kvm+bounces-24250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0938A952EA2
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:00:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B180A1F226CB
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 13:00:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3AA19DF73;
	Thu, 15 Aug 2024 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fn3tmV9i"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7841991B1;
	Thu, 15 Aug 2024 13:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723726805; cv=none; b=hDX/tdvGMiEtMEYKbimitftQjSvjKqWUNcI41+wlKEXntub1b152leI2kYuOMINBAqLeaYjShzxUt5oo1HgP4NFDLV+i1jZB0b2EWWSdNg6+sapYImKE1bABiePaydAbVWP8+VK2lzUwuCFb49RbyS295XqYExVz6oVPBYxn1XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723726805; c=relaxed/simple;
	bh=5P04ykbmzh8C6jEQrvdjizXGGEpPVWPIOo78t8wPxO0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KxZHkiEZU7F+Y6Pv7e5al7O2OLuJT/cufWNiapek4KOGxgXxQvpBj2xngB8VKg0eta6ZWgE/uBL1f+rV68cryon88qlZU926c9NfewLPG4S//VwxUs1gfAQmO7C2NvYNqar3l+iWSyZXOeNtSregeenhSkNp39aTdZogM3/y9E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fn3tmV9i; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36C6C32786;
	Thu, 15 Aug 2024 13:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723726804;
	bh=5P04ykbmzh8C6jEQrvdjizXGGEpPVWPIOo78t8wPxO0=;
	h=From:To:Cc:Subject:Date:From;
	b=fn3tmV9iCXVehiYp45JhYoCAFk8j7Xefo9L/vbhK5lyeFDdR2RYRBC9OMOtakRsL3
	 PP27JlUdw2LO84yLQnH4EK6NaU2sVKck39lu/+d+9u15i37unjIueEJCN+PLS3DYT/
	 QEvKl3wJIOWAzcTi4WizveU/UlivWhIMlzUiUPMYaagxCFH4lB3GUm/+m5CjWjgSl6
	 5pvaEK+ULsRPlpS8mh0y/ysYyAJA44KXSNZ7/+fL/cuMHUqf+8a6JtxQwdjmhfDlFb
	 E3T9F77c9p/dQCPYvnWlWFOx4m9X9NRtP8nBN0YtdIcXM4SiSHmFv6CKPWxcu3d5+2
	 PezwWJ5YzILNQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sea5C-003xld-LH;
	Thu, 15 Aug 2024 14:00:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 00/11] KVM: arm64: Add support for FEAT_LS64 and co
Date: Thu, 15 Aug 2024 13:59:48 +0100
Message-Id: <20240815125959.2097734-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The ARM architecture has introduced a while back some 64 byte
Load/Store operations that are targeting NormalNC or Device memory.
People have been threatening of using this in actual code, so we might
as well support it. It also fits my plans to cover the features
enabled by HCRX_EL2.

From a KVM perspective, it is only a load/store. Nothing to call home
about. However, there are two situations where this is interesting:

- a NV guest wants to trap these instructions: we need to correctly
  route them.

- the access falls outside of a memslot, and userspace needs to handle
  this.

This last point is of special interest. Instead of going through the
pain of doing all the decoding in the kernel and presenting the VMM
with a fully decoded access (like it is the case for normal MMIO), we
brutally return the ESR+IPA and let userspace deal with the outcome,
hijacking the data structures for KVM_EXIT_ARM_NISV for that purpose.

It has all the information at its disposal through the vcpu ioctl
interface, and can definitely do what's asked. Just not very quickly

I don't think this is a problem, and that approximately 100% of the
VMMs will simply inject an external abort as an indication that they
are not handling this.

This is otherwise pretty uninteresting code.

Marc Zyngier (11):
  arm64: Expose ID_AA64ISAR1_EL1.XS to sanitised feature consumers
  arm64: Add syndrome information for trapped LD64B/ST64B{,V,V0}
  KVM: arm64: Add ACCDATA_EL1 to the sysreg array
  KVM: arm64: Add context-switch of ACCDATA_EL1
  KVM: arm64: Handle trapping of FEAT_LS64* instructions
  KVM: arm64: Add exit to userspace on {LD,ST}64B* outside of memslots
  KVM: arm64: Restrict ACCDATA_EL1 undef to FEAT_ST64_ACCDATA being
    disabled
  KVM: arm64: Conditionnaly enable FEAT_LS64* instructions
  KVM: arm64: nv: Expose FEAT_LS64* to a nested guest
  arm64: Expose ID_AA64ISAR1_EL1.LS64 to sanitised feature consumers
  KVM: arm64: Add documentation for KVM_EXIT_ARM_LDST64B

 Documentation/virt/kvm/api.rst             | 43 ++++++++++++---
 arch/arm64/include/asm/esr.h               |  8 ++-
 arch/arm64/include/asm/kvm_host.h          |  3 +
 arch/arm64/kernel/cpufeature.c             |  2 +
 arch/arm64/kvm/handle_exit.c               | 64 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 29 ++++++++--
 arch/arm64/kvm/mmio.c                      | 27 ++++++++-
 arch/arm64/kvm/nested.c                    |  5 +-
 arch/arm64/kvm/sys_regs.c                  | 25 ++++++++-
 include/uapi/linux/kvm.h                   |  3 +-
 10 files changed, 188 insertions(+), 21 deletions(-)

-- 
2.39.2



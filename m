Return-Path: <kvm+bounces-71956-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sGPtNbYloGkDfwQAu9opvQ
	(envelope-from <kvm+bounces-71956-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 11:51:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F3A91A4924
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 11:51:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 66498302BDEC
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 10:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0581318EE6;
	Thu, 26 Feb 2026 10:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eq0N/CcV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FD1302750;
	Thu, 26 Feb 2026 10:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772103070; cv=none; b=ItdXLPyFHr6x3KbTRsLQFQtAPWvOxbEu4mqzbPzF4mLYVZsSoBNE3rDowVIHRb2mXqOnyNvx2ScAln6TYaswW2HW6/R821sCYQ/kJPU9n9alPZlSyObIKdOrr06dHpiXeOsZL/sj82T8OJttW1liDD/oHm8cK9isf9DbNy124yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772103070; c=relaxed/simple;
	bh=c2H9Qi49m5+C4KxTW0j8/WB4GcymfvOF1Dx3C8KYFFs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SJ8e9T9sIuH/GsrVD+OR0SHQbWjpcjzU7FyigCsVzWxCkJYCESaD+lBRME4hx5sd+562JNIG9NRKrF8Jt5MfZNtVPaxTM1yn9rkhwVePAc4H1WryN5orDQI/IPMVKvn4pHqEY0rNIySyrQVJWVV7H/ahANNQxQlo8iNMQGgUJ7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eq0N/CcV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C381FC2BC9E;
	Thu, 26 Feb 2026 10:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772103069;
	bh=c2H9Qi49m5+C4KxTW0j8/WB4GcymfvOF1Dx3C8KYFFs=;
	h=From:To:Cc:Subject:Date:From;
	b=Eq0N/CcVRqyeonDZJrXv9xf3VwFC3Mrxsw0GwBo1up49FgA9c+Wv+Vdo0yenwTCM/
	 c7lUFm8KvlVKebR1w3mheBfxkQ+C9gadmCPvyhJg1KzY+CsACuJjyd7xR90llaFNnW
	 o/YRAfhqXTXF44ytY4W/xynrOigplzqcDObe8xIgASJc02kex8sdfkwLnrungkIk2A
	 tuVUBLKBur7cE+h9zRtE+6vzLKx+SHiEr3KtUyfiw2pKnDxyZIWXBNlqdjaQ0Si8aZ
	 3WTxHdG3WZH9tK/MeC7b1jMxRBLovlNNY1XF+8XHWq7eJByIZ/D3EU5SZUUHppwGEN
	 T6rX32Xvv4jIQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vvYxX-0000000E12u-3VQk;
	Thu, 26 Feb 2026 10:51:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Kees Cook <kees@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 7.0, take #1
Date: Thu, 26 Feb 2026 10:50:47 +0000
Message-ID: <20260226105048.28066-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, tabba@google.com, joey.gouly@arm.com, jonathan.cameron@huawei.com, kees@kernel.org, broonie@kernel.org, sascha.bischoff@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71956-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4F3A91A4924
X-Rspamd-Action: no action

Paolo,

Here's the first set of KVM/arm64 fixes for 7.0. Most of it affects
pKVM (feature set, MMU), but we also have a GICv5 fix and a couple of
small cleanups. Details in the tag below.

Note that there is a very minor conflict with Linus' tree due to Kees'
patch having been applied to both trees. Whatever is in Linus' tree is
the right thing.

Please pull,

	M.

The following changes since commit 6316366129d2885fae07c2774f4b7ae0a45fb55d:

  Merge branch kvm-arm64/misc-6.20 into kvmarm-master/next (2026-02-05 09:17:58 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-7.0-1

for you to fetch changes up to 54e367cb94d6bef941bbc1132d9959dc73bd4b6f:

  KVM: arm64: Deduplicate ASID retrieval code (2026-02-25 12:19:33 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 7.0, take #1

- Make sure we don't leak any S1POE state from guest to guest when
  the feature is supported on the HW, but not enabled on the host

- Propagate the ID registers from the host into non-protected VMs
  managed by pKVM, ensuring that the guest sees the intended feature set

- Drop double kern_hyp_va() from unpin_host_sve_state(), which could
  bite us if we were to change kern_hyp_va() to not being idempotent

- Don't leak stage-2 mappings in protected mode

- Correctly align the faulting address when dealing with single page
  stage-2 mappings for PAGE_SIZE > 4kB

- Fix detection of virtualisation-capable GICv5 IRS, due to the
  maintainer being obviously fat fingered...

- Remove duplication of code retrieving the ASID for the purpose of
  S1 PT handling

- Fix slightly abusive const-ification in vgic_set_kvm_info()

----------------------------------------------------------------
Fuad Tabba (5):
      KVM: arm64: Hide S1POE from guests when not supported by the host
      KVM: arm64: Optimise away S1POE handling when not supported by host
      KVM: arm64: Fix ID register initialization for non-protected pKVM guests
      KVM: arm64: Remove redundant kern_hyp_va() in unpin_host_sve_state()
      KVM: arm64: Revert accidental drop of kvm_uninit_stage2_mmu() for non-NV VMs

Kees Cook (1):
      KVM: arm64: vgic: Handle const qualifier from gic_kvm_info allocation type

Marc Zyngier (2):
      KVM: arm64: Fix protected mode handling of pages larger than 4kB
      KVM: arm64: Deduplicate ASID retrieval code

Sascha Bischoff (1):
      irqchip/gic-v5: Fix inversion of IRS_IDR0.virt flag

 arch/arm64/include/asm/kvm_host.h   |  3 +-
 arch/arm64/include/asm/kvm_nested.h |  2 ++
 arch/arm64/kvm/at.c                 | 27 ++--------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c      | 37 ++++++++++++++++++++--
 arch/arm64/kvm/mmu.c                | 12 +++----
 arch/arm64/kvm/nested.c             | 63 ++++++++++++++++++-------------------
 arch/arm64/kvm/sys_regs.c           |  3 ++
 arch/arm64/kvm/vgic/vgic-init.c     |  2 +-
 drivers/irqchip/irq-gic-v5-irs.c    |  2 +-
 9 files changed, 81 insertions(+), 70 deletions(-)


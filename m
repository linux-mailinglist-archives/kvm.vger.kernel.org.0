Return-Path: <kvm+bounces-69883-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OBujNuvwgGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69883-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:46:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A792D0466
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:46:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AF302304C094
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60DE73815C2;
	Mon,  2 Feb 2026 18:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QIDroI2u"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1412F12AE;
	Mon,  2 Feb 2026 18:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057821; cv=none; b=ZyX3d+yBviSmIvJc/IsT/gtY3DXH5P14mw5AJJBlIzJ27xcG5lnKHcZAh+GyFLHpYa44Om/c3rYqX3VmDFyzn13U/KdtbC7rhCu5mIXkrzySVnfDokPG74oyEeUwTGfrVxu+LNmj9RmLTfODSMdewXTQ5FmiiYeuLxgEL2JsFI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057821; c=relaxed/simple;
	bh=bLqTU9IRK/P5BfC/WRSUY7H5idKZKHvYB30haHzcFsY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mDMLLn1IsIJMfkSOzjzBc2CmBc4Qemvjf41iepE/lNvQ8x+zBqAM6xc749z3AWT7/8xjEYSIFf5f6cbqE4Q5VW9eDIQCy+OAH76TX9+8TmsFWA0DX3XtryvUl/nnnOyvKBhZ7AaQGkvmxkcXTJq54giMXavVI5nsiO6ysUj6Xwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QIDroI2u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290C7C116C6;
	Mon,  2 Feb 2026 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770057821;
	bh=bLqTU9IRK/P5BfC/WRSUY7H5idKZKHvYB30haHzcFsY=;
	h=From:To:Cc:Subject:Date:From;
	b=QIDroI2uQ5KwG245M83Ix7pyJM85+KNclxYYYMlvZgjw3hU9fdYeLCAUchfYXa4Nd
	 OJ4jSSog6RjK8vKlOURzvc3Q62NLi+euYjlYWl6sNRdUCrkadO4J8yDol6fJwTGuxG
	 O0/W9dWzDhegPlbkwQ9GApjTp7XoPbkpD3qkWJ1WKPjJ1et9DqD0C9zolKhKzPHrCJ
	 5r4VKXPjOQz06l0m21MWLg6cp5Z6ZmzIE3R7hFk5qs9/tAndKCs5P7mmHYI78K2pAb
	 kYAUpYWChP1k0ffjQzIH2CXx5hmgf1XYYG7YRzaTIg/p4DqsksDRo4cQm472tq6jrS
	 88OHKUMRebV9Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmyte-00000007sAy-2ppV;
	Mon, 02 Feb 2026 18:43:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v2 00/20] KVM: arm64: Generalise RESx handling
Date: Mon,  2 Feb 2026 18:43:09 +0000
Message-ID: <20260202184329.2724080-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69883-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[hcr_el2.rw:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0A792D0466
X-Rspamd-Action: no action

Having spent some time dealing with some dark corners of the
architecture, I have realised that our RESx handling is a bit patchy.
Specially when it comes to RES1 bits, which are not clearly defined in
config.c, and rely on band-aids such as FIXED_VALUE.

This series takes the excuse of adding SCTLR_EL2 sanitisation to bite
the bullet and pursue several goals:

- clearly define bits that are RES1 when a feature is absent

- have a unified data structure to manage both RES0 and RES1 bits

- deal with the annoying complexity of some features being
  conditioned on E2H==1

- allow a single bit to take different RESx values depending on the
  value of E2H

This allows quite a bit of cleanup, including the total removal of the
FIXED_VALUE horror, which was always a bizarre construct. We also get
a new debugfs file to introspect the RESx settings for a given guest.

Overall, this lowers the complexity of expressing the configuration
constraints, for very little code (most of the extra lines are
introduced by the debugfs stuff, and SCTLR_EL2 being added to the
sysreg file).

Patches on top of my kvm-arm64/vtcr branch (which is currently
simmering in -next).

* From v1 [1]

  - Simplified RES0 handling by dropping the RES0_WHEN_E2Hx macros

  - Cleaned up the kvm_{g,s}et_sysreg_resx() helpers

  - Simplified dynamic RESx handling

  - New improved debugfs handling, thanks to Fuad!

  - Various clean-ups and spelling fixes

  - Collected RBs (thanks Fuad and Joey!)

[1] https://lore.kernel.org/all/20260126121655.1641736-1-maz@kernel.org
Marc Zyngier (20):
  arm64: Convert SCTLR_EL2 to sysreg infrastructure
  KVM: arm64: Remove duplicate configuration for SCTLR_EL1.{EE,E0E}
  KVM: arm64: Introduce standalone FGU computing primitive
  KVM: arm64: Introduce data structure tracking both RES0 and RES1 bits
  KVM: arm64: Extend unified RESx handling to runtime sanitisation
  KVM: arm64: Inherit RESx bits from FGT register descriptors
  KVM: arm64: Allow RES1 bits to be inferred from configuration
  KVM: arm64: Correctly handle SCTLR_EL1 RES1 bits for unsupported
    features
  KVM: arm64: Convert HCR_EL2.RW to AS_RES1
  KVM: arm64: Simplify FIXED_VALUE handling
  KVM: arm64: Add REQUIRES_E2H1 constraint as configuration flags
  KVM: arm64: Add RES1_WHEN_E2Hx constraints as configuration flags
  KVM: arm64: Move RESx into individual register descriptors
  KVM: arm64: Simplify handling of HCR_EL2.E2H RESx
  KVM: arm64: Get rid of FIXED_VALUE altogether
  KVM: arm64: Simplify handling of full register invalid constraint
  KVM: arm64: Remove all traces of FEAT_TME
  KVM: arm64: Remove all traces of HCR_EL2.MIOCNCE
  KVM: arm64: Add sanitisation to SCTLR_EL2
  KVM: arm64: Add debugfs file dumping computed RESx values

 arch/arm64/include/asm/kvm_host.h             |  38 +-
 arch/arm64/include/asm/sysreg.h               |   7 -
 arch/arm64/kvm/config.c                       | 427 ++++++++++--------
 arch/arm64/kvm/emulate-nested.c               |  10 +-
 arch/arm64/kvm/nested.c                       | 151 +++----
 arch/arm64/kvm/sys_regs.c                     |  68 +++
 arch/arm64/tools/sysreg                       |  82 +++-
 tools/arch/arm64/include/asm/sysreg.h         |   6 -
 tools/perf/Documentation/perf-arm-spe.txt     |   1 -
 .../testing/selftests/kvm/arm64/set_id_regs.c |   1 -
 10 files changed, 478 insertions(+), 313 deletions(-)

-- 
2.47.3



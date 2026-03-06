Return-Path: <kvm+bounces-73029-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ENJ7BqG5qmlpVwEAu9opvQ
	(envelope-from <kvm+bounces-73029-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 12:25:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F3521F9E7
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 12:25:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2931830B1008
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 11:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE22937E312;
	Fri,  6 Mar 2026 11:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YsOHJERd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002EF30AAA6;
	Fri,  6 Mar 2026 11:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772796176; cv=none; b=myoWQIdVA85yTJ8RDnQ8SoILorm9OpY8ByiokZryv3ws1firC7Y1Ime7t5ghr55sANAkZAWJNp+Vshk6WQQWIWQTgGELeN50xtQZ4w0CWUsDFfYE8i00ZtR9kSCQ0pa8yjBI/3p9X9ZyB1zEAv8vtGnE7sylN2Hoyz1CORYcOYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772796176; c=relaxed/simple;
	bh=bTskKNStNZifhhf7Tm8WvVPQQAa5+bxG9ESJPyn5mQI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jy4GuxdiwRZyQRVhzv9IDF1uY7eqaWxKJ80A+I9P22AV2w/sJKnPk9aIUaEzUSD+Rz+Y5FUAGHp1sSpFfcC2/H9m2VD83yAiyroTg8MnXccKhE0KTIgkHdDruGFtTa43DI7YX6qcjxVrd1ycgaunBVuYdzLLKkkRXFNuVfOe36Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YsOHJERd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3E6C2BC87;
	Fri,  6 Mar 2026 11:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772796175;
	bh=bTskKNStNZifhhf7Tm8WvVPQQAa5+bxG9ESJPyn5mQI=;
	h=From:To:Cc:Subject:Date:From;
	b=YsOHJERdSCgr/siqbeGLtLQLlYFc+kcKrqWx1ETjGioq/he5BInajVEYHeR+7SpMW
	 7MOGKqrK/i0oICg760+T/DQjgZlFfWcAehXhFC3ExpDnMn3P1SQu1NFoQz/kEWlHD1
	 48YHWHn8U/qlTLN1Mt92fIDogPULBuJzw6Es9DEzhLSKBAWArnXCLae2CZPtR0kDnw
	 /aJdFpPyV2sGjnzGj6Y50onvLT+bz89yM9oU5n2ZpYD1c/nMKpfhYZZ+nNHWqDeZGC
	 a34xyxwfWah5y0DuBK7BJrEmsQOy/lOGJBAcNhh+hJmQ/1aQKv/GRVPvQjinwX9CIM
	 Gxf1om+j7m+1A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vyTGf-0000000GoNa-2HP8;
	Fri, 06 Mar 2026 11:22:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Fuad Tabba <tabba@google.com>,
	Quentin Perret <qperret@google.com>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 7.0, take #2
Date: Fri,  6 Mar 2026 11:22:31 +0000
Message-ID: <20260306112231.3201502-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, tabba@google.com, qperret@google.com, yaoyuan@linux.alibaba.com, zenghui.yu@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Queue-Id: 91F3521F9E7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73029-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Paolo,

Here's the second set of fixes for 7.0. The only interesting fix is
one affecting pKVM and preventing the host from making forward
progress when a memblock is not page-aligned.

The rest is a bunch of low-severity fixes affecting the page-table
code, some of which Fuad has promised to start cleaning up!

Please pull,

	M.

The following changes since commit 11439c4635edd669ae435eec308f4ab8a0804808:

  Linux 7.0-rc2 (2026-03-01 15:39:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-7.0-2

for you to fetch changes up to 3599c714c08c324f0fcfa392bfb857c92c575400:

  KVM: arm64: Remove the redundant ISB in __kvm_at_s1e2() (2026-03-06 10:42:21 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 7.0, take #2

- Fix a couple of low-severity bugs in our S2 fault handling path,
  affecting the recently introduced LS64 handling and the even more
  esoteric handling of hwpoison in a nested context

- Address yet another syzkaller finding in the vgic initialisation,
  were we would end-up destroying an uninitialised vgic, with nasty
  consequences

- Address an annoying case of pKVM failing to boot when some of the
  memblock regions that the host is faulting in are not page-aligned

- Inject some sanity in the NV stage-2 walker by checking the limits
  against the advertised PA size, and correctly report the resulting
  faults

- Drop an unnecessary ISB when emulating an EL2 S1 address translation

----------------------------------------------------------------
Fuad Tabba (2):
      KVM: arm64: Fix page leak in user_mem_abort() on atomic fault
      KVM: arm64: Fix vma_shift staleness on nested hwpoison path

Marc Zyngier (2):
      KVM: arm64: Eagerly init vgic dist/redist on vgic creation
      KVM: arm64: pkvm: Fallback to level-3 mapping on host stage-2 fault

Zenghui Yu (Huawei) (4):
      KVM: arm64: nv: Check S2 limits based on implemented PA size
      KVM: arm64: nv: Report addrsz fault at level 0 with a bad VTTBR.BADDR
      KVM: arm64: nv: Inject a SEA if failed to read the descriptor
      KVM: arm64: Remove the redundant ISB in __kvm_at_s1e2()

 arch/arm64/kvm/at.c                   |  2 --
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  2 +-
 arch/arm64/kvm/mmu.c                  | 14 +++++++++-----
 arch/arm64/kvm/nested.c               | 27 ++++++++++++++++-----------
 arch/arm64/kvm/vgic/vgic-init.c       | 32 ++++++++++++++++----------------
 5 files changed, 42 insertions(+), 35 deletions(-)


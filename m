Return-Path: <kvm+bounces-27867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07A8198F82A
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 22:37:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94CFC2826F8
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 20:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC07B1AD9C3;
	Thu,  3 Oct 2024 20:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pQS8+bex"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1949D1A7274;
	Thu,  3 Oct 2024 20:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727987858; cv=none; b=LWLROzjrviuCVFg65B+/LM2XxN4t+6pzs+xTOsfKHpxtgxGiWK8zocJZlKVlztEbtnngtVRY51I+5IdRNjTNqErfcUa1obXsG9yW6LE/KYjm4zXeM/dtJXXrHDFrtn3kRhs5D6x4ZY3qm+uJ73ukQ/B0XQ/pd23t0g+YFVKt600=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727987858; c=relaxed/simple;
	bh=8T6eykxd6XDU5qs08iAO7QM6z+RQFEJlVhLiF5MG0UI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DWKoNwuubqTpsyO5bCi/N4lvyUP6SAv52zLb5pQ6VVIz9YEDzRVkGQ3SwqC8eF3VbNVXDfbg9Qe+a/DIc3pfItt37r/p0q5zCbFK25Sc8WC8rMufIVKJrXDZd42nzNdi2Ldy6FqWiF6Lr5Oa0vZSKl8/L0V8HTgugZR4N0egbBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pQS8+bex; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6A8C4CEC5;
	Thu,  3 Oct 2024 20:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727987857;
	bh=8T6eykxd6XDU5qs08iAO7QM6z+RQFEJlVhLiF5MG0UI=;
	h=From:To:Cc:Subject:Date:From;
	b=pQS8+bexM6YUntvxK7zqyuqMa8eY2VkKi8f8MLEN5wDlnzbYli9UoSlIAMW6xjfz8
	 vbTXTy4RM1ejkNNVIaKCdVD4fZeSlYCnoJfsABjaaVLkJ2rZ7Ys9fDpSyM8bjm0fws
	 TJbcvCbjx2azEdUHepy/CCP6UorLo0GrBP38DO46QZ82amN+0qBe02Us8zq3/yvhL6
	 bJsBxVpUfIsxA/cXiaUV1jybcESvikfLrb8U7+MINPPTzN4ATr+xj2OglLZp/gBeKE
	 m8tLjRRiV/heCkwkn/zu/6136s5HcmejOb9ZAWULFFenrP2S2BuCd4Z9w99QuY7xK2
	 Euvx0wyoXLwXg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1swSZr-00HX6X-3Z;
	Thu, 03 Oct 2024 21:37:35 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.12, take #1
Date: Thu,  3 Oct 2024 21:37:23 +0100
Message-Id: <20241003203723.2062286-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, catalin.marinas@arm.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com, vdonnefort@google.com, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the first set of fixes for 6.12. We have fixes for a couple of
pretty theoretical pKVM issues, plus a slightly more annoying fix for
the feature detection infrastructure (details in the tag below). I
expect to have a few more fixes in the coming weeks. Oh, and Joey is
now an official reviewer, replacing James

Please pull,

	M.

The following changes since commit 9852d85ec9d492ebef56dc5f229416c925758edc:

  Linux 6.12-rc1 (2024-09-29 15:06:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.12-1

for you to fetch changes up to a1d402abf8e3ff1d821e88993fc5331784fac0da:

  KVM: arm64: Fix kvm_has_feat*() handling of negative features (2024-10-03 19:35:27 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.12, take #1

- Fix pKVM error path on init, making sure we do not change critical
  system registers as we're about to fail

- Make sure that the host's vector length is at capped by a value
  common to all CPUs

- Fix kvm_has_feat*() handling of "negative" features, as the current
  code is pretty broken

- Promote Joey to the status of official reviewer, while James steps
  down -- hopefully only temporarly

----------------------------------------------------------------
Marc Zyngier (2):
      KVM: arm64: Another reviewer reshuffle
      KVM: arm64: Fix kvm_has_feat*() handling of negative features

Mark Brown (1):
      KVM: arm64: Constrain the host to the maximum shared SVE VL with pKVM

Vincent Donnefort (1):
      KVM: arm64: Fix __pkvm_init_vcpu cptr_el2 error path

 MAINTAINERS                             |  2 +-
 arch/arm64/include/asm/kvm_host.h       | 25 +++++++++++++------------
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 12 +++++++-----
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  6 ++++--
 5 files changed, 26 insertions(+), 21 deletions(-)


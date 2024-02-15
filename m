Return-Path: <kvm+bounces-8774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3206C856792
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 16:29:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C61221F22030
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 15:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 038D713328F;
	Thu, 15 Feb 2024 15:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ih/SmNUC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D40C132C37;
	Thu, 15 Feb 2024 15:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708010982; cv=none; b=uamQg+xwUPdwzUOQqhRaHLL2hQelvhx2bYrIUZITfWjmKiohqUVsleTBDYNs3WW8t4rdS0k0A411kivQQeDOzwjs1lKm7BQkg78r+RF8ZbJIMgidR+jy/lYEuJMICl9uZVdnelg9i73AyySezNPa2ZCotdZeZFYW7pgzCbP5eH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708010982; c=relaxed/simple;
	bh=Nnud892Bslm9egn9hKCn7asQA+cP79m2+G21dMWR1LY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VUlfhcWFnFj4XsG16v65IrPfoNxEGZQALe5UhnIYTNEWbzvhrM6I8Pq5BB0OvFmbZ7nJ6HnLmD6fIbogX2HpasA3XGPjROTYHxAkYlHCDbyJE/KxKeYH2+6aKCK9gGzSPo8sDxBiSqI79jeLH/8a0lnGW0CcVAiMg6lKKj+afR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ih/SmNUC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE90C433C7;
	Thu, 15 Feb 2024 15:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708010981;
	bh=Nnud892Bslm9egn9hKCn7asQA+cP79m2+G21dMWR1LY=;
	h=From:To:Cc:Subject:Date:From;
	b=Ih/SmNUCvkQ1V4RSA803oNyGazqyAgjHiYHZrR1OdR2xIUNEgyXTQ/eNccrdxDnS3
	 VTV0MH5jrzlfI4Zzf4VrvlXdQ67DcTgnTpkzajQUh72pBdE+bnabnFsyv51BhOFZF3
	 iBNJ7/SXTX5UVrKHgGjrkMiFzMYpukccyQ48F9Cei1KplJQmpH0N7d68/mB1LEhw+F
	 4DHQD54Jemax69QTAiGdWnMwjdGha1cLLZmieaiNW3OgUAZsm2QJEWFL3MncQAWhEr
	 SGNzIcuQMoifNsZ1ZpmAe47sscDez3sOIQiNehxwsbalkJf26d/SvCWeg57+ZP0iJK
	 pJq+2p3/kBm5A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1radgB-003XsL-Co;
	Thu, 15 Feb 2024 15:29:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Ricardo Koller <ricarkol@google.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.8, take #2
Date: Thu, 15 Feb 2024 15:29:35 +0000
Message-Id: <20240215152935.3093768-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, oliver.upton@linux.dev, ricarkol@google.com, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Hi Paolo,

Another week, another very small pull request. This time, the bug is
irritating enough that I want it fixed and backported right away. It
has only been found by inspection (thanks Will!), but once you've seen
it, you can unsee it.

If you haven't pulled the previous tag [1], you'll get both for free.

Please pull,

	M.

[1] https://lore.kernel.org/r/20240207144611.1128848-1-maz@kernel.org


The following changes since commit 42dfa94d802a48c871e2017cbf86153270c86632:

  KVM: arm64: Do not source virt/lib/Kconfig twice (2024-02-04 13:08:28 +0000)
are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.8-2

for you to fetch changes up to c60d847be7b8e69e419e02a2b3d19c2842a3c35d:

  KVM: arm64: Fix double-free following kvm_pgtable_stage2_free_unlinked() (2024-02-13 19:22:03 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.8, take #2

- Avoid dropping the page refcount twice when freeing an unlinked
  page-table subtree.

----------------------------------------------------------------
Will Deacon (1):
      KVM: arm64: Fix double-free following kvm_pgtable_stage2_free_unlinked()

 arch/arm64/kvm/hyp/pgtable.c | 2 --
 1 file changed, 2 deletions(-)


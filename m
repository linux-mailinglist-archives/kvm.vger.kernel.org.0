Return-Path: <kvm+bounces-57548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 687CCB578CB
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19C6B16CE6A
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F1D52FFDDD;
	Mon, 15 Sep 2025 11:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qFzP2Nk0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493CB2F49F6;
	Mon, 15 Sep 2025 11:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936697; cv=none; b=EgKBrL0MGCWqsktlh0ijiodH9fCM2yrZeQcweVFTKrXBLhXijAl4EAFxMdfA2dl8OBGNKgwlsyBgZ2Mv+29LgBNkG6hCq0RLVWaP+ZSJUMC6nAzOy4ItOcDObmMWRg/UNnKZ2mrgjMZ1YaC12bP6ib80FnnM0VsUG8Hya4VnULQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936697; c=relaxed/simple;
	bh=T4sKcaGjBev816n86vAdqzzxxqZb1Hw/bY78A4+x9E4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EZyLSbiKAwQAID2ssuIz9StrSzRVPR+3lvqkCposu8uevpBAa91xxkRZ2Un5eeKBc4Hjv64eLub6u2J8/Yyx0eNJdvm6pRyGGqfl/CaD3UMWqzWyyWnAvDKFYU18ajS1mhfmaNRjmBEZBi4xj8WVl5oTMmM65DuWUjw43bP1q78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qFzP2Nk0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01E8C4CEF1;
	Mon, 15 Sep 2025 11:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936696;
	bh=T4sKcaGjBev816n86vAdqzzxxqZb1Hw/bY78A4+x9E4=;
	h=From:To:Cc:Subject:Date:From;
	b=qFzP2Nk0XiyB4nAixs0Mqz06ngRuECMbio3K3A8bDTY04dQNlvUSGGl3obd7PXdlK
	 T18EJ7cCJ6RD+RACeNFdg36BovQ8SYH7Csyz8sKc7ke1fah7UbShFQ6HiGgQck0fnm
	 0r9QSCdQJdZKoyclWiixi/HFip0DUrC68tv8FZ2kQ4jdG2AVL1D/qVf6Op344QRe3V
	 /Qte4ygimB15PDiCgWxLLvyIKZ7oDZYvf/6JQ7G8a+K6W8quhDkI+tsotpgh9VdPEg
	 ShgbpAAPm+hvP4XV7+puGH85si+IcPEjyR1AYLtTXupdckmDjiPmMxJODNrQDRIsss
	 SgYKEkQZ/G7NQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7de-00000006MDw-3nLh;
	Mon, 15 Sep 2025 11:44:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 00/16] KVM: arm64: TTW reporting on SEA and 52bit PA in S1 PTW
Date: Mon, 15 Sep 2025 12:44:35 +0100
Message-Id: <20250915114451.660351-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Yes, $SUBJECT rolls off the tongue.

This series was triggered by the realisation that when injecting an
SEA while on a S1PTW fault, we don't report the level of the walk and
instead give a bare SEA, which definitely violates the architecture.

This state of things dates back to the pre-NV days, when we didn't
have a S1 page table walker, and really didn't want to implement one.
I've since moved on and reluctantly implemented one, which means we
now *could* provide the level if we really wanted to.

However, nothing is that simple. The current code in at.c is firmly
48bit, as our NV implementation doesn't yet support 52bit PA, while an
EL1 VM can happily enjoy LPA and LPA2. As a result, it is necessary to
expand the S1 PTW to support both LPA and LPA2. Joy.

Then, once the above is achieved, we need to hook into the PTW
machinery to match the first level of the walk that results in
accessing the faulty address. For this, we introduce a simple filter
mechanism that could be expanded if we needed to (no, please no).

Finally, we can plug this into the fault injection path, and enjoy
seeing the translation level being populated in the ESR_ELx register.

Patches on top of 6.16-rc4. I intend to take this into 6.18, so shout
if you don't like the idea!

* From v1 [1]:

  - Rebased on -rc4 to avoid a simple conflict.

[1] https://lore.kernel.org/r/20250827161039.938958-1-maz@kernel.org

Marc Zyngier (16):
  KVM: arm64: Add helper computing the state of 52bit PA support
  KVM: arm64: Account for 52bit when computing maximum OA
  KVM: arm64: Compute 52bit TTBR address and alignment
  KVM: arm64: Decouple output address from the PT descriptor
  KVM: arm64: Pass the walk_info structure to compute_par_s1()
  KVM: arm64: Compute shareability for LPA2
  KVM: arm64: Populate PAR_EL1 with 52bit addresses
  KVM: arm64: Expand valid block mappings to FEAT_LPA/LPA2 support
  KVM: arm64: Report faults from S1 walk setup at the expected start
    level
  KVM: arm64: Allow use of S1 PTW for non-NV vcpus
  KVM: arm64: Allow EL1 control registers to be accessed from the CPU
    state
  KVM: arm64: Don't switch MMU on translation from non-NV context
  KVM: arm64: Add filtering hook to S1 page table walk
  KVM: arm64: Add S1 IPA to page table level walker
  KVM: arm64: Populate level on S1PTW SEA injection
  KVM: arm64: selftest: Expand external_aborts test to look for TTW
    levels

 arch/arm64/include/asm/kvm_nested.h           |  25 +-
 arch/arm64/kvm/at.c                           | 341 +++++++++++++-----
 arch/arm64/kvm/inject_fault.c                 |  27 +-
 arch/arm64/kvm/nested.c                       |   2 +-
 .../selftests/kvm/arm64/external_aborts.c     |  43 +++
 .../selftests/kvm/include/arm64/processor.h   |   1 +
 .../selftests/kvm/lib/arm64/processor.c       |  13 +-
 7 files changed, 362 insertions(+), 90 deletions(-)

-- 
2.39.2



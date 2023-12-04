Return-Path: <kvm+bounces-3345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D71048036F8
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:36:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAEDA1C20BBC
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 14:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD52B28E3A;
	Mon,  4 Dec 2023 14:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UCFBgZ1f"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFC228E07;
	Mon,  4 Dec 2023 14:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55518C433C7;
	Mon,  4 Dec 2023 14:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701700579;
	bh=j1HPCgU1PQL/jc9JYytnvjS6AN3f656T+qdLua+mCtU=;
	h=From:To:Cc:Subject:Date:From;
	b=UCFBgZ1fXjY9ckYyRIHc0K21Gb9/dC4YNZDK/7VuNei7rbp9MFLPEbl/s/j0Vq8Bg
	 ioqH1rBT10fPrJ2gmCFElQfuOLLu8Wf+B9fjCGj5oJDMnjTcoaDrZY/bHykMaVsHKU
	 i48Jt8a3SuD+U5jCxFEX/T4HBNGydXs9pyWB4PG53mGnDChXjeaq5QRjlc/CjyJO64
	 I/lC2UK9FnvbdoLBV/L1KbF+i2gcxiR788gusMPRvxl6hgl76Sb0PgFpNd6Ja8SXsu
	 ZRJDEdW2WvqnPqYCOB87gwOKwJkaYQnhEL5+BBZ1PX+JDI3EiNdXg6MoNN7gQysjGD
	 3w0YhuIojklaQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rAA3U-001GN2-Rd;
	Mon, 04 Dec 2023 14:36:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 0/3] arm64: Drop support for VPIPT i-cache policy
Date: Mon,  4 Dec 2023 14:36:03 +0000
Message-Id: <20231204143606.1806432-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, ardb@kernel.org, anshuman.khandual@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

ARMv8.2 introduced support for VPIPT i-caches, the V standing for
VMID-tagged. Although this looked like a reasonable idea, no
implementation has ever made it into the wild.

Linux has supported this for over 6 years (amusingly, just as the
architecture was dropping support for AIVIVT i-caches), but we had no
way to even test it, and it is likely that this code was just
bit-rotting.

However, in a recent breakthrough (XML drop 2023-09, tagged as
d55f5af8e09052abe92a02adf820deea2eaed717), the architecture has
finally been purged of this option, making VIPT and PIPT the only two
valid options.

This really means this code is just dead code. Nobody will ever come
up with such an implementation, and we can just get rid of it.

Most of the impact is on KVM, where we drop a few large comment blocks
(and a bit of code), while the core arch code loses the detection code
itself.

* From v2:
  - Fix reserved naming for RESERVED_AIVIVT
  - Collected RBs from Anshuman an Zenghui

Marc Zyngier (3):
  KVM: arm64: Remove VPIPT I-cache handling
  arm64: Kill detection of VPIPT i-cache policy
  arm64: Rename reserved values for CTR_EL0.L1Ip

 arch/arm64/include/asm/cache.h   |  6 ----
 arch/arm64/include/asm/kvm_mmu.h |  7 ----
 arch/arm64/kernel/cpuinfo.c      |  5 ---
 arch/arm64/kvm/hyp/nvhe/pkvm.c   |  2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c    | 61 --------------------------------
 arch/arm64/kvm/hyp/vhe/tlb.c     | 13 -------
 arch/arm64/tools/sysreg          |  5 +--
 7 files changed, 4 insertions(+), 95 deletions(-)

-- 
2.39.2



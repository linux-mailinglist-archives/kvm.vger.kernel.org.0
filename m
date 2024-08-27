Return-Path: <kvm+bounces-25120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D16B9602B1
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 09:07:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27ECE1F2344B
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 07:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 858B6149DF4;
	Tue, 27 Aug 2024 07:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jikjkFik"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6511428F3;
	Tue, 27 Aug 2024 07:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742458; cv=none; b=n3StdrJC32vCjCcnwKHczNZyH2XZsgfDP7MuQjCIa4oT4GdVGG5IjNWFRSan07clG1yoyclScPOF31l1l327+VFtD6pftoGffNxXxSDP8Iho91jT/YyMjcMcYuKr31ElqgKZ5NVYgLfPuHR9ztn+wuNSCPRA2doB2cISe7ykwew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742458; c=relaxed/simple;
	bh=w7cxUhLIAzp2ombetFVrAYWSkIfI6Xs1DMlJ3n1Zcf4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WTB+9LR8NNmmONpWvYSqTYMosZNZV5ktHEIppk0yGZ0CfWwBdt3QV/yXK8JtOnSXX+ZLZFmiugBCQf0Z3AuhZ1qEYSPWLQbhbKGqeL3lbPcaHki1eJ2n75kyTAJGOANCbBARGgILVoPG8h/2MPXGhMLUK0pUnzy+twgB65Vx9J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jikjkFik; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23394C8B7AA;
	Tue, 27 Aug 2024 07:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724742458;
	bh=w7cxUhLIAzp2ombetFVrAYWSkIfI6Xs1DMlJ3n1Zcf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jikjkFik7s5RnDb53CbhMDzOqygs8f1+bSff7o42MTzuuMoGF80LpeFSQFythukkQ
	 uvs+ECE7wOBG679XDrs0n2A1BaF+o0IxRyY0dEPYsGvZF0XPONJVs8t0YI56r7VuI2
	 haRN/LZU+sNz9Fv9O0DOxeJJdRGmgrP2TeWoyg7o6jnzhYpXjTutTvlF4yeYUdtLCC
	 aGbIaY9t9m2mLTNW4Y96YHjX4boM/+gHkKyBTMeO+gbfTzwxqd6OkVjWX61I9fsbQ8
	 LhT7bcxA5AzIExO1JavuJOT9ZAgTXT61lJu+5uwpAf/k8RgeJo0jf+uGpHYWf6j0Pp
	 ylI0gy6/uO87A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1siqIh-0077cp-J6;
	Tue, 27 Aug 2024 08:07:35 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 0/8] KVM: arm64: Add support for FP8
Date: Tue, 27 Aug 2024 08:07:31 +0100
Message-Id: <172474244499.3905348.3393130116483819167.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820131802.3547589-1-maz@kernel.org>
References: <20240820131802.3547589-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 20 Aug 2024 14:17:54 +0100, Marc Zyngier wrote:
> Although FP8 support was merged in 6.9, the KVM side was dropped, with
> no sign of it being picked up again. Given that its absence is getting
> in the way of NV upstreaming (HCRX_EL2 needs fleshing out), here's a
> small series addressing it.
> 
> The support is following the save/restore model established for the
> rest of the FP code, with FPMR being tied to it. The sole additions
> are the handling of traps in a nested context, and the corresponding
> ID registers being made writable. As an extra cleanup, SVCR and FPMR
> are moved into the sysreg array.
> 
> [...]

Applied to next, thanks!

[1/8] KVM: arm64: Move SVCR into the sysreg array
      commit: b55688943597df06f202c67341da5b9b0ec54e93
[2/8] KVM: arm64: Add predicate for FPMR support in a VM
      commit: d4db98791aa5316677a1da9bfa0788068c9863dc
[3/8] KVM: arm64: Move FPMR into the sysreg array
      commit: 7d9c1ed6f4bfa8d5fcafad847ac64e2839a04301
[4/8] KVM: arm64: Add save/restore support for FPMR
      commit: ef3be86021c3bdf384c36d9d4aa1ee9fe65b95af
[5/8] KVM: arm64: Honor trap routing for FPMR
      commit: b8f669b491ec4693d07126b20db0fbe747556d11
[6/8] KVM: arm64: Expose ID_AA64FPFR0_EL1 as a writable ID reg
      commit: 6d7307651a8a021e7286e90264676b893cb6032d
[7/8] KVM: arm64: Enable FP8 support when available and configured
      commit: c9150a8ad9cdb69584d4ec5af61481df41498eb8
[8/8] KVM: arm64: Expose ID_AA64PFR2_EL1 to userspace and guests
      commit: 13c7a51eeb747ec315485ac7b13d4ea03707f53e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




Return-Path: <kvm+bounces-54124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1C7B1CA24
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 18:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A40114E31E4
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 16:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3021929B8D2;
	Wed,  6 Aug 2025 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LSMkU25Z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D58292936;
	Wed,  6 Aug 2025 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754499390; cv=none; b=mhDohh+hhDv46SDPuWFZUSuqrNy5pEuK5RiygIA55PV21utQaqakFFTqsIbRjMUUsdWms/EWaDz0/hWxw2ydOMambZCyyJQ+EILHCG6ZclxIKC+a2OosgSFYXUKmN4gjRDWiBsurfixilD17SsEyzxI6ZQs8ebCVcQxCu72FKBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754499390; c=relaxed/simple;
	bh=nAgxQxMg7fSf4u6ys2lhhQQPPEUWlRT0i7ib+oOcq9g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j7rau0Jd4TY7jBx2Ux3pis5zfwXERPsIMeU1Jb6akoQjDII+if26ZSAsMJ+RFwzHPv/zZ9qFwAT6rVjnIZ7WIvYKMiqSPFIMY8g2QbYGUhTVGOEq30HieNde0C4pWvKNttlK9API2dF1+DaAQ0OM9Au1itDWP9KrYoAhOaxIqfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LSMkU25Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F14C4CEE7;
	Wed,  6 Aug 2025 16:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754499389;
	bh=nAgxQxMg7fSf4u6ys2lhhQQPPEUWlRT0i7ib+oOcq9g=;
	h=From:To:Cc:Subject:Date:From;
	b=LSMkU25Z5/Drk3O9ryMexaEg+Y4nJBkF9Ju3k285DSVia4hDolFL3uud7vi9gksGy
	 8JaqrPsOkBgdx1d9pVfhPXsKIsAk2pGCxJaOl+fotiLStZsrOuiIWHWymyvjAiyBsr
	 XBS6QzjIJ69HE9t9XZRR+mVzJrBDD+LUy26Sk5KbGmpU1MYeeUO9xkIka3KBp4MV0h
	 jsFogfu1k0hnSe/RQnhV+3hif6+kIHHBeFROucplfJrVl8uTxlIF2qcp0ZkfyrbeCA
	 LRWmI9ZpyOO03UPHhgN2QZvOltWlOuUZmLpk4II3TwjZJhoIQk2cwJj0avjEKePWa3
	 FeR5I3eCWVUIA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ujhRD-004ZQV-FN;
	Wed, 06 Aug 2025 17:56:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 0/5] KVM: arm64: FEAT_RASv1p1 support and RAS selection
Date: Wed,  6 Aug 2025 17:56:10 +0100
Message-Id: <20250806165615.1513164-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, cohuck@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the next iteration of this series trying to plug some of our
RAS holes (no pun intended...). See [1] for the original series.

Patches on top of kvmarm-6.17.

* From v1 [1]:

  - Bunch of patches picked by Oliver (thanks!)

  - Added missing SYS_ERXMISC{2,3}_EL1 from the list of handled RAS
    registers

 - Added some rationale about the advertising of RASv1p1 (Cornelia)

  - Picked AB from Catalin (thanks!)

[1] https://lore.kernel.org/kvmarm/20250721101955.535159-1-maz@kernel.org

Marc Zyngier (5):
  arm64: Add capability denoting FEAT_RASv1p1
  KVM: arm64: Handle RASv1p1 registers
  KVM: arm64: Ignore HCR_EL2.FIEN set by L1 guest's EL2
  KVM: arm64: Expose FEAT_RASv1p1 in a canonical manner
  KVM: arm64: Make ID_AA64PFR0_EL1.RAS writable

 arch/arm64/kernel/cpufeature.c  | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c |  5 ++++-
 arch/arm64/kvm/sys_regs.c       | 30 +++++++++++++++++++++++++++++-
 arch/arm64/tools/cpucaps        |  1 +
 4 files changed, 58 insertions(+), 2 deletions(-)

-- 
2.39.2



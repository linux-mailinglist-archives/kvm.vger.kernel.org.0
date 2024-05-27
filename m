Return-Path: <kvm+bounces-18184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 490798D08F2
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 18:49:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB82C2823A4
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 16:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D695B15A86A;
	Mon, 27 May 2024 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gihk2WUd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0700C1E4BF;
	Mon, 27 May 2024 16:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716828530; cv=none; b=Qq2ZLZnnaJuHta33Qxk1owt18xo7cbR0VH3SGq1rrBluZTTg0in8mzh8kAf1pCNTaX8+jR25caQ0GH17Erk2gLoSofBSoxNErOxnZvvlIPty14Gb/4wHae7HDc06PPhNupBESOf7P2h6Sl7XhdGJWCmVfoIpacjjVungikGb8OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716828530; c=relaxed/simple;
	bh=Vxt4wZu1D8rsoBLveSFL22Ki4caTFHV/R39xu/DzFY0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rHXWzuqR3CxdcBhZr/w92Djaw8YdJOuivq/LhQKDKDJt52jWp74pfF2g2mO233vAdEXicDUHLN6Xtjj9THQdDVc8C7hKv1zBaQ0sslby0Ye49nD8Pz1AT0s0GqGVkP1VVd2WIu1+dovdX67G6D6bItkNP9lsJMuzAvfvFAaoscQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gihk2WUd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD31C2BBFC;
	Mon, 27 May 2024 16:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716828529;
	bh=Vxt4wZu1D8rsoBLveSFL22Ki4caTFHV/R39xu/DzFY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gihk2WUdbo4BHbXXN22Ub/e8biVwtYDRP8uK4K0r5I762uFUeHkh6B8cjbV6rP1Vm
	 LulFHUmdC8mWefFqcgMQT+HU6KRWf16Na64Mjm4eZur2bo3hFhKwOrLqeiuphmeW6D
	 +WM7HE/hQ6AAZ9zaH6YB5RI2AEjhJxlvySzIazkb1w7aM4zYLMTvGg1Xqr3mM1Sli1
	 0SFeUFpxBm1/lUhba1tHyj8/L+ek9QX0oqjwFYtCjSRNWiU5WKROYfV+7b4jQUvMtJ
	 S1Z8hT0WjqpFMZK3BJ3WKLd799JXQFdm1kJItLwv5IJLo6ZYOJqZ6ba1DvsYPFSJ/9
	 04l802U0sGEqQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sBdWh-00FyEn-6j;
	Mon, 27 May 2024 17:48:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/3] KVM/arm64 fixes for AArch32 handling
Date: Mon, 27 May 2024 17:48:33 +0100
Message-Id: <171682850243.1823849.5447352038599596772.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240524141956.1450304-1-maz@kernel.org>
References: <20240524141956.1450304-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org, nsg@linux.ibm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 24 May 2024 15:19:53 +0100, Marc Zyngier wrote:
> The (very much unloved) AArch32 handling has recently been found
> lacking in a number of ways:
> 
> - Nina spotted a brown paper-bag quality bug in the register narrowing
>   code when writing one of the core registers (GPRs, PSTATE) from
>   userspace
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: Fix AArch32 register narrowing on userspace write
      commit: 947051e361d551e0590777080ffc4926190f62f2
[2/3] KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode
      commit: dfe6d190f38fc5df5ff2614b463a5195a399c885
[3/3] KVM: arm64: AArch32: Fix spurious trapping of conditional instructions
      commit: c92e8b9eacebb4060634ebd9395bba1b29aadc68

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




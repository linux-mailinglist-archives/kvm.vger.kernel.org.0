Return-Path: <kvm+bounces-26573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D6F8975ADD
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 21:32:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB80B283428
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 19:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF531BA27A;
	Wed, 11 Sep 2024 19:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RV8JSEQY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506D258AC4;
	Wed, 11 Sep 2024 19:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726083156; cv=none; b=KXw/V1Ru3yk0RZ4UbrKnLJPgcyzZOtOxwsa+mI5nhcZCV0/3foz6vAg8/P2d938aQ1heczOn8mVz0cMwKMGkOhtEl+Dtbl9W/hwjcxNzSqF12MNw2cf3DaZiaja82/iuGvU6e1U/SZsGZKHglfQejW6SiqlCx5B/g26Ys1CjVBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726083156; c=relaxed/simple;
	bh=VdsQg9HsZmbhwQYQyJYLohUBcRLUGY8hZaRUHcNVfW8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g1E1wYa41BXchkysjS2bMCrgCNLsCbcE3xyUgzCLKE/hQNtydJsEeR2FtTAZCkLLuoeF8EBGvLUKNe/9h1XJ92R/EnLNHAWM8Eu+iL1jfs6lF6mbiTBJ64JnAhTlVDMWErlWeS1ZhFd3Mhj9loTNQ5IFlAvHhtsGppCfII1n93g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RV8JSEQY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69D3C4CEC0;
	Wed, 11 Sep 2024 19:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726083155;
	bh=VdsQg9HsZmbhwQYQyJYLohUBcRLUGY8hZaRUHcNVfW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RV8JSEQY7uVop6vG8+ApZXPJR+YhYk4wDQ+6W1myXYRhH+3N/PEfQ8OsSfX5SDvV5
	 159ZetBAZsYOONtcE6pVXiwFdMo61x08SnVyC88NgfFbANN0WbnXKWuTZvLzWkTatg
	 iGOTpFIMQPG54lla5ZVvdhojCp+piwcWcoc/7Ib+0oPWuYHcrmqWgZQiPjxdb9+obJ
	 8v0Cy1rbuoHLxRvZBo8orZ1BqzjIi+0A66lIwjY8Yve4nmd+0WUSJj3BWdSPBAQyEe
	 odLvBQOw0aD0X5YDsYc//7st9WEcpFOmsqVeSh99rPMRUv5ZQ6UreXEy3uKfK6kZwf
	 +J9Hpt9+lQopQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soT4r-00CDGU-Nm;
	Wed, 11 Sep 2024 20:32:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Get rid of REG_HIDDEN_USER
Date: Wed, 11 Sep 2024 20:32:31 +0100
Message-Id: <172608314298.404616.5760924324456191456.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240904082419.1982402-1-maz@kernel.org>
References: <20240904082419.1982402-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 04 Sep 2024 09:24:16 +0100, Marc Zyngier wrote:
> REG_HIDDEN_USER was introduced as a way to deal with the ARMv8.3 flavour of
> FEAT_NV, where most EL12 sysreg accesses would trap and yet be mapped to a
> EL1 register (KVM doing in SW what FEAT_NV2 does in HW). This handling
> imposed that the EL12 register shouldn't be visible to userspace, hence the
> special REG_HIDDEN_USER visibility.
> 
> Since 4d4f52052ba8 ("KVM: arm64: nv: Drop EL12 register traps that are
> redirected to VNCR") and the admission that KVM would never be supporting
> the original FEAT_NV, REG_HIDDEN_USER only had a few users, all of which
> could either be replaced by a more ad-hoc mechanism, or removed altogether.
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Simplify handling of CNTKCTL_EL12
      commit: 989fce63b2cb5061701c9fa04711d992dfaff5c6
[2/3] KVM: arm64: Simplify visibility handling of AArch32 SPSR_*
      commit: 84ed45456cee7e77effea8407f4f32b262f2e2ea
[3/3] KVM: arm64: Get rid of REG_HIDDEN_USER visibility qualifier
      commit: 0746096faca01823021f662282e1f067a69b965b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




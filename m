Return-Path: <kvm+bounces-16512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 716708BADCA
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 15:35:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5724B223E7
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 13:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4818A153BE8;
	Fri,  3 May 2024 13:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pLIBVXiM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A0F15358B;
	Fri,  3 May 2024 13:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714743331; cv=none; b=sUcWXf2LrTrAnW4vkBTTASDY+u0Bel0c/SxOTZKD/1peoMPqbHM9pyoDNgldBVB9ny4BdlD21ufvfGC7JIp3Pv5La7D8BzKn+Qjr4soBpBcZN2nO5MfTvlLnQKK/pwIHpoocMJP7wRRWnsadUdGymtMzyUzaB1eEnoO6d5XPzDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714743331; c=relaxed/simple;
	bh=m6+m273WWYM3xRKmtCMagMXcmqCj9wNVbU5LpE90Nlg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D79BYr358lNt/9GavXkS9RY0drD615yjhnKgth63IsEWlkO8yPWjXKqt14xl0WzDKHaUtWZRTjbcpK/pJqrYQDMASSaY40xcbYq+ahP3INcVmLpsxwoV4UkpeSRJYB2yTVC9VLCouX5CeZJVB93wyD98WppecVluysd7kwiiDT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pLIBVXiM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17485C4AF14;
	Fri,  3 May 2024 13:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714743330;
	bh=m6+m273WWYM3xRKmtCMagMXcmqCj9wNVbU5LpE90Nlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLIBVXiM1aEQebyjHN++XMdSyNat2XxcKgHa5x3UvMTSgMwvgBC7nA52GwUutwLEm
	 B/xjgf8jFa9gmv2nMUozvph+UzzPQwFr8r3CFtELx6qtNsPPFJg2Qa7k/WLfCL7Ahz
	 ixlcZAk/v5XdTVRfPQJyMUIXaEztEZ/4Mi/iPQ2XQUEtHtfmzZDksREtDS0HlzwZJy
	 7RM47SYFcnSrWQP+woGbiruaxLNBcq4NmlzKwsZnDd4Z0taGDWVaERDkAY2AfPzN2V
	 i6qqD63u2DCwpoHdsjHnpvwyrE1GLycQ2eTKAQzdDK1miVXd+fhddLeShUlYhHSuFA
	 geECfKPm3Es7A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1s2t4S-00AKZC-3Q;
	Fri, 03 May 2024 14:35:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Move management of __hyp_running_vcpu to load/put on VHE
Date: Fri,  3 May 2024 14:35:16 +0100
Message-Id: <171474325428.3225213.18323755309626244103.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240502154030.3011995-1-maz@kernel.org>
References: <20240502154030.3011995-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 02 May 2024 16:40:30 +0100, Marc Zyngier wrote:
> The per-CPU host context structure contains a __hyp_running_vcpu that
> serves as a replacement for kvm_get_current_vcpu() in contexts where
> we cannot make direct use of it (such as in the nVHE hypervisor).
> Since there is a lot of common code between nVHE and VHE, the latter
> also populates this field even if kvm_get_running_vcpu() always works.
> 
> We currently pretty inconsistent when populating __hyp_running_vcpu
> to point to the currently running vcpu:
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Move management of __hyp_running_vcpu to load/put on VHE
      commit: 9a39359903fea9c354d89dce81ffd952859c90dc

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




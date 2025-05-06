Return-Path: <kvm+bounces-45564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 740FDAABD85
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 10:42:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0BA7504007
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECE3424A06E;
	Tue,  6 May 2025 08:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jDgY1wOZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECDC1FDE00;
	Tue,  6 May 2025 08:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746520932; cv=none; b=PFNNmoDTwBjRW9ejTSNZr5rdXE4aCkIo5QuasLoFVnp65kxqvsOA3nLXMQEw1Y99poanykuZNCaNmawqKzdxahmlNOsPZOyAwQiYZFofzLNcqU6+Rko0V78bgvfpHj5NODe1a3UH/tZQ4y3qTRSjkLOeFv9KN1B948PB/+9KIgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746520932; c=relaxed/simple;
	bh=A7JVTQBmPAjbRx9TJY0iNXrjPsM+vyowa0qQxX8aIdE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=beCrT8XPovkkEvjnL/ufS4Fcs3YPqA5zwCiGL4Zh+BBHWxNV81izceByCLQ6/LCLicvfvEO0WRM7M1JO+Ht14bWXNtrZwMKkdRnbOCXW+zy2L9uTwH8kqlJVJea2a+1r2HqTlpM0xqADFjjWxjWJTyqAR2SZGYwhDtCdck5meJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jDgY1wOZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88965C4CEE4;
	Tue,  6 May 2025 08:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746520929;
	bh=A7JVTQBmPAjbRx9TJY0iNXrjPsM+vyowa0qQxX8aIdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDgY1wOZEvtEAdiSKgGul5Yy3klRVr/w1XasyAcx0GBu2abasCZ/H1/sGCacniZja
	 vYcrgAU7gTO0IuyTTzV7WXtWBevUAPbKV5Xu/hBklRDSR2C9Vn2g67zZMo/VIXnfw9
	 8aF2kqx/h40Iwwi0OMS+u/i8Mvbw5LhVYdNu89hkv3B+XdZZZ+BN7l2H1S+vqrS9ia
	 NEK5Ti7eV6/S1zHH97pZSkl5EgmEArUlo9Lko9IOV9R21RI5BILFyEo/69TjnmHQxF
	 wpQb2/9csIjMIPou/iuRW1af05bMZwa9xT1zMXSH5mtOFFIP+DuRhns90SUJvfvL0g
	 4ePuhF3opagIw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCDsN-00C9Jj-B3;
	Tue, 06 May 2025 09:42:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	D Scott Phillips <scott@os.amperecomputing.com>
Subject: Re: [PATCH v2] KVM: arm64: Force HCR_EL2.xMO to 1 at all times in VHE mode
Date: Tue,  6 May 2025 09:42:03 +0100
Message-Id: <174652091367.339365.17018853732670126384.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250429114326.3618875-1-maz@kernel.org>
References: <20250429114326.3618875-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, scott@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 29 Apr 2025 12:43:26 +0100, Marc Zyngier wrote:
> We keep setting and clearing these bits depending on the role of
> the host kernel, mimicking what we do for nVHE. But that's actually
> pretty pointless, as we always want physical interrupts to make it
> to the host, at EL2.
> 
> This has also two problems:
> 
> [...]

Applied to kvm-arm64/misc-6.16, thanks!

[1/1] KVM: arm64: Force HCR_EL2.xMO to 1 at all times in VHE mode
      commit: bae247ccade0a5016031e73c9f6d61b758b612d8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




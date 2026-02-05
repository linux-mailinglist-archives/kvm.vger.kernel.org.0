Return-Path: <kvm+bounces-70314-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHn3NcthhGng2gMAu9opvQ
	(envelope-from <kvm+bounces-70314-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 10:24:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EB9AF09E1
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 10:24:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A31D33063C50
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 09:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E56F36EAA7;
	Thu,  5 Feb 2026 09:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQd+Dd8Z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F04134B1AB;
	Thu,  5 Feb 2026 09:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770282516; cv=none; b=WAiKFQfaAmVUWmqH4NQVsrZu0SswpmTQN+TSl0c52CoIWCBQmDwGrF3P+HzmXKqCw+lny+2ThADp8GPUYOcdioAx+Onp9EoHTisBdXFEthQiZkmQzRCAPmY2i5YFHZYRuVpePiOgVVo7GpTvAhQELQTbJqZ4k8EWQ7bjDPQXAUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770282516; c=relaxed/simple;
	bh=OhN6+wIzAdohK1eS9qgSF+1gf6+BUDXfBSY8Drbw8Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xb1/maDov4fGKMKnXnBDf8R87eJzgzhoQF0zPsmwp4rNBv7YySbaarLw8cJhvu/18UkOUFQg5BlnVgTX1XUFL0ny2LGPb94F5JlbJTT9eQhYD64AABNoOPKsj/HPxynLs/Oz+rAj15oZBGKT79ZpXo3eAskCVGXuKw6ROAxm6wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQd+Dd8Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0081EC4CEF7;
	Thu,  5 Feb 2026 09:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770282516;
	bh=OhN6+wIzAdohK1eS9qgSF+1gf6+BUDXfBSY8Drbw8Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQd+Dd8Zhz/GIod6nkHUsaqxd5zPmnIgAdiFm0vowNhp/PfN97UlbOygWdyu0Q59i
	 xNG7kdHu2qRAu9YmTdPqZIOWz9JP0DYMSsrca6DgVnXo5Cy0P9jB0b5N+/pL42pEkI
	 s1MJ1Q4u94BwYaqbMro1fOL1T/VXO006fwsLeqn9x6WHxYTObrVuWyoj0NmQ9Mk/cG
	 5uF0tBlChvsWgHvweZ/SMNGjvqHc9D1VZVu0lGm6iJP5UNBmBd8vmjkw/NkbvmcARk
	 u6kqoVuvkqcnJdlT5NAn9L+z57CIMkxuxpIAc284p8bhdUCR7DSnFB9kIZUDo/TPZY
	 fXWJubhWYMFag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vnvLl-00000008kzS-2WCB;
	Thu, 05 Feb 2026 09:08:33 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 00/20] KVM: arm64: Generalise RESx handling
Date: Thu,  5 Feb 2026 09:08:30 +0000
Message-ID: <177028250536.3562664.3454274373045269376.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202184329.2724080-1-maz@kernel.org>
References: <20260202184329.2724080-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70314-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,hcr_el2.rw:url]
X-Rspamd-Queue-Id: 0EB9AF09E1
X-Rspamd-Action: no action

On Mon, 02 Feb 2026 18:43:09 +0000, Marc Zyngier wrote:
> Having spent some time dealing with some dark corners of the
> architecture, I have realised that our RESx handling is a bit patchy.
> Specially when it comes to RES1 bits, which are not clearly defined in
> config.c, and rely on band-aids such as FIXED_VALUE.
> 
> This series takes the excuse of adding SCTLR_EL2 sanitisation to bite
> the bullet and pursue several goals:
> 
> [...]

Applied to next, thanks!

[01/20] arm64: Convert SCTLR_EL2 to sysreg infrastructure
        commit: d43f2741ca535e12c8030741d517a790db6e187e
[02/20] KVM: arm64: Remove duplicate configuration for SCTLR_EL1.{EE,E0E}
        commit: 72ac893be5c0d57891948401c028600ad019e850
[03/20] KVM: arm64: Introduce standalone FGU computing primitive
        commit: 7b5359a603e96a5faafe12fca85726416ccf8f0d
[04/20] KVM: arm64: Introduce data structure tracking both RES0 and RES1 bits
        commit: bb006d5aeaf6e2860d380f02cdb8c5504906c77c
[05/20] KVM: arm64: Extend unified RESx handling to runtime sanitisation
        commit: 7e28686832b96196da8eac9373fd33b8067be095
[06/20] KVM: arm64: Inherit RESx bits from FGT register descriptors
        commit: 834538c146f7d902419c657cbc43c30eb51ff499
[07/20] KVM: arm64: Allow RES1 bits to be inferred from configuration
        commit: 459fc4e77e1ac932e47cb4a6d1a01b3be79fd41c
[08/20] KVM: arm64: Correctly handle SCTLR_EL1 RES1 bits for unsupported features
        commit: 8d4281d7fcad4d5724d368564510f30f23fcc454
[09/20] KVM: arm64: Convert HCR_EL2.RW to AS_RES1
        commit: c6c22eeb9ee94bee87db5f44f2ea7f4819cd5413
[10/20] KVM: arm64: Simplify FIXED_VALUE handling
        commit: 8d94458263bb2d44d8ba461327a1e18c05cfc453
[11/20] KVM: arm64: Add REQUIRES_E2H1 constraint as configuration flags
        commit: ad90512f12fef5506d1f72cdfbd720eb701eab8c
[12/20] KVM: arm64: Add RES1_WHEN_E2Hx constraints as configuration flags
        commit: d406fcb2030e3efe2c5a7f043028cb3727f522d8
[13/20] KVM: arm64: Move RESx into individual register descriptors
        commit: 4afc6f9ee5ed2fc0e76fe403dd0d60b638f252b2
[14/20] KVM: arm64: Simplify handling of HCR_EL2.E2H RESx
        commit: d764914990e086ffec042e81fd811aa8d731937c
[15/20] KVM: arm64: Get rid of FIXED_VALUE altogether
        commit: 791dfac623f9c0133ddbde66380126382e8799a3
[16/20] KVM: arm64: Simplify handling of full register invalid constraint
        commit: d5b907e197027352c8d02e15042c1c740e1e3b70
[17/20] KVM: arm64: Remove all traces of FEAT_TME
        commit: ca9a07fbebae715ebbfbe88e38d30c3f0a44e384
[18/20] KVM: arm64: Remove all traces of HCR_EL2.MIOCNCE
        commit: ab74a4ed036752c37aa2b9edac89bdb325f08acc
[19/20] KVM: arm64: Add sanitisation to SCTLR_EL2
        commit: d3a87aeadf8ec9f96a6afe9542a6aeeb1542df7a
[20/20] KVM: arm64: Add debugfs file dumping computed RESx values
        commit: 917fac520cbfc4dcdf10a427ca5b917445ceea68

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




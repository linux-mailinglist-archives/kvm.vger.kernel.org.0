Return-Path: <kvm+bounces-71052-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aOZUJaM8j2mtNgEAu9opvQ
	(envelope-from <kvm+bounces-71052-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:00:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 02EF3137602
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C18CA3033F87
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 14:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBC373612C3;
	Fri, 13 Feb 2026 14:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BmWDoQfM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9A11C5D44;
	Fri, 13 Feb 2026 14:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770994710; cv=none; b=mSrJjyfPpsICgSwpNKmUXsCcLWKHGacAtB16GONsDdnKtb4cwo+rfeoD08r0mVk9On62GTvS33kRPnSx+LAp1CtEtd26neCxymBBJbk/IuHVZ0E0ntIob8mACJqGaLLnUQI3sLtDRI5DhTJVEN+mGLgJd4Q3ehJORNrUDTo16F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770994710; c=relaxed/simple;
	bh=a1VABnZngA4STd31yo3YpGNkB/nSTL3k7/EUbnDUuX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZiZoAiLP/D9Y4A4w3oN1gZoXmyUEvmFbf21FBpaTImhqxGXmOcEtabRLJSNtD32IeAVDD4M6Tmyq5BsnfQ64ufdJCNv+/ZKS7WaG44a5WXfMIOgWsVGivSo52Bhhh3N3QDKrzM12pACz1w+L3sZ2NQ3i1aan09w1Isbn6y0Y+7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BmWDoQfM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A7FC116C6;
	Fri, 13 Feb 2026 14:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770994709;
	bh=a1VABnZngA4STd31yo3YpGNkB/nSTL3k7/EUbnDUuX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmWDoQfMXvwoMpDQnT0qo95sgLPwmcQFWK5jRYNRISQh/kuuKyAgtCXKMEOQTO3RG
	 d5/UL4eSLVcXTxTntoO4Fhi9s4TQVUnv/muUK5AlRx+Em2LpJx8D8camQjQAkxO0H6
	 MkxBGn6DpyoW343tdRFWLQB/KQ0uFnKq0x999ZX4H6hQN1y0j8FCkXRMZHj5wBVK5p
	 jF5poC5wR8J3kAI2GCbbkMckPT7YzzbYkjN/lATW7DAs2gmAMdTQ9GaHbagnRD/qOP
	 hKSumNH4pffUzhWIPG0us74MWcourR8Yt4HeYb+EQYWW998aDGyo8zvCuNmwkuRjlz
	 QnTCvMQRRWfNA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vqucl-0000000AuM4-244w;
	Fri, 13 Feb 2026 14:58:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	stable@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Fix guest feature sanitization and pKVM state synchronization
Date: Fri, 13 Feb 2026 14:58:24 +0000
Message-ID: <177099469863.1792134.7316507430953466702.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260213143815.1732675-1-tabba@google.com>
References: <20260213143815.1732675-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, tabba@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, stable@vger.kernel.org, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-71052-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 02EF3137602
X-Rspamd-Action: no action

On Fri, 13 Feb 2026 14:38:11 +0000, Fuad Tabba wrote:
> This series addresses state management and feature synchronization
> vulnerabilities in both standard KVM and pKVM implementations on arm64.
> The primary focus is ensuring that the hypervisor correctly handles
> architectural extensions during context switches to prevent state
> corruption.
> 
> Changes since v1 [1]:
> - Moved optimising away S1POE handling when not supported by host to a
>   separate patch.
> - Fixed clearing, checking and setting KVM_ARCH_FLAG_ID_REGS_INITIALIZED
> 
> [...]

Applied to fixes, thanks!

[1/4] KVM: arm64: Hide S1POE from guests when not supported by the host
      commit: f66857bafd4f151c5cc6856e47be2e12c1721e43
[2/4] KVM: arm64: Optimise away S1POE handling when not supported by host
      commit: 9cb0468d0b335ccf769bd8e161cc96195e82d8b1
[3/4] KVM: arm64: Fix ID register initialization for non-protected pKVM guests
      commit: 7e7c2cf0024d89443a7af52e09e47b1fe634ab17
[4/4] KVM: arm64: Remove redundant kern_hyp_va() in unpin_host_sve_state()
      commit: 02471a78a052b631204aed051ab718e4d14ae687

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




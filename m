Return-Path: <kvm+bounces-69247-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QBehFtDHeGmDtQEAu9opvQ
	(envelope-from <kvm+bounces-69247-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 15:12:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E6A68956C2
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 15:12:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6C2B5309D4A8
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 14:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782C031197F;
	Tue, 27 Jan 2026 14:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OhbtWIv3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76A927F00A;
	Tue, 27 Jan 2026 14:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769522948; cv=none; b=APNlWMp34iwVh6dQAxI7ToYYbXfvQiyVLMkpr+0e+seJ+xwKAqbMhDsS5ffyioQXe81BGA985kMQ8VW3tWYrLzfNh27oMTbbcJOEoQHaMCAj+92IfI6DQjAfpQA818cvHnuu+Zc3RaBNJp/H1VF/bs+x0r8RREYZ6bhuvH66QBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769522948; c=relaxed/simple;
	bh=fgeR+pqv/gwz97Tjn3lFHOd3aY5unS7fLINmGbxXt38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=usvW+t9CRiRxMg1X6Zl+i2zUPMi1uNhzmxZyGFoyTFki3a3YptKX6vLacLUJwllj9yz3YmqdBCfXB1hQ3UlC07Orp/d78fu2D70p/SUeJW9JebsXb8smgH0OmChEFl+yKCwIcOJgidjEK9LvKBMs1CvfYlPdiwLv6wwGYnyk8kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OhbtWIv3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09026C116C6;
	Tue, 27 Jan 2026 14:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769522948;
	bh=fgeR+pqv/gwz97Tjn3lFHOd3aY5unS7fLINmGbxXt38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OhbtWIv3iipk5Q5S5FsUlQxI6zyxgcORraneVhnUDRwXgeFR5gWgx9ae2y7wRaBFJ
	 SSe91tlqH32YifvmJYbD19yFVQxWQb6ylRDienrgQiELVw+86FF1PB+R0xcGniGEde
	 YgAbNJw8dD/JzmsQECoZ3im6gjN4NXXS95huG536pj6/9XVBN4CzJPlYOuUC5wSW3i
	 5Z+bOgciuCE6u7wc4fIF47jmuE42TiPX2xtwexQrNAODWs65WKZYzmvUEGTo0PBBeh
	 t7QyxbGaU8wbL5pEUifHtPvUZQxR6bdXmap9AekD4f+1UexdP43lIXBZEJMDR60WsI
	 QJNGOzGabI/+Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkjkf-000000064XW-2qtY;
	Tue, 27 Jan 2026 14:09:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: sascha.bischoff@googlemail.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: nd <nd@arm.com>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	yuzenghui@huawei.com,
	will@kernel.org,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH 0/2] Enable GICv5 Legacy CPUIF trapping & fix TDIR cap test
Date: Tue, 27 Jan 2026 14:09:03 +0000
Message-ID: <176952293346.2010102.7303410175644418702.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208152724.3637157-2-sascha.bischoff@arm.com>
References: <20251208152724.3637157-1-sascha.bischoff@arm.com> <20251208152724.3637157-2-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: sascha.bischoff@googlemail.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Sascha.Bischoff@arm.com, nd@arm.com, Joey.Gouly@arm.com, Suzuki.Poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69247-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[googlemail.com,lists.infradead.org,lists.linux.dev,vger.kernel.org,arm.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,ich_hcr_el2.tc:url]
X-Rspamd-Queue-Id: E6A68956C2
X-Rspamd-Action: no action

On Mon, 08 Dec 2025 15:28:22 +0000, Sascha Bischoff wrote:
> These changes address two trapping-related issues when running legacy
> (i.e. GICv3) guests on GICv5 hosts.
> 
> The first change enables the vgic_v3_cpuif_trap static branch on GICv5
> hosts with legacy support, if trapping is required. The missing enable
> was caught as part of debugging why UNDEFs were being injected into
> guests when the ICH_HCR_EL2.TC bit was set - the expected bahaviour
> was that KVM should handle the trapped accesses, with the guest
> remaining blissfully unaware.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: gic: Enable GICv3 CPUIF trapping on GICv5 hosts if required
      commit: da63758c1876d899031066a9d4b8050af767ceb8
[2/2] KVM: arm64: Correct test for ICH_HCR_EL2_TDIR cap for GICv5 hosts
      commit: 28e505d81766dcbe25c60d57ab9fc941cd3d38bf

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




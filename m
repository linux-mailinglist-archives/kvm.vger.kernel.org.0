Return-Path: <kvm+bounces-71815-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YIxDL727nmnwWwQAu9opvQ
	(envelope-from <kvm+bounces-71815-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 10:07:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2E7194A27
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 10:07:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7417230C5B64
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 08:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E94F328251;
	Wed, 25 Feb 2026 08:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xdf0nIHd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DE2242D76;
	Wed, 25 Feb 2026 08:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772009944; cv=none; b=de4C5LtKCRAapYrypYTdXENQ5OiZfBzThLIoYFzb47zO6nSF8UZiwgbV0ITytT9NtiShC1BhiSeB957P4OMEe2ExGaWW8OBKYv8cUmSetQCrl/jvuh37hmc1wZXBCD0g0HvlCaK6mvV0REPpzgsnvhKnOd6ACD/BnSWFgx+4M+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772009944; c=relaxed/simple;
	bh=IuIWpowmo8Xqgq3Y+onfDk5wFveKZIxmim1zX5DjEXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cy5qLr4sFS6qwFTdzRt/j0gv8xoZKDP8INIoQze87wRpM6zL7kqFz8uyBdTx9T13XBK4gOV0xSf2gEEeCUnnJiWASxVu9kWuPHZc3MwmaM+VgZr/EcjIi1uAcLx8k5htig01HJpbjTm4w13EMNawFtg6rr3GgfhyPyC+pCKDwpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xdf0nIHd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DC4C19422;
	Wed, 25 Feb 2026 08:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772009943;
	bh=IuIWpowmo8Xqgq3Y+onfDk5wFveKZIxmim1zX5DjEXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xdf0nIHdaPvZqclmpcCBZDetKJRrTJKTevPj/axoOXjXY7v2c8KGe/89TJbvCTH5M
	 5tq5+xxr3IsZoFRodycPFjYELix7m5ImM9Aya6MX4EvS34Jgz3QYnUWzfbVXkRpIp3
	 dfcfQ800ptspDtrGCisK68mmsBi8U362szXi2DrxvjV2o3WQa3S4M+mEgN/JAG0K6k
	 G0S4cc555PmB36FoK5Gx+gQjEKN9XEczQe1zX5MVZ7QrMYdji7iC+WmlbUu4Smw7C1
	 PgpMMcyu+yvsSgoqEf2000jq+fVsUCPBGvxBpxXAzI9m8lqYsIqbMX0fAqlyXrTXb6
	 oeuULsJ7bujdA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vvAjV-0000000DdIA-1uOH;
	Wed, 25 Feb 2026 08:59:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: nd <nd@arm.com>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	yuzenghui@huawei.com,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH] irqchip/gic-v5: Fix inversion of IRS_IDR0.virt flag
Date: Wed, 25 Feb 2026 08:58:58 +0000
Message-ID: <177200993275.3967978.14380203034813209994.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260225083130.3378490-1-sascha.bischoff@arm.com>
References: <20260225083130.3378490-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, Sascha.Bischoff@arm.com, nd@arm.com, Joey.Gouly@arm.com, Suzuki.Poulose@arm.com, yuzenghui@huawei.com, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71815-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0D2E7194A27
X-Rspamd-Action: no action

On Wed, 25 Feb 2026 08:31:40 +0000, Sascha Bischoff wrote:
> It appears that a !! became ! during a cleanup, resulting in inverted
> logic when detecting if a host GICv5 implementation is capable of
> virtualization.
> 
> Re-add the missing !, fixing the behaviour.
> 
> 
> [...]

Applied to fixes, thanks!

[1/1] irqchip/gic-v5: Fix inversion of IRS_IDR0.virt flag
      commit: 29c8b85adb47daefc213381bc1831787f512d89b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




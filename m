Return-Path: <kvm+bounces-71962-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oFaFFWExoGmLgAQAu9opvQ
	(envelope-from <kvm+bounces-71962-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 12:41:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id F41251A53DA
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 12:41:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 75F083036050
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 11:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 113EC377541;
	Thu, 26 Feb 2026 11:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBnlrRXs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41885A932;
	Thu, 26 Feb 2026 11:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772105912; cv=none; b=NTrWw7essieeowzLJ32h4bdW5driVu4AMIMZL1mPyYlDVkihPndNEYLXrSCUXXEXyK29piX9MeNjE4YWsaLokgTreRp4x0mxtDKwvzHcpjfpQ6aVqfBC6VSOYTphHNpAuBN19c8oEEQ5Jw65mbBA7Ls2pNVtIUged8ZcDN9URfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772105912; c=relaxed/simple;
	bh=h0LXqcIKOrvxUgaaQZFhxxdHYHkQ0+ABx+hsGmP7jz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0CutH5i5XhAm2WJh8mDOIaJB5tyG+hMoANDYFfWOIUFmI6IiKZKgB6qx5NcXoMAoUM/cMqjlJxFr8fdlKTnueWQBPnMkbRxuVC9z8n+3/r8yHTAVvt44xYBAdqTexvoghWSRWvmPJqUo9iHVhRZX34cqkCDFFftAQW59pDQNDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBnlrRXs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7972BC116C6;
	Thu, 26 Feb 2026 11:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772105911;
	bh=h0LXqcIKOrvxUgaaQZFhxxdHYHkQ0+ABx+hsGmP7jz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WBnlrRXsE6ZbQPudY3I0xHS7hZGfQ4B0Ogf5rz6MH/MzklysmhGRoocHOedAKhRSw
	 Zb9o0R1J4owSQcmJPaAoUxoPXPrJ9L51DXP2Ki820buN+4xv/he7cSfs0Loegg0lWG
	 k5HUmYffeRYsyfoOcKyrEhPtHYQjAI+3Pz4iWJ++CGqjOVzTpwDPB3sJVzyzo0q8QF
	 D+lYVWYxk6L1tAfK0zIyHoYOf1uSnEPlo3BUmV3IPkVOxVmWvxrQYmG0m10yztN8el
	 XdUAtCTmMoAW/8jMWLDx6DOFOdGgbRqD5IQpON49sXYnQF3p0xZkGn5qeIilqrZHpw
	 s/ByNyn5Zycpg==
Date: Thu, 26 Feb 2026 03:38:30 -0800
From: Oliver Upton <oupton@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, catalin.marinas@arm.com,
	will@kernel.org, maz@kernel.org, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, broonie@kernel.org, ardb@kernel.org,
	suzuki.poulose@arm.com, lpieralisi@kernel.org, joey.gouly@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v14 7/8] KVM: arm64: use CASLT instruction for swapping
 guest descriptor
Message-ID: <aaAwtrrJ-qFrqktX@kernel.org>
References: <20260225182708.3225211-1-yeoreum.yun@arm.com>
 <20260225182708.3225211-8-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225182708.3225211-8-yeoreum.yun@arm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71962-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[oupton@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F41251A53DA
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 06:27:07PM +0000, Yeoreum Yun wrote:
> +	asm volatile(__LSUI_PREAMBLE
> +		     "1: caslt	%[old], %[new], %[addr]\n"

The other two flavors of this use relaxed ordering, why can't we do the
same with LSUI?

Thanks,
Oliver


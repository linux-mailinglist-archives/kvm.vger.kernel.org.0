Return-Path: <kvm+bounces-68751-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iFd7NtsNcWlEcgAAu9opvQ
	(envelope-from <kvm+bounces-68751-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 18:33:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EE955A95A
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 18:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7B58B7EF9BD
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 16:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B17242C3254;
	Wed, 21 Jan 2026 16:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QISwPij8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7357F37F757;
	Wed, 21 Jan 2026 16:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769012444; cv=none; b=G4Rt76zdL6kJczs5tQ+TSEmV65WUD8bY51qvZIqfQvHw/+b1YTWcqKTv6LVCXF8KfAEZcjUJ2Z1EDBJDKHHynOW3ZoZKMDIlpqMbNcBs9GGdPjzL1q8SV+J+m0C6x65ZOgXqglYZ7UlB0jsr6YtUcIBib1OkWt1QV8EiZXN4LhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769012444; c=relaxed/simple;
	bh=1zrLB9YYiuSPiB+hTb+W3k1yLnlV8BF5PevPGnV9vcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZzqopF9Vk5EoULr1awQL68uyjOcF4w8VVdtGH2zRHLuf4UcDm+FSmV00AacglkYNq1wYwx7XkBIZ2+OKuxWfJ5eKXTLYlF86n5fF7V0hZ1ZzHkOxEAIpM+T9f1dKgA/NIYlinY0uz0edSY9YP7TNzbnyoErEaxD8StA7HHuJuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QISwPij8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DF4C4CEF1;
	Wed, 21 Jan 2026 16:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769012443;
	bh=1zrLB9YYiuSPiB+hTb+W3k1yLnlV8BF5PevPGnV9vcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QISwPij8Wrto3Bs19w6vqe3S2S5wUbzZBIkAYoW3q5GKX1oPPXFRUPe1kitED+Afh
	 P+qH1izc6yuCkE0EYlusxPbZ7hCHHqf21r/qBEdXvqXF7UAgd857zey6uVJ4Xgt/MW
	 MHMDvGAh7sXRHkbMW23lVMUlAD63w1vI8ZhNW+nG3uarIrZdYR0P6xaGU2GzL7GNZg
	 cXkfdI3oNMKE4jw8heAnjacEfhDglbXo4tELdNeXigasbn2JhCOYWFkj90bCGBAPGe
	 9slvHJrZgYXFftd3CHOiTy1JaF86l5T1y3z2zhubcNAzg1QVOy2RVW+DMnR6EoBJqZ
	 MUA+ohMHg8Qrw==
Date: Wed, 21 Jan 2026 16:20:36 +0000
From: Will Deacon <will@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	catalin.marinas@arm.com, broonie@kernel.org, oliver.upton@linux.dev,
	miko.lenczewski@arm.com, kevin.brodsky@arm.com, ardb@kernel.org,
	suzuki.poulose@arm.com, lpieralisi@kernel.org,
	yangyicong@hisilicon.com, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, arnd@arndb.de,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v11 RESEND 9/9] arm64: armv8_deprecated: apply FEAT_LSUI
 for swpX emulation.
Message-ID: <aXD81LT6TX32vlTS@willie-the-truck>
References: <86ms3knl6s.wl-maz@kernel.org>
 <aT/bNLQyKcrAZ6Fb@e129823.arm.com>
 <aW5O714hfl7DCl04@willie-the-truck>
 <aW6w6+B21NbUuszA@e129823.arm.com>
 <aW9O6R7v-ybhrm66@J2N7QTR9R3>
 <aW9T5b+Y2b2JOZHk@e129823.arm.com>
 <aW9sBkUVnpAkPkxN@willie-the-truck>
 <aW/Ck3M3Xg02DpQX@e129823.arm.com>
 <aXDbBKhE1SdCW6q4@willie-the-truck>
 <aXDn3iRXEtgaUtnp@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXDn3iRXEtgaUtnp@e129823.arm.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68751-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[will@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 4EE955A95A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 02:51:10PM +0000, Yeoreum Yun wrote:
> > On Tue, Jan 20, 2026 at 05:59:47PM +0000, Yeoreum Yun wrote:
> > > On second thought, while a CPU that implements LSUI is unlikely to
> > > support AArch32 compatibility,
> > > I don't think LSUI requires the absence of AArch32.
> > > These two are independent features (and in fact our FVP reports/supports both).
> >
> > Did you have to configure the FVP specially for this or that a "default"
> > configuration?
> >
> > > Given that, I'm not sure a WARN is really necessary.
> > > Would it be sufficient to just drop the patch for swpX instead?
> >
> > Given that the whole point of LSUI is to remove the PAN toggling, I think
> > we should make an effort to make sure that we don't retain PAN toggling
> > paths at runtime that could potentially be targetted by attackers. If we
> > drop the SWP emulation patch and then see that we have AArch32 at runtime,
> > we should forcefully disable the SWP emulation but, since we don't actually
> > think we're going to see this in practice, the WARN seemed simpler.
> 
> TBH, I missed the FVP configuration option clusterX.max_32bit_el, which
> can disable AArch32 support by setting it to -1 (default: 3).
> Given this, I think it’s reasonable to emit a WARN when LSUI is enabled and
> drop the SWP emulation path under that condition.

I'm asking about the default value.

If Arm are going to provide models that default to having both LSUI and
AArch32 EL0 supported, then the WARN is just going to annoy people.

Please can you find out whether or not that's the case?

Will


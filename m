Return-Path: <kvm+bounces-68610-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wGM/HwqDcGktYAAAu9opvQ
	(envelope-from <kvm+bounces-68610-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 08:40:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CD5FE52EDA
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 08:40:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BBABE80B4C2
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 11:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 203C742317F;
	Tue, 20 Jan 2026 11:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iINjgdbI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C4B3A63FF;
	Tue, 20 Jan 2026 11:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768909838; cv=none; b=VA9KjeMKcrrbUzg3EAthJiMGSc5vfP7rkY+B75i5ADNN5MxRJEnw/3ylnAd5Pad1qeoxzPBDnJqQ4WgX+Dyz74t/99EXqRUaRQirLqfJWYpTsXvd3FeRbx2uFGAKHpMWlQBby67lIvFdkrTumQYBnrDFVnkcy+lcQhm9rMlZIyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768909838; c=relaxed/simple;
	bh=fwzc7yqIuJaeQHw9CCm5cdBaBfc+5ih+Xegkbgg7jAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iUDF/vq829IrTVlJ5LjI1lO3TQf1f+H5CzpD1xsS5KClXmk6iab7tMzHBpgjxLibfwe5KobR0yOLv/k0imO8pAJX6nwUt+XilHMyj+vAdVvXE5yl+AG169sVEFrBWiDzcXiF/JJyylt8VhQ3bPiUEzxhPH2j+NYLmeogTn2pAKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iINjgdbI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC9AC16AAE;
	Tue, 20 Jan 2026 11:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768909838;
	bh=fwzc7yqIuJaeQHw9CCm5cdBaBfc+5ih+Xegkbgg7jAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iINjgdbI1V5aR8AhZ8qLkcXEaGUxqTCm+ER3WXRtrPQ4Ipsdr5FtiABTAxuRDqK58
	 N1FiFW+SK6Cev9SnwDHk0dTlDmFnEU8jMrXGIkHDJVkE6DT17rn1I967ZxcdX3XlA4
	 GNsHiFoXO4O8tnrJDxw2Z2agpi5uAy/Bai8WK2YORZ2xuezF7yJHTlW8P1w18MaiLy
	 DXwlwrbDzQrMojAA6teHCDKQ+TkNZTnEP8MopY2xujgvNifTeCj/0IzWjqYD4WPE58
	 CLIbIdZb19uSaFgbGW1CPlac5v4ZtfUEDDuhlOBQmDpzcRk1PEUHoIqDKRaky15gk2
	 wSh1njOz4d7Gw==
Date: Tue, 20 Jan 2026 11:50:30 +0000
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
Message-ID: <aW9sBkUVnpAkPkxN@willie-the-truck>
References: <20251214112248.901769-1-yeoreum.yun@arm.com>
 <20251214112248.901769-10-yeoreum.yun@arm.com>
 <86ms3knl6s.wl-maz@kernel.org>
 <aT/bNLQyKcrAZ6Fb@e129823.arm.com>
 <aW5O714hfl7DCl04@willie-the-truck>
 <aW6w6+B21NbUuszA@e129823.arm.com>
 <aW9O6R7v-ybhrm66@J2N7QTR9R3>
 <aW9T5b+Y2b2JOZHk@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW9T5b+Y2b2JOZHk@e129823.arm.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68610-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,arm.com:email]
X-Rspamd-Queue-Id: CD5FE52EDA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 10:07:33AM +0000, Yeoreum Yun wrote:
> Hi Mark,
> 
> > On Mon, Jan 19, 2026 at 10:32:11PM +0000, Yeoreum Yun wrote:
> > > > On Mon, Dec 15, 2025 at 09:56:04AM +0000, Yeoreum Yun wrote:
> > > > > > On Sun, 14 Dec 2025 11:22:48 +0000,
> > > > > > Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> > > > > > >
> > > > > > > Apply the FEAT_LSUI instruction to emulate the deprecated swpX
> > > > > > > instruction, so that toggling of the PSTATE.PAN bit can be removed when
> > > > > > > LSUI-related instructions are used.
> > > > > > >
> > > > > > > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > > > > >
> > > > > > It really begs the question: what are the odds of ever seeing a CPU
> > > > > > that implements both LSUI and AArch32?
> > > > > >
> > > > > > This seems extremely unlikely to me.
> > > > >
> > > > > Well, I'm not sure how many CPU will have
> > > > > both ID_AA64PFR0_EL1.EL0 bit as 0b0010 and FEAT_LSUI
> > > > > (except FVP currently) -- at least the CPU what I saw,
> > > > > most of them set ID_AA64PFR0_EL1.EL0 as 0b0010.
> > > >
> > > > Just to make sure I understand you, you're saying that you have seen
> > > > a real CPU that implements both 32-bit EL0 *and* FEAT_LSUI?
> > > >
> > > > > If you this seems useless, I don't have any strong comments
> > > > > whether drop patches related to deprecated swp instruction parts
> > > > > (patch 8-9 only) or not.
> > > > > (But, I hope to pass this decision to maintaining perspective...)
> > > >
> > > > I think it depends on whether or not the hardware exists. Marc thinks
> > > > that it's extremely unlikely whereas you appear to have seen some (but
> > > > please confirm).
> > >
> > > What I meant was not a 32-bit CPU with LSUI, but a CPU that supports
> > > 32-bit EL0 compatibility (i.e. ID_AA64PFR0_EL1.EL0 = 0b0010).
> > > My point was that if CPUs implementing LSUI do appear, most of them will likely
> > > continue to support the existing 32-bit EL0 compatibility that
> > > the majority of current CPUs already have.
> >
> > That doesn't really answer Will's question. Will asked:
> >
> >   Just to make sure I understand you, you're saying that you have seen a
> >   real CPU that implements both 32-bit EL0 *and* FEAT_LSUI?
> >
> > IIUC you have NOT seen any specific real CPU that supports this, and you
> > have been testing on an FVP AEM model (which can be configured to
> > support this combination of features). Can you please confirm?
> >
> > I don't beleive it's likely that we'll see hardware that supports
> > both FEAT_LSUI and AArch32 (at EL0).
> 
> Yes. I've tested in FVP model. and the latest of my reply said
> I confirmed that Marc's and your view was right.

It's probably still worth adding something to the cpufeature stuff to
WARN() if we spot both LSUI and support for AArch32.

Will


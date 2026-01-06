Return-Path: <kvm+bounces-67156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E55CF9B12
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 18:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 733AF30393CB
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 17:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56DC5355044;
	Tue,  6 Jan 2026 17:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="VL4qu+nP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XjH4X3k5"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F14D352F8F;
	Tue,  6 Jan 2026 17:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720240; cv=none; b=AaE6tXBaDZgdpdWrgIH5vxtY5Cy7oBBsN3QBE5m8cKtXQoZpTOV+kE8NiYOy2Bd04MTaDfA4gt6aYwrOb9r5Z/shbFlII3Sf04975HkuSdue9/D18fXN/DfS/2vV10J1yNtQ6jpyc3LSb8Ub6M6b7PjxpkTJ5mlNlYOrLyImNsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720240; c=relaxed/simple;
	bh=sjYVjLIpU88N0FNxAeSDQCndO50FyT2WQHOAUo3znrc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K9V40BWTgjdlCknkkZTtCMpyS2bnX6dalHWu6rLdvLPtagkZH8qgS+jba/gFNf0LLAGXFBzTcjf13KEfAIiUpII7Kj3rOM3hVrk9RgFvJLqEOLesmyN7mHOocRWlhLmvdn8SJg9ZE/WToKTPyPtU7iPMwPfYdmG+g6lZlSBB2OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=VL4qu+nP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XjH4X3k5; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id 5F54B1D00116;
	Tue,  6 Jan 2026 12:23:56 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Tue, 06 Jan 2026 12:23:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1767720236;
	 x=1767806636; bh=TrczBjp9CgnuX9dZjVpLH4g9fi4Rskt0vtReSN19ZN0=; b=
	VL4qu+nPxoM85+rjJAo2NX0KADvl0y9u+jbRY+ONMiihUShuUBFgpRPqd8Ae+0rc
	ytcJbOo01z+Dp+q2XNNBGWffEIEbfcVa+nsn6OJWqwo59+sHa63QcP6qV7qx1FSu
	eaLI0DC9CLyksCITD6K2opUMDxZcrv5RWU+5epyKUiRlezX3ZNxTZe1KwheK4fPY
	d+plAuRl4q4FYqYk38czra4e3RCuMQj+qWrxu7kzO5y3sT8aAnL7hzWu9b6su6ci
	DPpkFg6iYGwIrrn/4kXT9zivTkWLPbfdPbbgdDTENxQ+1vjwZptK9rynJbTU/Md8
	beiZV2KZd61HqIO6rVoPcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1767720236; x=
	1767806636; bh=TrczBjp9CgnuX9dZjVpLH4g9fi4Rskt0vtReSN19ZN0=; b=X
	jH4X3k5+zIE8UxbHHbmBXHSDeJm9wNQM7G2PCzApycjSI9D13M/07wK+96lnE7kn
	dDvBmEa3ymlbIx3JfRANEZLnJ0xsWlVFvhbVS+R2dwxzvJsY3F70tqm1Tk7jPBpk
	1vu2x+L3phWlX4P5CB4thJTWteM4Fp+0YKiiDXxPMk2I68W++TWliWq7GN8Vj7kT
	Rx1qsjNGUgQTW8jhW5mYvne4mew3OL8q7JRlwO6iOuLycus0OrznLdrXmTz6IJOF
	iqSrpTdbGXWcjp/eG0BVCfMkwt7v0TE7VSKHPxDiCr2Qe3GTd8MDB+S6X9wkRd4d
	UBuZioNAsOxyrv5XxDPeg==
X-ME-Sender: <xms:LEVdaTv_EX7YJYF9h1Yu20noOron-xxzrZi5xuQ38bCJYpK4aJpzVQ>
    <xme:LEVdaSS8fCYjJiwsWZf_8YCrQVv4XLM5XnOkO6BYEpAWtV-Cc4v7nHosDJ7oQ46Eo
    EXd1rFAnRXxxCCQORkC-M9NaYo_Iw7oPs5AGq19B1frnr97UEk>
X-ME-Received: <xmr:LEVdaROplcooSQX6yma18_kLRiBg111T4v8Dbiacw7HOX_6S49P52eF1z7E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddutddtjeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthhqredttddtjeenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepfeehudevjefhgeeileeijefgtddugeetleevvefhvdegueegieevkeekheeg
    tdeknecuffhomhgrihhnpehprhhogihmohigrdgtohhmnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhg
    pdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehprg
    htrhhitghkrdifrdgsihgrnhgthhhisehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhi
    nhhugidqphgtihesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvhhmse
    hvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsghhvghlghgrrghssehgohho
    ghhlvgdrtghomh
X-ME-Proxy: <xmx:LEVdafZcul1rXVUb4WHSoSHxJZ0WfrejLkqnhK41BMT06_EjeicH8Q>
    <xmx:LEVdaTyskeZ0mbAkQJ9RNwh_FLG3BuiP1DiKso7dKEBJEiCm42gDpg>
    <xmx:LEVdaSIkQfeus1i1AmGiO8GxsPltEwnMBBaFq3btO7ZdpzbLaZ2R2w>
    <xmx:LEVdaVqBnTsEiFIK85-zu9AVedSwvuKtO7FyN20yCmI0ZL5CIZ-6QA>
    <xmx:LEVdaXzJqq6WvOECNNWbWgjRlN7me4zRQGvlOBHpGWpZTbCHLg5jf6st>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Jan 2026 12:23:55 -0500 (EST)
Date: Tue, 6 Jan 2026 10:23:54 -0700
From: Alex Williamson <alex@shazbot.org>
To: Patrick Bianchi <patrick.w.bianchi@gmail.com>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, Bjorn Helgaas
 <bhelgaas@google.com>
Subject: Re: PCI Quirk - UGreen DXP8800 Plus
Message-ID: <20260106102354.4b84b4a7.alex@shazbot.org>
In-Reply-To: <26F3F2EE-37D4-4F73-9A51-EDD662EBEFF2@gmail.com>
References: <A005FF97-BB8D-49F6-994F-36C4A373FA59@gmail.com>
	<26F3F2EE-37D4-4F73-9A51-EDD662EBEFF2@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Dec 2025 18:37:32 -0500
Patrick Bianchi <patrick.w.bianchi@gmail.com> wrote:

> Hello everyone.  At the advice of Bjorn Helgaas, I=E2=80=99m forwarding t=
his
> message to all of you.  Hope it=E2=80=99s helpful for future kernel revis=
ions!

I'm not sure what the proposed change is, but the comment at the end of
the previous message seems to be leading to the quirk_no_bus_reset
patch proposed here:

https://forum.proxmox.com/threads/problems-with-pcie-passthrough-with-two-i=
dentical-devices.149003/#post-803149

IIRC QEMU will favor the bus reset if the device otherwise only
supports PM reset and interfaces like reset_method only influence the
reset-function path rather than the bus/slot reset interface available
through the vfio-pci hot reset ioctl.

Disabling bus reset appears reasonable given the corroboration in the
thread and the fact that the device still seems to support PM reset.

Do you confirm the quirk you were testing is:

DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ASMEDIA, 0x1164, quirk_no_bus_reset);

ie. vendor:device ID 1b21:1164?

Thanks,
Alex

> Begin forwarded message:
>=20
> From: Patrick Bianchi <patrick.w.bianchi@gmail.com>
> Subject: PCI Quirk - UGreen DXP8800 Plus
> Date: December 20, 2025 at 9:56:10=E2=80=AFPM EST
> To: bhelgaas@google.com
>=20
> Hello!
>=20
> Let me start this off by saying that I=E2=80=99ve never submitted anything
> like this before and I am not 100% sure I=E2=80=99m even in the right pla=
ce.
> I was advised by a member on the Proxmox community forums to submit
> my findings/request to the PCI subsystem maintainer and they gave me
> a link to this e-mail.  If I=E2=80=99m in the wrong place, please feel fr=
ee
> to redirect me.
>=20
> I stumbled upon this thread
> (https://forum.proxmox.com/threads/problems-with-pcie-passthrough-with-tw=
o-identical-devices.149003/)
> when looking for solutions to passing through the SATA controllers in
> my UGreen DXP8800 Plus NAS to a Proxmox VM.  In post #12 by user
> =E2=80=9Ccelemine1gig=E2=80=9D they explain that adding a PCI quirk and b=
uilding a
> test kernel, which I did - over the course of three days and with a
> lot of help from Google Gemini!  I=E2=80=99m not very fluent in Linux or =
this
> type of thing at all, but I=E2=80=99m also not afraid to try by following
> some directions.  Thankfully, the proposed solution did work and now
> both of the NAS=E2=80=99s SATA controllers stay awake and are passed thro=
ugh
> to the VM.  I=E2=80=99ve pasted the quirk below.
>=20
> I guess the end goal would be to have this added to future kernels so
> that people with this particular hardware combination don=E2=80=99t run i=
nto
> PCI reset problems and don=E2=80=99t have to build their own kernels at e=
ver
> update.  Or at least that=E2=80=99s how I understand it from reading thro=
ugh
> that thread a few times.
>=20
> I hope this was the right procedure for making this request.  Please
> let me know if there=E2=80=99s anything else you need from me.  Thank you!
>=20
> -Patrick Bianchi
>=20
>=20
>=20
> C:
> /*
> * Test patch for Asmedia SATA controller issues with PCI-pass-through
> * Some Asmedia ASM1164 controllers do not seem to successfully
> * complete a bus reset.
> */
>=20



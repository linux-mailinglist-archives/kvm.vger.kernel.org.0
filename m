Return-Path: <kvm+bounces-10548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 724FB86D3C1
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 20:54:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28AC8287A80
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 19:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A1AC142903;
	Thu, 29 Feb 2024 19:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pjd.dev header.i=@pjd.dev header.b="MRCduglQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OCqkEO0D"
X-Original-To: kvm@vger.kernel.org
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C7F1428ED;
	Thu, 29 Feb 2024 19:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.111.4.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709236435; cv=none; b=CKtmVzfIyyjT7lPc/8VVQ8yaV25IwqLgBBNoPgBm5HqGPfTlFcxkDPv3ZCiIe2XVukK1PTMfTo/B4X/PGedW2NHqER5bo4dHxPNshn5oCptfWJMmnySG23WVx+jnLBHeoDbhipxjYv8EvflmjQdAYyYmZlmyX+KrS9ddHnKuzZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709236435; c=relaxed/simple;
	bh=jthKmHH9qkCJL1rwJwt8b2jErTogMsGgAUEXSYO24Yw=;
	h=From:Content-Type:Mime-Version:Subject:Date:In-Reply-To:Cc:
	 References:Message-Id; b=HjNlqxFZlM4NQLEoAzRcu/oGFyjl1jE51X9s/goOSSXAnxaLWoDN85NnNyl5Qa/DQnOi7brhyl1kf1yji+1rdLShWBjzNT751orlFseZYQ2Fu5rE+/rxNU4yvD9b9eK4QxeB63fslkrb/vmLYSnBiVQGjXh3rsST4/lKF4HiATg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pjd.dev; spf=pass smtp.mailfrom=pjd.dev; dkim=pass (2048-bit key) header.d=pjd.dev header.i=@pjd.dev header.b=MRCduglQ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OCqkEO0D; arc=none smtp.client-ip=66.111.4.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pjd.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pjd.dev
Received: from compute7.internal (compute7.nyi.internal [10.202.2.48])
	by mailout.nyi.internal (Postfix) with ESMTP id 51E785C005D;
	Thu, 29 Feb 2024 14:53:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Thu, 29 Feb 2024 14:53:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pjd.dev; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to; s=fm2; t=1709236432; x=
	1709322832; bh=M6rbw+n+N/w7eLH273TiruvrBg5kCYrlH64w/wGT6BE=; b=M
	RCduglQ26s2yEjvTWgEx6I1ewsYbU+20i4Z1Fx8vBy3oeMwZGTJsJ1+U994l+jkz
	++L+pcn8/y4qSpBlFBNzj6Gfrnir/WEIz/GDN18PEjRzKJHO2r77JA9fNcNOQiZy
	//BvVlFPwGxQuiUfd4FEQQk2hyz62f38PT+El97C1JsD0s2XuEf3rtmBjEKvg4Gj
	guem2TQ3+p2/2S96IJljZvvDoU3WZgRgjpLP7phbSCgmA/XeP+NusQCyvLVbcZ3J
	OOy2ihFl1GLtDUj5ERXtQWYyojAVRRPugvE/Gq23ZRAR3Z0GB57lFZLWvveVFmeY
	s+ZD0RhrOoHvYeWE6CDlQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1709236432; x=
	1709322832; bh=M6rbw+n+N/w7eLH273TiruvrBg5kCYrlH64w/wGT6BE=; b=O
	CqkEO0DvDTpEFyxxN1l26pty9a/06rQgGuKiB+F7L2R2aUPZjJ9BafSWil98zPij
	pNTb09Lw0CTca1fSMX5Ldee60EIDdCo4X3+wHnTs8j4/8YYYBW+EahliDj8hQ1e3
	f3dVVUvWfd6eH/TSY2hfzO/wvDhr7hOirE5SHwXzBdkOC4TR4DgDkLQNjmyasglS
	mVpSIFXIuJFu00Le4C2fuRuDitAZISVOtr6+ojCE3AwyYnMcaBeh09HGgDWa7pGX
	zRQySiyeP5tdDMvTIRA2aBmrL8eHJFD3KpgUC6vogO+0/Sjcswzjqw5QxnHoA0Ls
	5t1qIlkKdP9Xxy4DdOobA==
X-ME-Sender: <xms:0ODgZYhQJiJZ8e8CxidGqvAUQvWY2uP42x_FpRpmC8qfe7spo4qt4Q>
    <xme:0ODgZRCWAGwMurvef3OvjOAwD4JywlxqmiVR-cECLzxdiyPc0eRwv8A9h3wcizRfC
    AM7E7XsGaKoU7RU500>
X-ME-Received: <xmr:0ODgZQGdMrH1sbmw07PB1Mv506CikCgtFNo7DHQzgStY_wa-dTPTNeY5qvzlJ4k0uMlHkz0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrgeelgdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenuchmihhsshhinhhgucfvqfcufhhivghlugculdeftd
    dmnecujfgurhephfgtgfggufffjgevfhfkofesthhqmhdthhdtjeenucfhrhhomheprfgv
    thgvrhcuffgvlhgvvhhorhihrghsuceophgvthgvrhesphhjugdruggvvheqnecuggftrf
    grthhtvghrnhepledvleeijedtteffudfhkeduheeludefgfeuveekheekvefhfffhffeh
    ieeifeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epphgvthgvrhesphhjugdruggvvh
X-ME-Proxy: <xmx:0ODgZZQra8s9NrKYILgCsPHGziVk5PK6CQUEYLNT3jOGF55DZA5xcQ>
    <xmx:0ODgZVxKfKaJXuS9nQ9pNluWXLInu-7dM2Bar0Syb-suaMEs_P6b_Q>
    <xmx:0ODgZX7tcGNY2ZTDdXgg4EwnoQNqCkZS0_9nh897giTD31Op3Wu-Qw>
    <xmx:0ODgZcnnaCFXPoYGS5hc8uT3M-zpslxBKte70xWrye0IsH1TXnmWng>
Feedback-ID: i9e814621:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Feb 2024 14:53:51 -0500 (EST)
From: Peter Delevoryas <peter@pjd.dev>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.400.31\))
Subject: Re: [q&a] Status of IOMMU virtualization for nested virtualization
 (userspace PCI drivers in VMs)
Date: Thu, 29 Feb 2024 11:53:39 -0800
In-Reply-To: <20240228123810.70663da2.alex.williamson@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>,
 suravee.suthikulpanit@amd.com,
 iommu@lists.linux.dev,
 kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 alex.williamson@redhat.com,
 Peter Delevoryas <peter@pjd.dev>
References: <3D96D76D-85D2-47B5-B4C1-D6F95061D7D6@pjd.dev>
 <20240228123810.70663da2.alex.williamson@redhat.com>
Message-Id: <D4DDA526-5E5D-40DB-86EF-B4B6D7692663@pjd.dev>
X-Mailer: Apple Mail (2.3774.400.31)



> On Feb 28, 2024, at 11:38=E2=80=AFAM, Alex Williamson =
<alex.williamson@redhat.com> wrote:
>=20
> On Wed, 28 Feb 2024 10:29:32 -0800
> Peter Delevoryas <peter@pjd.dev> wrote:
>=20
>> Hey guys,
>>=20
>> I=E2=80=99m having a little trouble reading between the lines on =
various
>> docs, mailing list threads, KVM presentations, github forks, etc, so
>> I figured I=E2=80=99d just ask:
>>=20
>> What is the status of IOMMU virtualization, like in the case where I
>> want a VM guest to have a virtual IOMMU?
>=20
> It works fine for simply nested assignment scenarios, ie. guest
> userspace drivers or nested VMs.
>=20
>> I found this great presentation from KVM Forum 2021: [1]
>>=20
>> 1. I=E2=80=99m using -device intel-iommu right now. This has =
performance
>> implications and large DMA transfers hit the vfio_iommu_type1
>> dma_entry_limit on the host because of how the mappings are made.
>=20
> Hugepages for the guest and mappings within the guest should help both
> the mapping performance and DMA entry limit.  In general the type1 =
vfio
> IOMMU backend is not optimized for dynamic mapping, so =
performance-wise
> your best bet is still to design the userspace driver for static DMA
> buffers.

Yep, huge pages definitely help, will probably switch to allocating them =
at boot for better guarantees.

>=20
>> 2. -device virtio-iommu is an improvement, but it doesn=E2=80=99t =
seem
>> compatible with -device vfio-pci? I was only able to test this with
>> cloud-hypervisor, and it has a better vfio mapping pattern (avoids
>> hitting dma_entry_limit).
>=20
> AFAIK it's just growing pains, it should work but it's working through
> bugs.

Oh really?? Ok: I might even be configuring things incorrectly, or
Maybe I need to upgrade from QEMU 7.1 to 8. I was relying on whatever
libvirt does by default, which seems to just be:

    -device virtio-iommu -device vfio-pci,host=3D<bdf>

But maybe I need some other options?

>=20
>> 3. -object iommufd [2] I haven=E2=80=99t tried this quite yet, =
planning to:
>> if it=E2=80=99s using iommufd, and I have all the right kernel =
features in
>> the guest and host, I assume it=E2=80=99s implementing the =
passthrough mode
>> that AMD has described in their talk? Because I imagine that would be
>> the best solution for me, I=E2=80=99m just having trouble =
understanding if
>> it=E2=80=99s actually related or orthogonal.
>=20
> For now iommufd provides a similar DMA mapping interface to type1, but
> it does remove the DMA entry limit and improves locked page =
accounting.
>=20
> To really see a performance improvement relative to dynamic mappings,
> you'll need nesting support in the IOMMU, which is under active
> development.  =46rom this aspect you will want iommufd since similar
> features will not be provided by type1.  Thanks,

I see, thanks! That=E2=80=99s great to hear.

>=20
> Alex
>=20



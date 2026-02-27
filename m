Return-Path: <kvm+bounces-72198-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UA6wAPrboWlcwgQAu9opvQ
	(envelope-from <kvm+bounces-72198-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 19:01:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AC961BBBB9
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 19:01:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A922D308D37E
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CA84364053;
	Fri, 27 Feb 2026 17:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="aat5WdRO";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WxqmtJcO"
X-Original-To: kvm@vger.kernel.org
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F417F36E46D;
	Fri, 27 Feb 2026 17:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772215053; cv=none; b=BlAd+/fKVrt1GNCRMITffY3iUqSSFSowNFDnqPa+nBKEF95AbXr4QN2h1K6KKXmiJL1//TJaMZx3mLqlE9xGJ92+cEIAlKAZRNNj6eVmYp8D6F1UpcI07GomIfouJMIZno3Q6CdnEj23sp9kNvKHDbHzfyMgF4q7DQGFPy6n9XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772215053; c=relaxed/simple;
	bh=S6KawJbtcVXw3+duC5lB0oRS2LBKKrK2JTZCmWJ4tlw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n8zaMWsNC3JLgh/tx3+GopSZ2E8mO3hu9/w4SHQpBo7px9p/Z2sgWUZ3R8j+fRDrwxD361+emvQIgDZhg/s1Lprp1kXn5/Gd61BdcReQnFBj5w1Yp15ZcTRpvz+BynJxIWINmBNTW4qPb3bmQEJWfQp/YJaXxTebcVO15Or5nmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=aat5WdRO; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WxqmtJcO; arc=none smtp.client-ip=202.12.124.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 3F62C1300E62;
	Fri, 27 Feb 2026 12:57:27 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 27 Feb 2026 12:57:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772215047;
	 x=1772222247; bh=K2yQm0oOGTcRJfhcrEhEmD0poePPSAOAfmgoK4/aZLQ=; b=
	aat5WdROMFK4MIAhDBYWwdq0MIcDck8De3aplVKiAQDST6EhMB5PcW5tdYpMASS+
	Lwzt8PZ2t/Vks2Gz4X5ZD6pdN26+IdzlXQZqudjRIN25E+9WKMhgqSWnxhjoWCuU
	Vvy+OwWxDo/e5yr0fnLuFRHymkkXqvE8y6wWzNE3Ojj+EoITsFc3+feRRhqKx7uw
	QCtWIHCyzSB2nG8tHB3q5wtWzmKHRV3bhThUKDX8lSL5eLjDzt9Ltx1XWwPicyHc
	gBFcO+3nfj61Pc3XM1/KVRAyL71hj680c6ci4mtUugl5CjPxlzT1d41uQ+cB3Kjw
	/SxMAZO1OqzqUyUmadPSPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772215047; x=
	1772222247; bh=K2yQm0oOGTcRJfhcrEhEmD0poePPSAOAfmgoK4/aZLQ=; b=W
	xqmtJcO9/vYtHkLC8ry/T0H4riRZtlEP84tsZsbvOF7uyDV2DhRDT9EFxWz8XiZ3
	5YimAM/blxiy5DiQdzLbwfFBeoCdw5gLmTW9CVQOea7C3zb0AyB1sf1XS+wmfv3Q
	Ds3c8w7JL5YsaMfC5Al7JyE92WwHtRZLH8a0uMk94qa9MVsfoP6yhSuvimDw6m7/
	0Vz8KIDNfDn+zdyVaa/tMTWGIwc8UccFyxqFQglgrsg4CseIls3XRYZIDO4ePIei
	HCyVzy589uVArJ51VYsNvO/jUSHwDM0rW/z2eNUHdq2EX5myg0+WDdo9RdMlxi0o
	IsS6cWHKbOS2VNTCGTGUw==
X-ME-Sender: <xms:BtuhaeIZ2jS2UzpJd553k8XHA1Sp13wdZhBu7QQZtWIcByVOCp_UKg>
    <xme:BtuhaS8hJK-hkPnFru1C9zc1y9z6dwFIhx7qBKUOL3_IP1aZ0UeNjHLjD_ZPtaIJb
    Ap74DRRikSk2ywtNYvGEudDqP4xYKNin3E1E33BFNp5CKHwOsAWgQ>
X-ME-Received: <xmr:BtuhaS7gLyrUe-l3rxzVCz0cLdnzfbW-UmoTkvJBStG9ul5e7o1ztrntfSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelieeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeegudevhfejueefveduieeuueeifeettdekveekhffgvdetfeelueehgfdt
    heffhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepgeehpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopegumhgrthhlrggtkhesghhoohhglhgvrdgtohhmpd
    hrtghpthhtoheprghjrgihrggthhgrnhgurhgrsehnvhhiughirgdrtghomhdprhgtphht
    thhopehgrhgrfhesrghmrgiiohhnrdgtohhmpdhrtghpthhtoheprghmrghsthhrohesfh
    gsrdgtohhmpdhrtghpthhtoheprghpohhpphhlvgesnhhvihguihgrrdgtohhmpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopegrnhhkihhtrgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepsghhvghlghgrrghs
    sehgohhoghhlvgdrtghomhdprhgtphhtthhopegthhhrihhslheskhgvrhhnvghlrdhorh
    hg
X-ME-Proxy: <xmx:BtuhaRgx07S3OQW05vQUdMULcKyIxw-lTak2T16g5_r3LQCchEXMMw>
    <xmx:BtuhaZgs_wOwuGV3uCTzdlPxPYWSRXfna-r2yxAr8x8ogV-5YZqCiQ>
    <xmx:BtuhaX1nJjDQ-xPKXDYD3-xh--mPBEI78fmknqtRndSlh83yiY3kdg>
    <xmx:BtuhaUhbU6JSFEpTI_Y42gSPmoFE2aI-6lqMPTHvgr6MwH-vurp96w>
    <xmx:B9uhaXpqlDvWlnCcYlLipLPhEwUJg3Efvxe_E5IjWKRMOlvzQntJDuNL>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 12:57:22 -0500 (EST)
Date: Fri, 27 Feb 2026 10:57:20 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
 Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
 kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
 Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Lukas Wunner <lukas@wunner.de>,
 =?UTF-8?B?TWlj?= =?UTF-8?B?aGHFgg==?= Winiarski
 <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>,
 Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?= <thomas.hellstrom@linux.intel.com>,
 Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Zhu Yanjun <yanjun.zhu@linux.dev>, alex@shazbot.org
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <20260227105720.522ca97f@shazbot.org>
In-Reply-To: <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-11-dmatlack@google.com>
	<20260226170030.5a938c74@shazbot.org>
	<aaDqhjdLyf1qSTSh@google.com>
	<20260227084658.3767d801@shazbot.org>
	<CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev,shazbot.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72198-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,shazbot.org:mid,shazbot.org:dkim,shazbot.org:email,messagingengine.com:dkim]
X-Rspamd-Queue-Id: 9AC961BBBB9
X-Rspamd-Action: no action

On Fri, 27 Feb 2026 09:07:48 -0800
David Matlack <dmatlack@google.com> wrote:

> On Fri, Feb 27, 2026 at 7:47=E2=80=AFAM Alex Williamson <alex@shazbot.org=
> wrote:
> >
> > On Fri, 27 Feb 2026 00:51:18 +0000
> > David Matlack <dmatlack@google.com> wrote:
> > =20
> > > On 2026-02-26 05:00 PM, Alex Williamson wrote: =20
> > > > On Thu, 29 Jan 2026 21:24:57 +0000
> > > > David Matlack <dmatlack@google.com> wrote: =20
> > > > >
> > > > > - vdev->reset_works =3D !ret;
> > > > >   pci_save_state(pdev);
> > > > >   vdev->pci_saved_state =3D pci_store_saved_state(pdev); =20
> > > >
> > > > Isn't this a problem too?  In the first kernel we store the initial,
> > > > post reset state of the device, now we're storing some arbitrary st=
ate.
> > > > This is the state we're restore when the device is closed. =20
> > >
> > > The previous kernel resets the device and restores it back to its
> > > post reset state in vfio_pci_liveupdate_freeze() before handing off
> > > control to the next kernel. So my intention here is that VFIO will
> > > receive the device in that state, allowing it to call
> > > pci_store_saved_state() here to capture the post reset state of the
> > > device again.
> > >
> > > Eventually we want to drop the reset in vfio_pci_liveupdate_freeze() =
and
> > > preserve vdev->pci_saved_state across the Live Update. But I was hopi=
ng
> > > to add that in a follow up series to avoid this one getting too long.=
 =20
> >
> > I appreciate reviewing this in smaller chunks, but how does userspace
> > know whether the kernel contains a stub implementation of liveupdate or
> > behaves according to the end goal? =20
>=20
> Would a new VFIO_DEVICE_INFO_CAP be a good way to communicate this
> information to userspace?

Sorry if I don't have the whole model in my head yet, but is exposing
the restriction to the vfio user of the device sufficient to manage the
liveupdate orchestration?  For example, a VFIO_DEVICE_INFO_CAP pushes
the knowledge to QEMU... what does QEMU do with that knowledge?  Who
imposes the policy decision to decide what support is sufficient?
Thanks,

Alex


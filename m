Return-Path: <kvm+bounces-72238-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YCqEGYoZoml7zQQAu9opvQ
	(envelope-from <kvm+bounces-72238-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:24:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C7D451BEABA
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:24:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 36498307B7F1
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 22:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A18D47AF64;
	Fri, 27 Feb 2026 22:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="ibyQ9xq8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="heYMklfx"
X-Original-To: kvm@vger.kernel.org
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A955D322B6D;
	Fri, 27 Feb 2026 22:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772231024; cv=none; b=a31slK/B4aEQn99GEZgx22nbTX5S855KWZk9hWQgjj6LCf7FaVGUGm8/ax3dH1nlxPPlebDmbvaBN0d7kkK2v/kL/06xfpwFdQyx1wN33W/KBiwqLyyEo/D4kHrSMVeiYcUP8smRj3uweeh0vRu7fjTF6jnoGYTru4z1x7CN6c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772231024; c=relaxed/simple;
	bh=KBMAvSvDQckqME7TpGCiPOU7XymSowZAfDJAaO+tQHY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SFdXC659GFILCXk/KnG7aO1FWugeKmz8uka3Q9kwGoSMsosNdBRDsC6smJgfF0V/RJlXCjBtvm4jDTurZdF+nanyuCAe2zyGvTPIAc5ScXi6LfbDewffUb7BaIBQpoYUEVKJ6+IqWkIjjT46xg1Nr3szqoeUt5mglLHwTFmB3KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=ibyQ9xq8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=heYMklfx; arc=none smtp.client-ip=202.12.124.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.stl.internal (Postfix) with ESMTP id 617581300E4D;
	Fri, 27 Feb 2026 17:23:40 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 27 Feb 2026 17:23:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772231020;
	 x=1772238220; bh=5gDryY4zQRH428jXcjjSGP/R/ZBS8LlxLYxDdPgkkiE=; b=
	ibyQ9xq81ZUFDtngjlebvG4FaCgNpNNbQr1R+mWKzerZDqZJKaMwf0HBblpSPQ91
	VFdvsMyKGU5Tg9sMFl/57BZro8wkMOPw1LWE3jqikOFmHEQcnmlkJjpTO3zUAXow
	XOqfcAa0iIMoieG9RdcB8yL8non1RpY3YX3cBZWsNRzgZoVDHcW4WvsrdYMvRR4O
	kXG9r5jcj3nRPeI3wIZjCqx9pYJ+ovtiJyFyz/zG1Tnpx+Wt4tq5H6UYxb5/xjlk
	lkG0YgCvfdWXxZfC5tYJ4+h6oCW1XZQUWE5ZXPBMY4qfpryKhrz4mlFKl0CtABZh
	ozaeXUkPc0VOpKeMVm0KzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772231020; x=
	1772238220; bh=5gDryY4zQRH428jXcjjSGP/R/ZBS8LlxLYxDdPgkkiE=; b=h
	eYMklfxrT1hKh6s89IGlVCYgodJjyXuEtJzsN6GWawwrgE3RWvsVXiKD+nITWgWN
	uNh/M4JytKcYo90WUBaxX6+sbp0D1FJQarxN9Bl5nKn6toxi0MxhIWTI6N3FuwqC
	O38dHRyoBq/f0uv0cZ0cpvnBSDck1XGNuRuaccj7YkBP9n+efQLf7Dwy5Hdi+GHk
	8YOK86rNlDdXf8PkgONcfllG3kXVA5sq8Bm5XES78tNMaptniFche5ptLjl7/U+u
	AoG867Fox04IbnG/hATygTqTDaZqoKyJxDxYxhOyZQugp7Mthn77Ts4A+ePYYqlV
	Z++xJLYSuIBgqTjIBJbjg==
X-ME-Sender: <xms:ZhmiaTqQpfHE1fOXkXhzKjbpYL9Yr0pf-ceFjB6YPvRSGWBU1Ok5Eg>
    <xme:ZhmiaWpKATxZf0QUyqaYcd-5hQ6sPzPCE5RK_NWP5U50Ly0JADS68CrX2pDqRubi0
    NRsKG0qW5uMqo9Qv9rFyGUBShb1aqFQUKn-lJVJvFbN5ytXZJ2VBg>
X-ME-Received: <xmr:ZhmiaZ7-_PGS79ULJoNU-MK8CiMWbivAY9WumbCm0ZFBs9Fvq0YS9WcGEe8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvhedtudelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeetuefgleefhfdvueegffdtffevhfffgfffiedutdetgffhheejtdekfeek
    ieehgfenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhg
    pdhnsggprhgtphhtthhopeegiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepug
    hmrghtlhgrtghksehgohhoghhlvgdrtghomhdprhgtphhtthhopehhvghlghgrrghssehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopegrjhgrhigrtghhrghnughrrgesnhhvihguih
    grrdgtohhmpdhrtghpthhtohepghhrrghfsegrmhgriihonhdrtghomhdprhgtphhtthho
    pegrmhgrshhtrhhosehfsgdrtghomhdprhgtphhtthhopegrphhophhplhgvsehnvhhiug
    hirgdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhn
    rdhorhhgpdhrtghpthhtoheprghnkhhithgrsehnvhhiughirgdrtghomhdprhgtphhtth
    hopegshhgvlhhgrggrshesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:Zhmiad2sbjfkxksva4ZZqUdWmMjzHkXGC5X8v-2AP5oEUrr0XTMl1A>
    <xmx:ZhmiaVlE8cxGOSiEybB2C9Afiqd60myTjWnbPqKtENleQaquZovVjA>
    <xmx:ZhmiaWieRutAuXs_kAh6v5Y6dFLmaFCfa8MUC0xje_WFkspzBxewcA>
    <xmx:Zhmiac30mxy-wDrums-gZ6YprIYdP06ito0nnSpm_CQ9sTCgWFmiig>
    <xmx:bBmiacvgXgNhRla-HV46CCK5l8R8PlNCFfSmuJ_LXC__y0uuR4tYHQ8Z>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 17:23:31 -0500 (EST)
Date: Fri, 27 Feb 2026 15:23:30 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
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
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <20260227152330.1b2b0ebb@shazbot.org>
In-Reply-To: <CALzav=egQgG-eHjrjpznGnyf-gpdErSUU_L8y82rbp5u=rQ83A@mail.gmail.com>
References: <20260129212510.967611-3-dmatlack@google.com>
	<20260225224651.GA3711085@bhelgaas>
	<aZ-TrC8P0tLYhxXO@google.com>
	<20260227093233.45891424@shazbot.org>
	<CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
	<20260227112501.465e2a86@shazbot.org>
	<CALzav=egQgG-eHjrjpznGnyf-gpdErSUU_L8y82rbp5u=rQ83A@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	FREEMAIL_CC(0.00)[kernel.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev,shazbot.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72238-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[messagingengine.com:dkim,shazbot.org:mid,shazbot.org:dkim,shazbot.org:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C7D451BEABA
X-Rspamd-Action: no action

On Fri, 27 Feb 2026 14:19:45 -0800
David Matlack <dmatlack@google.com> wrote:

> On Fri, Feb 27, 2026 at 10:25=E2=80=AFAM Alex Williamson <alex@shazbot.or=
g> wrote:
> >
> > On Fri, 27 Feb 2026 09:19:28 -0800
> > David Matlack <dmatlack@google.com> wrote:
> > =20
> > > On Fri, Feb 27, 2026 at 8:32=E2=80=AFAM Alex Williamson <alex@shazbot=
.org> wrote: =20
> > > >
> > > > On Thu, 26 Feb 2026 00:28:28 +0000
> > > > David Matlack <dmatlack@google.com> wrote: =20
> > > > > > > +static int pci_flb_preserve(struct liveupdate_flb_op_args *a=
rgs)
> > > > > > > +{
> > > > > > > + struct pci_dev *dev =3D NULL;
> > > > > > > + int max_nr_devices =3D 0;
> > > > > > > + struct pci_ser *ser;
> > > > > > > + unsigned long size;
> > > > > > > +
> > > > > > > + for_each_pci_dev(dev)
> > > > > > > +         max_nr_devices++; =20
> > > > > >
> > > > > > How is this protected against hotplug? =20
> > > > >
> > > > > Pranjal raised this as well. Here was my reply:
> > > > >
> > > > > .  Yes, it's possible to run out space to preserve devices if dev=
ices are
> > > > > .  hot-plugged and then preserved. But I think it's better to def=
er
> > > > > .  handling such a use-case exists (unless you see an obvious sim=
ple
> > > > > .  solution). So far I am not seeing preserving hot-plugged devic=
es
> > > > > .  across Live Update as a high priority use-case to support.
> > > > >
> > > > > I am going to add a comment here in the next revision to clarify =
that.
> > > > > I will also add a comment clarifying why this code doesn't bother=
 to
> > > > > account for VFs created after this call (preserving VFs are expli=
citly
> > > > > disallowed to be preserved in this patch since they require addit=
ional
> > > > > support). =20
> > > >
> > > > TBH, without SR-IOV support and some examples of in-kernel PF
> > > > preservation in support of vfio-pci VFs, it seems like this only
> > > > supports a very niche use case. =20
> > >
> > > The intent is to start by supporting a simple use-case and expand to
> > > more complex scenarios over time, including preserving VFs. Full GPU
> > > passthrough is common at cloud providers so even non-VF preservation
> > > support is valuable.
> > > =20
> > > > I expect the majority of vfio-pci
> > > > devices are VFs and I don't think we want to present a solution whe=
re
> > > > the requirement is to move the PF driver to userspace. =20
> > >
> > > JasonG recommended the upstream support for VF preservation be limited
> > > to cases where the PF is also bound to VFIO:
> > >
> > >   https://lore.kernel.org/lkml/20251003120358.GL3195829@ziepe.ca/
> > >
> > > Within Google we have a way to support in-kernel PF drivers but we are
> > > trying to focus on simpler use-cases first upstream.
> > > =20
> > > > It's not clear,
> > > > for example, how we can have vfio-pci variant drivers relying on
> > > > in-kernel channels to PF drivers to support migration in this model=
. =20
> > >
> > > Agree this still needs to be fleshed out and designed. I think the
> > > roadmap will be something like:
> > >
> > >  1. Get non-VF preservation working end-to-end (device fully preserved
> > > and doing DMA continuously during Live Update).
> > >  2. Extend to support VF preservation where the PF is also bound to v=
fio-pci.
> > >  3. (Maybe) Extend to support in-kernel PF drivers.
> > >
> > > This series is the first step of #1. I have line of sight to how #2
> > > could work since it's all VFIO. =20
> >
> > Without 3, does this become a mainstream feature? =20
>=20
> I do think there will be enough demand for (3) that it will be worth
> doing. But I also think ordering the steps this way makes sense from
> an iterative development point of view.
>=20
> > There's obviously a knee jerk reaction that moving PF drivers into
> > userspace is a means to circumvent the GPL that was evident at LPC,
> > even if the real reason is "in-kernel is hard".
> >
> > Related to that, there's also not much difference between a userspace
> > driver and an out-of-tree driver when it comes to adding in-kernel code
> > for their specific support requirements.  Therefore, unless migration is
> > entirely accomplished via a shared dmabuf between PF and VF,
> > orchestrated through userspace, I'm not sure how we get to migration,
> > making KHO vs migration a binary choice.  I have trouble seeing how
> > that's a viable intermediate step.  Thanks, =20
>=20
> What do you mean by "migration" in this context?

Live migration support, it's the primary use case currently where we
have vfio-pci variant drivers on VFs communicating with in-kernel PF
drivers.  Thanks,

Alex


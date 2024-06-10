Return-Path: <kvm+bounces-19248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF2E0902764
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 19:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61B852897AB
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 17:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6259114535A;
	Mon, 10 Jun 2024 17:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="nJ8CEmCL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04olkn2100.outbound.protection.outlook.com [40.92.45.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B339886126;
	Mon, 10 Jun 2024 17:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.45.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718039029; cv=fail; b=UKsmA5+tIR96HJyg9LtAm1TRF7ynIOdUTutVrm8Uyp81RCZRY9itRLcgILzvqZ1lIrZVvaOCWkTS0G9KlICGg6C/abQ9DHYhxRXFlXUpfhYURrMP+bYfc0gpUIQbVghdxwpSNuIiT8h30QD+c5Bk4+pnKNXnuIhbAthtOcc94nM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718039029; c=relaxed/simple;
	bh=ATKp5UGTuNiWaXZb/D+Cw38/HqOa4/RkcUx//mzrqts=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T46XdF4l7O1pgFWDgy2sHks4kbcWQPpo+VMpkyxiVheNQ1YnQd4w3UDhXDYrKj+xGdv40hhaYJB4X+WNerkumI5opYKrPmHnAJazP4z+jqw5l3O7WP2Jw51zuiuvr5GVYefd7UoTyHp8OCs9jBA4qQnAagb6kUWnpvNmfS+hcAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=nJ8CEmCL; arc=fail smtp.client-ip=40.92.45.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+n3GC9NEi2ww3cEufqNPeA6eQLzWOzvcqaZXPMs5EqiHMfvYLDUIsccPzUDxG6FAFnLLfxaGxdJl7n3b/2IwyxunqDahghmhh1yWq5deJ/O5c+mKBseVSh8/Sj7vw3DMKraAZM+68zo4gk4nxDGFNsp6iaeD2xlXf5uNE3ZzETBZnZyvH+Inym9DDfd8B072SrO/lfEBYmKmhF5IdIVEFGrkyUYgN4BkRE0hK1k0SWGaalMabF5oQEWgeIykqkSmMsBB5dOyqAa8Pz66hUmbyz8fYaRSNNdksgInCzMwEWiTmzfuHaaKymzLZ8MKLJnDXdOm+7lSQrXSvHbqWLwmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eKjT6MeGJfiPxxqnAoLXIvdH094/nSqxmuESy6DSFb0=;
 b=JW01OMiK53KWgDxs76YYLaj8ei3G/vHfOb076+/mW18TyCLZYpl7/Lkv/Zq+XikA2L8NxrdVuzd6bHHMtgEjLCQwNmM5myXLxDAfiwM4tlOH2BTiAuiVKkXfdg+6SVI352TO0OmsemqZMaWsWXka6K6qhHRWMrlXaCh9EL53tTCe116uEtBeeAXS7/NTPzuAWtECbvI9w2BqWt7KFqi76YFZjqKXxWTF6V8RXjHkNsS6iFcSFqETnY715GJZVftNIS3g8tWdWt04BxMnHFB04dr33fq8ApM9LmH6+1Bl/D/iVhftH9YNihqSrXccv+soAyTDVT2stMCSwIZPgjYp4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKjT6MeGJfiPxxqnAoLXIvdH094/nSqxmuESy6DSFb0=;
 b=nJ8CEmCLUBGrO1NSXXrLldGcjg6OgCziOTjzS3cqozqiO0eI+vwRsZ0w0plSt1q7tha7NwkbU72lWyq+Yb2SCM8GgYhvh45972kQ2tmBV3ApgTxgh0cXHzpB657+n5boumfr5ghGaDqfZ55/A9fdfQoJ0Kuuw1zPsa6yyVeIsaWqjoiJ+ROc4DGw5tX9CfWoYvQD+7/emzfr1g6uV0MkHmsrcPsFWMWV3tsub064yfP9fCkhIkNN8LM1cNai93EKe7PNZANUuOUy+r3BZeEU9x+DjDZ3gR5UAyiInWswBvaZhZVkCWYY075OYMNalrv4x2FWkcVpATrl2CETPyofjw==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by MW4PR02MB7138.namprd02.prod.outlook.com (2603:10b6:303:64::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 17:03:44 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 17:03:44 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Steven Price <steven.price@arm.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse
	<james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Christoffer Dall
	<christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Ganapatrao
 Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: RE: [PATCH v3 00/14] arm64: Support for running as a guest in Arm CCA
Thread-Topic: [PATCH v3 00/14] arm64: Support for running as a guest in Arm
 CCA
Thread-Index: AQHatysPRYaUedD8SEOOWptuNOqVvrG7hVGQgADmoQCAAA8XwIAEWhgAgABd+QA=
Date: Mon, 10 Jun 2024 17:03:44 +0000
Message-ID:
 <SN6PR02MB4157E83EAFA5EBEF5C5889BFD4C62@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <SN6PR02MB415739D48B10C26D2673F3FED4FB2@SN6PR02MB4157.namprd02.prod.outlook.com>
 <ZmMjam3-L807AFR-@arm.com>
 <SN6PR02MB41571B5C2C9C59B0DF5F4E7ED4FB2@SN6PR02MB4157.namprd02.prod.outlook.com>
 <ZmbWpNOc7MiJEjqL@arm.com>
In-Reply-To: <ZmbWpNOc7MiJEjqL@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [Cj93qthFVrIn7tt70uwz0Xwo42k4DmfV]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|MW4PR02MB7138:EE_
x-ms-office365-filtering-correlation-id: c5be212e-57e3-4044-7e66-08dc896f4960
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199019|102099023|440099019|3412199016|56899024;
x-microsoft-antispam-message-info:
 yUjKH3I2PcoCjwtEXocviH/5npBTtLuh9bEJwUJdBiABHEUz+Agmo0WpNBl3oUX9ZmHJZTYmIykI58iGHgYClRa1EGTcZ+Wi6QhV4WPiKnV68g2lN2ygatQjdzOXIjGOWoq7PaXfMmf9xA7MD+nGVUY4TLikDVzwHz/lOHmx4bkWVYChAV9Isccqw/jmAMEV/sJDg/eAZbrBZnj6LHOrIk/Ko6Dmr2cW/cM3s776vdYCZ9YiEfNFWYc25Zj4HZLLYToBXbTRar+I2bAm//Bz3Q9ld41q4c5BKlitGxHlIAiKiB0siAKNzW5TXKoAmugxoSF1MNcal1ShO5FNUEDufAit/uhqisSGqplPxfLuW9bklCyI2fvnQ0gW6NDGjo9P4zq4Ji7/pCE+1cAfwCZHtgqnqqgJvGN+urrpIOcoqOYoHVBG+cwWeTj2ijei94kHt3StbX5JpC3skH0dlouxBp5DWRd87hPZVthp76wBqmQwhTeL1GqpGqY/t6G3lL+9ChGZjjkInXxO22fNLhdO9qA5g+1pUiw0z6ASTvlex3nJfjXEzPB+B+uAVsiXIfOqwi7n8T16gb4Oas9JstQdOeneDIXS0oJqseYcXXFJtKb56TI5W50n4dh1DTweB/2Dr8zdoFkto3hpnX9V8BZFGQ8HBbqIBV6rqxTNK3BwC3U=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ZGJ3DyLaNNPCGUmfZLMMQI7sCrP7B6AWVcdkyHdQo+GgUcTLYDX+RD7aAOY6?=
 =?us-ascii?Q?rOVMPN4Jup13doGQINzYy/M54HHDtVWgSm0TCh3lngOQ/b7hX6qxgkK/pGoB?=
 =?us-ascii?Q?5XwwIi/yflGA3OJRwvaL/RtI6TwPnFb8JFbuYrXfg1M3HhcssvZ2N+OARXll?=
 =?us-ascii?Q?R09mFr+kbiREIBX4AYJ0nxdxVo0tu8O/D0E4Jf6hWYD7p94CU2+c3DTaqBpT?=
 =?us-ascii?Q?jWjDMIeqwjREw4cwQfHv25wz5CP/UlLO3BKrotDVSZv+LJrERvanHqk31Skp?=
 =?us-ascii?Q?XSGgY/6mqOOprRsqMtiHR9NzzWa3Eiezzj4DHabj8uHkVgmWoARzuLj8/EiV?=
 =?us-ascii?Q?I61BBfx3gSlwWhlYkeJ2jVLeQXxyCZUFKPCGaBd+p6i/f4TnUFcizpWygNbP?=
 =?us-ascii?Q?j0bUztchMW/pDTP/NKiElOJ7D3DBuvnW7ac0JJjVa+sw0HP/e8M37wtNGDE6?=
 =?us-ascii?Q?4MAH5GPZGgWlMv0SGNthQLtZGwGYh3D1KMSfJ5zXwYaekM3uNre5JvmcNEHC?=
 =?us-ascii?Q?aB1Y7hndVw6Dr8dk17EdpGlR7uFPXlJswvHquuAQ1drphqs37a+2yOQz/0Tz?=
 =?us-ascii?Q?4dKpbDAShC1TteNHfCUjZP17LUMZCeGCUA+iYpiaGd/JT+V/5lmppsJb59NB?=
 =?us-ascii?Q?WhL8WQ5/OuG6AOE/4jDHiHbrWo8okr8N81EXbGLcPlXGvqF+n2CB6MUjWoIj?=
 =?us-ascii?Q?uKswHb0sSHd9OpEUk9UwYh/w5wNUZ2W0B7NYyB0lfKTfxsAm5xSw4QSDMrta?=
 =?us-ascii?Q?eowb4uTu8PMqrP1vnCM2y2nHa4Fzz3UE9Ip31dp6Wao9J2o9A+wLwUbjpd7/?=
 =?us-ascii?Q?PDyjEyzY9IFChe51gZSddPZVWd7Csms2BoDRhae+mxnWFbml4uCEL9CGZ2er?=
 =?us-ascii?Q?EexaHD7fMeu8XlqjC0tJh5BJDZ2mVOdfrN6qzE7I11jsIwM+ZnH3RJQQhmwA?=
 =?us-ascii?Q?3J8EOX6HOnJlG/HCq7w2Uaegbd3frkQ7IYazxuYyM3n74OooKG4UqA6FfOIL?=
 =?us-ascii?Q?hE2F/L8AT0XNr2JfnDmFeBT0k3mmgu4h4Byh1qbqG8G7+oHJnWIbv7PR3Y8B?=
 =?us-ascii?Q?shz64/gvB8xqMXp6EYClI/fMufEdfC3K+vHoIaB9gjX7UaczbTyklacgwNsY?=
 =?us-ascii?Q?Z5dtRxvtNKlhx9RD1UssKptY9lZeQauoFxigNBtarNWHaCk+nBkUYgVTtQIf?=
 =?us-ascii?Q?bABA8/dxmwy2QDkfFt6N7phU6+un46q6NDbLaFrOr2re7SNlVevOWi9nKqM?=
 =?us-ascii?Q?=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: c5be212e-57e3-4044-7e66-08dc896f4960
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2024 17:03:44.5146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7138

From: Catalin Marinas <catalin.marinas@arm.com> Sent: Monday, June 10, 2024=
 3:34 AM
>=20
> On Fri, Jun 07, 2024 at 04:36:18PM +0000, Michael Kelley wrote:
> > From: Catalin Marinas <catalin.marinas@arm.com> Sent: Friday, June 7, 2=
024 8:13 AM
> > > On Fri, Jun 07, 2024 at 01:38:15AM +0000, Michael Kelley wrote:
> > > > In the case of a vmalloc() address, load_unaligned_zeropad() could =
still
> > > > make an access to the underlying pages through the linear address. =
In
> > > > CoCo guests on x86, both the vmalloc PTE and the linear map PTE are
> > > > flipped, so the load_unaligned_zeropad() problem can occur only dur=
ing
> > > > the transition between decrypted and encrypted. But even then, the
> > > > exception handlers have code to fixup this case and allow everythin=
g to
> > > > proceed normally.
> > > >
> > > > I haven't looked at the code in your patches, but do you handle tha=
t case,
> > > > or somehow prevent it?
> > >
> > > If we can guarantee that only full a vm_struct area is changed at a
> > > time, the vmap guard page would prevent this issue (not sure we can
> > > though). Otherwise I think we either change the set_memory_*() code t=
o
> > > deal with the other mappings or we handle the exception.
> >
> > I don't think the vmap guard pages help. The vmalloc() memory consists
> > of individual pages that are scattered throughout the direct map. The s=
tray
> > reference from load_unaligned_zeropad() will originate in a kmalloc'ed
> > memory page that precedes one of these scattered individual pages, and
> > will use a direct map kernel vaddr.  So the guard page in vmalloc space=
 don't
> > come into play. At least in the Hyper-V use case, an entire vmalloc all=
ocation
> > *is* flipped as a unit, so the guard pages do prevent a stray reference=
 from
> > load_unaligned_zeropad() that originates in vmalloc space. At one
> > point I looked to see if load_unaligned_zeropad() is ever used on vmall=
oc
> > addresses.  I think the answer was "no",  making the guard page questio=
n
> > moot, but I'm not sure. :-(
>=20
> My point was about load_unaligned_zeropad() originating in the vmalloc
> space. What I had in mind is changing the underlying linear map via
> set_memory_*() while we have live vmalloc() mappings. But I forgot about
> the case you mentioned in a previous thread: set_memory_*() being called
> on vmalloc()'ed memory directly:
>=20
> https://lore.kernel.org/all/SN6PR02MB41578D7BFEDE33BD2E8246EFD4E92@SN6PR0=
2MB4157.namprd02.prod.outlook.com/
>=20

OK, right.  You and I were thinking about different cases.

> I wonder whether something like __GFP_DECRYPTED could be used to get
> shared memory from the allocation time and avoid having to change the
> vmalloc() ranges. This way functions like netvsc_init_buf() would get
> decrypted memory from the start and vmbus_establish_gpadl() would not
> need to call set_memory_decrypted() on a vmalloc() address.

I would not have any conceptual objections to such an approach. But I'm
certainly not an expert in that area so I'm not sure what it would take
to make that work for vmalloc(). I presume that __GFP_DECRYPTED
should also work for kmalloc()?

I've seen the separate discussion about a designated pool of decrypted
memory, to avoid always allocating a new page and decrypting when a
smaller allocation is sufficient. If such a pool could also work for page s=
ize
or larger allocations, it would have the additional benefit of concentratin=
g
decrypted allocations in fewer 2 Meg large pages vs. scattering wherever
and forcing the break-up of more large page mappings in the direct map.

I'll note that netvsc devices can be added or removed from a running VM.
The vmalloc() memory allocated by netvsc_init_buf() can be freed, and/or
additional calls to netvsc_init_buf() can be made at any time -- they aren'=
t
limited to initial Linux boot.  So the mechanism for getting decrypted
memory at allocation time must be reasonably dynamic.

>=20
> > Another thought: The use of load_unaligned_zeropad() is conditional on
> > CONFIG_DCACHE_WORD_ACCESS. There are #ifdef'ed alternate
> > implementations that don't use load_unaligned_zeropad() if it is not
> > enabled. I looked at just disabling it in CoCo VMs, but I don't know th=
e
> > performance impact. I speculated that the benefits were more noticeable
> > in processors from a decade or more ago, and perhaps less so now, but
> > never did any measurements. There was also a snag in that x86-only
> > code has a usage of load_unaligned_zeropad() without an alternate
> > implementation, so I never went fully down that path. But arm64 would
> > probably "just work" if it were disabled.
>=20
> We shouldn't penalise the performance, especially as I expect a single
> image to run both as a guest or a host. However, I think now the linear
> map is handled correctly since we make the PTE invalid before making the
> page shared and this would force the fault path through the one that
> safely handles load_unaligned_zeropad(). Steven's patches also currently
> reject non-linear-map addresses, I guess this would be a separate
> addition.

Rejecting vmalloc() addresses may work for the moment -- I don't know
when CCA guests might be tried on Hyper-V.  The original SEV-SNP and TDX
work started that way as well. :-) Handling the vmalloc() case was added
later, though I think on x86 the machinery to also flip all the alias PTEs =
was
already mostly or completely in place, probably for other reasons. So
fixing the vmalloc() case was more about not assuming that the underlying
physical address range is contiguous. Instead, each page must be processed
independently, which was straightforward.

>=20
> > > We also have potential user mappings, do we need to do anything about
> > > them?
> >
> > I'm unclear on the scenario here.  Would memory with a user mapping
> > ever be flipped between decrypted and encrypted while the user mapping
> > existed?
>=20
> Maybe it doesn't matter. Do we expect it the underlying pages to be
> flipped while live mappings other than the linear map exist? I assume
> not, one would first allocate and configure the memory in the kernel
> before some remap_pfn_range() to user with the appropriate pgprot.

Yes, for user space mappings I also assume not.

Michael


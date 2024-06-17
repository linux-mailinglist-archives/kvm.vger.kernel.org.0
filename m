Return-Path: <kvm+bounces-19756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2122790A301
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 06:06:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A488F1F22332
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 04:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A873A1802D9;
	Mon, 17 Jun 2024 04:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="VZ/v6+RV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2062.outbound.protection.outlook.com [40.92.18.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB3810A2A;
	Mon, 17 Jun 2024 04:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.18.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718597180; cv=fail; b=Z5CK8CklfepN6N3Cf/oUeQa8wPJPB/mh1boFg7/1nn9aoGThA8jSXzcyWJDBipe0O+0No9K5VG8q86BvYY/Xw0BwSsyJneVJyfbU07gtCScM98lq+WCrYiWt756EvE6uqF8cqOlCMDCzyGp/eBFAE9iifYqZamtocpFMhgjaZns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718597180; c=relaxed/simple;
	bh=3DYu666y+uW2udMQ1LH8sT2CcS93AJtgJeLsggLXJIY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r5KsY16+EQRpU5o7wdE1Y8PFjH8wXSWLGSPHvMmQqrwga34X45PLR7xWzkJY+jaOGuio1+XKKGwG0FFfK2mfZ8AbEuOcf0Y+Lx8GaF7NCe2cXxi6mxmQjog6FQ4u/n+PYiwa0GC5yLkC3zlHX85NSx/IuNe25nlanDsa7TOjVvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=VZ/v6+RV; arc=fail smtp.client-ip=40.92.18.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQ2edO/7vnIs7yG9Qem+Ga08jaVWDrU1Ib843iu+DrQjoIsJBdeJFD6ZMMDErsgKL3InUOtRDbjro1lzUdtZymn22BZ1JbBHayMhEK/zKV6W78CAxXjIR+ZSs/JcXzU2oHmcRKJY3660ho80yYfQ8tXj1Hdf6mSRs3+ode2etBH66ugT2saXxZAhQERAWC/BofDNZIImG9CC2YYm7xFbek1o4ZwcVbfvoXbRBVrtMWW8azxyfk+hhRUOC3NXbgUWO8wQmZezm3w1yBOr16DvcH48YC8E2CYplurm2n5G2cvaWhlK/NYk+yQfMVwYcqLogrOyRTOUsiX9hFcOxR6Mpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/zI7G52kAvmPQ+ebPAQUKDO8+uZrUG2Pk1M6l1K3GgU=;
 b=fJ4ScllnXgLR+nNCIKNiKbeC84zJHFb8a2Bo0BYmwbOPo9TrT2QgkjxB3bYh5RN1t8ttsoLc1aLKY4pKJGTvx3LBqFDeVLvqgly9rrEVYr4qMulPLP7NE5AlyyPKlDZ559l1nW1pPrehDnnmkNeiBWgi+bp8jVdSabHgPp9Ecj2vX722YTBCneWYDggbH+jMQVvJOizfwMzyX+bz0hDE0lTE4e5uMufJaC4EZcE1yyrRx3iifmXIr3BUL2rvHRa17wTvRYDg8b/KwNwEUzTGTEaCXDq3YFJQM1s2kj5QZWLxr82lr4ROVkTnElRYPTrTNt2XRNff5a7zjqThoA+J3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zI7G52kAvmPQ+ebPAQUKDO8+uZrUG2Pk1M6l1K3GgU=;
 b=VZ/v6+RVj6G8aiXWN09dG/iJ8FB5XIx+Ii17r6seLqnd+fGZ3yucvXXfcNAmJNJuxqeLX7Jx2Y/fO6jaLEnDfgY6OGPqyziBP3l60OAG2dvP5nPt89u1q9osSUqSckjTHxzyhYr0a/A+MrE59aGpBgfXMhdrCa9lu/X9XztNRd/uMp/j+hcyk0FNlFgWr859UMWBG+DAkRZ0PCeTdQFEOXIwLAq49U+7yt2Y5ia0CnVylQVfN3mKvyajZMqjejJxvHi78x81ch69pb0omUyTfLRn9um6aqZ0/iC5R6x4mhFcEUxMnc4/HMIR3vN5g4Unr1kJGOVO1H4h+RcQ6vmqHA==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by SJ0PR02MB7645.namprd02.prod.outlook.com (2603:10b6:a03:329::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 04:06:15 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.7677.024; Mon, 17 Jun 2024
 04:06:15 +0000
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
Thread-Index:
 AQHatysPRYaUedD8SEOOWptuNOqVvrG7hVGQgADmoQCAAA8XwIAEWhgAgABd+QCAABqzAIAKGFwQ
Date: Mon, 17 Jun 2024 04:06:15 +0000
Message-ID:
 <SN6PR02MB4157B95E74A3865C44F6132ED4CD2@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <SN6PR02MB415739D48B10C26D2673F3FED4FB2@SN6PR02MB4157.namprd02.prod.outlook.com>
 <ZmMjam3-L807AFR-@arm.com>
 <SN6PR02MB41571B5C2C9C59B0DF5F4E7ED4FB2@SN6PR02MB4157.namprd02.prod.outlook.com>
 <ZmbWpNOc7MiJEjqL@arm.com>
 <SN6PR02MB4157E83EAFA5EBEF5C5889BFD4C62@SN6PR02MB4157.namprd02.prod.outlook.com>
 <Zmc73jAL2XdLU49P@arm.com>
In-Reply-To: <Zmc73jAL2XdLU49P@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [o1v+mIqT5cE6fPVXe6lez/pjj9e6s2cc]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|SJ0PR02MB7645:EE_
x-ms-office365-filtering-correlation-id: d9b524dc-9896-43a4-eb53-08dc8e82d550
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199025|1602099009|440099025|4302099010|3412199022|102099029;
x-microsoft-antispam-message-info:
 5H/M3KBLlSN0ivzLZk+2yUgRgnrNX70F8NByob0nZ4Rb9ILB/K43ZTrbtpYlbmZvjPY54G0Sg67fvj4DXLpccpUbfhloBiu086gduFvHZQ/oA5dCM0LCk7KV+OLfT1oCglNSdwOnpPtxCiHbKf0kiZvpxSv6VpqkASoFhHM2bkSThwgkj+h18TSMWbu1/N+LGUmUvh/qAXaaODJ4+siJBq5LOG8JwMqmVL3PYmrV1BHZEenrg2KcRWEAqwMBz/pBQj85VdPyaBKEqmFQaH9I66t/gmN0xUB3uR38Lb0UzOr1CZW5jO5Omh+WT0qqeisXsKFJGHPOCiVQnyACKMw9VWhrlPJUcks/7H4YOOHjpc+RpmPGWr79vsA7GpoM52ojcNwhZVyLKoCinGgUXeu+NdBAFDpp/Ks3sS4x/aK8HYib3jzR3H7HIW8DOGRJjRrsf9ecJxMv5ZwdCxc+I7wClXoh71An7/7AIUp0tWuZ+dFr3XiQt23s3Vudtn1zv7GFstUCSvsWNspWmLk1QJ3nSNUTHQbbD0e16/9HWQ+KLWUA1fJEy59jmjaWOcsxkqEzVHYSsXfboxZlJ2B6sN8h6GTkhUCFynFz8L+rOroVIDZBjQp4Av4ggpkMwe1nGUvgtOKw/d1rmnarLN2akuef3c9JvxTqrQaLkGwgZzdK0SOMRKH0hTkxhYtaYydqRII5
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?RxrpkyEIR1HTnG/HHZENwjdTjzoTYwes/hThO/xlISbUI/2Bc2piZICiSOyq?=
 =?us-ascii?Q?MjlAOVR8w0VTVM7TUIwOXA18ha7/Jdre9IR0jcG4rqCh3KcFJAuuBXieHUEQ?=
 =?us-ascii?Q?5zIDSpphFTz27GFWlXnWwf0t9i1JQW/UEUkI6BqeRJVTCAkCywLBOtgMdacR?=
 =?us-ascii?Q?GwkGWPspwmhEGKh1szS8LrpZ5v2lO4OSGbO4O3mb51uQGKBPfnCdisEj1dz1?=
 =?us-ascii?Q?ONLCYFo6kjdX+w1H4j9PivVbxYKLGUJ+ycMdxpoK+IS+uQsigS45wt1UY3KF?=
 =?us-ascii?Q?cFUQUu+i7T/ULWV+SzoHIEJiyV1vAKDfNDfkbL/N35YIFlFlF0Mkz8d5Hsve?=
 =?us-ascii?Q?lKkEN2k557QHmrPaUpYXCHu9XsaiqwhxTpXA5b+HCwdJ4hLTxn4CmvY4fE/2?=
 =?us-ascii?Q?eofWeZg6H2bqZKoJsCAcCm1PEOGPcgCNEhDG4z3oTb4XvE1mwUbNF9H7ZZaf?=
 =?us-ascii?Q?vFqD+UrlfBthln48xXmIi3E5X+ujWCXBVGTQlsKXvhDts11Mck0OZXB+6zwQ?=
 =?us-ascii?Q?yj9uMnHC7+EJYjXf8En21NtIZpIrhGV1qymzR/LVGKYsmSGMADT4gXsIEIwN?=
 =?us-ascii?Q?McDJ3UZROCiEbe+FuN+yPjuqWMaeM4o2ZYySl00lkl7tiRWcGRgA6GnUCCHs?=
 =?us-ascii?Q?GVQHDY5u6lx7dKRw7HUEn0/0R3uZg9vFicIrROM+ihAbS1wt5WN6YuYxGVfK?=
 =?us-ascii?Q?FHeAHmS+XGv3E/TtNVyLYHhtSEFUqffi74dqxmkOB+P94kjJ2f3nJu+riMMi?=
 =?us-ascii?Q?kXxM6Kp5PKg4xvIM3+fvX88aYsyNjmIk3J1NkgCZ5dWTZyuaAHHyqcXPrKjr?=
 =?us-ascii?Q?O+U+ic+qSfNxAgC1+pVrc2z2ntNFaKrpKxwOloKs9W4YF3JUOq7TFHccthz7?=
 =?us-ascii?Q?8iZ5St19xtl8AgnW5wvpjqOw0/wYZ+U5lMq8AgqFGUp6jwJSax6Aeq6Xt1AF?=
 =?us-ascii?Q?Z4gsCkWWFR4OFPsOFkuAGlzfsgcDVUL0vSXJCHTLUDJ4wGzEbSbMZaPzCn2T?=
 =?us-ascii?Q?elLFH+8O0J4LYAZEDjfgGq05vZNRsBbHXRTzYsnenucVcFE6xyt8cxW4lM+U?=
 =?us-ascii?Q?OS4TFOtS2uXvL9iT70UkNOZ8kkM0bZ+pN4cfhdheaiCqwpm/SIhLiH1hOICG?=
 =?us-ascii?Q?+1SOP1LxTIVPMLDLP6ZWU1W5BKaG01nns70PEwmdJW9dkTsYgFL/KzSdNx9o?=
 =?us-ascii?Q?55m373M1qfbstE8X9j4k30m+oGAOhVjgr81my1ZKHW8cx9qYTOKN4i2BWwY?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b524dc-9896-43a4-eb53-08dc8e82d550
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2024 04:06:15.5251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7645

From: Catalin Marinas <catalin.marinas@arm.com> Sent: Monday, June 10, 2024=
 10:46 AM
>=20
> On Mon, Jun 10, 2024 at 05:03:44PM +0000, Michael Kelley wrote:
> > From: Catalin Marinas <catalin.marinas@arm.com> Sent: Monday, June 10, =
2024 3:34 AM
> > > I wonder whether something like __GFP_DECRYPTED could be used to get
> > > shared memory from the allocation time and avoid having to change the
> > > vmalloc() ranges. This way functions like netvsc_init_buf() would get
> > > decrypted memory from the start and vmbus_establish_gpadl() would not
> > > need to call set_memory_decrypted() on a vmalloc() address.
> >
> > I would not have any conceptual objections to such an approach. But I'm
> > certainly not an expert in that area so I'm not sure what it would take
> > to make that work for vmalloc(). I presume that __GFP_DECRYPTED
> > should also work for kmalloc()?
> >
> > I've seen the separate discussion about a designated pool of decrypted
> > memory, to avoid always allocating a new page and decrypting when a
> > smaller allocation is sufficient. If such a pool could also work for pa=
ge size
> > or larger allocations, it would have the additional benefit of concentr=
ating
> > decrypted allocations in fewer 2 Meg large pages vs. scattering whereve=
r
> > and forcing the break-up of more large page mappings in the direct map.
>=20
> Yeah, my quick, not fully tested hack here:
>=20
> https://lore.kernel.org/linux-arm-kernel/ZmNJdSxSz-sYpVgI@arm.com/=20
>=20
> It's the underlying page allocator that gives back decrypted pages when
> the flag is passed, so it should work for alloc_pages() and friends. The
> kmalloc() changes only ensure that we have separate caches for this
> memory and they are not merged. It needs some more work on kmem_cache,
> maybe introducing a SLAB_DECRYPTED flag as well as not to rely on the
> GFP flag.
>=20
> For vmalloc(), we'd need a pgprot_decrypted() macro to ensure the
> decrypted pages are marked with the appropriate attributes (arch
> specific), otherwise it's fairly easy to wire up if alloc_pages() gives
> back decrypted memory.
>=20
> > I'll note that netvsc devices can be added or removed from a running VM=
.
> > The vmalloc() memory allocated by netvsc_init_buf() can be freed, and/o=
r
> > additional calls to netvsc_init_buf() can be made at any time -- they a=
ren't
> > limited to initial Linux boot.  So the mechanism for getting decrypted
> > memory at allocation time must be reasonably dynamic.
>=20
> I think the above should work. But, of course, we'd have to get this
> past the mm maintainers, it's likely that I missed something.

Having thought about this a few days, I like the model of telling the
memory allocators to decrypt/re-encrypt the memory, instead of the
caller having to explicitly do set_memory_decrypted()/encrypted().
I'll add some further comments to the thread with your initial
implementation.

>=20
> > Rejecting vmalloc() addresses may work for the moment -- I don't know
> > when CCA guests might be tried on Hyper-V.  The original SEV-SNP and TD=
X
> > work started that way as well. :-) Handling the vmalloc() case was adde=
d
> > later, though I think on x86 the machinery to also flip all the alias P=
TEs was
> > already mostly or completely in place, probably for other reasons. So
> > fixing the vmalloc() case was more about not assuming that the underlyi=
ng
> > physical address range is contiguous. Instead, each page must be proces=
sed
> > independently, which was straightforward.
>=20
> There may be a slight performance impact but I guess that's not on a
> critical path. Walking the page tables and changing the vmalloc ptes
> should be fine but for each page, we'd have to break the linear map,
> flush the TLBs, re-create the linear map. Those TLBs may become a
> bottleneck, especially on hardware with lots of CPUs and the
> microarchitecture. Note that even with a __GFP_DECRYPTED attribute, we'd
> still need to go for individual pages in the linear map.

Agreed. While synthetic devices can come-and-go anytime, it's pretty
rare in the grand scheme of things. I guess we would have to try it on
a system with high CPU count, but even if the code needed to "pace
itself" to avoid hammering the TLBs too hard, that would be OK.

Michael


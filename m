Return-Path: <kvm+bounces-19873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 215FA90D909
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 18:21:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EBC6CB257D2
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 16:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B64D4C62B;
	Tue, 18 Jun 2024 16:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="KpJIKUBW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2024.outbound.protection.outlook.com [40.92.18.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B3F46450;
	Tue, 18 Jun 2024 16:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.18.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718726662; cv=fail; b=t1rOAGf1XtjD0Pg/8kVrnM1wUF+A+bEg9gyMpaLKK1iyU8tbGofxCXH2LVwWdsYFVrpt9lWsH7Qt+UBuy8JYiGuPAYabvBh9X5xkWF1gfjCR7GyKKpmZnu47our49p+/uJjczXpGFshS1nOiemFXI54uYA1ts89xIJWmrHgkOLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718726662; c=relaxed/simple;
	bh=XL3P/Y0I08GB369aM6D/nUeIb+67GtVCUERYOTWm/tk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ios8mQjqO6LZ4WId4c7jU7kxwOV0lIhNWObjChgQdr9zc4QO8OLlSUEqGAbmjESc0iCCNVrnEcbeuWt8Stc+RG9hH1x46IRxNC+vHwhkLC70V6I+SChu6FR1GBDS2t4msI9iXParYiOm1ga+d2Z4o+MtgSdxAbV6eayKa0uQQZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=KpJIKUBW; arc=fail smtp.client-ip=40.92.18.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUXQsMfehpQvwuiiuM7OQPgJHPPNkQbthTOMNNyuKk43zrIez5Okw3qFUTG3hERgDoZwawtITputlvC9QBY9XpH2eq8G/ZM2RfRDFiNx/IQvqfv7blrK6fnHKWVCZPUJ1iYp1L8xFS89ioTEhWXNdLAw/KHiUGEmtbrtBVbJ3ZH8Yv02Q43P2qZe8jdW+Afw4B25yW3ufAxeWUKcHIODBcSivbVh6rHTaKWbY368Rv6nS9SYXxkN+wp0uNADcC429jUHkMhPCx3NOJ0WoRw/rJ8C0CHbILOLgjoMbiV8uO4ihYyBNVGuhcBlwGXtyGcKq+BYMxfmGyx8QJDLH9O6Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNJk2+KK43abrJhB/hhsNJh/iy0DqltHo+5M4eNm2MM=;
 b=PV4OHt1PtMdZt5YSftsGN8KiCjRcDS5CmbCduKwSlQGkfFW1fpPu5ATR4XO0dt5yIWoM+RaRNhs0k2pTGoZC2QNOKBMWpRspD43X/kbHsSAu325uazfA54RowJCnYNkozPYUWlof2n0QGsU7SdmCX+quWGC7yaUI0buk6gYfEbd10h+2CQGws/oI/GKQcETn59bB+lQdYYyClRgI4Yuq5xHyC2gTRZUd90FhP5Qw/JeQFWoVDIL9XWbKoxPY+ZT0W+Zl05GhVVRda+h1OzdQX0UulbpEkq2gClNowGcsdj7gG4oBQlacZaOxa3HYqDE3n/0TZ4uWOOft4FsPYJKqIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNJk2+KK43abrJhB/hhsNJh/iy0DqltHo+5M4eNm2MM=;
 b=KpJIKUBWE9C3PpP3mDSty5aHxcnGCMBc9apoKWbtTg7kX+WzsoZ3LE1p17XxYnUXXWzCy1/RSEgliBQ0lFaNTK1rBl+g9S/OKGZZfftbbQlx4NNbPM6xRYStuhjKKOCJufdIIiYgBwWR6S33gl9PK28ZLUGcmxMKQypJPelGGvL1sSoovVf/oHU1jRGy5i4YveZeHcdkfRQPwT8fxZ7JOKPvCNDJdc5UXdbpbVU55yL7bP+sA2DW6ZnlX2Nirs0ZOaCoGi4KTROJPkNISEXzSaLzkqogA0VWWPOJIf7cY1UHIPvcQySPJp7w/RI4LcLXGoqtn8BYVFDwsZkKKOnNCA==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by CY8PR02MB9450.namprd02.prod.outlook.com (2603:10b6:930:73::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Tue, 18 Jun
 2024 16:04:18 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.7677.024; Tue, 18 Jun 2024
 16:04:18 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>
CC: Steven Price <steven.price@arm.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, Oliver
 Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Christoffer Dall
	<christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Ganapatrao
 Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: RE: [PATCH v3 12/14] arm64: realm: Support nonsecure ITS emulation
 shared
Thread-Topic: [PATCH v3 12/14] arm64: realm: Support nonsecure ITS emulation
 shared
Thread-Index:
 AQHatyvDpGLInPLe1k+KxuF+HFPQEbG5LUiAgAAY6oCAAUD3AIAAi9kAgAGGSYCAESO6QA==
Date: Tue, 18 Jun 2024 16:04:17 +0000
Message-ID:
 <SN6PR02MB41578FDF4DD1013FEF690069D4CE2@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-13-steven.price@arm.com>
 <86a5jzld9g.wl-maz@kernel.org> <4c363476-e5b5-42ff-9f30-a02a92b6751b@arm.com>
 <867cf2l6in.wl-maz@kernel.org> <ZmICEN8JvWM7M9Ch@arm.com>
 <ZmNJdSxSz-sYpVgI@arm.com>
In-Reply-To: <ZmNJdSxSz-sYpVgI@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [JM09eADDQR+3PcmA6opUM767Zvhcms9H]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|CY8PR02MB9450:EE_
x-ms-office365-filtering-correlation-id: 1d43d9ea-3167-40c9-0ad2-08dc8fb04ed9
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199025|3412199022|440099025|102099029|56899030;
x-microsoft-antispam-message-info:
 epJOZL+/4bIK25OBUoJ/rK7F7zAdf0iZnjMY0bY5lRKW7MvQrawu9uwmd0UZNGtpUNVn99JUNLCC3L2yoOIVq4uklxcJ1k5vvkvHtCgE0QPDiw25Ll5gyL6CaBIeM4KY/3oPK7mrTFStLu88paByzRGFNdpKxr2IdaH4lHFntNNM4Iq6tPifIWIWhbukU51ZWOFG/xVMi16wuyqDX1hIvPJGKWi488gkU7cpeL8sm07izpfHffYpu3E7+QYJnOKjYpcQgG6Pja35eWM7COrVudjPPYA0a90b5bngImpNgIyw62HDdXw+rD82ctw9Go1vNO1v4HIkgMU0wyLpxIGkAAqUTvtm2EOwaePf0MdyCFvSwPnfr1bCTCW0lZT+tHU+Z411kcGUnY/7k6iGOoG3TcJSs4GFSDil5LgG0AbhYrgWYAgq4pkPahO1d6EQQ1epWcy0HGwaYkDbEWWaIUHdEOiiWKk5T5oQa0E2khSp8fGWUpZ59KB+Hd2MBnTcmbEnHun1HlxCl2wwMevg20gDx9kXrBLckHqYUUxh0EULuKl3H4FFbowiG+6sVqvxQr9i
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Jhut+P2Gbr+TclKmy+g50YW+NgXK5lWadgaRMU3EjSd6+xlFiTkUh9soDRwK?=
 =?us-ascii?Q?QJqMx1gjMMifqgA7bSGCzD9iK4859rPgx4UyjCQdF4m/9g7lq0h0uWfTVxgx?=
 =?us-ascii?Q?9pWmB/o8UYZyK0X8hF7SDaP8J7iaeGwFTN7r3JYuSuOfStMRW4cld9M62pfD?=
 =?us-ascii?Q?oDTucecOFUMNOcxdETDtk5S3YJ3cCSoNNyhuTPA8TrriZDV5Vya1VWQS4zK3?=
 =?us-ascii?Q?y3/lN/ay3lJ8UNyiFeKkuHPh0Q7hopzW1CbkGey5ZcQxAygaUBzw+IdBy3Hy?=
 =?us-ascii?Q?brFDWkFZRPT1YFFLol2o/7JM5Gf8RMdThgPX337p8Mi10h3OBkNDjiqx1WUF?=
 =?us-ascii?Q?k7Ppulgw4/JTvaFvhBylAm5cZdApbbUilyXFltiuVpK6eKBDyGrDnCaQimmg?=
 =?us-ascii?Q?GRNm6dwmloYqkEMVV/hkLCskb2vAbA+laMLuFMyhEPy1nsyiLSc+pDW9Xr+4?=
 =?us-ascii?Q?UPvvXYrDOJMX9wTqJQBpFcYP7SK+Bc3fCxRIyra56lXGdr4PxdNSFTSe8nyQ?=
 =?us-ascii?Q?+dUujJBrz1ZxteMzLiiUM2DCGCEbpYcFAY7MrzAVGu3ZiCVGw+uUx2Hx6fNl?=
 =?us-ascii?Q?kuI7jJ0A8F0aVEval35kGd7ndttbbipQqMfDzftVJTyRhhMlikpNJq0nNbSf?=
 =?us-ascii?Q?ly1B1wEQ9uri4Xp6mmtSD5XOON2ggIPIReOwqwF6BQfx0twCxB2tUZ0TREcD?=
 =?us-ascii?Q?ftSMFDXpzTEyRCTO7/uFkJsDoy3L88RC43X04zSc5CnhUT9cooC53PE7M/Re?=
 =?us-ascii?Q?JO5LhiHaAJv88jNhlGemuP0zBKA9NrmEU/tpnCmQgmeeaL3kL50Z0v9eQSFc?=
 =?us-ascii?Q?6Mxm1MIYCih25CwgQuruTTxfkoiTgG8KHEcVAcFy8j8sN1KVfGzRKXq2gzqw?=
 =?us-ascii?Q?f+/Vu3ODOhjVi8frI6XgmQFz78VX1RJ/PPvxCx8v195+1vCGynajx+MAx1l5?=
 =?us-ascii?Q?lGmJDyLFe0uUSQzk3VD+EQnalIlwiK9JoAAzMiZcPiuF9ogcBidVu/vcd53J?=
 =?us-ascii?Q?435cRoBIwczXblvAu7vkFQWu/dFfvd40j/xgnjEsjbqfr8IF48Jz24k/vhoI?=
 =?us-ascii?Q?c1ig45mt2ztLY/RabOgHTP2STniLUgMIanMmQMM8WFUijErni0jF9Qd1nZN8?=
 =?us-ascii?Q?uJuThRWIho+9wDMTngOoxRcK1qbL7ySSurpqOnH8KuhsAD4cuZxj92LSnmua?=
 =?us-ascii?Q?sYECQ+DPfdkvlguBXSyIhPvc3ztWL6ULhwv/Nuw6RQbpMNV4iYGog6XijK4?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d43d9ea-3167-40c9-0ad2-08dc8fb04ed9
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2024 16:04:17.9320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR02MB9450

From: Catalin Marinas <catalin.marinas@arm.com> Sent: Friday, June 7, 2024 =
10:55 AM
>=20
> On Thu, Jun 06, 2024 at 07:38:08PM +0100, Catalin Marinas wrote:
> > On Thu, Jun 06, 2024 at 11:17:36AM +0100, Marc Zyngier wrote:
> > > On Wed, 05 Jun 2024 16:08:49 +0100,
> > > Steven Price <steven.price@arm.com> wrote:
> > > > 2. Use a special (global) memory allocator that does the
> > > > set_memory_decrypted() dance on the pages that it allocates but all=
ows
> > > > packing the allocations. I'm not aware of an existing kernel API fo=
r
> > > > this, so it's potentially quite a bit of code. The benefit is that =
it
> > > > reduces memory consumption in a realm guest, although fragmentation
> > > > still means we're likely to see a (small) growth.
> > > >
> > > > Any thoughts on what you think would be best?
> > >
> > > I would expect that something similar to kmem_cache could be of help,
> > > only with the ability to deal with variable object sizes (in this
> > > case: minimum of 256 bytes, in increments defined by the
> > > implementation, and with a 256 byte alignment).
> >
> > Hmm, that's doable but not that easy to make generic. We'd need a new
> > class of kmalloc-* caches (e.g. kmalloc-decrypted-*) which use only
> > decrypted pages together with a GFP_DECRYPTED flag or something to get
> > the slab allocator to go for these pages and avoid merging with other
> > caches. It would actually be the page allocator parsing this gfp flag,
> > probably in post_alloc_hook() to set the page decrypted and re-encrypt
> > it in free_pages_prepare(). A slight problem here is that free_pages()
> > doesn't get the gfp flag, so we'd need to store some bit in the page
> > flags. Maybe the flag is not that bad, do we have something like for
> > page_to_phys() to give us the high IPA address for decrypted pages?
>=20
> I had a go at this generic approach, Friday afternoon fun. Not tested
> with the CCA patches, just my own fake set_memory_*() functionality on
> top of 6.10-rc2. I also mindlessly added __GFP_DECRYPTED to the ITS code
> following the changes in this patch. I noticed that
> allocate_vpe_l2_table() doesn't use shared pages (I either missed it or
> it's not needed).
>=20
> If we want to go this way, I can tidy up the diff below, split it into a
> proper series and add what's missing. What I can't tell is how a driver
> writer knows when to pass __GFP_DECRYPTED. There's also a theoretical
> overlap with __GFP_DMA, it can't handle both. The DMA flag takes
> priority currently but I realised it probably needs to be the other way
> around, we wouldn't have dma mask restrictions for emulated devices.

As someone who has spent time in Linux code on the x86 side that
manages memory shared between the guest and host, a GFP_DECRYPTED
flag on the memory allocation calls seems very useful. Here are my
general comments, some of which are probably obvious, but I thought
I'd write them down anyway.

1)  The impetus in this case is to efficiently allow sub-page allocations.
But on x86, there's also an issue in that the x86 direct map uses large
page mappings, which must be split if any 4K page in the large page
is decrypted. Ideally, we could cluster such decrypted pages into the
same large page(s) vs. just grabbing any 4K page, and reduce the
number of splits. I haven't looked at how feasible that is to implement
in the context of the existing allocator code, so this is aspirational.

2) GFP_DECRYPTED should work for the three memory allocation
interfaces and their variants: alloc_pages(), kmalloc(), and vmalloc().

3) The current paradigm is to allocate memory and call
set_memory_decrypted(). Then do the reverse when freeing memory.
Using GFP_DECRYPTED on the allocation, and having the re-encryption
done automatically when freeing certainly simplifies the call sites.
The error handling at the call sites is additional messiness that gets
much simpler.

4) GFP_DECRYPTED should be silently ignored when not running
in a CoCo VM. Drivers that need decrypted memory in a CoCo VM
always set this flag, and work normally as if the flag isn't set when
not in a CoCo VM. This is how set_memory_decrypted()/encrypted()
work today. Drivers call them in all cases, and they are no-ops
when not in a CoCo VM.

5) The implementation of GFP_DECRYPTED must correctly handle
errors from set_memory_decrypted()/encrypted() as I've described
separately on this thread.

Michael

>=20
> --------------------8<----------------------------------
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v=
3-its.c
> index 40ebf1726393..b6627e839e62 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -2212,7 +2212,8 @@ static struct page *its_allocate_prop_table(gfp_t g=
fp_flags)
>  {
>  	struct page *prop_page;
>=20
> -	prop_page =3D alloc_pages(gfp_flags, get_order(LPI_PROPBASE_SZ));
> +	prop_page =3D alloc_pages(gfp_flags | __GFP_DECRYPTED,
> +				get_order(LPI_PROPBASE_SZ));
>  	if (!prop_page)
>  		return NULL;
>=20
> @@ -2346,7 +2347,8 @@ static int its_setup_baser(struct its_node *its, st=
ruct
> its_baser *baser,
>  		order =3D get_order(GITS_BASER_PAGES_MAX * psz);
>  	}
>=20
> -	page =3D alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO, orde=
r);
> +	page =3D alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO |
> +				__GFP_DECRYPTED, order);
>  	if (!page)
>  		return -ENOMEM;
>=20
> @@ -2940,7 +2942,8 @@ static int allocate_vpe_l1_table(void)
>=20
>  	pr_debug("np =3D %d, npg =3D %lld, psz =3D %d, epp =3D %d, esz =3D %d\n=
",
>  		 np, npg, psz, epp, esz);
> -	page =3D alloc_pages(GFP_ATOMIC | __GFP_ZERO, get_order(np * PAGE_SIZE)=
);
> +	page =3D alloc_pages(GFP_ATOMIC | __GFP_ZERO | __GFP_DECRYPTED,
> +			   get_order(np * PAGE_SIZE));
>  	if (!page)
>  		return -ENOMEM;
>=20
> @@ -2986,7 +2989,7 @@ static struct page *its_allocate_pending_table(gfp_=
t
> gfp_flags)
>  {
>  	struct page *pend_page;
>=20
> -	pend_page =3D alloc_pages(gfp_flags | __GFP_ZERO,
> +	pend_page =3D alloc_pages(gfp_flags | __GFP_ZERO | __GFP_DECRYPTED,
>  				get_order(LPI_PENDBASE_SZ));
>  	if (!pend_page)
>  		return NULL;
> @@ -3334,7 +3337,8 @@ static bool its_alloc_table_entry(struct its_node *=
its,
>=20
>  	/* Allocate memory for 2nd level table */
>  	if (!table[idx]) {
> -		page =3D alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
> +		page =3D alloc_pages_node(its->numa_node, GFP_KERNEL |
> +					__GFP_ZERO | __GFP_DECRYPTED,
>  					get_order(baser->psz));
>  		if (!page)
>  			return false;
> @@ -3438,7 +3442,7 @@ static struct its_device *its_create_device(struct =
its_node
> *its, u32 dev_id,
>  	nr_ites =3D max(2, nvecs);
>  	sz =3D nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1)=
;
>  	sz =3D max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
> -	itt =3D kzalloc_node(sz, GFP_KERNEL, its->numa_node);
> +	itt =3D kzalloc_node(sz, GFP_KERNEL | __GFP_DECRYPTED, its->numa_node);
>  	if (alloc_lpis) {
>  		lpi_map =3D its_lpi_alloc(nvecs, &lpi_base, &nr_lpis);
>  		if (lpi_map)
> @@ -5131,8 +5135,8 @@ static int __init its_probe_one(struct its_node *it=
s)
>  		}
>  	}
>=20
> -	page =3D alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
> -				get_order(ITS_CMD_QUEUE_SZ));
> +	page =3D alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO |
> +				__GFP_DECRYPTED, get_order(ITS_CMD_QUEUE_SZ));
>  	if (!page) {
>  		err =3D -ENOMEM;
>  		goto out_unmap_sgir;
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 313be4ad79fd..573989664639 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -57,6 +57,9 @@ enum {
>  #endif
>  #ifdef CONFIG_SLAB_OBJ_EXT
>  	___GFP_NO_OBJ_EXT_BIT,
> +#endif
> +#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
> +	___GFP_DECRYPTED_BIT,
>  #endif
>  	___GFP_LAST_BIT
>  };
> @@ -103,6 +106,11 @@ enum {
>  #else
>  #define ___GFP_NO_OBJ_EXT       0
>  #endif
> +#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
> +#define ___GFP_DECRYPTED	BIT(___GFP_DECRYPTED_BIT)
> +#else
> +#define ___GFP_DECRYPTED	0
> +#endif
>=20
>  /*
>   * Physical address zone modifiers (see linux/mmzone.h - low four bits)
> @@ -117,6 +125,8 @@ enum {
>  #define __GFP_MOVABLE	((__force gfp_t)___GFP_MOVABLE)  /*
> ZONE_MOVABLE allowed */
>  #define GFP_ZONEMASK
> 	(__GFP_DMA|__GFP_HIGHMEM|__GFP_DMA32|__GFP_MOVABLE)
>=20
> +#define __GFP_DECRYPTED	((__force gfp_t)___GFP_DECRYPTED)
> +
>  /**
>   * DOC: Page mobility and placement hints
>   *
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 104078afe0b1..705707052274 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -127,6 +127,9 @@ enum pageflags {
>  #ifdef CONFIG_MEMORY_FAILURE
>  	PG_hwpoison,		/* hardware poisoned page. Don't touch */
>  #endif
> +#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
> +	PG_decrypted,
> +#endif
>  #if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
>  	PG_young,
>  	PG_idle,
> @@ -626,6 +629,15 @@ PAGEFLAG_FALSE(HWPoison, hwpoison)
>  #define __PG_HWPOISON 0
>  #endif
>=20
> +#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
> +PAGEFLAG(Decrypted, decrypted, PF_HEAD)
> +#define __PG_DECRYPTED	(1UL << PG_decrypted)
> +#else
> +PAGEFLAG_FALSE(Decrypted, decrypted)
> +#define __PG_DECRYPTED	0
> +#endif
> +
> +
>  #ifdef CONFIG_PAGE_IDLE_FLAG
>  #ifdef CONFIG_64BIT
>  FOLIO_TEST_FLAG(young, FOLIO_HEAD_PAGE)
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 7247e217e21b..f7a2cf624c35 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -422,6 +422,9 @@ enum kmalloc_cache_type {
>  #endif
>  #ifdef CONFIG_MEMCG_KMEM
>  	KMALLOC_CGROUP,
> +#endif
> +#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
> +	KMALLOC_DECRYPTED,
>  #endif
>  	NR_KMALLOC_TYPES
>  };
> @@ -433,7 +436,7 @@ kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH
> + 1];
>   * Define gfp bits that should not be set for KMALLOC_NORMAL.
>   */
>  #define KMALLOC_NOT_NORMAL_BITS					\
> -	(__GFP_RECLAIMABLE |					\
> +	(__GFP_RECLAIMABLE | __GFP_DECRYPTED |			\
>  	(IS_ENABLED(CONFIG_ZONE_DMA)   ? __GFP_DMA : 0) |	\
>  	(IS_ENABLED(CONFIG_MEMCG_KMEM) ? __GFP_ACCOUNT : 0))
>=20
> @@ -458,11 +461,14 @@ static __always_inline enum kmalloc_cache_type
> kmalloc_type(gfp_t flags, unsigne
>  	 * At least one of the flags has to be set. Their priorities in
>  	 * decreasing order are:
>  	 *  1) __GFP_DMA
> -	 *  2) __GFP_RECLAIMABLE
> -	 *  3) __GFP_ACCOUNT
> +	 *  2) __GFP_DECRYPTED
> +	 *  3) __GFP_RECLAIMABLE
> +	 *  4) __GFP_ACCOUNT
>  	 */
>  	if (IS_ENABLED(CONFIG_ZONE_DMA) && (flags & __GFP_DMA))
>  		return KMALLOC_DMA;
> +	if (IS_ENABLED(CONFIG_ARCH_HAS_MEM_ENCRYPT) && (flags &
> __GFP_DECRYPTED))
> +		return KMALLOC_DECRYPTED;
>  	if (!IS_ENABLED(CONFIG_MEMCG_KMEM) || (flags & __GFP_RECLAIMABLE))
>  		return KMALLOC_RECLAIM;
>  	else
> diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflag=
s.h
> index e46d6e82765e..a0879155f892 100644
> --- a/include/trace/events/mmflags.h
> +++ b/include/trace/events/mmflags.h
> @@ -83,6 +83,12 @@
>  #define IF_HAVE_PG_HWPOISON(_name)
>  #endif
>=20
> +#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
> +#define IF_HAVE_PG_DECRYPTED(_name) ,{1UL << PG_##_name, __stringify(_na=
me)}
> +#else
> +#define IF_HAVE_PG_DECRYPTED(_name)
> +#endif
> +
>  #if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
>  #define IF_HAVE_PG_IDLE(_name) ,{1UL << PG_##_name, __stringify(_name)}
>  #else
> @@ -121,6 +127,7 @@
>  IF_HAVE_PG_MLOCK(mlocked)						\
>  IF_HAVE_PG_UNCACHED(uncached)						\
>  IF_HAVE_PG_HWPOISON(hwpoison)						\
> +IF_HAVE_PG_DECRYPTED(decrypted)						\
>  IF_HAVE_PG_IDLE(idle)							\
>  IF_HAVE_PG_IDLE(young)							\
>  IF_HAVE_PG_ARCH_X(arch_2)						\
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2e22ce5675ca..c93ae50ec402 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -47,6 +47,7 @@
>  #include <linux/sched/mm.h>
>  #include <linux/page_owner.h>
>  #include <linux/page_table_check.h>
> +#include <linux/set_memory.h>
>  #include <linux/memcontrol.h>
>  #include <linux/ftrace.h>
>  #include <linux/lockdep.h>
> @@ -1051,6 +1052,12 @@ __always_inline bool free_pages_prepare(struct pag=
e
> *page,
>  		return false;
>  	}
>=20
> +	if (unlikely(PageDecrypted(page))) {
> +		set_memory_encrypted((unsigned long)page_address(page),
> +				     1 << order);
> +		ClearPageDecrypted(page);
> +	}
> +
>  	VM_BUG_ON_PAGE(compound && compound_order(page) !=3D order, page);
>=20
>  	/*
> @@ -1415,6 +1422,7 @@ inline void post_alloc_hook(struct page *page, unsi=
gned int
> order,
>  	bool init =3D !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
>  			!should_skip_init(gfp_flags);
>  	bool zero_tags =3D init && (gfp_flags & __GFP_ZEROTAGS);
> +	bool decrypted =3D true; //gfp_flags & __GFP_DECRYPTED;
>  	int i;
>=20
>  	set_page_private(page, 0);
> @@ -1465,6 +1473,12 @@ inline void post_alloc_hook(struct page *page, uns=
igned int
> order,
>  	if (init)
>  		kernel_init_pages(page, 1 << order);
>=20
> +	if (decrypted) {
> +		set_memory_decrypted((unsigned long)page_address(page),
> +				     1 << order);
> +		SetPageDecrypted(page);
> +	}
> +
>  	set_page_owner(page, order, gfp_flags);
>  	page_table_check_alloc(page, order);
>  	pgalloc_tag_add(page, current, 1 << order);
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 1560a1546bb1..de9c8c674aa1 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -737,6 +737,12 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
>  #define KMALLOC_RCL_NAME(sz)
>  #endif
>=20
> +#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
> +#define KMALLOC_DECRYPTED_NAME(sz)	.name[KMALLOC_DECRYPTED] =3D
> "kmalloc-decrypted-" #sz,
> +#else
> +#define KMALLOC_DECRYPTED_NAME(sz)
> +#endif
> +
>  #ifdef CONFIG_RANDOM_KMALLOC_CACHES
>  #define __KMALLOC_RANDOM_CONCAT(a, b) a ## b
>  #define KMALLOC_RANDOM_NAME(N, sz)
> __KMALLOC_RANDOM_CONCAT(KMA_RAND_, N)(sz)
> @@ -765,6 +771,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
>  	KMALLOC_RCL_NAME(__short_size)				\
>  	KMALLOC_CGROUP_NAME(__short_size)			\
>  	KMALLOC_DMA_NAME(__short_size)				\
> +	KMALLOC_DECRYPTED_NAME(__short_size)			\
>  	KMALLOC_RANDOM_NAME(RANDOM_KMALLOC_CACHES_NR, __short_size)
> 	\
>  	.size =3D __size,						\
>  }
> @@ -889,6 +896,9 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type ty=
pe)
>  	if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type =3D=3D KMALLOC_NORMAL))
>  		flags |=3D SLAB_NO_MERGE;
>=20
> +	if (IS_ENABLED(CONFIG_ARCH_HAS_MEM_ENCRYPT) && (type =3D=3D
> KMALLOC_DECRYPTED))
> +		flags |=3D SLAB_NO_MERGE;
> +
>  	if (minalign > ARCH_KMALLOC_MINALIGN) {
>  		aligned_size =3D ALIGN(aligned_size, minalign);
>  		aligned_idx =3D __kmalloc_index(aligned_size, false);



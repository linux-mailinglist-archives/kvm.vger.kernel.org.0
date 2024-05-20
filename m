Return-Path: <kvm+bounces-17797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CDC68CA34E
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 22:32:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20F9B281323
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 20:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652C613957B;
	Mon, 20 May 2024 20:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="T6GOYDuB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10olkn2063.outbound.protection.outlook.com [40.92.42.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8895CD27A;
	Mon, 20 May 2024 20:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.42.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716237168; cv=fail; b=fQkaf9h4PEA+iU+u9SRe3nsuG8yR3FNNSma0/FXYDjsxu+E416/4u14KzPYYhWqbMKD2vpmIKtFNUY0OOyxLSSTVIXdCUlLTd+kpnAPGTLYS3fDlmHawMPfk6StXPruGgXV1Ht0zuGEcGKbRIj6m28ADlz0IQY68z3F8k8IHXcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716237168; c=relaxed/simple;
	bh=VNAawCNpYBxLWCevty6R9qEOgXbEyUGBwltQiiFSvmo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K9mKn9YLjaYVwnEYem548s1/lVqkMmdY1HoQ5Pz1N6/R5MyDuBwClAAPGq1k4p4SGNUsJSGeORjVR0ATpY6/oNklO+qjZaguBCzr0PCfJ4xs8Mn51JWcQWPtsdu8zbnuXcJ1rlkvLi7HrjEtQCuIUpjK1+TQlj3onKS1gpKehKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=T6GOYDuB; arc=fail smtp.client-ip=40.92.42.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTCUe91FaVsRtYe1/5hrso/lxShT8E8q7XXZk8vIcbM87gz/SpenRh3wly5GLKNkHnjeMntTf1H3cL+gcz2DizUuNtYf3EtgQr3R/ck+je451VCtKFyqVPXht5HFWu4XTJX5PhMErJcgzLp8eGKnZ7EOeyg8ZKKrbqCRECqr8zuJjGDNM47Nk6FEPRCh+E6OfMVa6AqHvPo+fvbeg6dIAqq51nc+Q5Qo9BiX9igwWL6A64QxlMazeexgjrrTSGI9MTb0nboeslde2//mtoWyHWU1JXTpfheH0MsArEY/qVIO7CdZCTF9DaoHNqg3aWOnE941YiHsJpnlEcZgOW64RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tcCKPH0emDOKanEx9C8IU2wtyOaRHKCg/Uzkny1JHKY=;
 b=VlLvqQBq68T3xxlVztMLTkRoWguZdit7bIVAFRP3l6t2tgHz9SDld498avLDP3Yk/4eN1grPW8SJJ+JLhFHRTjH+Iugs1SZ5j/4rV2cr3jog6bMkZfX5KgOARiJ5Ask1oGgPGb/B8r+8f4cfV3rPs64NiH3twwfg3vADw2IgsNbAuorZ+LG7qeK5hjquMwjWgQEXfe/C5L63VLRhyX9uJXwH70HrmdPZ2xaWBNBJxO1QaPocxVEvXJ776+KjtRacSLEyvuwqYHOZUq0VCo0W2KzXYLkGHR9qzDozp2k7JuWpjdXj6DHxTp8Ohaa+Ww6uiWkaZdTiPrsIm3RebWSWaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcCKPH0emDOKanEx9C8IU2wtyOaRHKCg/Uzkny1JHKY=;
 b=T6GOYDuBruYaVvcmW9doc8WMgy6jjwiDmeI8QCu25fGH7HV7QShz7s1Op+LsZiWmdZECFKDUgROfGm7Hzee4toZlBrIXyE6vXSQm7OD9i92Q71hwk+I/Eln0MpLeLlSILV90SU1DnL/svSLX26JyQsM6RrqipsyPcpHrVcmjJw7il0va+uhSulVRReu6TH+IndUnUKpJz/iIKhUVClxqPw55acc6LRgw94vlFkLjXjgImcjuze0YJG1gROSgkYPfu/4Ul8+tXumAKUHyjaGsVmrzNyBEKFmXpL/blGNNoCRCjBadkhE1ZqiXx4TzZDUlNLhmoKPEwrpuJeijKUBcYQ==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by SA6PR02MB10479.namprd02.prod.outlook.com (2603:10b6:806:40a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Mon, 20 May
 2024 20:32:43 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.7587.035; Mon, 20 May 2024
 20:32:43 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>
CC: Steven Price <steven.price@arm.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse
	<james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
	<yuzenghui@huawei.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Christoffer Dall
	<christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Ganapatrao
 Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: RE: [PATCH v2 09/14] arm64: Enable memory encrypt for Realms
Thread-Topic: [PATCH v2 09/14] arm64: Enable memory encrypt for Realms
Thread-Index: AQHajLXQMgjFys++30ujzNf0PFm657GXN7YAgAEZTgCACEIGgIAAOLVA
Date: Mon, 20 May 2024 20:32:43 +0000
Message-ID:
 <SN6PR02MB41578D7BFEDE33BD2E8246EFD4E92@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-10-steven.price@arm.com> <ZkOmrMIMFCgEKuVw@arm.com>
 <5b2db977-7f0f-4c3a-b278-f195c7ddbd80@arm.com> <ZkuABQlGgtbzyQFT@arm.com>
In-Reply-To: <ZkuABQlGgtbzyQFT@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [ociKdzB1dl3m+zvpW8HiKy5UYCiJqXaV]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|SA6PR02MB10479:EE_
x-ms-office365-filtering-correlation-id: b2f7abc6-4f6f-4777-9f4b-08dc790c008f
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199019|3412199016|440099019|102099023;
x-microsoft-antispam-message-info:
 6IrE2GYWU2a83iVBTGnfw/4Ic4mMDsSIcui7Rgo6rzK3N7/PgS7zCxznUOoDpYqEczfF3dSh1GCq4B6i9B4ZT3fkIA+UAfQfGViG9ov5qD+eHO/IH9mTs0APlvh89HAPSK3Eu9nhEgmJIUygghD3doLa2OcC51BvwelPiHDsQ5cVPtE/rhp/KdAIEIrFxc7inqqGrwUChxHP/NeX2dPTwaDmD+geuzCi3NbahS1qi6jA/pr7WvoZlvQGgDkTdpOCxkMcKUPnGvjZ4+2enjrA9ENmminT3b00YCNVqik82SZ/2eqatb/iq3fAplZZD+ltcNIsSTgPAQwr/GMOPw8CkSaKcKboypD4kkwoNt/jjHj4SuZ86HmsNhf0m6gKY82B7h6Yg5F1eXaW670l1m4VFiIXUt9sTZBvKqGy45If4sWYGN4sfZowLZVj63fC51AprA6w7qz3hYJg/JV7ivcdW7ukO+IeaR6i9BjibLLX7JHSgKroPpVghRj0UXDOVsuQrm1/xLsm/TOurhacwkySbOoRCc1zR5C/uQZdr1fO8TIz6aLOrlNYaRBQpZ6XoqCc
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?iq/wpraKhGNNbzTL1pR8Vv6clHxmcYxgyl+Jbw1bnjwQ9el/P9MUeVRhGOdX?=
 =?us-ascii?Q?CDMUMG78Nc3eFFRVhkiG787psfHwne/PqiC+JLD062fdle2q0xjXwmvQDqi/?=
 =?us-ascii?Q?k3liR3vn56cQD/C83hDwBeHRFjq7+ycoIeVXhviPf4xM/31qGhzMDspAfOTM?=
 =?us-ascii?Q?bksRO5/37zzoIfAwobMkgYJCVxrPwpVj+usI8pmNzGToMLl5Ym/6n9dtuifr?=
 =?us-ascii?Q?lK8B4V98daZZPajk5W/Vd+5IdE6KEHhpF5RunUhuaMKRNTpGCthJJjFTF0JY?=
 =?us-ascii?Q?1c6ghhXLuFTE+ibny6tyci6VAU+xS3d6oic2xWkzw6GgrqctxwqXuW496ZvO?=
 =?us-ascii?Q?swrmAlnEiE6LbGUnsb2bNe7ay8HW1TEvoYbDpbboXrqS+qqy7G5zOANr3NM2?=
 =?us-ascii?Q?KuxLXPWAIJYv4C8syVUl/dOjaAJvitVr83jnl048PzdRS+tclCSJu6ySFpx8?=
 =?us-ascii?Q?7/JH2386pTgcDgm48Jw5gD/gIgPaReWZN9OGDp1tHl05mi8XFxx4aDxkbOnw?=
 =?us-ascii?Q?FLtbFF7leXI+Qk0tfdUrmMu906JpJdRXFOjZZ1q2mrHPV4wm2QPGoGaKXy25?=
 =?us-ascii?Q?WmqZHaXmvgxM9vIymsQly0WUDuM7MKI24cnkq3CCVH6bUZ4NezjOPwsdrZIA?=
 =?us-ascii?Q?ppJczdhr1nKMFQoVNDwbSs3a8pejjsrO/VGxRSJnTz1A/JSzhkvwcTKjNFQJ?=
 =?us-ascii?Q?8nvj07F3QN83Ejz/LRSmvfpcGdSSpvgYDuh/LaUAQdd0J4OeCddqpaHE5YPl?=
 =?us-ascii?Q?l5+mj5UViUGgOlyrAJF05166CmkbTpFMi6MBXW0T9CWdKP7e5EFWIwBXTm8i?=
 =?us-ascii?Q?G4DPuqizX+qeHHZSN3UPpKXXfZbl4woCeLeWhH2LBOx7h59IpddOG0HorxSC?=
 =?us-ascii?Q?/xrAMONh5yQht7Iz1oyQf8kJ0Fj7NdA3UNoz85u5aJG5JcL/gW61GwhSo8j6?=
 =?us-ascii?Q?E9dGED7tox80Zb6HXbMQgHbzPSmSk/ZsXkIttJYaZBRo5WFNLMUQixfDPYb5?=
 =?us-ascii?Q?PDDhOXGNosjjNz27djagB5HNpVDcYdmtSrwo5V82uE3xyjeTE3rK12u7gPEh?=
 =?us-ascii?Q?DIPaHE1hHNEqB+zTlhTFPdyLQnUQgKRAAD8HGjRs8DWha0SN7jAVWN0gDePX?=
 =?us-ascii?Q?QWbyDr7f0kQ6Ohgl/iQyj/i7cv9+L3n7htp35IjfHjNgHEXWRn7PNn96y4oe?=
 =?us-ascii?Q?nQz4DicRPcyYavE51DyQXKmd424+NVL+2DbuEs2qR4ABmSqJ9oHrhjk1Vhk?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b2f7abc6-4f6f-4777-9f4b-08dc790c008f
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2024 20:32:43.5594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR02MB10479

From: Catalin Marinas <catalin.marinas@arm.com> Sent: Monday, May 20, 2024 =
9:53 AM
>=20
> On Wed, May 15, 2024 at 11:47:02AM +0100, Suzuki K Poulose wrote:
> > On 14/05/2024 19:00, Catalin Marinas wrote:
> > > On Fri, Apr 12, 2024 at 09:42:08AM +0100, Steven Price wrote:
> > > >   static int change_page_range(pte_t *ptep, unsigned long addr, voi=
d *data)
> > > > @@ -41,6 +45,7 @@ static int change_page_range(pte_t *ptep, unsigne=
d long addr, void *data)
> > > >   	pte =3D clear_pte_bit(pte, cdata->clear_mask);
> > > >   	pte =3D set_pte_bit(pte, cdata->set_mask);
> > > > +	/* TODO: Break before make for PROT_NS_SHARED updates */
> > > >   	__set_pte(ptep, pte);
> > > >   	return 0;
> > >
> > > Oh, this TODO is problematic, not sure we can do it safely. There are
> > > some patches on the list to trap faults from other CPUs if they happe=
n
> > > to access the page when broken but so far we pushed back as complex a=
nd
> > > at risk of getting the logic wrong.
> > >
> > >  From an architecture perspective, you are changing the output addres=
s
> > > and D8.16.1 requires a break-before-make sequence (FEAT_BBM doesn't
> > > help). So we either come up with a way to do BMM safely (stop_machine=
()
> > > maybe if it's not too expensive or some way to guarantee no accesses =
to
> > > this page while being changed) or we get the architecture clarified o=
n
> > > the possible side-effects here ("unpredictable" doesn't help).
> >
> > Thanks, we need to sort this out.
>=20
> Thanks for the clarification on RIPAS states and behaviour in one of
> your replies. Thinking about this, since the page is marked as
> RIPAS_EMPTY prior to changing the PTE, the address is going to fault
> anyway as SEA if accessed. So actually breaking the PTE, TLBI, setting
> the new PTE would not add any new behaviour. Of course, this assumes
> that set_memory_decrypted() is never called on memory being currently
> accessed (can we guarantee this?).

While I worked on CoCo VM support on Hyper-V for x86 -- both AMD
SEV-SNP and Intel TDX, I haven't ramped up on the ARM64 CoCo
VM architecture yet.  With that caveat in mind, the assumption is that call=
ers
of set_memory_decrypted() and set_memory_encrypted() ensure that
the target memory isn't currently being accessed.   But there's a big
exception:  load_unaligned_zeropad() can generate accesses that the
caller can't control.  If load_unaligned_zeropad() touches a page that is
in transition between decrypted and encrypted, a SEV-SNP or TDX architectur=
al
fault could occur.  On x86, those fault handlers detect this case, and
fix things up.  The Hyper-V case requires a different approach, and marks
the PTEs as "not present" before initiating a transition between decrypted
and encrypted, and marks the PTEs "present" again after the transition.
This approach causes a reference generated by load_unaligned_zeropad()=20
to take the normal page fault route, and use the page-fault-based fixup for
load_unaligned_zeropad(). See commit 0f34d11234868 for the Hyper-V case.

>=20
> So, we need to make sure that there is no access to the linear map
> between set_memory_range_shared() and the actual pte update with
> __change_memory_common() in set_memory_decrypted(). At a quick look,
> this seems to be the case (ignoring memory scrubbers, though dummy ones
> just accessing memory are not safe anyway and unlikely to run in a
> guest).
>=20
> (I did come across the hv_uio_probe() which, if I read correctly, it
> ends up calling set_memory_decrypted() with a vmalloc() address; let's
> pretend this code doesn't exist ;))

While the Hyper-V UIO driver is perhaps a bit of an outlier, the Hyper-V
netvsc driver also does set_memory_decrypted() on 16 Mbyte vmalloc()
allocations, and there's not really a viable way to avoid this. The
SEV-SNP and TDX code handles this case.   Support for this case will
probably also be needed for CoCo guests on Hyper-V on ARM64.

Michael


Return-Path: <kvm+bounces-17844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF3A8CB1CE
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 17:58:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1B3E1F23507
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 15:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB461DDEA;
	Tue, 21 May 2024 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="UsanB40S"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02olkn2033.outbound.protection.outlook.com [40.92.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1261E1FBB;
	Tue, 21 May 2024 15:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.44.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716307106; cv=fail; b=GV5UTvZTPDFcAKucmRcdAI90+kv5AaoPeoP8F2/Shnb4LDloU979P7SyFYIz2DcLveuuNknfWjGIXtuDP1CZmey34JIEqxVyORLiKRIdhZMmz0rYzKfl20ceCUzDfGEpK4xAtwobvkI9Y3l6ty+8uTCLwbb8hBFJtDXi6oXeJJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716307106; c=relaxed/simple;
	bh=zD3PNsBK1JnJ8so8iRWEWNXtVjB6f2MDD06u9yOkilc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SDttvyjeeEJivGhpbj/OGf6uFfU0kG6Mml5SvSrFAqb2ldpdvbhmM0cjkyEhMNSmCbFVs06QU1vXY0/cFNoX4Tw5Tfd4hmHfmq/W1zNSnqJCuoZhsz/QurvPO4jycWlsetoBLRpNQGaNTmQCj4J1wso7CnvQvP5Eg1tbSgFUUOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=UsanB40S; arc=fail smtp.client-ip=40.92.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRMpRJboG/2RZnfB25rU7DW9bzR2ksX8wQ0bny8ImSX2cxFyrFrCv0PW6qSDdX54oA+WlelJ24O+SbGsfc+SFbOQDccZqzmtoO1le2ePeht7uOB2Dtpi12Qg23oeZgkKtzahi3VrbT15oCQkrH2LLDIAPH6AoKszG5XFTC745Uc0a+bWzTL7CNOekyN7o+hE6XsIKNFnJwWUa9hz4TiLBTf6LkAlXFi5fB3h84yheUfHs5jBEv0PAJNjhJUIZJOGfjlE2JXafoWMtVKpuLnTRyN6oPZ1zE8JDZSXEyNuvqKWXV0j6xf0zsQbdTh/zXGQtwaZGzBX94/OrAeZGiieVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ob5xk2YJnreaMJErdwOuTIrp5bnMFa/xZAP3EqjzKE=;
 b=Ayjlp1UigjfH6hOBF8uWC1n0ZapZBZiOvfGctTEjd3QKY1dok/K+c4oDEut7Z01uEQ2ySV9qcx3JLW3dQ+cJhSiekOJXXRIFHe2eFMmwo1WO/9j3gAmXm0Fayl6/KmwBPndT2hVPvQg2NA8ZzyRwZcYXRx39p4s8Rd0XVOv4Qe0VGuMaw+9mQeXRavAKzemkbm3GzllAXFjaVqJXIABVT17wbwvzu4JtpP84F18UPHr5X8qlU4tJ3aJws/CMuM7h9GvH7r6D2TYKvSM3P2E6jH4D2gvy/i0C1kGOB3AsV71bhxwxUzU9cTq5v25X1ldKOVS1GcfkAcWdbdUWa+E1Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ob5xk2YJnreaMJErdwOuTIrp5bnMFa/xZAP3EqjzKE=;
 b=UsanB40SsEXccjkwW90k/k6cCiCzLDDAleCjI2s8psun8f+pqns8Tg+tVa8iG4Vc8te/pv3ZNHfyudcd9I0rnlsjbDIoRsYiwPxeY+KkPkGL5MYqHz9ix/FmtCrLkhKy1RF4VXBxW6HKPH6tidDY0nxBGmJNJKBsQjUZppbKXF1iilRyIAk6c30jp35j53zDC0HewAYaeYLHSJhQyAYSBG3q0vaIPYc3BmtdJKVRMrt6DHHsuGoSuKtynmKSqkQ8uQWOmYNyWb3zBFxowVS/Ia6Q3gu4n1j2NFwKnBhtgPyjEtKsa6PkMmhfdMqyS0tZeWKNPrtlOpEAfRfrPVjhfQ==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by CH2PR02MB6904.namprd02.prod.outlook.com (2603:10b6:610:83::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Tue, 21 May
 2024 15:58:22 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.7587.035; Tue, 21 May 2024
 15:58:22 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Suzuki K Poulose <suzuki.poulose@arm.com>, Steven Price
	<steven.price@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Marc Zyngier
	<maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse
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
Thread-Index:
 AQHajLXQMgjFys++30ujzNf0PFm657GXN7YAgAEZTgCACEIGgIAAOLVAgADqG4CAAFyJAA==
Date: Tue, 21 May 2024 15:58:21 +0000
Message-ID:
 <SN6PR02MB4157DE40FE34B6FD9AA21FEDD4EA2@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-10-steven.price@arm.com> <ZkOmrMIMFCgEKuVw@arm.com>
 <5b2db977-7f0f-4c3a-b278-f195c7ddbd80@arm.com> <ZkuABQlGgtbzyQFT@arm.com>
 <SN6PR02MB41578D7BFEDE33BD2E8246EFD4E92@SN6PR02MB4157.namprd02.prod.outlook.com>
 <Zkxz-QfzUM_D0SAm@arm.com>
In-Reply-To: <Zkxz-QfzUM_D0SAm@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [iXtUZB8A3tAPzWddfJ6FeXvE0KDYeK/W]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|CH2PR02MB6904:EE_
x-ms-office365-filtering-correlation-id: 62ef91db-a94e-4cd8-e158-08dc79aed6fc
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199019|102099023|3412199016|440099019;
x-microsoft-antispam-message-info:
 kLdqP3zlNmQi50v9YiSR9GjSW/Gc81Q2tVn44nq2K5V7RuWjXmWiGcXuPmk2SMpZt1lY6LKPwRQmfV3XbJYBlMdEM8HYmeKwuXSZrrsLS+dX2Nt8kXTdYOQOVxPs2xYN2LxpxbJKZxM+BC8z/Zo3Mjw7nSquWNz/rNVAR1+SMY6HDcreu4uhm9VYFJg2uR6L/bFJgSq+rdCU1ZABPp1VnXmfepV5v9IYiGGM0n03cNAssFWYYUkdHZCj15ZtHiHBD+bMdzagyot35fvv2cyHDN9UqAFWQMA5Q1TMVRbexDFk0GPhqDqycSU3vz2v9cMJGz/bMYNXM62h3bxsTHBus9vySd7ZfrnhUwmqaeWCLNDS98OeunKIqwROFdnhSfOEp1/sud3s/o7D/pYww1DfnEZ9V1AKNPmNKtM7anR15xmgitpGoMQnAKxsVSEEC0VQHOpx+tiF9zEQ9Cw3fLDGCLOHB3YABH8aT4aGnFAJuFsNn7nyxorrxUnb663/REt4dFW/UC604/g1S1+R6ObuRciyFDz38TLiHea/xwhTh8K9b9VxQ71/ZOGhcr/veAxZ
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?IAuw8gCP4KfGYVCoOB6g2+exgvv3ySuaGeNaFnkn1QHVlz1T4p5ZjejLtnbm?=
 =?us-ascii?Q?9hEF5Z+ySDKmsur/3DfRuYJ5ZBJ5EYBEv4nh9h9/ja4M12IZyrGZ5ej7VChL?=
 =?us-ascii?Q?vbmrZUOM+Yqm9FX/0fHfkAnWtWhuZLimbAObRzgnxQrT041asPPDdCNhd5u3?=
 =?us-ascii?Q?k99VVQYlfqvYYe9g0WSXoS3kNWhfkLBLXJdm5tCdDXf0F9awhnUaTNs+Pw6c?=
 =?us-ascii?Q?j1TDeUbKCzQwDt4mF+2VyhAfmkLO17sx3Jf1QlsoabnMh0sa0tHgPwGV5G2a?=
 =?us-ascii?Q?uVKsZTm1qudlSGFCm5dhT03kr3iyrkDRDf2TZnTGuMnwRUlXzBh/QZ73vZQu?=
 =?us-ascii?Q?CthCveFvMiPuG8X8Xd/6pJP8QeqOswVVjbHhxM0N81fwYDIjnHcaxwZoCcql?=
 =?us-ascii?Q?D2pW/7qpDeeS3CBVOwz2qEAhCIyZwAHQLZFu9NsGQrRMVrLS/2lnsjAlre+K?=
 =?us-ascii?Q?THyce2FzkG5hGX2SDPqJwXDER6Klw1KEVT628+sKSN+PRn/FgvxYHXjgQirQ?=
 =?us-ascii?Q?3xd58PHpn09BiBgm+TfUihUiuyG+MIjRd/WG32e5hIxtZRNgRMw041ZeVfH9?=
 =?us-ascii?Q?L5EMH9CxqqmNxAd4ygnkdt26sqGp3f4+U0zoXlhNLqEH76xgI95/IxVNO5Fv?=
 =?us-ascii?Q?icLxhj0sp18V7AwM5WbcgCaxthx5En6e/XnVLaUsTu1s7/Ptkd3ZgFDK/3zP?=
 =?us-ascii?Q?ijD84/nIPbFoVMqTvmSbtE+zHH7TMcJ4ckkJanQogFu/fzHcPCXlTSSClUIm?=
 =?us-ascii?Q?UUwQoPm0hw+Duu1k5RtefgSHFkIfsKduQa1uM+5pFzvcirnrZ2kx/AFnGFMI?=
 =?us-ascii?Q?y/OCKhN4+XLMnrcMxRAD0QZ8xSXmdIoCSf9VXWy/FdnX9stACB7R450GZfRj?=
 =?us-ascii?Q?R7WKXPMok8EVXkLIjJVPRamXwMh3ruqO4LSEqxy9Lk12h6lt8djJxjaumgsb?=
 =?us-ascii?Q?wzFALBCtS1DszjECK8WHkmCSnOJVjMgNBrwq8RocxYj43mebSDUYFgsFPFVC?=
 =?us-ascii?Q?aKELN8HQ1tEer7aJ7oOjnYT8Y94atU16qf+WbcRbY0c5kZQvAJeUY2rs1PAk?=
 =?us-ascii?Q?wnB9j1jjEFAJqjh8ucNR/NEe6RlGZJWE4OMMeeZd8hjvV+rYCbo0454mgQMV?=
 =?us-ascii?Q?cD6lfDExGngVrkgZV6mQQ0hXlr/W3KBu+ObLCMXzssGJ4H8zStwIfb79O2sF?=
 =?us-ascii?Q?TbR1rDdh3Z4NdQfAd2xet0/0zd2qU/+NRzziyA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ef91db-a94e-4cd8-e158-08dc79aed6fc
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2024 15:58:21.7745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6904

From: Catalin Marinas <catalin.marinas@arm.com>Sent: Tuesday, May 21, 2024 =
3:14 AM
>=20
> On Mon, May 20, 2024 at 08:32:43PM +0000, Michael Kelley wrote:
> > From: Catalin Marinas <catalin.marinas@arm.com> Sent: Monday, May 20, 2=
024 9:53 AM
> > > > > On Fri, Apr 12, 2024 at 09:42:08AM +0100, Steven Price wrote:
> > > > > >   static int change_page_range(pte_t *ptep, unsigned long addr,=
 void *data)
> > > > > > @@ -41,6 +45,7 @@ static int change_page_range(pte_t *ptep, uns=
igned long addr, void *data)
> > > > > >   	pte =3D clear_pte_bit(pte, cdata->clear_mask);
> > > > > >   	pte =3D set_pte_bit(pte, cdata->set_mask);
> > > > > > +	/* TODO: Break before make for PROT_NS_SHARED updates */
> > > > > >   	__set_pte(ptep, pte);
> > > > > >   	return 0;
> [...]
> > > Thanks for the clarification on RIPAS states and behaviour in one of
> > > your replies. Thinking about this, since the page is marked as
> > > RIPAS_EMPTY prior to changing the PTE, the address is going to fault
> > > anyway as SEA if accessed. So actually breaking the PTE, TLBI, settin=
g
> > > the new PTE would not add any new behaviour. Of course, this assumes
> > > that set_memory_decrypted() is never called on memory being currently
> > > accessed (can we guarantee this?).
> >
> > While I worked on CoCo VM support on Hyper-V for x86 -- both AMD
> > SEV-SNP and Intel TDX, I haven't ramped up on the ARM64 CoCo
> > VM architecture yet.  With that caveat in mind, the assumption is that =
callers
> > of set_memory_decrypted() and set_memory_encrypted() ensure that
> > the target memory isn't currently being accessed.   But there's a big
> > exception:  load_unaligned_zeropad() can generate accesses that the
> > caller can't control.  If load_unaligned_zeropad() touches a page that =
is
> > in transition between decrypted and encrypted, a SEV-SNP or TDX archite=
ctural
> > fault could occur.  On x86, those fault handlers detect this case, and
> > fix things up.  The Hyper-V case requires a different approach, and mar=
ks
> > the PTEs as "not present" before initiating a transition between decryp=
ted
> > and encrypted, and marks the PTEs "present" again after the transition.
>=20
> Thanks. The load_unaligned_zeropad() case is a good point. I thought
> we'd get away with this on arm64 since accessing such decrypted page
> would trigger a synchronous exception but looking at the code, the
> do_sea() path never calls fixup_exception(), so we just kill the whole
> kernel.
>=20
> > This approach causes a reference generated by load_unaligned_zeropad()
> > to take the normal page fault route, and use the page-fault-based fixup=
 for
> > load_unaligned_zeropad(). See commit 0f34d11234868 for the Hyper-V case=
.
>=20
> I think for arm64 set_memory_decrypted() (and encrypted) would have to
> first make the PTE invalid, TLBI, set the RIPAS_EMPTY state, set the new
> PTE. Any page fault due to invalid PTE would be handled by the exception
> fixup in load_unaligned_zeropad(). This way we wouldn't get any
> synchronous external abort (SEA) in standard uses. Not sure we need to
> do anything hyper-v specific as in the commit above.

Sounds good to me. I tried to do the same for all the x86 cases (instead of
just handling the Hyper-V paravisor), since that would completely decouple
TDX/SEV-SNP from load_unaligned_zeropad(). It worked for TDX. But
SEV-SNP does the PVALIDATE instruction during a decrypted<->encrypted
transition, and PVALIDATE inconveniently requires the virtual address as
input. It only uses the vaddr to translate to the paddr, but with the vaddr
PTE "not present", PVALIDATE fails. Sigh. This problem will probably come
back again when/if Coconut or any other paravisor redirects #VC/#VE to
the paravisor. But I disgress ....

>=20
> > > (I did come across the hv_uio_probe() which, if I read correctly, it
> > > ends up calling set_memory_decrypted() with a vmalloc() address; let'=
s
> > > pretend this code doesn't exist ;))
> >
> > While the Hyper-V UIO driver is perhaps a bit of an outlier, the Hyper-=
V
> > netvsc driver also does set_memory_decrypted() on 16 Mbyte vmalloc()
> > allocations, and there's not really a viable way to avoid this. The
> > SEV-SNP and TDX code handles this case.   Support for this case will
> > probably also be needed for CoCo guests on Hyper-V on ARM64.
>=20
> Ah, I was hoping we can ignore it. So the arm64 set_memory_*() code will
> have to detect and change both the vmalloc map and the linear map.

Yep.

> Currently this patchset assumes the latter only.
>=20
> Such buffers may end up in user space as well but I think at the
> set_memory_decrypted() call there aren't any such mappings and
> subsequent remap_pfn_range() etc. would handle the permissions properly
> through the vma->vm_page_prot attributes (assuming that someone set
> those pgprot attributes).

Yes, I'm pretty sure that's what we've seen on the x86 side.

Michael


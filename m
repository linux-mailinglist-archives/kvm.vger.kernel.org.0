Return-Path: <kvm+bounces-19754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A9D990A2E3
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 05:33:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5C9B28171B
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 03:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76F8117F39C;
	Mon, 17 Jun 2024 03:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="Akew6/Vq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12olkn2058.outbound.protection.outlook.com [40.92.21.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFFFDDA3;
	Mon, 17 Jun 2024 03:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.21.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718595225; cv=fail; b=poJZOSNPj9sjDw/Yv85gufWYvVbufAXrvTr9Kbmt2A1f2qZQdU792ngMg6ZqoDAYGaWQKDypC2NFdtMg6EcHkP9Rhf1CAFFV/5WDdmBWfz7qqJxIzS4ftTs71n06gU19MwabtYPiyOKSf4kfP3riKeudZUB2aEQjP+7js+ZfDq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718595225; c=relaxed/simple;
	bh=bAk+Plc8vOuCKOKAB4ovQlb/dZSizhlhd6OqDQbwa/M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Alp8E4/SehjPwWJ4MB2tWbrclTAecuwyBzgGxEg0JhBmZAuieBokRiinhnFt/TRBqPFv7r7AUbY704w/Yts9HwWPZVfupgWT4AF9ew3pCaosxkdv04aUCKyl2iLSHK8r8w5XrqZj52t2XIu2Q8gdZ8o3a7614C3Xj7Iv75vWQkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=Akew6/Vq; arc=fail smtp.client-ip=40.92.21.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyetlkmWJCRwr9hi+iI0hM9ZboQWiZq+ICN56KFi3BFrz2iwAAWcew7+8SMV4pC7SqiR33XMO5qgNzuKtCZi0Gu6FDU9DK/65Ng3aI9ocpNZPpZTkrdRyi7ttHSEyWgT6reG/ez0yFu5F3+FqbceM7181VIGMOXHAhPDOKQHpkskVvMdrg2sS2EUG0JiiyAr8oF/tOETtbnOrK0y3I88WvZGq9tspzzxNsb6t8n2TVfhPAGzwt5mWwMsHAo81XpVDhAwLCkxgzdMGVtzcgvnhTRW5ZinThnuZDCAYpXKnyMq41B6p+w39uoIM2Ul3cG9HUOue6BtWYG86FaqYoeR9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=21xyLqQigw+Ez1WkkI4dh/40HKeaa+4NYKdS2IHwIcI=;
 b=IVUrzvLCviJgZl/n9cgH0v86cZA3HIHYYyfp/v/+zWMQy8uNkUbRPThvM4ovMmDno/lewTsjblX1YKbbb3cY5/9MrQsUXksYDY2GgZL2P99m3smTPFZ6ppzEqfouuFYksm7otOzhEU5LV2krspakp33K2WEloQtoMHpe7vQZONV3ikUH0n/CTiDCjPSl21O9rfRz7JNsXk8BEazKrItIogykJR3JReTUK+im6dTSUQeWtMlYhCIxL1icLrSFzV3yiQ2t4uwi6MikPNQgrl3SNchotKo5kh8Fp8EhYmR0bh9gXpYpA4fFrTtm3cJLFJM63VF5sxo0TwZqMsPEd47TBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21xyLqQigw+Ez1WkkI4dh/40HKeaa+4NYKdS2IHwIcI=;
 b=Akew6/VqgeM/mKJyQdFqJFcHLCQrmF+hdzo+PuwananNzd4+so5BepgW3LSzoMclkG3WmM9M8Z0f0AiNRxbLTGaRVd6BXMp/7T1BNdAuRFspIGseHU5bvdf1YaRRnlzk5ouMHeW6qeSTJLIlr4x/vZn0zQGiUQp6vgBMuRTlV+6wxHX9gZ6yPYYlYxA94ugupqTAtCPixSqVXs9jW/34HnY2N3iMId/Wnw0AZIl9xyyI1DiNZJLPmyX0tZDMGnpwXkCljpSc/vphOgm+RykrvaNX9XXLZH7a+VGXFz31oiwlE+q4K0yStxpTO8hOlC6gvtqFgGePhEb3yBTdiviOMA==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by CH3PR02MB10535.namprd02.prod.outlook.com (2603:10b6:610:20b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 03:33:41 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.7677.024; Mon, 17 Jun 2024
 03:33:41 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Steven Price <steven.price@arm.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
CC: Suzuki K Poulose <suzuki.poulose@arm.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon
	<will@kernel.org>, James Morse <james.morse@arm.com>, Oliver Upton
	<oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Christoffer Dall
	<christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Ganapatrao
 Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: RE: [PATCH v3 10/14] arm64: Force device mappings to be non-secure
 shared
Thread-Topic: [PATCH v3 10/14] arm64: Force device mappings to be non-secure
 shared
Thread-Index: AQHatyuoktsEyvA+5U6nclVJ10j8LLHLXc9w
Date: Mon, 17 Jun 2024 03:33:41 +0000
Message-ID:
 <SN6PR02MB4157D26A6CE9B3B96032A1D1D4CD2@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-11-steven.price@arm.com>
In-Reply-To: <20240605093006.145492-11-steven.price@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [H3lG16CAVJareHP81Rg6f3iFGMCA0MqK]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|CH3PR02MB10535:EE_
x-ms-office365-filtering-correlation-id: 5a94a02e-8712-44f0-bd84-08dc8e7e486e
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199025|440099025|3412199022|102099029;
x-microsoft-antispam-message-info:
 9Zuc3p8aEaBDeDCIK4wq4b9ZlCGM6D6YvFRslYuiAg/1ftXssR0EZOezFL/+/t4sFW7+qwU9i0qBdLriV938xLY07IfiMev2nTRZJzzWngeGJiQSL01uZgJ8o7eOpLCfUEKWXzspTn5uMMv6h8Hljj+Wu+H5zrqTMVbgRBAsbAupWLt8lLjoXO55VBwxtiLect+0TthPKSsAmUOQZdtvNT9qsc46mptu30JxMCFh4SVge6cF9FjPO/C/eH2MnlcMgK5txHUrMtgeniBrjjmkEINSR3jJ5Ec3FBikVyiyMwBeOHpm7fUmjAEG/qOErtQlub7IDm1Q6dIGVlquVvwj3XtVhV1joxQavxYmsJXhJOnijZylqLXby+S72JcOpKvrP9nyR40oLv3RjSsEDl576ACXtFKr+VLDmC4LsZTsr/K9VD1CdLncGZRyNkNBr0lHwXmU5bVuOWuuk67Yxsg6DO3pTp3NQN16J3tOqoHITR7cVxMOdo2oe+UVJo4YT2TRKPRyxb96V0+dHk1KmcZv4B9fJQkGUViBEaVZ0ME1m8XZ0Yz1UKbJe/vYFqCF9kjP
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?g1tIP6gneK7qAuIi6xXh9CWwtQhJYV1RmCPMFbD+IkJByhc4MLaxPtseV2Bo?=
 =?us-ascii?Q?T4EGYsbQxjETsm2W6Gn6OfOqtqiOB0ngIBX2dIQkJGMXu+nI5KfU2193jzEF?=
 =?us-ascii?Q?oWi5/CgCiZc3y3LSKnxghl6N9aILCyF6874I+eobHKNt5YLSpiTdwMzOpE87?=
 =?us-ascii?Q?3+icNLf6kkj+dkAHwYgFbQWtHzaTB+mKuqxXy/sfjEZ63/4ssQNj2ao2yi04?=
 =?us-ascii?Q?2eMdRzrcNPdc5PC7zx9D4mo075pzLiqhOp6WBvqxdNlTQYBP0txKHf7raW9Y?=
 =?us-ascii?Q?IeeP3I/xG9ZB+GfdR4BFKf3vvojcWeM30PMwi5f1YpMYOGgPvsFrDGEzMy54?=
 =?us-ascii?Q?WlR4ZTacJ9EHvQgwRRthF5YNHW+qtpN/wqjTqsEtWPXYcayef1vDRjpGfe3L?=
 =?us-ascii?Q?OgkVF+IaTNMjJUfG25OL24dxsD1PaxYewDKkMcutKiUd/fQngIT+vIwfFFTK?=
 =?us-ascii?Q?dFKqnOmOKML26vc0GuWa9IU5g6T0vCiTbtsPdHiL+O4dt4LMXtwfIvuPMMQp?=
 =?us-ascii?Q?WC2hkVZJwwzlptGqJr9JjdLNkh7ftJod6+l1CVBW7o1DiBvMVqhftq22hGBo?=
 =?us-ascii?Q?1kw3Uj5HRBZVr2sklD+LWrqzBA/3XjTbVi0ofCRB3lAg0Glkmowb7/9NSmAA?=
 =?us-ascii?Q?I1HTij2mxyi85qnx8z/cFOYWiD2bAhTakyEi/ydOZ2Ypfvp1PexG4shn01+H?=
 =?us-ascii?Q?zOJ5kzmXWh8LQkCrsfH5x3fxWEbXmFRE97NburK55rP+/j1Fcx4dk5iNPoFL?=
 =?us-ascii?Q?TCaVgpjCxikbJNFHBNnzQ7qYc4+0Q8b1mVfJsI3Lpv9uLbGkL8knavXuCtpG?=
 =?us-ascii?Q?t9U8qO8NM1EUhrIIwnUcHZ6BMIq2zllBX1LP9PboLGTb89XQomicSkpTV+b/?=
 =?us-ascii?Q?qo+8KtsyfM4P5DiIOkwwXNdillI1amxrBQzTP8g4HQz4L6Y2oxv6aWQbuQUp?=
 =?us-ascii?Q?xUwyzBH12Nc4NGYCcyAMZCnJpGPLbRpcExxgB3ldoLow1872EnX64lnDuDdE?=
 =?us-ascii?Q?OwDVIK52RigBXORatCVIPWecaUOm5/z2EQhUus5YgRyv+jLtqYsx+Cry3PL5?=
 =?us-ascii?Q?dEYY63N1/DC2FQBGHFUT5U8vdQK6+QMBdMzu1EG40jwg0LL7QhFiI6SZBeGu?=
 =?us-ascii?Q?p4rFs3BeiiA++yqvCEoU48OtBnOelZm5fM9Dlmf69WUkLli3MJjgV5jFucy4?=
 =?us-ascii?Q?1OWbIQQU65GE1tLTsZzCDl0Hd5RyYoPcwCDTHQIPXGTTbrE32fCqoq5d+yU?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a94a02e-8712-44f0-bd84-08dc8e7e486e
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2024 03:33:41.1823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB10535

From: Steven Price <steven.price@arm.com> Sent: Wednesday, June 5, 2024 2:3=
0 AM
>=20
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>=20
> Device mappings (currently) need to be emulated by the VMM so must be
> mapped shared with the host.
>=20
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pg=
table.h
> index 11d614d83317..c986fde262c0 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -644,7 +644,7 @@ static inline void set_pud_at(struct mm_struct *mm, u=
nsigned long addr,
>  #define pgprot_writecombine(prot) \
>  	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC) | P=
TE_PXN | PTE_UXN)
>  #define pgprot_device(prot) \
> -	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) =
| PTE_PXN | PTE_UXN)
> +	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) =
| PTE_PXN | PTE_UXN | PROT_NS_SHARED)
>  #define pgprot_tagged(prot) \
>  	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_TAGGED)=
)
>  #define pgprot_mhp	pgprot_tagged

In v2 of the patches, Catalin raised a question about the need for
pgprot_decrypted(). What was concluded? It still looks to me like
pgprot_decrypted() and prot_encrypted() are needed, by
dma_direct_mmap() and remap_oldmem_pfn_range(), respectively.
Also, assuming Hyper-V supports CCA at some point, the Linux guest
drivers for Hyper-V need pgprot_decrypted() in hv_ringbuffer_init().

Michael


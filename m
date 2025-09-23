Return-Path: <kvm+bounces-58569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F6FB96CE0
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 18:23:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E252416F618
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6571322C63;
	Tue, 23 Sep 2025 16:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pkuvilvR"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010030.outbound.protection.outlook.com [52.101.85.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517F730F554;
	Tue, 23 Sep 2025 16:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758644590; cv=fail; b=PF0o2ve05F9ajsYiYqAgh4Gk+46gucgDBjry9T1wzPGZ7u86EIg/fCR3AY8XuM3xDKRrxNhXmXE0sb+5VBQ0n6Iu3c2E8kJWIN1SJj1rsA+UzUlksbzl4EUSaEIWBwXf49TaKd9WUCtW92VIg5jeXj4zGnkcsz+5FMBsLUQxeV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758644590; c=relaxed/simple;
	bh=RjgR2OzECULxxVT0Kw72jgxSBepbHvZ2N+ekWJXA7W0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QOVTua3N99XVC7yKHQjUQvDICUMFRacC4uAyN6jBsCAXpUTyZeM60vs8+d5vgesqusaB612LxwsuUfntapZrcS/0PDuGXFzrqbwBUGEVZTRwkYele5/ssNgq42Z1tH3S9+dfVCR9GCMLq7oGSmdYnOciG1GwEWSioy5BbFiOSoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pkuvilvR; arc=fail smtp.client-ip=52.101.85.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=llCasDgSRgNzxFhKXjYPYElu+sZ6SqodTR1GJTyEfr8raGbQ/ISLtcJ8uSBbI38n39AS9CyneleC288qi6GFlQpQ7Geeddp8I3TgLmf8PirUu/CFUeOvdCrfRgXEL3okg3uVGD6InIce/3ett453pkg6fmtVu4j431NA3SRGt1BuTh2Fi6KgHI9IhFSM7WSE4Txaj97Dgf9QGNEIqma5VnPaOr3Fm9oONTteo9/0EOzyRo6cARin03vTG8ubt0vW81Ff/SrZHgvCLfa6t2+s4hNXfSF5u1T5fWSnpHcMaZBMcU13DuJ+5+76t9S5tedKD4wcrDliXs155Si71nbFrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RjgR2OzECULxxVT0Kw72jgxSBepbHvZ2N+ekWJXA7W0=;
 b=QtYIwQ7S0rn3HZmwV5W6wQ3zinZ4h8jXbdIFkb2hkOHTwu19Dzglzk7LQoEd78/qlpEOYx9D6tDwkIu90e+igK8DH0wBt674X4ugpfCZe+tO/f4iAE4CJYwUBwH9iavC2FUwvULeM7adK9MCc3K8QIYBNDrcmMDI3HyezlmJB5OFBn9CsjQSAaI2hWuAVa1s7/F+rW0cQ++mOvP6Pnh5ivsiIizrHSnA1P91NnLMm5jN9YkbLLa3TUZm69BfNM5nDuK5Dnt3DJ0af9Bd/rbJ4AfKqUfXUs6phnQfF7diwXG7PaCsZtyZuF32/oTvfXufg2CdMhnJLi9FpBAsAVLo6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RjgR2OzECULxxVT0Kw72jgxSBepbHvZ2N+ekWJXA7W0=;
 b=pkuvilvRLA4XF0oyYwavKCcy2o2RSzBj+jPm1PRxT+wPtvzTLNsJKIevv8tHs6G38yg/vOLQSzqAzkGW+VNC1kdjqO+epwVx69IhzH0wHPiQ4yDc1X02ZI0hjxBZ2rKyjh+eFDbo5YkLTBZB0x5lgYk14F3BI9DRus4HAT/u9U4pz6Xm9riQ9sOX5sEFYJPQ8iMESCfxLy3uQkiNYs2QGf7R4Fdt+stguJ1Tv1geYP65hWvpsMFIiWx0u02+xpr7VuG7t9To6UlC9anyQyeROxn7HYM4nVZUeQam4m8RxFnEEbYE3k9l6IUMjBENYJK5AkKPKpW/0VVd61GqCXO+SA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SJ2PR12MB8977.namprd12.prod.outlook.com (2603:10b6:a03:539::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 16:23:05 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 16:23:05 +0000
Date: Tue, 23 Sep 2025 13:23:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	zong.li@sifive.com, tjeznach@rivosinc.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
	atish.patra@linux.dev, alex.williamson@redhat.com,
	paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
Subject: Re: [RFC PATCH v2 08/18] iommu/riscv: Use MSI table to enable IMSIC
 access
Message-ID: <20250923162302.GC2608121@nvidia.com>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-28-ajones@ventanamicro.com>
 <20250922184336.GD1391379@nvidia.com>
 <20250922-50372a07397db3155fec49c9@orel>
 <20250922235651.GG1391379@nvidia.com>
 <87ecrx4guz.ffs@tglx>
 <20250923140646.GM1391379@nvidia.com>
 <20250923-b85e3309c54eaff1cdfddcf9@orel>
 <20250923152702.GB2608121@nvidia.com>
 <20250923-e459316700c55d661c060b08@orel>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923-e459316700c55d661c060b08@orel>
X-ClientProxiedBy: SJ0PR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::27) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SJ2PR12MB8977:EE_
X-MS-Office365-Filtering-Correlation-Id: d59f2327-9ae4-4cfa-f6ea-08ddfabd79ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P8ZCB5ls9AsDUJ7CrtTXy5Zn4SnhSeJAAF56jecwk6/ll0KiahBDFEr/U4kL?=
 =?us-ascii?Q?rnxooDBAvLUHSEV7/yBkWd8T8alzIZh43Z0OelGONwZfkyzKnkovozd43jbb?=
 =?us-ascii?Q?f5V55G/3ZELHe9+otzx1jtEi29BszDiKjpKlznXOGfsZaVP/ZVPNWY1WYZcL?=
 =?us-ascii?Q?Ij1H2iY+zB4FGylCR4sPToYuoJvs8fwji5kNw623wFq4dSQ6hSpGOagIkFy3?=
 =?us-ascii?Q?MUIWX71YfwTfxBAKD+oCohoX0+2ynPC9enLG/iKBJ2DK62/z6ZLZWvpHmqJW?=
 =?us-ascii?Q?ViRdOtubsAVEQYiNP+/IEispnwqwbq6k1ucMovK5TQpVHeEkzu62UqmcVS/b?=
 =?us-ascii?Q?l3lhBVQlve5acsprizF1aEzifuIXNYc2TAEzfiMC7H4Vw/8A6Jy0iEfh8I4f?=
 =?us-ascii?Q?M7Tv4wjVhnTruW6VDN04zGjBOMwcMFOid+LKn+8lFN4SJ9q/22zaMh68IkbU?=
 =?us-ascii?Q?6y71oTJktb8O4G2NGqmBJx9rdvn6um0kMuaz3mkKwd5xES4Z3dLOklSfq1Zd?=
 =?us-ascii?Q?DGQGBtfIEB1DDNvFwrLxRUjbXN9eBS2ExVpqllycR3QcUKNZNx5r0njjjm1Z?=
 =?us-ascii?Q?/09JZO5Ya5ArnbMgjd6pUgSpcIXxbTZ/TYkUn96tWwvmBWqayl1fVAjEfDFJ?=
 =?us-ascii?Q?h+nAj3wMucQZqszgUAet4rbeYy3dg3OLb9ZCYxdY8lhMFYOOVW/pRfVMyqcI?=
 =?us-ascii?Q?bgor3HCkiGho+GaawhqzdBuuOKJhu8skUiSHKv9+i7sgFQrADF1fO9X/0jLO?=
 =?us-ascii?Q?skoxqZK3n1NA4RO54djafTKkPnl2vTeEz3hR3eWlxvq7jsJ1+iGJXe2pbQ5X?=
 =?us-ascii?Q?/wnaxkPvnMpqQ04FfZDORB8i8Kks/Ofp9RvpdaiJPsGpqQsmeiYjhSGgu+GJ?=
 =?us-ascii?Q?D9wGOTSUCciW88LCWdewjbWDVsINuK5GHUe7uXM4iKciRqMDQxlaf+S44Wqj?=
 =?us-ascii?Q?+cweiGNTjkZdyxkkVQ1HgmDUI7Lw7BaNCwMF6rzU0vNqpGJsZzVgP+6C3kmP?=
 =?us-ascii?Q?erQHonP5FBdadOe0NOo7KMyHa1VtA7h6cG6DcDlVlgUxl4A82pC3O5iqQnHr?=
 =?us-ascii?Q?90WXhV8uNGTY/KPeYlD+2N9ME4FBDzqsOShE9IQTJcbf42Q+EZnqhAxZELJ4?=
 =?us-ascii?Q?kS542Xh0+w3D10m/kbja8wSAgkZrX1cBGfUV1Fch1YWh8B1jfh/81g0Ih4E+?=
 =?us-ascii?Q?9eUs8TjR3nMRUbEKi1Ppk35GXbXhOBM6vKjY+JA8E0eqHCvrg7beFF2MKYjA?=
 =?us-ascii?Q?ViGBwyahfmuCbDbcV9P2UZj5TuNOKuFfzTrZxWYvpusyiRM8PCsRFzirDy4F?=
 =?us-ascii?Q?H6kgzt8SD2/IeXmRi3kE90ivhqDFFtQgGDTmRQS4oNMHIjcerIU85xwpnx9Q?=
 =?us-ascii?Q?F184MiKvDy5kDxsFbWZe2zX1gBgE2gJ4OHOZ1AfDUHVXJOQdBW65bM5ScUl9?=
 =?us-ascii?Q?1MnlRkwlvrE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uMRNhT+a08cn27i4kIjGKSstq8TRNq96wdJ/ZF2UxD+Ya/4OTZsA38RVYC9f?=
 =?us-ascii?Q?l/2uFxYObV//eo7sm9QCJmQ1Q4IDPE8o0BdLUTGtLvXvpNcaJApUOJw8RDpQ?=
 =?us-ascii?Q?uROj+1soWblSjhZt88CUL3JXiLaNP6XV+1ItIB1WQwQgDCy0Ucw9pcl0i7lb?=
 =?us-ascii?Q?u8oqH/btwFBMYidtldv840LAp4tIIkOtTW4yi0caA3kslqaXtwIFHdoBVX/z?=
 =?us-ascii?Q?SNRE4l4MQ+pazCQje8TinaQZC8g8YeWM4NZOnXUpNmBnHvOpCHnj8N6UfRty?=
 =?us-ascii?Q?A8Ofzx3zjHzdY49qs/SdzpplGUWFpXP+r4X6DbVAFepGIbXyAyxTdy98jYre?=
 =?us-ascii?Q?5UMNtjNaQ+BxqdxeuluzH8bvI+LIKX40Fb0hSZN+Y8t8f7cPLC51HuBX2VIK?=
 =?us-ascii?Q?nrQsJ7YLsF7SDL+Ti7kCDuat4pOCwPf5z3tp8o3oYCnPKVRQ9UjFcir9jcfc?=
 =?us-ascii?Q?teUnTuMPWPsz2vNmtpMWtE2ycpjoKY0PJQE+hSmusyh1DY4UClqOhAtke9C8?=
 =?us-ascii?Q?+AZipHbz3m0kDtd2mx1Vj/zbLQCxfdc+xrAVMzcUCJ8U0xCakSfQf3ZDZMHV?=
 =?us-ascii?Q?HCTIFqDeYcaoSff+58P8h6PVsY0cEwGHpZlucMpZHDdvcxa4/iLkhFzRP7Ej?=
 =?us-ascii?Q?s0Mc/Z+BJKGDKOIEumBnmOjlARt75+SxLDFJQSOzrs48QsaBBf2xVxsjpmnp?=
 =?us-ascii?Q?capKAdA+TatCkLVMMAiZz6a1xW+XE/F6nJybkJg1djDqBKrOf62Z3A8dK7Xp?=
 =?us-ascii?Q?rFap9jkmsM0M89PCG3/fHh9ZfXExl/jDNeXjpAfzhB75J3w1htnXuLENu8SE?=
 =?us-ascii?Q?vIsbIwxkMCgjQBfgQQV/FymPX1w8B2A+9/Yc4qaLWtd/TCOcROgr6hkWYAoc?=
 =?us-ascii?Q?Yq5OozSwpT/F2+mP6/ADzNNLbZHCLvXQ3FLKeiDi1SQvIl1mZips6uA0QAMZ?=
 =?us-ascii?Q?WoLIrHXK7E1ko0H+txuXQLA2OpEkQaTrHKwOtFjciTdZavmbLdXeIvC1oMwQ?=
 =?us-ascii?Q?33N9dPULhoWXiRZZlo9Gl5hOIgh/LaR74fyDtIEEGyojoJUwDXMSrzzJW+Ls?=
 =?us-ascii?Q?k26jMh6rL+Za+GZYpyxQcT0IkY6FD3RP0MMTN95ZZ9AtVLIyUrdKErMjTkDC?=
 =?us-ascii?Q?S/kX9lvJFDhaKTTx67rxvbdE6C31M/7ZDCenCVeS+xuEHnGYOWEj1fzU18Nj?=
 =?us-ascii?Q?GQlwvulY784na36CPP0LWpCWa3C/q5E5W+K6mfnUx3/GSBKDHfBJy/tkHST/?=
 =?us-ascii?Q?nzHoGBKhK1MQXzz7zwaubT/wO9uAHzNKK+r8c9n/Nkmtrmd1u9h2GGzQ2GjB?=
 =?us-ascii?Q?q30AkLVLkQJSIM8e+2xXOXGxDDeEMNKu1FBNq0ToBASTXb8S4zpigaoXUojR?=
 =?us-ascii?Q?bqPR1qwfQAPwZkYQ8HOdjahtuuYAv61iRdX5IQ049qmW9kZL1snf/NhRk9uT?=
 =?us-ascii?Q?XH2iG/zX0ISOjuCAHgWQSTcwb1ih+/ATl/6ooF4k2e9p1Cp02v3bNdlLwedF?=
 =?us-ascii?Q?JlXBJOci6EM3Emwu2JY9ETAqoZ7Op4mVVcxJKxnLun0sTaNg6eSK06y7x65o?=
 =?us-ascii?Q?OfSW0Jv83wMJ7RXH5XMP66w0t/rh/i3BfcoIc7vR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d59f2327-9ae4-4cfa-f6ea-08ddfabd79ab
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 16:23:05.5737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TPPyGUz5g1dhhhgNXYINeStOmakIOGLb9zxetx4GfChKS+2To2NQYSg6wQw4XNEU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8977

On Tue, Sep 23, 2025 at 10:50:56AM -0500, Andrew Jones wrote:
> Yes, this is the part that I'd like to lean on you for, since I understand
> we want to avoid too much KVM/virt special casing for VFIO/IOMMUFD. I was
> thinking that if I bit the bullet and implemented nested support than when
> nesting was selected it would be apparent we're in virt context. However,
> I was hoping to pull together a solution that works with current QEMU and
> VFIO too.

You probably do have to make nested part of this, but I don't have a
clear picture how you'd tie all the parts together through the nested
API..

Somehow you have to load a msiptp that is effectively linked to the
KVM reliably into the DC for the iommufd controlled devices that are
linked to that KVM. Then synchronize with VFIO that this is done and
it can setup KVM only interrupts somehow. This kvm entanglement is the
"virt" you have mentioned many times.

The direct injection interrupt path is already quite a confusing
thing..

Jason


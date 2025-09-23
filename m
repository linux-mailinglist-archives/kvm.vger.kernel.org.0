Return-Path: <kvm+bounces-58531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E671BB96264
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:07:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D79A7B3033
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A80122759C;
	Tue, 23 Sep 2025 14:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rF1I5CBt"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010048.outbound.protection.outlook.com [52.101.201.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161A021C9F4;
	Tue, 23 Sep 2025 14:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758636415; cv=fail; b=reBf/0viPlmYyTgn45iYUSPmDN8UGpNEfA0M/bVaGhzYPyhkNDRhu3FNRRau7v57ryyssJGl1rP4MpIi4TWI3c7ck2TmhJFF+YULaQ6VgfVCKkixnxE+I/cmNxCsupfindaC5/fqQCQpFRL1lKWQaPuQQT8/8cB8ZRRI8jX82lA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758636415; c=relaxed/simple;
	bh=fsMesOOhDAIPPIO+mhOllpcRadV0mK7BcdfPH2WYLLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CY9xgkKCzPJkdTL23KCgWA7t5FZ180Ee/lDsTuWfjgI8oZ5hcBAfFM4Q1/Mmg+Hyq5b6pvHdX87VIouXkBtEOCFdejq3pO7Hhxqg+PDl3F2OXj+N5J9tslwMu/U6UStOLS2tzXesMBZR9ue8bR4IjWLOTsrmI+7/uyclKedaFjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rF1I5CBt; arc=fail smtp.client-ip=52.101.201.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LvfjTdxfpk/yBh/K7m6B81tPX9QmpEVlC7vEJ6c3PX+SPCEwxD1DIn0Efa6YQQ8aMSwRrJX9VQxxcAiRM2yfwYyp30jQEGDhbpAoDbppKe1iyjBa3FksFOK2h3aAvPXvzc2t6ikRtKI2ROQqqR2yscABgJGRrdcVPXiGk0YLJnJMTwz+letBv1puUc+bMzagJBNEqw9glj+kwLf1Jx1LNf6g+GS3TuIVa1LX042g4KCsAFM8XrYE/b87P0EZ8E2x6oJK8S1kWx/n2FYQEra/jwxxyJsvlY4uUxl90miA3O+DV6kBrfc/0dKGDV+2GwG94SXwXRDv7M4kY8HZRrGELg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dU8KG8TBt8VeNziA73m48MhcMtB5VIZ0N/0CxyFeAtQ=;
 b=p/StxvgIiobUd99U0LYlKrHpA45kDqgvq52k2nSZFfLN3K9ywGmTQgujWvcqBg+x9++ZcoEDvgfdqH0Krg2OPF6ory+oaYmCBLfdKWz9wmkhB06Cjob25SWq4DH8Xu9Et0RDD1t0LwFtVB7/bepLoVNQku2/PbsMhy3vRgtI1UYGZboqjN1wCtRTqWcqm6zIyT3rTenoXFow617wj+WIrfYaDqLXTeYqwEVq9w0uOw37MUxL9Rqe8AkPJllvprH6y+uImVsI9z5Ov6TZudzPyiKcbJATFBOz6Jg45p0K9M3o7d0dycZGPYy9juGP/HhUS9voV1mCxswtV6oSwfB5GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dU8KG8TBt8VeNziA73m48MhcMtB5VIZ0N/0CxyFeAtQ=;
 b=rF1I5CBteYdjJRJQGFOLxyhBr3fqEGZl3mILc8q93+OHKE0OYU0cOczjP5uCJrtZKiRlGbyM8wMEwipj5l9+p8HEtgov6QAa0ZLQ6D0jcdt39SkgZ2QUDlsnyQPH4YZcY0d34gb9+SJ8Dgsg9Jjw/telyyGyEdsOGI+G5ZohJYMU/JSXK3Kw6EZbvXMPGoKHa/UyDOewSSBTtofj7xPz20FdVYM+PxADZ6fBEh9a7ZHEkr20t7aKdqM9Jr4z03mRQA82VKgnrkeeylzm1yPjhgOtF0bJ/s3u9Dz93U78+Vi6HkjiNatmUruyRDfv/tyhH4/93s1euGwf9tr2EPz9Rg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by PH7PR12MB7305.namprd12.prod.outlook.com (2603:10b6:510:209::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Tue, 23 Sep
 2025 14:06:49 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 14:06:48 +0000
Date: Tue, 23 Sep 2025 11:06:46 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	zong.li@sifive.com, tjeznach@rivosinc.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
	atish.patra@linux.dev, alex.williamson@redhat.com,
	paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
Subject: Re: [RFC PATCH v2 08/18] iommu/riscv: Use MSI table to enable IMSIC
 access
Message-ID: <20250923140646.GM1391379@nvidia.com>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-28-ajones@ventanamicro.com>
 <20250922184336.GD1391379@nvidia.com>
 <20250922-50372a07397db3155fec49c9@orel>
 <20250922235651.GG1391379@nvidia.com>
 <87ecrx4guz.ffs@tglx>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ecrx4guz.ffs@tglx>
X-ClientProxiedBy: BL1PR13CA0255.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::20) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|PH7PR12MB7305:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f4b83fb-74cf-4098-ca23-08ddfaaa7008
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6LUnmU4F31tWAVX0wmyJHkuSDeWyk8tHIv3uvIANe+NBBcZ0LCI0uCBVPr7n?=
 =?us-ascii?Q?FWQvE0YjDCjn1xU8k/32TqXSnBBv0HVnjyjl9tR8CYMRAV/n0OvdK+yEICTY?=
 =?us-ascii?Q?weHfMpsitRmnNlj2s4UbD8ldoHUSQTz4gQan5IvFWGtZFrj1rVLWqjwmgGpm?=
 =?us-ascii?Q?1yY1sXwfwLFMn+9k7NMkc0FinU0OV0gEJht94EJh8eEohlhZnfQ2e7Nsa8/V?=
 =?us-ascii?Q?RJZ29TO0UmR/xZMfFVqV6mVBk0Dy9fRUyurJkKuO41WFeRVCCYid8UQt9Xdw?=
 =?us-ascii?Q?K2l0CnXRRG/qa1bmDq7jphMtJ+vZr0aHXMnZu+okzNYuNKThJlpap9rHLdSb?=
 =?us-ascii?Q?5PxyP7XeScaLB9R/V3kAxkGfRskQZv+AWEg1/y7OqQG4qHfV+z2xEOX6T28Z?=
 =?us-ascii?Q?I0Ep5z72YDt3DKVlStXv8FeHBXuXWGKpwXef1qbhc/PsaVGL6BCqaHCGyiIY?=
 =?us-ascii?Q?wG1yOeDiaOVIV3Aoo2QJ0ezJpwdBjPXvI6jyiK1RmcLotBAVjSF2ZvWnGgeD?=
 =?us-ascii?Q?8l5BPD4ztaWZu78loZ4usfZqWsX7q8IywZhQBsP+0Nrz2yfNCIIY5952B60g?=
 =?us-ascii?Q?MU9PSt371qhGmjo/sjF5gq12dJb2Cmn/rI3I+V9fZEoq8X4/Xxw+l54dNlA5?=
 =?us-ascii?Q?5pLnlTYbT1c6Ucl87MYp+ar5O0cjTvr9NR6C8KZaTpZbQIbg/EKE6bqy46pd?=
 =?us-ascii?Q?4pXK3I0JPFUlBAbqjyUVw3sHug3dBcfQ2W1LlXfsM2mEjtuNP6aR0vGdxwfI?=
 =?us-ascii?Q?C9UEwwesIMcLBwjQCfF1jSB9QgVZ1nK4ID/vAgMr40A/w+FF1PTBkubraF5T?=
 =?us-ascii?Q?9cmIUPznQn8lOmAGQ1El3dJUdTVC1d2ucxyaQasKen5O4Hvr5RCNYrNlqh1v?=
 =?us-ascii?Q?8Oacz7pxlqV3BURooJgEzg76t9SrugFcOKKFUpokiaO7vWiogro0jxoowngF?=
 =?us-ascii?Q?kbA2wlLHQ+OGsIkSGpw659tRbhxEXOjnrCj4gIcW7jX9/fyjMU1mR5+HDcGX?=
 =?us-ascii?Q?7fOD7M4vQcPIilz8Mz7mLPr1Pf1X5Wxj0vQASRDbC3uH3tfqSFSmom5fimes?=
 =?us-ascii?Q?uGTxAcmRtx0r+U9vKkAclQCnVhG/sLKYzNIj3LigK8GtFOesUfcHLV6ScTtT?=
 =?us-ascii?Q?/XUse/FXnAd2nnvtiQU47W+JAhfv7Ur3chUIkACeU4AukutdoYZccNx5Ylhk?=
 =?us-ascii?Q?mqa1ux2IdGyjthTEyL+il0QNrA3ZWiA7iaLh3cp+agleCQtoLVQ2/LSWFHjp?=
 =?us-ascii?Q?sJNk/9I8XIumRn16a6e/EcxjJOLLRsKi5aJcA+S9tqASqSxaXG/tD5eHrrYC?=
 =?us-ascii?Q?U86Egwd97QOnhtt0oJxhCeI6Lj2JuJZvNh7L1SbpLzmj4WjsGTV5Q5+OaUYl?=
 =?us-ascii?Q?h8m+vYUokdwzrTnABl8GGqKfqWOEC2Th7f3I91vGVa3ldGL+ZpG1rHy6uU+Z?=
 =?us-ascii?Q?qcAiCER6T08=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AhD6g4c6U+Ik2ZzHJc/5QhNVtXbtvnGfWZXuzl2nfIGKAG7XPk6VVJFdj1Fo?=
 =?us-ascii?Q?72N4FQY0NLdSieLtofAgxMdFXGsQsCqSIYeP1CYIrttz8y46Fdq/5AlSDsNk?=
 =?us-ascii?Q?bZrIjGaiDZr7FY0vRAO4BKt1FC0EMTcu3uJOFDtnDt02fiA31IBZc2bVB62d?=
 =?us-ascii?Q?MyzItw+3SO8sOlPqy7HXhmZHnPuiF0bgDJy6+xu9M0De3o+BGNOFsbTj/q7s?=
 =?us-ascii?Q?AgtnTBnz4wU9J1uWa6XQFRXQju+iKYhlEVLmhctheXRT98hJTh/opcY9KFKt?=
 =?us-ascii?Q?MVCednDBhiuJihJoJAaj2GqalZ6cLpyVTYiUSbiGZ3LwKFK4sFpqkmmYhL1n?=
 =?us-ascii?Q?TnBzf2KIpVC4nOM9xpn5SmFiO6pNiUtUzxZXOWxXx8ySVRRGdI9tQvRQYFi0?=
 =?us-ascii?Q?6tVt+Sxg06PsMAZwTaDn/51pjW4V79Gu4+4QuQophP8RDIXuI1nZK7vWzx+U?=
 =?us-ascii?Q?Iop6PQwqa1gQkBOx2MOoqNSenLexqfIGwEsDPGDk6EWALts1HNmamNk2yVVv?=
 =?us-ascii?Q?OKT2BO25QJjKAOAtyndg4zSachoeW9jPRrRhacWLdbPXfUUYFbT8d7mdfpXY?=
 =?us-ascii?Q?juYrAuxgUfn3XHV2nosP2jWUqxuZHGBfNPREtdXHKfwHURaSUCuzlieeIPWw?=
 =?us-ascii?Q?8DguEdemMuHTjYRhs7EuU+VtCPyVxmIMKl2RlNWku27s9v5M9GP6TuaLZBqU?=
 =?us-ascii?Q?SEoSliPdbp7BPm2ME3fKz7qsj6pkErbwfwH5f6XzGoaMIuU33S0zmoJv7sUz?=
 =?us-ascii?Q?AuW2uj52FDtoClPkqLTC75kkCbwrpQCFgDUMukiLSuVfAhZxr/T4S/SxKHHY?=
 =?us-ascii?Q?g8eXLd0R84e0qfWqO+4hUIWcJYMWdKwjNMfNNP68vvDed0JTkXOBYHBy+Bdi?=
 =?us-ascii?Q?VitFbfd0okkSckQnzAknpxN6sDhuWYzvvZAlciEjPUAfpfm7R6oDff4xMFRf?=
 =?us-ascii?Q?FXgkwEfrAMt2NruxK64GQ8wpP0p5sH8LrbFBE3oSYsdd9GRUz985sXtSolop?=
 =?us-ascii?Q?LDZ5zlZx0jZUVwv5BUYKpQ5BTvYNPyqny/MdWaNDRoRGzNR3UulPQhMCW28R?=
 =?us-ascii?Q?76V7VbBMGxclN80qbxf3nQjl7CON4d6Vo7bRqxCQzBRhatiJTXGK8r1a8rD8?=
 =?us-ascii?Q?q5KFR1eP6e6Z6s5C6Vu2vYhJl5KaXN2S+bi1TeZUWTvPqjHYygFvxW8O6hWv?=
 =?us-ascii?Q?ErZD/Lsxfw8rB1zVaNFxGaN0qBobaYf7pzqeQwdnOeEEfKyw6Ue1ditd67wv?=
 =?us-ascii?Q?pf0UAnV7smpHp4Fl8Qv1WZcCqoTLJDnhPD5BHB9kTouEwQ1ptHFGlSlB5cV3?=
 =?us-ascii?Q?FXP4Wt2tILBQvBjuTNpkkM8bPqTZsVVEFyCiyqo827bnuBvE8KXGWLv1+qHC?=
 =?us-ascii?Q?yZWCqwG2MyEgnZg5sjLBCh3wWT6ol5mFsD5MtxHlovSfbgc3S+a32qqZYg+W?=
 =?us-ascii?Q?B87V9GPJDa0rEsiz678SuQMs1lv1W/l2n/uxIGs/R/fW2MmhQ7YNANGOYdn5?=
 =?us-ascii?Q?Witf8E0uwhA7QMzo5oUA8SwFHEREAhB8QdmqXHN5n9IbU0fgxDf4TLiJVQME?=
 =?us-ascii?Q?FlEarxAK0Jo6biqYaKLEIdd5GSPpmY/C6Ymjf66P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f4b83fb-74cf-4098-ca23-08ddfaaa7008
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 14:06:48.9050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gkQ0ErG0wzG352s0T7LMQpQEo09+RV700Qvpxc42Okx4Tsz3hIU3sXRmNlpacncj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7305

On Tue, Sep 23, 2025 at 12:12:52PM +0200, Thomas Gleixner wrote:
> With a remapping domain intermediary this looks like this:
> 
>      [ CPU domain ] --- [ Remap domain] --- [ MSI domain ] -- device
>  
>    device driver allocates an MSI interrupt in the MSI domain
> 
>    MSI domain allocates an interrupt in the Remap domain
> 
>    Remap domain allocates a resource in the remap space, e.g. an entry
>    in the remap translation table and then allocates an interrupt in the
>    CPU domain.

Thanks!

And to be very crystal clear here, the meaning of
IRQ_DOMAIN_FLAG_ISOLATED_MSI is that the remap domain has a security
feature such that the device can only trigger CPU domain interrupts
that have been explicitly allocated in the remap domain for that
device. The device can never go through the remap domain and trigger
some other device's interrupt.

This is usally done by having the remap domain's HW take in the
Addr/Data pair, do a per-BDF table lookup and then completely replace
the Addr/Data pair with the "remapped" version. By fully replacing the
remap domain prevents the device from generating a disallowed
addr/data pair toward the CPU domain.

It fundamentally must be done by having the HW do a per-RID/BDF table
lookup based on the incoming MSI addr/data and fully sanitize the
resulting output.

There is some legacy history here. When MSI was first invented the
goal was to make interrupts scalable by removing any state from the
CPU side. The device would be told what Addr/Data to send to the CPU
and the CPU would just take some encoded information in that pair as a
delivery instruction. No state on the CPU side per interrupt.

In the world of virtualization it was realized this is not secure, so
the archs undid the core principal of MSI and the CPU HW has some kind
of state/table entry for every single device interrupt source.

x86/AMD did this by having per-device remapping tables in their IOMMU
device context that are selected by incomming RID and effectively
completely rewrite the addr/data pair before it reaches the APIC. The
remap table alone now basically specifies where the interrupt is
delivered.

ARM doesn't do remapping, instead the interrupt controller itself has
a table that converts (BDF,Data) into a delivery instruction. It is
inherently secure.

That flag has nothing to do with affinity.

Jason


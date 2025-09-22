Return-Path: <kvm+bounces-58408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31944B929FC
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 20:43:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBD197A5496
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B3BA31A559;
	Mon, 22 Sep 2025 18:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cbFHRS9W"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012013.outbound.protection.outlook.com [40.107.200.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB952EAB64;
	Mon, 22 Sep 2025 18:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758566625; cv=fail; b=XrkVinmjzVAQqxqwjvKNgv3B4KGNY+0YD9eQ80FQlBS/eKPGdoBb8evwHorSd7ZnOYxk3X6pwuP/Z8rtfmra9e14If1rhshmwQoOaY813ChYtMjwqx++mei6pOj70NfJwEoJaYKQ3tMJvngGniA5XA7hCO+4v1qcuDqLqLQ067w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758566625; c=relaxed/simple;
	bh=eolSg0rzExzNDfc7qDIgDzHooaUIUHgfDZtBJtrQv+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EJAE3M3e+1jSizlSzxm3okrIC0N1lUIYFdEeRW87XcxC6sfSyPCDDIrRvRT89BUmxcgx1vYNUbrgXJY3Mj0Q0wfpxPpRZj4kyF0rOgEHD67bZ729uLYTMniuo2C0zW9FTiBnxPQwgPMWrDFhJf6Bqq+X2idZUk3lO2/QWgYDiXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cbFHRS9W; arc=fail smtp.client-ip=40.107.200.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ywaaysgi9UMRJh1LWggraXHMlqW+uW1qiV8s5P3em5kVV0fx1WyM7NhHF0dubPRaB7qHn9tXrlPB7ml18KFRsmmyOWS9zncuILVZv/n3b/N0i49vPotpAagBKGTIuc6Pr3d8is+V+qUFXfsBrWtwzq856/PmomteoaVmLUGnT7WrAe5Irc5OgYE+B11yECCpioaemetxkQtXiZNSg090Q0MbfZ/vtmGoLZOuyqBqKISp2ZpeScEMpDFhMJIE7sk90MtViyX2bcprHGadTO2Sh++VZv7me7WGaxqre7EkHPdX/X+Xi4UxucJZQZS4NtlURFly75oeoJ2OV4xOUdO74A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eolSg0rzExzNDfc7qDIgDzHooaUIUHgfDZtBJtrQv+I=;
 b=PTjfETJI6IHtC6WSmodR1FBodmCdY1arUEcyBi6adK/3mLwjNDzWB5VSDL2oaHMClxqEGFIKVgaJJPRYkF/BIaeqdbHPsjtPF78R24rjpwMy2JTgsMRBcfpnDLvRnLShbmgY/RC5uOo4KOilFfjl4QGCcFzU6W34I1lcz9PdwvexkzJIYzi6xcF/ROH3g63W93afQXhvBKKk1GCecmw6J8thXLg+ZvUBFeU4oSEtiWOy/o6+aVd+NjlkH3bMimrQTGjDjfeqoWgGryHlWKLjK7hRAxThhaghvXxLcLowTTQ4g4pF/rxqcIWYc9S3RYdpdFJoPQC7ylVzEADrirra4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eolSg0rzExzNDfc7qDIgDzHooaUIUHgfDZtBJtrQv+I=;
 b=cbFHRS9Wl7Sm3AD9mlhR10INpFSM9yi56kvY6W++3vPntZNLYo4A4bV43sJq9F0DHwPDBCPtX9bdfIZ6ji5Dwq/0LGs+X1C2zwYR7gdj35iKxwzsIQWKSdXTZrmp5UGTJnbsC82EuYUUPL9nTQS1BzDCmPCxQD8MDqv+sICeOaYSQ7x0SWR+1sS2kk6f5VVHAt4/K8TOk+1SZUYgnc4xX7bB2ldolxvTlZzb3HyshGvLpIHnasXE632WgEEPdXy0758SC0Y1NpdZpLiOj7M89RYnNW8CRWO/ApNOJSdg4XMsQOK+91MABzREg1oh0HALDAAMswqbQ8OarlvLc4i+0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DS0PR12MB9399.namprd12.prod.outlook.com (2603:10b6:8:1b8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.18; Mon, 22 Sep
 2025 18:43:38 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 18:43:38 +0000
Date: Mon, 22 Sep 2025 15:43:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: iommu@lists.linux.dev, kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, zong.li@sifive.com,
	tjeznach@rivosinc.com, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, anup@brainfault.org, atish.patra@linux.dev,
	tglx@linutronix.de, alex.williamson@redhat.com,
	paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
Subject: Re: [RFC PATCH v2 08/18] iommu/riscv: Use MSI table to enable IMSIC
 access
Message-ID: <20250922184336.GD1391379@nvidia.com>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-28-ajones@ventanamicro.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250920203851.2205115-28-ajones@ventanamicro.com>
X-ClientProxiedBy: SA9P221CA0022.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::27) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DS0PR12MB9399:EE_
X-MS-Office365-Filtering-Correlation-Id: a3a5cb85-73e4-43f1-ae0d-08ddfa07f1c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kODFTFjzR2oSUMLIHRSAX4khezXayjrI6p5fC2hdTGvBZLUSVUJmczjLL6dx?=
 =?us-ascii?Q?0lbez1AclY/AJP6HYjN9i0OQkiPK8VDDEbEUX1cZEe9kQ7j4/LpcCp0Dszyv?=
 =?us-ascii?Q?kDROfQDNTJ2C/WWJmJN86gQ+IcvE/XwPo2pjjIpi569F/cMnMl4Rh8u9rNtu?=
 =?us-ascii?Q?/Q+n/0DJrIPLtI0xlm1OiuRLr95rH0ouAYwcwmzy5JcQeMOSf+i/GZAPMXTL?=
 =?us-ascii?Q?Ch6ijPJF1IpFUj4dgvUzAHLvtGpaNR+wKy2jx3ofmhdIxM1ypcfglG0WH4rH?=
 =?us-ascii?Q?0IX3TfMZ43cFTE/nmTaBJjDnhU/VONPxzROdwWVX14yEW5k+/83Hp4v4wr1R?=
 =?us-ascii?Q?angNepYcZ34JfMGj2CPK10O0vAuvUX5xLDHByMxiqXrpyzhJlxgU9jrhrrbc?=
 =?us-ascii?Q?FB2UBkz2RzE9ztLHwLskZfy3JHISI6UJTi2Nlxzn393/J0YnCEpmglwRHv5U?=
 =?us-ascii?Q?Iv1TGvnbFQsDvTbJ8hPG2rYHto23AFeA57PSllgtVPiYuocDlem791Odr5VN?=
 =?us-ascii?Q?cGaWHl/nCsfKoDKer5iYwBTfH1x7vufQibXMjVx0A72DNcKQ9x49svW1eAQd?=
 =?us-ascii?Q?pB2OfkwWrBOsnM4S7m/8wvu3ADe5ogwHsZwQ5/5c1WOEz2NekLj6yH3xMLQy?=
 =?us-ascii?Q?SJy3qjfgpEaGeoU6FJEBwhOX1wJ4U8rGcb6lyaa8YbdyBp9suYPYcu46sQ3M?=
 =?us-ascii?Q?BahgksWltm7Tb/aIAtMP9E/z0pmWgS7VYPDe2ShrMzsIP78+XCKw5tKPCn+n?=
 =?us-ascii?Q?G8bG0ClHv0EOPaSiTJstTdmuiRPkwRV8M7THi6/tE4vn0/Cp9sMu5Fkf5B9x?=
 =?us-ascii?Q?aYSnN+UfHpKCf6iVJpdLfJt+F4Rlrz/PIgPiFf/eQqBwXcgOcvN6wiKrBGHA?=
 =?us-ascii?Q?E8BTsBcbMqOHHpYIBuGP9VXMHs38HwIIpuCpH33/I/3FSxLesvrTOHEDe5VE?=
 =?us-ascii?Q?e2qvy/s5odTG32lH/TuHMRoLI9erUeOi6hswEYyZs8MNJ5VM851YOw4veV74?=
 =?us-ascii?Q?fpps57aqZlI43PXWbahrpeXTGk7hva8X5vfmm+0xYJEtvw3Ia7TchEvtSkQ8?=
 =?us-ascii?Q?vsDBbEDLO/eUPMZdbDwveFS9lVpoFNewiRY9VBBba/pcCzkGcpVFQENfGTT2?=
 =?us-ascii?Q?FT4x3IL2Yj5T1LacUb4BjyaLlBAzm2Zii6X18KVde0jo4Yrn2bFpJxVDLWG3?=
 =?us-ascii?Q?7cbPDcNMPJ5kxeaLOOVxZgzC9ZXQFWhxqYUcRASLKCKG7A/3sdBFfmgS1mAs?=
 =?us-ascii?Q?tN7obiLsFb1qB67UExPrD1vncjTdGFCbQqnvOPzD1oUVAJDXFWj21VRzhRxF?=
 =?us-ascii?Q?FvsYBTBIRUWkosyOvRbYZFiFskZN6fHmr63tnQrkB1zJwMxejwjL/gdLKtMl?=
 =?us-ascii?Q?6cNdR7ub5MoFgYhjlVtWwHYVxcxyaDsLH1NVFSy97x0p3HDdTORXMhpQ1fWR?=
 =?us-ascii?Q?5j5P5WDAiSE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wc9Xp5SRNiblxnZfOhdYMWfOvpj3Kps32pClAeJqUKg+E5YzF676y9zKKJ4s?=
 =?us-ascii?Q?KnrH/CQipRtdN14f2hx+Iz+7wfXpaKz8/57+hyKHBEOgoC1r+myVetSOR6Yc?=
 =?us-ascii?Q?tiL2dnK0MFkHjEYg1Lq+/wSuOJY+VzQ06dP2lEMjS5yQGlGi85AbL2mLyq/l?=
 =?us-ascii?Q?1Il1N44RXl28w+9biSzmLXnhiBmvhm/t9PiX5bczoQtZdsB40j90efCON/Oq?=
 =?us-ascii?Q?XaFUDsNDDXEpB0o4fyzJAG6CW2nGTKmZSMoKjYL2zEFv0Qz4QK0ELq6P0ZSa?=
 =?us-ascii?Q?EREe5H6qvILS1P08NWQV6RxF//7+hetSYT3EGHKDWxyhrwXfhTsWJ2X6QKs+?=
 =?us-ascii?Q?q1hzn8Yo/B48saxQCgOreLfSGwswK32nrRTM0WKkCu69i77KJpyGQ4mEJbuq?=
 =?us-ascii?Q?NtvGw++t2sW4HbqvxPWG8OUYnbhHyUw1vjnAfZKeFXhaMJFKsGJVBGYCJkia?=
 =?us-ascii?Q?c7Ca+tGvFUrBxR1+8MC+sBm2IQU67YBLSYxTW2YGhJMA2m/Plm7nlD8Ibu/J?=
 =?us-ascii?Q?jh++xJJjMhyU9oxGrwxp0A5l1vb/E5BHBiXbGg14ySjRNkkZm154DP3s9i8G?=
 =?us-ascii?Q?jzZC2NtYd6QQJbYS6qKdqQxOoUA84E1aN7bv/bTakazpsApTQja7meTWm7o7?=
 =?us-ascii?Q?zKL0a/vvtLdrfKB/Ip4xLUDMUCwFNuvw+OaqR8cQjA36/sNY1vC0J7gYVVnx?=
 =?us-ascii?Q?BZr+07UwJa7b8P6qrL6W9CVun+nuqGM8J5Pro+i2XKB+MafdUctaM34DC3Wb?=
 =?us-ascii?Q?f6u8snYYX+yVLqcYV8Z1rBqAG71ZoZpGpI1rgrOgg55k/3u0MxdVsSyYTSj4?=
 =?us-ascii?Q?fNk0+XwAQPLYJL3m+Lv+dEUYI11W4dTpUjHr1qGCIKkeKbbSVq4cJdjKWtzl?=
 =?us-ascii?Q?vPZBtzWSUNPdRbtPqx1Wc9UCkhGT6HS/1DhNlYTntYeSXbm+BfLRfIhNqtrt?=
 =?us-ascii?Q?5FpiWZAKkqymAaTx2ka+nUmqVtL63St6r/z6Zy9m+ASOoFEpqCaqX6fEJ8wG?=
 =?us-ascii?Q?R/IlblRG+tAYHiulrqiorQka0I9CPFVqE7ofh83vFg8qinWLnqtrKYDKX+LD?=
 =?us-ascii?Q?AX3JTK9yfKopysjCSHmZi+TbzXkWU5MAEPH9Uo/K4R81tVaVy73JA9NPV1Pv?=
 =?us-ascii?Q?tGMDt19/sB7whDzlNau8laHYe0vVpyaJIP7eWGrpF8AoUHeJ327/7DYlYAg7?=
 =?us-ascii?Q?QcWvXzneQo1t9sTglXvfJXE39NS5nvl2PN0OleyWC8gIDg+nYNQw1rBW0MDy?=
 =?us-ascii?Q?2cKgZL/STPFdf8rn80JmlwAH+BV6BPH48TUpW8vi67AQl9PtGwOKDYH4eNk+?=
 =?us-ascii?Q?mA+ZuTK0LUpji+1HNbzieQNWURXlUDDnWLLlW0IW5kW8KO5ol7hIqUISK3gd?=
 =?us-ascii?Q?K9+F1HDisz0X1UjBgJ9pF5PRT+6PG4kZwlLCeDRIKfOyNAg2UHvbiODLR18f?=
 =?us-ascii?Q?mupBNawckWCbVmrS1PsJubCEuTGXm1zv88wxc4EAzhrOi6/LAYOOScMPQBP/?=
 =?us-ascii?Q?P9kV5+BjQw8G/FrNw0OjCb04C8J3eiBccB0D+9alyR1gI2SNmoP7FZ8JPkAX?=
 =?us-ascii?Q?h2/sDaJbakvR5/LDjDaPRQaSIzdm2TnZfk3Y1zOk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3a5cb85-73e4-43f1-ae0d-08ddfa07f1c3
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 18:43:38.6243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JvtHAFIHa/UEzwAHfxK/OQ7thPGIlPpM/brMTisvs3Y/ttBrm260HK//HfkuBwDw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9399

On Sat, Sep 20, 2025 at 03:38:58PM -0500, Andrew Jones wrote:
> When setting irq affinity extract the IMSIC address the device
> needs to access and add it to the MSI table. If the device no
> longer needs access to an IMSIC then remove it from the table
> to prohibit access. This allows isolating device MSIs to a set
> of harts so we can now add the IRQ_DOMAIN_FLAG_ISOLATED_MSI IRQ
> domain flag.

IRQ_DOMAIN_FLAG_ISOLATED_MSI has nothing to do with HARTs.

 * Isolated MSI means that HW modeled by an irq_domain on the path from the
 * initiating device to the CPU will validate that the MSI message specifies an
 * interrupt number that the device is authorized to trigger. This must block
 * devices from triggering interrupts they are not authorized to trigger.
 * Currently authorization means the MSI vector is one assigned to the device.

It has to do with each PCI BDF having a unique set of
validation/mapping tables for MSIs that are granular to the interrupt
number.

As I understand the spec this is is only possible with msiptp? As
discussed previously this has to be a static property and the SW stack
doesn't expect it to change. So if the IR driver sets
IRQ_DOMAIN_FLAG_ISOLATED_MSI it has to always use misptp?

Further, since the interrupt tables have to be per BDF they cannot be
linked to an iommu_domain! Storing the msiptp in an iommu_domain is
totally wrong?? It needs to somehow be stored in the interrupt layer
per-struct device, check how AMD and Intel have stored their IR tables
programmed into their versions of DC.

It looks like there is something in here to support HW that doesn't
have msiptp? That's different, and also looks very confused. The IR
driver should never be touching the iommu domain or calling iommu_map!
Instead it probably has to use the SW_MSI mechanism to request mapping
the interrupt controller aperture. You don't get
IRQ_DOMAIN_FLAG_ISOLATED_MSI with something like this though. Look at
how ARM GIC works for this mechanism.

Finally, please split this series up, if ther are two different ways
to manage the MSI aperture then please split it into two series with a
clear description how the HW actually works.

Maybe start with the simpler case of no msiptp??

Jason


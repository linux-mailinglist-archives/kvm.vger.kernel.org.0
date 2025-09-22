Return-Path: <kvm+bounces-58432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39EF3B93A73
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 01:57:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EBC8189B083
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 23:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DFE62FF142;
	Mon, 22 Sep 2025 23:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P5nOfohY"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013056.outbound.protection.outlook.com [40.107.201.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B672DEA6F;
	Mon, 22 Sep 2025 23:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758585425; cv=fail; b=oo3uWQh6gcDaQ9LvJ+aOwnGZPxdfQXeShcjHhyK9IcVrmLf1kxn8l3Vv+Wbx4ljbomrYKDX+KcbUy0I1b8sSfAQN27CtnhZkIyQ+RHvjml22iTBxgNy+gIvcPzNW7bFQGfkDl288jcsyxyaES5rl1Gceh9KpfueG4PuuME6Vip8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758585425; c=relaxed/simple;
	bh=RCkORrQzyncrCqJOMlcHIqB38JIFAbC0zBCsOFgSiG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ljun05Aw1H5xB7HMnMKxCl321EklgrOtPkl/GWYG9ndUhvamy+Vlo0vKfqlWmRFMMO/BxN5vMICTlBcEpqhmbXgV24ZEwD+TvoI+V8iXOHpJ+BO4r342pb0wGEEg+iNLtpYHl81Mluao1WnidjPKhvwOCDFkv2Dc6jZ75aSRW9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P5nOfohY; arc=fail smtp.client-ip=40.107.201.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KzdI8xFiXzMJvj7xlBf6qCfsArAhcsnUEMF1V4UJkG7KKGqts2TQTIL+h/36cSfUpVOoxcueLrHiS2YAMrhi9a+QccYlHGOKrLPa4bi8P0t9up/Y4ysA1h5OrsRPAhTw2oFQhBXmeUljMQDZK6vlvQJ4aI4odxIxVa8sT/xyn1juev/ULgB2BbiD5xCsArc8SQ3BOPL0GeaVUTHXnG/3UteqkoXjXhI+u/N5DLd1dW30FWSvpTOTobrUZ2LFcwnGQOVsanUV+OXlT6kbKv0jGXfGHQ/2EXnZBVejzZatVFbXzmIUDLFbFtFAyfgS5qpGt5YUYAhELJMQg+00FVIlRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v5i4wn9cbMwAH5oKmh7YND2E6+fs9j0fd1X1WVlhd+Y=;
 b=I/B4KJJ4hcZZlR8VWfc7uCfS+vo6MdF+qhCb6Mp67HtixPTDWvJt131fo1RHFpIgjNHk6NMszMLOG9vqC82uZIlHOUDeeQ0yVwSpie8dQfTDYRs8JJSmmJo/ABdTKW/ClchLgDYgbTSwiah59fqgIuZdynCN2K/ZhcTB9bymoBL5iIc5h9U25ijnTw3QZ6nDhRfyODsJY/eGvtFWqhXl3kjcbOwCAhOrD30p7IsNxytxfgcmL93Iy9SGCVDjkzIisueJLlM303FpZcfqzoEmLerkM5IDBLJQsaDZ/SvkW9zuSA/AnKLeCGWriCRcX90lFJM0R48BRl4PFAiYTYejrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5i4wn9cbMwAH5oKmh7YND2E6+fs9j0fd1X1WVlhd+Y=;
 b=P5nOfohYV/yPPg/kkGmLgln9D+bUY6Uu04fFbt9Vr8evgQo9uuud1DyROfeTR4GoTipCzYoELjzM3YVMHHW6hYCI/eJHGqtqAfkMlGez3irRQDgseBYYY1mAEiuSjB/pbqUBfkQroCPW/M/nOuCp2rcFUA3zFcViIJ33GEbbLzRu6fE7rB/sPrqvCJcJuCjksiCUDwRElF8PLHtr+L6YJgbVW/zmgbZBwJjEgTMDXyy4EEf6f2fdUXNNz2CB3qINnd/Qs55fUBHRLxZEQtaYHUPj+xxow9Azb6kyUvgXoR8vA4eiGOI4tW1Ig8sXlwQVvMH5re55TGLHiL3+/RYskg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CY3PR12MB9656.namprd12.prod.outlook.com (2603:10b6:930:101::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.18; Mon, 22 Sep
 2025 23:57:00 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 23:57:00 +0000
Date: Mon, 22 Sep 2025 20:56:51 -0300
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
Message-ID: <20250922235651.GG1391379@nvidia.com>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-28-ajones@ventanamicro.com>
 <20250922184336.GD1391379@nvidia.com>
 <20250922-50372a07397db3155fec49c9@orel>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922-50372a07397db3155fec49c9@orel>
X-ClientProxiedBy: SA0PR12CA0008.namprd12.prod.outlook.com
 (2603:10b6:806:6f::13) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CY3PR12MB9656:EE_
X-MS-Office365-Filtering-Correlation-Id: fcaae62f-3834-4914-0498-08ddfa33b794
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GDpoNuH2+3Hk0vy7uOO0uUC1fgSVFCaZrOe0+XrbkhJlgnv0fcSgL/cDdfzq?=
 =?us-ascii?Q?u6sDHy4FplfWICVbuMIwPUQYpIyuIg8ff1M8ydxcV/Gp3xMPS54/wULqZ2K0?=
 =?us-ascii?Q?E4UZynxJFwbfqH6uPrE8BFRkbA+oHzBnU792CfRX4jHBQsSeUWR2MeG4rDq/?=
 =?us-ascii?Q?pyEgj+x3FRwIwcKxhKcbPAXoCYN9EndChTY9UCQ6viOOn1i/7xOomKXPpvvl?=
 =?us-ascii?Q?NV4DkjIo+Lp4QNnxDLO3DgeSQtqNL+VU2ubu9hiO87ZgJkUeCe54IVIDghlR?=
 =?us-ascii?Q?fW0JsrOiCxN8/6Q4hNakO5ijwhvaMqQN4v+dRh5k29P1XnaJmW8QEScqFpo+?=
 =?us-ascii?Q?wJ9sO6pOyaqUPthSkG0/k3iM2HifRL/LSVOZd4B9itWWTXxfIGxK+5+jfJd2?=
 =?us-ascii?Q?tPRPIon/1FqzqUWHBBxO8tVr6RHFsaTpUrovp4KWKA+9FPPNJmhlilFHVoTI?=
 =?us-ascii?Q?8y+6Al7ZJe7kPkyUKIJfD9zPEeoOrlJfgPbiSg2aCoGbyTxy4YFnQ6aNHG0p?=
 =?us-ascii?Q?u93QRm8wRs6drh8aDufOcveODWpAzJm1vy1jGbiYJv80GnKQWkuz2v1LM8FV?=
 =?us-ascii?Q?PeREsOV31oB/ICS3vKlKV3ZQI9YbGorks9sUk5SwaiF5ALE6fSrT2nXDySHN?=
 =?us-ascii?Q?W0KJyluoVilPUTkC3nYaFmY+H6DYL0MpwujzRNSiboWLpSdGSN4OoIT8ORob?=
 =?us-ascii?Q?AiEemzrk60zQLu9H/WcZpZ8dmYM6amXioC640x22Rk/2p8zQU7E/+ochHaIJ?=
 =?us-ascii?Q?2Xb3koFggcZKTcuAjXD5/ciwo8pH/niX8hjbxUKkxO1RSsm0D7rMoDQGkSlL?=
 =?us-ascii?Q?d9s9TehX6Tqq3kyiGyKBN94bfEyLDgZsnmiyG/GmdbVjjkYilAoBVcHFcnB6?=
 =?us-ascii?Q?PG7FGeSh/iKgqY63Tpkwm0UggH9e7U+KIkbNOk2s9o0rjFGC5Nu8hmdzA17+?=
 =?us-ascii?Q?Z2J5pRN6S79/xsSvWp8PNfvcJNV75+NXCraIO1DGPKPcTOVYMiOGfD+6YqbF?=
 =?us-ascii?Q?pNAiKsmp+J9Kb77x3q+aju/p/xJYCZcFe8B1V6XjL0Fy3T2YpIcUKNSAXa/j?=
 =?us-ascii?Q?x+Vstsj7OaE1kkn3Aw87Ei85jLOiIvPeYF4XOUcp/gTyoZLmgSWvUxNk7hf2?=
 =?us-ascii?Q?jGSnXgCDTh3g23BcAHnS8257xUSYU36lyqewU9KFJDaQMKqol5hblvITVfhv?=
 =?us-ascii?Q?Lu1Vl97GLORX326XVZyZ/07ale0AGhVItEa712txfwYnnwF0DneFY83JqUxy?=
 =?us-ascii?Q?CD7QcCLCaU1w0pP35PY5oqAO4NbaKRawxlwCKPzCSxzHodnaeA3UIdEMh6RE?=
 =?us-ascii?Q?+Z5kIZ/Ffv2HLwOs7FnL0pqYr5FMtA7kaSInHVA5C407B9i/v+nOpW6xhpZa?=
 =?us-ascii?Q?GyL4JnZtGXhIfc7MB2OBqDyEbZlFjAHXu4azkphIVKN3wjKZMMFfwjtGI5Cx?=
 =?us-ascii?Q?ta6+AKAAAxs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mvey9DpBWKxE3DHGutghsxJDKKSpCae4vyywQtvZL4ea0JXrT3HUU3cdP7V2?=
 =?us-ascii?Q?cmOwh5CvIaWItdKKLq1grnVgQi1qGSL5Qei5N71Bnbx9bKJCYCu7ip6eRrmG?=
 =?us-ascii?Q?oWWUxMycI/jXhDux2rlvikkLykUp0wd72k3qNsL0ESD3IN6v2EytZ6094NC5?=
 =?us-ascii?Q?02hKCoo6p0QbLaKbkVg5slCTC/Gi+Lhr4UVywEPh585BXBphSsimT2A+S2jT?=
 =?us-ascii?Q?reJdvIp02BSKnNTaVEwnbHWAy1y9rYjWxIVqc8q2RPSTflfELQmoGvruFqij?=
 =?us-ascii?Q?+in6KaSXrqYhlcQ37dCcMPYmqf75Eok5h0MotOUeLJDCPSHLY0Q5FdG7KQhA?=
 =?us-ascii?Q?EGFpmrLkVrPNO2kbEbePR1F1ONq+VdU5BSf9hc3k2rEcTiyoSgnxE5s7UjJ6?=
 =?us-ascii?Q?9s44wHI3QWTg77y95OwnKKLi747LT0nKD5TLY3eWSsDowWI2OJXBf6EUuDhy?=
 =?us-ascii?Q?7PMrXhykDWMRfiTVHtlYaTQoUt5Lm2yvUpWh+N2XB1I3Sv770vWjYGrJairu?=
 =?us-ascii?Q?tbpGi1mZtbaDXAiSzuj049lQLE/2tqDxGJdEQ9eTm83sI4eInWj3EU7aldUu?=
 =?us-ascii?Q?5WQSOLJzCNFNUKoDkBmdNHubRjPg9f/v+3E+OcDgQ3J1Jx9oWEuzoV4c1LUN?=
 =?us-ascii?Q?ZO4eaWG4+imZFJtRDdX0RMli51YtRpX9oIcxZO/cL/Nlhw05T3DDCco51htG?=
 =?us-ascii?Q?ReFOwffrGtgJLRuJke+YeO7j5kaLkLKpyCMMpmAHlcsShjYAOs6IDcmUOqIK?=
 =?us-ascii?Q?GnAm9gCYW2g+sTVxdijpW+b/QIAMxgUXdUUBFu4duzxfWPe8uZMgaKGHF8Z9?=
 =?us-ascii?Q?t1iUbgrvbEn4poEHj9weLgmRjsx9+M0nNRewYFIcb1JUmcz8XyWKFdmHgUo1?=
 =?us-ascii?Q?UD7ovKxhztrG1fWh8sPWJ7dQ+SeVO5tPhMPCIbIhObuxyk7+9xUaIb7qJsRP?=
 =?us-ascii?Q?mQLDv8URDtuRLPeJp22NSVGwxVEpioxJtTfSQLbufYNCAPPAN/M+KOPFbamZ?=
 =?us-ascii?Q?qwaKD4ci6iUyUx1jI0fedeJHH3do1R6cxeyfoYioh7nT+1grVBty1tnGioxp?=
 =?us-ascii?Q?cKmqznSQvjz0lSH/rnzZMKRPGKZ3Litb2Esr6fEG1bkXMN0B3whY/kN4l7k6?=
 =?us-ascii?Q?ztLzt2nwnkTsJaXDMkf+uQ+jmoL3cYLaduk3CUT4PqkiGpLzUfYNOMP+Qrzv?=
 =?us-ascii?Q?oFT6H4IDsytyHqpFP0TI3geHTkJDt5LABoLQCDsHoNpM9Ql9iHb8BqowagNj?=
 =?us-ascii?Q?DZWchxdrSVIcl3I/4SmdLlwqrDOnd0OoFuGaHsXZUciujaFwH37xW0znJNLC?=
 =?us-ascii?Q?AZk0iDmtpv5YlbLMHPy7+oMHmnH7cruS30OAKaKx6sS91IF0wyF7l9Jhwpje?=
 =?us-ascii?Q?zRJU7Z5Qxezxd7y/j/kvtJalIXaPqYBfrzaDiLwEMvHUJ6ba9vP9Pz+kG1+t?=
 =?us-ascii?Q?IABaqD49nTNrvi+aLukWH6aM1a+iteng15WONfuX3qxUWCOEbDuH9+soyn3j?=
 =?us-ascii?Q?05XeD0zm2O3fuRJg5cYVFuqCX7eD70pjmothweVh9Pg2nVP9h9yu1W2Xdwyn?=
 =?us-ascii?Q?zHleW4Dl3570/Rt9mnzSUSbgMoS+9/elz/qOeNyW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcaae62f-3834-4914-0498-08ddfa33b794
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 23:57:00.3218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QXB3sV9yh/jB/fUOavYAYWMKv9YpZR0Sk6Gk4Nk1lEgrHodP9/ZesH5C2ooqHTeE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9656

On Mon, Sep 22, 2025 at 04:20:43PM -0500, Andrew Jones wrote:
> On Mon, Sep 22, 2025 at 03:43:36PM -0300, Jason Gunthorpe wrote:
> > On Sat, Sep 20, 2025 at 03:38:58PM -0500, Andrew Jones wrote:
> > > When setting irq affinity extract the IMSIC address the device
> > > needs to access and add it to the MSI table. If the device no
> > > longer needs access to an IMSIC then remove it from the table
> > > to prohibit access. This allows isolating device MSIs to a set
> > > of harts so we can now add the IRQ_DOMAIN_FLAG_ISOLATED_MSI IRQ
> > > domain flag.
> > 
> > IRQ_DOMAIN_FLAG_ISOLATED_MSI has nothing to do with HARTs.
> > 
> >  * Isolated MSI means that HW modeled by an irq_domain on the path from the
> >  * initiating device to the CPU will validate that the MSI message specifies an
> >  * interrupt number that the device is authorized to trigger. This must block
> >  * devices from triggering interrupts they are not authorized to trigger.
> >  * Currently authorization means the MSI vector is one assigned to the device.
> 
> Unfortunately the RISC-V IOMMU doesn't have support for this. I've raised
> the lack of MSI data validation to the spec writers and I'll try to raise
> it again, but I was hoping we could still get IRQ_DOMAIN_FLAG_ISOLATED_MSI
> by simply ensuring the MSI addresses only include the affined harts (and
> also with the NOTE comment I've put in this patch to point out the
> deficiency).

Nope, sorry, it has to validate the incoming target Linux interrupt
vector in some way - that is the whole point and the required
security.

We cannot allow devices assigned to a VFIO to trigger vectors that
belong to devices outside that VFIO. HARTS should have nothing to do
with that security statement.

> > It has to do with each PCI BDF having a unique set of
> > validation/mapping tables for MSIs that are granular to the interrupt
> > number.
> 
> Interrupt numbers (MSI data) aren't used by the RISC-V IOMMU in any way.

Interrupt number is a Linux concept, HW decodes the addr/data pair and
delivers it to some Linux interrupt. Linux doesn't care how the HW
treats the addr/data pair, it can ignore data if it wants.

> 1. stage1 not BARE
> ------------------
> 
>       stage1     MSI table
>  IOVA ------> A  ---------> host-MSI-address

If you run the driver like this then it should use IOMMU_RESV_SW_MSI
to make an aperture. Follow how ARM GIC works for this. The Linux
architecture is that the iommu_domain owner is responsible to provide
a range for SW_MSI and connect it to the interrupt driver.

> 2. stage1 is BARE, for example if only stage2 is in use
> -------------------------------------------------------
> 
>            MSI table
>  IOVA == A ---------> host-MSI-address

And here you'd use HW_MSI to set a fixed aperture that matches
DC.msi_addr_* (?)

> I don't think we can apply a lot of AMD's and Intel's model to RISC-V.

AMD and Intel have the interrupt translation as part of the "DC". That
corresponds to the DC.msiptp related stuff.

ARM has a SW_MSI that applies the S1/S2 translation first and then
puts the interrupt translation in the GIC IP block. That corresponds
to what you just explained above.

Somehow RISCV have the most challenging properties of both
architectures, and mis-understood what security Linux expects out of
interrupt remapping :|

Use SW_MSI to open the aperture like ARM, use techniques like
AMD/Intel to manage the translation table in the shared DC

Don't touch the iommu_domain from the interrupt driver, it simply
cannot work.
 
> > It looks like there is something in here to support HW that doesn't
> > have msiptp? That's different, and also looks very confused.
> 
> The only support is to ensure all the host IMSICs are mapped, otherwise
> we can't turn on IOMMU_DMA since all MSI writes will cause faults. We
> don't set IRQ_DOMAIN_FLAG_ISOLATED_MSI in this case, though, since we
> don't bother unmapping MSI addresses of harts that IRQs have be un-
> affined from.

OK, that seems like a good first series. Implement just the SW_MSI to
expose all the IMSIC's.

> > Instead it probably has to use the SW_MSI mechanism to request mapping
> > the interrupt controller aperture. You don't get
> > IRQ_DOMAIN_FLAG_ISOLATED_MSI with something like this though. Look at
> > how ARM GIC works for this mechanism.
> 
> I'm not seeing how SW_MSI will help here, but so far I've just done some
> quick grepping and code skimming.

SW_MSI is intended to deal with exactly what you are describing - the
IOMMU translates the MSI aperture.

1) The driver declares a IOMMU_RESV_SW_MSI in it's reserved_regions
2) When a subsystem wishes to use an iommu_domain it must detect the
   SW_MSI and setup some IOVA for it to use
   a) dma-iommu.c allocates IOVA dynamically per-page via
      iommu_dma_get_msi_page()
   b) Classic VFIO uses iommu_get_msi_cookie() with the SW_MSI range.
   c) iommufd has its own logic in and around iommufd_sw_msi()
3) When the IRQ driver wants to establish a MSI it computes the
   untranslated address it wants and then calls iommu_dma_prepare_msi()

   iommu_dma_prepare_msi() will return the a msi_desc with the address
   adjusted

   For instance dma-iommu.c has iommu_dma_prepare_msi() call into
   iommu_dma_get_msi_page() which will establish any required mapping
   for phys at some IOVA it picks.

The riscv mess has the additional obnoxious complexity that the S1/S2
are inconsisent.

Right now the only way to deal with this would be to only use one of
the S1 or S2 and make that decision when the iommu driver starts. You
can return the right SW_MSI/HW_MSI based on which PAGING domain style
the driver is going to use.

I recommend if the S2 is available you make the driver always use the
S2 for everything and ignore the S1 except for explicit two stage
translation setup by a hypervisor. Thus always return HW_MSI.

If the iommu does not support S2 then always use S1 and always return
SW_MSI.

Disallow SW from creating a PAGING domain that mismatches the expected
interrupt setup.

There is still quite some mess to enhance the iommu_dma_prepare_msi()
path to support all the modes, that will need new code as ARM doesn't
have the difference between S1/S2 (sigh)

But broadly this is the sketch for where the touchpoints should be to
setup a MSI aperture that has to go through the page table.

> The first five patches plus the "enable IOMMU_DMA" will allow paging
> domains to be used by default, while paving the way for patches 6-8 to
> allow host IRQs to be isolated to the best of our ability (only able to
> access IMSICs to which they are affined). So we could have
> 
> series1: irqdomain + map all imsics + enable IOMMU_DMA

Yes, please lets try to get through this first..

> series2: actually apply irqdomain in order to implement map/unmap of MSI
>          ptes based on IRQ affinity - set IRQ_DOMAIN_FLAG_ISOLATED_MSI,
>          because that's the best we've got...

Make sense, but as above, need to do something to make it actually
implement IRQ_DOMAIN_FLAG_ISOLATED_MSI. Limited to HARTS is not the
same thing.

This also needs some kind of new iommufd support, and I don't know how
it will work, but setting the DC.msi_addr* should come from userspace
and create a new reserved region.. Maybe we need to create per-domain
reserved regions..

> series3: the rest of the patches of this series which introduce irqbypass
>          support for the virt use case

Yes

> Would that be better? Or do you see some need for some patch splits as
> well?

I did not try to look at the patches for this, but I think your three
themes makes alot of sense.

Please include in the cover letter some of the explanations from these
two RFC postings about how the HW works.

Jason


Return-Path: <kvm+bounces-25530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B97CB9663EB
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 16:14:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CAC02853AA
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 14:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B45F1B2538;
	Fri, 30 Aug 2024 14:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Eb+cetkh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B441B252A;
	Fri, 30 Aug 2024 14:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725027206; cv=fail; b=UI8fBlfS/sNCE+eRZkAKumzRzwCq7aV6ZcFSNgSJ1LneijBRt1TRzAXB6zwTVTH0X/Pm0kvfSgLJHV+zGYhJtxhmfEFXtRqnmWe9GEDjJ3CYWznWHTNGpp5oe9FkDHexUnaXe2IhWXBRek2LXzf2kBu0yICFNOVgCh2A8AoEWHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725027206; c=relaxed/simple;
	bh=WeWSyFaD14M8XwVZbZ1FgDi2z7n83pIci5UBnrJLpg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lQZGryz96CWEL3aEKGwaW1FWTZdKk8KjSk8chuoz6HqkYvBu8uGGR/2Ogz8khLH2k4tbSfPvybTUJuwKYYEN23DAXYaWg9xYxmYxEH7G/3nNuwZRREAvTnRmQOxnQVwNXZmJODGx7GY05jX1ITCrzorhD15ihgWv7/nZHLER0VI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Eb+cetkh; arc=fail smtp.client-ip=40.107.94.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CK0IaZ0GEnalmkeOVgT4TpobhxmxCUcHdk7gxf+tr5p6EbmdX35oYZ+vk1LRp2ptZ3rbEsL4Pipj4JqaFt2IS/zPFhV+vT0QBMf1z41NRWFERcX9nY4ITcfu5Qku3ul1Jy0Nf5JJ1xN20jODlePJCKAUJ40fWWFynYInagirsU1Lq4VpCg5VYJUYfFKbY5iIM+eLDhHltNJ8PCjUiVFKkvC33jXTrAY7HxuCcVMjdyG8D5gdprh5dKIeanqC73a0tB4PfjSZAq3pCvIIxj9yiqirHYdpucGmcdpo1QQGhuNYKs5MBMJwPYDHZEVlFLfHzWPE1eyIs9gQkDqfIsGK1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77ANguECJF/sCSrpf0f6d02Xl9jZ+7KASqwDIx6o9oo=;
 b=SluEF2SsA1fWb1LMxDnexhkW9ZlodbSe+ez02tSOJQgw0HPCCqYb/4gmz7nZfEQqYjh5s6ulVbjuTS+Eqg8XSCdsosQY+1TxMSDYS3A4Q1wbvDbChlPphzpDqll89M7RFcdmR5KUmvia74GhoyXhVkbkHxfmwGEo7kNtxHt/U9T6g/+uC+brFeTrwHg++PGIZP9SoaB5n62NclUKr2AgQXhKvgA0YbeSmDlhbM40lCmW8vhbgW7flcz57Es92m5CIXoy2LyFM7FHd+t5wBminrHDt1yUliMasERXvDuANdOhtZeCdi4fqUnS6m5GNbB0VaBGsuqUasUW7J1KO3WaKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77ANguECJF/sCSrpf0f6d02Xl9jZ+7KASqwDIx6o9oo=;
 b=Eb+cetkhjfNclbaEtmaRSMfAvCJzp7fHaYc4+oLuRHY0I88mNe0OpkUQZqoZxy++GN29f0itq7FQQGee/ExK/34eIqFvFPScfuvwS0q+3NlQIF1YP5Z4qRkgcRfjjzJW8UwmFLaGYITLGVvJ5varxXiVPUcPowd+zSyBnhom8wiuFjaR1oDKOsUtEC/cchcD0FZHW0vJXW6jJpQoTw3W5ferjljeiKeSjbhAmt9obeYPeJ3EZ7trJ+JEvrcrXz1Trxyb3kgih4nKBQ8F/Gb3Sb5VUPptB9zkkZmJXFLVHsH/NmDFPEgj0baiDErREDpro3HEUGrbYzfjgsbhkmeEXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CY5PR12MB6369.namprd12.prod.outlook.com (2603:10b6:930:21::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 14:13:20 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 14:13:20 +0000
Date: Fri, 30 Aug 2024 11:13:19 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>,
	Hanjun Guo <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"Moore, Robert" <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <20240830141319.GR3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <BN9PR11MB5276AD532C8F43608A8D30048C972@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276AD532C8F43608A8D30048C972@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0069.namprd03.prod.outlook.com
 (2603:10b6:208:329::14) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CY5PR12MB6369:EE_
X-MS-Office365-Filtering-Correlation-Id: a40e648d-7d15-4164-99d4-08dcc8fde6ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+hrg65cqIZLf/jqfDIdLXfP4E8ODMsz7Hhmk4SIWeBohGD9X7HzDACjr5ai8?=
 =?us-ascii?Q?6ERGDOAhVZPgE5Rut/rkx80kY4mFt/SVI9okfuhX6ebyvCa7LMl5yf6JKeLK?=
 =?us-ascii?Q?IQ6LmkeeDkmqetWG2qz87FBnXrEy3cWxb1Bpqzp945THM+YlquMT5wWCujN2?=
 =?us-ascii?Q?JGOoxNiq/FPnyPEF/CEigQKTT2oZPAvKJijBtRNwo8te88DSbXPuRwnwuZeE?=
 =?us-ascii?Q?r/pZ5ZxZwCghFtWuSZV7mplQqh0YCMW74NVBuKpHDfdnUcc7HZpElJUg6Rul?=
 =?us-ascii?Q?DKidFqgOyKOvyxHSyWVasvl/IAa5Dw27YtaHuPbItE6o6rSrFAaTZ3ZGgsMB?=
 =?us-ascii?Q?H7yaQSc4w5GjA6TYXwUej88PttpTByTfxAQScURckQDP2G3JhuCdQSFfOHia?=
 =?us-ascii?Q?ozXnD9R6pKqfHoFJ3yssa9w7QP6kg9uDRoq2pAaVsAJNLqdUjDzxCI8UQUAa?=
 =?us-ascii?Q?N5+RMLTBMS2VvFFVwSZPKGfcauFfo0MWhZjE0IPtiwf2oTGrnO9ikEWYa60w?=
 =?us-ascii?Q?KmDw+RJ/rNZihS6ISy1IYkTfCeJ4o+y9oNmdNLXyIvvOYh3YNuZ28ATYLvH7?=
 =?us-ascii?Q?EJiL7/AsdCg+8XrxV2/okbD/WjFFW8vv/r1GKtHK/BNCmeMuPKF8O3LFNLuE?=
 =?us-ascii?Q?o0D3x0/TK/t95AzfOsywvUjcCAQp+n9MGKZT3erCa2AGe6eahdca+p6tq3VL?=
 =?us-ascii?Q?sIGmWULBDM/c/ngQ4lS/i1gOZ2U1Fg3NYn13Sl3xrLsJGPIyqUmKMWiVqkb3?=
 =?us-ascii?Q?43X4GTj1u5vns1qFblAjKmKDy+1Bu6URI+SOhAcngzwJy2gI1cW85/TVm0c6?=
 =?us-ascii?Q?7Rum8HogLeupk5xkRzawFCvicsLrJC8ol6/uaC7McTaRlBHzUBDsjPYBiKow?=
 =?us-ascii?Q?BiySoUPHlTOsxwjsScGJoOHgc9BQl8dLur7zZGmkiI7XlHxitkiw/n4WLEun?=
 =?us-ascii?Q?jPKOjURGBaBpH6Kg9pJOrHnsScGGsMkH5n55KXXQxHpyHxAHsfPM9JANMPye?=
 =?us-ascii?Q?4TpP1AJXEPymQ+dq/S102l79YUZ0QMsk+PJKovRrH7OsW3rwCkrXiILLmKjs?=
 =?us-ascii?Q?UJrpgTEDEBBcw9WwxnlTDYlwM43v0MiQcKg6KaopSZIj/Tk+3Qxho4cLwcU7?=
 =?us-ascii?Q?/y5WXMhpXxy54XusFTJ2cmjzd7s4zbrBpu7dMfsCODVzrZHe99TGrKI+1FaU?=
 =?us-ascii?Q?cqcyLQycclpluSFra+keoyONZR2OFIDfWaR9WrSSTcAzRxGj6QPFvfriH/J3?=
 =?us-ascii?Q?cl/z8o+UF6V7nzggh4mdTYeK+ov5j/eKGeb+CChe7jXD0iWDLwMpgzVHnLR4?=
 =?us-ascii?Q?gqc/MmhqKB+EFOZ7wsNQc7+8Oo3FQtB2smN9rePy4TjpsA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ClT094G9jdTM4Q1a+SsJa67rtCoZMysq6EKhKfq/02/RmM8a4CA6Kw4iZqgd?=
 =?us-ascii?Q?Flt96QTklFcdQkqyu2uVqJdG03X2ygHixnQnMfGzNeReG5lQ3fSgRsI0c4Eo?=
 =?us-ascii?Q?pfLWayZJuVwSJugaGoY7kUHCPBTcBkvt5KujpWgK3HoIheyL/0yBgxvdlMOw?=
 =?us-ascii?Q?mHgu2tBP1/oAJCggHzgog8QpRw/Lvdco358r+hiqLDE2CdQQltuU4Z6zaYml?=
 =?us-ascii?Q?4WFDrW20byICXFitE/qMFMnHt45EjuCKod/xHubbvAj1FWA9Sk4MgYNIUEq1?=
 =?us-ascii?Q?MVt6iPyiDWFPn3CbqqlDyyHFT0uIxMUgjflNWYHK+s5Pc1A5gpK6D9Efb+lA?=
 =?us-ascii?Q?JAjQNnFIa9AjqR6x2p4HX7ObtJbt396bLHSxn2K6l14eFFP6cN/VxMlaSHzr?=
 =?us-ascii?Q?Yx2SYKoywtqM+qwTlee/BP4TZS8pxJkFecBZBH2dTVuo5WTxNXQci8ngEj3L?=
 =?us-ascii?Q?yZ/ncAmje0ppNoH/nB0rbsnlVAAHVhdivu13ObSvym88d6Kn/1zkth4GpIaA?=
 =?us-ascii?Q?11tuHHJNO7ZIDi0aamktR2iddFou7sGeIALdfb2A3kTV5vSq2YYPV1216j8i?=
 =?us-ascii?Q?ebKAxRCoHsJtSUk0Q5F92oVDut9GMPbJbVd3ZyS5OryWqe1ORuGT9Rf3mJsV?=
 =?us-ascii?Q?/30uUtWQEmz2RkSrrMkprgWrTOjJIDh0qeOW1ClTsXqoUwAXwxF+ohhGUHkT?=
 =?us-ascii?Q?g7CruCA1iuhHGU0mAcRmv0U7hLRf4tP4d3wlRFcEvJ85t825zbHAY+H3Cadk?=
 =?us-ascii?Q?IYrxHhLuHjIdmijZRkRXP72BGWjhRr2gTPSJ4ZisBjhEwTEH4yZcVloqyYJO?=
 =?us-ascii?Q?8EXg4lDrr13WO+gFS3VrBm+TcPjFPBJnlXiy8QPmHRnnhejQ7sjfpJyoJ0aH?=
 =?us-ascii?Q?z38QAFV84ugBPNv9jKb48BNH54e9ypTuLUhQIXjuVOfvNN8MObu+xetmsL5u?=
 =?us-ascii?Q?ZGvxq0kLWwsdUa1R1rtTuOAwe8HV2X+ZV5RnaJ2PO8v3JmiV9Kob3ObYjTyC?=
 =?us-ascii?Q?eu2fx+LATOhVfov81VAWo/o2KfF2IRAWIx/dyJrH2bukaLHJIYiddYLdJ9A1?=
 =?us-ascii?Q?9W6Pqfo/PhKg1QHewoJImcA4gH/CPdpgwuXhSXO6v+nrCI3WL0g9l/Lwpefd?=
 =?us-ascii?Q?e9mNRkqNyQRIE1lhzdwC/Fa5AuTl8O6D9NceAMhqKAxKYjXBlhARqfOTW6iu?=
 =?us-ascii?Q?0jTKeQra1m5nfIMIw4jKk4r/wjmKc1x2ssnYjJEfVW0h3j/MrQSiqV+1Jhlj?=
 =?us-ascii?Q?N6ue31Qcyn365GblKrqkLM8QI95Uynkz3RYOty/BLd6p1/0H4O4U9wgs6KO9?=
 =?us-ascii?Q?hec6+O6BZejV887SiPinY7BykIfpan1BUNjf9y2uR44Pl0I3MwFyZ3z5iLG5?=
 =?us-ascii?Q?8Wgn5CEPA5OFmPRIcPFEEEm/KuTlX1YjLCnnSgtMTuV+2oS4lAAgYCrec9o7?=
 =?us-ascii?Q?nHcvnuQ7+77fNENRYsTQUnPu+0U20jW6HrGzsj0y1YbGXoqP6A8MToaMb5LY?=
 =?us-ascii?Q?1lo6dIUQAHIRCsZceCm3Vq6XOS3fgUIQqt4dqXLp9LrxYnkdcP2r9RH57Ry0?=
 =?us-ascii?Q?6chUjCQ1/rYlkxhgpcrSDa4sjaRYXYCss+V8OlQD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a40e648d-7d15-4164-99d4-08dcc8fde6ba
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 14:13:20.5810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bc8EjilUW+9ln7NrFZTfcoP/cL2189Fz0mwGdhmj2bVORbQ/j/kTMMJa7sjN2kxy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6369

On Fri, Aug 30, 2024 at 08:16:27AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, August 27, 2024 11:52 PM
> > 
> > For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2
> > iommu_domain acting
> > as the parent and a user provided STE fragment that defines the CD table
> > and related data with addresses translated by the S2 iommu_domain.
> > 
> > The kernel only permits userspace to control certain allowed bits of the
> > STE that are safe for user/guest control.
> > 
> > IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
> > translation, but there is no way of knowing which S1 entries refer to a
> > range of S2.
> > 
> > For the IOTLB we follow ARM's guidance and issue a
> > CMDQ_OP_TLBI_NH_ALL to
> > flush all ASIDs from the VMID after flushing the S2 on any change to the
> > S2.
> > 
> > Similarly we have to flush the entire ATC if the S2 is changed.
> 
> it's clearer to mention that ATS is not supported at this point. 

As things have ended up we need the viommu series to come along with
this to enable the full feature, and viommu supports ATS invalidation.

Ideally I'd like to merge them both together.

> > @@ -2614,7 +2687,8 @@ arm_smmu_find_master_domain(struct
> > arm_smmu_domain *smmu_domain,
> >  	list_for_each_entry(master_domain, &smmu_domain->devices,
> >  			    devices_elm) {
> >  		if (master_domain->master == master &&
> > -		    master_domain->ssid == ssid)
> > +		    master_domain->ssid == ssid &&
> > +		    master_domain->nest_parent == nest_parent)
> >  			return master_domain;
> >  	}
> 
> there are two nest_parent flags in master_domain and smmu_domain.
> Probably duplicating?

Sort of, sort of not..

This is a bit awkward right now because the arm_smmu_domain is still
per-instance, so the domain->nest_parent exists to control flushing of
the VMID

But we also have the per-attachment 'master_domain' struct, and there
the nest_parent controls flushing of the ATC.

In the end arm_smmu_domain will stop being per-instance and per-attach
'master_domain' would have the vmid and the nest_parent only. I'm
aiming for something like how VTD and RISCV are doing their flushing,
with a list of flush instructions attached to the domain.

So for now we have the in-between state where a S2 marked as parent
will avoid the ATC flush when directly attached to a RID but not the
ASID flush. Eventually we will be able to avoid both.

> > +static struct iommu_domain *
> > +arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
> > +			      struct iommu_domain *parent,
> > +			      const struct iommu_user_data *user_data)
> > +{
> > +	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> > +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
> > +	struct arm_smmu_nested_domain *nested_domain;
> > +	struct arm_smmu_domain *smmu_parent;
> > +	struct iommu_hwpt_arm_smmuv3 arg;
> > +	unsigned int eats;
> > +	unsigned int cfg;
> > +	int ret;
> > +
> > +	if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING))
> > +		return ERR_PTR(-EOPNOTSUPP);
> > +
> > +	/*
> > +	 * Must support some way to prevent the VM from bypassing the
> > cache
> > +	 * because VFIO currently does not do any cache maintenance.
> > +	 */
> > +	if (!(fwspec->flags & IOMMU_FWSPEC_PCI_RC_CANWBS) &&
> > +	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
> > +		return ERR_PTR(-EOPNOTSUPP);
> 
> this can be saved if we guard the setting of NESTING upon them.

IOMMU_FWSPEC_PCI_RC_CANWBS is per-device, FEAT_NESTING is SMMU global,
they can't really be combined.

> > +
> > +	ret = iommu_copy_struct_from_user(&arg, user_data,
> > +
> > IOMMU_HWPT_DATA_ARM_SMMUV3, ste);
> > +	if (ret)
> > +		return ERR_PTR(ret);
> 
> prefer to allocating resource after static condition checks below.
> 
> > +
> > +	if (flags || !(master->smmu->features &
> > ARM_SMMU_FEAT_TRANS_S1))
> > +		return ERR_PTR(-EOPNOTSUPP);
> 
> Is it possible when NESTING is supported?
> 
> > +
> > +	if (!(parent->type & __IOMMU_DOMAIN_PAGING))
> > +		return ERR_PTR(-EINVAL);
> 
> Just check parent->nest_parent
> 
> > +
> > +	smmu_parent = to_smmu_domain(parent);
> > +	if (smmu_parent->stage != ARM_SMMU_DOMAIN_S2 ||
> > +	    smmu_parent->smmu != master->smmu)
> > +		return ERR_PTR(-EINVAL);
> 
> again S2 should be implied when parent->nest_parent is true.

I think I did all of these for Nicolin

> > +
> > +	/* EIO is reserved for invalid STE data. */
> > +	if ((arg.ste[0] & ~STRTAB_STE_0_NESTING_ALLOWED) ||
> > +	    (arg.ste[1] & ~STRTAB_STE_1_NESTING_ALLOWED))
> > +		return ERR_PTR(-EIO);
> > +
> > +	cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(arg.ste[0]));
> > +	if (cfg != STRTAB_STE_0_CFG_ABORT && cfg !=
> > STRTAB_STE_0_CFG_BYPASS &&
> > +	    cfg != STRTAB_STE_0_CFG_S1_TRANS)
> > +		return ERR_PTR(-EIO);
> 
> If vSTE is invalid those bits can be ignored?

Yes, but also I was expecting the VMM to sanitize that.. Let's have
the kernel do it. Move the validation to a function and then:

static int arm_smmu_validate_vste(struct iommu_hwpt_arm_smmuv3 *arg,
				  unsigned int *eats)
{
	unsigned int cfg;

	if (!(arg->ste[0] & STRTAB_STE_0_V)) {
		memset(arg->ste, 0, sizeof(arg->ste));
		return 0;
	}


> > +
> > +	eats = FIELD_GET(STRTAB_STE_1_EATS, le64_to_cpu(arg.ste[1]));
> > +	if (eats != STRTAB_STE_1_EATS_ABT)
> > +		return ERR_PTR(-EIO);
> > +
> > +	if (cfg != STRTAB_STE_0_CFG_S1_TRANS)
> > +		eats = STRTAB_STE_1_EATS_ABT;
> 
> this check sounds redundant. If the last check passes then eats is
> already set to _ABT. 

Yes.. This hunk needs to go into this patch:

https://lore.kernel.org/linux-iommu/3962bef2ca6ab9bd06a52910f114345ecfe48ba6.1724776335.git.nicolinc@nvidia.com/T/#u

> > +/**
> > + * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 Context Descriptor
> > Table info
> > + *                                (IOMMU_HWPT_DATA_ARM_SMMUV3)
> > + *
> > + * @ste: The first two double words of the user space Stream Table Entry
> > for
> > + *       a user stage-1 Context Descriptor Table. Must be little-endian.
> > + *       Allowed fields: (Refer to "5.2 Stream Table Entry" in SMMUv3 HW
> > Spec)
> > + *       - word-0: V, Cfg, S1Fmt, S1ContextPtr, S1CDMax
> > + *       - word-1: S1DSS, S1CIR, S1COR, S1CSH, S1STALLD
> 
> Not sure whether EATS should be documented here or not. It's handled 
> but must be ZERO at this point.

Let's put it in the above patch

Thanks,
Jason


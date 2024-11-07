Return-Path: <kvm+bounces-31137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FE159C0A6D
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 16:52:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ACFA2B2243C
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 15:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C57D21502B;
	Thu,  7 Nov 2024 15:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CsuNDBpA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEE92144A5;
	Thu,  7 Nov 2024 15:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730994716; cv=fail; b=qc5MU+wM3LliDkJUf/5rVvhAPiIf4jl3iqgSXBz8PtwhqOhdqTd2rOSiKRtQtHpwn9mZgCAg2/KHEuW2rPNwt56AYfQhYqC6tdOaTGk8DS0kKEeod+bIugE47lSRht9DWyF9tkjY/WbOKkv5xpY3/RxXtw4YM9h1pTSEhMolupc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730994716; c=relaxed/simple;
	bh=DNfmREALQIdyYyW6Q0QZ9I7h0QFXduZqRg97GNwjtZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mxQX+MqVcWMrUs+l8e+qOO/wxWsYKvKosM93WnTkD3AKVoq78IumvckyVN048edYAbh8q8GnfMfMsVr/pzmEyrJ3xTkXa3Q7jJjZ3N0gjOeFCyZRjbqZS51oDBxN+R4tTp1GvAMCQA3pHS6RC7/zft35q9eBE2lmYKLaNq8hlQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CsuNDBpA; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CEzQ5CktD9I2M1MsVoxJjz5MRtNJ8vFvdo98TYG2vPLf2kC0sTAgZ4+4plKdcuW2n9SQfNsNi8OGduEAB6/e2c7k1hEq69hYKJdDjUbJWwwkM/vkn7Tw+YugJaqZRoEyx00z2lYYiCtO/z6EiZNVQMybT5dBPjYnUMyAJUEkE416Lx3k9oCIXtPS/NyGpuEccmM5O76ro1vjPVxlXl7QsOodcdhglnBoeFLaljRj3zh0dzJJIdi4drGmXNeaqJMZQZ/m01vUsIa+DeKS5qARqdzskVQPZCpbJ4nitrOMLPGD2tgDfzVrhGyo3epRE+cq0lcMHluydqeroIMC/GwQJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jg6Ck2TA/9JqrHRFolKiu/83sEVbl4LjdEAd+5wJJ2w=;
 b=G90OU/HoJyVqJc592cFAF/3O86hggLuVyiIwBLg6UCUvwYJjgN3CBf5DbRagmfhlkO5/R8RiDvC1JcEkE+cEmPjtmkICbTkFko9jpf6LHVALbM/WbvUTa2Pt+5Tl4QrdeN552s/lblSs41cTII6i36R3DPSNs+3/C1ioZyjk855Z42wSzgFvcLKAYqWHtqpxd9KS6oXPXlXti4wEztdzRWjaPIE37qSMVA1BwVcz0ycrMJ2EoA+DqzJmBAwVBEv1/HBPbpxC1lQYF5GEI7ytKNbIMWGeWrID1ESYyaUZiK9N9elIiqCo6pgUMAUeNsyFV/XkHokvysnWDVBFqH48LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jg6Ck2TA/9JqrHRFolKiu/83sEVbl4LjdEAd+5wJJ2w=;
 b=CsuNDBpARmua9P7YJF7fCPE2KnAsL3vKW/3xFh6ZpWFN8A7Ep2/i0Nqrl9x+2SPJ5uUvyho1GeBta9Ot3sZJ7NTHOz+kHJWXxdtYLb0ZqLsWc1f7KWWka7qMjYegT2LUpYaVG4wO1zG3GY1WLPvWIigdeZUCDJeieB0UcKMwr1LApJuI0tIK2+p2Oj2yIcx/20zFrlGdUQvia866ErOGLSyrxTm/YvsQ3TwTcZZ1pBuRRXpMM+Yc2p+SnAo1np8Yi5WsZptAyVIFwx5cikO43NWUviycbwbwihSAg888ouAI+KgmvTc7ch1U7tr/d7u+qQApXIr70N0NLGsN0/kMMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY8PR12MB7708.namprd12.prod.outlook.com (2603:10b6:930:87::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 15:51:50 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 15:51:49 +0000
Date: Thu, 7 Nov 2024 11:51:48 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Will Deacon <will@kernel.org>, acpica-devel@lists.linux.dev,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO
 via struct arm_smmu_hw_info
Message-ID: <20241107155148.GF520535@nvidia.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <5-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241104114723.GA11511@willie-the-truck>
 <20241104124102.GX10193@nvidia.com>
 <8a5940b0-08f3-48b1-9498-f09f0527a964@arm.com>
 <20241106180531.GA520535@nvidia.com>
 <2a0e69e3-63ba-475b-a5a9-0863ad0f2bf8@arm.com>
 <20241107023506.GC520535@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107023506.GC520535@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0252.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY8PR12MB7708:EE_
X-MS-Office365-Filtering-Correlation-Id: 4abfc410-74b5-4487-5d04-08dcff441770
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oQmlx1pjs9+a0NO+pLxGfPNHmPM51QAcSnp6yhGirxTjeeOGBoxmeGeUQXr/?=
 =?us-ascii?Q?UG3ESmysX3rnj7VtMga5SIIFTwWd8pwWb+vaxNn1Cjea7sWxkCYC8y7nC2ND?=
 =?us-ascii?Q?ElCwKUTBUvS7f2RnYoCrSt0Zu+lTZBnIRH4G4rQve0IyXld6dG8OGY16fGFZ?=
 =?us-ascii?Q?Joe0GQp0/5wlcFJkYhhTGC9FbYYY2WH/7j1g2iUfqKvJLFqn87S/QYGkGsch?=
 =?us-ascii?Q?l7f3OtFwKsibpQfNHfe+Z19g3ZSR7Uxfuvm01XtZRhL2CB62pv3oBV3WST1D?=
 =?us-ascii?Q?zd6i+z0lVwGt7Te2vHK0cBI9gQdfDZDRHp0ONvh5IUOzhlrxcOoJUcqTl4tE?=
 =?us-ascii?Q?OjZM+28eZf3R63ZOGbCHkF7bTtamgwimEfqpgeXzTqwqKjgxZHP2dmPalusg?=
 =?us-ascii?Q?7W8p70EeJCJrk5LCxtGkI3Vang/bd/rfg4jUauL2N3o5a+TuTOvKXdrf1JRM?=
 =?us-ascii?Q?0rO7Gy+sHcAwm6BZPOkaMbocjDQpf5wYiQOoSxjPcmlLnBRFj+C0ReNvSsML?=
 =?us-ascii?Q?Yv7NuMZtE8sfQjTZV86pzvlZRQv27+EdTBKOnHYNarohBXlqx9lelLQzjX6K?=
 =?us-ascii?Q?XoDNSnEThCtjT6QTEYOSgQK8BqZQdNPaITWtOttU+K6kAL5OPkvKLRewvbRq?=
 =?us-ascii?Q?PScX/oRP6JV2vA1xDEDB4WWIJJz9AhhYFPWHSsL/FEdeAAv1Ox05WhHl4r+H?=
 =?us-ascii?Q?swb0n3FjxWqUUja5P/J79ByBNdWd70lbWwMHKccIflp6mGMTS8CIV3aWShX8?=
 =?us-ascii?Q?xp9qS02tNqI4uQsWynMUGJp0ZMwnga0mxFUNYQIRKKAlU35gZxS4aMpoUMJD?=
 =?us-ascii?Q?0iYJPlZz6lHwWz6WjZl6jjojsKecZocU5soKYmwio+9VbyqiGfkLffdzsLqm?=
 =?us-ascii?Q?0zZ6FZBJBKsXb8YnJtLWE0sDzP+6xokUxjUcwcAZLYTaFYBtN5kITzWRy3hb?=
 =?us-ascii?Q?c/6Zd1Tm5rNuscQLFJAzN+lTFmY2LpoFiey7ax57lnRUd44rLzmEhpPYn93d?=
 =?us-ascii?Q?sOwmFogLldFo3fayr0bYrqXq/gJyUc9w8fx0eBj2rBJCf2y2EXztS6usE9Wx?=
 =?us-ascii?Q?WRda53ropX1MhhIwDelYMEo0/4cwI2U8JEutuq2qTaNzODGSwO1Aciv2c9Iv?=
 =?us-ascii?Q?KgRdbUKoetTXt8d1X8+0aIk0fH36WMoa6Ubp1JOmoxzKPhjWHrjialyu5fj+?=
 =?us-ascii?Q?KYwBcxXnkw2HG8hdiSfU6LGAq1oVgOjqwPoo25nEzx7EPEpu3sCnhVPMRJ3h?=
 =?us-ascii?Q?2Yl6/ByjdPCtmO2ZCNYUVJDAky74XadcJr5hnHNxJMyjejqeNsD9XCqRKAgc?=
 =?us-ascii?Q?q0KQ5ItW9BC8YsRJDaxj0cvh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PEGEZkQHHfAKcUxFgvx/1zNH8Kcxh0EUtuZukZQwJeKKXAt6K4E5GPNi92Yz?=
 =?us-ascii?Q?SF4rzLCHc0MdS/EwDr+0svLoV5q0l2mWU2R/By1PGaDPdJyvFa9A1al77WT2?=
 =?us-ascii?Q?jUOLpUrGMga9E6Kr0U8bwM9aRM/hZMxN5g7MrcQKxEDQOdequqFJg+vA+SCL?=
 =?us-ascii?Q?p3lrbU/E1kko5uw9I7+Exs4K2CuQrZRFVbXeCRRXjf4QGssj7pM5ChMJAhB9?=
 =?us-ascii?Q?E0UsLu5m310Ei9Kh6QUixxA3dhI0liarfElPot9UdoFG4UZJFeePdt1nkgXn?=
 =?us-ascii?Q?NaVYHJrWMyzp/Mg0gxDQmi6HCPdWXXlKRyX2Xut8N5ZRQNtMSC17CiiLZpDe?=
 =?us-ascii?Q?zxHCqdn28xzWLrz4mWRW3qUFdENVoD6ItEo89ZbTEHmCdyM4ZAAsSwgW2K1E?=
 =?us-ascii?Q?qPBmevmO0dUWvBGnDBtkQ7y+rHuEgouTgSx46UrepulHUj724EOkQ9/GCv7R?=
 =?us-ascii?Q?9HZVu9YNeipsIebTQYNDjoLccEchN5AguZND0AvrHE+9UCkdBY13jqCmgxE9?=
 =?us-ascii?Q?hvVXKfgmTQnTDIvIOjeGSgq56YTz00Usk+MC0cskoc2DSt+hQghV4uQKNsr/?=
 =?us-ascii?Q?W2jqjUfe5eczvBjjNXsuZLD1jVk4bTbju+pdJ40TXHv9EItGkqjZ721UX3nY?=
 =?us-ascii?Q?IzYZV2HHlaJWqCp438OqyuRHNsmZNOuIm+BO1J+RqSzd3R9Pv3JAKQGmbFoY?=
 =?us-ascii?Q?LWNzus2Sos2dt0SarHWiMEGJfE9b67ayVyz8wdSelx6SY5HJG3PX/JG7D/+e?=
 =?us-ascii?Q?WFqGHHnoosRUaUbgny3yqas0pDsbeOKRMc4dID81PYs8Ux+bOjYmHARzCbJp?=
 =?us-ascii?Q?12UXEWI2avJbU1yfSoLnr3FwnuyPyzm1mSXSQ33StDjaVqOdvjon26YDD2Ox?=
 =?us-ascii?Q?R9b91c51tW4kXWJF78HQHVnn07xUXH1VUYR2fCKd8fg8XuJd21Ky54/pvH9a?=
 =?us-ascii?Q?vQnhECTM8DpBFsazI7coOTU8GZ0S8oT5ZTP85FDThvWbZh8c9/wvyUVstPi1?=
 =?us-ascii?Q?DujQxxtXOh9Irr8Vh8fbpzcfG3q5YTDOaybW9Laa82YxkGURJd5gMbhj3+P3?=
 =?us-ascii?Q?flzRfhOdcMv3ddvMU5X4AdSweLjBXJ/HQO0JLp4Ec0tONMoT6TEWAvhPmShi?=
 =?us-ascii?Q?7tID8WeOOwCoYoPyM/96g7OQBhIxUjTySslahio/Blpga0coRezVaTekCxBi?=
 =?us-ascii?Q?VEdiT1EEosge9oDFW9a29ZID8hQ9gRE24qN4ZrMuwuVj1WD1HilN5o897lmh?=
 =?us-ascii?Q?vv27Jmuljh1LnY7Tj5Pg98HjaTQ11CxeBOrc2UmdiDF/eCXiMs45z6dy2Hpc?=
 =?us-ascii?Q?gGraFVKzb/2VfTvImO86EKtvHDs5CiljeCyK7EWAH0SwSCGnLd2Vr2C6kSfa?=
 =?us-ascii?Q?KIYeaoHnnuC12SEgI2UegjS9ArpZLN0inYnhxUVIXtnVhPkhom/9bpo/80+h?=
 =?us-ascii?Q?oWQijrTC1/94kjmHeN8agu4OPAOX3pEuPNBcoG4shacz6q5WMuSE/99qUQiu?=
 =?us-ascii?Q?EHDWtx+lo1CCRZWXZpIXwjjL0DRXpz0JCzTuzzkEei/8YXuG3b6bbFw3zWJt?=
 =?us-ascii?Q?zg+cU+W3cYb1de1FNO3h3FWOGHLa6GxRs6SmZ+Jq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4abfc410-74b5-4487-5d04-08dcff441770
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 15:51:49.8710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5mkUvx97nsdIr1UNo/hMmHVaMwVOlmlJunRXlyfFhlRVOLfteEqEMtFJ3Fo99LgH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7708

On Wed, Nov 06, 2024 at 10:35:07PM -0400, Jason Gunthorpe wrote:

> I agree the kdoc does not describe what the baseline actually is.

Nicolin worked on this, here is a more detailed kdoc:

/**
 * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
 *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
 *
 * @flags: Must be set to 0
 * @__reserved: Must be 0
 * @idr: Implemented features for ARM SMMU Non-secure programming interface
 * @iidr: Information about the implementation and implementer of ARM SMMU,
 *        and architecture version supported
 * @aidr: ARM SMMU architecture version
 *
 * For the details of @idr, @iidr and @aidr, please refer to the chapters
 * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
 *
 * This reports the raw HW capability, and not all bits are meaningful to be
 * read by userspace. Only the following fields should be used:
 *
 * idr[0]: ST_LEVEL, TERM_MODEL, STALL_MODEL, TTENDIAN , CD2L, ASID16, TTF
 * idr[1]: SIDSIZE, SSIDSIZE
 * idr[3]: BBML, RIL
 * idr[5]: VAX, GRAN64K, GRAN16K, GRAN4K
 *
 * - S1P should be assumed to be true if a NESTED HWPT can be created
 * - VFIO/iommufd only support platforms with COHACC, it should be assumed to be
 *   true.
 * - ATS is a per-device property. If the VMM describes any devices as ATS
 *   capable in ACPI/DT it should set the corresponding idr.
 *
 * This list may expand in future (eg E0PD, AIE, PBHA, D128, DS etc). It is
 * important that VMMs do not read bits outside the list to allow for
 * compatibility with future kernels. Several features in the SMMUv3
 * architecture are not currently supported by the kernel for nesting: HTTU,
 * BTM, MPAM and others.
 */

This focuses on stuff we can actually test and gives a path to test
and confirm a no-code update to future stuff.

The future list (E0PD/etc) reflects things the current kernel doesn't
use. Our naive read of the spec suggests they are probably fine to
just read the raw HW IDR. When someone implements guest kernel
support, does a detailed spec read, and crucially tests them - then we
can update the comment and have immediate support.

HTTU, BTM, and others like that will need additional bits outside the
IDR if someone wishes to enable them.

Jason


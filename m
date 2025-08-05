Return-Path: <kvm+bounces-53984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3B37B1B385
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36AA03A1025
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 12:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A932E27056A;
	Tue,  5 Aug 2025 12:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qf+k7uui"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2059.outbound.protection.outlook.com [40.107.96.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A02C1A0BFD;
	Tue,  5 Aug 2025 12:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754397403; cv=fail; b=Ic6+SBaRHEaMoHn4SUt4k5gyatkv9shQZltr5aTGtku54/1v6jytYySmGG4u8h41J3A5AHeXPJZ24MeCOJ4J8DinJckKD1lcpGl0yz1ghE3YC6tcNs/gw5wb9JliDsUkSWEcwcdnyi+RNnUqB++pS1gMXtkSL28Hdd7FihafdJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754397403; c=relaxed/simple;
	bh=SzQG/lAyMg9aq+YD6zaokzq1J4IUrfN5HvTXaR3Ejuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MyuaQ6gWDTaDhSUGeAJkSvLyjBLqLeciRxJPQWpx0hJFrsx0koF+yyOV0b5b6IKgoeGPWxqwQjHUxqZo3KSykePte0VSq3kgbANUI9EjCTeslvZvzlI/B5aRYgR4ZltBZNtmP07O4v4Vqu6wRdcEsyDMX6keZyt1G/shRlqlCcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qf+k7uui; arc=fail smtp.client-ip=40.107.96.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eYhq4V/F77/aTZeueQjNhXBUdxbs7KRpljTCrrn/Y+fOFG8sWnfcRrmjv3r7c6A5JxXm7338IVjb4zUxlwYzuZrC7aePlXJwBAqlkjAweQOFu5vbo2bSDGnEMbnO8sB9tS5coJ2o2UTtunW9fK+dZlJkGuNu1dexOiYL1BZAM+H4GF+oHc3OavRJnWjERfXzk1+fb8bQ4Z1P8t1zo03ryxvPnULZWdL/IhJqy39W5w0RCKUh6TjLyCuKGwjDFEeq7qtwZH8xjlkXgwC7XgAAooO9A9YoXQLrNpkC9WsnrRrDmBmbDHJi1/9HD2oyJnaNEsqtnPeMckaLw5zxJ7Lc8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7b9tGelX3ibZD9aTjf9DZWrQxRp7Q5qwRpfEZ3/CI5A=;
 b=h8pYoUZ9zfjqLJh2490PVKp72kTwzw5sjyzp3SkULV3V3kqU2CCnmR6GAdH7DIWcCeM/m2qLLr7Ka1rXQvHQTh0E67FKLQqrGwyP0Q6OltG+5KzYQ6MiX1bobsdBIBeydhd+1Pj/uA1Yv4OO/QfhpwqBBKWS4sF78x7P7dOcpwPUl4wtpW0ZzPgaFMzkDxH8WCJJXSSPhFx++tDQgS70buzUQa9AImB7QfVMRlKhK2I0eV4daoNghdJbOJXDCnIV9U4tMXYYF0Xe8bVA7/HGA/HszCWJS7nJOtsNQvt9ljwHnFULRjaRQhfKiAHzZX11B25ycl01miAidAQBuYlAsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7b9tGelX3ibZD9aTjf9DZWrQxRp7Q5qwRpfEZ3/CI5A=;
 b=Qf+k7uuig59HGgJcjJsVju0jrxLKzTLIVky/QzBnj1AhVOsalFUlWPYdhHHuDG3nzk73rrTrEIjawUBI0ZTFgYupGl7EOYqtHK0hSTADATfUM5PwcLRsUcET06pBwDLjGG+ZwsfT2B5jssXKEHls7lcCOO46spP9xEeAP5s22Xp999ndK7L72RkjGmQHPBPRZPbZboqZ5qvlmm33+TNF9030MBZtqPv4i7skUDyTLCu5R543r+ieP2/xcAnzF5CtJeJLMxgkQ9/FhuokUDa6vRqTDli3mkgnc4vfN8VWWc8bZREj9Wgo+o8NiuqKlo19txbfvfip5J/afcpMUCeL7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB5865.namprd12.prod.outlook.com (2603:10b6:8:64::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Tue, 5 Aug
 2025 12:36:39 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 12:36:38 +0000
Date: Tue, 5 Aug 2025 09:35:55 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ethan Zhao <etzhao1900@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
Message-ID: <20250805123555.GI184255@nvidia.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <a692448d-48b8-4af3-bf88-2cc913a145ca@gmail.com>
 <20250802151816.GC184255@nvidia.com>
 <1684792a-97d6-4383-a0d2-f342e69c91ff@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684792a-97d6-4383-a0d2-f342e69c91ff@gmail.com>
X-ClientProxiedBy: YT1PR01CA0066.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::35) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB5865:EE_
X-MS-Office365-Filtering-Correlation-Id: 41152671-191a-4860-e7a7-08ddd41ca356
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/HKbRV0r6sKg1XBqeCCcWYQ3q+zOSwJVd2zEgAu/Hz6TH0j6xpp3kBUZLoGI?=
 =?us-ascii?Q?VAc9y403OkZEPd3yK0f793Q/XQaAoUfC9xZp4jlfM6muRmkwX8+hScUckYGm?=
 =?us-ascii?Q?EEMAc91pemU6NC6fqMJqOREMAcTJL5CqH5+VdS+kwI5FsnIvlntyybHWgAhp?=
 =?us-ascii?Q?MldGau67+FcvWVsJpbzLziZwKO3Rj9BzJ7dP8MSe1OZm4uRkL1FK9Wo9FIry?=
 =?us-ascii?Q?WJTTkQRVcJl6bPNjimczN/aEEubSorqpvm6k+azQGlsiK2cYP50XUO+aoZQF?=
 =?us-ascii?Q?LhQDaoCg0Xxx3gmAZHcY71LJubJFwZd2beXHbZaQB0PXCRfBCZ9jDMiAIIHy?=
 =?us-ascii?Q?1ulH8QmAL4bvc88f32L1ExOJfM/N7ksux9SwgVQzbm21AdbBjvDpM8S+u8ak?=
 =?us-ascii?Q?1pXIUpKyGMU5v90IRPgE3ysrwx5vsyt/SgMwn9UG4W3msT/Ben8Q0ti6e4wr?=
 =?us-ascii?Q?qqRAHSw5WnnDe5a7bGZbwqA8eVsDBehz/a8CCruC1E/I9KJIGD0TnNsKKE5y?=
 =?us-ascii?Q?221NEdeKqrFXfqqzBwR98Bkf/K6qJgPBK6p0QYcxb4SV9BWlmwyqyLaSYjWi?=
 =?us-ascii?Q?L3WrrLd+F5mdKoi5BE/68zP0YxOASDfgWZMdPWId56vC4MX9ep+9v430051d?=
 =?us-ascii?Q?br58Vzobt7EnnahHMRWd3cquVqMXol/mXfRcgB2Z8J0Z0s35VEZZWEiVy5QI?=
 =?us-ascii?Q?qmSAblT9X6Rl1mQV/GR+vDKbh+pxagOAVolth/0alIc4WZRyoqooMm2NuWAL?=
 =?us-ascii?Q?iwvqxBZdHPQPZhtK0sqq6Ed2aBum8du9I7SP14oytlMwklJhReXNoeA8VJvS?=
 =?us-ascii?Q?4IPN2MbQHcHghVzh24hX/u5yhJPFbmF2Y5xjPztenvuyr190OjXxVdbU2NIV?=
 =?us-ascii?Q?YhTl+8MioeJmH6Fx32Rw/A8iPI8zkZJH4Koo2nwv42fyv31xirQZ+MFu2g6t?=
 =?us-ascii?Q?uJSzUkClQWctBmp6IXr+UhX3v9oOv0DCXsUNyJ978S0Fflvb8nXTkhekMJzR?=
 =?us-ascii?Q?ssfy76h6K+JEg8bCaB2kVtV8PXNC3uyEDyQGe3DCPImp6aWQ2Vq2QCBPr7XQ?=
 =?us-ascii?Q?G1u3NMINaeScRaDzYybU55GOpekizO+FGOL8aYNBy9NFZy5/LWwrOgA+rnKp?=
 =?us-ascii?Q?iO9l/AV7A4MuMBlBpAzuj72uAqXqhRyCagz6PSaGEFn/a6W++ebVRxXswCEe?=
 =?us-ascii?Q?KY7IMcjX1EAYan15u9QnAzLzHj/jMfX4ZtJgZFQ/Nbmgs7OwoIW4Et27KP36?=
 =?us-ascii?Q?1+xGLM5E+0nBcin7wDLxEinurKpMD3vjNWB49n/BRJWg1AJij2bkQ2ZN9QNx?=
 =?us-ascii?Q?zPzNnW4oO9L8N63cBaayQE/CKW8Q4fKKDPZ0qpWmsmD1PiAtC3OoLALTRH+9?=
 =?us-ascii?Q?wwPqW9T48GgUelCE0M0dIy3I+GtbNUaJGQUOLIm/luz/wLOYcg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Py62G13DBG53sQVd+cfzKqM6/WZI8BYHx+y2kZf/DoRp6Ua2i373HJlzPf3b?=
 =?us-ascii?Q?qSOsuKoL6tTaCDXgzkzXQA7EZp1u6q/NIfp/kvtrl2u+kKzv0WNBUKd3eESX?=
 =?us-ascii?Q?740icyTW20h998Giu3NOF2Dp+4R8P+8QBAH/1luFSSKKWWvtUPg+uH9cSvxd?=
 =?us-ascii?Q?YhNxhT4n5CeM2wdrTrZGcaHR8mPd/Ok+61x9GRvNQp7zteUru3SXfaPamMHh?=
 =?us-ascii?Q?1zn/u7DKwbhKWg/An2qUS3KEROywZZbBFnd9LZ760B+syDOGK5Mbo7ns4nuU?=
 =?us-ascii?Q?fC2ckSZX5UkPyzu5fash9Z4kHdJ1HXuTqOZQ8p1+2s4lE08lrLnIsHtNp1j9?=
 =?us-ascii?Q?wSbf/o/SjwTbvFHNYNEfz8EC1bzAxfrvVw/Lm0fOBtpwsKKLNEsyuPwmoT3l?=
 =?us-ascii?Q?bhfS68nY1O7IhHkz5IcW1DdDErr1WZxx80/JeUZCAHW0oneAEMVBl05jBROI?=
 =?us-ascii?Q?kDGGZNtR6ULxZZdepPDL5dDKVVZUPu/eD6aqj9Qmt/9sYmeDtC8xLM1PilCn?=
 =?us-ascii?Q?6zyzQMmoS8KlB9J2EN9BizNQoBq+wAlaJDGl37odPlobeDmU21Msw83Hs+Dr?=
 =?us-ascii?Q?Y4Krjoc4y4rRh+c/qXWOeGSGUiL1caKXgQsx0puVsWtH9bjibnz5+WeosZE0?=
 =?us-ascii?Q?4Aq1IzKDZjwyhoWfVGQkdjMahwsNG/iD8ZzJUSstIf0hKq/6F8t3DQdilTpx?=
 =?us-ascii?Q?Co2ecph91kWnXoccn718hPpVA9fUDo/p0tuyg74SQVubccS/1+nQ/vDwcJbV?=
 =?us-ascii?Q?/4cpYK9MHmKV1FscNkljpvZLLlsGfIFXxjfdVjdGAqP9Ijb1iutFOyFMjX7S?=
 =?us-ascii?Q?m6V0AAxoSgvDDYqiduIbS2eJXYhrDOYjtkaxWGqtN0Tun9nQ/kftWCJwmonr?=
 =?us-ascii?Q?D1VCPXfaRJQ/gutLbfZqK8Sz0pQTynCp/c20wyzxdxhndFUo4RImCNQs7UJ4?=
 =?us-ascii?Q?1h8KPyRZgZiK3FQQRrRienjlOZ3Phg+0PiqS/Bse6kBTDc90ZldxpL9Cj47n?=
 =?us-ascii?Q?RTkL/wbF4RaBFcXclk4LGiBX1sKDHvD/gg3ZnzV5GDcV+sqqNqgPo8QUq1eA?=
 =?us-ascii?Q?dk5U97HpFwR/puvmWO0+90aKttGInzJVFfkHyHSaGKl3jycb+J1Wxqjp46Nh?=
 =?us-ascii?Q?6Q6qVWIc+6fCj4SiWmxi85ZQLVoS3//lboU4QRSZMc+zCofUPzcgP5fnmLl9?=
 =?us-ascii?Q?q9VuOyfe7IgT7fAtmdb4gkCpQcKhZV1j0W6cLI5NJ4hRdKoPZ91qYKyt7Fzi?=
 =?us-ascii?Q?1TR2lM0P/Lqb6ZbOiavMSJJeOD2pLGPKjeo+zlzhzVo6+grWZf0nxlIIQMwb?=
 =?us-ascii?Q?5kfemypdezY0Xb1FzbnEUk37h9wenOrEAxRrHeceix36x0KfOwSLx7wbcIAA?=
 =?us-ascii?Q?pvpH4ejW8X12r2v5U1Vk2efcUiI6XizlDSek50+b24dcjTe/Opa1xBeZY/Ky?=
 =?us-ascii?Q?QlFq895z5v7Tl6fDT21qT7Lo+gDRdEgYJCBb0VLyMpoNj+FYjlsZbex/lLMb?=
 =?us-ascii?Q?O8QWugwlcWzNA9gJ8hz5XzmJG8pAzrvWegXW7DMR5avJA9BKM2TW0YiT29gZ?=
 =?us-ascii?Q?Ue73N2g6cN7GnOpNMeI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41152671-191a-4860-e7a7-08ddd41ca356
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 12:36:37.5659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wozsQFr5iMSZanPd/l3dTqHCODNwkVp6Or/WcVx8E4irnJx8KQ9yIjOhxjRUPf6t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5865

On Tue, Aug 05, 2025 at 11:43:29AM +0800, Ethan Zhao wrote:
> 
> 
> On 8/2/2025 11:18 PM, Jason Gunthorpe wrote:
> > On Sat, Aug 02, 2025 at 09:45:08AM +0800, Ethan Zhao wrote:
> > > 
> > > 
> > > On 7/9/2025 10:52 PM, Jason Gunthorpe wrote:
> > > > The series patches have extensive descriptions as to the problem and
> > > > solution, but in short the ACS flags are not analyzed according to the
> > > > spec to form the iommu_groups that VFIO is expecting for security.
> > > > 
> > > > ACS is an egress control only. For a path the ACS flags on each hop only
> > > > effect what other devices the TLP is allowed to reach. It does not prevent
> > > > other devices from reaching into this path.
> > 
> > > Perhaps I was a little confused here, the egress control vector on the
> > 
> > Linux does not support egress control vector. Enabling that is a
> > different project and we would indeed need to introduce different
> > logic.
> My understanding, iommu has no logic yet to handle the egress control
> vector configuration case, 

We don't support it at all. If some FW leaves it configured then it
will work at the PCI level but Linux has no awarness of what it is
doing.

Arguably Linux should disable it on boot, but we don't..

> The static groups were created according to
> FW DRDB tables, 

?? iommu_groups have nothing to do with FW tables.

> also not the case handled by notifiers for Hot-plug events
> (BUS_NOTIFY_ADD_DEVICE etc).

This is handled.

Jason


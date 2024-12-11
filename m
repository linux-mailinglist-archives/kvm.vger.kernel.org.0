Return-Path: <kvm+bounces-33494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F509ED47A
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 19:07:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C48FC188A7DB
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 18:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED6EF2010E2;
	Wed, 11 Dec 2024 18:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="beIsdphj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B31246344
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 18:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733940412; cv=fail; b=sYTYDJkdmyF2bZHT598XO9/TIHpvwEQ03uib490OwroxBNVIW+tLQ/+Wtxis0+ynb3AmsVcc3MXbGPA7hvo+i4C4AH4J0m9KrNgg7Zq2p5ODc+AbSS+JPPr8NhZ0JOHkU0M/tbVo7pYSd7iIN1cSl/oA5q5rFT2jqp9xjEC1POQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733940412; c=relaxed/simple;
	bh=VfJhf5T1jfOw89ZmOhm5AM9zlBSuF/JeK7hlMOLYtrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ngpnT5L0AIDaPmq+a9hAZ4Nz5P76PGsa0dHGDJ4/sy2T6R9PcYkHG6MNBLkFHqAtWw4BO/cseNOpkzM6XpfZecxW4eD6y9X2xbtnA8w+wR9WELIaZVbQ2E4QengW9zIYFOzNz6iwqgrcG9u9p5wLqTbewFtR/MNtHZzfLwFR/zU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=beIsdphj; arc=fail smtp.client-ip=40.107.243.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K2gsWqrbsv7j8SIFOC9IxO3HFckDtvSVV172Q3MRVMFHdUKs2hKES/MbK5zFFxHGrYG9dtU7bFQz2k2UOxRYgZgV63hBfinljlpyXrfOo82m6U27RjRzNencY8mweB72HE968OKxcd1JBXDmUugDz/ZpW1ihFKVTT4m5R3pL7KY6rbTu4R8rHTJM4KKNcDzqEOqR1e4tbT1XcrE0yei3PTzUyyq3BlDcjb9fw8DSTRZriWcHX3+B9EYGZ+jx6pDeRa4SdrPtsXXHubPssoFytt7Z6sQ/HU6s+o48V5CaEAoPu0m84/meyembVBcQ+3fntA+oLJqHYTp+AWoFCREjeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A12+CSEe8YNXpfYB71liIb6BtsqngUZ6CukdhNI8nKY=;
 b=ilnKEOht2Zdgi1ojydG+BhjOc6YJ1OLvIdeLFmtmysfYDR3oLh2U5LWMNpQXUh+bfrPrHQosdiyt7oizO8kbVwJUgzE/65S1qcM05+AzhxeyZpOIjSOs15WgkQFF7Uofw9lwdL5IfV0OnogEWjI3SgTaHHG5os1WdMul/g6kZU6NqT+uJSKbGS/Rqg5XsDbfxdc8+rXMtNNCaDNWsXaq32EKCy6o1oQF926L2hZe5ccnqCVqkKXDI4mJ/5zxDhH/+jdePCxiW1uiryLq64AhIQvI6nWyXTCE6CEru3mK6D9UdW+Vewm55/x0jBoJn4hxgKE4FsROlMPH915psMDKRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A12+CSEe8YNXpfYB71liIb6BtsqngUZ6CukdhNI8nKY=;
 b=beIsdphjtQ8vn0IRT4cO5JikvN2bey3Kz2kiG8SdgzETJuJIJlOAj89C02GdR3LwSn10rr3mdGTXePDvYYJ7ue5tPzYM60uGQYon0FHcVT/mm5iRkaf/LTDfCyOX/rkCzPx7vvml5iBKWE1MsvLaJhL0Bz4VJVxFRlka4VsJKrd97+rwUpKDEseb0/Net8/EgTS38LhFpq7OC5hMM9cW8yEGHi2yfhOZOLWV4hwzsXIVQzfPnu38J8xkMP9vz/UvF15eznfy0og0EIlJeUurxa80sIOSa6j6xhAa5iqht98AzSymwGwt3mFFMFkFvBqK6RfwR7TfurDXxMWUbtaz5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA3PR12MB7860.namprd12.prod.outlook.com (2603:10b6:806:307::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Wed, 11 Dec
 2024 18:06:45 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8251.008; Wed, 11 Dec 2024
 18:06:45 +0000
Date: Wed, 11 Dec 2024 14:06:44 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
Message-ID: <20241211180644.GP2347147@nvidia.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-9-yi.l.liu@intel.com>
 <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
 <20241206175804.GQ1253388@nvidia.com>
 <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
 <20241209145718.GC2347147@nvidia.com>
 <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
X-ClientProxiedBy: MN2PR18CA0001.namprd18.prod.outlook.com
 (2603:10b6:208:23c::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA3PR12MB7860:EE_
X-MS-Office365-Filtering-Correlation-Id: 953af1bf-f99d-4146-ecbf-08dd1a0e92f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1opEI0ZyVTPybPe1JwaYra+BsC2itDp1DWDBOtl8O8ZaZmlmQ5H8A3Ec4YiB?=
 =?us-ascii?Q?PIASwfQeLZGnzNtJ12vqWT3HUtvwYFx23dup5yF35CKfOvo7Q4KgLNOKIFv8?=
 =?us-ascii?Q?tjfqOqKKpqMIh7REXk/zTZInjGz1Vs0kKW0IKjj9W+PajnOrV1Gpl3IoOZ8W?=
 =?us-ascii?Q?afmSSx/MyrjGnZBzwzeHG6ANpzB9utKerYsuVJe9BJDIkv/FBWG4XawGHgyx?=
 =?us-ascii?Q?v9ShIyJUHaO0w6j0/EY9EQxjuncMYOw+nXjk4rn7HRKj0DG9+mWzRWFxZ6qQ?=
 =?us-ascii?Q?3C/XMhXxtVqdmHVWSbZZWWiH4pQOTYu9C8btfxgGU23juaeG5BoMFFo6K4MT?=
 =?us-ascii?Q?Cqb+MJzGXvvNrxW289p30nVq+s11TelcDtaaordxV75tq1PZIBYl12Y+X5eU?=
 =?us-ascii?Q?7fA97SwNf8g3jJEVKYlNbq93+cHL6zH9q0kHiMe6DQI4jAapjArzbspjk7v+?=
 =?us-ascii?Q?V93Kg8CPs9poH8C9PFLuJ44aMqLjsvjQsmwkkSHZSkqmPp17qQ3EhrYtknMd?=
 =?us-ascii?Q?RO86TqOqYctm6ZCAl/0F94iv5t6u0zJXrnVRtC1W/cZkJRe0VCQkRLDfS1XV?=
 =?us-ascii?Q?dRjbLw4Q0DesSJREk+MDwUXrb36/Egl/xi77tfn20SSYBTUP1++xXZH9iLVw?=
 =?us-ascii?Q?frFdR0/RHU4YJiINO3y1snxpB4QI58Dej6KvUWFZi49mUbxcmdc6qDywM5Yc?=
 =?us-ascii?Q?jC07Jbq5h6eG6em7ICoRWUrOlfF0Nb26KSt9nygkl3M5Ymzr7ZUWM214Fzbs?=
 =?us-ascii?Q?F04Ig6MmP2sEE3YhydBm2icuhnohRuo71E7o4481gmgKY2ibghPatoNcKVr1?=
 =?us-ascii?Q?4ZTfgFvUAj/bGW/Yu2Kbskqydar9BSCl95ZJ97PUI1MU/Y+rcuxrjgE1v9ir?=
 =?us-ascii?Q?rh/sOw+2JoJRyP9ue7ImzCMKRDmbkyVY5h6Dtdn09QqI/zbNlO0axsTnwp4/?=
 =?us-ascii?Q?UnPG99wW4FaQ5RtjnoZt0sqCcggBjVXeksXZgCOP13BZxBux+4s5EsnFKQbG?=
 =?us-ascii?Q?coIMNmATMI++2z4rkgsQnadnl9T9vybhBb5rTr5ZhNEipvVxr3zo/DnJq4pm?=
 =?us-ascii?Q?GuyGXCZq1P2jcNdw14GbHStSpVHWWqWpZlt4qx1XyaM2Ily3HBQAiHa8g12x?=
 =?us-ascii?Q?OQj+dziTB43glghUFKq1K2SQzxzFIfbSqxLdXAJ5yLll5xLzfNkZWYkiDnB7?=
 =?us-ascii?Q?ClBYib+0BS5/fOvuSIeqtNqhgkYLAl+C5RWwOcQ8cD7HRF2m1uWTBWQyBI6t?=
 =?us-ascii?Q?oHRQHktQ6oreysQBIChYzVuSArYKglg5+3nNWcUh0DnDkT4qOvTyr5JrHdyg?=
 =?us-ascii?Q?Yvkf58SZNrAhlZjRK97edU0LR1yRU7FMWjxGzgiLwnAszQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QBe/mBtfKSJjd+fW5CNDBtpVk6JRqtSHEWoQNhUIawzjRsMpr0ifXeEF0qsu?=
 =?us-ascii?Q?4YiWx6Pe8jDRBEl3sORz+XrYZwALwhCTUNm+B0ibhWtVp6OCoSDPNQtG3+BA?=
 =?us-ascii?Q?cfUUhYyN+auc0/6sCQPXTj5eWzUWqTGZQX6aHeeqg9TrMCnXyn01XhqCxvY2?=
 =?us-ascii?Q?FzKRlSTtSryVJLhPwkn1U94K2ocoyYkiVUSqTUptSb4m2rx6ISQw/SfuQN+y?=
 =?us-ascii?Q?DpZx5nRoxBMooX4LngaFYi1KqKaB2VgK8zqKTYds0W9M1tO5iZndZJYVUh6p?=
 =?us-ascii?Q?6kQU42fdOkJOEsrqxKFHijbzp+q93MJctW51UeuuyfAVl/Bix2lU7jBBgOBM?=
 =?us-ascii?Q?ZO15lpSKgjp8RYcYwfugZt4jroBEuu2SIjgMBC5Fpmmc5EK8AuqkcgGcieA5?=
 =?us-ascii?Q?ZftfsWuf6P6arXYkDDd0ymRyWmHqDyzg8DkzUq63ekzCak6JkePSUxb0whRc?=
 =?us-ascii?Q?mZdjMoUOPgeCzxO57TkbjjHW8Xz2tegmXPrMbgCavRbNAvY0ELOC5Cqr73OC?=
 =?us-ascii?Q?s4aLosjMp8T5kx2FnFxk7ufbrMQ8UEtaR0g8drGs3OW11p0aER9sp6xDHFAM?=
 =?us-ascii?Q?4V3dO8LbezIUgY/VFIGxT2ZXDTyyY7N/k9ZexvKD0u5JoqR9V4ndLXg3ldcU?=
 =?us-ascii?Q?/kItFRtyRT8m76pJJ9tvj0yOCuDOH+unuGpHfWYo5k8hgQwmdpaoJYPD5DPd?=
 =?us-ascii?Q?qZWYYNLiL3IStc7McmkRIU79F92o9gVvAKUgtKYqiOHrg2WbA/1dx+IFFGmF?=
 =?us-ascii?Q?B3X100eEqRBa9a7dhvfaLuxYdZFz4IGYDgEFVgpxWpANLP+xSauSPQ+jcNLN?=
 =?us-ascii?Q?ILi4qWUmV9ThfXKgQlk+1kB3bI4ICjZskQJoIfZ2FsOjlN+8PgA8wVctMk9d?=
 =?us-ascii?Q?DwzfJlK9pn8bmvgQzzViRrI9HEBXj/xddWYD0K3jJpbXT0QYlZQE5T7xAkXF?=
 =?us-ascii?Q?jWfLfmrP1E1qWtiIqcLLjaYOVKcVOD0au2rWX9xd2WbE9XU67rSZeigT77Nd?=
 =?us-ascii?Q?GNChFeSwApJQfCddeQT1ZEukLRenSU4ya5ginQQwrWGoC9dDrMcmYwu4gyb6?=
 =?us-ascii?Q?u07eCi12RlWyeyEiYW6essTb7Nyc84uCpmu36xX7cSrsgg3BD4j/HgP3neet?=
 =?us-ascii?Q?P8FnycgHX6T85pOMCjnpDeeCLAwNW1GOFtjk/g1myR6ZPYFhJKgSQPMtgSVv?=
 =?us-ascii?Q?RhZfFISVWcUwt+lTSfgi3eUtUeIpJBXHzdtoFH1cWYzbKxSZ4dRiH7Bp41SP?=
 =?us-ascii?Q?P3DiWhrZHqQZW94tU70KK4FxZoZv91RYo8yrYOCzC5+OOYX7bEP7RgsrO0bb?=
 =?us-ascii?Q?ND50XPmfd0FXblxtr3EXsTgbJ/s9PhB3GOlv9+13LpfTGT4JfyzsYiVAqLjy?=
 =?us-ascii?Q?7rFpcJqHsC5wgC7lrUPObyaWP9detM4f7WoKtXdyKrcuz426jMwn7jIRb2eC?=
 =?us-ascii?Q?CjI4/1h01jj97O7QrGWiCjE9q2h+lMCh0gpkXeorjRglXnPG7sKXKWtKEdU7?=
 =?us-ascii?Q?UGO0zMkzmEHDrw9n61uwLaXEx0E1WfR6bkFv9MvLeZpPomvWwXyd95RkQbiq?=
 =?us-ascii?Q?HLbo6Lx2gVAj/3yWX1DDiZofocrM6pGKIbSgkfIS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 953af1bf-f99d-4146-ecbf-08dd1a0e92f0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 18:06:45.4906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qVl468gQU8ywNLvSGGdoGRRtviK/rqb5U9xAk3EZpP4K8Ry2Bo/y5nMVePgp1HcW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7860

On Tue, Dec 10, 2024 at 11:15:13AM +0800, Yi Liu wrote:

> > Why can't it be in iommufd? A PASID domain should be a hwpt_paging
> > with the ALLOC_PASID flag, just put a bit in the hwpt_paging struct
> > and be done with it. That automatically rejects nested domains from
> > pasid.
> 
> The problem is Intel side, we allow attaching nested domains to pasid. :(
> That's why I'm asking for updating the description of ALLOC_PASID and
> the enforcement to be only applicable to paging domains, not applicable for
> nested domains.

Seems reasonable

Jason


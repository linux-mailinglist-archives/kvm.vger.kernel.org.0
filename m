Return-Path: <kvm+bounces-24206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A72DE95254A
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:10:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E218282E6C
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B76AB149C60;
	Wed, 14 Aug 2024 22:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z5dFzJFU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC0060B96;
	Wed, 14 Aug 2024 22:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723673439; cv=fail; b=k/GkJlfMUNAe/AbZz8fqRniyv/3h3m8moX2U2ofg6cVA7zUNhgWXqEThcdvCZu+dGSzpTL7QpktGCxpXo2ALL5MU2UJZ8ZW6L9sJUmUWmZYP4jJD6PFP/Owb8Ug/dKsF3HHesIm2nuWIFV86sgyJR8MSIuq7rInUxKonkpQ4Nkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723673439; c=relaxed/simple;
	bh=j7fCh/W0E/t04m779J/QmmOd+d09hbL87TwgrdVzgA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QfWKuRubYIHYTIPtFf8v8zGnpn7nNyxcA3NFuaO8OOLhdyk+b8wTKXPq9FKaAVVVILhEpwqfPE+VPuXDcXkhnrjbUMUBeiM+6uN95vFrigWZtSAIkxbrYf3ONRdKRaYgseJUoRUhvMHuQiBnYvV6EZ595uJgCBqx+SOhrgVAo0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z5dFzJFU; arc=fail smtp.client-ip=40.107.236.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=paVQMzhcNq+3YKyD8AxcgdIOZsKMuFq18ffx9wW2zaWBIwzhfz6nHOckwzvrvLW5UJ443crlaVpHlJgfj9M+tKqXoa8del0OgsDwmVkkYHEFgfPop3mKKMite3jtKe4CfQZpggFjXj0OTqSSjhlVgq6gtscYmiuEPRJ1VOY0JKcPnf7GmOfTrC/QDBGxuTbFzCwj/GZ96SAt/fm/l6ySwtgYrm3iheczA9owO68obFzOHUvpP1w3nr+EZ2CYUZQ/4wBNp7MZURPsPt3pWQx6XZdtlh2j+o2dThJVS0zAlP3/6TX2Tx3UkQFgDm90CSXsVIw2iTDuqcsq/ZgaOZHAWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LE1PQQNDeulJVj87CUZ9oMbbx/fC8C3IK+RllAHVvWU=;
 b=qL85PwQ8r/mouvjNRIm5AN31vhoA5/mGYB9LeAduxK4j432QPoUbe/ELRnaaPXQVNLGMdaRb8RD47FhBcBxojyh76iVZ1JPsVtApcliWYgV0gQrCwSck0pPP2e43UkCCjSrPLx9tWME/tM3X+OA6TPox64LE8Bi98j9LSXrOVl1yCX0ND+2VKkK2zUcIgRCZabzdmFqJ0UsdOFfFwu7KCUNEZHZjC82uCuVoRVFFeCOdnLqdFWglO4UGVRfxz5UAfwxI5X2zxMwo6qxswc0vZeYPKK/qNr5uqr4TNAFIf0mLHg4La75YAnWaL8eyMs9yQ0ycyH4QyI2EerC+ZLecCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LE1PQQNDeulJVj87CUZ9oMbbx/fC8C3IK+RllAHVvWU=;
 b=Z5dFzJFU/d6wd8WvJDbluCFfWwnOqAzRxijCBfM4CydqrMOkVy9KsJQXVPf5VvNbmRrc8VCzYVruU7lVBRRx44r9rErouIht2pL5j5g/7nq3eYNbLGVfMuyIfOX87k51tYUS1t2kqcGfq7SQeaWpqRBKyViX4Q89HUQveEWPze/Ha8VjVQOjc9vkuQtK3VNv0vwlhMan78/i2jryZrIV7yOmFxIVS0cft2LJc4xx2EfJT7BgI0PRb+ZmCpIC21H6GDhgpo02KFLrbf4AeFO6bYNivp+W1hnKAfZd7hTSzsX7M96Gv7uC9kosgHWWySHgn0++y1H9mSTxFaLe4cBZog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB7803.namprd12.prod.outlook.com (2603:10b6:8:144::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Wed, 14 Aug
 2024 22:10:35 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Wed, 14 Aug 2024
 22:10:34 +0000
Date: Wed, 14 Aug 2024 19:10:31 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 00/19] mm: Support huge pfnmaps
Message-ID: <20240814221031.GA2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240814123715.GB2032816@nvidia.com>
 <ZrzAlchCZx0ptSfR@google.com>
 <20240814144307.GP2032816@nvidia.com>
 <Zr0ZbPQHVNzmvwa6@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr0ZbPQHVNzmvwa6@google.com>
X-ClientProxiedBy: MN2PR15CA0025.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::38) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB7803:EE_
X-MS-Office365-Filtering-Correlation-Id: f2dcc4f2-8881-4486-c40a-08dcbcadeafe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qjoGpi6u5m74zm0+EWDagp7gezGWw2Xc7d5GqdtdzZmMTCnqUZe984RJXlkh?=
 =?us-ascii?Q?NKlnGYKonYsfwOhtRj+U1AveQz9YbDVQmNpVEzhafsxAQLi1cZYbDBfi/oI2?=
 =?us-ascii?Q?y/LMZHQDajO5UTF9xaJdjNxz+PhlA46GArYX3COh6DqX/oKo5501uUII6t1g?=
 =?us-ascii?Q?Pm9nUvTy2fRP7/RiGFes5HEmuZivqY+J4RH06xyLvFwKsiVmKPVEWKA8QQzK?=
 =?us-ascii?Q?SkHCUAg4IpkfNltLRxsnzD8xlBaKkV+FrqnSbKHeWWqf6OXGFK8AR1DNEv8/?=
 =?us-ascii?Q?tuEJLuO36kIyaU5riXxWMiMb+HNX9oVGzmYsgsrdKdbU/pb2bnzRsr/uaNbz?=
 =?us-ascii?Q?Lf99q5929xqV24zRIocacuTfqmvyusoauosi7XIs6aGOUmZTYEMZ8s4tN5kC?=
 =?us-ascii?Q?aLkxGgrWqvWxu6BlNbaCYHmLKtshMB1Gm3yNRA0D0WQQSBMcOWKEVIbsF6NT?=
 =?us-ascii?Q?BEhN9B0Otl8LdRb+6FFEzPCovgAJ9tuwJtbKVxxvFIxq/S6o/H6XWQoufOON?=
 =?us-ascii?Q?twh0C4LiGfW0saEMBXV/Si23ZBo/TSBB9o4E+SQWLoEyN4/rhPYZpTFl+vws?=
 =?us-ascii?Q?OZ4XixGYoUcOphxk/lQRC3mgcDXYD0liShwq/9CVKCBTgt1WXbEX5Zdckgcn?=
 =?us-ascii?Q?gZ4rmq94EodW3lfEfgwvyaUXv47eOhRovJxZQgj5wvJlbuHF9f3mNsrzw1js?=
 =?us-ascii?Q?SkOj3CiN6qxgKbl6IFEzcqzpf1/46n9S+0OEagmUFz3uwZ3sIvkLRF5FjFkA?=
 =?us-ascii?Q?LSl5AYu5DzRmo45UB68LaOlPBrUT8TODaGgv/zNsyIjbOIX8+3RRAugLT6FM?=
 =?us-ascii?Q?ELpid7Qa7LnSdBCN9ys11vhF/oWeYg4PweKSB4jw9QCtAZu+1iB5HfAXKLWO?=
 =?us-ascii?Q?/2mMqdgpkAjNPhqtWE4qEQrHzHFU3xOVc840iOE/EFDsCkt4196ysYDm2rwa?=
 =?us-ascii?Q?HcVJowDauNiMQSTmMrq97FG6IBLvu0Dt24WcY2IbTwUAiWBHC6Aef9lwnT+B?=
 =?us-ascii?Q?6yoD79C+RMug4VsgHnGJuPpJhRO7mHkrEDkbdGhXVk04qqpI102S4oj89Vkl?=
 =?us-ascii?Q?Z/Ntd9RKrLxi3gWTcQkLuQx5+GPAMl51x3VXZcKvDJVUViSNmXokwiZ6shQ7?=
 =?us-ascii?Q?W8R0aIaJIyijZBjw8y2Ouqo7roi7EkykHAY85jvPLemb2oQEXBb47HI4HeyW?=
 =?us-ascii?Q?41H7gItFHchIlwSiaaMohc/WP2jLdLhrpvurYBfaVrbWCnnW0gg4uMhZV4SG?=
 =?us-ascii?Q?qvsq4W5THBY0cM2JyM5ugbuCrLx5AU6DvlRkbWnl9YRNz+H6Wrus7rFcE0DT?=
 =?us-ascii?Q?DdU9M9oAN4lOfE4UA0aCn33wASZ1JWjSFFwZzNJoi3lvJw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OXcB9/Y4ygl5hoED3hbWLMMZ1UxqzWLRUPwoslX1h4MCSgD2rMZZzbTSpW1B?=
 =?us-ascii?Q?nFKRl4MHyIRZy5UoVOegMmS2obr11QjC5dXtAjewuJfN6gZ8jIpg7Qm7+q+/?=
 =?us-ascii?Q?7W7LY3kmWLbj50s7e2ukGFsDj19C5T2Ngoo4CuuMZ4JSDGPrtPhl8gv26xzr?=
 =?us-ascii?Q?KbwYY/Co4HB1jC+MZkxcu+S2PDmlhnTw6sVfRvFA0B7k4yOgIXK6rO+KcNpj?=
 =?us-ascii?Q?77M1gRItQRV8L0LTyDb7yYUlsqNCgO9brCJC6ExstLkaMNoQ6kU1+MwHNJrU?=
 =?us-ascii?Q?V10gaPwVzhPV6ktu+qZRpdHb1lor60TiKWqMOHv4MhZKZsHgJMmrS0ULiDC3?=
 =?us-ascii?Q?cjb6mX2+oGO1zDtrhzap+I29OQFWubWVhI38vzY8Z2UMfPL7FJ4SC7A8czvP?=
 =?us-ascii?Q?c++c+2HUEoVBgD9tnnK85oLILMWHKPzC6tzB+Jzy2/zQjhx7X3IF7NaarI7x?=
 =?us-ascii?Q?CnDDaSotuT9nFlTucdPW/dy677Aiiou1KFCDAwAcWl4FT07XhsqRlvbsCZcA?=
 =?us-ascii?Q?ETojSL/72sP7DA4agvYR6sSpP5Ma33LvVS3AcAEuE7HcSygylaLNWX9+CZax?=
 =?us-ascii?Q?SwcFtExyG/45RXD64Py00kL3edE0GRZ/jSryw0QGHWHW7hFjkf54EHtBS/I0?=
 =?us-ascii?Q?yZSLg6YLP2Cc2P3UuCicosM85BgAw9+taESSeqLgl5ZiD93NyTBrhSBKltmk?=
 =?us-ascii?Q?X1fhPIxkB2IyYrJBDIdOwMM1CdfmoS7OlGpYRmzS3ZPR02PoIXzbM0Og36wc?=
 =?us-ascii?Q?E98GzXYlVnX902EPNXSWex3cVJF92Qsm2f3GQ1Qr3Vh/Xbbc5eAwZ+5PZMv5?=
 =?us-ascii?Q?wZICp1B/zFadqca5MvE4eBX2d+i6/eCKzowi+P3TyTlzf26oD7abxmVnDMQt?=
 =?us-ascii?Q?2bUD1HfP/trebcwLZdAOjBKmWXhUuj5sgtgnIKCy2yCkre1urZ5n43IWd9e3?=
 =?us-ascii?Q?p4MPh5gx/O95rKyPTpv3yyvGMO+O+0UfiZeuNcU3vTq5ff5Kkg+8hGLPkrLL?=
 =?us-ascii?Q?PoV5S73zAthUEl0q2BVghecBhaKtNJrKcfS78ImUYCb21+ThvlsH5nWaKZe0?=
 =?us-ascii?Q?cymxJIeubUSeD1iST7DzWY7ARAibxKxiSQM+Q9EtP8I/aSH8+PmFjaa8Eym0?=
 =?us-ascii?Q?6k73WWoEiPx12q9IlsvLDXfcyK3p60fL+FmQP4lHjt46dNhlaa8Bb8ikkEn/?=
 =?us-ascii?Q?h1AumcxhTLG+2OLSv2Yar2nvEnlbWCeNjEd87Eshe91+oVpjBa87+9/rQrkW?=
 =?us-ascii?Q?JMKpj26fO9eiqWGTQaBEdNKPMyRNEKqxS/hfeYKBstr80xEp7q8KpuR4hb1A?=
 =?us-ascii?Q?AuQ9VW0OtdgA6s9sEf0e8PQH6mZ6ZTkKmQYPje2bb/us6U/Jk3cYICRuZBcm?=
 =?us-ascii?Q?przjAR+V0U+Go5yAEFx+GOtHK9rzjg+BT+AtjOEmwSml5Kg3THW1+KtDfB9t?=
 =?us-ascii?Q?Z+Sy0ohQXGa/8kNfDQWc+ZMMLBrHKNV5fXuWGNCOmf5DIzwKO4u9sYQct41q?=
 =?us-ascii?Q?v641TYFqAs9gpV+BTtIAB0sxcRiKwBzh4SfjQbbJLt/DnV2xzVI4mXkWEq+t?=
 =?us-ascii?Q?JlJWowx+Phss7//PEG0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2dcc4f2-8881-4486-c40a-08dcbcadeafe
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 22:10:34.3346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3wNLuTpATmsxAuY/86QCZTHCXC0fD1ZuRa9IBfj53TAYsdnwdlE6UiVmVaAJ01rR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7803

On Wed, Aug 14, 2024 at 01:54:04PM -0700, Sean Christopherson wrote:
> +Marc and Oliver
> 
> On Wed, Aug 14, 2024, Jason Gunthorpe wrote:
> > On Wed, Aug 14, 2024 at 07:35:01AM -0700, Sean Christopherson wrote:
> > > On Wed, Aug 14, 2024, Jason Gunthorpe wrote:
> > > > On Fri, Aug 09, 2024 at 12:08:50PM -0400, Peter Xu wrote:
> > > > > Overview
> > > > > ========
> > > > > 
> > > > > This series is based on mm-unstable, commit 98808d08fc0f of Aug 7th latest,
> > > > > plus dax 1g fix [1].  Note that this series should also apply if without
> > > > > the dax 1g fix series, but when without it, mprotect() will trigger similar
> > > > > errors otherwise on PUD mappings.
> > > > > 
> > > > > This series implements huge pfnmaps support for mm in general.  Huge pfnmap
> > > > > allows e.g. VM_PFNMAP vmas to map in either PMD or PUD levels, similar to
> > > > > what we do with dax / thp / hugetlb so far to benefit from TLB hits.  Now
> > > > > we extend that idea to PFN mappings, e.g. PCI MMIO bars where it can grow
> > > > > as large as 8GB or even bigger.
> > > > 
> > > > FWIW, I've started to hear people talk about needing this in the VFIO
> > > > context with VMs.
> > > > 
> > > > vfio/iommufd will reassemble the contiguous range from the 4k PFNs to
> > > > setup the IOMMU, but KVM is not able to do it so reliably.
> > > 
> > > Heh, KVM should very reliably do the exact opposite, i.e. KVM should never create
> > > a huge page unless the mapping is huge in the primary MMU.  And that's very much
> > > by design, as KVM has no knowledge of what actually resides at a given PFN, and
> > > thus can't determine whether or not its safe to create a huge page if KVM happens
> > > to realize the VM has access to a contiguous range of memory.
> > 
> > Oh? Someone told me recently x86 kvm had code to reassemble contiguous
> > ranges?
> 
> Nope.  KVM ARM does (see get_vma_page_shift()) but I strongly suspect that's only
> a win in very select use cases, and is overall a non-trivial loss.  

Ah that ARM behavior was probably what was being mentioned then! So
take my original remark as applying to this :)

> > I don't quite understand your safety argument, if the VMA has 1G of
> > contiguous physical memory described with 4K it is definitely safe for
> > KVM to reassemble that same memory and represent it as 1G.
>
> That would require taking mmap_lock to get the VMA, which would be a net negative,
> especially for workloads that are latency sensitive.

You can aggregate if the read and aggregating logic are protected by
mmu notifiers, I think. A invalidation would still have enough
information to clear the aggregate shadow entry. If you get a sequence
number collision then you'd throw away the aggregation.

But yes, I also think it would be slow to have aggregation logic in
KVM. Doing in the main mmu is much better.

Jason


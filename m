Return-Path: <kvm+bounces-35536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACE97A123FE
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 13:49:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 474BD3A7710
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 12:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4ECE22F84A;
	Wed, 15 Jan 2025 12:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SQzxf7Pn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290E62475D6
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 12:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736945378; cv=fail; b=LXs8y4EcDC2IqYbQq4XO1UJr1tqvPhLW2q8PCVTBOdImv0a71YpHeUseaQ0p61rozf+l//duGOvFrGtE34qI4Ki1HHR7G6Px7WpjE3VAVolEW3cv69aam41qUzzcAU9nqWDWNJFx3Ohm1cbVTPjGlGRZFDqkJV/bBjZ2WuoKHPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736945378; c=relaxed/simple;
	bh=OSqxR7veM2RL4kZf1p8Gm8T//7dcrCQdIfGJ2PHTqJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TeQX7VWFDRLCcYoZEoMUUOvvO5VMN9uy76fyueh60xs6Ib8HuZTr93CQ7lQcXa+NM38vJUhdu8Qc8ZHeJySydOp9GZEDFzwlYsFr2xhmCYkiVdRwmlm5m1dGADjGf6/hNQx92pe8Mau0z3VvRDEHMB51XrMBhkzm8ojU8NK5QI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SQzxf7Pn; arc=fail smtp.client-ip=40.107.244.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x+EN8iggyscGmtZzl2aoZsUl09RWurtOptyq3GTNRUslyLYJjK4/Mwj8MhgExEmxV096QcpiLFjK7N8eRspNhfL8R1Y3yIt2PhQWSbzr8XRdo8RdzRgWjUucvotgJDXOc6GItT7kRB0mKrr850BH+sPP3i9xO70fCP6e4A3du2jyr0LgcoaLhzgE7jvuzm9X5SygrgyqpIzzlNPsq+3vKhLSC+khNF/3TMLGFCT1LK9Nzydng0yXEjOYd54B07XUlMAICRuQVcYUc2VRYttfQBB3lglC8vck9sNny8XArLfW7hLywhrTIuVWfwDPmMpde/gaRmq7vHubHTpAM7LzAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imMe7bv2UxF/tFH0YWdb5B8IV87k4Nvd/obVoIJQDNk=;
 b=DabEPq0MISwrjPZ8sovQva89H0Oc33BkVFKhckvHq4tUlgvhPQLgbF0LD41fEyoT65KGkpgbpph6BktuAZDdhkJnNoq+HbHiNjOgXcaqnqW2ut5KQvM4Ob0xlcU4WLlNFw6ZP7mWMxrjWyUQKONvcjmOTbrmdVnclTbBcuR4UdsytzVO8nFoVoGNg7QBQ+5NJ5u/QGfxXfBwAWWvgU01NdbhCtYA1LF4FtVNjmdAsRFCoQUZbJEBhaeEdL4DLlkt+XrswIwu+J0antMyK4U+qPr2+bPGWNynI1iihz4OPG3ieGBcfkgfV856lfNNCKg2ApxUjpYr03vvblB59kbtgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imMe7bv2UxF/tFH0YWdb5B8IV87k4Nvd/obVoIJQDNk=;
 b=SQzxf7PnJrnc/gYGuqdvhGvC2v/03ZyajgopDR3KSpHFldlU6hRxdY8wWwIsQege+Rx9DDZkK2fALWKRLt2nvCg4PuXxYpQTfmemRgw1N8PfEp6DE5a8BKgbT0CLHp2A8e35i6E4zkJeDCQh2LPyHwq1+k28NDsE6+TZbssuIOmbQrwSH2S/y/Zr5iU+2WpX88B0mwH+3Ndx7Vbw2mpNY89nOYNKYQqbszvh3wTeTYGa6flGC4OUmOw88eD6RGwkxYJsYrkyS67vwfIcDKQcMa96XJ5eoo4vMrYyH2n07nWHhM7W6Un2YyZg7XGHBW+ivOYmpPmmSk9Xeha6jwPKTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH8PR12MB6867.namprd12.prod.outlook.com (2603:10b6:510:1ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 12:49:34 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 12:49:34 +0000
Date: Wed, 15 Jan 2025 08:49:33 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: David Hildenbrand <david@redhat.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 0/7] Enable shared device assignment
Message-ID: <20250115124933.GL5556@nvidia.com>
References: <8f953ffc-6408-4546-a439-d11354b26665@intel.com>
 <d4b57eb8-03f1-40f3-bc7a-23b24294e3d7@amd.com>
 <57a3869d-f3d1-4125-aaa5-e529fb659421@intel.com>
 <008bfbf2-3ea4-4e6c-ad0d-91655cdfc4e8@amd.com>
 <1361f0b4-ddf8-4a83-ba21-b68321d921da@intel.com>
 <c318c89b-967d-456e-ade1-3a8cacb21bd7@redhat.com>
 <20250110132021.GE5556@nvidia.com>
 <17db435a-8eca-4132-8481-34a6b0e986cb@redhat.com>
 <20250110141401.GG5556@nvidia.com>
 <9d925eaa-ba32-41f4-8845-448d26cef4c7@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d925eaa-ba32-41f4-8845-448d26cef4c7@amd.com>
X-ClientProxiedBy: MN2PR08CA0004.namprd08.prod.outlook.com
 (2603:10b6:208:239::9) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH8PR12MB6867:EE_
X-MS-Office365-Filtering-Correlation-Id: 760a6393-32eb-4cb5-5278-08dd35630fb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bloE152ZPHNk3xqguWPluKTRCUuhYv7CysCSpVYc1XV4JouejpOkFDcZTtgk?=
 =?us-ascii?Q?ffwA2YJsp/KohfdfwvncYsj+D81zRfVxxPgoSsYDrSC6DXMB6t/UwoNvsgwb?=
 =?us-ascii?Q?18+U9R+d3ViaqoXBE8d/OzzFPkRl+G/Mke87XptfLjdKexE1EjFJWjC9adN7?=
 =?us-ascii?Q?rhjqRbPq1KvkCZWQsyPqVl+/YbsXAMM8/Ov0hJEQnMf3B+zpYOG1nWL+qJ0o?=
 =?us-ascii?Q?LOk/2fbW9EtaWpGkK4PtHEr9R01wuE4gzHadK+KEVFqvyiFtZXaK73MOtaMo?=
 =?us-ascii?Q?etrUaeoKpVUPInWbz0EYnb45N5vnywkmX8yz7WIYsv/DfF0J2oOmS8Z9W53y?=
 =?us-ascii?Q?MFDIL26+HtzScaqLC4sIeLTW0dciRJkhmoIb5zsDmQQDxaJv0lD0NrzprT+M?=
 =?us-ascii?Q?/WSEsmuqtgkzuaBIwh7JhsE8IdTPOrYbi+7phk+XKduUwIAio+nFPvB0i6hf?=
 =?us-ascii?Q?QC6RAfJYrdJrvM+YZOy5LhvAnhRQzuwNd+D4OEw8acvZ9ZfpS95sl4G4cKnO?=
 =?us-ascii?Q?C22aCQ5zEhcY6cwPHPQoBHQRPZEEu+0WLlH6O/6Zj9sgCnyycu/sm9GnAoge?=
 =?us-ascii?Q?q6JO4GS61MF5jMzEpnGT7P9i0DnmPkbsSiiIvvphnL4KZRMj9o4n1xIfZPqc?=
 =?us-ascii?Q?ViHJ4O6IBV8BLUlqIOzjekTRDJQbWNFlKDnOcUEkUEQQJiM6j9qcaT19cD3i?=
 =?us-ascii?Q?+teyBtWcaWaJzSBkHTYJ3knoWpEwg4YBaol9ViWmXiqtT8jz70fvufA+7Cnm?=
 =?us-ascii?Q?gYdb7KMojX+ebcOKB6j5WN93rjnPDdS6Qp43vSaAG6/fhacxO9TYQRpAWTOe?=
 =?us-ascii?Q?87pPsVVF4mOSj44IzY95irKpX5j8tgpLiLJRS3Y2UIiNEEKDLbX/5V6mgh2/?=
 =?us-ascii?Q?irrAp/Z3MYBaHjjIajdBXwZJJS5hfbrrfTqZEHYd7pHIm7tM02M/UzaZs2zx?=
 =?us-ascii?Q?VJwZMN9tI4hFoaqUUf3PREfbUMdCo4QPwLD0M1RSsDxjBBEWvr8azGusJ1TP?=
 =?us-ascii?Q?GkIB/GBZgZc+W4B8ubj1XlmrSdku9cwfUudhv9PxnZfCp+90xjnki4CT2iXC?=
 =?us-ascii?Q?GjTL1pn2w7GnbSmOa5CRBR1AuH9EQs5BoHUbE3uVDLXizF7RJsSuW2STUnyk?=
 =?us-ascii?Q?UXcvQ14yJ4MTgIOHNyhSbZpfi9XpUEFgyytSoVsBtoPl2e0La/QrZ5idgX95?=
 =?us-ascii?Q?nyL9C8NK7LtMpEJnxmHi+rDNONduyMjPK0GZZy2/foS+3lGE9/FzfuQBN9GH?=
 =?us-ascii?Q?uIQCf3Nv8A+jLA+O6nJVGUKgkFZ5CG8DMOdS4wAChxiPL9lP5a9mwmtjMC0S?=
 =?us-ascii?Q?5tBhYjge2XP24Ek5a19YFQ3ccnIbtoSHHFit3zdPYTCnV45HUNME9ZIfX7+K?=
 =?us-ascii?Q?sL/Tqw2AUwOoNPY/xjE80u2Qzyzj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l0rT0Zo9O1ikDyGLx+iCFOgNlfjG/OcNPZm0copU7pLNgK0IBltsOHEizYi2?=
 =?us-ascii?Q?JeuZHKENGJ+qNI3+1PO9oiA7uThYKAkeCpMu/Cyu+DeWVTeu6f8ZhYlDpZ7e?=
 =?us-ascii?Q?3qVPinIBRFwe2ETJwAlaLFgNbYACo/cMEJt/t3duZ+GVPivDz5GLE+b9QaDz?=
 =?us-ascii?Q?VRMwkRm4lL7cBsAqLESq9dN80QFQGa2XWChcf0BGPxhSyOTMRl+PgR4KNsWx?=
 =?us-ascii?Q?nMQJ/rlyh39gdkqYiobeYS5rm4jLuh+jtXhE/F1Tte3dgmUsQGtKKzEKSQ/I?=
 =?us-ascii?Q?IN/1XfW+HdvWLl4q/z04i4ksbX7hnkyhPuMvnIPMFYZNlIkZzYnavKKqZyyI?=
 =?us-ascii?Q?Gn3WqyNUN73zFW/CKuOabpdvlA4MzzAz142r0sqsMbMP1PZcvoc2rr6Kp04S?=
 =?us-ascii?Q?xkmKX962r4Iqp+gxzvRWJjAr0ZOmZ940x92XxdnBnYU3KC6L2W2mjr79zUrb?=
 =?us-ascii?Q?zx0dYKr/KRJ9Xes8r/MjZucNyEwPwSIy/mpvthqorJc26XrwuZ3LslZUfn+i?=
 =?us-ascii?Q?sKJplcg1TsRZ+AMVGhC6gO5NVaBoDARNeQ8l5Qp1EgzhJYPi+mrNnNwT0Ss3?=
 =?us-ascii?Q?AXBLTq7ilsuoTtTc6j6kVgJxwdCdDAz/X8k5hBfedhkFvPr7NwvbDOh7dStV?=
 =?us-ascii?Q?tiIps15F9apWScMSQFB8BoIXq0twNw03xjIKn40Am7JH2AQSiYtXqbU8xN3q?=
 =?us-ascii?Q?M7f6CJuHO4WV/4U63Pas06pLuvXEdwQtf4YLXr7yISoSqx+guDpFWuiwOrAa?=
 =?us-ascii?Q?FsBz1aPdN48AQX5hkKt3GsKjMFzqOgvjh/+gK+RY1ot7Z/6xeuiidJsvLBGd?=
 =?us-ascii?Q?YjSTMLe6fKAn0ei5DHn4+AEgLeb2uuAdAex2tAL4KWUcGKcAQN8cjJvCeFZd?=
 =?us-ascii?Q?aV4J0KeFif8WRgmwqZSNAoL8z8ESKttNCS5laxOraprfRTMdgR2a8FYz5KqK?=
 =?us-ascii?Q?w+2uN8Ci8WZ1QaxuRJn+prweMWGXT6DZj7XOv6nKLX5G0JtQdmy3FOvXlW+L?=
 =?us-ascii?Q?350JzK6xhKGTzvzFTifuE4dhss/yEXaCgPqPBcwPdjBWgxgs+Z16aS6cGhSN?=
 =?us-ascii?Q?wswjyeTRLjO9NGIOuGX/uXD7sYtj+HS6LFYswsCB/c+kbtkvkoJJw0eyxcpi?=
 =?us-ascii?Q?z3PB+bpE14tAx8g1hsZfchqIjQf3x1cMt86qAmilk/qd1xVdJ+7Tk/55YppM?=
 =?us-ascii?Q?fu7Gv8Ox5jrPils5l+HtIFbJ1izekA9dnHEr7saKjmP8xVKDp36u5N2Lbs65?=
 =?us-ascii?Q?q1faketEzDiPzYw3ATZRdex1i9JVcPfO/JX7dqUh4/JYxQQjETsjE/CUzsMA?=
 =?us-ascii?Q?bkA5gXnCoPKqeXfZNMleGpaRmjxhhqtIkOT/4+F1bNAUmobIb0cqbupaCgPf?=
 =?us-ascii?Q?FIMNTxcjw/cPOY8HiBLgX/fUDiOi8CKD9TStWyAaGv4kg+/xvkl0qCjPB0gO?=
 =?us-ascii?Q?+HcQrhaxmqub/AlKbcVO0iadbCXz4nS2irHe1/wNlIA5Mr7Pw+5OzwcDOLyn?=
 =?us-ascii?Q?+St4Ra5WA8R1F6/+q9IDBovjgLOi/oYHG3wy3GVmyXfC8RLGVMmkYOX3a3Za?=
 =?us-ascii?Q?Ak7EXaG5AzyNo9r47bA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 760a6393-32eb-4cb5-5278-08dd35630fb4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 12:49:33.9725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KxR6aHrZeGeANIpFGv1OIwOWt/iiOQa91hv7If8Ws7WaM9Uu9DvYfJQmhUBKpuDl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6867

On Wed, Jan 15, 2025 at 02:39:55PM +1100, Alexey Kardashevskiy wrote:
> > The thread was talking about the built-in support in iommufd to split
> > mappings.
> 
> Just to clarify - I am talking about splitting only "iommufd areas", not
> large pages.

In generality it is the same thing as you cannot generally guarantee
that an area split doesn't also cross a large page.

> If all IOMMU PTEs are 4k and areas are bigger than 4K => the hw
> support is not needed to allow splitting. The comments above and below seem
> to confuse large pages with large areas (well, I am consufed, at least).

Yes, in that special case yes.

> > That built-in support is only accessible through legacy APIs
> > and should never be used in new qemu code. To use that built in
> > support in new code we need to build new APIs.
> 
> Why would not IOMMU_IOAS_MAP/UNMAP uAPI work? Thanks,

I don't want to overload those APIs, I prefer to see a new API that is
just about splitting areas. Splitting is a special operation that can
fail depending on driver support.

Jason


Return-Path: <kvm+bounces-38852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91DF8A3F4E7
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 14:06:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 387988614C0
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 13:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F28020DD63;
	Fri, 21 Feb 2025 13:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pqwMj9x8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98AA2066E3;
	Fri, 21 Feb 2025 13:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740143104; cv=fail; b=OwNDaRuRS0Nv9sgIO1ukAtG7tLQ0q05WGfE92Ah6OC5Kdokp87gb4oK9rFzN8H/6om/WRyRQkEj+iTb+TVxp5+0+7ixsC3OjvwAkpNWlKvx5s9M10eWhSlAID5EznhFFXXwnOfS4aJnTb+gxsSxgRwiFOIY6ntRQzGe7Y7mKur8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740143104; c=relaxed/simple;
	bh=Xem2Tyl5qTi2knvVfttBIc6fosG3p+O8s/cRTYDb13M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VRyUgsSBG+MaiD7tLXHUSect+FKdey6LJJiwBEyfN/V+9B78hBBXbXi4beQVGK3O4pK7O7Ruf1tP3a+vTN/uecAole5lP5+nIKiDnchzahHTFaD34vSaKCNTX32ycmwkEOcxn2yQ3F+nTbipQooJjDUik58uJ2Uc9s/NsumfiwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pqwMj9x8; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OHiXZPjmItkJ4gYtCfp8y3vaXs2ZU6DhLq5slPkymf6J0qjWKmMWB0gORV2R0+ffWJRGDZdN/YDJS6gNvmBkhSrvYiFHomKrLXXnYcPZB23XI3r2jUzE3u0j3I4VK8lFpyNIkrcyYXYyZD7FNmBJiz4av329IUWp0X12ZReSEBTc3k1V19wbCAM9u3FxN9GU3yb1/THnVPFgx4ehxjSduGaY9KFGNCohxQvSHYCE6OLnecbJ6MN73klOaqcfmcJ9LR+40NRcO7wz7gvYIejUyieA0S9cYdsF6lbYp+xeJS2fiuMQ2tr8WybALGGJ+EO+i/7x8W1nW6y6Kp4WsCogDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TukrNxXvXJLVgUPjFemlYH4oFVueYQy66OOTXabiue8=;
 b=p0Iokkj+wlFhKpwfeF6b1+fCk8CsVQxTuzQMlMG9y8xeqlcyUfkypExYdjFuDvQr1OovvT5b+uaccz8/iViGyd6pDPMNLW3x0EJo9QYhVwQKfnJ5lvHzKpQmz1k7WJ3Pneu3OFntF5yMyRMPAmigTkEFniG4KcjtHeuEYCXa1X2oSgv0teehXNqKv3etdPa5AeLIWmHW+3n3k9lh5zvGiKZlkshyQpE7RlUsk4lPv/ZIELcPWolkBS5a1UYMj5u9SaWuIZ50uyGkxZit6QtkqK158b1MkX1dj7R6XVymbtSzi8SAJ/hyvervSdfaZXjGHQ27dqOiJa2Tf7k4jWAi9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TukrNxXvXJLVgUPjFemlYH4oFVueYQy66OOTXabiue8=;
 b=pqwMj9x8dbUiqd3pSqI27BlIrxWqrEr/kZ3wTtS7+xtZfNl+CYAwCOyUaer/HQyDExz/BoL7ge3PdEBkgFxNb6b6layFAXqEtb2WYHCJWcBHnGtGfwPH4OWk1mD6QKRsEezeAJqPm1yFqZ0048FGQzi5mtlah3FBEP5ITKCHRW93HkcHNoiXcCv22uo5XqECKz8hYdowSCm1mVvahVu0vs1XFVKxs7ew6AEFVCNhLR4zUzGvYAhRTQV6LvwUDorfmW/I1dqZ7G7Ve/Cm3hm5A6s/NyDAxxc9N7WaVxmP2valMai0JXob3kg1yRlRjIP1FERBXrfuxt5t1o/+/Y5Log==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM6PR12MB4300.namprd12.prod.outlook.com (2603:10b6:5:21a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.17; Fri, 21 Feb
 2025 13:04:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.015; Fri, 21 Feb 2025
 13:04:59 +0000
Date: Fri, 21 Feb 2025 09:04:57 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>,
	"acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>,
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
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Message-ID: <20250221130457.GI50639@nvidia.com>
References: <bc9f4477-7976-4955-85dc-3e05ebe95ead@linux.intel.com>
 <20250214124150.GF3886819@nvidia.com>
 <58e7fbee-6688-4a49-8b7a-f0e81e6562db@linux.intel.com>
 <20250218130333.GA4099685@nvidia.com>
 <f7e30bd8-ae1f-42fe-a8a6-2b448a474044@linux.intel.com>
 <BN9PR11MB5276EAD07C3B32517D339DF28CC52@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7027fb3a-dfb4-40ae-ac9c-5ea1dcd57746@linux.intel.com>
 <BN9PR11MB52764E131435DF44370653CD8CC42@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c57977e2-d109-4a38-903e-8af6a7567a60@linux.intel.com>
 <BN9PR11MB527644D4478318D4DE0E027A8CC72@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527644D4478318D4DE0E027A8CC72@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BN9PR03CA0252.namprd03.prod.outlook.com
 (2603:10b6:408:ff::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM6PR12MB4300:EE_
X-MS-Office365-Filtering-Correlation-Id: a132f6e0-8434-40d2-9ef3-08dd52785879
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/5cMPmymFPm4cDx5pyA8hDiuouYZpQ1yWwT5Z4B4OjvzqY9/ar9t7+vsuR2b?=
 =?us-ascii?Q?Fb3+i7KhfwHoXwd2c8SAj0UDch1NmpuoQ0FrsGVYzY6LrkkjGVp5OlrZoHu7?=
 =?us-ascii?Q?eYkk8BjSqIJy/pKkw3Phzhqw3laXKOMi4vkpgOa6PuOE0MG/V4OL5xl8bliL?=
 =?us-ascii?Q?Ooy+rwnpXHfCZiqrjWPQvdBLVoBy2ENzEFc68arGsQVOyWIVYXdV5wg6PQ2G?=
 =?us-ascii?Q?WdPrfhJm0Hy44MGMas/QZPnoJG4IluafHtukAzVu7vsVa5u3+4ekXaS5vHay?=
 =?us-ascii?Q?jlEu+VG5kQFkOD7Y/ND3E01T2G2+xf2lTPfnjNG/6qfiP5nxn9fsWLkohw48?=
 =?us-ascii?Q?f+E2jwBf/AHqX9w4M+rcvVDt7nU65Pa0GFT/Q0IvavlF2CBqwgDHGisee/DJ?=
 =?us-ascii?Q?wagCzUpNxmBi4K3Ky2js1zuG59Ix7aT1nYEXcliqdeDxjs8i3QEe2TRBwMXA?=
 =?us-ascii?Q?q0ef50v0noyQSlIdIUjrwa0ssPhmBmVeUgaf9Mm5wyeSY4B813rCw4DEomlU?=
 =?us-ascii?Q?DBiTiQD8NuQ4iR5jrdoAsccEkZky1xKHoYrT/LWCO+2STbD724ySfuxGF8Ei?=
 =?us-ascii?Q?LZX9D1cxt6iy26T+0LYqYcmUgPDNME7ErwDEXnWnB25k2gnSWaBwWjEwCBO5?=
 =?us-ascii?Q?dcEJb/W2ArwE1ZyQ1r0VG0T/fhanGZlFTUGZcAEpXvE8KCQBA9rUunMNkU+E?=
 =?us-ascii?Q?LTW2S1Xh8/ceXK2BopLv16jcu+T2WyvHy54kL7T86Z5djkyNhfp2N6MbRJkp?=
 =?us-ascii?Q?6VNsA0rhVkgPAd1IoHKb3eDRN15U4tZsnBwGrKAh7WIXSwC7d+BNCAvxS5+Z?=
 =?us-ascii?Q?RrgNkSoTc82x0wga/MRglWrBgnIhEF1G1quCDdWZJAwHZD9gg8g/UDiBYaU3?=
 =?us-ascii?Q?dux8Pno3DKIo/XEXnZ6U9AxNmOwZNxkXpf7lrWW4i93T/3nsnslf0VtmkTn/?=
 =?us-ascii?Q?vAbtwZxV6PRSAyc/xF8yC1EYrotcDj0jDaMMc58SMjMne+d++B10xIVV0e29?=
 =?us-ascii?Q?SK6q103yvd/iAj9VAm1wPS+Cu6blZWhKAkYtqcimLp5w32Mj/r2JqVsrQ7Kf?=
 =?us-ascii?Q?Rd1Oot61mYOTsmoa9wI0RSHlfunorniolJ2F7s/mjDA/M62PQ8NtiLDn0tSE?=
 =?us-ascii?Q?tfQTPqIe9cdIwWkpX5B3Og1gsf5qIvVmW4POQHohSRyBFU/BbFDjkH3AcHx2?=
 =?us-ascii?Q?dZKdg2x4BbI8UXALPUoMywlA8Cth/ZAO/Sc0IAJBc2fyfQX2VEA3F5cvAf6b?=
 =?us-ascii?Q?UIw6SaUF77BPjqVIYVtFMpYhnSYDUFCsxz73Y13E65rLMQ9IQVM+K5ogM/WW?=
 =?us-ascii?Q?t5Z94ziuVSmG9oA+KlNHTmg4gj6QATn14F+SgzKMdMQsxsXWp3m8jcbhQFMv?=
 =?us-ascii?Q?YqJzo7OWllDHzZ4TAa8leDQEBfzx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?St7usA9WAQyjJ0TZtHmC9XG97uQ99nmDpJe3FsOWrcSBpYIyo7WegOxr0CAu?=
 =?us-ascii?Q?5g/QGJgd1hmy60mbtF/TcqppBLn0JUBRIxYdnFyEkZ1tVcvTT06ttcTsBRtH?=
 =?us-ascii?Q?PjleqcH8JueEqbrFDIg1NC/tNStidPJPQxe5aKXggmX0i7f755+OQZL7VeaT?=
 =?us-ascii?Q?BwbVYoPFyD09jAwYbhSkHy7474Up5R0iakOgN+6i4LrNAR0J24i93gexdQGH?=
 =?us-ascii?Q?sl8JSDs3w8daDVlGbCtNQW2WlUFD9BJo+N2gNCM5+SqpfwtO3LJ2zSVdJMIB?=
 =?us-ascii?Q?2S11ILmYVuohmBhBICB15BPOK8zB3Jj/vaFOswSqydgzXscmbfWukShZt9Hl?=
 =?us-ascii?Q?S9Yq3HszoeqbidIVmt2yrfy3bsDOoksbZM7gMgy/mrm4YGLxgqSSOtcpwKnY?=
 =?us-ascii?Q?SF4OQQROXc1Cn5U+h0zVg37xaZ3+MwrDgjFHLBmsx+80bD8JGF9i2stmFxIA?=
 =?us-ascii?Q?yR2v+ZUFpdLoolzMjSLDRKLQMtewPLIT/0/0zIneFRepkzfCoOSQ+V++msMi?=
 =?us-ascii?Q?FBJMhBbDzLLcdLMUj+zSVaOcvidfhpMfGESxnkX/pKYdDP/vLpUwOAhzNhJb?=
 =?us-ascii?Q?AVsDObYxjyH7cfpvXdOln9GnvlpgqS70ZwN9mNcx9H7UVBlMd+txRIv4hu49?=
 =?us-ascii?Q?pJV8mB7t8mwnz3Y7IdHYJ0XGNozZ89djN4X+wJTnXNn5oQasXI9EX123iYoa?=
 =?us-ascii?Q?yxtV8ak88sL7WFXdAWj0RAEYcDB75gvPB0vrJhiXqa5B/Hcck/iyIa1XtZVa?=
 =?us-ascii?Q?l5k7NmfL+OY5lo8HgQ8FxEU6saZ8XgJiNLoV26P5WX/8Bv68wy62tkxDh1PR?=
 =?us-ascii?Q?/prq02uCZ5hXdqvT7IweIGxfZJGrurK/32MjTPt7Jj7lWaagEo/q1vvhS0w8?=
 =?us-ascii?Q?aZu3keXRaig/q8eYN88nYHQ0mmR5wORtQ0qcRsu/8Z0gWepb3GdEs4apOBsT?=
 =?us-ascii?Q?bbGxxxg/K39U5QDVo8TQ6wDwnEpBKlUdZBTGjy/B4IwsTJ7RXP/TahHHtFIS?=
 =?us-ascii?Q?ouibUOepY2ial0XliFIX5ULEIeVuMETv4Z2o+fH/fno9JchMvO9yvORxJc1l?=
 =?us-ascii?Q?7IFbLDsTKfwHMaCRWiJKqnKn+81FBnpVsg33c0ixlO09e9+UYI7tf57Tr7zy?=
 =?us-ascii?Q?kd3focni3SjZI90DEdL5+fCaZ0MJv0R1+REF+jxKta0yVT7LEoaiS7jC7Nul?=
 =?us-ascii?Q?RIwQB9rgxaCZ+1soGb5TKegWmGufIrjN742VTw0IFb7X/2VwDr4OQDRdsw9q?=
 =?us-ascii?Q?j3JD9pnOmMGu45sv5Fl39H3d3tWSfFxb5IWGtIrhgjrVxmFFs5PcfD7IcuCb?=
 =?us-ascii?Q?EfOu+eQ+mKPiyd52pnitI0Cj1C/+bHB6vFpC7nvNyWgpjWmj+Q0mpTKFv+Rt?=
 =?us-ascii?Q?8PB74rTmrgN1CRhaDrkSpX5fsn96/x1yKQk2voKhvOtzOvoUkqBgsR6EhIzn?=
 =?us-ascii?Q?z26a6gbYmfAmn1NeEj6637Aqt8M7x2JylLXdEO7B2CA8ndPBX4GqOUrCHSy5?=
 =?us-ascii?Q?63BNnryR33sLSI8nZCWo7w1utUO6ShSsNuTtNjew607sTn+9Vvh+f/2BbaVu?=
 =?us-ascii?Q?2gs74IcUDSjD6NQ3P50=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a132f6e0-8434-40d2-9ef3-08dd52785879
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2025 13:04:59.3666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZV+zzbYNlyqrauxU2nPmI5Q/j1289C44CCbq2b8yDZ9+76xCutBttSqNokc3uB/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4300

On Fri, Feb 21, 2025 at 04:28:50AM +0000, Tian, Kevin wrote:
> > With PASID support, multiple domains can be attached to the device, and
> > each domain may have different ATS requirements.  Therefore, we cannot
> > simply determine the ATS status in the RID domain attach/detach paths. A
> > better solution is to use the reference count, as mentioned above.
> > 
> 
> Okay, that helps connect the dots and makes sense to me. Thanks!

I also have this general feeling that using ATS or not should be some
user policy (ie with sysfs or something) not just always automatic..

Right now on our devices there is a firmware config that hides the ATS
support from PCI config space and the general guidance is to only turn
it on in very specific situations.

Jason


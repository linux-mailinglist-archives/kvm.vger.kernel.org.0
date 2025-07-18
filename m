Return-Path: <kvm+bounces-52936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 924A6B0AC64
	for <lists+kvm@lfdr.de>; Sat, 19 Jul 2025 00:59:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2EC31C4031B
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 23:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A4DB2264A3;
	Fri, 18 Jul 2025 22:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cCx53CC3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20AD1799F;
	Fri, 18 Jul 2025 22:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752879585; cv=fail; b=aURTicmvxjJ3hoqIdIw6/799uziY3sxc39N73/Ih+FJ6blNc/Cz0LwmtnFCtP8eSUE8hKa1DcuT2hUyqWYSJ3FxBLfK4IKm6arEpJfEcL8kFisIkv30bCHYgbJON5gAaWmDmQKCu1REMSjE+LVdqRjtDVTND8GIcWPvUhoUqMsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752879585; c=relaxed/simple;
	bh=wa+wvVSS2IJzYBVeMjvJnvNxFy4+zh42zFmwxqcmtng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OV+xkb5lKepuLeoYzYjgbEHwxuhYc+Of+X8qP0APjHh0nUDn0nWcdniLrAyjSGHkS80gx4d5AgEoGtiJwWaJ5YdIYH96jZgbOFBuPRZsECo0EB2ZQzV5kH5Y1KrKGUSjBsNB34xPRfRcToxbQI95z0NcFwDckH2xGZfXBYUjsss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cCx53CC3; arc=fail smtp.client-ip=40.107.93.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BZUGlQ9BWTThrWBbSG1iEJyH1KTmAZJ0JpxS5EcShvWFfi8ULBUBJGE2ta5Wu3rseuRrED2jMARheSIxwVhHGPe2451dlhiqYQ3WM5CWjpHHocV9lCNGXy0w1lYfCvx4tvcVGqR5Gy7IerosAeZczfzOLA85Q908NmbKi7ul2tJFLTYVLU3+0YYmCom5MAR8VufazquTnz/Whmv2/FXGVxPvqKPYonGefG40foDbLODMUjt+nNJ0JtbhRInKAM0h2x1UuX9QL544KzbtFL53Pwkhv9dAb7uWxOZ4SyVWqEaMG6e9jeFRCoBTjuj7vjuYbXK/rii/boPjvLER3ZWc1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m7cB03nniq5FZ7piVeWtfFT3pry+TCASzXHy+asqbEw=;
 b=ndBKPsp9p3d5Je8WptELdOq5tA79yXDR7oZIbxLGxwBrI2LyXALYcVtK08a0cpJPIKuPJZtL0/cS5xoVt0Y0amDfbray0FSbHgj7g1zVAhIuLJGf60Z6vNFfqIRk4XEq4gU1h2nokazBBzT2qijO937O0n/xt95hyunSDc/F9dxQ8gvHuWHW2UMhZALWEfNLAITOjR9GtYqbld71+InRrqoZNGIkQRkJ7G5/8CzWanzoHdUs0LP8uZziZe91GrbyJsbXb0Z2JTNKHAK7nDAC+6E9J/et61fry58IicxKljZ2vAI2fNxRnlMsP8BoFdxxDs5y2x3jwNbEdwtbKZhbAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7cB03nniq5FZ7piVeWtfFT3pry+TCASzXHy+asqbEw=;
 b=cCx53CC3GPwFwSfBgMkcruIEsgAmY0WfzFyYqzD48fCQ1HGoX2KB7eqVhUbROpARKgTCe4dz7sOoTB1uEPVKv1oAD1O/OiBOAlx7xiokeI3SFRc4T6AcbLWdx55ALfBA5ZhwXX0H2TL14KinxZRlgzWPM3esOminRYr7ifLdzqkFzG94Uz6bRaKw4TQGQP63AaSQzhP0aw8MvG7CK7TL7uHawErmfGYIh0jTS02gG0/2mCD3K4IMa4VKZyxz2HNVi6WxDOkq2suXGEIWdvDTaC/yMW0jH+7JUv6WNvVLcw4iE/c+hKW1G35YU/fzwelfpD78UUltrFhxr0zQ7R9QCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CYYPR12MB8890.namprd12.prod.outlook.com (2603:10b6:930:c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Fri, 18 Jul
 2025 22:59:41 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Fri, 18 Jul 2025
 22:59:41 +0000
Date: Fri, 18 Jul 2025 19:59:39 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
Message-ID: <20250718225939.GL2250220@nvidia.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <20250718152934.0cdb768f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250718152934.0cdb768f.alex.williamson@redhat.com>
X-ClientProxiedBy: IA4P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:558::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CYYPR12MB8890:EE_
X-MS-Office365-Filtering-Correlation-Id: e6af5161-4af3-4594-4182-08ddc64ec73e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tpl6eLwtM0FgZ/GF6NVkjBujz5VeiZaud8K84gJyJ5gsjPTESNw+pi54hvlf?=
 =?us-ascii?Q?acHY1RU1aBXh0WOye8iJDRlOqfHNZmbBzWpyKdZ7VXkAz88Ad8r0tswhV4BP?=
 =?us-ascii?Q?jWoS9Pu+vJKunQPNE7AM/WvqulDLYVCf/L4mvLmYY36/JLsLBD+7Or/GsXBL?=
 =?us-ascii?Q?axyII9LNvuZJDKhDZ8Zkdp/8QCeNri5feRnqzH07sadXsQHbuo5WT3SqERwt?=
 =?us-ascii?Q?2gHbbmFADxm42YehWLUo9poqp7BfCgmYuGqhxXepDrQ7V/RMt/T0dbDu5bTg?=
 =?us-ascii?Q?rsj5UyK25mAMvkmDAGUkczQ0HRihMhOedJGvrIcUKOEFgWKD9dt55hDooPbC?=
 =?us-ascii?Q?ds0UDqIsQ/g5K8S5tYLXhVQ60tvjamb3oAqudOiN1GGN3LBOWd541wQkLYoq?=
 =?us-ascii?Q?CNqRS9/V3v9sK0DFzEBVEQMfA2+RwwIDKGT/SNLy40gsI366hatBkPmJCgfO?=
 =?us-ascii?Q?Lbau97cHwOfsHzhhYf/YQ3fxiwcDpCOzPCoRbImXIY2z2BiWuhnJFRTzRmm7?=
 =?us-ascii?Q?Q01i1kcP9He8B+ypIbqJeM3mYyKYdjNJ+UyBKV1Q1qLpIT8EKWfNvBfQqJuo?=
 =?us-ascii?Q?VkOFoGoqlJ0HrpB+DSPHXta2hq4mGCE/kXz3Gaz2LIA55pQnYQJfpFK2grw9?=
 =?us-ascii?Q?8aBJI2FticPi++8jA0biddKr3wtXk/ZZJ9MEIgQgQ4OtDm2L/ctJ0q1v4mZD?=
 =?us-ascii?Q?AUGJrpsMdtHLZI4VKyuiybOYdicgeNiMEdGi92sUXO/80DJ3tY87SOjtR1Pp?=
 =?us-ascii?Q?E3Yd8b5v9vIma2R5Gc6vjtDQG8Ez0e4MEejuxwcScVrO1QooqjTw6mojzbbi?=
 =?us-ascii?Q?Id/fxpsy5gtVfnTCe1ICwny7x2bgRX+wP57Bb6Mwho3lRb9IzTEmKj6HZslf?=
 =?us-ascii?Q?RyrTW8smvZWVvhFIyzLQzocGUtYTOqF/1k5st5V9sa+zqj8b0fIwF7H3TT4Y?=
 =?us-ascii?Q?z8XgqbYj7kTbHBGBkUcDfD8IJOKFt4Qdm1cZyTlZKqTuEyIxwvhHGcx2AGAv?=
 =?us-ascii?Q?MYQ5hwLItSCTz35QjsrkwwaDT3jDSO5Kovy6Be+BoOq+h4WGEGGCzzFcpaQv?=
 =?us-ascii?Q?xDD28ARZN05AWLV13Vx9n7HbiWjm1vQECB64rdukXyMgAG/v9e0RQmAnB0F1?=
 =?us-ascii?Q?kCAu1SMNSxrXDrTg+tp8vk95t+U3xClkxDG9L5BDRmRad7EjYZ5aI/csOlph?=
 =?us-ascii?Q?Z3f1SBfKdCchtmRBHAp+MVJSbp25tfKykM7i2osKgR9o8T3O0ogeqMHS+Uzp?=
 =?us-ascii?Q?nPBVw9bgU5//04udDGr8+4qwZ3lO0AJWUI8puAeBuglU+g4NrRERTrNWrl7L?=
 =?us-ascii?Q?0z1sTkn4CAzEajTBDXvdDKoe/GXUx3nutcD/ZahtWUyJzAgxuHQ1rpReelxd?=
 =?us-ascii?Q?6iNX7YFjt2okFJxajBL+z/JDNRNyLIexkjQU22J5hC9tRSooqmH05oiIQUpy?=
 =?us-ascii?Q?fhbz1HgtNTo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A5yoVQ+iRQCmYkRGxtIklL4i0iXKS4XloH6MtSTiXboSbQa2tv+SCW0PCoIP?=
 =?us-ascii?Q?92+9eNdJDzNNzmHGLtWrg7qXEiTadrofn0wl4FILhd6tKRTu2gsCMRVp/j52?=
 =?us-ascii?Q?i+lTG+MIWKRRx9LAR5NOSaFBcWfR8uuU5xNeZ4byYxtLeLGwI3i4FFrDARCz?=
 =?us-ascii?Q?IsFgS1jcGH8RtIGVNmmFbboSMZWfQPnLjuxMFL+wpDMdJH0YeyvJwczvm3p4?=
 =?us-ascii?Q?hIPkwQncIrgF+I24eN/AL2kyZJrFbXQ3SIbn9mH/aiQzJibLvtV7+rGOsC0B?=
 =?us-ascii?Q?aMKsX2LOHSTgVN+gimPM4hfj6zFDXvOUjDCX0G9qQyYJ6069xrpQUpJZkq0v?=
 =?us-ascii?Q?Zl1nAeTko0s+hm/OAuSBFtVS91VrLIVsBi4CO7waSH85uyc6FkxldAoZ0jAi?=
 =?us-ascii?Q?Iw+5r0EcGEApWe/R7VVltjJELWgP7wQO1hi/UNm4HrA/Pykj0DVWNbJGbu6u?=
 =?us-ascii?Q?Z+kMXR4ezzVt/Idw9Ys33PjyNxH3ri6E/CZ33Fu/zoip5RZfApw368aGn4J/?=
 =?us-ascii?Q?6V/KngJF042b6rxZ+mDToKsSzNBuuB7yXyxdREdrMKdheZIs8nmuDtHpWJZk?=
 =?us-ascii?Q?T5bo8LKNUbwrOvWKwSk5/8Onb12L2CdpeTLXSJz6LUlYG8pW8f7qPcVrLjQk?=
 =?us-ascii?Q?g6N/tVp72QSI4VZj8/aFoI/dM6U/uMF0uq5lZC8tUlDUfZMni6igSm/s2hno?=
 =?us-ascii?Q?823IFFW9BEJzmg71T7BoIzQwyFDanigAzKw/xgFr/kcLutaaL/B6+fhqvm1W?=
 =?us-ascii?Q?03U4uSp+El5FsMd8gdjJEtiV6Wxl4Ql90+sjfZp5XF4boMiWHvMjqxw8IN6u?=
 =?us-ascii?Q?NskQ3Wm7tqwxz5JnqpYiJIdFZ9AmLgIKQHD0lWEvdNc6a/Bppv8S8sIyacug?=
 =?us-ascii?Q?ShXVUgvWiE16sB9vcCFzEMbV2c/creEQiDPQ9s5nKvqJQa0dzB/mQJltXki5?=
 =?us-ascii?Q?GFpefDLwEVCY0iQH+HThXlsBo4ldmkhasRWGjE3FKw3JYKil5U5EKfkHOgr0?=
 =?us-ascii?Q?AW/R9rj5NglKGdBcLR3WJeHoFBY3cPZEbC71yWpe9X8nhrkbu/gY/rBNl/nn?=
 =?us-ascii?Q?+SfmJsdSOr7UP1s7wr0Xo8z+3rFtD7jqU4HJdovtZa0VJ9BhsUEt7aNJtt2I?=
 =?us-ascii?Q?lQOu5WFG98UtcT6JusKM0s9tRHhx3KvFYoTFfdQuH0I5aUeYWxongn8JL6FK?=
 =?us-ascii?Q?qvwWDafUG4IM+1XMlwm2c0o7im8unICr3IJ6kE3IYxE1vlr2XQzt98M/Dtc+?=
 =?us-ascii?Q?JLWgwG/3uwpYGEDNC2fhwhs7KVYsRVd5bobdpi3AsYNVbsTB+3wwmYvsuPxB?=
 =?us-ascii?Q?uyYWL5Gix2kaYLTkNZha//aga8sc59RFYgFUW85ljKQNx03PHjyKmDSdXtU8?=
 =?us-ascii?Q?ydEaG8WAFrd3qI5mDf5iY1YIkblEUxg9+RxUUv9LDi2oG109z4UDbn0OR71k?=
 =?us-ascii?Q?OJt1zOiX77qizb9Pe30L52hHOOh6ejfzcS4X7ZxejqodkXJn58hwAvqLnHrs?=
 =?us-ascii?Q?MECLrKx3oQlJB+3lmLiJhoD+SX8/dcaepouz0c6TGXT+53sqsKLMOGnmuDSp?=
 =?us-ascii?Q?CyTzHnCI7lNoy/Vn0AVl9nHbAS8xTfE5NQHximuP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6af5161-4af3-4594-4182-08ddc64ec73e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 22:59:41.0810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJpl1hnL3XKrzkdSN5e8mFxFyuDNaTKUhi1tLXvXS2KQXvrgtBb5RZnkDCAViXxx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8890

On Fri, Jul 18, 2025 at 03:29:34PM -0600, Alex Williamson wrote:

> I can't say that the proposed code here is doing the wrong thing by
> propagating the lack of isolation, but it's gratuitous when there is no
> DMA initiator on the non-isolated branch and it causes a significant
> usage problem for vfio.

I think the answer is the quote Don found, if the MFD function has no
ACS cap then we assume it cannot do P2P:

 e.g., Section 6.12.1.2 ACS Functions in SR-IOV, SIOV, and Multi-Function Devices
   ...
   ACS P2P Request Redirect: **must** be implemented by Functions that
   support peer-to-peer traffic with other Functions.

So I propose we lean into that. It should resolve everything you noted
here.

Instead the logic will be if any function with ACS has non-isolated
ACS then the whole MFD is in a group. This is alot closer to what it
does today, with the addition that explicit ACS non-isolation groups
correctly.

Jason


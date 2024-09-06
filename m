Return-Path: <kvm+bounces-26022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC32596FB38
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 20:28:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79890285D26
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 18:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B7F1B85D8;
	Fri,  6 Sep 2024 18:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MOyAjXRp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B078F3C488;
	Fri,  6 Sep 2024 18:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725647317; cv=fail; b=X836SxAteYAnCwgN2dhUkx4nfFCDzTIlVIqSdpue14Cb2N4/t9pGlt0lHWCI+fVO6GlQovFmLZ3w9zcS85vj2YoC/WF0ec5teN2hUIMOKzVerTMAnzz/ewikWymHoCiE/UVaf5ucLT5vBXyYP1okAHmzLi6YOiiq9GAk31nKGKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725647317; c=relaxed/simple;
	bh=qIHhbqHHpuyJGF68flrxD0oOWZl1oK0d3VV7oGaZbwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qI9lTPt7AtHPFM+HWsI3KovFsqo5k2kvaPzWWcYzg+KUm2KCJsYl4py/Nf703pu0CfbmA50HO7KeGkAMW3BOX5S87Cs6njtQC955kDjOvvdv8vv3+WTWaYjkAtJIkBjUAcS69ht5h1soXTyp/QoErSCwtWZg9YgEL7deHkKchKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MOyAjXRp; arc=fail smtp.client-ip=40.107.244.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CP1gt1vuXQ21PcmLFDJO8KFRN4scORLZd8SroyWmcmQB0yQZP3M/RmE5Itcugqk6qbAGop5c+VEMs/Q3AuYP4JkHS5CHEwf7YS6X1jued5DalmSifvNOJrlwXvpMu09R4v74ohnxte4y66BVOJsWQeIH94yHfyLNp0X0RjzHCw71TLaiad3VbiHHQ2nzM/xtuhjQ3qkZHMcYNeWs1mwF0fw8tn91L4J8wMilFji9ovXoU4d5shPlVKdUyv3HSnePg0H8GvRBgQcpebzvpl/vkcuwJbajbHI/s3Zmizsv/nYd8dr7r5+6D3f9SFR+e4Dmfv4CMxJi+CYIrgdWA07JUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIHhbqHHpuyJGF68flrxD0oOWZl1oK0d3VV7oGaZbwA=;
 b=bO5tZma+YYu0KaiVf2+Dk3nsDDhMdCO+sEXR11HliCYFcBfl1fbO5sCnBv46LyXEBRKOKAsZS4tKV2SmU3HfS1NXX/AV4OAkip+ZBOn9BnVKNlrX6rfu5AeytFi/lajsR6dnFk7O1scOMqdVt7k87M9KnXfd4F029wXiq86Aujf8E1Nr54z4w4qvzPypXKKWx3Rlx7anIDxkjX7DaHO+ItxxZT7vItreifJNouckHX/N3tPuRW/AjylwbP58MUqdv1LblL1xoAdWG0hPgGJSNIXTYLNCAl0pWm4Z+JDxeCmPFGlrTbj/zjqH4pfcCbHrFwYxnA+Zzdg8vrYS3IHYqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qIHhbqHHpuyJGF68flrxD0oOWZl1oK0d3VV7oGaZbwA=;
 b=MOyAjXRpSO8nlIJ+WrYEqDEbj1k4lDw7FWwrpXEiYBpfXFbycsV7aTOCyefyQT1RtsIsaHpy6vrWWiNrOehol78Jeh8ZyeAr2MZiWgFnMMw1mF8+z9Ko4pBnNqV6E1NcvK3BPDFfn4CzPkGSD6H6zpkY/gUwrs2xECfKIlR4V4cQ5Vt9OmEs1QIcgSQRx6boFszM17vqvjr85srBgq8b1nFRm7o52Beu29ilhXgXW1QngxoqBpybNbert7OWJdJnUDMW2jldKTPEeWYuAWvBcb2PuVoI0Pe8yHhc4P1ahSJUToDXFYv0CTaFCf6Lydul0Oc/KnEes/FvyvzKetGC9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MW4PR12MB6876.namprd12.prod.outlook.com (2603:10b6:303:208::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Fri, 6 Sep
 2024 18:28:32 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 18:28:32 +0000
Date: Fri, 6 Sep 2024 15:28:31 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <20240906182831.GN1358970@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHuoDWbe54H1nhZ@google.com>
 <20240830170426.GV3773488@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830170426.GV3773488@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0155.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::10) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MW4PR12MB6876:EE_
X-MS-Office365-Filtering-Correlation-Id: 02307565-575a-42bd-b64b-08dccea1b62c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IfhRxqW0e2JTxJSB1FwESAMm8DsqmlefEa1wDWG7OrDVvdQJrglQEambtJgk?=
 =?us-ascii?Q?xNin6VaGakbvlc1zek7K/ddnfDRSXQY4cdZSjp3QQ7WFCf3SZOtqR2GfxGHr?=
 =?us-ascii?Q?fRE5gXGxzZH1qYPNJmcZjB+fJoLZTDlobirWHbdrrPClN5asdYJ/ejbi5jkh?=
 =?us-ascii?Q?WAhUP5nFJHoDlXV4ftQUM2+2A2PGIRXBvJBvmNLXZIreKtMwUH8Aioiwb87c?=
 =?us-ascii?Q?ugK0uY9k9zgCi4KWhX0HPKv+SnHdZeB85eZsL//zzTjO9AKdV0Mb4brdQhME?=
 =?us-ascii?Q?pRCwqiCjFDlhvDiGqe8iEhWLjx2N+A9AnvqzYZh4VS979VSjM/53epnhGg61?=
 =?us-ascii?Q?zpn/1GXzlgpYBcT6ribxTUQVWh/z3LpY7gWPEZig37kwyk+xZL02/ZUVueoW?=
 =?us-ascii?Q?r0VPF/UVnBZCDEdAq1mk5N9DHE5JdlrXpProm0zFbBUfjy3lnUX8vXLi9M/S?=
 =?us-ascii?Q?edslvkiYwPq/KQA2mtdAuZf5EqTRY11JQ1+6MMxXmUoay5r2z0c+LKWfDyKm?=
 =?us-ascii?Q?RSWf+MIWdgkRC7qQmjg+e0A5nqwheNEeLnuW4/qkQ/ukb+TpaJgLyzThmTc0?=
 =?us-ascii?Q?gOTgB7Q4nHxChailjSDX1n8wxgWEm/aWKYX5pLCtCyXuUs7twuyffmXj7JVf?=
 =?us-ascii?Q?Y0f1Sv43bsNojkGzArgWVpYpKP1E2mZ3NyFi2nvULcJhbiO3SokzGLMHR+vQ?=
 =?us-ascii?Q?Ax5W4SyUpgs+HhdODQUp6/XN8CvVG73goxwMr/OnTbpRDN+XOnwz2OPWgft5?=
 =?us-ascii?Q?ncm0j6stnofoo+s/n6aquc7Nf5KUtzImg/zeDL3XfmmgNzX4HEO1T2gjXKTQ?=
 =?us-ascii?Q?UKRxNVfrA8TZL39nFOHeDr0EwFGoj+8Ysi+PXsNB2ZXOYM/DUWQkpLTVHRox?=
 =?us-ascii?Q?QRhv6docup7MAekLo7JfWAji1zD+xELS0w5VuQYG8XRT1W9CLsz44bK5KYgp?=
 =?us-ascii?Q?1nUR58UizzXsOuBgwsnyTgwZxwrVDuRb8bs1Qu2aT9uz5UuNrrowrvMfDvbW?=
 =?us-ascii?Q?0DGC37QODqEaeRcMSsO54VAqoBsgNFlWI4fb6McWOmx9SMgp/ROiHwQsTQGh?=
 =?us-ascii?Q?IUgpQjmdloU6P/wkbAewLEg5dX3E/m40YawVBbOjJGPmBZ1M28LxT6B3vNR8?=
 =?us-ascii?Q?F8xQJNz/4o9dHNpB7x1472ZfqdYpnuuzCC580Yp3FfT22b/ioKYuQ4gXyxSe?=
 =?us-ascii?Q?vo0UwthhofF5kcKFWgAsA4sBwvbPdv6EqjWVbLSlwd3KDYQXNQ7/Bt+qSked?=
 =?us-ascii?Q?VbMmRp9PF8NYyXLQYAxPI7HcyRjEo6Vp0uunmtMomwaDEezwB+Bc4jSjHnRx?=
 =?us-ascii?Q?/JmSsUz5hdVnXs1UStZlYz/fFu7Atf/+EgTNgWtw0eFelw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BMoO/s9+UwOvsEyUwZQ/j5qqu1c7bKlrBQbl7aQlw4sV4nu5J7Kyiw4ghCt+?=
 =?us-ascii?Q?8o6Ww3CoZsx60EIoN1HQxHI74NkbUnJU7ITxYz3pdwXbQ8eQ+7GSkrK0k7lT?=
 =?us-ascii?Q?I7XLa3Vk7ePn2B9NrzI/7shlPNrG/BtxVoAk7wlywv311KWrHvWIRgMq+Rs0?=
 =?us-ascii?Q?ZP2V7vv0HNZrJDyfFwRGdqCnJwLUzj9vwVqfxKmHV+blA9O4TH3uMQ9Jk4d1?=
 =?us-ascii?Q?dScls497tjL11RdvfNQENVkK4S/JbGfKIL+1AwELLWx0Rje1gNoi07eyVlvz?=
 =?us-ascii?Q?dWGIVZgZcjcmeXiwFkaxHp71XmrLT9nOJL2IAViX4Rq+hsO0RH3Ujy2+zLQo?=
 =?us-ascii?Q?zPiYaJbgJWOE92qj8l/gwIuLSUl5l+6Xa2ogebdndJk7LAz2Gy5BH4MsTqU9?=
 =?us-ascii?Q?jZEhrs5+LCwVrYNIEnnUqVOwpm0bv/ur+S5Rn5pqn3aUdPXqjHVzQYDBxdCu?=
 =?us-ascii?Q?wwWoOwkgkPzLBloteUCgONeTcMzuXI5zuJcsB1eBSBvMIPHTS4nAxb91rSP4?=
 =?us-ascii?Q?lTbhGy73vOAKSyFj6MxPgoyz2nRpa5cn0koX5FSxXb2/is2AFq2DVaiF7zkk?=
 =?us-ascii?Q?G7Nc5jbU82xCPzzH+4oknpanfcqGdcrtLiS+cXVnuQbXHpEYFyQFvokDyyPR?=
 =?us-ascii?Q?zeiaydCNRsEH9AI3xPLgKpdluYD2JpUXUJIeBGN9Vr0KxIaz8G6gwYbcdj9M?=
 =?us-ascii?Q?RJweonyZCBTpTIQlMlGDnUVk6CIOc2LvMbXQVThatkpnvL74jLhI43G5RA9a?=
 =?us-ascii?Q?LAwZhlS0e1ch/fxdhgEbG1xVHcrBDJGeu6aUr8ZLT52S6poNxLRKi8FOITN1?=
 =?us-ascii?Q?PFrBYtnM9NyCFlTzsIDNK+frcC6PBt1ArJw3Uk8mO9Qvl5aU6ckUhHS6nqIS?=
 =?us-ascii?Q?IN+ywa014QS47XWnPh9qn24+SbuU1dD3oomTLmf9Kl3QPvfuV7GGKfW2BwQm?=
 =?us-ascii?Q?83kxPvfZW3+vp7mtTPLH6PH+/JWd2DNSCmBM+8Gt1wak9F/47ypjyNC/2LUI?=
 =?us-ascii?Q?lQVXMq1BT9w/IAd4s9RoXhw+pT16aeH+6Gcp/b6YvxXldO1wOxmLk2HKX0nR?=
 =?us-ascii?Q?8sUGWQIE4/JAVY7yiSt0pzZXflKdAOh6cyb9OuoKczrLtTNe/l0V4bRRA26M?=
 =?us-ascii?Q?6343uTQMw9dEFSlThuq93fzdGPp9m2Oeu81JpA3GD/P+A4ooxKe/GHLROVfA?=
 =?us-ascii?Q?v3ChtIqPC6F11mhDzFS2fyKfw9TjrMt0swCH3P87QoPQ/ngDAu5v5ns/QKBA?=
 =?us-ascii?Q?QxnguVKt+YhwVrxo/tKAFzh6adWX/fGwKfSbDq1E8YawU346VaFLULclqvDO?=
 =?us-ascii?Q?AqVlExp/LAkqfXMnymUvTkZmFnOg8LhKJLrHfd4ZqgWYxQLQ8VrmK/MbciwR?=
 =?us-ascii?Q?Iv/Xjk1XWqyfc6daQkxrpo+6Fuip8Lc+4u8wzZ4LwcDNAFed+OjUL8RGFn2x?=
 =?us-ascii?Q?l/pV8t97hX3cfrTn7GkASr07hxaFSxav4p62U8UikrOmTwtTU8ohjeogzl1B?=
 =?us-ascii?Q?UE0vivFgiv7zt7GeOZWyflMrUI7rWBl+FuCoPO9gAboYWVl+G2DGfwx+2K+x?=
 =?us-ascii?Q?rNgR3bLZxDIw+DvDwXaPpNAkVvdAu5oGfeptSgNX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02307565-575a-42bd-b64b-08dccea1b62c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 18:28:32.3639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9P5/V0jJmVu9vp+FEwnT+TkyVZCoFQXoqatDK1WPRNT48bDQ4sfQBl1cnZZuEWfF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6876

On Fri, Aug 30, 2024 at 02:04:26PM -0300, Jason Gunthorpe wrote:

> Really, this series and that series must be together. We have a patch
> planning issue to sort out here as well, all 27 should go together
> into the same merge window.

I'm thinking strongly about moving the nesting code into
arm-smmuv3-nesting.c and wrapping it all in a kconfig. Similar to
SVA. Now that we see the viommu related code and more it will be a few
hundred lines there.

We'd leave the kconfig off until all of the parts are merged. There
are enough dependent series here that this seems to be the best
compromise.. Embedded cases can turn it off so it is longterm useful.

WDYT?

Jason


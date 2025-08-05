Return-Path: <kvm+bounces-54024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BD40B1B6CB
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 16:43:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F6C6188EB92
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9ED527932F;
	Tue,  5 Aug 2025 14:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L/VMV/EQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B1527877F;
	Tue,  5 Aug 2025 14:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754404991; cv=fail; b=omDcfoXcwwoTndYjDScEg5khB/c33wbcHOf6ioOw93dWkJtUMiq3lg7uongYCZweu+BmN+zxWAuqNmahMMsAt1FMJtyGoRE51xH87WFRa03YGRFWBZxVzbxT8xRobAYMF2Jy8ch8/8og5Js0zl9UOfPNNTNwf2IBWeHBQagInVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754404991; c=relaxed/simple;
	bh=nDr+CZmP1uAigeS0dPouof627wwajN+4Bazu9QKKh6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=exeV4VpK1FOwpVdLVDNoB5CTj88r2OibjvLbgb3LjxrwD4fnuOXObvMCGURndS769tftmfHvYucdY6iPxthlVQTmEQucRZ/cThWTEF2tOcjRWLtlFX/yzwRzE8yOmhbtJiv2aPiwvkszIiiLL8crJUc58E/A6SFJm2B/u9kVHRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=L/VMV/EQ; arc=fail smtp.client-ip=40.107.94.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sLXQHq8KY1FqBs6tzJv/8AIgfx1ttg/WWX5tpovH5OSIbJAfTMGYjavkadr3XDAOflL7yTsMgNN1NoWOMB47HYXWZozizbPETn0tU/P9YK35itq9LQX+w1SZiwYskl6uCcXZ6ok60FHZBauzTIoB6P6zGxX2jUstg8Z7nM/vLDj4x8fB3aCdkOoMMhDuaXRut3kVQI1uw49k5EXXpFEfs/R5tGjNezjrydLpJKjHizdeUZiaApvzx2A+xBHDBQyYqKJaGwrKqEQII3Wpv+SbYsNbrNFCK3qkbAj+arWrD2VTD+XjTyazVmCPIiR4IS/rTsPZO0kd44H9XTsPcD++MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HvN+85QxWFMuT+rr50ET0blaF9HOia8Lrf21nGMW10U=;
 b=Zzt3xs+5aGtf1pmA/fp6TeMKqu5E1UTJduGeJiF8CIT8yTRfeghw+9afELUEOKHClukeTQe6992jp4hU3pJCJmVZ3T+go3u3GSESuYaIPIAVkj5AVX6L4q6GPyjpq9mgzZB8AJX7sVx47kJvlFBS+PiLDwkEBs0NPcZAcmbPWW6P5E5VkbaslZaYZFdQIUg7AlzEbotf3fzXEkeCsoxvJl8BzUDQw3f6ZlexkzovfpnfLPBHgjuUj/fK4ncWCDMTqo2STLud05oxHVTQ3W54He0tozbTyz0gsrLoncvArPdgj1aOlaR0f0MWeXqqaJY4lLXusO6NNgGlwdpR3o6zNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvN+85QxWFMuT+rr50ET0blaF9HOia8Lrf21nGMW10U=;
 b=L/VMV/EQFWypxZnO7kFT03JgREJ4bVrOh/serCb98K1n0va0LMLKsVqw1mVFgDRBEB4GSmRKO1kD+xmZXEgSQksDFL/wu5CAmOcWQ67YwLbiPM7JLoOZyp3VXOvCOAQO8WMVVF5KmJbtB/95GAHem2iPbazy5iv/7UMTkvrrw6QwMtrHt8/LH5nYOIMJU+AMOklCXjuO4c8wnclkVjOHreHDtLlbdBkD4RYjEQUHQ3CXeQSI5q/P1V+zh8cTT0Bif4h9fTZGMY2ePfGWae3X2rBI+TD29IGBH1gU7MLwNKvLI/n6s2Thq3HqeTnAzu7qlC89MphZH59/E4HvUmXoxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA3PR12MB9226.namprd12.prod.outlook.com (2603:10b6:806:396::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Tue, 5 Aug
 2025 14:43:02 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 14:43:02 +0000
Date: Tue, 5 Aug 2025 11:43:01 -0300
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
Message-ID: <20250805144301.GO184255@nvidia.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <a692448d-48b8-4af3-bf88-2cc913a145ca@gmail.com>
 <20250802151816.GC184255@nvidia.com>
 <1684792a-97d6-4383-a0d2-f342e69c91ff@gmail.com>
 <20250805123555.GI184255@nvidia.com>
 <964c8225-d3fc-4b60-9ee5-999e08837988@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <964c8225-d3fc-4b60-9ee5-999e08837988@gmail.com>
X-ClientProxiedBy: YT4PR01CA0121.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::9) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA3PR12MB9226:EE_
X-MS-Office365-Filtering-Correlation-Id: f794ea32-f1e9-4da1-e44d-08ddd42e6164
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H+hVgMpN2q16s/9RXQ4vKMx8tO8yM/POyDe0drI7z+dZ/06dEZ4lD892zVuT?=
 =?us-ascii?Q?7Z1Lscurn9pHckY+0C5qssulBWHrB0+gbrKKH1ve0KFBfYIYq6RZoa4z47hG?=
 =?us-ascii?Q?D5sRjxv5239nf0Pjq4n2oWhFpX3H/BChCZM74kLRqj4CBr5VsVRj3O8xYlQd?=
 =?us-ascii?Q?0vgv4+PsYNHBv1G0KnylGbv1nbiWz5afyD2+Rtz1HLmaZlt7wGSpJXFnDAuG?=
 =?us-ascii?Q?IbIADvQISITPA3R6SdRZ0IYklv4MviX9var6phDk1bG1hFQp6eKpT9eA7hOl?=
 =?us-ascii?Q?Nsyz7bw35LTtRlNK7V9ANmte8DWkEWBy0ubLGfM6L3bVO2l6JHfk/DGVXbmD?=
 =?us-ascii?Q?sFhPPiUfhkrVsCWJBbquv+vIcI+wZk+MWjr+MeAuqlefdh8UA0CJPUAA0quZ?=
 =?us-ascii?Q?IKcjVArcAtQy0djml/ZdKbWDB2m/4KNDKvAhWc9dz9BWWTGbZMNsPWpAll/A?=
 =?us-ascii?Q?INOXo9AapfXt97plgt3GnVk8SA4Lhbruo8zSUu7ts8TP/aJArX2nunmT02qX?=
 =?us-ascii?Q?dFPIZ/XIesbfkn5NK6fhQSiELJC0PzRUv90J6BvYtLhU8TwLijprtysXSm+R?=
 =?us-ascii?Q?V9g0oZ5vcgXKnQmBBjmCctMl5fFUjySs8RCNHpsOsxlxU7SU3+b1jLVLPChr?=
 =?us-ascii?Q?vQ/1SOL/BeNWLUQ4t8XHNJyT/ztfVlp/I7Q9cC8+CArDoMEUMHMNRQNfvWOQ?=
 =?us-ascii?Q?bxlb/YLZvCo5mfXTPp+xR2TPMQaUY6Dqn4aHCG1jLB0xfEI0be2xXNn1QBel?=
 =?us-ascii?Q?mp2guxAsjrnmULcpgczgAp3VZetbyX4MmQ0uvCNNBdM4LMZpdqoIChCVSSj5?=
 =?us-ascii?Q?M+JwihdBJp64vMocCbgSEFOabVOzm9aEDuqAYI3m0T0WzJtQ1atozdlfnV2F?=
 =?us-ascii?Q?4C62wwvi3xo7UUImxkDaiVOcxlFMzZQLxjEqIqS9jUPMtlRWdpEjW+t/AyJA?=
 =?us-ascii?Q?cQHk4aJEDpJ64YBFgR+rR2yAeIOLyd5ajkCj/WOIbfMe9dpL5JCaMjIbowi7?=
 =?us-ascii?Q?phtw0M9h2WjfDahhD9fNA3jsXckAm/NxU+5RyC4x9HhotuIHkpIXXi9h8Z0o?=
 =?us-ascii?Q?L2G6F91GS4MckZbfkYgCKxiQUWU37Cm+nIu/IN5RuwpSH6fDrCRQ6IP7bVJl?=
 =?us-ascii?Q?pKVSVIvZirraMgJvbuMk8KgaPUE9UJ3JJYIdkRbmfRiOPBF9b5/n5aqS8x3U?=
 =?us-ascii?Q?nJ0sBiyPFqa2Ra/2ZIjdtbH7HJp9k7yHA6zFMj/EBicsRR/tbXPxxgctm95H?=
 =?us-ascii?Q?3AaA7oPpS4ZZfjGBzlfmJpWh361ehbK5gP/wEVMGDPXPAaeGAe2EIzhIVAEq?=
 =?us-ascii?Q?YNtyHk1bBlpaDgKC4NpKdZKiSnk9idh3BdCjzy6ODw5RobOEc2xVJUNjDM4Z?=
 =?us-ascii?Q?lwlXTJRli1CmCyElffWTU93D5clgzw+F8ubpaGGAs9aMdXtV6VcqcscoRVeC?=
 =?us-ascii?Q?o0EBPP8LJm0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y6Ydz8sI8sxzFa10irYt2cyMvRflgRS2Z1/zIg5rOJkQLpyqHEN6rz/5fztC?=
 =?us-ascii?Q?h493we6dSh7Tt9Py11L/a4Ae+mPna+X7sV1TCmgUZ/4qG5mZ9t+tICGniT65?=
 =?us-ascii?Q?cAxPb3GflSYTqRkLsgMTIcFCBk84T8imNhZC4CJsyVhou7iRfvoqyPAkaSvF?=
 =?us-ascii?Q?JmMpQpqYsIcF7XsGtbRjwmddvjghE7WIqs2oDTzt8ZPMbGjWv4wFYqlVl74C?=
 =?us-ascii?Q?vJ8Z9caMT4LdSo2ouG5Y393PvMbUnGI2J/GSV8iD0OXvxzLzkr8/Yrp4mC7m?=
 =?us-ascii?Q?7B1UPrUS+v0dI7tfzdiAbpDpuepXucPARfo3BEWqP/ziUtPu1glIlwV0yLV/?=
 =?us-ascii?Q?VgBEXO3+eHhIdkMz0lxLx0k88/Yr4BjgGXVRlqNI99bywxNapW/OArAXVOQ2?=
 =?us-ascii?Q?P8jpXH5d5fJN8CmgMSdphR2oogJo9qLg1Qc0PrNI0ZAQJRAhhDG3WFMsgW1z?=
 =?us-ascii?Q?8uQqCH3ixUbyn0Aoebrg6eHtF64PRiD+pKNKrLZVdmu9Y12BJE7dm/pmCMFA?=
 =?us-ascii?Q?FxsY+scI83zBhf9tUCHoKGLqRE+RAFMxBB87yf4vtUqrKtUwLQjnKsoW77zx?=
 =?us-ascii?Q?OMvJZIQpW1flOoGsQjbX11zs221nM6qCt9a1LilsUzYHctcE7kWtVbvU/DNU?=
 =?us-ascii?Q?bW/0JO3LE68oLKpMKXLapgrmlSXLjccTr7WcdO7m6rNTolQMwYKeQFXKN0mF?=
 =?us-ascii?Q?am3u7GdPO3RZAzwQbRs1EXMoxy9JbQe3f/LDnKgv8W6mnIZBiD9uIbV+AvU1?=
 =?us-ascii?Q?KTF5SJ++piDFEWF4psrs95LeGgOeFCB80PDgpDdIF6Ym3RcUanL9AR5EEfRJ?=
 =?us-ascii?Q?QP3uT3L5jcvjvTctzB65hpXr999qxNl7SdcnhljDqdAhVuwH8j6446XoMZk6?=
 =?us-ascii?Q?bHsLZmwYemvLfMZCSjbzAlDrVpV7mVEwP3omWXx/RJtRYH6uoExvf/CxxCQ2?=
 =?us-ascii?Q?P0gSqz08KXW69H5EAaGXGhx6jov6wQ3rnvQezEGtRDyImDcKuMiKR6way+i0?=
 =?us-ascii?Q?+eEZKTIlFRtmRZqAW/DjhcVwe2BM3R89OFbpmmkKqJLmC2pbwlv6+39Fqr+1?=
 =?us-ascii?Q?SgumzKSXMq1UIWCDNblQByOajjR3P+73Vo4ygVx4Sh8HdZoaHW/UZxlMsMNI?=
 =?us-ascii?Q?kVOXwaZNU6Z94Wnr7D/FDLaQEDWxRI8IKAhSVSVUaQvGQ0XSHv4t24XTcbn1?=
 =?us-ascii?Q?7RKOlmZgJ23DhcLnFE5T7vkZsBudxBhuzaUaPmgWPxZSL+r231hFweykrahp?=
 =?us-ascii?Q?wCmSBXlADE7FmXAL00MPk5tSK8keGyIwGUZWDJX2c0VHvs7plLry8NgP+5Xh?=
 =?us-ascii?Q?OV41FNYXFCzdUKtT6IPNfrcvetFlLJLxJlt/+PSKZQHgvu4v3mNEZMGp1kzV?=
 =?us-ascii?Q?LwG1eFJdkxrhb3GjoA/YEk8FUJd2AfFdoyVr5wwuhbp7JriDyxyWtEvusfm8?=
 =?us-ascii?Q?44+bobcxHh93jtH1/jSOIWgxzJWcs+WYOCZBcPf6qGLdqxuULDvI/aEWJbSe?=
 =?us-ascii?Q?P98uMxaij2lEhhqUB2cpK/6fPJqRePN2nD9p6w/eY0stOslCtNreaoKp8tE2?=
 =?us-ascii?Q?Syi38rhHNadJPp1DZ/I=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f794ea32-f1e9-4da1-e44d-08ddd42e6164
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 14:43:02.5654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGURlaS8ukbx26JJDrXffA2fxFvJ4zd89qiZFYBqZEF9wLhqcdjv6Owh+lr8aEMp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9226

On Tue, Aug 05, 2025 at 10:41:03PM +0800, Ethan Zhao wrote:

> > > My understanding, iommu has no logic yet to handle the egress control
> > > vector configuration case,
> > 
> > We don't support it at all. If some FW leaves it configured then it
> > will work at the PCI level but Linux has no awarness of what it is
> > doing.
> > 
> > Arguably Linux should disable it on boot, but we don't..
> linux tool like setpci could access PCIe configuration raw data, so
> does to the ACS control bits. that is boring.

Any change to ACS after boot is "not supported" - iommu groups are one
time only using boot config only. If someone wants to customize ACS
they need to use the new config_acs kernel parameter.

> > > The static groups were created according to
> > > FW DRDB tables,
> > 
> > ?? iommu_groups have nothing to do with FW tables.
> Sorry, typo, ACPI drhd table.

Same answer, AFAIK FW tables have no effect on iommu_groups

Jason


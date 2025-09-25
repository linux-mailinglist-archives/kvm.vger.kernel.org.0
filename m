Return-Path: <kvm+bounces-58747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27536B9F38F
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 14:25:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9F343B856B
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A77AC3009E7;
	Thu, 25 Sep 2025 12:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PNkk8UbS"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012042.outbound.protection.outlook.com [52.101.48.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1D23002D7;
	Thu, 25 Sep 2025 12:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758802833; cv=fail; b=In02o4PDJsw+gifl8M+OXYtfp+QEyMzOyvr1qJCeHQQr1yUjruw8TMKIjLA0aI3uTCi+VfXZJgZdu4/z7XrrU0/wQL22A5SLztgd159gDLQ+OKdbGbWa6PHANMcwlayBZFMVf5enK9N6KIgJSGAtPFW9gB0nUMns+1pK4JJbgig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758802833; c=relaxed/simple;
	bh=myAsuZ6PPUR4q+jrEZebILx+K85j8jK9r0oPBz8jufU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JJ73fONs9oBvhgog/CVZJ8inVn7j2QciX6leBWZ3FbmOHyR29zIKVBl4qqadtmb059pHncuLu+jVuEEUX2UiPg+1dF7Qh9eMRRGvDGEgiolrda5xUNKpLLtOM08pQKmkEvlw/O42OyCMXwGuZM/CUiLlH9egjAzVuTnsfqvzUTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PNkk8UbS; arc=fail smtp.client-ip=52.101.48.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tQigW33qsxmGJfiiB0xDW1odQsri4t3mVH6rwxz3SvhTihEGr1mpyjKXDuC3ahlUbzTcWNzs51TXs4XopRDgtRTmMYdbD04B0Hb9XivsMta8I5rekLwcTYx44QWvVhJj9gpnQPEvO1cHu5FumvOuv1XjXivcacAP4gMb8AzVYhGZhsmIc0eyX3egzgSS4i4L5EYI4+vt2k+p1+ws9zPbspFMTdlvxAXEY9Q7S75Mthz1C8w2eCDj5XhHSF3vBUsyLKkFVV3glukm1Bsuwxkx0rtf2OvZpihGAlBglowf1c464CaxUI8+gY2iULJKlzFts3erOOBhS+2OA7jX/c1krA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r/vcPIAqpBShxYHTPTjS5TuzHjo8TtH7KC6C0uUpgP0=;
 b=D3muMmxv4MtJVymXModb+7It1q+1rJ8vwh14l49SoDIiVgmUb/r+JtRFP+8EpoR3GPSNKKTCgLhYQY4Z7f/jFK8QSDdXplVL/p0knUFj7uy+MEchh29LyhSUk5JCkltKg/jSEHBkaA/Wkhy6J1KIPA+SSm+s70EjVefMg0hekeh0mUU7bbNEmsp/gpzi5gdPG5fKkc6uM72BmYLRzBOPZu29TNjp3xqVQCMF28D0SFXxRudCQCdg7UQDk9BBG+bJFUazAFlGKfuFk0XMCbEdhnyT9Ydz8BlQOGK3oSG81v0rpUxMAxzm13i8mLUoVcM2v4P76dxmUpI/lyevl6lNXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/vcPIAqpBShxYHTPTjS5TuzHjo8TtH7KC6C0uUpgP0=;
 b=PNkk8UbSPVvstK9xSmP25SXbgxm585JAPTBdjgUGrKNhOz7k3D0v7gGjPisYSxtUYdI+4FKyXKdH8Jix+dGMkY1Sw3Vfzpx9iXDPbKUuxPwcRu4bwXzwC0ZXP8zshBaxo3QpQJ/Ai+SwIEK+INwTwt9lWMkpjlR5PM2uE1s2ITnI/R9y2hhzTbl7Rr6Px+Is1rIXShwX0l+s+/FNl12wRwMfN1qERSqMV7o8VXtUjyHpaRJqJndpZkx5DMMGOV8Ga5tpWJr2W0C3EKvdFa8ATlauvk12A9vr2+IbxLSzuCXitlL7OPMa9UZbKGHXTjL3H7OhUdmn2CFDmjN9YnwFnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DS0PR12MB8504.namprd12.prod.outlook.com (2603:10b6:8:155::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Thu, 25 Sep
 2025 12:20:28 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.021; Thu, 25 Sep 2025
 12:20:28 +0000
Date: Thu, 25 Sep 2025 09:20:26 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Donald Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	galshalom@nvidia.com, Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	maorg@nvidia.com, patches@lists.linux.dev, tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250925122026.GV2617119@nvidia.com>
References: <20250702010407.GB1051729@nvidia.com>
 <c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
 <20250717202744.GA2250220@nvidia.com>
 <2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
 <20250718133259.GD2250220@nvidia.com>
 <20250922163200.14025a41.alex.williamson@redhat.com>
 <20250922231541.GF1391379@nvidia.com>
 <20250922191029.7a000d64.alex.williamson@redhat.com>
 <20250923130341.GJ1391379@nvidia.com>
 <20250923152952.1f6c4b2f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923152952.1f6c4b2f.alex.williamson@redhat.com>
X-ClientProxiedBy: DS0PR17CA0011.namprd17.prod.outlook.com
 (2603:10b6:8:191::13) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DS0PR12MB8504:EE_
X-MS-Office365-Filtering-Correlation-Id: 56692540-a63f-4917-014a-08ddfc2de990
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/j0Wdmrrioq+0ypgGcAuRPp2uutk1HIGNdcrIhKugTIzI9VRlYynMCBKWhoH?=
 =?us-ascii?Q?ZN9KjFM4yzUJrJWBQrrskRONELkO2Gx9nMCSvjd5SMF5wWgByqY0ggA3m7Gh?=
 =?us-ascii?Q?CLiapkY4PTKNxZ3fLQyjoYdSX5tU/LDgbO8iwM4szSvhBHUvNfKnNSROXzlu?=
 =?us-ascii?Q?UelwmUTrqfyVKRFTEn/KFPbPeKJAf8dDbvWnWmZaSj0SnzHtRFZ6SHB1g+9S?=
 =?us-ascii?Q?NAbH7CpU8lQ8Atm9O0VjFrqyQqZzHiNBjBXCBIhWQJRttus6CNAPqbwr/r59?=
 =?us-ascii?Q?apwId48W3LpmW/ADqPO403oZdiPfCDLIeCCkibpkkCTSFMmYMlsWNWls4N6H?=
 =?us-ascii?Q?o4wdXSxCEL9DSp6Gvh3OxNxb9kSWkOdiT8FmjY5bLXc7Jfp+kiYXYmgJ0j8h?=
 =?us-ascii?Q?ouy6wRmhs8UXHOX2HReauyEV+P3LXLFUBsd3w4k4DL1q7wLkc953UTwyNgrg?=
 =?us-ascii?Q?7IivJQWUvC98yiGZcpD25kZB6rfBPu79YkZ1rfuPNGhrj0QMlxCSK25VJvwU?=
 =?us-ascii?Q?A0VNCijhqdldS9haoj7Od+3woXVBvwkY1Q5TcmOmi3qQNi24pcUMSYcgP5Zh?=
 =?us-ascii?Q?wxjf5Uxvgw0gUQWoRnZBc/qv3BJ9x096MFbQFIt7JJHM/4kL1bdRC+sV0+Sx?=
 =?us-ascii?Q?v+jOuz6NHn9TLmE++Q1ifHqx0tb+o+8yYX80c/ByBvnVlt9Op5T5NEiSyw3T?=
 =?us-ascii?Q?r6w9tbIYzvahZG+EGu/rVUzvHmcpI6erZDwW+dSmNahS3eBEZnRNR0rt4+Fm?=
 =?us-ascii?Q?VtA8T0QNaGG85JVqYP+Ch1jDVUULIRSzBxgq7a5HciF9AfdqHH20CGfhpWGo?=
 =?us-ascii?Q?i/pBUQaSr/DT3UUxoKfX5oLnFrJlKbF7PitEFWbCEbo7aeM6MnqE5Owc9zv5?=
 =?us-ascii?Q?9Y5vIDKzjQjEIjkza6tc9EfLhFzOVZnpjAylulg0XdENpWGMc8QCMSx71t5A?=
 =?us-ascii?Q?gKjhBpAQGWp+GzTIq8szY6XW2Ed9GGqt8tme7J/Jjanlrik9S0of1GT09hYt?=
 =?us-ascii?Q?sAgMOV0/+eEIAYiu4DSRyLoPfbMVAvKXAdGP6JcdN+6Wc89/F7p3fbl2Cd/y?=
 =?us-ascii?Q?lCWa4lE7jgXIBT5MeGrv49HXj8dx12t/zdBlSX7RKieMhPI4P32EkZWa9mV5?=
 =?us-ascii?Q?Ny9vjGU7IKbYlMAr8+5KNxb8KymLbgZ6RH5MIUWT6J4l+JeCEW7aHIF+LMH0?=
 =?us-ascii?Q?ED2LUQxrzvpyy8q16s7Y3GidJDM5IseTaO+d0+pTiXfhkYqUrAfHQF/X4kWj?=
 =?us-ascii?Q?4U46sjreuuFWavI25+dJM++Yd7EUx5stTMXPgBCxBmktL2A078Z06SZUeZrb?=
 =?us-ascii?Q?83HSO51JkPeiNCVUZpfUUcN8/IS/2Q6nfsbIw2VI3mQPgz5cPzcpZDy7pOvv?=
 =?us-ascii?Q?2sNUFq11i88VnJ+gFdx/y4F+89nNQkjW8c6h5knMA0cvUe43w1fM4FeCEZ6z?=
 =?us-ascii?Q?N3jVLPwzBYBmIcLp7wtP3pNNf8IcJJbmPZ6J3gg/vkHG7ocWnlag6w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vFDxc7bdem87XIF5WJLmYXH01W0WlK1qqA6+H+XedMPyr3ED/Cv1EbNKRxjq?=
 =?us-ascii?Q?60hW2cNt4SZFzgNVElStkkWWd9DbxfMNvCb5Nk0TzC1oMNgi5VvvfDQx4HZN?=
 =?us-ascii?Q?SjLcHkGgp6XcPHSujVCHH7Np2cI/ltZ8hJVyhV7vwM+nr4oUD571tiUR0O2T?=
 =?us-ascii?Q?ksYyIV4CDR17xj2N0eZHKLJyWr2oQQx9S9a5LcbEFlh9PJbtnN58Q/inWcu4?=
 =?us-ascii?Q?rMtf/AxLRN1EWb9ik8oFko5ZBZWXOsXfctWFBm/8gjCER/OirFu7X22UAo4i?=
 =?us-ascii?Q?vz6tyvJ1KTOcAssMiWHqEuw7CgeX3I6EzYjR+Uv7mb2+8H6HSoXv3Xbk/RLB?=
 =?us-ascii?Q?XUEdplaLU4Jzd5tW5Hu4jtUeWs9d2buJGtIufVva/GG9Ex5JaXuSOaVfRT0a?=
 =?us-ascii?Q?DUL1VXv05VCuJO0fSF8+ti+O/w6WUXcsvWplCnSzz20YLDDRjxJGZpZGURIs?=
 =?us-ascii?Q?51f6HHU+hA3RBypZejO7t6C2sGmQmuDRSajSWiGvC1NQtxa/A9hkr4v3kCws?=
 =?us-ascii?Q?FHK0u//AhYdaZQD2LO7XkgqWiFVlKuzG6X6NGB6T1byUw1y3JunGyPUzuRaC?=
 =?us-ascii?Q?Bm2RBRbcZFNSCACkCSYAPOzqbRcOyBc5SWhRN35o+kD/XS55q+QN2ofxLumU?=
 =?us-ascii?Q?fxwCDf+Pw6IJVulmghZtz/+DBA5wlyN7wOys5yunzH4gOdWJ9Sph+Flc1ro1?=
 =?us-ascii?Q?rsr5BdhG1WrVTm0SsP+QH8GT6UYf4qXYTG7VzCYT+iKmbguFi0e+dA+qh6Km?=
 =?us-ascii?Q?gw4ymMg7Q40ALyZmWmCl50d7DfCFkXJdxzLe2zk087rOGw/gNGjWy9DAYOZI?=
 =?us-ascii?Q?2NVzy/EWUMQJy3jElzTJ7kvJI8ia28PlwxKAcjZYJ//D8dK/ggKyhS0QWHYB?=
 =?us-ascii?Q?zOP8UzCEc8h3zdmchwfyEsttWkKtKDKEbgEYfrh1KOl3XgF87MR6e8oDKCcz?=
 =?us-ascii?Q?aXdCBuWFEO027b3F46JWEuEidoB1Z9mkQDNd5HPjlSCibuv4CT0JieNwCbo+?=
 =?us-ascii?Q?psoOVo81Pd2zprbV+48gB0kgqYnop+BLmkBn8qfuvGBgn7jIYLR9eFu5o5fF?=
 =?us-ascii?Q?3PlRAvmwjSLCNmlGb12/5fI7ClKL6JrQFZJ7jTH4hFQTLFYjdxeNS8JmnNvm?=
 =?us-ascii?Q?P46Ajv+CqAKEaAPv1HX2STHn2g5oON5ZiOdMQewwkzF7M63xkq2a0LTYJf2d?=
 =?us-ascii?Q?KkVc1S9DFNzCpzXbwAopSGuCfwV05uk/5rOaywCyZYbGv1fd+xu6VWWsO7UA?=
 =?us-ascii?Q?b3DpFoaMF71CMlOH/TQpfG5uwI9QzJEPjRfowf61IxImgtVDBDkuIdAOda5S?=
 =?us-ascii?Q?SdaAJHMh5MoY5G4dW79NtThDfDOnFwrGiWF0wbsTqP7RqqBtGmbeQHGFZIid?=
 =?us-ascii?Q?2r3tNIRJBrJ+TQEDMPVoAG2xeuZx2dvTFczngSMQrFmAIjc4K7wEtkmvTuJb?=
 =?us-ascii?Q?rYz4QCm+ugYpiUQcRY6XT9uDidmn2/X9JnrYZAClRbZVzV5z2vu3DoON9kLL?=
 =?us-ascii?Q?tgmZpUYv+/LN7dWaTYNvbesk58vCH2cMbk+lYiG3DvP6vo4RNmp0N4eghP6h?=
 =?us-ascii?Q?IS0rhrJbG1CQud9jZBLdYcma5hGUCkb4UeIckDL0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56692540-a63f-4917-014a-08ddfc2de990
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 12:20:28.0424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fy6BQYWl3aIsXANIx2CQ3DFov+tb2h61d1+uCy1bOWnmhvbiR0x0VNSsVQDax1w1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8504

On Tue, Sep 23, 2025 at 03:29:52PM -0600, Alex Williamson wrote:
> > > Where?  Is this in reference to our handling of multi-function
> > > endpoints vs whether downstream switch ports are represented as
> > > multi-function vs multi-slot?  
> > 
> > If you have a MFD Linux with no ACS it will group the whole MFD if any
> > of it lacks ACS caps because it assumes there is an internal loopback
> > between functions.
> 
> Yes
> 
> > If the MFD has a single function with ACS then only that function is
> > removed from the group. The only way we can understand this as correct
> > by our grouping definition is to require the MFD have no internal
> > loopback. ACS is an egress control, not an ingress control.
> 
> Yes, current grouping is focused on creating sets of devices that
> cannot perform DMA outside of their group without passing through a
> translation agent.  It doesn't account for ingress from other devices.

That isn't the definition of groups at all. If any two devices can DMA
to each other they must be in the same group.

There is no ingress or egress rational with groups. The fact the
implementation is creating these inconsistencies with ingress vs
egress is a BUG and not in anyway part of the security definition.

> One of the few examples of this that seems to exist is something like
> you're describing where we have a MFD and one of the functions is
> quirked or reports an empty ACS capability to create another group.

Yes, one of my test systems has an intel NIC like this. 

> The ACS/quirk device is believed not to have the capability to DMA into
> the non-ACS/quirk devices, but the opposite is not guaranteed.  

I don't think so. The quirk should have been applied to the whole
MFD. Because the code has this behavior people got away with quirking
the NIC only. IMHO the way to understand that quirk is applying to the
whole MFD.

> In practice the ACS/quirk device is typically the only device that's
> worthwhile to assign, so the host is still isolated from the
> userspace driver.  Arguably the userspace device may not be isolated
> from the host devices, but without things like TDISP, there's
> already a degree of trust in other host drivers and devices.

No way! That isn't how any of this should work with hand waving around
"worthwhile to assign" guessing.

> I'm afraid that including the ingress potential in the group
> configuration is going to blow up existing groups, for not much
> practical gain.  

You are aruging both ways. The current design does not follow the
spec, and does not implement the security defintion for groups.

Dismissing that as "no practical gain" for correcting the security is
perhaps true, but then don't argue against this series that it
slightly weakens the security if it has "no practical gain". :(

> I wonder if there's an approach where a group split in
> this way might taint the non-ACS/quirk group to prevent vfio use cases
> and whether that would sufficiently close this gap with minimal
> breakage.

You want to build asymmetric groups now?? It is already too
complicated - this really brings no value IMHO.

> > If a MFD function is a bridge/port then the group doesn't propogate
> > the group downstream of the bridge - again this requires assuming
> > there is no internal loopback between functions.
> 
> I think that if we have a multi-function root port without ACS/quirks
> that all the functions and downstream devices are grouped together.

Yes, if the MFD bridge has ACS then yes it wrongly blocks the
propogation. Again the only way to understand this behavior as making
sense is if it is assuming there is no internal MFD loopback.

> > It is taking the undefined behavior in the spec and selectively making
> > both interpretations at once.
> 
> The intention is that undefined behavior should be considered
> non-isolated.

Sure, but it doesn't do that

> We try to define that boundary of a group based on provable egress
> DMA.

It's a bug. That logic doesn't match the security defintion of groups.

> > How about we answer the question "does this MFD have internal
> > loopback" as:
> >  - NO if any function has an appropriate ACS cap or quirk.
> 
> In this case rather than split the one ACS/quirk function into a group
> we split each function into a group.  Now we potentially have singleton
> groups for non-ACS/quirk functions that we really have no basis to
> believe are isolated from other similar devices.  

No, that's too strong. Given that ACS is an egress control it is
totally pointless for a vendor to make an ACS that egress controls one
function but the MFD has internal loopback allowing other functions to
ingress.

We are making the assumption, that Linux is already making, where if
some vendor has added/quirked ACS then it actually provides egress and
ingress isolation to that function. Meaning there is no MFD internal
loopback.

I'm propsing the consistently broaden this assumption to the whole MFD.

> >  - NO if any function is bridge/port
> 
> This would hand-wave away grouping multi-function downstream ports
> without ACS/quirks with no justification afaict.

We can drop this if the bridge functions have ACS already today to get
their groups split.

> >  - YES otherwise - all functions are end functions and no ACS declared
> > 
> > As above this is quite a bit closer to what Linux is doing now. It is
> > a practical estimation of the undefined spec behavior based on the
> > historical security posture of Linux.
> 
> It's really not what we're doing now.  We currently consider undefined
> behavior to be non-isolated, or we try to.  

Maybe it wanted to, but it isn't implemented right.

> The above makes broad and unwarranted (IMO) isolation claims.

I agree, it is trying to match the bugs in the current code with a
grounding in something explainable and understandable that matches our
security definition for groups.

> This puts data at risk more so than assuming undefined behavior is
> non-isolated.

I already sent a series that actually assumed undefined behavior was
non-isolated.

It breaks alot of systems because doing that *correctly* is extremely
pessimistic toward real world HW.

> Should we re-evaluate how we handle downstream switch ports exposed as
> separate slots, certainly.  

So lets start with that, we can stop this series after it fixes the
switch ports.

Jason


Return-Path: <kvm+bounces-58528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB86EB95ECE
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B023D19C239D
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 13:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5276E323F58;
	Tue, 23 Sep 2025 13:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TqBUUrKA"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81A9238C0A;
	Tue, 23 Sep 2025 13:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758632631; cv=fail; b=j9FXHxxxklgjlDJacKjfxKToVYvSxB5eFSsrtqQlgNgV+nvRDQapvhjfSvZEcOkb4Z0k72cHRQ8J/X2aEQFhmMSYV2Vn7okpn2w3SnYDR6m1Jsc9VK/NVWMQmWWEOXtPFANU6KtW9BiRX3U5M51/HTyL89qVUSzLBuUEcuc7GaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758632631; c=relaxed/simple;
	bh=+/gAALjV39zB+KAv/4hKfZK9pA8Ko5vrAl8LnX8Oc5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=poahnHYLq9ijblhcE8u82A6U0IQukgMx1LW0QsumpRiz9HlTItw8e1nC5n7fEfoAjP3kPkQ9EOHvfApNM/6SvvUzCuMyIglN675+ZHhX2uvxKcyuzRZ22MXCAyiFZwPo5gHHrKuGkD9LEsjjsYeZAu3BXXC8rXIUGk1vQ4w2BGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TqBUUrKA; arc=fail smtp.client-ip=52.101.56.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W+FBLhzaMA4FeJIli/UidCZk7QRw8KxvShUPcUsNaGmTbB3yQtwmt8ZelrT92fTfSH3LY4afXCQYDMgnHudsqrit1yWMb5+35unMMRHYx6VKCKwicCwevQV5mGEXsmzq5SGJbmV6H867hMfsi5vIa48Do4qku0pRpD/PX3M+Sd2sEIt8ETgtpQNcEtlsoDidfBBmBmClnW8Oho6dyzI81PD4m+z+YQ+sQftSFTNtLW0eDYnF9OSSwdBLBvm+Wd808ycmNjrr8aCpdOrqII8Euv+9DU9n6oknp/vdIMBBZ7yjMNmuzu/z0KdQe+nPkT4bdcTtSP0nw7qhGws6kRjxUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALc4M62CqVoXAOCDo2iUYAr+7Lxc023W3A+UCWQ0tNY=;
 b=XX34YX7DHYuZE84w4Kp9y2UdJjJXX8ppRKulJ+Ep9vufbXOHK95HZUZrygTfZjUewaRapSaOIU3TaepAOAVE2uZV2+GGpKev4Bzw/iIpLkT5abO3ZCbuKcAkS/lVAFB83NMAh9VVMIgFS8mbY0Y1QV9hQjEbhbXUkYiINNL4YURNSorNpU05yqmxRixSkFB/Fq4AcF5inuW80nnMEEdbtdUf//GYarL7KCHTqymSon6YgVlrnY62RG8DkjmmjmoWchzcEavl17CFgg4mtgPxhpCqfwxIKMA1E23e99WMiH6WW2ZWfdI/LZxZ8ZWG6aLHVJAJUfUO5duGtv7iiXZpwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALc4M62CqVoXAOCDo2iUYAr+7Lxc023W3A+UCWQ0tNY=;
 b=TqBUUrKAJaABXgpwAeRileNape+zjs3QHfmpB+CVy+MtEcxbSD4CWTdbh9zhodzqK99TadvanL2yrAiD3z+gcwPesoIfSyeTxXlCPXRAsBAyh1CcReQpTrKoevl+gJayKC39x3IfSSc4D9hHcNecLLiPK9H/TRo/TOBwXISF9+aXQVKj1CQK83YmonIIHroc1nPBQz1UvcKmXBY+qvQqTEqZWurGATXcCAHnB0HVI6gB/JTu6UN6+tDdOd4g5XFNg62cpPM6V8lOiR4M/3DphffYVhSN4Xcnq9EBuIuapd3GEjDNQbvVGgQ41aXeG8KgVJolJ55bHTmoGIh0dRSjbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA3PR12MB7975.namprd12.prod.outlook.com (2603:10b6:806:320::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 13:03:44 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 13:03:44 +0000
Date: Tue, 23 Sep 2025 10:03:41 -0300
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
Message-ID: <20250923130341.GJ1391379@nvidia.com>
References: <3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701132905.67d29191.alex.williamson@redhat.com>
 <20250702010407.GB1051729@nvidia.com>
 <c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
 <20250717202744.GA2250220@nvidia.com>
 <2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
 <20250718133259.GD2250220@nvidia.com>
 <20250922163200.14025a41.alex.williamson@redhat.com>
 <20250922231541.GF1391379@nvidia.com>
 <20250922191029.7a000d64.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922191029.7a000d64.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAP220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::17) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA3PR12MB7975:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dd11941-f641-452e-bf51-08ddfaa19ffb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PoqbNWCzpJOlwWhpcAbn/fFUIwToe4ViNeFArAQylRZgewo0EEREuPBxTddB?=
 =?us-ascii?Q?WkNjN8i1SUOGTF4g8cYjKhoLhJVkMrhSaWHVj7He6u+9H6NLgl3laYh0AZ14?=
 =?us-ascii?Q?Teu+4LXvRsxEZVcHA2JsC2rJ437lWche3KnE8Coyzt7dc603m4vwVe7vN0/4?=
 =?us-ascii?Q?readaRtNckmn0ctJ0SqeuQikib+fGKBH28qq1AQzn+rSh2CnoT3WFquMVyV5?=
 =?us-ascii?Q?qMjSFep+SF9SxrpbwyEtn5t/t/5TONJ4+uz05O9c9VXOMumI5DrryeUT/LdV?=
 =?us-ascii?Q?gq6I74wDW9AV5q2ZgeyrrBWrW8fI3lIvPuSvUdIa53PGmZNzrZLGyj/VA/bO?=
 =?us-ascii?Q?w670tTPWJBrbzVt2kOedRBuUZeadu8IK20c37rxJbrtFhd3PEAN6bK5QaB/o?=
 =?us-ascii?Q?W97r+JNqtQKFsIabXiqkfH7EOQZ6Vr9CswsJA3QWjkl+zB+H4YprJoO12kka?=
 =?us-ascii?Q?f9cavWS3AtW0xT0HnE6jwiyquHhUfl2YqDWJncPJSz8kF8AAafKALK5mvW1S?=
 =?us-ascii?Q?03piv84zzsF+97f1uCFRITg2xUhs6BKGvj+gLlUcM33c49kfuzrONJin2baR?=
 =?us-ascii?Q?3fWzbmG4WVRMOYZhLXkKGuajEOO/AwwpeEHIkNd/NYycxkBWPZ659HN32td6?=
 =?us-ascii?Q?hH713pNQ7fq52e19/GZJaQ+gIoH1eU/xTzDNc8mdsPHDFfl7jZwdnS5p8/b9?=
 =?us-ascii?Q?Tv6K0YCaQC8VXdfDNvScZmn+p7VWHoieefe2EZieJAP2IzEvyzUlcMBMCKii?=
 =?us-ascii?Q?NcGS+7aDbdDb+LCzcqzxoeBnoc29dfzIyAMH4uC205jX2VlbVDePbCql/kOe?=
 =?us-ascii?Q?29aKZAZtbvNwD6YBpEV1/FyuPFxoSkH3zcDyvBFfZj29JZ/i3wClvDLhj56S?=
 =?us-ascii?Q?pBTCqwW2JUEn68407/+NhSiZYcebWjZgGL3l48jV6HJ9XRHt3E17HssM8+hX?=
 =?us-ascii?Q?BWLh3sZFkpTkFLfADoHHEyV0zZ8uQIP6xIWBrMwdfQI9QiP79LARMg453gc7?=
 =?us-ascii?Q?SSPd0QfpykciJMxh4r0abF3cwHXxNPLj6PIuIylXHWk/jxzF1a7+c+7MWuJb?=
 =?us-ascii?Q?XmgO6QAlf4KYQYx9eaMF7Rm/ND+BwE3FzvBSRpkqm4jBGZbuBs30X6U7U7Cp?=
 =?us-ascii?Q?YdVtOANBInOMXCkmUwF7+5wzdTb3lqGWgkrqDPESIHmPIfQCdEF9AahXyGtz?=
 =?us-ascii?Q?od4YcAFYp/jVajWLGD5+JmhbBvH1XIl6dYEgcD+wG4I7IXg0EWKV+19bPSgC?=
 =?us-ascii?Q?zRCmuCQOZOnb8SqyGiFefsruUkqnsAOBK6uNLLTMT93w9njmoBD+Uzgz8Z+N?=
 =?us-ascii?Q?0JaJ6doi6Cyg6hVK3LC2OXC5N+OLKDlqaN2qdjQqz6ZQ6luVJWEfvz9AqOLb?=
 =?us-ascii?Q?UAiquk7g3CGRinm7Ek2y0MtYFGK6holpP/P8LnzvTMbFm9W8WaE/QCxmFbPg?=
 =?us-ascii?Q?gxxEFjoxXZI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?69QsmRj49vKcYWIHHB7EGAUnijDeg+Nvb3uat56nqIPorWPupRkswpKmxcOt?=
 =?us-ascii?Q?f9ViYu6KUNoSWvI4NGZ2KLs1CwC2R3sfsUwdIOorC7LOCqsDueWhzvJMahUq?=
 =?us-ascii?Q?BpeNzG7omKWvO7igJQG1dZsjl6XX3eg3b0dyxvA//OuP3ACL4+HBPQhCAhG1?=
 =?us-ascii?Q?ozU0d3gb/uNKeLVUuq7cz3k6U9jyMSmh+Y6xWCJDIknzRZydfZ9Mw0hf6wRz?=
 =?us-ascii?Q?AqO5l4W4cHHzNbyLjddk7WiKT/f/rBoEe+kg/NzD9Vpb5ETklae/myWV5pjs?=
 =?us-ascii?Q?K9cFYtOq9xJvRy4vE6loJ/7Kvzp1qWjlac65ogS64HPcC/YXkCwdgMABKG5i?=
 =?us-ascii?Q?6PTvOPXat3elVrhFhfRKVwEtegi/zUCH6sq2RzSKCtmjz1dRYJnEGQfCuvWo?=
 =?us-ascii?Q?wt7rTdds3as9jk/K3FzyafEtSQuO/gCpr0QkjByw3AYVT8c90iCN7FaaTKL1?=
 =?us-ascii?Q?aOgi3FNR+Ggnoqx8jkmrOUwL8SCd1frGtgAz6Fe1W2B+FAilp1bgONjIUpRb?=
 =?us-ascii?Q?amzbazrxsYPeS/7Mb9ewSBZTHsYO+EWMUwljte44WTyUqIviUYHZthwSLqwE?=
 =?us-ascii?Q?hDbsRSqYphtd8I+S7rbmaOaz0XbGKyDcocWd7/WtajFmZSKivDJtRJbH9SkD?=
 =?us-ascii?Q?jQeQ4n8+r5F7mVQpG/5i4unDiE2UsRrt60PxeXK8ySfuNADoouNEnTngMNNo?=
 =?us-ascii?Q?RMRW8IzeSKZ4fMtLzoDdja4d8T3ONp750teatGblldG4sblSEApDn9IQiqej?=
 =?us-ascii?Q?GSyzWogRXaxgJ5ciwI5GBZMVl4lo3stXHjnm2ka8hTQDYzo9mx1z+nDBU+Pj?=
 =?us-ascii?Q?i87Il1Uj/gSkJgdXr1kOKGwzJKLR/1s1wk7f05obQ9qxSFZcRllg7RBgg7ZM?=
 =?us-ascii?Q?Qnwto9tN2FBttNwFKbqCBM+SAqQorcs1NKZ3bZPJt1eDOxF0OzKzEyNzAr3e?=
 =?us-ascii?Q?9pTXnn4mJXUudebEOxknkJ0TmLbPzXNzuCqOx6DazG2vlSm6rZWUQV/4jO3F?=
 =?us-ascii?Q?pqEY90+Y6dDHgFw/wB3llACEsyKOm6fPEhYUyPm1nqvh2E1F+3gMC0snWsDD?=
 =?us-ascii?Q?ffaoKCJdSWDP+yCcvjDGUbuPKmMQFDdHU2HcJDMAfZ19ZXqlnCGXVdk6/Ozo?=
 =?us-ascii?Q?/zddA/TToOMCUU873XZZaU3+JPTM8/hUjbFL5Wutyq/nZubhpJseHvA1fNbG?=
 =?us-ascii?Q?t2FZ91zkpWynTHMn2M1vfMyfazCr/F0fDCVQBjCm4naY8iLgnssFOCc6t1Fq?=
 =?us-ascii?Q?A70bfNizv1yqP8+SuH5+4W8PrOkj+nCi+zGwD7BforvSRXYcjEryZu7x/FLm?=
 =?us-ascii?Q?svVSmHGLD6+v40wWq2vhdyETxw/opk3R+w4Pzfq4prfiJewzipOQzE3Y03Ui?=
 =?us-ascii?Q?l+6/Jqn/iYGgKtaDWlMbgDeLjXLRYHqjSNTcpDwh1vDVQC388xzy2wBb14bT?=
 =?us-ascii?Q?BiEuu+pSrZZG1sCxTKp3h1kyHKuaOi6nDvW8+igEYVUF3CrueBoS47ZtKT6e?=
 =?us-ascii?Q?DO17GOsInIJta36U4QrXm62UtIshF4gkfXWfUyTKVHG1qcTJ1KA/mv8sd6tg?=
 =?us-ascii?Q?7BUMQ0wcovqQQFhPhTbzVRBF5e9+28Cq8PnThI+U?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dd11941-f641-452e-bf51-08ddfaa19ffb
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 13:03:43.9580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oL6SmSNgm8yz3Tfb7/MSPEKbrAY4DTl/jv7/QGUmjSTpUQ/yH/oZHrwQQRQv5QjZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7975

On Mon, Sep 22, 2025 at 07:10:29PM -0600, Alex Williamson wrote:
> On Mon, 22 Sep 2025 20:15:41 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Sep 22, 2025 at 04:32:00PM -0600, Alex Williamson wrote:
> > > The ACS capability was only introduced in PCIe 2.0 and vendors have
> > > only become more diligent about implementing it as it's become
> > > important for device isolation and assignment.    
> > 
> > IDK about this, I have very new systems and they still not have ACS
> > flags according to this interpretation.
> 
> But how can we assume that lack of a non-required capability means
> anything at all??
>  
> > > IMO, we can't assume anything at all about a multifunction device
> > > that does not implement ACS.  
> > 
> > Yeah this is all true. 
> > 
> > But we are already assuming. Today we assume MFDs without caps must
> > have internal loopback in some cases, and then in other cases we
> > assume they don't.
> 
> Where?  Is this in reference to our handling of multi-function
> endpoints vs whether downstream switch ports are represented as
> multi-function vs multi-slot?

If you have a MFD Linux with no ACS it will group the whole MFD if any
of it lacks ACS caps because it assumes there is an internal loopback
between functions.

If the MFD has a single function with ACS then only that function is
removed from the group. The only way we can understand this as correct
by our grouping definition is to require the MFD have no internal
loopback. ACS is an egress control, not an ingress control.

If a MFD function is a bridge/port then the group doesn't propogate
the group downstream of the bridge - again this requires assuming
there is no internal loopback between functions.

It is taking the undefined behavior in the spec and selectively making
both interpretations at once.

> > Assuming the MFD does not have internal loopback, while not entirely
> > satisfactory, is the one that gives the least practical breakage.
> 
> Seems like it's fixing one gap and opening another.  I don't see that we
> can implement ingress and egress isolation without breakage.  

Yeah, either we risk more insecurities or we risk large group sizes.

> We may need an opt-in to continue egress only isolation.

It isn't "egress only isolation" - the thing is I can't really
articulate what the current rules even fully are..

I'm not keen on an opt in. I'd rather find some rules we can live
with.

How about we answer the question "does this MFD have internal
loopback" as:
 - NO if any function has an appropriate ACS cap or quirk.
 - NO if any function is bridge/port
 - YES otherwise - all functions are end functions and no ACS declared

As above this is quite a bit closer to what Linux is doing now. It is
a practical estimation of the undefined spec behavior based on the
historical security posture of Linux.

> And hardware vendors are going to volunteer that they lack p2p
> isolation and we need to add a quirk to reduce the isolation...
> dynamics are not in our favor.  Hardware vendors have no incentive to
> do the right thing. 

They do, otherwise they have major security holes in
virtualization. In an enterprise setting I have no doubt it is already
being done right, and has been for a decade.

I think the above rules will broadly be pessimistic toward add in
cards and optimistic toward the root complex.

Jason


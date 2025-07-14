Return-Path: <kvm+bounces-52347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA2C8B0451F
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 18:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D88A93A4076
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 16:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3776225EFB6;
	Mon, 14 Jul 2025 16:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NkuE6P1/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2044.outbound.protection.outlook.com [40.107.96.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB66F1F94A
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 16:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752509312; cv=fail; b=l1ToHezFXitnmCriWDaHnHjrB5/DHlg7KTB2z0rwSOJsseMD3DltB6pZ3emRcHn8DdlNClhF+Cw3pDFApUvIWNsuJCrYvON5ZFa2N8teCXgY/8g9hSnsKmjH0xUSJ9Dt3vLUF9+Z+CZXFokhArBnSuLXq9riH6k+IDVE2XVGhwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752509312; c=relaxed/simple;
	bh=534qjgJXUgoOsayCT3CSoCXPJWwvjZJGGIDvm7Ntgjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=q/nbgxBphAy8Z7WLZ3yINCIifvPrsTeB1817/F5u+TtJmOcW5JkPwCh/rQcDOmw8DqdpnlTf1GsPVx3UOmO3iwIToQCNeGtiU73MKuotbO5Zqi9npXsiO8UMXqXz19mueQ6RbClFnHdIdaqh83dvkFMYX+BlYi2DcD55llBgtx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NkuE6P1/; arc=fail smtp.client-ip=40.107.96.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EOBOHwdSHn4yrvrEt/Zbt7sAmbucLet/Rv8+yzr8jdaVcGz0buR09DQqEXfDTbq4QvfUbFXW1bly/8y2BtS/HwVC0EiFHPGU7eAj0MLF9r78KbjU7IwLdvO7hJOlbvBjOyY8+etOmMT/WSKA29LGZyUb7Geqdr4nVCeDUqSx6SJA3LlS8MZN8RqWSvhrHiP16jD9DlklMcsBmS6SppZT1ot2K659iuVL4+7KjqgEArvCShDOpJW1iLbGxzl7wCCly46HW37wfdu7jQbtg2V3thQ6xL8WIJjGnXc3PXMvTYA5/15U1IqhWc9It3oWEKTYZ+JfqJ6BXfkir49sNR9w6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+agGZGno06NC/OTlIYxDpcloNpkOoeQll75PHNP6uE=;
 b=IxURVRcnBumVXVl/haMQ21UkwE2b1yUALnMo0peBHx8qoPEeqa9nY/PlE1+3ds6ebkpTx8kIDs80bLH4xVP/5zbOKD04yHKgk1Y7smej1Hm7Rzgqj+ow1M+lzHwndPNerBbRLiLv2Ele0rmrHGcI92ARfyGpXi1X4u0whP/QwjEH+Nef5Gcb/ZDfztcjV+kvrA6NhfAa0//CWBV7432HekZJlS+id2SE6HuvfHKssUuGMkSp4a7zRCTwjsdMWP8SifdUa6bYhJurYx5W4M32nMw9cUntuHJ7dN+n2lSkR/VRA2ws6XIJEfH9Pc0Q5m4VygxQZ64Ixumoe20Fyj62Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+agGZGno06NC/OTlIYxDpcloNpkOoeQll75PHNP6uE=;
 b=NkuE6P1/3ZM0cq9FIVagqnp4UWch6+esliPSxDDFimICGr8/TcYy4VKVsTOXm7se/0bO/PUbEAGaDlXhAa96uDtVLWQCUvGuxAoIwzi0HlNEK+VfIjFsBIFGtz9PlQ54qB8ZI4mf80oizk1iBI/Wqm5lCK2Sa5mJ3Qsgsj9rkIEoTgicMo363dKYw2tRlT1N2QutTuNSXoZsUVVfAVUkctHzAZdB/VSv8jpsoC1gdGtyypF8gUBqxoyUH6q+AaK2LjkHOkRHK/CGDxpwQheg6BsPi6wT3GAyHcCCuidcJ3NQ6+YK8+91Fhk7mn23RJw689EW1YHZI3kiLzL3IsBHxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW3PR12MB4459.namprd12.prod.outlook.com (2603:10b6:303:56::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Mon, 14 Jul
 2025 16:08:25 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Mon, 14 Jul 2025
 16:08:25 +0000
Date: Mon, 14 Jul 2025 13:08:23 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>, qat-linux@intel.com,
	virtualization@lists.linux.dev, Xin Zeng <xin.zeng@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Terrence Xu <terrence.xu@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v2] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20250714160823.GB2067380@nvidia.com>
References: <0-v2-470f044801ef+a887e-vfio_token_jgg@nvidia.com>
 <a8484641-34d9-40bf-af8a-e472afdab0cc@intel.com>
 <20250714142904.GA2059966@nvidia.com>
 <20250714091252.118a4638.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250714091252.118a4638.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0212.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::7) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW3PR12MB4459:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bac5357-2643-4e59-da3a-08ddc2f0a98b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?12c4d3xD6ol7ZXjc2LL2gv6ONyml4Le8NPSIM+tQ11zpicm0DJG1ACZiIUAP?=
 =?us-ascii?Q?YiTp1i6VE3wSwdcpNeQeI3ZhvplVlniPm6Ngq5TMENnsfo/mDTMzUR6RU8gm?=
 =?us-ascii?Q?AupGNKpHMeaO0z613e2yMuLiW8hc9Sn3MASPqQwtXN6Wak78rPYwaz7a17rH?=
 =?us-ascii?Q?zq4gInmKBNNhPdMvQinsJkZCjsmDIgm8F4+9sbzWPExVgy/85hkIELgdDkee?=
 =?us-ascii?Q?n+Xh6/eWBbKxRq+LdOhBW0Z4lGausd4yNqzou+cU/tD9lYH/RVyWqEgq7t89?=
 =?us-ascii?Q?cKuyj3QYyuLMmqRkAtoghvuU+sLbz4kA5a+oL2O1fkTRM2ygTb43CDma/vz7?=
 =?us-ascii?Q?g+jYgV5N8E/FioRy69bBJj+am2M3sp5Mew95IuhGZUR8D77S3zyGt8OuRblK?=
 =?us-ascii?Q?+KNjm3aldUTAB1abgjscHg0PvSV/yHhgfwcX9R3J3lDJsOPoQhDFoLgVH2bL?=
 =?us-ascii?Q?k8qi56w1ZwtZA1LwH+b8AJOWUimwgyvE+ms5QbCXAfwCjNTmnmHJG1oqQASp?=
 =?us-ascii?Q?2R1Z8S7gMogYzt1N50cwgfybEAlcxOloYYmsN7uxr9NTsNVpeEtNSumS/DIn?=
 =?us-ascii?Q?34Wle7FL/jJwOVl6LVL4bc0lIQZ5tg3vkPBbDnA8ZxZad7FtniaytRGRvLQS?=
 =?us-ascii?Q?HlCyGFX2rht5h1/MeSInmQW3kRC7SLQ0X4yWb7YjetjJPZgzrg1NYKiLzhbh?=
 =?us-ascii?Q?A0+rmDKde4vb1T5wDAVsFFq0q7rmo17MyQo6wU0E4wQfsAItBsaP+gY+jmeD?=
 =?us-ascii?Q?rJ5N12bmD5LUpmuypxzjFbJpX+92szvmzwkIGRIMrZJXXkMHqIKHe/PH2dHd?=
 =?us-ascii?Q?UNoxGEI0gx/+1JluhBwR0+/KQ0NYh4kJ+Mz9Oqq6gnIB9v9nJJ2nMs4ZiwiZ?=
 =?us-ascii?Q?QnUxw9pEWMbHQTeE3VPIqHRZxTYnkb+YDQeJgYSgEDwbH3dlloUSTlOR0GQt?=
 =?us-ascii?Q?GV4Ftn/l2QjnIKgcHtGJx3UBPEB3oL3sxQPyK5IatNpqyXSTkbwpCxkZlfOV?=
 =?us-ascii?Q?1eREC5WyWSq/hHvkG9g0WxbEULsLy78ktz2fG2IK/wDl66SIVwoIQSkUVPuV?=
 =?us-ascii?Q?txPzosZGV7kevXLsvKnz4crKf+7Sy1/xXL60/zCIvtQyf7AM9TcAQFX5IdiE?=
 =?us-ascii?Q?FwGm+keu37rJF0r5C0E3ZJgYh2J/U0lqJu0bcrbFMiJdN6dbzRupAoidFlkT?=
 =?us-ascii?Q?2IcOH/UeNOzI2vTCkCtqaxlW45ePkvWBK+gS+IoAKSUEKYijqQtW1O6BWm0f?=
 =?us-ascii?Q?raFWRm/GK3BRA3uKFNWN+oQlioRrpi/7JOuAr7Oi/wq3TCR9DxT8+Qoo08aC?=
 =?us-ascii?Q?sNX/IAnUw6K7X7j3SKSjfKnzPm+g/b5BRloYwKCD1xPUhAqbVhanrT/oMREo?=
 =?us-ascii?Q?AypR+Ua5FUVnjxN1NKttb4lIJpZM9KD9r9LFFjNziEChRt7Q4Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+H9pdushxQCXtKosIAymhnKehoKfbAkyFgECTr3E0+LdQHLjhDaV6Da8Yrcx?=
 =?us-ascii?Q?OIv13umATABU3ecCnbo/ClZ5v2eCedkQiUl+8+O/PWvNxwaPjoGToAA3k7IC?=
 =?us-ascii?Q?KGjTFLN06uEaNcYfO2N8LQY1t5vHYp03024V4eRQoKpXELNvzrwkjDLFmsEE?=
 =?us-ascii?Q?eITSpFq+UCTo8nq58z5NWnmWJ9MWLSpSBwybANGfkJN/r8t/Pi28KZPbvNPf?=
 =?us-ascii?Q?nwdM/oFcBFYaeekS8VYW29hD3ehqn9ZlBAKnQ6Qqch6LBD/RVBDH3vKnIluP?=
 =?us-ascii?Q?rmt+blt+tdYFSte+ZOhqsNXq5iGXJPlpQX2guZszhw1KhfIDulkrN/53YWvn?=
 =?us-ascii?Q?AQ2gMduQ8IrqDkVUAkm4DjAKd/TCy2T4MX58zftPkAD0+YDISAuiXmVJKgMx?=
 =?us-ascii?Q?3QPvOI5YVcQVS3JUc0QbjWjSyzRcJED93cuHnFoELOiAObKEhBqTJgYFiyRh?=
 =?us-ascii?Q?NrKh0MOCMTxqyOOgwFjUQ1oGrmnqATcqoSvvPPyvjhGi39+VIltPvvw+NwN8?=
 =?us-ascii?Q?Z3WvVkEgeZQbPGMPIea2RGVVVqZY55RQJFwG4hKtIEf9KY2BiXN47JYthyek?=
 =?us-ascii?Q?18q0qB3VoCmJsA7t6njqaqv3virtbz8fsR8s9qX76bbLDozEprLaqWa8lukO?=
 =?us-ascii?Q?L6Py9u0yhy2KPjzWVM3mK0lcGtBtLW6hF9DdbyMw6fiHtRUCDG2jD7POP2SV?=
 =?us-ascii?Q?e/eS71i4c9MTw9VF0XxbV049NmYnoaxGV14BM2awvkx+sazuam+xQWQqjAl3?=
 =?us-ascii?Q?vzl8fnrJ0UeaurRJrreAbE59Vj/YX7ddzgzVnEIWAxJrZI/42JpEupjopMip?=
 =?us-ascii?Q?JABEYkzE4DX2j6QeDAOt0HxSJRnUgBGokgIx4Gb6Xum+wjS5RVzwK8GNlpFp?=
 =?us-ascii?Q?kswc89ePEknWmU8Ecd3cWBl9s14m5BhD17HFrF+n6WhRaoMyh57RDfYAlP7Y?=
 =?us-ascii?Q?0Tb0q2sEzn1GlU9i7V6j1dAup7800wNXraOF3TVom7tLBVBnCfGP1A+eJJFL?=
 =?us-ascii?Q?J8597LinXmCpYWLinHw+wZAMzVOmjsWg6xutDwP3KxEjuuh78zRN1ZTCLULS?=
 =?us-ascii?Q?T3C5B3u/0QcCpgko4r3vV8g+U9ihZeZJwY1zJwQrHSzvpasEjuBiT4ZUdGAM?=
 =?us-ascii?Q?xLZruCbgA0TR7+aoG2lIeOWA4NiRJVnMAoe3m6nB4wQW1xhHcsynl+ECtTPR?=
 =?us-ascii?Q?hoEWFClO0CnXBPubEYzNAMIwH4bMaFGVYjtLwfvs5TRN4PLFRGX1cdllMmSs?=
 =?us-ascii?Q?HEMNagzd6UeGOr7dBWK32PGeUodFYpiETq2Zujq6E4OKRHaM37liREUVGu/j?=
 =?us-ascii?Q?/gOcdVYgBg+EyT9SoURrk6JZ+AOGDIrhRhrrc6t2CYxsibUihXPoB2PKgQzk?=
 =?us-ascii?Q?xRlai9KJxUZkT8bdA+2FkuxiqSh/JHBL6/Jwlh3Jq4Wsc531ItRDrjCkMFGf?=
 =?us-ascii?Q?wgspqldBWdAmBF4O7l5fEfj/n1IukN46TrlbEXM+Co1IOkehSd6xjdXiq5va?=
 =?us-ascii?Q?0KpFZs86qJvHPGNH5M/MIoq3lQkdgbTiSceiAv1yTI21OyprsqKrbVoBHorI?=
 =?us-ascii?Q?HSZLj+lRCny/ukiN1rNyOg3f2JnyngED4cNESJVo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bac5357-2643-4e59-da3a-08ddc2f0a98b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 16:08:25.0825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R7CUpLFQ5iw7Ul/snzQ+VhVr4bJuqWXyuvRt/jOSRTL5nHgusZEZF/oE1FX7Av6Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4459

On Mon, Jul 14, 2025 at 09:12:52AM -0600, Alex Williamson wrote:
> On Mon, 14 Jul 2025 11:29:04 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Jul 14, 2025 at 09:12:30PM +0800, Yi Liu wrote:
> > > On 2025/7/10 23:30, Jason Gunthorpe wrote:  
> > > > This was missed during the initial implementation. The VFIO PCI encodes
> > > > the vf_token inside the device name when opening the device from the group
> > > > FD, something like:
> > > > 
> > > >    "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
> > > > 
> > > > This is used to control access to a VF unless there is co-ordination with
> > > > the owner of the PF.
> > > > 
> > > > Since we no longer have a device name, pass the token directly through
> > > > VFIO_DEVICE_BIND_IOMMUFD using an optional field indicated by
> > > > VFIO_DEVICE_BIND_TOKEN.  
> > > 
> > > two nits though I think the code is clear enough :)
> > > 
> > > s/Since we no longer have a device name/Since we no longer have a device
> > > name in the device cdev path/
> > > 
> > > s/VFIO_DEVICE_BIND_TOKEN/VFIO_DEVICE_BIND_FLAG_TOKEN/  
> > 
> > Alex, can you fix this when applying the v3 version?
> 
> Hmm, where's this v3 version?  Did you already send a version with
> Shameer's fix (s/bind.argsz/user_size)?  Lore can't find it.  Thanks,

Hmm! I seems I prepared it and then got called away before I pressed
send. :\

Jason


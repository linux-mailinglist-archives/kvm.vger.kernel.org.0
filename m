Return-Path: <kvm+bounces-57216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6179B51F31
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 19:43:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 836277B6309
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 17:41:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28ECE33438E;
	Wed, 10 Sep 2025 17:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nuKgz0b8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AE1270EDF;
	Wed, 10 Sep 2025 17:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757526189; cv=fail; b=ErEMzafx735zU8/GG2iEQHf5AWFLzQa8IY1AbVcz5DVBgJHyGXOQRO+yeLzSYj2kBBWQyj5i8K7FSKEDX8bZ7toldHDc5S1ItBz/Po3i2rdgPTQTSMRAhpxrq6lLaocZmvCau7qgrd2laPNqfW2opA9XEwQsw/jjUpJs0YjclTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757526189; c=relaxed/simple;
	bh=queIhJ0L30V36YGla6wSwSsnJ+qSRZDuCSRtL1VnwHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QLi0QVbqs+/odZ78AaFSfzonH81jpBtYLlvzHWRJyBSaoel5meLBF56OFLbh+Ev5CusymlUTC9pVRXJaw92bVKRnIiCWx/Wt7DGBKgYLLTgu0I5HXBdMd+nJbpYsjvsuuL/vicRtCSjsmUhhtvOtpBNBs9pWElCSrx/3vxYlHeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nuKgz0b8; arc=fail smtp.client-ip=40.107.94.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=miFSLyMnz537QnRyK+RjiMe2MZPdmYPCscx/0G8SsZNTpkpyXr3CzJnBEj+0YKR/x0mNlnoBLSIWYEUwgba9eXqSjm0tezGKjoXgli8KDOYPOcs95cMWCmm/PRmZhNmvOV2alBHP83Mjbc4SbvtpWU2HpdeWv5/6DMGH8PTHlK0lPYOuix0P1RlhT9WPw5HWCAefbEuLiYhxM6wNSzVoOe+Y0uZvJWl9dyImXBRbCdxz0CTjd+2XFPnxEkF35Bgd7KPyBcoCoq44NXPPnUb9IXfBtdqAXYm7NFxw6fblgUIzr5WYPs9a4PK2NS7/fbmFtbQcigSpoLaDhwLpEVgsow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5eoSG2CnVrJe6mEcXVgAutFjdmwJ1dJvrvu5znyb3Pg=;
 b=ZOSye1Nq6uI01dXsblf5Te/HC+3lVKVTByVXHZK3tp5e7VMeZHdVBnnvnZ6IXvQqnTKsqEYMB9StPZKN3LeNZo2d+3I9d6gfdA6jeOWis79kspR2kvsWlhDn3TrMas5phJml6Kqi74saBS1d6mnzbNLt4gjtwV+RrScWF7s6+ReZsVu1LY7v/An2XvpMxsA7uIz5e148yeJoexdyoi8jOTrq24p19IIj/ST7FwjhgIbOuR7FFMbuJVfob0DqD2zDTRtqGi798gP4dzXMQnCopPVItqk/37a6Jb0FfDkz9Y6vxDncxf5Hy8nziaQsUNbFqcxrfGpLykJp/wMlaLUkLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5eoSG2CnVrJe6mEcXVgAutFjdmwJ1dJvrvu5znyb3Pg=;
 b=nuKgz0b8xzxmWLcBT6qAeUj4xRvXMkyE+q6z4A0sthrsiUYdG7PhawB+6hb5H5TQbW76oJ7j5P2Ekd7njgURsQY2n9FV9fPwAIwmesCQicMH4OzZ8T1ZG14JV5Oq9376xqGURNFwzpyea4DoIk14L97Ggz1dSkpkF8QgjBxDT4RB8kelAHTRuH12B8rMR6J20CXbsAO99yMFuagp6SfL5wRykiuQjbTSqtFllg3BUdiblBpOdhdqKFuCeCAMMoM0Fu+xmcQ/QfIIex3EoqeDmviZfWpEKiueXt5/XUFZ+Hir/zgAqq4egfsqhyG7RP6llti4l6OtM2VH4VCNWzmW2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5769.namprd12.prod.outlook.com (2603:10b6:8:60::6) by
 PH7PR12MB7454.namprd12.prod.outlook.com (2603:10b6:510:20d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 17:43:04 +0000
Received: from DM4PR12MB5769.namprd12.prod.outlook.com
 ([fe80::f5f:6beb:c64a:e1ff]) by DM4PR12MB5769.namprd12.prod.outlook.com
 ([fe80::f5f:6beb:c64a:e1ff%5]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 17:43:04 +0000
Date: Wed, 10 Sep 2025 14:43:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 06/11] iommu: Compute iommu_groups properly for PCIe
 MFDs
Message-ID: <20250910174302.GD922134@nvidia.com>
References: <20250909212457.GA1508122@bhelgaas>
 <15ee1d12-6900-4cf2-9348-6e6cc8aefbe9@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15ee1d12-6900-4cf2-9348-6e6cc8aefbe9@redhat.com>
X-ClientProxiedBy: YT4PR01CA0451.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::17) To DM4PR12MB5769.namprd12.prod.outlook.com
 (2603:10b6:8:60::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5769:EE_|PH7PR12MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: c34a16da-7322-4cf1-fe7a-08ddf0917e92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xu/b6m4mNL6NnDORoHMjXFaBEYgDWqi2qfcYI29LE0lh4rHnECfkVUgKCd29?=
 =?us-ascii?Q?kL/LWXGZI7qsI3DS42rDeYwOXHCxUxZqXxX69lODtJhAuo+8hs81Rw8IQbCe?=
 =?us-ascii?Q?GbOP0/UAn+h1YTIvh3SuLV1XPvM+gXIpv30htiogoFL8rpH7fSQSN/Q9fPdS?=
 =?us-ascii?Q?0b49OF/XXPLimzsiiUiHZRaLCUg5aE2I+YzXPDEqVnEDQvg2PU3IvLaDdw9m?=
 =?us-ascii?Q?08zg9WnxQSlADeVi17DJs3VUh+cd2iUzWq2FmdokB3tdjPX0JgPVMf3WuX2O?=
 =?us-ascii?Q?rvRuV6gScQJx8DTj45+ePucJgPXMLV2JSgJyf3PJoq8NnARvmowZCc0xaON6?=
 =?us-ascii?Q?nspwqrYovE6l7i+ypKBoil4JkG5qX8ANra0Kk/OQgKcpCggjR5UAb1xpg7lJ?=
 =?us-ascii?Q?jeymXjVWhV+Xw8oft8m0s5c1iuW+4MDLP1CONFrKq8a1zQPDxmGNOHQ+YK5Q?=
 =?us-ascii?Q?/BzvWuwUR2MwXGOlxqfEfGL1ql3MPmKW2XpNknBUB4iQ+kZNj23RPgQycEcO?=
 =?us-ascii?Q?h2IcGxwUENOr32WDy3Pby2F8pNOu4ZNQzvcu/PaMhg4Z4cWCq9RGGIkG8xFQ?=
 =?us-ascii?Q?KxeSY/ZttfbE1NR6IE2zQpxirzOe7vJAaCffsd8JCJMNSUFqojbRalHcMsll?=
 =?us-ascii?Q?6vGsob7BHB1NUqFgHB5NX5SLXrpebfZ8jVcjgIY/zGcOvInXgJZJNu6iUFgv?=
 =?us-ascii?Q?p7gIGULBsvGHAmMU+JqZiciaM6WW0JwwY0Z0l6NkWonzv1vp4f3m+WmfOItA?=
 =?us-ascii?Q?0SItHeaF4meI9vyL4dxAKjiSCWEnzKWHveh5OhxamP4f6cWHikLEqCMwkWLX?=
 =?us-ascii?Q?zKp8IRgmI0PGgao0Lj9dDHfGHFaMv3uMkF7TzqJ9O9n7fGi7V6XTdQ+tVjtX?=
 =?us-ascii?Q?slOay+y1PQHPjYxBDb0Ltkcypo+idafbPoDiut4RigHCO0QD3rCPH10Ta5VO?=
 =?us-ascii?Q?OwiUM4aIXRk/negmYd70XZFAU2Dg0VkDouZPMu0uAKroHJLoosLyO8gfLChy?=
 =?us-ascii?Q?omCwx3wp1N+Y6Abmk0GCokqQOAWIdShhpU1jiAyXvNmbIYlq+pJidk/vP343?=
 =?us-ascii?Q?rbz6mD21tAWacp/jHNKuzqdYViEza69zchX6MHOP5Mv8MZXggu7I8zwqADJ5?=
 =?us-ascii?Q?IPX2AanE9sqPYJn25jtFK6AkX07meowE97vMKUXasReUV7NVYpC9g09Vn9aL?=
 =?us-ascii?Q?DDOT/5WnY37IxV8l36yrecrNLdog1KCuWE7zx3kb49YbFKsp6+58+qxfP7sf?=
 =?us-ascii?Q?wVF2K+j85RIkbN1zX1YDF9clX+P/hiJg2x5OFFiA8ocys7rxSr9bLu4OGp4w?=
 =?us-ascii?Q?p8MbuX/60QnmvD6EJQNlnqKeRrikayaesWfR03E9YKdsHn3cyyfvOl9iqtSz?=
 =?us-ascii?Q?Z2jk+JAbhzE6w0Y4JxjAI9SjT/n5wWmLH4gouicy6O68k5QTrYou9uPnSk/t?=
 =?us-ascii?Q?/QCdV1W/yoQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5769.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EeZn7Bxa4eYCBd2R5pen5wX3s07f1Yy9PbapB6WgGHut2Zi+OMcTg93gbY7/?=
 =?us-ascii?Q?WlImeidiEAWvHkAwMiFpp/K/tcFCY2wVQKkW8xiThHJWGKyWM9ki7IlLvX5j?=
 =?us-ascii?Q?O8lBQvvKl9QTizbb52IRIfXNi9fWd5FxFmraFfVy3Yk0UZQbGlw7qEly++wC?=
 =?us-ascii?Q?sWTNpzHPpFezoDyJrAfTmpQ8QrgkbrH76p5dbtErHebjZcmTUe0zwpC3YaUP?=
 =?us-ascii?Q?CpwKrkJE+mPLILH92EisdmipEW07vMFASUU6eSvSVSWGqZoU+7R+BR7wXdcs?=
 =?us-ascii?Q?V0sjbjoiqWdiiaFXmPINA/XJzMkadlmQwgRwEpeBPodnoCZwcDhcwUJkjZIj?=
 =?us-ascii?Q?X2brOtvYxHXwf+4EABh4FMc/ULYuKEnbMRaa8/Wl/iIZ5O1MaXB5ByjL+7c2?=
 =?us-ascii?Q?V2icGxEzoLqkzJIW7y5Y6cJhdcabP6S3ILXbIkz0RV+IaFJi4a0JQu0TUYqb?=
 =?us-ascii?Q?BVpgR43tky7e0Ur6c4pD62xTKkokMgE2EEKfDa58Y7wnmwaZPiDT6VD2BULd?=
 =?us-ascii?Q?Y+Jq52t/eDojpChb2RoIu2JYZocYZgTKkt/K5ZAG+mW4bblBwPvwVnYxDYoe?=
 =?us-ascii?Q?KrzqEJ2hoeITNEPN1a1pc+LvQ9r3GfMh+XwMRsqnQB6Lnwur9VgzyJrEnRdW?=
 =?us-ascii?Q?oUrgDTczvhoaC7QckrJbHxuDTTWE6zzsQg3mtggaAxriZvbNr6+eHFi4Tea2?=
 =?us-ascii?Q?XbMOj56fqiK0miGPKLer01A4Hbkw39xQT19BlzbrhIQjxVEYqjVqbgLccwmE?=
 =?us-ascii?Q?a/d7S7eusUbtJNSxM9KDuxDQVWvMPnvDAkGhox9OwcdMEvEoYFHZ19WAONqn?=
 =?us-ascii?Q?wL87iqfCg65hpAH08fHaBdVHnQRnTSmFZM/gEfL6MHHgDchAYHzDVFjEv7lz?=
 =?us-ascii?Q?ns27nygGg46OK4KTnnvJXpxQb22fzBRGHz0RJ3rjjIvzTtKdr0z8YPZ3ZIBQ?=
 =?us-ascii?Q?gQ02r6NfTOFGmrRkmVcC3JwT9Q9l5IAWX3ebm3ZyQ4LiQXw4QnzkEI9AR8W/?=
 =?us-ascii?Q?TIxJWaOmvqDn5BgE7vct0ZXeuasK/breuAYG5ypi7aafvvAvkXXCPjbin8Pf?=
 =?us-ascii?Q?mZwFqA/5hLL8/DUNkbXclqn4rvqQg/7RvqZTOgQPYT57dnKR+bax0V9eOpvL?=
 =?us-ascii?Q?njetdvpdSWjw/UqcjeBAHKYmIJBKMLi57dPUFwW92YHM3A7pT/w0yqb0uJ25?=
 =?us-ascii?Q?r8QyRL8n3B+XuYG6f/HugWqLifUg+rbENpJYQ/e5i1oPfQAfhJpCVOtHwXs8?=
 =?us-ascii?Q?CDdktGb96Bp7qawwP2YI/a8VGREgVh/0v4Uw7wwY3DL8b+1wnaVhrHDKw9Ds?=
 =?us-ascii?Q?NrJGIrySCvHeo+tFf+24yjImCVhyHACMcBmHrJ7GV15roTlMyTGGJmYQE3D2?=
 =?us-ascii?Q?8+F82rEatq9RZqCtS87KPY+nUW8nGY0Vp1+ynHHZno4w1ZoLf2H5TzVPoxeA?=
 =?us-ascii?Q?lW6TQTTbxOqNsA9DaN3oMWXPLkAcHldRmjDgT6GLh2W0/vLzrb4IqN0/q9J7?=
 =?us-ascii?Q?GBc7F/f5o3aFPu9ChBOVHb0J6EhsRmt1iHTPdNoythlTCbqT/ohUknRqfnJm?=
 =?us-ascii?Q?WlQ5CSMZKC/8I7Z/kYw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c34a16da-7322-4cf1-fe7a-08ddf0917e92
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5769.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 17:43:04.2742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6WDbIUmiewYlq3ni9nA8tB2aUdDwHtQzPbcUHMmx2j6hyNInW/lYZ7YeXOWdMjXo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7454

On Tue, Sep 09, 2025 at 09:59:23PM -0400, Donald Dutile wrote:
> > Alex might remember more, but I kind of suspect the current system of
> > quirks is there because of devices that do internal loopback but have
> > no ACS Capability.
> > 
> and they are quirks b/c ... they violated the spec.... they are suppose
> to have an ACS Cap if they can do internal loopback p2p dma.

It is the reverse

Linux assumed all devices without ACS capability CAN do internal
loopback.

This captures a huge number of real devices that it seems don't
actually do internal loopback.

When people complained, ie for DPDK/etc then quirks saying they don't
do internal loopback were added. But this was never structured or
sensible, I have systems here were LOM E1000 is quirked and a few
generations later it is not quirked. I doubt it suddenly gained
loopback.

That said in doing so a few cases (AMD sound & GPU MFD comes to mind)
were found where the MFD actually does internal loopback.

So here we have to pick the least bad option:

1) Be pessimistic and assume internal loopback exists without ACS Cap
   and expand groups. Quirk devices determined to not have internal
   loopback. (as today, except due to bugs we don't expand the groups
   enough)

2) Be optimistic and assume no internal looback exists without ACS Cap
   and shrink groups. Quirk devices that are determiend to have
   internal loopback. (proposed here)

v2 of this series did my best attempt at #1, and there were too many
regressions because if you fix ACS to actually group the way it is
supposed to the internal MFD loopback pessimism breaks alot of real
systems.

Don pointed to the spec and says there is reasonable language to
assume that if the MFD has internal loopback it must have an ACS
capability.

> I'm assuming the quirks that the current system of quirks impacts the
> groups and/or reachability, such that the quirks are accounted for, and that
> history isn't lost (and we have another regression issue).

In this version effectively the quirks become ignored for iommu
grouping as we don't call the acs functions if there is no acs cap.

Jason


Return-Path: <kvm+bounces-18119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62F578CE61C
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 15:23:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 876F71C21A74
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 13:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA97126F07;
	Fri, 24 May 2024 13:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jgU5yYJF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4EF482D8
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 13:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716556966; cv=fail; b=SR4D0hB4lHZ9USuag7iVMS6xfOehWxX0Kh5E7QClXyaTWQlwM6ZyEmqto7vMrJ4nyybSVAf5Fy59rvQHrKdBxTAv2iZGdO/pPquHIDbgHUvgrKb/90mG8X+jJfXwL2TtIJ1pK9ATJ+7T5yNVt9ehjEjbf3CSGdE9BpSo5V4FBkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716556966; c=relaxed/simple;
	bh=ABpbvogi2piiEeXdoBr/QXJJJfgYmAQfISuc0540RAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KxNkH1PQZgAA5N2qSR9CniyJH2NnwYFQkUd6DFF2TTLZsZccMHA4yS/4BSC8extIl9K7FW+qb426hWYU59ELucCiObYhz+aYeZkCjA1IIek0xLsT7wxzqrJOSYS61RLUIYcpBrYISNG9La7Dl0Rv8jP8CZ7U9uu1A0nn5wuTd2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jgU5yYJF; arc=fail smtp.client-ip=40.107.220.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9suQJIkx000SSY1C8qZaDu6PSAIEwV26J0M4d6KukNpzELhrVxBqNOEG7zvFTMYf0ZIIPD2AxaO1ZjvzeV3sr0jr7hp0TpCRB1kr/v965RvWTUCSQVKZucpXOYkP++0RrUSt3v0RTyLrjqR7XiCPxZk+M361T/m2MRNqchLqXqYImi6nZLHtYG6FVlF40/dn5R4vCutFCKxign3oTt6m1v9QeJMufb6rZiGvsVLsQ6cN+4zKwFAMq3+xQpJ72RKAKi0+qviwa6IEXkwVoK7R66Sjg+AhFSzyxp9Mg6eYmcEnWF3ZKlK9j8yFiBwUGZLkfpFxyo2V2DiuQ7ReYv3Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9KqgvmCSMTsVug6hb2Dt9e2NEgrJ0LKVHd9MP0MuZE=;
 b=MmpgFViO16dg+YbwbHFnCV9SyKWJRUb/0AYG6YBCE7OdgVlki0G4I8yhNrG6n3M/MfqqqET3XcfXTaOt3vzaqvD6wCw/LwB1CflMw6Nw59Ur8OQPraXo5Z7bu67ZOLfxDqh6J6aGsQDzXHfQf0DtuIkFveW+IMEfvD3E/H6054xJjIg1xuNcIsuGP57z/Yt13WHMD6qOtDaR2O00npoE0bQr2U/p5UnUjJFgejI6rfyla0Iveh1au0IKeu/TQihsTTLmcg51lm0BDl+L9d07qg3ssR2jqilN5vlNGRzaqqWR+pD8DKLhmghqdiaZOROW4dd8YTqibVXjoM035aNVIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9KqgvmCSMTsVug6hb2Dt9e2NEgrJ0LKVHd9MP0MuZE=;
 b=jgU5yYJFl0Y47AXyO0yH76Qluzt1XTBHkM1UJKmxuDytpBNO4o9L44sgcai76GiVN9VFxmCbHdglXn1aKtHgVQWOo2ma1/fEGeZlSJDrfk4hQQr9t1QquR7BEVbRu/QXwAXh9TU5klXZZvbmsUOLuUWqDftraByvCqOpwC4XZTxE9j+SpZs6UhDVUxQqvTAbq+Ain0+RcV9v5TJ31VTHRrNpeJo2DzscIMIHQ0ydKZAXFh7nIRJlak/m0/pQTGjN7jyROwXu9vod0fjunfKbiNfXxP8BwIUoL9PaRdW7kUJDkMXwMmb0eVfGmgog4oAVRlDXHhyXapoDZA1l+CI/2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6955.namprd12.prod.outlook.com (2603:10b6:510:1b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Fri, 24 May
 2024 13:22:41 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 13:22:41 +0000
Date: Fri, 24 May 2024 10:22:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Peter Xu <peterx@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
Subject: Re: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <20240524132240.GV20229@nvidia.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
 <20240523195629.218043-3-alex.williamson@redhat.com>
 <Zk/hye296sGU/zwy@yzhao56-desk.sh.intel.com>
 <Zk_j_zVp_0j75Zxr@x1n>
 <BN9PR11MB52764E958E6481A112649B5D8CF52@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52764E958E6481A112649B5D8CF52@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT4PR01CA0262.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10f::26) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6955:EE_
X-MS-Office365-Filtering-Correlation-Id: f3d06a03-4979-4f32-193a-08dc7bf49715
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3scge8/vMJ43GCoYCcNdAFvtjxNK7Vdli+PF95r9jEUD+JwhypJv8IslpZBU?=
 =?us-ascii?Q?APA7OJEbhU/Ev8hhpkLV895UFPfOJP7eKWvhwVR1joq95IPWES536VQN6M4u?=
 =?us-ascii?Q?R2XqcMLfkC3yORvqnnVLEi2SNcwBwBvUap0nR8hfJU9fvS3UGSQ0UjA8j1v6?=
 =?us-ascii?Q?hOM8pYe0njuJiz0cdCsO7bV2S4uo+lntR9ZDaiOjr4i5P9g8eADd3A+vydhy?=
 =?us-ascii?Q?rFF47w7OBGJCSqtqC3l+/AU4XtjVu2ZtfMRunFJdDJKLHoIJLdQEo+0XiIK7?=
 =?us-ascii?Q?zZxkbUF7AmVWY8t/qbB38h7mn/04o1iqxFlc0poHmeKWlmu7uu64OulYnnUx?=
 =?us-ascii?Q?7lSu5B3FBhjsAbCMX/VC63YKk8OuR4y5RBdrne23mYsHw8qYhgQkK4Wd1I2Y?=
 =?us-ascii?Q?0v+30AmHpLi4mjzPj7h99ZxwE7SliftSFYXNXUEm2qlrBFq0ZMHuZGcSCbst?=
 =?us-ascii?Q?mhbG4lnn79mzBBjRMWIgiNd+1F9lkTU0QYpit8YAUQTwPqQ8KURWxVlJv+ru?=
 =?us-ascii?Q?d51GI0TQFYQvFng5SDyskm2aQ8IEZDcNeqHo8iF57rKk2qFlr2Twt+xy4Qzg?=
 =?us-ascii?Q?s/MPFcc2QeMObmvQM7YXtL+yN1iheZByXdcPUo4iDY3pM6AnifYhcqo10ucn?=
 =?us-ascii?Q?DLXoj/SnhDVrHwPG8eko8inOhbH4EndAEFIIfx0XKBaTxIcG3ns6B+1sIXnY?=
 =?us-ascii?Q?U7kyAagCvsvAfcN0wlBc3jprpnj8mRlNPHPgqOGgKPNEOoGs/C1i2uMcIOig?=
 =?us-ascii?Q?2myJBe7JhA2Rm3uxBgF2wNG01r4wJkg2yXKVXG5GOmI+qMksGMqTD17e+8Zu?=
 =?us-ascii?Q?m34v80irJ4Nt0gfDBvmhMgryQAyoKuaqI1nNnyItlMpVY0nzJJtDFTBa0M5I?=
 =?us-ascii?Q?fjEcvgrihldkSIWHcUzf+Y8uZboY9LSpIjfX71kVGvVkIcSDz59spgHseaoW?=
 =?us-ascii?Q?p1Iw0ZRLg0rbJudnkt1JF/caCQUzY2G9oGOpI8RP/u+sXhqq/XeO5BKOdHxS?=
 =?us-ascii?Q?XLNENV9k89gVDIVZZ4f50aQyUHCYUg3fWymF5X6MZN4PnZx33FYW4bLrSizm?=
 =?us-ascii?Q?Sl6d1NMOTOJoUn9K0tqjOZj3bEsdT01Eqw2Cq/rEhv8EZDvT20gOzJlPdS7O?=
 =?us-ascii?Q?xjZjZ2sPTyZEFPHzTWOYbf7LXv3GOZbDSV1+Lmj9EQCO0GNiDD8elj6CVquM?=
 =?us-ascii?Q?wOaxEF4Gm7pf0g00Z9zijqDSjTZnE6y6584eoWk7sjBzkcA7JLhhM47unjNL?=
 =?us-ascii?Q?ATV25j5A9+AMFgO4E8YpujDd/10HNLfCv8oJqXdWXw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dfrP7oj8cYMHiISiWjpXNO1dE/9CXl21wmvsx46Ff3THmNKRJhb3zRWSTaNs?=
 =?us-ascii?Q?jJIurvaVpbw1Swk7u4ckRMMvCLy9MAfQvLLoDOEAR53l61JZvkckJKecSIS2?=
 =?us-ascii?Q?QbLNwVirlXu9Vy9kHDgvFk0R/IqH2InuOOMRLuAFdNlS15+PixsS5IzBOzAz?=
 =?us-ascii?Q?8Nt4l618O2AXezoP+rZrOmzwNRKe64XJbWop23PPg5ewT4O9voOz6cKpyI+e?=
 =?us-ascii?Q?c96PXpG2awxREDpaMVixxWjcA4G0mrkLn65QJyw+KENS+600xgkt/sqzj+5x?=
 =?us-ascii?Q?6xPEA72i3zFYu23EtCLRYZZXRt+ZVkz5yho7iJ7PwBa2xHP0nVXDoRriPSC2?=
 =?us-ascii?Q?L5CH+6KtEeTGxOCARy8a9JgnAwreMW73RZHSxNbhsRsgsk3Yw0+s1bf1MDi9?=
 =?us-ascii?Q?ikbMvRTw2JRO8+3A7Ubv6TKIl8N/hdfnsC+AbFiqw1o33zMFoOMiiJrkhJ2Q?=
 =?us-ascii?Q?R4NSENBVoMI4NfpptKDekW0blk0qBbLlxpjRlqpF99oOzuvAFQAUaRpb1n+W?=
 =?us-ascii?Q?f+xKnZ82F/RPjQf1w5fYcqNT7hCzBFJHDNzK2uPnPIsoY5cS/T8MxhB6CBJ/?=
 =?us-ascii?Q?DaKnOzMceW/Br5nWhIRW8ew5MejKOkSqWnBteBgqbcQKLJacwW83GlsbVaJB?=
 =?us-ascii?Q?4bU5VOvVYugIVaoLHFoYHAYi3VH2r9LXwD5kwD0QGTDsuhn7/jXz/+A4x6A2?=
 =?us-ascii?Q?7eWkbS5qf3fRujPmmvYisCnjOkdtN00mq9AcwQtq1wkxTyxPkwXzgax/Fp8c?=
 =?us-ascii?Q?RgCRUBg4/tfwTzutyc6CDsO91sia+USp+Up1NRNKr5xnHl2q4c800jkuiDfM?=
 =?us-ascii?Q?rcvb8AR+1JHgG2nVoUA3aPNWltl9HkV6ry+m1ugIwfXQFWHEAvzeE6OrNtqT?=
 =?us-ascii?Q?v1dXk1TOuxgaAh8Iw/YwFNLOLPOjfCGLcqxngLcKWfId9TJBfb/0T5RA0Uq+?=
 =?us-ascii?Q?oCBZ4ZGjGjzkAQC4BdwAZMD0uYav94KDAyhJUD3+62nGaYc7R6VtHa8UVziN?=
 =?us-ascii?Q?RJTcEOUodP3nA5aC1ukJjmNAiVE3GYRcSTOnwWVAoE++sn7Ro4kUaA22TEE9?=
 =?us-ascii?Q?vbgwCmIRSNme3unqusTUJxJN9f+geCPPETdjI0ojI75SyHVbX2tyf6F9iYhw?=
 =?us-ascii?Q?lcHHr6S8dxYr4UF+YBTDY7jtnQN9YLnez60IRp/mKjetaPFE5qAeacbG+w36?=
 =?us-ascii?Q?vJTTQyc2DDkRICAg5cuyf7SOKP7l5q7jI0XAgp+C06iQo+K22iPIJE4ulMOn?=
 =?us-ascii?Q?FI/78dJuMN7dzLkqk6czNRlV9s1EXtrur+euw0VUHe9RE5VVpyi8QNfgW2zx?=
 =?us-ascii?Q?zu4hbY32vyKmSjQAxcKQv3HKuxMExSSd9ldS/GrBIwKjPuZxf1h7Qhw8OCd5?=
 =?us-ascii?Q?fzsPd6kBvZW69CCbRE7F867F1F2cDUxd4VnEteqCPifCw4wy/NJeBxgvgiiv?=
 =?us-ascii?Q?qYmvhx7dOL3uJ9mKLvh6XuKEuvL71o3TaCiYQFHixDwT/nNUdlpMwfyur4Hc?=
 =?us-ascii?Q?C/b4fH/DDyqvMiq4OEpdo8X6rnIsI3CUxxHvepkbgTORi0KBW+YxvnC3hxcF?=
 =?us-ascii?Q?/vluFVURbfbhEcD/Ga/RDzqA7QF8zcTG/2AylITa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d06a03-4979-4f32-193a-08dc7bf49715
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 13:22:41.8512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uVpUVSyqoiIkeBiHDJsZfRKqf2XFqOVjevWlW02RZZGB4qFs5ussqC/MAWkFXsCu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6955

On Fri, May 24, 2024 at 08:40:26AM +0000, Tian, Kevin wrote:
> > From: Peter Xu <peterx@redhat.com>
> > Sent: Friday, May 24, 2024 8:49 AM
> > 
> > Hi, Yan,
> > 
> > On Fri, May 24, 2024 at 08:39:37AM +0800, Yan Zhao wrote:
> > > On Thu, May 23, 2024 at 01:56:27PM -0600, Alex Williamson wrote:
> > > > With the vfio device fd tied to the address space of the pseudo fs
> > > > inode, we can use the mm to track all vmas that might be mmap'ing
> > > > device BARs, which removes our vma_list and all the complicated lock
> > > > ordering necessary to manually zap each related vma.
> > > >
> > > > Note that we can no longer store the pfn in vm_pgoff if we want to use
> > > > unmap_mapping_range() to zap a selective portion of the device fd
> > > > corresponding to BAR mappings.
> > > >
> > > > This also converts our mmap fault handler to use vmf_insert_pfn()
> > > Looks vmf_insert_pfn() does not call memtype_reserve() to reserve
> > memory type
> > > for the PFN on x86 as what's done in io_remap_pfn_range().
> > >
> > > Instead, it just calls lookup_memtype() and determine the final prot based
> > on
> > > the result from this lookup, which might not prevent others from reserving
> > the
> > > PFN to other memory types.
> > 
> > I didn't worry too much on others reserving the same pfn range, as that
> > should be the mmio region for this device, and this device should be owned
> > by vfio driver.
> 
> and the earliest point doing memtype_reserve() is here:
> 
> vfio_pci_core_mmap()
> 	vdev->barmap[index] = pci_iomap(pdev, index, 0);
> 
> > 
> > However I share the same question, see:
> > 
> > https://lore.kernel.org/r/20240523223745.395337-2-peterx@redhat.com
> > 
> > So far I think it's not a major issue as VFIO always use UC- mem type, and
> > that's also the default.  But I do also feel like there's something we can
> > do better, and I'll keep you copied too if I'll resend the series.
> > 
> 
> vfio-nvgrace uses WC. But it directly does remap_pfn_range() in its
> nvgrace_gpu_mmap() so not suffering from the issue here.

People keep asking for WC on normal VFIO PCI as well, we shouldn't
rule out, or at least provide a big warning comment what needs to be
fixed to allow it.

Jason


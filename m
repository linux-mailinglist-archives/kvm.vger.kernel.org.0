Return-Path: <kvm+bounces-14813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39E728A729F
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6EC73B2139B
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00F94134405;
	Tue, 16 Apr 2024 17:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QFW1rcgo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AFF1327ED
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 17:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713289825; cv=fail; b=GvB8lZ4sqyybzs3KLafzMdCqHswwqrd05dqK40CqEIc+lMfk7Y5k/Hr/hOXDDF38yNsSDGGeAQ/5HIjNST/ndsXDhwER9bUx7skWltgfG6uWtjL1g4+lZYguYB1CILurR2ZP06gmk2w2kImirSMdgX1a2W7Qa6x2JGNOHmCD6Fs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713289825; c=relaxed/simple;
	bh=ML9NHnFOAtlScCI0XOrCYuji6LDOjnb67g8gdL+Tfhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E/lFt/5SwWpnqvGzVx6ZvFqzEcyjt0rg58CrsNSllbkFaf5pHjVuVP70wn8eWzsEogDZi6oSiEj8OlJDZPsW/IqcYsc7LIApGGyqIhZ34rTtP+tWg3fSjKJxmMNwcrEvFddAEp9E6sKniiHWjwzOuh51ubZTLdZ03xbWz0rRcYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QFW1rcgo; arc=fail smtp.client-ip=40.107.94.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGBQ2ysM0cTDVcaOYQLJcJGIq4dyN5CysLx9VUyAF6Sd4AnhoT910acO0ekbY70lo6XvvAomqcs3EDuFIWZ9Bp6kAR/gfgpNInu6GptPhUyk+LzvGNu50eQ5NFz2yJtANQfVsDWTNgWuGb8Y7GsGenglUKf1SPNgjIvQcSFfaZstpncr+gyuQKusCW7VfEfmiFNCqjsp583tLn5wsJh6SmMB1HobJJCzTv/yDaqdEvbYNer2I322REpgEbwGPW5gaVQ+q6RFIoBY+JgNBVzrissIYK/tUkkZUA0sbWzKSevOMelo17hM9LnbCXk/LVlva6lS10YMKCgcg0NAcmgReA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+SF2tE+rWiViz9qonAhswjOhalHuj7BvF6UlFuj54w=;
 b=YRwMyOcT38iz3/v/ZV0AihJU4e1zNjkG5XxBIvN5mBYodzXL+83YM2x+/CroJT37iM6e6zi95n2lfosD5ac4cE7TGL+PN7pigxQNyDh0/5I0YCvxULbc1Hz5nRacA0W7az4QVD0JiH+fQo8WRAioz/87lvh+euTy6pg3KQtlkoqqpS+ER/LucyYr6dtuFvCgzb36hP2RrBhFuXUvJutOdu0/lTFeaK//jtaS3rnjdCpFTtxNWQx8RmX9iX0Mn0aC/9Q6a6lAJqoF9Mkr//d/3VhzbQV+FB7tZ3g5DzI7FXv1kB1pcDHBQAjGZRSoy8IB21cTgiPg4FCJCpqFPl1YaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+SF2tE+rWiViz9qonAhswjOhalHuj7BvF6UlFuj54w=;
 b=QFW1rcgogvDul51vw5ShS4HWv98FhMDCO+bx9vHWqih9wnIjB2MVTJm529CuFjP41+7BMAAwk0yoKi645YjSZ/Nzl39QXkxy7tKnl0HWSC53RA2CdPwkzHog8ObqBs5hxSn4mYBKPYkrR19tJ/efltjNE6UlUg3/8sCxkKYbmI/4cq64kzjjT3qdWDjyBA0ywQNA8d39NIi3kxwL6FiJ6lgmgsw5mEjxxLeEm5+JvAHRH7qk875Zdqf1f1Of6BZyJeggIY0Jyea0huAKQncYbBbnPuPlouGM9van0dHJsts5ZvD0XtVrbnnxxPlylqW4hnq0kbgnrPRd7UI3Hzub7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ1PR12MB6313.namprd12.prod.outlook.com (2603:10b6:a03:458::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 17:50:20 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 17:50:20 +0000
Date: Tue, 16 Apr 2024 14:50:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240416175018.GJ3637727@nvidia.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SA1P222CA0039.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::12) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ1PR12MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: 54c3d18f-7ee4-4c1e-bc79-08dc5e3daef8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ofVPzFw1iCH3PVc319bofL0iNNNTibB+dpBJ5tTW+7rAlZEZG7Ew+4foSUQHtn/C/qxaEXwqxJurnsGrxwZyf3j8dq7xhHysltqb4lnWpuYeCIEEG4jy1jJVNQHZMeOHNJ6sXddYh/olPS5/oubUhyhuGknfJ+xzpmonPYYe//eL/KmucDdKBP7gOoFoPFc+z7wyaxnkrVHUUMpyZHHBcNyN41+DcKvo6N/CbLu8LREWUinwVcZMcpC7ZnXOzmHrQIR66o09zwNvaooQV+o2j+/LMeyGPPFtuGz1tC5gb6dPxcqv+om6cQtwhB/wUO4x4jwvyeAmIQG2n2uvFyJI3UfQcUzVILHVP13T8NG8UoEm0StlKz3gxtB+itQOSst0+qS9SbhTE8CZYLys8LRbKAeqOJ+3mQzZ43Hx2rf5UIgzcfPF+pcvxRbi/roIhQtVl86ya3gzog/SvaVQnaVGNS/P/jK3+rbYcfnSrwiiV12ggTu4zp8OLgP3DR2nzcSYOrCGxLgm3JJsOoMslEdYA9hDKzYmsbn1FfEV/VKb/6kAc6bxfkhSwUt/fK5fZahqd7vnnlAFfXyBCgu/pd/6Cd++9sPwKhnWeNrLII62VGO3IV9EhrRDvnLvvDlCceLQUVC7e7XBJqoKu4yYL6gn0cpRwQCp+7Dj9QTLMgxDq5I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QNTxqaVGNJwsL1FrclPiQlisSENZ8tveunxTyTytz5IZe5NwQ9aT8vIpgQzZ?=
 =?us-ascii?Q?KvrbW9ongzEWrBVO/f0ud6j9ra00nJE44OABQxD32Ty40zfdxjvW0nlnKmV1?=
 =?us-ascii?Q?ZkDklqnaFgXnAxlSk/U0e3AmlSumB7tNIHd20TgQwsjj/Ub97gIRZqkNXoM/?=
 =?us-ascii?Q?BrEWCuEVMY1/WkoOE+sePSzIKQ1Ykwow8hzp3/SKvCXa53x3Zamng5QSApry?=
 =?us-ascii?Q?NWbrRbRmespCbSoBKj6diOqVst1ZbtaqwQM6CyC25gXnUExyqBxxaPsJebXg?=
 =?us-ascii?Q?yoSSOa3WToZ/qQshQJZyb54kho6YRJvPhVTH2hxh8grl3q++JzBaNQ0Chqvr?=
 =?us-ascii?Q?5u97oAkKxbiAfqEAdTCSGKSZv8KoxHHLCJJ5OxRlBElDjccjDCaLoxVFJ3BU?=
 =?us-ascii?Q?X1O1zGMwW7L+pvOOSdMsrTIePrJDk0DdbjV9pf6uQ+tzfXKEAJR3Ws3ZNDUZ?=
 =?us-ascii?Q?55eJwn3b4Ido78RUYd2XlB/fdV9BhVJn5j+Lyj8rDUCH1MTrLOlfny+AaAO8?=
 =?us-ascii?Q?cXKDr/kjQQjmz1ygqWRxrV8w3LcIvauVoDT67r58rkO/4q3/2sFm2lLUluFX?=
 =?us-ascii?Q?c1AsaHiJSMp7Ck/WDHZbJrypREhStTF0wIzGfy0yDgxC2xsiRakl0KFzZtJA?=
 =?us-ascii?Q?YUfAqVFGiDg/BlwBHNTTU8sBWIZ/CPCSLt2IvO1QA3tIQMSHPI0J8sNWKE+X?=
 =?us-ascii?Q?1t+GI1YvLYLMJ+3EkONmNu1QJsnycuI4xTH5NOn2YBzSCshV4sMCvahoOUt7?=
 =?us-ascii?Q?otJepVnxNGbD8S3wtJgUWiRxQ5KP7uLY9giWPdrsfiE7IO7/VTprXYRxL7PL?=
 =?us-ascii?Q?iWr6OShh419SCW8cqwTnMW9dYXeCYoU704OgZ3Yt8JKloFkA8nw+RZH3MQxD?=
 =?us-ascii?Q?90DqK2oKn3g2xTqAJ1ttXIs/7sOvJunUo1StzdoV6qc9uDphfEcWd/MzJ5OB?=
 =?us-ascii?Q?Z2ynkoZAr9dLyny4GB7P1T73YK+AJbORT4Jq7nxroWbXpF+7+oP0uZAVmXSO?=
 =?us-ascii?Q?gU2RChnE7VrLmchQNUDGxGV8V9AyY9Tl1yS/qS5v1PX+dr6YCW4jKqxKS/DV?=
 =?us-ascii?Q?uHRRCPoRgCCojEudPbwlLr7bPz6JXdH1uJOBYDzq1QtXM98v3X9EtX5nEkDK?=
 =?us-ascii?Q?j7LCZiWSd1eui65bO/+57h3ZVFgGo41wDMoGKK3dTDOKfRx/KFd7LoRt0X5o?=
 =?us-ascii?Q?eiUfHfqCVXMI6abhQEQEK5w6NH4lAnXY6zpTuJrYvjBQWAS7wNggXDsJ2Th6?=
 =?us-ascii?Q?V8k9YfpOfX/+a5P6kUlsdBJ+FjWTvfCqwMTzE7HEY3R7wptpepiH86GyFfdo?=
 =?us-ascii?Q?Zvl6rUI5jUu+V89BBH2pk2+wL6d9NAGBuJ4u8fMBvq6REilGPquwn/qHPzOB?=
 =?us-ascii?Q?fXp0Mv40WJ9Oam2dePHvtXnPvdi3/ozmvIp3yUNNFTMqifLvHE61b44c3rAc?=
 =?us-ascii?Q?d5vA2KB/JIWN/7pabqJI8qaT3sEBxuGCtmy8T9RjwRV2v8VTGLgP259WL0xa?=
 =?us-ascii?Q?Zce8cz9uXSMqMZKTAINCeVVzcOhFrkDXFv8wjhtTZj2Fa25MefXiPjZA3hEr?=
 =?us-ascii?Q?OvmltpKlhMArqilgT0slGG4CpCrihTvC5F7TMme9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c3d18f-7ee4-4c1e-bc79-08dc5e3daef8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 17:50:20.2566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PKgUIEL6Dy7yALb8DWdMwCpmB+86ulMzqyNOd3RKPggiootW/Bt0u+VqQOz8QFpy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6313

On Tue, Apr 16, 2024 at 08:38:50AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Friday, April 12, 2024 4:21 PM
> > 
> > A userspace VMM is supposed to get the details of the device's PASID
> > capability
> > and assemble a virtual PASID capability in a proper offset in the virtual PCI
> > configuration space. While it is still an open on how to get the available
> > offsets. Devices may have hidden bits that are not in the PCI cap chain. For
> > now, there are two options to get the available offsets.[2]
> > 
> > - Report the available offsets via ioctl. This requires device-specific logic
> >   to provide available offsets. e.g., vfio-pci variant driver. Or may the device
> >   provide the available offset by DVSEC.
> > - Store the available offsets in a static table in userspace VMM. VMM gets the
> >   empty offsets from this table.
> > 
> 
> I'm not a fan of requesting a variant driver for every PASID-capable
> VF just for the purpose of reporting a free range in the PCI config space.
> 
> It's easier to do that quirk in userspace.
> 
> But I like Alex's original comment that at least for PF there is no reason
> to hide the offset. there could be a flag+field to communicate it. or 
> if there will be a new variant VF driver for other purposes e.g. migration
> it can certainly fill the field too.

Yes, since this has been such a sticking point can we get a clean
series that just enables it for PF and then come with a solution for
VF?

Jason


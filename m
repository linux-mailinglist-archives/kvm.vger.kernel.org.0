Return-Path: <kvm+bounces-8453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC0D84FADF
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 18:19:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 899D31F27843
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 17:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3D67BB1C;
	Fri,  9 Feb 2024 17:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZhoHGRbi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCBE7603E;
	Fri,  9 Feb 2024 17:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707499150; cv=fail; b=mlitoatWBasWoLz8AbB4ajR+XnTzoni51Pzn56guVP5zuCzHL5Bjk21IvXyUgaJFk2TNnoFZF+EXMRSju+GIPIO7hrP0pApar2JlSpGYDhS7G8SHSUkzeU7s+d8LTM8XC2zcLAYJMQrOPt8m7LyoEZDZ1/J1eMsxNhIP9uguU5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707499150; c=relaxed/simple;
	bh=Y0bTLoiYZv1wCbTQ0nIYW7NvxTjwYhRbe6sCe2qJx+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E5EhERoEmi6p8LWbZ3m/c2IaDzBeqytHf0A6eqdxwk7xXQWs/m+/N7UCOwDcQJuTSgiRRfFvTIgiMmwMe2rkt2PFa3DYiZm+pL6ZBJw70D6uwfuhYACn85MS+/cFsUQ2NS25QpjJ7AdownhNNJ8kH2mAZ/VYZNfjpmigBG2Wlfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZhoHGRbi; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7j5BXq0BOIPpzrOAPGQuqo5rVQzLpuY5LOK/frKWyEelEOKilj4HR3oQDciNWkJNSZj50CVOynSYOweGCk/stmj0SU6/fgxce3YLb9+PBJXUIqmMH+oCUUd0Erob7s9mha/QN8RWrk8K+UVPrbs+dXbNTV/j056lW34x7mvcu0fnJwO3hhVpnUy3lcv/Dp/dt9wjavv3kq4RCWVY470kMWCwPjaYvKCodCvJ013hUzs3q7pSQgEYYohegQp90nqPP2ylLX54KWfu8k353qd4brsNdMlPhym9gPm7jt8h5a1UqPgoYng7RKzWvELCrNxTMK7ElfjEFoVYT1zZsPe9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSenxutTBV5MrDfXDKXXpAiEXcZzCXbjBtSHKKxT56A=;
 b=j91h01pBAzTt49y7UIZKSjGzUvapnTXO2K54F2oDwQktfeHehUm32w+YDHLyjb7v7+WplwpEUx1wKoHXMbiKmrElb14CCullvatxDRAMG9L+dvd7qLhb0qng3KTk8oN+EA0ueXJKYKzpKWFL0RfL2yCvWSilkH+Obg1NWz7XjI1DyKO/QRYMIE0pSIVEMg2s6EUWHqYuX2S8lY11saxjzOKcDEih43T2EO7MY9UTQyRIH8OYXwE0s7nr0oazaonG8zjK92BeijXFcsxcvyHSiD19AZbCwraY1z1fa8+hampAZLhT0duv02qAtxfW21++khVYeenNxfA9p6MMfeH5Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSenxutTBV5MrDfXDKXXpAiEXcZzCXbjBtSHKKxT56A=;
 b=ZhoHGRbiIbgOfbicZ+Gei7XmGC8D8GO6pFh9z8/eS6us7yxcSq0dd5a2VV/Ersgr+TzpufU0WFy6OpZTGswt2OUrBS3mfBFMCllBi2q17WdLK9Ko7/pXAKbAlnstChyIin3vV1b02s8WEnClc4Gi1hyEQ4kCNWRZS61iSgh1waplYdEJIIh84uFFYT4PTMoSxr2wrrdyLCZUZGAwFARPtRCpBoorR7aJYt8mU7M6r811oN276N0lNeGHYzPULoRQmABqIMZ2jsQWNikDb7lYx3NF2r7ZzT9yciafYmHj7E0HzML+New29ATVLJnQz/v36AyG9soKhiO5xDsfU3C0GQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5331.namprd12.prod.outlook.com (2603:10b6:610:d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.10; Fri, 9 Feb
 2024 17:19:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Fri, 9 Feb 2024
 17:19:05 +0000
Date: Fri, 9 Feb 2024 13:19:03 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	"mst@redhat.com" <mst@redhat.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"clg@redhat.com" <clg@redhat.com>,
	"oleksandr@natalenko.name" <oleksandr@natalenko.name>,
	"K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"brett.creeley@amd.com" <brett.creeley@amd.com>,
	"horms@kernel.org" <horms@kernel.org>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v17 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Message-ID: <20240209171903.GQ10476@nvidia.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
 <20240205230123.18981-4-ankita@nvidia.com>
 <BN9PR11MB527666B48A975B7F4304837C8C442@BN9PR11MB5276.namprd11.prod.outlook.com>
 <SA1PR12MB71996EBCA4142458E8BEE367B04B2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20240209085531.73f25a98.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240209085531.73f25a98.alex.williamson@redhat.com>
X-ClientProxiedBy: DM6PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:5:60::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5331:EE_
X-MS-Office365-Filtering-Correlation-Id: 07436d66-d670-4953-d83f-08dc299337a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zkwlKR9iPnN4Tz3jNY+mfq5eTjuy6znrCuYutlKdog6Jk9slxqwWkaXsL7xOTbOTwwRycJFWmrGajpwbZTYGRIQGBXE+u52IxlN5sdE6H8WRVydqzF7f3mCt74HhM69JUTX3jfALi5y1lcHEYioTxM3bNaa1hYaoglfAcUSVL7C5abUx38abbFWc4r4J6H8MFn30gqmX+414eH7eXmeuCpUmjIPLDyMXN7CsHms5x2i3IXP/nrzND6m828AceuzeE8V1lFv9TUtMnqX1BRHKEWrXhB5EdgEANvUn5pVX42RM3IdkRCYPpZhAYUDvlw4zxEKHf35FqGeBoA5xG4tclaxRhe0TVekyK33WaF4QV5brsM4hAl1zxxpYtu9gCtlu+AjiGQodvTMJKdVQv4mhhlbo3K/rHRnlpH9mE+1GVKkvQ5KNP/3Ifilj9slmwbdmQCfR8oRh94lcR5Z2bAdbtYr2PSMjqx0N1MCXqmsocfOuaqf4zTp440V7/92qf22X+RYInYyy4JF7pIJIKpptHoHB5S89xvgvFAY4r3OgaD4oYKdtMK5u9aFJBWP6RGa2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(366004)(396003)(346002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(41300700001)(478600001)(6486002)(6506007)(2616005)(36756003)(6512007)(66476007)(7416002)(66556008)(5660300002)(26005)(1076003)(2906002)(33656002)(66946007)(4744005)(83380400001)(6916009)(8936002)(54906003)(316002)(8676002)(4326008)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nzzoFfUJf5OuSkYef1L/foYzZ8QCRRzDn53mDnhrOg9AFg+3mZvTZCYE1W6O?=
 =?us-ascii?Q?s4Zt38IYILoSlG0vOy/HRxjbmOParNS6rUnz/V4D1vRB5OVhM+jsNKmfWZ2p?=
 =?us-ascii?Q?Kt2Z0LOH72cf7Wo4puinUzLIdx0OrxYoNCWagCVqT5PXhTlYEBvx2w4hQPH3?=
 =?us-ascii?Q?sO9CicWASSDRDWjZwolGyBKgfaLkbGPFhj/2q4+lWVhCjApaxYJMmh12e5e/?=
 =?us-ascii?Q?Iyi4f0mZA9cv5BBaib3yY8TGbLjKWETZURgBHn1dVOTcvoQ7YX1dXD+FF8QL?=
 =?us-ascii?Q?jOkpyLdMoeZ6dfsWzHX0hrso+fW+JitBWpVuxPyUIKibikMaO0vMGyXfY7Rg?=
 =?us-ascii?Q?5nebI1v3MXZBtOGWBH58+4fbHpxdFwtNgry4YGaNkSTtMd85wZCsOYoTqkDa?=
 =?us-ascii?Q?vzfzwIxYlhXQ4zQOOYrnA4yoUiOPJWkgN46AuxKx1lSz4kboU0Xl4rI7QZKU?=
 =?us-ascii?Q?bKBi9SUWJnIxEp1nI7HU3BcKaUXzKiHmmDRLXWX7HJJgrGI3xPf7Pfdtw+tV?=
 =?us-ascii?Q?tC5dHTT+ozjj/HJS+u75lpv364mopLNWdoZnLkZxHJ328JGz2if2bClOEjff?=
 =?us-ascii?Q?z25Q5IOPEb28ge6n+TN3kGqzMpfqS4ha1/6EalY5qlkP1KruoRmo3a8A8DyR?=
 =?us-ascii?Q?al4kWFxZeLyrsrr7P3VdgHcKBOf07nu4KmfJOq+suLwiju1qlMCYc4V93bQP?=
 =?us-ascii?Q?O64RUaru86yDmrUKdLUlOGyxqp4Zpl4JAZXAkh38/wOzAdSh/wZGmz3pR2xj?=
 =?us-ascii?Q?oTITeCIn9lv+/TbTO+wCN498rG8Badu2B9AIhnvly9CeAR9G/cuSQSE/lvSf?=
 =?us-ascii?Q?MujNPxpmEX6wBUSguWY6cEBPYRYgFugZ6aBl0xXNWNCI4oFAyavqVGYYqg/n?=
 =?us-ascii?Q?v7tTAeC8yAyPU2bSNAIFlLlXEupX5QGRe2OzCVWj1IZwBH0o4QcgaRgnZMxS?=
 =?us-ascii?Q?SQigSE0pMyR6FwUNJUrWdOg57QZSo19MnhZihZAiPLBVl0WNOcyUvJPEzrou?=
 =?us-ascii?Q?ut3acVPTA8AalXdKlQWkfuxIflnriPEkF28rwRkxtyTPTEbkpkr97GxX0Cbk?=
 =?us-ascii?Q?LBg9t6MJ9pSGIjXN8X4Ln6xRjgnJlS08f4QNWrWLS7zZak4bcNoQB91e3Qvw?=
 =?us-ascii?Q?S4EYqdktecEBv6RuzZGDl74Y566i8qViQY5UURwjMpTXj8feGq0qwEpMqGmJ?=
 =?us-ascii?Q?MHfDdn4C4mATkevFnzyiQZxPZ80tj0vLldKsr3ZdkGMbkYVZ6aHKFRpvXncX?=
 =?us-ascii?Q?P2JXDm8/wU8jeGKhKc7tlShwyNEEL0M4UG06W/+XBjBnve1pRIxkaXJRRYlm?=
 =?us-ascii?Q?f1jHyJTcXydc6+NxKwAcWrh49/+4Qrhd0ojTvHx5AeSA4eVn4WnEAfCEPQ8K?=
 =?us-ascii?Q?wZxLblhntC7m+7WyMjii1NStSZcYt7U46vYmROgQaHGl3d39xFKuFK+fYAqS?=
 =?us-ascii?Q?EKOjhx4ymRYO9n5x3aXOgF7t/ALs7kZjAV8+gXFftMmZ32rcl/Zl9vHZc+KM?=
 =?us-ascii?Q?0wTjgXrlkusKKVCH6zgeJYiGwS2vbUcMAtJ8GZsIXeDrEwrnGnTHe11z63fz?=
 =?us-ascii?Q?pZ3K7WN6GY57+itFzv92FHR/If1F7H6G7EBUaPak?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07436d66-d670-4953-d83f-08dc299337a5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2024 17:19:05.1551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jklR9EDdA6rQoZvlvwEiWZ67QTeUEXzN3V1NVLNXx1sa2b0xAWeiheyT+3Z/oHD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5331

On Fri, Feb 09, 2024 at 08:55:31AM -0700, Alex Williamson wrote:
> I think Kevin's point is also relative to this latter scenario, in the
> L1 instance of the nvgrace-gpu driver the mmap of the usemem BAR is
> cachable, but in the L2 instance of the driver where we only use the
> vfio-pci-core ops nothing maintains that cachable mapping.  Is that a
> problem?  An uncached mapping on top of a cachable mapping is often
> prone to problems.  

On these CPUs the ARM architecture won't permit it, the L0 level
blocks uncachable using FWB and page table attributes. The VM, no
matter what it does, cannot make the cachable memory uncachable.

Jason


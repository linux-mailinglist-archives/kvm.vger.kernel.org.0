Return-Path: <kvm+bounces-3581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 852848057AD
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 15:44:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A7FB2826D2
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 426F761FD1;
	Tue,  5 Dec 2023 14:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YafkTAn4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14301B2;
	Tue,  5 Dec 2023 06:44:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lf2uDl7v2+25jqKE1tBsuRh033d8BzI6jZlg356ugIJl5T6bFLG6fYf5GgY08BYVBLykOJ1lHaJ2QREptKy10RauInzrg2GoxJlyt4Im3ZowqxbllWmo7/qL/TzXoNECArOwjpe5gjBSIV1qog63dw5C/xm2roaxkRTpfOAv1oJri+zAwRKd+gXKgyVvOhJI/25mvwldm88K5qrzwy3A5l0qjNUXnLzxujHu1/R3oO8Q1injg9Zg8Uct38KKNqk2/ONkiQAhEnacm3BTcJn4mALxaS77Fe9UmWlqtDCYpIKYemyA+7dZXVQdMfVMAwOHhrMu+8cgJ5kNMT2BFWL8DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TDwymX1Q+fEM1Ur8sMOKKWwjot83SnVgw2FjVWCeUxw=;
 b=NicMw5oDXOvJwTc5ShWRiwcbTOAjPvfDpSZU0u2acjPbKfEc1PQN4ntSEDxDAePRYLhjNcJKFdLhTdeaQg5SIFSDiYIobUPVRn0QOZxqlcmzFbtZY5WgMQNJ55uQSjmXRkk4Dv+29t4VZXW9ytHpYEuiC2RYpFWqEIKuKHDcYE0np/PG/mOfDPiWrzzONFbi9HxoJ3TDRQtdgdjZ3lkUqesHn0r9i01EZk3DxYiZVcEYy8YLU4Rh5gYedfB+hJO0KcU9ovwIlcu4740RT8RJCjCVBnVVg+3HBnG+L9R82nGCqUFqSaNmtDH5Isakz382D7Xa33PvVW9KjKdr4QcK0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDwymX1Q+fEM1Ur8sMOKKWwjot83SnVgw2FjVWCeUxw=;
 b=YafkTAn45/NB4q3GSkvNCWYvDYREmI1+0u8F3CBdU8gAcVhk8vsq5Ft9BMl+3nYD8rSI0R/NFqDZm3gq857tRhvmty81R2ES2E4/rTRnM82yabxZtM/6rLCEd1SqEImB52Ti6VT6HM6XPZY8bGq9MVVS+Fmx5BcXyTT0ywglfPzsYLu0AOqk4EaRaD4MNibTw6WY90nyvhs/wr/zKuObIZ0BzexFhycDmroHejagav6GqDJD97cCRNKQr1ENcL56ZgR4+aHaYXM/3IaCyWI8gNAcg6OJZ6Zw6r0EPsFdTjr1ROWsZbCINrLWwUtJP/RN2kQ13BqycX01Qto0n0xwDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5315.namprd12.prod.outlook.com (2603:10b6:610:d6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 14:44:18 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 14:44:17 +0000
Date: Tue, 5 Dec 2023 10:44:17 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <20231205144417.GE2692119@nvidia.com>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
 <ZW81mT4WqKqtLnid@lpieralisi>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW81mT4WqKqtLnid@lpieralisi>
X-ClientProxiedBy: BL1PR13CA0075.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5315:EE_
X-MS-Office365-Filtering-Correlation-Id: b1652f45-1790-4e76-cd37-08dbf5a0a8b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sh4w/mwACMcL9zWNVzSAZicE+sSRDDlnzfOIJWvJl2fdfBVpGfD8Vr9b3cg3zO+8ZhWQtXfGCuBeh0TrdBGlVVrlrk+BepHK1XIQIneU60oNPe0C/HCYxnj2Ix6sxpJM7rApVDLD5U3+02wUsgavo8tMKmY6U8r8Waw71vePn2MLEMMRrwiW0zpKCaSdu4kDr9D1cHbLOfPG1Jzp6lGG9n7VZl9QNhPc6L3H9VehfMY/lWgN0JI01hzxZ0N9ylAnLlk5JYOp781mrmzFND1ItLxL+GldQvdKEE9S2F66jjvAhxv09Y+umRJhFUIIljr3KdPDfBcARh2tiU/UdzzEhuNEsNx6bZngRSoF1zNKxux4Y7hCaB0kA7MlB0aXq9nZrfoujsAFwT0HFasQ/o2g3Hx2dLLPOObAxlf/I+Bq7wLKfIVAIsoSw1oSN4p37BQ0rloa9Zvei/iZyQ+ET0YjWU7LO1YZ72tqI/VheOEUIrBX7JulZh4nN6+Z1jed/XSYbLCLCUBHwlWHQ9WT8E3kWcsCUWAyK27RN3sAiteUsHBIB1B9xGla4BVLr0QraeTlwMEsrjAhCLuxGBE9mZITPhx6IsZHWqy5vtb7uHiehmw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(366004)(136003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(966005)(26005)(478600001)(83380400001)(6486002)(6512007)(6506007)(1076003)(36756003)(2616005)(316002)(66556008)(66476007)(66946007)(6916009)(54906003)(38100700002)(5660300002)(86362001)(4326008)(8936002)(8676002)(2906002)(7416002)(41300700001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3Z07Sj/2JVbzSBNWdjB9O9Ifcf5KKOQBFQhZI2OjQBCcD/ypH4PaU3kZW/ER?=
 =?us-ascii?Q?z1gIgtvt084g4lni8UjSJVEYNs7MNBaS36Y7fI5nYJy7W5Zm54fN+K7ITo8T?=
 =?us-ascii?Q?qZ+I79tySF71U+Oh3AWCJlshP4bcO4juoGxrbEU5exWPG31mMz4SnetFISjD?=
 =?us-ascii?Q?utzAiWGXqy46geZJcdVnAA2XUDm7P2JNWWDPUxSnz2A0PNVFIyWM99n8+Rzh?=
 =?us-ascii?Q?St8sO+BoU7k8iq6kB9Nm/KnAn0DYoW2BpflqQT/3jfMkoAyNcKGOEoB+ySfC?=
 =?us-ascii?Q?oxJfKPqEZlw0TvuTWw2HcZ1UD3LXjUtxmKqGWuj//wuck0jqWERBpBL+enoC?=
 =?us-ascii?Q?nc6sfMlQE2y6XeLNUGlb4HsPqLfGnjmTih+vel3XJj+Nca+q6yRoI3CMTBw2?=
 =?us-ascii?Q?L+OsWWaoC5zg50A3lYs+lyDPtRAnoAoe0viJjZ0iQdjubKeYz99SCpCzLAhP?=
 =?us-ascii?Q?6ScGmnLJtkvrrkSbPNNlRrHW1LzxXV1sN91fbzwaVUO2zkGYX6CfzF3vYlCx?=
 =?us-ascii?Q?QvTUj+ATHNQc7gCWVllaibu8PMGP2ASt2AuSiHcTsEFCXoIbzJdpGz1PT1X4?=
 =?us-ascii?Q?xjIedcJGC0fWSOnZjTTm6+XRWsqxk/fwqXkJqvNJNxb+9dS38QKlZqsunutq?=
 =?us-ascii?Q?1dY2pqfSjU34vuQzpqpCNlA/ds1QNGIbyF8SA+n0EFbw7IdLhP6ormtdk4xr?=
 =?us-ascii?Q?kf8GFILu+m3tLEyG5pKym6Qif3tDmBYDwmY7MrD6oJw/rmY4ntudvpf6sHU0?=
 =?us-ascii?Q?DdcHljDdj8mvpK4OC0zEXf9s0ZSiPFch32dbYsTf0wu59r8DNAoV3DFlqdXo?=
 =?us-ascii?Q?edp0JSBytTH5x2Y4xxqbU2dRWpcpPxrMsgfzzlV3VsWHLCslHyw2t2kImzWK?=
 =?us-ascii?Q?CIZiV/AUnvLfu7dNEbl55UH7C1JarvzOnOVt/Ps97KserTkG9zldFfhvfCj1?=
 =?us-ascii?Q?0+h5Rajn78t84m3eMV+9Zcsf8PB8XSOnI8/elrTeKK78dI/OHjKbvnCqe6A/?=
 =?us-ascii?Q?ghLmRkboff1OMW6KWF2lZc6XPo4Fj1H8gYhomyxkytOLst5LFF7AiY0YnXnB?=
 =?us-ascii?Q?PktdJ5b+ghXRtSjZgfScwGMOrxqIbH+PxauB7q2GovHfUf58Wzgmo5xU/KvK?=
 =?us-ascii?Q?sT+v3FxcLlfJY+wBuK/a1CTLTWFHU8rm+RvrkABiz2xZYcdI1YEsVrOEK3SV?=
 =?us-ascii?Q?UCDhjaJBaQvEUupWHj0lft5cAg/tYtzWxWkvxsdSisOEn+diAXs7/EnbLZ0r?=
 =?us-ascii?Q?dZ4oV5WVVsggCGaFwKIWKbJcfnk/v/VDTQUMsDb6z+M+BXcOB9ps8vkrytqY?=
 =?us-ascii?Q?cxHIw3bjQQY+H7NLlJzxCVsp1Zu+02ZXl2xPhOeftuv+6q9sqaQWncAqtAN4?=
 =?us-ascii?Q?aJEN7L1KVrikuxgIw3zPyCiZwjGl+Tw90Iu1xXSC3m+Dk7rTzzcb0uVmpipo?=
 =?us-ascii?Q?FBF8D8TnERcDFtzDPU8Ml6LGC4GZOaiz9YVYLPz/GQktUUNalPSsxtPHDZmD?=
 =?us-ascii?Q?2Ebu6C34NlAdp3D405naaA9gM8UeWYcbINVy40PwuxCNyRdFqRuxySWJ3mWU?=
 =?us-ascii?Q?Xvz4uuFq5Jiy7NpqMUCwbffA0r1ZJF2FVYnOTMKH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1652f45-1790-4e76-cd37-08dbf5a0a8b2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 14:44:17.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: miXPyv6u1aKOhgkCs50XmdXqkhvqWdU8/Zwt9TcgrYqIaS8zZSY8sIZ9MLHOk9mX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5315

On Tue, Dec 05, 2023 at 03:37:13PM +0100, Lorenzo Pieralisi wrote:
> On Tue, Dec 05, 2023 at 09:05:17AM -0400, Jason Gunthorpe wrote:
> > On Tue, Dec 05, 2023 at 11:40:47AM +0000, Catalin Marinas wrote:
> > > > - Will had unanswered questions in another part of the thread:
> > > > 
> > > >   https://lore.kernel.org/all/20231013092954.GB13524@willie-the-truck/
> > > > 
> > > >   Can someone please help concluding it?
> > > 
> > > Is this about reclaiming the device? I think we concluded that we can't
> > > generalise this beyond PCIe, though not sure there was any formal
> > > statement to that thread. The other point Will had was around stating
> > > in the commit message why we only relax this to Normal NC. I haven't
> > > checked the commit message yet, it needs careful reading ;).
> > 
> > Not quite, we said reclaiming is VFIO's problem and if VFIO can't
> > reliably reclaim a device it shouldn't create it in the first place.
> 
> I think that as far as device reclaiming was concerned the question
> posed was related to memory attributes of transactions for guest
> mappings and the related grouping/ordering with device reset MMIO
> transactions - it was not (or wasn't only) about error containment.

Yes. It is VFIO that issues the reset, it is VFIO that must provide
the ordering under the assumption that NORMAL_NC was used.

Jason


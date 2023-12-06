Return-Path: <kvm+bounces-3654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7355B806427
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 02:31:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEAF11F21743
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 01:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA36010F3;
	Wed,  6 Dec 2023 01:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NZedMS4t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81521AA
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 17:30:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5vA++seuxp/i5xh7bRxVrwAYTWKAlVFjSlFo1RiNNOQZhQb74gpF+BWpa5+GngWx93fnn7k7g8/6VEyzYqYk7PRjCGi+cn0Kp6xZ20RkZh6jFK7KnYuS0mm73obWRvXWL9Yu4ncgmigASbq/Mf4+82+owtcWBOYP+8+vjfXmSOTP3bw0uhKHHMQNdtLl1JrQ01yv/Y3RPwF+OTYh4CVuyxd+8V8Vhr2tS3ByNEkQ2oUa8iTaOMmj+3tKTzta6ztkEg+yxxTlWFb/KeZQiKVxAHaTN2kcoNkqpaeck03SJfQGTuoa9b8iCoNYMuNdgnsJXf5Z03lIPAiz8JxyHQuLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZKVRlPtMnSbCXthrXj6sCe71qmiohhSnAhUOFeg1Oc=;
 b=Ld5Xr53aSUdr19iPvsrosiWhHlA3b6hFoiCsrHzAxQ1iYKcFeLhLS6r/VVXU5yj6uYDSi5CgfiU8+ZRaooyg02pIVGwjQAcOe/G6lJkYYEjPlT2uMl1v+qS7MCxGmyXUGC+WLtRECvvC6isMAqjK4IurRNSHTz8uHQAoEi9ghDy+p7dLxAUx25Le5k4OA1R9gd8b7v1y3zszTF8D9ARbHZv6Pj2qx9x2V6siD4LYQV4ofJ5/GjSqlTR1CsoDkKLRMNEQ43ihnHrfVNEsVwMJsrJxT8eGS5IVwyLq3w0HHfjt3eJOLcQFE+qm5KikNnsHtgAy6wP4MAmc2ss3zXKacQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZKVRlPtMnSbCXthrXj6sCe71qmiohhSnAhUOFeg1Oc=;
 b=NZedMS4tFGZlh5PiOVJsfXJ8G05XqVPYJTfbwwEgqu5h8JQG6IK1908vvX+AjjiTCuhBSQ0EGTnZGU0eHZv/m5QM1RHIvnJkf8EHSSWNBGTlyCkvVFU6j/2B7tNJxxFjPpgOJPd/3llCKZylwlFiYgXF4XFURmq/sgbwYhjBnOdyAwhjVXmNRiyDfQB/FEbJhEUdj0mFYkaZ9DhsjWQZ6VkJUhhGaWziCYugpN72f6qg2tvhuFE5aZSks5RZ/lsM2u/QfZ4XjisJ78lGXkv1eC+wYDluhVAuHErmxDOz9NRQvA381N9dJcoN+tcR4JV3+hzZfr948FTdPb4yJiC3yA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB8092.namprd12.prod.outlook.com (2603:10b6:a03:4ee::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Wed, 6 Dec
 2023 01:30:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 01:30:40 +0000
Date: Tue, 5 Dec 2023 21:30:39 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	jean-philippe <jean-philippe@linaro.org>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, Wenkai Lin <linwenkai6@hisilicon.com>
Subject: Re: [PATCH] iommu/arm-smmu-v3: disable stall for quiet_cd
Message-ID: <20231206013039.GN2692119@nvidia.com>
References: <20231206005727.46150-1-zhangfei.gao@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206005727.46150-1-zhangfei.gao@linaro.org>
X-ClientProxiedBy: BL0PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:207:3c::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB8092:EE_
X-MS-Office365-Filtering-Correlation-Id: a677fd9c-fccd-4228-954b-08dbf5faf4a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uFVcKAPm+OFAyV/u32/MZcTztsl+HwfubmTRRESRzKPMtsLOyL8liVpfqBzGqivcC/q/zyH5/hC6YZJkQ5j/laEsoaXgTtDvAtsm7NnPa6JU2gi3CTPqFihpV/sBQ49oow5CB7vPmCOymMnK6HQ0qzng1zidSOaEmMak0q+44bbpg2NbrG5469Aon5aF1LB5nhAsaAHkRd5M83qKXGzwziyxq4MoVhIDsbNRD32uNOoFf7x3fGYqdSkB7Ke4ofEYVpV7NW9q5Rjc6lVJkkKOsOPcNab0wX8TZ2cB6b+t4Le9aGbCSsS9B7jsTCYyxxRbQ70yC4TrMM5Txy5zC5BV/SLXIoDZOJ5/dnZfIOAp415CJQZkK+7fo8sbuGMhJEbdHBmbx5mITAG+BvDBN9B+hFkvnh5vQQExP3xtiL+Ptxf8/hiye3bd2/9nQQH/Y4gUeOJ9GsR0WVNPL85kqC3YLuZERJksxWOiTwipyhHYo5BDVyQYzv2viehkPSzFeeTe3uxw9C/avH8Fd/QyfZFZlL+RvovZXSOnNjX55k+620x/puBv45UZ/Qo0pQZDvl/D
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(346002)(39860400002)(366004)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(38100700002)(41300700001)(86362001)(33656002)(83380400001)(1076003)(2616005)(6512007)(36756003)(6506007)(2906002)(8936002)(8676002)(6486002)(478600001)(316002)(54906003)(26005)(4326008)(66946007)(5660300002)(66556008)(6916009)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vRoBT6cCtBCETK9toa780eJqKmJjz8WQsg4PF/Rkx29r/QY9bLi6dl5WMqwh?=
 =?us-ascii?Q?QScrSzCPaXpiAZ3AQSEWC9QuS2Fh0kVhFcXIu7bu4S8mqunIfowGTVASFbMT?=
 =?us-ascii?Q?Oq2WEU/FViM/5y8rWKhHmGkjpXd2dGHPc9CULeZ2lmMqiGK/YD0XQ4zzwQ/8?=
 =?us-ascii?Q?bU7mO3At3Zq4BD7mKE61wHFrHHUihgdjCdEVUTn628zpFrA8ukCr9EHAqphR?=
 =?us-ascii?Q?aoiohyz1fQCuiSYIBG4tA97Y0OJmMcWvldMcltSVBOp38jybpW36QRMiH4aM?=
 =?us-ascii?Q?EBvLl+NC+WRKbRrGHhVH2LBMeWROP1w0bTLf5aaFelr5E01XTLGCFZ8w0Uol?=
 =?us-ascii?Q?uth55iMYDFNMBapEKwcyVxV1ShPIGlRLgdBZXo18hE9utNT8CGZ3Zcp8ESan?=
 =?us-ascii?Q?yXPsNmv34jPzbAtcKY+46pKXsdhVe2OHtlJPfPTixSsCys5qQn9PePEFiP8F?=
 =?us-ascii?Q?JUIrRyxD8Ok0nr7ppyCcZW+FP3mfs1Xq+AxiqlOz7kTHvUZROQpizUI8YZai?=
 =?us-ascii?Q?vcv5DdWWGNH4jZ0KlYPgryd61DPSDzNnUmiYIEsVcAWD9TZvViFVFiRFge8G?=
 =?us-ascii?Q?Eek3/LzJ5tHkLZHGOKADssoOJBXdp7TCyEaI8UucRQZtcjkMx0jsYopTCHQO?=
 =?us-ascii?Q?ZvK+9ELQKnAUwqfoMDHZw0pp1WJtFCnPtI0Pzlol6wP9F5QPsLRydz6Q74+V?=
 =?us-ascii?Q?nglCF56iNNrKx+RKz50ptjKabmp8p8fQF2OLXYPXCBsN6PdLxpXrhAS1KtJv?=
 =?us-ascii?Q?lOCN/uZWUVS8HHIhm+MNviE7/kryjJiR2b1Cxsa8/BCL1I5acERqvyXbuzxo?=
 =?us-ascii?Q?Ywv8YDwB+BXFpBkvtz5M3U7Hdg+JE8xlCJ6jAtv49kn3mPRd9DlalewsAUzj?=
 =?us-ascii?Q?rie+UUrT/h3qqaQLM4fgjZwYUVXZwas/aeA6R3CmXTxaPCeuGudnWXPcvpSB?=
 =?us-ascii?Q?0kU40wrPbUg/QIvmScU7GHBlRnaCWOtq7kdbJxLAgEH3E3L+pziJkEgDezdw?=
 =?us-ascii?Q?8T4pYBigcGbONcqFVyqmsoOc4MCnbjcKQaKD5f8XBUH5xFVGl2ayqOniDyfY?=
 =?us-ascii?Q?u7MuASM4OSzgrJFSvh8YaaeP/JfJMI1Y/MwfC13FOUrjy+cMtJLqB+FgVgdu?=
 =?us-ascii?Q?Ym4P/anv03Pshbf7dX/V3+rnZRUqtH12SVZl/+dFqKISAwNzrRmiZcq+tKiU?=
 =?us-ascii?Q?NgsA/F4X19HFQY+FJu2woWGPjmBBLU4X6mlx3OpdKJQPKbQ/oyxpsFYPnJYy?=
 =?us-ascii?Q?v+wgZZAxlsPv+geN+5rzt9ffeyItdJk+wcZUwFcrhrM9EGea6ityflHXACeX?=
 =?us-ascii?Q?nIwGtZCBnKr3kC2OFn54/OeUoB3vPLj0M+PvaviYbfSXji0ea7rZAhBPsWXS?=
 =?us-ascii?Q?xEemyZk4i+rFaVeK352iYTrWUlXckobRo6DrwHloMy02lvAoA2Z5VdViMWM0?=
 =?us-ascii?Q?eirdpiK7mb0sD+fAxKSybtga7US1GgGfC/Y2SsQ03DylhkmFQE4HRGkljMPF?=
 =?us-ascii?Q?y8oKgDmkrFhYSAZ/IjKrssLcKrLlE+frjcyAIBEaomkDear0Vf/gwMZuXYjx?=
 =?us-ascii?Q?mlVb4aPTgmErlzho8TFHsjfa9zNa34DSQx1xSvYe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a677fd9c-fccd-4228-954b-08dbf5faf4a2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 01:30:39.9302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fNAC6b33akEA1g1ilNkU9M2FVSkD61uAXJaR7ng3ZC57uYJPGJqHcvfYHhRx7xBL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8092

On Wed, Dec 06, 2023 at 08:57:27AM +0800, Zhangfei Gao wrote:
> From: Wenkai Lin <linwenkai6@hisilicon.com>
> 
> In the stall model, invalid transactions were expected to be
> stalled and aborted by the IOPF handler.
> 
> However, when killing a test case with a huge amount of data, the
> accelerator streamline can not stop until all data is consumed
> even if the page fault handler reports errors. As a result, the
> kill may take a long time, about 10 seconds with numerous iopf
> interrupts.
> 
> So disable stall for quiet_cd in the non-force stall model, since
> force stall model (STALL_MODEL==0b10) requires CD.S must be 1.

I think this force-stall thing should get a closer look, it doesn't
look completely implemented and what does it mean for, eg, non-SVA
domains attached to the device (as we now support with S2 and soon
with PASID)

The manual says:

0b10 Stall is forced (all faults eligible to stall cause stall),
     STE.S2S and CD.S must be 1.

And there is a note:

 Note: For faulting transactions that are associated with client
 devices that have been configured to stall, but where
 the system has not explicitly advertised the client devices to be
 usable with the stall model, Arm recommends for
 software to expect that events might be recorded with Stall == 0.

Which makes it seem like it isn't actually "force" per-say, but
something else.

I notice the driver never sets STE.S2S, and it isn't entirely clear
what software should even do for a standard non-faulting domain where
non-present means failure? Take the fault event and always respond
with failure? What is the purpose?

Aside from that the change looks OK to me:

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason


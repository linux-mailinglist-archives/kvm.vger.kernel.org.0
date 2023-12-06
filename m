Return-Path: <kvm+bounces-3701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81E75807354
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:06:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36FF7281DD8
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 15:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4535E3EA9C;
	Wed,  6 Dec 2023 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eASVI896"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1229A;
	Wed,  6 Dec 2023 07:06:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0Hoz7VqSRFcoHgO1K2XhapwMecwhvsLrrkNqmvCIVyK68zxw4xpa9CBlsXS3P+JpaCHlOTycUdvakrShKEtuFcpLI07KfjAT+OT9VmO0+D0ggBYanC2TcXzefV0wtRA7yXHb1ngon5Du/Z4XBPqVdjqJ3c5XZH+QSFu+0xfAADbtOEeTxTY2RNdTb3NZKTWuKeSWH4fbF3tW1+k9lVag533oraSbQfNbsm7PdrkuueP/BheDKaMpgshPRNtchE5dxN6gYtZ1SJqWYW5KP+UP3csz2mqwj12KgyMQLWGuH1Rw31Dc6qlqKTxT2TrDBwqlaLzOs0l93AeEN2aqyi8nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NC7UdfGABuNuc3jdOEi6MWbguRxvUvVDi3ALe1OozHw=;
 b=ShnLQX94RIlEzDUxQ8K3DfL9oSYgIzBuHqHWv+DBmqt/YJOH5ManT6UMPm7PiKYFN6kmVQPQDeq4TKGUutlM9lZvnTdI/tbnOar7F2UoNnTRtM4sW3fGaK7nwbsqDbtDvHmOncMeeV58JQoViE+GWBIhZhMX60h31aoiWW0sVIwrSUnFD0gIA/0eaHL/b9EA6Qqy2UvjAu8zndwfj1Ep6dcm4pW+W9o0ghIqGcWkUN/Y23R1QRvt0oiAYsbLjJBLHQJnT4OPgoAmG96ONg2sVJQqrbWKfAyfWLnIuPs+qXbrWxFAyaTqt+h0bfDOEXQHOaWDZ3k9M6DHNRInkiGimw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NC7UdfGABuNuc3jdOEi6MWbguRxvUvVDi3ALe1OozHw=;
 b=eASVI896ZxDVqdVNh9ChL09SQ9o/UtxWN2/8DCokn5XKDWpoY0ArzlY96T7fwnv7uWnflLQmClywhByDq4+WBfBRS5jEJLpzHsMiAzX0JtV0cCZepMgbLIPe+IGswkpzdROymTSaPgKiWEk1C8GD/7zeoJhXWGsAgbGww46seyPEhZKSZ9v8RpC6GAdIrUYYrhElvYAAUf17S1snosdjV1Fs8iXHrscLVjDJEE4jW/k6qhYxoBGT1GYXtOhTDejBhu3p1Y1qYNA3puy4N78jPPQbg2iEKJQTtw8MCMLpYHpbg1hClNawHIk5jbz1MKhclxVzwTzcCBe3ipADL0Eknw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB5816.namprd12.prod.outlook.com (2603:10b6:8:78::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Wed, 6 Dec
 2023 15:05:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 15:05:57 +0000
Date: Wed, 6 Dec 2023 11:05:56 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, lpieralisi@kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <20231206150556.GQ2692119@nvidia.com>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
 <ZW9OSe8Z9gAmM7My@arm.com>
 <20231205164318.GG2692119@nvidia.com>
 <ZW949Tl3VmQfPk0L@arm.com>
 <20231205194822.GL2692119@nvidia.com>
 <ZXCJ3pVbKuHJ3LTz@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXCJ3pVbKuHJ3LTz@arm.com>
X-ClientProxiedBy: BL1PR13CA0186.namprd13.prod.outlook.com
 (2603:10b6:208:2be::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB5816:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f0c161b-0545-49fd-7d85-08dbf66cd986
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nE0NmbkA5pDw/1HT9RYcoRHr2iKD582HTLaQC/biEzRPYeCKHbOfqktLCKsqAkxe4i24aJ16cDZS2m571sN0ZEm7PjTr3JsalkxnEF3N7kSjK1j4aB+kPl9gmdt9UxNseINDvyLyS25b9QGTS0L4ayNpsXQsoxlBK2chYDgDwX4PTyF9/1xCPLRsFepe+BbBemgh7lC91xw9H/P3lERrmiVdznq0q7XXwbP8jB8EHrfe/57sbYuiWxnz0J5855q7jSaRDlhroVmnOzqKAzivLTcu+kESW50HXEA5B0TMNuDsJzhPHKEE6rjbEV76W10an8vRlOSAdSohk170RkCkCRvYaQyjlNpHkOw/nbN7p+N9deNZRgBkvXfEc/b07sp40r2/oLTrMADoVxGpx9zwlNAPiHu9O2orjVI/jVZiLHqCB0NkehY0NNFdOAbt3ZhFLspTYLiDFLkXwzeVlTsWO90YGrDfW6A2edqo+nO4BhD3DPD9lHn3pNW9YB0ZjbtTVrLUlAVhLmsuydoJ18dnGCl81GWDTE0bLGKUSsVNYQkbJ4+H7qFvR3RNyb5MaLuA
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(346002)(376002)(366004)(396003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(5660300002)(6506007)(86362001)(36756003)(8676002)(8936002)(4326008)(41300700001)(33656002)(38100700002)(7416002)(2906002)(6512007)(26005)(83380400001)(1076003)(2616005)(478600001)(316002)(66556008)(66946007)(6916009)(54906003)(66476007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kLC+1oeo4TLaUFGqY5IPaK1oCQuN+nnyVk+5FlHQRexhlYKd84bjyoCXfJpU?=
 =?us-ascii?Q?9JkMQySWZHExPUx2rF4Lema1Q0y7o13QvhctvBxjntrlxyoJNBT846IVnbkz?=
 =?us-ascii?Q?KGiy71zPvKewTsJdNErOkjh4x69iTcOXwmRtzpv07CxFmDE7Ri2uSujGQtGT?=
 =?us-ascii?Q?lHKXGX+Ysm7T05Cudj6cixC4JD0nO/CcbgGKZVFk+T+kgDceaXBJADnaKIyi?=
 =?us-ascii?Q?8+McFFVbOo5AqYZMqvm59/GWIovylGfg/ygsLwBim009PYf1hWThoQKzSJ91?=
 =?us-ascii?Q?K6Y3DRW/PUAV1dp24UXSbLBCWo+rN2rYD09BH+EACPXxlBJYbfCnp/NNrnnY?=
 =?us-ascii?Q?C4cxRnJKLjfdRieRO1mmrEikCWCMfYs4tRBAWdlKpzAmX2OxKqoIsR9rwhNt?=
 =?us-ascii?Q?whvpSPB0jyqcP0+Huurcc9vLFnslAIQAYT7N6I6J+FbmwmG7iN7A0/5zecmv?=
 =?us-ascii?Q?JASI3Q6EIxXm2PQy22EmzFLTrlqJ1vJ9MlZscNpF37BEnK43HaAx9b9DQ+HQ?=
 =?us-ascii?Q?U0qy9X6gB/DG3N5X6bSYDq0N/vhysCP3bsWIBW808W0WzGSAQGzhkAtiB0bl?=
 =?us-ascii?Q?VxUXsH8y01/iLQIKzfH43z+YGeEo4jsLvf/bl5ricwFROEiRfhHvELX3Lpea?=
 =?us-ascii?Q?7KunnJzL3MidsBC/RACfxSfPBiq/WfkN6K90mtMkhdOTk1BkDhNxDpqz6gMc?=
 =?us-ascii?Q?f6qbTOXdzcBYnqbpdJzrq3kiYRxMKfKyqjg1glTTmbwu7uu80P8FVE3all2h?=
 =?us-ascii?Q?5NOGAPmR0UamUd0cCQkpt22B+1BI+7Qy1FcW2MNrBhFsdGKN9PQfRVpGqrG0?=
 =?us-ascii?Q?UE3r6iUI5bTfCgqxsamvOna4CRjI9BtamUJF4SkeBD9kQFQc6W+yFKU1WIPv?=
 =?us-ascii?Q?mj92RZ8+WRg45yn/1od4CB+ULdXbvjOMIJSeua++cyZlh/ViZCw42M2vQyY2?=
 =?us-ascii?Q?bJ2lHHf21qGt64IkaIsmZrohoMt3WpgsacxzI0hwAAAmwag8QnqzHvKEsaMr?=
 =?us-ascii?Q?OQx3dz/s6jfY85IQYLD3zHgxEel0MzOlwEKwN7V9XfxQw3qZaLZVd1BZzznY?=
 =?us-ascii?Q?yZyt4QZ4IM9tNcc18a5+w/mP9gvHagP7ehWUqhOgB2vMZg2+g4sMV3iHNoox?=
 =?us-ascii?Q?yq56eB/rwHolXl1BAEyHdyiExPGcK24hpTRyYAHAh/nDkMYvsdpfTwy6hzv2?=
 =?us-ascii?Q?16FuIPGI5uDN69kzXQOiYc5xsRlJWTefCBjzXSywJrE4Exr268Gn0CklJrVE?=
 =?us-ascii?Q?oC3O/oHqtjFs9zVAhBHAYcA7+DBEpjupbhU/17oiqDAIfyK6tQuhKwK6AH4I?=
 =?us-ascii?Q?sROUUGRf64p+jgWieozq2KFUcfTb7PqCIhNKwbED2oIyRKBnJA1orvZR3guf?=
 =?us-ascii?Q?udPJiNl+eyCkTsfcXE2d4S1rX0D6CVY53RDk9qZWTYEghDriI9HDXRSg3Kcr?=
 =?us-ascii?Q?4a6HkZGMjhhfBCXKpg8NEfa2Xa5fYNMu7ekSMR/vjaTg1dHa8Bae9Kw7vhy7?=
 =?us-ascii?Q?C+mhSGaMN67L1xuV61ClAXhpHIo4Nef64Rtd6o73pvkJkaXsFd4uGeMv47Td?=
 =?us-ascii?Q?gjRi4bEXzRID9WLRI5ON2TmvKHSSig0qB7E8b3Ig?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0c161b-0545-49fd-7d85-08dbf66cd986
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 15:05:57.1507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4z7HUl+FBfEz+aF1H4b5MiGV63kGqlXEJgftgXZMI5AqJyulYWdKQPxBPVOeI8jo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5816

On Wed, Dec 06, 2023 at 02:49:02PM +0000, Catalin Marinas wrote:
> On Tue, Dec 05, 2023 at 03:48:22PM -0400, Jason Gunthorpe wrote:
> > On Tue, Dec 05, 2023 at 07:24:37PM +0000, Catalin Marinas wrote:
> > > On Tue, Dec 05, 2023 at 12:43:18PM -0400, Jason Gunthorpe wrote:
> > > > What if we change vfio-pci to use pgprot_device() like it already
> > > > really should and say the pgprot_noncached() is enforced as
> > > > DEVICE_nGnRnE and pgprot_device() may be DEVICE_nGnRE or NORMAL_NC?
> > > > Would that be acceptable?
> > > 
> > > pgprot_device() needs to stay as Device, otherwise you'd get speculative
> > > reads with potential side-effects.
> > 
> > I do not mean to change pgprot_device() I mean to detect the
> > difference via pgprot_device() vs pgprot_noncached(). They put a
> > different value in the PTE that we can sense. It is very hacky.
> 
> Ah, ok, it does look hacky though (as is the alternative of coming up
> with a new specific pgprot_*() that KVM can treat differently).
> 
> BTW, on those Mellanox devices that require different attributes within
> a BAR, do they have a problem with speculative reads causing
> side-effects? 

Yes. We definitely have had that problem in the past on older
devices. VFIO must map the BAR using pgprot_device/noncached() into
the VMM, no other choice is functionally OK.

Only some pages can safely tolerate speculative reads and the guest
driver knows which they are.

Jason


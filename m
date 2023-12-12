Return-Path: <kvm+bounces-4225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D23380F547
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 19:12:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3259B281FC3
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 18:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EEE97E77B;
	Tue, 12 Dec 2023 18:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LBgE9ACw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73591BD;
	Tue, 12 Dec 2023 10:12:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUYbpxYBd182wJsYYoMkJ2vMykUdKWf05P7ZkbqD8VE8QcGP8x/oIVf/zeCFTgXYVNtUXK5LTDgMOAivEYrWdF50W9h2NtT41uqcfExbQRxrsJLaUOtpp/mwon7AFkwPo4YDeU8e54tqaeQ7eK3nf3T+WvAjP3685wAa9LA2T3KPTIu16b/8zRmimHxuFBKI7srQ/Ayv0hiYGuFNbw8Tnp6868c06h2ZkiraJCl3jf4VZFsvfSnl2lNtDfHUhDQfy/xhP377VevjnODtX19tm+CzuUvWf4u5uiS+C/E4QQIbflD8T/fDzGuY4FsdFzPnGtmnh4IG62XVljmB2FwzPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DsdEjdFGro1jUaUTRB3jpRmIpqJfTbR955de68Nrfyc=;
 b=LrC92Vkp1Wo3FeDLsTQhq/8CiziE1U7+LgF2rOgogxWtseyluizkmdf+M0fgMdRNmJ/0HreVt0eXgU/F47tAStPrSUyo/k+ZHltsv2reFCYQ7PrpmIUfXu1y5FU+FMc33h5vhK4h4aJ52M+2y7cZLJMP9MkVGzejNkm5jP/d21u7HQ1FTZwcHvpNTy0AmreP/xEmhb94rufFqbnqdTvha2N5Qm3xAlpinPxFNIogosFkVR8jUY2kzHZaTH22VpzBee8z09Ez7PTJ3K/Y86x6GuB4S12b2BYBSnowqoX2VXxi+0bdmDroEuelS7w0+kau/sFAfSI+hvlaLg+THSVUeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DsdEjdFGro1jUaUTRB3jpRmIpqJfTbR955de68Nrfyc=;
 b=LBgE9ACwCj2vsqSMjtpj26FkBaPSGUd8vOo2f97yhvp7zp8cEBBuim1iF+ui4QS9TeL2S5N+k6ve1+4stUktgVal/UO0d/DNOGUl6P8M3oTM03n3KUC7XZT0cURnqNU0AkcxkKoURxOTE6Y6ry+lpSk/zJcCfRXQiWEAIwOTeGbqr6K1/4Y+ZxgOXrDW4Eh0s9GlJZw/mfNeTUgCd+Mt2Z8qxXl39KuBHLXGF/DQVvBKFGSbNpDnDdp2rQWJf4nTm1Z/00wY9lTkk5QUpef1gHFTgU/zIn+SXNfqu+nXDQQtXc6NeRDcDLsleWhc53vkCnKDT5kmKok86y4ATRvpNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB8428.namprd12.prod.outlook.com (2603:10b6:510:243::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32; Tue, 12 Dec
 2023 18:11:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7091.022; Tue, 12 Dec 2023
 18:11:57 +0000
Date: Tue, 12 Dec 2023 14:11:56 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	gshan@redhat.com, linux-mm@kvack.org, lpieralisi@kernel.org,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	mochs@nvidia.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/2] kvm: arm64: set io memory s2 pte as normalnc for
 vfio pci devices
Message-ID: <20231212181156.GO3014157@nvidia.com>
References: <20231208164709.23101-1-ankita@nvidia.com>
 <20231208164709.23101-3-ankita@nvidia.com>
 <ZXicemDzXm8NShs1@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXicemDzXm8NShs1@arm.com>
X-ClientProxiedBy: MN2PR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:208:fc::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB8428:EE_
X-MS-Office365-Filtering-Correlation-Id: d3fafca0-d646-4b38-167e-08dbfb3dd430
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hPLN4IERp5q2wZAX2wdRWqMVf+Fk7/Bvtm/y9UODYAPpvHtxcbLM4NZW5aXVCOV/cb4r/6/218onG4WhZxBak8hkX17GXSipbpKXE64hsmWs1BTUB+qg4S3t9+5aL0SDqrVdYJsiaJWgDnNmHSGtD5omH0Zc9dQsIMrwsTDWgK2ePjQ8rnY5xwu158nU59bv4B4ch5AxzwzLm2oNEeyrkToXmZyCdkEgnibFdGnmbAeWlQ5/r/CJLMFDsW47uhZPsH0WHEKKev7cVnuhNBdrp69yQiR09HCGmdqmc+ynCVXfRyn6q+PavV3L5JtSEh6xOt9BS8JaHK4dPt15fx7/4Oe+gJXc5K6V7T9OvrgEr1jx02ijeThl9K2BIrWNJR81ObkplKR6ixrLAtDbyPqg+TIJZXUQ3xtkpkhvLgy48yRvhTIWidqAODC9dqc0hQmbDdq3zPRNNPQnC24hDMtgbARP3OkQbZ/gkXLt38TDfWOd1LzuGcU2gYzPjjcVVTB949cGp1P6ZAnidBt2SJL5GoUD2Bs05juxdbJOrYcInHcKVO6UznX8hQqQHpD32KnG
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(39860400002)(396003)(366004)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(2616005)(1076003)(26005)(83380400001)(33656002)(36756003)(38100700002)(5660300002)(8676002)(316002)(8936002)(4326008)(2906002)(7416002)(86362001)(6512007)(6506007)(66476007)(6916009)(66556008)(66946007)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lY+ljsP3PhtpT/EpVX1ZKQab0bzV4kfOgaErxMjpaqM+y+mB//tsww8slkYC?=
 =?us-ascii?Q?/YryN+gOdI4qJ7siLtRknWGYLBba8O5EfmSW+zEXd0Qc1L3keG3JiJXFmSfK?=
 =?us-ascii?Q?xxeOSIfR0bEGZJfFF8TCdlG4vYPMFgBBLSBcGGlSSOPI11P0mqc6VS0kPDdv?=
 =?us-ascii?Q?U3TPQQG0YO0xmbT+tHUlS3cg2VgMgWASkF0ksdJ/7At4Mffx6/hHsU74bFs2?=
 =?us-ascii?Q?d0tT+59qQOLLGYiGU5w8JwGOiTpRRUPAFsVqKoPNCDIOkYSJWyhjdwqTKeiT?=
 =?us-ascii?Q?t20eIVYfJQbAnKrfkjb8XLw4mi1kS6JDg8JmdPkZ4y1OyAlmPAYRHH9kHJ6b?=
 =?us-ascii?Q?NRkKy2A1gBhd1oY8JjB+MU7m7HQ7ywH5l5BGozVGWMsDiZH0IJmo+Sk6igMD?=
 =?us-ascii?Q?sQPkubIT8ENgDK8sJJ9fM8N4h9/QYVA2WyVy5KfmAFbqlz8+/uEtvYHYydzp?=
 =?us-ascii?Q?/nM1n4zeNw+0hy0X6cEITbgA5hZzVjlhbM4kzSrHdu5mejTjWdGp9Osy5X0L?=
 =?us-ascii?Q?HfB9mWoWd+RDxLQQdIWM4SvQyjO9GlBBga1lNADdN+U/XWgx6gAwc+6ezZdF?=
 =?us-ascii?Q?pSsTovZF5KlmVicqmG5EYlKT8XE76cWjJFxTBXMcFlnZm05UP+CzOavFs3KW?=
 =?us-ascii?Q?2gOwFlunuzn5gZk4/7ejOEEOzkTsfHLH4AEiYLARwyotXNVXh2GKkPdOxKSL?=
 =?us-ascii?Q?g1cCKurXjfYly46m8V4HXFmErGes6EclMCHuiC8CyxiYyronW0Ok+GJngJoC?=
 =?us-ascii?Q?XyYPjiMlL+Ys1x38QDGDlyOoI2v12Im7AoMqv366aIULCZQYvJsz/qsS+k54?=
 =?us-ascii?Q?1HYvhcL37vCFWAsSJRQqtPSbJ3TW+f/sp0ZbB7IUOYmyFDnEQxkarl1tDf7S?=
 =?us-ascii?Q?bvauImFSOpA6sQ+vEVr4ZkIDrGYNb+SALYylcSnXdcSb5QVi9jI4p+h7EyZt?=
 =?us-ascii?Q?DU1X1WKLj61Z8U+AkL12v9/tmC9smeXWdCJr01Lkwzhxqa228AM9v/9nlqbg?=
 =?us-ascii?Q?i1ZdcoS7JRygPZ922SAEvLnflK2/jAO32oI8ECd08hxJIzdRYLhCGkKqOSXC?=
 =?us-ascii?Q?bCN/iFqBAXIeuQE6fo1yPX3xEI1BX9yfO5L/j+iR2XKTHOzb4XlgKsGZw8Gm?=
 =?us-ascii?Q?UGFwH8Ndx7y20DtPvXKYvKEHz2pZxQQSi+kkbpTDN43BDgqtkAU+3Kp/nrhW?=
 =?us-ascii?Q?p7X6JePiqJkhw06Szr76Cgjjvn7i7Sx5pXAFMohSMRWjHFQAtGVYsOVqrkdK?=
 =?us-ascii?Q?eIFMrofFXPFyT95w0ZN0wLUKHn1VDKd5UK82Gr5Piv47IrHggJuYWiEx4f/w?=
 =?us-ascii?Q?Z7fhfcde/+9hJgT533DEjyxDH1kN+3hcT1RhAAsvpvaslcoIT5ki6BMyKWmS?=
 =?us-ascii?Q?CAZP8V+RAKcQQItELXI36j3lWYb5XF426amMOZ2OJIZ/zxIrRUQb9apAbwEU?=
 =?us-ascii?Q?d5fY19ZfMD4kCRTPZMNnSlRGijD8nt5GJAGahG8H3fshgkXA2zyCWMfc+aGB?=
 =?us-ascii?Q?pATNqK3BS8EkrtBXeNxRwqCbXhrv/mcNlgGGLsCTQz0esE738B1MiVdfO0Z/?=
 =?us-ascii?Q?ZcRZC0gT/laouWX/surdnG5ECZRLdH9/o8EOvSsM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3fafca0-d646-4b38-167e-08dbfb3dd430
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2023 18:11:57.5689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9bXSN1XWQUcSUdDFg3DI3BMjBwwQ9lTSMbnpSNQJbgBDOo8vCF3oA2FmClbwkLnJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8428

On Tue, Dec 12, 2023 at 05:46:34PM +0000, Catalin Marinas wrote:
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index a422cc123a2d..8d3c4820c492 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -391,6 +391,13 @@ extern unsigned int kobjsize(const void *objp);
> >  # define VM_UFFD_MINOR		VM_NONE
> >  #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
> >  
> > +#ifdef CONFIG_64BIT
> > +#define VM_VFIO_ALLOW_WC_BIT	39	/* Convey KVM to map S2 NORMAL_NC */
> 
> This comment shouldn't be in the core header file. It knows nothing
> about S2 and Normal-NC, that's arm64 terminology. You can mention
> something like VFIO can use this flag hint that write-combining is
> allowed.

Let's write a comment down here to address both remarks:

 This flag is used to connect VFIO to arch specific KVM code. It
 indicates that the memory under this VMA is safe for use with any
 non-cachable memory type inside KVM. Some VFIO devices, on some
 platforms, are thought to be unsafe and can cause machine crashes if
 KVM does not lock down the memory type.

> should know the implications. There's also an expectation that the
> actual driver (KVM guests) or maybe later DPDK can choose the safe
> non-cacheable or write-combine (Linux terminology) attributes for the
> BAR.

DPDK won't rely on this interface

Thanks,
Jason


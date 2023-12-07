Return-Path: <kvm+bounces-3784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16638807D6F
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 01:56:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E91A1C211CE
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 00:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67A03EA6;
	Thu,  7 Dec 2023 00:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PasUswlR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB75D46
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 16:55:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iA8wuYMY8nRkS8tQ967Me9uott2xgPf/skWm8QTLSFA8FrgxRAYf3A1f5gMWlZy5zvuanbRQFt9+vGuZZoSc8seEtm0hvcVhIznlkYPOcOGzyTGIsyl/70WehogZosLUQoJ3Ao1J5W2uJkYE01NPfvVTteTzafzQfNCrnxGpwndFnQyV9mLLcg0GOjAjcU3mY2in0nV8qWNJaPRsh9jD/Cw3TzFC7UVmWTSzkmsMtsajZzJtsecPfbBaRV36JqqVgazYXjpbcpnHtRQ4yYlR7RJ4HM1YKuSWDKHQ1BaZZPGn+PYemVQCly2BspeuO3/tJw9sxBbDrN5Dftnz6VBk4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=adC4YfgKRjl3DjCNoQUtuZhWaKlp2IWaUwHYz8pSgQM=;
 b=gDi8oivXi9dHVnehFoiUaQZAVMr1XVNqaa2IpNAhiKgayW1lslRshNmNfalvalZwVtPg2tDznYQlGwEpyPbtELR7wxAKabd1ztHKiV3KFUjH3dGyTo4CpVKofhlfMv0xRTfUYwOJgaxbOsnnhODTrczalezwOqxLrzh0O3EAZq1UNPiMiHq0ggBcE1UJYE/lD7o34gxkF5ow5f7rZshqY4TttnGdjsgyqTZP+3oHCfbcl+gIYXwpG4G2qPhF9rTvlir/d5f+w+gnHJa51LND3QUSxB1E8bKGSBNnBdxkiagSjXDVi6eEy5u4pivbxNvs0zvhoAMkGBr4kd1veEqGCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=adC4YfgKRjl3DjCNoQUtuZhWaKlp2IWaUwHYz8pSgQM=;
 b=PasUswlR/Ug4VeXj5k2C+dGorX33x8qhdDUD7+Cvc3fQoP7bL7EA3G0a44t5pAKlzCR1nq+P4IgmGvnHqIp34xcAuKNt4avEW1cmirFzkg/vD909k+6iT1gCZPe+mE0pTDMo8hXkQ2iv853PpgKq4mURK+zDxFOLddoRyZ/17c6xBLWN+JKWRIQ9Pkybq6XfDlB4ljaVGf64SlwU3D6njyPjptHVymhAitHj1MyzNi68C6uNVdFKdYF6Dn+sesMJs8igK2Va6i8B7UsviJ2xludEwnrKktSSjZj2u40KWw4ep0d8nm3CxK0GOv8DDyWc/aGmQMiRSDh4AuuxO1HYKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4243.namprd12.prod.outlook.com (2603:10b6:a03:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Thu, 7 Dec
 2023 00:55:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Thu, 7 Dec 2023
 00:55:54 +0000
Date: Wed, 6 Dec 2023 20:55:53 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, mst@redhat.com, jasowang@redhat.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
	kevin.tian@intel.com, joao.m.martins@oracle.com,
	si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 vfio 7/9] vfio/pci: Expose vfio_pci_core_setup_barmap()
Message-ID: <20231207005553.GE2692119@nvidia.com>
References: <20231206083857.241946-1-yishaih@nvidia.com>
 <20231206083857.241946-8-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206083857.241946-8-yishaih@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0163.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4243:EE_
X-MS-Office365-Filtering-Correlation-Id: 74e2e2b9-fbec-4d7a-0035-08dbf6bf4426
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Nh8juBYos+qaSF2RTa4IzJJTr9vfk9Ya6rLRRBfAUzK5JqTQjV4JlJJi7ggV/nf4lvC/BbRdt2H8a0tmAe2LGZjtqorfoFjbntUQNSbDxiFOSNfp72ehlaHsOI+Mol7FdfOtg42yBqWvDm+Q9rB9+rtr6l+mbrp4vzduQ6bakoWqwwUVxird/XxVxRBvffdQiibqEeMg1ajisqT8vzYD9kDnkQrCibYUsBsxqvcLzwlS2PQCVPdNmV8jeuhu4DBF2LiPKK2+ARHVyLFsV9j3UYSsnJL8o4H39UR+IgKSHgONEdFLJNVLkdlPY2UFYKcurMmedIRUQRO+JRZmtnolZa/Vml+FEL5Sn6CVZ6dLw06OivVdoy3WDxEgfCKIYtwLUMsaZVcdt5R6/17yoG8l5YtqAaDOcB9iIrXhQnpyqLZEvY3uf9PGic4SPIg3GsBKVrGjHFGixjfGBWzq8IxMw26na5DzBD0/ab6pLz64ZeFXztivX7z+Lxqw4a1FUO+3Dzj27g8hxPlY087Qlrn7YVyjOANJGv1ahYZEeOSeq+jXzdBnWtfeg+H6HxnesqvR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(366004)(39860400002)(396003)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(33656002)(4326008)(41300700001)(36756003)(316002)(37006003)(66556008)(86362001)(8676002)(8936002)(6862004)(6486002)(6636002)(66476007)(478600001)(66946007)(4744005)(2906002)(5660300002)(38100700002)(2616005)(26005)(1076003)(6506007)(107886003)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T5jMl6SqzX+vPbzeT6Pf1YdbH3eYX1AUs/ZEMcwN8+l18o90YDzBt/ivNiqa?=
 =?us-ascii?Q?yZrfmUx+blcS+rm9eYtm3gIpxNmpwfWoJi1Z1fPFUL2dUztF+g/o0SBnMmBf?=
 =?us-ascii?Q?BAc77txQB055CXb+S3zoZwjUAWZzIq0FO1T1hm8PUgoY2A1gLeFphC3DQEn3?=
 =?us-ascii?Q?3piFzWg52dxhzxkaddd1mTGs26f9HmsuhM84nK11b3A3w1MiTg1VnAFJg5wU?=
 =?us-ascii?Q?lUAfQeH5nFPuHxA2K1f/Sn+8alHQf1F++HrGI9Kcuyc3puaXCcMwJbUXjCSu?=
 =?us-ascii?Q?nabpzfKj6WirCWWT+r8CO3DST8wSpj0iPJQTtvBL55pEJA+qJDkPJeeAyD/I?=
 =?us-ascii?Q?T3+8Nf812QrTpeo10U766cYzTSCP0O9ukCETjtOMZHDykObxQV1dqlgUYEYC?=
 =?us-ascii?Q?ubB9fyAkRrbWWXwl16XHPT+qj1ojFKYzDsUV7RF6OSGx1px4PvkW7fgaOqYb?=
 =?us-ascii?Q?pfDsHEJoaS3xmc4FbbFMpkHSzjYUnv7bPWsrLwYL//BpjhHDUOGesPndpolR?=
 =?us-ascii?Q?BphlfQzgedpzUPrhhISWi7QAIUv7xAcecRv6fHAYl66KNKrLjAtoPJ0EfBHu?=
 =?us-ascii?Q?YqDrGpW0F5YyLjrSCYLkBjaQk5o8MISTKYdI2jsZEzSMEeWAPzDFIdhJ9Mz/?=
 =?us-ascii?Q?AwC7FJyZSFp68wGfGYEwTfOXz9ct82NZZEIB1M9qmANs6yGOX/4Vl2rdK4t7?=
 =?us-ascii?Q?EiT6JRmFbhi7fP5h09GnTCvMnBW4RGS77qaXkX5oZH/0xIGcx8sQjAJE7P2V?=
 =?us-ascii?Q?hg0Evz3UOd7/EuiGzkbb0hPPKOEtu0LH02kqguROmIG0NJv1ope+m52xLJrD?=
 =?us-ascii?Q?HUDp4z7OVbBj6RBEh6Tz2NQVcp6S4sqKj6IzmOFscjBeFFqbKpGPiWICaxi/?=
 =?us-ascii?Q?FWzVxGUquMenz/GUUnP/N8Qwl4Kd0ZqpmshDIOIPh/YLM/p66/Qvf2yS7HLN?=
 =?us-ascii?Q?jVQ/Kk3kxfZL3BppOvJMJRRw7FANnhDcCvszKHo4h7eXMEEtetMslMjyfiIs?=
 =?us-ascii?Q?w0RC4KIM3OMtcHkrPDOSZCUWRz/i4GrcTft1wZbGnSHIW/izUsHryFsHOyNv?=
 =?us-ascii?Q?h0chNhOtCH2VcTb1hOKmyUxwt25WYyK2FmaxB4jVgMa+2g7rNXoUjQTB8N73?=
 =?us-ascii?Q?Qt9FHCgOjCbFOO6yZGd11FMAlreGksOF5uQcDaRgxShU8zH31fPVkjNfEpWS?=
 =?us-ascii?Q?QVdegqeTS7gbR/MUVACkS1PNh/i+yrp1vSudgucgNLcHSnL/yxc9/FPWiNix?=
 =?us-ascii?Q?fsQwybwGHTdzEdPgGroPOPSRRezFqZiF0tHJMmMMn4JpFVcVg71XKOV+0yUR?=
 =?us-ascii?Q?t1/Mj9RzRf57kAows9UPyDubdvJyDIwLOHKa4sG9j2yAwSXegewQP7Md12Ly?=
 =?us-ascii?Q?5QfUA0rEVxt+mfmvBEz5DHoQtF4NxNMEi3cezuoCU+rCbZV9bvvCCMfkKHO6?=
 =?us-ascii?Q?PLIJdcPzVGr5CR7Lhy4cg4H/EVb/x2qoVQowVz+0FGFardYQlVO3N0mj2sBP?=
 =?us-ascii?Q?520y9Hfxr1wyxfWDfFCLckfHyCi2hxPkjiENdd3syCpiHHBZSr8A2nR88cCv?=
 =?us-ascii?Q?/7+xfb4hgKskrYUQIBVHcqoUsELBjU1W3AmyWo8M?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74e2e2b9-fbec-4d7a-0035-08dbf6bf4426
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 00:55:54.7098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6PuHR0iw3uJVJeDJdG0+fJwmIJ4ksEm5Fl3j5TO0u/1/DF+ozdi00JQB49ZQEEbY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4243

On Wed, Dec 06, 2023 at 10:38:55AM +0200, Yishai Hadas wrote:
> Expose vfio_pci_core_setup_barmap() to be used by drivers.
> 
> This will let drivers to mmap a BAR and re-use it from both vfio and the
> driver when it's applicable.
> 
> This API will be used in the next patches by the vfio/virtio coming
> driver.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_rdwr.c | 7 ++++---
>  include/linux/vfio_pci_core.h    | 1 +
>  2 files changed, 5 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason


Return-Path: <kvm+bounces-62319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B5E60C41131
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 18:42:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 821F74E260A
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 17:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC39336EE5;
	Fri,  7 Nov 2025 17:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q2iOHsvt"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011053.outbound.protection.outlook.com [52.101.62.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC1E3358D2;
	Fri,  7 Nov 2025 17:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762537307; cv=fail; b=MPowDKEmzGGOjzkBVn22IoabHcM5jpIgrATAYKYMjYUT4Diso8qO806xToflszQbiVJGudCulWHRXca3SaKxeenfvCJQqEnNQhGopHGT0J1js894B9Jv3xdeul46moMpLE7D1RsFtwGUqtFPRN0LiKUT06ELyNLoLMYTw8TeRBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762537307; c=relaxed/simple;
	bh=o1XP3Shml8TYxJ5Xij+uE2fEuihxchFPMW0YvuSHwHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DZbP/vlPdDokv49GsIrqMKcFAgixYakEBcwDTaNSeS8Tjc9/6EPFfdO38WbiIfgja1Uel5amLRYwBmaQbqjm9IyaTrFLCdAPNw2Lg7gYDReew+HDQO4IRrjAoLS9KWkd58eKZAH/HBYvHgq2icpF7IoDY6fI3587xYuM0AZplhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q2iOHsvt; arc=fail smtp.client-ip=52.101.62.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yVQjFWXkGLvBHvSvtUsmA+bPeaiyQMQDW7XdnwIWgD5qm694RDrYaLle1o8kM3VTHnzbF6C4TZJO4jdCi1aYqC7v4ngSuDcFzh6u3qV9pjkO1FIK1kNLe3mPEMh8M7ljNZvd5MTgbVTT+fFxbmdxkcYs/OqI48E7hH74aioNau74kXeFSIRMxjuE1EHZgKkKge7vYt54e/lWsg6u5AUrQbVi66kiFHzLQce8BxeYoyMIBZU7RO1r8rJa+UZ0mc0v36qDXiGdGnOkPX1jl4c1Ne5V31LaopDRNqQFm2dCGlq5yb+d4rB93zru3koSU+SOsHW38XqavrLSF4UvSEUZTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zK6hKt+m4p8mBOgeiLqfZ3pViADF5UOxaCs7blQwb0w=;
 b=jNWiuQMuGZfY4B+pvJUPMsJavQ0DW0QuIB6l3n6ivOlVZmCKxIwRciBJmIuxjMmJOgoMhjW6Vv/z2BR2wIBe8oEzc8OBy2soPyKeGyGmUcSX3Ibhpvn6Ws3wh+KHJx6XcSjKFhtmONzSScS300mktUt7absU5dlJUMtHwVfdyWT/gif23kWOKGaFQ4HWPNz5fIYiDhe1y7Lxg2HN3LTgXCgWJDfFwU8h5mUe84HogMJ9hhowiXHGyDz/DoAPVm5gl5i4L0F7hlShhwae6sYwmqTQTaBn/V42AoG3dE+Mu30nOGNjBe0TPSpUnKs/n8uuFLYEfm26E0eXD4r1H4UiAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zK6hKt+m4p8mBOgeiLqfZ3pViADF5UOxaCs7blQwb0w=;
 b=q2iOHsvtFOhwx/vdaH0yMdTriekUn1B6OtBWAKNoUuvQpjllfElF8DbgHbqsghAKxpmRoPi0iopGQeQ+IlUf6NkE/QUrYSS1Q+xEa5M/m8UnIkVmYQ1nN7fI9Uc1t/KDLMsO/RYo3X576AvwXDJJWX/04dCECVYsV8OLaq3xQaV8mpze3ULk4xmV2a2cunqJpI5qNA4f1fx6GxaFoqUog2NT+98h/xVXUqR6r5DPiEbt9ia6EAR78OYGigEr4zkQ78PuUKg3MfKdrAH36Y/rUIeEFgYF3sKLfV0d6AR/2YgopGdrlNJZb0N+oTvPjvUoDCA5CW/IWlkXFsak47Dpuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by PH7PR12MB8826.namprd12.prod.outlook.com (2603:10b6:510:26a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 17:41:40 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9298.006; Fri, 7 Nov 2025
 17:41:40 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
	David Airlie <airlied@gmail.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Brett Creeley <brett.creeley@amd.com>,
	dri-devel@lists.freedesktop.org,
	Eric Auger <eric.auger@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	intel-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	kvm@vger.kernel.org,
	Kirti Wankhede <kwankhede@nvidia.com>,
	linux-s390@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	qat-linux@intel.com,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Simona Vetter <simona@ffwll.ch>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	virtualization@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 07/22] vfio/mdpy: Provide a get_region_info op
Date: Fri,  7 Nov 2025 13:41:23 -0400
Message-ID: <7-v2-2a9e24d62f1b+e10a-vfio_get_region_info_op_jgg@nvidia.com>
In-Reply-To: <0-v2-2a9e24d62f1b+e10a-vfio_get_region_info_op_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0352.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::27) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|PH7PR12MB8826:EE_
X-MS-Office365-Filtering-Correlation-Id: 4db0a713-5a5f-40b1-6c20-08de1e24e833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tunOKxsL+PZvI9JqQ7MzHOlEzct6y8vswBLiAx1A8NgfQvGodBssQNmIQ9Bf?=
 =?us-ascii?Q?64SlEr5lFUZFDrUISquEAMQYiLuBTo+Xx6vWrgaQoKWdwiuwYFRrSAN/5qEV?=
 =?us-ascii?Q?8XoBMZAI1DZ9Imi6Xo12JwgKl4aD6b9mPTzK5RO6YzqXC0b4p0JZZqCf/CTd?=
 =?us-ascii?Q?FlraQkWiG2C5nLhFeMVLfKhmNJNM/48IIkS7ZITfUqizsl6FlV1PTrCza9Om?=
 =?us-ascii?Q?alPpESqjJXOSN7lBPD1zZlg1qrGsSCcaXkPCg1GuoXNH2kEwz2qXSIpkbWnx?=
 =?us-ascii?Q?V+rYMulCsdH5THl08/ETYLhFwcnX2QFr9JUUp/D7rty3OjOIXh+2ZXVEikLW?=
 =?us-ascii?Q?fAnbizy/MtJNmRLcULgsLDz/ZTT9KZuNKs0uIdiYKFqPmCfQBHxIlThDXoza?=
 =?us-ascii?Q?oeu/IPVgUsR82p14ex6tQzboOS+c9SDckwnGGO/t7c/0kmJz9VLsvGpcd3fu?=
 =?us-ascii?Q?n8nrKigiPqRNmjUFc/hsN8QB1+SQPwsEHLrW/zV+aWZjQ7AzmMxDRoXChDGG?=
 =?us-ascii?Q?Rls/p9hc+CdVkba7kS+4fJlxXI4/SUXDeSctWijIcNNAjvhZjgT0denLDgN9?=
 =?us-ascii?Q?OfoxyMJSb0QJ3q4sp/kMt3iJZ6CPe/FMkFagu4q4X58gQU+FzjsG9/JKMz6m?=
 =?us-ascii?Q?QAP0G6L/JRjnAWZJBpkMjVRyTl5NcvH6Dq3UVTgEcSVvew4vTOS9zutGH6m1?=
 =?us-ascii?Q?saZteXs6WOEricArKargS7BrWxfGzgrd6iBQWCqH56sJJPeFYYi1t9j7ExHP?=
 =?us-ascii?Q?98d0LUs96EGHJLlK2AQ3Ndzfkxh8NRyssHd95lFTfLrxAFsJQzUrE2sawc+9?=
 =?us-ascii?Q?1HTdHNH+a9yU8LAkNooZJVwkj3oZMtGmTqx6nFq+cNGH73lTFehAKLP5Xh9n?=
 =?us-ascii?Q?l8CRIFi+OCi8pG54JFlmnFPKJX9RR+teu/+kTifitju/9FBZGtMImtQAzdF8?=
 =?us-ascii?Q?bs+fxVqiRBFbrQ3IAOX+w6KSUsgYDmkqwDVl2txaWP2ByCx86In9dJIHOb+p?=
 =?us-ascii?Q?uYywHjZIQjluk5dOdN8lFkcO9KXxZtuVZDtZmZ7uTl0Nml6zRAuTFOpC4yFo?=
 =?us-ascii?Q?wW32s9EzknoWHJqa9q5aPgY1nUKquYITE3s5RYEJcQo1FdeEn4ogMXI8TUYU?=
 =?us-ascii?Q?oUhOd+dpFahwaooP0jm+ymwXr0mxVwTK89aFRMJgUnY3oGHAouOuLv9UdPXy?=
 =?us-ascii?Q?42fv4dzqQeD7RhnaVfMXoQAjv2AdlERcCvWBRTRH8AE9vcisfCL9g2qN9fNQ?=
 =?us-ascii?Q?hy7Bc5mQo+Q+2bf3SZYGja2DHLrlc8OjiTO5S8O1GLj3OpYGpMX+mykpGj21?=
 =?us-ascii?Q?vObaodz/5w4wO30kIb1GMmW6wq2cSHBrOg+32RzdOOD/TsrW58Vo7qTVAcIF?=
 =?us-ascii?Q?B39ww16dK6MhkyWFZJCzYuHTdqpVryC2agiktQprOPY3KcaNLIZLmHV+QaiD?=
 =?us-ascii?Q?nNhyv7JgMR3Vl0NgxAsLLIE/gUkziulLnpsPvU72MobqGBr/zzINTt1cwP7C?=
 =?us-ascii?Q?r4dziyrfspySYVs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NhQtgknT/cwMHYilU5KBLc8EQZEyFp+gd+4sMNKmt989zlED0xoOrEtATcul?=
 =?us-ascii?Q?Tl8HmoVPkGj+GzksbkMvUWHklnE3wER1G0f+b60LMGVggqcVLTRxDSVjPnEV?=
 =?us-ascii?Q?4s1+g0Se8Elo2sXS8AAy8uAQ4LOnWS/UEMTvKYEGrAsVXcdjh87dDaABoM/b?=
 =?us-ascii?Q?JESEYOn1KXAJKLLCoy//HVeGR3KUgmmNxdBJS5Cwp3nPoJKnp4DCSBp3+t9d?=
 =?us-ascii?Q?HK9UwOueuJCTrsOGv4GaK8MQ3X/9iqxPTEiyvb6YzmB6wN0CMAUgreFhp9i+?=
 =?us-ascii?Q?yVushs0szD1irkuWD3J5883dmA9Z+TmT/7M2X+2w5SiXZfMlPHSIGqvGxHCU?=
 =?us-ascii?Q?idKyXlnWZOr1usnb9qqI23hZGY5oNeuCmXK2sLybV20FGTu0srBvL0QVF/bK?=
 =?us-ascii?Q?ad4MkN3Bfpo+IXWL7R+X1ShHLPhn33zYzWKn0g14aeRgtxBToDFvOfi5WIt/?=
 =?us-ascii?Q?muFfMHlsVJCWLbvVgIvCCZHUy5P9zHPj3DQtpN0l1PeNh2DRsn/t8Etg0kBV?=
 =?us-ascii?Q?bZtZRs2fU9N14vOD3jdd9B9tCucjhE8RA6CC8fq8TqdsuahRrvvw/VIXhR4r?=
 =?us-ascii?Q?muhni4OP1BpHvRA4wYyrzWvyBsV38a5jF/xkoC+eq1qOvOUv/TEViLedP4PD?=
 =?us-ascii?Q?cW1pqI+FOqmvP3zYnrW2SUoSm16F1RUxUMKarMHyYTgDFsEji8fyB+nPyQVZ?=
 =?us-ascii?Q?l0DGLrLGrYY3dx6vierAAdvas7eYxZSbvJ0moz1iW93Dz7sdouTFxqflIveX?=
 =?us-ascii?Q?52R91VbLxIVVXl4pFJY2+qPoykgwXqPYzEW/SHFx8HKogFidNRjpkoFZUdIA?=
 =?us-ascii?Q?K9apo61PMzwKrNuHyLg6ZlFceet3paUqZFFFQlXFwYb/Ca77+bofc/J86f9m?=
 =?us-ascii?Q?HINdK8VyOjCRyVUMzDtwZjeNabfNrUKHkSv0rQT6L1FOh0bBT6Xoj5apGLkW?=
 =?us-ascii?Q?E0Sy5UaM+Hxa+rgfTAjZ2jCqqfNTCVnDdg/SekoROTBzOKc/HV33fGPe1Lnx?=
 =?us-ascii?Q?XAj55LbT0BlcWd8IriQk5JhA6IUsfDfktMM9s2PxXrFXXbELeRdGnOp5v2Cf?=
 =?us-ascii?Q?JpYuOrmsRgoQBTEXPM0+CICtXQDoy0VpFLgq1U8EeSzhJnWwnKfvS4EINgLP?=
 =?us-ascii?Q?nVl5vUxxsS+fsp46DLBmNthUJ2IoxzKKEbNForFuGhhpOIFHm2Jg1BfnPm8c?=
 =?us-ascii?Q?1crqW0mW55gC1k1AOGH3rVQBEYfWs2JMp3I83MsGMAmqqvtOQ24fq/S4TZZ7?=
 =?us-ascii?Q?TbqGe2MwDq2Sc/O+KcXpQwxcbEPmVPIqUmwhOw8aan+mUs7sUZakZZd7ZmSU?=
 =?us-ascii?Q?mxWuht2VjfgG97F/3w6m3wPA6qmVeDpRTWJKdBBFtXkcWuofyzoEUb+VyPWl?=
 =?us-ascii?Q?sbodce/CF7o1WoIN81hHR0vlhM1n2z5ulZrWkxvsN4EtSo1LVJxxl1XxpPoi?=
 =?us-ascii?Q?xqmuFxCArPvZGHeCYf9rovtpK2U+WMiSii1OJHaW5ie2+x02JSUcMSZVUZAw?=
 =?us-ascii?Q?Gb3sM+TJ3MthbTTpZkv/ZtoAizBZlI+HTESKeTPYkjKfkCxCGjklV1SmEIqc?=
 =?us-ascii?Q?MwBmE53oWJiW9PSuF/4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db0a713-5a5f-40b1-6c20-08de1e24e833
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 17:41:39.9502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TFz1eVNpW/ffO1zvmztW7vWBMbJ6vG7tjeVqM8Bx+pzffhJmebKx2NN90mwPYPDq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8826

Move it out of mdpy_ioctl() and re-indent it.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mdpy.c | 53 ++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 8104831ae125be..0c65ed22173862 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -512,6 +512,34 @@ static int mdpy_query_gfx_plane(struct mdev_state *mdev_state,
 	return 0;
 }
 
+static int mdpy_ioctl_get_region_info(struct vfio_device *vdev,
+				      struct vfio_region_info __user *arg)
+{
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
+	struct vfio_region_info info;
+	void *cap_type = NULL;
+	u16 cap_type_id = 0;
+	unsigned long minsz;
+	int ret;
+
+	minsz = offsetofend(struct vfio_region_info, offset);
+
+	if (copy_from_user(&info, arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	ret = mdpy_get_region_info(mdev_state, &info, &cap_type_id, &cap_type);
+	if (ret)
+		return ret;
+
+	if (copy_to_user(arg, &info, minsz))
+		return -EFAULT;
+	return 0;
+}
+
 static long mdpy_ioctl(struct vfio_device *vdev, unsigned int cmd,
 		       unsigned long arg)
 {
@@ -544,30 +572,6 @@ static long mdpy_ioctl(struct vfio_device *vdev, unsigned int cmd,
 
 		return 0;
 	}
-	case VFIO_DEVICE_GET_REGION_INFO:
-	{
-		struct vfio_region_info info;
-		u16 cap_type_id = 0;
-		void *cap_type = NULL;
-
-		minsz = offsetofend(struct vfio_region_info, offset);
-
-		if (copy_from_user(&info, (void __user *)arg, minsz))
-			return -EFAULT;
-
-		if (info.argsz < minsz)
-			return -EINVAL;
-
-		ret = mdpy_get_region_info(mdev_state, &info, &cap_type_id,
-					   &cap_type);
-		if (ret)
-			return ret;
-
-		if (copy_to_user((void __user *)arg, &info, minsz))
-			return -EFAULT;
-
-		return 0;
-	}
 
 	case VFIO_DEVICE_GET_IRQ_INFO:
 	{
@@ -665,6 +669,7 @@ static const struct vfio_device_ops mdpy_dev_ops = {
 	.read = mdpy_read,
 	.write = mdpy_write,
 	.ioctl = mdpy_ioctl,
+	.get_region_info = mdpy_ioctl_get_region_info,
 	.mmap = mdpy_mmap,
 	.bind_iommufd	= vfio_iommufd_emulated_bind,
 	.unbind_iommufd	= vfio_iommufd_emulated_unbind,
-- 
2.43.0



Return-Path: <kvm+bounces-62325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91EB5C411DF
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 18:43:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 541EC3A5572
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 17:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A81533A01C;
	Fri,  7 Nov 2025 17:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LsoTiY/s"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011053.outbound.protection.outlook.com [52.101.62.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32093385B1;
	Fri,  7 Nov 2025 17:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762537314; cv=fail; b=LKW35E9twZiOSC4oJBRFP/28W+WjJz9aZEe/VPu3z6Nl1YntgD4FccQ+xtLqqnp19p20m7moZEgBKrO8o4gloWfKCgAUiaysRxjXzuUTfGCMoI2SG11jQqYo4Q+QU2VCWMGnqC25dPSNecAt/3XMW90mydk7yJqXV1uZqC9Tw7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762537314; c=relaxed/simple;
	bh=jz7+rhdeI8KmZHA+R2VWgOuWcNLDELG4//A94J8P5KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eZqWLiNN61hv8zF0KhZnCqWGlc2FcjlbrQHgiRR68ejH7dimBTEcFC0xifVr+EHftnBehfX8SMRQu6MqIUKkBJ48MXzvLl+32k8SK/kquCKfiz83iH/zbgQSjh5KzTmMJnOrIuF1WZz3Npc147ljgcR9+IMh0Y0jscj9MJo9jiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LsoTiY/s; arc=fail smtp.client-ip=52.101.62.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=clHXMgw1UbZDy0SDKSmlrjJPdWHFIYuqzwEMRCblE2nEFygZtj3Q/okZeQR4EnN7uVtf45fsuJzS4fMmnDUdLrkzUIbY7oSM2tWhE9+91MQBCaAY2fi5P/2CZAjXaxxKOWuhpOSDtLzKG+T8K5rR9KyrRT6QwSKnqK2gxDm2mZLqDeHFuRMnLQkA/dyybE8L2fogqOo3U1/IAA0DyS3dfhtgqV4VqJvy3hEanDyxPCJKBw2cAVcsIL+hb48MO0E6de75K1jBXuFq3VOigMKJMwUXEg0f7J+ANAmzXz8JsP79pQ7eKefxolXaft19Z8qK0t6+bLuQvEc8fjYD6lpKVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t3/xpB6Icrq0w3VSy5MbGXGeLwr2Cd4fbW/ztfGd6D4=;
 b=ELqSNlX9PWUvchlKwHruvL6/8kZcLwlGP8QcNoIwTlU552CsnKQlO+S0SieJMkrjNvuTdQRtFWvwb3iu4/5SG7MgcdZTevdtLj8PedNn3oJQTxmmdlojgiaSQgJEUSLfH5+6uAKXt+jFBefzgpziFqz+0mgaAe9PFcjkGdjOO+gUsqiWlT6KQ1jlsKhjJaDQahxEIka1nKsKbHhY8YJAQ9at5BCGTv1Fz95kJx+okHp3ewzT3ZFvq8SVz24sk5mvLDBV9k+Kh1FUeBDdERAMqdclg0trIuWWrT0AdhinBJL/ZTp84UpKjm+t2BxqWL/6cK/QPPKknCedtTKGJF35RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3/xpB6Icrq0w3VSy5MbGXGeLwr2Cd4fbW/ztfGd6D4=;
 b=LsoTiY/scq1FZ0DbuliDU4D1sdgVWpbIoO0H/WWZ1oIj7EU7elOeWptLG4M6Ydl8cTB1zlUHh+b1C+N0ONnSCmgCPNM2s34aHUH9qOUklTzEZFBLly7a7Kp9aYCQgEydS2S5fC1Qy77aCZbpJsfAm3qz9rQe1LJgozmLNks+sY7TnC/BqRk5RWjHii5D5hxwMGOtdiGfhTWBmSx2Tf/KfIOJRSdNUHQnCWcXLSoQm+u3vwE/bduZReXEWFQXu4aJt9GpOuHQMb4h05dPpvFmqhBK2OzduD9j5zlEepQBEwwi1LljDH8WcSbP2twf5hWVOGDZuRFccicMNm4qudOVlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by PH7PR12MB8826.namprd12.prod.outlook.com (2603:10b6:510:26a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 17:41:44 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9298.006; Fri, 7 Nov 2025
 17:41:44 +0000
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
Subject: [PATCH v2 12/22] vfio/ccw: Provide a get_region_info op
Date: Fri,  7 Nov 2025 13:41:28 -0400
Message-ID: <12-v2-2a9e24d62f1b+e10a-vfio_get_region_info_op_jgg@nvidia.com>
In-Reply-To: <0-v2-2a9e24d62f1b+e10a-vfio_get_region_info_op_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0419.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::34) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|PH7PR12MB8826:EE_
X-MS-Office365-Filtering-Correlation-Id: f8a25779-5982-47a0-8bcb-08de1e24e913
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i2NrhjWr82WQvTTNlZAn+g9LGHDVWzMkzl2h6us5ITryU9wodaLOrpk+MCZp?=
 =?us-ascii?Q?3iZkN6WfR6sH+KbDdMJyzTwDM9MpvvqVCIoc7kulHXq5JO5FLF8hMDE72Hf0?=
 =?us-ascii?Q?ckJo5Pa+WEDmFfwbRU9Vx23NtPtb30QzmNmixutWizauhKqvcUdXuMbr7LIA?=
 =?us-ascii?Q?rlhtYR3jVmsfy0EfbT1BahvIIofP3kmGXMU0KQuJpYmkw5ubs4opLAz2JPgI?=
 =?us-ascii?Q?HOB0Bs+dPsPpz49pFxLeyw897376SczDy2uCvqMEBPeVo4L8xL54eYYx7rrN?=
 =?us-ascii?Q?MNm9fZBeJ4Imr4x6JOkbp3P47f4Px6Y5lrnJANhs9M6nsRl/iX+Rut57/We3?=
 =?us-ascii?Q?Eg3tgTETgC2tybRfGTNYGwaa+3Ve1IrAFjfbDZibfr4NUBmT+OqmMILqyTwO?=
 =?us-ascii?Q?0DtItUlyr91I3hiXAo8lA5mUBh9chXiLG3frl2q46pturbeYmUlo+/yMXS2S?=
 =?us-ascii?Q?7iQHSroA2hL0gjaAhUq6lrYx/AV0Lc7cELsOx4uvGd0MbIPAbZn1gkxHggTe?=
 =?us-ascii?Q?V4USFVCX/dMEeT+eb5w3qtGHPFNl4o+0MhQxpi0SUhwe8KU9sPZk6l6if4y4?=
 =?us-ascii?Q?rjj/vToWmjL/7S600PmSTvWURDmHQTctGOIqv0mqPxBIBXjFm//py9+hSLUz?=
 =?us-ascii?Q?FHI5DR2EYPWqesyoIiREYtNEe7Y4QKfXwaQHHrsuvlr4MvRCULsn+3ILpXxl?=
 =?us-ascii?Q?WA6k5HclBBPbqefX+Rr3n/BrEZFQuI3VmK2lNQj5vTz9Rym8VUVAn9wzkeoQ?=
 =?us-ascii?Q?b/AdBS36yQSt9wpCgM3Qlihv3Gj7hqBO/KCr2nvjgf6xCqeJfv4WOwi5zNpa?=
 =?us-ascii?Q?nTkWfMdAGED5dfQ90E9OJFg1mqIi6uaXbfT+0LxU5mEqqP9LWKbg9v1dZzjn?=
 =?us-ascii?Q?XHwNr4CW6azagdPOJ6DOQUKY3Bsok88o/5zgW/trxeeeqEwcI9cl0SqiUkAL?=
 =?us-ascii?Q?C1kewa0aEPRmr4DcOX0CQ7NvESZCaR4Xa5SpVRUWHiK3vE/Xr4KetmBDrw4p?=
 =?us-ascii?Q?SxMxBvst6/8D7j0iDuyroTRy0qJZh1cvrUzSEvpxjlCx1JFal74VhXgsxkhi?=
 =?us-ascii?Q?0K73v6TgQEvm7oqWfR3aXAmixTuvadcDiWFBearnIYv4tZ/HXW7wA3Gi/9Gw?=
 =?us-ascii?Q?HclwEoKKsopZ5qkUCbJI+jKSpZz9L9gUSXZaa50/J8vAqQL7D7+jljuszrjz?=
 =?us-ascii?Q?YI53c0kOL5sfSjCKOZssuHkzsD5GvtDPLFkJReXIcEgyZRpsA3vVahumrjwK?=
 =?us-ascii?Q?3JPkCIjClXSWiaVEJLriBYrfhU7Curp3wXbBs/rGXj8LzBkZhrtFrCnv/aDM?=
 =?us-ascii?Q?oSjD2z7W4cSpHjh0Rp0rGHMehMWSSHErnXGb1fkG0/2wOHfDTGkUKpELAecg?=
 =?us-ascii?Q?CaZ0yAMrwPOk7t8js+0EVd600SotT3SsiLCD/vqy7K8jSf/pzgF/l1K2vADH?=
 =?us-ascii?Q?Qtuj6TO4ChPvF0W7ui7bQsNPTA+mb1bbAuJgBzVE/8JObdxHZJCa1ZFBJhWq?=
 =?us-ascii?Q?yKOyW9/Uz9+y1TM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V0cDGZooaKE3EanIhZ6KEH6ySVaOR3psqZisnlw/4W0rBfaT7huWUK3ey5bj?=
 =?us-ascii?Q?4b7ceHAJkDfpRH3tKlmIs3VcTmE01onedm2EZGZqXOrg7NeYk42a3hv+NXWB?=
 =?us-ascii?Q?bCCUf570EIiuze4e/Pv+gncGiZK2Al6SoVjyIuV+O44Xx3tL3lZETtLXLQWz?=
 =?us-ascii?Q?uZfqhWJEEiBpPAVksUrmpRa1FYXbXA9td1BCCp/AWe2zwPz/vqhr7HIKFCjW?=
 =?us-ascii?Q?sWWc1B2OIobb8RTqra7N7K0cmF4Ksyut+CqrvQbySuzkgMz1lEr3nPbRBg+t?=
 =?us-ascii?Q?iNbPPvpdE+RpkVHruj4b4gS7Hp/urn+Qp557yOw6Iinnqzeu9ocq5gayDw7y?=
 =?us-ascii?Q?S6FVwcu2nv1PIRFXFu9ALw1dUP0ck5nShXLPFxgpB6LfIJTScIxDYd8xLRHi?=
 =?us-ascii?Q?rQmv6dXRHa6IWRn3d4x2ZcCB68zyJ1OLydaDJ+yyBkGCNKJHlLG3rfYagRoO?=
 =?us-ascii?Q?4Z2DZRRlIuVIfiPW22SWZqnWfsjvXE0q4j+1kCpqZR5fy/b9H4NyqYHOVO31?=
 =?us-ascii?Q?54FwvezZcPj5d8IPg0mlBbU3DBa15dKlF3JppbdQ6sLuFN9ZK0yUddua2xEB?=
 =?us-ascii?Q?/IhV2bShb8YI7UFSPBtmdjqQJVf0uZckTqDkoJ8OaxBX50nDU3qkA8i9PZAd?=
 =?us-ascii?Q?hVg++a8Ifu4FspbkloyH+rTXohohw11tu5B5aSZntzql8Ybte2IZ2w/c4fd4?=
 =?us-ascii?Q?fOtyLviwah2Pmf2LOyToRQhis6E3zmGYXur5oZ4TvzOPhJWR+u7f0AG0lcxP?=
 =?us-ascii?Q?zPorb1kXCISR8cdfDC7l7Z/zMy99c5l2IaZnBaQp/JXedoz7qP83RBZEu0oC?=
 =?us-ascii?Q?yO7ZeFZWqIXOhUlvw1/1v6IYhgWYbuFFcCvZ1BsQZ9T7X+ciVUWgKl+lDXpQ?=
 =?us-ascii?Q?qa0cqGlEuU+urAwmvl/IUtfbj1mdeJJFvic3UdtLNkqhKGKAasgUj8TczByl?=
 =?us-ascii?Q?5IVLLQAiyG9uJnqXIIPlj6dQ4aBHd7/gRe8kb3dNEJSBms6C8Jie/y8u11rU?=
 =?us-ascii?Q?UUGT1PYR8o7uUyDILP3gjBm9L9xEfUEcj6imYm3+2SPKdTyegLwaTNihHfEF?=
 =?us-ascii?Q?wv4R1KVUliIGR6obl8CCANSjFxxN/pRwDORfbW2WVwjeeauouAFiMh9o6Ymx?=
 =?us-ascii?Q?fQHcCi7EGVLzEYTM4+zeoIrjwO6y0j37SGOqnqOQS3gBIVmwDsWumo2F9Za/?=
 =?us-ascii?Q?awLi8KD0SPk+v2QQQLzJuPMqq5fEvhyFPDV2WrmuyspoDt0+fUk3QH8OLhEJ?=
 =?us-ascii?Q?Kf39hifxA+clvbY7m5R+w4fqcdLsGb/cD/5brcav/mOMXVSQbdBXwFLMtOwZ?=
 =?us-ascii?Q?F9jpKtr656a5c9NGxSOOBIhIvmK0IEbhYJoZNKY+ObXf96gdHD1xOkuevVbC?=
 =?us-ascii?Q?ppZajGHIesz8fF7bDvHhNNUjTZ/iVll7tHKrRykjUT0qk/fmYW/GK2aaoR2y?=
 =?us-ascii?Q?3241ZjykBDoFHk1LO/frJfwZ5oqMS0QbqLZ0gBwGHPgGxEA9ZjX/TtTCzfla?=
 =?us-ascii?Q?hknd0Fyq98IiRse7jNcDY+vip9dSPtijuIKJOrhK92v+xyy9Z2F8mIWZ38fp?=
 =?us-ascii?Q?swHaOh1VTTrO3TPh4cc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8a25779-5982-47a0-8bcb-08de1e24e913
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 17:41:41.7038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RrjpVdw8VsxdlS5wSkEeF7XubK5P9t+sw3os3+LH1IkRZ5+RDtbgCPfrWUSWH3fp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8826

Move it out of vfio_ccw_mdev_ioctl() and re-indent it.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/cio/vfio_ccw_ops.c | 44 +++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index ea532a8a4a0c29..6d46e0bc76df15 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -504,6 +504,31 @@ void vfio_ccw_unregister_dev_regions(struct vfio_ccw_private *private)
 	private->region = NULL;
 }
 
+static int
+vfio_ccw_mdev_ioctl_get_region_info(struct vfio_device *vdev,
+				    struct vfio_region_info __user *arg)
+{
+	struct vfio_ccw_private *private =
+		container_of(vdev, struct vfio_ccw_private, vdev);
+	struct vfio_region_info info;
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
+	ret = vfio_ccw_mdev_get_region_info(private, &info, arg);
+	if (ret)
+		return ret;
+
+	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
+}
+
 static ssize_t vfio_ccw_mdev_ioctl(struct vfio_device *vdev,
 				   unsigned int cmd,
 				   unsigned long arg)
@@ -532,24 +557,6 @@ static ssize_t vfio_ccw_mdev_ioctl(struct vfio_device *vdev,
 
 		return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 	}
-	case VFIO_DEVICE_GET_REGION_INFO:
-	{
-		struct vfio_region_info info;
-
-		minsz = offsetofend(struct vfio_region_info, offset);
-
-		if (copy_from_user(&info, (void __user *)arg, minsz))
-			return -EFAULT;
-
-		if (info.argsz < minsz)
-			return -EINVAL;
-
-		ret = vfio_ccw_mdev_get_region_info(private, &info, arg);
-		if (ret)
-			return ret;
-
-		return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
-	}
 	case VFIO_DEVICE_GET_IRQ_INFO:
 	{
 		struct vfio_irq_info info;
@@ -627,6 +634,7 @@ static const struct vfio_device_ops vfio_ccw_dev_ops = {
 	.read = vfio_ccw_mdev_read,
 	.write = vfio_ccw_mdev_write,
 	.ioctl = vfio_ccw_mdev_ioctl,
+	.get_region_info = vfio_ccw_mdev_ioctl_get_region_info,
 	.request = vfio_ccw_mdev_request,
 	.dma_unmap = vfio_ccw_dma_unmap,
 	.bind_iommufd = vfio_iommufd_emulated_bind,
-- 
2.43.0



Return-Path: <kvm+bounces-60936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75531C03C71
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 01:10:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93C0A3B425C
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 23:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83B22C0290;
	Thu, 23 Oct 2025 23:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="afVn2Dz4"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011006.outbound.protection.outlook.com [52.101.62.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203F026F462;
	Thu, 23 Oct 2025 23:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761260991; cv=fail; b=ujGCIqjAqYz+8cm/+1UwAIkD2hjl3bfWjTKI/ee99cc5U3RAQW+H7FhgkIoD3uPTQ8cryym1pBeQh1Sh7J+qIfDI5FacMbm53HQbRV9hBbK4akQ52B2HGJDzsm4iCproGwPRMhleud5RlJZIPZAVPH6GCGla1d95gBcwNP9PJDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761260991; c=relaxed/simple;
	bh=r3E6Wlaou455xxXKFf91b9OtrtvJQ1FUMHDphobI0CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jIiZyLvoyUxTfUNlmalxXInIhLzY/DXP+zY5+azXdZXlZaAub8AEW/R/HdH+mlyS35N9TjZRPE+KV/dH/ee0X1Cc/HYzB3NwRysxHBgDkVcEt8hEa1XXn4wv3hYQ6V/qwKvR6k40xIW9Q4DOf2BN0SBqLjXg1Si9F0yLLxyTaQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=afVn2Dz4; arc=fail smtp.client-ip=52.101.62.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rGJIOVvp4Mv6lH/j0PbNXIjCxQZCqH2WOV4r1YhwXopLqGLROec2W3WMtTlXckODxNY4/wXrGo3Mz2gfawWsFtqKoZrG8viWbdgbegISR7zs4+hrsaYFQTDFh/Z+vYTGQDPbBFqqP3K3jNWvl4Ew7UaLs+SYy/WoOMZgW6sGmZZ19mh3qGEEo6nz4Gxw78aErUJj2KXi7NoWVKNWsODVm9tA32EnjT2JXP/NMJrHZ5BJ8pnVXbkvYJAmYmLkZfXn2Xd9u2TTzmaGEWH2ohy+cGjqcuJGr23uK9qR4kfSZj/VVg80CsMM/7nYQfJwSo+sdPSb2Jogv3kV1ThOgpvkDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WGu3ZzwE7gs5InwBxP/cFxDBe723K77wWa7pR2mwEzk=;
 b=JpAZIxQJ+6nG5b6YGuDb4YCNRTL2QcGTZA3ANiYvSI4TGVBnDVgEcmG5vl5JjXxpJdYK46306SkczA1qNYhbnO8CZyHWbAUFrKgiPnb4mUK/O7N64KkE8d8vs0uFxDQDxztDnTwfwNvKZDBaJCM4aOJLB3eoT8s37t0F2/qxmUzxUGSObWmotgCDaGYVANEjfZCQZ1/1yks1Vhf3xCHlm1pqhIMXjnytmLx4fHLq05UY1pe/uFXlg7xN7YdjdiFNVEK9TAxV/ELi5pg12It4pFJVurK1UK3DcxXxAKBd2SwU8cfDsHIThrXpMmbCxTNM9crTwihmYineJdgTK3g4bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGu3ZzwE7gs5InwBxP/cFxDBe723K77wWa7pR2mwEzk=;
 b=afVn2Dz4Yckp59bnK/cEZU79UIWa+0Om0sy/xjZEssx5FT/zvTjDt4U67rxI+C+FUGR4Yj0zYn/agIIspCAh6p0iHfj500sz6Tmh3n07a4jNWgugiSLnNSAw9e9bXXZDZeHXFnoK/IGHsoKw7ggTuxGNX/lR/ZIJqMDqI3aTFtwFKYzfQc8el8QBhrtLL/yFKijq9szTYFAOA8RuM3kJCZQVGbOuhE3MpT6TLMLKGYnf2509Fr5U1NIZEVUC6EvSAtoDd0xmIlEsjZs3RkAHKSp4YRX9+Je7ON4eXdqII9gGDYIxWM5gYMv/KrfPQMWirpZvHcen/+gAIbE1UPYhTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SJ2PR12MB9138.namprd12.prod.outlook.com (2603:10b6:a03:565::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 23:09:43 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 23:09:43 +0000
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
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Kirti Wankhede <kwankhede@nvidia.com>,
	linux-s390@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Pranjal Shrivastava <praan@google.com>,
	qat-linux@intel.com,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Simona Vetter <simona@ffwll.ch>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	virtualization@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>
Cc: patches@lists.linux.dev
Subject: [PATCH 11/22] vfio/cdx: Provide a get_region_info op
Date: Thu, 23 Oct 2025 20:09:25 -0300
Message-ID: <11-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
In-Reply-To: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0099.namprd03.prod.outlook.com
 (2603:10b6:a03:333::14) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SJ2PR12MB9138:EE_
X-MS-Office365-Filtering-Correlation-Id: 10452aba-c424-49ed-fade-08de12893f8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZWojZ8J2rxCDGMJFd24I5SufWGlMDQ76gENI/irq59gBaQgrwlxU5InYX/uP?=
 =?us-ascii?Q?CIOm8yBTrFUKQ7x28u/g7Y17xmhFNpYA1XK8Jy2zPS3Z9erphqTHCwRkFCSp?=
 =?us-ascii?Q?NoY1SsBz/M9NfXt1uKCbdIs9/v2pEUR+jyHcwkrDa7A7WPwZEX1BEpd3yNm+?=
 =?us-ascii?Q?lS2+UtHpa3p8DjZI9fIOY9SzEmghHAfkBJX8MZoWAdBb9izPmKeVq8PP8hjp?=
 =?us-ascii?Q?OX3+WDreKfydmw1DjShW84PWYRFO1H9v3dS0DqwfPQtwMCh4zu6a7wgPlsue?=
 =?us-ascii?Q?exy6I7t8twLf3WNHVaW9mejqAAtMkYR+7QtMUyCeFN2W4NpY4UY5Uysvuqdp?=
 =?us-ascii?Q?WGhcs/di34Q2FeSJGlvT6daGnD6HhN5Du4Qhb5CzCcuOdLMVoJnnkm7HiRFM?=
 =?us-ascii?Q?mxUZov4FK5ZfkiwUjs42VnQ074aM3X31zwq1YDfhq5tp96desC/W4Im/49Bk?=
 =?us-ascii?Q?lWKMSnv51fky7YIWLT1+0GUT+PlU0X/tDy9uexmi5siU6EZBuUZuX1HRL80g?=
 =?us-ascii?Q?HSKzZMRyo4ViFkVRYNWM8fT8pmbPfiFUktwtWHFsfjUT3AG8CbB/VPfdDCQe?=
 =?us-ascii?Q?1HQdMOxeZzWvo3NAjvgN4L+ID7pGxWN7iU1SAGfhE5cXO07H3jXD720p9ewn?=
 =?us-ascii?Q?9itYaRbbIsKJgtCE/YpO9/DesbANzS55Hplo/xhVmU9z5Gv3Blfe3JL02119?=
 =?us-ascii?Q?Ik38Q57ricdgs3sWj9aNpgazYqZejd2PrMHXg74kqj7KxMGI+ZYyXWTpFj4o?=
 =?us-ascii?Q?8BWYVCwmPIAn6uUs0nMQ9HLlNP343jM1w+spYjxaW6bsyetGoFwXkSic7Vjj?=
 =?us-ascii?Q?5jjokyTuTFQkhj87PiP1IjkxQQ0/966TiJZ+rs013MjfBAfP/OxGMxIjhJgR?=
 =?us-ascii?Q?00xy/+iSVWrmvffBA5U87OG8XXtiDFjhJq9aJ1ruRPYZVdUYnNY4HiciabOm?=
 =?us-ascii?Q?ssff40xGCeU401s5CYzT2pbOGvXYYA59Fa2amDCp8KtIy3SLAy6QqqPgA/gW?=
 =?us-ascii?Q?EXmOlpS642BuVfhy0h3yK70XeMu71fERWJ5HHKLLtKGath3lwXeAh5IT/zEG?=
 =?us-ascii?Q?KwmUIZlggOKThyCq4WYH/XTDbGGgzLbRqshN93QRuS8DI+hMzkzU06spxucO?=
 =?us-ascii?Q?Qo73ixSCKRcVG5FeTqBskzLuk1W6FWxlUZtMVI9xb4gRuxkSln28zFdkkldC?=
 =?us-ascii?Q?4PvCLozSELZTTmlW1wDXFSknc34hwHkTGWN69rFGPdmoDUHWw9J7IrUuJBo0?=
 =?us-ascii?Q?zPRLqFzSS1T9v18S1yHcxE9npl0DqHzeSycb/mkzOxURSUqFWkVtJdr+WHWp?=
 =?us-ascii?Q?fD5A1NvtkEUiYDAbmF6jbetj1yLIAgrgMUqDdZpNA+TwqqT1grE3KPspG5GT?=
 =?us-ascii?Q?sqw+ImoucVdqv//umyIUa/sLCAN4DxFpjKwZ3sA5+34Ko8U792704rRgFnUd?=
 =?us-ascii?Q?qiMzmBIiu6jbR4sefb1Vz3mZfOCopiAA3jCgRwnzKwwBdBLqLJn0zAdsnaWO?=
 =?us-ascii?Q?PdVNkBtnMYGPGNg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b5O9VnvN3ihZ6QQNzpOH0PO+0rTnM8Gik/C0JELYcg6pgkBPCSznTc7JmV70?=
 =?us-ascii?Q?H2M3UsaW1bTYaAZZXhHUpnS8g8nAzWcWHMp/uuKHiIdU62TmQlIiQRXldfw+?=
 =?us-ascii?Q?cgEWQwSvClDO+UIoWEWLILuF9lKmbyGAgIp4lgtwwk33hX7zFGEEF6vZWG7t?=
 =?us-ascii?Q?JAHwSR3FvhIJmg7CiEL8nkgo08TQTX9BOlruv35JsVO7I2+uJKcslWYr4C6w?=
 =?us-ascii?Q?MHjKX9994uWV/wdb1FkCdaF8XSmZ71H/nwaOC3jjTGjryQu2TbkxTODRbD37?=
 =?us-ascii?Q?4Prx3hByU+ktg1YV/RvRkVUJC0wPxTS5BxMWoBrLn+pPs4/Dsswz0zgxhooZ?=
 =?us-ascii?Q?kxvhcUUb5Bau7pVGS+XuUQiU9ru8Njk2hXQ125GTNWItfeJL+2qsp/navMiY?=
 =?us-ascii?Q?4wC1NDD0LDrjnVEVlOR+NHvi8q8zgoEsBNHB2X6sUIWFlKqEzSXDorMi+OCP?=
 =?us-ascii?Q?TqslD2Fk1oz+pojZ+GqVFdx2RgQonyI3h+GgxQM9sK4gkzFB2m4iIPaNRLRN?=
 =?us-ascii?Q?kJAM3mlaoCtJURdTj3Kq3Zju7CRf6xwMnvwHbfs8N4AKTaW1/HF+5rEVqSBt?=
 =?us-ascii?Q?lo6bda6h4FvhETf/Wae6puYjkIGE0c1jaPBWvflh/IycpdCV8z6KCN2SvGBB?=
 =?us-ascii?Q?VdkVbiET0OAD8OiCOlUsaBPHrFsb9pIvP3bHOBpQdkVDHru0TuAgugZelnXy?=
 =?us-ascii?Q?Zs/jIh273AW8juz+9KVvfdLdGTA9BsROhKIe8EjGRwlkScWWDPaFwxk21YVc?=
 =?us-ascii?Q?JlV2u9P0jhW7IHpcjHWFkqHybO2Ng8hu1ISozYmWszWQrHiJ5zZV6QWJjLrH?=
 =?us-ascii?Q?e2sGI7j7RxqEuhA1z3onm/VCErGFcxjdgPpsN5s3mY1vYIApZr+TxJU6U0Ru?=
 =?us-ascii?Q?+PY7A2bvCBT4NWEidFfBjQYLoIuhzKPrrtvHU8YW2O0NGbSaYJH00Xa85QJo?=
 =?us-ascii?Q?a/Xw67aq2v9kXwiuI9NZgoXAdvJEvh+qAt4T8H/sS4aWztCVDZ+cWXGbZu9r?=
 =?us-ascii?Q?zUqjNbsXc9iTHC3p0GV6kPBvH9w5w3f6vt6HgCjbWlBwybyHNBGqUxzf4+vN?=
 =?us-ascii?Q?j3qzGIpD7E0bFYC8K0o2NYn7LKPhhwzWV1IbHyjJ8wcgP0M2Y+Mkk3FU7BKi?=
 =?us-ascii?Q?Sm7Bz2OGS9zIRt5ljFCF/pSxX1RBq0VIeW+UWnbFD6j35N/jkhe1d86EVlsR?=
 =?us-ascii?Q?sAdHy9iYjViMeRpmwWNp6d5szma23TxJgbSagb6bgeukusow628TlZcQNxfA?=
 =?us-ascii?Q?yaWx80hecByRO1TnRIskLp1BQWa60c69bWhLh6mFhumdxqy2diP5dHrnaSvh?=
 =?us-ascii?Q?uHW+kYMha90+b+whJpDbUXvy4VpcsbUkximaz7r0S475662vYBtk8vYxHd3Q?=
 =?us-ascii?Q?Ts5YUPIXQajeHKV/tQ58DBmVp+LFeRN+Zs3A8EvRD3m2mKp9RyjsZqa/W9Og?=
 =?us-ascii?Q?YYDZUYodv9jqH9gC7v0MwpLiPUrx+5ZmnWXoNi+cX5izF6JkK2+fROOQnAbJ?=
 =?us-ascii?Q?hArQXWJQuYuP4Ps/y9io1YwWJGPUIPjCkdnYYKylm52tP70BwsZ8/zQQMv0F?=
 =?us-ascii?Q?/Xow5scET5s8GXl5/hUAQyzEOgTpwYqpLQrwxDXU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10452aba-c424-49ed-fade-08de12893f8e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 23:09:42.1840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +qWVr99UgDgCVm29YDDOgbGC85hS4SbKFbBy7folpItyl58oDoW8rxiCOwa2DFhV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9138

Change the signature of vfio_cdx_ioctl_get_region_info() and hook it to
the op.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/cdx/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
index 5dd5f5ad768653..506d849139d35a 100644
--- a/drivers/vfio/cdx/main.c
+++ b/drivers/vfio/cdx/main.c
@@ -129,9 +129,11 @@ static int vfio_cdx_ioctl_get_info(struct vfio_cdx_device *vdev,
 	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
 }
 
-static int vfio_cdx_ioctl_get_region_info(struct vfio_cdx_device *vdev,
+static int vfio_cdx_ioctl_get_region_info(struct vfio_device *core_vdev,
 					  struct vfio_region_info __user *arg)
 {
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
 	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
 	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
 	struct vfio_region_info info;
@@ -219,8 +221,6 @@ static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
 	switch (cmd) {
 	case VFIO_DEVICE_GET_INFO:
 		return vfio_cdx_ioctl_get_info(vdev, uarg);
-	case VFIO_DEVICE_GET_REGION_INFO:
-		return vfio_cdx_ioctl_get_region_info(vdev, uarg);
 	case VFIO_DEVICE_GET_IRQ_INFO:
 		return vfio_cdx_ioctl_get_irq_info(vdev, uarg);
 	case VFIO_DEVICE_SET_IRQS:
@@ -284,6 +284,7 @@ static const struct vfio_device_ops vfio_cdx_ops = {
 	.open_device	= vfio_cdx_open_device,
 	.close_device	= vfio_cdx_close_device,
 	.ioctl		= vfio_cdx_ioctl,
+	.get_region_info = vfio_cdx_ioctl_get_region_info,
 	.device_feature = vfio_cdx_ioctl_feature,
 	.mmap		= vfio_cdx_mmap,
 	.bind_iommufd	= vfio_iommufd_physical_bind,
-- 
2.43.0



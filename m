Return-Path: <kvm+bounces-60941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A2AF8C03CC2
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 01:11:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 70ADF504A2C
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 23:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF2F2BE7CC;
	Thu, 23 Oct 2025 23:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t7tPJhts"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010014.outbound.protection.outlook.com [40.93.198.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8EB2D3EDD;
	Thu, 23 Oct 2025 23:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761260996; cv=fail; b=HyymiCVcxifYNyeG9wH+wFg2Gr0rt7+HjF7aPpz5/mBHadTZNuPVBYYmXOZDEBlPjezUmnjtp4ZDoSwWShJeD+C31FBB/Dsge9IhviPMDR2MZPwjRrKs9pWtNREN+gTWex8vIo+trvRjmeXuERAxMn4zeeR8p2XZKYyL01V4Y0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761260996; c=relaxed/simple;
	bh=ouoH8uT8GqzzCZVD2qRag+p85sl+tX8De1wX57KEK3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qeYbrYi0VPBVZKemq9xKl3TV+Tib8V3OvciXHyGg5ed8nI6P2PS9gcqgCfk2Aw0c3u1mjOFZz9kzt3XO9xVT7wdBQYhl3HUrB+rD2HfGgha4fgjFQGCmvBYaEh9d+ijKy2c7DqGrQ99oh5faWNmuzsQFMRNpYnXvtWVGgfamOwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t7tPJhts; arc=fail smtp.client-ip=40.93.198.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r5WKuzwy8ZHVKIvsBlZsF40i7FqxO5Q6YEY4IOZnjqosqbGotqVj6mnMM0Sxe7uI+MJaagMOV2iwbGhQ0Zdi5m/LLZ5DKNZKzkLNzofRkrOS8pIwe2tAZSkPebtHhMhkP+l7jGvHnFQT2zATkOZFRnk8OFiiBVTTvSmAnURRvsfEM4S/xfP6Le1DjifLgk5nO5sX3HETMpOr/8QvZS67Ze9LoADcq0xS0yI/+OiJWe2nJtqe8fkODnV49b2zkN7cMAqq1dWO6gm/QXwXy0cFVu8nH2DqvYAwZi3ZJa9Qgp1kxDfFik+ZcPjP2SsZKr3ENuj5vNPV+3pzfOBOxxr3Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESgTiGHtSz4DEV8hx+nMwOCdwZArcctajJ1HAmAmxVY=;
 b=J59mRC8gZYyi3QHLOWiLT3JM4Y4N1dGJXJLtEB+rKY/V6N1iordA2mWhvTARXp2xClac0WBiFCcipNRUDpoXjDLLea0t5U1yA0M386NspZqoZELY09LsDYSCUUxnOE3J9Ui3/iZp05ITYh9sC85fdZgMs1ohQ4ZbM1y17mTZF4cgpekBU1KBGj//bBCYgFLb5b9UF+iEpqwzjWRnYSXXKqkMVb3xzG9M8JBD/z7aJnJUP9yMIDMnmepxXnkZrNZNgc+stLeoGvNmIh0kK97M9A5FVxozbSRpia7/r9m14RVqMOLX0IwUImSBbR1axKyaWHFFtJIKSvQestj/ycLP7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESgTiGHtSz4DEV8hx+nMwOCdwZArcctajJ1HAmAmxVY=;
 b=t7tPJhtsCVh5J6C3SZa29twVdexZk6Bg9denTcH+iGwxNueXMoqCpoDwPZfl8RFw9Eyhjp2A3SoPsIUs5CGuPpZ3NXpgB6sVZNcdMti36nGmh+6gXchgE9BHAfO19kCyhW6MZpotdUlh0jdu3y22Lii9G6myUfwy6HROyXZ8AQQ2/HxPchyb3DJqyLpy7sdwAi9914w18jeji07TipG4c/2j105FLbSqXplgxlJHyKiTF0Awtq+Ifqg5p4hQbbqnAHgPwko5RuJ7J/VQi6uu1Aei3HdB0Y4xvi+HniejZmdrXPlSE6Uw0b7D+5Z2xc5AyGqrz5fd1qgaTbnotd18sw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SJ2PR12MB9138.namprd12.prod.outlook.com (2603:10b6:a03:565::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 23:09:45 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 23:09:45 +0000
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
Subject: [PATCH 13/22] vfio/gvt: Provide a get_region_info op
Date: Thu, 23 Oct 2025 20:09:27 -0300
Message-ID: <13-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3178646e-3000-4eb8-feb8-08de12893fdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r2qbrCVTb1SfZVko2nGk9OEERVYBZzslQOIuq3suE1yuu2VLxDETdjFSUp8w?=
 =?us-ascii?Q?JlZqKG/1b9Tayqp5iFXH/ZJIaAQ3hTdkrWdpgn0BQsY0D41JiPeFnnch8gN3?=
 =?us-ascii?Q?F+fmme+7naNRe2rj19svK0zyg/xlnvUCseCwdeHCbNNF+ocCfExnP39yEcy+?=
 =?us-ascii?Q?40FPgSd0eu7tEB86Lrn0WuwArZ5YVuIYdplY7hQziijkQE4eEGhf9O1b+TFi?=
 =?us-ascii?Q?ek0fdJnq5ltVwGnshZvTuyM3+YAJQZM1eV/UCkkxtFHAFfJ7tj2m+kTwnXjC?=
 =?us-ascii?Q?qVxL3OfU91Sm0bm2tnet3TKNfsjZDoE7ooAu7/aH+uwhGeLJJ4YOzf+HDg/r?=
 =?us-ascii?Q?nm7EdZ3Bw01THZX6L3ajCyCuP2Dmy9MzmN8rvId85WQ4LFH96SI4xaO/rbRD?=
 =?us-ascii?Q?W04JcBOFf14php9DOJVColiSKBmIcGt5TeQSj1kjUZkmk8blCiDJC5EDH+vS?=
 =?us-ascii?Q?erkSYBhP1EwNUqG7NpqY1W7LdaX+srcK8FHEH5Xl76nzk7g7xHx09eUenU2r?=
 =?us-ascii?Q?SDvzc7+yzdHZInPQrfj5iEi9stNn/nazahhYn0Ul90Uu2C7igfwkk09VND0u?=
 =?us-ascii?Q?fw17ZyHMmrOx7YQVeHEvQ2J/SoCrYhbqMN3qPWCtj73g8xZhyZXdf6zckmcB?=
 =?us-ascii?Q?zbT7M4GeMpYrj7kpQLPuA050zBfAxKey6+avTFqKAT8j2WcszDlbIHM1j01/?=
 =?us-ascii?Q?8zb3cqNmaahqOfXJypKIVthJ/QIge/n37KiBL730QFbWkcysYEvqDKWLL4yb?=
 =?us-ascii?Q?aJ3vg8TKdpVB7vhJNP16y2o+W6TnzKwuf/Y1C91Qh0uw8jeXKN99ND0ViVh8?=
 =?us-ascii?Q?f6bT5dCUm7c0ZtU5SKaq90XBiG1xbm3kluMitrp+7xRqAaMlDYVZq9P1WmI1?=
 =?us-ascii?Q?7pPXzBLLU/nZfmLtXRB3sqJgYN6OP6NELf2X3jNIlw6gjPSntgMlrgVGBDxm?=
 =?us-ascii?Q?KvMB4AfFB3Z9p4drBN3Gu9dL1l4Ao6midEHYYojxPDpI8VxxaKPVSP8EC8/Q?=
 =?us-ascii?Q?MusWY5VvPHSMsX131CkkaM4BIfLayI0JP64FQR4gz6zEH/pM0vPux0plgxyy?=
 =?us-ascii?Q?GoMt0G/PqFrXuAVUHTDe9ywyMyYbFrXKn9scNyA/RM0PtlMmKAZ6Y+VJzhph?=
 =?us-ascii?Q?55GpggfagdpvaY5kAPMc99OqodNISg2fVIlCa3NkHoIXZfpbkXJgAEX5bmtX?=
 =?us-ascii?Q?/CFVuGU62Xz6kmUULYNtqjm/60GTJaKHmaxMyEtpzzshmoU0CR21+Zp+8GOC?=
 =?us-ascii?Q?/MwHgxTOdhnFwtkiiE3TDMAEUsjbbjPDa8rrVykzqYWA9epiRvc0P1f6B0V0?=
 =?us-ascii?Q?+7B/zum1XgbqmvNFdrhjOfea89lhJxf8qyAn7i9WPcLT2HtjaD0J5w2O+VBK?=
 =?us-ascii?Q?trVcmW23mwAudTrQ1qlTdOXLzYF7yfAnksJcbXpU2xNFtsSZtkiB9ozcufdU?=
 =?us-ascii?Q?hm/g52/QKBsSruru+AQHOCuEpB3vlRyx0HczRM5rHu/MpIqqZiToD43/h+/4?=
 =?us-ascii?Q?M7tw/ejhKiZ4LbE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e72DiRjPadLe/c95/a//QpsWGt00yJSEsvUPnz466zyx6risM9zL7ehwzwuY?=
 =?us-ascii?Q?XLZyJbl3xLah4z/fJSDNoZul/nYz6Tgm3eA7gTrwwbOkdXX3KkqID5cW2kYW?=
 =?us-ascii?Q?i1ml+V+y9yBAbI9bH76fJA+uP24jce68TjLsYRfa+K/RodgqHBYLAb/fkJ5U?=
 =?us-ascii?Q?wQbH0lL0zjk0ACmbtGQwq6LXqxShxOt25HLOZzuSYxTTViu+pjYVd1T2fF9f?=
 =?us-ascii?Q?eU5R7xvvXifXL0oUOHEQLx6DQev698fDiKvkiM2etTSI8ZkOei/vcDnBA8PJ?=
 =?us-ascii?Q?fd/W9JadERG/P7RY9/AjrGEjLO4uapnuPqyFAHFJoZJ90ssAtUQa5mo3h/1c?=
 =?us-ascii?Q?3fGXvCPQM5Ckw9D71sTgXQyEQB6frM8Axt1sbAVE5vSiDb+6r7xW0dYNLNpm?=
 =?us-ascii?Q?w8dFp4nIXzk/9KVEd1ZP3ZPdfy4qQA0YEIxSU+c5sUOElupaPMQ5594/XvcZ?=
 =?us-ascii?Q?bUYlmhR1HHN7GrJpVlrpKP/qpoB0mjdk9aMg7kPXp2Fb5akgeE/s8/mySS+G?=
 =?us-ascii?Q?aZIrJ9SYwynyoawEZSWW20m/sx2J794b0TTxVKyt/CHbLE41teUwqL+uKOFW?=
 =?us-ascii?Q?T5o3CZ4TSdp7d+D0ys2Xm56aQ/O+XY0ZbrcJrs4XdUDyajnc4mrD5+FKbH85?=
 =?us-ascii?Q?e6r3HsQeY2mS5YaxwD5Zjni2H9vX0anqwaG441g3Syee0YTy3doTrBs6jpQT?=
 =?us-ascii?Q?qJFtzkpskgY+dXtq4sYRCdoHyGWYWMvKBn4Ev24fF5oV2TeKWOiIUlatpoA8?=
 =?us-ascii?Q?Weohh0Hpx5ueLwXX5nAbIvwWqjosCxWRmrBmt4iScvvfVtf36H9AZ+3hAlQs?=
 =?us-ascii?Q?a47zxckj997Wu8j8poxSkIOG7jWwMRMBoxaHMAW20mGy920pjb50jL1QLQww?=
 =?us-ascii?Q?YEohHyyN2fjw0qCCjT25KvR0pqj15d3ZNfZoqfNw/oGHQ0vvob3SkcXWfEHM?=
 =?us-ascii?Q?09xyEwIy1uAT6DdIaOXGuC6DY7SzJgirkCptULwLQyOl1s3NiU6alqJa8lit?=
 =?us-ascii?Q?K0edteR17gJTCsgbvj5/F52DWw8DzQ/J73RCRxlckMMop3qwdcTnEV15VI+g?=
 =?us-ascii?Q?LodndjVwuMvm4R+uS57y3zcxTHtz0geprR/1T8DxmztXeGb6wfoCDsyz6QrU?=
 =?us-ascii?Q?YgsjOtjNKFd7SCObK212KXmRbG0Tci+IPmrhqLMhzjSirFb7UdE15tS0MpFC?=
 =?us-ascii?Q?BduLxgVypo0oR/77ZQMvgBeT05FAoJ2zjAoWbCzJiTEcPNZNvN2vQBGMxOJ8?=
 =?us-ascii?Q?F6xy4gLlBJ+HQcDH9ebHM2/ZVu2wx9oNgvCQkV2N+RShjmiDnSY92AN89MN7?=
 =?us-ascii?Q?9rMcnmfyxJhCDSPCIvl6TVlH9UiQ+JCN08nQC+fuIAgFxjsdvIJ95cpdysHB?=
 =?us-ascii?Q?BbrRA8sGm+hdds6j3AsRDhKuqMXnVp5vcmEgTcsjFLi/xHKoqlNOVjTdcmqv?=
 =?us-ascii?Q?qjno88+IMAUdALmetEiqdOJjAg+PAJFMTHihNoDkRfGFI3o95+J7tc5aP8KK?=
 =?us-ascii?Q?lSQDL9jnMkgmCfKf2i/8yOUYEdkxgtVtndf30KMqPbcKT83n6d5l2/8WSqJn?=
 =?us-ascii?Q?mr/bJRbEGz7NYmJoEcAo/7HfnEjIR175kvdX4y9s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3178646e-3000-4eb8-feb8-08de12893fdb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 23:09:42.7975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: skMV2r6azQcDVg/+ca8HsTI84GSkwwHO23PEZMuVuvIdmbe2KUWC9ri2oZqU3+Vv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9138

Move it out of intel_vgpu_ioctl() and re-indent it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 301 +++++++++++++++----------------
 1 file changed, 150 insertions(+), 151 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 69830a5c49d3fd..6b47e33078eb52 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1140,6 +1140,155 @@ static int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
 	return func(vgpu, index, start, count, flags, data);
 }
 
+static int intel_vgpu_get_region_info(struct vfio_device *vfio_dev,
+				      struct vfio_region_info __user *arg)
+{
+	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+	struct vfio_region_info_cap_sparse_mmap *sparse = NULL;
+	struct intel_vgpu *vgpu = vfio_dev_to_vgpu(vfio_dev);
+	struct vfio_region_info info;
+	unsigned long minsz;
+	int nr_areas = 1;
+	int cap_type_id;
+	unsigned int i;
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
+	switch (info.index) {
+	case VFIO_PCI_CONFIG_REGION_INDEX:
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = vgpu->gvt->device_info.cfg_space_size;
+		info.flags = VFIO_REGION_INFO_FLAG_READ |
+			     VFIO_REGION_INFO_FLAG_WRITE;
+		break;
+	case VFIO_PCI_BAR0_REGION_INDEX:
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = vgpu->cfg_space.bar[info.index].size;
+		if (!info.size) {
+			info.flags = 0;
+			break;
+		}
+
+		info.flags = VFIO_REGION_INFO_FLAG_READ |
+			     VFIO_REGION_INFO_FLAG_WRITE;
+		break;
+	case VFIO_PCI_BAR1_REGION_INDEX:
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = 0;
+		info.flags = 0;
+		break;
+	case VFIO_PCI_BAR2_REGION_INDEX:
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.flags = VFIO_REGION_INFO_FLAG_CAPS |
+			     VFIO_REGION_INFO_FLAG_MMAP |
+			     VFIO_REGION_INFO_FLAG_READ |
+			     VFIO_REGION_INFO_FLAG_WRITE;
+		info.size = gvt_aperture_sz(vgpu->gvt);
+
+		sparse = kzalloc(struct_size(sparse, areas, nr_areas),
+				 GFP_KERNEL);
+		if (!sparse)
+			return -ENOMEM;
+
+		sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+		sparse->header.version = 1;
+		sparse->nr_areas = nr_areas;
+		cap_type_id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+		sparse->areas[0].offset =
+			PAGE_ALIGN(vgpu_aperture_offset(vgpu));
+		sparse->areas[0].size = vgpu_aperture_sz(vgpu);
+		break;
+
+	case VFIO_PCI_BAR3_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = 0;
+		info.flags = 0;
+
+		gvt_dbg_core("get region info bar:%d\n", info.index);
+		break;
+
+	case VFIO_PCI_ROM_REGION_INDEX:
+	case VFIO_PCI_VGA_REGION_INDEX:
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = 0;
+		info.flags = 0;
+
+		gvt_dbg_core("get region info index:%d\n", info.index);
+		break;
+	default: {
+		struct vfio_region_info_cap_type cap_type = {
+			.header.id = VFIO_REGION_INFO_CAP_TYPE,
+			.header.version = 1
+		};
+
+		if (info.index >= VFIO_PCI_NUM_REGIONS + vgpu->num_regions)
+			return -EINVAL;
+		info.index = array_index_nospec(
+			info.index, VFIO_PCI_NUM_REGIONS + vgpu->num_regions);
+
+		i = info.index - VFIO_PCI_NUM_REGIONS;
+
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = vgpu->region[i].size;
+		info.flags = vgpu->region[i].flags;
+
+		cap_type.type = vgpu->region[i].type;
+		cap_type.subtype = vgpu->region[i].subtype;
+
+		ret = vfio_info_add_capability(&caps, &cap_type.header,
+					       sizeof(cap_type));
+		if (ret)
+			return ret;
+	}
+	}
+
+	if ((info.flags & VFIO_REGION_INFO_FLAG_CAPS) && sparse) {
+		switch (cap_type_id) {
+		case VFIO_REGION_INFO_CAP_SPARSE_MMAP:
+			ret = vfio_info_add_capability(
+				&caps, &sparse->header,
+				struct_size(sparse, areas, sparse->nr_areas));
+			if (ret) {
+				kfree(sparse);
+				return ret;
+			}
+			break;
+		default:
+			kfree(sparse);
+			return -EINVAL;
+		}
+	}
+
+	if (caps.size) {
+		info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
+		if (info.argsz < sizeof(info) + caps.size) {
+			info.argsz = sizeof(info) + caps.size;
+			info.cap_offset = 0;
+		} else {
+			vfio_info_cap_shift(&caps, sizeof(info));
+			if (copy_to_user((void __user *)arg + sizeof(info),
+					 caps.buf, caps.size)) {
+				kfree(caps.buf);
+				kfree(sparse);
+				return -EFAULT;
+			}
+			info.cap_offset = sizeof(info);
+		}
+
+		kfree(caps.buf);
+	}
+
+	kfree(sparse);
+	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
+}
+
 static long intel_vgpu_ioctl(struct vfio_device *vfio_dev, unsigned int cmd,
 			     unsigned long arg)
 {
@@ -1168,157 +1317,6 @@ static long intel_vgpu_ioctl(struct vfio_device *vfio_dev, unsigned int cmd,
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
 
-	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
-		struct vfio_region_info info;
-		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
-		unsigned int i;
-		int ret;
-		struct vfio_region_info_cap_sparse_mmap *sparse = NULL;
-		int nr_areas = 1;
-		int cap_type_id;
-
-		minsz = offsetofend(struct vfio_region_info, offset);
-
-		if (copy_from_user(&info, (void __user *)arg, minsz))
-			return -EFAULT;
-
-		if (info.argsz < minsz)
-			return -EINVAL;
-
-		switch (info.index) {
-		case VFIO_PCI_CONFIG_REGION_INDEX:
-			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
-			info.size = vgpu->gvt->device_info.cfg_space_size;
-			info.flags = VFIO_REGION_INFO_FLAG_READ |
-				     VFIO_REGION_INFO_FLAG_WRITE;
-			break;
-		case VFIO_PCI_BAR0_REGION_INDEX:
-			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
-			info.size = vgpu->cfg_space.bar[info.index].size;
-			if (!info.size) {
-				info.flags = 0;
-				break;
-			}
-
-			info.flags = VFIO_REGION_INFO_FLAG_READ |
-				     VFIO_REGION_INFO_FLAG_WRITE;
-			break;
-		case VFIO_PCI_BAR1_REGION_INDEX:
-			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
-			info.size = 0;
-			info.flags = 0;
-			break;
-		case VFIO_PCI_BAR2_REGION_INDEX:
-			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
-			info.flags = VFIO_REGION_INFO_FLAG_CAPS |
-					VFIO_REGION_INFO_FLAG_MMAP |
-					VFIO_REGION_INFO_FLAG_READ |
-					VFIO_REGION_INFO_FLAG_WRITE;
-			info.size = gvt_aperture_sz(vgpu->gvt);
-
-			sparse = kzalloc(struct_size(sparse, areas, nr_areas),
-					 GFP_KERNEL);
-			if (!sparse)
-				return -ENOMEM;
-
-			sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
-			sparse->header.version = 1;
-			sparse->nr_areas = nr_areas;
-			cap_type_id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
-			sparse->areas[0].offset =
-					PAGE_ALIGN(vgpu_aperture_offset(vgpu));
-			sparse->areas[0].size = vgpu_aperture_sz(vgpu);
-			break;
-
-		case VFIO_PCI_BAR3_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
-			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
-			info.size = 0;
-			info.flags = 0;
-
-			gvt_dbg_core("get region info bar:%d\n", info.index);
-			break;
-
-		case VFIO_PCI_ROM_REGION_INDEX:
-		case VFIO_PCI_VGA_REGION_INDEX:
-			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
-			info.size = 0;
-			info.flags = 0;
-
-			gvt_dbg_core("get region info index:%d\n", info.index);
-			break;
-		default:
-			{
-				struct vfio_region_info_cap_type cap_type = {
-					.header.id = VFIO_REGION_INFO_CAP_TYPE,
-					.header.version = 1 };
-
-				if (info.index >= VFIO_PCI_NUM_REGIONS +
-						vgpu->num_regions)
-					return -EINVAL;
-				info.index =
-					array_index_nospec(info.index,
-							VFIO_PCI_NUM_REGIONS +
-							vgpu->num_regions);
-
-				i = info.index - VFIO_PCI_NUM_REGIONS;
-
-				info.offset =
-					VFIO_PCI_INDEX_TO_OFFSET(info.index);
-				info.size = vgpu->region[i].size;
-				info.flags = vgpu->region[i].flags;
-
-				cap_type.type = vgpu->region[i].type;
-				cap_type.subtype = vgpu->region[i].subtype;
-
-				ret = vfio_info_add_capability(&caps,
-							&cap_type.header,
-							sizeof(cap_type));
-				if (ret)
-					return ret;
-			}
-		}
-
-		if ((info.flags & VFIO_REGION_INFO_FLAG_CAPS) && sparse) {
-			switch (cap_type_id) {
-			case VFIO_REGION_INFO_CAP_SPARSE_MMAP:
-				ret = vfio_info_add_capability(&caps,
-					&sparse->header,
-					struct_size(sparse, areas,
-						    sparse->nr_areas));
-				if (ret) {
-					kfree(sparse);
-					return ret;
-				}
-				break;
-			default:
-				kfree(sparse);
-				return -EINVAL;
-			}
-		}
-
-		if (caps.size) {
-			info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
-			if (info.argsz < sizeof(info) + caps.size) {
-				info.argsz = sizeof(info) + caps.size;
-				info.cap_offset = 0;
-			} else {
-				vfio_info_cap_shift(&caps, sizeof(info));
-				if (copy_to_user((void __user *)arg +
-						  sizeof(info), caps.buf,
-						  caps.size)) {
-					kfree(caps.buf);
-					kfree(sparse);
-					return -EFAULT;
-				}
-				info.cap_offset = sizeof(info);
-			}
-
-			kfree(caps.buf);
-		}
-
-		kfree(sparse);
-		return copy_to_user((void __user *)arg, &info, minsz) ?
-			-EFAULT : 0;
 	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
 		struct vfio_irq_info info;
 
@@ -1475,6 +1473,7 @@ static const struct vfio_device_ops intel_vgpu_dev_ops = {
 	.write		= intel_vgpu_write,
 	.mmap		= intel_vgpu_mmap,
 	.ioctl		= intel_vgpu_ioctl,
+	.get_region_info = intel_vgpu_get_region_info,
 	.dma_unmap	= intel_vgpu_dma_unmap,
 	.bind_iommufd	= vfio_iommufd_emulated_bind,
 	.unbind_iommufd = vfio_iommufd_emulated_unbind,
-- 
2.43.0



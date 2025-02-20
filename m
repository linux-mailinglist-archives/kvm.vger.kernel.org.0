Return-Path: <kvm+bounces-38783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF6C7A3E53A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 20:40:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A423F19C2B53
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 19:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703D62641E3;
	Thu, 20 Feb 2025 19:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TrATA7tw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67682135BB;
	Thu, 20 Feb 2025 19:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740080412; cv=fail; b=m8yDMrZFcGzfUtLXQoHKa/DVhTsIeLe4F+7S2h6UQYon4w15n6Q9YxNx6Ru5Rw9rZVUo0yBGSiO772TdbJ0fIRyNyBtIgOY/aifHz1gd0l/fgunKV3HUyN6oWCxovhwOKLVVYsB976HrFE2XVzk2ziGib4Jf2S1EYvQ9lyI7yps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740080412; c=relaxed/simple;
	bh=CBqm1Fqk8jMIKNdea7uYXMQmcKuEctyOHf36PORjkpI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cFjKNuGvO9LcB7GkXoiCAcmK3pSCE1kFngTWLzWg240xrryKMuXaog83T6pH0okC1WN/u0tWeIVTCdC7ta3V5ap4NOEvcxM8n3kWlC/QpEU2jzFtdEyXAl0cum4U3VjIzo3CZZreJNyytaOfb2FI5EakEqYa8RZQHb+OM/Sly0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TrATA7tw; arc=fail smtp.client-ip=40.107.243.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TiOQ517m9lfDQPXE/9WycyZhtBSmNqtqDkcp6QfHRi2u8x5uDTNW7yix3zR8CUfMgliX/69drXLAgFvS5HvVZeRdxD3q8VxxQlBBMmvcaddIeM7dCddOpuI9wlXtS7+dCYgGUMAvZAOo7c+JV5mk1844gkzC7xFnTBbZkbTBBEtPdCaI9s79GJPrKqhBjdy1C8Gp0drpaedrVNNHrhQlh0quGMwUTQ/JQTenFezG584PVlPYoo4MVhIwlbJjFxRscpZLaKCksmFJVPJhomD/XmXOvrZPj2BHP9cDenC2abOjfidWsiUQnxSn62Qjpmn88NDV+pk3C69htux072kezQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lUVRy7wyUKTn/gJhDGGEBDKzDKhUk889JAGtm9Zd2bU=;
 b=GBjiKPUAF+6ecmJ/DAwkV0iydHxIeSUDttWVRK3G3/18zdGiupC3g4BjIHklGv3Rp4Dplj/DYy/9p1EvqkP5foXtmlESUwlCX5SkmPl820Q9qqlOumFUL9uP5g3BdQCo4deYD90X1W0OxR6/wa+WiX+7BGUOxRSwxHY6Y0+DCaUsLEULK1VBmNb9Dywmx7htBliXT4RdXDkbuEt8RUf3F7gR0LgTzSDuNCpfn2CYR+6ZBPpNLXYzHWxu8WIfZv4fs9/s9PK5M9JDNEY5XJ46O7DSJ+3hIAp0kiYm1Pa97Q5nt5/PgSVAwzB9NbZGaw2OFi2EBF7gL8GbB3h6uD7c3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lUVRy7wyUKTn/gJhDGGEBDKzDKhUk889JAGtm9Zd2bU=;
 b=TrATA7twCrzFI1MLyQ00Y57ZKxsaoB2AosqPnh2tl/0eFu5txXzEJqVerTKKT4sOKoDH1Pj9BEYuOgd0RZZengAgjjlVHicUQsrh3wFQKflfCROS1iQzWrDqvmSXjD9b34BFWxkkANlkl4zC43epKxdLBK8Z+sDCZbEIyaWqqxDjiNKFzPYiU+/nor+nCO/3VsOWTToR5MJcrE015Jxcvu/v/N5a8GZWNMYHzW6hiu+0E6CEX4Dk40IFkWwbywBMi73oZ2QdCDeWoIKcDcHbK2RqdTTswhK+C/K5T/PsOgdRKzfd9KZjYbDuwDoyV06X6srvpqKOBAwaARwm6/gUEw==
Received: from SJ0PR03CA0073.namprd03.prod.outlook.com (2603:10b6:a03:331::18)
 by PH7PR12MB6444.namprd12.prod.outlook.com (2603:10b6:510:1f8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.16; Thu, 20 Feb
 2025 19:40:04 +0000
Received: from SJ1PEPF000026C7.namprd04.prod.outlook.com
 (2603:10b6:a03:331:cafe::c9) by SJ0PR03CA0073.outlook.office365.com
 (2603:10b6:a03:331::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.15 via Frontend Transport; Thu,
 20 Feb 2025 19:40:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000026C7.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.11 via Frontend Transport; Thu, 20 Feb 2025 19:40:03 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 20 Feb
 2025 11:39:56 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 20 Feb 2025 11:39:56 -0800
Received: from c-237-113-200-209.mtl.labs.mlnx (10.127.8.14) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.14
 via Frontend Transport; Thu, 20 Feb 2025 11:39:53 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, <virtualization@lists.linux.dev>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, <stable@vger.kernel.org>, Cong Meng
	<cong.meng@oracle.com>
Subject: [PATCH vhost v2] vdpa/mlx5: Fix oversized null mkey longer than 32bit
Date: Thu, 20 Feb 2025 21:37:33 +0200
Message-ID: <20250220193732.521462-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C7:EE_|PH7PR12MB6444:EE_
X-MS-Office365-Filtering-Correlation-Id: ef044da4-09b1-4e11-70ba-08dd51e65f38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UDc5VGZ5dTQ2dFVwemlnQ3ZnZ3M4czFidnVZZXpGNjQ0aGhVeFBHU0cySTkw?=
 =?utf-8?B?QzAxYkNPcE9oRnZqcjhjbGU3TGFFOS91V1ZxRWdPSlFmMFBXTnhIK29mNytY?=
 =?utf-8?B?NXRjWVFhaHN0Vi9ISzgxWWo2VWxlMmo4bUNMWUorSEhoRzlaa1JvWTJRV0NH?=
 =?utf-8?B?V1VTOVAyZThESS9LN1UyeU9xYlhpUE1kcTNkeHl0UjVKcTA3MlYzanhxQjQ5?=
 =?utf-8?B?L3NvVVhrZFBsUVNDQVE0SXdnUzFnWlNZaE02WC9KOFFXUExoV2lidHQ4bTRz?=
 =?utf-8?B?RjRvY2JycnpLV3JIaHNhdm1RUk9ZYm5WcnIydmFSNVJEcnBDNFVVRk5IdXd0?=
 =?utf-8?B?RTIvdXpFNGFSS1FNMHVXd3oveXFaaWNmaU8vbmQ0TU9TNDNpQlg0cFVkUTBu?=
 =?utf-8?B?cndjdzlETjZiT2dSenhqWW5qVFA3SnF3WVNzcm9XaWpwUmZZN3o2S1JGbTFR?=
 =?utf-8?B?SC80aGtIWGxMSExveXM3cURXS0dNUWJTMXE0WU1YOXVJSmZnN3lrb1NWeGdM?=
 =?utf-8?B?Y1JLOHFWaTlZRmV4aE0zOVNVUCtMQUdYdG5vTjNvcXJ5M3NvTTRCMEgrMGUw?=
 =?utf-8?B?N1BzajJ6U0JhaXM4UmJqQTd6eWsrRFhxdTlXMDM4aCtlaURrM3NvRmFxQjVu?=
 =?utf-8?B?bzJwM1V4UlRSdWx0bnRvNElqVTFqWFJzSG0xUlJmNDdzUnYyV1JBdGJ3dVVJ?=
 =?utf-8?B?dEE5ODR1WWZraTVHSGM3RVBwQUhDdURoeE5hMUNoenVsSzlsN01FWXlzbVcy?=
 =?utf-8?B?bSt2UkszK0ZiYWNPQ1ppNmNrNDZYaHdMTVdETklCWi9YVVRiNXIzVkxpdzdB?=
 =?utf-8?B?UEJPU3M1Z1RjS3VzOUZYWm5tUVFSK0tXclhDYjNWOFhCNUdxTkgxQ1RTWTR4?=
 =?utf-8?B?c2lVSFVETEFnSDZwOThPTHgrdG4wSGJDby9BVEtOUkQzN1BBUXdiZ1dvVkVr?=
 =?utf-8?B?M2ZPV28yQ3oySXJJeCtMSVdIbVJlTEhRSG5IWTdBMTRBaU81eUs3MERWaDlB?=
 =?utf-8?B?TndtTElscVRXa2YzWTRUc2RnaTF3d0MvaGhld2F0RXJRdzNXZ2lWZTZaMWUx?=
 =?utf-8?B?d1FuZmJyRC9UUWltQlJybWIrMDMxejdWOTY5MEgyeDNOa0s1Wkh3TFMyWC9j?=
 =?utf-8?B?NW1ETTZHSXd3RmNPUXB3dWNMM0VDU3k0Z0xTQzAwZmpSMTdyS1B2TDBVRDVr?=
 =?utf-8?B?dnc2YVdjVWZoQndvWE8raEtrZC9KQkhHdTE1SmtEdHhwajhFR2F3OXNuMUdj?=
 =?utf-8?B?aitpeDlrR0xJSzdqZ0M4ZHNuOUVwdHZvOHUyc01CSGh4Rzg2L2tITk0wTklX?=
 =?utf-8?B?ZEZISk9MckNaaHJoRUV4cnRWNUhmK1hFYmt6N3UwcW1KcFdKUlpOdkVnSm5W?=
 =?utf-8?B?WkoySTUrNlc4aWY1VWtHNnlmeUZyaDZvWkljaXRma0FOREZyNmtZSHFsZmxY?=
 =?utf-8?B?UDN5eTkyVzlSRHRyRHA0Vmx1T1Nwam9EendqdHBQTzY4NHNDU0d5cGVKSC95?=
 =?utf-8?B?S0lFVUdHRFl0cjVxeTA3eGVjRGpMNE5UemFkdTVoMHY1Q2hhbEdneHBJejRw?=
 =?utf-8?B?WW9CWW1DbW1NR2FlWVBhanJ5ckpPL3ZuOWcxcDUwTGdUa2hhL3NSeXhUK25u?=
 =?utf-8?B?Sno5WjhxWjJQOU9WN1VaM3RqTGZIaDFMTDQ2NlgzWjFZdDQ5djJud3ppbDdG?=
 =?utf-8?B?NVU0REdoUUQyaWxKbDF3RTVqYzZoeDdJYVlEcXNFUHBKWHRFUHdXSytqTkdE?=
 =?utf-8?B?ODBBalhaL25oZFptSkszK0g1cHdPQURkOEVvd09POVltTUY4WEc4K2lFK1k5?=
 =?utf-8?B?emsrK2JtVEFxdy9pYTBwbFB4NXBVU3VUdWtlV092R0JYUHoxZ0RjalJSN0dO?=
 =?utf-8?B?VVpRUk40MHh3K0ZlamxiUzBoSEdDeEJhRG5kb2dLcEhHK0RXa2IrenVpQXFV?=
 =?utf-8?B?OUpMV2QxanJzZVI1NXhxMnFLNGRrcUY5aVN1eVo2eG8vd2cveU1oNGpPNkUw?=
 =?utf-8?Q?80TnAw0IWLv0rayuN2Qj1BRbmz9XDU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 19:40:03.7871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef044da4-09b1-4e11-70ba-08dd51e65f38
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6444

From: Si-Wei Liu <si-wei.liu@oracle.com>

create_user_mr() has correct code to count the number of null keys
used to fill in a hole for the memory map. However, fill_indir()
does not follow the same to cap the range up to the 1GB limit
correspondingly. Fill in more null keys for the gaps in between,
so that null keys are correctly populated.

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Cc: stable@vger.kernel.org
Reported-by: Cong Meng <cong.meng@oracle.com>
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
---
Changes in v2:
- Added Reported-by tag.
- Fixed typo found during review.
---
 drivers/vdpa/mlx5/core/mr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 8455f08f5d40..61424342c096 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -190,9 +190,12 @@ static void fill_indir(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mkey, v
 			klm->bcount = cpu_to_be32(klm_bcount(dmr->end - dmr->start));
 			preve = dmr->end;
 		} else {
+			u64 bcount = min_t(u64, dmr->start - preve, MAX_KLM_SIZE);
+
 			klm->key = cpu_to_be32(mvdev->res.null_mkey);
-			klm->bcount = cpu_to_be32(klm_bcount(dmr->start - preve));
-			preve = dmr->start;
+			klm->bcount = cpu_to_be32(klm_bcount(bcount));
+			preve += bcount;
+
 			goto again;
 		}
 	}
-- 
2.43.0



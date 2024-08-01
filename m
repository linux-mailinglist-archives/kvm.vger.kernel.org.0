Return-Path: <kvm+bounces-22957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EB9D944F73
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 17:38:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8B6F288B84
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 15:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A9141B32DA;
	Thu,  1 Aug 2024 15:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s2idSab8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBC81EB4AF;
	Thu,  1 Aug 2024 15:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722526700; cv=fail; b=Ha+6uvYdjPaDE1SJMpylXYtdHIechR1+6nIm0Ur+SHsQ/294GXiWc4mBWEsPt/oUQNojLZIz6q7cMCpWO9w+JjyZHF17Ybk5ZItvieOBEerTndQHpo8ndFXBju/Q0GY5rHrY77icp+W7iHAvO2HoAXBtH6f0vKRlM4getJJFKi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722526700; c=relaxed/simple;
	bh=7HSixOMUq0HFsQlt6+Mx4ZGAji5Wa2qe1rbSTD9Vz8Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A1Q+1cCAGMbsrJeipPEI6nmsvwdEljChiI1o05jVmIcKE6TxRZ8EqXk57geEpjZ39rLvkbY9IiU/5WELqiiPaTUUI1PoJLPZZesFkjjpTuxlT32yoPu3iowqC2X6C6WK54mPkmI2LHz/o4vMTaLSNeRP8N8AH3LY/NA9Wweu918=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s2idSab8; arc=fail smtp.client-ip=40.107.236.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SfRbm8PxNYUU3vnv2VCVZcWTMzz8y3kxvGZWmFzzFoqnUbx9+TGvDRc+N0aiZ4wD+ntI7y3a7ABjzvhne1wDs6bfjGiF21KE7o3OvRWzKXBJYO10cCksh1zZ/d151CxTJ54rc4i+kMExXkz/pR7Bp6BKGlMPww9aKai6Un/UBNeexIKD0csu/CgvcuB+0miyK3n6ftg3FaEwDBOITYxE3QbrgncIjFV7lIc7siyTAADlKMHGPBdHA//D7w8enWxx4LWKHiWs6d1UE/Jx27AWttUQ2vMHYOsMTWa3dL6kfC322nFeUuJkVsqrtjKcOPesAs42Di5S3p5YgdmqTlv1xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QUPH8YQZqhNqhb390PAn6d6Niy7HRnJK8goUEgp+j5s=;
 b=qvYxwRe+QeE5IsHG2Q1s3sDETj51aUz1ka4JfdX6hOV1T4ux/0JERGPcjbtD6VPsVM1ZyKoeoeMTB4G2Zca2XNBBt1Anpee4KnCOJM0OE+6T+Ox3mmGXfcfezzmx1/L1iHel3qqBaOLvPyQkHLTJ/2WpnIsMUrnYyy/tcLlZL/rk5YbP16l/HItKAEv3Ypig0UbxfEqNeEORbaFlOT6GelyTkQL55ewrFv5hbVjUQ0lXy/HSSGZNYBP5BrS4k0E7QijICWQhDJXsPv1+WrBEECgw+HedB3wc+awzyf5aR9xeRrxBJ7HIrm+TxtzJGk9j4a5uyjwO7CyTskYIVcm1/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUPH8YQZqhNqhb390PAn6d6Niy7HRnJK8goUEgp+j5s=;
 b=s2idSab8H+Z+Na0jEdsmmrc6xvmdr17UMgfAtk8ZbCYud/MMPgm5LjqtDbA9bDkr0bTfMnPH1q/Rt4nNxzyBI6ScD/2mTvIbQFG1KYYwzyG5bPnlRPc9UIgcA6Ru85s+dLOvRMCmWoKPTb+74k6YQY3KdyPpzt2ICQb5ylBxsKSV78TIsqdVNFHAkUkq988geJHmEXn0k51zDEPxW5gj8d+6QqQtP8GANC/aQsqGo+R0FTb8YwvN2qUpCEGbBcusbOKFDJ/e2yeW25jXdwwJqwBK/zsJYY5/f8lBmwF4dIGkDAzWo09di+3eT9mYqoac2zRO5TvAWKr1vC+DuFB/0A==
Received: from CH5P222CA0018.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::29)
 by DS7PR12MB6047.namprd12.prod.outlook.com (2603:10b6:8:84::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21; Thu, 1 Aug
 2024 15:38:11 +0000
Received: from CH3PEPF00000013.namprd21.prod.outlook.com
 (2603:10b6:610:1ee:cafe::f4) by CH5P222CA0018.outlook.office365.com
 (2603:10b6:610:1ee::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23 via Frontend
 Transport; Thu, 1 Aug 2024 15:38:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF00000013.mail.protection.outlook.com (10.167.244.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.0 via Frontend Transport; Thu, 1 Aug 2024 15:38:11 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 1 Aug 2024
 08:37:54 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 1 Aug 2024 08:37:54 -0700
Received: from dev-l-177.mtl.labs.mlnx (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 1 Aug 2024 08:37:52 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH vhost] vhost-vdpa: Fix invalid irq bypass unregister
Date: Thu, 1 Aug 2024 18:37:22 +0300
Message-ID: <20240801153722.191797-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000013:EE_|DS7PR12MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: 74904c2e-cb39-47c0-d0d8-08dcb23ff37d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F8g9b0FQsKonG7E8E5cm246c3+A1THMzzoSlwMPoQU3VBe8A4mNAmVIVuRAE?=
 =?us-ascii?Q?/LZRcd1Xg+ONv7xQ8oAEP2ywJW69wD1GVkxSSfBkbhtA8j5twx5IzXWJX2Uu?=
 =?us-ascii?Q?f6Zbck8PPJxkcJ4bCs9fzYKbKSUvi3R/gjSHJbwKFdERSBOB3eMSR0tFDHvj?=
 =?us-ascii?Q?OZ+jjvsDTM3VbQZzcBInaIICiusceLYnyaqFN1uhajw0JjHuH51HV0ktxbrx?=
 =?us-ascii?Q?NCHIWWQGeXba6zekRVIo/Z3cHZrWck13t+//SQaE10hp4EuXgEOJgqe6AHtW?=
 =?us-ascii?Q?rVzQ5tDQfigytzMo8OrCYsrhvhWvOes76bmYcgLnKNc4MGqLZQKb5GIeTxHT?=
 =?us-ascii?Q?Cy5XDdVb25JUWivv5B4y+kBoUzjmImPx1LdWhu45utixP0t1EMNa597f4/xG?=
 =?us-ascii?Q?vjnufECEQE2qDtaf+jNXk7y7lRkI339hYn2Ng5ETEAvcgjYjVxXO6Ss73/b/?=
 =?us-ascii?Q?KjeWLHzs14Xe9pYInFnWB89ojJz8OVC2pbGuE/dLA6Pi7zZ+Sk96XT/9btx0?=
 =?us-ascii?Q?fzE44bS+pqYqcfPmoD0gfaUmc4YwxGdtk7PFsxLti/0HsBAOwCTkCTjYVlyV?=
 =?us-ascii?Q?Q36X586X9To4ZXh2oMRUyHkxRCIaKkgWKxU83t6WqdlCfQeWJZR4PMSXvTcZ?=
 =?us-ascii?Q?P6I2vw+8W03tP6QIy1FTBpP52Ls1/AYZnHO0sDzQ0EQF6yUYRysa2GhGwBqN?=
 =?us-ascii?Q?MIE8pqXRFZNvP4nO3OwNQIsPkKb9fEr7XzpyjZq2EIK0RY/heD9PIt7Buh1D?=
 =?us-ascii?Q?vwnTqKFkVUxs4gFeow8edNLaECFC5UJp7BYaYiDkIZ24epUYjRmfZI7Fwh76?=
 =?us-ascii?Q?CeBc0UwVUxR+M1xZmUPQpmwQ6vkvzGx4ZJq0sX19YG2z6ctl6A354WDicM6G?=
 =?us-ascii?Q?puR/9N+abgaC5cwM1bY3Zl9+asCMgEOfdcDQqa4r2SQNHZHzVTIzO7fMWPi3?=
 =?us-ascii?Q?T5/rnxB7WYoe/JCqb/XPFunr7xWziLr/Rsv1mJiIjqPtDoz9NjAkEo7mpPro?=
 =?us-ascii?Q?z8RMRbXV+WpuN2WahyzYY03+YgsjES/ad37jZ771uyP9Kz1R0ef2tOXeT5OZ?=
 =?us-ascii?Q?CT6NC0T4DOsSUKlDPYI28ojnjDIQl8mL3R2pdVoYXad7t+FtYZx/fJCWF9vI?=
 =?us-ascii?Q?bqS+HXCEZzxUjsfqLBc5nhxX04AU9o8PTXOAQD6JG5CNqHWK6N91DEcPGbAi?=
 =?us-ascii?Q?HQqA4jb/PKw5oC+huQQfDPvyqnkqj3Tn+Zlwxi1VLJCwBvcPx3dBIxJofGC1?=
 =?us-ascii?Q?Q3AjQDrXAAnMuIrsPzi9+GcaGx0jOIi/ADE2MAwGukf0YEkVi8l5Sho9d/2a?=
 =?us-ascii?Q?cmcjUKYQnZYzShQB4X7oSF/6Xbk5AD2v6ZArjlQLcaZtFlmQE14yo2XsspjA?=
 =?us-ascii?Q?JV63gQc+ERsZ/wzc4r5CFwcHBADYj5g0lOcOKPHuy+E+BHO6j7omSaKwQb/e?=
 =?us-ascii?Q?Km0OTYEXoECDHNeTWG+DZUJV5jvh7alh?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2024 15:38:11.6154
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74904c2e-cb39-47c0-d0d8-08dcb23ff37d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000013.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6047

The following workflow triggers the crash referenced below:

1) vhost_vdpa_unsetup_vq_irq() unregisters the irq bypass producer
   but the producer->token is still valid.
2) vq context gets released and reassigned to another vq.
3) That other vq registers it's producer with the same vq context
   pointer as token in vhost_vdpa_setup_vq_irq().
4) The original vq tries to unregister it's producer which it has
   already unlinked in step 1. irq_bypass_unregister_producer() will go
   ahead and unlink the producer once again. That happens because:
      a) The producer has a token.
      b) An element with that token is found. But that element comes
         from step 3.

I see 3 ways to fix this:
1) Fix the vhost-vdpa part. What this patch does. vfio has a different
   workflow.
2) Set the token to NULL directly in irq_bypass_unregister_producer()
   after unlinking the producer. But that makes the API asymmetrical.
3) Make irq_bypass_unregister_producer() also compare the pointer
   elements not just the tokens and do the unlink only on match.

Any thoughts?

Oops: general protection fault, probably for non-canonical address 0xdead000000000108: 0000 [#1] SMP
CPU: 8 PID: 5190 Comm: qemu-system-x86 Not tainted 6.10.0-rc7+ #6
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:irq_bypass_unregister_producer+0xa5/0xd0
RSP: 0018:ffffc900034d7e50 EFLAGS: 00010246
RAX: dead000000000122 RBX: ffff888353d12718 RCX: ffff88810336a000
RDX: dead000000000100 RSI: ffffffff829243a0 RDI: 0000000000000000
RBP: ffff888353c42000 R08: ffff888104882738 R09: ffff88810336a000
R10: ffff888448ab2050 R11: 0000000000000000 R12: ffff888353d126a0
R13: 0000000000000004 R14: 0000000000000055 R15: 0000000000000004
FS:  00007f9df9403c80(0000) GS:ffff88852cc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000562dffc6b568 CR3: 000000012efbb006 CR4: 0000000000772ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? die_addr+0x36/0x90
 ? exc_general_protection+0x1a8/0x390
 ? asm_exc_general_protection+0x26/0x30
 ? irq_bypass_unregister_producer+0xa5/0xd0
 vhost_vdpa_setup_vq_irq+0x5a/0xc0 [vhost_vdpa]
 vhost_vdpa_unlocked_ioctl+0xdcd/0xe00 [vhost_vdpa]
 ? vhost_vdpa_config_cb+0x30/0x30 [vhost_vdpa]
 __x64_sys_ioctl+0x90/0xc0
 do_syscall_64+0x4f/0x110
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f9df930774f
RSP: 002b:00007ffc55013080 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000562dfe134d20 RCX: 00007f9df930774f
RDX: 00007ffc55013200 RSI: 000000004008af21 RDI: 0000000000000011
RBP: 00007ffc55013200 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000562dfe134360
R13: 0000562dfe134d20 R14: 0000000000000000 R15: 00007f9df801e190

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vhost/vdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 478cd46a49ed..d4a7a3918d86 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -226,6 +226,7 @@ static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
 	struct vhost_virtqueue *vq = &v->vqs[qid];
 
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
+	vq->call_ctx.producer.token = NULL;
 }
 
 static int _compat_vdpa_reset(struct vhost_vdpa *v)
-- 
2.45.2



Return-Path: <kvm+bounces-17144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CE328C1BCD
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 02:39:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 702411C2217B
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 00:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD15C134CC;
	Fri, 10 May 2024 00:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jaguarmicro.com header.i=@jaguarmicro.com header.b="WzsE+sp5"
X-Original-To: kvm@vger.kernel.org
Received: from SG2PR03CU006.outbound.protection.outlook.com (mail-southeastasiaazon11020002.outbound.protection.outlook.com [52.101.133.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389494A33;
	Fri, 10 May 2024 00:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.133.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715301477; cv=fail; b=lmds/ZUcONhZQzpeMvkRtFeHAkymegKKGAfGibdHGUjdSyA5umICBoiIkQ0zEBPfGVWR2k1u79jx4bwUipzZvB3HVMnCYmrDLKWXpa52dqN0msxIkrzyPbXI0oQsQkOgc1A2d1zVcTNvs2iclN/NWj7X5nyptF8aHv6phJENOKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715301477; c=relaxed/simple;
	bh=5vn1YGaQCnaKUz9iQLpCKwUxJi7HkkEnfYNsGr6hbpg=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=fL0hvMSIze4Q5qJgKfiy2ae6mvG5u1OELX/JYiFvLMlupLs7dczgDbukYYq0uEddLd3eLLqh+BXdVAnma6gSjLH0ugid79ZW5HHdHtuQvPUrSZ2SmTa7gSJfuvUni32lVTbZ4DPW3En2QDiH41C1sK4Xpn4r/AlCqraGxjS4q18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaguarmicro.com; spf=pass smtp.mailfrom=jaguarmicro.com; dkim=pass (2048-bit key) header.d=jaguarmicro.com header.i=@jaguarmicro.com header.b=WzsE+sp5; arc=fail smtp.client-ip=52.101.133.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaguarmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaguarmicro.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewthdat6nnuBFVlKBMtNIxpLz/N3mpUmx56yoYmbPMjqvUC62fQLAU5mMqxbBUNZagbW0MDnjttEnEd2I8VIS4sgeBgYGzaT9llwHSNKr8Mf1pHae8W66ZVKs2p7H2Vv7bohjpB+XvZpWwwohp73hw3x6pSxm7zLfpba8oR77KyXZiLlKjehcC0HHEtIkvPPqbBLP2quip8e4j17ADkoOhPdoAV6vF7lQbYn1yzUwLsrTjFIm6wnpNze9vd6jkMtBtNL7eK9x1tey1ABdvssBwl+q5JQWfDjx7JauWwzNV1kTtPeFpOp6pWJrulzXLQeH1Z1eVYCu8IKvxihmvKwzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AC1JAacRssBq3LzzaU8NpbMnKNxIhvj9sWlUpaIlI6E=;
 b=WRn9mP3OEiX44Zu2CrCZpA8OqAzkZcmA66U0LzYmBdw3Zo1JRHQuRCVZ/cZ2e8ssZKkXJBJjE2FMYixgQVwNIV92FpdHGgGiBSmjYWU8bUP3Pb2ieGvijGKFF3O8IYYZVWG808WeyXXw6ncRwSCjRrt1aez8czyuMiH8Z/DFnkLlpFz6D1mxLkHkfGmZVHDp54mDj46hdAzuqaURvgxpmYkKC1eoxuI99syN5vXbSQLPSVZVvEU9nmPiq9WN052CMlKk0kCrQqNkt3YBYbbMZ5fOAIO9jXggf+PDkx77RefeYfoLFMQeKg3N+waNurOXgH85h1IsRhKR3jFqW1tVdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AC1JAacRssBq3LzzaU8NpbMnKNxIhvj9sWlUpaIlI6E=;
 b=WzsE+sp5yg18KK4Xw68hoKVNL8EMIesgsXIXOsMyfDLOxe7rkn8mq8rEqZICxgFGg/iFNB/XWXFmT4g4nL0LNogV5VfcylVZbM6E53ADZ/36TqBIpiL9AKtkljOw4HpIxqBBkaIAH6h6l77CHnGlqYE0wDHVse+1oQL8ze0tojrusvqDxquVCMcN3VK+JXgr/x36YRaFscF5pLG7YQ7OO43UWSdYU4y2qUNmRGDtpH+cS4hMtnUT2hfr7Wsj0I5pyvHbr0rkpDDCBLOVxpekHrKkACXwiR1blM3koTe/olGAbHfrSHRbV5Osap4d48Y4Q/QbHlH/dkmpby8H1BH1XQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from SEYPR06MB5256.apcprd06.prod.outlook.com (2603:1096:101:83::14)
 by SG2PR06MB5431.apcprd06.prod.outlook.com (2603:1096:4:1bb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.47; Fri, 10 May
 2024 00:37:48 +0000
Received: from SEYPR06MB5256.apcprd06.prod.outlook.com
 ([fe80::ea7:4953:3160:4916]) by SEYPR06MB5256.apcprd06.prod.outlook.com
 ([fe80::ea7:4953:3160:4916%3]) with mapi id 15.20.7544.048; Fri, 10 May 2024
 00:37:48 +0000
From: "foryun.ma" <foryun.ma@jaguarmicro.com>
To: corbet@lwn.net
Cc: alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	angus.chen@jaguarmicro.com,
	"foryun.ma" <foryun.ma@jaguarmicro.com>
Subject: [PATCH] vfio: remove an extra semicolon
Date: Fri, 10 May 2024 14:37:35 +1400
Message-Id: <20240510003735.2766-1-foryun.ma@jaguarmicro.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21)
 To SEYPR06MB5256.apcprd06.prod.outlook.com (2603:1096:101:83::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEYPR06MB5256:EE_|SG2PR06MB5431:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a87dd87-31f8-49ac-2e83-08dc70896ad1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|366007|52116005|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NZoCsTHzVblDhF+BPq6oGxqW93F61/HaqKH5jJLl59SqjXD8H0r9VrFTyXQ3?=
 =?us-ascii?Q?2p+pWGerPT+Kr/YMjhc6vbjfo3JskVZhZvmk89cRusSFSEu+14N2UTiEiXAO?=
 =?us-ascii?Q?moSw8SVgVCypvU2+Kck4z7gNj/o4sEfMhHBy+DHHrLkXPtloE7LsMt5FXBaQ?=
 =?us-ascii?Q?4DyPf++AMn29e4zHD45Cipf5Fa6BcjtXHytGZQhXIznp7bEqE2xL125qr1fr?=
 =?us-ascii?Q?25WBjGYRtcyJKynlrlnAWS3octgLpdIxUS10ZbDFNjRqvnoX5jyktIwTorMl?=
 =?us-ascii?Q?CXHsZdn1ZOhtrWmDoLerdmPA6m06JW6Vxboif7XGusTr2hJRbq47oPbzV5ur?=
 =?us-ascii?Q?Vdpsu39K0yeGgrvJkgiDsb6x1a+jCRYImBQQL4CouXMzqx6MepRMq+UIHS2u?=
 =?us-ascii?Q?UMx59WJUG4WIcJlG5vh3g1iSIa4TZbUAc3XkGyRBagxFrlvrP9UR8FvtvIrN?=
 =?us-ascii?Q?CxLSAUDymlE1bQI0rnW9Cq75fPiTrv0MFy7uEuzNy4Huj5GzH5i0mjoe3lk2?=
 =?us-ascii?Q?H5Ftwk5bGRrkRDNXsPpe7bhGmHnSDi8ipZ2iqrJbPpf28KI8hLpr2w3JrCwA?=
 =?us-ascii?Q?Sv2ImSQlSYSOEDv+0WQoPeFMHEBjTZtB1w8WKDfdF3RAQFTiOPgYodAsYoMe?=
 =?us-ascii?Q?o9Vx5Q/UiXjFDUlom1IFznD74sB8GGgIs1oQa5cc/m39UUxlSE4g2ObiHrnt?=
 =?us-ascii?Q?g3pbfLoLPCuSncovO4vdAzeKPxdKuCat7ESLKwMENZgzjTE3EuATASbyBFAH?=
 =?us-ascii?Q?9HMeKONJ7e+LZ6HMxDkq+I8wi0HyFWrkoEPQ9ji2iHJSz17dqpK9jCazhS5y?=
 =?us-ascii?Q?ueGhy08YAkYKqy4xhF/Qq8kLL/dgROrJTB4PGKIrdEvP1JWs6YXSWBKTQ9rZ?=
 =?us-ascii?Q?dJ75f3HOIQCLxwXzwHD5pz2sqHYxm9jFSJ99j+yllYOJyqTi+FrdHlv0RIdy?=
 =?us-ascii?Q?LWtJXc23YhsPaYEK/UeXXfwKeXpeVYzcCZFY+76cvyBji937oqdkgm+nzeSS?=
 =?us-ascii?Q?idGAV4D+RTyjyEVRMfvkPPf7bqIX8L8OywFO/ZIjRB8BVd6Rilej436V2pZg?=
 =?us-ascii?Q?BQEW2cKkp+573pDO/kboJc523pSEjkB1Wa1rIRHH5txdSIBeGE9rWrdgm0wY?=
 =?us-ascii?Q?1trflqcqOfboyaXbfl1eaoatRNLKSsaoz9KzWVaev4DeIYSwu9/H89BfgK18?=
 =?us-ascii?Q?wN7qLbvZeyj4Mp0p6sJRWEK3R8xeQOUGuAg/iwLkySWqUG+i1sfwC4feQ1mO?=
 =?us-ascii?Q?aOAmR1HnSDOYy5esCrWRtSWRRPJhIaVZu9pzVmQhYyHkYyKDF3pqcQhxumZA?=
 =?us-ascii?Q?RkQm1JowH/4jeMmUsX3XiiEtsDgKFFkxzwFsYgAkvvH1Mw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEYPR06MB5256.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(52116005)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yp1Ruv2J2PUewv0xdONTBvujy5qn2pjcWKL5HSo6Ml1n66OBZJo4EMU6MRU6?=
 =?us-ascii?Q?pDxuLq6XEsY18csqyKdQcyOAe0B9o8KZEMgk9f0fdCaGHiCAI5jKmz3q5abb?=
 =?us-ascii?Q?j93mHn5K4qYelaqnyyJIFa8CS+oFKsOR2eSLKzhOqWMZP2UvlaRb8LYKlCIv?=
 =?us-ascii?Q?DrdAZdP7sKeGhURUck2avFwJKtU2XO7RabwecWyI9TS+QHdWJi5ZJoS+G4Kq?=
 =?us-ascii?Q?Pxx1rjQsgnuX5t5tISec+Wi25yfKZS++AxqY8FmMuA2GSHlSc6WrjW7ky4oc?=
 =?us-ascii?Q?JuhG7awdKPaCzrisjUZVmniuzcEu1AvUubMKZMhS4MVxwynpBEre14cTbQZ6?=
 =?us-ascii?Q?zbF6KPAIor4LlR4PpuuirSyDhCbyaoH8WdeTT4hB+PI5BTCR3JoNjtVGadYH?=
 =?us-ascii?Q?D4d8SvbH6xsvThUv1NgaTWJQOVR4gMAT9yHgVR0hgpjDHRxYFdVQt+3s/nXD?=
 =?us-ascii?Q?20LlObANEAG7H9soNjc9GiuKuGWAXcfRTt2yqUw54Mkp2bc+wwFPWmuOjQBf?=
 =?us-ascii?Q?l3Gn1LeZNXzImCDgeEhUMhIoWXNWv+2pfpAgFMIQriTt2QDBnqLzP/x4M2dC?=
 =?us-ascii?Q?2gtJ5Ipa4MSGrvMb0GKiCIy1NigztfnWccjqoAiym+jm/mqQ0iAo2+VqnwZ5?=
 =?us-ascii?Q?3L5LKWSC2dixSIHOjQtXX3Bd3vTcfe/6Tto2B8emfi+MuWk5SOzaOcCJ25vP?=
 =?us-ascii?Q?/2Y2krk6ZhjYVgQ/TpSjdM65u3BB3L7XYWaSu3xvZRYZPYMLp86PYg3j9KPU?=
 =?us-ascii?Q?5r9kaI0Cm54dfz4eRl/r+76voyQClV3n0Z5mf2Q/szXjUnYls+nXY52e0nE/?=
 =?us-ascii?Q?gwVkca6s6xzWue5maVVkwDF9T2knj8elK2oxHYJwUnARIP3CxD0umTYfCW6M?=
 =?us-ascii?Q?G0gpzgA1eoVRQ63mKK3BQu9zvGzBmt8q/cUHtN934ig+WkGvbTZDyiWtg9sn?=
 =?us-ascii?Q?4itclaaV3hcYQqGRledl6ZmA9EvS8Zmm6Ab3kAHi+FwkM1tzeZ7ywyfybS3w?=
 =?us-ascii?Q?g8A1RlKHbUG3vkHT2X0DHJw2VzH6Gm+g1LUdQziInE7MSPEXlABA8itO4Qn+?=
 =?us-ascii?Q?AA2belKSlSI/5tHPmVW0VPsQh1enfpu3x87UkxKh8W0loHzVAbbGjtFI1F61?=
 =?us-ascii?Q?Zxd1YlFP2mlc9LC7SQ83cC54IrGqY+A6LIxEdjdKoqgC5Ea80eIYGW5aUeRm?=
 =?us-ascii?Q?Pgdg3JhV6gFMzRudKyXVN25CY6rMKZmEWH4ru+MLZi+6fRidY1224xZOkhOD?=
 =?us-ascii?Q?Dfv3cWmTCpV3I08PujrTjZ9b7sLswcQFc5cuu2quUsaZ81oo7Fz7NvdONBHJ?=
 =?us-ascii?Q?dbn43ODJwbV56hoea0mv5VhnTAnzghXqNZaWiDDyQypuFRAM4kXugMXCHFT6?=
 =?us-ascii?Q?IMcIw9r5+4gnhQkmNPKcpI6HKVZMHxLNSx7+gpZjTF60jp4WnlAMdKfN7/cc?=
 =?us-ascii?Q?Fag8LCBH92kXWYCe1w91m/3ttxeKHGGKU0q/eQHaQSK1vo00xBF2eYnBA2wu?=
 =?us-ascii?Q?kKZ9067Jy8bRPlnKGK1jCVUJwE21SiK0tB9IW+EMuEN69zHQwO5L9VYiRf4T?=
 =?us-ascii?Q?5mCvmYeDeL+0ldzagHEmxiGn+31QnL3PNBdt4sBSQ3Pnipk14is1uoPawsSw?=
 =?us-ascii?Q?tw=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a87dd87-31f8-49ac-2e83-08dc70896ad1
X-MS-Exchange-CrossTenant-AuthSource: SEYPR06MB5256.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 00:37:48.7044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PsXwlyxbvCNOIpsqXc6ILexBAG0TNCORjBmXu8XKC+K7sp4dfgtu4qFhbSqwR+b2p4hqTF8K5/50FCh6J9UZO1Tnm+CSDRtqISfq5HP3zrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB5431

remove an extra semicolon from the example code

Signed-off-by: foryun.ma <foryun.ma@jaguarmicro.com>
---
 Documentation/driver-api/vfio.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index 633d11c7fa71..2a21a42c9386 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -364,7 +364,7 @@ IOMMUFD IOAS/HWPT to enable userspace DMA::
 				    MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
 	map.iova = 0; /* 1MB starting at 0x0 from device view */
 	map.length = 1024 * 1024;
-	map.ioas_id = alloc_data.out_ioas_id;;
+	map.ioas_id = alloc_data.out_ioas_id;
 
 	ioctl(iommufd, IOMMU_IOAS_MAP, &map);
 
-- 
2.17.1



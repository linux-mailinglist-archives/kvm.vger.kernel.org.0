Return-Path: <kvm+bounces-18392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF9A18D4A26
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:17:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C3812820D2
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:17:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 932F217799F;
	Thu, 30 May 2024 11:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1L5ZO1qf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5041416F0F3
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067811; cv=fail; b=DPWnKE7xYwIoF43n7jNIOprgCRLDj1h+xJ++lwzBnuLg0Nr7D9Gopp8NPwZcLUiCa17VbITZLr4oZO8g5zexnqhTyHDsMTJ9ygvdGcPmeBPJR2WkWouYUdwGj4bF2mwujqB+4lMD2IXaZyqLk/sT5p9gWgqbW1dqjDzgjgEyrVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067811; c=relaxed/simple;
	bh=OlU79fW+oAqIF8r4+Q1tIBUS5LmkzdX+wV6EyWSbnHg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VUuL9P7DpdORdTaF9+b1XrnRRazmSYSgD/3G3iv/VsNh1RlrS6Nd58p0ufWSe+ZpXerAayh+F7VG7XoFsLZaaifI+oXihpIKzoR5PUAqShbp3qwrG6wyVsqAbUhvvwdE/UednY271XJiD7wTN40iIXscD2Su4N5rL1TlZMFSDCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1L5ZO1qf; arc=fail smtp.client-ip=40.107.220.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bmg4yI4X0hR5wxxil6w6dwHF24qvhP+DRKZNLe0JV7p6JMHjg8NrAV2eRF0btQ8ttJgeLbwVkhX0iDWdhTgkB9Ahuu1EjlPYolY8YwIPD2bsGbi55UdDtbvo84rK5BkKE096icXEDTIISReGCa1NqH7dtaXnIC3QLV7GaSMWlYl8AYar95+JWFZawhBGxMUzzpj4xDHndvGdh/g9nmlwcBEBBMykZmQdBz73mNOB3lYtmR5QUimBbOsXpPz7sL8th8DUqSv3BfY6oiIJzHpkipdrIlglkgdmmftS7bop0cqYoWDin/HKaXCsVUfCuJFjFZhTmh3tpBDI4BF3f97s2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IHDPUk3qDcJUq2+XauMilZ6tBTfb5QzNxjQVcPify5U=;
 b=naVuXZW/gqis8LzNym8UGdNAHmBLQ+FOmPMJuaZhkUEADRlW85WFNf7wPnIaKv5d4IVK8u7a1sU0NN1EYaQHUSDxltzkumkCL4PHa38d5RDz5wwhtVK5XkUkO9iSNWp9YJ0kp0MPudXHP+kBLTVbb6q//61XijOLfh9KuHfY5ks+8HVDYvIjTQyyu9APp0Ck4Pro6UIe7wqUuXcGQH7lQ0Uhj2KteKjX3kaCNwgRko5eP5MAsWUngHTmVdV06AenlIz+TCtNdnBfnOieE3+Yx32RHTMh/KCoVSqRcUo7z/tQrGnPvve7ai1Q5MJcuTliSLU5p9SPZZw1lum1eLs3zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHDPUk3qDcJUq2+XauMilZ6tBTfb5QzNxjQVcPify5U=;
 b=1L5ZO1qfsmHjHUF/C2F7CmN3M+U1pgthcs3hPAeXWDzvheDkW/gxVeb1Qs7/MgAcDXNwKx9m/itY/E7quAiGpnvE/ykkTqL7KPitsRS4TEywq6m7VJ8BZrRpPEetWYcjAAJv/JPamtPKUsrGjrKFlLOi8drQHUz3R8DvHn/YTps=
Received: from BL0PR02CA0137.namprd02.prod.outlook.com (2603:10b6:208:35::42)
 by DS7PR12MB6262.namprd12.prod.outlook.com (2603:10b6:8:96::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.30; Thu, 30 May 2024 11:16:45 +0000
Received: from BN2PEPF00004FBD.namprd04.prod.outlook.com
 (2603:10b6:208:35:cafe::50) by BL0PR02CA0137.outlook.office365.com
 (2603:10b6:208:35::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30 via Frontend
 Transport; Thu, 30 May 2024 11:16:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF00004FBD.mail.protection.outlook.com (10.167.243.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:45 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:44 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:44 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 01/31] i386/sev: Replace error_report with error_setg
Date: Thu, 30 May 2024 06:16:13 -0500
Message-ID: <20240530111643.1091816-2-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530111643.1091816-1-pankaj.gupta@amd.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB03.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBD:EE_|DS7PR12MB6262:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f98420b-847b-4f10-32a2-08dc8099fd8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BA2Ft6ME4jmqtZN/fU6pUCOLAsMt5ivr0OoAmH+RF7EjCpMP1MnfMPpTGHco?=
 =?us-ascii?Q?C/4ghJuUfrUHHSpMP8RuQAY/V/nQPtV7I1cYvRQMaREDexU/t25SAzDEmtZL?=
 =?us-ascii?Q?Zlqhox6/GZyf+B8ehb8fEwM/FKQUY72cRQ0VERON1NZcvu5VpqIP5bkQi/U/?=
 =?us-ascii?Q?8E75Y4lz4M33M8GuYG7upNoL4jnvZQMLq0wk4jK77S44l8j+7xnDfjAQ75mR?=
 =?us-ascii?Q?wp7A6uDSulgDrsimC/qVkR7rHYNBlui2neTf7WJ/ZuZPsTGs68aVvO0SGaYC?=
 =?us-ascii?Q?+nKYnQAT8VXHycJO5+DjIIdZqRZfLA01ceXqkasNdb5+ozWYyFMJKSkm+tUZ?=
 =?us-ascii?Q?CY+r2gcwbslbmUp1OabVsdr+65LokycNApOBDzsYgGY9rFqoib54le0eqSEr?=
 =?us-ascii?Q?XXrO4M1/qnyDRqOMPCX2QaH5AE/G9j/doK7zAcFIzMpUWh8Wcl111b05EMAA?=
 =?us-ascii?Q?nnwQIOnOLO1psPyPfHdSOOtnvJNmorEEmajRcnsmr+vC8EkzkCCjYcXSKyVa?=
 =?us-ascii?Q?1Zjlx47bFAuQNZYpP5yoQf5fjUd+6UZugWs+ewTPmPMFp4inCanKZ/CTOiw5?=
 =?us-ascii?Q?1GYzKhouZqz1urkfFOWwUxtVgASOBYLTvBxirHCEPWStufxwRQ+/BqCKbpLF?=
 =?us-ascii?Q?4TE1L66OpWci3rQTyUMev3+Q4POOltHthUA+NzNAl5/KtNtNOoR2AdR5ltUj?=
 =?us-ascii?Q?0+/WQLnU87Nc1mXUljtDPIz4SAjwwktBnK6EdNJ3L4WKzEcE0JeVofgAlPfY?=
 =?us-ascii?Q?0u+dwqGXSiZUADQAIgnTluBQ/KEh4AhNUsnfxs/Yakhqkbu1SQiVSZwVJdPj?=
 =?us-ascii?Q?iZKSMQmgwIgHZfJPhdEdsTn+t+7RU2xaFcN1ce4BV1eECWpWVU6fLp/OHODG?=
 =?us-ascii?Q?2kc4nheN9h38XVIPbxZGRJsbZMKMn0k8PAZm4AVeiGSOA+QaeUgfiZr5PVdM?=
 =?us-ascii?Q?p/HC0ssZzsqX46xPaV/ux/ZFWL1rUjNijZ7KOi1OUOcE4BkBrqWNYvfGLCMj?=
 =?us-ascii?Q?199Ms8IGjMvWHa/Ew8jxM4TZQD+AI3+0PFyGrwYPZzW9GubgIQzbsrrcaOsu?=
 =?us-ascii?Q?ORdSwCoZ3gBexnDG2LABSST3tz2LL9/R7jBCvgzNUMGqfGze/Eo5syRnyzQo?=
 =?us-ascii?Q?Mt7G2swJVcWm6UYhEfsmcaEJSJMcNEldPLgYk1pgoy4YNypEP5+HknFDGwq5?=
 =?us-ascii?Q?1jIoK2c27HQVdQCq4w0SwRLgjfCi608YAp1bWVqRicYVQqJ8wcd6gB288RlX?=
 =?us-ascii?Q?DWIthGNld5M3JzBQ0fo/2ExlXG+JO3ZOcIwAUzZGl2IUt1c9HqG4S5OuCnnv?=
 =?us-ascii?Q?NLguEc0JIDawe435rkIoZC+KrTuFtisXmgKwWspzgNp/4w800JakjXvdpk7F?=
 =?us-ascii?Q?M8NyM8g=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:45.1605
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f98420b-847b-4f10-32a2-08dc8099fd8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6262

Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index d30b68c11e..67ed32e5ea 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -952,13 +952,13 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 
     if (sev_es_enabled()) {
         if (!kvm_kernel_irqchip_allowed()) {
-            error_report("%s: SEV-ES guests require in-kernel irqchip support",
-                         __func__);
+            error_setg(errp, "%s: SEV-ES guests require in-kernel irqchip"
+                       "support", __func__);
             goto err;
         }
 
         if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
-            error_report("%s: guest policy requires SEV-ES, but "
+            error_setg(errp, "%s: guest policy requires SEV-ES, but "
                          "host SEV-ES support unavailable",
                          __func__);
             goto err;
-- 
2.34.1



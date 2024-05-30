Return-Path: <kvm+bounces-18401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CFFE8D4A33
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7DCA28203E
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D99172BA2;
	Thu, 30 May 2024 11:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LHM4H884"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5877E17D360
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067817; cv=fail; b=rZgJoJ4in1ZhWY2U2STz5pgZd9/ktP3lmRWOFnXZAVdQsPiiweN3cI4VbpJNFWZRU81BcFhFsH/nWmuGyyFIfmKGm5fZ4/UbN3qG/OWkVkzUBoqeIt3FXTIdONq0emoRMIzhIhSoLDOpUubRcxDYKaY4N1th/hGSlGyE8bYMflg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067817; c=relaxed/simple;
	bh=1csCMpSizQC8cnN6JmwQsVuT4QpuHdTaL/BLCdXC35g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T0nhP4aEOpfiYSK2pc+5qiUwjNbSYUUAV3CmaxOOuI1MR0K5q5KJmqcdaiRlu/Q/+wgfXSjyfMFCpKMwWkbHVAlnagUevBk7PVXDahPwMBLdlQHm+YXIoVERoDafRznArwYHjwAVlch7RnnOOppZfbigEmRFHcplrzxastQYOmU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LHM4H884; arc=fail smtp.client-ip=40.107.220.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htMEP7GVG1NHX069QoTwyXA79Oaj64/Sjghw7buP0i5Xa7GjdX6tTcqb+y+VEmHsWXWUseEqe9YkpbDQVSV8aHpT1P5bALrPcJIM+rssRqIhqTn9xzL6jAqx8e7wAKBEtgChe0hvVV8FxZOlUC9asBOD94YVOy5kB9tSzUsL5TO5xZW48R39bQlL6yeYQ+Tb4rK2s2i4yatHOsX34mC6Bl4eT4ibQgd2veJ7hvnpkgA/zjbUtOaNfZ9zAb9qXlOYsInE3lsDE8Dh130qlUzy1i40uRxp55lgPwOPJ9UZkhEZqgwLah6WMKmzHdFlPKKIoOm15Zm8QI/iGq/WICG9EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8S2vaPBh5th5l3Et1gtUJG79iJKaMlNF4hxcHHq+8o=;
 b=ibZUFv2ibvDi9F9YtEVjN6vORbCEWlFxg9De8nq8IaV/g2OGsLXG2v5kbfy6Qcfx70KwyzwwoZIZ8ksyym1Sr6G95HPw731qrHg0lIB5ALb9bta5pPJ0xB+TFf5FSs3twjgnOlGH0L1Aw4gP3v2/7G/ECG0W37avPFXUIv+VwoUJ1+ga2VL4DCtL3tRasZuhRMiSCIzsm1DM1WTrG4ospuKD6LbH0+62oa4c+eqYnTplUZBUrDqeWYOK1/G7py9gVj0yLKNoqUkp2ak43xXwFTkBjqEO1O1XwxFKzjBGQD4JVrDyoyo8g/aYKBwPjQTIsSZXZTmexj9i+oc1wK8zDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8S2vaPBh5th5l3Et1gtUJG79iJKaMlNF4hxcHHq+8o=;
 b=LHM4H884Ryr+37Nm3yp1PEsU2dMW4RMiQzOb/2N45KEDxd3XuLm+MeyvJN2HmtRcUfUDvo3gT9P0SaV/ffiLv252fnh0N9l1Fc3iDwANwqQ5QyQ0RjgeU6sSYyMDaRwv6FF6q7U3QYcPGb2xZR/yRaR3hywgP0RMEG94bMsLhkk=
Received: from BL1PR13CA0098.namprd13.prod.outlook.com (2603:10b6:208:2b9::13)
 by DM4PR12MB7501.namprd12.prod.outlook.com (2603:10b6:8:113::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Thu, 30 May
 2024 11:16:52 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:208:2b9:cafe::58) by BL1PR13CA0098.outlook.office365.com
 (2603:10b6:208:2b9::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22 via Frontend
 Transport; Thu, 30 May 2024 11:16:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:52 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:52 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:52 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:51 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 12/31] i386/sev: Don't return launch measurements for SEV-SNP guests
Date: Thu, 30 May 2024 06:16:24 -0500
Message-ID: <20240530111643.1091816-13-pankaj.gupta@amd.com>
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
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|DM4PR12MB7501:EE_
X-MS-Office365-Filtering-Correlation-Id: 5047e8d4-ba08-4444-3f6b-08dc809a0209
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rFrZXlhhUFMoR9zEcfqrNzdfPw8tu34mlzWbyklJRag8PwUTS4gqViOzmzBq?=
 =?us-ascii?Q?Y1ezlSiy1TJwwVs/mAnC9F+u2Bdc+2okAjPzMaHYMNrH5rpgTJlPXHUtvIll?=
 =?us-ascii?Q?r5sJzdW29a2az1sn7Vn4GU+nkvygs+a6fFk1YQI3UPoEhalSKOrd0dw4l97P?=
 =?us-ascii?Q?feFt3VFX/VYayut6+OBHJRu3eGGagLPkD0EEicMG5G7fORWVTh2MqvsYtjcK?=
 =?us-ascii?Q?2x5SW3gDAq2ikjqI89dYMb8J66CnyHFB3OYh6cOHUf3hrdMPd/G67iXqhtOe?=
 =?us-ascii?Q?lDj8CxJGLv0InTtlhkcCYCPMo7PxGLYtLjEqs3CAqnmP18wY/Xhw8sptQwd1?=
 =?us-ascii?Q?2q6r1+md8ZFS7C3Ukuah5R9XdRGH5vOMCaMZV5ukD/jgQfxr3gm/R36djQnz?=
 =?us-ascii?Q?2QbSmdNUGqhRu+bFkvZ4rSqzCvwxCbCbuxrUBlYNokMXhKwm/hFBpi8zA4ci?=
 =?us-ascii?Q?pPvToutuHXR0K1Pp3kWanEVjJpo8zY4kfx2ckIflWmmYPhqxXv3I75g5VfBZ?=
 =?us-ascii?Q?KjWUCvt+Itke/4SROOLZqBsG7PM4NhWlubDDUdW0JcQIF4vDf0jdUZB1f0LA?=
 =?us-ascii?Q?lZ3Y9Wbjj7uYdXHhliFBApMdZ+gj207Oxw/KzhtD276ePUf3sYWGpWnov9/S?=
 =?us-ascii?Q?GcILajzaCUUb8U0Y1/GowMjIXm8pAKmtKMsFB4KMKSR1zo1LyYHJKcxUDo7Z?=
 =?us-ascii?Q?v93Aoyebz/dyanaGtEDic94xaLdB8ZCSVP8oIlwIVmPs4lu9y3P/C4zvpwQg?=
 =?us-ascii?Q?4Zljf2/8EL45MB3eWxo5YndRSMG+zTVmRIY/Oqv2HNt5YQq1BD1bPphNV/D8?=
 =?us-ascii?Q?AZ3v+NGeW3eCh5RuowVcpeIKUVZKtbR1Fkt75HK9icNJqgSFApAoV6isGmrr?=
 =?us-ascii?Q?1eBMM7J/p+3K95n5K3KYIxiMd/fvUF4gUQe0rNToiA0rg8h3BVjUXL4AhlE1?=
 =?us-ascii?Q?9fpZuQFH4XJCAupF3G/NyAxQM+8PD68MS29qwhwSiMe3XWdA+hvzQA3KXOs6?=
 =?us-ascii?Q?deg8Q71wCDOhpvw6uqlQa2UUltkVUdKNgpdtWCW94TmnChbBb2nZ+Y+1b5Am?=
 =?us-ascii?Q?Mxpqcm8I9NecEhvN7DqC6fpFka9EVmIW2dJzpvvzSZHHpcwOO6IldL3+2IBD?=
 =?us-ascii?Q?LoRCUmDfGzrkk2riI6zNMXevOlWyre7Lnhtv2D/iemAQ68Rl8gdK2LxZ+Oq0?=
 =?us-ascii?Q?2gGPVZRnTiezNS5WqooMnu/eQ4SmZUEgykJyIl+N/vtGm2Dk3+jp1ts/ZqA1?=
 =?us-ascii?Q?WuEYmwu/VtXjRnfpsoYm81JPzn0S4V2Gt2laWFHYKMoM6FdNBSWy0hef7DH/?=
 =?us-ascii?Q?97P74o4Xa0/qK0i33djAU91S36O1g6MhAX982B8hYZgT8smhOPos2iqA9t4Z?=
 =?us-ascii?Q?rNuKCcCV2bT4Jp/E95ZUbvqhzSwI?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:52.6934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5047e8d4-ba08-4444-3f6b-08dc809a0209
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7501

From: Michael Roth <michael.roth@amd.com>

For SEV-SNP guests, launch measurement is queried from within the guest
during attestation, so don't attempt to return it as part of
query-sev-launch-measure.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 56c1cce8e7..458ff5040d 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -803,7 +803,9 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
 
 static char *sev_get_launch_measurement(void)
 {
-    SevGuestState *sev_guest = SEV_GUEST(MACHINE(qdev_get_machine())->cgs);
+    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
+    SevGuestState *sev_guest =
+        (SevGuestState *)object_dynamic_cast(OBJECT(cgs), TYPE_SEV_GUEST);
 
     if (sev_guest &&
         SEV_COMMON(sev_guest)->state >= SEV_STATE_LAUNCH_SECRET) {
-- 
2.34.1



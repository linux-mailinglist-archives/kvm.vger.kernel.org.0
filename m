Return-Path: <kvm+bounces-12245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8CB2880DD1
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:52:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E899F1C20F85
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A070E41C85;
	Wed, 20 Mar 2024 08:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SmwQoXPW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAF84120C
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924617; cv=fail; b=R2o8lzJg8LH1Unvcoaj1s/36dbLdpWuup5D/BJZMd0bZdXSjb2qTKFS18NzK2GM/7+ZDKzZDzDR1EvIgbM3tMX2xmNhvjVNYweBebtKrywIJm/b3nS/K5JcFIX6mMeYWaP077Y/2aWbrisNNwBbOcBkB45Yqa8NEisVLzndUP4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924617; c=relaxed/simple;
	bh=vRzv0Av7M/VFfRodQFzQmiX1R3tPCVGLMoAZYd2LEVc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GrIUBYVayKnYWd1HSJZHAL/R/1foWMEKNk0usRkUOAb4D5EjX2hU73M1PvL1ZCm8qo+pW97RbbriuY03451qabyMpTprA5HKq2GQoIg5QkaHh1GmSN4mzipvdvRKeYGd3dKNeg3SeRHA8zi027UOiENxmbxoBEMSGaX0Fqb/4Eg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SmwQoXPW; arc=fail smtp.client-ip=40.107.93.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BkhiWO2i+rQgi/A55Xr/AYStl+SA4qaU7jeK+ayU7hn0oJ8y5nlAA7r3rGD0co4Kn7LfoKmOM0UydOOdr2ej6M70CuZb1F5QbAdjpcOci9wPeML28gFj0CgMgQ0Lfo1phS9plagqTu8uUn1CWYNO9EfKWLkdQ263ALd04j5Hudf5gORlKt8ULJ//9g7ib6aPCEW7k7rAe7iO1duYeoXrfnjgRKoewE95vt13SvGKX0KWYkpg+Y/LmY18OZLRLRBXtUaFAd6H/M3pFKR+MtGFwWgHnLwe1JEQhRRCGANjROU38cQHN4ttvDSUeikrNPsK4+ZyHqlFgltRw6BVbXTujA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34C1YfoGnIhU/dOBQftedsu20IJfwfyy/w4rgp/Mw1w=;
 b=MNEjbPMgwDNk88areKeDjiJ0Vu0JNdyxzm2OqYbZP2YKznCp0TX9ss7XuLACl2ppfTGuanAtKmAnQKmkYF8HygTgtPBRKALDA0xmhyJVUW/7wjf+SDfa7EEMgvWKPRJC3zK6VSVMTod4rVKnv+58tCwu3OBKAOLJh7fNP/lWMwnhyRqNdWo5QK80OR6BQwY3eSPOg+soZx5XAj2QbcRtUtKeORESedoYyd+W+gIC58DjRadnrQpWGtVEE9QiSVaAeKEpHT6le+YNIq7aW9dF/+W5QbCdVVUVvruBXQQYXB1WR0iHe9oCKpfKoq//gNnMPS8PcxZB/Vkn/hmW7gbXWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34C1YfoGnIhU/dOBQftedsu20IJfwfyy/w4rgp/Mw1w=;
 b=SmwQoXPW27GgOq+u9RVqCOZ/tyfJvLsnIe0WIRjEIqX5hh1bXHZXHTiqjckUzGJNlGh/p6cmrXvsfTqTVfbnHeWzqT/daFAWgwPU0KB8YjSW4v71R299V+0RvwcSO/rJ+IYrn/QYn8cbSN9P3BWaNDygbUkeQnAEXVOxhZpZtGY=
Received: from CH0P220CA0026.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::22)
 by CY5PR12MB6599.namprd12.prod.outlook.com (2603:10b6:930:41::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26; Wed, 20 Mar
 2024 08:50:14 +0000
Received: from CH2PEPF00000099.namprd02.prod.outlook.com
 (2603:10b6:610:ef:cafe::53) by CH0P220CA0026.outlook.office365.com
 (2603:10b6:610:ef::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18 via Frontend
 Transport; Wed, 20 Mar 2024 08:50:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000099.mail.protection.outlook.com (10.167.244.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:50:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:50:13 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 32/49] i386/sev: Don't return launch measurements for SEV-SNP guests
Date: Wed, 20 Mar 2024 03:39:28 -0500
Message-ID: <20240320083945.991426-33-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000099:EE_|CY5PR12MB6599:EE_
X-MS-Office365-Filtering-Correlation-Id: d2b2f3b5-324d-4500-9e7c-08dc48bac203
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1XQ9F871zufoX/qh2H9iDbrDnPRbUXDNOkiIzxA6gRAP6Q0rC2zntrCF3gqssJc0+x4VIw+l4fw2eR1LZuldeh04Am9hN5rCPVTUx5rjzPvrUXyvDHLCFr4t10AYEg53v7K5lIK5TxNaTws3B7mzJDlPHayX2z0mKbjOZQEnUEC5y5zVhEd3XoPAOE9vvj7h1n99PioViRhxbCDMB8p0v/fo/7gupdl1uh31Ui1yiG47NJro2hQK34a6TD6I3267ho5FixkY4hCf/ByRx/Z7ADsH/2qczt0CPoUhMfBDCne0yaUaFr0STpbghZ6q1au2ltZ90a5/jT2tp+A0nwCX+q940IzxfBuG576FJRIwldf92vrGL+7aQ29bc6fldtVCV35bg5VrdGMUnP1FNkh4/VUwuKg4pD+4ubCeTsQ0Y1SpYJ3tOW3Yo1bsrbbD43XD8tQm/kDDurZfCnYgJoCfwOBs+qa+yz4AAmkEGPMZB6LGieoJCi4L4PQP4OK20EAnubt/KoXr+BGOjZ6rGfahTEeBgOHvjLfQjvJkLDxZ7b+5IeI0UePZBNzdhKEjqLDTZaA5Asolf5dRpNW4VqHxmHo1jriyipMrQxamYkssvvtHrV6sH8SaCNgD5ZF5GBehaq800Yl2SzFq9IDrTU1wSYjADQ5xoTm/77tZURXByQkuFxBwFByNhDLP9d71g/6gVWJeIEVHygmmiAQtbMeEB1llkgvzkuDhugLmk4aZL8YqdKbePNyvnuX6Qp39NqVo
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:50:13.5433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2b2f3b5-324d-4500-9e7c-08dc48bac203
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000099.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6599

For SEV-SNP guests, launch measurement is queried from within the guest
during attestation, so don't attempt to return it as part of
query-sev-launch-measure.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index b03d70a3d1..0c8e4bdb4c 100644
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
2.25.1



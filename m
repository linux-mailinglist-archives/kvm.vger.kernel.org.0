Return-Path: <kvm+bounces-12254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D74F4880DEB
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:54:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02F431C22595
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45CA93BB22;
	Wed, 20 Mar 2024 08:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AX9R+dty"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF10039AEC
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924806; cv=fail; b=X7RYYBpxSOsZ2bMxzopk3+uBTXjvgX4osM8F3yUoltTdok/KnGAjZauJ9Ib5csYuU51C5UPqDSDtk0uBuI82/QibWPSZ0rNcJIyQgEUwuCOqn99vFM1O2Q++R3vGKT6XTI4jlLV3iX28T3Bn+dl/4A/FyhTp+HkDX2cenjWCYpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924806; c=relaxed/simple;
	bh=oVo2FriQkKkPdSuDkhA2U4aLnLaOyecxG9J0ZOEF7d8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EVIB3su2QGdhHVH+Y+scwwB3LYuBEhsvUqnMMfEEGG/mks2JCIblurmpFXm7xGOwvpECXgp9YTMUeiO+j/tOzcg+3VQuiNcPU/LqIIbZfI3oi5XH/XYMhnKXcM1DqOemyPcUTHl6xaBLNMKTp1SjJxxXw7SUcrVFdOL5TagmJ7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AX9R+dty; arc=fail smtp.client-ip=40.107.220.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWNa5P+xgyzreRDexI8xtN+Q0pK+tNWL1UUo+HXRYWSpvfhyJ3YMYG3hiLhN8q/MsN8vX2ewdMHdKOX3twFU9SATSKfDs4RkQOiMrBsVbTTgoJyscGxh7ZhaUFl65HoLVGCHnavmvmsuEFr6/fVfRFQbaoP5UKbm/q07p2fvBNH2jOWJzi1Et8xiUY+dTuYAQuvYRAoVyIiM3ldvSvqCYMtghVZNxQMImfQD4uw2gU88A8o74MflQ+ctFy/XZJIT5jljaZbmPuIrScdUig0drTHrd7KeuLjmIIHSlNlca/o9i7MT28bdHrykwmie/DWAUv1+Q2vlHKn8x6IQhsK73w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5HPNI8nosuhp2hAjQ29ghlD9VELMdvXFv27zQ4Doglc=;
 b=ZP6qz8O1mOa7Oz7pTCwqpvtGzUnDHHqvvFYZ9g5NIT0XBj32ua8xBKssnweBMzVABTo4DgsK9dsJw+DadUU0+onWmiILTw3l9mVtclCSycq/cJhvBxAyBoMumcPz8S1OeP98k4wkMtVWLMEo8dzpcpjC+N/u2oJGAZMHU1rlHvJbZZkIAVqObhjFC6l2FzvAC7ZVk4zycMZTnYt/GASpQmvJcXWPqmZfk+7HIzHiR+DRRusuOO/0n9RUl5bDryqpdU/y8LlyYDPgovOb7yPYoGOwytoTGHWuN2yKIKfE13lM2nIdFUU7O5UxQ5EWYD+ZIclODu62pzufDhvgHOxmLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5HPNI8nosuhp2hAjQ29ghlD9VELMdvXFv27zQ4Doglc=;
 b=AX9R+dtymPCRZwExMyV8waZyRUEZEQidDCAFBC9rEX+ITCnX3d2Eex19Hw4WcD8+XfQlntoF4h1TYWibT6b4Ukiz/Su/adw+rdDjDDTR5FRNi4qdEm/5tjmisJBbabqjWS98mV4D6J44CCxk5RiB6KPvfocdpRfYq8ilMFifYKM=
Received: from BN8PR12CA0021.namprd12.prod.outlook.com (2603:10b6:408:60::34)
 by DM4PR12MB7647.namprd12.prod.outlook.com (2603:10b6:8:105::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.29; Wed, 20 Mar
 2024 08:53:22 +0000
Received: from BN1PEPF00004681.namprd03.prod.outlook.com
 (2603:10b6:408:60:cafe::78) by BN8PR12CA0021.outlook.office365.com
 (2603:10b6:408:60::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27 via Frontend
 Transport; Wed, 20 Mar 2024 08:53:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004681.mail.protection.outlook.com (10.167.243.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:53:22 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:53:21 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 03/49] scripts/update-linux-headers: Add bits.h to file imports
Date: Wed, 20 Mar 2024 03:38:59 -0500
Message-ID: <20240320083945.991426-4-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004681:EE_|DM4PR12MB7647:EE_
X-MS-Office365-Filtering-Correlation-Id: 15931be1-fd01-416d-2b45-08dc48bb32b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cSAWIcRwGZpNB6zHiLxxaggeaqJq8pY8j3uPHHW5SOTmjueHNrE8WVp7gS6XAESEcoon3QLMrpZzq0CPuvtf7Kyh3eveAQN0bq5kGg/tL4yVcwWEddc/oCtpAOVR5fNNniPoLt9DDLxMnjCU7XmZ2zk5HL8np2c9y81Jf3KgDVC2wnMHlh0G+H8/Y1BSHFCY288A2qNismpUjV74U+AKoVcoQLu9KJEhFrC4SP5jQanKLkUkkuPBAQ2SlQCD1+MB4GixhidNtvH00cT998zEk1F5UwRXFD3nbSIaI5de31DjMP+2eA5q5/etMBqfh9D4QMKDxVjMWCY7eIH1Sz3k5bVwg2WYTlfGvXs7WSRrtWvyFfGjzWmBRwwNgM2VBdlagURpTiJSonzO1GBx6KM1Wh0Fno9b3WLdXRoKiLzX/b1ogBzGTiNVuqVsvbje6LbuTpnXnaHNwcGI+VtASNZPLG3DKxsreJieGF/M6+z3m4nOrPX5Hue7IRVme1M6v/K9E5bnaDag1jmJrvO2IYB2fRhUAvqV6y83UN4I+ghDmQsKDJCj8eBQeozJAszOyXOYCPRXHeZSGzOlQsZ7WBgsmgtDZqJA3JzAcNFvmC24qrF8jfv33Za0eulXHaWman8R7TfktC0hs0ONDj1ysZvGRf001SBr75FRULLQ6HMBHKOd6/A9NKAtuj6q754QKUX++67U+ythvcFizqcT8ILBqadXvwXl0Qz8LGEgw2RJ7eNf6ieuvedWXUAQZmSbpz7j
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:53:22.6313
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15931be1-fd01-416d-2b45-08dc48bb32b8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004681.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7647

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 scripts/update-linux-headers.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
index 579b03dc82..b992ed7b15 100755
--- a/scripts/update-linux-headers.sh
+++ b/scripts/update-linux-headers.sh
@@ -168,7 +168,7 @@ rm -rf "$output/linux-headers/linux"
 mkdir -p "$output/linux-headers/linux"
 for header in const.h stddef.h kvm.h vfio.h vfio_ccw.h vfio_zdev.h vhost.h \
               psci.h psp-sev.h userfaultfd.h memfd.h mman.h nvme_ioctl.h \
-              vduse.h iommufd.h; do
+              vduse.h iommufd.h bits.h; do
     cp "$tmpdir/include/linux/$header" "$output/linux-headers/linux"
 done
 
-- 
2.25.1



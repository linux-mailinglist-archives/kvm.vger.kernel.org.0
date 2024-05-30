Return-Path: <kvm+bounces-18399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E06278D4A2C
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 991C928207E
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A1B117E442;
	Thu, 30 May 2024 11:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hRU1zE+n"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AC1176AAA
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067816; cv=fail; b=mA7zmB5OLCV/mNY4UvI86WAfdgdExWOlwB1jF4NezGp+pf/xp+CZGx47O0AztxSeO6xG8TxVkdeYyuAmz6ggrrkIgGWwgSZzob73ctIYUOXUPxxs9KT//X4e0imjqbqLOrcMjBEW603poKGu/Fw1FLPF9/602OVs+N6OPw/0mbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067816; c=relaxed/simple;
	bh=jaB77DNutYg8OBNrRnzvNMx8tRAKdcaM5Z4f97VLB48=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hnKqH080kuM2mP1VmRNJKbnphm2upn5S4ZFMYkNrla3vnjfOMEkBM1+Ky/4QEcmvVgXnvsUvYdNYqn2FQLy3JR2yVIORKhv0dy6z4ZvwOJKvAWKxZsU575/RvpO/w3vFnujUT+z3YExSOKFWpCEkga+/L32TbG80WkGGtI7NE3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hRU1zE+n; arc=fail smtp.client-ip=40.107.223.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXMcjqdTR3Xr+jfbLpKlJR7KBAHwtl8lJzJEVs94F40EjvHkaS584HNncDPIDuAfnP/YgA7NIzsUaoi/2x58W6qfjuHKGHgE0FhAbZ8JKB6SbPUfx+wyAoidGrJN3ZL0G6JZY2THQJVDhahwxztkq9wLqxLRzJ09ixDmuXEBQgrW1Nua7hkECJ0C9pLVLhMdK8gKnPEty+Gqw3AOue8Fxc1t+3QEpNTe9Hw/IpaLza0UeFkUC8nK8ahS+PZCMOXp8FCBsc5HYky2Fupl5e2lBgPHER74+uHNa0jRGYaZMT8t6OJn9Xe5oeJg5GWmptn/vyLv7DtJRvGkZr+MiaZy3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GfCXPruts55gOh3ER99dvMxSJNa8gwHv0r6YK/+ytZ0=;
 b=DVTz9uy86trZa+rGl+aFde84hG9piPq3HkltPB4uEGK9XnynMik2Ws03lQPJyz+hlHAb6A5fGa4K+STdEjzud/7qCJoSPgHOFdyoF0JOj3+NF69iK6XY3oW/ybRf3EEG7JZn+2Orj6Wq7/7o2jg29AHBfCAd5A1K4My8liVssxwaKOekEqiIWA2Lbb5SND0+q/vdc0aJB0q04wvJaNFtV8S9yELKTN7ESIekAuwHrx/jYoFKycRlQQv4E0Zd34n7TuZ6skQDZkzBqtFcA3uujNqszppoEgmFptEYhnjOPKBaMP29JgR+QNO7EQi2+h+5R519UL44uzhzCqj9gQEDEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GfCXPruts55gOh3ER99dvMxSJNa8gwHv0r6YK/+ytZ0=;
 b=hRU1zE+nkA8NbZzy9LGEQtDE5R5QXL6qvZ/x23m11C9cL0tauOL2slQRDfdsuN7IblIclTR7x+LfdyMoucZA0jfRI4GpKbQpy+6AscdNJkRRHG+cwmH9/dYOh7PrzMrboMkZIxSvqLdcGRWr63NpRVrD7M1me7//ZFCe+e84q04=
Received: from BN1PR14CA0019.namprd14.prod.outlook.com (2603:10b6:408:e3::24)
 by PH7PR12MB8106.namprd12.prod.outlook.com (2603:10b6:510:2ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 30 May
 2024 11:16:51 +0000
Received: from BN2PEPF00004FBC.namprd04.prod.outlook.com
 (2603:10b6:408:e3:cafe::cd) by BN1PR14CA0019.outlook.office365.com
 (2603:10b6:408:e3::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22 via Frontend
 Transport; Thu, 30 May 2024 11:16:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF00004FBC.mail.protection.outlook.com (10.167.243.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:51 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:49 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:49 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:49 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 08/31] i386/sev: Add a sev_snp_enabled() helper
Date: Thu, 30 May 2024 06:16:20 -0500
Message-ID: <20240530111643.1091816-9-pankaj.gupta@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBC:EE_|PH7PR12MB8106:EE_
X-MS-Office365-Filtering-Correlation-Id: 13ce287a-40ac-4413-814b-08dc809a011a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|82310400017|36860700004|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TyWxKWOUfKYvrl0qvb9coAvnyrbe8RdfYZ3YrVEtXjjikKCQ8aIStv1HzMED?=
 =?us-ascii?Q?e81FPaPyua0Crukboo741hPj9yp7htzGiu2Q+9fSgeQKG+OEmt1nK+PiKYZa?=
 =?us-ascii?Q?biyXfA4Lrmx6j8gFAdKE7xom9Av44As9FQtJrEFJnVM928hfeX7HJuIeYINB?=
 =?us-ascii?Q?LkT+AF+DQa3o73DvbqbRlmkqvhLn9TmjUIqKgewWA/zfbLXWzEuERIIjET+N?=
 =?us-ascii?Q?12fVvLy98RSkSdehCFHRqtVklqHbe68Gy56TfsbZk2cyrDlAnxtCji+sjoSw?=
 =?us-ascii?Q?nU2BJjBzlSCfnPXJBKw9rr/sd613t06NwXm8S7xA0JJaNivmvzfWB3/HrQgy?=
 =?us-ascii?Q?BouEJltlNfdRLRf2p8VxI9KczeHImbf8UtwlH1y3gWGDktL0KZp+FxaG+Nfx?=
 =?us-ascii?Q?Qvp9bEGtu2ajvWBr/CE2k5Gff+7xnIdynYGd5fxRx7lzVwLtd44NuU1nTl7g?=
 =?us-ascii?Q?f1Gv2T+Ndq2/AAlJX27XweZTjR62JisfuVnB/KIUmOFrGvWidX0fAo3gPXW/?=
 =?us-ascii?Q?+g5PJWT9Bc5ST/HE/URmSuEu6rIgHgxF98PmPsoxNehxiYo/LReCyw5Jj+BR?=
 =?us-ascii?Q?rRd61RZC5rTkX1eBrnXqk+yXtwdZvDgdf//b2jHY0ls3QMZe4tdqA510ufed?=
 =?us-ascii?Q?eBc25Q1p8vJzTp55/yqaxAFoneic/cjqvr2+y2/wXpwMsIe6nkkOJFxHGrQb?=
 =?us-ascii?Q?/mw6E54gImIKk9SUEq6YV/ntT1dQ9uatKE/s5R7755UUkyJ1NAWs4kJDPaSa?=
 =?us-ascii?Q?KDcCR+lZE9HrGU6ZWhsDO/LQsKGWhUun+zUvBZU8TyIWb5PeTki9yN4+PdNV?=
 =?us-ascii?Q?bMzSrtc/xj2/zVy7RldocZO6bWaNBJGNtNC6jYyKP87h9NLq42C1pkJ+U2bD?=
 =?us-ascii?Q?84Ttye4QubyVejRj/TsuX/RFO6eA8Pzp+ev2uZo11S1Svqp2J3Dvh1kIhDFx?=
 =?us-ascii?Q?akH9njkHzqU/UOXd4t6U+Kyq70QyReN9BOAvyqdfsyKQAIIZVnWizmqXes8g?=
 =?us-ascii?Q?f0eyb3mzc/LzK55DT3Mh2c19OUHW361V+Ajfa5knNTCYkArwhmVbUuBVTiZ8?=
 =?us-ascii?Q?X3XnsvY6XRCm1PVlBmTBciW+dM0A9Bk/c1lfmvnBGMYmCKwk6KQ/dq5ZZjR0?=
 =?us-ascii?Q?4BQEK2J65KnX1owZ/imQdQPQRw1wYcubUQ1fLn3MaUxOuxO0D/k8oSft2hj1?=
 =?us-ascii?Q?ptbrC8EzP62W743Rq9VGEcqKmeoksp/jTMjHhlIDGG4ZhtxJcI6uXgKOlcA+?=
 =?us-ascii?Q?5QLUldO7MUs59uoQIyBPMYDMkezmbKVH26i51lc1FdfoN5W92DT6l9IoaCUd?=
 =?us-ascii?Q?EtwKki6HUbyp04YxjZedFmZr+/MCQG94Xq7j7QRjtJsik2DLPFV/6gve+tD5?=
 =?us-ascii?Q?aIpd7lKDN7j1njhvhokrGFxn2dgX?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400017)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:51.1132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ce287a-40ac-4413-814b-08dc809a011a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8106

From: Michael Roth <michael.roth@amd.com>

Add a simple helper to check if the current guest type is SNP. Also have
SNP-enabled imply that SEV-ES is enabled as well, and fix up any places
where the sev_es_enabled() check is expecting a pure/non-SNP guest.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 13 ++++++++++++-
 target/i386/sev.h |  2 ++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 841b45f59b..f4f1971202 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -333,12 +333,21 @@ sev_enabled(void)
     return !!object_dynamic_cast(OBJECT(cgs), TYPE_SEV_COMMON);
 }
 
+bool
+sev_snp_enabled(void)
+{
+    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
+
+    return !!object_dynamic_cast(OBJECT(cgs), TYPE_SEV_SNP_GUEST);
+}
+
 bool
 sev_es_enabled(void)
 {
     ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
 
-    return sev_enabled() && (SEV_GUEST(cgs)->policy & SEV_POLICY_ES);
+    return sev_snp_enabled() ||
+            (sev_enabled() && SEV_GUEST(cgs)->policy & SEV_POLICY_ES);
 }
 
 uint32_t
@@ -954,7 +963,9 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
                        "support", __func__);
             goto err;
         }
+    }
 
+    if (sev_es_enabled() && !sev_snp_enabled()) {
         if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
             error_setg(errp, "%s: guest policy requires SEV-ES, but "
                          "host SEV-ES support unavailable",
diff --git a/target/i386/sev.h b/target/i386/sev.h
index bedc667eeb..94295ee74f 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -45,9 +45,11 @@ typedef struct SevKernelLoaderContext {
 #ifdef CONFIG_SEV
 bool sev_enabled(void);
 bool sev_es_enabled(void);
+bool sev_snp_enabled(void);
 #else
 #define sev_enabled() 0
 #define sev_es_enabled() 0
+#define sev_snp_enabled() 0
 #endif
 
 uint32_t sev_get_cbit_position(void);
-- 
2.34.1



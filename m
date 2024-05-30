Return-Path: <kvm+bounces-18397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB1708D4A2B
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:17:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68FF81F21C43
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977BC17D369;
	Thu, 30 May 2024 11:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dg8k5c5p"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F5D17995B
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067815; cv=fail; b=m/Apb88I8R4/PRcLU5rM0fLQEFK6YKS11Fcn70MtRXewLZVaRaKrRz6x27y85439RRSsZO9yffOuia6+gfVO3iHkCHn3R1HnrXJF6f1/ufdmcJXYkl2qD6AeJMRzO3k9Fv5D5MXoeQsAUkodZmLTyFdWckI9MiXUsJ1nyIINzcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067815; c=relaxed/simple;
	bh=hNDVXJ3GxTp2Tb0uaTF+W6xoB3fjltQ1xxyHu9eAWtg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G3GxiVDhI2PckJcDPHI2LJQDuOTw4Ar20e0UknczkZobtLPoemSH6aHkn/1yHN8PdAE3kfGv+a7VBsvnhUao5Ip+8cMIr/tu36VyETPPOIkoQ5FxwQwriJPuPnnv+z/TjzAnuDHwdX7Jzsp/DVjvOPKmGK5152djK3AgcW2U25Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dg8k5c5p; arc=fail smtp.client-ip=40.107.220.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnI3RY/7vkROxHND0obO27yBl58Tj4AcEB07H++B+X+oNS0LQaNiqvh4/pUGjcb+PYi0aia5CY32/NJMzuHPTccNJAhEJyYxr4in2iNV4MxSznaXJMrlv0EW5klhDiiUlDxHqkPSTVrGq7PL4DW0q4rqbjYEcAwWJtVYPvpuu1QGPM4VkcXRma7xMUYa6gCdn6ZDhRL9BdF5iH58Ps+IBgW5YBL1T6WW74QM8PdcTuAj4lW/yhoDZ0EGtaS8TWpLRvD1QvEHodgQ3cZQgFRQVZsU/KUXznxU9/5jipUv+AAy3do5p5XA9l7DhSerQOrODAPMVkfpWr4TeiIAPd3oCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BJ6SNAB/eiJuKzZ1KSTGlcuvPgGATe/M/aAx9u1UViQ=;
 b=lVyQT7mI87DvLfKVMJjv8fZt6HDyUnIdZSqfa+kXgN3FipUVsT9VkuvtIZmPrdUukUNC3h3p/qEJpBw90D8+p128L8fcPd/f8hD0R+2LtdLP0cw1WgpBZDxXZbfXqLH48b23iprT5DbRb0dvvTLbXvOa1TvbyIdDNXuknIY8HwmDNMu4bonQJaSYIUAD4MzM0NHh4b1IGsBvwTIviAjCHXoM3ByrWWLsoX9sLOvArOuafwBWWnt+/29ZFV2ETJVn0NIRDmYgLD/U5OXFKNDcbvkdDDUpuvML6fDr7HCdkHFq2cuL0TBtZJSne7AbhSu324J5TFtjP1BbkzoL6AmkAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJ6SNAB/eiJuKzZ1KSTGlcuvPgGATe/M/aAx9u1UViQ=;
 b=dg8k5c5pjkLNZNI+lts3UtPRZpjAKhfMHBWorRuBsMC/+xy/BG72SxRIV83ohPufMlkR1Ou0d0M42Sc2HMppXEMwovcWfNDLvbCVXlO101sUMGxDjgZikwIbDSelZ3lApj6ZycrMLZIre35m0ZSdexNwSQqkNdrlenIu6h0K4YI=
Received: from BN1PR14CA0026.namprd14.prod.outlook.com (2603:10b6:408:e3::31)
 by IA1PR12MB7493.namprd12.prod.outlook.com (2603:10b6:208:41b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 11:16:51 +0000
Received: from BN3PEPF0000B073.namprd04.prod.outlook.com
 (2603:10b6:408:e3:cafe::d2) by BN1PR14CA0026.outlook.office365.com
 (2603:10b6:408:e3::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.18 via Frontend
 Transport; Thu, 30 May 2024 11:16:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B073.mail.protection.outlook.com (10.167.243.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:51 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:51 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:50 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:50 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 10/31] i386/sev: Add snp_kvm_init() override for SNP class
Date: Thu, 30 May 2024 06:16:22 -0500
Message-ID: <20240530111643.1091816-11-pankaj.gupta@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B073:EE_|IA1PR12MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: 426e4472-446d-49aa-5223-08dc809a0148
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|36860700004|82310400017|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zRvVRdKhKf7Lsvk7azx2AfQ9B8veGJnjLQLesAViWCtxZ/V+1NtQ8sb1jc1M?=
 =?us-ascii?Q?lsZ01gNtpjq8SEHRLhcnYMzzEEsE6lNNXAguSoqXKMMOuu6r2dMF6x04RYVG?=
 =?us-ascii?Q?4GvepaxiE2kizKaNljUijv4aMO0tGdjfA+5wZzqsn2Hy5gvl8/ZDMGJo0NuT?=
 =?us-ascii?Q?GLQsdrk+Hvj3PUbXsKfOXz3OaiaXHaTsGReVg9A3OtOBsCKdynY9O/YWTRpw?=
 =?us-ascii?Q?2sc1kiZwF9ZZjYNKvNt+0vtgOBcamuK3RMyQcFu1MbHAn5DPCebZWO6JcsWL?=
 =?us-ascii?Q?zt2pvSqrimSZEUIwrgJA1wOc5A+PQJcONk8Ab6UbyYH1gKwPDg79F3/sjGVE?=
 =?us-ascii?Q?yrSlE/OlAtYzrQKM89t6H8mIqFakMFSIPZMH/kEzXz4Vp2dydy2QLynhBTXp?=
 =?us-ascii?Q?Jbzm7l3L615FdWjcJ9Oq44Z4jYB8EhZeBZemLPI0OwawoT0LZmmMsr0w+Sik?=
 =?us-ascii?Q?6Kk8GTWyzwcidOgmFu2ZNdi8duls0eN97jGHW1zVs/xojiCqF8yFD5C8Ssk5?=
 =?us-ascii?Q?Bsh4UwZKxSzh+Riph0vCGXpV+EzJkmrswDQ/iphFsMxo2k7TxVWT1ZTfkPmL?=
 =?us-ascii?Q?NE0kHAUca8h93bZU5GOh9CEsxC0BJKWR3iZiRPIvEiTIwe4XtEDJ8ufmfgnz?=
 =?us-ascii?Q?7BeTRd6Xw1ld3kjjkWJoukohXp0epUAS2K5Imq70XW6tXpFxrWzQn6x7/19+?=
 =?us-ascii?Q?Yr3qbu4VcYjBC8WQdrvZMBFkq9E47qYNRkPzCVkKzf//AlAkbk6+1XwjxwFZ?=
 =?us-ascii?Q?uk8j3sdyo3dcrAEIYFqBNb18LuiETLulvIYeHP2OkfWENiRHSpJHrBQemS5I?=
 =?us-ascii?Q?cXawYqC4CHhxJ4O2NolmCcjKQy3wPa14ZwfYJSJjVjI7U9tVe6QZ5Lnfabxg?=
 =?us-ascii?Q?07/rCftkdeTgSAk54Q52VZpgUPJrheaa5HPajxARa8MGa7HWaVRLhjLk4OqT?=
 =?us-ascii?Q?ggpejHQ5OMstdD2v3TkBhyk/h68hUK6pa52BEN3Xr8Bw57LMX2b3TAmznYHf?=
 =?us-ascii?Q?RcEubc3sQgOD+sYGQlD07cBDpZOfu2T212vXq6NG6PWCBRcbgSsWWQfaU6oT?=
 =?us-ascii?Q?x1wBhmFiqZTxEDFqC7pOhX1pnm8jZyuT7u0W5PIagkO6+YAjLHbw7KJJ9xGb?=
 =?us-ascii?Q?PLiotWMP9GW6Z9+uhIyIw7fBfGFfGU1mJymhCV3qZ2dD6XImd6pumiSHTo6b?=
 =?us-ascii?Q?VKh4W1QoNW52vToPrpr1v6paGko+Kj0QMqO0WEM7CfFRJn8hThS9Xr7cX0+0?=
 =?us-ascii?Q?qWVzW2OS6rq+LWoMOOZcMTY9HVpFojWz6uCrUCJZSrAMT8R7onPHxwbRsCU4?=
 =?us-ascii?Q?rVBOk4zJ7sbV88HTCxn7LmBfbapRvLujP9ZTP9EHlIrHq3RWXJ6OUp9R0b8D?=
 =?us-ascii?Q?7f8GKAwri2HbYIfYPrZPWmHOC5aP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(82310400017)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:51.4134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 426e4472-446d-49aa-5223-08dc809a0148
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B073.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7493

SNP does not support SMM and requires guest_memfd for
private guest memory, so add SNP specific kvm_init()
functionality in snp_kvm_init() class method.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Co-developed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 2a9a77a2d9..56c1cce8e7 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -893,12 +893,12 @@ out:
 
 static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
-    SevCommonState *sev_common = SEV_COMMON(cgs);
     char *devname;
     int ret, fw_error, cmd;
     uint32_t ebx;
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
+    SevCommonState *sev_common = SEV_COMMON(cgs);
     SevCommonStateClass *klass = SEV_COMMON_GET_CLASS(cgs);
 
     sev_common->state = SEV_STATE_UNINIT;
@@ -1038,6 +1038,23 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     return 0;
 }
 
+static int sev_snp_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
+{
+    MachineState *ms = MACHINE(qdev_get_machine());
+    X86MachineState *x86ms = X86_MACHINE(ms);
+
+    if (x86ms->smm == ON_OFF_AUTO_AUTO) {
+        x86ms->smm = ON_OFF_AUTO_OFF;
+    } else if (x86ms->smm == ON_OFF_AUTO_ON) {
+        error_setg(errp, "SEV-SNP does not support SMM.");
+        ram_block_discard_disable(false);
+        return -1;
+    }
+    ms->require_guest_memfd = true;
+
+    return 0;
+}
+
 int
 sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
 {
@@ -1761,6 +1778,10 @@ sev_snp_guest_set_host_data(Object *obj, const char *value, Error **errp)
 static void
 sev_snp_guest_class_init(ObjectClass *oc, void *data)
 {
+    SevCommonStateClass *klass = SEV_COMMON_CLASS(oc);
+
+    klass->kvm_init = sev_snp_kvm_init;
+
     object_class_property_add(oc, "policy", "uint64",
                               sev_snp_guest_get_policy,
                               sev_snp_guest_set_policy, NULL, NULL);
-- 
2.34.1



Return-Path: <kvm+bounces-7057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6AF83D390
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:43:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44F101F2467B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6780DD272;
	Fri, 26 Jan 2024 04:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KhZVpj0s"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2045.outbound.protection.outlook.com [40.107.102.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283CE125AB;
	Fri, 26 Jan 2024 04:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244159; cv=fail; b=Fd8JiE5cUAqIM4UNw/BKn0SHW+DG4er6t+B/kV2jCkpvOXjmgsZa7YlkX6+mk3IeuItTHmJd6AQfucfZinpUw1Is2iPULh72L0YSbTafPYNtoUkth5/ruOKbCWTpxe9FTCpe5FXBKWW2I12ksOfXHiXDNtaGv2rChMtAB0QtVWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244159; c=relaxed/simple;
	bh=Yi8Ze1jMGIjJoGfwM5iMmb3itmZ4fHEDmJ1LwxDmkYs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AjgtOKeHT0D0IshJAYI6DtlIF/yG29y/BFGMQhXSYJ92z9nALtcbzaK7H0dAjJIHBBw7KKZMFOMXrn7VxVRbMRVe2XD9r8F1dowD+EuvJrUW9Ea0GsIqEk+kHkSQ0Mv9PEMLlLoxTxl2uT1dxBoVBCWTrDpUFW9f/7kLLuI3JEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KhZVpj0s; arc=fail smtp.client-ip=40.107.102.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWiyBsvkaStF8zJ0Kh+IHwLKdq7Gre2oAlu9F1h8h0d8FQNP5hF8M5qyDtO8sOZ5Mo+cxzZYyeWVBwASWx3qdu7sJYmxD3TK0d/xSKzNtXuEc9KSNw7Aj+qA1gQA+0Bn6mVzXBV1NhUB1kXC27PTI41kTgUfxgTsJ3CA4Tl8dijdxUOQ/taDC3m4Ri/ws8OAGQC4MLhsf8Ipw7ru3XKTzFord9vSc/O2E0wIkRJdAKdXAkRTodviF9pDWSr63JugDIiyslQMXyE4Vhtm/tQehNhAj5CDurH42S1sO3WmjTz2Mkb8OWSMtc3pAax1BvZHsjAgcdqVu80oquKf4JOaKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIRT4X+BHmhFMwKgtoHtLtgItgyKgjXL4IM1rRR5oe0=;
 b=CjG3dUY/lL8i21jrBBNVB9SaURWGdeCSEU/Lw13UFclVDuKZGtEFzDC+PXcmtyDt+UaDN9lRabC5ZY4HpPcr2Dt+zgio5ILjkRe+CuGl3wqkkwkDTGU1wF40HLqAxdUOItiiiiG5ibmIafjBIMO0C8L5Z8Z4ZA/T4J5usp1wnKymlAZpyhVykEksVFYy4I+Ybki5ePWbh01K5Hb9ZvowPFNXbZ4E1dTuzk4wz+R7EPNY50dvBcN+HWP8LCUCTcJ6F7/4chfPRIaROatug92My27NZoivN563/bXYAMwHPIehNHBjoPEcl51xluavLZOBjO+Ab0j5PVY8p2Qm8TzSFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIRT4X+BHmhFMwKgtoHtLtgItgyKgjXL4IM1rRR5oe0=;
 b=KhZVpj0skMvlZJBljCeQCjzHpn3N/Pz81st6X4r8JOKFSaIZFtqbe6+z4zPxA2Rlw6PNk4XdlsuMs43xBe/3b7ZzhdvFE4JMxKaPSU+Cu6sMDQ0FqCnj4yGwv5bUxFwBRt3oruaOow4JC2CWvw/qU6o7VanLoopUdyHAtlQgg/8=
Received: from MW4PR03CA0287.namprd03.prod.outlook.com (2603:10b6:303:b5::22)
 by SN7PR12MB7833.namprd12.prod.outlook.com (2603:10b6:806:344::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Fri, 26 Jan
 2024 04:42:35 +0000
Received: from MWH0EPF000971E4.namprd02.prod.outlook.com
 (2603:10b6:303:b5:cafe::dd) by MW4PR03CA0287.outlook.office365.com
 (2603:10b6:303:b5::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26 via Frontend
 Transport; Fri, 26 Jan 2024 04:42:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E4.mail.protection.outlook.com (10.167.243.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:42:35 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:42:34 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v2 14/25] crypto: ccp: Provide API to issue SEV and SNP commands
Date: Thu, 25 Jan 2024 22:11:14 -0600
Message-ID: <20240126041126.1927228-15-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126041126.1927228-1-michael.roth@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E4:EE_|SN7PR12MB7833:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ee5e0df-eb93-40b6-caff-08dc1e29378a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uZkSYZdwzoWmMd6bEqa0pFnR+a8nQeMRW79xJMbALVR61dmbwhviDXxuxduFv1Tsvpk8zELywWoonGZFoOu/9ixzsMVWEXKh6sI6xWXsmAsUSz4QN6tdOU5zByE3IV/ayV0L0/wBSuxIfFOj3eHEs/GeeKi8Sa2d6O24J/EEQSb+kE2RhbFdPJkOaKm+a4NFq0+3/pUr16Hc+l+e3oigLwkqAFNEHnE+wcDUEQC6JsSbb/CXXwLz+5jvv9F3kxV4bts7OWBjpHkMj2wUY6XKo0T7vN2MMuzxep2bp9KU2/eiQV4QhIGTrA0/7+Gk4kMguOGVw/2opJTSlo6HjaStDtS33SMPiKZVtEAIg5xcZgg8l28KAeGw8rCfaCgMe8dPTmWQHg+eGSDZG21jQiOTTYiRe6UztT90+2y44GQbkwTDmKNm9iZZUlvbFmVvQ3O6K39gYJxASnv3lqU3tDEMO9QsRPbDIqNg1Pp05ovthqCGvpm2f3QZyVd9gkvqvMxF/Gpz8LOsrCDLne9GreIbRrcCSANn1Lcla4mqSzama2f7ZCUc7kA6p/jBLmY7ZrJCLy7oQbXn/7kDQIrJIF7crwDIW956RB8J5e70E+2cz5CCt0JDj1//9awKfyGBSHz1QKT1KG5sZvCPz+/igA5hV6OHVleMYCOiul1BeZxsNfz4A9cGZmrxcnz7HHKKmN1hzM8JxTCqOu2bF2MCSZ+S7bGxarlnU1hQKCqKN30ICs/b4DQzEJ/Boxf5F0CsDXZXE2WlJwTDY/smrW6F4kwzUiP2mgYnjEq7xphM3yxG0VU=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(39860400002)(346002)(396003)(230922051799003)(64100799003)(82310400011)(186009)(451199024)(1800799012)(40470700004)(46966006)(36840700001)(36860700001)(47076005)(86362001)(2906002)(36756003)(41300700001)(81166007)(82740400003)(356005)(54906003)(478600001)(6916009)(70206006)(2616005)(70586007)(5660300002)(426003)(7406005)(6666004)(336012)(44832011)(7416002)(8676002)(26005)(1076003)(8936002)(316002)(83380400001)(16526019)(4326008)(40460700003)(40480700001)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:42:35.2540
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee5e0df-eb93-40b6-caff-08dc1e29378a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7833

From: Brijesh Singh <brijesh.singh@amd.com>

Export sev_do_cmd() as a generic API for the hypervisor to issue
commands to manage an SEV and SNP guest. The commands for SEV and SNP
are defined in the SEV and SEV-SNP firmware specifications.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: kernel-doc fixups]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c |  3 ++-
 include/linux/psp-sev.h      | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 712964469612..abee1a68d609 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -431,7 +431,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	return ret;
 }
 
-static int sev_do_cmd(int cmd, void *data, int *psp_ret)
+int sev_do_cmd(int cmd, void *data, int *psp_ret)
 {
 	int rc;
 
@@ -441,6 +441,7 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(sev_do_cmd);
 
 static int __sev_init_locked(int *error)
 {
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 8128de17f0f4..c7dd6ff9f36b 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -915,6 +915,22 @@ int sev_guest_df_flush(int *error);
  */
 int sev_guest_decommission(struct sev_data_decommission *data, int *error);
 
+/**
+ * sev_do_cmd - issue an SEV or an SEV-SNP command
+ *
+ * @cmd: SEV or SEV-SNP firmware command to issue
+ * @data: arguments for firmware command
+ * @psp_ret: SEV command return code
+ *
+ * Returns:
+ * 0 if the SEV device successfully processed the command
+ * -%ENODEV    if the PSP device is not available
+ * -%ENOTSUPP  if PSP device does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if PSP device returned a non-zero return code
+ */
+int sev_do_cmd(int cmd, void *data, int *psp_ret);
+
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
@@ -930,6 +946,9 @@ sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENO
 static inline int
 sev_guest_decommission(struct sev_data_decommission *data, int *error) { return -ENODEV; }
 
+static inline int
+sev_do_cmd(int cmd, void *data, int *psp_ret) { return -ENODEV; }
+
 static inline int
 sev_guest_activate(struct sev_data_activate *data, int *error) { return -ENODEV; }
 
-- 
2.25.1



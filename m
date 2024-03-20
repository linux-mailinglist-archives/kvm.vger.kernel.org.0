Return-Path: <kvm+bounces-12239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 45109880DB5
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:51:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A997B235B6
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4C33B2BE;
	Wed, 20 Mar 2024 08:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o37/kEG8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E8439AFE
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924492; cv=fail; b=khaVydxEpIeYvOoLJ2YIIg+18OcxVSwJj5fwzu40Sx1w2rXlImbBzvu0mLY9BCbvD0rASv8MXcl/YiyEVglrh86QlVoHNjMYFwYy3Bto2gm7H2RD+d67l8Fq0vwJ+S4dsPCiXAIxkY5vPxLsKLQknfGrfIPe185tbxqH8jd9n24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924492; c=relaxed/simple;
	bh=yXPDRHVdX80LU0Rh4Nx7A7S4x++G014E5kdkXdHy1i4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhYuSU2BU1xDjz5avm4XH/Llr7u3Vns+BEqcO1c/qtuvMlfaN4LQXT0pE1Ee9pLCM5wRRgXMxmEpniAWD6sS7HJKlkrn96UlbBNky0tcpH1xL8ufuNjw7rwgvZz+toIX6oc/JsqOI3Cwe7Vs6fjs+PYWlk50e+BgEQmEA94zFlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o37/kEG8; arc=fail smtp.client-ip=40.107.223.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJyfi5ap23Sd5odO27BHm+NzWSlc4tRrBWViCSkGUrsOQIE8pSyMN1CgU6m2+bRHNDCkS4a/CZBEJbOplC5g6rf6ZS4oJyS92MfP4etlHzoh+x456i6xXrqOhAffAtEfoslnt+syrpCr5XsOZoBCOPte+hM8d2ij1grtQywmdvkMi+nV0oBbRxxcA39s1XY9ikH4OC0RD7gkH4o7/MSL+nbwwEI/71326izYKvNMs8SEIJ3DQths30h4PmEz0jsT22BYCBNp4hqSSQkwhzKJRM1Npwv+9n+FIQ76X9Pm596MLmqYxWO1vABhoctDL95wvuBTRantAQCo1vKU/+on+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gAWXeU5FCXZgrtMbCoPGDFMxpIXgXuWjZAR95kDe674=;
 b=HLqTM6C7e6uiGv4ELrZnZbpfikZaaHmWiS2L805fU/dvamG5XdUFjZT9buLyLXVKZpQa58crOEcC0kHYgYYO0dKBz2pCPe2OkHqp+/yejFyAllVDZrn+EAKsdHZoWZS3TsMmMO1axPLR0KukL8wl6EliHvJ/ADhy/VQElxMkOvHKAyzEhLG4CBurabjkwQ2yAH2xTfHhItrmw+ooGj49qTHznykSqcx0gUQNEH71pV7Zq8swxCUzTCv7HrmTCIID2QfSA2aT2ckETu+EGYGzJjibqxdtnq8TWI3PxMemTB2sDRjEfLhKhfzbHpzUfXUnNKbWCOEQcIBrL0lb2SBLSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gAWXeU5FCXZgrtMbCoPGDFMxpIXgXuWjZAR95kDe674=;
 b=o37/kEG8oEKmE7fQ6ot/NzUY/EfnclDUkFTtkgR9uoWfq0ufyzdf1QCUCaVVyG4eZJZNxAKEcADn1nrl+cgudB8i8JOdcZQyCJeWPOSafBz/e9UfFiqhryeUx1kRIuYogrvg38kSVqx4GJ4c7CHxGPmN/7oE+KX0/h81TY6awrc=
Received: from MW4PR04CA0065.namprd04.prod.outlook.com (2603:10b6:303:6b::10)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 08:48:08 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:303:6b:cafe::94) by MW4PR04CA0065.outlook.office365.com
 (2603:10b6:303:6b::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.25 via Frontend
 Transport; Wed, 20 Mar 2024 08:48:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:48:07 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:48:07 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 27/49] i386/sev: Set ms->require_guest_memfd for SNP
Date: Wed, 20 Mar 2024 03:39:23 -0500
Message-ID: <20240320083945.991426-28-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ab5a55b-073c-4680-da0f-08dc48ba770c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cUoeTVGEkJrCYS6mEpYRwVUF/KO7QQz+Ut7RVBlibtZTuUlqx/uro4bY9YMoh6WmuvLbm1xtESq+IPq/Ke18JoS8X+mOTqaiTZo5XEZgcai6A6rUC20pMcgcZd5N6qk1IUZJHkvhNUOlR+uZ8mTVuNeAcLBgC0XSQgDXzWIFI+pIyqkKS1LpFJdK2GlGdLX45xYIHKedGwZj6rM8jFuylXaxEN5UsLAiPTX7n6Vtnx3eSKrOy+ZVR2qioC2C15BF+O9jxOSfKqV2wLIRCba1nhUOWk4Ya/innLEIDK1tBL2LCVZ/D8OAHeMg2qgaFyeuNiFsfa8vr6qo/WEEITi3LlI31ohb/pk7n/ekE/D+uZColejN71EEfZgQDw9QxsitvgCPV7jMfF6VLxFVRDO0qoh3Vn/kw4x/y1raBICcSMVLyCHZ7PSUHVj2e3TzLqcDiTAg3+sFSD+EWkMvgeVRVGAl5UXowfbJ3u2cQH4CmkfrWQ9wBKxZQVp0JO/qJvSgEtkA3EiuSVVovokW2Y1nZX6hfcbBmFzbJEGkbeJJinelctQbdyT5WtusXz3Pd0BQvDTcyisV3xU6Ses4VkWbbY2vdvvZK6Qej+bAHube0oc6hF5iVHkHTRMpRAlCMmMT+R26FzEbblWYG4irs7qOpsqBHYKocNfU+JZauTc31LlIZhmpWuzfv2ST5VPRGjWg/bJhJXCmCzpUOl/WnUZ3fj7fuG6+02wCuY7gz8RpXCa4kRC1FCkWrUWI0URN+UbP
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:48:07.6496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ab5a55b-073c-4680-da0f-08dc48ba770c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

SNP requires guest_memfd for private guest memory, so enable it so that
the appropriate guest_memfd backend will be available for normal RAM
regions.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index e4deb7b41e..b06c796aae 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -880,6 +880,7 @@ out:
 static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     SevCommonState *sev_common = SEV_COMMON(cgs);
+    MachineState *ms = MACHINE(qdev_get_machine());
     char *devname;
     int ret, fw_error, cmd;
     uint32_t ebx;
@@ -1000,6 +1001,10 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
     }
 
+    if (sev_snp_enabled()) {
+        ms->require_guest_memfd = true;
+    }
+
     qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
 
     cgs->ready = true;
-- 
2.25.1



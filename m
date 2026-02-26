Return-Path: <kvm+bounces-71950-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MNbCGJ4UoGlAfgQAu9opvQ
	(envelope-from <kvm+bounces-71950-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 10:38:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C6B4C1A38E5
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 10:38:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F60830A0527
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E3A3AEF36;
	Thu, 26 Feb 2026 09:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MPa7ZkIG"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010037.outbound.protection.outlook.com [52.101.61.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11AC3ACF10;
	Thu, 26 Feb 2026 09:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772097884; cv=fail; b=Iwf+0VhXKpY7VfBwrvFRHlHfoxDGf6e2bxm5am4MrldVvZRf+HCdhj42i3w5Ri+FP6JQixs4MRvkQrEXYLzThigxioxPJOsQxx860RFaCL1jA6KTjn40Pej6KWWg4oZDC8K1y101d+tN4mr6NSKICLTcbw7fJbRsVULKGo3ti/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772097884; c=relaxed/simple;
	bh=7I9v/BhHtBzhKqJMIUTeJQr2Vz43krmq63cEaZfq02w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I0JGlj88CdIniyQ1H2GF8TuQnmT3H4sR+TNO4GUJJzMg5sEMWUlDTVRLbficgq0KTDxQ56d4W+6a+tIBixEwYVWnTjfyJfgXVN2XA2+7eYgWlS3N/Ms2UHpTbn8drgfRLb4D7Zp1pg2knO2kmD91HZt+M+3l7H6jYkwzXmIg+eE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MPa7ZkIG; arc=fail smtp.client-ip=52.101.61.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jz038V9ppSBqNyOZLICL9Enf0hfBTvFa4XRrVk2hxvFqbROnBNssOKHNDqrX4SeKqevuVinKe6/ZYHukGHkeUAu/Yrn8sbOL6U51b8FjBTFIKxCPiXgaycyXmPj9rmi7J/Y6oO+oEyfqWvgF54xfvTiXQO72Qj/Mr5rtn+GpG/lvNYn65+hOMSdl8yVf8Hk4lwYAv9DJVO9s1cuJN1cVM1yso8vC5m1GgpkUPyaAjQClqtSz157aLmKFKLyMt5DgCeX4BY3RTBb+FynGaO3u9l8KZNet05vbdilEqskr+YJbfK9YcXJU7s3nkp73p0P17f2Zk0Y14fxAcBHrx2nnBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SdpSp1QPqLx2mijK9kx+7K35suAcFrgLfUrwObDFUlM=;
 b=Uuh88BQVrv6YvvhqyEKaSjm4pixSqg844+WIObnAnWPdvAgKu6AmEIJYUu59VhXE7dV9SFG5TMbPw/T1+Lo7yPVhH954JDo5PFQBPugHzIifY29aOmfhjPHjnQm47Pwc9zBna9st6UNVEqJlPKvEJTaQisGgugCPyVma58WB0jVhb24P7x9pcdfGYOTg6XNRuD2FYBM9gBOZYG3/bL+u7//oxXJk1pqqjMxVg2vRWHEoE9trUCrGoJAMvkJ0bXRBUYabKd/uvi1aE+JPq2u9Ayx/0qA5ojaNAW7XadvfcsBTrbRMBbucrJL7wB4FhcpZjMlQVxifingp2fls6ix/tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdpSp1QPqLx2mijK9kx+7K35suAcFrgLfUrwObDFUlM=;
 b=MPa7ZkIGNnQhxWD+p/K3XJC/h8glaZUCoT/thkSxRf/QOsAP432Q2UAicLw/EhBZy1wTDeHAgpMnLDgVXphwwUounuLolz/iJnwb8TAlClBTiOIhMpVMYmCdKhuP7IxzWp5EaSK7jJWjN3pB9C6KQos1fKKOFbP6RJErcZz5oco=
Received: from BL1PR13CA0234.namprd13.prod.outlook.com (2603:10b6:208:2bf::29)
 by CYXPR12MB9444.namprd12.prod.outlook.com (2603:10b6:930:d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 09:24:39 +0000
Received: from BL02EPF0001A0FE.namprd03.prod.outlook.com
 (2603:10b6:208:2bf:cafe::86) by BL1PR13CA0234.outlook.office365.com
 (2603:10b6:208:2bf::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.15 via Frontend Transport; Thu,
 26 Feb 2026 09:24:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A0FE.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 26 Feb 2026 09:24:39 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 26 Feb
 2026 03:24:34 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <bp@alien8.de>,
	<thomas.lendacky@amd.com>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <xin@zytor.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<x86@kernel.org>, <sohil.mehta@intel.com>, <jon.grimm@amd.com>,
	<nikunj@amd.com>
Subject: [PATCH v2 2/2] x86/fred: Fix early boot failures on SEV-ES/SNP guests
Date: Thu, 26 Feb 2026 09:23:49 +0000
Message-ID: <20260226092349.803491-3-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260226092349.803491-1-nikunj@amd.com>
References: <20260226092349.803491-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FE:EE_|CYXPR12MB9444:EE_
X-MS-Office365-Filtering-Correlation-Id: 27e8ce87-73c3-4574-fe77-08de7518dd98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	IILmFU1ZvKP+0oIrtTDz+XqQFIgqBm2/dwLL5acjSrwtHDHZ19Jx/YboneqiT68pnk7r5Jp/XVt/IDaDBB/afDizCMxQHqTQVEg5xZpDanbbrV5LxKwZnYrRkUQOmcuvNp/YHzEREl9zH5Wlft6//jyoTt6Bwus16YmJkKjue43S6ECCcLt+mcYefukYRLNmmMP5SObmwFi48Iks6G1yvo664l/zqoMFGM3PnVvsEuLs+3GE6VBDboJ863pliKpYs1U2gl3ieOm6XfhrbxYK2JUp9h4e7bibGjVaBGaxJ6OGEii0dwivoWYZw7rQQZ9zL5Jz0EPcQ9MzulSeZNwmHujRZmfWH0t88dIoIUU3uSxrpDvB2+1opiAGFiVsD5BBIGxk2fG/ZiwysetiGNZH+vm1Kkl8UN8WbMnrXZJWYvVooJafYeCB7YdW06U9W4es/Zk40cqmIAFpD9tDgBay9Brj4/TpZCeRHrBOQMe2Xub5zxYE9mynx4AwJCLkzw5oFIdX5L7Aq6MDVWU64oSuCVtT9Dp+l4NYvp91OizYg720jCA1pJTvZcPeJ1AyP1PyZpNgb1cNyZbrpLAZ1hTiiRY1OssITpMmRvfz970iZECRovOQEEEk/ePhgLmTcgwcJyWLxHsGRMtHIsRUypGP2DH0LG5havuppwLKsH90LN5TO9DgVbghtkPIC7cqBreIogi44iJ7IIHjhfSumSejCE1Q56UgqrIkbE7cZUHjDHoiz1gA++MU1t780VcTRLBpMsPDxp9bFDOf4QrA2Bnga7m/9icn72/+1oZUFtfp15y7F18TJd/CUFgGDgwuJ4qXa2IyMRCgS+DPB6GAbUynJw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8FlBqqawzQDvUXwyUlahJVQovzr5xRO61QQI7yqT0XL5pzcJ/LIxLokTk5ZeTqbeYTYWvlsCKYtXinIhrrXPlFF/KAXVhwgZSpX8M3YHYOw5J6U311iigNS8Z1MxF1FFQ8EwFiQtWjiUytc4b8RL88zmN2QkwUZPBV10CxLbzwCkcnhRD7/5k8/d6wBVJXZ+dGb4WbUKamAbQKxwAhUTpVu9RnKNWW2dqYhBBwnUgyRKAsCM5zPC6c96qQ6JSrum0ptvy1P7tUyb4+iNqOuf7fFfJ3G0JW3U5Lo5EaiIS1I/EtKjfMVyzwefT6dhgNrLpCXBGjZltSqMOw62Hp0akavt28vYsjou9Sp5aAl2OzZOzi60zP/uY6+yFXc9iUN6s3b9TlzsCdopRsdWhA6mxO9Yktzj3y0wXvpcILJyobbImA9AtIG6aCi3QT85bhW+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 09:24:39.0198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e8ce87-73c3-4574-fe77-08de7518dd98
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9444
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71950-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[15];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: C6B4C1A38E5
X-Rspamd-Action: no action

FRED-enabled SEV-ES and SNP guests fail to boot due to the following issues
in the early boot sequence:

* FRED does not have a #VC exception handler in the dispatch logic

* Early FRED #VC exceptions attempt to use uninitialized per-CPU GHCBs
  instead of boot_ghcb

Add X86_TRAP_VC case to fred_hwexc() with a new exc_vmm_communication()
function that provides the unified entry point FRED requires, dispatching
to existing user/kernel handlers based on privilege level. The function is
already declared via DECLARE_IDTENTRY_VC().

Fix early GHCB access by falling back to boot_ghcb in
__sev_{get,put}_ghcb() when per-CPU GHCBs are not yet initialized.

Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
Cc: stable@vger.kernel.org # 6.9+
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/coco/sev/noinstr.c |  6 ++++++
 arch/x86/entry/entry_fred.c | 14 ++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/coco/sev/noinstr.c b/arch/x86/coco/sev/noinstr.c
index 9d94aca4a698..5afd663a1c21 100644
--- a/arch/x86/coco/sev/noinstr.c
+++ b/arch/x86/coco/sev/noinstr.c
@@ -121,6 +121,9 @@ noinstr struct ghcb *__sev_get_ghcb(struct ghcb_state *state)
 
 	WARN_ON(!irqs_disabled());
 
+	if (!sev_cfg.ghcbs_initialized)
+		return boot_ghcb;
+
 	data = this_cpu_read(runtime_data);
 	ghcb = &data->ghcb_page;
 
@@ -164,6 +167,9 @@ noinstr void __sev_put_ghcb(struct ghcb_state *state)
 
 	WARN_ON(!irqs_disabled());
 
+	if (!sev_cfg.ghcbs_initialized)
+		return;
+
 	data = this_cpu_read(runtime_data);
 	ghcb = &data->ghcb_page;
 
diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index 88c757ac8ccd..fbe2d10dd737 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -177,6 +177,16 @@ static noinstr void fred_extint(struct pt_regs *regs)
 	}
 }
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+noinstr void exc_vmm_communication(struct pt_regs *regs, unsigned long error_code)
+{
+	if (user_mode(regs))
+		return user_exc_vmm_communication(regs, error_code);
+	else
+		return kernel_exc_vmm_communication(regs, error_code);
+}
+#endif
+
 static noinstr void fred_hwexc(struct pt_regs *regs, unsigned long error_code)
 {
 	/* Optimize for #PF. That's the only exception which matters performance wise */
@@ -207,6 +217,10 @@ static noinstr void fred_hwexc(struct pt_regs *regs, unsigned long error_code)
 #ifdef CONFIG_X86_CET
 	case X86_TRAP_CP: return exc_control_protection(regs, error_code);
 #endif
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	case X86_TRAP_VC: return exc_vmm_communication(regs, error_code);
+#endif
+
 	default: return fred_bad_type(regs, error_code);
 	}
 
-- 
2.48.1



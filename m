Return-Path: <kvm+bounces-12240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8991B880DB7
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D7F0283C9B
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E633D0AD;
	Wed, 20 Mar 2024 08:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5sYaLpYI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AD339850
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924513; cv=fail; b=WOdMFjgr757PFWLv9oYNIuL0x0hQmtP/XRAZLndaW/hqdzGeq486UR9+MfYRhzNb9p/QySLzRvnO58MBy8pcZAFm+27u5yWxrVwo2hyZUhfBwxDqL2n/CU+EbB2UrnZNNjvwmbkFlGRotemuY3O1eccnI848D1v4DkH9QZllk68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924513; c=relaxed/simple;
	bh=yJAIGk2UW7+spx2Dzy6jCBZwjGdE5LGlVS213agiiMc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WEF8spUmT4ZgxYRT6V8VSQepOMeAATiGsaUk30DjNTmXYtSm31Pw+wZBFQW3lY7oPjVeslvciq53HW+zq4XdWn0lvZDjVHu6AsJQzBlXpygOyE1lbdJhv7ibgxFWlXNLXP4NW5Y5vJVmpGmjskXGeohteKs8k7efLmaFpqmVvvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5sYaLpYI; arc=fail smtp.client-ip=40.107.93.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P05DoRmQbrZDpvwNzvPXNZ1KWhzKWcLvnmRmEHZY/zfKHpxFbduydRSvjeRGdWLtoMCmLptWESjCMk4vND3Cd54UvFd74g6MxWQZZ/6ZEF01WRz9Zms3lGDI4Huxxy8wzb6gg0f69hunpaCWWp9yTTG3Vt42g0VT3ruJ/IPRRiERjLa3kkzB/SMmwYglLacIypUH5JclAY7VEhlZHaZfQTu4XwKqZi6nNHgN7kZCMe7dNIG5NyFVg9WcEWDpgEkZezOOtdp+smEGQZwg1mvNuxWd5EaI4HX667FFLAZ+bZ3+N4PmGFDoSBgJys0SL38vwplqVeNh4GJSF7vvBj39Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mswT1AfKqBx1IghYuuHecyz+d8qtFC452e6jZy/oyFY=;
 b=H0jJ2nrUOkVTtLrYCncLQFlGsH4gS7vTq9DQWDJ0V4JHdV9dX/b0M7fXAAjxq2NqsIvz0uvy9xnbA+ibOEC0x8xaOwqZXyzibpx++m8DQDiFrToTy+S9Bsh/WdAQOeiXRJ4U2OLitoRVcMnE+14XQIao++kFrqYU3krP+b1ZLdQSAuTQwcH8vEUaiTmOIzsfgxV9HlqV1QPmt4XI7KHRX9PTaeeAq5sZ2ni+wD/Y7/Mz1ELAjVn7u+BnZ1mvVAjTDET4ryB6sFwa/m2Oeh0cI9WwtZErnpQkwATThBEpW5dTUtVyCq1hy5s9SSh5QcvpThNg0YX0dwivbHhgLx1YsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mswT1AfKqBx1IghYuuHecyz+d8qtFC452e6jZy/oyFY=;
 b=5sYaLpYI9rvvgmDag9vPr8XHeGd0t2dFtoSo11VWS1vI9odsChF2Y+xvdp+1gaAxYzqniKrertoWxO5NG/G+oVTBNnFwfHgQDN3Rr6DLYM9oVaeHImPoQjxoSPPXtggILswiyVtgjENIcKmuH9kUFxmQHb/RaKybvkV+DXr36zI=
Received: from MW4P223CA0012.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::17)
 by DM4PR12MB7743.namprd12.prod.outlook.com (2603:10b6:8:101::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 08:48:30 +0000
Received: from MWH0EPF000A6732.namprd04.prod.outlook.com
 (2603:10b6:303:80:cafe::33) by MW4P223CA0012.outlook.office365.com
 (2603:10b6:303:80::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27 via Frontend
 Transport; Wed, 20 Mar 2024 08:48:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6732.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:48:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:48:28 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 28/49] i386/sev: Disable SMM for SNP
Date: Wed, 20 Mar 2024 03:39:24 -0500
Message-ID: <20240320083945.991426-29-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6732:EE_|DM4PR12MB7743:EE_
X-MS-Office365-Filtering-Correlation-Id: 7074f910-55a1-42c3-24cf-08dc48ba842a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	M7X3ANZ/hqL5NmMRru7+R0p8KLFmnzwgtkLBfevs+xP/eh1GZro8vJ9paCEpX4aLc25sTi/CoNGkTuoxjesC8jOLKoI1/rZNjnVxPZZkO6QfkdPS+CMk8ewedo8QWpdlAzz5cAM8QBbvo+fWxsq/wDbeHoIF87/ZW5MbQTzJ57kCAp0P1+V1uF4g6TeD8NdcKv8ttzS6jN2bEsdEAnypnSZ9bAsFUUhPf/h2jsXPaFb3KErGNxGDspLdnwRsFTi62feZ7h2XVbsf7+xfS76qdeY9kNofPt/P8Yqji6EBnH7L37aa87OCZ1DK4gzlx0z6ApitzlDnattlBeQEuPszQBlEakl//5JG1YnZVwBTCykHdnvHH2/t18UOLM07NCfKr8eLH+S5rNz2pD0wU/XP43MEKWDlKD3IRp/xDrQdo4hj2Siqr9wXZv4aDtaQR1EJAPoNP2Mb1ZcYB76RsEPSZCPSA6dZexzUVZfNxsQ8O+3DB6co5nmuGpgwnWWi1LbIiU634+Kh7aJ2IfMrpniobPRAsX3OuKhoi8RhpzLjPRYsbasQ0ITDE88R3yj5WLKRWOXeXCt9JdEwviFVXSw4f+2iwqnmHqaTRS5DRAkv92GWkVbLtdIc3CE9eq9jYz80G8jaxEFohQWiCwcbAFCP5q0N13flpN1U0B2fi8CISgkeVwnC9gE2fKrdFh1MJE60TzNXh9+7jge8aKeEhoL7yyxT7NmoUr9wjLrG2KG9bSQMiJw6TpnNOmOuknWyvqsZ
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(1800799015)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:48:29.6676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7074f910-55a1-42c3-24cf-08dc48ba842a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6732.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7743

SNP does not support SMM.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index b06c796aae..134e8f7c22 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -881,6 +881,7 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     SevCommonState *sev_common = SEV_COMMON(cgs);
     MachineState *ms = MACHINE(qdev_get_machine());
+    X86MachineState *x86ms = X86_MACHINE(ms);
     char *devname;
     int ret, fw_error, cmd;
     uint32_t ebx;
@@ -1003,6 +1004,13 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 
     if (sev_snp_enabled()) {
         ms->require_guest_memfd = true;
+
+        if (x86ms->smm == ON_OFF_AUTO_AUTO) {
+            x86ms->smm = ON_OFF_AUTO_OFF;
+        } else if (x86ms->smm == ON_OFF_AUTO_ON) {
+            error_report("SEV-SNP does not support SMM.");
+            goto err;
+        }
     }
 
     qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
-- 
2.25.1



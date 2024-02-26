Return-Path: <kvm+bounces-10005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33F49868334
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 22:36:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85EA3B255E5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 21:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3212C134CEB;
	Mon, 26 Feb 2024 21:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1hG2VuFH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE73D132C09;
	Mon, 26 Feb 2024 21:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708983220; cv=fail; b=GtLxy7pvkW+XSqiOeBcTR8WmaMwS77qdX/htsy+3k3fL72Y0nOWk460jrJbTGl8sts00nb4ti6jtGNRIwURfgYiIqW90MK7erD3biFbYWL6IKfv/pjMxsGjA+1VMNVv2loqypdckL1WKd4sllZx5Qt2dYCmoh7XMbv89vAR0k7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708983220; c=relaxed/simple;
	bh=TWe/GoX7unY7TDsBKAQIyKabGHNwuZLS0FcVR/q6KUw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W6qqU1qpNjQPH8wmW7sVZxDn4UE5cm9i52SgeecoFwUx5BMZ7BxiryFHdLJWov9z7wX6ooCLcuVoopjQGndLTf8VNtk7+fsbLUp5ma399bRmDs//wdOoTZZ84zluGwPsY3SzJapLAxaIeqJEERXMfwP7WtDlvWItIKTSipgPmCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1hG2VuFH; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOVNnYipF1k8t+v4s2Ho3Fscilxu5L/L7l0q2DfBMZZ0LV30C7LlCHtlWZm7nr4RPwIilW3k3x7OCCL+QF1NRP5M3cdQFPdKgjXOt1qzNJ3DwWiqh56ozSb247+yEmIwU5iIiH8b59gbjrPp3IR57TyFqTezGVw/kX9cYNDr5bvV3nd0Ac41aQmzzww6JD8qsDU6tQyCAaKKAx57F97JeOvC9J06XfXO5Zjv5FiGqMg6zTEZ7rrbBOxRRf9DLnYzGDnHeOeJZCJETazrFoAp06+hh1jszT0EEyoBAcFVxNtma/wfcwulWslRYSI+pjFSpz20EUy5siY+j9AQY3ESkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/SkAmPau6YEGtzE5zoZz5RgHpEsEQxHwBgGGFR+//N8=;
 b=iR4gUzjirUZzI/9Rfl9tDO1+CzbSoPpJbN818wtUaYlAJbs629p3K83sr4cokpdUX3Ew8BojZX3PR9tDSPFV7qpnfwOQlvmOm9CZnUkXw79aX9n6Zt8NKxgHXmgQufR3fduN1HxFVLnOzAJwrFImhZjlulRizp+/OHm0tV+fRgsZI9MjaedY3IPcYBgc0WOfSmssiUAA5upiRXMGu+dJ6AZZjQXto6QIAS1/KSBaEsR6Qny0gB7ivPUjP1bHrIODjteJdmpYXZBIIC0tknTLpDKICFO8O1XHi7FaXc68/yhqvs9DzjR+SsfUoxbhkZT3nq6nt+PuXt9+LMtuo/AyuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SkAmPau6YEGtzE5zoZz5RgHpEsEQxHwBgGGFR+//N8=;
 b=1hG2VuFHDUPDdaC6NNEZy0wNqJ/T4uJabgSylW5y7bAvJzmNNuuRmHFSy15UweNf3T1M7+gBv6RLCzfkpaxUQBtcYB2y8LNQSptal9JXIxjNAJfHINJcJFXirLyWe4n3P9owWpeFRCDLIrjdHMaa/PCuKPvWm3QnuOpd6w8KgGQ=
Received: from CH2PR19CA0018.namprd19.prod.outlook.com (2603:10b6:610:4d::28)
 by SN7PR12MB6714.namprd12.prod.outlook.com (2603:10b6:806:272::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 21:33:36 +0000
Received: from CH3PEPF00000010.namprd04.prod.outlook.com
 (2603:10b6:610:4d:cafe::60) by CH2PR19CA0018.outlook.office365.com
 (2603:10b6:610:4d::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.49 via Frontend
 Transport; Mon, 26 Feb 2024 21:33:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000010.mail.protection.outlook.com (10.167.244.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Mon, 26 Feb 2024 21:33:36 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 26 Feb
 2024 15:33:35 -0600
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>
CC: <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<pbonzini@redhat.com>, <mlevitsk@redhat.com>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, John Allen <john.allen@amd.com>
Subject: [PATCH v2 8/9] KVM: SVM: Use KVM-governed features to track SHSTK
Date: Mon, 26 Feb 2024 21:32:43 +0000
Message-ID: <20240226213244.18441-9-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240226213244.18441-1-john.allen@amd.com>
References: <20240226213244.18441-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000010:EE_|SN7PR12MB6714:EE_
X-MS-Office365-Filtering-Correlation-Id: 152bf045-2cc6-435a-3b4d-08dc37129717
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mzUAIw+fXhad49XxIp/cgjwW2G5Ug9XBQoedqGUIL7+0qKmSy0z1tenhPDScty6o6vbr3OkPGPlP33KaHHQns+kFf5c2pVVC8natPeBPKQaYDP55x5ca9tgyUPnsy9C/G9Pwx5rUx7uMTPoe4Zx5hMRJeDFz70AjbDIbCg8662Mf11GsAYWMpoxCZTW4Db1Slf9s2A8GmR46lkhjDnIccFj9KPGqcfq0R1P822jjwHXoSa7SMv+DjQC3GlWPzmBG55T/KJ9CNpU9Duo4/420n+pnl9VWxTVzEFzKQam5sE++4ZqzNiocnVlQWV6vGql+YkGalNkDn3B9b41hn6mQNHrW1MErt1OpXbKmXq76NIT+rd0D8krKkb+Gct3DM32AFKIJuQtK8+04AIBC320zT5mhItdjr5nsGW8zuEwlDj+aReG7L4JZ4HT+/0Zuv6or8uA41ip1SHXRL8lI7KUCxTeRocDr/q7NTdyxMgmZS1YNYtn1/UQj6t/sbdVlEUHrF8LL/twGr36RpF92VLftadsgxeUAP6gH1JRDOAoZ+d40eR7tOCyfVflaJoNt24F3oo356p26ThbaIwHc3d+TZCwLeO46cZf2kE0trtO0ftAwulkuUlx4Dg9KX6jDzXn4gv67EhJe/uzcv8FH4IkJuZ1ntLbAUy5i/mGJaVfPompDwWIXsygJLu1vZH0rXekge6O7tspLhfnozD8pSstGUzj2zAfYviJBfwG6s6p6v8M4FY98zMqRCOR0nhUldcQW
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 21:33:36.2963
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 152bf045-2cc6-435a-3b4d-08dc37129717
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000010.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6714

Use the KVM-governed features framework to track whether SHSTK can be by
both userspace and guest for SVM.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 68da482713cf..1181f017c173 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4386,6 +4386,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VGIF);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VNMI);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_SHSTK);
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
-- 
2.40.1



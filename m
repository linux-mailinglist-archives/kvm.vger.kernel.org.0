Return-Path: <kvm+bounces-23466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 075AE949D36
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 03:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 860A31F235E3
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 01:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED2C41E892;
	Wed,  7 Aug 2024 01:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cpRDhcHz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703AA7462;
	Wed,  7 Aug 2024 01:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722992682; cv=fail; b=BhfS8PAIcS4BFYHY09BKf1is5Bjf5shiaZbkYBph9sQfNFFNPJEUWx1UeQ4teFmVhPZJ184olIKMSxeJbfkDjYClVYGER3iuJui7q/zYbCn21UbRE7jE1KSS5OlY3J1rDZUuGwSRwPnkpq7lVMaXnVqABHhC78pP/zZwK5Y0+Gs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722992682; c=relaxed/simple;
	bh=7bhshxWFNpR2PwW9Q6i7bI0Elvjt/SCUTedmuU3bK4k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bWV4oW++A8XNlGW0HUMlIaAFHW9UGtFQcuPH1p9YJ5icNj0m4SCjXZkD6LSmC3EGdbEkqumoNmjKw7a8z60QtwQrE1dDdZTYz2Y5lWS/wpCeQYpClIN754v35HofAe39wRZhKEIaOhNnhG/bdPzfle+TdqXsRxxsFFgeDbHLU84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cpRDhcHz; arc=fail smtp.client-ip=40.107.223.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R+HWYLhaoATcopYs/7ysCHOjQmsd80yS1/0Y/yPetPhktvYIQpthAnyCpsyLAeaX2kqjqLkGJa0IpBli4UUEMb3e3v4+59YaP4L9MPIcChrNSe79wdeDi/3nJ2BkhqglNpkFG0qbMo8TgI0iszS4HG/UiU5pcOJ6DwamBJg7GgkfMomAeKrEGjBDjP//sPPS/roqyOp3CSAeOs4yWRAHFcIaEnw0YxWYUcWPQkGboRS30o9zFiWpG+jqGw/4K0nYiVn30qn6kAtkuJWlQ/48+SBCRT9ZiaCtNIKN2GQ3lbtvC6b00LQvfMwiILJ4HkSZStPunuSC5FfVPBpHCWM/lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QlKOGx/T+4cVHorcuam8p/rvMhh4Yh1OFWpeUkY5WSg=;
 b=FVKKzMX+XBCha8jlO0BL7v5OORvVT9FZgl/r60ERbLJ3wF10FTkXhjqbTFMVwu1i4Yqg7Sx2/0EjlygPZoG/UG2wvYrjA93wyNv1WtGnC4tyJvgge/8yUIrI6f5M9KRo86OCm3NEJj4lxBE921QwqQH4jVM7un3pvra4txzxXL3eQGpwVT7KJCoRPewlpbGQGzOKfjv9u9DrO90oxu21oP7mmoQoavOFKXeFO0VJANPjCfb2Zavtu+qoUd54w5Ho3e4/QOpyvUgZDDYePc0HhviKdQ/GwNY+tNCcGpU3ZkIerhpzxNocLsA4Ix1JGjERMAH/sgkAo5QVHcdaPYMv0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlKOGx/T+4cVHorcuam8p/rvMhh4Yh1OFWpeUkY5WSg=;
 b=cpRDhcHzvTVtZpaloxgO21B7zt0U29L4lPxb2qkn9TnqRRx5Nh+hGj60zKyE9Pu/DITJxdn9jzYvUMcC31hwdmW8lfwpU/twXZ/5B6adbgbLfZ+lbbouwHzqUFAk0gTFLuu4dUofVuuPHbvwpyp7razVZ0T0CtAenEUubOHLavY=
Received: from BLAPR03CA0033.namprd03.prod.outlook.com (2603:10b6:208:32d::8)
 by CY8PR12MB7217.namprd12.prod.outlook.com (2603:10b6:930:5b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.13; Wed, 7 Aug
 2024 01:04:36 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:208:32d:cafe::51) by BLAPR03CA0033.outlook.office365.com
 (2603:10b6:208:32d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.28 via Frontend
 Transport; Wed, 7 Aug 2024 01:04:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Wed, 7 Aug 2024 01:04:36 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 6 Aug
 2024 20:03:45 -0500
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	"Ashish Kalra" <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>,
	"Melody Wang" <huibo.wang@amd.com>
Subject: [PATCH 4/6] KVM: SVM: Inject NMIs when restricted injection is active
Date: Wed, 7 Aug 2024 01:00:46 +0000
Message-ID: <6d39d187147f9c98863fd5123bb044dafe54a916.1722989996.git.huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1722989996.git.huibo.wang@amd.com>
References: <cover.1722989996.git.huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|CY8PR12MB7217:EE_
X-MS-Office365-Filtering-Correlation-Id: bec761d3-d3f1-44e3-4a20-08dcb67ce836
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k10CYh2Hr5zdFd++Nh7sKnCI6x26g28W+26XjUSPlz4vRbeOQ0Lc/3RllnLv?=
 =?us-ascii?Q?t45dJFz2GQezah7uA5ffXHC4e6IrmFYJXy49dxjL7CfBzf2kGRoy51qtzeit?=
 =?us-ascii?Q?3PtQIHuSN8SxlR618ERi/Uls6IXvdzXw9a6QFbKpqVvKn0BRWDbj/qj+jRRS?=
 =?us-ascii?Q?nTtA58IrHk4Z3iMa1QnQdbGOeFiQTEeKCOZ11eQ33qJSXPUKLrL3AQGdRXDF?=
 =?us-ascii?Q?YUd/UuwZF4dBoGAaVRw9dWRGPkI4NvN7LAhJnUM5DKY41NQjxM2/mjjgYVav?=
 =?us-ascii?Q?EoJReK+LBBd9nKR/8RZCAAhQfoig74/geYwV/Rt4xsiboZrQJMP40BVyhh2h?=
 =?us-ascii?Q?QP6kAjxzpemIlVEOq2aSlyANqc8MEkrCC5ARn9G0prKlGHJMcRqfC+txX7aR?=
 =?us-ascii?Q?Fq/b45HhACZZk6KXhdTL2ol+dJRhV0ZqqhcRaf0a7R38Q1sjil5UdfNuSweY?=
 =?us-ascii?Q?FljhS7s/RetAA8prMGMQLFjazMXWplCIAhKIIm23iKypXrvsheqpI5KD79Tw?=
 =?us-ascii?Q?2GdW/Ivx8ik+wY2ByCIpPt8rD8192k3uGrpS+ReETQARU2c6h7fryqdGr8ow?=
 =?us-ascii?Q?ZlCg/H6bkyugCDaA1rvLJRtMCOlsWDSPxCb3mS3nXHbWIOtcec+8Y6dfd1BR?=
 =?us-ascii?Q?PAlzuqXlm/HQVswQ7JOXOpsiOyy4VjzSmi1Z49xKAPapNg5hvEL9Rf3SiaZs?=
 =?us-ascii?Q?Dv0UuCQaB8cZJlH5qfnLuLVZkeSpVIpWZb93mQTFII/TzZhSHfKEL6g+p88K?=
 =?us-ascii?Q?94SwBPwW3Aan925OmnHnsztdTOi5YEnEHN0ITHB1zG8rq4elRePM45qeluvv?=
 =?us-ascii?Q?hPnygIlI/VlKfJyH0P0qjA72th6lDF9oNgUqxAewhqkxE0SvN7DiH4SEDEGi?=
 =?us-ascii?Q?n4msY2DPON6JVxHPUhTKCodxYuiBwF7BHKBSVY4u7dvgoMJjOuMVOqzHxiXU?=
 =?us-ascii?Q?99lPuUKNJgNek8FktKaVR81TqMBQJRsGTXoypiPjqDlAa8jIPeVsghi1k9d+?=
 =?us-ascii?Q?LGS9uPU5vWddUv+6wpaU25isD7qfTS1dt27f41HnzMzDrid5pjOA9u2rQctd?=
 =?us-ascii?Q?qgBvZW8Xmr2NWvrP7noCOrgKHz4BPDsgKOFBvJAW2/2RWpq4Z578M734rzyl?=
 =?us-ascii?Q?ErY9zRhL8FdD/GQ3hBItE+7yPXUXSTNBDLxoZS1DWki/6NGWukjRZUbWwB32?=
 =?us-ascii?Q?/xAMBPW56y26Mufabrj0jOa1KI+oATUfCTcSeclvKBHBned364dust8z/4NV?=
 =?us-ascii?Q?ryi+FBoJTqtBfCYr+VbWJDZj4CsSMEILsA6XRw1Gv68Dp7e9J2210unca83A?=
 =?us-ascii?Q?VD0ZeG54A/D16ZSJMHWo5OLax0Qxxu57QQ0iWVSM7kc3W0IMbzyeasuCaVmk?=
 =?us-ascii?Q?/3EuDMZh7LhWYDd+uq3jM94fOWzOdQkFkWH4A3W4UmSGTGV4nrbrq+naGqbd?=
 =?us-ascii?Q?Qx0A76ELLWK6DSC7Mgl2vg0iH+rCRlJR?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 01:04:36.7058
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bec761d3-d3f1-44e3-4a20-08dcb67ce836
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7217

When restricted injection is active, only #HV exceptions can be injected into
the SEV-SNP guest.

Detect that restricted injection feature is active for the guest, and then
follow the #HV doorbell communication from the GHCB specification to inject
NMIs.

Co-developed-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 arch/x86/kvm/svm/sev.c | 19 ++++++++++++++++---
 arch/x86/kvm/svm/svm.c |  8 ++++++++
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0d330b3357bc..7f9f35e0e092 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5069,7 +5069,10 @@ static bool __sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu)
 	if (!hvdb)
 		return false;
 
-	hvdb->events.vector = vcpu->arch.interrupt.nr;
+	if (type == INJECT_NMI)
+		hvdb->events.nmi = 1;
+	else
+		hvdb->events.vector = vcpu->arch.interrupt.nr;
 
 	prepare_hv_injection(svm, hvdb);
 
@@ -5147,10 +5150,17 @@ void sev_snp_cancel_injection(struct kvm_vcpu *vcpu)
 	/* Copy info back into event_inj field (replaces #HV) */
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID;
 
+	/*
+	 * KVM only injects a single event each time (prepare_hv_injection),
+	 * so when events.nmi is true, the vector will be zero
+	 */
 	if (hvdb->events.vector)
 		svm->vmcb->control.event_inj |= hvdb->events.vector |
 						SVM_EVTINJ_TYPE_INTR;
 
+	if (hvdb->events.nmi)
+		svm->vmcb->control.event_inj |= SVM_EVTINJ_TYPE_NMI;
+
 	hvdb->events.pending_events = 0;
 
 out:
@@ -5168,8 +5178,11 @@ bool sev_snp_blocked(enum inject_type type, struct kvm_vcpu *vcpu)
 	if (!hvdb)
 		return true;
 
-	/* Indicate interrupts blocked based on guest acknowledgment */
-	blocked = !!hvdb->events.vector;
+	/* Indicate NMIs and interrupts blocked based on guest acknowledgment */
+	if (type == INJECT_NMI)
+		blocked = hvdb->events.nmi;
+	else
+		blocked = !!hvdb->events.vector;
 
 	unmap_hvdb(vcpu, &hvdb_map);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a48388d99c97..d9c572344f0c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3602,6 +3602,9 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (sev_snp_inject(INJECT_NMI, vcpu))
+		goto status;
+
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 
 	if (svm->nmi_l1_to_l2)
@@ -3616,6 +3619,8 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 		svm->nmi_masked = true;
 		svm_set_iret_intercept(svm);
 	}
+
+status:
 	++vcpu->stat.nmi_injections;
 }
 
@@ -3786,6 +3791,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 	if (!gif_set(svm))
 		return true;
 
+	if (sev_snp_is_rinj_active(vcpu))
+		return sev_snp_blocked(INJECT_NMI, vcpu);
+
 	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
 		return false;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 95c0a7070bd1..f60ff6229ff4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -43,6 +43,7 @@ extern int lbrv;
 
 enum inject_type {
 	INJECT_IRQ,
+	INJECT_NMI,
 };
 
 /*
-- 
2.34.1



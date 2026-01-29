Return-Path: <kvm+bounces-69510-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AJlyCJIAe2nKAQIAu9opvQ
	(envelope-from <kvm+bounces-69510-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:39:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A747CAC450
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EB38C30215A4
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 06:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC5493793B8;
	Thu, 29 Jan 2026 06:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RQJkRYOU"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011056.outbound.protection.outlook.com [52.101.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A871E1DE9;
	Thu, 29 Jan 2026 06:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769668743; cv=fail; b=spgGXMLtJVRosh6gZUkUqUGLOf9XWUmbl/IaSluAESMTyPXlmj/kfgkB/N1PTI5f87hgvc2DeEVsiUSPXQWQq+1Vnkk/dlMBo7fOyNN+pPt2hQuw7D+CHOySEpXB3ze8ylfEcXyfQrSzSg0cCYqGqzHWnm3ue6A39uSAnHufNSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769668743; c=relaxed/simple;
	bh=PQfpP5GpnOUrFJVaeAY0/3KcYl8uMYItzp/V+uzQuEE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YRr3LuoZs7Nphy7pGLeCErvmSONmvjHvibZ2WjgNUSpmqH9ErfBSs1AzhhknUMRAK8nzgLmDNJujsIjuHcl+rFjy5hwCmik/LHH+/vb53XWuCYQ2k6F+PmGICYJLUt9PE8fhDWm94V+DVKjJn/IQv5rkCfQtlsdTAgmWrhr3T80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RQJkRYOU; arc=fail smtp.client-ip=52.101.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XKxn6UelrLLb9/bYOAJM8w63818ShBxVOFunEXQ5S4UacwuqPKLSqUmB+sSL/heAZYMLLLGkppYggsjoR+qAXvsZMB7a2ExHQPAIIAagQtyEpYaC4zl4s3GS/al//Vxs5O7Ykt4pYaIF3x7cgiJ8Qbq4A/xZpwzqe/wpc1UqP4c4RDvVIZ2BnbPN9GLxUZ3F53CxBoUEyIkc7+XGdv8XT6qEwuDfpNJcvyoESAely9VSMlmq64/uHa3vG4+eJkbl5/vLrKai0RfjdC0KoE77QQ/vH090IkjWSA28k4MXlu39cYONPJsOu1+pdJplRcCeSat/GoPafD8oCu9Gf22Mqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K8MAZ6MeOk2QJ1RgVx0muaLSsWCEMxkEF23lL4zVoL8=;
 b=uVbDmF3WlLQEwK+BFRkqFIRJpabhA/Y1NVHpDToF4kEMI2x/MVNRwcHGeMSS2g4Novk2ekNAJ97tJrd7fGLlpYFPvVxhGs+y+T+E0bgDKqFQF5wLEbAcNBr9TgGQtixhUSoy56gFBeUp6HPrDl5f5uGLopGXjV7KE6hKcXgTnNYlDNQK85MQP+tSSdt8kSIuF/dBOaYvovZx5WWp/Xf1pVNWAJGUfBX/wZfHJ92ByHXDcFgTCIfhFoC9cFEDN2DN2RMhXR1ilfY8vEmtDmN6bwMPQGwMQDGWbG0JvrjSN9Hc8SBWmMvbOyRzYJ9rlHk8N1yTdb7nl0Rj/eAasyFX2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8MAZ6MeOk2QJ1RgVx0muaLSsWCEMxkEF23lL4zVoL8=;
 b=RQJkRYOU/tIZG6imFUbEPGKBsNNAYLkEMwzm6CaWYs8j62HtgY+Ogke2fnogmdKDCbyGREqhdH4xXsP3qfkUMHZeWGVXMTEnOBWN7JmB8VC8plVMIWbOC24TtSo6UxEAFD3s+BjBZ0nX44fGzq1d4AnjCKyB/FBkHbWGGDn/Xm0=
Received: from MN2PR18CA0023.namprd18.prod.outlook.com (2603:10b6:208:23c::28)
 by DM4PR12MB6134.namprd12.prod.outlook.com (2603:10b6:8:ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Thu, 29 Jan
 2026 06:38:56 +0000
Received: from BN2PEPF00004FBA.namprd04.prod.outlook.com
 (2603:10b6:208:23c:cafe::2e) by MN2PR18CA0023.outlook.office365.com
 (2603:10b6:208:23c::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.10 via Frontend Transport; Thu,
 29 Jan 2026 06:38:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBA.mail.protection.outlook.com (10.167.243.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 06:38:56 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 00:38:53 -0600
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<xin@zytor.com>, <nikunj.dadhania@amd.com>, <santosh.shukla@amd.com>
Subject: [PATCH 4/7] KVM: SVM: Populate FRED event data on event injection
Date: Thu, 29 Jan 2026 06:36:50 +0000
Message-ID: <20260129063653.3553076-5-shivansh.dhiman@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBA:EE_|DM4PR12MB6134:EE_
X-MS-Office365-Filtering-Correlation-Id: d1924770-c9c8-464a-bb4e-08de5f0113e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QCWHZQm57SszDpLUNc7FNYuA6lY1v6wCwUqEn8a5yGOeIFYG2XceTgPIiQn8?=
 =?us-ascii?Q?a74waNogcrTrnmcb7tPQd5bkQJ1Q4vMWoE3Z7rURSrKo8tNahSxZcsBH752C?=
 =?us-ascii?Q?q4M87Hb7YPVgXMzvzODtYiNrSEVCxiDjs4qiAi2eUaqdKUTVBO3YXe2cdb8y?=
 =?us-ascii?Q?EVrf/YtIWoMyBEr7EXCiJRhy0NrNt26sHmeFJ3UDlBvLid0H+ZRG/RhWkitI?=
 =?us-ascii?Q?uESk2vcuevWDUH/2wtaD//2zdC1Mc2sshrxAFD7huoQLo80DTUWoa731O19t?=
 =?us-ascii?Q?xxs2Ddk4m0eT0ySRxXo3LvwyUrUqA3aZb4lLmUrwDTeDiy7DRhsxG1SISepM?=
 =?us-ascii?Q?5wxwk46rTH0ZOykksDMmS7R9z3OS/Nmp87eGqP6TcnbGiT2GrG+g6lmhKxI+?=
 =?us-ascii?Q?V5LU3J1DngvbrLM3zbMj1jodw8O06LJTwI5DpG4eprjveS4r5bTQFOvStZw7?=
 =?us-ascii?Q?+OrNsgHWNQetEnnHz7xUix9jeGmfSmdheoxCzSpLNdE5hlyXhfidWpZ4knG7?=
 =?us-ascii?Q?QVUx1TBU9zXh2kvGeAmfhywo+4qIMiVT/JgOU+vYfg7qpARR6YtR9blO6YzC?=
 =?us-ascii?Q?+Wv2lOCj6hvAx0ssDwXhrSDjCDMLQ6gWRpTnKRAByFpRwsCjsk/hVVDtvg6Q?=
 =?us-ascii?Q?NUhTE6QvpotloV15UrXcnWUD6MEoMUz3LjM9O9gVNPSUHjyKHsZ1nWVUVHdq?=
 =?us-ascii?Q?asGvEHJJYyRgtpJHGv7UvNFhvMLxxTUUNLkwVJZN6qKo+PlP0jYZ2LR/URM8?=
 =?us-ascii?Q?Y2tI4myVhPSO0VSsbAp3vQ8Ws16vXgHrWXqTcA4l1X2pTARuq3Rih2riDsGk?=
 =?us-ascii?Q?+Okej65xc3VekT6geHjXpkCv8I8+17ZCU1JIWw4OREsPaMkBL6fXaaeTAovQ?=
 =?us-ascii?Q?cBfzHw9x6ABKQhArb4g4A0dMhosbj7PCnpJ1xY6sJ7ED7wzdzb6g+rCzcJQB?=
 =?us-ascii?Q?VMTfkPC9YbuT7Gdk8f1EA729qWlAD8Tp/2Z+yCkwBQVkx2ql4yFZIEUMDygx?=
 =?us-ascii?Q?05Mx+bZm4m1RN2rMnISy3os8Vm4yMai4owpq3LPuH1o6wEA3oiIz14thny9b?=
 =?us-ascii?Q?rWVmhze/tn5Pn8vsL2dBcCIYAE5biShj+iD37NrgbLdOjQ64R7/brPwgmzjM?=
 =?us-ascii?Q?NOV3G85B6LsKZy6e2m/M6ium2GSTn5+fDhMFn/plyjbBP4QBDc9b7vh1BCzg?=
 =?us-ascii?Q?WEXawlIHMZ7Bdo3+1A6agZ+0cZeiebvvsT0EfVwekL5OkmFn/S0HdpxFR5la?=
 =?us-ascii?Q?q7cP6ZP6XQD+RXA+GaRsrAsoZP6ihR+ScwT94KF5PyHJCFC1ii56BVEaUULe?=
 =?us-ascii?Q?XgysZCa4vfpTsnheKCXvGS4EPUIxuZ4qzuZVEuvdM50prROVQn55BqQ64pqN?=
 =?us-ascii?Q?E0BB5tiPVTfUcTQVcbl/Uk4AuzQPF4hRxKNUuBMDcyoxn8eZBDulKKuIc2Bl?=
 =?us-ascii?Q?rQj5s2xE65JxE/RSWc07uKE0lvRwUVGvYF2vMgZJw/ceVOSKrW6b6JtX028i?=
 =?us-ascii?Q?RK91NMjJ/dPsa5phT1uLAKj2zMfrc/dQoHOo5Z0v54/NJwMX5NOzCWS5joLk?=
 =?us-ascii?Q?xGcb+f5SXb4C2BrhBm/EDBVi85+9QdsN2LrUcyyjTY4FVsb43kcBUjAfCYuo?=
 =?us-ascii?Q?7aK+BFHSbg8TYx/KtceyuVCeQ0D3EYssPMDkRsbEoYwsUhMGqTOZiZrioEUt?=
 =?us-ascii?Q?kILWEQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 06:38:56.5486
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1924770-c9c8-464a-bb4e-08de5f0113e5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6134
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69510-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:email,amd.com:dkim,amd.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: A747CAC450
X-Rspamd-Action: no action

From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>

Set injected-event data (in EVENTINJDATA) when injecting an event,
use EXITINTDATA for populating the injected-event data during
reinjection.

Unlike IDT using some extra CPU register as part of an event
context, e.g., %cr2 for #PF, FRED saves a complete event context
in its stack frame, e.g., FRED saves the faulting linear address
of a #PF into the event data field defined in its stack frame.

Populate the EVENTINJDATA during event injection. The event data
will be pushed into a FRED stack frame for VM entries that inject
an event using FRED event delivery.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Co-developed-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
---
 arch/x86/kvm/svm/svm.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ddd8941af6f0..693b46d715b4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -374,6 +374,10 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
 		| SVM_EVTINJ_VALID
 		| (ex->has_error_code ? SVM_EVTINJ_VALID_ERR : 0)
 		| SVM_EVTINJ_TYPE_EXEPT;
+
+	if (is_fred_enabled(vcpu))
+		svm->vmcb->control.event_inj_data = ex->event_data;
+
 	svm->vmcb->control.event_inj_err = ex->error_code;
 }
 
@@ -4066,7 +4070,7 @@ static void svm_complete_soft_interrupt(struct kvm_vcpu *vcpu, u8 vector,
 		kvm_rip_write(vcpu, svm->soft_int_old_rip);
 }
 
-static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
+static void svm_complete_interrupts(struct kvm_vcpu *vcpu, bool reinject_on_vmexit)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u8 vector;
@@ -4111,6 +4115,7 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 		break;
 	case SVM_EXITINTINFO_TYPE_EXEPT: {
 		u32 error_code = 0;
+		u64 event_data = 0;
 
 		/*
 		 * Never re-inject a #VC exception.
@@ -4121,9 +4126,18 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR)
 			error_code = svm->vmcb->control.exit_int_info_err;
 
+		/*
+		 * FRED requires an additional field to pass injected-event
+		 * data to the guest.
+		 */
+		if (is_fred_enabled(vcpu) && (vector == PF_VECTOR || vector == DB_VECTOR))
+			event_data = reinject_on_vmexit ?
+					svm->vmcb->control.exit_int_data :
+					svm->vmcb->control.event_inj_data;
+
 		kvm_requeue_exception(vcpu, vector,
 				      exitintinfo & SVM_EXITINTINFO_VALID_ERR,
-				      error_code, false, 0);
+				      error_code, false, event_data);
 		break;
 	}
 	case SVM_EXITINTINFO_TYPE_INTR:
@@ -4146,7 +4160,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	control->exit_int_info = control->event_inj;
 	control->exit_int_info_err = control->event_inj_err;
 	control->event_inj = 0;
-	svm_complete_interrupts(vcpu);
+	svm_complete_interrupts(vcpu, false);
 }
 
 static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
@@ -4382,7 +4396,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 
 	trace_kvm_exit(vcpu, KVM_ISA_SVM);
 
-	svm_complete_interrupts(vcpu);
+	svm_complete_interrupts(vcpu, true);
 
 	return svm_exit_handlers_fastpath(vcpu);
 }
-- 
2.43.0



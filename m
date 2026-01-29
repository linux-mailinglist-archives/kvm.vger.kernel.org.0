Return-Path: <kvm+bounces-69508-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SI6qEHkAe2nKAQIAu9opvQ
	(envelope-from <kvm+bounces-69508-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:38:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A89CFAC449
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:38:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 88E9A301D6AD
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 06:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F653793B6;
	Thu, 29 Jan 2026 06:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jwNq9kqE"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013061.outbound.protection.outlook.com [40.93.201.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED271E1DE9;
	Thu, 29 Jan 2026 06:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769668699; cv=fail; b=gQUNQogthBN7DB9kzCmLABzhrLYwHg2sM5/RQychQqtF5zS0I/wxNabDkltHg1GUUhzReAHF2q4qlEkW400YXvxqCUckuMoAy9LUKngfZlrFNDb41No3VHyD+Ad/e7uaCwjp2+dN3vSlO+EB7Zteu0lNFgSAIy8EkpYKLWe1UNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769668699; c=relaxed/simple;
	bh=IaEmFIXFCQpENsA3Qj+qos/+7PLWZrZ5frojW0JQHV8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CuFviSMc9I6QHvRau7rPcFOSfbEh4jhvA+ko53jst/xKbeYkrPhmeO2DmCgo7dNmlTWrQ/T7XN2KS0qOzj8QwVDFgrnH6SNRtQMwbJrd8o1HHE4IWhYeRtP5I+wqPU9qhzNmJVTO7S14zrJG+kpw9xShYD/SXECXaPZROdJ+Lzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jwNq9kqE; arc=fail smtp.client-ip=40.93.201.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o6yuSLt15+t4yWKn/2Nhm68f/KBQvA86risRjbGkxmQ7ICgp6T5PEJqT06gizpCxbgNwMpXWcYEXlw0BkfM43xv1QDJE6jHWitfOcckXgdcN3v3Q/q96jyWMJn7A5Jtl41kEWls5lHvj1tl1fMBVFUvrtdPjviYQsiRPINhyq+bb1Bsfo7HW3zfA4xqsSlO90Wwge2oC44TckTeS/caSVL0kP0CncQZ+uJbGaDBbM30ZLMHGtPxuIve/XUtSfaEc46zW3XA7+xXoV6TvABSuPBTGpFZbCRvsmByC3FzbuIVi/Paj/X3jl3wgFH6nXwx0shSSkwe7pG+KxVoUmam0rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xcy35tWQGczlKeHXhwXuzkWNoAILDCyX3iQOLbUzims=;
 b=S3cH/y5/GXNiTLhUAN9kBV7v5o95Tt+DUqIPpEVcXvoApmlC1AH/igxmCUs4T0MPL/vvTXvKfsNv2Ne9E4ijstPCEbkDqqXaE8r+CJ/V3XrRURcA14TgZTEccQnBuCbvBZI76KObhmNq7TYUn1bByhv5blBEZC99TpMZhUp1sQLdjnddKwGdYYLiowMArb9AjZA0pQ4XITbiYicOCo2fx8KYIqkxolttsoeV549bPo7VcuekK/LFW6CQmfZJRzmoRef6t7YHvUSAVG7xUKcIC7qTj8WO1ARphzsERkV1eCkBPkU17eyleKJm+XKb41gPBwANBfv2xFL/6nm18I3M6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xcy35tWQGczlKeHXhwXuzkWNoAILDCyX3iQOLbUzims=;
 b=jwNq9kqE8edVJIx4bHd6daZfmJViOQRf1+U7Nx5kr2sZMkARm6rsBBCe+pOx4kMZCgLYwuZ5otXqYTeRLjZOMg+wNC7lzacsTzYeEbB5yJ62oUVXZDWOCBLsFP7RoLZVeeX2fB2qrzZgVPVksi+co39+Od6sToSLr7m/BcgJ5Bw=
Received: from BL1PR13CA0080.namprd13.prod.outlook.com (2603:10b6:208:2b8::25)
 by BN5PR12MB9463.namprd12.prod.outlook.com (2603:10b6:408:2a9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 06:38:12 +0000
Received: from BN2PEPF00004FC1.namprd04.prod.outlook.com
 (2603:10b6:208:2b8:cafe::8e) by BL1PR13CA0080.outlook.office365.com
 (2603:10b6:208:2b8::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.2 via Frontend Transport; Thu,
 29 Jan 2026 06:38:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FC1.mail.protection.outlook.com (10.167.243.187) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 06:38:12 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 00:38:08 -0600
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<xin@zytor.com>, <nikunj.dadhania@amd.com>, <santosh.shukla@amd.com>
Subject: [PATCH 2/7] KVM: SVM: Disable interception of FRED MSRs for FRED supported guests
Date: Thu, 29 Jan 2026 06:36:48 +0000
Message-ID: <20260129063653.3553076-3-shivansh.dhiman@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC1:EE_|BN5PR12MB9463:EE_
X-MS-Office365-Filtering-Correlation-Id: d86ad019-ad29-4b9c-02f5-08de5f00f97b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WGXmgsz7aGlFV3s0RGKw6cg8T1EjSjLM0oXIhW7ieTkbfeamKx/YPAedyp1z?=
 =?us-ascii?Q?AouMk2N3ZpZGN/2QUd/Qbgs23I3ove6vAiLnnakI2tYl706ADCG/Qwbtk5VJ?=
 =?us-ascii?Q?HPLH+Gewebxxfywk+kAQxRCkHhppJyT6gNqikbhSwEQWOm3yC/Y0SxQDCjlL?=
 =?us-ascii?Q?HPxLcAywjLavwGfVi0v3lo2AofdoQ55EXPx7QiGLnInkBbSrflwqarYyKYvc?=
 =?us-ascii?Q?6EP1M2+3JnqtGDlAhBM+Lo6UPqejggN2/ruIitb9Nwxkfv+nCi/EmK2BK39O?=
 =?us-ascii?Q?WrFaGqSz1CrVw+trtw4eqcaPjYyHP89HXmYMX+Zi6BkP18ZCIqMVyGyG8qCl?=
 =?us-ascii?Q?wugs65dmBfFQHKwf54oOmP2ncPbC5+jt6B50+QPsqj+WjhjcHGFiVQd9i6Qu?=
 =?us-ascii?Q?oRvs3I1FvojKZWnWsEOTfPocg9GJNqvkklWWWTN2j94muYheSsOQjwrVMQ0n?=
 =?us-ascii?Q?Rp8X6jPEta9Qs4J9+hCjBFHPwTqsZGv5WUfplo/bZxHPUatW+tRJCM9I8Ppu?=
 =?us-ascii?Q?gj5KAtOoifVWMW5fdPw/t+Kcz9jhO/s/AyHg+pWVUrD2Om+FV3JULt5AIe0p?=
 =?us-ascii?Q?Peor1jIbRwgqvKtmk2iw6Hng0GO6rk3zSQX4v34nMAef4BAFmmo6MvNeEf6F?=
 =?us-ascii?Q?DYOhCUXk2AsFDhPYtZp0tQ/JbsbCKb+d8I3Nm13YeCFIztiycYU/NQoTPF5p?=
 =?us-ascii?Q?2/nDYWamviSe3zgM+uWVWcSAHknEnUnoSzjw7NIjXG67OzpCmGUj9EdZF9E3?=
 =?us-ascii?Q?QdrlwzrDLG2R0rzWvZ8SQbar9Xk+18CAMvWLYYg8Pgro0Qhz7aVun8XGYRjv?=
 =?us-ascii?Q?e0FHksCu914TSesUvPo9C1/Ro+tt1dnLkRFzptO6O1Mjan/mJW7iSsjkBVwF?=
 =?us-ascii?Q?T+ZsJyp9OP9FLSTuOKUDAKYfhBfRk0pUHNHVCaUQbY2BifiKYjCu3HuHjhoy?=
 =?us-ascii?Q?F6z5a78ynHS4rQFMi6RfugXSh7enn5om3rycwZIspqxPwQ4e44urq98UdctI?=
 =?us-ascii?Q?fRomh2awMK5RlSmxzhM/BQOEuef1bTxODss7tMI8DecSL1E+yfqUjd/rrEcJ?=
 =?us-ascii?Q?oQIFI9lvJdlxcWc5noG5EAleeW9iP4Dgwvf16jhUb/b+IOmlFdQMUfRCFD45?=
 =?us-ascii?Q?r/GJ+HM4LVU4huKW9hTELpsriBDKoEY+eGX9qbZ37OJ1YOgRlL3Np75WLGhA?=
 =?us-ascii?Q?Zt5g5GjFNphEf1apBDwOff4r5kyiZxJEgFqhWBWH7PvJ2s0GNMXKbetwqFXg?=
 =?us-ascii?Q?IASJb6rdxwadOsl5ZClfwq3v2+FoQMsVpEHKJ53rYrXH/u6aojqG5ZLi4C68?=
 =?us-ascii?Q?SpaAB8LVQNOI6m3PakrV/09OQqNvBgggRhx6TGwewxNheew75o8ig0FXpAXZ?=
 =?us-ascii?Q?62p5OpTaDQwBwcrxak4oDrjmgGqrfRb+igs2YkKkBfUjvxgD/dEMYOL2iIEE?=
 =?us-ascii?Q?NLwP0YQICKgL0zHfN0m5m4yGLBjRJNlMzKmgrIuT5I9KI9LzQ+cZgbuB2TUH?=
 =?us-ascii?Q?F/BPfGJGnhD/BwvbyGMcc0zaDwIAdcYKxqZ0i1Y+PAhKWGuMoSIG4chN16rx?=
 =?us-ascii?Q?uBand6Gpaq1HlkrVlomJ5jp74udWLCx5X4ZG1XyJ0bm9m+sk00/D6pdbXMRD?=
 =?us-ascii?Q?+55bKotsH+yvBa/1r7Ifo348Dc1G0YnKDhmRvmp991Wvb10CY+RkH0VgE/7o?=
 =?us-ascii?Q?5W1xMA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 06:38:12.2635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d86ad019-ad29-4b9c-02f5-08de5f00f97b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9463
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
	TAGGED_FROM(0.00)[bounces-69508-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: A89CFAC449
X-Rspamd-Action: no action

From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>

The FRED (Flexible Return and Event Delivery) feature introduces a new set
of MSRs for managing its state, such as MSR_IA32_FRED_CONFIG and the
various stack pointer MSRs.

For a guest that has FRED enabled via its CPUID bits, the guest OS
expects to be able to directly read and write these MSRs. Intercepting
these accesses would cause unnecessary VM-Exits and performance overhead.
In addition, the state of the MSRs at any point should always correspond
to the context (host or guest) which is running. Otherwise, the event
delivery could refer to wrong MSR values.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Co-developed-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/svm.c     | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index a42ed39aa8fb..c2f3e03e1f4b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -224,6 +224,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
+#define FRED_VIRT_ENABLE_MASK BIT_ULL(4)
 
 #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
 #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5cec971a1f5a..05e44e804aba 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -727,6 +727,22 @@ void svm_vcpu_free_msrpm(void *msrpm)
 	__free_pages(virt_to_page(msrpm), get_order(MSRPM_SIZE));
 }
 
+static void svm_recalc_fred_msr_intercepts(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	bool fred_enabled = svm->vmcb->control.virt_ext & FRED_VIRT_ENABLE_MASK;
+
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP0, MSR_TYPE_RW, !fred_enabled);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP1, MSR_TYPE_RW, !fred_enabled);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP2, MSR_TYPE_RW, !fred_enabled);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP3, MSR_TYPE_RW, !fred_enabled);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_STKLVLS, MSR_TYPE_RW, !fred_enabled);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP1, MSR_TYPE_RW, !fred_enabled);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP2, MSR_TYPE_RW, !fred_enabled);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP3, MSR_TYPE_RW, !fred_enabled);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_CONFIG, MSR_TYPE_RW, !fred_enabled);
+}
+
 static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -795,6 +811,8 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 	if (sev_es_guest(vcpu->kvm))
 		sev_es_recalc_msr_intercepts(vcpu);
 
+	svm_recalc_fred_msr_intercepts(vcpu);
+
 	/*
 	 * x2APIC intercepts are modified on-demand and cannot be filtered by
 	 * userspace.
-- 
2.43.0



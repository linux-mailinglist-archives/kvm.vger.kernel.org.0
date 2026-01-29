Return-Path: <kvm+bounces-69509-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YDnXKpwAe2nKAQIAu9opvQ
	(envelope-from <kvm+bounces-69509-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:39:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B4E5AC465
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:39:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 853A23033500
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 06:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 755943793BA;
	Thu, 29 Jan 2026 06:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xBO9X3at"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011040.outbound.protection.outlook.com [40.93.194.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606331E1DE9;
	Thu, 29 Jan 2026 06:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769668720; cv=fail; b=h031Awx70dt9ZCcShSNUeyxKbYpAhHxEYLzvw5nP6ErHR4TrIgm4TihNlqCJ5x4K/Bht0utMkBfxfDAGoRO/VW+3c08O2FqH2rtw7kPxLU7cy/Ij89e/Kpcuoqp/kLQm0YWDesEQYn3PfIh9rCut8kx25xbEz29sI9bKjzxzYMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769668720; c=relaxed/simple;
	bh=OkzhD5JDDarZ2YSvKNGbufpW8BhhrhpDiKAepWO098c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GurwkJt7p8rQ5iMOdVwNDo7ibs5QZa6URrfS/OgDsr9uesF1FXwN22/2VCataTdHy2ldkhZvbwQCIJEClVY0cCLtF0DAnw0rKzNv6JTvGhh4U0lDxsNoujbBk30YG2R+hC13+alWBRxI3INubkaq4OwWkUNhPgbN9iCb7nK59So=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xBO9X3at; arc=fail smtp.client-ip=40.93.194.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ewPchDXlDQJ9XCj99pKu7ttNXKqr6UGkgCA7r2cq9t8nuVdCccuvAbvRlUJXKJhwtxJH2TdJeX8E2qjMY0wlNxicSutKQFfGJnAj+txAGjn0yTRhr0mhwMY+XnxU3V3r3Esjhmquwz8ApayADV93R1SeYQaPw6a8QNLOiJ8j8gFx3uCR4KJfyv+hAR8OoZKbfcGAO23h3rOabRL1YmXZwpCbDYf2MUCNHUC8AfxTgvoodfrolAEkjKWF5Bi70xAXUzBCtVR0utgLcxWJedtO1qBZvwyWqJg9pGkUghpyCLEgUpNd3rOhk0me7wrtcMR7FTXkFzKT1mF6DvyIwC8WrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mxSXzsC0R3uweS+FE73oCjYrVXOO4GS93dgq2LPwicw=;
 b=BaN8P876nRDNEylRnSgKBGj7LoW0d3yep9gvr5dMlXyXVpGNJywxBZ6xd6Mica/ua9EH6t8sNz6HmzJnkql4rvL+YCkRwyjeANyu2Sy/PxYGLUcT37quZgVz1yzAO4emeu2ftCi0iSGNfFnyu19gVGYeNkJSWKGvmP/HI++OR98W8EBwejHll4LXE+THRN1YRa2V+TS4CUyM2crZ/H+vefNn52nHOWEFscTTttGRZJ8cx2wPr8c56d8mcxRP5/Bfd4PPOFnsDcy9lRxTO0YFJ7pbNB+/O/2w94FdAfSHLi2J/TD9l5FgBGeYouNJV5iQVCu4P7vUkv3S0ySqt/lpZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxSXzsC0R3uweS+FE73oCjYrVXOO4GS93dgq2LPwicw=;
 b=xBO9X3at4BhYFObz7BJPchdPssymfSpjyMroJMk1eG3v+W5bvtsSFNs/culuTVOWMqp7MLhDpV1jdtpwfdNiTr7EDQwnxi5kn8iyQMQ7u9QL+vnn6EDWQAmaPGd0yg1pVkQ+S6CCmonyKVvkOIS9OLtzVVyRiG7dSBtKDFNIFeA=
Received: from BL6PEPF0001640F.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:16) by SA1PR12MB6971.namprd12.prod.outlook.com
 (2603:10b6:806:24e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 29 Jan
 2026 06:38:35 +0000
Received: from BN2PEPF00004FBB.namprd04.prod.outlook.com
 (2a01:111:f403:c803::7) by BL6PEPF0001640F.outlook.office365.com
 (2603:1036:903:4::a) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Thu,
 29 Jan 2026 06:38:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBB.mail.protection.outlook.com (10.167.243.181) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 06:38:34 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 00:38:31 -0600
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<xin@zytor.com>, <nikunj.dadhania@amd.com>, <santosh.shukla@amd.com>
Subject: [PATCH 3/7] KVM: SVM: Save restore FRED_RSP0 for FRED supported guests
Date: Thu, 29 Jan 2026 06:36:49 +0000
Message-ID: <20260129063653.3553076-4-shivansh.dhiman@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBB:EE_|SA1PR12MB6971:EE_
X-MS-Office365-Filtering-Correlation-Id: f3d3b2d1-b661-47bc-01e6-08de5f0106f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZMwvlzmT7OMztO0uwvR/c4X5BiLpFMVgHToftdYlhLM9on1dgqTK9dpNl0Vw?=
 =?us-ascii?Q?xnP0/vYHkIRRcXl/OEe194cebws68xOYN0YmlJKCHewb/hYqedgheID/LTZF?=
 =?us-ascii?Q?d3looWYQsGnOB74zMrlAVZ1Xs9zAcDEh/CY5bIAF7DaK75SFEWveBYfSNsS1?=
 =?us-ascii?Q?6HCx80uIj0CDPC0IUZ1PCXnod+oufE+2VXgtEp0ko08UiWOGc08w3fvWmPM5?=
 =?us-ascii?Q?JvLF02A90ZzNdfdnIz77a9BhMFxK/TqZeqDhWHlpg1IPpUYAvDG6T/EmpZsI?=
 =?us-ascii?Q?ejc07XHa16Mw7pJqUcD3hQWZLVHzaSDb7ad4AOPrl/7iVpqkX2TlgcEIhTDx?=
 =?us-ascii?Q?svd876CAvdydvK36sLtls8kYkfdcXiAELYS2DuuR/W+TeddwTwJT6Dxd1KRq?=
 =?us-ascii?Q?imxEJkliFOkSkTNAfV/1DnxNmwAM/PUbpq+WOrdf6MDMxPMw51HiGwO0A8hr?=
 =?us-ascii?Q?KJhf8nPoLPvZboi4/XlnUC9lH4BZ4euaH43rsZdNe4fDgqSSp/A5y0ZQ0s7u?=
 =?us-ascii?Q?pnoJzee9RQo6shfDIKpTXMeQjTzNy3OURJORlYLNFUXzqlNiPkJyu8uIDyw2?=
 =?us-ascii?Q?fqHNpexgS9KBrwlfDB8q0EyljBbYYB8WqWQzTf15/Gr7AKkKblpWurdWD2Nj?=
 =?us-ascii?Q?CltT/EwB16v6L0edW70g+aNHZDNPzBrq65+fkmAeiiZcTwL551Fwyq8wei8B?=
 =?us-ascii?Q?RIBRlqCzn+ZYC4GfwJme7Bc+WiPiGHskBFOnt+QlbeHkIcu7OzhYexGpvOJ2?=
 =?us-ascii?Q?++VyYGUr80RfA9sJ0bZlzzpgefANnSI35InsD9lGFlBlY4fEG9RcMLsXpmqQ?=
 =?us-ascii?Q?9ttqE8pX6OaeM9FHp9F34eleEDfjR8RKkV6Vnw7/mX2qF+D0mvZAv0pmiG6d?=
 =?us-ascii?Q?CqzAGLpuXjjwJtVEsDoAg/v92ElrsYipSJ4CUC0/6RmlN23FSpI2Eni7xWwt?=
 =?us-ascii?Q?s2StzVGqwh7ItWX1hm67JtAxdL2r/HmkFec/vHjdbN/huUqm1/z30RaEEbP1?=
 =?us-ascii?Q?udmEedZ5fxAksFAsBTUbTmWKePgPtBrWfDqW0yuSJhGbHUj6z0TLIBD1Zj0I?=
 =?us-ascii?Q?ytjg2zC11VmBWXziWKV+OKKg27w7f2bDuhYK8/hYLSh9yyANQ1D4ouPqrxDW?=
 =?us-ascii?Q?gwquGm5maaEPM8jrddrnDdyYUwioqdgAKe2CMr5/j715ktUnjzzh5tFi5cu1?=
 =?us-ascii?Q?iqvt65WhlDVG8y2wVi2bZDPpp1SgozeqPpeIFbt7J1wfCzC42EQZHZldd24o?=
 =?us-ascii?Q?GrW5Q9n+a3jyTQnEEq4ngs8x9O6Wc8ofVvopYcnwVwE/Ch/xaDkRfMesLgD2?=
 =?us-ascii?Q?43B3CAJlhc9WsxdGqs0SImtb3zfCAUexSBVhz9y/gzadr2XD5Zb3ZlemlaJA?=
 =?us-ascii?Q?G0SLFez0ICRx/S2wmg67z/H5RZdyxh7Rm9Ncb2Ygt7Hd82nmblpPWj+e9MEH?=
 =?us-ascii?Q?B6YBW9vY+hhQUl+L+YZau5m3WeT8fCqGDLTOCZAg/TDP5PLLCnhnDpI6DNfw?=
 =?us-ascii?Q?FXjrrfLIvJVDDw7jwn2cBG+DnzlG/GtJ2EDTWe0b/5Hqk46rRcV2VabkMl0+?=
 =?us-ascii?Q?DGMxJyWutJ2Uh6DNIO23ppCXEgkTbmf3WSrqJHa62mEhJRIFW83+j6u+PjpY?=
 =?us-ascii?Q?grB+M0P42DCXdwLp2RnOcWdmgVsCL/TVHsyYi1fJd+fR?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 06:38:34.8009
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d3b2d1-b661-47bc-01e6-08de5f0106f2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6971
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
	TAGGED_FROM(0.00)[bounces-69509-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 4B4E5AC465
X-Rspamd-Action: no action

From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>

Hardware does not save/restore FRED_RSP0 for Non-SEV-ES guests.
Save/restore it early in svm_vcpu_enter_exit() so that the
correct physical CPU state is updated.

Synchronize the current value of MSR_IA32_FRED_RSP0 in hardware to the kernel's
local cache. Note that the desired host's RSP0 will be set when the CPU exits to
userspace for servicing vCPU tasks.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Co-developed-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
---
 arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 05e44e804aba..ddd8941af6f0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4192,6 +4192,15 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 {
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
+	bool update_fred_rsp0;
+
+	/*
+	 * Hardware does not save/restore FRED_RSP0 for Non-SEV-ES guests.
+	 */
+	update_fred_rsp0 = !sev_es_guest(vcpu->kvm) && guest_cpu_cap_has(vcpu, X86_FEATURE_FRED);
+
+	if (update_fred_rsp0)
+		wrmsrq(MSR_IA32_FRED_RSP0, svm->vmcb->save.fred_rsp0);
 
 	guest_state_enter_irqoff();
 
@@ -4218,6 +4227,15 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	raw_local_irq_disable();
 
 	guest_state_exit_irqoff();
+
+	if (update_fred_rsp0) {
+		rdmsrq(MSR_IA32_FRED_RSP0, svm->vmcb->save.fred_rsp0);
+		/*
+		 * Sync hardware MSR value to per-CPU cache. This helps in restoring
+		 * Host RSP0 when exiting to userspace in fred_update_rsp0().
+		 */
+		fred_sync_rsp0(svm->vmcb->save.fred_rsp0);
+	}
 }
 
 static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
-- 
2.43.0



Return-Path: <kvm+bounces-69512-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ENVBGtQAe2nKAQIAu9opvQ
	(envelope-from <kvm+bounces-69512-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:40:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DBD15AC47F
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:40:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BFB7C301C595
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 06:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 037533793B7;
	Thu, 29 Jan 2026 06:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QucO+FC8"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011058.outbound.protection.outlook.com [40.93.194.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5871E1DE9;
	Thu, 29 Jan 2026 06:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769668794; cv=fail; b=tmOdsXPbWBPrY/AEp28w7FI2xgvhhqNIEVS/0oIEpuILWTnhWG8eTTF+HTN2nmbCrP+hPZrdCVAOjt7s63dpfYMs05M65xd7GSb1bRvvEPTpV8IsDDlc4BqUMvWNfdRMZ/1bf21fTyAXl6/rO3Vw8NetT3dVwucR8B/B0OIJwNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769668794; c=relaxed/simple;
	bh=TROuxJJZ7v8eOcelpU+5RCRer7bQznteFwqboHm9T4c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jVlAhW3JYMAMyeLR6jU/iKf/yhKMISfRtkGLELMAE/IINOgc/vVBa1TqiDTyFO1Hz5fDBnMp6Ydj/W4ZthWf7GvlwvmGW+dCQFjtxhUTnRhEh6kE+sEsP+VTjcMarTj0xkCk/y3jMxS4Z1V+Msahygx+VsoyYLiUQGC9rAx5RM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QucO+FC8; arc=fail smtp.client-ip=40.93.194.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V0m0rUYOaFubAafXHIbDUKa7Ysk5B74LrhauSKYrL0fHeT9ZVT61ZFfxIPEgTByRMb3w8ey/J1qj+Yq3cBzw4fezkB7Pxtc/1Rp1Rz72gxWIG4KKmeJMPzcz5F+6Tz+/5cKdqETVICyss20/iMWq2wvWuUroxS+f8bH3Nh/BximPSZJa/RsSFATjO9eOQ4CrVr5XChDGnV0gsPFAYoofSHz1KJhMHTxzUEGYlza95d+IjS8fSBorCUesZAhWurcBSOYuGqj27I2coVT7CKnRdIRUZ/HEb/dslcj3hRMTqUVbsxI1IW8gt070tJaex0D5UW35RLWh5MjebkKngMMgDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BD+wWEjFxEkiPjMdivG1mjVq64fBQWPhFGgmFqMxgMY=;
 b=CjbSpNWeFH8hoR6zrUqnSh85/S8ndLdc2ChwnhteuLNu6lfTXdpRpV60XmGgh1J2W5gbGQOX+zQbcv/BnSybF6AyoN45YgTYp1DnAuzd2T+ZPeiYGethB0Ad+BaYXiU2RugG7UxEB0Ftry5nkX1/mciTwsglYwfl4KbDwS6lEMRoh604TvvVikOM3C0BvoPBkYWbJlah0f8O749WVfsz0+XunxjM+tlI2HRZKBfLGZSdo1d+TdvxOLIS0HWceSZPDR+eSgUhSJI9SmJzb91nQd2D66XSW7pBK14Cs07ZnutzrVnV/HkbrU+dLrk/yLM+5T/szfkUCxPKWlgVeR26CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BD+wWEjFxEkiPjMdivG1mjVq64fBQWPhFGgmFqMxgMY=;
 b=QucO+FC8aH1T/VCb81Qk6ZD/cXNS3xfBuswgxnPa0JMfMK4G0io+VyM2DEbiQiXb+dlE39eLvSGope43A6RkVg9l69leq4epeQoCUGgajkACt9Rg6x15QOKaj/mMJmoPPgGMIqvwizKmof49KaUbmiRuRVqHKZ9dne9muSdaBT4=
Received: from MN2PR13CA0021.namprd13.prod.outlook.com (2603:10b6:208:160::34)
 by LV9PR12MB9758.namprd12.prod.outlook.com (2603:10b6:408:2bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Thu, 29 Jan
 2026 06:39:49 +0000
Received: from BN2PEPF00004FBB.namprd04.prod.outlook.com
 (2603:10b6:208:160:cafe::4) by MN2PR13CA0021.outlook.office365.com
 (2603:10b6:208:160::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.2 via Frontend Transport; Thu,
 29 Jan 2026 06:39:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBB.mail.protection.outlook.com (10.167.243.181) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 06:39:49 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 00:39:45 -0600
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<xin@zytor.com>, <nikunj.dadhania@amd.com>, <santosh.shukla@amd.com>
Subject: [PATCH 6/7] KVM: SVM: Dump FRED context in dump_vmcb()
Date: Thu, 29 Jan 2026 06:36:52 +0000
Message-ID: <20260129063653.3553076-7-shivansh.dhiman@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBB:EE_|LV9PR12MB9758:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ece5ad4-f901-45dd-af5f-08de5f013376
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?60TeQxpXWqhLUa/FLuMwbQWNOcAV8VkGJqiAThAy+DlJ1PS76+XEJvYD8VMx?=
 =?us-ascii?Q?4+Pe5JGcCkcVjRH142N4ILtJKaqFGHckVdMN4fq8W1RgWBfwFjUjkZp6D2GX?=
 =?us-ascii?Q?dQ/qzDjhGnenoGBBoQlLvS6oWK3RoGJRIaiR8nlckYkCza+kminM9HJyyMr6?=
 =?us-ascii?Q?mYr89BYTE59ngQJ34JReEiYPMwKT9H3XEvGrF4JIjPGxp94FsAUAP69hHrQR?=
 =?us-ascii?Q?wajcQIMr2ob/boCckJxNB3JM4Zm+Pa43OE7P79cOAY6fJy14t8iATq7IwqBB?=
 =?us-ascii?Q?1G+sPoneNjF3DvQFSobwqRCu4ZVJj8gS3+o5MF4dGQKzW435OJp5i28jdIP4?=
 =?us-ascii?Q?u5VFozMVz1IPVlqtHFugqxI4/3jyzz45dEEkxw1Lh+ZWOhiKpcdW7xUI0S6t?=
 =?us-ascii?Q?1EkvyJKOiRVGiiqG07d5bSWEGZuYGq2tCnd4K9TnTG8h8K/wvhYAIIkaA9r6?=
 =?us-ascii?Q?pXxTTbvI+IoVXkhRacQcpWN4yMs7XKHi2mQg0/1sWp656YX4th6Ad4xAMdN9?=
 =?us-ascii?Q?olwmGdF7/jd/ZqefJqMPX8zuXW2EfBX/g/73c8lpg0ycErgps8haOmn2yLED?=
 =?us-ascii?Q?bLiIx7gQwOxl8nB3SljEcQzGoO/tX5b5hkB9m7SdPKlHpmHyiKT6DUCd7W7+?=
 =?us-ascii?Q?jfGPvD93eAMRnlKNYANX0rKcEoODMfYfmnYAcYt+sZA9+aZCN1X3zzW/1ZS9?=
 =?us-ascii?Q?B8PxjASrSwL6gGWTI4YGSMOGlLfXRZyoE5AU10RELcTbUL/wQebOtNppPtol?=
 =?us-ascii?Q?2LVyYgjVhwF/luCc5GW/8b2CSgZsNlATOx8C0dp8mL9CUlDkFCDuyogVg0hQ?=
 =?us-ascii?Q?fIT1Sp/fn991+tGT508W5DwV2k+PvC5dHUv21hQfiZNpDUirwPR/2dAUwsOd?=
 =?us-ascii?Q?KNmH7d2xWYcSjcgy3ldyFbeaYe+pcHGxb2ODRXExer6C4USsu7zrWjk5iPXM?=
 =?us-ascii?Q?sX/0zVtmhnqNA/vK7WSabzMguSbSWUr0FOmxmpeHp63LtZ7GBZokmbYf12Q6?=
 =?us-ascii?Q?sAlSfkorFhU16vmyTfMaYkMNA+nwwN9JV3RiuxoC/2TdEv0RMr4panp+58Nx?=
 =?us-ascii?Q?WhOho+dPTBhoGsB1izj9NU2M7acIeQ0MOs6RHL/sG17lkzvMkDlph3B4tWw7?=
 =?us-ascii?Q?k+/BSGMXAOSvctC55gD6m5O43Eg8w1Tl4uJzZ8NcZPCktSGz7pm9ka3DUVn0?=
 =?us-ascii?Q?hTtDWV/xOWztji4BCP6gd+jxac+c8512e5R0E3UosZpwsVNLvM9+2yZoI5Q/?=
 =?us-ascii?Q?oS/QiO1g8SLyLds0ftfxTmBl5Tk5MuV2hSSuCCdTKsjLTY/ZBL7H9BH87UrF?=
 =?us-ascii?Q?WxzRAJTZBXxnBlOh8FyhkMryDKGURL5J8Lx6iSWjiAgVKNQ3rWhnrsZjtM87?=
 =?us-ascii?Q?ah0dYjUPPIdCkppunK/05Nf8FZf9Fmt7lE/0YC7r7miWur2Qaov5AdGOuiPw?=
 =?us-ascii?Q?ereIeVqHnufxq5onOj8DC4+1m49ZTeGthhAhtRS7W4J9KFnQ5yumybBsCOtu?=
 =?us-ascii?Q?+qykYb9+PbjVpLK03jsXS5AlIBPfcSzxMTMAPo/YbyaYOrvLuiYOjBEP1JwD?=
 =?us-ascii?Q?2ifNTIchwjQfpR6kxumpJtcXimLBSCwruaCvufDIy0m7nnngDGYFKFPhwuiL?=
 =?us-ascii?Q?kn2KknCLD2NxR3PBIReZ0vsu9dZHj8vH+5vgLx6hbBpfqNxsys43ct4bAwN5?=
 =?us-ascii?Q?qpDmOA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 06:39:49.5177
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ece5ad4-f901-45dd-af5f-08de5f013376
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9758
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
	TAGGED_FROM(0.00)[bounces-69512-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: DBD15AC47F
X-Rspamd-Action: no action

Add fields related to FRED to dump_vmcb() to dump FRED context.

Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
---
 arch/x86/kvm/svm/svm.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 374589784206..954df4eae90e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3319,6 +3319,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "vmsa_pa:", control->vmsa_pa);
 	pr_err("%-20s%016llx\n", "allowed_sev_features:", control->allowed_sev_features);
 	pr_err("%-20s%016llx\n", "guest_sev_features:", control->guest_sev_features);
+	pr_err("%-20s%016llx\n", "exit_int_data:", control->exit_int_data);
+	pr_err("%-20s%016llx\n", "event_inj_data:", control->event_inj_data);
 
 	if (sev_es_guest(vcpu->kvm)) {
 		save = sev_decrypt_vmsa(vcpu);
@@ -3434,6 +3436,25 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 		       "r14:", vmsa->r14, "r15:", vmsa->r15);
 		pr_err("%-15s %016llx %-13s %016llx\n",
 		       "xcr0:", vmsa->xcr0, "xss:", vmsa->xss);
+
+		pr_err("%-27s %d %-18s%016llx\n",
+		       "is_fred_enabled:", is_fred_enabled(vcpu),
+		       "guest_evntinjdata:", vmsa->guest_event_inj_data);
+		pr_err("%-12s %016llx %-18s%016llx\n",
+		       "fred_config:", vmsa->fred_config,
+		       "guest_exitintdata:", vmsa->guest_exit_int_data);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "fred_rsp0:", vmsa->fred_rsp0,
+		       "fred_rsp1:", vmsa->fred_rsp1);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "fred_rsp2:", vmsa->fred_rsp2,
+		       "fred_rsp3:", vmsa->fred_rsp3);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "fred_stklvls:", vmsa->fred_stklvls,
+		       "fred_ssp1:", vmsa->fred_ssp1);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "fred_ssp2:", vmsa->fred_ssp2,
+		       "fred_ssp3:", vmsa->fred_ssp3);
 	} else {
 		pr_err("%-15s %016llx %-13s %016lx\n",
 		       "rax:", save->rax, "rbx:",
@@ -3461,6 +3482,24 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 		       "r14:", vcpu->arch.regs[VCPU_REGS_R14],
 		       "r15:", vcpu->arch.regs[VCPU_REGS_R15]);
 #endif
+		pr_err("%-26s %d %-18s %016llx\n",
+		       "is_fred_enabled:", is_fred_enabled(vcpu),
+		       "guest_evntinjdata:", save->guest_event_inj_data);
+		pr_err("%-12s%016llx %-18s%016llx\n",
+		       "fred_config:", save->fred_config,
+		       "guest_exitintdata:", save->guest_exit_int_data);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "fred_rsp0:", save->fred_rsp0,
+		       "fred_rsp1:", save->fred_rsp1);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "fred_rsp2:", save->fred_rsp2,
+		       "fred_rsp3:", save->fred_rsp3);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "fred_stklvls:", save->fred_stklvls,
+		       "fred_ssp1:", save->fred_ssp1);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "fred_ssp2:", save->fred_ssp2,
+		       "fred_ssp3:", save->fred_ssp3);
 	}
 
 no_vmsa:
-- 
2.43.0



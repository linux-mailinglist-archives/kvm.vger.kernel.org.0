Return-Path: <kvm+bounces-18495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 248678D599A
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:47:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD6E0287E0E
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20EFD7D096;
	Fri, 31 May 2024 04:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aZHR/Ivu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC077CF18;
	Fri, 31 May 2024 04:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130837; cv=fail; b=PNgr3SshuIZ6LydRnxbeCM5gIBjsqWnUobW/6eF+LmUzBCI792blZ26FyZbxRXu/hfDsbpoS8wChigJzxwIt4pdpXVvahY7NN3OBis9umkwZQ93NQSB+fINU/SRULPMaP3srmBBVtAHO9QXyiyEEj7LiPs46865fwC56zYQrPZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130837; c=relaxed/simple;
	bh=5lL3aI3vi8vCy5aBU5bpgG7/xxPIb+EB/xm23JrULVY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fg4USjcd54uQ94AlWGIl0Hj49Q7mlQn4vZS636iVDcScy9A7CzjGjj/Cn0gz2mJszm0ohwiIGRg9F5lE0jRobC3whpjmvcKqzKEBHKEnyMeF+TuCxnehErwqMcakA7BWR3KXdA3Ia/7Pl4hUmJ0sLEBxMWMNaS/GijjSmGoABtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aZHR/Ivu; arc=fail smtp.client-ip=40.107.94.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVddbopjRB6jVztSL5S4oES6F8IkggUQs1TSeybXdxd+8E5ZaCbJlfCzmbFPzG0bzhKIVoP+jABRFlkQoJABSAOm+p+R+T1gQXKEJjixUOg8NMdEJg3atPnHMhiXb8FWmxhVG6UKsnlspcwAQlR5bU7Wh8+xb4r2VaRhQcLj5uBH91zV7XttUIEx+WW2R2f2JgsjMGSUsFSq77rJ+5CqBWMJHz50oz8zUT+OCHOABzx4guxSfb4g/JaURt/uGfAbeZf0gMasXUr6YGG3Y6NTOQ/TkI54MAD99pYaCLZQ1qFglLSl1Lb2B/B5RD3u4UvAry27Wled2OSamANgd7Oa5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NSsPs08EE4IN8Hd/z3BInqa+SvueQCn4d/dTyrIvO30=;
 b=aG0i+5RELlw525s6ep19vUUSISonrPSJIZBvl2Y9evLoC4HGkmplQlqaZIiP5WEmf00K6ban+Dxu+gN5oy1g7GAyoqnv2G421tPqpPp+F5slSpGtlVK6JTX5a1TgEQKwMC+qhcYw003Rsxp8/VVDWqXbm/mXgjhI3zt1yxbc3tef8O+AjEJRNNgnCeOuK+5fjI+b+TTTDkqH27fEIWtfJ0Jfuku7RtiaY01DT7SVSzJcsIpJQB5hzLDhMFNIej7xtx+fTeDRw3zyik9PKCdwIzwlgsrIpRy53bJZFJg7fcumXvac5upZQ+H+zS4I04LFWor6WbZbZZ+zVH98C58b4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSsPs08EE4IN8Hd/z3BInqa+SvueQCn4d/dTyrIvO30=;
 b=aZHR/IvuSSKpI2tL9ETzk5jd/5N1tcquXrbHI3K8k01Lzw2xS0SuvYyxG+DNmH+ghtIyQSv3eE7nWlA8N3h2gMRd2wbQ6BWsrZ5/OBdRXbvZQ5IjfAInP2W7uFJuZqUSmHGXpy7QV0noyi2kTnuvQ8iZwlCJAeK9pJuL04LIVTI=
Received: from CH2PR16CA0003.namprd16.prod.outlook.com (2603:10b6:610:50::13)
 by BL3PR12MB6474.namprd12.prod.outlook.com (2603:10b6:208:3ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 04:47:12 +0000
Received: from DS2PEPF00003442.namprd04.prod.outlook.com
 (2603:10b6:610:50:cafe::89) by CH2PR16CA0003.outlook.office365.com
 (2603:10b6:610:50::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30 via Frontend
 Transport; Fri, 31 May 2024 04:47:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003442.mail.protection.outlook.com (10.167.17.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:47:12 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:47:06 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj.dadhania@amd.com>
CC: <ravi.bangoria@amd.com>, <thomas.lendacky@amd.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <michael.roth@amd.com>,
	<pankaj.gupta@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>
Subject: [PATCH v4 1/3] KVM: SEV-ES: Prevent MSR access post VMSA encryption
Date: Fri, 31 May 2024 04:46:42 +0000
Message-ID: <20240531044644.768-2-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531044644.768-1-ravi.bangoria@amd.com>
References: <20240531044644.768-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003442:EE_|BL3PR12MB6474:EE_
X-MS-Office365-Filtering-Correlation-Id: d31c67a7-efae-4cc2-d9b1-08dc812cbc9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|82310400017|36860700004|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OUSqwfa2G7Ca9vGhO5YxYK2XdQkls2DfgOh99/O0kNR+q9L9A6d9PWjwByYk?=
 =?us-ascii?Q?it1sIkhLJ+Mg67iIYXRWo/CHYACNUyzSyFKOZwzJqPwpM4cBcOTGxodF5L/V?=
 =?us-ascii?Q?hLVEsAGLxARGKZC+qyvUN9KZoZDJy0AwbhL9CpUnSYBZr7l6sBdIEiN8WPXz?=
 =?us-ascii?Q?o2CRpwiOYgDFfp0wMwXiTKRA97EhgRjA3B8zQQINldZ2Mt6iZcT8pTx2k+Zu?=
 =?us-ascii?Q?7J4OimPZq2WjSMwCUyGpstUd58wgSE7jMX+jnmQsItiU2y8uKCdefQtNTpUN?=
 =?us-ascii?Q?0E1Tqos9GXpHq8qU3CgyK0fa/Au70tusGlj7T2mkYaAaBwkPhT5VP+xo4IbA?=
 =?us-ascii?Q?XhZY5bVuupgrbrlcj0pxg9CzhuA6NHqKVKrdJv28NFRLZg8RPSp02gOnFDG1?=
 =?us-ascii?Q?5nauGLgKvkAm4pzEQcBPTlQoOzEPb0fXG7uV3XiVyKXnM2UK67bGiAgPPPhg?=
 =?us-ascii?Q?I3c67Sm/UQz1rLUFuKMjzSjReIiLo82HuK66WoQUGG3uuqWDgwCCtRbQmmUs?=
 =?us-ascii?Q?kmE8Lt5dqRwPVXu2UDXe7gIAb5f8IRmostf8eXCMu4CY804g9Miyd/MUt5WQ?=
 =?us-ascii?Q?cySM1QY6r9xx+i0LC/sabf/rJOofMR472zBdEGNEVdnEetgkN1oK/FoJstJx?=
 =?us-ascii?Q?O9fRItuGrOUEjLdWxwmTofZoHuHlXcIhPAAGR894RXINzQDazxXLZMDidQhX?=
 =?us-ascii?Q?CLjAzAR3gQj8Hre8LP20Zp1mxcgURmL3qeRSgBZ34i5GUZSsOPPR7/MRoe2c?=
 =?us-ascii?Q?7hisYdtu/vhnJzXc0zmkY1Xy86DskddME5e/GwOB6XERAs7tVqz19Hxp+1wE?=
 =?us-ascii?Q?CtqvMCCc4gpXxxByX7S1rXZ3NYaDtbdfJefXc3PMVcMDzL5Kp+Vl8K3j9DbI?=
 =?us-ascii?Q?ZPOU/K2zHoknXgTamR7tGPDPxfohkGAU4JZoDMwUukBhazUWv1yyXgzjUGZz?=
 =?us-ascii?Q?PNSma1nwL1rWJ6iM1xKj2qF4qH1y5zPytOIAC+PWXYwy3G2mN9mdGoJeu76e?=
 =?us-ascii?Q?6dE7xXaHMWX0+bjzd/Q+4PLokFlNp4xswN+z6yBCCTglopjXJF1l/C0AKWXs?=
 =?us-ascii?Q?e1NBqEWuLK32QQCOjc5ToRJNaWBPZqq/4SHTXHSPALdRWyUpD50u4AV/SUdM?=
 =?us-ascii?Q?AlZQqFEDYyey2+NaLJfhFUCoLLw30UzRd+l3Dz8WvAPiu56Co1AoLqzFX5Fp?=
 =?us-ascii?Q?UPg785xSBKOSR2hO78B6x+IHkvaYcY3Zqf5WsXMAoqI/zuee1/XHLu53iPtS?=
 =?us-ascii?Q?VFkF40KoV5I6FFUQagLt6t82ro2XrJk3oQfb2bDlPBAq+0+mjUBFp6Qp1CBJ?=
 =?us-ascii?Q?bnIn9UsvPIMUiE/fuhxiQZNxrteDYKYcnP23cCYOAn8Ipxbq1x2JC2Q8tXM1?=
 =?us-ascii?Q?2B0nEu8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(7416005)(82310400017)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:47:12.1704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d31c67a7-efae-4cc2-d9b1-08dc812cbc9b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003442.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6474

From: Nikunj A Dadhania <nikunj@amd.com>

KVM currently allows userspace to read/write MSRs even after the VMSA is
encrypted. This can cause unintentional issues if MSR access has side-
effects. For ex, while migrating a guest, userspace could attempt to
migrate MSR_IA32_DEBUGCTLMSR and end up unintentionally disabling LBRV on
the target. Fix this by preventing access to those MSRs which are context
switched via the VMSA, once the VMSA is encrypted.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3d0549ca246f..1a01293f6909 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2834,10 +2834,24 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 	return 0;
 }
 
+static bool
+sev_es_prevent_msr_access(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	return sev_es_guest(vcpu->kvm) &&
+	       vcpu->arch.guest_state_protected &&
+	       svm_msrpm_offset(msr_info->index) != MSR_INVALID &&
+	       !msr_write_intercepted(vcpu, msr_info->index);
+}
+
 static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (sev_es_prevent_msr_access(vcpu, msr_info)) {
+		msr_info->data = 0;
+		return -EINVAL;
+	}
+
 	switch (msr_info->index) {
 	case MSR_AMD64_TSC_RATIO:
 		if (!msr_info->host_initiated &&
@@ -2988,6 +3002,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 	u32 ecx = msr->index;
 	u64 data = msr->data;
+
+	if (sev_es_prevent_msr_access(vcpu, msr))
+		return -EINVAL;
+
 	switch (ecx) {
 	case MSR_AMD64_TSC_RATIO:
 
-- 
2.45.1



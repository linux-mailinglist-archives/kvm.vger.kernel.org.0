Return-Path: <kvm+bounces-15442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A05168AC09B
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:09:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 572BB281354
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C21E63D3A4;
	Sun, 21 Apr 2024 18:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nLjc85bm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529C72C853;
	Sun, 21 Apr 2024 18:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722952; cv=fail; b=CfJ/R+3Ts6jDbEawUaYMVk4F4NedZT0GJQnHvaJolcV3q3ATEkly7aDh7Yf58zSwe8B97Qpzvze/AbF1UMgjRgk+/nsiCIIOdhu0Dhp46wcDKONGpL2BC/vjD6HFXbK7nE9UrsseG2MbzuFrN758BkxxQtmxDdDLzI2slOkD1jg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722952; c=relaxed/simple;
	bh=uQ7Kx3TwQhw26SgLxowep5X/GtjYEaH5Eg1Jg4fANxI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XvmGQrhVsD+5qbkMHg1qqAakImG0xl2BpsT2Jo/scBZKeJ9XI4TbZpL3bzAZq52Rv8ATLC2SqpK/81wOwDbEVUvsF5WrEWNsWIzH3PI8yYccKq02O6egA+GEJdGlHBfTEHqefs7gAig7CYzd9Q3Lz/N8AL4ZUBECKWs16yMHDkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nLjc85bm; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhTe5uq0el5Ao6VZyd18+tbbXC5IVMDSuCKTOuGuUE+VFFy6CinTW6rOYBqsOEnWPDnf7CcKUZbq28b0wVVxx4Eh1/AdJk8CWarMMb2/ZFTvMHhJAkfEOd6Z+tE2iQhkrZJVGgX9Ec5t+5QPL59Obd9/LZGdkyh8Euduh3r+1uIKjZJQ+rK/UpiS/T/bAGxLJUkU8kAPxpY5/auFcLjV5b1k/u3ilVitlzW6wg4YtMZcm2Q4GUIMl8J0YyQSr8mK1fFOYkUgS+pH4fbGO7x3y8A/qeFOzJVrPxqNvW+wKSVRizelJbIO06KnBZezzBUi5GIyUDznbf8LCGfgF4WYeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUcwiyFHOOyR1TxaHBGwT/R8u08BH+n1ydQXmt0BUDo=;
 b=UD8V9GBwoE04GYRd7YZQ0YI4AVyftlEsmbz1G0z9Axszdc7TROobl6ErRfftmNvc1KTvyPHl8dHEtFokQeHygHc4ZY59WOgPlKdJDvpWE0CfHlo97o1xAnhx9zlNdWoNyPUN6cofILh+PGKMR2nEMIh/hHdLZOPzStUZ9gLHOvaTcTXkE8JPO4D8FJ8rGLvq630nsH0j68X/BEXHPeeRpIW6Dz8cNyk5DfqIZ2yWwV2i0sFTVN3e1sPZxQwC+tpbfAjDaGHXb/WSZQEOoVsvK5e52VLdalR4YDmNUKwoRqdQ80tZJB+/WI2nTK+ECyjYzLgM2Aw8zJE1JUfLE7SJmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUcwiyFHOOyR1TxaHBGwT/R8u08BH+n1ydQXmt0BUDo=;
 b=nLjc85bmeMpHY4+KmPiz1lSmKf5c3iGwtbhjaOCa1ZeHxPklaTmVD8BByuNP6/RzHwGAA838g9SSQN6KUlHoYmaALQMIVR+Kv4IstiGxzJta9u36646ByjECHLgOAElTI15osR/CSVJh8C6ZHSztFR4VENXjLfbc+6WvjeQMU7Y=
Received: from BYAPR11CA0097.namprd11.prod.outlook.com (2603:10b6:a03:f4::38)
 by PH8PR12MB7448.namprd12.prod.outlook.com (2603:10b6:510:214::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:09:03 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:a03:f4:cafe::68) by BYAPR11CA0097.outlook.office365.com
 (2603:10b6:a03:f4::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.32 via Frontend
 Transport; Sun, 21 Apr 2024 18:09:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:09:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:09:02 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v14 02/22] KVM: SEV: Add support to handle AP reset MSR protocol
Date: Sun, 21 Apr 2024 13:01:02 -0500
Message-ID: <20240421180122.1650812-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240421180122.1650812-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|PH8PR12MB7448:EE_
X-MS-Office365-Filtering-Correlation-Id: fc9b7ceb-3d34-4834-4b05-08dc622e20b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?huaABAK0E6/58H8ZcUROohLzz652unpG7GsDtz3fKe1GK/gXuqVQ7p2y0Mtt?=
 =?us-ascii?Q?RBYj+WLS/ftxC2RzSd9Yz9DRWfRK3OvsUKu8b3zkVvBzMutUDBPAv8WmOODr?=
 =?us-ascii?Q?gUrcu9JZQ/b/aRWdcL+Ud+0IPLU9aSOadWlPySp8h4KjN/Rboicfqis3Dg/Q?=
 =?us-ascii?Q?23UcDk8bUwSUEQI1qyWOeN13JZtEkHOA4iv+KJevJPn1cVQ/wNmy5VEdOKyP?=
 =?us-ascii?Q?27UXOoO6lO6mvNxAH/S5VOtMF8egrCY6DkJ6OTs92TbwjEWL1juhO0hPHWri?=
 =?us-ascii?Q?fs40gfXmhSyMSr1bNtQ3pa3O7QsTZ7pEuaF1j7X4nS3JGlN8w6AO9hdzISw3?=
 =?us-ascii?Q?COG57HHeQsD3BH+sZ3gXbf+ermmqi7kOZ9RAch/HORr2KQdgsDbAZzHMjYQS?=
 =?us-ascii?Q?c9faN7AbSbqDyTx4E0O5+QHoY5NwtgYlTmJozQM5zd3O9KrFsVJtyHL2DE1g?=
 =?us-ascii?Q?X27W8OT9rlV9eqswPDtZvxGRdB4yWl+WiYsPqFFX/bcbQADr+4yfpRir18sl?=
 =?us-ascii?Q?2EiJ3vk1SqP3trfWIcn+nS2XcEpS8Ym5QKP6x9Ln7JNIkt0DziUi2xpa+aPF?=
 =?us-ascii?Q?qLQhxNh/NP1l2557/7UgqlL/gl7hKsiRVjs9NLAYpHwFGMtvDJSWSJPUEEp2?=
 =?us-ascii?Q?8QaxJ44vldiKHuwjepeyWuHmIydwRNasNGgMh5gou5ZrwuIQYVeXAww5nNGq?=
 =?us-ascii?Q?lcQhBvvZR/z56h1XPhStBhJeQiqUcLIbca6lCDZMjH1eMztCcpjBPR6GVbxZ?=
 =?us-ascii?Q?2HZC/pIJJt6vQqo1DzxoR5BrhqMIEhlvPcwtHF3zZcAP8UccwfwAMsdrqn+J?=
 =?us-ascii?Q?Q+/1JJx5vVWqbMf2f2jFDoETcqZt7EW5nzuW6cCVuwGJguhUEkcEFFjjSn9L?=
 =?us-ascii?Q?cWmXgsnKc02xJj7k6asNVPFlxmsNvMzBeIsXwGNURvqIw8lXuHh6hucjWZpu?=
 =?us-ascii?Q?ZkHwu2X0P/M1OSyHg/lwPVZ2umY2l22AM/ri1F8+Uj6Bw0sysSdm9pBnWROj?=
 =?us-ascii?Q?9k/CXgHi7zL/MwZY+/4OMh9nPm6ldfgyaQn4xZRJ60DnaV1OMkjkxSFZTSZ4?=
 =?us-ascii?Q?FXXPTuBtwA8Co5cVEjUYbmdmvr+xr1nRSBheAt9/lAkuHt430GRUrUG7oAQt?=
 =?us-ascii?Q?fFcK3f4LxelFImvcLuJH/ptm9tZSOuHpAegBRFgeiENzbQSpCzD2KazSu8so?=
 =?us-ascii?Q?0uMuY9BzcRzlj0JhtQ94wRyXmBoHczUIWOQbJzZB44OGnleErZ+JxKgDdReh?=
 =?us-ascii?Q?3u5xTLvZ3NOn6AZb+U1Q3CdhUS3RKRQEhOTdBPXe59OouCfCtrToTQhXnslp?=
 =?us-ascii?Q?n/jYjODTGsOs6Plk60x75p8i4kC/SlHYiwVOM43BhmV81p972EiOcumU2suF?=
 =?us-ascii?Q?n3GbuKkwSxIOZkL9UZbT4Vw7gJyh?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(7416005)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:09:03.5600
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc9b7ceb-3d34-4834-4b05-08dc622e20b5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7448

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
available in version 2 of the GHCB specification.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  6 ++--
 arch/x86/kvm/svm/sev.c            | 56 ++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h            |  1 +
 3 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index b463fcbd4b90..01261f7054ad 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -54,8 +54,10 @@
 	(((unsigned long)fn) << 32))
 
 /* AP Reset Hold */
-#define GHCB_MSR_AP_RESET_HOLD_REQ	0x006
-#define GHCB_MSR_AP_RESET_HOLD_RESP	0x007
+#define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
+#define GHCB_MSR_AP_RESET_HOLD_RESP		0x007
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 598d78b4107f..6e31cb408dd8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -49,6 +49,10 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+#define AP_RESET_HOLD_NONE		0
+#define AP_RESET_HOLD_NAE_EVENT		1
+#define AP_RESET_HOLD_MSR_PROTO		2
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2727,6 +2731,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->sev_es.ghcb)
 		return;
 
@@ -2938,6 +2945,22 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_AP_RESET_HOLD_REQ:
+		svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_MSR_PROTO;
+		ret = kvm_emulate_ap_reset_hold(&svm->vcpu);
+
+		/*
+		 * Preset the result to a non-SIPI return and then only set
+		 * the result to non-zero when delivering a SIPI.
+		 */
+		set_ghcb_msr_bits(svm, 0,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_MASK,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_POS);
+
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -3037,6 +3060,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NAE_EVENT;
 		ret = kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -3280,15 +3304,31 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		return;
 	}
 
-	/*
-	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
-	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
-	 * non-zero value.
-	 */
-	if (!svm->sev_es.ghcb)
-		return;
+	/* Subsequent SIPI */
+	switch (svm->sev_es.ap_reset_hold_type) {
+	case AP_RESET_HOLD_NAE_EVENT:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
+		 */
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		break;
+	case AP_RESET_HOLD_MSR_PROTO:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set GHCB data field to a non-zero value.
+		 */
+		set_ghcb_msr_bits(svm, 1,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_MASK,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_POS);
 
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	default:
+		break;
+	}
 }
 
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 323901782547..6fd0f5862681 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -199,6 +199,7 @@ struct vcpu_sev_es_state {
 	u8 valid_bitmap[16];
 	struct kvm_host_map ghcb_map;
 	bool received_first_sipi;
+	unsigned int ap_reset_hold_type;
 
 	/* SEV-ES scratch area support */
 	u64 sw_scratch;
-- 
2.25.1



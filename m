Return-Path: <kvm+bounces-34417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7DED9FEAA7
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 21:37:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 234463A28B0
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 20:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 754BE19B5A9;
	Mon, 30 Dec 2024 20:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LSeHkVfH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2080.outbound.protection.outlook.com [40.107.236.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AE519ABAB;
	Mon, 30 Dec 2024 20:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735591061; cv=fail; b=d8Mrf654QRZnnUhXXEorb9P09mlz/hABtwFLexdLRF4mwcEiPqY0QQK4JOdWFcuYBMV73tXI6YiF5ahLKiqgY04NvfYy5zqc6eNCIUfCuJx60lawS4LgQFvvwBqtMZ+mPggCty8gUPhOb8OzV7vYO77qwI/TnmzhU1dXRcGS9JU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735591061; c=relaxed/simple;
	bh=Wl0l16aCHgK7mSt5buk9CjXiz5kKnzqvsd0fyVaDBRw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=obw4nGXjm+3/ZTD0qfucHSn07ftf4k9xbwKgxHpZ0iumyVa3ZsMWr9bgCwIFhKEi9YZ0ai0QObb0p64GnlLfg1iNDZmNr1TuJrq4Cp6Dd912PGrC0GiAd82Syjpb0+EVHBC6vsKv7U8gJ/sZka7aXzIWhRFV5/5cifUr58AZRQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LSeHkVfH; arc=fail smtp.client-ip=40.107.236.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QJu6qjR9E1Dj0Ha9+1vcLDy2PB/WDd/Scnm/fykHfgWxqIBDOkvFs7EPMYG8lhkcr98CX4KceDjyIv+cZ4uI3TO2+bPLVpH0OBI56Z9QdtCfy8MJPLa7yhkDXewD4UHuzcelIuDc5bQOhFmqPbXOkJ06qTLCtEwGPZgQFzuDJ3XnaoKHUIrDTpkkdA8P9nLKdYaTpl6AFQXHX0ycb5DCD1YBbnbEif5SNS1TUV13GFvXeFj7MpN4zkrsvg7Y8zmr9GQZ6VDqu+T86zQ1ecvTiiJkLh9lLUJYlNp8n7jve2C7rpPJvWWhlR2GJn6vfOUBmt2+zWxolbdTqOxRmd8SkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6YoJv6rRp3RlmGbZw2r2vkxab503jQb52Qe1oPkOv5M=;
 b=pOW/Mo1FVYXAwmr3//G4+y+xtMOhc18jmpoEtRSeGqXiRcvUW4wv2M4nzm43coNlta037Fo4RqGk04+FZXMZyH7HuR3f5nSPnm2JERBXx3P1PEduWI3zkOfkNO3xKtGKZkRY3LNo/9c4bWtp3M37YDw0SdkufMIkh7ojKwqytlfa6O2tlccIQw4doanqYXdTaSC2g3dojQ6s8/zT7A4WjnvVGPf1s9JgRGq4xNfr89l613wvnlHbdRyJ/zB4mwUCvctMdyiiW9yQnhR7lhb3px3UPtGQBvbW8csullUhEafMqIAVpOLEC0b7/4TZ+VkpBJKpLVR5EYHZiOQg+s0R2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YoJv6rRp3RlmGbZw2r2vkxab503jQb52Qe1oPkOv5M=;
 b=LSeHkVfHsLM4obgJn03jy4/RUFk1/dtzLiRXIFvJT/c9lwAF+W6SLdkuLYD9IT2aH3FvhzntlKmEBADZfwe+eq1q0869RWwL+Kxqw/J9jc8t2/mDKoUt3n+VxLp5tXzWWRN7ClN07q2hp6N5JdFnluJ8cEyS2CEl248ow114Pd8=
Received: from CH2PR15CA0023.namprd15.prod.outlook.com (2603:10b6:610:51::33)
 by SJ0PR12MB5661.namprd12.prod.outlook.com (2603:10b6:a03:422::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.19; Mon, 30 Dec
 2024 20:37:32 +0000
Received: from CH3PEPF00000013.namprd21.prod.outlook.com
 (2603:10b6:610:51:cafe::7a) by CH2PR15CA0023.outlook.office365.com
 (2603:10b6:610:51::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.16 via Frontend Transport; Mon,
 30 Dec 2024 20:37:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000013.mail.protection.outlook.com (10.167.244.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.0 via Frontend Transport; Mon, 30 Dec 2024 20:37:31 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 30 Dec
 2024 14:37:30 -0600
From: Melody Wang <huibo.wang@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Dhaval Giani <dhaval.giani@amd.com>, Melody Wang <huibo.wang@amd.com>
Subject: [PATCH v4 2/2] KVM: SVM: Provide helpers to set the error code
Date: Mon, 30 Dec 2024 20:36:40 +0000
Message-ID: <78dee5850404a2db1bf5b4ec611c286cc5bd6df6.1735590556.git.huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1735590556.git.huibo.wang@amd.com>
References: <cover.1735590556.git.huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000013:EE_|SJ0PR12MB5661:EE_
X-MS-Office365-Filtering-Correlation-Id: 0019ded1-c212-4e45-55e3-08dd2911c8cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ue6hhOxItfaWZ9OP8bb4Br/2KuCuyr8xqUmG8ZfS85OGbWiVDp8r+Jrhqkz6?=
 =?us-ascii?Q?IXOChT/4gAfqCeCLWbNeERvlZ4Rof+q9jgcCvSoB4rBSh441FKeKZyHo9EV8?=
 =?us-ascii?Q?dhWCqXyXkk+CCzE7RhIP3RN41qL5WVvIxnnEgIA+jVNUeCPQISwD0KrUvDWi?=
 =?us-ascii?Q?p+/qObrtml2F6jVlvxmzQlMsHO9MTqEgfonCoCkmfsKSKOtmzdvU+cgvnzP7?=
 =?us-ascii?Q?Bf86SO8iahV/7rgOvv6XYISKxfLZQ5NwMp3jzCZH1pn0m/RwiLlqR1oAjXme?=
 =?us-ascii?Q?CxaUI2VL3+UG1XdAH8Bvis4K29nMp5kgUeiEU2SZ3i6JL8MwYprUhacyRKZJ?=
 =?us-ascii?Q?eBnY7lst60w2Un2KrHl2Msl4kutKBisYxWcDuPJQ9/6T60G9VW3j9+53f2Xu?=
 =?us-ascii?Q?XMrb/u2tgDWuuhFZJWwpfZk2Sx9XhY2cN0/AHKk4XNFG7ydqaNjqQY8wNw8y?=
 =?us-ascii?Q?Xljf0vdXohVLZRQWGudLgrL6xOSYHMwU5t5vljczdSXwiYM0N18luFx8eI2f?=
 =?us-ascii?Q?K+/kmn7eOYFD8VxcT6wUvbaWwRk1lFTkHYwBtOPBGSqCfiVglkRcGNUVMWJZ?=
 =?us-ascii?Q?tBlkPQbZPGgm6icXS6GXa+5PbPViP/Ud0F2BO5hhPGy4AXHQ/uvrrBHVAjBg?=
 =?us-ascii?Q?SK9pJy/KuGgenfnp+n1gyVJ1uGTx0IFIZ2XI3Qs0auv3gWmoW81aeDg/Jtb8?=
 =?us-ascii?Q?0snccjkg58Z2fOdWcsPdCxmA6gU3qumJDrUIThC37JDSB0He59s/f4lYq+Ql?=
 =?us-ascii?Q?gPtS+oDLAXvKOUWcnhRCUCEeJ1Gmk8KXhXPMpielqMcRjRj9Rqe41ytRl89B?=
 =?us-ascii?Q?jPUYne4jpmjCVOMdKwo+bQCmLisYtNgavJT2223zRWVQ1NMGKwMShydR/98v?=
 =?us-ascii?Q?I8A4GMw476mb9U90dMu8BButkJOa+KFe9k4UXYvL11/GXEAvV8/DV7l2KQaY?=
 =?us-ascii?Q?YS8mKLC+e8YRM/1MUBmuf9d7Dt7i+/G93pL5Of4hC4jkus0hiP9aQHQ136+y?=
 =?us-ascii?Q?R03tkq36twuKzd18D7r3fItJLphiPk7qRNAqWuwXoI7OHb2lGQc8mC0uC8Jb?=
 =?us-ascii?Q?WjbwYd2NHNNWnLTqcD9kC/OWriJN4NDLdpu/ZqyG8szRrm/xGG5tK+F5EdIl?=
 =?us-ascii?Q?kY4KwUY8O1PyAJZO9VQrJ2UeG8/zAI+RsejnVOSceaizNCjDAGW0ux9Z1ZfF?=
 =?us-ascii?Q?Gp2/V/3ZkGOLeE27xsFmD05f5/8iqTB2J6lcX5Fd08K5izXeZB0fTlQBZ6JU?=
 =?us-ascii?Q?6hI1d0ZpZT3ehoDWVfPE1LwMdoNKuRVYUSJAoPIncmZB5xJdt0EC5RywhmoN?=
 =?us-ascii?Q?1ExEHByb46qnYurtWk38Z3GEUzaKGts5CkXC2C3cu3/59tRkLMoZQSg6afK3?=
 =?us-ascii?Q?EXFFhwNnMbjChyp2EGFvKBV4ZMxmAJWfb+1Bc3MFGBVUhLU2Cnss75jUOvD7?=
 =?us-ascii?Q?2Ec2WqGlzUGP/T8QFFgo1lFvomI9hpL7YZhDs7jTBOcoJBmjL5YQSONqGknR?=
 =?us-ascii?Q?wicMOsTDk0lzjZM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2024 20:37:31.5714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0019ded1-c212-4e45-55e3-08dd2911c8cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000013.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5661

Provide helpers to set the error code when converting VMGEXIT SW_EXITINFO1 and
SW_EXITINFO2 codes from plain numbers to proper defines. Add comments for
better code readability.

No functionality changed.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 arch/x86/kvm/svm/sev.c | 36 +++++++++++++++++++-----------------
 arch/x86/kvm/svm/svm.c |  6 +-----
 arch/x86/kvm/svm/svm.h | 29 +++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 59a0d8292f87..6e2a0f0b4753 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3420,8 +3420,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		dump_ghcb(svm);
 	}
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, reason);
+	svm_vmgexit_bad_input(svm, reason);
 
 	/* Resume the guest to "return" the error code. */
 	return 1;
@@ -3564,8 +3563,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	return 0;
 
 e_scratch:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
+	svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_SCRATCH_AREA);
 
 	return 1;
 }
@@ -3658,7 +3656,14 @@ static void snp_complete_psc(struct vcpu_svm *svm, u64 psc_ret)
 	svm->sev_es.psc_inflight = 0;
 	svm->sev_es.psc_idx = 0;
 	svm->sev_es.psc_2m = false;
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
+
+	/*
+	 * A value of zero in SW_EXITINFO1 does not guarantee that
+	 * all operations have completed or completed successfully.
+	 * PSC requests always get a "no action" response, with a
+	 * PSC-specific return code in SW_EXITINFO2.
+	 */
+	svm_vmgexit_no_action(svm, psc_ret);
 }
 
 static void __snp_complete_one_psc(struct vcpu_svm *svm)
@@ -4055,7 +4060,7 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 		goto out_unlock;
 	}
 
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(0, fw_err));
+	svm_vmgexit_no_action(svm, SNP_GUEST_ERR(0, fw_err));
 
 	ret = 1; /* resume guest */
 
@@ -4111,8 +4116,7 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
 
 request_invalid:
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+	svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
 	return 1; /* resume guest */
 }
 
@@ -4304,8 +4308,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_NO_ACTION);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 0);
+	svm_vmgexit_success(svm, 0);
 
 	exit_code = kvm_ghcb_get_sw_exit_code(control);
 	switch (exit_code) {
@@ -4349,20 +4352,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			break;
 		case 1:
 			/* Get AP jump table address */
-			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, sev->ap_jump_table);
+			svm_vmgexit_success(svm, sev->ap_jump_table);
 			break;
 		default:
 			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
 			       control->exit_info_1);
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+			svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
 		}
 
 		ret = 1;
 		break;
 	}
 	case SVM_VMGEXIT_HV_FEATURES:
-		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_HV_FT_SUPPORTED);
+		/* Get hypervisor supported features */
+		svm_vmgexit_success(svm, GHCB_HV_FT_SUPPORTED);
 
 		ret = 1;
 		break;
@@ -4384,8 +4387,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	case SVM_VMGEXIT_AP_CREATION:
 		ret = sev_snp_ap_creation(svm);
 		if (ret) {
-			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
-			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+			svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
 		}
 
 		ret = 1;
@@ -4622,7 +4624,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		 * Return from an AP Reset Hold VMGEXIT, where the guest will
 		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
 		 */
-		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		svm_vmgexit_success(svm, 1);
 		break;
 	case AP_RESET_HOLD_MSR_PROTO:
 		/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0de2bf132056..f8c5c78b917e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2977,11 +2977,7 @@ static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->sev_es.ghcb))
 		return kvm_complete_insn_gp(vcpu, err);
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_ISSUE_EXCEPTION);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
-				X86_TRAP_GP |
-				SVM_EVTINJ_TYPE_EXEPT |
-				SVM_EVTINJ_VALID);
+	svm_vmgexit_inject_exception(svm, X86_TRAP_GP);
 	return 1;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 43fa6a16eb19..78c8b5fb2bdc 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -588,6 +588,35 @@ static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
 		return false;
 }
 
+static inline void svm_vmgexit_set_return_code(struct vcpu_svm *svm,
+						u64 response, u64 data)
+{
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, response);
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, data);
+}
+
+static inline void svm_vmgexit_inject_exception(struct vcpu_svm *svm, u8 vector)
+{
+	u64 data = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT | vector;
+
+	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_ISSUE_EXCEPTION, data);
+}
+
+static inline void svm_vmgexit_bad_input(struct vcpu_svm *svm, u64 suberror)
+{
+	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_MALFORMED_INPUT, suberror);
+}
+
+static inline void svm_vmgexit_success(struct vcpu_svm *svm, u64 data)
+{
+	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_NO_ACTION, data);
+}
+
+static inline void svm_vmgexit_no_action(struct vcpu_svm *svm, u64 data)
+{
+	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_NO_ACTION, data);
+}
+
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-- 
2.34.1



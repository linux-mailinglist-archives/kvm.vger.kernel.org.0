Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C042464D0F2
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiLNURY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiLNUQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:16:34 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBB546650;
        Wed, 14 Dec 2022 12:06:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZikPoEYQaT3G8092RXf3lGvElWf4UHfSd1tYb4+dpvaAHpJsSQjeZFD+o0mHInB/zfPIWlynSfCraDYvTlLugvVVHE7LoacxoyDKKOCIZE3FxoCGz943bONFEmpcTXsf1LEZhJoS0hMlrlzpVLjjKAJj5EVWz9Lk1nudsLXMl2p9I0kcPRu4vqljGUcrD95PypF6e+rOM/FzgW2FU32R5esIHtO73881MUZLP2U5A1pnGPB4pGx/mMcKLf8B7a60m6l5/ObcZf8Uno1SHz8+VIzFDtHCnIHG3AuoLxINKSbi+xDrZ0YyD0fZf/HEWeUNqDz8kXUADxL7LR+j+iWnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UfBSbTttNEq3CmS6i/IUU8habEU1ekDUawFULn11fY=;
 b=W+V+HfoaAXLzA4F0qckRgnTdMxcjoOLb2Iwo90yaxy3b4Is7koY1IPiWvYyQZJgFQcI0wWb3C7m9EOCUkuxRBGqgD+wJd7DZJgwjMKKD+2G3ZAGVF/gBLJnvPDF5NXpM8dq/vsICwr64eWaMc5SSKNw/1+lznlj8YZ5V1rW465+X3Nk6XtaEJcaJ4AgeG8jQv9JetmthjZLukhGG3nZk/HYtAsWL7Qj73SQQqpMzDrcE1o4OpdMy003iam2+WCb4K03yBVOuLm+SmGP+gdMxv01r9ClQJMfV1tO3UQSfDUvUSYuPe961KkyvXZTy4eq1ZXux0dSvxX7d8vfsWt3utA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UfBSbTttNEq3CmS6i/IUU8habEU1ekDUawFULn11fY=;
 b=dNVKq2Td6H9UYRntQVRyMGpBzrH74Twm6PYPP36TCTeo4533heOCihLJuV3bfc9u8X5tvTd/XM/d7nKLFBdnkBKtA04it7feEykPbGknbyBVgHQZVg+DT/hu0m0Y2A3NrIQhUB7RiuvpfR1/EqZE888HeJ93W2eMECtW6T1R2PY=
Received: from MW3PR05CA0019.namprd05.prod.outlook.com (2603:10b6:303:2b::24)
 by MN2PR12MB4272.namprd12.prod.outlook.com (2603:10b6:208:1de::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:06:22 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::58) by MW3PR05CA0019.outlook.office365.com
 (2603:10b6:303:2b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.5 via Frontend
 Transport; Wed, 14 Dec 2022 20:06:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:06:21 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:06:19 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: [PATCH RFC v7 60/64] KVM: SVM: Sync the GHCB scratch buffer using already mapped ghcb
Date:   Wed, 14 Dec 2022 13:40:52 -0600
Message-ID: <20221214194056.161492-61-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT016:EE_|MN2PR12MB4272:EE_
X-MS-Office365-Filtering-Correlation-Id: 08bbcafc-89c7-4ff1-6afc-08dade0eabd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EtlAn/Lfv6MzDLaW04qs5PfR1NaqneupPNeKRbY86wDfn6eGAh0WqEqxYYt5fQh6u13+Q0rTSD4EuAFDi+R/uDTfnm4qaEwHSn6dTXNT8pIGeSMhEsSzDgyhefKYEsZLQB8/nMszR50JOGB1bY1iCRPd6nEyMajfYA9GmSz0Oxa8wSIhE/cBakOMO6UtRoWS9FOBzB9QTDOF5OuJE2fxZoym1MmFCtpPGfbnrTEc46Rx1DvhidkrifzpsfwUnKeqk048tllTjVHeaf3DzM/1FZVcGhbqYf52dDi7aS9K8zYjjsyCBnGf2FZol0pXg76s/txj41evtxEa0sYLh0Sc04BqklPSF2Uq4iMRKj+xcWtNfjrMFGL3jRpanQK+tcWCAwdWPRKiGfcaUUEx4aziEP3rb1FIl12bt6P8ztj5QVXcIrkcIRamNRapBgmQXeL7aHdngZIt0CRX5SA6d2w1CpQn49XegV0xFcgi5QrpOvX24kz4iJ3Br4Rsc6Qn3c9A0UqnHOBpmCzcbXrm/Jm/VciPObRBVoE/gu6eLnaGoFuxHHbi+e3L0nbWj1FPuT8sHS85XSgeGG/q+VezSpLHjBSx/szYzMfK+7y5eK+tQRU6jDIvXPCjFpL8SIHPWPToxcX+Ljvq1mhrm5LTMtZmBKj2umH8XJyjzoTfECEiGHM6wrVTbtEJ329Hl1sWGD3Zyy+jhlBIkvmqc3/ZP4W4vwits4UD/53RzpF/VZuBLDY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(83380400001)(36756003)(40460700003)(40480700001)(478600001)(86362001)(47076005)(81166007)(82740400003)(26005)(36860700001)(6666004)(356005)(16526019)(186003)(1076003)(336012)(4326008)(2616005)(426003)(44832011)(8676002)(70586007)(7416002)(2906002)(5660300002)(54906003)(6916009)(41300700001)(8936002)(316002)(82310400005)(7406005)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:06:21.8361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08bbcafc-89c7-4ff1-6afc-08dade0eabd4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4272
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Using kvm_write_guest() to sync the GHCB scratch buffer can fail
due to host mapping being 2M, but RMP being 4K. The page fault handling
in do_user_addr_fault() fails to split the 2M page to handle RMP fault due
to it being called here in a non-preemptible context. Instead use
the already kernel mapped ghcb to sync the scratch buffer when the
scratch buffer is contained within the GHCB.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 29 +++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.h |  2 ++
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b0f25ced7bcf..4de952d1d446 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3036,6 +3036,24 @@ static bool sev_es_sync_to_ghcb(struct vcpu_svm *svm)
 	ghcb_set_sw_exit_info_1(ghcb, svm->sev_es.ghcb_sw_exit_info_1);
 	ghcb_set_sw_exit_info_2(ghcb, svm->sev_es.ghcb_sw_exit_info_2);
 
+	/* Sync the scratch buffer area. */
+	if (svm->sev_es.ghcb_sa_sync) {
+		if (svm->sev_es.ghcb_sa_contained) {
+			memcpy(ghcb->shared_buffer + svm->sev_es.ghcb_sa_offset,
+			       svm->sev_es.ghcb_sa, svm->sev_es.ghcb_sa_len);
+		} else {
+			int ret;
+
+			ret = kvm_write_guest(svm->vcpu.kvm,
+					      svm->sev_es.ghcb_sa_gpa,
+					      svm->sev_es.ghcb_sa, svm->sev_es.ghcb_sa_len);
+			if (ret)
+				pr_warn_ratelimited("unmap_ghcb: kvm_write_guest failed while syncing scratch area, gpa: %llx, ret: %d\n",
+						    svm->sev_es.ghcb_sa_gpa, ret);
+		}
+		svm->sev_es.ghcb_sa_sync = false;
+	}
+
 	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, ghcb);
 
 	svm_unmap_ghcb(svm, &map);
@@ -3248,14 +3266,6 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 	if (!svm->sev_es.ghcb_in_use)
 		return;
 
-	 /* Sync the scratch buffer area. */
-	if (svm->sev_es.ghcb_sa_sync) {
-		kvm_write_guest(svm->vcpu.kvm,
-				svm->sev_es.ghcb_sa_gpa,
-				svm->sev_es.ghcb_sa, svm->sev_es.ghcb_sa_len);
-		svm->sev_es.ghcb_sa_sync = false;
-	}
-
 	sev_es_sync_to_ghcb(svm);
 
 	svm->sev_es.ghcb_in_use = false;
@@ -3321,6 +3331,8 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			       scratch_gpa_beg, scratch_gpa_end);
 			goto e_scratch;
 		}
+		svm->sev_es.ghcb_sa_contained = true;
+		svm->sev_es.ghcb_sa_offset = scratch_gpa_beg - ghcb_scratch_beg;
 	} else {
 		/*
 		 * The guest memory must be read into a kernel buffer, so
@@ -3331,6 +3343,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			       len, GHCB_SCRATCH_AREA_LIMIT);
 			goto e_scratch;
 		}
+		svm->sev_es.ghcb_sa_contained = false;
 	}
 
 	if (svm->sev_es.ghcb_sa_alloc_len < len) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4692ada13f02..38aa579f6f70 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -217,6 +217,8 @@ struct vcpu_sev_es_state {
 	u64 ghcb_sa_gpa;
 	u32 ghcb_sa_alloc_len;
 	bool ghcb_sa_sync;
+	bool ghcb_sa_contained;
+	u32 ghcb_sa_offset;
 
 	/*
 	 * SEV-ES support to hold the sw_exit_info return values to be
-- 
2.25.1


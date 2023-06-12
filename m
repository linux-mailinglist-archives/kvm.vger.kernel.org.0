Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B8072B6C7
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbjFLEqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbjFLEpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:45:23 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20621.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::621])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B3E171B;
        Sun, 11 Jun 2023 21:44:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nKaPZ7aEC2jAlLLPmgR+fbjpfjmlpCX/egPf7OZMIX4kw31xOJgtkGlAwddWSbvxNKbcVHahsdP43jI188X/Q9fTckIvO0VspYqm1UoiJUFfOwuZhciHwV/QVic8pqvLkx1nPpp1pgtpd+iK9mfDpJcMVu/pTI3w1eycFe2MRY7KezNWVjxtyK7hnu5bzxJeimllUiy3SB25C3UIRh+8aPYy+prQMei9CcSN8vqyWyuOgBdvgcU9w6OP7bqO/Ov1p01iSif8GFWPRTy6oI068clpeXm0od6ERbosrjmqauqqc2sxBP51iChPekCmnHvlvBLyXaaPaUySPs29e6yuUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dGa3k8AqLLW1tjtn3WwuRM7764enwizu98BPdPH3+7E=;
 b=Rrv1aR+LqM+8MfM67HNHDMUDtYSUeT3doTEpcAfQ4DtBb1s7sRWvZxC72nBMC8fIFU+0ccTCKfxwwRqzgRQg9nF2dPsOHKasu0aZeuWjXkWMmeAVcxXEdJFvNviToOMAHVlDrtumbwHUgpqx919/9TVBXkk7IRoI5Pd0BaOpd0ZiPml0fhLfcxqzlH4ytsrFzWjxL2e8mfsLt5HeCy8fps5xMCa4CDZRB2rvhlA0AuWlM+6Q8rikMG2w7PI9BPq1e7TFSxLPXPWSBEvxgTWa2akp/xfAyZi9H+zCPugtVxQD+rtqXNLneERf64t9Cc8dmAmndUGCLHS47I7y9kYIgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGa3k8AqLLW1tjtn3WwuRM7764enwizu98BPdPH3+7E=;
 b=jTlHICZQsVSzwXB4VGld5ziBwiQpm+spu7W8hU9v21MqeFPT+hOhWl3azHL68az39CIPXPPwVqvyez4jl5L0DFSPUCuYW4fGuHA1svMWlkgiU21rULNIXQXAp3vsvBj6k1VAR/bzT/gwsZx73jLMZKFfoGKC0FyQigg88l3Zdhg=
Received: from DM6PR13CA0068.namprd13.prod.outlook.com (2603:10b6:5:134::45)
 by SA1PR12MB8120.namprd12.prod.outlook.com (2603:10b6:806:331::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 04:44:43 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::dd) by DM6PR13CA0068.outlook.office365.com
 (2603:10b6:5:134::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.21 via Frontend
 Transport; Mon, 12 Jun 2023 04:44:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.29 via Frontend Transport; Mon, 12 Jun 2023 04:44:43 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:44:42 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v9 37/51] KVM: SVM: Add support to handle Page State Change VMGEXIT
Date:   Sun, 11 Jun 2023 23:25:45 -0500
Message-ID: <20230612042559.375660-38-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT012:EE_|SA1PR12MB8120:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a03cd3d-401c-4a77-a599-08db6affbda7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xcB6CwXrHsHJ1KLRi1+GIz3PgRuuOCmHjWLwGIQfSvedys5FVRUjiXor8ghIJR2dmyc58lHkNg5jTMdEBwMebyAiOlkvI0N2HSUd9xMfVu8W8XnUtNhkNgiqvhCjDMm5lGNeoMRh0CXIabBybwvm016jTrtkSD67EnMSlnp/Pm22nGCowaFts0t+ytVdRi1zamnD6pLs51aWiYWSGC7ZupGxMBU+QcUuSAuUhYPcAdHs8K2O3AOvoWT72PsSMw51XegVsxdijOJMZutGgFYZcNvs79teq0o6CoTAaH/du6xomzNQ+IJLrGDBG6o2jCUbV20tSgL8md3VTWybsRbiyNS/1FiZTBEEawGGyS/SVnUczOV8B047BSw/d+nmCJuIA90qK2K/mMTMPYgOtuXn/tQTJr1SmSl9EQHv3dMHjTEDqlTRa9HC96yT16s6zAhCi4GCBAD6txPistJOZvhq0GJDFS+dylcXISAseEluWn277Cha1O42g5T8kO+Qz+9sr8LgjFL7jUxL7fp6QCytPFEu3+RtbHFewl5ydrr4hVa5qnW4equTmCJSuSRZgCSPho36oGjn6paw2fPuCvE8+8YlNq45EEfQWUyBHdNr1W6/1Sb19Nu9HkR+8axZgJeT7VYh4DWzp2c6ezU6h5K+paoo9WxW7ikpl4pS2t2y+ujejTNsx2zX66IVxIRWQGosY6UGC0FYEEzrHZOJAtMDsSJutCBCP3ALSC1lemSmOTCmBcTQoEs0rAXH+LRrOYvc/yNvzLa9iLVylSIQIp0byw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(66899021)(1076003)(26005)(16526019)(40480700001)(186003)(5660300002)(41300700001)(426003)(82310400005)(36756003)(47076005)(36860700001)(7406005)(7416002)(44832011)(70586007)(4326008)(70206006)(8936002)(83380400001)(336012)(478600001)(8676002)(2616005)(54906003)(2906002)(86362001)(6916009)(356005)(316002)(81166007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:44:43.3361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a03cd3d-401c-4a77-a599-08db6affbda7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8120
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change NAE event
as defined in the GHCB specification version 2.

Forward these requests to userspace as KVM_EXIT_VMGEXITs, similar to how
it is done for requests that don't use a GHCB page.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2afc59b86b91..9b9dff7728c8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3039,6 +3039,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
+	case SVM_VMGEXIT_PSC:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3242,6 +3243,15 @@ static int snp_complete_psc_msr_protocol(struct kvm_vcpu *vcpu)
 	return 1; /* resume */
 }
 
+static int snp_complete_psc(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, vcpu->run->vmgexit.ret);
+
+	return 1; /* resume */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3485,6 +3495,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_PSC:
+		/* Let userspace handling allocating/deallocating backing pages. */
+		vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
+		vcpu->run->vmgexit.ghcb_msr = ghcb_gpa;
+		vcpu->arch.complete_userspace_io = snp_complete_psc;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C9C7CA9E6
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbjJPNlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbjJPNkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:40:37 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2050.outbound.protection.outlook.com [40.107.100.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD45D63;
        Mon, 16 Oct 2023 06:40:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+jYcA+pn2G17xiz2r4hu/jjEFmyAlxm/BlXSqkguWhTuEJ5fplC1zOCLBb8IXv4otBDbMrVcYwQ2pmqr1seBUVgVAkOnhPPgfdtFDhFD4btx6zHCTcoYlHmTMazWYOVPmemKK0BjOe9+Skhd3rD+SB5xxX7qvf+47s6O5faLW9xekfaUgWG17itDfGVz785CzkvgcKSDgk6ZYg7EpY8bFa559jS/KWRSvAMAzPytzcjm2ZToaxaM+JdShEUXGX8zdNDirV99En0yGmLn2zYyhv04QxS9Mfjl/korLlT5m56sJmJBiORA43ry4gPSbuhx8jg7eTTFMhyWjYMWurI8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUa4LLN/5rx18Dya9AF6PZolJHOKQF5UHzcW/KaErq4=;
 b=G+o7I4gbtVSkFXPzivo6NWDgWsTCFbcEmnnEg8QWK/26pGE4c49QIZBWRBMEqkzcZvM/2Qc+7hL37Jkd4N2fbWDg1fYBRv6SVpjZsbQZd/XQWkoXRRJoazkP8rXxvDGIW7f7hEwyNXK1P2GGb12sFuc1fxw5mEXnXKsIJ1P8liyduHWvnj75BI/6CV15vTYt/FdDsbPcvDxxWFwj7EkJaLnDHw34IyLbPDynesmUs3NLDd8rlGhpVZQp7f2mEIyvtSAiL7m5Fr9AJm6FiQplcmU/nAkDkg7QyaSSjbCvE4kVumzQ5ruqBIpJWvsbgIjjbKIO+B/QHftdNhzVPNi1iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUa4LLN/5rx18Dya9AF6PZolJHOKQF5UHzcW/KaErq4=;
 b=uq9xBeFqA/3ZAO+/jRiI4TgjSpIO1VoBn+3D2+/GlNZKHZJglpO3w+WnquWGobCe7IDx9YLnHx1uc2dOh1KMrvVCh1HCKFBsEIBR+WTQI2l/b/sUI5vjigLcLDtam4tQFYY4NLq2zAC26exzn5ZHCjPkfTZBCEiC4TobsMkmqng=
Received: from MN2PR22CA0009.namprd22.prod.outlook.com (2603:10b6:208:238::14)
 by BL1PR12MB5063.namprd12.prod.outlook.com (2603:10b6:208:31a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:40:28 +0000
Received: from BL02EPF0001A0FD.namprd03.prod.outlook.com
 (2603:10b6:208:238:cafe::86) by MN2PR22CA0009.outlook.office365.com
 (2603:10b6:208:238::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36 via Frontend
 Transport; Mon, 16 Oct 2023 13:40:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FD.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:40:28 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:40:26 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 33/50] KVM: SEV: Add support to handle Page State Change VMGEXIT
Date:   Mon, 16 Oct 2023 08:28:02 -0500
Message-ID: <20231016132819.1002933-34-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FD:EE_|BL1PR12MB5063:EE_
X-MS-Office365-Filtering-Correlation-Id: ebab6e9f-3d80-4c8c-353a-08dbce4d7591
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uWM/sit0AX4lrdxh6e5divQtzSDR0AmcQ2infXvZ5YoA7PlPMCQyxY1RWZshW9CqKnYtal1b1mI9JI8/VLgebEHpczat1BknGjRlHmwU9YcRMpIgXu1aKuWEKxN4R/HPBuAJXw+GAeYDR87P7q5KGM4YqCLnpeyaKlCZC9UBhi0GvqRYtY14APvUX4X/I40hcHKW1g715nwltJfylKTumBj7K3/AvF+Kel40UWNZ49u7SyExpJZQM1ZZizwaVFFatgz8Lvy2qwOcqIMGCpcSLIBtqAVX2ZxtR3aU0suuWsxcSjSdOqIZwrk4NUL30SyY0GSeS9SiOLdod+VCFe+YZoEw0Kss4A7t4Bd2EjQhE/OQPaoKPHIREzWV3wmdFXiWwtyZ07jOZtCQyKuIMQIRsoG7PcSy3GxEACj7T00Z7joPBcVEB691NK/+6YOsayMZcZcofpBrJ1plPX7iVLqv/G9B9CiQEcmhBNaJUG7aMoCJBQCqcUVXWIQ6z81MiMzGvQORKp9beWV+SaWMvoKS/KD1QyxGbg7s2BZb4RSeJZ5TntpzA/RvsJ4Y0yMkV+rP+JxsH9sIPNwxF8LqnaGJvAjxXM0uA6E0mJYVTyllRWKtP2auqEQPPtZBCiagYfHkn81sfu8tF9PjZUgAZzAhXzs2JsDtDlz86PoVo69SAYJeee5qzJhxMX1efo1E4cLAFwMgx/00Rgt2XyYTihFLJ5FQIqEZwNtOFeiyi46YJ7Uvh+S72plAwuC4a+hamklafXcVw0PcN2oHpnqg6KAy+w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(136003)(346002)(396003)(230922051799003)(82310400011)(1800799009)(186009)(64100799003)(451199024)(40470700004)(46966006)(36840700001)(70206006)(70586007)(2616005)(6916009)(54906003)(478600001)(316002)(7406005)(426003)(1076003)(336012)(26005)(16526019)(5660300002)(8676002)(8936002)(4326008)(44832011)(2906002)(7416002)(41300700001)(86362001)(6666004)(36756003)(82740400003)(356005)(47076005)(83380400001)(36860700001)(81166007)(66899024)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:40:28.2686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebab6e9f-3d80-4c8c-353a-08dbce4d7591
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0001A0FD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5063
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index 4890e910e6e0..0287fadeae76 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3081,6 +3081,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
+	case SVM_VMGEXIT_PSC:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3278,6 +3279,15 @@ static int snp_complete_psc_msr_protocol(struct kvm_vcpu *vcpu)
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
@@ -3522,6 +3532,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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


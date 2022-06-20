Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08D45527F9
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346654AbiFTXOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347900AbiFTXOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:14:07 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC83625C7D;
        Mon, 20 Jun 2022 16:11:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3CkYMwJFrOPrQr29jyYUJHkVnpe6PRMw2y0tvze3H2ptpubnIThsJyPiU2mksAu2o1fBHH/GbobeVKboGcVfAxCZAejAyqi1YObR8oRPljDh9h9HI+vMcZZdeR2LC8d99UTjseRxp7DRggcQeW5DOC7c0nwAYk54xyzSOn1D1PML/VrMNbZoY4dlBx9xnEokLOBYX5wCb3AI1rWykM+GRGbBl0y4In758QEqm7xsIQotbIkuCHmyTOnfdfPxQSt5uYD3V7V4xGELoJUFTQeyOi1JxOFugiPmcWLeNi+AcQ1rTMHU36ml1fhPP1Dv+S+Da9d2fSXcIErmxbdKBBeog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y81EFZPX3JsRKz8tzrQyohWd7XE+z+BpdWr8BFEYYRE=;
 b=fa26X18HZotkjdthzKQ8kLjFvnTlvAlW9Ke4IFyY7Fy9ZTTGLUWSChluFVrrI84GGphpaP80syrFgxcomhPusviIOyTXlk8aaVA9Ub8Cfm0eeTLDHuNyP/6mx/HI0AUS1T+NkxIucSzre/GMDRwpXRVAtrksusgBUnPoDPDi2qenXx5V/j5Jq3US0hf87MAHdgPJ89BdykXj6QLHRnUgNC046YJrmEvrZsP9dad3JPxmZg2fwf8kuChKVVcOCG5mf24HC+7ocpuXZHWO7ozxUjXUR2vXxCuFVGfe6tFTTFOaqxZnz9if0jiLcb6mmNVFVTntgOMLu1rr3RbR/zA3ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y81EFZPX3JsRKz8tzrQyohWd7XE+z+BpdWr8BFEYYRE=;
 b=aJ68MCCHqFxPZAABhWIJPQ62hsKHbc0rKOUFGwE3LpXT69C6JTIzc82B6+PHCMxh50ajN8p2b+41LeWBI7kUPtYQFsfEdRep7FsX95oCEcYNI+z5Q7jj5UhcQTiRRhTe0OREH7zQ+H5SdINFOylSb7Bsym0VuaSR8KEf3H1L31s=
Received: from DM6PR06CA0083.namprd06.prod.outlook.com (2603:10b6:5:336::16)
 by BY5PR12MB4098.namprd12.prod.outlook.com (2603:10b6:a03:205::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.13; Mon, 20 Jun
 2022 23:11:55 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::a2) by DM6PR06CA0083.outlook.office365.com
 (2603:10b6:5:336::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.21 via Frontend
 Transport; Mon, 20 Jun 2022 23:11:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:11:55 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:11:52 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 38/49] KVM: SVM: Add support to handle Page State Change VMGEXIT
Date:   Mon, 20 Jun 2022 23:11:44 +0000
Message-ID: <2ca231b788a0de2d3ba4913963229fde2c8fad76.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acc9b1e5-9584-4127-b69d-08da531244b0
X-MS-TrafficTypeDiagnostic: BY5PR12MB4098:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4098815D2164428F186B70B48EB09@BY5PR12MB4098.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tFgVSlogAKDfS7cf51cVtSBrlBsbjWliWPss9TXlktKgjhkeIXKZAmGTAk9ZPelhrEy65Mms840RmI4K8A8DylCClGyNXXtE2U4Oamlfe5UGo3rUQTWJkWQIol0e1reWDuFwIBj1LdXZ1SIwOSWYhoZJJl2rbUY6FmI7EuDUCionaHCDZxp7DHemsGwOsFsodv5E2ngT6pINF2h5mwN3pOVL288KAxNDDHBvFx1Fk4nMu4eSQ7PhIcVPCNcjQiHP8PfPkaOND7aPpr+UP9STU2suYPMW/sDUz/xZY5wHmeMJtgf7Qyk139c6oTz/hIuTcrdhCC28RzgovkcF7CZQWULKITkqVidb4zw6AfFD7JszGb4Nuve1hRnMZGc7lh4HA/NDG0UVrIxleL2lyqfSPjnJzSn1YRuP88HGlHDLd+aHpc0SMdON2U7icHliROOP2XkbWjFxIlcLyCAK/ivBnvj7xjP5xN1tzENJ5GSQPqgNUo6gzy04uMeQXUGa/cLeF9P1b1lpdjsFPZidoJiNExK0iNjDs6T1ow8wEFfMgvPqgZeOUQ7ysj+gONhl8GifYCZtpQYnkP2SswA8Uog/2fDhBr1u8uKnDzy8v0MqbW4/tjIIdFQAWZ3AWADy+Q/9PJ0iIBactY/dqwtuhBUF6E4t00EfZsCnl1RLJGT5+JxExCpRTX3Y1Z2EZ0FnX5ZkQmNwjdxrGoxbGTf/+ciodOvRqP44L/MTnt2LWVx0Glu3IBXgQyqFtt/lClz/Kmi12lS3AVpoyXt0Jvx8B9/kfA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(346002)(376002)(396003)(40470700004)(46966006)(36840700001)(70586007)(70206006)(6666004)(2616005)(336012)(41300700001)(16526019)(82740400003)(426003)(4326008)(81166007)(83380400001)(36860700001)(40460700003)(8676002)(54906003)(2906002)(7416002)(82310400005)(356005)(110136005)(7406005)(36756003)(86362001)(26005)(478600001)(316002)(5660300002)(8936002)(186003)(40480700001)(7696005)(47076005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:11:55.2201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acc9b1e5-9584-4127-b69d-08da531244b0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4098
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change NAE event
as defined in the GHCB specification version 2.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h |  7 +++
 arch/x86/kvm/svm/sev.c            | 79 +++++++++++++++++++++++++++++--
 2 files changed, 81 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index ee38f7408470..1b111cde8c82 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -130,6 +130,13 @@ enum psc_op {
 /* SNP Page State Change NAE event */
 #define VMGEXIT_PSC_MAX_ENTRY		253
 
+/* The page state change hdr structure in not valid */
+#define PSC_INVALID_HDR			1
+/* The hdr.cur_entry or hdr.end_entry is not valid */
+#define PSC_INVALID_ENTRY		2
+/* Page state change encountered undefined error */
+#define PSC_UNDEF_ERR			3
+
 struct psc_hdr {
 	u16 cur_entry;
 	u16 end_entry;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 15900c2f30fc..cb2d1bbb862b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3066,6 +3066,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
+	case SVM_VMGEXIT_PSC:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3351,13 +3352,13 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
 		 */
 		rc = snp_check_and_build_npt(vcpu, gpa, level);
 		if (rc)
-			return -EINVAL;
+			return PSC_UNDEF_ERR;
 
 		if (op == SNP_PAGE_STATE_PRIVATE) {
 			hva_t hva;
 
 			if (snp_gpa_to_hva(kvm, gpa, &hva))
-				return -EINVAL;
+				return PSC_UNDEF_ERR;
 
 			/*
 			 * Verify that the hva range is registered. This enforcement is
@@ -3369,7 +3370,7 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
 			rc = is_hva_registered(kvm, hva, page_level_size(level));
 			mutex_unlock(&kvm->lock);
 			if (!rc)
-				return -EINVAL;
+				return PSC_UNDEF_ERR;
 
 			/*
 			 * Mark the userspace range unmerable before adding the pages
@@ -3379,7 +3380,7 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
 			rc = snp_mark_unmergable(kvm, hva, page_level_size(level));
 			mmap_write_unlock(kvm->mm);
 			if (rc)
-				return -EINVAL;
+				return PSC_UNDEF_ERR;
 		}
 
 		write_lock(&kvm->mmu_lock);
@@ -3410,7 +3411,7 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
 			rc = rmp_make_private(pfn, gpa, level, sev->asid, false);
 			break;
 		default:
-			rc = -EINVAL;
+			rc = PSC_INVALID_ENTRY;
 			break;
 		}
 
@@ -3428,6 +3429,65 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
 	return 0;
 }
 
+static inline unsigned long map_to_psc_vmgexit_code(int rc)
+{
+	switch (rc) {
+	case PSC_INVALID_HDR:
+		return ((1ul << 32) | 1);
+	case PSC_INVALID_ENTRY:
+		return ((1ul << 32) | 2);
+	case RMPUPDATE_FAIL_OVERLAP:
+		return ((3ul << 32) | 2);
+	default: return (4ul << 32);
+	}
+}
+
+static unsigned long snp_handle_page_state_change(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	int level, op, rc = PSC_UNDEF_ERR;
+	struct snp_psc_desc *info;
+	struct psc_entry *entry;
+	u16 cur, end;
+	gpa_t gpa;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return PSC_INVALID_HDR;
+
+	if (setup_vmgexit_scratch(svm, true, sizeof(*info))) {
+		pr_err("vmgexit: scratch area is not setup.\n");
+		return PSC_INVALID_HDR;
+	}
+
+	info = (struct snp_psc_desc *)svm->sev_es.ghcb_sa;
+	cur = info->hdr.cur_entry;
+	end = info->hdr.end_entry;
+
+	if (cur >= VMGEXIT_PSC_MAX_ENTRY ||
+	    end >= VMGEXIT_PSC_MAX_ENTRY || cur > end)
+		return PSC_INVALID_ENTRY;
+
+	for (; cur <= end; cur++) {
+		entry = &info->entries[cur];
+		gpa = gfn_to_gpa(entry->gfn);
+		level = RMP_TO_X86_PG_LEVEL(entry->pagesize);
+		op = entry->operation;
+
+		if (!IS_ALIGNED(gpa, page_level_size(level))) {
+			rc = PSC_INVALID_ENTRY;
+			goto out;
+		}
+
+		rc = __snp_handle_page_state_change(vcpu, op, gpa, level);
+		if (rc)
+			goto out;
+	}
+
+out:
+	info->hdr.cur_entry = cur;
+	return rc ? map_to_psc_vmgexit_code(rc) : 0;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3670,6 +3730,15 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_PSC: {
+		unsigned long rc;
+
+		ret = 1;
+
+		rc = snp_handle_page_state_change(svm);
+		svm_set_ghcb_sw_exit_info_2(vcpu, rc);
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.25.1


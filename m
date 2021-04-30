Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC6436FAB5
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhD3MnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:43:17 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:56928
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233014AbhD3Mlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:41:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GB1yxsPOkPxiWi9PRaXuIbViV1VqNj8FdRt7nPu1uM5BH9gk/AM0BBCteROv/rBNcoCB/tqUq/CvgxXuPEWKWiikbaHqwpz/pekcVx+PjZJZzMWU8NKSk52hclPQ6EbMr41EhGywBp9qJmgmWrOgrGHpxw7QuPTiZCZZNm7kiegoH9hO07J+7xwMHoyGJjelAOB9fXkpsK49rJ3ZpAeqdbzvONUUmMOi0fhBeWlM7nAgh0cMuZCW/daAx9IKPxi5iu1ZpuDy1DCCOZjWD960IO0E4/e14TjI24tfff2gLf0EKpcLS0gyLY4FFhJkkipPN7Ec0li81RefTRa7biuINw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZJ3je2wPxh/fQFSMVgcp3662puay8fC0jHWjiSZ3ZM=;
 b=FtNqg0rr5631RDoOUutWYOOiE4DOP78IWUycQEEiJtjywN+C+rBTGioP9cnmHhdvIPL2lgubPsxPVSf8vSwkkEWBSzdMf1S6Zd054sdKKpDlyaYhAxPVVpPN4UpubiVHi3hVZDkTO64ITv+8UXjBTgSJ8aqyxTfgtC+FtKCCm/oTsoPV1NgAolxS2c2/Z+qgYuaVRdGJJRHCBGc6z+7H5aUsyTo+XGoBX1LXcQa+97Y6VdjzsuPDq1u4c9epv0bshVBaANz5Pnl38B47WHS9wvSS6RaC1sn1Z6RiW2XUvzImc5W+neBF6IF7tjX3XfPSJGc2EDB0/3VPBeTCpTLAPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZJ3je2wPxh/fQFSMVgcp3662puay8fC0jHWjiSZ3ZM=;
 b=a9a8VLdpQOMHTMt4h1cS+yrtmxkzhtb8g7cGSjniu+BI8t9nU5D62cbEUiYnHVPhTthJSrnYB24dqcSgkHvutm1EOmaJk90Uu1FFoGcVC5/VOPoKuo5k/knf6X3mBr34i3OK0RXb3adiWlBw+cNvPWbq3G7I0qL9d9VOA0KDEzI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Fri, 30 Apr
 2021 12:39:48 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:47 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 33/37] KVM: SVM: Add support to handle Page State Change VMGEXIT
Date:   Fri, 30 Apr 2021 07:38:18 -0500
Message-Id: <20210430123822.13825-34-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f63ccc21-a4a1-4406-e556-08d90bd4f8ac
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26880E7F8C1E84D74F16543FE55E9@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x8tn9OFGzOt05bCYFXDOHWzz0YuFmAcX3T0K/l7b7MZEZbFNLz22K7L64ug2NjSNN15KQUbjD5lY7pLL3srKZpxaPvlt6dXtAp6MuhJ/5oKP0Bl3UfSQRyhq3mq4H1YNkSXjjkmW/a06VfUz6BheL10J6YyiwnDdCW5RajdldCiDK8ZY6Ii6LzjikDFDy4D45tMBwcFxJOPP7CGFoxWbvFfTZM2oSgTl/GFA95Gdj6oPsnrCKWHx9xg9FQ+RMYjdMMfZ2/AsEeu3wIqj79L//6QbvQLkrfHjhLFo166b73KwyM8IVEM4/kxKnl2tJ11KFt1gPV0xHxuQrC97hWzdJVYtYy2Y6+Bhf14BkjsmV2f5I3AscyD69DPVGxn277Z4UHLe0FbSdC6XgXVW3lomSKIGfyZNEwlvhg3AQWdo8Qbn4PdCxemsDbuHdf5YXvmWet/R9/rqpajHLVoa6iW6Xn2ni+PcFpPIvTwCxgWHreAko7dA1aFF+4HYhKOMaWXt4ygnbE14c8/yJ1MJR5OBAKM2mIM9UOawLAykQmSpugH1LcVGCKmOFDpqeHWh17w/Lcu0Q5Tk27eo6DLFPlNTbmk3c38LxYPTrZU/KBJ/XG1QxIPgaqC67u+GDW3KV8SQF+BX4nal+tX41VZqRdH19A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(26005)(8936002)(86362001)(478600001)(52116002)(8676002)(1076003)(66946007)(66556008)(2906002)(7696005)(83380400001)(36756003)(66476007)(44832011)(5660300002)(956004)(38350700002)(38100700002)(7416002)(2616005)(16526019)(186003)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Q1xwHglMZ6aPN/K3uTcWuaezBwk+pLXLgNwzrLGMjWZxkYJox3N9wF6C4o6c?=
 =?us-ascii?Q?yYgw9KVY3TTgMGSYG25VSQfpH5wYUn9mepxhfDIOBOuxJflkk/ecIEy3D0kr?=
 =?us-ascii?Q?np2qMLdRZwf7hJ1fiCyI4DUk3KSaF/2yURPq27HaJZ6YWo5qdn+aFoa1T79y?=
 =?us-ascii?Q?2naSlgpH3YZxixBdK0u7A3zIuaPxUWUqvdXsOQve6nNFQI0fNwVd2T3qW/D/?=
 =?us-ascii?Q?vvjGrihzZsXo+LMmTOtOfK3nn2h/1n83IUX9Cy+93UzKY9VyfHv8vm76ugeC?=
 =?us-ascii?Q?xykweH0npXDBf/6m8E4/sECv0zxPROCH2dP0twWEH1djM/+1ET7XNtU1TY81?=
 =?us-ascii?Q?7reG83YJcyPmW0v/PBm4QU0a6uHt9pV4Lc9M91tM22sF3ajkE7y6t8/IgtDQ?=
 =?us-ascii?Q?3ne6fjWy/1clwWygMPDcEUYJ7CFgSRje3yFQvHOkGnwJSclOQ4GCxkucPJCE?=
 =?us-ascii?Q?SnCSSHEr/Hp3nkfBm1dIvhBeoXxrkmtoYbk63tHKJ/JGtGH8u8diexXJ88Ct?=
 =?us-ascii?Q?WwXQ91UnmfRMYsQNJOoGyZ4wiNIvjOIP0y9i1VpzPBWdcnWrNNblfIeeiePX?=
 =?us-ascii?Q?Rfs5mSGcZHx5rNI7CcQJgfUAKtdcIBa/EHLBVPmzq0+9GI07l356iBXbuViF?=
 =?us-ascii?Q?jKqsG8BMW8AjY7HozxthyDH7yTtRl9xABj4D7eLU8ROOkl1SXCcUTsdUQ7VN?=
 =?us-ascii?Q?dl7F1RnFxZlxPrk2o1huh/XuyavVScYs4qrnJ3S9KWH3I7niVHn6B3EllPY5?=
 =?us-ascii?Q?qJbn6tuJoK+OQyrrZsj2qkTP+CH+K5UKasfhC5i3996yuSBMbMfXAcQCNlv5?=
 =?us-ascii?Q?9nO3b5T+feRYSfQhnbZrUNh3LlCqL27/FqFUYHo77yLcX0Akmhg71eQSpOzm?=
 =?us-ascii?Q?mGr1OJJjJvBBwRCp/BGByPC5H4zNVgkcFofS5a+weVMl3K5BwGf8OXxPYfjR?=
 =?us-ascii?Q?s0Um/eO2o7jqbEYnBBgMt/+In6SWi3rLcU+ClNQmU3wFntjWVaZ6hqB3qwPU?=
 =?us-ascii?Q?5Du0sSH5dwwciSopllLBZCbla52TEYG6cepjMP+rQNaB2HVaYQ9ejiVsyP0J?=
 =?us-ascii?Q?TsRn4NO9N28WmjuxI+MGUP1T2hhIRMKtcXQ1ar1FUg1zzoN/uvRZzJ2Iws9l?=
 =?us-ascii?Q?nSgFhaNXxNufK0JBZiyjKiOxce/r4fKIhh+KShksygWQaKcFuTZQozsyQyIT?=
 =?us-ascii?Q?mpH8iEZ3dCVXdGRTlScT8ooOeo8SSgV0yKh52GEpcV1F63bnRpXzC8NyCzMu?=
 =?us-ascii?Q?VLlVDHO2HmeNHMKVbCH0IhmefdLos39Ll/OJkKMV96oxQoeCaYxBL/6y3teo?=
 =?us-ascii?Q?p77znflt5+qDkMY4H9yL1fEo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f63ccc21-a4a1-4406-e556-08d90bd4f8ac
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:18.5117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b5TAikzR2LXg8kxeiyJ2tWm+09iD808UKYnTJEvs+RPjiQFxcyzMJSY+qKUtEmUCwQ/+9/5INPZh9kJUbxyOug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change NAE event
as defined in the GHCB specification section 4.1.6.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 58 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cc2628d8ef1b..bd71ece35597 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2641,6 +2641,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HYPERVISOR_FEATURES:
+	case SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE:
 		break;
 	default:
 		goto vmgexit_err;
@@ -2927,6 +2928,7 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, int op, gpa_t g
 		case SNP_PAGE_STATE_PRIVATE:
 			rc = snp_make_page_private(vcpu, gpa, pfn, level);
 			break;
+		/* TODO: Add USMASH and PSMASH support */
 		default:
 			rc = -EINVAL;
 			break;
@@ -2947,6 +2949,53 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, int op, gpa_t g
 	return rc;
 }
 
+static unsigned long snp_handle_page_state_change(struct vcpu_svm *svm, struct ghcb *ghcb)
+{
+	struct snp_page_state_entry *entry;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct snp_page_state_change *info;
+	unsigned long rc;
+	int level, op;
+	gpa_t gpa;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return -ENXIO;
+
+	if (!setup_vmgexit_scratch(svm, true, sizeof(ghcb->save.sw_scratch))) {
+		pr_err("vmgexit: scratch area is not setup.\n");
+		return -EINVAL;
+	}
+
+	info = (struct snp_page_state_change *)svm->ghcb_sa;
+	entry = &info->entry[info->header.cur_entry];
+
+	if ((info->header.cur_entry >= VMGEXIT_PSC_MAX_ENTRY) ||
+	    (info->header.end_entry >= VMGEXIT_PSC_MAX_ENTRY) ||
+	    (info->header.cur_entry > info->header.end_entry))
+		return VMGEXIT_PSC_INVALID_HEADER;
+
+	while (info->header.cur_entry <= info->header.end_entry) {
+		entry = &info->entry[info->header.cur_entry];
+		gpa = gfn_to_gpa(entry->gfn);
+		level = RMP_TO_X86_PG_LEVEL(entry->pagesize);
+		op = entry->operation;
+
+		if (!IS_ALIGNED(gpa, page_level_size(level))) {
+			rc = VMGEXIT_PSC_INVALID_ENTRY;
+			goto out;
+		}
+
+		rc = __snp_handle_page_state_change(vcpu, op, gpa, level);
+		if (rc)
+			goto out;
+
+		info->header.cur_entry++;
+	}
+
+out:
+	return rc;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3187,6 +3236,15 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE: {
+		unsigned long rc;
+
+		ret = 1;
+
+		rc = snp_handle_page_state_change(svm, ghcb);
+		ghcb_set_sw_exit_info_2(ghcb, rc);
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.17.1


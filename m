Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD9A347EC8
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237428AbhCXRGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:06:16 -0400
Received: from mail-dm6nam11on2061.outbound.protection.outlook.com ([40.107.223.61]:33120
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236994AbhCXRFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IkF7WI7yuPd6YC5dkwvcziaEnnRlpbf5Or+wtjY3aPJ/hRUJk2Vn6ihufnrAUfkuPXM7EBOvVTP3m5SZO4YglzU/tHPxWojpd32dny8CuIHivOeLNwhsYbbLsaPl7OyCfZG+Uqc9eqXPReksUrBXWphysbP0wdDNIsAWCnEKguZcyDBKRS9lVa1IpPXDA1LjDJVzh/MaJIPr5ZlRxaih9JwhOVK1PLqTGO9iZTaTioaGbvC9c0ifSzoAEfmE9Qc264sfHRf4a7EcLP4MM1ar++xA6ZJ93AZmecYT1xlcMm8UNwSewI1Cdc/R/AFAEWAnKJse79T0OJEoZoS+8jM4Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIECAcruEgVnm28ZA47pi51qvtvUNQB6wUDCQ0LIx6U=;
 b=oXNjH9j2jPCZDLRfeU6Gx/zs2MoCmxgYFsuBkVgV+buyZfP/r0pdJaI1nRmfJYmjwpvtdTQFnboNe1isHXfRf2wV6wee47rKp6//tuCeDPWRBNQJOauQ/B+D+HwXCWUu3/caOIb6bqbIJ+Z7QCvmMPWxi1K1BTDxo0ZWjqgmK3OTCv1dctEumKK38g1DiZ5vzlmzt3R+1o+jiieMjQReEk33YupTBSVf5Iqno6xvJ/+Zr9S3RUUQBVqh8IyR2Be9X9KTZVEJnUFQja0uEmBRHUz3L8hPc2tgV4otKJ4HfaNWrdcX4F9vEthYvWYg/FwA06iEYyEtjCOJsiVAyQUSaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIECAcruEgVnm28ZA47pi51qvtvUNQB6wUDCQ0LIx6U=;
 b=DSU6d1JXVOydq9s+nGn78/sFt5h2fENvphwx748LkATHKjTfIEd+2RlDVRfXuRNPnXcVMnb9jglO8+I1ljbM4VhxKmY2iSAT5D6AhONXyqeF38xelbJgqEsdFhur1/o5dd5oAOhw27Paj7efLmbEXL/4uTvft2p7GwOMFBUdnt0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:14 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:14 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [RFC Part2 PATCH 28/30] KVM: SVM: add support to handle Page State Change VMGEXIT
Date:   Wed, 24 Mar 2021 12:04:34 -0500
Message-Id: <20210324170436.31843-29-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3c15bc95-e9a0-414d-857a-08d8eee6fde6
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB438294DB0F241F687CA61B61E5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XkFmFRR5W7Fla82uirixMCgEwcEb6eLzhS0L2TH5OZFssAVo8PYJ+Bg/V6y+rHg2r4rPk9w5FOGiKx2UAqBaB5wgDYxLx7tWu//yLAb6WQDKpDAZRdQcalcc4HBcQQgEjNTPAtbhJJSUnPOw5gCW8TAhAR5Sg+3aff+rKGgQe2cUPRTlbqTCohQv6M2PwcVfldYQIvlpHsBwFskFObnrRX82z+BIiFQnrbuq8qGlUMd+N3R+93eqgoRVGMmSURKmafdT6U74MZubKy5XvyfmwZsq2zPor4wQlG6IBaZ3CxojVltobwOwc86sdHb7PEz9YI1QTUiU6ZXlLA8ykDjyPRe/346jDUfEdzjLvGNimcw28LBImiWcNlyxz9udVxNPyXaBYlhTbnftsszBkgUR0e6PP7zy/4ri2BI98Rkzjwi9i8dAs2fL2bwCDnWgTgHntSOs+13l/xXS2YH76ldF1wflpFEQkVv5Hx6+296eh6XHuIcxDRBR6fuLrfUyvlp0a/hW7I6qATqeqaD1qW7KGUyMokbAqerYit1PE0CW7AytGa6qi2GBTmhNuULdsM8euSLP4tl1Tj2DujRZmdjFf5a3MpWKl+4w48pCUJ1pPWSU/FZMMARp9tvCqs6n0/q+zny3Jb7zpEVzN2IaxAZb1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uSBdoKekaY6UBAXo6/7ILqfX3ajwc+LtLjpedJgYyclCuXZ873NmHYwhCpee?=
 =?us-ascii?Q?W40OQOXRngeaeCA+8JwwGdioyY/IW6qBStiBNmEDTRE/hYK6jvnjXMMCxdob?=
 =?us-ascii?Q?iWwVkcyOuqw1Ve0iR7dKyLwQ9dbX++cTcmw5sAyBocUsCqwGU1Okg2C8gMRs?=
 =?us-ascii?Q?8CYIVL6O5DfksUxVc9E+ZttuihoZqFTbfaTop7vFIndKyqfupGOKYngVuD50?=
 =?us-ascii?Q?tOwgKzX/zNrUR5IzcosGeKiTRxMhEcSskoGWNklf3VoXsmoKwOieCgv8yNio?=
 =?us-ascii?Q?e6at3X4mrcoNU9QACq7o+O+DH2TdJezOcMAEYwSY06xo8N0fKxjnkHdI1D9E?=
 =?us-ascii?Q?gOAkTYaBqlNSEfYwCET6hqx4zq8QJMagtWCgUFY5zQxF3qfgrnFz8IUiel2D?=
 =?us-ascii?Q?gTMaWuON/UYuG2fOPzstp/aKQfI9V8kP7WrRDwx/j6RoePXoNq4qQXmh4AvL?=
 =?us-ascii?Q?GqLXeKnq6/fCHu7mjw6eIBZFOlIeqjTa2n5uA5OpK1G1aZUzdMiVWP1CA4DK?=
 =?us-ascii?Q?wwMp30sTN0uwGT4I6ww/A3d5D3UbCkTZcEMwkr4bBTyODM7Olgw0OOFBeRBY?=
 =?us-ascii?Q?L50VtmGXGmAWJ8V0evX5Am9xP6lY0MtqmKIM8S41rHymqG12npD+z36WSKR0?=
 =?us-ascii?Q?t4KqHIA0CeDQlWOmkDhf4nJbgklJBMooobH0SvYFOknythPeYtaoRJBtPFsW?=
 =?us-ascii?Q?r7KJuA+WQHMh4zo21IygRHKpoGLNe1AmcI9LhmjDB44v/qCcTkP5z7jqezck?=
 =?us-ascii?Q?OuMBpZsMVeLvul55yenasdiYO+q/pvAw30SOHIQdY8mIxgCK2IJVH0mb9+Lq?=
 =?us-ascii?Q?5sP88EmvEkoGPhbQwdpYIFtJJXyYF63W5Easns2/Vp8wNlusi94bUN8POK2l?=
 =?us-ascii?Q?OF7yRgxHp2n+U5ZjWXxRwqcIyvyfbbSk8D6wM483dTYwKveJbFkWsxLCFr8l?=
 =?us-ascii?Q?i2PEFuV4JsZn3RYcuE0WHEbAdflpGFxxY4nUI5jcjy3ner+emLc05g5FLBsH?=
 =?us-ascii?Q?gpiG3lFAQu2sIQhzf3Yh1KqT0oQrHcptQz9TL4D5gfHWFbUP5ETTeM2FnKAC?=
 =?us-ascii?Q?I5zLEowyKRLHpOq+CPwXK6aMuJv3ATHWdchaBrgliuGOsrq+Wqc7hMXpcRbI?=
 =?us-ascii?Q?AND8cJDhhyIpM5v0B9FZF7SxcMSMECq4WuhFWBQjO2oVUL6lWLk0F23nE9zM?=
 =?us-ascii?Q?pZwqlLs9bSs40zIpdUA50nmxzD/zPxssdSdYQRHI/1PDS7q2BKguVihhypTq?=
 =?us-ascii?Q?n04lvPMZ4/wcLpl5uJuwH3EF80tA7HfiECXZQZ4WKUtzPkWWh/Xjd6QpkifF?=
 =?us-ascii?Q?rcfOwGa5c/ztFHCD1ABWdkLu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c15bc95-e9a0-414d-857a-08d8eee6fde6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:14.4006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7zZMTchPuhDdxy1zh6RwpzQM0mv3J1m7zfuo7GLqAzuN/tViCvHZd7L+PMXWZ0xcCzRxYNvqk4oLbLEN+GuqIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change NAE event
as defined in the GHCB specification section 4.1.6.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 58 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |  4 +++
 2 files changed, 62 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8f046b45c424..35e7a7bbf878 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2141,6 +2141,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_PAGE_STATE_CHANGE:
 		break;
 	default:
 		goto vmgexit_err;
@@ -2425,6 +2426,7 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, int op, gpa_t g
 		case SNP_PAGE_STATE_PRIVATE:
 			rc = snp_make_page_private(vcpu, gpa, pfn, level);
 			break;
+		/* TODO: Add USMASH and PSMASH support */
 		default:
 			rc = -EINVAL;
 			break;
@@ -2445,6 +2447,53 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, int op, gpa_t g
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
+	if ((info->header.cur_entry >= SNP_PAGE_STATE_CHANGE_MAX_ENTRY) ||
+	    (info->header.end_entry >= SNP_PAGE_STATE_CHANGE_MAX_ENTRY) ||
+	    (info->header.cur_entry > info->header.end_entry))
+		return VMGEXIT_PAGE_STATE_INVALID_HEADER;
+
+	while (info->header.cur_entry <= info->header.end_entry) {
+		entry = &info->entry[info->header.cur_entry];
+		gpa = gfn_to_gpa(entry->gfn);
+		level = RMP_X86_PG_LEVEL(entry->pagesize);
+		op = entry->operation;
+
+		if (!IS_ALIGNED(gpa, page_level_size(level))) {
+			rc = VMGEXIT_PAGE_STATE_INVALID_ENTRY;
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
@@ -2667,6 +2716,15 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_PAGE_STATE_CHANGE: {
+		unsigned long rc;
+
+		ret = 1;
+
+		rc = snp_handle_page_state_change(svm, ghcb);
+		ghcb_set_sw_exit_info_2(ghcb, rc);
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(&svm->vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 31bc9cc12c44..9fcfceb4d71e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -600,6 +600,10 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 #define	GHCB_MSR_PAGE_STATE_CHANGE_RSVD_POS	12
 #define	GHCB_MSR_PAGE_STATE_CHANGE_RSVD_MASK	0xfffff
 
+#define VMGEXIT_PAGE_STATE_INVALID_HEADER	0x100000001
+#define VMGEXIT_PAGE_STATE_INVALID_ENTRY	0x100000002
+#define VMGEXIT_PAGE_STATE_FIRMWARE_ERROR(x)	((x & 0xffffffff) | 0x200000000)
+
 #define GHCB_MSR_TERM_REQ		0x100
 #define GHCB_MSR_TERM_REASON_SET_POS	12
 #define GHCB_MSR_TERM_REASON_SET_MASK	0xf
-- 
2.17.1


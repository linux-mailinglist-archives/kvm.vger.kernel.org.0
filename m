Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D655398C3A
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhFBOQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:16:07 -0400
Received: from mail-dm3nam07on2052.outbound.protection.outlook.com ([40.107.95.52]:43296
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231871AbhFBOO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:14:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbKGPIVfaC5LF9APWueZ0MUBeFighZF9luMdIpVDVTyJLBX6whOhmfl6s8MWhUyTTvK2GH/j/w+WrF6WaiE6WbJMfb4slUS7zQ7OFK5sSk3Rvn228i8cKwdsk2YUmXJz/l4eDBFpxPHO3ttSFknpUW+b1hPsfEfDz8RvkJxc+4npBhTTIgx6dPHxJGQJsM72omNzhXbBMqY8jMz3CrP/DccQiqrgUWzoX2nJ19aPJwDfzkKd+FD0gmhRqqAfw9GFXj+gFJTf9w/cjVCSeddkex6avFIjmTnS4rvRA02dba/1z4OhdxYpojw7LD+Pi3RKSDDJbiC3j5xhuNAfHWB2+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TR/OilF+kLj/6CoYEbWq+e3F5tqZ+4LrJ8NSmaTNCg0=;
 b=RPJsSt1yLMhR7IzaKoXH9Qv+ktKhZG7Ii1jf/MLlYfRk6LJj/9ViCNfEbXluwVDTWs5TA7wn1oIVR6F9LapVfjoWmM5ckfdqBW5amruRYpWtEPk6oKUWp+nLANg62leSb51a/ViHTbKeS1eO0IMRQ44bZ9kYZ2nqkBCOwYF22YXgixLVBt2sIwUnTI1+mVD5OFR8dCUYk3hypfxJgkPvTYz4q2Vlr1vLXGl91gve1/yCQf5hTLmT/Nt0qUq9K/u2Yevh45pddoEO9KwYme6aHPiwk83opdRlboWrxA57Rb+54Z0YsROdRiG/oAzIBrzLzRI4pVZsmV134uUy5h8ROw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TR/OilF+kLj/6CoYEbWq+e3F5tqZ+4LrJ8NSmaTNCg0=;
 b=0ix3C8QX0TGCHmZzQGYHQ0Ay6jl+yA887jCae1IT3iMCbHkY9BkT29Qab/DPPwGtJSomaB7AqifICeQPxcF1kbKbrYauepUjKN+q04R2xGlOO+Ywzl7LH9ejfFhMDrnXyiFpUjPwVLjjdbAr8OYrE+Qkdp15SNintLO+9zwBfSI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 14:12:38 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:12:38 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 31/37] KVM: SVM: Add support to handle Page State Change VMGEXIT
Date:   Wed,  2 Jun 2021 09:10:51 -0500
Message-Id: <20210602141057.27107-32-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:12:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7144cafc-4990-4b35-ea78-08d925d0685e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45740704B7F6F5C12932D3C5E53D9@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vH939Gcn2vPH8DCoyoFfHGFLB4u4Hq3nnbNgYmsrjSotu1KCxX8z6KB/zWyJqnH/btqqKcL74tPs+MagRHBVsH35MFVCiSNKNyZ778sRtVZO9/lbFU6We3WZEawAITCA35hyRkYxgqAqH8E3nQp7JHMmAnKavI48EvUw9QGrQ+1wtSu0IEIdhqAEOaSpjEC2LnIK2gPMwRB3cQK1S4jlo4zJt44H4yRJwhqg1BoQgFkiJSa146S9+YDGqN1z9SGqtceOQBj68/TAqSciUAkYrZ11+emZ11d0kmJM5auCd7jKV8AOkBiIccRsCyhoBVnssoOlsXoYWlCr0ChrAIOF1vbAECO/yWCPFk8T2DxVgF3dDBjtZ1/VT7T39MFqb4s0OVhG/KxBtDiUJkxx2HIpCYF1yLAVCSclgARgA1GzKy9dhxmOUdyUP/76YxzebYIZhdED7bt744OUGD+1lPyv2sz7KKKyHHD/c2WDk4fhMmVRXWRhsYKZMumJo6znoI91gWSWpR6FP2l6bcRHDMclilzRXVlEMvg7o1nw5WXYaCK7eeeYomovJNcvab7jKJrRsft58e4J8ydUq60Fn1PNAWqi/vfhoglDW+HUIDeC4c5wR5FB7QpUdQS4KzR0s+LJN1rrq+iNc2ZdzIMtxn9BLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(86362001)(8936002)(7696005)(52116002)(956004)(478600001)(2616005)(66476007)(66946007)(2906002)(26005)(186003)(16526019)(7416002)(4326008)(1076003)(316002)(6666004)(38100700002)(38350700002)(66556008)(44832011)(83380400001)(8676002)(5660300002)(6486002)(54906003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?H7kFAsywpYqvWDy6+4TXxu8fTUkRQcbCDy/7EsMAtLApa/5z0eJgBDrWqzvl?=
 =?us-ascii?Q?b3+p75i9gS9kV6xeJ8L/AkaUjZ3lLX6UlcIJUDq5rbqqvyUcIRJgXY7QokDm?=
 =?us-ascii?Q?lgQB6haF4sU0bWdL2Uvkkw+3AIR8HGv5n0OYomNnxRlnnEf9lIfoL8t1o68j?=
 =?us-ascii?Q?694D2dxJgg24iKPccnMVVJNbMqn7gIHhLEvgga+/AsqgZWjZt8j5Dcg4ZHIU?=
 =?us-ascii?Q?OdSLFOkL5E180aoBn80UN/uzkaeefAMQYna8/bVPoFT3EbF22++DvvxSxOAB?=
 =?us-ascii?Q?tpv5HlM6OH06k5g9BYdCd3e/4QxM9dUJ2OEPgDrY+i/2wVBkiZ4Wr//4VTh4?=
 =?us-ascii?Q?DTk/d/o2FNAL5gZW5cy7hqPVc6WXFGZlh3dRalpCg265s03CGtQeMqU/S1Sp?=
 =?us-ascii?Q?SzLZs3vXl5vTI5200BU+pmxKn3wDZnPIUlKpwn/rOWAn7GdlW7z8xzwSpBCH?=
 =?us-ascii?Q?E/SHE/KFMB8cBbqbkSpO5Fz+wCIINh0FVHB305CeUm/CXCCpDo3kh8KEp+FX?=
 =?us-ascii?Q?yVOEGMK7r6sO2r/ZBkfhHy2ebM8kDNgm/ze4EP/ukSVgnxmySYZAr8R3k9/5?=
 =?us-ascii?Q?uhJCsrcGyR8AWl6rdZ2Ko2ZBXa2UAVQpuWU7DF3IzBD3Y4Z+Pzp4UyLq6o0m?=
 =?us-ascii?Q?M/gWKlhSawc8ZAz50oM/b6sULpvoe8UQNe/DIdQ/4tiMt9+gqPaNXc9rEjij?=
 =?us-ascii?Q?ygqFqshTSI446IDBVB3tOLCl2DFeBP9rm3kQ+bhXFFKXD+FucJHmbklSVuuN?=
 =?us-ascii?Q?i+DgDE3tFGerqBwl/6fRXbvKCBLJDFKzKt0X3yLzHyom15pYRNKzMZ5i4Sji?=
 =?us-ascii?Q?RIOoigcAvPL3sCzGFbCt96EGPe2Qu+/j6/DumU2uKZhSZQ4Gfu/AiMCL1gvX?=
 =?us-ascii?Q?XrzqF2NZmVyueX/gaqRLL//Xc/9K55xmd+pUyP+MMI0JZg+8tTcPsAOV51Q0?=
 =?us-ascii?Q?LKpTfCIYyd19s5V95Sa4lcBeEv3zp9CZb0PMrR5sbKAD+OgSkrmNMp/YAB1V?=
 =?us-ascii?Q?loruxs5DzvJefO47sxDkhhHHGAYZbBUnwhlbcWCevFPYj/jE/Ag8NSZLyMu1?=
 =?us-ascii?Q?N3jYwXU+EjZFDQu9AsZIuvy3utmgQpA/v4L/Xqbq5DX+YbZDld7hnqhD80+K?=
 =?us-ascii?Q?uvk+FdIie3mVfmJaC7qtgNrPfFuezlSFvQSLkIKr3wTDH7+oxFtRGEVvFYvY?=
 =?us-ascii?Q?IdmE1DtKbBkOM/mffErbz1l8QXPVv3Re+2Sw2rEmKxBQ/GoopBAqErpUtw6U?=
 =?us-ascii?Q?CQCo4COv7YUyr3xfpOGlcTvo+eCPCtJsIh1NJBpLTMS1GEHtNnDEuVlNhiyb?=
 =?us-ascii?Q?FfkQwhXe64CEYLLN462x31R6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7144cafc-4990-4b35-ea78-08d925d0685e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:12:08.6770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wGK+CUL86aD8LHciSYB/CQiwOrErd40Rf18dbpw/jGQb4pb5PIxSAXz/oOIBTCEAyVaJ0LWdvNfFrOQoEHLw6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change NAE event
as defined in the GHCB specification section 4.1.6.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h |  7 +++
 arch/x86/kvm/svm/sev.c            | 80 ++++++++++++++++++++++++++++++-
 include/linux/sev.h               |  3 ++
 3 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index ed417340ed42..aeaf0ff3f2c7 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -102,6 +102,13 @@
 /* SNP Page State Change NAE event */
 #define VMGEXIT_PSC_MAX_ENTRY		253
 
+/* The page state change hdr structure in not valid */
+#define PSC_INVALID_HDR			1
+/* The hdr.cur_entry or hdr.end_entry is not valid */
+#define PSC_INVALID_ENTRY		2
+/* Page state change encountered undefined error */
+#define PSC_UNDEF_ERR			3
+
 struct __packed snp_page_state_header {
 	u16 cur_entry;
 	u16 end_entry;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dac7042464be..ddcbae37de4f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2640,6 +2640,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FT:
+	case SVM_VMGEXIT_PSC:
 		break;
 	default:
 		goto vmgexit_err;
@@ -2888,7 +2889,8 @@ static int snp_make_page_private(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn
 static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, int op, gpa_t gpa, int level)
 {
 	struct kvm *kvm = vcpu->kvm;
-	int rc, tdp_level;
+	int rc = PSC_UNDEF_ERR;
+	int tdp_level;
 	kvm_pfn_t pfn;
 	gpa_t gpa_end;
 
@@ -2923,8 +2925,11 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, int op, gpa_t g
 		case SNP_PAGE_STATE_PRIVATE:
 			rc = snp_make_page_private(vcpu, gpa, pfn, level);
 			break;
+		case SNP_PAGE_STATE_PSMASH:
+		case SNP_PAGE_STATE_UNSMASH:
+			/* TODO: Add support to handle it */
 		default:
-			rc = -EINVAL;
+			rc = PSC_INVALID_ENTRY;
 			break;
 		}
 
@@ -2943,6 +2948,68 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, int op, gpa_t g
 	return rc;
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
+static unsigned long snp_handle_page_state_change(struct vcpu_svm *svm, struct ghcb *ghcb)
+{
+	struct snp_page_state_entry *entry;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct snp_page_state_change *info;
+	int level, op, rc = PSC_UNDEF_ERR;
+	gpa_t gpa;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		goto out;
+
+	if (!setup_vmgexit_scratch(svm, true, sizeof(ghcb->save.sw_scratch))) {
+		pr_err("vmgexit: scratch area is not setup.\n");
+		rc = PSC_INVALID_HDR;
+		goto out;
+	}
+
+	info = (struct snp_page_state_change *)svm->ghcb_sa;
+	entry = &info->entry[info->header.cur_entry];
+
+	if ((info->header.cur_entry >= VMGEXIT_PSC_MAX_ENTRY) ||
+	    (info->header.end_entry >= VMGEXIT_PSC_MAX_ENTRY) ||
+	    (info->header.cur_entry > info->header.end_entry)) {
+		rc = PSC_INVALID_ENTRY;
+		goto out;
+	}
+
+	while (info->header.cur_entry <= info->header.end_entry) {
+		entry = &info->entry[info->header.cur_entry];
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
+
+		info->header.cur_entry++;
+	}
+
+out:
+	return rc ? map_to_psc_vmgexit_code(rc) : 0;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3187,6 +3254,15 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_PSC: {
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
diff --git a/include/linux/sev.h b/include/linux/sev.h
index 82e804a2ee0d..d96900b52aa5 100644
--- a/include/linux/sev.h
+++ b/include/linux/sev.h
@@ -57,6 +57,9 @@ struct rmpupdate {
  */
 #define FAIL_INUSE              3
 
+/* RMUPDATE detected 4K page and 2MB page overlap. */
+#define RMPUPDATE_FAIL_OVERLAP	7
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 struct rmpentry *snp_lookup_page_in_rmptable(struct page *page, int *level);
 int psmash(struct page *page);
-- 
2.17.1


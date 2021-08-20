Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F6E3F30DB
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbhHTQEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:04:47 -0400
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com ([40.107.237.72]:45024
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235727AbhHTQCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:02:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQEffHwOEfJXe3Ct9qXrtiswzDlIw8nvYocXaKheU8VOb/nD/nroQu6Gp/6HTv5zygnmgabInn7AcfdgMgujPdckZvyO+6CFfLcXv2aIQrDGVcfc9ZbqmtVeYiIo0CWMZo/g5retS5Gt3gceq+Miuj+11X53szM6cRWC+q7UMQiQL7O6hpEcdeUxqsslEYPfT4RPVCxBfEtCC2xUNWkQO6+HP513v2/a46Ljwvy7zqR1Mmth+vakTtLYbBpTRRxg55ulpl6l4T51Ps8wQkx/rIsD/Ejtz1v0WNt98lSFKg+jENoT2yMvN3/27U83N3eN1m+WJyzRVOMz66CRkPMQrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKqVjfxJwfOckUs4khLKJnX2F948fdlcNswk7S6UPNM=;
 b=fA69D8CqR4Ak1vz4UwcGqEmhpmgfS6MuxT3IXGl0sWCSRa09f4A78dWQhurgfpFbF1X/rixqcx5OTQezrAbumv6SHkrjnlOR6lM1VGNFIOEwLx88EYoTPh9Mx0wRFzSDjDiNvZQ6j7GUs+wKGwljFWpQQTcLm0lPjNsaSw0Yav1m3Ql31k/98vj3NjsZldRj4602MT7vc88DYStw4h5tuNyMYD0VkdNHLOysXHeBa3Svqy9ioSgLfcUskU/pLP7ZLPYSEL0SHJZoNLsA6OBAS9Ahm6/BYqhQPtWca9RoiHkRKiZv8zNVFqZ4fyD8hVYXQmrCPwuFeJQBnx++eiZG5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKqVjfxJwfOckUs4khLKJnX2F948fdlcNswk7S6UPNM=;
 b=5K1yoKnvRFhHgpfgZZ9bbKk6CUO7R1ZFZZfKpeFZuHWfwF68VfGKpCENlvikGnyuZg/VL8LLAcFmdQ78Rpycxp1XqD4F1JoVZHlM4hm77mGoPm7si27Jqk3wCQcbisAH/EBkxl4wNvi2HoHszrZ9TDdWcN76ZQO+Wa++ecVdy1Q=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:01:08 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:01:08 +0000
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
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 38/45] KVM: SVM: Add support to handle Page State Change VMGEXIT
Date:   Fri, 20 Aug 2021 10:59:11 -0500
Message-Id: <20210820155918.7518-39-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e62dcf92-fe45-40fc-7e05-08d963f3a9b9
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45099F26A8D70E0B0C175156E5C19@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EKwXIJnjKzVKz2BIRqhf2v+ZkITCFmpQZZ0jtwfG2+ECZo/xp65UNVA3K7sWYHDNTjMI8C3bHAsjRW7TVL3rVhU8ZLGEkBUwXBqcOr8gnzqEQYZx4s56PQQ3hLeJ8boInlm1lnSSRU/6dIrz5pGVsS1oatsaN2UhxNN2Uda6yjSu7RvBrB1ZVpfCzI08VctbMUvLHZC/b8BuRjApmfn5oFG44o7uQOB/QS75Rz/zsSFTv2xXf6Z4blrukdjk5gp1fd+vb9IJqAXwmuatOpY/y83h6THS3w+mxIykLBGXNG+caNWLX32Fk0npanpXuJYtb7Y2OARg/3hRxvBR/YPqW1nx1kek1oEzbN+Sw3PyfEhI2cWgH2gEIeGQJe0X7BoZKETdDE/4RPW+yrrfhmWNRnYAp3OiD1SKAmoxl1QfOQh+6qmAq35z20xDG3TrfFtPKKjGK1B81Yl/iVvBB9nrXRQAlPGC78fmBGyCFCvC81TJ7uUrVELcnRutAZ1pqkCqpbe98gmGAFdci3K9l0AsV1UuVL1Ac0VuU6DJWqZnZKiuG1dXBBFncTRYWAERbW/tUBdr2eoBZalNb/oq0kjKHA2wEw7ABEhzKnNB7gZTuJRcTxzLO8GfT7hxukOs7TK54GF7gwZNfxNIu2qSJ77+BEm4b7eTfVb9YNKnMr0gFtIJcQ4y3viO/mwi4u0wIsD2lZDJ8pCBN4ZHGhGO5IQKwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(36756003)(7416002)(44832011)(54906003)(316002)(66946007)(66556008)(66476007)(86362001)(7406005)(956004)(6486002)(2616005)(2906002)(83380400001)(38350700002)(38100700002)(186003)(5660300002)(8936002)(52116002)(1076003)(7696005)(8676002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rjlfMhIPXa+DTQgIUGb6trSvmM1cAdXYxlJdCzD/CeWdjOGXqnj1btcJKjFB?=
 =?us-ascii?Q?j3wiq4ik6Sb6gKmHn6mYAlM7EvySqpd7BglcjreJFDylXZ6NA3kL206CdzN1?=
 =?us-ascii?Q?ZdEt1U3YwOwyIaBdnicDmNYJNwxnIc9aSNcWzVftVFAmR1ELYbyLGFPqsEvS?=
 =?us-ascii?Q?aSBTj2sjsjm9QomQMbEu3zgxJHFCSOr1UD1ZaEFBbBLoLqVHQWgSD6zevTeY?=
 =?us-ascii?Q?kWrkWoGpVnZIG9pPU1DGuvVZMzJ1e+M0rKfXewfynR3NVEgHpYaXtDaV3ZEX?=
 =?us-ascii?Q?PDCaz2nUMxTOfn4DKBgKhuW8usCOpFrLXq8ZJ0c5RgwZl+bjYSj1x0QEZ1qX?=
 =?us-ascii?Q?wTVittFktJfZg2S15rG2G32Y/gipG2urmWkQ+gQATTMADw1klBR+TXqqjqlG?=
 =?us-ascii?Q?JgFRf1vp+ubXTm5rEGZnFlQoFbHvFXDkOg51Lzv9C4kT9LjO1hvTAWvt3aRy?=
 =?us-ascii?Q?wpITmnwUrV3Hpmqt/uDgSJi98bBpJtPUdDryAOz8oZA5SL7820PXLZwj8W0Q?=
 =?us-ascii?Q?W/E1kl6kSxZDV77V40oeAiES9U0bTUJiPHIEq/oLGnVyMDt3FovA8w//jVQa?=
 =?us-ascii?Q?o9gZ7B23Ll9NP8BQ6229N9ozsk7W1ovZJbfL0bbkMDT74K6OY9l+TgwKlHN3?=
 =?us-ascii?Q?xDJM34ZEhA/n0PQ1ILZtinmkvvDP7UcrulUoLsXrB2qOS7F4Xprq/nPKH0X/?=
 =?us-ascii?Q?5V6mj53upOKxtAqNXaklUoLGqfCyrW/j+yU9IOhf6fz6Wcy1YVU6d8hfMq5E?=
 =?us-ascii?Q?NEO00NWSLgZyOcj76pDJ7BlyoPCHRHhqu4lhGyla6xnCn3cMUprjt7d5bZ+r?=
 =?us-ascii?Q?x+CLk4kDewspfTCKUL2fmYBNK6S/fpUmBTFuBnO+hDITWuCG8ydcon1zvFlR?=
 =?us-ascii?Q?JabmGR+ws99LWRI63uB5gCwwsChh5nEnGU9XGqdX5zvKBnwYBX6JS0QlUJZF?=
 =?us-ascii?Q?9JfQMIDf18hjiKkHFROzbqS3THDIs0cGTPGG8V1tEcxfXu/FBV8nkgXlc/e7?=
 =?us-ascii?Q?G2OjlifhXPEoQJBw1gMFYXSSm45YNXJMbzdfmDuax8I+VZFvw+n5+LHXV3Zf?=
 =?us-ascii?Q?13wRNuy+BDbcgMG2h1vv7J6cZVS+y8lm3p52m+PyM1Fu+Icx8StAJFcX+lJg?=
 =?us-ascii?Q?LSYV/Ug2Ajjs9q5yw4uDhjaEGgpDDo/OnvAfZUrlZXAf3+p4IqdOhaBtdtRv?=
 =?us-ascii?Q?ZMV5Y/nG/ULuZO+mM37J0aCCZDAoR0GbfC0AXXHNQ33XnwGoXcZDMcYQnTx7?=
 =?us-ascii?Q?B2Tyxe8ki4MIeIZswzfbXcIf3Am8hrzyYHRYu7Nyqztmxjx3s+tiHIw94g4a?=
 =?us-ascii?Q?LcKznLGggTKtwMmcScRjV5GE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e62dcf92-fe45-40fc-7e05-08d963f3a9b9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:42.7113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rvk5ds+fS47zaWT837BcOlwYkyXp2vJ8AaieqY+gk7nzlfpMQY2j8hZTW4s6cc7tR76Y8hUaTlFxwU82I9sp6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change NAE event
as defined in the GHCB specification version 2.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h |  7 +++
 arch/x86/kvm/svm/sev.c            | 82 +++++++++++++++++++++++++++++--
 2 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 4980f77aa1d5..5ee30bb2cdb8 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -126,6 +126,13 @@ enum psc_op {
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
index 6d9483ec91ab..0de85ed63e9b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2731,6 +2731,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
+	case SVM_VMGEXIT_PSC:
 		break;
 	default:
 		goto vmgexit_err;
@@ -3004,13 +3005,13 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
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
@@ -3022,7 +3023,7 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
 			rc = is_hva_registered(kvm, hva, page_level_size(level));
 			mutex_unlock(&kvm->lock);
 			if (!rc)
-				return -EINVAL;
+				return PSC_UNDEF_ERR;
 
 			/*
 			 * Mark the userspace range unmerable before adding the pages
@@ -3032,7 +3033,7 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
 			rc = snp_mark_unmergable(kvm, hva, page_level_size(level));
 			mmap_write_unlock(kvm->mm);
 			if (rc)
-				return -EINVAL;
+				return PSC_UNDEF_ERR;
 		}
 
 		write_lock(&kvm->mmu_lock);
@@ -3062,8 +3063,11 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
 		case SNP_PAGE_STATE_PRIVATE:
 			rc = rmp_make_private(pfn, gpa, level, sev->asid, false);
 			break;
+		case SNP_PAGE_STATE_PSMASH:
+		case SNP_PAGE_STATE_UNSMASH:
+			/* TODO: Add support to handle it */
 		default:
-			rc = -EINVAL;
+			rc = PSC_INVALID_ENTRY;
 			break;
 		}
 
@@ -3081,6 +3085,65 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
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
+	if (!setup_vmgexit_scratch(svm, true, sizeof(*info))) {
+		pr_err("vmgexit: scratch area is not setup.\n");
+		return PSC_INVALID_HDR;
+	}
+
+	info = (struct snp_psc_desc *)svm->ghcb_sa;
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
@@ -3315,6 +3378,15 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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
2.17.1


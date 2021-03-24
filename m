Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBDC347E04
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbhCXQpC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:45:02 -0400
Received: from mail-bn8nam12on2043.outbound.protection.outlook.com ([40.107.237.43]:10848
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236545AbhCXQoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:44:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByuYCqNM8LgUmT3aDJ+GNH6yzLhxDJBjmc3oGz2mJ7WjG1f+Pc2euxnNsNQCCT//iTIzQuT002Ip9wKqEGcLK/2blKRrun733pAGK0SRvjwQ6vBxzfOAI94EYPPBM404CqFNXQca9qNRsM24YO/T27ihrk0qk9b4wX8c734XpnwWkqRB4hGpcV1RPZp98llhxTLcoHnTCbBcsSPiHeN6q7V+soV0PJymAB5WEP7Qhz5lCGvNX+b4XxxQ4Eg6PM9Dea/eY7auJf8zfbqtnvI22pXDbP16sWiSyEsYDtE+SimI3gZWf/eK97sU0Xt4f6xXaMA4YAZisUhQq7IMtaE39Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZHabqdghz3vzEVi6EqXAVLLM+JPON4DLXqK+6MGbnpY=;
 b=oJHBtz2cFeBT8dDrvX9xNbTLXP9mRQx7shtypi3QIzEyq5D2A1hcve/sd/R+D4/XDlfepPPKY9g7KJf51TdqjdIbwLcNpXQrF3L1hs2QRZ01QWsO/zhs/bEX1DJ/aRWZ3S5lEnA7VIP4iHP6io6WX42trlUgwZo+ovtNy2TgoLJpra0gOka5j/sSBosCQd9kK6Uyc1B1zNSH7X6qF9uGVxqCQRNvkqdmtOsaY5gcnUOSwOOrynIlMRpJ80D9W0Ovg+B9VCD/Y9VmyuGOiydUhdAZJgnEUa6fqJwH9XLuRy6ykckJryCtdG7WhgedND7Tiy/KoB/XSRoJT7HncmhGSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZHabqdghz3vzEVi6EqXAVLLM+JPON4DLXqK+6MGbnpY=;
 b=LFCsRUbuX0ONaCg2i4z6ejO+V+4SOfcgvo/gsf5JHSJ0JQa+Vcr6D601PFMGe2YBGA/C+b1oKzGhbrTWMJ6ciwEVoEOptCntgLbsKQ7XoXohbV7S6qczO4X+Rs6EV6N1j7kwzkrmctuyaFffNNCvssOlN3DujF+YrmaCpLuiWVM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2447.namprd12.prod.outlook.com (2603:10b6:802:27::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 16:44:41 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:44:41 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     ak@linux.intel.com, Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part1 PATCH 04/13] x86/sev-snp: define page state change VMGEXIT structure
Date:   Wed, 24 Mar 2021 11:44:15 -0500
Message-Id: <20210324164424.28124-5-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324164424.28124-1-brijesh.singh@amd.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:806:d3::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 16:44:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c3e931ef-d455-49d7-615d-08d8eee41ebc
X-MS-TrafficTypeDiagnostic: SN1PR12MB2447:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2447633F5AA8628406D9D18BE5639@SN1PR12MB2447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KDzomUIfjSr4X/Ok9ujpml8tQankbpbZ8sLRmAoWPCJ+rNNlDupRxZRaZ6nANXdFrBVmwvp7RZaDohnFVNnBeB5Xa4qzVrs2V17SnXosn8NPjObfZ2Vv5oKtqZAS74CFhvxLYCGBvvjUH45DxGGYRx9YdiN/iLrYbas3KcUEDMjfTSigIDXYvfaE3VqKT0Bn08ED1aGMS5zDFH+diTIZjGbmQCyuP6SjolUoJx94uMLNSHYyUEHp5GYxTWAcB7Gbs8FZrmA18wLKG8zUeS23iTPTG2t5u1yMIid9KDZMBeY22ZxI7d6DoE0UveK+tyGg7gPoAzffHmzNb1kCHE28MSHUR0CcfQJstkktaPcYvV2kfOVH6ff11jbv4ZZgc+SAZ7KBOmRnivAfksilro4cWNtxNBhAf4NdtzMWbjEf74GWL4tmvhLBjzcL70uEAB4ahirgh8Pr8LJskd9lX7PWGayMsIGOpQzA8OwPJjAIXm55i1Ut8s3c9I3oyzUTmdyAKq7UYmHB0bo7Hau4mqCscDm6zxIdV13YQZ8y6MuqL+A9zuAolMDAf4aGJpLJ9IaVvqFU7Hs0XrgjO//TXYA9hO/GFr4fU9G2/n0mqj0s4naRdlcZCrWThcVsroI+wPpXjOIsLtBCATWDwdSF/Tb9BYgtRKuftg33UiLToQwZ4Kk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(16526019)(38100700001)(5660300002)(26005)(44832011)(36756003)(1076003)(54906003)(8676002)(316002)(83380400001)(8936002)(4326008)(956004)(2906002)(186003)(6486002)(86362001)(7416002)(2616005)(66946007)(7696005)(478600001)(66556008)(66476007)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?k7hJMn30r06R+RCrlESqCBO6jwnn+ALYUsrYQSzbkQmMA6ZTxfHdbpHUHLUU?=
 =?us-ascii?Q?jdXWMeZWhj9wHHDO0d6YF6rd0SEC58zXHZDEk00rqDc8NxaMRN7yh4ACrMuz?=
 =?us-ascii?Q?b2+S7iYANqJahuE1+DTa2z6fkJd3GtF9/I7FoKpkCZRzDB0tRIV/hyKg7d8J?=
 =?us-ascii?Q?mfr29amPZuvRLvdDXggmnf6cDAXzbnUxsrDgevbJpEjyfSBr7oDpyPsipkf8?=
 =?us-ascii?Q?jTf38VHNykq3pJStXcOgQa0Ms9F5ehQ/jyV3c7iPusiHkVEgmWaTKqx6CA+R?=
 =?us-ascii?Q?n+hPATwE2tKQ9f60QzFkT5GRcg146sSLd32icwHY4d3hvAIiIHDr33c9DpIb?=
 =?us-ascii?Q?otHTJw+Dd/EngcJXV5A7pGAjb84GA8Fleos/QRWd/0qa72Enx38+rSHCzsY7?=
 =?us-ascii?Q?hEPpTRAafGMRLjtKVexwmO9ee4WDgVuT6rn/ZJcMTRXsF/7Nisi9BjcrUSZZ?=
 =?us-ascii?Q?TXlvRmOENBJMWJdGPJYlEt5JPpOfUSYm7lmyuk3gTOlYskrQXkBh3uE0n2ph?=
 =?us-ascii?Q?PtpWPtc8fEbBy7Vzjycc1OrtJpEcp5FmpVUjHejrJhfSIOlvjSe+CSZDhmSq?=
 =?us-ascii?Q?WQrOw6QaCrpszCSKAIXoQ0xjZ9+QpmNafv4cvMKMAuq3w3B+UTGXCAJpDnX1?=
 =?us-ascii?Q?hJZ2PnAD3zXxkzjDkz4F7+PSY+9Fxipmteo0ntPAxsb7BApMdd52A8LQNXul?=
 =?us-ascii?Q?hv0cSI2Wt0D0SL+DbIFn0YdIMbUcbYGMrJH6nBOVc6h7nwikjSD6z2aWOsqd?=
 =?us-ascii?Q?frpMqYuFEdh2Duc+NcfSZp5t8cTuL495eOYTJNtHw+Ttpv2swFG9CWePtBsZ?=
 =?us-ascii?Q?4VGC7OiZ43ejVPrESLxmnquS+iN9AZ94Hj6IObHlmvdcdFcCGZ5ZzcB2rYSc?=
 =?us-ascii?Q?paHN+riHtdN2y82S6d0+4utWY+5R78uvlGAcf6mCFEHjnPNqKrQqpdcA7O7s?=
 =?us-ascii?Q?uu4p3XFaCqzqrtLv1W7z41kNJ8TELOQZ5dQaMkMmXZbJzNs7rtS5zj2Nz9Oc?=
 =?us-ascii?Q?6yaLnhf9RnPQRYU3v0GK/KKOb/AzaQy8hO8k3m4SCpgivsTqTpwI/D9JG7cj?=
 =?us-ascii?Q?nr3ZEp10+T4rAp6eiAyL40+y4ZSrCutw1IwdJOLlVkIY9V7JRIyD+lATGaJz?=
 =?us-ascii?Q?qMCA3udx1cMPVvw3lsFGjDoTNmA30OqcuM2yjaYumSQvXRl4W69TXihwsLJI?=
 =?us-ascii?Q?Y5Magz/fjcWnkv+w6pfsoUnCaEQL+ZbhAvDxni+5lfHcAELDGppaqnCLqE/d?=
 =?us-ascii?Q?qNIAYYjD5Dz6E9Utg73veWd8Ba0K4o5OwWYyqDJn0nWDyzOD7fe/uSHEcu7/?=
 =?us-ascii?Q?rl3+a9PNc9ZOp5Vvk9i/7RT+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e931ef-d455-49d7-615d-08d8eee41ebc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 16:44:41.1190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DFlE2Vat6peC+SVWiALlG46253umEYAePrTHx6Vx/uGoW/xfpUG5vBXClWlU8bRVX9nsMl9KpVrt9DzWYak5lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2447
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An SNP-active guest will use the page state change VNAE MGEXIT defined in
the GHCB specification section 4.1.6 to ask the hypervisor to make the
guest page private or shared in the RMP table. In addition to the
private/shared, the guest can also ask the hypervisor to split or
combine multiple 4K validated pages as a single 2M page or vice versa.

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
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-snp.h  | 34 +++++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/svm.h |  1 +
 2 files changed, 35 insertions(+)

diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
index 5a6d1367cab7..f514dad276f2 100644
--- a/arch/x86/include/asm/sev-snp.h
+++ b/arch/x86/include/asm/sev-snp.h
@@ -22,6 +22,40 @@
 #define RMP_PG_SIZE_2M			1
 #define RMP_PG_SIZE_4K			0
 
+/* Page State Change MSR Protocol */
+#define GHCB_SNP_PAGE_STATE_CHANGE_REQ	0x0014
+#define		GHCB_SNP_PAGE_STATE_REQ_GFN(v, o)	(GHCB_SNP_PAGE_STATE_CHANGE_REQ | \
+							 ((unsigned long)((o) & 0xf) << 52) | \
+							 (((v) << 12) & 0xffffffffffffff))
+#define	SNP_PAGE_STATE_PRIVATE		1
+#define	SNP_PAGE_STATE_SHARED		2
+#define	SNP_PAGE_STATE_PSMASH		3
+#define	SNP_PAGE_STATE_UNSMASH		4
+
+#define GHCB_SNP_PAGE_STATE_CHANGE_RESP	0x0015
+#define		GHCB_SNP_PAGE_STATE_RESP_VAL(val)	((val) >> 32)
+
+/* Page State Change NAE event */
+#define SNP_PAGE_STATE_CHANGE_MAX_ENTRY		253
+struct __packed snp_page_state_header {
+	uint16_t cur_entry;
+	uint16_t end_entry;
+	uint32_t reserved;
+};
+
+struct __packed snp_page_state_entry {
+	uint64_t cur_page:12;
+	uint64_t gfn:40;
+	uint64_t operation:4;
+	uint64_t pagesize:1;
+	uint64_t reserved:7;
+};
+
+struct __packed snp_page_state_change {
+	struct snp_page_state_header header;
+	struct snp_page_state_entry entry[SNP_PAGE_STATE_CHANGE_MAX_ENTRY];
+};
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 static inline int __pvalidate(unsigned long vaddr, int rmp_psize, int validate,
 			      unsigned long *rflags)
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 554f75fe013c..751867aa432f 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -108,6 +108,7 @@
 #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
 #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
 #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
+#define SVM_VMGEXIT_PAGE_STATE_CHANGE		0x80000010
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
 #define SVM_EXIT_ERR           -1
-- 
2.17.1


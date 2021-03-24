Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E36347E0C
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbhCXQpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:45:08 -0400
Received: from mail-bn8nam12on2088.outbound.protection.outlook.com ([40.107.237.88]:56672
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236582AbhCXQou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:44:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWsnadJ1e9i+yhmnLDSa3GaBX8+Fodkuj4F+9VN8bTr8+tEp2viMM9vRIO05lj/b7U602pR0HgRaT0xrfowx2hRWfbV0+iPAMWjWmGdx7awC1n5eAYdoVwOQVMeyv3lPXMMR6VxuvmtLDCyOGuh+9bC/A/lMRBxkFBm0QUrh1fzBjs6HgO2gU8GClhlZULoeQO2hD0SLst2H6zNjFWaMVxL8Zf+qJNOyEO/dcPRC/D4CQKeuIKi45yDmFWIHeATN8Tl4EY8VXQ9/MLfv+oXx4VllrZFYim+q8Jdw7NWgQVzI/yutdUnNSnWZT0pvCDH1cY8c8W7+fErzM5x97jykRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKsje28WOguc3V1il1l3rLQjEAGQYr/n4Fs+RMK1ko4=;
 b=BSPfeaRi5D7qqYInZgr9EDIW4Esbo4j1kw2HOySxWNLZSDUatorpJmeLD1wvFUIb7VRX6wSclMA1ahSpVo4CETX0Z3dSey1v0kjJLdYN1kZYUqDFTNgTKGCnYa+/UmQCFA+QTxLrVPcNGRVX3xfroAhZIcNXJ5GUnlTtKPzkGENpOEgBDWSZA06EqW19pLErs5mKSsbuzRPBW1fQAHsIrvhWar94pkJ8UlANVVZSqWTBPEBKcY4QwIU+onQFKTGEUs61TViPIWbncH0YTG6JDQWoBKSTgEg/pcBI5e9ZdR6kEANqWetQH/FCsYGVje4dLVDapx9p5BSR1fdsSNHYrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKsje28WOguc3V1il1l3rLQjEAGQYr/n4Fs+RMK1ko4=;
 b=yRnMaolMgp/+WNBOu2cx8xffaDjI4Iaw1t+X+nDVsy8d/a/19sxUeZR+0Ba5x0N3Eq83KJYL/qB2vDDdzlCtvQx5A1wnfUYONj8puCgE7io85K2o7RW1kAlT9Exw7c6j4nwIm5/Qd7kPVQgci/hAkf2f4oScRIlBbIzO5vsXUHw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2447.namprd12.prod.outlook.com (2603:10b6:802:27::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 16:44:43 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:44:43 +0000
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
Subject: [RFC Part1 PATCH 07/13] x86/compressed: register GHCB memory when SNP is active
Date:   Wed, 24 Mar 2021 11:44:18 -0500
Message-Id: <20210324164424.28124-8-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 16:44:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 28f0e37f-ff5f-4803-af8b-08d8eee4202a
X-MS-TrafficTypeDiagnostic: SN1PR12MB2447:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2447F905ED0CF0E4035C5867E5639@SN1PR12MB2447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R1xDn2amfCI3E5B3lpTQHQK4eqfLDRfevCiyQd6a04YxX5udBgqObA8XWvv8SMGkRLRfC4JGc7l/MSa3vask4vu5QYcU9xzluBHozt7KrcleAyb3MUvqmHUrLaiw2/MeihY7GPSEsh3z+/CiZhTU0j0gmMPQk4vo6Wu62OtHrEScYzaFJxnH+XsH/yiLzhGJg9/8pn8p2ke/82ywnwkiDHvW1ItDGDoEUFiVK4Y7xCmFcjMBAWqRf4TyuQx+8orrfA9E2JRqrPBMBKXX6zGrJXYUNnABxAZFRMXAGVODvjSrjMuI22LusT8aHaxg3Pd5NEgmewYPSpSLmuXy+Ehl2DBTqRRnX0AmI30daA1dnAR4dy0mBTj4CLmgODx4eXEkwBcCyYhPxkpkPYdTDvLKuPuNhT6LfW7Lq+NYKfyJmbc1gGHyfGd5bhYZ3AbvvuUZsdWpXdqhw5+1bAbc0VB8ClUJegjOOLxhnBmEbzOJBfw5QQligzHURNtGn8jX+3ruXjRgLDIho1VVhECannup/S3AF+n1io4TuytHyPot6OS8pegbx6DQXU/3ZV4rZfI+NccSsDZX1CC1COxdwjA9U+2Sh7bAXNIARwt2DKzIaWp0itE9V5Ah41qgILDrygmt2Sv3Z2vcHPzla2AFatYfKbOewX6gYIWRtMdhayAykTU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(16526019)(38100700001)(5660300002)(26005)(44832011)(36756003)(1076003)(54906003)(8676002)(316002)(83380400001)(8936002)(4326008)(956004)(2906002)(186003)(6486002)(86362001)(7416002)(2616005)(66946007)(7696005)(478600001)(66556008)(66476007)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3wnh69DwpugyEDFpgY//Ks/E2+olcuFxRE6rtV1tQddkTvmoXy8jVxrzthNz?=
 =?us-ascii?Q?GlIFBGPES+vyArrXcAeluHH8pAvPlqivEtga5uJ8NMJBs6cv9Rk1OXDjxpRq?=
 =?us-ascii?Q?QuqzX6US1ZXoijBhbfsUwa0Oq7GpmtQZKuasRjkpZ0HPoCXoec6NjHbRaeaa?=
 =?us-ascii?Q?Elw650OILPRzN3JUokJY2gCNj8L2dZFG9DOcvM9e3Ujo8kOf+WqToMDNndXT?=
 =?us-ascii?Q?wmcYKC1y+9e25ON4U9Ex6UU3206V45vz0SOGCLoL+PVIiIdkeBx6C1y8meHN?=
 =?us-ascii?Q?1qXdTH73ZrEPwmi0/UAeE5n0RCqQf6dK8IShl/YC9NUe3M/Yt34tMlk25++1?=
 =?us-ascii?Q?ffUwyHGSnrH8cVJn3SYSWjWQmOvzHHXOZgss9dCaNkMwD31uM8p3jb1rTTrw?=
 =?us-ascii?Q?KJXuLwkofanQThVEH4tqE9ySLu7FiFWb4sB1UT2re5qcDANxWIhpnO5zlOCh?=
 =?us-ascii?Q?zIxtoCUUyTGjxiTlGFyHHR6IXNFM3idJrd6saZ8pIzGCRgp3DdjSwWiBmFNA?=
 =?us-ascii?Q?MBFpwrtSH7y3YZavVb2609GZsYoZv1IzWR8J8pGBNn0J8W3RtzxU3XHZ0rsv?=
 =?us-ascii?Q?/xWrpYM6MKLV2GYWkzPJotivq2LPIP3/wNK8rtrr0Q1ueEy8lWSyuiFKQbLo?=
 =?us-ascii?Q?2sXqJ4gC9RlxEVZbfXRxysVH/94nxLujvD2vh1aWCk531R6aztWE8ME0DbNx?=
 =?us-ascii?Q?nuwdQGclN4mNX2YpYZow6ORqmALLMvpIMXmBRMcvJt3uHGzeORSecj+IRpW7?=
 =?us-ascii?Q?AzfT60N+6+0qI1xV6S97Wt9iyjMtH+0ivzuvK09bgc7G1UOss3yAiSQf1eDd?=
 =?us-ascii?Q?sjCeZd8BKD/3rbTwFu+qpyv1T131j59ft+bJkabDG3GO76vHxlTiiROsd+T8?=
 =?us-ascii?Q?nLOZm/uM4niWvClY99HvIMy2pNhcyRvYIB9eMC0usFVzuDdRhp6g0a/v2BiC?=
 =?us-ascii?Q?7WISm7XXGkxISL+60BxsRolUS34OUFfK7r+PLl5odPvBilG1RMcgRdOp6jnX?=
 =?us-ascii?Q?018dmhcyTE0rkI5gdeK5juNyOXBE1iS9YCeaxUuRoC+OltTsfucoaRDPcxDq?=
 =?us-ascii?Q?Mxp1Crv9a60LeKahlECFubrH+j7hXYvANUkLiayY+kPA33A8atZlXK+zthwG?=
 =?us-ascii?Q?wtsPJKh9NIWA0hkSzDMPvR2BlsQE4qDStZt1AqDN4sFk7lW8fAR40//WbR+e?=
 =?us-ascii?Q?9zFfiYQvURPnJxOU4O9Aqa1AM9Px9h9K5n0RcFgwnOeDHlMgFO4+EFdKUyu5?=
 =?us-ascii?Q?D6Bqhtas7e9GoA863tQvUiimKuYLgVMyvBRtcsVk/gYFACTCD5jPyXx9s2hm?=
 =?us-ascii?Q?vjnfofcGw3CetqzwOvO7EMd7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f0e37f-ff5f-4803-af8b-08d8eee4202a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 16:44:43.3886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6JYnK/yHBFY0MkB/QmElTrpldJ5pg3t0QSaKzmihaxGQ3b50/x56ClG1JEM7aNn64nnSXUFEKaSnEUiASRzq3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2447
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV-SNP guest is required to perform GHCB GPA registration. This is
because the hypervisor may prefer that a guest use a consistent and/or
specific GPA for the GHCB associated with a vCPU. For more information,
see the GHCB specification section 2.5.2.

Currently, we do not support working with hypervisor preferred GPA, If
the hypervisor can not work with our provided GPA then we will terminate
the boot.

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
 arch/x86/boot/compressed/sev-es.c  |  4 ++++
 arch/x86/boot/compressed/sev-snp.c | 26 ++++++++++++++++++++++++++
 arch/x86/include/asm/sev-snp.h     | 11 +++++++++++
 3 files changed, 41 insertions(+)

diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
index 58b15b7c1aa7..c85d3d9ec57a 100644
--- a/arch/x86/boot/compressed/sev-es.c
+++ b/arch/x86/boot/compressed/sev-es.c
@@ -20,6 +20,7 @@
 #include <asm/fpu/xcr.h>
 #include <asm/ptrace.h>
 #include <asm/svm.h>
+#include <asm/sev-snp.h>
 
 #include "error.h"
 
@@ -118,6 +119,9 @@ static bool early_setup_sev_es(void)
 	/* Initialize lookup tables for the instruction decoder */
 	inat_init_tables();
 
+	/* SEV-SNP guest requires the GHCB GPA must be registered */
+	sev_snp_register_ghcb(__pa(&boot_ghcb_page));
+
 	return true;
 }
 
diff --git a/arch/x86/boot/compressed/sev-snp.c b/arch/x86/boot/compressed/sev-snp.c
index 5c25103b0df1..a4c5e85699a7 100644
--- a/arch/x86/boot/compressed/sev-snp.c
+++ b/arch/x86/boot/compressed/sev-snp.c
@@ -113,3 +113,29 @@ void sev_snp_set_page_shared(unsigned long paddr)
 {
 	sev_snp_set_page_private_shared(paddr, SNP_PAGE_STATE_SHARED);
 }
+
+void sev_snp_register_ghcb(unsigned long paddr)
+{
+	u64 pfn = paddr >> PAGE_SHIFT;
+	u64 old, val;
+
+	if (!sev_snp_enabled())
+		return;
+
+	/* save the old GHCB MSR */
+	old = sev_es_rd_ghcb_msr();
+
+	/* Issue VMGEXIT */
+	sev_es_wr_ghcb_msr(GHCB_REGISTER_GPA_REQ_VAL(pfn));
+	VMGEXIT();
+
+	val = sev_es_rd_ghcb_msr();
+
+	/* If the response GPA is not ours then abort the guest */
+	if ((GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_REGISTER_GPA_RESP) ||
+	    (GHCB_REGISTER_GPA_RESP_VAL(val) != pfn))
+		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+
+	/* Restore the GHCB MSR value */
+	sev_es_wr_ghcb_msr(old);
+}
diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
index f514dad276f2..0523eb21abd7 100644
--- a/arch/x86/include/asm/sev-snp.h
+++ b/arch/x86/include/asm/sev-snp.h
@@ -56,6 +56,13 @@ struct __packed snp_page_state_change {
 	struct snp_page_state_entry entry[SNP_PAGE_STATE_CHANGE_MAX_ENTRY];
 };
 
+/* GHCB GPA register */
+#define GHCB_REGISTER_GPA_REQ	0x012UL
+#define		GHCB_REGISTER_GPA_REQ_VAL(v)		(GHCB_REGISTER_GPA_REQ | ((v) << 12))
+
+#define GHCB_REGISTER_GPA_RESP	0x013UL
+#define		GHCB_REGISTER_GPA_RESP_VAL(val)		((val) >> 12)
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 static inline int __pvalidate(unsigned long vaddr, int rmp_psize, int validate,
 			      unsigned long *rflags)
@@ -73,6 +80,8 @@ static inline int __pvalidate(unsigned long vaddr, int rmp_psize, int validate,
 	return rc;
 }
 
+void sev_snp_register_ghcb(unsigned long paddr);
+
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 static inline int __pvalidate(unsigned long vaddr, int psize, int validate, unsigned long *eflags)
@@ -80,6 +89,8 @@ static inline int __pvalidate(unsigned long vaddr, int psize, int validate, unsi
 	return 0;
 }
 
+static inline void sev_snp_register_ghcb(unsigned long paddr) { }
+
 #endif /* CONFIG_AMD_MEM_ENCRYPT */
 
 #endif	/* __ASSEMBLY__ */
-- 
2.17.1


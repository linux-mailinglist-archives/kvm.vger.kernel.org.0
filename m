Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA202D640F
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392953AbgLJRuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:50:46 -0500
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:9021
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392564AbgLJRNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:13:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P58n4UzuYk9QQLLji1HG8vI9DaGqrtPC7CmS2wyw4bZMgSWvHP6zQq8FTCsbzh0V8INE0BPTKLAZU3Tai0Yr7mo+9Qn4kqqoIXBuqSJ5djPrTYFIVAEPesWj1ekn/hDw5MrXy8wSptN/eZR3zNqCbN99NGikVeTcSEfkJxTDH0xUT61REHhhv7gj6/UkTZxC8O0RYWCsS9pVBYuTML40PW/wt7bxM1VZS59rvn3pY9vQ4GFCUkjoNEnQdWaIV04dk4Ao2z478DfkASAhf4IggQIVL0/WHAwsn1UBjs0PUMT3zxYemhTiqkx/k2iC3wTZwr3EW3ObW4xH18NE1xJnOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65vd2SCR7CxcVYHAZDS/7uCBTD0tZyJR+ANoP2eCmpg=;
 b=C+rpn0C8L6tg0WF/Ohidg7HAnsvgoCKrLcQMurF0B6l/yHfiS6rF2TrlYG6NciDqcyFEszDeGuVZ0yJXqp+sc5h+O+4IHMnCsWqaWybW1H+lwwCImF5zZEA+87Fbz/HdZTXBrr5jwOVfd8MCRB6YuoovAnMRd4qZnz/+j13e+ji4FZY+dMHICOrtPklQ+0fDjdNeyCyIvD84jUZXe70WaozCLtC94t62YnDJzWTkSVUdEPptlGjC+G/HLJRrCn2oxwBzkb97AYDhu725r+JoRDRrZ4gRmOcJ+SmS5O1iw8A54nuavjTiD/anVAFwY2B2XyTgZnMR5iVgtAGjKtGtSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65vd2SCR7CxcVYHAZDS/7uCBTD0tZyJR+ANoP2eCmpg=;
 b=eS2lGmOIYaXh2HnqkyETsk+t1/QpcJ1dpMz3aznihj16umvyPgJkS/msteFBuLblWjzOxuJqymm2n6bPOImrbFULIphVcAkg+Zwnh6z/md3ZCFTqLo9q7s38AoDeWTB2H/dst5dcmvVpuAMf0nMXPewrxhsBM57Lu35s2B7z4oM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:12:40 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:12:40 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 16/34] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x100
Date:   Thu, 10 Dec 2020 11:09:51 -0600
Message-Id: <f3a1f7850c75b6ea4101e15bbb4a3af1a203f1dc.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:610:4c::17) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR10CA0007.namprd10.prod.outlook.com (2603:10b6:610:4c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:12:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 74adb1e8-5107-4810-16b6-08d89d2ecd06
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0149F676839815B1432D33EAECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NPu2FGsHyzbga8D19s/bzNGeQtgUQTDvtZHyW2e7E4Fn8Eh9CC33z6MXD/Tanzh0L+DlQJb4VyvqbB3Ne5Bq/X9YQyhjpc2Q36yJD7+R/pywR9Mw0vv2GE3oNa4vs7DYPm2q1c8LrpTOdZVqSJfbQiT/R0GkGfq22idrssWWODno/QteR4nJV6Cgv5zzsnUvYYpi6JaTvALEjoCk+kxqEIDxRhjTCVk6p9WxnkT0uiAqzRYtL38O4/rIE1V1GPHbAZIhmeb2I1SABS40TTvUivQPkmsKgqBunOQSTywkaEXxhU48Y1CG9Mhmum5ERiC1gcBF8WtFtpkqh/j+S16Fk2n3dpbil8vuHkdoUcrCVMichrTe3WEUxXzS2uoQn47W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eax+bFFcHnWJnIzktXIEvwDTwFHy+1mQPqOmgxqLK5DpPzTyV4oO/9PqIq8H?=
 =?us-ascii?Q?3Pd9DVMVxJpsBNW2C048q2wy0szNnSGVIhEHfUBIYrguKhOMcHhWyPFeqF9r?=
 =?us-ascii?Q?egIn7TzVByerQ333sLYyEudgP9HE1pTxAGQq4ACuPsFhJVNLQzodFpMJaN0J?=
 =?us-ascii?Q?fdojnD5UucLyy4MlUTJHo41kYV1vUwLmupVCrGWmBPC8jKLkB+4Skx+NDwhG?=
 =?us-ascii?Q?CdGcJ0l7gFoZtglfdO4BJAOpFRsvl1fpn6tkZqdsdIc7v1W2fqQmdzuP66Ed?=
 =?us-ascii?Q?cUK4bZ10rtT1PDSAo4dAYxXJXd64PoDwvRLCto9z5qN2pr0+7M9PT0mwXA/B?=
 =?us-ascii?Q?fUoDy+y/T7bNnj4bJ66kHQw9zUTMlORe1RWGCOP+VSjmtUWIfU3Ll2l/pGzZ?=
 =?us-ascii?Q?BNOFS5Obuvc92BWaU2EZvdhago2D4wwxQ4rMilhbhdB3kG1ekCLiWxyGxS9G?=
 =?us-ascii?Q?BcnCmM5caJKSt91q/l3nZ1q1fabZMg255z+r+DKunSI4Enl6RXpYAKE2hJ/t?=
 =?us-ascii?Q?2/QTY0l6kf4so8gjY1S+wKxLAaxeGO+hpa2NZGP9tmvkoncfFZf2njyNt0TA?=
 =?us-ascii?Q?Um631QO3VzT+OLvzAuHCE/8IblA97XesujK7RR5BbgMrxT3l66yhTVadIBOp?=
 =?us-ascii?Q?GOhAw4SMiibvM4acJ/2O+JUuY8u16QflZzjdhSYvhiaiB5PXqFjOc54P596B?=
 =?us-ascii?Q?VDYAf1f0HIsuKO1rQ6EM0x7aH1Ar12K+RUn5jg/xQsPItgW7+5cGNSsk6yEn?=
 =?us-ascii?Q?y0KbSC4gbNwsuVaotIbeS1VaJtd/2orM1IwhPcNp49lgrVcllsn3PddhqDbJ?=
 =?us-ascii?Q?uBFa/1hFRR60jPIgfZliC+JfyR5g0O7eTRD7vAYB+6hLJhOxTuenz4vArevK?=
 =?us-ascii?Q?3MXCLigvoFLIbPfeI47yuviPnTEIdZ7h6ylr5xtz+KydV7/25uOfE6GDxTvo?=
 =?us-ascii?Q?AFseB4aWn7oeI2PEk4TFpdkDjMHgfwJMP1gA/MZILZxHXRsyLtvlvA/uWC0+?=
 =?us-ascii?Q?ZV/x?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:12:40.5010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 74adb1e8-5107-4810-16b6-08d89d2ecd06
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qOKsNkDEYRUGUtJbeO2proyL6Uuk4Vjlb8QqPzA3EZr2CuSU7mf6l3vhrLfhjOHEQ20oSzArZfa0oB+8zsMtnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The GHCB specification defines a GHCB MSR protocol using the lower
12-bits of the GHCB MSR (in the hypervisor this corresponds to the
GHCB GPA field in the VMCB).

Function 0x100 is a request for termination of the guest. The guest has
encountered some situation for which it has requested to be terminated.
The GHCB MSR value contains the reason for the request.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 13 +++++++++++++
 arch/x86/kvm/svm/svm.h |  6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 53bf3ff1d9cc..c2cc38e7400b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1574,6 +1574,19 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_TERM_REQ: {
+		u64 reason_set, reason_code;
+
+		reason_set = get_ghcb_msr_bits(svm,
+					       GHCB_MSR_TERM_REASON_SET_MASK,
+					       GHCB_MSR_TERM_REASON_SET_POS);
+		reason_code = get_ghcb_msr_bits(svm,
+						GHCB_MSR_TERM_REASON_MASK,
+						GHCB_MSR_TERM_REASON_POS);
+		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
+			reason_set, reason_code);
+		fallthrough;
+	}
 	default:
 		ret = -EINVAL;
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9dd8429f2b27..fc69bc2e0cad 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -543,6 +543,12 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 #define GHCB_MSR_CPUID_REG_POS		30
 #define GHCB_MSR_CPUID_REG_MASK		0x3
 
+#define GHCB_MSR_TERM_REQ		0x100
+#define GHCB_MSR_TERM_REASON_SET_POS	12
+#define GHCB_MSR_TERM_REASON_SET_MASK	0xf
+#define GHCB_MSR_TERM_REASON_POS	16
+#define GHCB_MSR_TERM_REASON_MASK	0xff
+
 extern unsigned int max_sev_asid;
 
 static inline bool svm_sev_enabled(void)
-- 
2.28.0


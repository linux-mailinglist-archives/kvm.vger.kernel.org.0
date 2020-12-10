Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CC12D6408
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392635AbgLJROa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:14:30 -0500
Received: from mail-bn8nam11on2055.outbound.protection.outlook.com ([40.107.236.55]:12128
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392618AbgLJROR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:14:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PoCJc2n18RixN97LKA+h7v+kpmLIHqrb2zA/+GW2GLic4WRVQsP1Uq2C56VpUmxclkQ56hpj7Z7DCoKlMR/2PbbqH56dH6rERO8q8A9JjElxs+WwXBZHqcfbcXrtPLF/uh+2jKi60KC45CmE3kbP/6hgCvGIw82iFBZan0gAodGjO3dbZjIEY7BEdKmEyuEOWpKfXnr9XojkG9mdXS/Gq8ZZL5CpR7kV1nuoYV/DWHO93tyFQg0EmyHIwlQrbXpgXoK0EmN/eeCq6sTkxdu7+aOpCU/LyMtf9rGihk4vTyxgIjlSyrEAItMpMxSUJx78Ut8/w4bf5UnoN/ap0tycLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VyVPVr88IIWm4PKBln0zfj5IfY+l/4IqCXXFghal0Ng=;
 b=E6xF+cWqk36SaQElySwA33xswRdtYE6SHn1SV/x40wTE9Q8ydxoSCg6Xhfesk04qvjdXiFiP1RXLysbJxUv77dtPcbRmLqN3HTLISlTVnZmkZNOo7xNMcxOVWG9UOdPBNuJjEioDtgEnDvI386nWOb+sEK3/uRfBX8NEQ4uoeTE7XaksIXBqSdP1DSSdD4SzbFs8vZhRH5QsYkDSKbPVIqvxsylDrXveJdznTQF1FEIG45NSGq4Y/R2wxmN4dczbT8VLbJJ70nqhuQ78q4YTpTfgJqujzcjmljsFowz60dg2QGacQ0DU97Yrlfq5Bm+Vwv44ko3ew6MB1L90y0hT4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VyVPVr88IIWm4PKBln0zfj5IfY+l/4IqCXXFghal0Ng=;
 b=QgxqgHTEPIR8WSd9FkGniAku4pFGCR+xzVYqm9K+4+m0sdBKgakj0PZnrtckdlt/3Wll5wKLJgUJQyPsUF/dbOL+nLfHi+Q0qnMg/58u2jGSDJ0lM4eqMQNFHWwmNF2k9z5SzFJXLqe55/FA7eMSbs70I3DNZGldRheJs5DqVcM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:12:49 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:12:49 +0000
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
Subject: [PATCH v5 17/34] KVM: SVM: Create trace events for VMGEXIT MSR protocol processing
Date:   Thu, 10 Dec 2020 11:09:52 -0600
Message-Id: <c5b3b440c3e0db43ff2fc02813faa94fa54896b0.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR18CA0023.namprd18.prod.outlook.com
 (2603:10b6:610:4f::33) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR18CA0023.namprd18.prod.outlook.com (2603:10b6:610:4f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:12:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3cffb790-d1b6-4ab6-ab45-08d89d2ed24d
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB01497F76CB75E203C2106133ECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M0GZUB6aDp+aK0aiuz479xS6cUNyXnO8YgTpNK7ICZfzRP1DsaxxWZri6uCAq79pjhzUWEONRyTPUvYMjes54OdVwHV0JcFKm3cKfffMx1moRTScHDBfl9xYNCMEtxRxMyUpCL3toCLLB0uzp74jVIICkmOGr8UwWH76+ti0FVURzogkGpi7QTpfWonQ8b7L0PdyuSLv4zRfNfDPEMXWd+dM2uEnkiXSUThxBFzky9fnm3Ug1FUDOV2ZxTipWD++dM/mS3NODP7+C5xUWcSGR3UEJZhmX+1iQFMKcPLqkbgfDlV2UWZUVm+5cqoI952u7LCMB8uWMjYkT9TWD/bahr2aK4rgg+xRWppzOvPp4MOctwWYlYuYd/7lWZvkGU9k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JNIbDF9ptgYYXpN/y32mytQX9b6sRjJ4+GqWQr+QIhzRtZvG9n7ErlkyJ4vk?=
 =?us-ascii?Q?PjPB0YgCPzmnht/L/Dh3tpD88Bw4gprA6iAkU3NavUXaqLENy0K1gzTSTpn9?=
 =?us-ascii?Q?TmlG6hY+nfZQfoP+GRmVpp7/Y9EIc9YPxePiMnc6eOGLDceo5DLAuu/NLIJ2?=
 =?us-ascii?Q?Kh5tBrvCLY6btnTuUIxs8fXHKvhceHdGg9vZB7UqW4iDZZujqEzsd0ka3B39?=
 =?us-ascii?Q?7QsuGHLCO0mdz9PIMlUsnP8i4X+8ck9GrD9nPALSs4QcLKe4EAxj2eIgVVEb?=
 =?us-ascii?Q?ktKhZTKZP3tiVG1n6D7fFc/a6SNl1TbNTL0kfCU4ee2FqpQ/PRu5qbnyJdEz?=
 =?us-ascii?Q?zgXgA3bsJolNGScsd2CJb32J+wTJ07utqAGbEAFG3JOSQ2POb6Kid1GKfOXn?=
 =?us-ascii?Q?tXdGrBAzDYLquyBE2ONdr+iwVSqXDJ0in14sVDrk6wMF0bH7RezNIcBNeSQm?=
 =?us-ascii?Q?hGeIAnILoPHlHqELN1yFu79cvywIAl3Hwkupp1p6kR2fRkj1fYKna7s/xFVp?=
 =?us-ascii?Q?u5xFW9Wtmq0Jh0X5vgavZtekMYEFIihn5XqKF4kx0PbDBoaI37mKTnp1oyUg?=
 =?us-ascii?Q?VOHkKa/u86ubs/0Hnot0pzGhtKAaniFrIG+9gSgR/e0H1Nvc0klov7oK/R13?=
 =?us-ascii?Q?BMAFBXnLuRxgaPtZh+nsBpIPyLWUh7O7WOYhed08m+aFqmiGwcKzWfAuH8DX?=
 =?us-ascii?Q?gnl33CmOcpKkI7pLcoXRwuMaz678BH5EGpRTltsuXULxzzo84OBfVw9zbF6W?=
 =?us-ascii?Q?0lGntF6SR5epEYokHppCwXaacTFang2WCY6TPjpEF3AGjJX/4PE9ORDNMSBm?=
 =?us-ascii?Q?+QoDHxijLuOlqfCXism+92KoHyIk9pTkmhP0od/ZYUqYE60FKvcbiF/Sp0Ha?=
 =?us-ascii?Q?RBldAPJlBjqOsf3hkH//yEbDsFiJGuQpi3KRXZKUY+/x8j8thEWOEsih7rxP?=
 =?us-ascii?Q?vQU1AlzYpBrMooh5S+b2xOMyS8WhLBe69gDITVETWVL9XVuTgSA7RXXRsTGW?=
 =?us-ascii?Q?BDwE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:12:49.4047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cffb790-d1b6-4ab6-ab45-08d89d2ed24d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SZ8QhLrS1jDO+TdxYS2agGq57EBR7TQN6CYFWWDMxeT7OmwNTtMUr401TKxM3/HTKvca2EKywEQZIBYSuCTn/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add trace events for entry to and exit from VMGEXIT MSR protocol
processing. The vCPU will be common for the trace events. The MSR
protocol processing is guided by the GHCB GPA in the VMCB, so the GHCB
GPA will represent the input and output values for the entry and exit
events, respectively. Additionally, the exit event will contain the
return code for the event.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c |  6 ++++++
 arch/x86/kvm/trace.h   | 44 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     |  2 ++
 3 files changed, 52 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c2cc38e7400b..2e2548fa369b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1530,6 +1530,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 	ghcb_info = control->ghcb_gpa & GHCB_MSR_INFO_MASK;
 
+	trace_kvm_vmgexit_msr_protocol_enter(svm->vcpu.vcpu_id,
+					     control->ghcb_gpa);
+
 	switch (ghcb_info) {
 	case GHCB_MSR_SEV_INFO_REQ:
 		set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
@@ -1591,6 +1594,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		ret = -EINVAL;
 	}
 
+	trace_kvm_vmgexit_msr_protocol_exit(svm->vcpu.vcpu_id,
+					    control->ghcb_gpa, ret);
+
 	return ret;
 }
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 7da931a511c9..2de30c20bc26 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1631,6 +1631,50 @@ TRACE_EVENT(kvm_vmgexit_exit,
 		  __entry->info1, __entry->info2)
 );
 
+/*
+ * Tracepoint for the start of VMGEXIT MSR procotol processing
+ */
+TRACE_EVENT(kvm_vmgexit_msr_protocol_enter,
+	TP_PROTO(unsigned int vcpu_id, u64 ghcb_gpa),
+	TP_ARGS(vcpu_id, ghcb_gpa),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, vcpu_id)
+		__field(u64, ghcb_gpa)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id  = vcpu_id;
+		__entry->ghcb_gpa = ghcb_gpa;
+	),
+
+	TP_printk("vcpu %u, ghcb_gpa %016llx",
+		  __entry->vcpu_id, __entry->ghcb_gpa)
+);
+
+/*
+ * Tracepoint for the end of VMGEXIT MSR procotol processing
+ */
+TRACE_EVENT(kvm_vmgexit_msr_protocol_exit,
+	TP_PROTO(unsigned int vcpu_id, u64 ghcb_gpa, int result),
+	TP_ARGS(vcpu_id, ghcb_gpa, result),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, vcpu_id)
+		__field(u64, ghcb_gpa)
+		__field(int, result)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id  = vcpu_id;
+		__entry->ghcb_gpa = ghcb_gpa;
+		__entry->result   = result;
+	),
+
+	TP_printk("vcpu %u, ghcb_gpa %016llx, result %d",
+		  __entry->vcpu_id, __entry->ghcb_gpa, __entry->result)
+);
+
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d89736066b39..ba26b62e0262 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11323,3 +11323,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
-- 
2.28.0


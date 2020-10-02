Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B1C2818AD
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387692AbgJBRFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:05:44 -0400
Received: from mail-eopbgr770053.outbound.protection.outlook.com ([40.107.77.53]:24518
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388161AbgJBRFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:05:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0eJ5OXEKMdMQSkTvRDbPrr2LnnrB7FP/09jTFngesNmg5cmxFMbTklec6ap3mSsL+Cv03F8ecDJcH8FjMBl0CnwC6WSRXFPMZnkzKO8DfG97vW/5tkXink3gJJfV/QGKj2ohv2DbLQQ8QaHMyjC1AAJDVhpHGSJy4UmvP7Y/DCGy1O3w+6jEfv6HEp3JCWBMkRkuFLs/7O3AtSr08Jy6BMnoJnJBKv81qKO36r5hLpg1d/LoacIV3GSxR8WTqyeHffJvk7uCeZen4JaIfyPPwQollDovlIUU83xqfM4b3uWVQiR67nr5jyVHEORF5/iFj/lAs5kLjqGSPaE4m3h5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZT/M+qZ+OhYqstSE84ZZk0ECX2J9qMaZ9uCe1g9fm4c=;
 b=kbNToZ9sxUCIEiEUOB2UZ6DZjhVGh1NGJy6/nNAD++v/KYZH14w5JBh1D8MkxdqD6GG6YQW2KN1Kpt3SzNG1o9YN8+VbZjHa1DRmM0vze+II94NQdLbSPmPiP7Ijhm/qX4A6FNEMPnFU7C+lCX6OHfwKhYRaJukI3IUi1AsSFE9SoOrQKaAe3Qg/rOYiSZzWcBVAT5vNSJYnIPZu1aZKwK9ollDjc4EPHKa8RE+9BHgYO976iZfTaILC79HK4z5u36mB7n1K9SVHzhYs+zwL5xtU9ihWOQJl8oSp6hcM0fFM2B/eXvi3ABcPDW9XUEEV/YfXsCQSvaOq588D702unQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZT/M+qZ+OhYqstSE84ZZk0ECX2J9qMaZ9uCe1g9fm4c=;
 b=P3vMHE5Y8f5sRiQH2YExtHXOd+LMtDSFTU2xdt84/r9FEG1NFjwCnHfM0sYjwpuwE4araSL8vLpziKPq4x7eymmLqLLis1kuIsv4RMoKgSSAWD8jdmrHaTF/zfCD+jIT+NXbSRHW/W5Watfv78thCn0L0epWtgAIYcywbxO9/Cg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:05:27 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:05:27 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v2 16/33] KVM: SVM: Create trace events for VMGEXIT MSR protocol processing
Date:   Fri,  2 Oct 2020 12:02:40 -0500
Message-Id: <bfa9fcfa893b30325698d3867c7fb3e48b804749.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0055.prod.exchangelabs.com (2603:10b6:800::23) To
 DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN2PR01CA0055.prod.exchangelabs.com (2603:10b6:800::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend Transport; Fri, 2 Oct 2020 17:05:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3cb07a2c-4804-4f4e-c21d-08d866f55c50
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB42188C7DADB649DCDAB7F068EC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IXiEsruDDo/yneOQ7CeOpZJFnarBoNsimUmZ684DUEdEKKhw7D+9dB7+TlBZ+e4BfR0HRJqZyP3tVdDa2pHV1vpKVWxUStU4rG/sOTM8dmKdwII3EnKy+YenwK2s9cUlrCqjCovTeyYCExvX1zjuQhzYKOjk8GgyeBGx0+2m9m8l0KNiQYnxQhZ12BBxqMNmf9xjpskuCZXviFOmc62mysG3+uR5xbwYmA3ABCY6N7S+nzVCdgxZWxXKNVGzemTzWCl8WOAbERZ1ezpk1kQsD7ZJdwjtRNNQjrlgEzUf8tCcZ9pXN+tsNYXLKnJsBcTl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iqMAlz28LHbcrb1l/xtvJO5KC+CvZ9ECF0Vt1cTJxoiv6orhp3q+l7lVspTUGdr6ET/RV0g3OSfquGvnJDyCfev4D64Kk8Lx3LUIDF5hBD/rTczHbuV/ncrP1LCzayC+/5YDl3BlWVuSSet02ZdogQF3CIki5f35QIKeTVHF3bkOeTyFS0JmrbWYhSqc2tRCTYTKyLco6GFnOGl3JNZieueaLQ9STZgtFC+9gV28/oxxAeK+/09aj4m58GD7lvmXM4UApXSk+x3XUcGmY/f/hYaVu7HWqD2jGmdb9tZeFzXUqIB+S2aeVjRpgKoBjXVGS3PNrGHXtZvrFDYiSl4YZxp9LP2cXvIjTmwKB1h6u9YWYtXiSnPJTzeUjpsPw58y3jFZacrWqGxYVVz+QGkJCU7s/Jq6fU30MXXL8r+J87J3y7He6Y6jd48PVbLJyxgeIuomFk8zY0XkeC+t76GMAIMtdY8QUPTn/bG7G5YHvxM9mCTyIOc3kRUJQFPIcB6D9rI8/LkV21S+apsBmgoZDI+ZVXClb5wzuCo+F9jQplcvXtesF5sq1JDlYtOU8tQXy3NMwN2L8j1CC0ykNeVjhQhqlhNsQ72vvkT75cb3vp9aGZpC9zeZF8uXKbUn8gguOLk5wkILmTn5mOZBlOngYA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb07a2c-4804-4f4e-c21d-08d866f55c50
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:05:27.7251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m0Myrdg/Z/H7MhBvDOItiSrnj8gQy4JwyAy5FH6e9KVCoQICkaFfsb8K8q0HE01D5OlmiHy3ud+zxuRByNwK0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
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
index cecdd6d83d9a..4a4245b34bee 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1438,6 +1438,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 	ghcb_info = control->ghcb_gpa & GHCB_MSR_INFO_MASK;
 
+	trace_kvm_vmgexit_msr_protocol_enter(svm->vcpu.vcpu_id,
+					     control->ghcb_gpa);
+
 	switch (ghcb_info) {
 	case GHCB_MSR_SEV_INFO_REQ:
 		set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
@@ -1499,6 +1502,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
index bc73ae18b90c..61fda131d919 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11176,3 +11176,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
-- 
2.28.0


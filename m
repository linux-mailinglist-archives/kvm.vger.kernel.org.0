Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224652696A1
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgINUaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:30:17 -0400
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:7038
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725914AbgINUTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:19:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dop4l3tSTWrWB6srqCRe/XS8f3q2V0siEIafH4+JN+a+Y8NCMKSJ44AAC4+CAaNnWnT76aufVr8S5iihdlB7IY44OmmoNvp1GT+7rbKpUifeful2/IiyE5nU3rUhfWwU3DqNjeW5qPedYsYE1mlLyX9j1vE3O47CsId75M3dkJridYOVA4/mWiR3HvvsqKu+gBjzFQ/FQxoKkMqfy17/jxWJtRDvxBI93t4yEfXzlbxXdmHUaZw+6CnoMDBqrKZeDYHg8BcztKXctVPCZcUcdpqc/BFgrHgyrhCVJ5FY1PZsxnLOEweBb4xU+avS4rjS4wkchYicQ9fOyqhwFsXihA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W817GBrQsy6weF97usiyU69QEwCZKsdf23gktrJU5io=;
 b=lBGcECXuMcP0dUJE3lqlyYquBc8kLULVWfFdWU5mlPpZtuNBIUC4wRg9QBADlJoQgPjS7vucEuw/RnJaMZQmY5A91k5Kcof6vDpShPaTufbbIrjF5CFhEfJGuiXEmv8YxrObhA9S+d5g7z8GRZ9jHQs5hTLHiY3P4gytEVzBCAW3YfXashijU7xLTtHxJ3H1yaE3jmdks00bpqYaNVSvcWeVWNoYgmYaTgQYSRNo16csxBD9lirOwl2IjiuuCLsYW8dDPMFbR/t5At2PgemmwRXgbkCesaLcS7642/IIVrvi9txCncLBI9hLyNZzYrg7f1KZ48MBWNpwbEW/bnsiew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W817GBrQsy6weF97usiyU69QEwCZKsdf23gktrJU5io=;
 b=A7SwzcfCkCjiqWeq44tKFqW5KgPauBG+rSjtv4BdCz6cE7Lh9cM2JfVDaJRxeaD6s76XF/SoPOk0/C7vN5pdol5EcHtXRVXyGezQSfO8jwG1hQhAXUSNeu6TcwMay03mPSgxNHO377tpPkF4lAdpBF95IYKzhN+TGwnBuapgCW4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:18:14 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:18:14 +0000
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
Subject: [RFC PATCH 17/35] KVM: SVM: Create trace events for VMGEXIT MSR protocol processing
Date:   Mon, 14 Sep 2020 15:15:31 -0500
Message-Id: <cb97745c4ff20b7e06088a75665d1fd17c6338a5.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0014.prod.exchangelabs.com (2603:10b6:804:2::24)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN2PR01CA0014.prod.exchangelabs.com (2603:10b6:804:2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:18:13 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f244b588-b5a1-44ee-b2da-08d858eb4f1a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1163EB07209738099C3861CAEC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BLcL87sADCSgUAyJRSW7wIZj7uCZEVHYApkxAEUwCpPC+bCP8hJOtTwNPeuAsa0i4I8ddzqSAdho/7HdBrt8cYj2+YzIJZncQV/JNb0rk0bkN6SnUI71UKcIgZeywWW2HLl1LGHgY3tZqLKbF01STQrt9+dziVT4OhSc6iT2VYMomS8ydH0X00k+jGzWslLSrTs36S1Ii5nB8K1X44Qn2jSu3ehsDCwMBle1PWG/T/u54pnaIhU/kKeBWA+5OOu4/HnjyZql/r6y9R/QsEHHmJioYktR/Qni7fj1P6fVqez0HQ1hYuemtc5IBqtuFwA8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8kxSAeJ8BOHYn5F5dbrfqm7gvztFg5Bzq0VgSIsbZR0yxWhc4VGLrFPC6djXnT89+br+3/W3t288M45Cc7Ibgjd998VFb2H95VelhO5KFcI3tVi5xL0pFrcrrA5uaqonFN7K4/BGyuzmEJbvz5t3R57Fe7A0GvELUqVy+99vEihQBEBAH9DLcnbSMgClPD8xBiT96tqSmEaJdaXXVTYTOqGHuf0h11KBc2IGg4UDuPCHTlqpZnMd1WeMMjvWd7/Y7P4pcgxIL1IhM4k64+K66jRUZ7Sx6QiOwnvAavuJ/ZMO8oXeD2/5HClwUeMy41arDJDeIBsqC9KzUX7Wimp+asq2LoZzEeYrRYygtntGT1IudfXwv2Jeek0JTz1+rLysMQmHBvIfcUUDn+qmlDkfFuhTZ4c+/kAlYEE9E1eMj9qqmyMOCVb7BjuOWagXhR5iZ85jXxVkSKeQGKA0y0Q0sYhYwenpbIIk4a8LBYElK1tyNSpZZtDdeeylz2h6POpGWJtkkrIjcsyir7DE86teCmi5DzA3XkkSLqG0rN0X4j8nEBVaOhR3p9tGTneCMk8ZGGWEVPAMZytbZxLD3LXd2daWHNJJST+uzxmv9+ajxfIBBspZPrNBiTVofH3ubOBP3Z7ld77V7pkVUARYVm9GRg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f244b588-b5a1-44ee-b2da-08d858eb4f1a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:18:14.2313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pc1iYXiDCvOvmYU7JH7e1JYP2mORkKfyBgmX1LIJJBrkYbJDSTIOMLyff0RDuN8vkiVtnHItPyGl3s/7rr2oFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
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
index 8300f3846580..92a4df26057a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1248,6 +1248,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 	ghcb_info = control->ghcb_gpa & GHCB_MSR_INFO_MASK;
 
+	trace_kvm_vmgexit_msr_protocol_enter(svm->vcpu.vcpu_id,
+					     control->ghcb_gpa);
+
 	switch (ghcb_info) {
 	case GHCB_MSR_SEV_INFO_REQ:
 		set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
@@ -1309,6 +1312,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		ret = -EINVAL;
 	}
 
+	trace_kvm_vmgexit_msr_protocol_exit(svm->vcpu.vcpu_id,
+					    control->ghcb_gpa, ret);
+
 	return ret;
 }
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 06e5c15d0508..117dc4a89c0a 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1647,6 +1647,50 @@ TRACE_EVENT(kvm_vmgexit_exit,
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
index ef85340e05ea..2a2a394126a2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10792,3 +10792,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
-- 
2.28.0


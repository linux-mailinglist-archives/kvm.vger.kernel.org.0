Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99652B6B42
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgKQRKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:10:10 -0500
Received: from mail-dm6nam12on2083.outbound.protection.outlook.com ([40.107.243.83]:57856
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729114AbgKQRKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:10:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8q615VAgWTY4rCYkuBKi69lFXmzzAjZsykAkiV1IQnEubOqmpY2Jr80v2I5FyLf98NJEX5V0AiIutGmxE9Dh8BM1szhRvYLRYMJ3sAJgPucsu3xBzbgNzyCUJA6WmqoQK47VUz22O58rozec/dpj2qawHynHpq0uqw8+qvaSEKpcItnpZ+41BbKlBE2I99HJpl2z6SkQgd1MWNx4l35rNuGT8IR8ihguDKcd14cwkYHn4IIhtuYaoA7dEehfbCuDeNp6LKj6Pg0GyffQPvSY5qNQHX7lnMeeGxbzMWs+Gyk4LydyOeEFLplt6iaM1VEFZINl1XsiWkOrRxBJz/fPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/mPRYtNF6XmgXwz7maagVQNsQ1FVNXGe7IRELi2c0s=;
 b=DcT5dl3bNhCVAHi82XPWiEbu59tkshTwGE/QPA8NEnTwiwmLMAwxpWQLQS+L+NgaqT1uKA+JvjBf5lxT0/vMEu8c06jJhzzMLe060cKm+zp4NJ37Hr7tUI+khvErblLLmQAo414RTDwDmmt3MLj1RbgIwf8kPtPs7FbfGbE8zgt0y4EIMBOyiKcVf8onL/PNpAi0uVW1FDTZEZXjn1PuKkV7GH1SxHKgrVBYwLKNihn0gUXbZDLOeOSDSO9w621shTHsaYQaMSRpaIg+Ut05z45ZhkxBQ1j/FgqAzgE0DQlUQdwdWOz0c5Wwf8o8fOvhJzVD4hyxF0GpKGTJg9W7FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/mPRYtNF6XmgXwz7maagVQNsQ1FVNXGe7IRELi2c0s=;
 b=t36stxOazKzsRASlcFuzerWivmOeAo1eyB4TD4ONfQYs1J6g64mBRWd/AKWtv0jLiaCCgRFd+oQynfLWoPejLq5i/R57OM6bQE54/VwVHIYWmCHmRA4shCRUFgNLSvJEEq3gJpBP89//IwFQHqcWHQl7puslXOdROeLptHD8D9E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:10:01 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:10:01 +0000
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
Subject: [PATCH v4 17/34] KVM: SVM: Create trace events for VMGEXIT MSR protocol processing
Date:   Tue, 17 Nov 2020 11:07:20 -0600
Message-Id: <b335eaa2c95cad14f133443dbd51c69dbcf6da41.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0701CA0027.namprd07.prod.outlook.com
 (2603:10b6:803:2d::13) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0701CA0027.namprd07.prod.outlook.com (2603:10b6:803:2d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 17:10:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8463cbc5-c2dc-475e-e462-08d88b1b9e5a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772877065C51A8C45B94C99ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wVvtGBZ33dqztn6zuE4s1kxY3Vr57jm3dRXwtDrItZZvzPozmZidcX/vjiuPzWVYzZJpQZZeXhPBdgi6rQKdZFr6CwwzEb6IfcrVUKwP8QIGpsdx/USS4WzxpTM4JeWymTuo0Se+tXBxZw1629b7DK/80Lawc4BcW7vhash4U4NafAiW7nFO9BcAulj5KjcyAWndGsvqFZ+mOPztjAz3cFdR1QyKLiMcSrnv2xT4g34oC7/QSx6tQDm2K3usQEMvh2+/v8sbOUL/sKVza+Snv8YbR1l34bvtj8l52YhvVBmWT9mSHfEMdvXhGK/Muxhq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oEAdQCj1ES66olB8Qptf8x36J7tAzhYunBUpfy9kN/ENhauYi4L/TDHShRnyHtHhx1eu3fVKOgsTxSrubYh41g9RbDg0Myg656NLJI2GvnFMDGkoPwKerkUu5wmQdpf8Xkn+tsJidHk/E+TbXMZ75a33nn/NuUJyDwaKdo1NUT5oa2GXBCyZhFVwNvFde0vmP9T5OLePx2iroqQjWafBHl/8tPMhgNOfQ8GjUsNO2Ff/Ik6ng9GJ6B/DfrSWoeI/rVx2loKhrNi1AhuJnGLaVcvZJLbslqAIujGIWho0IIw2lnL+dCHYu8rgxN68TJydtogRqbvI5nz5uAcgEza1GMfYzPuuUBAjpYgiv1Qs7OIckjqqjYehn9Fz1JcIlfStBPFP69cr83iDkxOoW+O98510Hxdsp0kA9zgL54XJKennCH2V6m8sw4UMeS/8mslCcINIQC4qbGHsJrN1o/TY8ckM739S4yutnbZjBCkJG2w3xd6/PZHfk7yvb4NdI9+wpWL373Re+jYLh1yhf/wWZD2NG82c5IkdI7/rJeYLWgk8fF6ry+PML7Ug12gNdJdym2ZA+tNrHqcbbITTqoSSIhGLmPxS72bQxX7SoWJCcBZkjpD/FAF0JUSo2dlxS3UeNaeT6a72P5+MQAEZdi3dfg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8463cbc5-c2dc-475e-e462-08d88b1b9e5a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:10:01.3028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OdmLjTgjQs/vG+HsUblK301R207BiNgBlgwKZYEVC7yiLxbec9y0vuo2NEXWCmkHJZQ63TMEAWEkMFTI//CbLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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
index 1f60e4ffbbda..7b707a638438 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11290,3 +11290,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
-- 
2.28.0


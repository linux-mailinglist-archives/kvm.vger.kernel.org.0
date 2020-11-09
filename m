Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8020A2AC878
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732093AbgKIW2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:28:33 -0500
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com ([40.107.237.72]:34044
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731332AbgKIW2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:28:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfirdPwIUBj+olxZ6XAkJe8tJV9nu1NvqnUvZl5a4udoTpUZXnCGqEreV55TDcxwU+vqOJ1uXxwYscziXEc8xpq7O1C1Ma+x1I0PqqEMunKv/famRxSlxg9ZNzjPxptHms4uqANVrLFHzn48rEz7tMtKsZ2l2ekX05ZOIQjpQ3vgQI9n3oRvT+BNhH1Du07DDF+ir/J1eWY8vgbQDUKrmIJik1o00WBodBzqUyKZtJiJlvHXA4pw30js+k/7auaQivE+VUZ/aS8lxiiwk4hbusY6DicjbWDI+s9tLyeqnsRC+Pds/U1VoQ3pHJlpbnFsMdGFR3wlzdqTHiR1mTzyMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7avQOz6ju5Xzc30n8mG9o2zVpqn1dzG38JUXpjlDSBk=;
 b=eaAYzDohKNAwUPHbnGy6AxtxQO4FsfItorRk2w9D2062ygl1lWFrUEdeuqdbjd1xXzhIOT1wAhTutPyVgGKfeaN8khgxr3tWMxQQaoWIcf2qFBfZ1oDqn+ItleUM2DDIlawCaAQAcOLWIqLKjYFRosmssUIhjMnfGlZiuXwzZndbe8fM+VIQQuY2EgKPHeMMp4EROJ/z82wNWUM+bTE0t7x/OdS3w3P5TbmZZHeueHsh5Nr0MdsXVsOiUFfRXItKFMPxXIO4KE4v9v0m9W78hEt7uBMOnyB5rHu+vDT5HHVrFRJmPh25H6gnxD4MijAMWDpFgXQuCUvSlVtJ8egdxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7avQOz6ju5Xzc30n8mG9o2zVpqn1dzG38JUXpjlDSBk=;
 b=AIAV8eo61DxYyhoKsaDaaUc9gxp4WatvLEuqQccQQn1WntzFb/qiWQ66fjltW/uHrQZr1eGfHwa/rY/DJ7GY2B9VtrC78UsFKS75kldcNOziQluZJijm84Is7N8JGKe1H8mSntyqnNur+aWzBHLl6wW91/CHR1NCLnTSpewpVV0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:28:29 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:28:29 +0000
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
Subject: [PATCH v3 17/34] KVM: SVM: Create trace events for VMGEXIT MSR protocol processing
Date:   Mon,  9 Nov 2020 16:25:43 -0600
Message-Id: <53bb01b4817c7a84f832ac0285f7e032a752ecc6.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:3:d4::25) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR05CA0015.namprd05.prod.outlook.com (2603:10b6:3:d4::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.13 via Frontend Transport; Mon, 9 Nov 2020 22:28:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 96f1a16c-b0f4-4773-6478-08d884fec863
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB405818FEF4418A3BDEEC3514ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HVo68l3R1EpiQRN1sYW4cLX/t8kmZwwZTEN8/LBaviy4/VScKztZZ/RIMvvvlUppVHeKIec5XEOF537fhQTfyDb7EbR7jViwlx9PZKCD2bfTLLWIAssC2sLO6viXF8WqapDqb0Vp1L67HvTXKKvmQsmGDvu8lbNkBGcJ2ggBZ7BGZq5gHOWlnFeI9LjvZ51b4HsrLy1IBEMw2xuGy2YOgaOTlWpas+hSpbPWFYbesfMYJYF5EbzQ+YYarUczLZ072ZJC1iPP/vaJXTE1YdLbrXjU3f2sOFU4qZ0kYrB3gbN8NMRbf65gNyP7thL4prfP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: I+mqbWoxM4CyrTtfEL8A2JxEvUktI/w1+gpS3EDamigg2enLHpjgolH5vncwLvELm2fjiPH1w10i1l5Ibt4Q+EN321/cSTB8cmG7Y1dVfTba1x+nmKLitllbQIfKEDvwk7XJZKrLN7XEVmKHUeExXfXA62EzrI6IRYhiJDMKpYDPyQoXW2jtfihXJZJcHyFJiMBXi4Ub4Q2seqrbsnrlklpSYrJX8YUbTdlT3w1QsnVKs7nb3lb/Q6X8N+gpzmkvkgOkWDXp0/BX383PoDClwG1yKFdnuSb0BLdChur9VRN3d0dVXu9oxYfNB8UOrRgbYRLpbcQYk0FjYBcix8RMRwNAkdOvdKJVX2ovVytuTNllZP4+dh5wurjEjg7moBRgvIDAQW7T0mUMgLQ8m9FfGSh23AJ5aKV22KL3YlN3xWfa6ogBg0SUQw85IgYObzEPcv4eEGqJ7hThKceQ7zpCfh3t+VMpPHTm/03H7xFSCzNbGfqp4PYpIXgREESvpDx7+ysrCU0RV+7UL967u0hl/ZH5RoDaLETTt5jFzSSF9RyK+TCI2i0iRp4WqzV2u1DW7FGUWZlij56SgNRS9J5PjfRFeJAwwzcn7hG53F2myxdrIg1n1vRmxfhcpuQ1IExn8fFQZcoC8gl2bQSLknqq7w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96f1a16c-b0f4-4773-6478-08d884fec863
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:28:29.2851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dosdu1/NZ35BKuM6efvQKyfAPKcp2kA7cKeRg2NvvPQ22nhshVGTxmUk88zkDz1uGeSffdLMoA0QLmDDeaEZuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index de8501264c1c..50081ce6b0a9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1527,6 +1527,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 	ghcb_info = control->ghcb_gpa & GHCB_MSR_INFO_MASK;
 
+	trace_kvm_vmgexit_msr_protocol_enter(svm->vcpu.vcpu_id,
+					     control->ghcb_gpa);
+
 	switch (ghcb_info) {
 	case GHCB_MSR_SEV_INFO_REQ:
 		set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
@@ -1588,6 +1591,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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


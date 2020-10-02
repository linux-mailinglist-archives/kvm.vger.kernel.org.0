Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF3B2818A3
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388405AbgJBRFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:05:24 -0400
Received: from mail-eopbgr760073.outbound.protection.outlook.com ([40.107.76.73]:5358
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388410AbgJBRFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:05:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksYrnxxiDXuoHFSN0HCf5vGzuLWIIHta2p9TRRQmKKXurwNnpuHzVWZItTOlCh7RMBRxHLjdUWJ8kr+XNJRqIan3hd6wVxuLOcQxhcfS+DvNOXRri1MmiiuyvPDOooiL9z/wU1/catOE73jF5ze//0TXE2vx691Oh6jnxUlGpUFDZURO7JfCZpU476jo+fX/3HB8a8Vyujjp0oiH9di2/TuVKQemCPvwYNEcmjYiRFHbxFZvzG8tdB8T0LXJdUwvRqRYyEfPniOBq+0NKzAwmZYcrVSZtwUVelsG4zGFeNfMV4MJ3JshII1qWgNuZo8l4RM9NZPm8zqpBu6lPPCT2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=310Sbmzcy3d4gW80n4hTfQljlW6qMmagXJfJVtAc+ic=;
 b=C0Ukiwg36ob93yX5Zu9XOuq3z9M6qjBGD24PJidI1V2G0mlREkjsThQqnyrazUclU2SgkBv7SSPGmH9ILRjNoy98D1QVuOXVjK3AwWCnudDSSJoICSJq0y7bIt5WM6ceq/l1DvVLHD55WAG3Djaqtns634xUS99lKkBvMJ1li/356aIAavjfxObjyU38cQyU0fk3QxotJlIOHXxJIRLMdaVdrzX3OKw3QS5WRt8V0+lBRV2AfpxSx6/Q6rHEo5dYrOmaSP12Zz/gvGTLxvg1Ka3iV4I2qnlZGd+xnfqcNuIzTQYTr3DvFRLfmy5nuFMK62w+ZHsJz7zABxMmcT5I0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=310Sbmzcy3d4gW80n4hTfQljlW6qMmagXJfJVtAc+ic=;
 b=ynhTJgKJvL2nMWQ1veS4Xl01qvoGBnGLnrqez4nsf+a29bUMkLsfLfPyc9ISxRziH7Kc3oVLiv4m3r6D7ny6qhk5QzMMzW+zamnE4VvI4Jm1uKT8t5InUYq40u15bkVVOJbIk1ZEnNCjwgf+BxakjUMIplSDFeMz9rT/D+BD144=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.38; Fri, 2 Oct 2020 17:04:54 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:04:54 +0000
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
Subject: [RFC PATCH v2 12/33] KVM: SVM: Create trace events for VMGEXIT processing
Date:   Fri,  2 Oct 2020 12:02:36 -0500
Message-Id: <b7082c10c6bb70c737555615bfa5fcbfdbbc4dbe.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:806:20::21) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR03CA0016.namprd03.prod.outlook.com (2603:10b6:806:20::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24 via Frontend Transport; Fri, 2 Oct 2020 17:04:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6d5335aa-f80a-47e3-49af-08d866f54856
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1706F5EB630BE56007E58373EC310@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: deQ25nsWm1+HSAyLvXWDbuciELozztgy0HXqorqxdMO7d+xYQq0D6GoVoZZWeMZ98lSr5BxXv7aGs/554XcsNZ2iYh29cv3xijeOxQtJgpdRWjb2WfMQ5DtT+GBkhFd7hSSthRTfiug8ME0OXNv/GztKOKFq6botahooAbXfzU6GsFauJYlhSaOjC/amYZsyyiYGirRXpPMTWzHi7M2g/UfsUYHXoSaVnkjjTlWFZ10MTvAxihJAM14RU33a+yIKbB9iIIQW3zaNbHrlbJ48NE6zZLy/+u/InFfQD+dcs9woNeD2p/DVysUQW5kJH9Fr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(66556008)(4326008)(36756003)(66946007)(86362001)(2616005)(26005)(8676002)(5660300002)(83380400001)(6666004)(7696005)(8936002)(52116002)(2906002)(6486002)(478600001)(316002)(54906003)(66476007)(186003)(956004)(7416002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ut6Sm1B7nYOzkULyv++PjI79e3hAzLTJQ4R9nHajMJFVjnwgf3CHsJRvWrNto+udgoE7ormcLGI39wk2Gwbm503xzdykXnGqwZYiXx0S1kuNHdL3TrHcUIBRIKZSrW/Ej+wsWOWJd2jshsolBGPRxKw+jb0CFjtD2U9/7t9pn8p2Tczley58G4bx9DCT41IcG1AJ8IKi9fophS9P0JHoh+VjTgEBOU8AjfsPr4EQTjK8nehgZ3WrMxpk3OYcU54R5RN4yRLjnFlWSuE8uziN+6iVL2Oo46ACT5g49fNKoUaGL4EkM1WR1Dlx0OTky/PmiaiRhkIidiJimJsjy25XHumt8Xvp+vdGXvU0BNz3lEY7fvWCDQHvJQCGcBYhcHXxvBxBB6vw+GkBXwCmRBgrrhm9OG2UpDw6ZTEsOYWy8PdzPw2qfYcgU5wyRtI42wgjPxoWTLl4cmAqU/EyJ0fYkl2/yMckWjPymrX5kNOcyz2FkKo6g2gGehSzMBw0gwkvloyjNMM62bFl5efIOmvk23hGCnuvwoHUTVK7klRT2HE3clFH+ih4CZxQAWwDfe2sWsPp55xwInwm7ce4eOCoIGlFJnq9Ip4bz5Mpcz2VhqADS/E+IM+HdS4I44Ixi1Qiae/aVgvP0BJ/j2sjphC2DQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d5335aa-f80a-47e3-49af-08d866f54856
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:04:54.1619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: US8ZSsm6//+plvNp0fHOjjqLV/t08e/1bBlP0UDvucSEsbQ7rd8/ebH5rfEc9s0zBn3Q4DxZRXgEEDVM4CqxbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add trace events for entry to and exit from VMGEXIT processing. The vCPU
id and the exit reason will be common for the trace events. The exit info
fields will represent the input and output values for the entry and exit
events, respectively.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c |  6 +++++
 arch/x86/kvm/trace.h   | 53 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     |  2 ++
 3 files changed, 61 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 06a7b63641af..500c845f4979 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -14,10 +14,12 @@
 #include <linux/psp-sev.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/trace_events.h>
 
 #include "x86.h"
 #include "svm.h"
 #include "cpuid.h"
+#include "trace.h"
 
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -1372,6 +1374,8 @@ static void pre_sev_es_run(struct vcpu_svm *svm)
 	if (!svm->ghcb)
 		return;
 
+	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->ghcb);
+
 	sev_es_sync_to_ghcb(svm);
 
 	kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
@@ -1436,6 +1440,8 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 	svm->ghcb = svm->ghcb_map.hva;
 	ghcb = svm->ghcb_map.hva;
 
+	trace_kvm_vmgexit_enter(svm->vcpu.vcpu_id, ghcb);
+
 	exit_code = ghcb_get_sw_exit_code(ghcb);
 
 	ret = sev_es_validate_vmgexit(svm);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index aef960f90f26..7da931a511c9 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1578,6 +1578,59 @@ TRACE_EVENT(kvm_hv_syndbg_get_msr,
 		  __entry->vcpu_id, __entry->vp_index, __entry->msr,
 		  __entry->data)
 );
+
+/*
+ * Tracepoint for the start of VMGEXIT processing
+ */
+TRACE_EVENT(kvm_vmgexit_enter,
+	TP_PROTO(unsigned int vcpu_id, struct ghcb *ghcb),
+	TP_ARGS(vcpu_id, ghcb),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, vcpu_id)
+		__field(u64, exit_reason)
+		__field(u64, info1)
+		__field(u64, info2)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id     = vcpu_id;
+		__entry->exit_reason = ghcb->save.sw_exit_code;
+		__entry->info1       = ghcb->save.sw_exit_info_1;
+		__entry->info2       = ghcb->save.sw_exit_info_2;
+	),
+
+	TP_printk("vcpu %u, exit_reason %llx, exit_info1 %llx, exit_info2 %llx",
+		  __entry->vcpu_id, __entry->exit_reason,
+		  __entry->info1, __entry->info2)
+);
+
+/*
+ * Tracepoint for the end of VMGEXIT processing
+ */
+TRACE_EVENT(kvm_vmgexit_exit,
+	TP_PROTO(unsigned int vcpu_id, struct ghcb *ghcb),
+	TP_ARGS(vcpu_id, ghcb),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, vcpu_id)
+		__field(u64, exit_reason)
+		__field(u64, info1)
+		__field(u64, info2)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id     = vcpu_id;
+		__entry->exit_reason = ghcb->save.sw_exit_code;
+		__entry->info1       = ghcb->save.sw_exit_info_1;
+		__entry->info2       = ghcb->save.sw_exit_info_2;
+	),
+
+	TP_printk("vcpu %u, exit_reason %llx, exit_info1 %llx, exit_info2 %llx",
+		  __entry->vcpu_id, __entry->exit_reason,
+		  __entry->info1, __entry->info2)
+);
+
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6b9125f49ddc..bc73ae18b90c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11174,3 +11174,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
-- 
2.28.0


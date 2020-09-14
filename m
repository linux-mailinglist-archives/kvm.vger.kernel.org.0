Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979C22696B1
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgINUcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:32:32 -0400
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:7038
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726198AbgINUSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:18:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SL4xmqtbUJuOobCaupd7cVaHQC3JVa4mxojOh3PrRqdXLPS2TrRoD0jXxoRM2oukYvd76tUo79QU6ZSiOXE3IANEHqcm+99EcVlRveUprHAks6zXV/WRQ4unyvIjraDJujdMimbZKKk/BkWwsL6HLdwUWWLNUSm5v8ol4lgqZzvlZw+aAPXYmbophrnuRI8LjHsua/0/Im7dhCWqxyety7j3a18C5nZLIrOPQ9zV7qhveFV8B3y1XaQ+O2HQfEk/z+zifXpBRjSK8czpKplobo1TxwXTwut9s22vmdeAXuT7UcLKntoZ/8b9EqPC/+wFryDAXPsNCbvn1Ybm+L8a7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrG9QiFSQe5yeZLMvzPMw9PkYBtJ1V5t2I+SYppvbTQ=;
 b=l21mNYs45tdFCUUmPwYTx5VBg/618Ie4jqM/W5hSZmuOcnamBoMefTXTjbJXj90weYUKIXJwfIhBulqodYVQDOyWgYDG2Oc5pAdnKWj3aVc5gKzehKZm95X56MftgMF16Uhky8s2iUtZGFW6XH/Q8WxZMPAAwBJqb/89HV4e7VNoOvfszqcU+nKJfaHRYgDi3ieFvl+/oYKY5HXSPcpisjoiE5XF+5bOB3tZEaJLR2FsLoWBv+wlD8+t/1gU9O2+HU4zbKQ9G0Eqer2JHepNLBNGO4XzgVjObSwsFdAuQtmAq+QUQsOyHmwa5EzWfQm34XQFs6fIfxH6kK6xb0nOrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrG9QiFSQe5yeZLMvzPMw9PkYBtJ1V5t2I+SYppvbTQ=;
 b=esv2Z5WiUg7HAg4P9Ohd2teDnMnfGQjN+lIqU05zvhd+hgGcNHXCUxIptKP6+xfPH5liybTeugLs3WSENhOzb5Z42aZse+Cu9OYmtnTjf0MjRvixKrHOMFcZqa/yCyEZdk3oAqUrWeQWllmXrnJGnv8nGWv4BqgHon6TTZuz4r0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:17:42 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:17:42 +0000
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
Subject: [RFC PATCH 13/35] KVM: SVM: Create trace events for VMGEXIT processing
Date:   Mon, 14 Sep 2020 15:15:27 -0500
Message-Id: <2d3976f1daae326c2cb7fd15f1c7ba06d7f4c525.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR06CA0072.namprd06.prod.outlook.com
 (2603:10b6:3:37::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR06CA0072.namprd06.prod.outlook.com (2603:10b6:3:37::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:17:41 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 91d46098-b57d-449c-ac93-08d858eb3beb
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1163523880F2985FDCDD0C17EC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kl29/JZnMuSaw5Yzt21+0W9gEXHvT0qnMCFTiPgLFnUOHuldq8X11QpEVOWuySxauzzR8J25aveq47JJyjfIfoSsYHtvr7YO59LderCU+3LEFsHJWePjr/UaB/A4PQOktDgfPuUJvqxZSheFJDHjQAH+Ati+B/v0iqiZWsMS2shfbXR7ihiUgBA7UmnwGR93CCj+IS/ZMEmp/ZocCwWPRQPWZQr32X9BrKlUkEi6D9D2UZuWZ35eXC2bcr0l+2t1iixPoVkW/Kbyu6wZKoc9FhODvZYsL/HF4bk8NUWRBaV+F+xUoSmo5z5KKoVo3p7i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lfuQ19JBrLk4TyCfzrisT0ZSypIE3fEnZX1SxX4CmkEvLZvTTOMVJcu4GEneVrT2vJUGy7VgFIxa7JVtT9i0LFQAlc4qSDaKrp0T3qon0nz6XcvowHjKjXpfE095WwpOQ+5dlLRLiP3YCj1Z8TPIS23/nB5HEN4Thk17QK0onC+iXL3vjWkh8tzz5sGuF59gvGPsdIiGy1mw4IE8MmgJz4wKPrDP6js2nehWH6//BNiP1BFu/u1u3InngtqHe8amT+LEdGJJyDqAPSHlDUt/AxyaJnDVw/UxP2q19lfzTLbe0aBe8kILevwIxKBsP1mFDxJ8z6eizDFeZujdVpx+Jx7eNjQRvwdrXDfkCommM5Ey94Mf4m3YwnxHp/MUONp9AeOxKCOtryfj6Xoonw9cGOS7LX99ahPwayMrkqxOWvrvkt4+6hw0IZgRNFk73gerDjIJyuXx9aNhf3x7t8VwOrgiHMJjAd5qxXdWpxLH7gdO5eLTiYBo4u04un+2yRZjUn+8E9Mk73TBzF0uNnZSHhLYpK9Ap7aww4McrrEH4Bx0/VMo16zcOMVXee6U8JaVjY1hUTpR9Wfcd08BQR3wMaaXo45cPYkOc3fN7bnj07bVHu/S/5wgx3mfP7F7PzbxTQ8DSbE+pdvz2UpPpOMY5w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d46098-b57d-449c-ac93-08d858eb3beb
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:17:42.1313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NiHWx6Koe7JIqmaWKE6ixBcVFMhCYG6DCA6gLPvFX/Tbxlvw3bTDkTrPAxWAWu7vhCGDi1IKsqkyLbirFAwK3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add trace events for entry to and exit from VMGEXIT processing. The vCPU
id and the exit reason will be common for the trace events. The exit info
fields and valid bitmap fields will represent the input and output values
for the entry and exit events, respectively.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c |  6 +++++
 arch/x86/kvm/trace.h   | 55 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     |  2 ++
 3 files changed, 63 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e085d8b83a32..f0fd89788de7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -14,9 +14,11 @@
 #include <linux/psp-sev.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/trace_events.h>
 
 #include "x86.h"
 #include "svm.h"
+#include "trace.h"
 
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -1185,6 +1187,8 @@ static void pre_sev_es_run(struct vcpu_svm *svm)
 	if (!svm->ghcb)
 		return;
 
+	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->ghcb);
+
 	kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
 	svm->ghcb = NULL;
 }
@@ -1246,6 +1250,8 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 	svm->ghcb = svm->ghcb_map.hva;
 	ghcb = svm->ghcb_map.hva;
 
+	trace_kvm_vmgexit_enter(svm->vcpu.vcpu_id, ghcb);
+
 	control->exit_code = lower_32_bits(ghcb_get_sw_exit_code(ghcb));
 	control->exit_code_hi = upper_32_bits(ghcb_get_sw_exit_code(ghcb));
 	control->exit_info_1 = ghcb_get_sw_exit_info_1(ghcb);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b66432b015d2..06e5c15d0508 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1592,6 +1592,61 @@ TRACE_EVENT(kvm_hv_syndbg_get_msr,
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
+		__field(u8 *, bitmap)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id     = vcpu_id;
+		__entry->exit_reason = ghcb->save.sw_exit_code;
+		__entry->info1       = ghcb->save.sw_exit_info_1;
+		__entry->info2       = ghcb->save.sw_exit_info_2;
+		__entry->bitmap      = ghcb->save.valid_bitmap;
+	),
+
+	TP_printk("vcpu %u, exit_reason %llx, exit_info1 %llx, exit_info2 %llx, valid_bitmap",
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
index 9970c0b7854f..ef85340e05ea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10790,3 +10790,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
-- 
2.28.0


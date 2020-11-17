Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4BC2B6B3D
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbgKQRJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:09:44 -0500
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:3169
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728944AbgKQRJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:09:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9RfLdfIlapbripApAlPCRkOF9PUA7Otk+sy7r3U7Lt6nRo5SfHLNdp7jDkxXIHelut7YGlrvlgJSwPg+Rp6kyd3r6BAGsI/aXzYXisG65PHKYmeb0A/+QiJsco3ZpbSj8StJZm+ehN6HFK90eV5qFR5lYk4pVZoD6ppnDJcWtG92H+DX3iOzg7c555ZYwesYAXbYIdx4lKj0/dkp4Y6GfQr11Aq2bCvJGqlgIn7Jz8KvMkRttnuDzt0MIUSGzqr4EPCszj8Ro/6zgSpsVQ9JdsvUgx7k3Rtk4rd56owyFE+SMxa9UinKBcGfMJFKAbxAxzC5ngffaa73Lkb4GSzNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpL93RDMVQ5VVJQJRqx9zctExwZjUDVhC3HjdRdbIoE=;
 b=Nd24bUsyy/IyZo0PYrpthtHWnFc08JBTyg9b5k2mRXh4OWQ/Zfsn1ph18xvxRxCmFizeF4AnYaz+SHeZUbe96lJgvc+2dnJAGYoe0xvyVduVOqGMgJ6ilpj0oTfeLRU870nxsKfsX0b1Q6zFIIgepxsyBzz7bwSphLskHSKmidBi7zn8rMCQudz+1jnMJTd6Y9818sWUtN1CvSmb28ht1/ROR3EBcH53ttkkURjP+Kub9mdMc51LOP3E82ONm6Q12pdR1Cmlu+qmEBv7NjLZrEqivcE5s7pFk/+1n5l/F6IPLx958wDrJfLdqoPT+2QMXgnjqY3ju3qg0hDn8UFUGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpL93RDMVQ5VVJQJRqx9zctExwZjUDVhC3HjdRdbIoE=;
 b=Fzw1Ghdb1zf5vnvhKCcJrHnMUGRF7y7ZDB2aLvqoALyB3qsxUTUjdLfjSXAWqhJpOiyvpteFEQ90dXmMvneQ0fYUmmlfvNzooTKM+VFuwUSSK/PawwW8DgVwUi5tEahHWeO5sg2cyPCjeYn4YfVLYlE1vxg8ZEH8HNUKvLJ/pNk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:09:30 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:09:30 +0000
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
Subject: [PATCH v4 13/34] KVM: SVM: Create trace events for VMGEXIT processing
Date:   Tue, 17 Nov 2020 11:07:16 -0600
Message-Id: <19bc69ca75a37a7d0ed32f59b56a989674d8a9b9.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR17CA0017.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR17CA0017.namprd17.prod.outlook.com (2603:10b6:5:1b3::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 17:09:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 28cddee8-fa11-4011-ad81-08d88b1b8bee
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB17725FA3274347B5AC82ABB4ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LyB9ZnjWdc5EjEeWeFH1SsP0UNSCUEpD0nagtUe24iFD+m+TUT+VO/ip3w6iIlcwnHxU8cj3434N/iAxKnmP576V59n923xLX9u48qDENelZMU3EdcXxnkaW/uwMzLXjAtf5wSg4XTN/RKMaSTdTqzvk4GB3xjkIQO7pu34n9Xlz8sOoy2vyAFp/rqoLCgrApv7cKi7o9K40OGjqyoBMB4+zztsyEiQ2YourkOYLQW2QVP5gNwCijG7zC5oHiCqbU1FwZFqi/TFxwuFepVpxjUYJHDnIUgzm1x/1NdQ3ucKQbUH2DKEhFXmAufOid7f0Tz6YMft9bQ6X1Z2UNQ2xrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OfsZQoTWeTScdqhe18ESEHRZpUdQhwLTB9APalHwQEx+p2J1g4aJPyn1JZKJnF0Ya9bmKMkmo5ZKJOvdDsOXiTX59VrhWbe/APxQ0Jzsee0L2bXt3J/X0RASHIrVSNxOtfLsoojd/agswlwU7YMfhfiq8I7ZwIiIjUFP0z6d1dqSgmeIiqnkZ0PB06iKRzhlZ7/NSt7o8BOhZQritK4pmN9TgqNMwAF7rzzF3XFNk0jY92GtHGPf8D5s/lHtPcdgMT+VV8HStYoNp29//eBmeTcWPDHfjVwXKuvQgacNqJjXEcgNsyVeUtbGm8IpvuqbOD0pG5+Tovos/W9VSeBkYon5Ln+Q5VIkWO0wrMWqNsx3LUY1rv/1Rn3+zwHdKp1bv0mmgyvo/MsgVU4vMZD4eSxE78n5gUVvphi2uWnVFdArXB8piyage6J35R5TXIHPnYUFQUCmiDi8t7nPp2S2m4IQ+qPkqBQhOFn/MghsrZ6+ROTL+TQah251bTt/p5x5Cy1zXbpAN4m79EVIM7PtFhs51Kj+PuawkIRpBrGjQM2OYSTRYgcvduuSm2/eF8gSTZlNa1wqOqJsxRbC3D+g9crYayIdqrI11Xi4myd5i9p00uAI/MmKpe9N5Qd6oCVqxpgsimhXDeHTjrecbNu0og==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28cddee8-fa11-4011-ad81-08d88b1b8bee
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:09:30.4526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oNy1ltguEvHfVI6wvn1DGCWGYxUxgta0zvCiPrK/mlTDo7MzLCYvjDCH8sAdOsNm5ZgLlg0G5ITrA2Qusu7x4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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
index 54e6894b26d2..da473c6b725e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -15,10 +15,12 @@
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <linux/processor.h>
+#include <linux/trace_events.h>
 
 #include "x86.h"
 #include "svm.h"
 #include "cpuid.h"
+#include "trace.h"
 
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -1464,6 +1466,8 @@ static void pre_sev_es_run(struct vcpu_svm *svm)
 	if (!svm->ghcb)
 		return;
 
+	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->ghcb);
+
 	sev_es_sync_to_ghcb(svm);
 
 	kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
@@ -1528,6 +1532,8 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
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
index 569fbdb4ee87..1f60e4ffbbda 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11288,3 +11288,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
-- 
2.28.0


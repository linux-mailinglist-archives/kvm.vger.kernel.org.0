Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3983182DEE
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 11:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgCLKjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 06:39:43 -0400
Received: from mail-dm6nam11on2042.outbound.protection.outlook.com ([40.107.223.42]:65504
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726023AbgCLKjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 06:39:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJ//0OxCNsTuWhvFb4ZnQgHAjrIFoINQgzVEBF93klN4rTvAU+m2yM+JwYFZTrNNy6bfyLgFt6Tb+GvXOh9IZaZZF+Yc2tCK6TyJMbkCWhBQaBAwXH0tpPp8mMkVor0AJ5YaQZVT9LLWqkL1yjuCrslzMSszPNz6/BesWhU5CEPELgd+iQmZa8b8pch8aAp3botQD2aIGeKt1DMDHXD2t0Izt7JHBOQ/HWk1yl0cfecnG1xTFDz638xebdYeeCdD1WGHqBTp4ethgEIvfILIs4INDmUrrHkjVMNUrzkJqDz5vaZTv4b5NEBLnvLBsHtwVGR+9IVhSC+1ndJDMuJ5tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWlPjNv/NennGkA26zbaVAstC6MS7BJPLzel49z3I1c=;
 b=So1Bq24SCM9y7gTaltt8NCl7xLJD6BslokEMRk0CFhk1W1DmIdcTGLvgEuQaSvE7p5qQrvRjSiaV4JIvyzJKpyBfv+vrfmX6S1rJY4i0F60Hgy9PW6yZNxxmV58wwS+/sjxZecnM2lsox+5fYMC0auaXo9si4zS68qAcVdhCAGjwLlpdyqa6zZuRAp4B7jRMiaXHwnT/rKMKDzxTaHrUusj/8FAQyRYDptolqVLkqrAM3WPSNnVYJUOFSoa0VOn+LfvD6dwuZmBefukl+kl1HBB1QZhj/2DxLPtXa+lKtsrKq2/gqyPW4dhoFj46xETNyo6lH6X7Pwlz2hiCpTr7SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWlPjNv/NennGkA26zbaVAstC6MS7BJPLzel49z3I1c=;
 b=ArIUjTS2LZaV9MH7grOJemnrIWTIb4zMgTY4Qjckm0ek8xUo31didVQpsuMqi0tGVqFbwwRa0TBfPkOCJxgrCijlmb/CLML046k/m+uEh5FW2Sr6Pt5o4a82BQZGTYwULOCBH/1Vpfh8rMFABZ2PJMGZ0HWoeoccZv2ISuK3QQs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (2603:10b6:5:1c4::14)
 by DM6PR12MB2812.namprd12.prod.outlook.com (2603:10b6:5:44::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Thu, 12 Mar
 2020 10:39:38 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::2d84:ed9d:cba4:dcfd]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::2d84:ed9d:cba4:dcfd%3]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 10:39:37 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] kvm: svm: Introduce GA Log tracepoint for AVIC
Date:   Thu, 12 Mar 2020 05:39:28 -0500
Message-Id: <1584009568-14089-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: DM5PR2001CA0011.namprd20.prod.outlook.com
 (2603:10b6:4:16::21) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c4::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ssuthiku-rhel7-ssp.amd.com (165.204.78.2) by DM5PR2001CA0011.namprd20.prod.outlook.com (2603:10b6:4:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Thu, 12 Mar 2020 10:39:37 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dcb947a3-853e-4140-a1a9-08d7c671a9a2
X-MS-TrafficTypeDiagnostic: DM6PR12MB2812:|DM6PR12MB2812:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB28120BDE5B7890772626263EF3FD0@DM6PR12MB2812.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(199004)(478600001)(4326008)(6666004)(86362001)(66556008)(66476007)(7696005)(316002)(81166006)(8676002)(81156014)(52116002)(2906002)(66946007)(5660300002)(6486002)(8936002)(16526019)(44832011)(956004)(2616005)(26005)(36756003)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2812;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FTBOzwS2IHHTpztPexVQk/N6ATf/++RSt7ztOUaIl6sPxfJgWytBYaqGm7alOHLD7E5KaIltnmdwE2jfR9yT6sbNF6HlTtnARVvc+cqS8RrxUaZGYfpXzhoZM6TtSAGcLnuk4x+u7W8QNvf7u8+do3DYpqC6SR3d8IR8t7vMlVbxmdcZrYF5QvnnwYDsSQZTCh8dZMvZ5JBX6gTvuZcx/KtwfYhBgMxUZO0PhHin6COHQHtv3/JbKFbnVRcAd1ng5T2qrHx+zuLz7dAPSr2WnGJealFA7QE9IoVWhMSTeYE1qWJIuTi/hKf5HTHlCcOzc8QQphIQQSQmsF5a423xUF35V5Cv05RbIx/KM2pcksAVrv0hay3MIu6Nc0PXAu8QEk61mpudCqME8UdkzynfarWMN4iQ3aay3OI0ZsSGXybETmiGypqsp2UHEK3Y39RP
X-MS-Exchange-AntiSpam-MessageData: R8KUGQeKjOTa73q16Alk48bpW+D3xqx7EtqMUsvyjRv6aPqgVVhJkw6oKKWY16CWKtV1ULzy2OSFszfoVtEJZCQ/onXO2OWgsYKAWBGEXp6fmrMRuVIR51o0FEbed9R5gU/Lo5Kc2Ue2VJlnDbjxXA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcb947a3-853e-4140-a1a9-08d7c671a9a2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 10:39:37.8294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8T0Dfc4NvYJL51OpFfP7ab+zzKldgvJyD8rkl2NfAfqe7YqXud21D+COqcbQbx2+wS7nISYb8BKkSgXHqPlBtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2812
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GA Log tracepoint is useful when debugging AVIC performance
issue as it can be used with perf to count the number of times
IOMMU AVIC injects interrupts through the slow-path instead of
directly inject interrupts to the target vcpu.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm.c   |  1 +
 arch/x86/kvm/trace.h | 18 ++++++++++++++++++
 arch/x86/kvm/x86.c   |  1 +
 3 files changed, 20 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 24c0b2b..504f2cb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1208,6 +1208,7 @@ static int avic_ga_log_notifier(u32 ga_tag)
 	u32 vcpu_id = AVIC_GATAG_TO_VCPUID(ga_tag);
 
 	pr_debug("SVM: %s: vm_id=%#x, vcpu_id=%#x\n", __func__, vm_id, vcpu_id);
+	trace_kvm_avic_ga_log(vm_id, vcpu_id);
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
 	hash_for_each_possible(svm_vm_data_hash, kvm_svm, hnode, vm_id) {
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index f194dd0..023de6c 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1367,6 +1367,24 @@
 		  __entry->vec)
 );
 
+TRACE_EVENT(kvm_avic_ga_log,
+	    TP_PROTO(u32 vmid, u32 vcpuid),
+	    TP_ARGS(vmid, vcpuid),
+
+	TP_STRUCT__entry(
+		__field(u32, vmid)
+		__field(u32, vcpuid)
+	),
+
+	TP_fast_assign(
+		__entry->vmid = vmid;
+		__entry->vcpuid = vcpuid;
+	),
+
+	TP_printk("vmid=%u, vcpuid=%u",
+		  __entry->vmid, __entry->vcpuid)
+);
+
 TRACE_EVENT(kvm_hv_timer_state,
 		TP_PROTO(unsigned int vcpu_id, unsigned int hv_timer_in_use),
 		TP_ARGS(vcpu_id, hv_timer_in_use),
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5de2006..ef38b82 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10514,4 +10514,5 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
-- 
1.8.3.1


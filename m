Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBFB2696B4
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgINUdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:33:18 -0400
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:7038
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726162AbgINUSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:18:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jirggKw5cDYi2WYV0JzuOcmu9JCYw9nEUqEKJgfPqt+70uo6hy+phJqYDhxjkJ/cwdM7IW4wzpxcuQ2odGHGuxm/UV/YTdQ7WyveznYKdq8kj3FAGpQ1k4ZX2I+AdHF6P0ovA9h9RRhDh6TwR4gzSwpDVtzrAmQ/2R8kaocQkcOuCZXU47R8gkPbhMZJgzNee201r8ouHkeHP6fiepZCe4ljrw2TTtHLwO+4Im55uMVT+eI1FYR3ghsXtAIJg6lB4F9zNVNQGQFIlzPJrAZolK3FWQcSo+T3x8hE1RJV5pQ+lHoTuxIUzDCEoh0zRCE7zOIE3EdcefBnpe0vc5iBIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kE6bjUOHPF2n+1Xj/O5V0z7+8x3KSOIhAncBkn2174Q=;
 b=U8178TP/eM4q4Ix1gY3gyAuc7+3QDZUIhS2d8fJv4X9nbHgt5MJjZCps6CBrnsZHKRgCchluKLDnMljWr0sMdIFF3bGDvjencAy+FTee54XO91zdGtYtZ5zRvnK16abC8jNviZFmnds0hYSo55cYmDGkU0MplVb9ldZeh6+hcrkZ9UZuQ0fJ+tg1bNBPgNX66vkIGhv2qG0BjbLJRGZTVqnjQdegHjvGSpgYg3R9oRgxL/MNyt8Whh8Ale22/+dNa4drz3L0/slqpb/HH3Ml3OQCtCk6m3Q9TMQPDq6s+IWJAhGQrLoSP9I4tUTX77SuCVyMy7jkKoD/Ag7/DIGIfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kE6bjUOHPF2n+1Xj/O5V0z7+8x3KSOIhAncBkn2174Q=;
 b=cMEQoSV4kYn7UZ4UToNlGIzDsJjeFABWsgzYcVyvOzFx4JG5gw2ZjQ/QXgitnHOaaYJhzst3a0HhT6M7xXxUK1FxFkljLAUwLwmfM83jY/pob41rCjb2pOhXr24lF5mr+hiUeKklfkq5w6SF5RttX1YYuNc02IXu1LfX3S165JE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:17:26 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:17:26 +0000
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
Subject: [RFC PATCH 11/35] KVM: SVM: Prepare for SEV-ES exit handling in the sev.c file
Date:   Mon, 14 Sep 2020 15:15:25 -0500
Message-Id: <e754f4a93c1d8d30612b7b954b043ea9b92519ab.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::16) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR08CA0042.namprd08.prod.outlook.com (2603:10b6:5:1e0::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:17:25 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed286f9c-1e30-4ec2-4fba-08d858eb32a4
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB11632A22ABBC00B1945AB6FBEC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uJdk7B0t5SLPARnelUIfZI6Bz3oBV+Nh3/VmuijJfYcxjYTT9Ptql/xOQ2Oun+retfZK/dFE/5gijRd6m2YZqlS/0DXO6g+H7LORmSh7emaUY0hcaJaf4u2zoV6StuHJr2MwDE9kyAb48VLnS/2eMR8YkIM+aHU6GzV89gPSPTHZTCEvxubKg68qO4TPHRTnVGLS1DV2ExOut+ZF+TuaTl/WhP+5CpPcNS4akhYqG91GSp/ZBQu4AxAEmsktXG46b5hJJk4JxNxn65PnSHNCt6OErI84nkZJfCzNhrWt6nKfvc6qinUg2cUWnGnNO30rONoQtIyuF5WAmSdM6sKMRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9e8t9b4iYwOylDxBjsldPCowxqDt38SlMSyiZQit1ZvdPjtvNYgrLzNdvW9r8NZpjqNYV2UeE5AFnswdj5dbt/03C5dO8M6RVgPT9wQByQzere576sw6xXsKGDrBzBFM5D3nJOjXyHfBrrD/twx3NW56faiPqoP3Wcb+2Rw/5qEtDcWBU63fFGbL/i/LNIz9Ta61btIXyOLFkO25Eb+pisSFuuR5wQ9x1bF7YY+gT5X9JQEwaKWXMR5lJ3tOhDv7nnUJPFEhwl8BvAqg1MOpkOWjqG+Y6mb8LdDiRqjtrQvIpbvA6jS8KftN3Uz9/PXgjEz9UrpMDUyfa68JXNpigrV+HljGnkj71ru6Yf5y5mbrR6Dg/avDALuAfSr481wW6vEi0LzCnKyiaSEAuFbM3ZG+kjAcAqysQY+RFGJWjhZfXGT3DiZz0K08eecB4qFY1gUDu8ShvGqEPnFVrUB5kowgEhI0wmYsB/Ywq2qcLb1m+kv4uzuDZ/FFc1RV3XvpZbF5YOuUL4Oq6HxMQ7bFiLWrZr7xqpU6p6yn80d47V1UriA8i+rm/a2+XmVF/Z+Ry8M0ODy+dquYfk7w+JzVePlpa61ojO5KvnfpktyT3d0OzpkQfdILr+N4Su6VxzHxIKtKIRqGPbVoM2uv4dJLzg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed286f9c-1e30-4ec2-4fba-08d858eb32a4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:17:26.4992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LVyg3v2GUgr8qWXk3qHv3YqtzzGii8mBkqEl835KSk1BElWNKAuFgeo7Xi3AvGyf1jTPE4A6Oz4ROSAvOwr0mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

This is a pre-patch to consolidate some exit handling code into callable
functions. Follow-on patches for SEV-ES exit handling will then be able
to use them from the sev.c file.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 64 +++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f9daa40b3cfc..6a4cc535ba77 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3047,6 +3047,43 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "excp_to:", save->last_excp_to);
 }
 
+static bool svm_is_supported_exit(struct kvm_vcpu *vcpu, u64 exit_code)
+{
+	if (exit_code < ARRAY_SIZE(svm_exit_handlers) &&
+	    svm_exit_handlers[exit_code])
+		return true;
+
+	vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%llx\n", exit_code);
+	dump_vmcb(vcpu);
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->run->internal.ndata = 2;
+	vcpu->run->internal.data[0] = exit_code;
+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+
+	return false;
+}
+
+static int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
+{
+	if (!svm_is_supported_exit(&svm->vcpu, exit_code))
+		return 0;
+
+#ifdef CONFIG_RETPOLINE
+	if (exit_code == SVM_EXIT_MSR)
+		return msr_interception(svm);
+	else if (exit_code == SVM_EXIT_VINTR)
+		return interrupt_window_interception(svm);
+	else if (exit_code == SVM_EXIT_INTR)
+		return intr_interception(svm);
+	else if (exit_code == SVM_EXIT_HLT)
+		return halt_interception(svm);
+	else if (exit_code == SVM_EXIT_NPF)
+		return npf_interception(svm);
+#endif
+	return svm_exit_handlers[exit_code](svm);
+}
+
 static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
 {
 	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
@@ -3113,32 +3150,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (exit_fastpath != EXIT_FASTPATH_NONE)
 		return 1;
 
-	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
-	    || !svm_exit_handlers[exit_code]) {
-		vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%x\n", exit_code);
-		dump_vmcb(vcpu);
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror =
-			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-		vcpu->run->internal.ndata = 2;
-		vcpu->run->internal.data[0] = exit_code;
-		vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
-		return 0;
-	}
-
-#ifdef CONFIG_RETPOLINE
-	if (exit_code == SVM_EXIT_MSR)
-		return msr_interception(svm);
-	else if (exit_code == SVM_EXIT_VINTR)
-		return interrupt_window_interception(svm);
-	else if (exit_code == SVM_EXIT_INTR)
-		return intr_interception(svm);
-	else if (exit_code == SVM_EXIT_HLT)
-		return halt_interception(svm);
-	else if (exit_code == SVM_EXIT_NPF)
-		return npf_interception(svm);
-#endif
-	return svm_exit_handlers[exit_code](svm);
+	return svm_invoke_exit_handler(svm, exit_code);
 }
 
 static void reload_tss(struct kvm_vcpu *vcpu)
-- 
2.28.0


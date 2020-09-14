Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55882696AE
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgINUa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:30:56 -0400
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:7038
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726241AbgINUTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:19:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1hxuJnFyOBjy/+x6lgBnwxkH47GEvBrXH4Hq1/9MC38pIyyxWNIrGztQ5z/zeGNXTWuzMyVhmZ0xa3q5itqvII/SbmJZKg/wteIs8pR1bh5qQoNXtG95UJaKUVJfiFhBzp4HLtv1kHIwtaxQhC7s2VgiZlnIvKGgKep0LtMjkYXGTqtCoIwZRvie7Q3hdrTdkbRQeAo+nQn2t3Rl3/yd8VAUjCEbgF1/ap98VGsVmwDg6eqq/yD3DcxhECUH3n9NbXp8MiQBoO6xRptXSghn6XT+9bTcRm/egM9tSNNt4jh210JXVZoy2LuhOY2zUg7xX6e5Mdz2f2l9akvGW4BFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+xuYZWf/50TsJUUIRBNqB1KwL4FT1zloPfZ9kSHEJk=;
 b=VyCY0Cxpn2xBsW7xA0CagG/T128cWle5qHgcPluPgr3ZSUmB7die2wfMLzG5CqsNYDDIq8BnD7CXuLTo65OPlMRkjLlDNBthuO9TjocWNoLWiH5UvavMY8VbZ6sWkCN9ox2VuAZs/k5iEY3Tx+Xii96DdB0RP+t5HG7h5czEu3Qh7I7wzA1AVQpp8wnWKtXnHY4yZi/zF/Nu5BvYeJHjygmEoleFlXVv8yAWfRHUQPA9xXu34r1hEUL6QLBMfrx/Tstfx/AqAC/caFme20Iqf1kbnnRVMjkXj0b/Zx5ZkC9BtzXVIfAAzQ98S3NY35lc/c3NHqtrWQHoFdHG0/gqUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+xuYZWf/50TsJUUIRBNqB1KwL4FT1zloPfZ9kSHEJk=;
 b=rkikJhJ+5tjWIbpiTiC1MSO0udKDr6ajtQHATTmNLCw8Co2tqH0jE1xJ/y5pf3nGmSImQo0yc5wh+hPMCutT2lSeV39hdYtmIlztJxw6JEEKFmm5q8D4q6z0b1NmKTHC8W9QdUFe2Skcv6sNcLBypJwRlV6rFLbXfP45ojBO/2I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:17:58 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:17:58 +0000
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
Subject: [RFC PATCH 15/35] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x004
Date:   Mon, 14 Sep 2020 15:15:29 -0500
Message-Id: <d52710e76e392a22bbdc37c9bb4c4df85342a5bc.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR19CA0037.namprd19.prod.outlook.com
 (2603:10b6:3:9a::23) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR19CA0037.namprd19.prod.outlook.com (2603:10b6:3:9a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:17:57 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: abafe5c7-dcb9-4b60-37ad-08d858eb455c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB116339A79B31CC0E7D3F67EFEC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: un+8OJSgJZjo6lZhZdaP52I4MYTXwn65wlpYPRXrNHP11RL9eK4Cs3FtQ7MBkF2acSBf5vmUZRkdS834VjNxvySpzceWJuLDG4VtoBZcp7pNkLxbrq4mVEup3OaXbongu4iInAV8hcBHmuC/sUBHyaC9ZJ97voy46XtbEQoJpCrXwZai3PsmuSCljIUVMVZeYYESMy23t4J6pNrMM0Z75yUFZ+F/wA7R/vgpK7eW7YePLRiYO0imOhKVlHHASioMCdaS65qfeQk5TmxaMhf6Rk43pQ5hqdI8NQxi4097pYtLLVZOkM8C1EGUoqQvwhrWqwJ/2DcHtyPbO0la48gDvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WFW3nR8hf7JTIoQ/5AaTIvC+mrU8CfEvj3W+0oYUzWfRxNAT13P3o0ZKTq90PaE2kweM8esZQfUaTDjaCtCPh6vZOLwuWeowM0wHnzA5lRNw5PktCJHtF1PfjiSUZa7i+UZS7h3w1Sd+qtL98n31DYs8bMB027QxljRFuaKe1JJSPDxXQ52TxAmi1QGD+XYFH0OssByHIcBkhCFTLgvwpVzu4pM0r2kM6wV6KgRYfm3g7oO9AxJAMzphBEpIJMke9G6Sc3Qh0jluWtxXyab4MwMDqbW4UkQhGPtvxkqKkVf7GYSfhdic1mZb29ywWlMqVPqmvBOGJL7PQ+Sv81RT7XBk/KNraDlHNGfYXZGmI+wfIT7vC+lY1Wl3QZHrkiWp7J34jW08okah4+wb+uK60REcutBy5xdnQVuWeFS0sWDYvKi4KuWb52QQpNZ1ht9qHcpBOzBA0+/aRRYsk1JyArwwJkpPEwHD0W4qTsekRFB4eYMHQGiOAZURa/BmtCS5Tzb0St6Wyh/vN7JUypay1+WuQJRRbnvgOzRyDrhkj7nx9nTPK6gEp1fjzrz+HBoT/GD76SkvM/V6rj90uLEOB+uNmqmaJIzyyCfYXmSdrDefbll8zluVnA8g6iJ2zDbZdggCirOfSs9FKGFTAeJLtQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abafe5c7-dcb9-4b60-37ad-08d858eb455c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:17:57.9204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CudbptPVRErotfDGYiwkIzgBGdxp7VACmsPDJW8lyM+gHKlq2jtZHRFWSRsQPTpRM70NCPpwbr8liv6MAtA1gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The GHCB defines a GHCB MSR protocol using the lower 12-bits of the GHCB
MSR (in the hypervisor this corresponds to the GHCB GPA field in the
VMCB).

Function 0x004 is a request for CPUID information. Only a single CPUID
result register can be sent per invocation, so the protocol defines the
register that is requested. The GHCB MSR value is set to the CPUID
register value as per the specification via the VMCB GHCB GPA field.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 55 ++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h |  9 +++++++
 2 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 07082c752c76..5cf823e1ce01 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1223,6 +1223,18 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
 
+static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
+			      unsigned int pos)
+{
+	svm->vmcb->control.ghcb_gpa &= ~(mask << pos);
+	svm->vmcb->control.ghcb_gpa |= (value & mask) << pos;
+}
+
+static u64 get_ghcb_msr_bits(struct vcpu_svm *svm, u64 mask, unsigned int pos)
+{
+	return (svm->vmcb->control.ghcb_gpa >> pos) & mask;
+}
+
 static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 {
 	svm->vmcb->control.ghcb_gpa = value;
@@ -1232,6 +1244,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	u64 ghcb_info;
+	int ret = 1;
 
 	ghcb_info = control->ghcb_gpa & GHCB_MSR_INFO_MASK;
 
@@ -1241,11 +1254,49 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 						    GHCB_VERSION_MIN,
 						    sev_enc_bit));
 		break;
+	case GHCB_MSR_CPUID_REQ: {
+		u64 cpuid_fn, cpuid_reg, cpuid_value;
+
+		cpuid_fn = get_ghcb_msr_bits(svm,
+					     GHCB_MSR_CPUID_FUNC_MASK,
+					     GHCB_MSR_CPUID_FUNC_POS);
+
+		/* Initialize the registers needed by the CPUID intercept */
+		svm_rax_write(svm, cpuid_fn);
+		svm_rcx_write(svm, 0);
+
+		ret = svm_invoke_exit_handler(svm, SVM_EXIT_CPUID);
+		if (!ret) {
+			ret = -EINVAL;
+			break;
+		}
+
+		cpuid_reg = get_ghcb_msr_bits(svm,
+					      GHCB_MSR_CPUID_REG_MASK,
+					      GHCB_MSR_CPUID_REG_POS);
+		if (cpuid_reg == 0)
+			cpuid_value = svm_rax_read(svm);
+		else if (cpuid_reg == 1)
+			cpuid_value = svm_rbx_read(svm);
+		else if (cpuid_reg == 2)
+			cpuid_value = svm_rcx_read(svm);
+		else
+			cpuid_value = svm_rdx_read(svm);
+
+		set_ghcb_msr_bits(svm, cpuid_value,
+				  GHCB_MSR_CPUID_VALUE_MASK,
+				  GHCB_MSR_CPUID_VALUE_POS);
+
+		set_ghcb_msr_bits(svm, GHCB_MSR_CPUID_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
-	return 1;
+	return ret;
 }
 
 int sev_handle_vmgexit(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b1a5d90a860c..0a84fae34629 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -526,6 +526,15 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 	 (((_cbit) & GHCB_MSR_CBIT_MASK) << GHCB_MSR_CBIT_POS) |	\
 	 GHCB_MSR_SEV_INFO_RESP)
 
+#define GHCB_MSR_CPUID_REQ		0x004
+#define GHCB_MSR_CPUID_RESP		0x005
+#define GHCB_MSR_CPUID_FUNC_POS		32
+#define GHCB_MSR_CPUID_FUNC_MASK	0xffffffff
+#define GHCB_MSR_CPUID_VALUE_POS	32
+#define GHCB_MSR_CPUID_VALUE_MASK	0xffffffff
+#define GHCB_MSR_CPUID_REG_POS		30
+#define GHCB_MSR_CPUID_REG_MASK		0x3
+
 extern unsigned int max_sev_asid;
 
 static inline bool svm_sev_enabled(void)
-- 
2.28.0


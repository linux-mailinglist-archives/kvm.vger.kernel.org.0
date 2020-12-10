Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09732D633F
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404108AbgLJRPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:15:47 -0500
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:9021
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392694AbgLJRPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:15:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDI+CRpTgLoTSjUcerGNHjPjEEvFsHtNTDpddlbjTv//wV4fGfk/I1dh2lh2jFqiGxaGQQl1DFSc4IL/awcaXmYqiO1RcOEz08bkVsGxxErqsLlmcg2cCD6PBI7NkY5shtm1dgOPf5HOMGPPWXfJvX796cgyv6zilimaspInj6P/1PCqc13AEuw3qLNJl2V0wYJYzsxM+9YxHQmMigPTVpOauqmpD8Bo6ovgVhbRHVbLHX5CMzrhSqZeXpMglHUE7A7szyQS3fiXKnpR3u1UbRX8IVHUPkM9INUyBXT+xacPnHlRSFJZN3acEQJY3/1IxiF+saU1e9EX35TtRVoGGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bnRSpYKoFNKg4HFMIVKxGfw7T/s6eWHUqllcP3uXOr4=;
 b=SlcPuDiovw/5FKtWdj9gHljso5IsgTwl6FY979v4MklDkEE5N7QPBQfJ8QTbqELkTk8L1VQriGfxD6nlSgqZkJFsW4RwnsPZxSA83MZ/eXgUyFmXj4DAAJ87TmC83CxNnpnnh8PegOc448VW2hmkt51hy6nOT9nAcyz2dV6znQ3GbhZZjQSvAD+h4Gy+V8f6+FIvbXXZX6R0rWCkxV8OVq0MDYOe+M/92WaPoFFcZGSxGDigJ9lXNCY6JjLhbXJ0SLQY1uRyuxIdwlRUeBz7mGRpdYEdyzJl1aEn1PtcsuJy/PnoxRR1pHWa8OFuZjNSTkWtGqTY/kUkSRaxJsRx+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bnRSpYKoFNKg4HFMIVKxGfw7T/s6eWHUqllcP3uXOr4=;
 b=pw6G4V1m98XLNqWwCZdT8CIZV9EtXH6zNvKJm+O/tUFYiaYH9OD0yHOPeg6IayRGK8C9EDFLpd2iFEBuJEC55lWSqaQzvHpvhZL3iq5u7zgTUkZpeT7kogBuknJ1CHuHnds/iBVgTyKvjIl9jnFPFCMLLLZEKsW/pe31UQSBJWs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:13:46 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:13:46 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 23/34] KVM: SVM: Add support for CR8 write traps for an SEV-ES guest
Date:   Thu, 10 Dec 2020 11:09:58 -0600
Message-Id: <5a01033f4c8b3106ca9374b7cadf8e33da852df1.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR07CA0033.namprd07.prod.outlook.com
 (2603:10b6:610:20::46) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR07CA0033.namprd07.prod.outlook.com (2603:10b6:610:20::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:13:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f669bd3b-7f06-4256-e48d-08d89d2ef43a
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0149F031B51D9D0035C93A2CECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W77zp/bUK+uuk1fRlOJi5SX2Nef/Es93j1qzIWj77NmWMWnIDFMxFcrwW8bOhEBt3TkXuN0gjH1/ccbWJEVluBEEkKwC3/9YXmeTXACItEUYhpKNUuti6fhRsgyE28VAWF6K845NSNTI+6CgT6dEO4qLJSQpFIxC2vllK8VSbONQkIJJJCOiDJ4xkYYs0uVbVuAcdFEWZuZ2w8rgY8V1Admx28EIhoEeRL8dkvXO2Iqvnf4G3NKaGDzd8dLpd7JZzVXO/ZG1aVmgLheG2olgEkIBvLizEKBFdkn65Z/719T08W5C2YLWpaj6+lhCjWGnzkGojbJlKsHJAjBFNdDUU9kA4Z9/4Xy/fovcAtDvpxCT1BdW3HWj3LAaeiUM+vhL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?A/bP3zoIbW4QYU59JhDLli0ex2722GeF0K5cM4fMgVV2S0GfM9yJJZFINtSH?=
 =?us-ascii?Q?SEbPZZPMo7aq5QceX70REWXQTcDszGwpB/B9Jymj0SIDGgqbVxkOazPPqPxB?=
 =?us-ascii?Q?ofPYHBr/IA+t0j9xqWLibIjM6UdMXVqNblffTTp6wLGSYWkU+5vYm/yp4PRo?=
 =?us-ascii?Q?2bQaVFvjnj9Z+oysiU1BUg9d1wMVfNUSTolvraBgFJWaSVtfL7TKHRtlT7Y7?=
 =?us-ascii?Q?nf+Es9HxrJpLCWcuENGqGYR7i8iH1dX2uLhKZsnYjP+I8BEh9fiYLX6ZDZGq?=
 =?us-ascii?Q?WJcvR1VkdOxxlt2M0Aql6nqGksj9XFyj2YK1C5EFayTe196FgyR1uO8CzNId?=
 =?us-ascii?Q?cq7OOxwknD3CTT9GYThS7ewBL2t17Vr/F1R0xkd6wx9PIaVrVk8IRjckKH+E?=
 =?us-ascii?Q?iwShAolPTDihSDj2wFKXIFvs687h61sYwNwkAsPj9tEwerG2JIR2SE3mlMxy?=
 =?us-ascii?Q?oezw7fdT8Zjg+5x5WYopTF6gSQFtby0jJhIAf2CGpNTL2eGGfRTKXo6L0LnT?=
 =?us-ascii?Q?+6KnnMBjV93CTdmt9d5cRlNsJ36putgYPSazTjhnL7anKJgbSfQHXJHDr33Q?=
 =?us-ascii?Q?GjBFSfYI4DB/d31DDeXTjveR0/LO1MVwyTHcbk0dcmpqXbFEdX0e+4sOuh2b?=
 =?us-ascii?Q?WW5lwztu4zb0jcCkNBiughlSlN7QizxGTSNrM2kMYGw12N+8vRvYKw0qLX5O?=
 =?us-ascii?Q?Xs/xAcYBbdeq6D1wob99QY2eMF42etesilKhAMQ2BJ4cNCgNi6pcH0iz8Tol?=
 =?us-ascii?Q?0I8pppaS33gh/miHoECOC0M9MHMBGRNbUlyqLAfHUZg1d3WbHVzECLX/miAD?=
 =?us-ascii?Q?tsZOV8KWWI23Z2hTAIM5MZarnd47mWE4s3MqK6uqW2D2BzLEQaX9//7WZJ3o?=
 =?us-ascii?Q?R/5X6SJQvrBqARaoItzDywJiGrvrfG1lp0RwOFYHxS3UdD6KuLMmjCtiKLxP?=
 =?us-ascii?Q?jH3u3tpy6Rh7ay8i7va/vqLnLDFyyDNKcYyqMzsJqcvzUFRd8rUiIX87zP3W?=
 =?us-ascii?Q?t03I?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:13:46.2982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f669bd3b-7f06-4256-e48d-08d89d2ef43a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KP0MBNa2w9Lr+CMvI5dr6mJ9RHmMl5B95CC0mBwk6la8OZBC92HzXQw9eVnh5vRWj6hZdhXrtR3rUYz/lS6iPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

For SEV-ES guests, the interception of control register write access
is not recommended. Control register interception occurs prior to the
control register being modified and the hypervisor is unable to modify
the control register itself because the register is located in the
encrypted register state.

SEV-ES guests introduce new control register write traps. These traps
provide intercept support of a control register write after the control
register has been modified. The new control register value is provided in
the VMCB EXITINFO1 field, allowing the hypervisor to track the setting
of the guest control registers.

Add support to track the value of the guest CR8 register using the control
register write trap so that the hypervisor understands the guest operating
mode.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/uapi/asm/svm.h | 1 +
 arch/x86/kvm/svm/svm.c          | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index c4152689ea93..554f75fe013c 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -204,6 +204,7 @@
 	{ SVM_EXIT_EFER_WRITE_TRAP,	"write_efer_trap" }, \
 	{ SVM_EXIT_CR0_WRITE_TRAP,	"write_cr0_trap" }, \
 	{ SVM_EXIT_CR4_WRITE_TRAP,	"write_cr4_trap" }, \
+	{ SVM_EXIT_CR8_WRITE_TRAP,	"write_cr8_trap" }, \
 	{ SVM_EXIT_INVPCID,     "invpcid" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e15e9e15defd..3fb1703f32f8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2475,6 +2475,7 @@ static int cr_trap(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	unsigned long old_value, new_value;
 	unsigned int cr;
+	int ret = 0;
 
 	new_value = (unsigned long)svm->vmcb->control.exit_info_1;
 
@@ -2492,13 +2493,16 @@ static int cr_trap(struct vcpu_svm *svm)
 
 		kvm_post_set_cr4(vcpu, old_value, new_value);
 		break;
+	case 8:
+		ret = kvm_set_cr8(&svm->vcpu, new_value);
+		break;
 	default:
 		WARN(1, "unhandled CR%d write trap", cr);
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
 
-	return kvm_complete_insn_gp(vcpu, 0);
+	return kvm_complete_insn_gp(vcpu, ret);
 }
 
 static int dr_interception(struct vcpu_svm *svm)
@@ -3084,6 +3088,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_CR4_WRITE_TRAP]		= cr_trap,
+	[SVM_EXIT_CR8_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
-- 
2.28.0


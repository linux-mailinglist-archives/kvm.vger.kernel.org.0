Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA8F3767B1
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 17:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbhEGPJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 11:09:18 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:21764 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233414AbhEGPJQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 11:09:16 -0400
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 147F2j6b032110;
        Fri, 7 May 2021 08:07:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=T+U6BfE1UIgocRpHqU11DfVFJaofIYhYh8JQiAHx7J0=;
 b=OG1e9s06olZLQBwy4OcmXmfimId6zTdDVpeWgTXCLRK8+2yJB+OzPahVn9s/srAEKJpI
 0QcckeBKdhGgPNYKiNU3wMJFuX7phX/YbnshA17KzVs/GdgXpfQVWenYVvOwqSAgzcfN
 pps8A5Au+NFqumI+fdzJNu75r+1UlbG7+awiQZ6AhoxQWMe46H5G2brChzs7BbKwKPhr
 lzGlE+IrqOJcucFZRxP4myhaL+cFVosQ0eDSXGavsFUp5W1X6aDVq4oUFfhljaq9W9gn
 fO00mMn0fCwQ81D8XozY+P8F2YAKjxndySDUWbJ6T1HTLpZMOlcDCk8s5Wejyipx770B NA== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by mx0a-002c1b01.pphosted.com with ESMTP id 38csqr1gmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 May 2021 08:07:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6Q/ch+DH+hVvmIqhlehjJHDxQLSs9lBzN6q/aF5vWvBNwVo2igVplZxEis6Q6+q0KlEoGUrX1jZQaVs2Lcoc3r63qPYEzoHWKbEiYpiiu4r/cPbfVab7ugs1w8hap/OhciFKtuLvAjxwm2d8Hjs0CqO2lAxYAFHR/YW/kNJ1BKJAi6DqGCMsmwgWOpm9ZZydj2DHJxVcOUIPisOlMhEDauKY/o1+reRu4iUA/ca7YD3M7rrn2zqiwNG1It/dhv39Ca8LTU6ZactPQ7n28qv1nAip4eiBzEqAd5jdVScmBmxU94vqIYq6kECmO3VDvhC93KE9UVqaSkgQ1q1CxdhcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+U6BfE1UIgocRpHqU11DfVFJaofIYhYh8JQiAHx7J0=;
 b=V69dAu9BMHYrWToIda6pCpUPxvBAJULN7JbgXa/lTQg+pRHtYmsHQBFMaw4dAHV/rUCPjvhHbV+iel4rLDZkW/4hjWcydprZjCXhwcE5EIZe5YrTmMa6EF3day+hGSNWIQXff3DYJdEtY/cF1USeqv/P8IDxM6+oIzSjJooGtt8671+yCdFr7zu9zbQmQcNi/klYPaADm13Im9sIpNEDX2ge1Z17MkyBvnpd1A7Lk6edGj4GBltmJQmjwOLGdMW86FVvY6+JD+IO7Oc+MPfOZcct04BXKy07RxooTjXHgkEKois+fr3JUZVe3M2xrJEaJ/oANdErbEvHNNHHIEaTJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: nutanix.com; dkim=none (message not signed)
 header.d=none;nutanix.com; dmarc=none action=none header.from=nutanix.com;
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL0PR02MB4883.namprd02.prod.outlook.com (2603:10b6:208:54::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Fri, 7 May
 2021 15:07:13 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07%5]) with mapi id 15.20.4108.029; Fri, 7 May 2021
 15:07:13 +0000
From:   Jon Kohler <jon@nutanix.com>
Cc:     Jon Kohler <jon@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: use X86_FEATURE_RSB_CTXSW for RSB stuffing in vmexit
Date:   Fri,  7 May 2021 11:06:36 -0400
Message-Id: <20210507150636.94389-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2601:19b:c501:64d0:a9a2:6149:85cc:8a4]
X-ClientProxiedBy: BY3PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::12) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from C02F13YVQ05N.corp.nutanix.com (2601:19b:c501:64d0:a9a2:6149:85cc:8a4) by BY3PR05CA0037.namprd05.prod.outlook.com (2603:10b6:a03:39b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.12 via Frontend Transport; Fri, 7 May 2021 15:07:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ae1a3d3-5d77-4ac9-67e4-08d91169cb96
X-MS-TrafficTypeDiagnostic: BL0PR02MB4883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR02MB4883D77AF0FC04445A959DA0AF579@BL0PR02MB4883.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:294;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5+IRvV9slExiGbcPFeBmK1XqdbfsePZMxG2REDeWKjb0gvoecUkfk11SN2RPg70mD96KhQ+2TIXemf67nVjatQnfEOb83DGonJj2tj2vYIfQX+RQrX8XoDr3l4bMqkG1DchLD5JKgMiAqQYXlBdtZVjLjr2ecSzePjRz3GoEx3FRpiNt/clkXVmeFYpQL7cvcPmMZ2Mf99dyeqpRugk99vo2rvQst2tQKVNDeO1kgvSjR9Wk/c+RMs2hAOmbOkUVevjT/ywint+IhlEV7XAPf7+HoNOjmzdS4MV7eccTDH5OxMCB/27AO0qgQum7OnxQGk4VaVgbBZv3zNLENp8w52oF6iuy9eV2180KMS/ehoVuvDL7/6lNAfMlltKL/VyTwIFRBkkpDdgJly7+uwkxev1UO+i5Mk9LfB9HqkuSB39oxzXdrhSMG3aphR8Hr9Wbp4dfvLVWY7SlzXkVgQrKPtIq0ertSZbTAtxiWtSSawsFksK45ET/UU3uz8B92/8aSneXvYjHubDfHjS+n50HvX9BG+UbdizIiOuqFQ8aGFS9VLT8gLyrCUgG0LFslM10OX3N6wJl+hePlbQ3iDNT1iFyETgLA3RmG+iVNtBdNbG7cUCL7uJaOlOtCGVFs1Km/zOdlK4XIBkXa4QwZB8EUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(136003)(39850400004)(396003)(66946007)(2616005)(5660300002)(2906002)(1076003)(8676002)(83380400001)(52116002)(38100700002)(7696005)(186003)(66556008)(16526019)(66476007)(478600001)(109986005)(36756003)(4326008)(86362001)(8936002)(316002)(7416002)(6486002)(6666004)(54906003)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fHpegl5EbwqyrFO6uq6+H9fJRiluDYzAbelcarEuNP8XYLkQfLi51RZNkXRk?=
 =?us-ascii?Q?E02Ad/38b3jqK82XslgxLFvMvxxAVzP7ScTq2d/fPcdMo6rw5FaAphpi4bBn?=
 =?us-ascii?Q?FDmQCG+W7kavmLyFcXOcNQkn9n40rdCnWGAUpiwCxvVZyNbooAuOmIHXh8au?=
 =?us-ascii?Q?N+txl5nvLpwWncWpAuD/GCsKn6RshkaQT6d8GlPTavDrGx7FQxbkZYhqftEn?=
 =?us-ascii?Q?mxYY1oXyHSPrOAKTnw7aYCmkUTTe0cwZWIjRb8wG4x28iPk5DB9BkXOvNRxG?=
 =?us-ascii?Q?fbRpl6/iISYYzh59kZF3stSZIGaX2GvJLulW7ifo4BO4p3bMvbE/AogWLIgt?=
 =?us-ascii?Q?RnbBjWOrP92hGqqHjG3lsYZ2rp7gT2NWmaNC3P1lWR77H4lxnLtgMm4BoLOj?=
 =?us-ascii?Q?EIkjpsyu3BZ+M1WUrgLQRI2PRkbDWjymFxXRRAEOhiPsdUxHDnuJ+VL55nPr?=
 =?us-ascii?Q?CN7fB+qBR7r8bCi3HIfhZefUHO2TZVijJdPdn21ftcKOhkkHaRspVkVYqQIS?=
 =?us-ascii?Q?i9X1Sj9reM6IRIbaRRpaAWPEtq+iYEx8koBmEj1evOhMRs97wH1aBEhxxyaV?=
 =?us-ascii?Q?EQvcRaDrq0W2XoXV7QrG8VuWK/RmaNxe9t+TN6RPyRQSazNz/DBc/q9fTb6I?=
 =?us-ascii?Q?sEaW5tp39Bj8ffCnrEy1oOedRf0X6Q7XGS0jK1YjK4t69+99gG8+Pkk0EMDA?=
 =?us-ascii?Q?q5BS+jYyWtzMSulwmrKgBPWqW/sY2mkN/cs5sjiU38EoaMxRFFCvqjbKj6zU?=
 =?us-ascii?Q?Ar9n8yh9D+LmOjwAbsmstjAiz7srvma9nNHJtTPOwdO1+Rey0i8S9gMs9r73?=
 =?us-ascii?Q?UcmCGuqwHLk3p+EopLJysvCcGA5MBTqyQNXbtCadw1dVGridjKt1Cl4kZiqs?=
 =?us-ascii?Q?JoikMyydyU+ll79qk2/8RTCIIAHSimE5HaQqzcXEXpZwxX+gcEixCfLiI6xP?=
 =?us-ascii?Q?Mzvwp2QL2eI5P01+sVKuykB1/asxUQYpA6xyYzg3oFcDgt51F+SPKst65v5I?=
 =?us-ascii?Q?2z7SK+8oBJCOvNa4jhcLZL1FSCAOF5xiSTYJPC68NrgcUYz922jXOPgOLbSS?=
 =?us-ascii?Q?rg1wjyjQInJwEIo2/KP3tNxKgmeLcJI4ADZ19SwwrWeEyvMuq8QP3Ed0juSY?=
 =?us-ascii?Q?Au43SzbjL51vLBKvzIyC0Q6a5UPMh0RUDEJH5ocyTahep6rqdsQ70tVKWQ3A?=
 =?us-ascii?Q?Uy/a4gAgx0Tdagnu34Hbq8dCTv0UOSDl/LU1QF12e++jMrqUI0cjSY8J4U3E?=
 =?us-ascii?Q?kT4677VYfP4BY5zLnjqhsgHqNFk4rRFatzQGwLz0KpmyXEGqoMSv6rhsVJKL?=
 =?us-ascii?Q?GFadCdIjLC277Pn+4k1nF2+cUFLV7v2DxL1A+l/NPM8m24r1Xh7Ikbl++BUe?=
 =?us-ascii?Q?ZnwcoqpODKA1NXmNlNMOIE+L2Nxk?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ae1a3d3-5d77-4ac9-67e4-08d91169cb96
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2021 15:07:13.7464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lEmoCS/JavAiCgixedtEJKtJ7jtl4ACtv/NpFJaSud0XFBaLsaE7jJVpTO8h72jte0YEsQCTVGZ83g7Y43xB5D84NrMlB5wP7+GsQoBu0iE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB4883
X-Proofpoint-ORIG-GUID: N5Fo_JGjmZw932CpxCuTmD72cjGf-0qO
X-Proofpoint-GUID: N5Fo_JGjmZw932CpxCuTmD72cjGf-0qO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-07_06:2021-05-06,2021-05-07 signatures=0
X-Proofpoint-Spam-Reason: safe
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cpufeatures.h defines X86_FEATURE_RSB_CTXSW as "Fill RSB on context
switches" which seems more accurate than using X86_FEATURE_RETPOLINE
in the vmxexit path for RSB stuffing.

X86_FEATURE_RSB_CTXSW is used for FILL_RETURN_BUFFER in
arch/x86/entry/entry_{32|64}.S. This change makes KVM vmx and svm
follow that same pattern. This pairs up nicely with the language in
bugs.c, where this cpu_cap is enabled, which indicates that RSB
stuffing should be unconditional with spectrev2 enabled.
	/*
	 * If spectre v2 protection has been enabled, unconditionally fill
	 * RSB during a context switch; this protects against two independent
	 * issues:
	 *
	 *	- RSB underflow (and switch to BTB) on Skylake+
	 *	- SpectreRSB variant of spectre v2 on X86_BUG_SPECTRE_V2 CPUs
	 */
	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);

Furthermore, on X86_FEATURE_IBRS_ENHANCED CPUs && SPECTRE_V2_CMD_AUTO,
we're bypassing setting X86_FEATURE_RETPOLINE, where as far as I could
find, we should still be doing RSB stuffing no matter what when
CONFIG_RETPOLINE is enabled and spectrev2 is set to auto.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 arch/x86/kvm/svm/vmenter.S | 4 ++--
 arch/x86/kvm/vmx/vmenter.S | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 4fa17df123cd..fe81012da4b5 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -86,7 +86,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 
 #ifdef CONFIG_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
-	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
+	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
 #endif
 
 	/* "POP" @regs to RAX. */
@@ -187,7 +187,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 
 #ifdef CONFIG_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
-	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
+	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
 #endif
 
 	pop %_ASM_BX
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 3a6461694fc2..ede6aac7d8b7 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -76,12 +76,12 @@ SYM_FUNC_END(vmx_vmenter)
  */
 SYM_FUNC_START(vmx_vmexit)
 #ifdef CONFIG_RETPOLINE
-	ALTERNATIVE "jmp .Lvmexit_skip_rsb", "", X86_FEATURE_RETPOLINE
+	ALTERNATIVE "jmp .Lvmexit_skip_rsb", "", X86_FEATURE_RSB_CTXSW
 	/* Preserve guest's RAX, it's used to stuff the RSB. */
 	push %_ASM_AX
 
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
-	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
+	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
 
 	/* Clear RFLAGS.CF and RFLAGS.ZF to preserve VM-Exit, i.e. !VM-Fail. */
 	or $1, %_ASM_AX
-- 
2.30.1 (Apple Git-130)


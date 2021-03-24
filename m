Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F209347EC1
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbhCXRGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:06:03 -0400
Received: from mail-dm6nam11on2061.outbound.protection.outlook.com ([40.107.223.61]:33120
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237065AbhCXRFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gf0qebKFykfm5id4QygZIJBwiHcxpKtrT/NFDABHN6O+w1qENWEfM5/ieHb89zvbVp02hsc93iS/kzETwmhLmiprTl+04xCSy4LHxJkgpIWF/wVJdqo9TLV4RIw0xLdt5kp9mFpYZVIcyMEJJsfJ1DFUtWIQQ0JgHNnnfsQOq7IMN5Dqs623TKFD9OwoJEm5MCFfEwQC1L8DkWifbQdRM1BkzDTd2BmhxjMM9CLN5kT8yy1jcqla+9DbmkOHgYns/7Dh3tlIma2zuMeqQz0MbnmPqnhv1a9KVj2yHNBxhjrSs65memFEIlih8VNZls0xjzYR8Xgq8cIlupOp43fu+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nr48WiKmgDb3qwxztPkZbWysX4pDIJ0p6abxE6mpxNY=;
 b=HsdvlAV4oR2xgJaNSWHV91b2m91xiS8SsblJfa5FeNvh4aBU7z4doTl4X1bAQJ0CZsm4Y+Z0p2VjUfGq5PdDzetf2jkC3lsua7c/iGj6bl7/s1AWOP0U2pVZ6h/XIfiBNxkzwtcs7H4GxFuovXW+IGhDLUttsu+64lKE54t0f9c7XHHOPLfevSW60TY8TkaUziZddYQoR+ZoRHqBMKktx0ZSdyZLS8DaEqr49YqddkZa7lHFT+OAjWZSqWWKYGcUm4rq9vAmv7G0YolsLUFCfiSmrfiN7oA0ZDXCRMj8hbBjEj7k5/M3T9HbwyW6CakwrxvkyJds7XLOHnVwPNrATw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nr48WiKmgDb3qwxztPkZbWysX4pDIJ0p6abxE6mpxNY=;
 b=iwkHsAVHrHaZFchZ6s9yW/E/1/CiZGRdSUywOemrRStPsnoZ/wqMYUrf63dHDlDpkGRclPwu9t7CTyIQQJ+3B9kPZA9mfnUXKB+DwQKBa5hhgOTxZ2gSq313ACcFjjBMsY3PIAoK0lyYm/i6T3ah9EfZM6vhaoMyj4teGu8mA1k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:11 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:11 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [RFC Part2 PATCH 25/30] KVM: X86: update page-fault trace to log the 64-bit error code
Date:   Wed, 24 Mar 2021 12:04:31 -0500
Message-Id: <20210324170436.31843-26-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3a74d890-cd5f-463a-f889-08d8eee6fc56
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB438264D124ACF5953A938A27E5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sW+b3GiY9HUa5zenSxkAvLB9BZCscPkgqjyKiTWLF9z9XREQR2Biw/4k00h6Otr0CgLOwAPFpGcNu8/MD3jwocj5rzWcEOhN5KFKORHhT4T7YxiD59gSduapvfpYH825zU+We06AEyg8W5KAYnXRuAzPqQdaXtYwJXs6bZnweiOItHzmK6hpRWEzzlVryARpq7eGdTObBr8GFRVF0+NA2UWWkfjoUrWFZjYRujYyeLpWAnDyshK2+9qS5rplfq+8VkLEEJAHz/VxEPnLztjpTG7GrCUgRBd/KSVyyP4zJ/cnruGti6KsWjwIrdMEB27K0g4wegM9CLyJVfeKcX8v9XGOzDe74FbUVCUSLBOpy1tOqo/5nOovc441o9HgWxpwNsYWdWvNSeFwfnEh0bu3UWcebvEa7ngOmtG30ftgQ5MZXyEdWN0YHBTBlY2s8tp61Is54mcZEJ+KmwrMzvlKyFZ4GAWjkfReoPclk772FBeroxrldJ2hSvrQTKs8gPaQgYmGNjfd/CwQzlyr7UHGAIkxrRp2fvrSsVqLkI9KxBoSP+U8MeZaDUgfVtCtWfUU4zTkK+0fhlrDY5LybyJS/cu9PmrYNYhEr+nJVuwEYqWd9AcFPl+OlpNJbYPosDE45KngRAm8huqQvtJjNxqEdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?S63ZhysfwVoIwbAUNrHoZ9LUNg3LDkAIkPu0m+RNHzCrvUEy+9KBze4Ho6+m?=
 =?us-ascii?Q?odkjJHhhhr1gSn344sGl4xxMgFq5+Yz4Nas7xspr/U5kNDMfIMeldbm6xzOp?=
 =?us-ascii?Q?IP3qZh70NsH3LFxpc9rUPxxrsW5ihXfRLXkGaAYBIzsrsy/fehU/gBx2lPHZ?=
 =?us-ascii?Q?qing+Sh7u4AFnLzyS5wt6cGuTpMJzlc7pSdoDJ0koH0WB03ncsjBFhfpbyIh?=
 =?us-ascii?Q?/sYQcp+pDh1EQOX53iQIxJp5ui8h7LIBHzJB5wuzi0bg323lUiHv3dmjs3KR?=
 =?us-ascii?Q?1ehdac3VByiifPsbLk3Z6KpDZaLRvhpIlMkmmP6jdmuqchRl0BMBMxb6IAw2?=
 =?us-ascii?Q?O5Ne94BKksNnONS7XrKldf5Zclm3Cu7D81O+b2VdHXppQA+v5ytapV+Gd1cD?=
 =?us-ascii?Q?YKLujfDygM6rd/sdf1CeviqSbRb9uQ7i3MTdIUaLr3tGea7TT2a9vhVfzQAh?=
 =?us-ascii?Q?Cvl/b48mIgdbQERjnGlRaHdhKMTnB3kKt9Vc/8Dsr1NSFVO5jl2WbSeJoYTP?=
 =?us-ascii?Q?MJ/fzgdyhzyFuBHIkHtTIkMGMJg2wPtlybTppakxcZFz3GUKI7r2dCDVhzPl?=
 =?us-ascii?Q?xv8rwGl8QEN9eF6ongHSa0S6RifsejZjwd+LPvZGlAnDg3+eAYQrqPEGR8gc?=
 =?us-ascii?Q?/Gjsc0IVBI4FaPbjrXlQz5YnQvCNXtgj4HgNnXU7CnyKR2cF59FjkRuJwPtb?=
 =?us-ascii?Q?RdPUO5X7bVf208QlnAVKxK8y0ABbTd0PnBMeRR1K1N6CAoBbhML/i17aZjK8?=
 =?us-ascii?Q?j9jIr1N/uQkw42r89Y9vWl7en6P3OVs3g21WFwC5Brvgc0mCeajbO6LxaTqD?=
 =?us-ascii?Q?kJlOqCLFKmKYZFKvvfUnvM0B7oNZtJ2vKjMBy8mR54NNy7cmgiSzqpnzf+yf?=
 =?us-ascii?Q?67u/1al2zqpC7mUZ3SLg+KJj6ntwqS25sP2tox9c/MhSdiej3gqAnzQ3DsG4?=
 =?us-ascii?Q?2MfaVfgumPRGtfb+GEYXuMMXaeq37tA3eNi5mPkuUpAV1VzRUUeNHPYrbCcc?=
 =?us-ascii?Q?LrZRtYSSYiOSeZSxVkeVPasTpQW6iadokuRyboHq3iLDtv+/itHekH+ZRT5u?=
 =?us-ascii?Q?XXe4ee3+zPdfNUKF+UdTUax6BfdfPIifK7XgwlK2Xlzn84rEUYtoXRxPJxaC?=
 =?us-ascii?Q?2yYrV9cg6twm3tLkCyLjCLnSE9B5/5AGM/aghNPI0zt/6d7yIYHPh3NvoJkT?=
 =?us-ascii?Q?jqrw1xuiFbQ07HeTcDTNyqfPw67fgtYH3JFhEtZ4ZtAghzPMZJ6xWpPzGbYP?=
 =?us-ascii?Q?rHl0YmsNac2gmEMmAJA0EAWAJ5bujZv/XTWBJeb4eE4S2wqy2fKN84NlRqrF?=
 =?us-ascii?Q?w1HHrJiMTQtbSUBWONir3MhU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a74d890-cd5f-463a-f889-08d8eee6fc56
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:11.8051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+XoHA6q0hgIa0Swsi39pe7voRfivWGeCK7P/vNpfoGCi1WLkeT91SB84nUjFmAqPWQL/pIHrJv3zVMomSfEfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The page-fault error code is a 64-bit value, but the trace prints only
the lower 32-bits. Some of the SEV-SNP RMP fault error codes are
available in the upper 32-bits.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 2de30c20bc26..16236a8b42eb 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -329,12 +329,12 @@ TRACE_EVENT(kvm_inj_exception,
  * Tracepoint for page fault.
  */
 TRACE_EVENT(kvm_page_fault,
-	TP_PROTO(unsigned long fault_address, unsigned int error_code),
+	TP_PROTO(unsigned long fault_address, u64 error_code),
 	TP_ARGS(fault_address, error_code),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	fault_address	)
-		__field(	unsigned int,	error_code	)
+		__field(	u64,		error_code	)
 	),
 
 	TP_fast_assign(
@@ -342,7 +342,7 @@ TRACE_EVENT(kvm_page_fault,
 		__entry->error_code	= error_code;
 	),
 
-	TP_printk("address %lx error_code %x",
+	TP_printk("address %lx error_code %llx",
 		  __entry->fault_address, __entry->error_code)
 );
 
-- 
2.17.1


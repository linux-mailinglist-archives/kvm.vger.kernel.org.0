Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1EE44FC2AF
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 18:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348685AbiDKQu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 12:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237884AbiDKQu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 12:50:27 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD47393E2;
        Mon, 11 Apr 2022 09:48:12 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23BDotEn015949;
        Mon, 11 Apr 2022 09:46:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=hOx/Ka+DbelCmtnJ8RtM/C888HupfA7Fcelg5H8g0eM=;
 b=VoPwgu5QsvsxApmbgQOJfX9gFdXZIw0M+fi0OkF/K8HmYxWGNOI1x8iPkT/emUMwf2f3
 LTqCN2q9+fxqXJ/Yda6lrAckvy9J6RL8wQLzWPwf34Y6Il4JA7obxFPJRjY5GdbsMSUR
 8WYDBElmbPl/lCIZ9GOxRU+uEmzrPvMQQncW26pyb0TuBqAucBs8SsNl2d/ehXgtd+CY
 28gWaS2xkj1oN3gmFSs6RqO07nmQMgRVpMjO5tlIX7pxXlKvDuXLXG2DRxognnFdTCQD
 kViJuePq7QHamWd3+mGJG5YNOHd+B7/MhdRSsFWrjb+IurOmoIVpTJpt5THVM49e5PDM Iw== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fb6fr44n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 09:46:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHl9N3CNMPZ+8MG+x/cxF1bg0V4pZcqfkN1PQyg0vH/FNyEHU0qGxy4XcPwEPfVVKZBL7EbtItDLPT2DdwBBQEyURDAU0ZZ6J47HuI6tERS3wVFOWZFedd0i8MrLy/DaKyhL7ArQe9r8vW1wJSnnH6WGenxWb88Z7xrfdAUhUi5f/3Y/2z22jDaCIvSzb7+jaGDvVrI8L17AiWi/487ttCQpMynDXxG4Mskhv145v1a9uRmKU8MzaBCb/o1SiwwtGPKdslpN26FPeOmrjEUplUr70anskMH3od8zuRf3KSeh1DhiTkuuSY8Ux4A7+B0yI5eED7mFSz8Z9Pv/Jpy8xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOx/Ka+DbelCmtnJ8RtM/C888HupfA7Fcelg5H8g0eM=;
 b=m4x/UchQvFtIRaer6CK71dPP1LcOshOCMP7o+fh0A6LjVtHfB97ABV1/CXn5kQtB5xfl/hlI4Fgx/ThPPq0lL9T77UQjY437aAPVyOROgmlCJvfFGLGFQuCGLNreDRS+YsL0dYDnsL+Ce00bL+MA1FRPSJyuFsXf0gMcCKpUZ8m0W+BSHbR22AGU3wqfBcEYSmZnkz68enDbWAbuXXqEwog5ogEHlcA/NUC/rVt4EPPXhEqUHl5fjyTxlTA9uC9G/3V4peyfnyGQ8xNmh78TusGOlEGTUtOjNRpXhHdTvgtYM30bZbnrAjMB0fzlBU1kndJk1uf541awhU2308Kswg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by CH0PR02MB8091.namprd02.prod.outlook.com (2603:10b6:610:10b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 16:46:57 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 16:46:56 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Jon Kohler <jon@nutanix.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, Waiman Long <longman@redhat.com>
Subject: [PATCH] x86/speculation, KVM: respect user IBPB configuration
Date:   Mon, 11 Apr 2022 12:46:32 -0400
Message-Id: <20220411164636.74866-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:a03:40::38) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 564a2678-cca1-4b6d-5dcc-08da1bdae38e
X-MS-TrafficTypeDiagnostic: CH0PR02MB8091:EE_
X-Microsoft-Antispam-PRVS: <CH0PR02MB80918877FBD4B3C924D409F8AFEA9@CH0PR02MB8091.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bDhsDeP1B54pTN1Q5toQIJedN8jiApWEPs8WdLA/K5pXBRe0kjiFMcdoM2NkrWgbueolwXj1So1TTXWpsud2W/YNzPy7RBDC53IxSBsGOc2EdzzZTLXqMDnQaIWfVaH8T7P5hm9wpGma3OUOp1/pvKKfSnwihoYJt19pwLFq+zEHPivYliOK5qO+N3uInI2QBi5dt2UHUml3yE6tl5ZuAzr7IqsFr5LdMlUcRL04KQ0XHwCqgCaQy7M1dEa0pb9Rf7rM6ZLQD8HwsWr/GYyXLRaYQFy5Z+QsSLiUCo4AdFKVK+7Lfmb8RXC6p7WQ5vayixQJ5N14NX80z/+H3guFppddTVev98DaQbLeW5cX3LCR3t4Asm/EZSbDwXgY5rkTmjx8VmqaCRGIWgTuaBAttuWS8UFL8QcXo7eT+wwnQT4PKzHc1ZIO62kZEE8Ph3ZSsDUJHpnSsduIpoj/u4Z4mjvg2OCETImRo3wf4YqgsF9gNPe4bP+sWcSk2oSeR7VPQG/H6D7wm8pvKsxO6wqUOGg/lPnL5zFy169CvwSHkI2J40iDz6QMglpOec46lOVpaa+dZQpUf7UrlHmJSwQ+GFvGMaABXeCGBGg2bFa6tmBAcmi3diNpNL7c+sA8Y3Qntz1mTSsajFmkEpZrKG2Yz/GYwfFU7UZmnefDZadI/2bmbj3SKwq3Dhkoo1ARLsktlnGvwhmoEFevV3br1ns4/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(2906002)(921005)(66946007)(2616005)(8676002)(8936002)(7416002)(86362001)(38100700002)(4326008)(66556008)(66476007)(52116002)(6506007)(6512007)(83380400001)(6666004)(186003)(316002)(6486002)(110136005)(54906003)(508600001)(1076003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DecXWFde5+6IL87qYsUnQMgTFnemUp3pKZTaqex7JVHPypkIa5ASkHpwobd2?=
 =?us-ascii?Q?VuaixvcUB5MCRjDS66dlD49COymz49jwNnTZddguZ09LkmIifwtk0IstW7oU?=
 =?us-ascii?Q?PiRiTISEceDDA/zd3QQ/HIMk/n9qh56nl+kNZV2Fh0B6GjqGBgDInbtABO0M?=
 =?us-ascii?Q?OIODDLYX1ab1ywvrA9ckjVi+fAkea7/qEX8bf8D3zpbBMldF8qWjHfOzd44I?=
 =?us-ascii?Q?jqIohiWSBBVL7X76wD0HTVe+wVbrJvfx0/xNmf38O3/GTQ99VutV07zP1JmO?=
 =?us-ascii?Q?0YKL3a9qilUvblLQFKyINz0SnZ2cdRRG936XlYqkJf3dJ9dzrl7SL0ocSJDn?=
 =?us-ascii?Q?S17JFbZs12w+93oNMdsOulZY1hutLFIpZftLr1QTKzQzqM3FSpnY4KNK4dkk?=
 =?us-ascii?Q?/WUaM4FHbSfqXhWGlGdXxTRqEYJGo7f3dUwaynQZNjshCYZO8dHCPJQ+tGDN?=
 =?us-ascii?Q?Sj5njfUIv7IzBXqxUGQbqM1e3+SDvnaX1bvMNJ8JM2iXfI0aPXvIAwO0SmVS?=
 =?us-ascii?Q?6nR69JJAByBWYiww/OsQnEspliVunSpSq3HYuWpdJxvul9DnO2ctcdzfrJnV?=
 =?us-ascii?Q?vzKdaI0loj5LEt+/3/9rNpuCVf/JbRgKxrV0wpUG3CsKQ+Eyx8I9442qLmXI?=
 =?us-ascii?Q?c2yHw1Wj7po6noTyrvrMX0QUhqe/CyQ57qwmMtve9mpSpmvBOrQUrLifPjQ7?=
 =?us-ascii?Q?W1cwrTGSLGBgcXwa3nbaftzR9xJxD+pMfowz7MkprEXinOOJvbWtqsgiUnkD?=
 =?us-ascii?Q?9TYUw9hAy6MYr9wqQONOkRig69pJWj6A8v2s5DWKjUuiB4ZQPk166s210TyQ?=
 =?us-ascii?Q?mVs4g55bQh3VM59OAeOxxeag5s4eDSFXA87rlfyYsSRyAwZNedk1di+haslu?=
 =?us-ascii?Q?Lso/FlH08OObzLF06IH/K5pGqRb9amY7xAxU+s9cCTNDop2NBlXesuzVg3Om?=
 =?us-ascii?Q?FkevwrrVllAlfGMwzaT3moxxsHsBYhJ9+pi8EtcaWkXbti/kv2eTQd4mXOf4?=
 =?us-ascii?Q?Rx+mgdpeqqaYRm6ZxBfFqZRwAFyHUP1p6yrXdW2K9hx1nzGld+vVKYZrxRju?=
 =?us-ascii?Q?va7rZhfYmSE1h4PtVeTSeByB8d9JqYnQEgZwxit7KwPalSet9w5JhzcQorM0?=
 =?us-ascii?Q?5lPeLuFtVs36PrDhlimMhtj57jVLkpJ/uaz1gvJI7RALiXfQK4UHIlbefQXg?=
 =?us-ascii?Q?+wB3/PTCPrOSsuQc9tlI56R+JqyQN+kZoSrtgPa3jqJT+uw8Ol9Zif9S/qjo?=
 =?us-ascii?Q?Chuw/GqJekjqPTo+H1bViE0gnyhfR18Y4cs7G7FGh0Jx72XZ5Y6RC9QnH/bH?=
 =?us-ascii?Q?pLJJBw5jZi+dQJgTyPfoBVZO0Y9PnA4o0pfswvBleDr+kECcH9BXd62cMVvV?=
 =?us-ascii?Q?MRryzTfBBPiC2xlAG6AxXNzWor1wGzrNgmvx8cI/ztMHxntYtTQBAJOX/mBq?=
 =?us-ascii?Q?YQZfnaWtSVfBJr/IzD91XmsyANDvyv7G9qAT/X6TzHwfKatPAOvzuX2tLf6A?=
 =?us-ascii?Q?DdUdY71+XPM2oAVbS8diQYjnGhRBkpZyFPLbv93lUFur3iDAr0K0gQgFdwW+?=
 =?us-ascii?Q?8Fk/ekKpHX6qD9EfiHIOq5vFlHEK92m4LzNy6URHuzW/kFqCtKsVWRvsPQBR?=
 =?us-ascii?Q?pDnWG8tzJg8+KWNsq+mHYnGoXJPqHjAgZnh6+OmKkhE9CDEroEzdLEqzxo4Z?=
 =?us-ascii?Q?+VEQqbzOW1ylsas9/pSHOChVASgmWM7bLkfiQa9DOEHTWAIJr0e4C293mqTd?=
 =?us-ascii?Q?W4pgGlhl5V9VaFVmMdb8LlzQPqOm6IIvU5rXmnA2845ZdE8f/IHVg4mWjnoS?=
X-MS-Exchange-AntiSpam-MessageData-1: BCRHpxjBwvOiZyR8iFW6I9hjkgVH4m2FtJI=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 564a2678-cca1-4b6d-5dcc-08da1bdae38e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 16:46:56.5299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YdGgt87EHvg94aGpt/fn595YYkAxY3Zk0QByJV+kvRJ0g1wP8OzEKlOrWP2fzEHLhenAAYSUqdCkzvRBGymK088XOsl1XkgvbyRawf2UmUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8091
X-Proofpoint-GUID: TvDxs3Z_gm5dhR5JcT07lkrbyS19Z9dI
X-Proofpoint-ORIG-GUID: TvDxs3Z_gm5dhR5JcT07lkrbyS19Z9dI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_06,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On vmx_vcpu_load_vmcs and svm_vcpu_load, respect user IBPB config and only
attempt IBPB MSR if either always_ibpb or cond_ibpb and the vcpu thread
has TIF_SPEC_IB.

A vcpu thread will have TIF_SPEC_IB on qemu-kvm using -sandbox on if
kernel cmdline spectre_v2_user=seccomp, which would indicate that the user
is looking for a higher security environment and has workloads that need
to be secured from each other.

Note: The behavior of spectre_v2_user recently changed in 5.16 on
commit 2f46993d83ff ("x86: change default to
spec_store_bypass_disable=prctl spectre_v2_user=prctl")

Prior to that, qemu-kvm with -sandbox on would also have TIF_SPEC_IB 
if spectre_v2_user=auto.

Signed-off-by: Jon Kohler <jon@nutanix.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Waiman Long <longman@redhat.com>
---
 arch/x86/include/asm/spec-ctrl.h | 12 ++++++++++++
 arch/x86/kernel/cpu/bugs.c       |  6 ++++--
 arch/x86/kvm/svm/svm.c           |  2 +-
 arch/x86/kvm/vmx/vmx.c           |  2 +-
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/spec-ctrl.h b/arch/x86/include/asm/spec-ctrl.h
index 5393babc0598..552757847d5b 100644
--- a/arch/x86/include/asm/spec-ctrl.h
+++ b/arch/x86/include/asm/spec-ctrl.h
@@ -85,4 +85,16 @@ static inline void speculative_store_bypass_ht_init(void) { }
 extern void speculation_ctrl_update(unsigned long tif);
 extern void speculation_ctrl_update_current(void);
 
+/*
+ * Always issue IBPB if switch_mm_always_ibpb and respect conditional
+ * IBPB if this thread does not have !TIF_SPEC_IB.
+ */
+static inline void maybe_indirect_branch_prediction_barrier(void)
+{
+	if (static_key_enabled(&switch_mm_always_ibpb) ||
+	    (static_key_enabled(&switch_mm_cond_ibpb) &&
+	     test_thread_flag(TIF_SPEC_IB)))
+		indirect_branch_prediction_barrier();
+}
+
 #endif
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 6296e1ebed1d..737826bf974c 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -66,10 +66,12 @@ u64 __ro_after_init x86_amd_ls_cfg_ssbd_mask;
 
 /* Control conditional STIBP in switch_to() */
 DEFINE_STATIC_KEY_FALSE(switch_to_cond_stibp);
-/* Control conditional IBPB in switch_mm() */
+/* Control conditional IBPB in switch_mm() and vmcs/vmcb load */
 DEFINE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
-/* Control unconditional IBPB in switch_mm() */
+EXPORT_SYMBOL_GPL(switch_mm_cond_ibpb);
+/* Control unconditional IBPB in switch_mm() and vmcs/vmcb load */
 DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
+EXPORT_SYMBOL_GPL(switch_mm_always_ibpb);
 
 /* Control MDS CPU buffer clear before returning to user space */
 DEFINE_STATIC_KEY_FALSE(mds_user_clear);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bd4c64b362d2..7762ca1197b5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1302,7 +1302,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	if (sd->current_vmcb != svm->vmcb) {
 		sd->current_vmcb = svm->vmcb;
-		indirect_branch_prediction_barrier();
+		maybe_indirect_branch_prediction_barrier();
 	}
 	if (kvm_vcpu_apicv_active(vcpu))
 		__avic_vcpu_load(vcpu, cpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 04d170c4b61e..baaf658263b5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1270,7 +1270,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 		 * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
 		 */
 		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
-			indirect_branch_prediction_barrier();
+			maybe_indirect_branch_prediction_barrier();
 	}
 
 	if (!already_loaded) {
-- 
2.30.1 (Apple Git-130)


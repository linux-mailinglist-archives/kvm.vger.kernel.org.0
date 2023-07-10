Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B905174CC94
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 08:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjGJGES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 02:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjGJGEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 02:04:14 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10olkn2011.outbound.protection.outlook.com [40.92.42.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B61185;
        Sun,  9 Jul 2023 23:04:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U1JkHBv27q1KKhm3+oBo36yu9pT9nFjJg9bG5Mc8jGbeaP8g5FCMDg6DVh2OaXfXkW+gWUU7LqTgwTi4Yxf9LXZDsO5CpxbkQKJz0JhSKubdAG0DkjlLzd9X3oKY2lmHCUTIsFcm4uHB34gtX3GFkWDFY3ZAmcMv0PzKP/g9I5rSIzffIB9DlbaY+fNd2jpjGu3BuXu0JkegWXh4+1idpAdRpdJQUwjsDd8s7UEsRkTkHJJwYbCe+JD77SlAlTMU12bme+bZUa70BcpJsQNiZmXcPqO7Noip+wU4UzGTw/8eq3OU99rT8YF2eEqEThgHj9EIXsbttsliAE8VLFi8mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AG5qOS1eRnY5okVTiOY4dIiEDyzd0Xh/wa8H9C4RrE=;
 b=URnh0X6ZvfxC/iatn1nqd3vqin1fiKHG9249vYdAnmbzbfjwMBBDWKkqFyXm0ZByhtKTCc4xY1gFSIw3kt1rLLIZvIqHhAp557j2w9JghAeCl0GtQrVh4W4dPPqFsdK+zQv+LTMgRyYLkrH0Jv/dziOcU2bZurq0bP2yWJdX7GoeVwTDhksF4L7oZBvpdmAbveNTdT4r+kt/9wI8fLvbxLAwC3caatH95OM3e/Q9s3Hmb1YpCp1j2CszRoyvE9G0rM6e2iLW1kRJcCLXuLpeg9iqEDYJHx7dKYbd1znDEIKAOzNcQAdHXMeBHbW2zg3wzw3LQEThIHjoRu40M8HE1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AG5qOS1eRnY5okVTiOY4dIiEDyzd0Xh/wa8H9C4RrE=;
 b=TjJZAzGtjgIogYK8GXQ5Djg80Y8tddqPTZ746QEBqWnir0IbGzUwkONeQVlH3Huvk/vHWRb8lu+vsF5U/w9JwfT6qCFMk0uLMLHoWSNqkIJ9dpBbR9f/myeQ+SjnujTrmoYJIkcnxODuYunk3oB7cAf8f/CZMR2kISVS2aKzY/tHI/pjWGD1UTpPqL/0G4lvvj+TIsiNWgDV/fDizXOueVatJAqJKfd6N9bTeQQnR0rkfV+jEcEDoF+fLye3/9tblllTSMwwidNrMCrbJBuJI+18796Qbo0vm2kEZCcYU9rLFgZV59yzf2ZW4wxnQ9I/nDcqbAKFR1dhQJqVrGwnUQ==
Received: from DM6PR03MB4140.namprd03.prod.outlook.com (2603:10b6:5:5c::12) by
 DM4PR03MB6109.namprd03.prod.outlook.com (2603:10b6:5:394::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6565.30; Mon, 10 Jul 2023 06:04:03 +0000
Received: from DM6PR03MB4140.namprd03.prod.outlook.com
 ([fe80::d106:d232:850a:bd33]) by DM6PR03MB4140.namprd03.prod.outlook.com
 ([fe80::d106:d232:850a:bd33%3]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 06:04:03 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH V2 3/4] KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
Date:   Mon, 10 Jul 2023 14:03:26 +0800
Message-ID: <DM6PR03MB4140D749D138D9A97A521528CD30A@DM6PR03MB4140.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1688969007-3796-1-git-send-email-jianchwa@outlook.com>
References: <1688969007-3796-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [B1qCeMbYtVIRhkN/a3VEF0yvoqOLVszPj6Xdh665lSM=]
X-ClientProxiedBy: SG2PR02CA0090.apcprd02.prod.outlook.com
 (2603:1096:4:90::30) To DM6PR03MB4140.namprd03.prod.outlook.com
 (2603:10b6:5:5c::12)
X-Microsoft-Original-Message-ID: <1688969007-3796-4-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR03MB4140:EE_|DM4PR03MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e7df2fa-5d8f-4de9-ecfe-08db810b7649
X-MS-Exchange-SLBlob-MailProps: 7qh87CJt6y28mnXrYaz3TQtaqHIOdY46ovdhFRB6L8YmIXd3X3Ht9mwbas5v/JOqj7TZagMFOUuxtBId16G8Uc9N5HqLSCLlEdqIB1MLyDIRNmI389KVq8sMtWHWKQawg/gzPZRjltdYBIUSoGkC6TOJM3i/S9KYco3T5ttjx9KQ6GXsBXVayOrD+CvOeaIio9oVSDIilGGI+/bcpB5tFIE18quiDy6z4a3q2aTSh3qH+pEkNMvIjqlC3LuK+5dBTZIHBnEOryvv9J95Cd4tAeSVQe04x4n6OP3fgL0YQaP2nZBXakHVIHbZnBxuiMjTtrYRTZ4ySRkbGpZv6NzMIR3MUbx6ZImJEMWXJrIgP66il24guyCNDRet4x/IL5LAFrseLfi/sm8+m30bE/HbvJjzGwcLOWbEY4rGOCMq7jK13C81QcDlW6gk6RLG0VqRMbkFT7fhrNHau1iJOwY+jk+kgnJjP4FUQ/aYjLZX7AJiV1tAG6ovXP1zEZ17FRAkI9lP5XrMvmI9FnixomQ7fsfXq67jiOcVG48ak+ErmbrP4Zp89DwE9iz7ZS3gtWlyeYfDI/fLv2fPp/XorhlAnFwbfoL/o5Dc+g9LGk563qIwUJGDK05EvGFRw/vNB+P17yRZ3YqqsoWAgTf4BZVkSP1evM5p6sauujPbNU0101iPCpEVPXmLPdA+zeMBDOMECrLwkNX/fRL1CpNLuenuCss3IU0dZR0mbNErnUV2dQ8NM5qaj+F29TCh646nywdN
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s96A9UKHHnIDH7cxLv8bkNs/hFKyAPjK0kp5xyXBgrSx5WQfe4YWzGER5ZfsRo2FDa7xBF2cVQ3jegIC4WwtaLyqxGbCEr4msDVBvZuWablMg/2S8wDTmto3jnOF/8uo8JJGRyxHojShF46Lr9yjCcvqzaWAPoDBunxPzXDnXqYZXmuP3wRFnPWFnzUwm7ClxwfWt8BVtST29UV/qtbqR70+ryWWkq8VnT93/TXBLVNAg0oETjsQv4a3D0U0Ueks2/wtxXP4jbB/DUoBecP5mSyPuzGcTb6MnJZYBosb3xuOg6Gh7uXGe1XBbZABKEEw/iYjMdLIutAYvbGyJx+tBQozw0Bq7cmjYe75R88S9XxAys9xu3GiIiLmyx22TiXpD+v5+kqXaDnYllPE05jLN3fZ1KqGhlcsqJe9XFIYREJC3u+xp4fYkkctAMI/BmVB1vT1fAjJJPbjwleauXc7GPDJTV35NKRGAlprF+bjUFkO0V3WDBn3E4enSKh/9bsMexk4PVEa7g6oVW1h7qG9ODbNknFjiNPgwVygh+lSZwwJLhuG7ZS9FOSExWpqMCBZ
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6yZeNh2//C7uWZB9vl45wL2qwasqzPeG7nlGlMB9M+N7AuNm0b7CSkmi+CcV?=
 =?us-ascii?Q?cDBXmKDFicnxr1gbue3epjZ/Jj7EiUpludND712QoDYiyhuJCDIwFDZXpOkg?=
 =?us-ascii?Q?tutrx0ktfxjhI8boTqpRFRhhieAqjQt8qE1ahDiKcDBT9U9KUEK0ciE8owq1?=
 =?us-ascii?Q?kCE8KQ2MJheP1LMBUcULu2fekSu7z862U5ROQ4YGS9UFZJ4/2NIg85vmFN14?=
 =?us-ascii?Q?nUMIddaYquVs6KfJbgi4f25v9kIeVZO7xR9HJTJs+EAAp5jHQgFAgRFNk0eO?=
 =?us-ascii?Q?dd5phKzHyOm34zojdtv2dJsQ8Jhv1e5Hez0JRDcy0vhow9M0U2vc31WN48xU?=
 =?us-ascii?Q?qTcbVnYXtQcQp/dWQwKUlIvNIJdn0stFDn1c1sT4SAJsPUJE8VLPEK56bZTA?=
 =?us-ascii?Q?/dffDp2qmlfLkn7QyVtXcua1m9c57hmo6jakonBe+dCEGcC4T+4ljJBmMgoy?=
 =?us-ascii?Q?5DN7xC/2MuYEiDeGnf4wFKrIOCHUMVldga4mOhFlrvk29mZFERfhoSOm/ams?=
 =?us-ascii?Q?KAGrlRrbDPxWpXUgh/mjdlhyoho7PGrVMIXZKAsaR39N1U6zUnoMqtzcw/t8?=
 =?us-ascii?Q?Utn11KQgA7skqBEBwSa8eT55u894aBVjcu8IcJp/t02XOZtT3Q7YR73WVGGP?=
 =?us-ascii?Q?J9OqI91CeQzaGdz9nO2fsKlkdPnV5dUBZLMsbo0YKNVss1t3vx/+3ALqkFyS?=
 =?us-ascii?Q?17Xdo8VdlT81kFC0/zORORkS0r3IvmVLzO2e3YbxbMRrdUeToIDAfAXGcxyM?=
 =?us-ascii?Q?e/Or/CkArrnNHPIp+WI8lsPPFMPNo8qTdfBkdiM61cPcfaB/htL3An/ij26M?=
 =?us-ascii?Q?mzdV+TCztXpwmClg4btOd2Xuhr6gQGItDFI0CUM9J6zZBhfLyvh6OUnoMPos?=
 =?us-ascii?Q?iJ7JapUh0LLTRbxXXytaw9Ctil0nKnLwbE/A1F4MhC3su0fQeE1u0gR+lKaB?=
 =?us-ascii?Q?N81GVE/O7+ssw0gSkHgkOKVT4+GNuqwExHYyWyEWSYSgMSJSLLudzBm21EzU?=
 =?us-ascii?Q?iTWYsnas4r5+k0To1fFi0IM7OG3zH88imVNIZyq0YK1NoX7KXYdgR7GHhU1n?=
 =?us-ascii?Q?nl5usR9MMtJMClip0fFl8ApId4tJ9TmLvBUIa5SUOoTv+Y2pkm1OFhXfqYnw?=
 =?us-ascii?Q?/7Krw0K79uhUbteJypXihUXODYhyJW066zZrhuIW424xiPeh8g0B2SyUCH6B?=
 =?us-ascii?Q?62+u3VASk3O0bdDiMHqB5lKEu/JI2rd6UHKxYKgNX/lDculMTN7ewuNHqTw?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e7df2fa-5d8f-4de9-ecfe-08db810b7649
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4140.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 06:04:03.6117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR03MB6109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Everytime guest write msr of MSR_IA32_TSC_DEADLINE, a vm-exit
aoccurs and host side handle it. However, a lot of the vm-exit is
unnecessary because the timer is often over-written before it
expires. This patch add a new pv feature, namely, lazy tscdeadline,
as following,

v : write to msr of tsc deadline
| : timer armed by tsc deadline

         v v v v v        | | | | |
--------------------------------------->  Time

The timer armed by msr write is over-written before expires

         v v v v v        |       |
--------------------------------------->  Time
                          '- arm -'

The 1st timer is responsible for arming the next timer.
When an armed timer is expired, it will check pending and arm a
new timer.

A new data structure is added, named, kvm_lazy_tscdeadline, which
has two new field, pending and armed, which are used to exchange
info between guest and host.

There are 5 new functions for lazy tscdeadline, all of them are
operated around the kvm_lazy_tscdeadline,
 - init, when guest open lazy_tscdeadline with specific msr, it
   will get and map the page where kvm_lazy_tscdeadline loctates
   into host kernel space for accessing.
 - exit, when guest close lazy_tscdeadline with specific msr or
   guest reset or vcpu is destroyed, the page is unmaped and put
 - update, when guest write to tscdeadline msr, host side will arm
   a sw or hv mode timer for it, and also update kvm_lazy_tscdead
   line.armed. The guest side will check it to decide whether write
   the tscdeadline msr.
 - kick, when the apic's timer, sw or hw mode, is fired, it will
   check whether need to arm a new timer based on the kvm_lazy_tsc
   deadline.pending
 - clear, if the timer is expired and there is no pending one, we
   need to clear the kvm_lazy_tscdeadline.armed, to ensure the guest
   side can write to msr.

Here is the test result of a netperf test with TCP_RR on loopback,

                         Close               Open
--------------------------------------------------------
VM-Exit
             sum         12617503            5815737
            intr      0% 37023            0% 33002
           cpuid      0% 1                0% 0
            halt     19% 2503932         47% 2780683
       msr-write     79% 10046340        51% 2966824
           pause      0% 90               0% 84
   ept-violation      0% 584              0% 336
   ept-misconfig      0% 0                0% 2
preemption-timer      0% 29518            0% 34800
-------------------------------------------------------
MSR-Write
            sum          10046455            2966864
        apic-icr     25% 2533498         93% 2781235
    tsc-deadline     74% 7512945          6% 185629

The vm-exit caused by msr-write is reduced by 70% at least.

Signed-off-by: Li Shujin <arkinjob@outlook.com>
Signed-off-by: Wang Jianchao <jianchwa@outlook.com>
---
 arch/x86/include/asm/kvm_host.h |  12 +++-
 arch/x86/kernel/apic/apic.c     |  47 ++++++++++++++-
 arch/x86/kvm/cpuid.c            |   1 +
 arch/x86/kvm/lapic.c            | 129 +++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/lapic.h            |   4 ++
 arch/x86/kvm/x86.c              |  17 +++++-
 6 files changed, 196 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6edb1ac..6b20609 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -113,6 +113,7 @@
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_LAZY_TSCDEADLINE			KVM_ARCH_REQ(33)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -713,6 +714,13 @@ struct kvm_queued_exception {
 	bool has_payload;
 };
 
+struct kvm_host_lazy_tscdeadline {
+	u64 msr_val;
+	u64 cached_armed;
+	struct page *page;
+	struct kvm_lazy_tscdeadline *guest;
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -944,9 +952,7 @@ struct kvm_vcpu_arch {
 		struct gfn_to_hva_cache data;
 	} pv_eoi;
 
-	struct {
-		u64 msr_val;
-	} lazy_tscdeadline;
+	struct kvm_host_lazy_tscdeadline lazy_tscdeadline;
 
 	u64 msr_kvm_poll_control;
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7705571..0fe1215 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -62,7 +62,10 @@
 #include <asm/intel-family.h>
 #include <asm/irq_regs.h>
 #include <asm/cpu.h>
+#include <linux/kvm_para.h>
 
+DECLARE_PER_CPU_DECRYPTED(struct kvm_lazy_tscdeadline, kvm_lazy_tscdeadline);
+ 
 unsigned int num_processors;
 
 unsigned disabled_cpus;
@@ -492,6 +495,43 @@ static int lapic_next_deadline(unsigned long delta,
 	return 0;
 }
 
+static int kvm_lapic_next_deadline(unsigned long delta,
+			       struct clock_event_device *evt)
+{
+	struct kvm_lazy_tscdeadline *lazy_tscddl = this_cpu_ptr(&kvm_lazy_tscdeadline);
+	u64 tsc;
+
+	/* This MSR is special and need a special fence: */
+	weak_wrmsr_fence();
+
+	tsc =  rdtsc() + (((u64) delta) * TSC_DIVISOR);
+
+	/*
+	 *  v : write to msr of tsc deadline
+	 *  | : timer armed by tsc deadline
+	 *
+	 *          v v v v v        | | | | |
+	 * --------------------------------------->  Time
+	 * 
+	 * The timer armed by msr write is over-written before expires
+	 *
+	 *          v v v v v        |       |
+	 * --------------------------------------->  Time
+	 *                           '- arm -' 
+	 *
+	 * The 1st timer is responsible for arming the next timer.
+	 *  - armed, the time has been armed on host side by msr-write
+	 *  - pending, the next expires time set by guest side
+	 *  When timer of 'armed' is expired, it will check pending and
+	 *  arm a new timer.
+	 */
+	lazy_tscddl->pending = tsc;
+	if (!lazy_tscddl->armed || tsc < lazy_tscddl->armed)
+		wrmsrl(MSR_IA32_TSC_DEADLINE, tsc);
+
+	return 0;
+}
+
 static int lapic_timer_shutdown(struct clock_event_device *evt)
 {
 	unsigned int v;
@@ -636,7 +676,12 @@ static void setup_APIC_timer(void)
 		levt->name = "lapic-deadline";
 		levt->features &= ~(CLOCK_EVT_FEAT_PERIODIC |
 				    CLOCK_EVT_FEAT_DUMMY);
-		levt->set_next_event = lapic_next_deadline;
+		if (kvm_para_available() &&
+		    kvm_para_has_feature(KVM_FEATURE_LAZY_TSCDEADLINE)) {
+			levt->set_next_event = kvm_lapic_next_deadline;
+		} else {
+			levt->set_next_event = lapic_next_deadline;
+		}
 		clockevents_config_and_register(levt,
 						tsc_khz * (1000 / TSC_DIVISOR),
 						0xF, ~0UL);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0c9660a..5a12601 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1118,6 +1118,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
+			     (1 << KVM_FEATURE_LAZY_TSCDEADLINE) |
 			     (1 << KVM_FEATURE_ASYNC_PF_INT);
 
 		if (sched_info_on())
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3c300a1..4462bac 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1681,6 +1681,94 @@ static int apic_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
 	return 0;
 }
 
+int kvm_lazy_tscdeadline_init(struct kvm_vcpu *vcpu)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	struct page *page;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+	void *hva;
+	u64 msr;
+
+	slots = kvm_memslots(vcpu->kvm);
+	msr = vcpu->arch.lazy_tscdeadline.msr_val;
+	gfn = msr >> PAGE_SHIFT;
+	slot = __gfn_to_memslot(slots, gfn);
+	pfn = gfn_to_pfn_memslot(slot, gfn);
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	page = pfn_to_page(pfn);
+	hva = kmap(page);
+	if (!hva)
+		return -EFAULT;
+
+	hva += offset_in_page(msr - KVM_MSR_ENABLED);
+	get_page(page);
+	vcpu->arch.lazy_tscdeadline.page = page;
+	vcpu->arch.lazy_tscdeadline.guest = hva;
+
+	return 0;
+}
+
+void kvm_lazy_tscdeadline_exit(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.lazy_tscdeadline.page) {
+		kunmap((void *)vcpu->arch.lazy_tscdeadline.guest);
+		put_page(vcpu->arch.lazy_tscdeadline.page);
+	}
+
+	vcpu->arch.lazy_tscdeadline.cached_armed = 0;
+	vcpu->arch.lazy_tscdeadline.page = NULL;
+	vcpu->arch.lazy_tscdeadline.guest = NULL;
+}
+
+static void kvm_lazy_tscdeadline_update(struct kvm_vcpu *vcpu, u64 tsc)
+{
+	struct kvm_host_lazy_tscdeadline *hlt = &vcpu->arch.lazy_tscdeadline;
+
+	if (!(hlt->msr_val & KVM_MSR_ENABLED) ||
+	    !hlt->guest)
+	    return;
+
+	hlt->guest->armed = tsc;
+	hlt->cached_armed = tsc;
+}
+
+void kvm_lazy_tscdeadline_kick(struct kvm_vcpu *vcpu)
+{
+	struct kvm_host_lazy_tscdeadline *hlt = &vcpu->arch.lazy_tscdeadline;
+	u64 next;
+
+	if (!hlt->cached_armed ||
+	    !(hlt->msr_val & KVM_MSR_ENABLED) ||
+	    !hlt->guest)
+	    return;
+
+	next = hlt->guest->pending;
+	if (next && next > hlt->guest->armed) {
+		kvm_set_lapic_tscdeadline_msr(vcpu, next);
+	} else {
+		hlt->guest->armed = 0;
+		hlt->cached_armed = 0;
+	}
+}
+
+void kvm_lazy_tscdeadline_clear(struct kvm_vcpu *vcpu)
+{
+	struct kvm_host_lazy_tscdeadline *hlt = &vcpu->arch.lazy_tscdeadline;
+
+	if (!hlt->cached_armed ||
+	    !(hlt->msr_val & KVM_MSR_ENABLED) ||
+	    !hlt->guest)
+	    return;
+
+	hlt->guest->armed = 0;
+	hlt->cached_armed = 0;
+}
+
 static void update_divide_count(struct kvm_lapic *apic)
 {
 	u32 tmp1, tmp2, tdcr;
@@ -1726,8 +1814,12 @@ static void cancel_apic_timer(struct kvm_lapic *apic)
 
 static void apic_update_lvtt(struct kvm_lapic *apic)
 {
-	u32 timer_mode = kvm_lapic_get_reg(apic, APIC_LVTT) &
-			apic->lapic_timer.timer_mode_mask;
+	u32 reg, timer_mode;
+	bool clear;
+
+	reg = kvm_lapic_get_reg(apic, APIC_LVTT);
+	clear = !!(reg & APIC_LVT_MASKED);
+	timer_mode = reg & apic->lapic_timer.timer_mode_mask;
 
 	if (apic->lapic_timer.timer_mode != timer_mode) {
 		if (apic_lvtt_tscdeadline(apic) != (timer_mode ==
@@ -1736,10 +1828,14 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 			kvm_lapic_set_reg(apic, APIC_TMICT, 0);
 			apic->lapic_timer.period = 0;
 			apic->lapic_timer.tscdeadline = 0;
+			clear = true;
 		}
 		apic->lapic_timer.timer_mode = timer_mode;
 		limit_periodic_timer_frequency(apic);
 	}
+
+	if (clear)
+		kvm_lazy_tscdeadline_clear(apic->vcpu);
 }
 
 /*
@@ -1927,8 +2023,15 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 		expire = ktime_add_ns(now, ns);
 		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
 		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS_HARD);
-	} else
+	} else {
 		apic_timer_expired(apic, false);
+		/*
+		 * If the current pending tscdeadline has been expired, we need
+		 * to clear the armed_tscddl otherwise guest will skip following
+		 * msr wtite and clock event hangs
+		 */
+		kvm_lazy_tscdeadline_clear(vcpu);
+	}
 
 	local_irq_restore(flags);
 }
@@ -2100,9 +2203,11 @@ static bool start_hv_timer(struct kvm_lapic *apic)
 		 */
 		if (atomic_read(&ktimer->pending)) {
 			cancel_hv_timer(apic);
+			kvm_lazy_tscdeadline_clear(vcpu);
 		} else if (expired) {
 			apic_timer_expired(apic, false);
 			cancel_hv_timer(apic);
+			kvm_lazy_tscdeadline_clear(vcpu);
 		}
 	}
 
@@ -2153,7 +2258,9 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
 	apic_timer_expired(apic, false);
 	cancel_hv_timer(apic);
 
-	if (apic_lvtt_period(apic) && apic->lapic_timer.period) {
+	if (apic_lvtt_tscdeadline(apic)) {
+		kvm_lazy_tscdeadline_kick(vcpu);
+	} else if (apic_lvtt_period(apic) && apic->lapic_timer.period) {
 		advance_periodic_target_expiration(apic);
 		restart_apic_timer(apic);
 	}
@@ -2483,6 +2590,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 
 	hrtimer_cancel(&apic->lapic_timer.timer);
 	apic->lapic_timer.tscdeadline = data;
+	kvm_lazy_tscdeadline_update(vcpu, data);
 	start_apic_timer(apic);
 }
 
@@ -2657,6 +2765,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	/* Stop the timer in case it's a reset to an active apic */
 	hrtimer_cancel(&apic->lapic_timer.timer);
+	kvm_lazy_tscdeadline_exit(vcpu);
 
 	/* The xAPIC ID is set at RESET even if the APIC was already enabled. */
 	if (!init_event)
@@ -2762,15 +2871,19 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 {
 	struct kvm_timer *ktimer = container_of(data, struct kvm_timer, timer);
 	struct kvm_lapic *apic = container_of(ktimer, struct kvm_lapic, lapic_timer);
+	enum hrtimer_restart ret = HRTIMER_NORESTART;
 
 	apic_timer_expired(apic, true);
 
-	if (lapic_is_periodic(apic)) {
+	if (apic_lvtt_tscdeadline(apic)) {
+		kvm_make_request(KVM_REQ_LAZY_TSCDEADLINE, apic->vcpu);
+	} else if (lapic_is_periodic(apic)) {
 		advance_periodic_target_expiration(apic);
 		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
-		return HRTIMER_RESTART;
-	} else
-		return HRTIMER_NORESTART;
+		ret = HRTIMER_RESTART;
+	}
+
+	return ret;
 }
 
 int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0a0ea4b..30a8cf1 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -278,4 +278,8 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
 	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
 }
 
+void kvm_lazy_tscdeadline_clear(struct kvm_vcpu *vcpu);
+void kvm_lazy_tscdeadline_kick(struct kvm_vcpu *vcpu);
+int kvm_lazy_tscdeadline_init(struct kvm_vcpu *vcpu);
+void kvm_lazy_tscdeadline_exit(struct kvm_vcpu *vcpu);
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15c265a..8270bd5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3873,8 +3873,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_KVM_LAZY_TSCDEADLINE:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_LAZY_TSCDEADLINE))
 			return 1;
-
-		vcpu->arch.lazy_tscdeadline.msr_val = data;
+ 
+		if (!(data & KVM_MSR_ENABLED)) {
+			kvm_lazy_tscdeadline_clear(vcpu);
+			kvm_lazy_tscdeadline_exit(vcpu);
+		} else {
+			vcpu->arch.lazy_tscdeadline.msr_val = data;
+			if (kvm_lazy_tscdeadline_init(vcpu)) {
+				vcpu->arch.lazy_tscdeadline.msr_val = 0;
+				return 1;
+			}
+		}
 
 		break;
 	case MSR_IA32_MCG_CTL:
@@ -10576,6 +10585,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 		if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
 			record_steal_time(vcpu);
+		if (kvm_check_request(KVM_REQ_LAZY_TSCDEADLINE, vcpu))
+			kvm_lazy_tscdeadline_kick(vcpu);
 #ifdef CONFIG_KVM_SMM
 		if (kvm_check_request(KVM_REQ_SMI, vcpu))
 			process_smi(vcpu);
@@ -11965,6 +11976,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	kvmclock_reset(vcpu);
 
+	kvm_lazy_tscdeadline_exit(vcpu);
+
 	static_call(kvm_x86_vcpu_free)(vcpu);
 
 	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
-- 
2.7.4


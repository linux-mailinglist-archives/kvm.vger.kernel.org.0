Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1074374AB3D
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 08:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjGGGkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 02:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjGGGkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 02:40:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12olkn2064.outbound.protection.outlook.com [40.92.22.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D831FE4;
        Thu,  6 Jul 2023 23:40:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KvU8/dMsicvbnxqUT1DJ9LCpytPbAOp6sZKZnThAJQA2OvROoM2S8EMZ5+Thko3iTSZWhsb1Sx18LCCmkSenOyZZPkqfBafYsxYlsInfPlvuqvsbzBje40jrX8lVr6f9soRioICdXf8ZwYDh7D/6KCOxJafEoQsdGhK4FcgznJgCAL854vG1oJqPEMLJpwFOuyqd/r3U1CvpOd/EIexov6Kev2WqkmYOtU9JWeGbkgPjTtRTfXGhVdi63BQVw8VufvAySVbBqGXJ2HfS9Ic5U3I9MkLiY940odn6en/lAy1ZRGngfhEGIrWvQJjMS8rPfhVzYuklAEk6ZkjrLLrz7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=chGnkZflC8iekcTM3+anSczdX6seyNvZF211+zivXAA=;
 b=N0HzlhbgBVFEmc3mQL7+wuMLCz1nHxfr3gfYWYUqvlHoX/57hLDimNYtMu5G2qO/LeiD064sMfcMG3IhdTGDiJfnjJPaTe6pQ3Z5Z856uH2Jl7lvB2Hu8PZMKOBQCqwh+p6imeI5LBa3y3HbU4ujP89sHgu5BKrT1hGQiwbCLuLo4IaZIxVFcI0RiJjV7KMUaVUEEu76FCZ7J3u6W4jKKDTrDCCl8flCwcamRF1Uo0/xFU4a41KawqC+/9qCZ1axPW9Qv1aKpcNoy+IualMFih7TfTs1dj37J/PILUY6d9GNbfurLfm1sCNkzzb9D+xvTcUBmHw2V16p0GzQgWNwnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chGnkZflC8iekcTM3+anSczdX6seyNvZF211+zivXAA=;
 b=NtuWXY8vpuJc/2oQCm45KDRjT4SEstW0Rjw4JFHJmWtm9wmaGQgJfocyKjCQDfJyXyH2b0OnuiFBpozN3cPihQe43haMJ1aA4xV+M7U1qeP++KAGB8XhRTbJvI/rKtZjwQ6E6fPn6blQQBbxzgrWhMH3Ar0OHL3KglOpaT9abfkEt5gvHyqZFNsHFx+K6VU3MPVauHu7xiRlGb7/+qWyoKIdy1vI+kvOCuwM6BsS6xUjG7NQCloTDWgG8R9V7xBcN7PPB/MJ+GMasdGARJvPHX2l8HIJePEx+LItZY4E8XTBs5SnfyLkbtCsFqivUXbhh93OD7dsj9qzCvFtTZkLyQ==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by BN8PR03MB5138.namprd03.prod.outlook.com (2603:10b6:408:7c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.25; Fri, 7 Jul
 2023 06:40:10 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671%4]) with mapi id 15.20.6565.016; Fri, 7 Jul 2023
 06:40:09 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
Date:   Fri,  7 Jul 2023 14:38:33 +0800
Message-ID: <BYAPR03MB4133AA70FAF897FD2E145FA3CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1688711913-23638-1-git-send-email-jianchwa@outlook.com>
References: <1688711913-23638-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [9I7EBKreMsmPdGD5pYLrbfFG5Q1yVcsG]
X-ClientProxiedBy: SG2PR06CA0215.apcprd06.prod.outlook.com
 (2603:1096:4:68::23) To BYAPR03MB4133.namprd03.prod.outlook.com
 (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1688711913-23638-4-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|BN8PR03MB5138:EE_
X-MS-Office365-Filtering-Correlation-Id: e7003419-815e-425f-ddf7-08db7eb50251
X-MS-Exchange-SLBlob-MailProps: 7qh87CJt6y36AGtJtE3eAQUqDJjjc43RN2XrOMiaQpPfAXQgkiKlX2WpQKTwCjeME7veSUE78Mth4NckoiQ88Ft2qfBymYcNWwmTSbjZkxc/3are8fut4Udu3YRn7XHfYDPd0cAa9OA6AbB8kjTsRg8Rt7sa9GzILBADN79iodAdrQUrnbVm8QyfR42yd1oaTiIHVv+1LJKNiuXAl62lybQjOleoUZYkXfeoR0PaQgAQ2tmCg7wZfjqqcNL48pK2D1fksBEElzh9Nhn7FB4x813/9btk2x7B5KbT99ucZKACSt376TT4+5pU+iOGqPLApzHnf+bVQNBrjgN5v9SdgMnYbhXuSoaiCnKOjy0zlIVJNiaSqnstFbl4zwNsXZP+esfPaQsCOHN6Gcvo2WeP7rS3lrqtgJSOilvVyFprnbAkMPal1SO/M0sU3galgTTKRMgLEscGqfghPJezm+h9ocTfTGbLqXRQcCzjsBqMAssZ6PZUq/VK8qAODx7/ee1QC5umT0p7JIS76dIRYBUL1iIm54jWLW4metb+kMVLkPBqoWIB8yDLCOxndmNHwQ6rGnZmgoLsck7p+FuJDIL1Hi0+oMSK4HJY9e88oBTcmNtEo/kvLMin6bozYzlfD8hlkyfNYNF3qwymnmmwi+AzQbRVthW9rnjin4NcQvMdwZpmSwUL2xRV7x9qGq3rcRDxROwaT9CpAqydrHu36C9CMtSDtUD687a6cTRYnHCEFQFLSw4X7Kv2ODiFm5PE4X00
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5sGwIsOP45Iibg2gzssh+8tmj/cKs40+D/oZjzdhB5CC508bUrparEy/CFIFUatntjFqj3lY/Dxr7y4VmI8H/BaR8daouyoiVaf9kuhDAYuK5aX54zv2ZfSlHM4pRn5G19rENga3nFb3Zfd4koz7ntGwnrOCEsJYC4hB/wZCD7/X64whLtdXLown11tTaCMXHBkc9AeoCjHowDXj/rp7dmHrZ3yQoP+C3l109tMZ2fTbBYWxYq2VPIl3V9iQ1Aw/31W2JpWZ7dSZYkHOOqSOeUV5vdBAFsBKwfsfuBZuJRqPW1N0ar6DDQ/ZeAlOc/zNK658wbvjt9Ub9vnaj5KTR4BQIlyaEJF0nn/sZ6tKTatZW3qGXm22/ibbPNOij7IJdgjpZnb3CGKLYcODAJLpMPEU2UN+M7Hy/LpThPaidYujShM7V0586lSVkDUVJCnbyV6Y2IUuNI1ZTXGwvWFv06l5e6hmZukvGynMAWe4J4LpZXmpT4HcvDjtr6Y0E+eVLpxnB7s9qgYRpyQitkYlO+4ZnsrKkBFhYQubf74e1nnzyOzECz1kuqGn/h4OLHVL
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?COaiFhu9Vq1RcXXtJ3bG7YkvTEmr4o3kguKWSIMwxnxtNbAPvMxj/PH5FQQw?=
 =?us-ascii?Q?TQGfpsjJOJckc6CJxhBO4iFp7xPa2QD68aPoOmVYpaS2huwOpBSCfiWi6pkC?=
 =?us-ascii?Q?ZDeXKxnFsh/iq37Z5NREPx3qFJsTblRpHt/WBggpnDcDFi0avBQHcH3KJDev?=
 =?us-ascii?Q?2QXflIl9AKVMkRyYKx5k7zGNd6QajQdvW7uElvjQ8zD0bNxjsxehwn5wQm90?=
 =?us-ascii?Q?jsZ8Rt0ZGvuK11F2IwUg6LIYFdcegykfGvxBIVFIoPyrqdJjA8Tevys7xnpQ?=
 =?us-ascii?Q?Uk9s9CSSk8KrNp84cAtfd0VbXToHODyCcgyrdrrknyzyZ1+lY+pjQoidlcG3?=
 =?us-ascii?Q?lqKU+Kx5fR5FK7Anz/CWNa7dhhUA6thizeH7N0dfBdeuVJgN/4MfKN++1s5O?=
 =?us-ascii?Q?Y8gE5his/41N0SKNI4FNBg6Zf7FlkEIU4H5ohxecnU4cPVJHH3wEeaP3SNYb?=
 =?us-ascii?Q?NxhGmTH2WeowtPW+vDdj+TiJAzOCFR0OstEBTcYFTzdu8CaXihFZUMyS2x/b?=
 =?us-ascii?Q?+pTIiTlP/6PNbuP7xGL6QWN9ux06kEXHEEngAlTfqmUHpBo2XJYgeIJADg9p?=
 =?us-ascii?Q?r3gNsiec6PhS29jsMMwagiZEHSNAByfhy2JcJOoQ90GKwMU+f/CR7M23KTVI?=
 =?us-ascii?Q?gGQN7QW5gBt5DUq7jIUKVoRUC1EjQ+73mXK9Ne48Xm1if1dyxI/b/7mjw8EZ?=
 =?us-ascii?Q?ya8IB7mA3ltwiOX2YyRcJUhiUfU8buirkFzjhGcsiP/UCxcOCLPcZEOFgBBE?=
 =?us-ascii?Q?HfqaQIm+zMy+vneWlqtEd5k50Z+Jt5EeYkfKZkLay8pn7zEQQngrT1ej1kUx?=
 =?us-ascii?Q?d4MGu3W/xqEGJy4qGOAqG+UGhdZWEmZu4HmXG2WxTEICnPXDzukwGGjBwdCs?=
 =?us-ascii?Q?rBgIbpVOHO1GpseGzPhec0/SgLsUZ202KyTenT4eMLsGTcs5dJYxmNZ9IUEz?=
 =?us-ascii?Q?c+VZVpPl/A7f5aTE0UiH3Kj+hx2FpjNQQITJrFLaTkXem/FcGgtnyVPhgPNK?=
 =?us-ascii?Q?DaQqrOPeleAyleG3P4ltXOT3yTEuAsLBTdGDQZ+4Z12NYnr2E3Nxi0yEdOKk?=
 =?us-ascii?Q?dkVgvmMr46dXydh6Nnmu8AMhZE7eaaKC1ATpHZmqU8R1LnJu4HKxsN0HFSj8?=
 =?us-ascii?Q?G8Z4xQf90ilZJYt9Ug1/kkGnYQvkRxUVQuLm5GubvlLUHDCVFZvTa91Sqd8W?=
 =?us-ascii?Q?6Nfx0rimKsYJ794lMrHYjmjd5AnwMea2yd8xQpGpkuev7ub3+T7nZN1oBJY?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7003419-815e-425f-ddf7-08db7eb50251
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2023 06:40:09.9574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR03MB5138
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Everytime guest write msr of MSR_IA32_TSC_DEADLINE, a vm-exit occurs
and host side handle it. However, a lot of the vm-exit is unnecessary
because the timer is often over-written before it expires. This patch
add a new pv feature, namely, lazy tscdeadline, as following,

v : write to msr of tsc deadline
| : timer armed by tsc deadline

         v v v v v        | | | | |
--------------------------------------->  Time

The timer armed by msr write is over-written before expires

         v v v v v        |       |
--------------------------------------->  Time
                          '- arm -'

The 1st timer is responsible for arming the next timer.
When an armed timer is expired, it will check pending and  arm a new timer.

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

The vm-exit caused by msr-write is reduced by 70% at least

Signed-off-by: Li Shujin <arkinjob@outlook.com>
Signed-off-by: Wang Jianchao <jianchwa@outlook.com>
---
 arch/x86/include/asm/kvm_host.h |  12 +++-
 arch/x86/kernel/apic/apic.c     |  47 ++++++++++++++-
 arch/x86/kvm/cpuid.c            |   1 +
 arch/x86/kvm/lapic.c            | 128 +++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/lapic.h            |   4 ++
 arch/x86/kvm/x86.c              |  17 +++++-
 6 files changed, 195 insertions(+), 14 deletions(-)

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
index 3c300a1..9d137c8 100644
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
+	struct kvm_host_lazy_tscdeadline *host = &vcpu->arch.lazy_tscdeadline;
+
+	if (!(host->msr_val & KVM_MSR_ENABLED) ||
+	    !host->guest)
+	    return;
+
+	host->guest->armed = tsc;
+	host->cached_armed = tsc;
+}
+
+void kvm_lazy_tscdeadline_kick(struct kvm_vcpu *vcpu)
+{
+	struct kvm_host_lazy_tscdeadline *host = &vcpu->arch.lazy_tscdeadline;
+	u64 next;
+
+	if (!host->cached_armed ||
+	    !(host->msr_val & KVM_MSR_ENABLED) ||
+	    !host->guest)
+	    return;
+
+	next = host->guest->pending;
+	if (next && next > host->guest->armed) {
+		kvm_set_lapic_tscdeadline_msr(vcpu, next);
+	} else {
+		host->guest->armed = 0;
+		host->cached_armed = 0;
+	}
+}
+
+void kvm_lazy_tscdeadline_clear(struct kvm_vcpu *vcpu)
+{
+	struct kvm_host_lazy_tscdeadline *host = &vcpu->arch.lazy_tscdeadline;
+
+	if (!host->cached_armed ||
+	    !(host->msr_val & KVM_MSR_ENABLED) ||
+	    !host->guest)
+	    return;
+
+	host->guest->armed = 0;
+	host->cached_armed = 0;
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
 
@@ -2762,15 +2870,19 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
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


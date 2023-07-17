Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BD87559A5
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 04:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjGQCfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jul 2023 22:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjGQCfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jul 2023 22:35:45 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2018.outbound.protection.outlook.com [40.92.18.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE251A4;
        Sun, 16 Jul 2023 19:35:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dANYz7v9QXweyScmdTfqzYgTcH3+zn3JfHgBmRkZyMun0HI5RUFVK4Hf5zGtsr2COG14E/YHxy6AGxjqFxBsvDwS9qZSTAjXS4h5Nip092whFiEMCFsdhDTnbAwdaoP3VFNkz8cXmliMcH1FOqdrCFGU87dyh+TXO6uqlwXowN3NeXKVoXxzZOrdCsSE3ipoIL4p6nPjhdje74hPSejSaCpt329VNdugcni9NmOvp0HWKxX0Lxgrsg52ptjLyCO4O1y4p5CJWStTTVb/+p0Xi6+y7ErkxezaY4Li6TKjn4Ua8lKLZxONXL8NJ061HvntS4AdjxEUO/BwoER/9ANwRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2K4QPVlPmiavqoWNx+qPnXEMZAPacACTRcHqitVF8U=;
 b=oXURXQ7tZbKEd7BRit02abrcy3nEFCadCTQV64GP/zfLdAO6DB47SgZDWJ2g3z6sy3ww7s9DnWHJoGr501gjY7G2dx/43SZb1dCyUMFn3jbQ5Smcx+OScBh5Zirqzc3o4o3/2yXphwrwyH+iXVy2fYxwvo34VYMqlg18dRdmGLv7zoe9+zB+l0RAdREgz0TdBzSbkO/sZoKTk8e/6UENitNm97F7Gz4Jmv0R8woHGZEIKnpGl744+01hK/rCvz8KZZyX7sgiNwqbtw6DhQNOLXfPrgeZtXZs8te3hV7dDx4Q0zBzV0IalOihCZdigswyvccvoUjVOvwbYKs1JnjvCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2K4QPVlPmiavqoWNx+qPnXEMZAPacACTRcHqitVF8U=;
 b=FWASkue4Q27ppq+TS51qV9GO1T2K9tBqCptvq/vay9KX3/nVygOEt66JOutJgU2jvbhMoZ91iXVm8OJK+aeeAH4lAJQt5nEn6j4g0tescRe3NIsQlM43pBPThvU9SKRPWB6L3KL06ZQ/JOzKB+19rr6rVquDkRVbBAdQmGReeMgSxW+1MyfRTAGwsvDBhSe5wgq8NOhiDC1i72K2JDKDuEy8q1mku0ALGYnWXHRlWVR2qYgsOTl+myixd3BgrlDcqUE/aTZtv4+jVvzOzjJuhXZNfIQ8eH7pDjoRavZ1gsxtliWSUKMIq+xAEb1I4/1tDWWqxAH6+qlYpULPlttwBA==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by PH0PR03MB6512.namprd03.prod.outlook.com (2603:10b6:510:be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Mon, 17 Jul
 2023 02:35:41 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::d952:a79b:d824:3b0]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::d952:a79b:d824:3b0%4]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 02:35:41 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, zhi.wang.linux@gmail.com,
        xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
Subject: [RFC V3 1/6] KVM: x86: add msr register and data structure for lazy tscdeadline
Date:   Mon, 17 Jul 2023 10:35:18 +0800
Message-ID: <BYAPR03MB4133048F3CAE7E32B7334106CD3BA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1689561323-3695-1-git-send-email-jianchwa@outlook.com>
References: <1689561323-3695-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [L4oA4qjE0MF81/q/G/81jLijZrS/MIsboZPHUH52v/I=]
X-ClientProxiedBy: SI2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::6)
 To BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1689561323-3695-2-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|PH0PR03MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f484a08-7a4e-47bd-24aa-08db866e836d
X-MS-Exchange-SLBlob-MailProps: 9IecXKUgicBAsOHsxkVJ3Zy3WHwqGpfPYOays21zM9FQpoKWLhuSb+2GvtFr9yRc9oeV7Fq6+CHeq5WV4T2CPCYcdhk6km6/l/POJzYaeci2w/ORoxLAmQ7v2GlVEXqMoFvHNHWTgNonMjcNy3PdwHgf0/YeVDaJ8gHEwWz6ZdGaxUeQyikDdUbEs1Go7YtREZUnW6HJ0rNL7Npn2b7i+runjfTX+RNS7vCYXPdjVnIrZzWel4NohpJyVdXAzs+6EALeqHtoQeMwRY4GxT+vEUy2CtzGgGIMTVVgXgixnmvigRAlX6QW5b+nukP99ywmNn1xywF3tzhW/hc7hmtZWAsJp57CpsB5bFaUK/oOM35T98Mf205z58FUVhJo+QZ72DGjx4Dy4xFFRWHFA6Wyjj2cysKUWmBmyZq+r2ERPqusPVXv5bVuF6F9ZVXM0sLwyeH3rijnGlmrtRU2rBsAYLZC3squGuH2ngF5SzosByAaezIE+i3KX/3tVuKFEjXDPNM8BwLOTyL2uXOjKxKUJfJnfFjJg/FiXfoY8anM5lwfp2RoywJMCZynfYXj78vHiteFBJHaYIeX5JJUJy8OAs6qg2Njo4iuIB4LTJ29D+s09zYEDLcLqnCLATBTWNKyhrYLQIInfuHUxtxTteFMiwnqd4r5xRdOaZ1cSGtGPAt0jE6XtN/ClMHgY4/c2ovERWtfR1BdnLoSx8vd66qo2epue+icCS18q+gADH0NL0fy5G/HAJ04Rw==
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XPY1xoI4B8ZZK8/ZJ6A9nWRo77uK4tqoGzCD35lQzMblqlULtOzBM/eLWgL5cwiiZu9vXXTH/9u2gmUQNhMqT54V3ZUGJsbZZJ3uTjpJOQq20wv5KtPzQ80ReKPWRuDIhDBTPxJahmwGaHbNC474hpaTpMunB94hJW99JL43xgqUWmvcw/XwBVbk7cnVaLvWIFx2cClXogz5zBNFzP1310Ovyx7BAUbGNfIMXwDySk/4V8bVLh7G0t1NeSqYyjJskXP9ze9eDuJv96y745Y6Q2e9+eI16KXoDL1eA47r2Jz48S3Jz9I/6SxpkmZ58f9IY4oFdQ+cdiBaruxbt+gZEKG1rQVusY0hSI1gz+0LcjG7hJ2gSiAAQ4QpbSIPfLTv63dtcRCkbZ7vvdV6L0noqepmyfH50yaIPKP817q+W8Yi25Cm1t3AFHsbvLM5W8K2Vo2hcpOE2+PjDE9rBICFuE5jFs/Ckyyr2OGykWgwIRktVVHvKE8Gpj0SThweIofyj4hgbr8BOfNbSuSRhfyfOkI8FUh3ZUBqTUP+6nNsklp8JjzyltdZtcxhpbSdyM6r
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e7rAKfYTYwzO4XA9oCU2wRjK9/Y8f4+q/HwTROHuFheHT7l+16PrjF1b37eY?=
 =?us-ascii?Q?XbllLYVum3Xc6U9G2yHbs+FOd+D2pd/mr0k01AnlHanqxJuEMV8U1P4bHfG6?=
 =?us-ascii?Q?flxdt+HaKIhfteI3fspsYWYG/BdVWPAX4EFvxyZqn1j8WCwtg/+ZdWShfqxc?=
 =?us-ascii?Q?SLJ8bGqa83KrvZuXgrEbOclZXUUGk7lMFVY+4hyCTe09Tv/hnlPU6Y3UUYgs?=
 =?us-ascii?Q?ziAg1xulGbUryUfSgvkeuVTWLNMV8xr5yzlg9bg+pyIfsPd7T/7/IlwPnSGX?=
 =?us-ascii?Q?MLZoB8At9sCkIVf0/OtiKluBoybZEaj/0URhlEMkkUwc+62GljTb9w9pxwwL?=
 =?us-ascii?Q?Z0H5I35d2KjlwnVOgYuPwuWDya51KDSGpakcdmu7hk1//w+anPkXRe1/k/e0?=
 =?us-ascii?Q?2zWGmLxW8hX0/L3rNZxbxe38X027y/Batus70KfZP+Bpy52PouVfNwO/YcHo?=
 =?us-ascii?Q?8sU+eWzSYsqVxaE48y69aGoIrV26I6opuhr9T30drOvLRvMa7qPpE4VEN0pU?=
 =?us-ascii?Q?Rg4/xVcDyIfchdtoUjdUVwbKHDmwcYUJu1vexUXW0m5iEieGvjKISlNQ7bMN?=
 =?us-ascii?Q?vJz6qYmqUWmUq2CejHCFnkEU6D2TKxktq38HlxxDpyp7jP08MAz7XTuCJsnP?=
 =?us-ascii?Q?raKQ1hII5icpK/brAgaprrd/knhHU7MZo3e+fMs6dPlnoa5c3LUOGaIeitQb?=
 =?us-ascii?Q?UufVafJBG9wEe6jvkBQGz3MlF/YASwwSXuyKiEdqwSgTjgFPcQPn7p1zQVre?=
 =?us-ascii?Q?8pEj29q/2ETChP7fzeCw0vTe4hMcf91V+PppO1GZtKu0xtvm+YhcoAgNnaxP?=
 =?us-ascii?Q?eh98VT6QdQwAel4gx/MEgjtN0AKNpTWUE4YEW8sGGk2TOvLUnQfjZ08ENcfm?=
 =?us-ascii?Q?lHFOrmPF5ZpiMJ0WZIH70UAdWpt4+euj2+oOm5/aiXx1tGMx1bxpf5dEx3UD?=
 =?us-ascii?Q?v+oq0MMBmWE85q0ny4g7zUecOFhGOsGmWmHKg4aPrFUwPZNVI/k83YE4e87F?=
 =?us-ascii?Q?B/D0mSQWJHUhJKsxh5IpStenQCpJ1hEKe+zgCcq8fgXDZv1gwsLk+Jj8XrED?=
 =?us-ascii?Q?9hLOaHyF1hjUA/LToDIoXyxA9T5LQlrTS9V7ybRz0iSI/A+HulnScElBrZO2?=
 =?us-ascii?Q?3VRnFQjuU0UEZYQGH8KZ7c/NlANyjqCea0ctUsV84PxV1kDIHSJ5Ic9gUYF1?=
 =?us-ascii?Q?oyaWErfWy/d1uhPrvjuAl5sp38+rZu2j/NtZwuE+yZWlPVypbw1LT3Cl9QY?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f484a08-7a4e-47bd-24aa-08db866e836d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 02:35:41.6610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR03MB6512
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lazy tscdeadline is a new paravirtulization feature which target
is to reduce vm-exit caused by msr-write to MSR_IA32_TSC_DEADLINE.
This patch adds things below:
 - a new msr register to communicate between guest and host
 - a new feature flag to tell guest open this feature
 - a new data structure to exchange data between guest and host
There is no functional changes in this patch.

Signed-off-by: Li Shujin <arkinjob@outlook.com>
Signed-off-by: Wang Jianchao <jianchwa@outlook.com>
---
 arch/x86/include/uapi/asm/kvm_para.h | 9 +++++++++
 arch/x86/kvm/cpuid.c                 | 1 +
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 6e64b27b..86ba601 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -36,6 +36,7 @@
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
 #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
 #define KVM_FEATURE_MIGRATION_CONTROL	17
+#define KVM_FEATURE_LAZY_TSCDEADLINE	18
 
 #define KVM_HINTS_REALTIME      0
 
@@ -58,6 +59,7 @@
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
 #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
+#define MSR_KVM_LAZY_TSCDEADLINE	0x4b564d09
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -84,6 +86,13 @@ struct kvm_clock_pairing {
 #define KVM_STEAL_VALID_BITS ((-1ULL << (KVM_STEAL_ALIGNMENT_BITS + 1)))
 #define KVM_STEAL_RESERVED_MASK (((1 << KVM_STEAL_ALIGNMENT_BITS) - 1 ) << 1)
 
+struct kvm_lazy_tscdeadline {
+	__u64 armed;
+	__u64 pending;
+	__u32 flags;
+	__u32 pad[11];
+};
+
 #define KVM_MAX_MMU_OP_BATCH           32
 
 #define KVM_ASYNC_PF_ENABLED			(1 << 0)
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7f4d133..bbebf81 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1117,6 +1117,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
+			     (1 << KVM_FEATURE_LAZY_TSCDEADLINE) |
 			     (1 << KVM_FEATURE_ASYNC_PF_INT);
 
 		if (sched_info_on())
-- 
2.7.4


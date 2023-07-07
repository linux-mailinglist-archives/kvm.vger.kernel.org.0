Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B155074AB06
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 08:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbjGGGTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 02:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbjGGGTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 02:19:32 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2029.outbound.protection.outlook.com [40.92.18.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E5419A5;
        Thu,  6 Jul 2023 23:19:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4/r0A+T7AED2mPb/KnFUTPTIPln2Xh3IDS/yrRgLm/2pfB5fqf29gGFWAJ5RlQ8mq791jAtMU8clayfgIwPjesWf6YsLZI4phgeMbuGv7cGhWH2gHRBtzX1Ewle6SeQpUWvmC6P6a21m2jkOdN9Rtzaq1O80AgM+53hZTsXu9V5fRKzEuL9sVt/GR/lqtLgKXWM2QAxxRi0MtqLQ+F/YeCQyawdSJ1uu+8hpK7Q+plBzXZzWNzn14gnYsGLvOQAQon4TbD3bs0oo7mEiAxJHc/7P4rQuPQyF9hOneZP22xOnAYG8sFUYCRBYxI4zyFqfgeKHO6Llq3LZukijuRhaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvCe70H0di5lIEKkvUXPfccNijNyq4Al2N9wTWKFDns=;
 b=jXflTV0/xje9EMxUx0goCZYyawU8C+ROxzitgHAkqRVznXO1jcSFR3YCukP0FwCotQEpUguanL9p3f+ugZQLP0CX22hd79/db3Lf+x5fYn1q59aId5kDRxHAt9b6vTheRsy99xxHIMuENdsSRU0mVBE1yprb8bonHMG6P7KdsJGqkg3L8aE0wtyPt2XJrdO1e1QXygPE6CvFxJi0qpf+D5lfmnpSoZnVrUhvmn6zj6YrYdg6pz1Y6J/o9Dxws2pJEXKFesBCuQWm5tXbCmSt96nNVh7GI6CT1J7cdsYccegv3b+C3vqpZn4BWB38iZaEiGsk8yYrxizX0q1LMe+gtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvCe70H0di5lIEKkvUXPfccNijNyq4Al2N9wTWKFDns=;
 b=pf9vTzAXBKLsTbGecKn2mHA/kzMO3n9rA/BgVoqoBbwD48WE/BliYDeWXr2k3mfu/AgTA87He4//WH7Bku08v90XkVzc8/4WTnysqL0vH8TXLVWb5KEE/23tFP1u/CSHCB7c5K/yzNqfSHOv12ar3kJTZ8BcS5n/wBFPRGTJgKq6CLzGpJaTjedzR3xnUBXRIy2teEB50LdiZr2wHGTvv0tJm9K79M4dZpJiGf6MXbpZgaIt5w5q/Wg45HwXGK784LX2vOdW/QicDy57F2ZYVFchOQEEn+COReJYU7e0OsjhFiWq9Of/Fza3yUGAaqcaZ2q0wb/WnGHpLDaYfypnaQ==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by BY5PR03MB5201.namprd03.prod.outlook.com (2603:10b6:a03:221::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.24; Fri, 7 Jul
 2023 06:19:29 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671%4]) with mapi id 15.20.6565.016; Fri, 7 Jul 2023
 06:19:29 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, linux-kernel@vger.kernel.org
Subject: [RFC 2/3] KVM: x86: exchange info about lazy_tscdeadline with msr
Date:   Fri,  7 Jul 2023 14:18:00 +0800
Message-ID: <BYAPR03MB41337C60D3D8EE4934962C38CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1688710681-22896-1-git-send-email-jianchwa@outlook.com>
References: <1688710681-22896-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [bTfLPlRfnM72mDbwy4UoxTx+J9HW7R4veqA7z1S6PsA=]
X-ClientProxiedBy: TYCP286CA0131.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::13) To BYAPR03MB4133.namprd03.prod.outlook.com
 (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1688710681-22896-3-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|BY5PR03MB5201:EE_
X-MS-Office365-Filtering-Correlation-Id: 53e7ebb9-72bf-4251-081b-08db7eb21eb5
X-MS-Exchange-SLBlob-MailProps: 7qh87CJt6y36AGtJtE3eAQUqDJjjc43RC1H8gHie+vwv3+USsUyW2aDaX5vLOtOs2DzRmU8V7SzseVENG15x5xSTJnVw9dCVTNXTNaM/uwstTu4GbRI6CE9L9IZFxClDgRCySx0k5/bTGRKoX3EBK8jgrrDdWez39pmrtj+5lZrqzLuh2J5Hff6gyzYHV16MkDFtY0cxfn+Zdr2oNezTa4sPpAW+FLbPr+xL6ZP7wXqtlz6NN3U3R5HBIWw3sbh+3+ogJ9qjkdbjDQCPK1S9b8SWTOKcpDulXndVUzWP5i4ortrKQvgCKk6vckuRBcdOUY2pPD5dDBquA8Zuw2AE2oYzpOHKAXxhrI4yBEzZZOWteNj1D9GDZ71w/6p5aPFB8wv3rbb0CW0ptlL6YcZsvoNwEW+BaWnMXhoCAJ0Dux1cLVQRWi28EmDYMsymqIUciW5GK26whJQuorQeyYdpTZzGJLClH636+9AMmFzsVOPQcGilUqBnIxTQBxrZCIOstZtA0jDT6cd5Kv4Ohe6V+MHWN4TsiHJWykt0wOonfRnldoOnEvlCSH/mlvs4vtR0Egvk1fpZgJ78CahODmVjMFc61MywYcreOD3+z3fwdWwgiFZWugyqgApupMCqnYx49P2QZfWmGBELDzonZO5o0DJALaaU8PfmjGcef7tcSXyAbpClJOwYfD6x9HOOnBzuqfAzA6SPV64nD95u+TBIDmA9RKlPAKEJK0jJaZfcsFG/SkGZZPwWamy4Cz/GiY1y
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5748S2kNpUbQI9RQ8a1cDbcQbT5W6eGCbn/BARQSvTWEfMVvoQvInE882S71b9zZIVckm64iZzFj9YrT+DYBnoynMvGim8gDoh0JYJoQgENsrP+NmgK065UsvaV4Op/dX4WqSnvvK5HFiR8WjVl+WPJcCQPlLuN2DQxNg6gZ25YKwyzRzUkbHlXT6EgHDINv19k1gVCKlFvYMaPTVXNtlXnaju9IFO/LzNEIOgO/o9X4mej8QSPO6ZMncMcZpNcvNv6RI9Rha67EwjDTPODs4QuP6PUWBIhJi9ur5uAgS+GC/xTqBC4aKp6Z/d+sHla2avMTWy83pE91yo7xgDtZi6QJ/jLAKoV0i+ceSMPfCj7k9BAsAtLYc/1dL3hv+luoDgjqZcB/ZnblL7P4r5ZKl3Lo4CUhkiVn7d/BTrLuPr0/n6h+Bon1fNY35BlbO3DrfubqUY2QKhPElle799LjRGqj0Qx1+v1luGEmroUH7y5qSD+UFbSvmu3rFC+SP/bw2446hrAoAU0WMsfI+BsLF0Gl4RBgTGzXWDY7afVb8faZxfxalUM38kYyE/lUh+fn
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?euDjIkNi8KBMkSjHR9Mn5bz22wBbC0uNzi+tOQj3bEJMCgNjvVGgvhr1ebIm?=
 =?us-ascii?Q?4GxAGU/PDQCY0l98Y6dKWipzXrJGsnY5P/Mo6ar4ubaMFV1i8KWO8RwIXgFp?=
 =?us-ascii?Q?HYGAa7+NRTjttA3HujtyEfayQxg1zDnlE0Cqq1mOo22pRhT7CT/loN9tWGso?=
 =?us-ascii?Q?Y8LIXg+tYC9Q7vLSga/GCZVh0EvaRhH4/2zpmNbFXEDIt8JhNg3e5HYLpKYu?=
 =?us-ascii?Q?CqaAKp+c1dA+JUbOpqgEEPUOe2qPn6Lt531OaRn4UVsVzDVDYSZQksW45Vkg?=
 =?us-ascii?Q?wSjrAXPBzfSqo79/jmy/8mJwFX9mLWSnU5kos8xEYaSpMoYUFokl7DQ3ekTE?=
 =?us-ascii?Q?CdMC5He3DaGy0LPcnoCbFzND4hAx0bGA+3KRIkGQgsVUb39and5CS9Vuscfm?=
 =?us-ascii?Q?S0Rr2BfQN/Ve4C6kKVGmVQif9PA2+RTJk0TF70Jvd3T8msaNl8ewWTOpdZBQ?=
 =?us-ascii?Q?uyRe/VGhClT3YMao2QshUq7uGyUy3j0bXZjVpD6lrgW2/DeGaGWuxRF+fOWB?=
 =?us-ascii?Q?X4vasX9XurDL8oZFBCs6UFV64rZmID8P0AjHGu97UtBjx2xD+o5yRxlygnzH?=
 =?us-ascii?Q?XPyLgHybK59ov4WAz3XDPkwwvKTHgNaIFDPjoJyb5Ri5hwwtYtzYWuDrDisz?=
 =?us-ascii?Q?sbJSWLa+Kt2o3CsW53bFgqiblb/vtFm+hxUMIny7zzosRxIwmlekvIx3feQg?=
 =?us-ascii?Q?WbJ2XmEKAX2OTkMZASb0NLHBfhx0Z5uh02kiH4rSCVtjG2wOjpViGmwpseIp?=
 =?us-ascii?Q?CDen4ngjLbV2pIHP0YGakKP6i/C/g7VzrkoJRyP2JPGO+4INlatV+vNhchKd?=
 =?us-ascii?Q?DKB1lOSgReIutLLMJ+kCwLJgxfd8fEARt1EjMpwugr6J2L7vByHmLLnszPs6?=
 =?us-ascii?Q?dN2GFdktjpEXmDDAipNG0sMNJd+UT7yIkBeZ9q081RcgA0zk9JrOYAJ0AMS9?=
 =?us-ascii?Q?/+FrKv/7gvBekxK5fgX7oshrp+Pk8yLq/A+auMH/f/cXIdsUUfu5+fK84Qif?=
 =?us-ascii?Q?ZuC0XKV/vmEIwRZADVYYwEjpkv8L6BRjB5UBa6OECHjByxKwoyYdzm88izkd?=
 =?us-ascii?Q?La9NJ3owSOte6Ny3ku4tRjIeQ+LN8AiuuW/TMXW0zgDkCiYgPi8Do4rkvQcA?=
 =?us-ascii?Q?6dj+oFYw88qYTUVQHybNjGExAVhkJBjuU3sbmaHkY8GuhBviA/0/fgTrWZAV?=
 =?us-ascii?Q?JObt206Ft/gGBLOwdiDbJND9NE3iYG2AX6mxghiF1zUvrC2C9FFmDA/U8c8?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53e7ebb9-72bf-4251-081b-08db7eb21eb5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2023 06:19:29.0685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5201
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The lazy tsc deadline hasn't work in this version but just tranmit
the physical addrss from gust to host sdie.
 - Add data structure in both guest and host side
 - If feature is enabled, set msr of lazy tscdeadline when guest
   cpu is initialized and clear it when cpu is offlined.
 - Add msr set/get emulation code in host side.

Signed-off-by: Li Shujin <arkinjob@outlook.com>
Signed-off-by: Wang Jianchao <jianchwa@outlook.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kernel/kvm.c           | 13 +++++++++++++
 arch/x86/kvm/x86.c              | 13 +++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fb9d1f2..6edb1ac 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -944,6 +944,10 @@ struct kvm_vcpu_arch {
 		struct gfn_to_hva_cache data;
 	} pv_eoi;
 
+	struct {
+		u64 msr_val;
+	} lazy_tscdeadline;
+
 	u64 msr_kvm_poll_control;
 
 	/* set at EPT violation at this point */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1cceac5..91eb333 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -67,6 +67,7 @@ early_param("no-steal-acc", parse_no_stealacc);
 
 static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
 DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
+DEFINE_PER_CPU_DECRYPTED(struct kvm_lazy_tscdeadline, kvm_lazy_tscdeadline) __aligned(64) __visible;
 static int has_steal_clock = 0;
 
 static int has_guest_poll = 0;
@@ -379,6 +380,16 @@ static void kvm_guest_cpu_init(void)
 
 	if (has_steal_clock)
 		kvm_register_steal_time();
+
+	if (kvm_para_has_feature(KVM_FEATURE_LAZY_TSCDEADLINE)) {
+		struct kvm_lazy_tscdeadline *ptr = this_cpu_ptr(&kvm_lazy_tscdeadline);
+		unsigned long pa;
+
+		BUILD_BUG_ON(__alignof__(kvm_lazy_tscdeadline) < 4);
+		memset(ptr, 0, sizeof(*ptr));
+		pa = slow_virt_to_phys(ptr) | KVM_MSR_ENABLED;
+		wrmsrl(MSR_KVM_LAZY_TSCDEADLINE, pa);
+	}
 }
 
 static void kvm_pv_disable_apf(void)
@@ -452,6 +463,8 @@ static void kvm_guest_cpu_offline(bool shutdown)
 	if (kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL))
 		wrmsrl(MSR_KVM_MIGRATION_CONTROL, 0);
 	kvm_pv_disable_apf();
+	if (kvm_para_has_feature(KVM_FEATURE_LAZY_TSCDEADLINE))
+		wrmsrl(MSR_KVM_LAZY_TSCDEADLINE, 0);
 	if (!shutdown)
 		apf_task_wake_all();
 	kvmclock_disable();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04b57a3..15c265a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1552,6 +1552,7 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
+	MSR_KVM_LAZY_TSCDEADLINE,
 };
 
 static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
@@ -3869,7 +3870,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
+	case MSR_KVM_LAZY_TSCDEADLINE:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_LAZY_TSCDEADLINE))
+			return 1;
+
+		vcpu->arch.lazy_tscdeadline.msr_val = data;
 
+		break;
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
@@ -4222,6 +4229,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		msr_info->data = vcpu->arch.msr_kvm_poll_control;
 		break;
+	case MSR_KVM_LAZY_TSCDEADLINE:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_LAZY_TSCDEADLINE))
+			return 1;
+
+		msr_info->data = vcpu->arch.lazy_tscdeadline.msr_val;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
-- 
2.7.4


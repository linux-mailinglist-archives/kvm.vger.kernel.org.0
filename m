Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB6B74CC92
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 08:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjGJGEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 02:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbjGJGED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 02:04:03 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10olkn2071.outbound.protection.outlook.com [40.92.42.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAD6FE;
        Sun,  9 Jul 2023 23:04:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTMZNMM1hOrgVDkxNVLplw3/jVuJK6RSdTQqwR+C0+CULKEr/6+ZEOc91g/DwEllqY7mbuTunkRYD0SZvlcmjGhYsZyNQndyFBa0apoIv2B6LT3j20M8hrqszLM0lUC4Gh19K3UnVudK1Eq1cPwdMZsH7nVGTY45Q6gq3Ol2iU7XoqZ3BxsALO5kdU/MWAko/hUK9mT3/FtGXIg1s11i7CXnsoqqEWrURU0simXXkLLEpExvJbTdzCUfwSnHBcjCkGMeoT2g1GFMKpzYFxcnqsO82CV28oANAyUTi2aZQsAt2d/V3qB3jxa7WhiO7UiqfuxDEuXbzu7XIiPUS2oylw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvCe70H0di5lIEKkvUXPfccNijNyq4Al2N9wTWKFDns=;
 b=VQTr7DTQRM8Pfgv0mPFzayAXaxiKNaWeMBWIHFLh9PnSSVAv/G/VkaUh54Uoap3phIPkOf1l+l8vJWByt2xkoHfmmuup5esl9PWgK4DEXK+TbvW/M41Jn4SL8Ml05rGm6P0owClIBiY125alCkAA/d538rwmVHnoR3WK6VANc4EGpytkUQiUcqTaKNnW+sD0kWT3zMnMwUetV3FJ93Z4jiupEUE8oWKmN7QpxS5ZXO3xDRze5n+hyyzdAhDqiiJ8kTmGU8B1vl7yanSp6ipqhwGnaJPVadaqPIxxWZPDGjyWVHFHbpE2Kp+Cu16jAwlJrqw253eqBxzBSAL7/xZuoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvCe70H0di5lIEKkvUXPfccNijNyq4Al2N9wTWKFDns=;
 b=aw9Rtd36lhyBS3mFK8wmY2Xdic/xH78IcdSZVUlJNHw3uzh895XU9A7hNE7aigG7CVXAi23VkTDGGhHD5AXgtfKDI8FT6hBdbTJvcQhDNVkYtNum9Oqg6O33b/NpGcSqGSkcxxqsO+ueTb0HfdKi8vRPbw5W02oNJNjdcVTKr0B7YWKMhg3FyChSTVf6mX+PdFsrcKAMHhKk7DSep2e7u/goLQjcUanOxwRgPB7YRRjCfO5eMkJUhGbsgU7wEMU8qjYIgXkubCT8wtVrA2YssWRLbKRR74+UW+eajBzfQ37i8w0LxR6W/WgOVKxQHH4dw1P/UPlsBAVsut7tIUwt6A==
Received: from DM6PR03MB4140.namprd03.prod.outlook.com (2603:10b6:5:5c::12) by
 DM4PR03MB6109.namprd03.prod.outlook.com (2603:10b6:5:394::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6565.30; Mon, 10 Jul 2023 06:03:59 +0000
Received: from DM6PR03MB4140.namprd03.prod.outlook.com
 ([fe80::d106:d232:850a:bd33]) by DM6PR03MB4140.namprd03.prod.outlook.com
 ([fe80::d106:d232:850a:bd33%3]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 06:03:59 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH V2 2/4] KVM: x86: exchange info about lazy_tscdeadline with msr
Date:   Mon, 10 Jul 2023 14:03:25 +0800
Message-ID: <DM6PR03MB414084C523F654200AB6BF2FCD30A@DM6PR03MB4140.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1688969007-3796-1-git-send-email-jianchwa@outlook.com>
References: <1688969007-3796-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [BxZ2MQsUKVlqahplK0O5uZxjk6uGE+kEWS/IcoRpbxA=]
X-ClientProxiedBy: SG2PR02CA0090.apcprd02.prod.outlook.com
 (2603:1096:4:90::30) To DM6PR03MB4140.namprd03.prod.outlook.com
 (2603:10b6:5:5c::12)
X-Microsoft-Original-Message-ID: <1688969007-3796-3-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR03MB4140:EE_|DM4PR03MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 46843e19-be48-41b2-5233-08db810b73ba
X-MS-Exchange-SLBlob-MailProps: 7qh87CJt6y28mnXrYaz3TQtaqHIOdY46M8/9xlCgSxTkDfJGBDMncVxruL0ddgvBQgXggPpPsxyTe3ggHmNvMhsRzyAI1L7tPlpVnbl7FBcKBYNhcPkBIw/WlYLdQwkCu5suicqpxCJ3XrIOaJP70Ah5vlx/jKBYvxOR4yKpXdzsl90qFqq0CIQdOnT3WSlnCduvOdXHB0LHcgQ7yweWJybX396TjolXWA/oZvBJ3OwqQseyfny6KSGT5JEO9Op/Tgqm8kerja4214bioPXrjf22gjPfXRGTFMK3Js49TZYmmyPpk3R7ONhPDugBUaaYvX7mbrMcfXvCFGRTc3qsLLY+aEQoTCyyMLZp0QFx4EUGvRHjDduyEFxGEmuO6TefX/v/DYDV+V+ZvkRZgFcAi9DaiWrVuarfdSw48MZ34piPCDbutKaaIElwpDhADd/OjVX/Xm/BqsC+/gJ2wweIklsDW5OZTxWNJlYz7qzHVu2kw8RSP2OC6y7kXaHiXwOg3LFO7xSWSSh5zfm+k5J7doCpdqMX3ir3Rhbw55NqNV+XfZkMDP1wqmsWp7Ulipp3xZNJ1ipk10kgsNMEYmLwXvBceGzeecC0eNbed/jyEsGsUgcpdpFH/R9YePILyPcGKeZ2yXRpT8B536QJGnxki7KtvDCFHVjOAMTp1ztC30wRRfNi4iouoNQZv8NcaVI39jPEqyWMsJjAozrE7uIHwKQMsCYq1dDh+WWy/hOMr5i8fx8RbMtI3Ysp+MLO5EdU
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M0GCY1eFiwh33+4cGOGIgAD3LqViRehXpOnV7dNxv/ahF/ZDr/ZYs38eEXl2XY2m98kjwqUltxE2T9ou6ApsPoQkuXyBLuzqIU0vfRGdnUDkkfznGNKjlBLB6P1uarF7avIyTcFl2Z19U1DjddoM0IBZgVfE+2CMspwyjydQmJU7QAANmvYEyRuxlkswUaMS7UHfyO3WArirQaWZd0dnIJyoDLsY/2k0BySEh5gUBeMNMrnLBSQMYekPZhuiCEuFu2UW2I7udWcMHkReOkpmoaMIksrUFGRva4EwNDJ55ezZrg8EbqgkiLR0XfmpQopr+QugSI0SaEm1+ztrMSdAAz7IBvOWPo65o9yAdmmraPW6D6Ikx/Nk9oB7WeWxj3sfPqRH4Ms0N0hIKa4FP8zNEWkuMjlbFiNnGGMmBHdvJZ2KlODFoMBOsR4SN+wq349JmTs0z2g9pTo3OpRQmpIy/CHlcTy4ltHd+TlEiRB8dYuXIaeE/tlhFPBkf3+ymzILstHUdjcGLizBV9J+pAxvnY8Xwn5K2R1BFdbI4e6ihCzz94BVuoyQDZL+jIGe36zI
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UFgm3Jx5jcz84cNLjX6cepTXXfe+1NPgFPZQRl6jml+8jiIVlYaj1PmLkCIZ?=
 =?us-ascii?Q?AhRNVn1qHAQTEryz/tg0mierHR2l7CbEvclq6i5hI/BsYABk9Se0YII/9uju?=
 =?us-ascii?Q?sdxfBSr+Uc9ffByflCcj94fuHxC/0mkeM3VxMgwrR8esw82xJ3VoxDtovFjH?=
 =?us-ascii?Q?stvp1gtdJyc2tias99JNf9OB+Ap9F9QyuUXIQ9cdeYwZJJrcg8f22E4Dre+L?=
 =?us-ascii?Q?gGlvvgLTrp5WVHBC3LDJNuzpOroRNT3vmnW/u9kHhJ9A8JMPPCR2sUwdUhqN?=
 =?us-ascii?Q?jcOZ2M+Lvx/RopHUjZb12+VEE2tTWCDMOjRbJSTIgR9z5iY5PyRJA5XndlKQ?=
 =?us-ascii?Q?gUu9yy0gA4VgMMN9FSnnltRNae897BmC98E5O/cAGWM2S/X7N6WpkSxdE/nG?=
 =?us-ascii?Q?sdppqecvh/YNO375+lVAkoGupmi7qsiV90c74D9XcPj0p18wp4H8u8c+Zwc9?=
 =?us-ascii?Q?TXpRFQ+pThqxKyc6lIHJuG7LXM2sZMdzMoHcmQhMU5d0Qp7/zQLPFaNajlNZ?=
 =?us-ascii?Q?pLfe70Efmd0seMY3qRKS/J0zQ49AVfEaIbuCkA02Me2sQi8PeFQA04gJZN3q?=
 =?us-ascii?Q?CmknCIevOJgPUvRaz8LBtCxfCPoiJ39wvL1WwmHYjLD8OzHxbIwjkNrpSLda?=
 =?us-ascii?Q?Ed4qF//4G7WWdRzTnW9j4Oqi+SdMy1dY087FegMfpMFXnBzKh+nNoCch0IbG?=
 =?us-ascii?Q?cKWdxJwwgmUqjotRgG935V+fuJX+HthO31ng6kquFvnO5tGlU1jwAEChzcAM?=
 =?us-ascii?Q?Effe7Kj5sG6vQcDXuR6Uqiv+UE4GmPpDnVoEz7O/wLp2esZ1J5fq4QJyPMMv?=
 =?us-ascii?Q?gJyfpgx47osQrLTSTm74bAQ2CiA3SgOqP0KhM81FHV7yr+EJIbekj2irDPKC?=
 =?us-ascii?Q?v6wlwbBr0V8yLaZzPkYhIQXyGx8Qm3ZRd3M6DrnfWFtNPJ1pCVcN0+D1jnPA?=
 =?us-ascii?Q?QVulnohQYmGj9urofqI9jR8MVDh4rZp1wi93vsVDwbWk98m5mL8saqQjITgD?=
 =?us-ascii?Q?0exk4nJ1CsvE03vcJgHp0CtXcvXXUa5JQlLXjupe3EvihfPc+k10oGzA+aIS?=
 =?us-ascii?Q?1XsruL+CwbvqTaP4/Kx2fth7c8luW5fM99tModMSiTOK72Bxixg9totGbr8c?=
 =?us-ascii?Q?iG5pAvn7ZFhkYx01yN+HJ+pynnXvSNJCag6KnTB8OKk5SsGBzy7KBs/lCswU?=
 =?us-ascii?Q?M15HRejWHmqTlVwPvx//JUD+vTP8eG2MYEisQP8EARu5UMNv802Gv+3A35E?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46843e19-be48-41b2-5233-08db810b73ba
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4140.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 06:03:59.3066
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


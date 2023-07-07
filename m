Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3340B74AB3B
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 08:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjGGGkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 02:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbjGGGkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 02:40:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12olkn2067.outbound.protection.outlook.com [40.92.22.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195AF1FD8;
        Thu,  6 Jul 2023 23:40:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRAJJV9oE4VzuuiFeNUzmrwUO3RMpk0M0ndP0eBQaQuc2odc611b5Gi5udJpAJwtt2qWc16hVkqEhND0XA1poEkYE6iNIZ8YuaU4LVapTHOeI/ilHHXuY2Z4e5imGTp6eWR/n/hRKWOrSkTJPU3NKUh1yZaMDm57VD2+JZgvMYaTA7Udx1KI+auOc5dRgbAf05HWiiMchd/VmM8HL9Ist70ZjdM3hLeNWeyzR0FJC3SUxyEsTHO2s2OpRZH74OJNN3q/vd70c+kvVjFthigR9v+p6rX5k/OgLP7Hszq3VVWrkL26KTVn56XFkpE1aKgDRKtlB2CLrIF5f9AKoNIxaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvCe70H0di5lIEKkvUXPfccNijNyq4Al2N9wTWKFDns=;
 b=iScysZcTXSONe4dobuZk4pGbOLjHluarRsz4NIPPwiOZ4SyTOuQkgi1nBeU2k5nTmHZi0A29gS2thrQ6YcJo1le9Ebdteh2wfETaIiI+OSxT6WiZVD6BkTWJqMDHEN6d1xgMuvZNcLTlyB58icsHduCtJMJZHnzPqO0FXPaoWUs/mT3ZTe/1dICLb5P289vAQwZw4tv1TVQUfXzl+HFpz6WkOc67XvrCWWsYirT/9LuMw6wh7b1HuavWQmjgelhh+A13zfJ4pqDdRmkeYaYbY0u1s0NOqVWLrey7xrr8o8rAR0iT1zB+civTlMTy148J7Cyue/wkHfaEM8vX0TWKGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvCe70H0di5lIEKkvUXPfccNijNyq4Al2N9wTWKFDns=;
 b=oAbGdYO3JaD6i/gQAlPBId3eqKDugqeprX4+/YwA+jPSOEz9LSgJ5k8FQvcUvgrOgBQP/XKocDwUuZmZS5Ps37FGjFo6wulnVYjtKJIzkXt0KhMwnuiezudzEN9NhtTYZorcQ9vdTN60rk5WQXKDKv0AxtA3OuCjkGJhqdUcn9KzvLgYM9/0czz9tfWujt3uDC1PXRwFEtZBTq3vhFoZ/TWGSZCHeG5ST1O3K8+yXDRUCE5NdqFF0Bs5ztG7poUVoch29XnecPylpaZNWQ79plNLcd5xSuPLrUnSD4+D0GP4VVmPbp6+G1c084zdAFR4scBPmzoa0jtrKfqnPxATpQ==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by BN8PR03MB5138.namprd03.prod.outlook.com (2603:10b6:408:7c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.25; Fri, 7 Jul
 2023 06:40:06 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671%4]) with mapi id 15.20.6565.016; Fri, 7 Jul 2023
 06:40:06 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/3] KVM: x86: exchange info about lazy_tscdeadline with msr
Date:   Fri,  7 Jul 2023 14:38:32 +0800
Message-ID: <BYAPR03MB41339B020C6A30DE40477122CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1688711913-23638-1-git-send-email-jianchwa@outlook.com>
References: <1688711913-23638-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [DqV3tZBqlYYDX2W6lze8qzF2fSrxtiiU]
X-ClientProxiedBy: SG2PR06CA0215.apcprd06.prod.outlook.com
 (2603:1096:4:68::23) To BYAPR03MB4133.namprd03.prod.outlook.com
 (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1688711913-23638-3-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|BN8PR03MB5138:EE_
X-MS-Office365-Filtering-Correlation-Id: 103e2e24-bffc-4598-4ff3-08db7eb50013
X-MS-Exchange-SLBlob-MailProps: 7qh87CJt6y36AGtJtE3eAQUqDJjjc43RS/UClgVIyXObArdGOnlMv14mFiUFXjV35xfqVoV5qB+gTisBU2iL1d2aj/RggwhArHbEYPSMGmq0uHO3ID0WYMFnKI3FV7Yb21aPmycsFBh/8cRWQ8qGUIoGYimQMjrX7ifNY/ilO3PIoxq23ikf8tMfjXC7YABG1i97KviBOyrMgjFaqcAoUdHOCWOdOLZVXkRjcaS5nRYCZZMNE+lo0FibIJ+FaUax5C5LR+GodjQdqee+cFDQyxH1hk/TJYdAYBF/NLz2KbCzlr0AXbwt11cOAYZhnItlX4kwi/+fX56I0CyfZmop7ID9bIYjVTyyH5DZ9SWDv3NNSg9PbtpgusEaREomftxGymJFDg+0h52o2Bsi3WwyGLH9uh7TJcCXB9XQTERut1b5NHi7PgtrxVfSBUucfa1XYm0lCxlspYybnsnF8eauYVtid/0lKjCQjJbYffY0BJPsd4w+lFCt0YYz54YQdDumYo8tk4kJbM77JPu/4JbzLaThIE0Ur39KkNc4L/H8ifQqHG9Ynwfot5DM0EKmN09U8nBBzErigHfK3yt8JQJ4jgi25zR8orgYCnZBuJbTg5c1lw/K3NtIvkVMkPdgTUYf/QA+4q77/+9jdIwI6IuMuWupZ9U5W9oq6Lz4Wbcv7w+XPK7SjH6dyIoMa5+lFgvthX7aHdUXhsk0bHCT5OnhCFaC4tL3W9GClm5YWnWIZ6qmiPgWkzLn+8C9UGiOWTel
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ir8iR/5Izwi4eDdYelmNI8UnRUawNMz1Lp48+cnGQvfX1f7Honpc67bG+EDUKhslDs12V3Iuu5FEjLWOcwfC2sa3Wbw/efGUk739L5OFRgnEqpNjxqya/UwSCQOPu8mQcKewLvTMxclpC/dAxgeo9ZnrREvHxk570HJJNX37xcKVM7Xm+AVCGUCNxEKqJLkWYstiAOEAeflNohlW/8fjxh4bPClO3fKQh/uKx8mCd6xhK0yYijQe03LZAluDmcRU3TjSNlX3nKiSk6iKWAFBZ15nPktHhVz9v4d4xFAGtKMZr++GFviGRzBLgbB3QLNMVeXjs0iN33TBSMZBkxPf1/unMFbQSp/H7yLqjFNYK4T+E2+u8808+iLjmV5w6b1e9HgCvQ3TClrnQ0oE9dEwlv7xyGsACyggyvWWMusYNO+7pln7ae2IDlSp0SckilIwuOVZkUwiqMk0aKwaJG+Z8Q+SYm1iixMoD9PnaGtFsq4nhg1YwgNfzRMyf+Akwzqf1wrtbf3vOt6shHTaDQogXaXC+6MJQphjhr60XTZuSr7RrBVRAke9aIraILrIivms
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4QP1TPizfi+91JfPNyLxWfAW/rLHkUAxm4CHqKUWedDKQ+sb6VriCSTqmaND?=
 =?us-ascii?Q?Gh9ZhJ0QtRIMWELPtggT07gNNiiHYnE/bz0QpQzWwODLsAblMF+E/RFVBssU?=
 =?us-ascii?Q?qQ31OQaw4ScGl45Hem3daFy4MuTatudmEd581eW9IEaB5dqEXJ+jX223ZrRs?=
 =?us-ascii?Q?N44GJxa8KQ76N0OhgL9BiND9VcqYsBCJsLRRJEgl1TZGhbYEk5nrJMtIawiu?=
 =?us-ascii?Q?MtDABFGryeFXHzZOeM+arHMjv1sQaLiUqhT2IgM5w6Wcp8U6JZK9aGM+Lly6?=
 =?us-ascii?Q?Uq3HtdFs6cSLu16eJkk7qNaT+cMZ8d8k/XMKg+TNSRzW33epg4Swefe24Bc1?=
 =?us-ascii?Q?DxNKIDI1s9ySJUKbdCGPZyRwNK7LZlk6Gd6kpyO9DBYD/wyST2rg/qpJNGV6?=
 =?us-ascii?Q?PTs63hMx1qADlgVAv67T4QzPrwRqmJ4Y/j+V7IsTVdJv/gGst6tBFBQb53VJ?=
 =?us-ascii?Q?giM/gz5VZ6jLKVJb0zbxc5N9qXLAL2Xa8l99DyFx/Q7QT6WVUiVtVjudwz2O?=
 =?us-ascii?Q?/jee96edakJHR2vr00vcDmNBHLt1KpwdjkaliDnj7PnX5fznEIqsOOScSomB?=
 =?us-ascii?Q?q9fWZcTz4ZNma+F+bFuBKASxj+cgJ6Ye1pv/5k5+CWzhXyr+8XVjfrxjDt4o?=
 =?us-ascii?Q?EStaJfYg8d4EKOdhwTKt2V3H44hRIEaJO8GQ34CjAVOEglD7fMpJhtIpl3hn?=
 =?us-ascii?Q?b4xzyNOBA46SYnooGmTe9NyjixzVWEkBGgbPHD8b9Jbg0YixJgSj86nj4eHd?=
 =?us-ascii?Q?AKJdxnTCHOq4ZuQsJnRnw8A7TTfCK5yHrmxFnGcXXeiw3UG3F+LuI8eX5nGD?=
 =?us-ascii?Q?/5fFbLQRVxhhEZkr8tvVXNfXaRNYty9rkvWCIXEWwXLcPOvL99KRkFhmefpP?=
 =?us-ascii?Q?eyrZbDA+BCiGdu0bxo6xZNOiqR5+tJ2UDxEBNTevgWho2eafKhAYkR5kLphp?=
 =?us-ascii?Q?ojwdySXKr6u9ym+CHHM1oTXrZon6LGZyGMiBTyPAv5gPWq4vHgcO6GLFFrfS?=
 =?us-ascii?Q?/XA9jxtHibVqcCdch15CabVAvATRv3nHB2AGFRDO/h5ShdUbESU2qI6/qfCv?=
 =?us-ascii?Q?Xy/FM55+yhSiCnieqNh6c3DTeuKbZUMofdZchuNtxWveYg+wxh1DS4fiqUYx?=
 =?us-ascii?Q?ep/bRMUzscA8BxLcGd97q8obKl7hbJlNv1/oeaVW0GIiA7bQ+Mjoij/JFSxR?=
 =?us-ascii?Q?ZoifFbllzFi4ml3xKrOGoP/3jepkbCYlndK5ZKRUipR5RvAB55oqorR0ZmA?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 103e2e24-bffc-4598-4ff3-08db7eb50013
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2023 06:40:06.2014
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


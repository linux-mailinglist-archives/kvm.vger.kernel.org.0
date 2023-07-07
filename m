Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E45A74AB02
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 08:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbjGGGTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 02:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjGGGT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 02:19:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2058.outbound.protection.outlook.com [40.92.18.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667E119A5;
        Thu,  6 Jul 2023 23:19:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmVhmyDVqA9SN1bI2SWcXG4FXeEhNBaJHquxh9Ayk/3PgM9A6Y+luNGyem8N/nHyb3KPS3UZE14Qodyq2JRbpPJxL8ToVZ3cR+SejBwrjNOByH+PWhoVgTzUagjUaCxBQpAd7C6YkAfbanSGOWJxTQ9o21Tx66l5Y7Jc1MQfNnRmZq+CZZKPYeLppcNWrb+a11IuLkOp5vVexKeLCIzZAzL6P3ApIM+Ba6WxPdyEosDSWXG7xv29/MJ72jkVoFWsoL/bvc/pq8KcyV2qPRRA5ujrUN93fW2KaqvyauuL7Z410WGqLIH7H0C0mievMlTgUgNjq7FayYmifHV4nyfjaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sj7XHpGOsg28kMTxw/cMhVgp2tGcjJmQNMtC+edIOFs=;
 b=lk/PoLrt2Pan9BY2ashxM7e1ZUdz95NqaV+FZuNDXQgGbD3ky5HiVvnHfBgJMT5nvBcPFx96rZzE5JXv45x6HznKcBriuMDkh6l6Vx8vYzcN3Vp6+f0IFfhZyyyFneoqLiRTH1SVC7h4HZ4EAnCIZmg3ECW8bcOEQNUCK12mTczhz4yrwg5OxQ2XV5dddsM/4C3Wjn/2YIEd1W7OkPm9aHS42+0N0i6Nm6dZugLiQg8b4gvdLnQWpjhDk6Nj4g4CsA5rEEg56eCFcU7RVta3u7HjGq+Bb9BVrBsnaBtX70oWkDIKfm1p3lTLaanplnaEU1tn6Rk0Caze6I6jaJfChA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj7XHpGOsg28kMTxw/cMhVgp2tGcjJmQNMtC+edIOFs=;
 b=gaxVAQv2EychNDBIb1VIXvrUYd+H7MhYG+4n9sVmHuEqLRqcADmq27UXpwB+qIlLlyPWhzeEwt8GpjX0WkP0ti0jEKs1JfD9nsho2V8apQNA1163TZflU9B0tIW2iVwl0ZKe/FBSn0qt1p9U+ZAnifOuAXdRg05Ck9Z8atabc/m2J6/7hjnD2TypSCLD/I072Y0rgUxKxhC7FkouLdGfM7j7NkqSNq52/n6Tcj+zQxLQtkqYWJtYdK+besHqh9mNqoeXFHeHjdPeZgE5to9rfkG1eDWAFJcOcBycjpAdxBimnKkI+aV+xIg6eDLmnjEh8t3QR0lrGY127Jg7+VTGBA==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by BY5PR03MB5201.namprd03.prod.outlook.com (2603:10b6:a03:221::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.24; Fri, 7 Jul
 2023 06:19:26 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671%4]) with mapi id 15.20.6565.016; Fri, 7 Jul 2023
 06:19:25 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, linux-kernel@vger.kernel.org
Subject: [RFC 1/3] KVM: x86: add msr register and data structure for lazy tscdeadline
Date:   Fri,  7 Jul 2023 14:17:59 +0800
Message-ID: <BYAPR03MB4133AA22745573570EA6E23DCD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1688710681-22896-1-git-send-email-jianchwa@outlook.com>
References: <1688710681-22896-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [HTvVboaJp5Mj083cj6HK8bXPXvOggDsC36kekQeef/s=]
X-ClientProxiedBy: TYCP286CA0131.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::13) To BYAPR03MB4133.namprd03.prod.outlook.com
 (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1688710681-22896-2-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|BY5PR03MB5201:EE_
X-MS-Office365-Filtering-Correlation-Id: d6af262d-41d4-4c13-9efb-08db7eb21c9c
X-MS-Exchange-SLBlob-MailProps: 7qh87CJt6y36AGtJtE3eAQUqDJjjc43Rq1OStfNZuTAKCM+RXFzCYzthL8OO2mAAdxnTLAu0HOAOj1LjDIP3OyQozaBWNH/hd2xGAwbYrbEM57f22sA17zAn1MXVsZyVaDWMD72TtS7h+Uq2vtPfQ182GsK3gYNpw5NaXhDMDWPu+iicPczIu4gjJ451hm1Y5UGHbMfBA3KnG5qlQaIPcApJbyxrR2k6omtP+N9neJcirW/nhBAOdcPnh6BfoSo2BjU9kRv8I6TCWFXHbXRSta4xgmf/6Q4T+nPf+BJGtz0v/FvHkvdOZ7yPksIopw79/3EuKWcSZqlcplMBE9ZSA3So1GYvxW1uifOcySe8mow3X/LkJZ0IqpGOqv31phGpkgN5phPrwW7y9ER/txjTCuFDfX9SYQ6Ab3BY/8m+xypGPlzfyybFNgXRdthNfNSmovuxYH8n01PtN+muUJHeNx5JcjWtovRbGNXqLCgOy8qMmLpy26u/lMfXNM0O2v0gdZE4j0W3AJxWA1Zr+h5afuyjrcY9m9xW4fg0ZWpgoMR4EZpRPcdKEWMzI8wo7G8cnFr8miPAedA8buPDxmftuXz9J1fBAyddqewpFkRaamQJhtW3tW/Xh75gcbcq/CED/ZQis6qcjMu6kJaKGo6xGFiHK5Vc9FpZ4cVrh51Hg77c/yk11d2EYqOHfWoHYcxN5i0GVS4nVEatXExooqlGNYUkrOwXjZbK8hW16qq3sYUQcSnLXDgub/rcKmHwgSyr
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yiEeDBH+/levOv+uZpIKoxq7tZzdxSHin5nPUwmfct5hhVAQjUJYVIcwAPUoP+F7DWpGrTxVDWl7ivDCgTF6vzsWy0I9UZYs0Wt6DtI4cldaPw3Q7ImC8ktsjkFqAWMRT3uIYpsbauc7qkaxaRhEFpMvQGa6PJ0jnBJ2BR/yX9Cg6aO+zXuYUMJrJ0DXyzpaslaINrdHGx9cxM+75q9WwD10yb52EWnVMoDmHhoQyJuVUVhz9iqiGg/wRn+neE+JPqXbQmVfMofwHQ6k/bYsI+KEE3SPlszyGy0ZAZxhDkjEHvuzy2BzY7xpOgbAIizWMIHS2W8sbKA8AoxdT+hHhtjZhvAdVc6OPhZBJ5buwdqPU1ljhqwGebZu0f5bsoRptD/u0ks2btWaJKKsZ171ahEuRKGHjxpHErj0TfSFrML1vz5ADb7StU5hrIiFwfJzJlVPu3Dy9ujL5R4hMqMDiD0DWRZ5QLbu7HRiAZ4stCr0lZfYx3P4wmZoLh9319O2mfCJPZZMavcv7MDbT8ZLupmSK9k7rAN8gVvh3cnv7JRC2q3xJD34rn78nHyampOJ
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kLAWSR6EADYAY2y0t/fx93j0YQ17zOIug75RFvF1GZnY+0fqurwW8ik/j2eV?=
 =?us-ascii?Q?wU3CHqV0gfr3gpJPvr+Ds2gh7gLJVW3SCfduOTpYxmPQvInFemRRpHSqLbsa?=
 =?us-ascii?Q?TnpHb7HVnecXqts+OLcGxupkR1JZL+kx4C7URA6y4juDM7xnX7dm7h7EMLnK?=
 =?us-ascii?Q?Q3q9iAJc3HvRdjiJpYNmjP0/jQb72Kkgv/jf6Ap+HEcpKJj3rjzxaCxQf/b9?=
 =?us-ascii?Q?KIfiiGS1m18PlvYSq6W0uc+36yNtoEIcevn8PQjnTKMYlmP/QtOQ9rXC2+AI?=
 =?us-ascii?Q?wQ7C//lN3rEDEL6oQFTLTBftNIxZySQIvlkPty4vqEU7EU6xUy7aJTsuj7Al?=
 =?us-ascii?Q?COMK1yV0058qbCesD8amNjHdLtL5gSK3oSR8Z3MRXp51YZYonFcOgzVagmDj?=
 =?us-ascii?Q?cndBLfrIDnaqs17Yw4aRrgWxU1lmNx8REl0xqQp+Yk0b4Wk7N0elJSLfXQeT?=
 =?us-ascii?Q?EX7wy0i82rKfAUSklZatY3d4aBqqKYQCB7MANqhDU1Eq34GObncUnEJwa9b7?=
 =?us-ascii?Q?bopbehWci4d26m1fIz+BIZU5m/9TIoQfO3GqyziczM2r7Al5bX+oyD6LRqn4?=
 =?us-ascii?Q?Bo97kg6rF548qnHc8LRagAY9m29m9mH4FpyRpZdp1+5rBGRRgE51ptTOxD3/?=
 =?us-ascii?Q?CeTEeFvy++yc2rM2XJryhJIcThI0Kjtfwq2SnWoDaveHkoIt33P4F6t2F1e+?=
 =?us-ascii?Q?/09+ENE35NqzeVAC2Bi24/ZuGsoMtwkGJRx0EVQ8GnJt/e30jyk5SkgHg969?=
 =?us-ascii?Q?vKuOznd2IRgLnaXHeewN/lz+CCBNFWDh4ZnlAhVgvjnGTpPeG8B/CjryQfkv?=
 =?us-ascii?Q?rUUDgE443EDmaYd3BogKYeLmFRBH1jf8zKWs8izegY8ePChEIfZPXhjVjlGH?=
 =?us-ascii?Q?VhYRq3Vyue6HHp+iS5U2XOEv7wOQug6N7cStNQLvyrpKrRc0T/4oaItXSe7P?=
 =?us-ascii?Q?4o06hsWekVqo0qQv9dz3gUlooarHz2QUAxSsnGENEpSc1V1qjjsO/gLDLfsp?=
 =?us-ascii?Q?rn92TF4wb1iZ+mORZQLUv9dnl+STT+l4iPp+Xp199vbhyyL/hsfaYBSttqSL?=
 =?us-ascii?Q?5x5IllBfahXQLsq8rOhxUrNqBuaa1ok1GtOog3kT3NeVu8YN4ChwAYkb5uJ+?=
 =?us-ascii?Q?ysgSZIcWvZSOnrMBsxr4S0eIRKOS+m8SrifmmTlh6/DqMMN+igQyMr2rHGOd?=
 =?us-ascii?Q?ZazmBE2+Yrb+ZXBxdTXpyNbgyos+Vp4qi1lqcf3/s1QnRkogXBqMeSeLUUY?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6af262d-41d4-4c13-9efb-08db7eb21c9c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2023 06:19:25.5886
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
 1 file changed, 9 insertions(+)

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
-- 
2.7.4


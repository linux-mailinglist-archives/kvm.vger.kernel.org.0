Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DE374CC90
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 08:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjGJGEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 02:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjGJGD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 02:03:57 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10olkn2066.outbound.protection.outlook.com [40.92.42.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A28FE;
        Sun,  9 Jul 2023 23:03:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHvXyEwIR//c6Luin4+NAn854Gvk8V8cuOoTYfzROOCuSFYhWRdGgRS6qTRqcesToO2/GK28g08S2TPbQnXH8O26U6mbaZJuPsE2737j0pTYxkV55AIluwnE8QFj4o6dYd1MU3bOtlAPdwACN1m/s4QcyyN93RdcQQ3L6WKhOEQ929PovTlh4KFeyaMP88Py6u0eKb//mvSZ7sF1yuekOGSAMzZA5C2BKm7tW+6Q/9rUVHwBw/do0ct27AhsflDXQ39OGX/AkU0a8ZOSQIHyQL+V1lTkKasb6AOCz4JXdY1AW8SruEIh5HJL88BT7sIMp3wF02IrfKfNGQIsPPnlNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sj7XHpGOsg28kMTxw/cMhVgp2tGcjJmQNMtC+edIOFs=;
 b=ZqLMY3WMmDx+TFaH8oaeEb3wtLukLzn1WASdK0ruIZsR90WfA2SPIX77TmdmoEFKyxTPN1WlQbLnAbLSMcigrWn17fd9epCJCcOr1vTqiX+sVCBvfMPipITgfmu8hEDlTRwrHYIRnNLpauCajvm6NTJnrOtcLSf6HRjddS/LJJfwRR486iafrnkWCqX3Tazv4mH0nClXj1cmh95gMY27Eyi7Vh9mP1dtuja2Y7wHpwY6H16b3rdACTdrBq4u8hJlRvQUVJ2aUX25a7cqO3PBSecgurLtN4itYPrQPUv6L52uY+HnazoMvFW/uuSD71BkG4R3cvmwy5r9tSdR2pYnyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj7XHpGOsg28kMTxw/cMhVgp2tGcjJmQNMtC+edIOFs=;
 b=GhvbhaVyLMKcfcs4gtoJWWlh9Hqf9yZGOx2/l5OThVPsGGIq8yBKbLqaYrg//jemDxcxnuEulc1peAo1ik6EuXv7FxCU6qzO4z5Zm4H3GOb60n4EY9373MPjuL1rjNJE1LQGOD/2TWvEaAKGPUaWt7O0rmjZUkchnzMAZ6G2yNifevFnDBOfNhiseqo6y0jsVGUYsHUQQoMXvbk1giLpTAycmnlf3cDXaOiXG6vQfzdkrG+t0d15N2pQHbkfos+Eag+Dv/c4nxOUD06Z+k9G40s+fxSx4vzaRxzBESFScpJciRgKenZH9VMZ93n8AxyUKzfZpE5zTqZ1vKysFehpDg==
Received: from DM6PR03MB4140.namprd03.prod.outlook.com (2603:10b6:5:5c::12) by
 DM4PR03MB6109.namprd03.prod.outlook.com (2603:10b6:5:394::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6565.30; Mon, 10 Jul 2023 06:03:54 +0000
Received: from DM6PR03MB4140.namprd03.prod.outlook.com
 ([fe80::d106:d232:850a:bd33]) by DM6PR03MB4140.namprd03.prod.outlook.com
 ([fe80::d106:d232:850a:bd33%3]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 06:03:54 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH V2 1/4] KVM: x86: add msr register and data structure for lazy tscdeadline
Date:   Mon, 10 Jul 2023 14:03:24 +0800
Message-ID: <DM6PR03MB4140D3396261607B81C45971CD30A@DM6PR03MB4140.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1688969007-3796-1-git-send-email-jianchwa@outlook.com>
References: <1688969007-3796-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [euvzYp2DQDcp+OKMGwsVTD3ikfQDxQADA7Lg48D48Fk=]
X-ClientProxiedBy: SG2PR02CA0090.apcprd02.prod.outlook.com
 (2603:1096:4:90::30) To DM6PR03MB4140.namprd03.prod.outlook.com
 (2603:10b6:5:5c::12)
X-Microsoft-Original-Message-ID: <1688969007-3796-2-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR03MB4140:EE_|DM4PR03MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 8710eb23-a7eb-417e-cfdf-08db810b70e0
X-MS-Exchange-SLBlob-MailProps: 7qh87CJt6y28mnXrYaz3TQtaqHIOdY4680kbF/d/MS008k2x+GWkIkLmbTOPPQi0+Upxxxt87eJWXG4Ez3PC8rD3g7kIAR92DcOPt8M/FcmexeQ/UlRnSGAzNNz720mqIEo6jYkNffB3bT4KkwkLXmiOWgnUZmW5avHCtxLcfDVKltDITwdgXovjQYdb41k/Nvl4GyWp3Ki6c0+Q4j0902PeykPEIs1LcuKwug7m3CERXibrWEHbJcmZU6z3YTHigSK30jy/fHaMRcOo3xkJPdcUrNFVgAB9Bl2wXDYeAlVWj4NEwwX6RyIs7eFQuqiQl/II60CtCkEUwRq9KENMOYYC2W9EVxDktAFcXkmgLvRf3sH70NJR7t3E2XRcNM2Vq+i9tJTG5TRCnrmrexfh4YIHN+2Ghrc6/Y1CJDDevYAel+MGBNwL+6hdErOvbpeV17mhFYjii6EVEklyYUIK8n6KyprNTLmbPG7waB4H6SUVXxJkB4MVC+4aco8KxqrRLjve6D/tGm5mM1xBQDa5OAvdhwqTZ6b9GbSuRHzoMZYI0DcWj8TXFG8zX3IuPfGKHV6TtyDaBbcdMtt3oVpKsKTOtORWOLh76D0SpQa4EUZbVSf4eODdIf8hE7yt/r8Z/7uxNWVeT8rflDjYhG8wLu1ig1bFbMUMuOM5dKb7XwgFQyp+EbiZwsre+2kw6q/NXJIDv3rzQr0ZG0HHTih3DmyKqrQ7hTNiv5lAXt0mGNy5Bysk2D9lxrFmHC6uMwJR
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oz1OiH0AXSB3aqldLOcdYxwqrv+NL1S+rVKWS//m/pu5gB+aCIrGeFPAKvY815dK0P64BuBoQyMguZk9B+aers8ABcoEw7AGb+CXQb7+Du/Moz2ZbJzr0iNolXeJoX9enJmyLorYoH+UA0S9g4+XE5aoBervhU5ESsfSXx+sPfNcG/oIO3D5qhJMqtEfp+11uTvEOaCt61S5gZe0Njvz2mS+Vnsx++sR2Iuat4OHStj1RZRLkI7Gzm6Neyp9Io0P1mp6lVwyCmoqDi3Q7GQkEfSqlsFd10vOZ79f/kxDO9H6ZgylrIcf/C17nh0je2ADa7ukOYqfE/NZkC6kJwD5a9994R84IJziOQk5Jozm0n8ek2G6OkVW7I1E/+6vawjLXhn74enH9I2uQ2PpA3gxDjTycZNOOb1GU5d7HBN3RhTsnhrVwoY+0W7A0rD8obme5OZ5furONO3yjpx1sLxUtEU2kGTZuJRtYLW0uqJTwY43WGIRUz1gLvBjCB9/F5SDHoMlaf5pV88qJhkr94WMbeUAQgTVqS5WtRe1D7GOyRE3OolZLLSOn4r15iGuNTEp
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fbsOfCOmDREfqE40ecNCnt16Br0z2MB+Ny4DmvGtUoiLcXmMSQPWckA5aKrL?=
 =?us-ascii?Q?0kQQOMZGdQ/HAHpVQqNGvS5F8iXpIKAgHukyio0L3+BmTNzzfbTtVCYQWHT5?=
 =?us-ascii?Q?5d+qR5eZ3Y9pkKehwDfrNSXHG20x5xGAGvQptC3u20Z+9kkUfwY+eqrvHS2w?=
 =?us-ascii?Q?pFiMKRQT8kuqlV2lxiycrIesJStFOCJrO3VhIeACUw1kUiFvLKAaTebB7qR+?=
 =?us-ascii?Q?YL2LXrDgU9xVCnzKp8vhy0iR8eg2T/tDwRPlETdysm1WN/t6lcD04iWsYf0s?=
 =?us-ascii?Q?N7UOfjTMMoKe7IX2Yg6GnhFltst2yJtJEIc9q8PfmA5fBPiHY2jovLn2s+nF?=
 =?us-ascii?Q?hu1IlF/HM3bkxkLXnmPE0FMIuhXUamAJqI5HxHUV6stfcZ+xS3Q0vxoE50PX?=
 =?us-ascii?Q?bQeZ0lZQm10Js6tNA/ND7neTbkZHd2R0EH+QbtIE9zkKpVrWoGQnKgH0P2qJ?=
 =?us-ascii?Q?Qw3A7uGcSPgOL8hrSYIO7p9cjUjKGp0elx4xXOymyd2MRlZu8yGa8are8Udw?=
 =?us-ascii?Q?GSpkXTrxfq8PMyOTVagDwrVIUulTsJh2mCm34WJx3ukxUY36p1G7mFcRO/p3?=
 =?us-ascii?Q?jjz9KCK6t7VIiEHqho3SfXlbe8ZWypxf9fjO3euWIlhkd5tyJfWgWMf9hx35?=
 =?us-ascii?Q?M8DxvrA9R40pp51CJIYNBDODomMrFQxYVPqkupWSswLbtoyLzhiyrzPGWV5c?=
 =?us-ascii?Q?tb7XyWfnDcWO6r3B1t/5b5poaBBw7odsk77S9oJgOsekVMnGCyAQb4bozOsd?=
 =?us-ascii?Q?8slAfs1ZI0dPJW8gQ9Nw0A62hd+p6sGmrkdcJUcN34bJPJmTSGnLSrqY8nT5?=
 =?us-ascii?Q?2P7Lxb9yfWXrtr4ftKUYikZLmLEjUkS90sOzo9Gckri1vSJ1peWQ8DcpDBa9?=
 =?us-ascii?Q?tu36XE9CDZc24MRAY0fCOo8++sFHrsv4W7Asc0flYvooXOBjrjXjKXw5hduu?=
 =?us-ascii?Q?7D3lIvQV+CGM0niiR2wKo8C+sAgfsqxxJjuBi94Kn4BKshqV+F3gJyeGog7B?=
 =?us-ascii?Q?bwiMc63Ikqm9RHsLG4sFbC+Splpkjcntxk6glUYBUu1yA/a5nVbEcpDYWI3t?=
 =?us-ascii?Q?BGkxeIgYd1cgsLxvi6AW1XlNsIxx5tQoovPMfnroBKl5HJtcuQPW/Gcl/aA1?=
 =?us-ascii?Q?+Gb7kFJwH/tSZz+UrXsPsY4n5h/9BJRk0jG+bql09NJYfgW6Hdwjz0YPMSSH?=
 =?us-ascii?Q?l4OUFITPWborYgUpu0bUTUpqg/bnSnue5+HCyj61aOElJpqROcplwuM388s?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8710eb23-a7eb-417e-cfdf-08db810b70e0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4140.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 06:03:54.5785
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


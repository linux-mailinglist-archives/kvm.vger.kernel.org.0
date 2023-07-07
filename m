Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE1C74AB39
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 08:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjGGGkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 02:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjGGGkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 02:40:05 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12olkn2010.outbound.protection.outlook.com [40.92.22.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700F01FC9;
        Thu,  6 Jul 2023 23:40:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asJICwwr27ylV9Gbq9iv/JFJGY6vlpn//6zq6po5qO102pu2KsT2wNLOhlFb57WsURzCtFw2+8yCLg63X3JWUmPYwkUoSDloahPesvl0GV2XRvi9Q+U/dX4z3ZjRlK1J2uhjP8KdLzPHWr73QdD0bGjBFp3dawZFaqaGD/WgNFRpg/JgGfPay+4GAykV8KnCrZ4aHXWVn8f4nfCrt9wRCo82SUu7dy08czMQjmK83uCV9w1UwUzU5sHADkNOGLwe8TTfPbkHidsaD9oNr1hZVouP8XRIDv40TF3mcjLlp5ZVQdeFhpegJlPcxozytvpK8JToVI46N8/JxOIgaz9uRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sj7XHpGOsg28kMTxw/cMhVgp2tGcjJmQNMtC+edIOFs=;
 b=lz2pM09KscDtQLZBzndYxHv9rz5enrF8R818C5Phbhn+WdeoyTrV2y7eVnQml4lo4sJAiBtAEImhOUjoM+WAIA5HxBdiMhcKzPCbO4a7vTW941evlDOlQn3zFcNXKEup1R20p9EkC7/XhghMigKYpseuc0aJ4hUNLtt4tJ4Z3aFvKrP+nPo8+L7vIL9sj2DX8ZsKeKx2TAerB4D9LED8raFATiDo2UDh1fOlvPgHyKOxI0Irlge2GRcVnHc4IsR+K3/LpxWTpNJT+M1e3h4u7pI2IIh7iBH9goCGPLpgS2CZdRzvOXYVLjvE+4PDJVlci4PBblB41A47tcH7gcAJkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj7XHpGOsg28kMTxw/cMhVgp2tGcjJmQNMtC+edIOFs=;
 b=mmcK8r7DtBbYFhpRPDqMX6CBt4hC8J6AkXehXSAfk1t49Wp2+1TzOLOeVrNREWv5xzKyw9pkWaXB+S4JbSuhRafK6n/OB9+1feJz1Gmqe0khmXgXEXz9MwakLQ+CO42uBtLohjSyehyWQIFlqvYMjSaJt0GtG3/MFgNHAP1RdYjWFwUea3rUV8bx2zWs/UB14HWx5cCqOkVhFzzv5gYvUdGNszaGWKpUQf05JC6F00i6KQPabqNZ2MLAGmnsWF+sxBjI/oBJCiApFZ39PRX+B+DNAXxFB2n5+Sh4gQWq9RMyVapm/NSoufApgFC+os6e9S1uQvzvJRT2WfeUgSyXQQ==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by BN8PR03MB5138.namprd03.prod.outlook.com (2603:10b6:408:7c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.25; Fri, 7 Jul
 2023 06:40:02 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671%4]) with mapi id 15.20.6565.016; Fri, 7 Jul 2023
 06:40:02 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/3] KVM: x86: add msr register and data structure for lazy tscdeadline
Date:   Fri,  7 Jul 2023 14:38:31 +0800
Message-ID: <BYAPR03MB41330C5A9EAEA034D0EC42D0CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1688711913-23638-1-git-send-email-jianchwa@outlook.com>
References: <1688711913-23638-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [sfWhXStDWtmZqxBfBwMNIbwD3RUbEKmA]
X-ClientProxiedBy: SG2PR06CA0215.apcprd06.prod.outlook.com
 (2603:1096:4:68::23) To BYAPR03MB4133.namprd03.prod.outlook.com
 (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1688711913-23638-2-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|BN8PR03MB5138:EE_
X-MS-Office365-Filtering-Correlation-Id: f2639459-d936-448d-868e-08db7eb4fdd9
X-MS-Exchange-SLBlob-MailProps: 7qh87CJt6y36AGtJtE3eAQUqDJjjc43RuddzsxrMRiFd46AnCs237954gauUPXUArNgnsFvM2t5P318897weIJSXyCRUfcrdI7Sudeb/q3bUW3xHsv0uGvEpewShKnPXx+XE9Jav496xPkbEw6gG/Ka+TW5b6L7G9DZxcpz2Zu+TwMBdiZzXgKrSMSsl+PMH9dmdykvVYNqdiwwLACi2ZwqC4vleV7+DtescQdEzMwMLwLSAKCTp8BnV79pxwDE/5ltoZSIxPu+1+n3dNRzX+IwLlSwZdzrQ4+1w5L4nZXTwsCFeNYlAr5V1Xr0SAPsMGjslznKuiix2VQ+qJxBUaJ9xChesa0++QGVSajsemb/Hz+FXxh2nwwuHCyCemD55v4qi3LP5WziIBYP54+tHDlVwrksqoFnx+C4xLiNNJmbBKvR0XKVMlKh8uGTJTHy6yan/L/MDF0fms740pIyq0T3bI2TIjeb+HxcNuYxEkZbbFWKSdTolUMcq4DRMpVHa8MmtAL3w8R0Je4cg0gBDpG8R5JAFugTqFgZSuJISY9qwLIRNJGAiC0DlfnpgUSAEsvYkYRwq/2wkydgY9dZjiTloV3UaG6+Z4qR8gJgg4iJ5n4xh8kogjaW3o7niWIZ/DBflMzGBZ4QR4Hn667wfF7oPz8vxWt/5vT98FPZfxixW9GAU7vo8dIRICETo9PcU9W/T6bC26iFGFh0yjrUGGwVjuQzYvb0lktv8Bw6DUCwcqduw9abuETjTvydePIMi
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gK2qRpZ5ciBZJn+4iM+v1nFd6eI12CDp3vLY3m8SNpqdV2xc2FVuCwVxpRl7biQ+rGXO48eXljkek1uJyuIfkg84v3gC/pAFeLIWSo765/4f4WPELL0l4LOlUpH0jvA6cShJfCseLvfwRs1VdUpThRll+z2/YjDApVv+1Dp4Ienv7BkjYSAookrpIAdFfBHABDiFsKXJyNiIpF1j2FjOLhYAufC/SRS9GlJOu3QCPgQjV0iXq19Gglj4UPnvYWGF1qaf1ucw4hvzjC3A4lV8BZzCtA/Bb3btqY0L2o4kpIOviObEUrVjEmu1RPRxzmLJWvGqWNwce9p3VTkl5Fa9K20rnATA9nX9kDffVLhNAUQi5h60pjyooRQ2yjnSn8UrhKstshqx4RVfvLZH3kqe84/ufqkGH+KfRM5UvXU2YrQibOzo64OBMxb3tDouzYuZpVn5xs38Qwd1CMf4LL8sFInwYv3W+xE7Akr/31SyOOGaMY7InmblUubkrECdureGksM+AaevjDOPQoem7XU1yGsSoUCGOCayVJRnAdtiqA0DiZRHifmjZj3RY8qziVI0
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9UraAqlB7lfJFfybOA1MGl4NmIDipMN0kqID3GPkGalKuxGVFsuItAfhj2xV?=
 =?us-ascii?Q?PWTRpd06IVVfXgJ9YrCZaIVxaMvkeiZtnvYXucyzO+xkgZAoHnGJXPDjsUKc?=
 =?us-ascii?Q?2OXqnd1J2kfqNTsFHtrVvQMtuqVTdpYj+iEHPguyGGxcaBAQPcKdoH5klR6d?=
 =?us-ascii?Q?aLBcZO8NmZLcYIjO8osUXuNzvAGDJytNGBxnELYDwqjL2+3eHeFKm9fph8ma?=
 =?us-ascii?Q?pB6h0f3qlEvWI2MUUQYiCR6EPGfAEAkWzjdkGzPfzpVTyoiKYDt2UDo+c3/V?=
 =?us-ascii?Q?A+evsfBuCMjTVoadTVaGdXeLURDMtxEtxtXKwmrB0deEWJJvlAYnn2c+9Rq5?=
 =?us-ascii?Q?AwTz/DAGg/q+NwrsW/chRFS/hviCeiLsaVDueqrcF0L5placN3QPJDwJ8byZ?=
 =?us-ascii?Q?pIIfMuhhXjMGF5nNzos2ezZpg5CcHI9NJ+LH4Jm6X24JYy4yxgR3cc41GDEd?=
 =?us-ascii?Q?PxIPfgjcvSNjy7NpTid4ugGNwKdqe6xvQj7Jtg7A1ZvBBSBr0JaqmN4E0vkE?=
 =?us-ascii?Q?qI5PcOKIJaZLAbJRHXC3wVs0dpx2x3jNfxIZXgMCfeIvmSHa+eT0C2O+Ys78?=
 =?us-ascii?Q?j42CmrGrNnfy0DsT/8z4SFnhsPA3YfFp9SARVdsfmhsZgJYL6NIbPywBwtI1?=
 =?us-ascii?Q?nT9clOzYYF1Ky8v+2l5IP1+mYjmehvlZi14iflFp1K2cmUwu75X8lnHwIA64?=
 =?us-ascii?Q?oURShkEoFHf05Kan/Bak8PvfCiSs36c6/fH3o0yZsw1QQGM3BGBh2FiZ0crY?=
 =?us-ascii?Q?Q5b7WBSzvwg7xMkWYpXObS5/IKf0EwqTkPBL4VineRWKtpjZnGDxitWo0dOe?=
 =?us-ascii?Q?Gfh71jpicNspzWyWpcPUgieB4i6NQwqtYdfVg4Q8MYSu+dMPNeMow2ZV7q7/?=
 =?us-ascii?Q?CZ2k97EMztqSb9BmfW4U1um707BENkuBZCV5fpZt+66B/2rsYo7rX69TxZkJ?=
 =?us-ascii?Q?C8tyP5SSM15mAMcCny/3MTEM/JudmBSQerSYgx1QXSUt2gn36K9PN4TSVFhh?=
 =?us-ascii?Q?PVIEbCE/7Jw5utqg9inT8ajEZNiSbAl+WEnqY0Tz8YrF9aC8W5Wixvmyc6w9?=
 =?us-ascii?Q?0LpIdCOyUBOjNxIJM7lykfTVv13bfD+SwHBoxADvrJ5PiCZqeyIs68vh0Qxt?=
 =?us-ascii?Q?A8fyTOAzjgoTNXaK8ocGCQT4oAuIDjfdQb+PTCxcSJwJlNsDrayyzwsdvEVf?=
 =?us-ascii?Q?jzCo+CCpT3zI59igxyxMBAIjZk1h+py4OMXd+slxCjd/ehrIkg2sWOCv/VE?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2639459-d936-448d-868e-08db7eb4fdd9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2023 06:40:02.4658
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


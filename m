Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB9136FAB7
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhD3Mn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:43:27 -0400
Received: from mail-bn8nam12on2054.outbound.protection.outlook.com ([40.107.237.54]:58881
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233310AbhD3Ml7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:41:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ha46fyYv0VCikiznudGiZeN6znVACKvg7oTmSiOomm4G8NUOv9ZEoJe0WDQ2SyQOMVH14V8jwQqXWEF+WJCJr5mia8MeYQ+F/N137Mm4tBQVrMb/tx5D1w6OC4zAbupqmqOJayO66exC1aOE5zQMdfGYIQ04tp658sNQtPKtcLtJS/+2KKR6pRjHvjXZi64G1Qoiciwg83zQqHlj1FYdR3GTyh9S2pzCzx3ZATXuX5jRBatWKAgL1tl5F7ktMHdjsS+j7RIyyR52l3dN9W1ZExE9CyBHmRI7A2hqdlYQTcj/0LviwPG9yqBeAPK5ZmtXTMNTfiKJPlPBLFffLqMREg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abYCMZAMD//6ueJlDs7Peo0qXXO5JGxNaccYluRezJk=;
 b=MvFBSPGOE9Yb++mS0TwdJjqjxEAW81DvM7phGn4ouON/fMN3gnYMU3rxEsj1FUTjb/UR/wKFsmnyqMXagTFvpQoh2AITUotyo4s+A5F8snpBVtErC7FqHp1yvYGsTKUYVQU6qKiJLqOvoXAqhgRctCiEm+WRhM7+eM0Kg6Xq7uZUjsKjkkgVBWNLZT5J85FqQ/qVBz83Ye7SKy6lf2Cc592vnQcc0/m6cL4707NsuAVT1ubdz/vCF5YW0M8eydioWBXOA/UfsmyJZ9AkX3N8dfUzbhTIpWHjg1QCrRVZQAKRe3uyyLGQT+Sv2Cq79f8xUkzPNkjxU4JXohBD9tJXHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abYCMZAMD//6ueJlDs7Peo0qXXO5JGxNaccYluRezJk=;
 b=TLzGDAG8/eGOdEypwRfntm8Flu38QE59EQKpGvKjn5BQ386IYM6+jB8+vBVJxoIDj0J/mnVtCMjK64v/9HVOja5K8s1MBDjvNiWK9FlDbsrHixkGGtvBOXLkzMqUUR6GPnYvGOThcmkYjjbZANcB7VWFvocwOeTzkLArRIPybss=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:08 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:08 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 20/37] KVM: SVM: define new SEV_FEATURES field in the VMCB Save State Area
Date:   Fri, 30 Apr 2021 07:38:05 -0500
Message-Id: <20210430123822.13825-21-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f35ffee-1ab1-494f-e7fc-08d90bd4f2c7
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2832F35899E70D698ECF449EE55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tDwQYsXb6XU6mjH+qWwtY65pBulO+i/tJoQe/ygiM/0jDcOYH9iYLQoAKwLrN+6Y/9ZuVhZ1qTYwod2xVcFyJqtvvU5SJLQRczhX55KS+d/l06g38KmdPXMWyne5BDHQPAqePzcXBJD7hWrV43HiZnJa7A1MwfELGTVcDqyH4GlRj348A5UudpQ1pfmKLbI+jH8Wa42OkeTfvL8IAyQzXkApfKdZ4F3iC6ju94GghwD5E0CQR8gpu+LLAvRnkdlH2h/135xXFWfij7kamPOFSmGyNTgtT7n5Uu5KA96x5VLUlBeMeDegVao+C6Y8f2hHkyq5SZ8BRMU8xvRdRxdyuq+GDmvkckSlmLoW+/KIfIOeYF3pkLhF2VrBoe8+ZOO4AuUXSMYBbymCztjVhMxN8G2jpqF6n72ML41HFyXLX/3XLYSZAkpKdPMZbRTgkoH2bmUlh8W/rD1W2vn4CgV6wdCJ5YdZy5KiPEnohmMpbSNA9SUViu/XbGebna8UVMcZzKxzbF9kaWRbnNNiOhP9izyR+chKuWmvxyO3aMtb/3M1J9GntwvnI92CKdsAaMAygnLvmzDQTuGKNv0HUKKwW1GYZmCpeKeVo2qdspu9k1noBUnolgauKm7eLYRmBJoLdTmzS0zh5rD57AvtxbP3bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(6666004)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?u+h8JxwtQISEIqQnohVaNXUx6Swe8spI00s5oHnBU730CoFucsOVILL1YXnl?=
 =?us-ascii?Q?8YhUTIN686+AiMYZQ28w5w7gXnfezzlLCKpluQZHOZQ91OYAnizpzUjeEKdJ?=
 =?us-ascii?Q?5BMI+cHcKEX0ifEg5OVBTvsgmvgW2wuW8Uqw31Qy31E3730pRODfqoC7V4jr?=
 =?us-ascii?Q?0up/X7bJOTAFa+T5vjooKYFMToPkIzKTtjEYC4nahnpuxqQAI0fxRYO2KS8Z?=
 =?us-ascii?Q?jc9Gr5TieIClWjmj/Tj+AvfezHW/lBu4Ow1X/q/0MhbYhjdCyRIIfWymQegO?=
 =?us-ascii?Q?gxJorL22inXWB/5/Fr+LZSB7Y7MIEi3VZ5hV0VvJQXWEaARnFRudLpgXYxje?=
 =?us-ascii?Q?GeYryTdoie5OmS+8wR5eY0jpvuYRj3mnJpGDRETKy4HanTNeDcRcx4EM48Sn?=
 =?us-ascii?Q?6YBVeH9Kv+VryUe9EJZ1Jm7U5rjkQyLBwoYWcGu69GW3cdEA0lREZ9uEDRNX?=
 =?us-ascii?Q?qG0jz2LbSyMF3WgKO3cdXcFTP6sZkKOHztwuNEjYmPBO8LbyLQQAITEa7v5n?=
 =?us-ascii?Q?FfoTmNKvE3mozsGQVoY2UQPnoNB0bAGO5Mh8dVUULGdmArQnpkXxH5sM1o81?=
 =?us-ascii?Q?g63LR70nFVhfLGG5EqotM9pMspNhMl077jkyIgsS7qbz0bsyNJ9cXj5I422M?=
 =?us-ascii?Q?knnut4zyZqSGURVKTqGjGy8I3YyUmeJvCqVZCmvaT2zE+Alf+g1YXDm/HUp4?=
 =?us-ascii?Q?hAsgtKGcvhDMG2+xDGXxw+9wrmE+qgNeX58/xEUaAZus6CIwB7Ayvmbs0+V8?=
 =?us-ascii?Q?0nIBSxKy88jv5dS7VYsCMO7gEzJjP0S844A+uA5qqiArD9UcidK2T7L7t9dl?=
 =?us-ascii?Q?q/UUJQPemtA+7awWYGGhqAmqDEe+zn5kjF0kfO/Svtv7ZVlJylgZCl/zUsWI?=
 =?us-ascii?Q?0dfRtZCmFHoNtxOZF0ckmL7kHTgq10ClF3x2q+ptU9gs1KiAP7pn5CUKcnKI?=
 =?us-ascii?Q?5yTXQUV5XsCXTRec3VUCPmKcNO8aXNnj8+zgTCjLp7CuXCG2fZlT8yL+cuSe?=
 =?us-ascii?Q?EWmyPqVwqVvs0bwRla9P5r30U8+3ZZogPnAXNBqFzYMuT9wxHrnySx9L2x3Q?=
 =?us-ascii?Q?38xIRE/4OPNRHn1KAwZqIqrOKhCFr/Kz/DfKovmJcdM9Zmq3dF5xhW/jYjvW?=
 =?us-ascii?Q?z12IeYpkkhe7CrRiK8kAbcYxAoVbTNXn5UjNpCrZyT6zttIdHcudXHUEf8IB?=
 =?us-ascii?Q?HqGwzzg408W9aj9Zu/KEtMKjGw1W639vX50P/wmAuvck/4I6ipLz8+VyurIs?=
 =?us-ascii?Q?x7eichxnzsQNkIpMB3ZZgHdMwuO7iRXJDtQGY9dsJCmDLHX0SRNUyJKLen/u?=
 =?us-ascii?Q?JPF9exHVCapCLRxhFfR9tUDX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f35ffee-1ab1-494f-e7fc-08d90bd4f2c7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:08.5324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cyuDUIBgyQen1jcXFc51cFiMNN0Gex3xvGWApCQygaARxvllRPe2xjAIPdgRhoVC1IMVVdfWoFtfkzi+MvIH2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hypervisor uses the SEV_FEATURES field (offset 3B0h) in the Save State
Area to control the SEV-SNP guest features such as SNPActive, vTOM,
ReflectVC etc. An SEV-SNP guest can read the SEV_FEATURES fields through
the SEV_STATUS MSR.

While at it, define the VMPL field and update the dump_vmcb().

See APM2 Table 15-34 and B-4 for more details.
---
 arch/x86/include/asm/svm.h | 15 +++++++++++++--
 arch/x86/kvm/svm/svm.c     |  4 ++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 772e60efe243..ff614cdcf628 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -212,6 +212,15 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
 #define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
 
+#define SVM_SEV_FEATURES_SNP_ACTIVE		BIT(0)
+#define SVM_SEV_FEATURES_VTOM			BIT(1)
+#define SVM_SEV_FEATURES_REFLECT_VC		BIT(2)
+#define SVM_SEV_FEATURES_RESTRICTED_INJECTION	BIT(3)
+#define SVM_SEV_FEATURES_ALTERNATE_INJECTION	BIT(4)
+#define SVM_SEV_FEATURES_DEBUG_SWAP		BIT(5)
+#define SVM_SEV_FEATURES_PREVENT_HOST_IBS	BIT(6)
+#define SVM_SEV_FEATURES_BTB_ISOLATION		BIT(7)
+
 struct vmcb_seg {
 	u16 selector;
 	u16 attrib;
@@ -230,7 +239,8 @@ struct vmcb_save_area {
 	struct vmcb_seg ldtr;
 	struct vmcb_seg idtr;
 	struct vmcb_seg tr;
-	u8 reserved_1[43];
+	u8 reserved_1[42];
+	u8 vmpl;
 	u8 cpl;
 	u8 reserved_2[4];
 	u64 efer;
@@ -295,7 +305,8 @@ struct vmcb_save_area {
 	u64 sw_exit_info_1;
 	u64 sw_exit_info_2;
 	u64 sw_scratch;
-	u8 reserved_11[56];
+	u64 sev_features;
+	u8 reserved_11[48];
 	u64 xcr0;
 	u8 valid_bitmap[16];
 	u64 x87_state_gpa;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ede3cf460894..1b9091d750fc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3191,8 +3191,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "tr:",
 	       save01->tr.selector, save01->tr.attrib,
 	       save01->tr.limit, save01->tr.base);
-	pr_err("cpl:            %d                efer:         %016llx\n",
-		save->cpl, save->efer);
+	pr_err("vmpl: %d   cpl:  %d               efer:          %016llx\n",
+		save->vmpl, save->cpl, save->efer);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "cr0:", save->cr0, "cr2:", save->cr2);
 	pr_err("%-15s %016llx %-13s %016llx\n",
-- 
2.17.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18F250BCCF
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 18:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382115AbiDVQZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 12:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381784AbiDVQZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 12:25:34 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E19E5D673;
        Fri, 22 Apr 2022 09:22:40 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23MES1d8021711;
        Fri, 22 Apr 2022 09:21:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=utUgyP2TyI23vDM2APJS5Jzam4dYeh/xyJrfONDsxIc=;
 b=UvqMRth43xoFugjir4akx9hwSzWT7sFtYysV67ZezJxwIXNkFYHImPDbTf9lB89MEAUR
 ttKXEEXI3VzXTQK0Pi+Fd597rzVNlClO0EKfp6IcLJVWaqkxOoLbguwebaAn3U1My/je
 9/lJa9Y/8iHXdprWT1IegJh4kPWomlJfZGKU0xldfekZYW0+p3oucHFvY0tF6EDR72sY
 rHa33v+wT2mfh9mtI7AKZJDp7ZojHwWlqgNyT0qxJTAerGsM97jbdT+bfOTrQYT18AdU
 j8qk14PKaRAQb2lhDRG48VOY7xoXitfKVucwgyR0F6JNEyPvrhC/WuAjEHgFvSfo0eVa HQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3ffsq85dqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 09:21:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dod/ehLQKkURCb2okuA6Va3T63f5xnt3WkFjavL/F/fILTeEcmPmOwuX982DUudnyCKwAYX8XatQb2AnTj6oJaqOt5OeuEVodDFp9NJk4h5yONhp3Ifpi9K4nHwZE079Exxv0y06s/ETz1gPrAjP8q578F2V4I2RNvDV+ZIwCn96dpnF9hetLG8wuSjXZEW8SqugEu2NwOb0Xy9woQorKZzUgETIj+2kf/vkDEpTwr+CesEgR+JdAR+AC2koK8b2adhN8bbHOOAz+S9lcE7lxJPCxnyWSDYUUC1vISXOk5cpqB+JrQV2KUZvY/6T7uWDZw3rkPVHOFmx4l0olbTIMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=utUgyP2TyI23vDM2APJS5Jzam4dYeh/xyJrfONDsxIc=;
 b=Z55vZq/8BMM8345nW3WeUnD6t77KHzk0YkH+Qor2zdQlCu5QFCpLSUZLQwDaxcff17N7QpMK8tXM7IQlgV+1XP0kesDnTs25zyqc1q5Zxpxj7PbGAoqhU2p218Zm1gQA7HPbIoN9+lIr0GkkdBzQt/d1kgpasi0I4f/MArl/7OrCbzEUIrsSxpvBnIzHBlCCuSsm+2QAZctULj42h/pfGDPhKfywr0OXQ8Cx0q7SM8XFzr2DaxQdQGB4/AgLSk53654sOopjeuuvaUWrtG+YFscVvhlY0Jjhf6iEztf9jXT3Xct1mWMibJS32/IqqSf+10cXHSKS57pY58Z+MOs+5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by DM8PR02MB8182.namprd02.prod.outlook.com (2603:10b6:8:4::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Fri, 22 Apr 2022 16:21:22 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882%4]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 16:21:21 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Jon Kohler <jon@nutanix.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH v3] x86/speculation, KVM: only IBPB for switch_mm_always_ibpb on vCPU load
Date:   Fri, 22 Apr 2022 12:21:01 -0400
Message-Id: <20220422162103.32736-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::19) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6df70659-876f-48db-6f3f-08da247c2311
X-MS-TrafficTypeDiagnostic: DM8PR02MB8182:EE_
X-Microsoft-Antispam-PRVS: <DM8PR02MB8182BF89E46F49717B4C02B7AFF79@DM8PR02MB8182.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZZBDRfqvqCXSA7X6AW2b8SGoPwYbIznxKTYg4PANmkAVi/DBe1POJOk4giyDAZ7YcjITSRwzc6Dn9jdDx4c3NRwAfb+wtTZdDcJRY6Ral+KPTYZO1P+Qg1XlwEaOSbYJQcxjzYK+BCl21n7yG9aAQsT0cg7If8yffsYq7954X38c1JtAl2RCvmhOn7q1Azvp6kTRuv5e5WpQS+bsU26QZNLt6eoDL4Gb5YkTUjjGKlyOCqIVatTYUP+PaG9+yit3DVu3aJ8Q/U772sFmWEPnTHoN0JdrhIAA7JAeVtSMZljfiRwRl9i41yI3/aIssT62Ogc8ioVuTnUSxb/lLzaVEl+MmizkBcO9QdymlyW/lr3freRk09daBUVy8PQbp1wVGV0+CMXXicP9x3CZ0nFNfaJ+KZz7xl2drnK6Vwvv6I/7lEfTbBLXLDpoQ0rN47GqO7o/0B+gJLCSzZ5SnWTk8pp21pYWkNji1if8mwsc0OfSFSuH6uqAsE24Xypq7D2oTm3loHqne+3/ckl0oOmvefLHYy82dQ9P2amt+cVzhzgsqOrZNKcdBQo/x+2ylP0KheMEJI3PbFnxKN2IImPv/khskc3JQA0Bf6uBwExrft8op3WP+C9WTYWV51LiFlUILLrs105AqBp+Kjf57u56XcRb8TIOTP/dSNDkx4kKXf9zTnnWD3VfucBqz5GYpA+3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(86362001)(38100700002)(36756003)(66476007)(921005)(8676002)(66556008)(4326008)(66946007)(110136005)(5660300002)(7416002)(6486002)(316002)(52116002)(6512007)(6666004)(54906003)(508600001)(6506007)(2906002)(1076003)(2616005)(83380400001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Va3jKxwCOs88+Kjeh4RNZW9U8Cx7Njs51V/MQQKIKsb15pXtNs0eazz436cT?=
 =?us-ascii?Q?PkA3kYR+VSnej+5cLm6p9KzkwcMw25b0U5Jfy1OvdHmrRpCMUoW7T1vQ9Rg9?=
 =?us-ascii?Q?zHIeyiPPbGY4hbvqNukBYbXYF9b/kbeZnlZCjQFlzq5Ob26eS1lAw6PnuXcv?=
 =?us-ascii?Q?rzIsOD5joxlZJNEqnSWJ2TY+ygGoN0JBJVJkMGEK3zEuEBZNJOc1TLQbCCAg?=
 =?us-ascii?Q?b2AEEB1+uG7RJykiNAGyObAgqhF/+cZmgEvUVTCzUfIZ8VwB4G7oNhhXrUY8?=
 =?us-ascii?Q?z0MdRnO8qcUzLNwxTB2EsSDWC4yZniD1u+PfSIYR5GYPUhUAT1WhhbSA6ULt?=
 =?us-ascii?Q?n1Y/mcgoj5nMUa1RB6zeLyg7Pw9TH+NFZraNI5Kh2ydft67ulqY8lVZvfAx+?=
 =?us-ascii?Q?gUOec9McZqvT221ACeE7f1dS6mhACfS97LVQcU7gmQoY1YI5WrC1r2bhR1rp?=
 =?us-ascii?Q?YrfZPDjPtgD2B/Aa4Gx6S2Sp7Sj+3Qvou+xL/x32MGJNUw5Z68R75FzCXzik?=
 =?us-ascii?Q?jX49OPE+ij6Ydrv83w0nQuc2Yjmzr/Vs4Wb/EIJjkGvKiH5SvOS7waU7FznF?=
 =?us-ascii?Q?ZNq1LwbYRClH/VXTKOqCkvqW1/IDSvTlM2W4g3R+2L7m7RfRwulJp0Aldx+o?=
 =?us-ascii?Q?+9f+XJqhKFUJxhE3gNQ3xp3HitOIhG/3HU3l6p5qbJAYGjufPFhD0gkJPSM4?=
 =?us-ascii?Q?xl+kABQ/Qoy30vPvTbp2lNjl5e3k4c5kvLTKzR/RsPeoYlJiewe3VqmJ7lmu?=
 =?us-ascii?Q?scBvpeODhNGp/xzOWszs3tdS91Un+DaiRkKBI49s+tRp+VNSfR8uWMgQXxpG?=
 =?us-ascii?Q?xaoSReXFX0JAjg3qPITgBdTLie6zXvVub+UdD8G2hs65x5Msc2rniAgztMDk?=
 =?us-ascii?Q?jujXlklSurnaPK83To9N5IV2ryN/KwOs9OBTdMs6t5ruyIrhoX1BA+1PpZLe?=
 =?us-ascii?Q?1l+TbC9waAVh5pxekpnDihRaoJvdl9rhIK3rrTwxsOG+/OoQEBJJQyvsqkDI?=
 =?us-ascii?Q?dzdNYGfXAoxmvNIzcW2U0qrluXcRe+KqZoo8/TDSOyF5tQ3JuPBMO6Nn4AX1?=
 =?us-ascii?Q?v0zyJZig75CZZtTD4mUQ0WZhWtGT+IjMGlMARD9lOxl92qxHokY1Bl6XUuV7?=
 =?us-ascii?Q?i5U5RzePhOw937tVPs2aF58gSHB5uBqOXeqF24N6dtfoUHt8Lu03gxd8e9LN?=
 =?us-ascii?Q?UxEjwcoc7a2x/OuSHUvDD5l+ofBqmJuVWbb1spGOjAiLLAQNWdZkoRd2E67f?=
 =?us-ascii?Q?e/UzKdzJnYL6zf3hxfLkCscB1xSIbsnwYIA9JRMAxKaD3qqMj7wsJqRb9vFT?=
 =?us-ascii?Q?LauMscilvkYyNywAdt0P3CZGr56lfMCE9O8RHsl2xIE0BdewXFkLMy760MD3?=
 =?us-ascii?Q?DK6GTuRXzPuwNnUpTJI2HcSaKqkOq+uLbTwBKk+VEsGBoA8En3M9CI+X0fQj?=
 =?us-ascii?Q?d2Oqv0SLZ5i+dml9SCvf4NAr8jcuaEXzhaqGK3GVnwqzKBe0ehSxRruWH1KR?=
 =?us-ascii?Q?HfvWaZtn5PunEuujTOXfFTKxqme+g+XyL6/3m5DG5DecWIJmf09hLX/pDIxc?=
 =?us-ascii?Q?y31xUN3Zfog6fgT+OY1epQjvQa/C49D8R6Kr3GVHlBs8t7acNX3Z2oHcogvS?=
 =?us-ascii?Q?mH7bhJtiX/AN9eEqSuvW/rzkQ2JZG6NWAjAuUe+N7o3S8jKybPN5Yf3rSvSA?=
 =?us-ascii?Q?5AfJ6jl6Zt+ckzZhE/tFLr1pVt0ntAXvNkyzPbwpYpSgF0y6OH61YQ1unwUn?=
 =?us-ascii?Q?SzNrgDr/tTtzlIfl8xf5RfdXu3sFsIMONd4wz1IO6CfzbVjTQUvBaE6at4ET?=
X-MS-Exchange-AntiSpam-MessageData-1: ZBaaa3jIvGvcncur2FVjNNUV2quiy1y8U2Y=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6df70659-876f-48db-6f3f-08da247c2311
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 16:21:21.5798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOVVOnBZ1gt08KhgMbOr2+ojsg9mGzK3c/peiXqIY3rFLJ/xcDdJ6Oma61I+qGEmzk+eFonqIVCWCRnnLbeBKyoWyga4P1PZiUYe4VeTT6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR02MB8182
X-Proofpoint-GUID: Azok1ET0IfScJCl6jMgXaqM4RrvSS9qJ
X-Proofpoint-ORIG-GUID: Azok1ET0IfScJCl6jMgXaqM4RrvSS9qJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_04,2022-04-22_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On vmx_vcpu_load_vmcs and svm_vcpu_load, respect user controlled
configuration for conditional IBPB and only attempt IBPB MSR when
switching between different guest vCPUs IFF switch_mm_always_ibpb,
which fixes a situation where the kernel will issue IBPB
unconditionally even when conditional IBPB is enabled.

If a user has spectre_v2_user mitigation enabled, in any
configuration, and the underlying processor supports X86_FEATURE_IBPB,
X86_FEATURE_USE_IBPB is set and any calls to
indirect_branch_prediction_barrier() will issue IBPB MSR.

Depending on the spectre_v2_user configuration, either
switch_mm_always_ibpb key or switch_mm_cond_ibpb key will be set.

Both switch_mm_always_ibpb and switch_mm_cond_ibpb are handled by
switch_mm() -> cond_mitigation(), which works well in cases where
switching vCPUs (i.e. switching tasks) also switches mm_struct;
however, this misses a paranoid case where user space may be running
multiple guests in a single process (i.e. single mm_struct). This
presents two issues:

Issue 1:
This paranoid case is already covered by vmx_vcpu_load_vmcs and
svm_vcpu_load; however, this is done by calling
indirect_branch_prediction_barrier() and thus the kernel
unconditionally issues IBPB if X86_FEATURE_USE_IBPB is set.

Issue 2:
For a conditional configuration, this paranoid case is nonsensical.
If userspace runs multiple VMs in the same process, enables cond_ipbp,
_and_ sets TIF_SPEC_IB, then isn't getting full protection in any case,
e.g. if userspace is handling an exit-to-userspace condition for two
vCPUs from different VMs, then the kernel could switch between those
two vCPUs' tasks without bouncing through KVM and thus without doing
KVM's IBPB.

Fix both by using intermediary call to x86_virt_guest_switch_ibpb(),
which gates IBPB MSR IFF switch_mm_always_ibpb is true.

switch_mm_cond_ibpb is intentionally ignored from the KVM code side
as it really is nonsensical given the common case is already well
covered by switch_mm(), so issuing an additional IBPB from KVM is
just pure overhead.

Note: switch_mm_always_ibpb key is user controlled via spectre_v2_user
and will be true for the following configurations:
  spectre_v2_user=on
  spectre_v2_user=prctl,ibpb
  spectre_v2_user=seccomp,ibpb

Signed-off-by: Jon Kohler <jon@nutanix.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Waiman Long <longman@redhat.com>
---
v1 -> v2:
 - Addressed comments on approach from Sean.
v2 -> v3:
 - Updated spec-ctrl.h comments and commit msg to incorporate
   additional feedback from Sean.

 arch/x86/include/asm/spec-ctrl.h | 14 ++++++++++++++
 arch/x86/kernel/cpu/bugs.c       |  6 +++++-
 arch/x86/kvm/svm/svm.c           |  2 +-
 arch/x86/kvm/vmx/vmx.c           |  2 +-
 4 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/spec-ctrl.h b/arch/x86/include/asm/spec-ctrl.h
index 5393babc0598..99d3341d2e21 100644
--- a/arch/x86/include/asm/spec-ctrl.h
+++ b/arch/x86/include/asm/spec-ctrl.h
@@ -85,4 +85,18 @@ static inline void speculative_store_bypass_ht_init(void) { }
 extern void speculation_ctrl_update(unsigned long tif);
 extern void speculation_ctrl_update_current(void);

+/*
+ * Issue IBPB when switching guest vCPUs IFF switch_mm_always_ibpb.
+ * For the more common case of running VMs in their own dedicated process,
+ * switching vCPUs that belong to different VMs, i.e. switching tasks,
+ * will also switch mm_structs and thus do IPBP via cond_mitigation();
+ * however, in the always_ibpb case, take a paranoid approach and issue
+ * IBPB on both switch_mm() and vCPU switch.
+ */
+static inline void x86_virt_guest_switch_ibpb(void)
+{
+	if (static_branch_unlikely(&switch_mm_always_ibpb))
+		indirect_branch_prediction_barrier();
+}
+
 #endif
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 6296e1ebed1d..6aafb0279cbc 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -68,8 +68,12 @@ u64 __ro_after_init x86_amd_ls_cfg_ssbd_mask;
 DEFINE_STATIC_KEY_FALSE(switch_to_cond_stibp);
 /* Control conditional IBPB in switch_mm() */
 DEFINE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
-/* Control unconditional IBPB in switch_mm() */
+/* Control unconditional IBPB in both switch_mm() and
+ * x86_virt_guest_switch_ibpb().
+ * See notes on x86_virt_guest_switch_ibpb() for KVM use case details.
+ */
 DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
+EXPORT_SYMBOL_GPL(switch_mm_always_ibpb);

 /* Control MDS CPU buffer clear before returning to user space */
 DEFINE_STATIC_KEY_FALSE(mds_user_clear);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bd4c64b362d2..fc08c94df888 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1302,7 +1302,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)

 	if (sd->current_vmcb != svm->vmcb) {
 		sd->current_vmcb = svm->vmcb;
-		indirect_branch_prediction_barrier();
+		x86_virt_guest_switch_ibpb();
 	}
 	if (kvm_vcpu_apicv_active(vcpu))
 		__avic_vcpu_load(vcpu, cpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 04d170c4b61e..a8eed9b8221b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1270,7 +1270,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 		 * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
 		 */
 		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
-			indirect_branch_prediction_barrier();
+			x86_virt_guest_switch_ibpb();
 	}

 	if (!already_loaded) {
--
2.30.1 (Apple Git-130)


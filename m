Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9D15061F4
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 04:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344271AbiDSCEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 22:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbiDSCEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 22:04:43 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C692B249;
        Mon, 18 Apr 2022 19:02:01 -0700 (PDT)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23J1eDtv003260;
        Mon, 18 Apr 2022 19:01:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=hA/btmuK5oUCjo6Gd2i/PlpKkbv8eBbtV3Ph05P1Msg=;
 b=ZWqNash8C39MojZrW6JZ4Pd0eteT/GlmiyrqBEgEuLLaKweLvp2YbSoVZek8PFAaCUTT
 olds696gHSsFIUBuBMjfjeGw+/tC9rX6rUgZ7o/xXyOul/FW2Au+p//m8T0hfK8FBR24
 58yUspnCv56FT1nMcpqiBHfyRFyIciWeKFJi3tek+TIIs679ZcYCvrNdnylu0PI+ea9o
 RYueoVdSLGhFWJi3V1/QQu6cm4SkChPkCP87nbT6sXBIpNDPDwEn9cDcMfmoTwaGdKdw
 fneRQfSp+X9LYaFl61VzBhVkFXL4d2WIAjTyZWOc3Tq+O4VEYHTE6Z0lCXBP4NCDxM2n uQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3ffubamhry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Apr 2022 19:01:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hA4OricEw1q/7RH8wI8+Wx6Is/Lfz+9ljlDR+97BzFEWjUeLKIx1DSeHr2ujcxXb+A0TwKR3EPEwvI4maE4ZHbHZaS7JQribJolysWC/Nmyd1EL2lt3ZwtqlOy59AhhLwdZqxd45SfcxpdVSi+d927vXfk4192qCsULxKYZwNPyCYITBB8nVQvNzU7mqfyCH83+7QUcyHL5+0vTAO+EfJ+yFPawMUi0fTdaHXXyzYwT8bKtuLuSs6zIIBzd0I2yC+Uzshwf39CzsTfPACzNO/+1bO8NNQLVjhB4oI/bIuXmBR9Mrv0vV5KbwWU86alWpU6D4tgt1VLx4rjPqLsFobw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hA/btmuK5oUCjo6Gd2i/PlpKkbv8eBbtV3Ph05P1Msg=;
 b=BJK82A5XAnOwAD/15TH6/rCzh3MxZfS6gJQ0zUSLWQbtwL604xWJcWWZ3JghU3Zvj08Oy98udgXZadeMEiQUKo7d4L+PL36bbO4+rFj4CAlTfKXs+M+chM0wnwyrUvaIB3P2NCQrhNe5rLo1r6yjWela/oO7ftx0aWWbgATF2YgVS5FTxcVLHiZxw0bifSJSoFWUNx2udbdKGbYlqev1Vf0HtA6JTYLUXwdQpemRPq4iN/j5RsysDpWb7xAJjh6Y5w046PJqBwoHhVo0rOQkapgsWSay/QDSr3olcBAzu6rSzrPPyAFHGV3eI0aY+6tc+L5iblZDjrPOn/X7DrKGAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by SN6PR02MB5503.namprd02.prod.outlook.com (2603:10b6:805:e8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 02:00:57 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882%4]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 02:00:57 +0000
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
        Andrea Arcangeli <aarcange@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, Waiman Long <longman@redhat.com>
Subject: [PATCH v2] x86/speculation, KVM: only IBPB for switch_mm_always_ibpb on vCPU load
Date:   Mon, 18 Apr 2022 22:00:08 -0400
Message-Id: <20220419020011.65995-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0369.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::14) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3d9ab50-9560-43d7-b6b9-08da21a871a4
X-MS-TrafficTypeDiagnostic: SN6PR02MB5503:EE_
X-Microsoft-Antispam-PRVS: <SN6PR02MB5503A7DD6EC4FB3B9009C5F8AFF29@SN6PR02MB5503.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LMkb3eDB6yyMn5EQ+5RtUdI8rBE8h0m/HOleREI3nz2jtcF5czfJVg5HcK/RpL/s8+z0tNvSvPyx6ZqPKBjkwnvvdb2o9UJrKEgc4aIwTh6VyvM6XpovcxDmQJL2nqGokFRQGdiTRjJavC6aYONDP5FAOMgzlbMeYMc/Pz5yanvsribfPav6nA5hdLgcC73a+Op7h5q8OHn3rmr92n/DaKZtfivwqUZx384c28BwoAo9PmxSGVUMQELTza5bsUzpX0LVsH3++FsjQwkboQ13m3oYnCRShKayIAkFjOzgrTamCE817hN2HOb6K4zNeXJRWdd90re8m461lSDYFgCHjfv/eaAuD70Lb5Y2X93xebeHaSf537bYOw9RiPcZbSIjSJZhYL/mU/lQunNtGTYJxkgyARLM64z6Jcg6hQ70ZwOcJMtu/K3qqplDOcuRP/tD7CLVXcC7EVvFBnjB3j9CI+x9DCy7YLhz3XxTr7rKDTij8mXsvGTQx7rsz2rQnV7PIPAbOqs+8JjbG3/QZGKMgNw8fWe1IfbZkSTTdjCQGhqJcIZyTQO+aYmnTL9IrLJhUZya6AVYXBv7u/oVSsZoF8ogvl6QccucFxc4oBf0/xDbDTJAZEgvs1/dGd0vLmkFsSsgaw7y2tSph+oehr2FiEZRVZQVxWAs7JrzKKrHr2MV4uSDoWDqfU+NQtmmakA4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(36756003)(6666004)(6506007)(316002)(921005)(52116002)(186003)(6512007)(2906002)(2616005)(1076003)(86362001)(5660300002)(110136005)(7416002)(508600001)(66946007)(66556008)(66476007)(6486002)(4326008)(8936002)(8676002)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4DZA8ah44d/OQpqFjJG3cO7dp/ln5+MFGAxH/i12q44RXJD8duI2Nlkt4jm0?=
 =?us-ascii?Q?Uab/0ix68Zh74XwkwX69Hb3ZzpqiXlmt5Eyw3zxxiRfXIA6P4Ik5YoR0BdCV?=
 =?us-ascii?Q?4ON5bfLeEBL+xjB5DaU6XI0GNBSjhpg4Jq+GOls8LQcuhEhhXU6b6Wg6rOsS?=
 =?us-ascii?Q?KpQ78tOGVvuNH6GzVjRCtXJSwzqaaWIVpNRjpJbelmItwVaFcEDa2CxRAP0Q?=
 =?us-ascii?Q?b3UJ8jucjYfIzK6+2aWzMNNAFz2pXe5j79mHdyn+ExawB3LrtsDHaxmxwV+h?=
 =?us-ascii?Q?70RaoOjGNJykjL45o3d991pK5lsYsq/IqM8puVNltodPKm+LQ+rHMikWe4m5?=
 =?us-ascii?Q?LuNnJRLB/P/N2k9AIJ2F9IHvx1c7RAmqrR7NRNLT8YuD5M9PDPAWrrrl8OFl?=
 =?us-ascii?Q?XKJ8PkZXTAm9b/grGXZBxMUAry5Tx8V7pM37ta5G5DpNJA/ww2Fxhm3OIbiH?=
 =?us-ascii?Q?LeTIBzm7IlIVZhOIarVmRlRhZsWA+fJwziMoI4YGMVd8koPKxUGCakDKiUtm?=
 =?us-ascii?Q?hQm/HtDCIQywJat8vrNxO4ESueQSjzSJ8UkOQw64tmK4fhhUhb/vhiC5DmZ7?=
 =?us-ascii?Q?5maFQlXXmB8jWX4CNlmZWZezGlqvoML48F5U0g5zdFcpXPZgtQjNpVbXMqZK?=
 =?us-ascii?Q?COXmrM1ktqzTVFMZISC9eAfV0CHm0ekT0YP9mCGvQtm3l5cCvf4IKM5qBW3j?=
 =?us-ascii?Q?njOiooGct32FIRWW5bJAzOSnaxPnLUGiqLnysqAYc1xNmcnePQOABiu+Ropq?=
 =?us-ascii?Q?oafcRH19MZ8FJmqqFEUmBIws/ftmWLEi1mXXqDHI+96E+JU4QIL13P5TCbhq?=
 =?us-ascii?Q?Efasn0ywXInJ56O8Vk/qnxvEtrrl5slPRycidjG9Wn0+EVk9Z/uyo3itb5mA?=
 =?us-ascii?Q?aXhoPs8ZsCclOaffhKJMpr+uKr65sOYVLvBo+nAYpLKWayoVIohvjysRyCy2?=
 =?us-ascii?Q?4TqeWnQZPapf+tjYVbLLxG2dPIPNIkZ21mpZH8gQ1SHZWuZ377J0lOG16vpx?=
 =?us-ascii?Q?nII7fa8zy59EiL7/8tla3R7jGwPJ0Jj97CqVSMFSKyCZpKRE8jQQGePTsnxc?=
 =?us-ascii?Q?WLfBuHq2t21md+0cU4tToLan3ENPJyVI9EwcXhwYDFZlHsajDRZmvoR0kM6I?=
 =?us-ascii?Q?v+lUm8vKxwNbbNYIEzTIAE2furNMqBt/Her7AErPHrMSjYC10UtbE5TLtEuY?=
 =?us-ascii?Q?WE7vK2ibMbkJX0qJgfk3mha8YkP8JrkuDErZgFR4rBGn2MYqiUluki/g9BvC?=
 =?us-ascii?Q?xllZT6QcZlAc/JZ4dZ3W8b7YCvkKqyQCSlgdYD5iJ/mlZiFAmCs8khg+Edmj?=
 =?us-ascii?Q?429zyUmZVTAbDFfrzxz7gRTXdPDR3O0pcGl4oF2twN3GSW044BvXmEpMcJu1?=
 =?us-ascii?Q?OtSOG0mi1CHNg8nMIXOCVsG9xk+WC2uollQMFJD0U79vlI3y+30Q1TVK0P9s?=
 =?us-ascii?Q?/GhGOhcN7Cse4pBcCW4kw7bVzCfZzO1Erqu6Tx/9MbPqIL9MOvoH++uBGQS2?=
 =?us-ascii?Q?ZfvpjfsBzvP0dZL/g6PFYrfU4TeqGl+pwtlV6llbhUiNncj7SzdVHRfjKxRN?=
 =?us-ascii?Q?sRizNzlWTmlwDn2z1+Z6C2Q9359F9WOlP3lyedUmdTBin20/X8V2VfMtLfiy?=
 =?us-ascii?Q?tdrq6RAgUz4Bq8jBtWI8A8QkOPm8V2l/ne4jEEJWuUgICBPbd/3crgqo0Q32?=
 =?us-ascii?Q?LXvg67PWZLotSLfRbfHUG4SCGNTUdbK84jOG7JnEb0JNhO50GhkUr0ClZhRa?=
 =?us-ascii?Q?yNTt7joFhWFu4zUvNgG+0L41GvkeuhMy0BUX7j9UmqP2Yk+ZKb+gLRRHH9MI?=
X-MS-Exchange-AntiSpam-MessageData-1: mjpAGyQ2D1GJW4Mnl1eDvy5vXXg7adheKTA=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3d9ab50-9560-43d7-b6b9-08da21a871a4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 02:00:57.3063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uB7Vx6ZmPvwjD0Xq/weIn6eTcBmYYbJ9QbcwrahCuZGgAXxTr3izCBJ8i6RIWDgieOwclU1ttYeRLlUVchzmdIhXAgCMcrnTgKM6Z2qvS/w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5503
X-Proofpoint-GUID: Ao9E-Hj7fnKxhe5YoLvcFA58_99Bki1v
X-Proofpoint-ORIG-GUID: Ao9E-Hj7fnKxhe5YoLvcFA58_99Bki1v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_10,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
multiple guests in a single process (i.e. single mm_struct).

This paranoid case is already covered by vmx_vcpu_load_vmcs and
svm_vcpu_load; however, this is done by calling
indirect_branch_prediction_barrier() and thus the kernel
unconditionally issues IBPB if X86_FEATURE_USE_IBPB is set.

Fix by using intermediary call to x86_virt_guest_switch_ibpb(), which
gates IBPB MSR IFF switch_mm_always_ibpb is true. This is useful for
security paranoid VMMs in either single process or multi-process VMM
configurations.

switch_mm_always_ibpb key is user controlled via spectre_v2_user and
will be true for the following configurations:
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

 arch/x86/include/asm/spec-ctrl.h | 15 +++++++++++++++
 arch/x86/kernel/cpu/bugs.c       |  6 +++++-
 arch/x86/kvm/svm/svm.c           |  2 +-
 arch/x86/kvm/vmx/vmx.c           |  2 +-
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/spec-ctrl.h b/arch/x86/include/asm/spec-ctrl.h
index 5393babc0598..1ad140b17ad7 100644
--- a/arch/x86/include/asm/spec-ctrl.h
+++ b/arch/x86/include/asm/spec-ctrl.h
@@ -85,4 +85,19 @@ static inline void speculative_store_bypass_ht_init(void) { }
 extern void speculation_ctrl_update(unsigned long tif);
 extern void speculation_ctrl_update_current(void);

+/*
+ * Issue IBPB when switching guest vCPUs IFF if switch_mm_always_ibpb.
+ * Primarily useful for security paranoid (or naive) user space VMMs
+ * that may run multiple VMs within a single process.
+ * For multi-process VMMs, switching vCPUs, i.e. switching tasks,
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


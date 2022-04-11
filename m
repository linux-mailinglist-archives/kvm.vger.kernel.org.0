Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33C94FC58D
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 22:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240399AbiDKUK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 16:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbiDKUKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 16:10:24 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A76A29CAA;
        Mon, 11 Apr 2022 13:08:09 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23BK6tT7014226;
        Mon, 11 Apr 2022 13:07:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=gjCT0q4Co1gWQhXUloyOMRcFtZ99cEt749dcn9G169k=;
 b=ATPAjIA86jjMHXySmgzcevWIGWBxgH1Eb28C9+JSL2acCz7d85NoNuokll1AffM8ehV8
 y9IvtM8CT99qBQjLsXzUS6L+L2rjimJfW+vm2GccRo7NqzI5XulDvZg7gH9WD+0Wo55s
 s6pZK3cRezb2kfj9pqt6DpjoRQNzrxgjqG2cB1l5GTTTwLAG4YaIMP82/1udnHDIt+lZ
 XyCdWaStohjQDzXXaqBOdrzJb7fzHVwQ/QxR0AIqyesADQHEmJXNb2q4G7s6L4l5UvJ+
 hAAwJyS0kD0pv4BKoUl0COxopBQAXJu0Ef6xy5P+BnViVXHD8jJvtrGuBqWjWTo8yXzU Og== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fb88f4d87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 13:07:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/g8Tp/6WwFYx+3KqLOddV4bhkYhzYkgX5lSojOzEUmRgUykOKsP6sbY8CgDUQjZwt46wvpqugCnKQ11rgDbTV4YXKytgjT+IDK0rvwstXV0MXRlusq8ZKpwPO+qTqAGFHoUUN2whqHWoFOmgpt9AhgzmwjmnRT1EHGJowoCb5NH8q738gTk/15QV4CaVea0TGjJvfOcowyLfEewq93rWGTszp9r4IvVNnt/vZ0Nw6NoGQDRHoHfv5mChLFd9P2+u37pJwEdQ5wF1arfUQHPO3uZa3WbpPcBP1rks6rPZvfmmMiCyy/b40jweC9H9TySLQn9yUv7bmwQzD8rmAq3xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gjCT0q4Co1gWQhXUloyOMRcFtZ99cEt749dcn9G169k=;
 b=QsxwVjzTtuRNWRDbICZGJ1f4eSMnLMH1DmLlrY/jftMVT2xkEr2TqmnwVXmHCwIa6iMM6oUXOC4l7Nr+OrVa0B6ejcLYFQvBElvpI5whxy57PW7HlMrjpXfSBMU4A17g7+Znh4aE1RC0jnhoN2NLNJ20ut/GWmwir/TVmdPLwzu+8PsQV+3ujWuijL4H84cvTfo/Nfik22+LFV0OMIRJaj9u34KDN/5LOxokfwr5oW7zSO0Hu1q16fC4yr03b/vXkzb2Gs0HYMLRaJtsSvcLTnkxXrREfZMB5IWtoSVm6DBTPgWh1V4x467GBIrTazqeh1ayD7Li3cmERpMIemnabA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by MWHPR02MB2382.namprd02.prod.outlook.com (2603:10b6:300:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 20:07:34 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 20:07:34 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jon Kohler <jon@nutanix.com>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, Borislav Petkov <bp@suse.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Subject: [PATCH v2] x86/tsx: fix KVM guest live migration for tsx=on
Date:   Mon, 11 Apr 2022 16:07:01 -0400
Message-Id: <20220411200703.48654-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220411180131.5054-1-jon@nutanix.com>
References: <20220411180131.5054-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0061.namprd07.prod.outlook.com
 (2603:10b6:510:f::6) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab42ae10-42c5-497d-8a1b-08da1bf6eae6
X-MS-TrafficTypeDiagnostic: MWHPR02MB2382:EE_
X-Microsoft-Antispam-PRVS: <MWHPR02MB238244700BD74637CB0BD2E1AFEA9@MWHPR02MB2382.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YWXg/FaArIKtQBszqWLqh0wMMfXj1INEFHuTorNim8+71V6qVH3fqJe0uuyIwUlPiCis9kJ+KPJR8EzH0PxFe6YRisrB2klbAyyM2rMiQ8pYTZmu/eW/MZm5GUMPyCQUvyD2MbHAuF3zaHRgWddRLKdIE4g5SVmoLmlJfABC5PLH2OzBD2A3O18UVwy2sFgVDGh0sPP52CMTg2jSRDQ3eaerXsrAp9o91mKonuJUeQsi0XSd3TVzeffhEuM0QJ3VQYjK1gmx4RR/PwjSKVUgsm0w9H/IiNsKFp0TEIUIxVl02gaDJnjVYg05TC5nEH9df6zRoAArA2N5BBmtrANJGsAQCFbBvt2rWPS0b52QRX6vvs68chM/H20ANTRJtkC7+zMb1ugLM4Bgwop32XCkLRgHYIB+pKtu9hWK26LXjJXBssqMoM4/W+PwRvcAcgRbplWw33NSH2dfJUkGKAwEVNob564o99JJyO8W9TkMSYyzwxLGZioUSm6J/JcHwSaSILfHVth722lRzkmsGjeaInFibz/RQn3e6Mjejwsa6lJEf1+w76DQV/uMkC4T6U/DO5yGxO6YdJL2nNVIPuPhzwZR9UkkQbPEFQvG3fAOUG/mYiYB1viKVob7gbE+jaf0BqQFmNCDLNcMLe9SUyCAmsFQ/ooiqikMgefY3JEHDkJdKdGywCYoZn8W5GDJiI6Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(6486002)(316002)(52116002)(1076003)(508600001)(36756003)(110136005)(54906003)(8936002)(7416002)(186003)(4326008)(38100700002)(66556008)(8676002)(66946007)(66476007)(86362001)(83380400001)(6512007)(6666004)(6506007)(5660300002)(2906002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KsPulO7LYrQoqoOzB4O+6caxK2SCSfOndXf158C196W9BwF5AWC+EmowQwcc?=
 =?us-ascii?Q?+LXPDChQlvX/VxRl0Cm/5XLvFnDOia0CmuyTvAZNyH4b73f9LR5JNjDkMx18?=
 =?us-ascii?Q?7+CsWxULu4dM7zzMYaPUbaREi3gjQOp2cEW96V9L7M9J3CMHoXzteMNUVx+T?=
 =?us-ascii?Q?S9gEJqDQq2hS5wKK1sgBtxE37clhbDRaiP9hBeGs/nBLCTAc092zJ0Tnit3G?=
 =?us-ascii?Q?OfWdDoEZysfwzOULk8emlMgFa/nM1qfZKYZXZkmwu1JFMIS79hZ1I8xoCL0S?=
 =?us-ascii?Q?S3FfD4HSxIDzQTpRKCLIfe7ifm9roehhvRB4Sfel1R4W+K0J7LpYLHOJW+op?=
 =?us-ascii?Q?8QncVimGI9BJn9ypM2+9FOu9gBySSSQw+lHpFtfAMKlpMx1p6hAyrbNqsocC?=
 =?us-ascii?Q?/QKmJJuh+DSFpkpLyLkELfuXhTrVfAQMq+H7nAI/IkyZERvrG2rLIoOVA+lq?=
 =?us-ascii?Q?9mS4SOGfGG+MTkvBdIsBhvUVaIBuNoZJEoVZELBMsYY1bFIBo2Zp14tFn3JR?=
 =?us-ascii?Q?V4LR4LpgK2Oh90tAyLt2U4tpjiVSQYBIJ/x0nN9kDRSAxCeXJS2LSQM93h29?=
 =?us-ascii?Q?Eo7VxUKv+40YSNzZotb07EhsjAmIABXjzcqAvvg38NXIfvebD7ec5QvyupwS?=
 =?us-ascii?Q?m2RvG5Ut4Or3EI9hZaDJqIQyASQ3mEVbrQ/dWBwXYjM6yDSZ2MZK+XkkaNTI?=
 =?us-ascii?Q?icDDV26zaAdpX2lQ/gMNDknFzaMKcBKWgdSJ8WZI6UPv4SEa17DTOldJ5EzZ?=
 =?us-ascii?Q?cH7WGwoV50Vq1apqUQbcUovLgEjc/oQCzd3w9GSu2v5+30HMxAy7EnSrUvG4?=
 =?us-ascii?Q?lYgizrG268Gg+TjjPEupSCIDrrm7J9S36cj7GNsg3vJVd291vQzM5Yel6bWV?=
 =?us-ascii?Q?PtvnLWj4OcVaNjM1dHM0xk1fCVdfuLS5X8U5Otgmf+fD2N/q4hjFbhJRajFJ?=
 =?us-ascii?Q?beSsGKFyFC95n0f2J7jjek5G8yyW2SVfi25ZMn4r3SfKGmvObPIxv4RFkaGG?=
 =?us-ascii?Q?GFRUkzm4mHABTu3nvC2dNMEONbzV+t7hwWIiavVcOz2hnaVydebZhXVl/1D6?=
 =?us-ascii?Q?hFWwCTV0on3ZWhfRBZB/Fs2khz6KHRQMbiGeyx7lyXe4mI4huSEnBbh6+SqJ?=
 =?us-ascii?Q?X9ibRZyv9PJUQdry+6hHiuXjdYeokvKSLGNaPd4Xx+/aMbHfGZqJyYgv9Fwe?=
 =?us-ascii?Q?WJg+yHYEK4lFxw92peXxQSVGY0Q/SZYb3SqY11NSRCYJErSzBWxR/qmjBGyP?=
 =?us-ascii?Q?li8X8dJOt9bOtZYkufGp6HQXjoIQ2E/CB4h5A9hTKG8AeWAnbVKMFbuvDwij?=
 =?us-ascii?Q?Tmf2CXUNaifBivfU4ZQNKVFmQqtvfG6yjXCl4WTqTSpXfgRaM+Z4HchRLm8V?=
 =?us-ascii?Q?rP8Q/PLNDQaNdulCvnn0rgyiYTmYZ+/MEnQWEkYQSRgKLpeu7LAHy5rYEJFd?=
 =?us-ascii?Q?KxWA+zO1bvKnsEbQ9iURktkBXFJwpkLo8IGnm61myjDuOyd6Fu/abxbABGTh?=
 =?us-ascii?Q?kaFxhXLcdxcsRaYubIgsOmryvoRl5m/ryqWJ9Vchbd20okodean/fr3wCMn4?=
 =?us-ascii?Q?eptidu8PWF8wAtiqcnoX3njXOZj/4Vn6JPphgXVLdMxDdnf3rEAe3mE48bsd?=
 =?us-ascii?Q?4BoCwODix84B9lInGm0rpjgOyiV1OpmwH7QWTLWNQhYEdUnGE9c1txbPMZF2?=
 =?us-ascii?Q?azbmfkTc0tpKGkqP5GQUL7en2f/UTq4uGG2Aui6TF/FyCgaHHBm3fUPCboFQ?=
 =?us-ascii?Q?sFrDIBe4v9rgNKlcslyflAu0xrRE+iQE8JD1dGIUjMqkV4L/BUIXdW+BV2DY?=
X-MS-Exchange-AntiSpam-MessageData-1: 8yxXpsOfHXQtGnt2EGp0UJtF+/Shf8miyUQ=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab42ae10-42c5-497d-8a1b-08da1bf6eae6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 20:07:34.4634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xXK8QQKoF5mDt9z58HCsuhrWQaB55nWiSU2Qd7lpXIBt7/xcUqkHdQGiXO3MP+Wa3mpEjbEdQPy4RtfSa6BSF0FYxQAcN8XAxmGKWP/rGMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2382
X-Proofpoint-ORIG-GUID: e3q1xkVQiJqogFzEk0ppvTOixxso6ocV
X-Proofpoint-GUID: e3q1xkVQiJqogFzEk0ppvTOixxso6ocV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_08,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move automatic disablement for TSX microcode deprecation from tsx_init() to
x86_get_tsx_auto_mode(), such that systems with tsx=on will continue to
see the TSX CPU features (HLE, RTM) even on updated microcode.

KVM live migration could be possibly be broken in 5.14+ commit 293649307ef9
("x86/tsx: Clear CPUID bits when TSX always force aborts"). Consider the
following scenario:

1. KVM hosts clustered in a live migration capable setup.
2. KVM guests have TSX CPU features HLE and/or RTM presented.
3. One of the three maintenance events occur:
3a. An existing host running kernel >= 5.14 in the pool updated with the
    new microcode.
3b. A new host running kernel >= 5.14 is commissioned that already has the
    microcode update preloaded.
3c. All hosts are running kernel < 5.14 with microcode update already
    loaded and one existing host gets updated to kernel >= 5.14.
4. After maintenance event, the impacted host will not have HLE and RTM
   exposed, and live migrations with guests with TSX features might not
   migrate.

Users using tsx=on or CONFIG_X86_INTEL_TSX_MODE_ON should always see
HLE and RTM on capable Intel SKUs, even if microcode has been clubbed to
prevent functionality.

Users using tsx=auto get or CONFIG_X86_INTEL_TSX_MODE_AUTO get to roll the
dice with whatever the kernel believes the appropriate default is, which
includes the feature disappearing after a kernel and/or microcode update.
These users should consider masking HLE and RTM at a higher control plane
level, e.g. qemu or libvirt, such that guests on TSX enabled systems do not
see HLE/RTM and therefore do not enable TAA mitigation.

Fixes: 293649307ef9 ("x86/tsx: Clear CPUID bits when TSX always force aborts")

Signed-off-by: Jon Kohler <jon@nutanix.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Neelima Krishnan <neelima.krishnan@intel.com>
Cc: kvm@vger.kernel.org <kvm@vger.kernel.org>
---
v1 -> v2:
 - Addressed comments on approach from Dave.

 arch/x86/kernel/cpu/tsx.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index 9c7a5f049292..4b701fa64869 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -78,6 +78,10 @@ static bool __init tsx_ctrl_is_supported(void)

 static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
 {
+	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT) &&
+	    boot_cpu_has(X86_FEATURE_TSX_FORCE_ABORT))
+		return TSX_CTRL_RTM_ALWAYS_ABORT;
+
 	if (boot_cpu_has_bug(X86_BUG_TAA))
 		return TSX_CTRL_DISABLE;

@@ -105,21 +109,6 @@ void __init tsx_init(void)
 	char arg[5] = {};
 	int ret;

-	/*
-	 * Hardware will always abort a TSX transaction if both CPUID bits
-	 * RTM_ALWAYS_ABORT and TSX_FORCE_ABORT are set. In this case, it is
-	 * better not to enumerate CPUID.RTM and CPUID.HLE bits. Clear them
-	 * here.
-	 */
-	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT) &&
-	    boot_cpu_has(X86_FEATURE_TSX_FORCE_ABORT)) {
-		tsx_ctrl_state = TSX_CTRL_RTM_ALWAYS_ABORT;
-		tsx_clear_cpuid();
-		setup_clear_cpu_cap(X86_FEATURE_RTM);
-		setup_clear_cpu_cap(X86_FEATURE_HLE);
-		return;
-	}
-
 	if (!tsx_ctrl_is_supported()) {
 		tsx_ctrl_state = TSX_CTRL_NOT_SUPPORTED;
 		return;
@@ -173,5 +162,16 @@ void __init tsx_init(void)
 		 */
 		setup_force_cpu_cap(X86_FEATURE_RTM);
 		setup_force_cpu_cap(X86_FEATURE_HLE);
+	} else if (tsx_ctrl_state == TSX_CTRL_RTM_ALWAYS_ABORT) {
+
+		/*
+		 * Hardware will always abort a TSX transaction if both CPUID bits
+		 * RTM_ALWAYS_ABORT and TSX_FORCE_ABORT are set. In this case, it is
+		 * better not to enumerate CPUID.RTM and CPUID.HLE bits. Clear them
+		 * here.
+		 */
+		tsx_clear_cpuid();
+		setup_clear_cpu_cap(X86_FEATURE_RTM);
+		setup_clear_cpu_cap(X86_FEATURE_HLE);
 	}
 }
--
2.30.1 (Apple Git-130)


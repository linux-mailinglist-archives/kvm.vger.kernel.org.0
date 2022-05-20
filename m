Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71EF852F40D
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 21:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353333AbiETTym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 15:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238363AbiETTyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 15:54:40 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6B6196698;
        Fri, 20 May 2022 12:54:39 -0700 (PDT)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KEdsVa018233;
        Fri, 20 May 2022 12:53:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=HOI2FXfrCklr8eN65JVepP6NGZogRxkp/FWag4X0Uiw=;
 b=UqBEwvkvRX9i73H0XpsELwHceGe2ZUKsanvLWvhwIxCoZDrmrBoLbmBVxhM2aScX0GIE
 5Ph7ZgIJzIjIUzm55aca1XJ8vALhbIf+TJEOJY6ySQJlsVTouBN89eTOtYLyV8jTwGil
 6UmrvQP/BRDYhIHTZ7he1XKMkLLZ/n375wrwq4xiRW2CHNZ+V/2C1+pXsgc+ljWSKXkK
 TCLjq9uvydPPi66qSFs9GXalPN7gsB6AG9WkGILyT/hknjba2WgtJ3LRN35h7PkVlHFG
 tWvWIUt9JeH4uZJFpJwmhl0UFBhZ1xcl2k+o6skOho/Q8RsoDelGOd8RK0ld6OqWHTRK 0w== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3g2byyx3ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 12:53:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmCvdSLlVjOVkmW941IYxocxggIIFK/t8MlW+Z7h6XZXZ/qmLy1AKBy/fjg2xk+rDMZURBzzzgcvGVFvG5890V30k7jG2b9cQZKAUFYecQHI+1EqPspqANDY0UMXUGoE/bdDIjFZGFJGGsY6QAjwUg5qYQNlKOdVBGuWDiaSMVBbow3ZLN40Icpx5IeHbZhSCnV6jK7Bjh9B2WjTUqwjPqEXrn285KFrhscBOrTZNKRJUxuJ15jWxTb0uzQ8v2Xx5rzc6oQh4dx5YXdFILi1blt+4Pgj5ZOPI4SgDn9pKvT94uUTFc7FRm4ZZIMG3xBxJeK9EJGvZC8LKM+tqR32+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HOI2FXfrCklr8eN65JVepP6NGZogRxkp/FWag4X0Uiw=;
 b=mi5EbxOOiqgKa1ifoiiT2CZwO2RdfGjB3WNM/N7V66HcrZPXzSx+D17LU93QbCanhYDPWOiE8dA6zbI8bUqGlyOeZoRzErifXu+7f1W60Y2u/GxpNwMSsJ55ea4IXr4r1r7rq6j6xMxYVof70hOton2T1I7Wn2s3TZmcSFLngfagB1fsuNDr/lY6RoSmRPvzSVyvER8VJW318u2Kr5Hgj2t4t2A5Vwi6/fqlBn1DobAKfkDs+3n1fDmrMKRQopxhjNUFASLQNrjyUWArmjol8xuDVG8MEm8VBa1Tss5ngevNszzYC5YUIpaVuFjZk+fpKpzaHaD/7TVfu+3Wd51lzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BY5PR02MB6535.namprd02.prod.outlook.com (2603:10b6:a03:1da::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 19:53:29 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 19:53:29 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jon Kohler <jon@nutanix.com>
Subject: [PATCH v2] KVM: VMX: do not disable interception for MSR_IA32_SPEC_CTRL on eIBRS
Date:   Fri, 20 May 2022 15:53:03 -0400
Message-Id: <20220520195303.58692-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0176.namprd03.prod.outlook.com
 (2603:10b6:a03:338::31) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c4874d4-ad0d-43ec-3da5-08da3a9a6948
X-MS-TrafficTypeDiagnostic: BY5PR02MB6535:EE_
X-Microsoft-Antispam-PRVS: <BY5PR02MB6535A2278451CF072852A029AFD39@BY5PR02MB6535.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U9N/R1Ueh24gr0V2SPpbXVNxvnu9QNs3rwKxVLOb0qNceeN5j4A1Hxxh1neiuEktSc/NYcNBP6WRr8+o94OYeS+AaTlKXKKu0K734K0kcLKEP842yzwTXPMyPX4c9f0dXuzB74a+Z/+4LWeC5qYWWF64wvmqoKdwU58hhke6+uCDHV+Jz0qWsh1X7t4iHZdMFCI/nZ3Fe+NuMRQJAa/jBSfgTxd+VZ6Kss+UgNDyWbL2FuCG/mJvtXIniJ+KFigk2VAKkunmqp0UASgvdQkMdSW0sMpkzqEUx22giLpNF9ybyjYVw5bvKmAjGdnEATB48BuRphO3yVXVs1fl9q2A/BrzZP3VAF5xKhVM6ZArVA7eviUN4RIKPN92+VTPhuzHtCgxiPEwWPGu3yo/oSJWB1kZCeoTwYmIv9AfhVlLcDE9LaO1n2oAMzVSHjbAhC2fntWsUD448PStvfYjlfD3l9L9Ozkv62QLIEO6Oe4cGkTZTnQ3bgzfLRRerM4nHtX3/A10zXJrCPIJYxYcSiry2JkZaoQpt0bKmxaax60REclEYMZ5AkuiYw8xJX7NackY20OiHMc12JgESd6usnDZlbxZjDCkHkh+pJIuWrxBN8iIlEnSTR8vaOUmOZ/xuzhkQ1FXhWv7ON4EzF8tBK6tXLlho6/53qVKzMDWn9Zc4+5PUySItgotXZclIwOpXWM3bxFpYse/f38vuiulB4cOzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(186003)(2616005)(6506007)(107886003)(921005)(508600001)(1076003)(38100700002)(86362001)(6512007)(83380400001)(36756003)(6486002)(7416002)(5660300002)(66946007)(66556008)(66476007)(52116002)(2906002)(6666004)(110136005)(8676002)(8936002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1LZ5sfYD7g8XfZeKm7Wu6vxrSP8FujAD22I75mNP4Ye+GhELAWDmXnc7Mkw8?=
 =?us-ascii?Q?aTdkDTergMCdrAZQkBKHC+HuDpv7aVaLOqsyCRkS55WlyFT5C5+oU3YGdWyv?=
 =?us-ascii?Q?GJllWCCm0H0wEzyzq/OZE5p5c9wzAPUbNFavIG0SAm+7SPwJzj5hI6S5YH0k?=
 =?us-ascii?Q?vSHx/numRPRwpPd2EtP/zRuy6QaMqBydk5bV/HWtZj5/MfJZ60URDUUF5mqa?=
 =?us-ascii?Q?+enNtaeLdpUdA0DO+GOpd1Lw45ZvnU3JQX6hPNS2GEv1+e8Sqp9fr2Q4mEXx?=
 =?us-ascii?Q?jaMya02ZTwLR9+JexVWKASOIe3a54XJC9dNXwapBL72EhCPt//ky70FYkE+2?=
 =?us-ascii?Q?xHwothi4vst7DC8Z1o862tXvXJmAB0NImcY4M1r/wba0nAR1yaR9KHSfMvuB?=
 =?us-ascii?Q?wka02loc/wyAo4wjaB91hUxTOIN9TWTlrGlW3w2gY+uUUl4ENtRMsT9uMUah?=
 =?us-ascii?Q?kBioEyVCuFoi2c/VGegrlKeMGsy0YU6b71gl9bkY8qI1mEZuakj7c9jevbcE?=
 =?us-ascii?Q?q13NLrmoZqfrEN5/tSp7BOBjSdAgvbMeFseeV0627bjoKkgOaOtkSR9UNjwO?=
 =?us-ascii?Q?wOkZIjDzSA8YHrGHd9xSlmCv9OaDE7wV8ZYqLN+KZvWxOV199x6sPwAYaSSF?=
 =?us-ascii?Q?HCOPrHq4wIBE07DeFWYd9ve/Smi/wtQVqXYjEy0roxAucfo/tqpuYHr+Ak8o?=
 =?us-ascii?Q?Bhn0ha9YELOpfhAV5xuXtvnLbaxnt5lPVCgQ2xzN5W7dmI+JlGw3N+Nv0rHQ?=
 =?us-ascii?Q?c3l4RQvH0kvsKhTV+QJwXhg+RkYPoMANbBgmKmzVqd6VDGt2rqwulQvvAqNw?=
 =?us-ascii?Q?2xe+u1JJVwkgXY6bPxO13lHYBWEGNGwmuy09cWOllWBbGI1qRMtYG7LWjF61?=
 =?us-ascii?Q?put2vssT4HcpWZVk3ZOA26ef5MtvAZHnoViEJNC1cRgXzOMkqCQ3m2p3nelZ?=
 =?us-ascii?Q?iliXymy3oZRzVgoEgfaCtWI8jKfCmDlnNVl724SGnW+F0mDrEI5Ew8Ekireg?=
 =?us-ascii?Q?EZNhK2MvneRVzQIEthAu6eeA+VSOjmnwbVFZeJuSHSGTf0VZkk+ECneeEv1T?=
 =?us-ascii?Q?LpxGrrlPF/k5jcIaCdIFMV5e8r8IDrM6kNZvCm9FqP5UmRHneY2kL173foje?=
 =?us-ascii?Q?q0I4Wlhu4eRTB54vQ+f0jR9zgw8OK0f1lj437bixURKm1HVPB8MqN1jYHzti?=
 =?us-ascii?Q?fMa6nnqiMMlabr4RuvKX2PuoBGO1HDViJnMsgLoK1A06AIJeZlvFG2oCAEWq?=
 =?us-ascii?Q?dInVflP0GsL125SqR1uhlBzh/89m9P0AF/r8GcrNh/nDp+NStS2qxQqQmfIf?=
 =?us-ascii?Q?69EyJpgrdUZ/thVZ/oeU6a3vHCp7zFlbIe7Cho3of33H4zMpfKNAc1qyHqgr?=
 =?us-ascii?Q?DcUl6kqFzw4/xdHR2B8hj6kWKHnIGlG0OcKw1Zk88OrCsVXK4foJJgTenohA?=
 =?us-ascii?Q?OzV/QxR0NXDIYzwcGSSVTMgmUPJgISM53OL5j5Yg3AdxM/2StOpTgy9HMWMr?=
 =?us-ascii?Q?EiVsr+PAloRXWu1M0WDc4n5qjP8gA9GO3NNOAtSGWDioIRzDnBlAo33rkfDX?=
 =?us-ascii?Q?4kJ2i990UlvERhA2QwINEQEk1VKnIFtDUL6DSGPaPRSVLhGaZ89Yk4WE6ct9?=
 =?us-ascii?Q?mEdWxucyX5mfvYapmY1Oop+xME5CwvLvglwnJKbdso2Rzo+jyeDa9XxtyNhl?=
 =?us-ascii?Q?i9FmCSGCSxOllh6FVSvbW5bCMU5F8WHn2dcSWbLoxmoZ3FyGqARCKPj7HSXm?=
 =?us-ascii?Q?0Dgg0gU56sSqMAOOdV2wykeoxnChcv53meiMN+QfS6i60rwfeUtXgNYmAvNz?=
X-MS-Exchange-AntiSpam-MessageData-1: PHcgpmPkWkoTkT5DZkDSc5qjrzffOttZ8KEmjQgiBql7fOQ7JxpZ0vJZ
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c4874d4-ad0d-43ec-3da5-08da3a9a6948
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:53:29.5812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s5HjgzWgb3kUU+oUAJOGr+GiwVt5uior+3kF+dA2Ih2C0Ygk5iw932xokTijK6MHh3rhb9MgPyqFjALQu/kcm4JTFVDopKpMWMhQhI8jymw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6535
X-Proofpoint-GUID: RnsYQuXuWhmHX8so6cmfLT4ilIJPGNb9
X-Proofpoint-ORIG-GUID: RnsYQuXuWhmHX8so6cmfLT4ilIJPGNb9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_06,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid expensive rdmsr on every VM Exit for MSR_IA32_SPEC_CTRL on
eIBRS enabled systems iff the guest only sets IA32_SPEC_CTRL[0] (IBRS)
and not [1] (STIBP) or [2] (SSBD) by not disabling interception in
the MSR bitmap. Note: this logic is only for eIBRS, as Intel's guidance
has long been that eIBRS only needs to be set once, so most guests with
eIBRS awareness should behave nicely. We would not want to accidentally
regress misbehaving guests on pre-eIBRS systems, who might be spamming
IBRS MSR without the hypervisor being able to see it today.

eIBRS enabled guests using just IBRS will only write SPEC_CTRL MSR
once or twice per vCPU on boot, so it is far better to take those
VM exits on boot than having to read and save this msr on every
single VM exit forever. This outcome was suggested on Andrea's commit
2f46993d83ff ("x86: change default to spec_store_bypass_disable=prctl spectre_v2_user=prctl")
however, since interception is still unilaterally disabled, the rdmsr
tax is still there even after that commit.

This is a significant win for eIBRS enabled systems as this rdmsr
accounts for roughly ~50% of time for vmx_vcpu_run() as observed
by perf top disassembly, and is in the critical path for all
VM-Exits, including fastpath exits.

Update relevant comments in vmx_vcpu_run() and opportunistically
update comments for both MSR_IA32_SPEC_CTRL and MSR_IA32_PRED_CMD to
make it clear how L1 vs L2 handling works.

Fixes: 2f46993d83ff ("x86: change default to spec_store_bypass_disable=prctl spectre_v2_user=prctl")
Signed-off-by: Jon Kohler <jon@nutanix.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Waiman Long <longman@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 62 ++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 610355b9ccce..11c76b0db77b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2057,20 +2057,32 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 
 		vmx->spec_ctrl = data;
-		if (!data)
+
+		/*
+		 * Disable interception on the first non-zero write, unless the
+		 * guest is hosted on an eIBRS system and setting only
+		 * SPEC_CTRL_IBRS, which is typically set once at boot and never
+		 * touched again.  All other bits are often set on a per-task
+		 * basis, i.e. may change frequently, so the benefit of avoiding
+		 * VM-exits during guest context switches outweighs the cost of
+		 * RDMSR on every VM-Exit to save the guest's value.
+		 */
+		if (!data ||
+		    (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) &&
+			 data == SPEC_CTRL_IBRS))
 			break;
 
 		/*
-		 * For non-nested:
-		 * When it's written (to non-zero) for the first time, pass
-		 * it through.
-		 *
-		 * For nested:
-		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_vmx_prepare_msr_bitmap. We should not touch the
-		 * vmcs02.msr_bitmap here since it gets completely overwritten
-		 * in the merging. We update the vmcs01 here for L1 as well
-		 * since it will end up touching the MSR anyway now.
+		 * Update vmcs01.msr_bitmap even if L2 is active, i.e. disable
+		 * interception for the vCPU on the first write regardless of
+		 * whether the WRMSR came from L1 or L2.  vmcs02's bitmap is a
+		 * combination of vmcs01 and vmcs12 bitmaps, and will be
+		 * recomputed by nested_vmx_prepare_msr_bitmap() on the next
+		 * nested VM-Enter.  Note, this does mean that future WRMSRs
+		 * from L2 will be intercepted until the next nested VM-Exit if
+		 * L2 was the first to write, but L1 exposing the MSR to L2
+		 * without first writing it is unlikely and not worth the
+		 * extra bit of complexity.
 		 */
 		vmx_disable_intercept_for_msr(vcpu,
 					      MSR_IA32_SPEC_CTRL,
@@ -2098,15 +2110,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
 
 		/*
-		 * For non-nested:
-		 * When it's written (to non-zero) for the first time, pass
-		 * it through.
-		 *
-		 * For nested:
-		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_vmx_prepare_msr_bitmap. We should not touch the
-		 * vmcs02.msr_bitmap here since it gets completely overwritten
-		 * in the merging.
+		 * Disable interception on the first IBPB, odds are good IBPB
+		 * will be a frequent guest action.  See the comment for
+		 * MSR_IA32_SPEC_CTRL for details on the nested interaction.
 		 */
 		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W);
 		break;
@@ -6887,19 +6893,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx_vcpu_enter_exit(vcpu, vmx);
 
 	/*
-	 * We do not use IBRS in the kernel. If this vCPU has used the
-	 * SPEC_CTRL MSR it may have left it on; save the value and
-	 * turn it off. This is much more efficient than blindly adding
-	 * it to the atomic save/restore list. Especially as the former
-	 * (Saving guest MSRs on vmexit) doesn't even exist in KVM.
-	 *
-	 * For non-nested case:
-	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 *
-	 * For nested case:
-	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
+	 * Save SPEC_CTRL if it may have been written by the guest, the current
+	 * value in hardware is used by x86_spec_ctrl_restore_host() to avoid
+	 * WRMSR if the current value matches the host's desired value.
 	 */
 	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
 		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
-- 
2.30.1 (Apple Git-130)


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31162525519
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 20:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357775AbiELSq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 14:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356442AbiELSq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 14:46:57 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC4841F9F;
        Thu, 12 May 2022 11:46:54 -0700 (PDT)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CF1sBx013925;
        Thu, 12 May 2022 11:45:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=bD67T+67ilcpaMH6AGdx5Tm1wirWW3om0vxe4SZUOvU=;
 b=pwBDLD/LwnSXOtheCWNR5YkF3GPwMMl5/59p9tvkJedkzYRIN7aZct4nYxtatWMKox9d
 xTuexsMEeOC0Z9wwm9LTX7oHCDJHUy6i/nnxnU/Q6Gfxuz4hYjYLWR8eYU8EHkqH5rma
 QXvUV9svdbOawuQlITSEh7weQRCGJU7uiaUn7UO1UhE7wi3HJzN690Km0K5NC8F9vrJk
 oz+TvYGN0QCqdSsmIoat1ePqdTvyi8sL5RpOB7KBPIdj5FUFEaHrU69K65a6gvBGj6y/
 JC3iw/TBf2h5altmL+DSV6m0q+z3W3KTLGp80x2osE+N1MEfiAvq0xIPTzSjdFjM4X4z 3Q== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fwrdpbqsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 11:45:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZ6Ptc2KxkHcH0CcOrvgBXYSNU8VpwVpAK5EAy3vF7w1XOR3gsivvhHDCGMZwrKXNYdIhg4X6/8E5jZ2LC0S9aWyM24JenlM1eTzv96GNcr8rm7UIL+nqfkIgVGDvWm2ZAAZTyGNZfEAs306X6tQYqzLD5v5bZyN9YrgrqrOEp0WDxDMar9Hovc4GOymRvgPITXi9kRPBbv85h/csF5TuEvgXwU06x5egH70TqtEkt/H1DFqGQTNmVSWBB9pY1tSqbHSLTXwf/Y3OmtUrh0vJR09llRQMkXvK4UZEVpzp7KOfjEbmcAcczhe1JVq/1JCwSBalAz21wB5Kkk/vgcIZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bD67T+67ilcpaMH6AGdx5Tm1wirWW3om0vxe4SZUOvU=;
 b=O4lc28k1fNVCOYoOP5+b8/jlU5oQQeVzH9kJ50x/YBNgI6qPaCV4z5hkFwF0EO7AnFJVvZ+6oNfnBFJSoeRAl5umxSnNGEWS5pV2a2OUQU75eymM7duGYnIJi8R0ongc1Z5j3oRcQebaEi+Y6126roTsdNHoFnZWUG4CIYN9iPMqsEhLrjJ00P+xZLhbyOovVLDjbTl3mmqsO3w10DjEVYWgBReBBNf/s+fZT9yOzIYRLKcbAGQ2Kr/R3GaZQF5pB6xpY17f7xPBMhSlJILXvfrCiuutYTecGM/hSyMEEUjXR9pdGYUDutqOXRrcMu/hBr+vPozqGCq2KcJzwj7HtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL3PR02MB8185.namprd02.prod.outlook.com (2603:10b6:208:338::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Thu, 12 May
 2022 18:45:54 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 18:45:54 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jon Kohler <jon@nutanix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ashok Raj <ashok.raj@intel.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Waiman Long <longman@redhat.com>
Subject: [PATCH v4] x86/speculation, KVM: remove IBPB on vCPU load
Date:   Thu, 12 May 2022 14:45:11 -0400
Message-Id: <20220512184514.15742-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0067.namprd07.prod.outlook.com
 (2603:10b6:a03:60::44) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9101bc84-418d-48f1-3d22-08da3447a4b6
X-MS-TrafficTypeDiagnostic: BL3PR02MB8185:EE_
X-Microsoft-Antispam-PRVS: <BL3PR02MB81850C6FB6BE14D181A9F6B2AFCB9@BL3PR02MB8185.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LdwnGJiMGWxOvYVb+rw1N75/KdROtNJ7deC3BBopd05xyRMVx7e8aVEifmM7RKbcv5rFu6bNhIt5W8lPLfrm59uqoq9y8RznUXnFZBJc86Wm7grf2iyXK2bMn3sc5XwxhJhM7lJ+KaJ0j/Q+MvHJtnkwP+VaInllb/6lMvEP7yJmDDBg7Qu15FDFYzjgqhbp/uzuceYXz48MHP65dFdqP8X0NH/k45VRJH/hdUFFJgmhdr5SCnPfzn0GeNPguViaCMvMDdkaR/xJCc40bEclM7+R8fKMA4cjIgPb1gYv0W93ZoU+kfgj52fukJM+aiLt/3Aeqt/e0Weqixw10q0ObNVQ0TkuLnYpwYsB+mq5KktsBsei0NSZGBhb1uKO43FqjjVgJaniS2b2btEF6vmlFdr2umohvFtXzh4Dq8rxOAAfZGXa7RPB1Brb+9eiZwRTrpQqHb9LfvB1PdAyTA6FJgxb5h3Hv+BnwYG9/X8AZDwcY0BVtweJ+GZB52dShb/olfA7JBCvNoeySxK5IEBeRFCPJmkaGQbsXQkwYNghUrWihKSESe/xpKrcaBUFFftSMpqtG8ct9b1IMWxT36/Bh6P5UaV+xvi3DPJQJL/zHmgM2u/Dx+2mLs4dHKFAvtr6TjBwPomzsm5ZO7O4HqjfxMOlqrj/+cLIj5qVTF+sgJ2uq9IiM8JgJ35VDxk9ZWjJbQwMqjHLmKkW0vBvngqTo5zzgAOKGEhnhX5vm6m0Uv3E97fNN5XP9/R/0ivUTQ5q/1vRLF09L4vYIQXmrb3WCwU0Xl0H3JttZnNl/ZgKXCw+2UjqNFgeyKage8/YbHil
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(921005)(4326008)(86362001)(66946007)(8676002)(66556008)(6666004)(8936002)(38100700002)(2906002)(66476007)(6512007)(316002)(7416002)(5660300002)(6486002)(1076003)(110136005)(36756003)(83380400001)(52116002)(508600001)(186003)(2616005)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k6d7+BiOW3RYXYSVDN3HOwqAJG3XrIcqnDR1lGGAzdHStZEmYpCH7pU8kngV?=
 =?us-ascii?Q?+X+XHmcDkMlepFNqtG/DbjyTKKQ7IL9KyaDlCEottHPw1Ol540SdQ1laC+NM?=
 =?us-ascii?Q?cwq2VtwyqWRD9Jsl3+FKZgJOeTXx8NBg5DGfzGskipT0tAHBrC96ie8rMTXG?=
 =?us-ascii?Q?iRtddxPEfziZKUI/XAHQEaQYBnoPQG4QjMlB/UIFcK6FnVr26tBLJudYJ/aL?=
 =?us-ascii?Q?oUzEOBROvVJ38xmYskNfbsLkUeVJ1xwAimjIZs8GPO3Nk5VkeS5x7GcqGJwe?=
 =?us-ascii?Q?aUlFb8c6X8QeCqP5T0OtSPWavPQ6mZDGEjuJhQnexHoiSJ5RYD5rqvsWk7rs?=
 =?us-ascii?Q?pSLtBjl3BLBzOnyOfaL5beLZjAIyyph4kL5E+So5aUh3eTFyZWLrfprUumKN?=
 =?us-ascii?Q?WUM3pdD2lG/HMV0UNaU0yCIHPrtEV4ol+TbBgQtlMQ7Sl5kkin83RnOcBItH?=
 =?us-ascii?Q?Sle/RMWg67Yzvfq9Wzs1kNRG7XQ9UAIMKyjlkT50DFUAjvlmDo1Zfd/3/LFp?=
 =?us-ascii?Q?YMiOUvUc8rZScy7TffT5IsPC/yqwwj1LNNdKRZql2mdaPRCD46lW2IhO/3BZ?=
 =?us-ascii?Q?qRx6MDxCM/AT3YN2sSVClbEEO1oZK7Tw5wxF+Tzq1kI4zvkqeqFvm3jaQOnn?=
 =?us-ascii?Q?8GEHccnYzssJaHkBrbwiP7AcAIGK5NXFyZ/NvFYoLfLaT8bqnn7DwTIxPOs7?=
 =?us-ascii?Q?c6kZnnD66ourvxd1NZcQKVTxTp9rKDv5ZYASl3AYI60+8oE+IKcaAepbAgsU?=
 =?us-ascii?Q?InQ1+GqHZIsNrPt2F5iL/x7R2Gw54RjMMTizFHaFuN49eMwxZmk09ezEHknm?=
 =?us-ascii?Q?SrmIL58DRl9sbQ1yVAq+wEKtrwOM7+FsZ3QFZYjL9AeeufSvdBEmXYd+JIfk?=
 =?us-ascii?Q?JorK97bServt9kGRJOSeyIEKHuXiFdnofJUcQQ54DuAlHGgOihKsqjOevl5k?=
 =?us-ascii?Q?4h4myuM/7OpFEQMHpKdmcfDUW6qlqjM4m81FOJP7GMavozlvGU4wL7BlVtMb?=
 =?us-ascii?Q?y01fz0qdWDQ0a53YSg78eE/uOZvfYDCDyPVjk5nWhLh6drQ16psPeJ4HJcxi?=
 =?us-ascii?Q?W4EL8fgxV6GnL77KaJB49y1f5MZkErG7p+dC4w0Hm9gEcMQCek/fBCnmqyxz?=
 =?us-ascii?Q?iUa6G4GKT8r4oVuFSFhw4IjMd3gFF2UpgfUo5bCIDSx6baKHZMMr6q9p6kav?=
 =?us-ascii?Q?KEVUSeVJbxTDTuLpDQp303k58Gbkv5FDXb98Mv1iu2ix7baLSyHiHX34Ua7E?=
 =?us-ascii?Q?hjTNOJUchSPnRBx/nH7N7a0XFvk3uIMMKnWWp3VI030qLkszqWoHRGBJN4oM?=
 =?us-ascii?Q?r2Kc9fYn7rBcE1AaHob3+PrLxljW4PRIf9U5hUncRLvjZH0JXWjP2YsPs9EZ?=
 =?us-ascii?Q?hwdeRjDLK9W44M/CrPqiyR44ihPi9R4OeQ1o9YQtcGLMUu9swY+/2kWLe3oe?=
 =?us-ascii?Q?bN9QkWQUESjmEZrM1NSym/Ju/b9m9oQxgBbddPk5FMBmZcdgnIW3bidC6oOd?=
 =?us-ascii?Q?PUzELb62T3CAG6abxlHOnyCERYdWT9JwdHXFjednZB5fZMpBWw6uEneaM7Lo?=
 =?us-ascii?Q?Ii2EUYOIT1SNRl0O40oSbNyNKPQsZA9tTUGUvj0Vwx27NAGwzssHe5wivwxf?=
 =?us-ascii?Q?lvsB4aTyoy/PQPkcteflr/yClNzqhUq7W2UOZuutzlqiQJKiBHC1WMiKCVZw?=
 =?us-ascii?Q?3yaQvE/M62znpFEpgSWxGz8EVXiUuAn097PBF/0REGYA8Z3PXPwjSvkro1PC?=
 =?us-ascii?Q?P6YbpFLx8PsAb4rq94dVGMBjme9jKLk2fjWanh0hGSGZe2CsSXgFnAXdEJHx?=
X-MS-Exchange-AntiSpam-MessageData-1: gVd+Yuhnv/qym5hb6JZi5pfa9+B9V72+Bmo=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9101bc84-418d-48f1-3d22-08da3447a4b6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 18:45:54.3637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wt48Kd0Ije7xRt7b/NKUh3+8Ytc4edbSH38X8O1KN/ITXJl2oa/xxvfqirDtu5j/vj+nzf/8yi/rNBBCVMQUvsT9ZBOf7wV5ZLl81TQaEc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB8185
X-Proofpoint-GUID: INChNP24OaxsmlN-JNVHDHLhBaBTpZp3
X-Proofpoint-ORIG-GUID: INChNP24OaxsmlN-JNVHDHLhBaBTpZp3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_15,2022-05-12_01,2022-02-23_01
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

Remove IBPB that is done on KVM vCPU load, as the guest-to-guest
attack surface is already covered by switch_mm_irqs_off() ->
cond_mitigation().

The original commit 15d45071523d ("KVM/x86: Add IBPB support") was simply
wrong in its guest-to-guest design intention. There are three scenarios
at play here:

1. If the vCPUs belong to the same VM, they are in the same security
domain and do not need an IPBP.
2. If the vCPUs belong to different VMs, and each VM is in its own
mm_struct, switch_mm_irqs_off() will handle IBPB as an mm switch is
guaranteed to occur prior to loading a vCPU belonging to a different VMs.
3. If the vCPUs belong to different VMs, but multiple VMs share an
mm_struct, then the security benefits of an IBPB when switching vCPUs
are dubious, at best.

Issuing IBPB from KVM vCPU load would only cover #3, but there are no
known real world, tangible use cases for running multiple VMs belonging
to different security domains in a shared address space. Running multiple
VMs in a single address space is plausible and sane, _if_ they are all
in the same security domain or security is not a concern. If multiple VMs
are sharing an mm_structs, prediction attacks are the least of their
security worries.

Update documentation to reflect what we're protecting against and what
we're not and also remove "buddy" from vmx_vcpu_load_vmcs() as it is
now unused.

Fixes: 15d45071523d ("KVM/x86: Add IBPB support")
Signed-off-by: Jon Kohler <jon@nutanix.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Waiman Long <longman@redhat.com>
---
v1
 - https://lore.kernel.org/all/20220411164636.74866-1-jon@nutanix.com/
v1 -> v2:
 - https://lore.kernel.org/all/20220419020011.65995-1-jon@nutanix.com/
 - Addressed comments on approach from Sean.
v2 -> v3:
 - https://lore.kernel.org/all/20220422162103.32736-1-jon@nutanix.com/
 - Updated spec-ctrl.h comments and commit msg to incorporate
   additional feedback from Sean.
v3 -> v4:
 - Addressed comments from Boris and Sean.
 - Narrowed change to removing KVM's IBPB only + docs update.
 - Removed "buddy" on vmx_vcpu_load_vmcs() as it is now unused.

 Documentation/admin-guide/hw-vuln/spectre.rst | 33 +++++++++++++++++--
 arch/x86/kvm/svm/svm.c                        |  1 -
 arch/x86/kvm/vmx/nested.c                     |  6 ++--
 arch/x86/kvm/vmx/vmx.c                        | 13 ++------
 arch/x86/kvm/vmx/vmx.h                        |  3 +-
 5 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/spectre.rst b/Documentation/admin-guide/hw-vuln/spectre.rst
index 9e9556826450..1705f7a0b15d 100644
--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -314,7 +314,23 @@ Spectre variant 2

    Linux kernel mitigates attacks to other guests running in the same
    CPU hardware thread by flushing the return stack buffer on VM exit,
-   and clearing the branch target buffer before switching to a new guest.
+   and clearing the branch target buffer before switching to a new guest
+   using IBPB.
+
+   When using IBPB to clear branch target buffer, there are three
+   scenarios at play for VM switching, as follows:
+   If switching between vCPUs belonging to the same guest VM on the same CPU
+   hardware thread, they are considered to be in the same security domain and
+   do not need an IPBP.
+   If switching between vCPUs that belong to different VMs, and each VM has
+   its own memory address space, then IBPB will clear during the context
+   switch.
+   If the Virtual Machine Monitor (VMM) configures multiple VMs to share
+   a single address space, they are all considered to be one single security
+   domain, such that switching in between vCPUs that belong to different VMs
+   in this address space will not use IBPB. Sharing an address space between
+   multiple VMs is uncommon and should be discouraged for security minded
+   workloads.

    If SMT is used, Spectre variant 2 attacks from an untrusted guest
    in the sibling hyperthread can be mitigated by the administrator,
@@ -534,7 +550,9 @@ Spectre variant 2

    To mitigate guest-to-guest attacks in the same CPU hardware thread,
    the branch target buffer is sanitized by flushing before switching
-   to a new guest on a CPU.
+   to a new guest on a CPU. Note that this will not occur if guests are
+   configured to use a single shared memory address space, as that is
+   considered a single security domain.

    The above mitigations are turned on by default on vulnerable CPUs.

@@ -660,6 +678,17 @@ Mitigation selection guide
    against variant 2 attacks originating from programs running on
    sibling threads.

+   Note that in a virtualized environment using KVM, this flush will be
+   done when switching in between VMs. Each VM is considered its own
+   security domain and IBPB will not flush when switching in between
+   vCPUs from a single guest running on the same pCPU. Virtual machine
+   monitors (VMMs), such as qemu-kvm, traditionally configure each VM to
+   be a separate process with separate memory address space; however,
+   it should be explicitly noted that IBPB will not flush between vCPU
+   changes if a VMM configures multiple VMs in a shared address space.
+   While such a configuration is plausible, it is not practical from a
+   security perspective and should be avoided for security minded workloads.
+
    Alternatively, STIBP can be used only when running programs
    whose indirect branch speculation is explicitly disabled,
    while IBPB is still used all the time when switching to a new
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7e45d03cd018..051955145c29 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1302,7 +1302,6 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)

 	if (sd->current_vmcb != svm->vmcb) {
 		sd->current_vmcb = svm->vmcb;
-		indirect_branch_prediction_barrier();
 	}
 	if (kvm_vcpu_apicv_active(vcpu))
 		__avic_vcpu_load(vcpu, cpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 856c87563883..e2271d935d5c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -266,7 +266,7 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	cpu = get_cpu();
 	prev = vmx->loaded_vmcs;
 	vmx->loaded_vmcs = vmcs;
-	vmx_vcpu_load_vmcs(vcpu, cpu, prev);
+	vmx_vcpu_load_vmcs(vcpu, cpu);
 	vmx_sync_vmcs_host_state(vmx, prev);
 	put_cpu();

@@ -4097,12 +4097,12 @@ static void copy_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,

 	cpu = get_cpu();
 	vmx->loaded_vmcs = &vmx->nested.vmcs02;
-	vmx_vcpu_load_vmcs(vcpu, cpu, &vmx->vmcs01);
+	vmx_vcpu_load_vmcs(vcpu, cpu);

 	sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);

 	vmx->loaded_vmcs = &vmx->vmcs01;
-	vmx_vcpu_load_vmcs(vcpu, cpu, &vmx->nested.vmcs02);
+	vmx_vcpu_load_vmcs(vcpu, cpu);
 	put_cpu();
 }

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 610355b9ccce..13f720686ad1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1235,8 +1235,7 @@ static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
 }
 #endif

-void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
-			struct loaded_vmcs *buddy)
+void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool already_loaded = vmx->loaded_vmcs->cpu == cpu;
@@ -1263,14 +1262,6 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 	if (prev != vmx->loaded_vmcs->vmcs) {
 		per_cpu(current_vmcs, cpu) = vmx->loaded_vmcs->vmcs;
 		vmcs_load(vmx->loaded_vmcs->vmcs);
-
-		/*
-		 * No indirect branch prediction barrier needed when switching
-		 * the active VMCS within a guest, e.g. on nested VM-Enter.
-		 * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
-		 */
-		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
-			indirect_branch_prediction_barrier();
 	}

 	if (!already_loaded) {
@@ -1308,7 +1299,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);

-	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
+	vmx_vcpu_load_vmcs(vcpu, cpu);

 	vmx_vcpu_pi_load(vcpu, cpu);

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index b98c7e96697a..d5f6d8d0b7ca 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -369,8 +369,7 @@ struct kvm_vmx {
 };

 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
-void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
-			struct loaded_vmcs *buddy);
+void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu);
 int allocate_vpid(void);
 void free_vpid(int vpid);
 void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
--
2.30.1 (Apple Git-130)


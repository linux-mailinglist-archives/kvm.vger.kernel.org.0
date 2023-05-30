Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4587C716E46
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 22:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjE3UC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 16:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjE3UCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 16:02:54 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE06102;
        Tue, 30 May 2023 13:02:52 -0700 (PDT)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UF3fCT026847;
        Tue, 30 May 2023 13:02:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=onOBIYlEmEoJaU5CupLn5wHBxu8zLYjRvxmC6/sHHfY=;
 b=Dna1mz1+goHXf7MIuaXFqDYHLKCf1bBhPKdCoXuifmruv8qJZovtCFzVA1pYRxJjIXSE
 UXeMmeXjod4v/sinpE3969z/yqjq/ZdMXfbfJuwmndmwIC7HvOWm8stjOpEKMIBVYekD
 VWMAkF8KghdfaC/xjhNLJErfnPizNb2WDoWwRiEQRxFwb4VXRr3T+PlelIe2gWuAaBV3
 sjemhmMvIrDwi8hl8PRnDToRm+qxISCJFpH5MjELtYB2m11vqU0RmeQxe2GR86RQ6ngS
 VU5npeasQgaXTAD2I7CzsZiERTx765+Muqlcb09IbL2Pa5C1v07EhemzB3mph/5fRq2c Cw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3quh6cg6cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 13:02:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kt4XmCRPppK2a0A2speElv0LsW4vKbgOLocoeXlCz52p1ltjBiyfqp9dmvE8LD5TCUyEhuJcsUgCzEgElNB030GmHqlmrGY/HoA3pAzT3ihgnCVIxwEyKjLsCecy9N1H8b4uyUaI3PgXPS4sNBjlkWf8roKtgWkjNrjcmaAMCKGV65oAQtZZL3tlGilsRUGRe+bonh84xKOLWi/OZCjHCD1F2htB9IB5hafOsmlHlTMDaGapCyHIY79/Ii3g6YKdfMWlCsQTMJIATGh1hGzO4vHnMefstTcBKr9lNQ7ewf2sPrvZ0t3j7y2UuGCwWGz8J5oalp3CW+zZbRwtU8cCIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=onOBIYlEmEoJaU5CupLn5wHBxu8zLYjRvxmC6/sHHfY=;
 b=ObSIqlscfEV4bDMm80xZi1Sz6CX81R++i45Iqh+oAWeMZEmMXBv7hBMJ/zFt4zDQJi/itj7vN+lEsL96zCo7NZqeKTF6UXu7ktfHvXvTZhx1MyvAkYzFMUqKRF1+1uuBQuydigxUcFzTSp6FucMLtnEVZD6/CbK3BaLnk8/AzKK9fHyRcFPu+a7ONOYJiA9Iu6id2e7Pt/LlpKTwPJ7xdAP00WeNCt5Mh4i69J9aJsDWdGHfIjKK1U4vfYCyFklIQaJf2g0Ls9e1zEY3tVvWFFsz8FTv3aMfav5tIKtLXAK4WqoXuArf2n6YaIfaZLsMf/6YUV8ENa2cSXJBTRO7Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onOBIYlEmEoJaU5CupLn5wHBxu8zLYjRvxmC6/sHHfY=;
 b=RlsOT867BSvVFYFMl2uAAfVUrlfbmxQv4kKmL0RoENTCTyQM7XniojPjFrKGgTEZs0IbgrYakDLDHmJrQs+tBENBXFlAWZvDIU9Z0gFqeVWhr++srBYLzmDVGgEKddQ2pxi2tDlMjE4gmW/vU6/DiGegG98Uw2SKrB717d8kNxZRwhR76cgZCOVPFkb/21u3+ujTR4+aQGiLCi5KXcotJHqef+q0+Z4Zbqybubghs4Bo6TrVi8uxJdNeIw1SXvq8ijyBMYb8OH4HV+F250ZGnBQWWje76vK45QUPssPM2By7nbKOkY+jYiQdoFm8odtAc/98cIcatVXNuqzU7Kr7PA==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by CYYPR02MB9787.namprd02.prod.outlook.com (2603:10b6:930:ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 20:02:11 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f%4]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 20:02:11 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Kyle Huey <me@kylehuey.com>, neelnatu@google.com,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Jon Kohler <jon@nutanix.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] x86/fpu/xstate: clear XSAVE features if DISABLED_MASK set
Date:   Tue, 30 May 2023 16:01:50 -0400
Message-Id: <20230530200152.18961-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0006.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::19) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR02MB4579:EE_|CYYPR02MB9787:EE_
X-MS-Office365-Filtering-Correlation-Id: 057866ce-51eb-4127-a10a-08db6148c13c
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4RV0exuOr3DdtXxpT48fZn1muoC9G3be4abOGr2FXQXOloCu6GqFL2VwespA5Ac3SeCiqlMMON+/A7z/Njuh3luhQxM0wW18Y8RJAZV29S+yc4cubCRnTpYqJ9FyQVaVw+M/4DXm+jmelmoUuoFJZdroVVqdpzDok1GqioLInfZIKXc7MYj2TE+7DCy2l+0S/T6AJURc++k9aBIQMFVNtHVCnvOQEMs2vXTKv4tyvWAjWfPHkOlEx2FmMhZCuVPag5stlWA+bRZqjpjeHA60Sw2P+wD/l84HdrfJzQn9qEjVm+vGIoynfcdgifwPfE3RglzrctofCnrSKxzDMyDAnFscG0ddS8YruwZCGQmRJE8VKu3bKGMLiDfemDyLmeMfovXj7nQsFNJ3sRuNWhkbXdota+qYSTIFt/GgX8ODrxmnhGf0FnnMPpf+kiqa0gprsHTsbamDqO1AQNyR2mlTmqrvvfTCM1NM88w8QQ3+N6p+48DjnL0CSvBySv+zKr2lPs8iGVSqYT15NfPJdLcJnTDODsKBkUfHM7MJ6hBrMhGn5/X9urGMOBsmay9GjM76Lu89fPBchIhdjacVW/G+jLpppK0QfTH4pOPYY2BD7B/tw/J+5RG4dXXllMc+5UD5t3crXPApZNGrs3FLPwaYng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199021)(54906003)(478600001)(110136005)(8676002)(8936002)(7416002)(5660300002)(36756003)(2906002)(86362001)(921005)(66476007)(4326008)(66556008)(66946007)(316002)(38100700002)(41300700001)(2616005)(186003)(6512007)(1076003)(52116002)(6486002)(6666004)(6506007)(83380400001)(46800400005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aZ/Fu6jogleN22DO8jh7Q4/ESL2yDn7j9RMnrYDKOZVpC9iBk35yKRV+F6dx?=
 =?us-ascii?Q?fH4slqjz9E4mv+H0r21Uqms2GGmfjSTNABJ1b9gQeaFJA78kEGZCEXMsjcZu?=
 =?us-ascii?Q?UJmTy3v7izFQMtpEJyfesBTzqve4hrtvBUGp5o6ho3mEySEzfVvkCY6Pnxhk?=
 =?us-ascii?Q?+aoo6p/HCGRwp8ytAFwYMrLiR6rcr3F0QyuXfWUb9jU/KgWHC/m8Inaow+mm?=
 =?us-ascii?Q?aGMqim/u99U7y0VBoLiNkSNkHx7w6fKsCBXYyLik5BkEGp3payPawzwW2QJq?=
 =?us-ascii?Q?uP+HD3V01KM1PZ4OpDKEs4s6uT0xOALMhA3Irh2KKr3P/ldMYidtth4E9Lx8?=
 =?us-ascii?Q?dMK9zDeh7fOEuKeZv1mDtzk/Vo7M1QbDft2z52ngzRw3ZVXL3ZZDNuDCcvf3?=
 =?us-ascii?Q?/3gJhVL7+moRC0XLehHu4+opme13cILlAiA5vsJsealJvZqSC33XJg/igzjL?=
 =?us-ascii?Q?5F2+s1KRZf7jonSK/onPcLq2qZPfKqOjw2lTtLu2X0Up6YNKZausPQg7F6ki?=
 =?us-ascii?Q?bdGoUC5pGM564DtXs6YhPuGZ9DPbvq/TEkpvrn1Eb8n2F5F0TLlzFHt4JR1a?=
 =?us-ascii?Q?hXZpqvZKtjjFXxZYXWNE747zU4QYaORbL5Zs9PIvBXo09SQoGeu/4tttyBVp?=
 =?us-ascii?Q?GmT93Nf/Bh7vGgg0FX1iGayNaXVyfZ3XtIC6jATKBtqHpjC/815a80hnOc0A?=
 =?us-ascii?Q?cvoo/PQhSx+5iAmuACINtuNInw+h3dEVRLNhiN5Qrw4hdwBnd9/kf+7H7t0z?=
 =?us-ascii?Q?gjrGaDMfqIJJYgSMfuH7Vx/jJClAT/7Wg/0kcKyf/W/2nDy7CMtN3eLkCIew?=
 =?us-ascii?Q?oePfWDrrWXHK8JSDNqn5zjobYKPA6JNkcEWH38hz764JAgZV/XiyBe3In93E?=
 =?us-ascii?Q?LCbOT6azDRan6slcYhAgrafrtZL++Z10cfMPdgxWsHLyyFkkhziLSBfljQ7G?=
 =?us-ascii?Q?nprJAwTIwiNdzjxEp+qGhsTZ2puxfDrqQl1wv5FrmLr8kPTp10yid2jzZHVp?=
 =?us-ascii?Q?u0TSaoKLhqhYtvilQNL0/OcrecnshKymHeJt90/k4NB9Aabwp3ux07zLlHCA?=
 =?us-ascii?Q?VhzZBJDSiV+LP8Kqm8zvRHNUUdvrkHBm2Ilo9hp/xC2fpK5xWDoUhImuVeBI?=
 =?us-ascii?Q?f1v/7qXI92mlY7mYoBBi0jmSeBJ0/2iYLI2H/O+f/lEHaQyyW+Ufu5wbZ365?=
 =?us-ascii?Q?/K6TOadpWV62vVYU3ozqhGY/DKQQGPZVvtXQGcImuS8R4KEsixeMCIjLgWNi?=
 =?us-ascii?Q?BbwKh7xD7fYAbL3cdsvlshe50yzecdD9COfHCAnV1A/j3UuxWZqbLAgP2QlB?=
 =?us-ascii?Q?/ba1o4fVAVkNtY/XRX9ZNC/x3obhBoKA4KiLVCH+w7fvhHS9lZB7SiZRLawT?=
 =?us-ascii?Q?eqwEvt8QOg94KD/t2/gPbKLKlw6UBmO9oCgSVQt/EmLyyy4/IDIErvb/aT90?=
 =?us-ascii?Q?SGebRZ0L7hXEEwnYAtPD6v2C5Awk11t4wesMRbPcvier2w+0ZXCmcmeQQGK0?=
 =?us-ascii?Q?yg0IOQnm1KVb8i+mmGFb5O2RGX8S7UtKo44LVPW2JijGaGdCxVXoqaJxLEOL?=
 =?us-ascii?Q?aubLjGsU1xUAfTnChMOYI/SH1OJ+vWgBCxVmRT+f35Qjf2mYvLvZFGlHwHDY?=
 =?us-ascii?Q?nV1rCafzxVmDnHNNQpE0UgJplQiSa5WgqAupm+r1GizPRk0uXTuIDgTUjFdU?=
 =?us-ascii?Q?1P4XNA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 057866ce-51eb-4127-a10a-08db6148c13c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 20:02:11.2493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4+4Joj9DheKsbRMI03rMpS6TqYXsMtPHfv64rbhPJxxv831RkRcky+3vqaRWdBKun24U0kvVRH11lpdZLYCn1eoiiKorSl2P1gxqlsKIpNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR02MB9787
X-Proofpoint-ORIG-GUID: a6WSXJ-4ZUQQnxg4xhucGpWsLAEua8Xv
X-Proofpoint-GUID: a6WSXJ-4ZUQQnxg4xhucGpWsLAEua8Xv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_15,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Respect DISABLED_MASK when clearing XSAVE features, such that features
that are disabled do not appear in the xfeatures mask.

This is important for kvm_load_{guest|host}_xsave_state, which look
at host_xcr0 and will do an expensive xsetbv when the guest and host
do not match.

A prime example if CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is disabled,
the guest OS will not see PKU masked; however, the guest will incur
xsetbv since the host mask will never match the guest, even though
DISABLED_MASK16 has DISABLE_PKU set.

Signed-off-by: Jon Kohler <jon@nutanix.com>
CC: kvm@vger.kernel.org
CC: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/fpu/xstate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 0bab497c9436..211ef82b53e3 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -798,7 +798,8 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 		unsigned short cid = xsave_cpuid_features[i];

 		/* Careful: X86_FEATURE_FPU is 0! */
-		if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid))
+		if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid) ||
+		    DISABLED_MASK_BIT_SET(cid))
 			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
 	}

--
2.30.1 (Apple Git-130)


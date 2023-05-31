Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF3171857A
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 17:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbjEaPCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 11:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbjEaPCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 11:02:07 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E48D98;
        Wed, 31 May 2023 08:02:01 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VETBmI004420;
        Wed, 31 May 2023 08:01:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=NhHqBaHaRbE7xCoTxDNN5fuF/rAzE5MjmdNybCg+c28=;
 b=EjdZGNBdfvwQydGrtxMv+HFyg9WLcsv/qjF5+sC8yNXGv8Fpwz3O/3BiFDIkMzS41r30
 ZQBGmo6QLstnQAq7xtHNSbu28msmEn6qlDBPhfcQups3HZKN94BINY4KNjbtEMY+vpjX
 vD/XG42pa7T+hiuwAXzLbQ2KHiDvK8tw9hYbbZI8EGmJ/GPGCVtoNp4LHFmlsU/9pvNx
 HAR49jIo8iSDiKLwUN47DeSESp0l2rHsg7T4Shb59Y34x6WoU/zZKZzx8RQaOL/QpBBM
 53VHg6u/b4oAk7ee1xr2mfc/kw/t1Dj0ro5bValFqX13xDpTt9ax67YjZLlF4bIjGTI2 WQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3qufyfa406-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 08:01:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eay7k4m2hmd8mvDcAyoqcEd/u1iOTlgGzm3hqSdxSqld7ozIaIKfreIoUJQy+3jAq3V6Ds0Pny3io9KLAHb6BQkLgutjtPdthoBHBkIfmyotHa6eB+Syq4h+7nhQxzn2QjT4+6HBms/9bXDzsarS7MuOV1MYx3BMvcrRfcbrhBY2GC/tCQNyAnrZzHPguW37WwLEsQWEFhtLY7C1HVEx/74Pk2JjMHAPOwLN9paqGwHaYiqYNXoBhuyOxaNGm5llt5nsbN9Z6TVt7MnlWXL3zxR0XoBcg6Yq7HpeuWO86HkRKVidBeDOsZaSXG9qOWFJz7zsfWkEefJDI5fa9kjI1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NhHqBaHaRbE7xCoTxDNN5fuF/rAzE5MjmdNybCg+c28=;
 b=b7gX8xbwz7pohgto23elFEnvMhYbPb0bWLMpx4cspfDqUzbQIl/V3iQMbvzcMDpn806hPoP45dLgyiu16I1iNB6lULRA8M3COiTUiS2GbPfaCQGASxZKwaRRutM6UDIWJRtQf5q1LwXfygC969QtWThhWiAYaJBm+3u2eYLy3NGqxqyKzXFid6OxZeTOupOEHLjZUoUHAxqq0dX8amxjhJ823ebY32Mzm3F8HLwMPUQCMcetnX3Noc3YNIVVocZMWDuVpAybve0T+jGPio1Xeqg0KWQCm9+JPgmZTUZh0Ca8HsSgbDSWyXVJvSWg3Dsa14gBfavh7PSk0TtW1K4joA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NhHqBaHaRbE7xCoTxDNN5fuF/rAzE5MjmdNybCg+c28=;
 b=nKs65px1gPNZRY0KsHcl2VPCtAEICbY4kHszAdYs1imKmf5hCt9G9mhDQX798Hqyz6qmpOUn6pNLamS8VNdNSfvy9HWEg5RC0YpUTUWl+oyJvg7vH4hpbFnE5L6MNlb2MBYJdLoEEK96Z3HXwh+h9puq/bx2sL3FHaJjLFMBSdMdot23CTOEFyju8FOQzBXiS053E/8I0orS+dZFyBeOnrBID18lqJf0M2juDvub2WU+Ap+3ntf2yrUhDBsS1ym6QvZzpk25222GTRqnUwzoZ0KByFMciJ5Gkpst/ndKXU3TkrNWfHXEFqkZu43tGkqrLOUrBpcQjm7IiGRl27NCXA==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by IA1PR02MB8922.namprd02.prod.outlook.com (2603:10b6:208:3ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 15:01:26 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:01:26 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jon Kohler <jon@nutanix.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Date:   Wed, 31 May 2023 11:01:12 -0400
Message-Id: <20230531150112.76156-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:a03:505::13) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR02MB4579:EE_|IA1PR02MB8922:EE_
X-MS-Office365-Filtering-Correlation-Id: 776f6559-2365-467a-0f69-08db61e7e801
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A0V/40pr5dgE6NTVImp1OKMfDfw1W4RnnOvSyGSkOEVatBOY09YdPvBOentegxSu9ZN3x261cZug1vL9KR5N+HKdhm4tc6S9oK6oZexM+3Y+2i9gJPmmiY++jOm+dCpZIE9LR/homvopoUjRHxN36//zlK3Fe91dYhjsw22/gz9M+6O3BBIJ86Ub6n69mT+2F0KMfkhWmqpgVWiOQSs0WjdasoQ0Q4nNwAQJt65GElQWb3m2rBVXTO82gNVEfuc8Urtph1wpmwgORZKOJaL7lMCcI3x2sTUAbL0iA1Um3Zr9AXMY9oT3mlGRClOVrWiul96ldDuWjhO95fOAr8fkVwfM9VQLo12yW61DhqpAvoxbhUbXRRvrQ0M3gXwHhQWflmNqnC/wMv1YOCUkBYSPEVc16L3sMspvHoeWTUNt3rUoCvIKKODEldy46cuuo3htIVckx5oPJNpKrWV+FpdpRcI91VDMrles63UuTboHNuarKnS89AdfMq5+qkUM2dnL/Yr6UFVvCfDI++A3UvT4RnZhN3WTexbv/Q6rhbjImNvsPdZrfOj4EO419vXvpBW2oqAvHb8itXoJu/s9tQlrJT+22ACjlhEX7xcZlwI6UGwznofFNdEke5bR71NJ8Snd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(66476007)(5660300002)(36756003)(7416002)(4326008)(66946007)(6666004)(66556008)(478600001)(110136005)(54906003)(8676002)(316002)(6486002)(52116002)(41300700001)(966005)(38100700002)(921005)(8936002)(86362001)(2616005)(6512007)(186003)(83380400001)(1076003)(6506007)(2906002)(46800400005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CGg5zUWI0oKzCnT7bsZBZKqXEctlLtEAKM5+R6V0cMjnrlcuSgTzxGkA18NZ?=
 =?us-ascii?Q?+trjhwRJilgjObpmEK5AagSQzLKYOCoiVd3iI4fXU4mGYoL/qBeWI6l6oq+6?=
 =?us-ascii?Q?P3bj4Kn4XWAIvPDRm+Z1tT/2t6RKphgl8pwutHLlTSjIaTy/ptRLXMbqqDc1?=
 =?us-ascii?Q?KFlUQIqmiCpkSuu66QVWxAaWvREf3/DSCOMUQKGDNgvs8JcTmEURex+GNlQd?=
 =?us-ascii?Q?5HJbZEFVmSsu9tPQO396VQ9qZ4vXKem9iytnsXiyJATw11XFOQ7I9QuQUike?=
 =?us-ascii?Q?hZB7oQAhD6h1WgE3Shx3PXr3QVbVsF0+DabgNIPwUZ6fbSZ509qKUQtXYWzw?=
 =?us-ascii?Q?oMXg4LfS+GuT1ZcGIszCted/c07hHiuPjs4VoGd12neqg1XNTcvZqKbT1RTy?=
 =?us-ascii?Q?eKWu51Xqa0t++knG+plPOPvvdxed9dXp0V+MR1R03TZaGleU/xUsI98Kdasc?=
 =?us-ascii?Q?kar7iZMacbxk6T/eUvBqPcGlnPWxz+QUVcgkJNVvwNJ+hK4ziVGA0Ui3y2P9?=
 =?us-ascii?Q?ltL+Vf/oNo3PkSej4ZsTbe+7Mh8oiEIV0QDdrbHHeui6psxwMzrTc02TEV9o?=
 =?us-ascii?Q?2+ovmGjI2hUK0VwJbAikx7TRefWeHy5CKKn+/UHG+PCpgZMWyW0aTNhQcwF2?=
 =?us-ascii?Q?7qbx2H5mRAMFFQaZjrOGrNvE2C1FKw1MO6Zl+gmJtJ9mlGJPoLVdiJvF5d+g?=
 =?us-ascii?Q?aPqOJcWpBO5REwX+MTNrFkD8Kq5EpzgEAkijiFaiS8hKEj1iqPDwLUWKKEMj?=
 =?us-ascii?Q?UF0eZVFSKhm+XUyTJ5xxLe5JNtLTE4HlTmSapk8A4vQ0FuNTPzossMYEyYMY?=
 =?us-ascii?Q?nRUafAAMpcPKq6X0TmB5HmNjweYEFt/OJYD0lVkrNkSmEDWiLq1R/E16fcYD?=
 =?us-ascii?Q?PRnnU/QuReQHmQAyVde9RvRlkoHGHzxRWWyFyi+Q9aZzYAXh5Bmc+EbVyEHM?=
 =?us-ascii?Q?A5dRfcEgP+fkV8Euz06xxzOvB98DIWFjEd/iBPTBEVTUssvfnZxPBlGiG1Nv?=
 =?us-ascii?Q?JhoHDafcn8AW+yEL3LBzAuhtRLacUZ31gQZ7aqS5ITeIApTt5PHvXBBnUJTD?=
 =?us-ascii?Q?3kA0Om7CAGBEMU75wFUu0YUcWEQqbDAcAd0yVcZeQvUTVhiN+Ko54s3h4LoA?=
 =?us-ascii?Q?jECHmRnxXQ337RGjoH8u4dGxNMZklHTtL5JoKUVBdbLRAAfYUdKsr+Wb3U90?=
 =?us-ascii?Q?bWfxmnSpIzXq3limUfsQucwQA4NF/hPFeaX6F/mAHvGLIbkn/OT1k3JhFqbG?=
 =?us-ascii?Q?mTcx9IJeY4zhoEwDZ2zuOu2EzE5sOv9C06clgqTH4iOcr6SuzH8BKd2Kw+6e?=
 =?us-ascii?Q?RjD6K6WNAm6avAg0ree7vd0QQp3YMEbVZnPyrNFJXzDTfmtxGgtmCHyaiMkr?=
 =?us-ascii?Q?M+SNj+U9Yp+HnMDLiIfN7sI4I+zuOCCYFd90BBxkyRziXD4AoE1ni2+YKBU4?=
 =?us-ascii?Q?fYqgkuHunyF1K2qhW82mSi2AUjq98lmJDsIcLCk1N2wXZAfw5bWCqDH7TDLG?=
 =?us-ascii?Q?WTeaoF4P9d7cbNVIwBYNhjPPRnHIxVETGaNuqdrkeBLi1aBzoy46nyMdIh6Z?=
 =?us-ascii?Q?ju+cwybk0vRq9bzi8aGFeJUt6g2gxARLPUhNSim29eG/Ap6USx5gJZmyRory?=
 =?us-ascii?Q?D/nJnIlfQVSMMrBdJrUxHJPk5zOauFjiCE0lYNYFpF/Pr2cTPI0oUQaXrK3d?=
 =?us-ascii?Q?wfOSNQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 776f6559-2365-467a-0f69-08db61e7e801
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:01:26.3774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QKciESiO9EVshNaZxrh6H2XDDa1d94RsHth6fX7hmKHs/uGzrn6+Ps1HL/oXtidgWPB4xDm5opXz9Qh3cJWEsxivRPyuqJwJnesG9vi1U7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR02MB8922
X-Proofpoint-GUID: 3OB1zH215kTkNMh7nQfkuX21_1Z70DXi
X-Proofpoint-ORIG-GUID: 3OB1zH215kTkNMh7nQfkuX21_1Z70DXi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_10,2023-05-31_03,2023-05-22_02
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

Remove barrier_nospec(), which translates to LFENCE, in
vmx_spec_ctrl_restore_host() as RSB-barriers (as defined by [1])
already exist prior to this point.

This LFENCE was added on commit fc02735b14ff ("KVM: VMX: Prevent guest
RSB poisoning attacks with eIBRS") in the 5.19 timeframe; however,
commit 2b1299322016 ("x86/speculation: Add RSB VM Exit protections") in
6.0 timeframe added a LFENCE for X86_FEATURE_RSB_VMEXIT_LITE was added
directly in vmx_vmexit, prior to CALL vmx_spec_ctrl_restore_host.

For posterity, vmx_spec_ctrl_restore_host also will execute WRMSR to
IA32_SPEC_CTRL for X86_FEATURE_KERNEL_IBRS or when guest/host MSR value
does not match, which serves as an additional RSB-barrier.

[1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/post-barrier-return-stack-buffer-predictions.html

Fixes: fc02735b14ff ("KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS")
Fixes: 2b1299322016 ("x86/speculation: Add RSB VM Exit protections")
Signed-off-by: Jon Kohler <jon@nutanix.com>
CC: Andrew Cooper <andrew.cooper3@citrix.com>
CC: Daniel Sneddon <daniel.sneddon@linux.intel.com>
CC: Josh Poimboeuf <jpoimboe@kernel.org>
CC: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kvm/vmx/vmx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..98ca8b79aab1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7130,8 +7130,6 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 	if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
 	    vmx->spec_ctrl != hostval)
 		native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
-
-	barrier_nospec();
 }
 
 static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
-- 
2.30.1 (Apple Git-130)


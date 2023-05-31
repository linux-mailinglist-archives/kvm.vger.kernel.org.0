Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3247C7186E2
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 17:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbjEaP7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 11:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbjEaP7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 11:59:13 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E296C135;
        Wed, 31 May 2023 08:59:09 -0700 (PDT)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VCeXOq004220;
        Wed, 31 May 2023 08:58:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=TMxfvKUypsKjFIi4c2h34TNGrmVxb0BcniC8uMPCEII=;
 b=sj7xbyRlg1sCeiNH9Iauvx/nXzFg4ptbmuH8TvcN6dJreyTleoA02oFJBKwWKPQbksjW
 0+1seUQRURRqnn0ibBrFtQuEK/oddVyF5BvDHs+NWIBVUpgphPqXKtJrAr/sxOSwcRE5
 mi838lkR/AAIjxbFWIOn8reFDqlG9iiOlXRtVJUijG2wXsoSNgHt9yKZLRBD00+1+RB9
 QWwG8xwCd/BrpuU2ViJF4tGb6bUVxxX0bk75sBpqD3hRGb/ek4znfPuAMslpXfpDQmsq
 Vm+mo6qLvQMbxkZ+dRUdLUf9rP5rtfRTp6YfQAYpriWti0CP4it/CIOaWCTG1qGw8fcs CA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3quhdvfwm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 08:58:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hY057nDGPERVFcKkv2bZJHAEMwTvEeQmxl6PMkUD7ES6bEW6b27u4dSANpILerF2kNDwZarRyF77pnO1boDRUF/RMW+fo/3Brgdak0CTZrv6pYvpLFXMg6cI3aqJxB4/r1b7bayTktSgUKs+/oAnlqL9xz1l21XJQCKRIibpw0KIs2oCmHPj3tKhBRrxmX9+IE+Bj5DKnbq3z79deqjgOMQe6yrrJyAFq2qUwBk3slKo561gKGU4UpuH+01LlOnTTTPlWRDxD+10D0jUEJVwQ/v6JAMtJRv5ELIT4VMlbpJYOO1P0Vla1TZNAz0m9jV7PN7ZUbwpSKSW22MiunRooQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMxfvKUypsKjFIi4c2h34TNGrmVxb0BcniC8uMPCEII=;
 b=GfckCOXg8g0PE3D9PAmxKYOUPqvmiRg2jMj7SjR7X8KhW86j+GpRaYaUMNLo1oFdnveZM8lcbuRSXdzmojhZZiqYo9gOeA3Kgm/kKSfhvTLmoMB/xx2k5rWcyWXNA49DrKghwxO3iE3her+s2h6CmvfcepCGNek1ayhvRAj2SMSOrvAoYvAQ+mNjn35/unqTgxtEaUPfcsorP7Wfy+qorOfJehEV1Zxp/8kHwsXfZaCupIkvkE2Ds1SXT0Sm1cCUvnEQ1vvfeWMbmopXtAyCFyM8bq3gNV9y6Tao0c5wlusJpc/LSdU6bT3uVDwy+F67qpJ8JdtyBmAEZxpczE9WHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMxfvKUypsKjFIi4c2h34TNGrmVxb0BcniC8uMPCEII=;
 b=T19SO5yUu/Yuta1J0aqcDWPQNgyeVMLNkvAOqeAQoIW9UJdHQ4bhzskbkaLdNL7mcyOZYG45qtYk83WBvp87hPLY0tpjt8YpxZr7NiTYdWPJzRXme0pt5bDMz+e2JtbzBz5I888dLQRKJQ+YwQ1aFsPjB7PwCnT6eSyo5xMm1KqP4VYbQNaKx8U05NVAGAg1q08nTKgdrvDozADzXLNbv/v+uxEnIqgl9takvlBZ8AvdfaozxnnP1MDf8x4wcjud9eOSsICpOPzK5D9+rvfQfuc5t721Qnveifk3tSY1RlrMx13+6++IiidF+HDbo11RtqSKHcJtt1ZMg8BupHw7GA==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by DS7PR02MB9604.namprd02.prod.outlook.com (2603:10b6:8:ee::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 15:58:36 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:58:36 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jon Kohler <jon@nutanix.com>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] KVM: VMX: restore vmx_vmexit alignment
Date:   Wed, 31 May 2023 11:58:21 -0400
Message-Id: <20230531155821.80590-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0026.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::39) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR02MB4579:EE_|DS7PR02MB9604:EE_
X-MS-Office365-Filtering-Correlation-Id: 55e26a83-0ba6-4bbc-3530-08db61efe48f
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eIVkYu147QnbA7NZkFtnAx9C0eSZ9hEyfTAY4g6T5DAiUYJhKxOvxLGuN3gOKqPvh+43bCp0BioL/qycP2qRE9IFd45bHQIANdX0jyjufWHOsdTPQbrLiFvjyAqLyfNNKihpMNfWbArlWZ0rHOlTDaSQr0Jq0bvCDdLCzeSeLeYtMhoGYbF1UY/TzvkH5MmtclaxGPxYEfslgChLqNpMbh8H18Xy1luBhhWIk7vVmqXdsYHmd8t+HNYaONeHnIEVKrgwplz+hgrMIjPu8CBQBySIs5W4gqHJACm03hE4xdOX7XA/g/cDNsiKIPW8KUhIMxG/+IYgPfJJ6laA1royPI6ehZxk3k2hQfn51zIgXaKSAAcd4BcZ2lKQ9aKKLRwtcA+cNfivACS0rUWNX/HVdpbxFUG/3TSOjlERuWmCgvgwjlLFcaes6JcVwvv+DGHp/rGJy/MFAOXkVb2aXEVwsarVWnZaBB01XD7/ifqzPi3vvGZJMeVyEVh0rwYyLVJfsya9WMUJOQkhOw5ERyrfRpud2BZvPI1377XV7xV1X13imL1XYmOgPoveGYHlVCkneRCD5xTGTTd7VofdwujSuQrntwHxcirTLcdjbozSL/1LkmuPjp/4p0i+3Ss7J/8a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(136003)(39860400002)(346002)(451199021)(52116002)(6486002)(5660300002)(921005)(1076003)(6512007)(6506007)(186003)(36756003)(316002)(66476007)(4326008)(66556008)(2616005)(478600001)(86362001)(41300700001)(83380400001)(54906003)(110136005)(38100700002)(66946007)(6666004)(8676002)(8936002)(2906002)(966005)(7416002)(46800400005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ee//AWFthtxHp1hyP3v5FbAl6uDV6u8g3JoqqivV51C04a04XQq/Pt+zErpM?=
 =?us-ascii?Q?cLzpNPF86KwsDBI4qAip1gXwxWAAhz6UwQijDgKNRQAnVLQoYQs3Br0otVmj?=
 =?us-ascii?Q?hjptq1IaKV/EAHwwAR0TrUpMnLLAunTfAbW6lW4zu0vPvlCcit5tP8so9QFh?=
 =?us-ascii?Q?onKNAL4cjurbjxDDNn5ql2UPDchKr/2b6/W+qVIvgOgafBmJ6uoU3r/FQ+Cb?=
 =?us-ascii?Q?rEmyPRtSLnSDJ+3PopAA588dL9pydSrWGFSgQyHp3g539Gh1RhwVZtQAnx72?=
 =?us-ascii?Q?1UCRHFnPdoJES0i4GNYZBz4M6PX+Go0xBc7nmnGcOjDnpK/5PSYTvjdYbnUf?=
 =?us-ascii?Q?eB+OHOvUFJg2IQhWWOszZdh2KCl08pTbwhX+mrAnkZp+SALUDlxMJ75I5sit?=
 =?us-ascii?Q?XfcAvNo3D9OTGLgyff1YiWoCtjf1VrYrSC9OH+uCYtNMy0tAFJYArWRdzgbR?=
 =?us-ascii?Q?taspRKNf6bjPjgf41ZBZrA7O+A2g+HmV3WGR3X0slF+bTnl7wYYBmUSOjd/n?=
 =?us-ascii?Q?o/dTAYLLRvLubY+p7i/vL98MDC8c/+lBJuTBD0GroF1CIjQptO1/R+T5i/9I?=
 =?us-ascii?Q?bkdBmmGv2JvpglfbgnMOBTv2JLB/PrIgJbFEgV8f76q50M3VRaX5IHgohlIh?=
 =?us-ascii?Q?RLMBuGtoQWmeOYZ4FY/rnOwerwUApcGsTayR7LkHFDlsdd4iogHBW8Tm+R6S?=
 =?us-ascii?Q?mQOLxBQhhQDgY6nO4Juyzx3v6ROfRknStchlS8xxQjubmHFBlKJcY1dmtAMz?=
 =?us-ascii?Q?FnbTnGmcnfwe1dHo55Apy6DFLVh1haCQAwzHklkOknLY3h8mpGJKf06klNfo?=
 =?us-ascii?Q?RNG5RPdjF8IpsIvkwzeO39Cc6fw008lIltWR1DdM3uMashR9ygfgBgmyJhxT?=
 =?us-ascii?Q?vOfHwatLmv58ihwEPlU71fmogyLAyDQ0Q/kOj30p5u0h/I5Ej9OUfABZGZmV?=
 =?us-ascii?Q?JmPH2IlvUNrhqpyprwiMk4LTiJxLg9E2YyITG+3892HEJXn4ahu0nAuh9mpV?=
 =?us-ascii?Q?AHSD98xfwI9AxbDkDtsL+R6gyxud/fHa8GpbxGwVjRqnqXTNX9Ss92meWSYb?=
 =?us-ascii?Q?3rHIMkK4hjRRkKt8KoLdXyVCy3rWJ5Mav4jeR5VZlpQCud1tOakey4+HxoaQ?=
 =?us-ascii?Q?YnIJbYnsjdzquGxsITGfFqFNohfYcMYfwVltpTdercKVllqLCuOWIXddMRgS?=
 =?us-ascii?Q?zCCYRWJHfDVM9TIOHXsLGV/471zh5QkXtSRm8MkGprOMRIIuS6DwN/oAK7F8?=
 =?us-ascii?Q?Tuii9zsa1IdPTDBn/qPysSUdHxYyP0dNdCxz2I09bNYeY/K32jbQyJPzWtAK?=
 =?us-ascii?Q?7IB2gWwcohcn/zZSt/7Znq+WI0KL5c1j3qrSSAzLDf9wHkOyGv0S2zBGGrRF?=
 =?us-ascii?Q?rcOTpYa3D4EtXVhG/400U37nLnqzZ2oRXg46DKB1WF3g0KpfGjaglXhKsfyP?=
 =?us-ascii?Q?30PpkM83k1vV1vnOT2pC0KD2GlV6N15+FCBHH/yYt9/7/B/RX5NH4yB1IiRK?=
 =?us-ascii?Q?looSzWaPMJLgjk+X8O6KsKsUNjxkiwX8Jm9/1nzsFufer49nqL0Gw477h2HH?=
 =?us-ascii?Q?Ptwf5WPrlWcBTz9rE7Ieh5dECMVWCZOGgvaFw7AueA7iEbNQyD0+snF355m8?=
 =?us-ascii?Q?Ca8j2AeW8YWC3vED1rJXVxyaiYK1BTmi/lqhVXw4xEXOohdIluSCRPbdtxzV?=
 =?us-ascii?Q?vVBsQA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55e26a83-0ba6-4bbc-3530-08db61efe48f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:58:36.4959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BtrbYWwgx+vlRtGsPZNpDM1qKjEUPOj82HlSnj5UUTpwa6SaSqQO1UgdId9mUdNXO4jsF+6nJkKPMOzCRUSL3Gs2d7WTfWpf9b9FyURk1SI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR02MB9604
X-Proofpoint-ORIG-GUID: _I3WxyMWGx9FHhz2iGg3inofqaZBb8fq
X-Proofpoint-GUID: _I3WxyMWGx9FHhz2iGg3inofqaZBb8fq
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

Commit 8bd200d23ec4 ("KVM: VMX: Flatten __vmx_vcpu_run()") changed
vmx_vmexit from SYM_FUNC_START to SYM_INNER_LABEL, accidentally
removing 16 byte alignment as SYM_FUNC_START uses SYM_A_ALIGN and
SYM_INNER_LABEL does not. Josh mentioned [1] this was unintentional.

Fix by changing to SYM_INNER_LABEL_ALIGN instead.

[1] https://lore.kernel.org/lkml/Y3adkSe%2FJ70PqUyt@p183

Fixes: 8bd200d23ec4 ("KVM: VMX: Flatten __vmx_vcpu_run()")
Signed-off-by: Jon Kohler <jon@nutanix.com>
Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
CC: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kvm/vmx/vmenter.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 631fd7da2bc3..07e927d4d099 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -187,7 +187,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	_ASM_EXTABLE(.Lvmresume, .Lfixup)
 	_ASM_EXTABLE(.Lvmlaunch, .Lfixup)
 
-SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
+SYM_INNER_LABEL_ALIGN(vmx_vmexit, SYM_L_GLOBAL)
 
 	/* Restore unwind state from before the VMRESUME/VMLAUNCH. */
 	UNWIND_HINT_RESTORE
-- 
2.30.1 (Apple Git-130)


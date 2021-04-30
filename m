Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5285A36FAA4
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbhD3Ml4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:41:56 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:56928
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232745AbhD3Mk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:40:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1tm2DEVFM3i59aYn6tuk7lzXF5stJ2ZbDQKiDR3ZvVgfV/nb4v2pFHJJntdt0SKmb1N6xkxj7Mo+m6/HOfTCFWRCgpyX0oz2sMNiOjUZ5TvBFGO5yBCBZy6ha5IOpIS99aKwCcYombmE0C30SuMPYgDOHqZ7w06FU3ssuZNYehIVoeBucwFLhCHGWzKCodJA+icXmNUpTuTBy7f3v4lW+5pDX+d5g3GkAOJFbn0SAX6RivDKFyqB3I6BnqbN7lwsQMEHgShR1L+OZVQcsUGtVBJrq5sGaxkR0vfuaICeyAsQKJc/axyvC89tY0Hc1L50tVCpnmXgSzOmarfiIbmsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjQAgRyMgOw+mtC7y0kLgIdnWcgpPFw68Dvc4o0vM80=;
 b=Vr7DluXn+7TsfGy3XEGwVRc1r/SNGoTITG8ErGI6CNtG70rNU8CuwTrgsL9k6h1BX8GIeLP0yUZzbeRRJ50+TjLRKJw52OlyM31v8TVO3ouAjogJ3YfSpWvPom0j56UrWQmUAeGeKXCo3IyRBLAky0BQP3SacSat/TwTsFT5+LnocCCg4OQ1gBkpwAvH3H8RArM99NCHI3Kgsfb7j07fgr0t/RQkkT7UZnuokJ2FVRoJL+ZH0TOV/7nWMK7gLWnQD9TjmJ/A676ThtrxKipItzK46WrWGsTusuEfXS/+RPsW3DZDOaS2GqmMU/oS0PPiI2GSUXSL1PBBjX/yXeC/7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjQAgRyMgOw+mtC7y0kLgIdnWcgpPFw68Dvc4o0vM80=;
 b=O3avIEfysiIdc0XR5eh6Yf+hPz/Ye71gFH5oXWiUFjqO732+F3rkBg56M+ajr6vV7eEtfQH9Z5zQcp8W/oJK6SzVgVPTpjbnynfBHebhCK7imoUl173nzLPuvcV8ScodfN1grZCRZgrVqQ1cioSk7S2r/dlV7sjwznvhE93cA7c=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Fri, 30 Apr
 2021 12:39:15 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:15 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 29/37] KVM: X86: Define new RMP check related #NPF error bits
Date:   Fri, 30 Apr 2021 07:38:14 -0500
Message-Id: <20210430123822.13825-30-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 094800a3-a37f-435d-b00b-08d90bd4f710
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB268830DCDC75D908C2ABA625E55E9@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KqGe/K5xAEDwk7I/vaKAk336tgtlXwb/adZpytTQZVB6u8D5K4HlPW2bZkX+LEMe8D5q+KSk+jPtbP1mYB8oCqDgoy2jnDmtJu3Sil3cSSbgutu3K0UMEFVcHSVObiEXk+YY69lqunK1ap8NOOJK4JdsYhQ3H4hC5vYvKPi1MWzYpYGAe65vj/ig4XgDohYkp+Qwb8e1rAsh5aO3klo85ewMFvFR0KpyC8FVFyZl7py9bprW7vSmcXCIIuiNdHZsH6u4+jlOrwqgniZEQrOSJw63Yhj5gu8jjqJG2YpJWI5Ku+6OleRlW593S4KKmbYXHeRJ/6dh19do8ZYNoUm8ultD1CW61kb7r29aKjDjXLzdbrwHqqw4Wj4q8+6i6KjxST7UXcpUaCWfbRIjEp9bjVpXcdlTxksXCOeetUDn16oMsyjOef7BR+agq879Q5M4/TDi3HEZLKKJ7FIJQFgLMxHwykeThhBKhq9n2Cp0ARsSwrIXbfsEwTsnxkYFEeSDHHLNfFcmHsC5u7nZ9ZDb+dTLsK4BPr+1mTMdXNH8BuIk85fX+j5+XF60JXc5Ta0/HeY5PPSERnLBY7iAhuuN5t6QYN+JaBxygAaoPK/49jLDuE2j7QSn8fBUtCpIwaWwW25v4SlFRql+awjKanyK+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(26005)(8936002)(86362001)(478600001)(52116002)(8676002)(1076003)(66946007)(66556008)(2906002)(7696005)(83380400001)(36756003)(66476007)(44832011)(5660300002)(956004)(38350700002)(38100700002)(7416002)(2616005)(16526019)(186003)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4PWhMzi6axe6AsOM7nhew6h0ff9VYPWKYz9h6JYTJRPEc47NXfZjUS52WfDk?=
 =?us-ascii?Q?gqSBgeFvuanamQjf7ihJ1LHaw1nTDIV2o2RmUV2hellUG86T5GJpT430lFEx?=
 =?us-ascii?Q?vzAJ72VSmboGXa2Q8syW8mpqwqZNLvZO8Dx/+hAzXybWdARzVqCzRi4PlTyC?=
 =?us-ascii?Q?Vw5Z9mn0cR8CJ4lcRT/vAzXC8MFP8Mo57434iQyWAqURBqQibf/cmT4hyHJt?=
 =?us-ascii?Q?B8uVeAW35Uda7D0th+Uha64rN3HYGy2CyZ0J5DhLRk+FCpDczXQxGCV9f6a+?=
 =?us-ascii?Q?ip7+MNxCIJPc2j0Bi/YcdeV6UkNxa2dE6IwECAaJHb9ARhxZyma3Mzh/7kDJ?=
 =?us-ascii?Q?80UGNB6sayiOjnkKwf3JJ7OKI10OUJ8s5PP6fu4jWN3JP7mxyMd3Wb6mnHlg?=
 =?us-ascii?Q?bAMtau73wI+0/uDOuZoRW2EBvdWX8HjNGNsoSkN2GFUntVAsOdFvTHmqJszZ?=
 =?us-ascii?Q?DghXe4Il5SPjerFnJeoPN62DsyCGo9Nwhlo+SlKuIKZiRMfUbVqvLKsGJCgO?=
 =?us-ascii?Q?JreAFO9i/d5MRhlMSlLwGUim99uB8ddexQKtZYQL6FFBhYGLl3EcDrTnqj/v?=
 =?us-ascii?Q?p3pQdN4fO2cZLrHCWfW9c/o+5VurkkvrEivG011XPHGDfuz8r01ad0BQ1z24?=
 =?us-ascii?Q?B0pg5iW8tONAoD1cWt4vhr8Bi+z9Kkqapt/W2mGyLHfHutoQZewxPX0l7kws?=
 =?us-ascii?Q?LSSdggkju2vBL8i6+I6YgZY2HWGjFjTMCzC8jK8GFAE0m2Uj9RHYUphfe7dv?=
 =?us-ascii?Q?igIjhnkvv/L8tueMHfXqriA8B1B14uqJxo9ObBNFhNZ3Z7QCfyFkxnO8i+of?=
 =?us-ascii?Q?pkN+b7tPryM07g43NIpxWQA4CGNTXH22qIxA5OMPLYmY1aTjKde/L21cDwiO?=
 =?us-ascii?Q?gp4sEWrffJnc5x031iB61OBkc9gaV8s+dYajt1ZVGf3xzcFszSPLLidIROeM?=
 =?us-ascii?Q?c74DDMoamNnyZul+LmIWyisf5snUMEg0pTNrgb8CDwMPobZQoND3AoclKnHF?=
 =?us-ascii?Q?SBZ02JSqf6nSGiX16j0glxXylMGRisTRsLDCXgopw6hfrkZJnXRi1EfqoLXz?=
 =?us-ascii?Q?LIaiucXxG5AAC8lvGezjMKtHyxZmB+o9Es/eDosdirL3TQsydFvKJePhVV+7?=
 =?us-ascii?Q?7CLsdfUjaFKYPisLYGH1/4Y2Bz96YWVhFeYg0ITj7F0gmf0twm2qYex33pRu?=
 =?us-ascii?Q?CkODZ0NxgAyOhUIa8HktQZRg1nnBtAwiD8LG+Dl2M4D/XfFK6I6IlOBfyP/v?=
 =?us-ascii?Q?1JxDwERPcu3ALWTdC/ppYBa2PRIZ/NxLkdXMM4zsEv0BCxLXuDBMytEQfYkS?=
 =?us-ascii?Q?VVCq9nfVf8fonOXITWolzYsm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 094800a3-a37f-435d-b00b-08d90bd4f710
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:15.7213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ApNh8wq+OHA08baAsjsQzrO3jx0XHnR4/iuYRJuyrZoP8aJV9LJJblEdbtSqUGMwUc41un/Jkmyx9IaVFiyfyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SEV-SNP is enabled globally, the hardware places restrictions on all
memory accesses based on the RMP entry, whether the hyperviso or a VM,
performs the accesses. When hardware encounters an RMP access violation
during a guest access, it will cause a #VMEXIT(NPF).

See APM2 section 16.36.10 for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88033147a6bf..ad01fe9f4c43 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -237,8 +237,12 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_BIT 4
 #define PFERR_PK_BIT 5
 #define PFERR_SGX_BIT 15
+#define PFERR_GUEST_RMP_BIT 31
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
+#define PFERR_GUEST_ENC_BIT 34
+#define PFERR_GUEST_SIZEM_BIT 35
+#define PFERR_GUEST_VMPL_BIT 36
 
 #define PFERR_PRESENT_MASK (1U << PFERR_PRESENT_BIT)
 #define PFERR_WRITE_MASK (1U << PFERR_WRITE_BIT)
@@ -249,6 +253,10 @@ enum x86_intercept_stage;
 #define PFERR_SGX_MASK (1U << PFERR_SGX_BIT)
 #define PFERR_GUEST_FINAL_MASK (1ULL << PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK (1ULL << PFERR_GUEST_PAGE_BIT)
+#define PFERR_GUEST_RMP_MASK (1ULL << PFERR_GUEST_RMP_BIT)
+#define PFERR_GUEST_ENC_MASK (1ULL << PFERR_GUEST_ENC_BIT)
+#define PFERR_GUEST_SIZEM_MASK (1ULL << PFERR_GUEST_SIZEM_BIT)
+#define PFERR_GUEST_VMPL_MASK (1ULL << PFERR_GUEST_VMPL_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
-- 
2.17.1


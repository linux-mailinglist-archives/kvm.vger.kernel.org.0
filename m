Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0CFB2FE33B
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 07:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbhAUG4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 01:56:23 -0500
Received: from mail-eopbgr760075.outbound.protection.outlook.com ([40.107.76.75]:35598
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725967AbhAUG4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 01:56:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJxWnr4i9d4oGq4ekD41KdTaeilkgkRn8+YAWkqrKOjA28CSGSa6UTIPLe7J5TvPjq1se867XwH3iT9eEAaILjKiUZJJTzIYLdgkhLfN9k5yn8G8Xs0R14l9KPl+i6oLcywdjm6FYFgFv2GcSSln+verhGom1iQBGOdG6YHnM6k91ReLv2rfMYdJAOcpbFkKcGPEOdZLkLiujQ7FtGFJ7o29rKoBGW4NokBZVXoVrmoZFkQhEihg6E7SNEfgJBXkdUxtyY+hR3VDh5j489fG8GTfkOxKZOw5gaW7bpsnTDiD9vnwwFsRYmTurcanXku0MeuJRRDPSu1voHLvGQ/d2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3w9P9wtnZrH5H5qTUACuyi+s+gu/4vNOIShL5/IiVTE=;
 b=mJZTfrvszw6Y5NMgD7J/QA3uxex5aw+SBnPL93PNWFBAJaoYl6kLWzWB92RffUxnI5hZoTuTzNh/4ukqJ98HXN2zPaC2dMAI5lcLn4zn54gOhbgtC4Zw58ueexW3WVeJCNxHGyk+KQgCPc/i+AbxDx//RZ0nhKZ8QHQUG9EajIhleZAx5FPNyG+9nTgO2eMYKywJEnoJ0yUGLCfaLcHe9SQ0fgsVzUStWUc1sR8BHgKLuDS9gVSjddEgpEv3SAWXKhlAnZ7zaLKZG7XvLM5z5Vcjmwoys6b5y/ESQ80tCRawsEMRAx4uQT9U/nRKlt7EPZjxLazKGcOA4q1vTkkgpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3w9P9wtnZrH5H5qTUACuyi+s+gu/4vNOIShL5/IiVTE=;
 b=myUjXX/geOyATFMIOAAaxZJ44S6Tudg8JQfaJp+fG2AnA3vZOV+EuGzYaDaRsEmNfVZurGfjxysnzxliBHL58QdZvnbCQOeHBryjQdqhlX0AoUpujeXKaRxLeENtQwPYsR+GZO/+V+d6btkLYwcVRzHRqBwln+9UVTMfKZlIVK0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20)
 by MW3PR12MB4441.namprd12.prod.outlook.com (2603:10b6:303:59::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 21 Jan
 2021 06:55:34 +0000
Received: from MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::d06d:c93c:539d:5460]) by MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::d06d:c93c:539d:5460%10]) with mapi id 15.20.3784.013; Thu, 21 Jan
 2021 06:55:34 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, jmattson@google.com,
        wanpengli@tencent.com, bsd@redhat.com, dgilbert@redhat.com,
        luto@amacapital.net, wei.huang2@amd.com
Subject: [PATCH v2 0/4] Handle #GP for SVM execution instructions
Date:   Thu, 21 Jan 2021 01:55:04 -0500
Message-Id: <20210121065508.1169585-1-wei.huang2@amd.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [66.187.233.206]
X-ClientProxiedBy: SG2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:3:17::34) To MWHPR12MB1502.namprd12.prod.outlook.com
 (2603:10b6:301:10::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from amd-daytona-06.khw1.lab.eng.bos.redhat.com (66.187.233.206) by SG2PR02CA0022.apcprd02.prod.outlook.com (2603:1096:3:17::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 06:55:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d7fe1543-0a81-4cd8-83ab-08d8bdd98c82
X-MS-TrafficTypeDiagnostic: MW3PR12MB4441:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR12MB44418465380901FF6394DFF9CFA19@MW3PR12MB4441.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6tk+wu/XDb4G8t1pbaJ8kJp55cdr1AlBSmiYrqwOW5Bs0hhh+uV8furbG21l0Y27l8zP1LgcW9TSkw2nUm7jv9pdQ/t72IIJZ63AkuuNw4bt/zId+/SM7TOKb9lGPHwjp6Uhwvm9ubEuKYUVpqRbawsjtXgJNRig++Ynf1w02JrxRi0J5HP5jS+S0ApPdmxDE3M9+f2sRVjOCuRf3p7m2gMYDDdihlUsbL5mKvjmMvBdi8ZJ9yBxmO0dlgRecaTw3dIgpCWrrq6v7iT2WyYRKf9v2uclkPpE7KWGU95j8h/u35GwWsSPMwrVdSlDrpCow9nNSr18okBFXfxw9CQDoT2Rsu8gJEq+NQuKXU7FaBrORUfzMj3WKHIkrbxZMm3Drf9YIWFvN5TXpjsQkls5SA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1502.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(52116002)(8936002)(86362001)(6506007)(66476007)(6512007)(6916009)(2906002)(186003)(498600001)(4326008)(6486002)(16526019)(956004)(26005)(2616005)(36756003)(8676002)(1076003)(6666004)(7416002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?awcnsFrCi7DSM8htXUyjh3YNVr8TdEjwDCBFN5wXes/XEpt5wKKmvgpI0o9t?=
 =?us-ascii?Q?9KMGAJWaJU3ZSxl4t/JD+k57Io6OVIcD5AC5cN0VMGy1kB+7NMnKAnmdomk8?=
 =?us-ascii?Q?wbCW1GHNhH4b7RSKiyFq/d1Su3C05yuiJoJu/MtRq+RwFZi5grHrg89PC3BI?=
 =?us-ascii?Q?UMT/cXo/ZT5EmGs9Px1RCPKIK5zCzg3wc93Ae//4wT6G9hQu2TeNWb9YvUPn?=
 =?us-ascii?Q?UJd8PH0fjtDLqTkqDTpNosCTe0xSSTAj9CSF9ojAZAHe08eLSQP15XdtxJWT?=
 =?us-ascii?Q?YkOKJSTre5wBaOkryb12+JCK3/yrBoHJfB461vmtvAcOac0wW5lBFs1FV3KB?=
 =?us-ascii?Q?TnInTxyty26XDPSxITGiNhxIbWyUQfbsZF/ig0bybrCizUtPZjftb1AVl3YZ?=
 =?us-ascii?Q?HbWIx3NQI6IwS1OjiQmOedxV8gcI3Y9E39yLh/iWnTG7f271X/pK/O0I7mw+?=
 =?us-ascii?Q?sHCsDoDkSavjbCQ7fY9BezLOoUNdlU1GNcerjIk+1hHSU4XHJ0N8rWO9QM/d?=
 =?us-ascii?Q?0+9LGpcUcLdPXf1U09ApB+fZGnFnZ8+z53JsykM53wXbH7tuotVNPw97XjGV?=
 =?us-ascii?Q?kZpQ6e2Lu4NCXcxzo+P0gnQe87IVmy3zkIz1BbbRnBPMWQvMM3c0gTEf3lhj?=
 =?us-ascii?Q?8pkd1jcbE2T1ggua5HlxZ3MzMaKwEQEA83IN3mh06YuWwwvc4snG+xDJIPld?=
 =?us-ascii?Q?dpTlVUWnKwyqbRPUqNCcwz7bB0qxpFkFc+AGUrHpcjkzq5jI2md+F9xCTfpJ?=
 =?us-ascii?Q?pnY5HlUDO0EauF0a+ROeno5LpNdv50sXBc90pLLwAR6nflvRfQn9xg/Ha2iW?=
 =?us-ascii?Q?OO1o0hipuvjsCaHZG1DxPWYM4yLlaJTL+F82uwsVnaa2t0Yuv/8klDBzzKhY?=
 =?us-ascii?Q?NiFRzZOMJ297riiBDfKs/Y6BUMNX67tAXctOmbx0MXp0qEHWm7CIediLoCKJ?=
 =?us-ascii?Q?N+p2gHWQ2KjhhhcIlnBHHWqmEw3oY+OQv8reDrVKMim9KAuoh0+0ulQm1Hv+?=
 =?us-ascii?Q?1hqX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7fe1543-0a81-4cd8-83ab-08d8bdd98c82
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1502.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 06:55:33.9560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NzrthFgy8HV8wzoD+FXQfzDndE+PxMcPdeIK+b4HuVV/afFa1FRPVYEsyNSaEPWp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4441
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While running SVM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
before checking VMCB's instruction intercept. If EAX falls into such
memory areas, #GP is triggered before #VMEXIT. This causes unexpected #GP
under nested virtualization. To solve this problem, this patchset makes
KVM trap #GP and emulate these SVM instuctions accordingly.

Also newer AMD CPUs will change this behavior by triggering #VMEXIT
before #GP. This change is indicated by CPUID_0x8000000A_EDX[28]. Under
this circumstance, #GP interception is not required. This patchset supports
the new feature.

This patchset has been verified with vmrun_errata_test and vmware_backdoors
tests of kvm_unit_test on the following configs:
  * Current CPU: nested, nested on nested
  * New CPU with X86_FEATURE_SVME_ADDR_CHK: nested, nested on nested

v1->v2:
  * Factor out instruction decode for sharing
  * Re-org gp_interception() handling for both #GP and vmware_backdoor
  * Use kvm_cpu_cap for X86_FEATURE_SVME_ADDR_CHK feature support
  * Add nested on nested support

Thanks,
-Wei

Wei Huang (4):
  KVM: x86: Factor out x86 instruction emulation with decoding
  KVM: SVM: Add emulation support for #GP triggered by SVM instructions
  KVM: SVM: Add support for VMCB address check change
  KVM: SVM: Support #GP handling for the case of nested on nested

 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/kvm/svm/svm.c             | 120 ++++++++++++++++++++++++-----
 arch/x86/kvm/x86.c                 |  63 +++++++++------
 arch/x86/kvm/x86.h                 |   2 +
 4 files changed, 145 insertions(+), 41 deletions(-)

-- 
2.27.0


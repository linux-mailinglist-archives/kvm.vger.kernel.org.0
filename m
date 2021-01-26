Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889F63037CE
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 09:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389908AbhAZIYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 03:24:01 -0500
Received: from mail-bn8nam11on2058.outbound.protection.outlook.com ([40.107.236.58]:20448
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389832AbhAZIVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 03:21:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABediNFkobGMG05Mn5lPt49uOlW5V2/KRukDA+++PWqvT4Dq9MGnM4lkTOVyR1Da1gkamgdnNYsSWnN30BrKGapswKNHRh7O8nlaiN+wnxyuUEIe/NabzxBf+CvCWBf/aiGCQB8nQrNrH7isa/xvV/Hf+3aaSS3MIiD+hd4kZLNUp37SDdZmS6CmNZJNUOtUvgy5Zq2e1kg7ImaL+DwyPs0m5M9lBQJT3+bQawaVIIqnVCQRkk0VhUGxDFUXyqmEEv1t11UNuROdkMa6koEk3FEAvB8cJQIjVxo/ZJ+UTaKTcpJhGV9kDYX3Fqf2ItCvSi9IGUVbXplq+hOduk6ylA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bv67/yfTw2Ixk6BCV4HFulzmxhv1b8TWBI1koiSFFhc=;
 b=OqaRqavqaFyCpazSjBpIxON0FcgYBJD2OAWEFXM77spftBUom4+1OGDFh2K6DIgOKn1OwNxDuC5VbXnHz9ea02AA9z6ItzX+vpR4ChJ1y9i/PReoYHYHZp4rg9YblD/zs+PF4nwUaYo3LJQlLBk5fxNPh73CdOwdo1bMgXGM42rH3N/2fTQv2KPHKgv1tO/9Nbdiv4jJ4BniRquAv6zPyISv83k8mBO0plj0A5dRw6/ZUkptJZGt/nY+bp0ux1tXAzuMLDphRGeImiyA/90oPmjcpglh4pBEC6w8mPsOrQGDybVW3t8OVmwd92ze4wLcBDKuLdcBYTsHIiyjto/6UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bv67/yfTw2Ixk6BCV4HFulzmxhv1b8TWBI1koiSFFhc=;
 b=hDWTdD3NGCvZToAaxRzkJ3cSrfsRScRuI0jBvEOz8KHkoD4IoArWlyUkxvSAB6JYuWjSQIBFkX4PrJJeQKHkwALQQefd8zpqlAahsNdFX5eqI8cJOofmZZOGQoyHUsOJB6XMPecQeXRtsq+8hVQyqJ1jEB6OrQ0auV9rP+tr/hs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
 by CY4PR1201MB0214.namprd12.prod.outlook.com (2603:10b6:910:25::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 26 Jan
 2021 08:19:47 +0000
Received: from CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819]) by CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819%11]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 08:19:47 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, jmattson@google.com,
        wanpengli@tencent.com, bsd@redhat.com, dgilbert@redhat.com,
        luto@amacapital.net, wei.huang2@amd.com
Subject: [PATCH v3 3/4] KVM: SVM: Add support for SVM instruction address check change
Date:   Tue, 26 Jan 2021 03:18:30 -0500
Message-Id: <20210126081831.570253-4-wei.huang2@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210126081831.570253-1-wei.huang2@amd.com>
References: <20210126081831.570253-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [66.187.233.206]
X-ClientProxiedBy: AM0PR10CA0054.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::34) To CY4PR12MB1494.namprd12.prod.outlook.com
 (2603:10b6:910:f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from amd-daytona-06.khw1.lab.eng.bos.redhat.com (66.187.233.206) by AM0PR10CA0054.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Tue, 26 Jan 2021 08:19:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d45d31f2-c3b2-4189-7e5f-08d8c1d324c4
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0214:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB02143C8782E5EE712393C5B7CFBC0@CY4PR1201MB0214.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MIdqLZikKyXX+cr6Y7nYA5JPdq4ItNIJJk7yw23sRDA3efg8wcsnFCc9jMJaFu/BGpkui7gR3fOhB2Nc4kl/pFGfZku115FX1urq0ad5E17LtuWCmUmjKdgzKqfm7nCfbtvV77T/nUTIy0ECVif9geTVLxIfmvTut2tCr6B+htVyFwJzPpEB2vfBU4I6KmoO7OBIcX/gUs/UKRnNVH1NKxskOQK998nXx0ruXmlENMmltZewlDCL8WjrxjdZJetxgDj4IWJg9lBygPbFsBNqJVmeAhmvivLXHuQ3tvPdWHRI3ar6Pfch4cG+/iFL2oxcz/zzDr/CDDYS4auSIeu0WClH5IJA6wWtq+cArEorkJC9miOlExC1WWp23d0axLgeviPwF+tHhx98BAOclEf3sA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1494.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(36756003)(66556008)(6486002)(8676002)(66476007)(66946007)(52116002)(86362001)(5660300002)(6512007)(2906002)(956004)(186003)(26005)(16526019)(478600001)(6666004)(8936002)(4326008)(6916009)(316002)(6506007)(7416002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2PH2Gz/PVk5+EFJEez464usCaaSUrO8VsWNCPdDDq6lQ9/VQrYBlYBBGsfmJ?=
 =?us-ascii?Q?q3SdFDhTIBs7UJrNygiArr07U8yq65nELoSZxHU1DgHNKwM3sDXcP26R6Hx6?=
 =?us-ascii?Q?mMGhfuzzrSBxfm7znEER0O+SBxFl6QbqjKUcJPuM3Ymcisj/2O1vkfEJ2RLd?=
 =?us-ascii?Q?r6VYmw4VGWldP36TPHnN5futIL0VqyNFnuWCT5zjgzZTaFCahxAhd5AFiyTw?=
 =?us-ascii?Q?figHE77yU+EOrYmUbWg71wCdOHwXIyAvSt5MhOM3oEabmR/1xsphLYBFHmZm?=
 =?us-ascii?Q?fXRjNwDFegJkH7D+c6PKOYojX7ujx4i/H+iVZ1XVGdolzSJE1bCt0ZLqVY6X?=
 =?us-ascii?Q?DR38tDi8kIQvHwjofkpB8rTwPRoVCvT0fkYUoxL9wd+FKrfTYgSEfzj7w1D6?=
 =?us-ascii?Q?nSSKlpmBG8VDjZG/AeyFzdsDh130YfNoFuzHHSTB01hyl7Pnl4a5/OFlFcOd?=
 =?us-ascii?Q?fsO4tzZIVqkNwctwd2zaTbdyXs3VWR1Bo+WFQQ0hQmwtYmKKSoGEWl2X0WU4?=
 =?us-ascii?Q?KUxF5dNVK2NiL0Bf4jLC2E2+rqU8E3zed6ivGW17ShffvJrLX16O1DqvM+ML?=
 =?us-ascii?Q?oxk2hmjojCtlh6ykABU7+XeqgsdPE52wPBm0Deagv7go0l7edJos1LmsP3o7?=
 =?us-ascii?Q?7k/3NsBIllSyWu5ddsUqwjq9fQXJXfJHblyU+Ra75X2oC6PUuSHuJfd9f1aP?=
 =?us-ascii?Q?cb6+c8TARj2xCyY5ky4tcJu0/KS7XBw5i7MVelLq5J9EiL51x+4UEirj7aMa?=
 =?us-ascii?Q?UWFk5OB4mZCp2cgl/bwx+Vs459pqCkWiyI6e2IUlkIFahdx28bzhXpj11RIc?=
 =?us-ascii?Q?bUyNA3sSt8BZBNBCpveJDQ2N1HVtdGuR4A9ifBwcEOnzI4HXGAlpUngdfqae?=
 =?us-ascii?Q?7dy5YDTeF0i9T66lBDR4tlRqEFq49dwDd/K1PtgWxvUEWqXq+xvfY/WPw5l1?=
 =?us-ascii?Q?iA6p5gtpfjl+ZD1ISFIFurPbJXyZK3kz5oHc2CzHCuxOyMqfDuFESCegTkYv?=
 =?us-ascii?Q?LPkuQvEAxdDsk5/cquUin6GNj2DJtlMDCqjpqbP5eG6AjkG0drV56wSpbqeg?=
 =?us-ascii?Q?GnrDDNWk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d45d31f2-c3b2-4189-7e5f-08d8c1d324c4
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1494.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 08:19:47.4921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fui9mW2AHYBhm3Y3GHV8jQpWUftukr3bplitCHjnqNDln9C5oD9fV+Yfv/+S3zHY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0214
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

New AMD CPUs have a change that checks #VMEXIT intercept on special SVM
instructions before checking their EAX against reserved memory region.
This change is indicated by CPUID_0x8000000A_EDX[28]. If it is 1, #VMEXIT
is triggered before #GP. KVM doesn't need to intercept and emulate #GP
faults as #GP is supposed to be triggered.

Co-developed-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/svm/svm.c             | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 84b887825f12..ea89d6fdd79a 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -337,6 +337,7 @@
 #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
 #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
+#define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
 #define X86_FEATURE_AVX512VBMI		(16*32+ 1) /* AVX512 Vector Bit Manipulation instructions*/
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e5ca01e25e89..f9233c79265b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1036,6 +1036,9 @@ static __init int svm_hardware_setup(void)
 		}
 	}
 
+	if (boot_cpu_has(X86_FEATURE_SVME_ADDR_CHK))
+		svm_gp_erratum_intercept = false;
+
 	if (vgif) {
 		if (!boot_cpu_has(X86_FEATURE_VGIF))
 			vgif = false;
-- 
2.27.0


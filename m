Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349A72FE456
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 08:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbhAUHsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 02:48:55 -0500
Received: from mail-eopbgr760075.outbound.protection.outlook.com ([40.107.76.75]:35598
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725967AbhAUG5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 01:57:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhz+5JuIDZpV/klaypKH7wVapn9+ECuf+vSjZezmpYNIOnT8l4bpy+He6e6ui4LE6RFD3n3HNY9JPSRKKtDsoBjH4KpgrZbxH/4sAEvWsV5ZLt9ukaXhD2Abxkundz64q3Ahu/euQXeb0BXfxV5Q+nGE0Ah8wfexkGtvRcXMSxlTBXzjmxi+l4uQ0zP9Yq3+A6gTMzhvJT+3elKPcEk9VBiPn0QEmSGkZTJwggjeLqdqqZvnUNO/WF6ZrmCY5stlWC4ljVGlIXhyCBr9cA8t+dix/vseQqcixt5KvtD7tVoGDweusJ+MmAZsPF/14+W/3aOjfziOFvbQXq7NvXj5cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1EIiAKuDJITokT4quODEVwGb3x5p6+c0mqJ0yG3gW0E=;
 b=YZyTIvfSAhLrM0Z3vsUq5C2INh3JGl6QyVjcw2mr2LIfFEL3/re7RSyhGtQ/DG+IX3WipYZmOdnvG+Jhl/WjSgU13OjdNO0pxpotBpnFjLyWvmwqtZCDPEMnXhghMEeOh7+dVtcU8S3jg6DY20GI5fzvivNqe4CluPoK+gZsafiiX4/yrBp74wAYrMYUGwASGPINlTW0zHNo+M4UQEvFAARhZ6KqhWvxtm8W5F/5ywCQGjDdbLlSQbEzBMZ+MM4zR4J90bzRgmL1w1Y/Qs1rTZ+YwrKBkbGftXQzyU0JAqet63M0mThS++nys4Y0guOoMMcsDo+/QoIxDXDsyWtMXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1EIiAKuDJITokT4quODEVwGb3x5p6+c0mqJ0yG3gW0E=;
 b=33ygBH0rnLafa09Q5RL5XxahC3/rzOy5lmV4TTd9DVXY5jfGR4X7PItQdzm/9OKu+FDTHNywL2DcF3GFVp5TfmI/8TJ4APeSjMns0zgV9g4R6JcpufJuI8eyG2E3Kqm/iOIxEvsEIWMAbI0GgCtP9s35T2a2ijcXeq0NvLLwLcQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20)
 by MW3PR12MB4441.namprd12.prod.outlook.com (2603:10b6:303:59::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 21 Jan
 2021 06:57:09 +0000
Received: from MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::d06d:c93c:539d:5460]) by MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::d06d:c93c:539d:5460%10]) with mapi id 15.20.3784.013; Thu, 21 Jan
 2021 06:57:09 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, jmattson@google.com,
        wanpengli@tencent.com, bsd@redhat.com, dgilbert@redhat.com,
        luto@amacapital.net, wei.huang2@amd.com
Subject: [PATCH v2 3/4] KVM: SVM: Add support for VMCB address check change
Date:   Thu, 21 Jan 2021 01:55:07 -0500
Message-Id: <20210121065508.1169585-4-wei.huang2@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210121065508.1169585-1-wei.huang2@amd.com>
References: <20210121065508.1169585-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [66.187.233.206]
X-ClientProxiedBy: SG2PR0601CA0017.apcprd06.prod.outlook.com (2603:1096:3::27)
 To MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from amd-daytona-06.khw1.lab.eng.bos.redhat.com (66.187.233.206) by SG2PR0601CA0017.apcprd06.prod.outlook.com (2603:1096:3::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 06:57:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 14a80c13-2932-4a41-1064-08d8bdd9c52b
X-MS-TrafficTypeDiagnostic: MW3PR12MB4441:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR12MB4441ED40210358F1ECC0B9AFCFA19@MW3PR12MB4441.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:326;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: COVmcjyt9Q8J2rJHiPaqhgeq3Na1GVk0tVrwmmTSDuXs+KnVseCTpnDg/ODvxrCIu+NOM6C3e9MdImrzH1BhkApcPqLvyjjhbochGt/uz98SjY5oZ+zfcRvUAR8pBAZMvzz2u3fJuZBZdXeX85Tw4ds/2w9rXlsrw6dhaOHyjsOTY+man/sMvXNm624KTKY87+zT/2LnkThIL7f6ygLfEHXnXSseBXwRcbtSCUNUXcbC9KBlw8HActC2/S5zsyfj0ZgCKWkWNzF5nYiKetIB468txlV4l+37LzS0usMd6C7Mw4xG1tuZtzTFr5CWZ+HF55opp9jtS2QtCccixJz7BB3xqbobJJWs1vdDdMgKJ7WINZ3tp0C+yoEy4LpWCcveRf0vsElQ5PlutFcYo6iZ8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1502.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(83380400001)(52116002)(8936002)(86362001)(6506007)(66476007)(6512007)(6916009)(2906002)(186003)(478600001)(4326008)(6486002)(16526019)(956004)(26005)(2616005)(36756003)(8676002)(1076003)(316002)(7416002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?o1C76GElcHMhJ6DImL0KdO2RayDomKJYurm3QtFX9WMa9UOFQWec3mKOm8Az?=
 =?us-ascii?Q?WrPcSmDfgBWWAzsL0/9eOnAff6PIqFPu31b2Wqn+TCcDfZxDW++ne0vSfwzO?=
 =?us-ascii?Q?rZ9qbmVrH+qUnEoNzTxO16GPya944+ruzPGysbIxel7ikUxq3/I03c/2pHCA?=
 =?us-ascii?Q?8ic7hcFYlHNJpAAG5DKcVZFoOPB1OHSMusj6SWqPvbOwdGs1ABdLYZBqYqC3?=
 =?us-ascii?Q?NMthO5mnmxBs1OISezTTFU4JBT719P6iVKe5YsPdkLePCYrfPKJ9yzuipy0s?=
 =?us-ascii?Q?ZecMFP0tUK6GnwrZboIVbxgK8CadlK5rVnxdBBZAGEPXTbzxcLGr6hHdmDbt?=
 =?us-ascii?Q?HGow87fEkvWVApEEA/TlXYHJfH6qIA/c7RF2esbNxQgWq5gWK154wEw1j57R?=
 =?us-ascii?Q?JF4uAplUhF/m4t8YBpAT6V9sHKWusTy8YbxMY2w7Cig2AMJRMZ39HpwFqL/6?=
 =?us-ascii?Q?0UxICXJbGfg5J/2mYBkq/Gv91QsdWdOPcNDA5CkHgN8uq/4RwljzKiOxifcb?=
 =?us-ascii?Q?JtEex3S5FFXkciWDfnn+lc2hNO6JwwGGEcJPZliog7p1Xka8AxMGKfC5mAnC?=
 =?us-ascii?Q?R6OTUvwF+VJhpZ2O5uV/1ON0ywp29Cc/5RFZKXBi7ojBjDorliPS+aeJnHgl?=
 =?us-ascii?Q?A5WQEYwrvwaFW6Z+p9JA2N1bijpLHNHy8wrH8U9m3BIIhnG/+81zC3sOb25N?=
 =?us-ascii?Q?lsnkVo29YatJjGcEKuhP1PZuYX7zuB15epY6j+7/27RNJmpPNnlJoRVzyT1Z?=
 =?us-ascii?Q?DOS4K3yIg2RLW1Hx76dUYFZNcaBkCOeIRX9aAcu9yTgjchlnIQp7ozkD1Ysj?=
 =?us-ascii?Q?+G4djx5ZF+hC67ZQSEjNNlpGrQpAddYjs6WjcaTAoKlGynjF07jSdhR6R+zG?=
 =?us-ascii?Q?UuRFoXRwsX+Z5hwaJGhRm/LolMCOvnn99DxdPHM0Ia4XHwCpgAyayIoYREGz?=
 =?us-ascii?Q?v95fatyV2vm8jcvVV3v1HOgde4ZFXTRoN+E6gGTWZlcsadougAbhXwjPQJd1?=
 =?us-ascii?Q?IWEc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14a80c13-2932-4a41-1064-08d8bdd9c52b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1502.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 06:57:09.1069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9QqwhRh+WXe1hLxIxarT1x0lo1reVpdAKVPMVdF2xeSlYPuPweYCWChmR6JTkujW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4441
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

New AMD CPUs have a change that checks VMEXIT intercept on special SVM
instructions before checking their EAX against reserved memory region.
This change is indicated by CPUID_0x8000000A_EDX[28]. If it is 1, #VMEXIT
is triggered before #GP. KVM doesn't need to intercept and emulate #GP
faults as #GP is supposed to be triggered.

Co-developed-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/svm/svm.c             | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

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
index 6ed523cab068..2a12870ac71a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -313,7 +313,8 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	svm->vmcb->save.efer = efer | EFER_SVME;
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 	/* Enable #GP interception for SVM instructions */
-	set_exception_intercept(svm, GP_VECTOR);
+	if (!kvm_cpu_cap_has(X86_FEATURE_SVME_ADDR_CHK))
+		set_exception_intercept(svm, GP_VECTOR);
 
 	return 0;
 }
@@ -933,6 +934,9 @@ static __init void svm_set_cpu_caps(void)
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
+	if (boot_cpu_has(X86_FEATURE_SVME_ADDR_CHK))
+		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
+
 	/* Enable INVPCID feature */
 	kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
 }
-- 
2.27.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B292F2862
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 07:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733300AbhALGix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 01:38:53 -0500
Received: from mail-bn8nam11on2048.outbound.protection.outlook.com ([40.107.236.48]:26817
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728560AbhALGiw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 01:38:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVJ4OsS5qZKzaAT2zkWyxoLKhJZeV7Wl9U7wnih5nfY6BO8PCgakZNO8FB0IvWkQzs6FxW6mJbijaaICDb0fiBrOyE/H1PS3nkJPu9iIbMd+H8SZkv5ivHKlV8f9WlkQPf+LiV/0hiJXjDq79Op7QGtqvPZLZPjPe7WSL2ewRDDOvyV60oPedX7x7Z1POEv8xyTsDETyCa8x8Eppk6Rcw1R4hNtGHLyn8BgO4aITkSUROzAqXESDrz68J4q1lRVaswC7byxtNvg2TdLo+jwRQf0rxZfBW4QICVjHYGVPqRr/rRFAIt2Lq6thANFOnPj7ihxKkhM4I7rccHjk97EBxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9IkJ/TBowJmAvjWg3K4uekYiL11yLv0ntBfq7xpuk4=;
 b=PaEpuqzctnbG5DPGtZb/mx7jPQefyZdqMTtvNfuL09P5kzF7f8rOkN8IuFVuxERCYA7xdKgYo5NkLHGnnyesiCsJLXlZR9yribvFUZPXJJOzcnVuu+lVXPkWSNj+xRjNKexzna407ZIgQicMnLGIvWnK+SAbnsRGJoAbuCVAw4LYWOcLAtIbO0kS5mRAXVJlinGl39C9V/tpq/xX4bfUcRnntfyrHzvroyOgXeh8VEh8pOXGyUmPj15svcXVYgCSaUTUBK204FtsyGttXD4ldWvmuzz65rRWl4M8OVKH6K7nHx0IAhRvdaIzyVb9Pmf4v2/VtAc8h5hMNGPVctO/Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9IkJ/TBowJmAvjWg3K4uekYiL11yLv0ntBfq7xpuk4=;
 b=huJmHTvVwTlB3pgg2GJ1rfjn/VaY0xNmZsISKnp2sxnTrDDqWFkb1HY8EhkCz0yDEab6NGCtHRnk8McingVenUE+1A6g+J6+uDAHrkqe6phMrLgg2ta31bluJaX2qv1sWLI7OyN5qlnXoM0q/bXTFXSSRkEAkrVqwl5aVQfJGDQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20)
 by MW2PR12MB2409.namprd12.prod.outlook.com (2603:10b6:907:9::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 06:37:29 +0000
Received: from MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::4d9d:16b8:3399:ce90]) by MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::4d9d:16b8:3399:ce90%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 06:37:29 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, wei.huang2@amd.com, mlevitsk@redhat.com
Subject: [PATCH 2/2] KVM: SVM: Add support for VMCB address check change
Date:   Tue, 12 Jan 2021 00:37:03 -0600
Message-Id: <20210112063703.539893-2-wei.huang2@amd.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112063703.539893-1-wei.huang2@amd.com>
References: <20210112063703.539893-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [70.113.46.183]
X-ClientProxiedBy: SN6PR01CA0014.prod.exchangelabs.com (2603:10b6:805:b6::27)
 To MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from weilaptop.redhat.com (70.113.46.183) by SN6PR01CA0014.prod.exchangelabs.com (2603:10b6:805:b6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 06:37:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2acb6c2a-8d95-4148-8b09-08d8b6c48862
X-MS-TrafficTypeDiagnostic: MW2PR12MB2409:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW2PR12MB24099BFE95C3B01869B17AA4CFAA0@MW2PR12MB2409.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:274;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WKlIlEpoPxFQ5Xr+VID21AyMCtOKnZzCMc37blN0ySnMPGc9KiNqmiL3F/jegxE4AnMHQedijNXdjbouHTD6gIctlMg3gOPIKSU6eGyisW3zQx0J21s/nCnnR7/dyENlLwXwywkBcGn3m5qxD7vrX6ypvj4KkRgpHdx7+5q/8/wSHOStr8fFhKRu255dMzdt2ZnJI3PjQVdnBo+HmRx/UUpyO9/6rVE6fKnmghOPWL/PTFpbhTjdq1Df+JFf5eJrbzmryvfGWPJKL+Khm1PLX6AYhzFt1HhVVsc84w5pSVUZ9qDwy+Fyql8DLdwc63ITNvLdfLwq1wkYUOCMCdKbUx7kez28zpLEY+x4mjuH8z5vzfhpvwlzMoyQYvOF6khgwUpy9i6Ax5fwAQWYG0pEag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1502.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(86362001)(6486002)(1076003)(16526019)(478600001)(6666004)(6512007)(52116002)(2906002)(956004)(2616005)(7416002)(316002)(83380400001)(8676002)(66476007)(66556008)(6506007)(4326008)(6916009)(8936002)(36756003)(186003)(26005)(5660300002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eaiFKSi5E1JGfavhuRn0p9C2FzbA52e7vDu41BVCOALBmJx3344CqePnjNxr?=
 =?us-ascii?Q?rrV37xtTohYcqEEbqAXimh8Wbo/nORgvYf3aZHtWlZq2zAd7cYavYpBO2i3J?=
 =?us-ascii?Q?xd/T5suECTffLvKRgFynl5e4TkWR/WGUuDB2iXRp5fP0pFQ0I3aubCtEQ5D2?=
 =?us-ascii?Q?lL6EXB6IGIxowi6oWGSTq0tu0+HOH35gon67RFdpyct0wZw4kP7Zf87oIYjw?=
 =?us-ascii?Q?zD5zlvjnBA19c8rG5oQLIB6nKFTGNi7OayasUjo8y7r0yaaNA4RE2pPrpndH?=
 =?us-ascii?Q?H5HnksRHELpJrfUYNWYXyjrvTKKmChAEST41uOLIDCfKCBf22ZpV+4liWdQi?=
 =?us-ascii?Q?rKOeQq3Gpjg/ymTAvg85UA2LnPrsz3USQkBqLUYDoFsdHyNSRpM3wKuVKNdu?=
 =?us-ascii?Q?EhMZzJBy12CdipyK/oNSu5QcXfIajQH0VlKZniaoP2VtmtozwAVMfohlRerP?=
 =?us-ascii?Q?RfoYsFeLmuN40hMD/3TXyfmhAxLmTqIEuzGbSXc8JXasvwkjFveYGY4WUNky?=
 =?us-ascii?Q?LXqFMWfnTHN8wHrLWccwbVkQbpF5GJZdsivLejKNtmaPs1jxHgFr6EsvKK8Q?=
 =?us-ascii?Q?pWLXRyDbti4+9yVwhNCWeD7AUtTW+G8TRpj97eGjIDAwK91jEJ/YXsvcMjks?=
 =?us-ascii?Q?E2dkuL50X0iMy6Bj8+CbTloPX/CvTrxGHyzZ1ZRE0ZnZBz72Rfb6vhNY6S1L?=
 =?us-ascii?Q?k+aRFvpjMLB/il+RSLlbRXaTXBB9iG5gZPSOpBdC2MdsHmdVEzeJbeQrHFqq?=
 =?us-ascii?Q?gkw7tsBEreXBlBce1BXydL+uKIaCeB2uJJcKgv81YU/dUjaHsckRKz97iEMb?=
 =?us-ascii?Q?QHgfiQ58EBPqtJlezojYYJe+6bFefejzUrDNRAf2O44YOziQd+b+hrU5IDHT?=
 =?us-ascii?Q?ysAdnjatiWbPJfsI5AUYG9mwmnL837nsb7PM4ZIrLEEHA9yA4ckUdGUzd1/u?=
 =?us-ascii?Q?B91IWzC77i7v62YyCAycydwT0zbsGAh00fJmAx8OVQ24SLtwZclEuEcjanpp?=
 =?us-ascii?Q?WUd1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1502.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 06:37:28.9440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 2acb6c2a-8d95-4148-8b09-08d8b6c48862
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2qZZzSFjl8MRs0l41bj683Nr43kaVYfnJgyHuMN1LaNsirjPx0WJMOGAkpNsCHVN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2409
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

New AMD CPUs have a change that checks VMEXIT intercept on special SVM
instructions before checking their EAX against reserved memory region.
This change is indicated by CPUID_0x8000000A_EDX[28]. If it is 1, KVM
doesn't need to intercept and emulate #GP faults for such instructions
because #GP isn't supposed to be triggered.

Co-developed-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/svm/svm.c             | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

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
index 74620d32aa82..451b82df2eab 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -311,7 +311,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	svm->vmcb->save.efer = efer | EFER_SVME;
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 	/* Enable GP interception for SVM instructions if needed */
-	if (efer & EFER_SVME)
+	if ((efer & EFER_SVME) && !boot_cpu_has(X86_FEATURE_SVME_ADDR_CHK))
 		set_exception_intercept(svm, GP_VECTOR);
 
 	return 0;
-- 
2.27.0


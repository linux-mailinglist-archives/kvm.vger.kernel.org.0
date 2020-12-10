Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E1F2D6466
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 19:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404042AbgLJRL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:11:56 -0500
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:37494
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732949AbgLJRLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:11:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1lxS4fnFFXRYvaQ3qAZEN1oTaUIKb6iD0y0i5mvRs36IIO1rZyMpAolB0MF8SWxkqJg6Vkz7xMHgWKnB4WOk0UNTFlj07pOx0j+tJMHzYUoY+qtKGnyw3PTNpIOWu/0vwlgIKxd5uYP7OC0xP4QEkI1trxy349prP7Vf/18iNN1p8HcscYqgJF0K1+FolgsU2cQWhegzJxIU3IvDPdQHSOf1xgBIqqu8BLvc2XlsUbgk05Fdwv/LmSYP+WjvuBzhJGQUVAWq5TCilZOZcJEo4MrcaQh3jQbqvv5ybIe6u8jIkff4fggtcDB4VoG1lqAU0w2I7JmUNZ90XS73ihjqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dezrM75SgkRzYWh4Ln72KARkco3Iwy+sJTmsje+sres=;
 b=DfUB43eIxKC90F3ExxbR7nxTs4NgYtvu3y+KcoRB+nsreqf87wlrXsu2k6mM73C9wxH9M8JEzageEJZ+xGQFRuMeSity3CB4LF3CMEkaGdKmsDGWz6JMs5c0aG5WSryQ9App1qU9K/mDjAfqzKaG06RdHSgr9mLOQDfk+Qp9Rg11cqPApRzgReVGcB3jA4u/Q05ptc3k8iaHcBuJ+5WZU7b9pyxqKY5KqB6M/MxfU9wRYnv9ffIG7rU2RvBlBaZe/8cffAMWVgjide3Mi68w4BFoT+Y8zWmpjz8vkeAV9bZ+4VlYr87Yrj8fGZQGkAG8ojWXkEb1ii/HolLJAmyYKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dezrM75SgkRzYWh4Ln72KARkco3Iwy+sJTmsje+sres=;
 b=inaRtfln6rXCo3SoW6DDLe7pOM2MQFQxVvN7AhxYJVCJ8VdfNcpFJgJwnp3b8C4/3gPmltHSFSGiVWSohHV1pq768Fgszu5x9wrTIHoJNDd01CQnO2wWrAj4gxFQZ1xaA606nPKpKFcqKUCFnOsuboTSmYWx4QwDVPfNZKNrM3s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0168.namprd12.prod.outlook.com (2603:10b6:910:1d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.22; Thu, 10 Dec
 2020 17:10:35 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:10:35 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 02/34] KVM: SVM: Remove the call to sev_platform_status() during setup
Date:   Thu, 10 Dec 2020 11:09:37 -0600
Message-Id: <618380488358b56af558f2682203786f09a49483.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:610:4c::13) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR10CA0003.namprd10.prod.outlook.com (2603:10b6:610:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:10:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 38015709-2c41-41d3-edb7-08d89d2e8278
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0168:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB01688C91E7924610C174E1D6ECCB0@CY4PR1201MB0168.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j6g4Cg4COSe8P7F6quS4eoCB38tfikB2hyL5UnalcufnrzPU4rdQTc1QsDt2y7+7fNBq29aVAtCd3hpLq3j+AKgQYtWsSfcEJN7CNS6tiz23Z7iG4oOMSUFHlJwYuCXa2BaFJoX7ioJWqxLMZw4y9pDZknhuF4tRVUFKuSy1wpnsO5SqAig1iNmTr8ahC8MbWo4BBN25Xr43WOzgIOZiuE4dQml1jv83VLOnHuh7b09r53R6xRoz7XJQaELvo3ZtNGJZMLOR34wFop/ClhdomQLS6WLY3/odfaDlRywYKD5hfMZcHjTJYnfNdEOE5sdbIlmQWzIa9vuw3L3DJZE9PFQ/gzSR5XHEjXrc43wniVaDRvxbfKQQ3XW0v9oV9Yd7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(36756003)(8676002)(6486002)(4326008)(66476007)(86362001)(7416002)(66946007)(7696005)(54906003)(26005)(16526019)(34490700003)(66556008)(8936002)(83380400001)(186003)(2906002)(2616005)(52116002)(956004)(508600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ldW8wXA0jddFUvfHEAYA1eg/qrTPBC9d1urgdv/nXv+hhufzbs7cx+Mm3eij?=
 =?us-ascii?Q?DrQGZrP2TTcdj5fmDHxtfVdbXD9zleHYdHKFRc7J+BnZ6f/8dUqyEQ4zZOLx?=
 =?us-ascii?Q?twq1u22u0dwSDLMTbgkoTcUCawOvnUUhvryjg9jxJq4E4MgOtfCoBzS+DvDm?=
 =?us-ascii?Q?rO/BPs/tbTfeJuNqRnCv9zb1TdPcOHB7FSLwJPwhqVtgOwKX1i29sr5sV5hl?=
 =?us-ascii?Q?YN8BFdnWnPqohZUgFCSLyBhmyZFjlMkW4EaTnqnpskmfCVg2/DSZSCku72yQ?=
 =?us-ascii?Q?r4LcXG04lbIbUJppfft43GDnMWlTrSqPtmMRd+bOFVVfAA8oqBRE0X2v4KN4?=
 =?us-ascii?Q?Jjz3j4cFrhofZD+akwPzujeIfJ4wF3NXpgU6usyaIG/y61VpO6jsxq8PKHXR?=
 =?us-ascii?Q?hDCmHH4YSXqFIhZR+FMr5kvhVcCvcouH0Rv6OKENrMiQM1hxLE6os9H5+uDa?=
 =?us-ascii?Q?E5IoUAAmnLqtzYlbxMHHLBAZQsRtNotJFQGUZUKq/I/jmV99/xl4t28BMsBK?=
 =?us-ascii?Q?Cwf8AxZbyMKjAKfmxf4DOm/AJTgH4I+DC+1cSh3UTMmswo/o46lCcwIADtzp?=
 =?us-ascii?Q?pEsaD4xEsbYImgrDSxYvMTOMDP0HS0+Fihx4vyN4Fe21Qbc4XXAT40/o6qZt?=
 =?us-ascii?Q?MafPDqXeSCVoz8LTWvBGVVtrSsd5prMkNE/6ruT2HPiJfMcH8qVK/lzb7YlV?=
 =?us-ascii?Q?Z/DGJCvPL9DvEGltMRpqJB4S3egYP5Ljtwv0JnoE1PhIkf8ZZIWJ2GDB+6OR?=
 =?us-ascii?Q?P1O1L6v80KbTiByH/Eo4MegKl6P8VoRPh30HzPnveEL0219bZkFERpW1AXJf?=
 =?us-ascii?Q?WP6bYhHewzNyfJSjVMEnM3je4fBNCRiGLATq5rpuuUWYfkZpeKYMFFTHPQk3?=
 =?us-ascii?Q?es5doXRQBzEXxoi3F4IOVJzcMi2KfXWGzkkdhuJxtqnqcQ8fx/ac+F9VGeTH?=
 =?us-ascii?Q?GyWjNmYnRjs5MDveixcfhlX2qxsnk4XD5mcSjCZWo+ou2NgLuiu3G1Lj83WR?=
 =?us-ascii?Q?uIn7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:10:35.5155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 38015709-2c41-41d3-edb7-08d89d2e8278
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fiN53wUMgaaO47Guol08md8M+FH8BV2oZteS3vlb/1B/7dqjr/oXSUXbFJ18lZbHMdK0Q+iW8oZzylFXuDy5Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0168
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When both KVM support and the CCP driver are built into the kernel instead
of as modules, KVM initialization can happen before CCP initialization. As
a result, sev_platform_status() will return a failure when it is called
from sev_hardware_setup(), when this isn't really an error condition.

Since sev_platform_status() doesn't need to be called at this time anyway,
remove the invocation from sev_hardware_setup().

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c0b14106258a..a4ba5476bf42 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1127,9 +1127,6 @@ void sev_vm_destroy(struct kvm *kvm)
 
 int __init sev_hardware_setup(void)
 {
-	struct sev_user_data_status *status;
-	int rc;
-
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = cpuid_ecx(0x8000001F);
 
@@ -1148,26 +1145,9 @@ int __init sev_hardware_setup(void)
 	if (!sev_reclaim_asid_bitmap)
 		return 1;
 
-	status = kmalloc(sizeof(*status), GFP_KERNEL);
-	if (!status)
-		return 1;
-
-	/*
-	 * Check SEV platform status.
-	 *
-	 * PLATFORM_STATUS can be called in any state, if we failed to query
-	 * the PLATFORM status then either PSP firmware does not support SEV
-	 * feature or SEV firmware is dead.
-	 */
-	rc = sev_platform_status(status, NULL);
-	if (rc)
-		goto err;
-
 	pr_info("SEV supported\n");
 
-err:
-	kfree(status);
-	return rc;
+	return 0;
 }
 
 void sev_hardware_teardown(void)
-- 
2.28.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DB22D630C
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392480AbgLJRJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:09:02 -0500
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:38097
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391374AbgLJRIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:08:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iodZAQJ6R8BQDFw7uZKbS76J4SzQryu8hM81b6yJP5DShhmDzkqs6HaioYMpPRI9d1EDkb3OYNyNSI8LTv5+DMLAr7mDtuwrUNlLmBaIZ5TlYNDiT+iWHsEa5HMAbXNu3rEl6tNqX2Z1MPh/cqPoMYl9oZpHEHFL5hWpTS0eXiVz+5Ij3+Lr4hXrv9s+tbJEvclO2+hCMBqoZpjjUWCZ4je3Iri90w5xhd6wLDfqfkgsA5iBGtr9ZKA7yDBB8SnLWa3OZrgMDPPtfX7z1QSooqa3JkYbxfcOCZ1rJi+sfkK7kectLgLysw7tfLdxaWj/lMocnIN/pHz/6aZF961Qhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dezrM75SgkRzYWh4Ln72KARkco3Iwy+sJTmsje+sres=;
 b=R3H646wn8VRREH9Oeai/rQ/DtuIvjOrLlyr477wNxifYxF5aJ+h24fNbxpFdT64O+biga9iVLPqo93FFQH8gqb8ZhBv9RyJ+7AIl4s/DdnzU8PGqGXDU/rUPJTo5RIY9InKW5CFVKFkJmrbJJ7KLPstrfmVTl4utE3pVA+et0ii5Tx5WOinrrfpwSfJ2rvUiMZiKSCQ+Cg/suc6GGKALpA1ziA0wt7qq1EO8Ns95LkLV8a0FtMb2YvtUDNUQkIXVAuRIEbTgecInvmK9PMfrWeayFwapzPqJ8rjbhvYawOomycZqt12rID6u8ys7+7uWF6Hvp1affJ6akR9/qkivwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dezrM75SgkRzYWh4Ln72KARkco3Iwy+sJTmsje+sres=;
 b=hpGOCcNCAhEfY97iwwcS0bsSsHWmUptYEZImvZSQ6h6Yx3+tIrqkeUMWQdsTtQWr4O5kud3JH0QN8EeoR4gHa8T5UO84/Tvqid08oyK/XucOa+yOvd7RZabqUTx40GwPsrtS1CrPQexbPL1jrzZtsHLU5fU7bp50ehyO5tAwbBs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1493.namprd12.prod.outlook.com (2603:10b6:910:11::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:07:52 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:07:52 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 02/34] KVM: SVM: Remove the call to sev_platform_status() during setup
Date:   Thu, 10 Dec 2020 11:06:46 -0600
Message-Id: <618380488358b56af558f2682203786f09a49483.1607620037.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620037.git.thomas.lendacky@amd.com>
References: <cover.1607620037.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:610:59::25) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR03CA0015.namprd03.prod.outlook.com (2603:10b6:610:59::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:07:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cd976015-2c88-42c1-098e-08d89d2e20ff
X-MS-TrafficTypeDiagnostic: CY4PR12MB1493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB14931C70E0B2900743193F42ECCB0@CY4PR12MB1493.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QziQro2RXCI/BanbiGpiyx3rXmHVKz/j3kGPZpSELzku+NnESom2recatIkXHf9WDqpe8glwjmVIQVKIYw0rH8tG5Dx6CbzapReVV4tH4j0UAINhBmpkvdaECQonhP68VmZTdKMjGs+YoQ70n9Bswl7CcI86ieNU5qulVh/ibyQ2rIarY6T/Rchv+8leAFPnQesDCogFGVcfA96l2/OnqHfHIn7yZ+JquNoo93MchQQ/o1uYOp17dfR8N50wiqomr898Dscz4idyKkWgFmyU4CeWjm9nVuQ7yBmqsH/EhPP5JL0uQfCcm+x1Sdb6VXrcVdDd4n8APVqpRtcLmlDrbc+hBAdeswZcdSomSocb1yRFj4NaNn6wimRt12Eb0ybK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(5660300002)(66476007)(186003)(52116002)(8676002)(36756003)(8936002)(4326008)(86362001)(2906002)(66946007)(6666004)(66556008)(26005)(508600001)(34490700003)(7416002)(2616005)(16526019)(54906003)(7696005)(83380400001)(956004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xxtxgu+UmhJPsPapv3B6ZFidWs09UIrgXmr5Cnks+syF7vXjfRHEA7zqy/1L?=
 =?us-ascii?Q?nxbYVE5yJ/UD7jyEORMcaI/jMLLg5y1FCZAgCVKzLIKj9ZF+/ZCRslZ/VFoK?=
 =?us-ascii?Q?Gt4K6W5Q58yCizzfqzlihwuaI4aN0fT1+jV3d7Q314JTm61XuVwUJW3IFZKF?=
 =?us-ascii?Q?n6C/4Ggg/xKMxqXfc+PmcbDQmIxELvjYFZPbGi726bQp5pdPsllRn3x2HDMn?=
 =?us-ascii?Q?od8EwewG2nh6McaNZsE78npOqWaefj3Ep0bO9uSdI5eszPUvKYhAU6HgIT2V?=
 =?us-ascii?Q?0SGbeqq0AeWytlSVohiXliqro88bvPd66potLvKi4VdYe4uxyrurPTwQXSsd?=
 =?us-ascii?Q?7/Uq9AOB1cjKSkPOJOwcnracSCyrTV5uXKnvGhoHWUVB8tcVacgwXXXVpRW9?=
 =?us-ascii?Q?Rt4jQlnqPcOTprtYSlKC8r7A3w0HsDH5JHmWmzYXa3VS2RZsQKqxneuXZhmA?=
 =?us-ascii?Q?iCTtHNdU77NEcWi0pHLWU+cecktztzT3GPLBl975AA1iJD62QnlcwtvpaDh7?=
 =?us-ascii?Q?0BGZUrwJR615KIrS1yQsVa9XSNhd+LwyywbGwGeFUreWxx4/DO37rQXnARdl?=
 =?us-ascii?Q?TIy6OQo/oNg4lzqJ5k4UM+Oyqtt27vj0pPF7LNqkZVEXF6rFTBhk0WWFu9F4?=
 =?us-ascii?Q?ENVzDan3H5msxmPz/OkiEJ2i5NsRmInON92zVUbzb+2/SesbOlF8CQiC5l2m?=
 =?us-ascii?Q?ueljTxF+KjBdyYpOAVsacjT+ORAvGSFoBpCVIzf21X5XMkkeY2ZkO9mYNwXD?=
 =?us-ascii?Q?2l2qXdnmzsQbNm+WN5Sj3xw+8kiMNVf6P5RYfpDncJ2hleOdQduFhwqFdzIX?=
 =?us-ascii?Q?kXYN5y0+aaLGeAWp7iUoJn7+WtEoKxGHQwZPG2kLJJ5J4sd+xE9DDbmyGdTD?=
 =?us-ascii?Q?ORYj9OzFUZHwzqJtXTQMQTCIK+va+nb0di9E672pvuaRSFAC2t4/JwQzIjQV?=
 =?us-ascii?Q?krbidbqGWRVG2e9kiplstczZpBBJKKF9yXjdHNoIROfPGtLS0bDZSnrItirF?=
 =?us-ascii?Q?SQsQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:07:51.9627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: cd976015-2c88-42c1-098e-08d89d2e20ff
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G/v7hvbOP/TKMR0b8Gqt2YtiHVHfOpCzURBg1Di7R4t/oHhzFJ+BT5CA4KolKmuxKwBbc6oOJ41bTH+CbhHovA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1493
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


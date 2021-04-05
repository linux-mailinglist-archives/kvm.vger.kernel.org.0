Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8732A3542E3
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 16:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241417AbhDEOgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 10:36:08 -0400
Received: from mail-bn7nam10on2053.outbound.protection.outlook.com ([40.107.92.53]:56769
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235915AbhDEOgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 10:36:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=coGYKRnhXmhdf2i9e632oexkHYJkKYkF5r5JO1iLqseSlz9w0iPjURB/FjV2BdRFDcDlou5K5cYlnpXLEzEkb18Ro8nsgFs6K8kHnuwkKDX7m4cTAnq8ABBl7TDh4Qf7J4J8AJCzzMLX8hMxj+gUIFxSHvWOuS31xF9Rc0lBmAzclB4a6nR0fOV0yTr/7txYj492293SvFE+aerB9VJ5cVwdPgfWWedQ9ENy1fwRXDJqqQTtMuD19JdcrtdoBkQ2aLRGE2dhqS/GcbV4OoeC/mQuA/tVYKNwAmY7eK/7I98+rGK4CSlHQ0/M2Saw0VlnkdlyM/e5P6MyxFjcypZB/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMFsE5kyHk8b/BTrnc+Jh1LeIka8vWE7qzvszbJdnIY=;
 b=cg1NdDdsSv0KU+LGL+PPsugviOTRQvejRKbRmLWGwvBN82YAQZopuql1Ymn2qSyKK8oU0WOjNxQY3rOL/PWGy3iqV4LVcVIrk/ITWfCJOSCJWE+HFPSB0ksb45pvtyq6aeoNxEiaKf1JTaXAmFSSTqGmY2OL9HaBfK+FEP6pg7q20bD03TeQNDW66zrD8vLPFmArqnTyhXGTHfDXVLORbXTxR07vNkwIBThtfOCTAoYSyQdrPAkn/dX3xyynhO394oGFfBs2Ja6Uf9tFmuVVZK+sX28xNejov5Egwapd4Jwhraw71Om3mKVPD+VyExJkyEdGQh21KqlO/J5cbnnUOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMFsE5kyHk8b/BTrnc+Jh1LeIka8vWE7qzvszbJdnIY=;
 b=MawoovEZGc82CTvoDR6ecL+2ENSgqgb+BJFZXtyxdk1r5fGCxEKx3hZlOhiWou8CNrpBi5O5YIcZe2qJRfmN3jsVMGMBFWjoyfHVGc15RHdr4NCezZLkjmM/7337TCGvUNGbgeaG/vlkCbJC9w+77aj0h+4p/dpBO47WMHjOz0o=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2543.namprd12.prod.outlook.com (2603:10b6:802:2a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Mon, 5 Apr
 2021 14:35:57 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:35:57 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com,
        kexec@lists.infradead.org
Subject: [PATCH v11 13/13] x86/kvm: Add kexec support for SEV Live Migration.
Date:   Mon,  5 Apr 2021 14:35:46 +0000
Message-Id: <f37fea4a83aecf03198b0881a17561cdbf4e5a2b.1617302792.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617302792.git.ashish.kalra@amd.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0074.namprd05.prod.outlook.com
 (2603:10b6:803:22::12) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0074.namprd05.prod.outlook.com (2603:10b6:803:22::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Mon, 5 Apr 2021 14:35:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b96be1d-68ab-49a8-e8ab-08d8f8402022
X-MS-TrafficTypeDiagnostic: SN1PR12MB2543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25438DEACAE7C4473F8842228E779@SN1PR12MB2543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8sGJAHtrO3nHFjbmStGyIuoKwx62113iKM+TyvxqtX7T2yGxr/LfDd33IIEr1NWqi5LHbIxW/HMH5f0A/iP5lv6QLfFVGER8i7pnW0aXy8SytPsNsbpbkbET0xXfWO0WRDGd/SnkQvpxCris5mf8N+ah7Dm1PNfUSY2I9WZEFRnfdPtu/7HohbjCBKFT/1cw2TEO0yzmdND+vh3f1yxVebT+RB8wUtW+c65VLXmrz3PzGpyvqb+kOm4PvKFn9s8pSJr5jv7mOzhRVJLVy8UXe/lZ8ClBhp9+vF7lhEZ/y4/ru9zX0z/+lxIjylIbHN2ydzk1O94VVcpoZdKNJJo7BX1yO37Mqa56SqCqGy/4NXK10iAWQg9GRj2mHCstCBbePCjtvUhV96KQ9mPivnGGgXxunD+bGkVvHc/C+ngzr3kERT5mkhXjlMmBHDdVZy+EcSoFLJQIKCmsAiORziMc8Il9Rt3z4XmTpcMTwFZjUuwmrSuDKksUeqRWTN613JLOKyW0VrA8V3k62UnOWZCZDI7qGE60FiduVIUss5XRf7LIYZGe0MtFAjLWrOlpDxUaIKCuRf3RBYHfrZ9Y0SPg/VCDvfm1DRq8jh1KAtvhIvOI/sYbHd/zcFHkQTrDjSHdjhd+VaZ6fP9frQ5cGRTYIDrHX/jkl+gwQ2IoRgOW6wo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(396003)(376002)(346002)(7416002)(52116002)(7696005)(26005)(2906002)(186003)(4326008)(8676002)(66556008)(8936002)(66946007)(478600001)(36756003)(6666004)(86362001)(38100700001)(956004)(66476007)(6916009)(5660300002)(2616005)(6486002)(316002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tTvrt9gA6tM01bHUq0yoVixCjbDeDBuvP67/4BLAm4ScI/zMyBIUK46jsmrR?=
 =?us-ascii?Q?HWmDeXRJl/17YLx/td34Ea8AHykdKmHaZlZDHpilIMOXTxQIb03s+C30snJe?=
 =?us-ascii?Q?92QYSWJlFXNM0wYJGgdWP63wSoMYGbCs0xOQ9vimglH4SW4qv5LnscxiglxE?=
 =?us-ascii?Q?gzXi4//3wy/VIxlfFBDc4jQTyfHjExPdixT/Jp3Qr12ZpMqcRK24EUr+E+kN?=
 =?us-ascii?Q?oSo36EkY/C6yAT/DsbgEeNLZ8eZEQyinNokgvhEcZ8Dh2Vpd1HJYNMbhLfUx?=
 =?us-ascii?Q?z3PNPnKWvJ3Av36HJ4GDqJLlbxyeoa9Q3bafxjcZVEzvTxcPsIFk3VfMgHsN?=
 =?us-ascii?Q?AzkJrb9pKs//W55wb9PA2mv3vpzzmmsvsXostbcvkHFZCYTLaJjyKZfiqAAo?=
 =?us-ascii?Q?68FtC7ZfaIXszg6Hf1rirBbZm5nJBzuY+mRE+msQ3UlbBxsMozrI/RMILkle?=
 =?us-ascii?Q?O3GD2tUL49HeYqxgnJQ4n5JR7ZSS7rzkr4EzRPG3jALI0X0TkAeZdmTi+3uO?=
 =?us-ascii?Q?rrgDMbnl33GPsg46dqBlxVRgepfBbSLFsv2kqWKjuKZTOXm672etG1/oVYbe?=
 =?us-ascii?Q?xEBXplhA+5VwlCTa5PI5uHoyM9ftQv4TnQj2/g7oKKf284+dkqirTvLTDR7o?=
 =?us-ascii?Q?wTnnE3NbSYgV0hO3E8cEs8/6GNd0YcSxfto9hsuA2pJrrms8/rRn2Axcfo8a?=
 =?us-ascii?Q?I5xy6hXswvy6/J6CtLWniag4/qV3W5sy6WwX6ZJvQaHWWQyA/9gYqaD9TcdL?=
 =?us-ascii?Q?TrhDjjHNmRcL+HaJDK1hOMswf0uPABYE5pBesR2Rt9hm835hOB312R14zhOp?=
 =?us-ascii?Q?uoJInXIzOwsq9/JRKCdPWQYjGOxjpZZtT/iooDwTmGuJsTW+Ii0SZkVJATjL?=
 =?us-ascii?Q?V3kEfLtVNctY6HPRMcsqpfnLa0a9kbL+AlpU4EbJI+bhbM3blHEIJtf5v+47?=
 =?us-ascii?Q?FATkwjqE7vUtFGiEK6EFlf8qlzNcZXrL3A1+vZo8F93Lm1gSDSuPt32dutLR?=
 =?us-ascii?Q?0iet83AzLxvatB77pSjo7HkdRZLWA7+6AoA68KHVN8AKCBHsJbpQnq35zcrU?=
 =?us-ascii?Q?btRCl0Ghc3UnqbUkYquMvXgZ2pxLuDEjty2MrCPzUNRrwHxJm5CrjqCmPlT7?=
 =?us-ascii?Q?xykl7IVUH2x5em435KkRP9E0PNzoaB8TO8mor0yH/a+IIotKyfG1S7XrHtA8?=
 =?us-ascii?Q?Q1oLl7ngPDmmQySSXTBpJCOsJjVh81RyYyOdcyQxgMnAHW7G7pMGtDXeUtr3?=
 =?us-ascii?Q?0vITkrBDHX2koKCcuj7siOoM8MwZASGHwi4L+SaO6ExAtleZhMPshuo12lpB?=
 =?us-ascii?Q?14R9xGu/oxOtypvpMgXbI4hE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b96be1d-68ab-49a8-e8ab-08d8f8402022
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 14:35:57.5118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWtD5LurCfSzITVFqKd2tyI2K94soHjqeFWTvwnmsEoLtKiOo08pkzhggVtbg2VmCrhvKegPxBaEjXSHhsnapw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2543
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Reset the host's shared pages list related to kernel
specific page encryption status settings before we load a
new kernel by kexec. We cannot reset the complete
shared pages list here as we need to retain the
UEFI/OVMF firmware specific settings.

The host's shared pages list is maintained for the
guest to keep track of all unencrypted guest memory regions,
therefore we need to explicitly mark all shared pages as
encrypted again before rebooting into the new guest kernel.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kernel/kvm.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index bcc82e0c9779..4ad3ed547ff1 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -39,6 +39,7 @@
 #include <asm/cpuidle_haltpoll.h>
 #include <asm/ptrace.h>
 #include <asm/svm.h>
+#include <asm/e820/api.h>
 
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
 
@@ -384,6 +385,29 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
 	 */
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
+	/*
+	 * Reset the host's shared pages list related to kernel
+	 * specific page encryption status settings before we load a
+	 * new kernel by kexec. NOTE: We cannot reset the complete
+	 * shared pages list here as we need to retain the
+	 * UEFI/OVMF firmware specific settings.
+	 */
+	if (sev_live_migration_enabled & (smp_processor_id() == 0)) {
+		int i;
+		unsigned long nr_pages;
+
+		for (i = 0; i < e820_table->nr_entries; i++) {
+			struct e820_entry *entry = &e820_table->entries[i];
+
+			if (entry->type != E820_TYPE_RAM)
+				continue;
+
+			nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
+
+			kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
+					   entry->addr, nr_pages, 1);
+		}
+	}
 	kvm_pv_disable_apf();
 	kvm_disable_steal_time();
 }
-- 
2.17.1


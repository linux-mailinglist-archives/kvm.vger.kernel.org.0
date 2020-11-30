Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D923D2C92B7
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 00:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388977AbgK3Xee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 18:34:34 -0500
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:11880
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388951AbgK3Xe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 18:34:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ra0FlBqpYN+4z6Q+cmvqcbLwsKZWBQdeKHG9k//zexhZeq7EHSZ3huwaE3PvSkO1gF4CdPWCuSREn+Js3FDLSAY3nr624an4a3uKKkPimMyAvkGF2e9t1mqwuplQ6FUtaI704T05P7SSqMBhTKn3t4TXJiMwHncBZHtnRH8VuG4AmGQye3Nn0AhluhsycoRKQdnu2k12ZjKP620HTdszfPLx4Odd39le+rhhqyQ7i/XDB2crkEjnUT3PJgzWZ57w0CwLcvZsK1B+6N3pgP9+Co8cgKsdCc8Q2fyUxLNf1MEVq72AR+OIZc+xm1lFMTDQmZscJmg37m9C3JmI1l6lsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GMm/eQKJw+rQ14sDUPcwk4EWWQ3Fl7hyawwQTrrgXy0=;
 b=og292iKWDfrNtoapqHQffSofYAbZt9uBkUkrJ0y5e9bTS4R7dSiZddvGwht5BQdkdg6t4ka0oad9f+9OUH5GuDch2T2isUg5CmRCOYeD+I1XrJ2icbRfofCWzRMX5KRoYpvP6he/u4CBJQGIQmhPw9YpSAWlWJpKMub+yewzrWvYwMRuhJwqfT+RNS6pe2NlTY3TEkRvRlLZh3F40mIXPmAFpJs8vXs129nihVkJmlX8NIb9ACHcoAIk1+tyv9TVuyks8PUNHH2NJ0Hly9Z5egTdQOGWZZAxDm48g92M2QvmJQQ0e7qhu83Ac7Px6IO5MXowKZ0AtCnt2kT3HZl2Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GMm/eQKJw+rQ14sDUPcwk4EWWQ3Fl7hyawwQTrrgXy0=;
 b=hidfG1QVmqWexBpfen9eGw0zrmVszL2c6O/SXZh3RlGyzF088xCgLnGP14QUxTPCic3Z6AxKjVejwVNN85+8Y+Mz63of/Ooly9TlanVvXH+2z8pfs6/MBD2I8xVYkDxyWRBcVUZieFtZx15jXBUvPtwvg88YgipdGag7AnqKhkU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 23:33:57 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 23:33:57 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH 8/9] KVM: x86: Add kexec support for SEV page encryption bitmap.
Date:   Mon, 30 Nov 2020 23:33:46 +0000
Message-Id: <a176837742fef70cf8fe911325a7d58e9befc2a6.1606633738.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606633738.git.ashish.kalra@amd.com>
References: <cover.1606633738.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0003.namprd04.prod.outlook.com
 (2603:10b6:803:21::13) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0401CA0003.namprd04.prod.outlook.com (2603:10b6:803:21::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25 via Frontend Transport; Mon, 30 Nov 2020 23:33:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 94611639-dba2-4603-8b44-08d8958868a6
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509B3396E7559DEC14F3F3E8EF50@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: adlC/l5qxO7c6cGIWpItKLNoblG6W44ksXI4Kdvj2LgyO137/IGBdJL0JsjWu8RkEySmKoK9NOB+7E20hdNGaeHap+Jr+z0UxHl7Xmu0Eusf+FM/CSoEWeYo8gTB4ZQx4mnp4uyhysWz6bU8sueQLOOaGrnjw8crsXVSDc+kDw1byw5DhmT/X6EdNFg6cMG6v+VjE85N3EKiGeEhS+qCV/smiCzme3bwwXMXMTxZlsNsuwFY1NhgVeojrm2jzOwgaLFl2+3kZr9Ih62rywp7lyL7x0fVtJRcCqJ5VOdxZ3WBosSe7g7DBAX9M+Ov3uvrNMyBY5fduJJEUTm0rrbg9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(26005)(956004)(5660300002)(16526019)(7416002)(4326008)(86362001)(2616005)(186003)(316002)(7696005)(6916009)(2906002)(8936002)(6486002)(52116002)(8676002)(66946007)(478600001)(6666004)(66476007)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Lwk4eioi4d9NSJ6eP0clL9xDytpm0lTkRV4ap5urtI8REIWnFcDiPBXzANx5Wst5LiedRL32T+FEq6CwrJ6aA4onDIL+Ay4SOBTD2uWhUME8NmNXvZzZt7DGCpFJrrjiQ8uI9/s+PnxXLzH1U5ucWfE3vdR2SHe1XXz0UyPKYacfxyZfVPE2G9IZlSMLSO4juG0Kczt4GimY3zrezYYnE+QyP/KMVBTZD6pahCYrWayTPN9IJRruwwbJpnefBuNUQu2u+8y+733GZBj4975qUAHjxehFPNp5XeYsNBXQKuUJm7BQ5ue7yfJyROoUPm3KiV0bwddAvTruvzS8+Rm1kMNx+eIdnEy8AMs+SmtbGN0HeB5tvZlGU6ZWVnTjFQ42zebDaeoXtZI+jKCxF5ClcEfmtVbkXU5ob81A+Xs8yNIRgJD5NoD+z88sgcbuzmkYJDy59cnML9S1lDHNkSsmHHlk5aPvdhFug/jf3aV6udDKO2vAKh3plPc+P7+zUwy679+j3u1PthBLIZUg2udhT4dOB7MrCcxuM3KDY8wx6PF8QiDTxNz+k0UtS0SIsHaQ0bm0Pt98iVMZ2TOR9SUBA0d2AEg181DYpMOXL9KzAFxYW3WtLOeVrmKYS7X5KHNrM0w/WxvRCKC4I8QfTMp/HvUKAHYcodDGp0kLHIKD82/4b3HHW4cP/GNXoqhAhcuWFlZawrMLLHkWX2IVQp3G7G2I0SGE3W4uOnMX/f9AqaCIh/+ph7v4AaefLpJRJQTp
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94611639-dba2-4603-8b44-08d8958868a6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 23:33:57.8250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nByA6pYO+2XMuK4zM/U6EDgl7y78Kwo9wj1raio/0bPJyx4JQAZl33B5i91Ltl56KDNSbOpfvqtHwAMFsEjdLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Reset the host's page encryption bitmap related to kernel
specific page encryption status settings before we load a
new kernel by kexec. We cannot reset the complete
page encryption bitmap here as we need to retain the
UEFI/OVMF firmware specific settings.

The host's page encryption bitmap is maintained for the
guest to keep the encrypted/decrypted state of the guest pages,
therefore we need to explicitly mark all shared pages as
encrypted again before rebooting into the new guest kernel.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kernel/kvm.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 7f57ede3cb8e..55d845e025b2 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -38,6 +38,7 @@
 #include <asm/cpuidle_haltpoll.h>
 #include <asm/ptrace.h>
 #include <asm/svm.h>
+#include <asm/e820/api.h>
 
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
 
@@ -383,6 +384,33 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
 	 */
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
+	/*
+	 * Reset the host's page encryption bitmap related to kernel
+	 * specific page encryption status settings before we load a
+	 * new kernel by kexec. NOTE: We cannot reset the complete
+	 * page encryption bitmap here as we need to retain the
+	 * UEFI/OVMF firmware specific settings.
+	 */
+	if (sev_active() & (smp_processor_id() == 0)) {
+		int i;
+		unsigned long nr_pages;
+
+		for (i = 0; i < e820_table->nr_entries; i++) {
+			struct e820_entry *entry = &e820_table->entries[i];
+			unsigned long start_pfn;
+			unsigned long end_pfn;
+
+			if (entry->type != E820_TYPE_RAM)
+				continue;
+
+			start_pfn = entry->addr >> PAGE_SHIFT;
+			end_pfn = (entry->addr + entry->size) >> PAGE_SHIFT;
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


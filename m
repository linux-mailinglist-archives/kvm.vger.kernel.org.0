Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B142C9445
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 01:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731101AbgLAAs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 19:48:57 -0500
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:4864
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727940AbgLAAs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 19:48:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsr8Y0EOF3fiUrlon3vyA3F6Cz0lZN/j8an23XZ0bWimunv6L7rZ8THpXkZP7tNAm+w3FiDNvhG4lfsDDhd2X2Xc3kUE5IHZHttveQFajw4l85GPlhDZaiwCLMFedaif5UXDK1pkVWd46xcTy8MCJ4QFgulFv6zOsHKJBWwjnwwC3n1QjHfc6jSOYUGf/h5C3I8vwI3tZsLnrGB+MfPrYmB/joABf1Po6mQZe44/XFyrGTtXHDKgKcNpdD0SksQ9HHdg8O2Ih2wlj2K19ZZlbhX+KPhLdugJWF76XdtubRZjvrw2Rn6OL3PQDGjtlNav8hMJ6BfBTir9Z2P5nGkX6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVG+eUxGHSAHvJ6FCq1B3tjxHdMSDf14B/hANqfY+IU=;
 b=DudJVlEpMAiU+s6RaUWUP2QrGisW/mYwoJl/pmmG7Cd4uSt+bFOWBVLbXd2ny1h11Z6B+RFCmRkDReM8nPdqO7rrpnmKebiKV+gIyFknfYHcfv0aZG9dqcTKUp7A77lYJGj9DroTMqJdpuSO/tcdPIsuxSRfANVOYw98u+8WniyX+jw1i4Sh4Q7YvxveC6qzrCrpcc1XouzSqqSK++dlDZvY77MrtU6XZORoPA7ENyXjIbrDBcfci4EKqDRNF3/7bIII7mbuB8yU9MMMTRnfOqvHTo1xtwPCc8jh1lIVVmx9kD/24GRVcj4wMJtFwBumb5ZJ2i/QldvRQzmo9vcw9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVG+eUxGHSAHvJ6FCq1B3tjxHdMSDf14B/hANqfY+IU=;
 b=JjtJ9NStxsZNK6LtF1/6ForDCqcZmR4PpuvBUB50dK+QIDw0vQss29o7LakbfZHnJ09fEF1kJZt0ZdwDe43xXXxuWeVVy1cq0gUFgm0ogZLmOktGLf5PCvDhcWJjdXWXIYXHAmYNVbjGnbOqybSy16WxL8DzYyqWYBcxtuvMpiw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB4751.namprd12.prod.outlook.com (2603:10b6:805:df::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.24; Tue, 1 Dec
 2020 00:48:17 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 00:48:17 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, brijesh.singh@amd.com,
        dovmurik@linux.vnet.ibm.com, tobin@ibm.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH v2 7/9] KVM: x86: Mark _bss_decrypted section variables as decrypted in page encryption bitmap.
Date:   Tue,  1 Dec 2020 00:48:07 +0000
Message-Id: <047c39df25282c07cb3180a5c3a63f27ec8be134.1606782580.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606782580.git.ashish.kalra@amd.com>
References: <cover.1606782580.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:3:93::19) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR20CA0009.namprd20.prod.outlook.com (2603:10b6:3:93::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Tue, 1 Dec 2020 00:48:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 21497cef-338e-49e5-adb0-08d89592cae9
X-MS-TrafficTypeDiagnostic: SN6PR12MB4751:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4751C1E8E1AB09C6CA4A349C8EF40@SN6PR12MB4751.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ScZbNw6dhzIMG2YE/23P0CDAoFHNcO5LEeWr7DhJCoo5SmK/IDj9flHL2v9Dp88Z8AUA/AUHB3o09cJyB+K3tk+o1eyBHBX1YFEvRN65e6w1eOXdnCf5+tR20QmLUdm/XHCH6FkBI9/rSbOc4tuk6CjYi7gsOouicmTTmXd6HTp/eb/Y1AGBJPmOcaw0DgFzsCcIg05YvAw69p4c7zIR4BNk4pZJ7F0rMZ7vz1OcZ0CmNWY9rjX0NmMlPFah3QVhoBLnObL6a1WvCqBjSHONLEiS368BJr9SzZy5PyxSzdHQaRlAJLy3z7jCn9Nz3TCpFra94VmdFHp08MHSyI9nmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(83380400001)(6666004)(186003)(2616005)(6916009)(478600001)(4326008)(316002)(16526019)(52116002)(956004)(26005)(6486002)(7696005)(8936002)(8676002)(7416002)(86362001)(66946007)(66476007)(5660300002)(66556008)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HovFRfkOk574YP1G83wgF/fRppQWxPsvwvZehONwRCrttqGWhC/bbcj079MN?=
 =?us-ascii?Q?u904CkB3iYsDUycJBnwXecMMgCgTlFR8fg7dDeyQcfm20VlO6DJyKQ1TpD2S?=
 =?us-ascii?Q?dEPqc9bgNefGyK8U8WTFv+OsSnbfrn95YKCINBBy68W3QcqbM/uH83ydWIYq?=
 =?us-ascii?Q?2GySUR0PbiiJmIfSOD+zPGdNRBymZkW0cTE6dxxCSAoxfG7xfK7WFdN87gnT?=
 =?us-ascii?Q?at7lptO6eDlamoFsX1dsd804fxF5tpzGtgFDlgyakrKFOoCJ6g0ovSKDEqAi?=
 =?us-ascii?Q?Zawtbg9JEwIdgC4SUatf0kjenlgBbAKvcB8059URJxJXOji/0mk5N+9IrLQN?=
 =?us-ascii?Q?1rbSXKYiZs0PzNrPgO0wtfBeN59/yvxC+p+BftbKMyI7U6sDKxkZxz9o85xv?=
 =?us-ascii?Q?MCDvHDcdSqiZ+OrvAmGS3K2U1UGyES2x5Q3jvbayjd5Ih1GbWhcr/qd2B5xn?=
 =?us-ascii?Q?2ws5TcSwJ5156y1rVc3fJmvFv/vYLpwJmJ8ha7RRMJCw/WoiyOSxv9a8shhh?=
 =?us-ascii?Q?7Rjutzow06clbaxPp9n5KXX15bNyX9W5JJnYa7ZauACHLjMtfcAAgGElrxhN?=
 =?us-ascii?Q?S2wAuXSLkAR5ramA9T34yangcsu5WWEJFOL1Lk2/3ADUQjQA2EIoB1GjL9jl?=
 =?us-ascii?Q?IDE38ScrYKmWLldqC0bvIfpFjHQz4zVGP5YmqceCP4wM5uXmROqsA9zDyluD?=
 =?us-ascii?Q?4aVBtS/f/FrXUNYH3ihW4rZIc0xnQ0nktwrX23kTYteQ+RP6t149rkZEh7L0?=
 =?us-ascii?Q?cInEmnQyl1HND81TfKYvl81/jaqV0mG5n9cYszPTw0khrJa2KHBElnU0xb/e?=
 =?us-ascii?Q?aSLK5nyQO3OD2/NOB/LbkWq94go2MbsG+/KsfO7MZpS5XiN/Ee7rWm1kKpCh?=
 =?us-ascii?Q?f/YMrRHUzVvHrt+APW01AH4PIRMkfdOBkEADQvivYiMGn21N1GkybzaNw/oG?=
 =?us-ascii?Q?GXR9ZqEMsLSlXPHEMk5lPKC3tqOrVaM6MMNuKiwxB6Xlt5I+oufoyxRIsrj8?=
 =?us-ascii?Q?AZWg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21497cef-338e-49e5-adb0-08d89592cae9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 00:48:17.6800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zxAltgtlvbQbFer5ZGclx4pjMkeqGPTaCns3ZYHNSYuL4C0v9bFUVWZFkczOZ9+/DebeEx2aliZiUI3X+j9fIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4751
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Ensure that _bss_decrypted section variables such as hv_clock_boot and
wall_clock are marked as decrypted in the page encryption bitmap if
sev guest is active.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/mem_encrypt.h |  4 ++++
 arch/x86/kernel/kvmclock.c         | 12 ++++++++++++
 arch/x86/mm/mem_encrypt.c          |  6 ++++++
 3 files changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 2f62bbdd9d12..a4fd6a4229eb 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -43,6 +43,8 @@ void __init sme_enable(struct boot_params *bp);
 
 int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
 int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
+					    bool enc);
 
 void __init mem_encrypt_free_decrypted_mem(void);
 
@@ -82,6 +84,8 @@ static inline int __init
 early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
 static inline int __init
 early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
+static inline void __init
+early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
 
 static inline void mem_encrypt_free_decrypted_mem(void) { }
 
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index aa593743acf6..94a4fbf80e44 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -333,6 +333,18 @@ void __init kvmclock_init(void)
 	pr_info("kvm-clock: Using msrs %x and %x",
 		msr_kvm_system_time, msr_kvm_wall_clock);
 
+	if (sev_active()) {
+		unsigned long nr_pages;
+		/*
+		 * sizeof(hv_clock_boot) is already PAGE_SIZE aligned
+		 */
+		early_set_mem_enc_dec_hypercall((unsigned long)hv_clock_boot,
+						1, 0);
+		nr_pages = DIV_ROUND_UP(sizeof(wall_clock), PAGE_SIZE);
+		early_set_mem_enc_dec_hypercall((unsigned long)&wall_clock,
+						nr_pages, 0);
+	}
+
 	this_cpu_write(hv_clock_per_cpu, &hv_clock_boot[0]);
 	kvm_register_clock("primary cpu clock");
 	pvclock_set_pvti_cpu0_va(hv_clock_boot);
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 9d1ac65050d0..1bcfbcd2bfd7 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -376,6 +376,12 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
 	return early_set_memory_enc_dec(vaddr, size, true);
 }
 
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
+					    bool enc)
+{
+	set_memory_enc_dec_hypercall(vaddr, npages, enc);
+}
+
 /*
  * SME and SEV are very similar but they are not the same, so there are
  * times that the kernel will need to distinguish between SME and SEV. The
-- 
2.17.1


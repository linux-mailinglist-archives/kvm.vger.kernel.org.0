Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FB92D35FF
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731441AbgLHWKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:10:39 -0500
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:20577
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731434AbgLHWKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:10:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnqM18GxsMBvS84XCF7+y5FQ6MuJZYK9bPjbm0zZTeEh4ksSjPHpnA/PIbieigv1Q1NbUJdJcMAMkO1WeZ8Lc1nOZPI/v7zzfapVWZnQQkK8lA3gghTFlRJiHm+rvwPTRoDXerV5nQavIDOBONawQQVTKEk/C58QHOAFiX/+oqS/HSwRYItdXwJOCL62MHa/MXyBQlqs87AftOTrVp+1kJip9DtlFBxvizozY6IGsv67Dy8Je8wC2U0e8pRN+hmwXjchCiFR+ilPq+mxVD8d06QVVCLZ5ebLYwwiT9q8Q4vrm1DC/4qgzW1niTd+toZ+Q/fjBZI6kT7qPvOLmeZWQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y32Jsat7mUDBkXETurjQXw1KLTgJMT3lbi/K3NLfE9M=;
 b=bCmyJduWLf1qcl9WAhiCPeGY/4q8AUWCsksoFBXw4YHL83poqgqu6u1AGlj7Z28jTbnnQb4g6oryninMVawsSl7h2PHwwDQ35f5HgCm2YBVp4VqruNg7V4MNXrAPAfqqlT0sTdhczJx9UUTvZNatRtVtb3G2Rn3006rT6MKUwEtjfFc5CjFPY5h3pb8fW/ChjdO7gUJmFYkAoWcMM9o0A1ek9HXdmLd4OsUrW0/O76P9LOJjYSXVEZLAxnnMrX96SUJ6gQCiRQ9lnZWTOhs2znj9PtSHMS3zsafrlXVwxUQbQlQ8R2ot5/Sp6B4HkzNpqlXsPIU8YPpQuNAYQPN5xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y32Jsat7mUDBkXETurjQXw1KLTgJMT3lbi/K3NLfE9M=;
 b=0p+6CVe/eqnX5gxqW7NHStjMfAttqFUe4eVbVmeIVxiTgBMIT5T/rqicqCZiJYSFGozKj7hAfY86KhEKcFdjLOh4LukPuiirM+9agrB6h1q488KC31tJpDNcCqDt/ixm7ELXLyF8LMBT+BnMIXs+4o34Ad8fd0FxyeEGeCfcPm0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 22:09:10 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:09:10 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 17/18] KVM: x86: Add kexec support for SEV Live Migration.
Date:   Tue,  8 Dec 2020 22:09:00 +0000
Message-Id: <1199f844e26c7e761c55d13a5fa2db30fc80f769.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN1PR12CA0056.namprd12.prod.outlook.com
 (2603:10b6:802:20::27) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN1PR12CA0056.namprd12.prod.outlook.com (2603:10b6:802:20::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 8 Dec 2020 22:09:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a40b1d0d-087c-41d0-78e6-08d89bc5e388
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2640CCDB8EF6AD43332A5BB08ECD0@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xzSTZGov2rpRzVs3C1TscUymXl707UrJz7uTQUskSKrqRoRmtAhpqELZ0197im0JdAlV1AVUbXpgWnl0hKFZjxJfhb2AXdsgBHvEQGUBx2+s8EI+91gTmfWMf/t5hqSkMlU5X39LTj0bTuMbLd9ytO0O1HKgW7R+QJkfrt1tQkXtLfx62gyWC2kqry7GTrN9P83EeCNIYAWzFBonLYsOcwUI8NP5A8ezZqGcZZe7FZG9epPpEYwVb3/F6h5UbqfAQfbc9aArsffyie9V8sE6R6LjayVFVhQZpIKT28sKHn26SEkYrKk/UAAIk/HZjgWSy67hfJv5Fs4UqrzubFYNhsYt1AdNRC38itG3I+aHCu64epjvI8inZakFXq5G+4ZY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(2616005)(2906002)(66556008)(508600001)(4326008)(5660300002)(6916009)(52116002)(7416002)(66476007)(6486002)(34490700003)(186003)(6666004)(8936002)(16526019)(8676002)(66946007)(86362001)(7696005)(26005)(956004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AoaYT3USW9ykf+r0nBnePZJwjRZ4rK9MIpZSTaFOLnoogz5oTASck9sobn4g?=
 =?us-ascii?Q?nwzCMw83se2VHYyK9cEgCrG82qbOMZ9/J7ITbDReQxraWsCqCxs2ZUGy7aWL?=
 =?us-ascii?Q?HO0PiRBKyCHLqpDefRH6aI6kjUIzRyWIfM4jCkkOFvEr0GtOZ0zPHqWzLCqH?=
 =?us-ascii?Q?nkN7nc7PJCjoSIJNrkBZwG0NOPvL6+Hl4rsuBiq1dZjtyr53Ogw6U2DPalEs?=
 =?us-ascii?Q?1IF7evqcxq+AiaOW+42ZuswG1EZiKfZ2FwjfyP1DIB0DmhFQY8jZM3aAoYxh?=
 =?us-ascii?Q?jknXWEj0KES7lC/1TszRz9JooCfT0WgfXH1fAfNRlbYeXRheMczPP0abCcYw?=
 =?us-ascii?Q?kklID/Cf+aFNE01r1hWmJR3k9O63YMiltk3akf5KtxGrZrlwya4gRlZHSocP?=
 =?us-ascii?Q?bCQd4g8TscdWmeQAv579x4Y/Wv9hOGaEVt7g8nNfzvtbqC3kycWOfwT8Moy6?=
 =?us-ascii?Q?tjEBSXkTGKFytM4xGjQd7u32fwZLeA69D4Is8no0a1jckSJH9e54HO8LZYg/?=
 =?us-ascii?Q?Cz4JEhrkmhVilx40MGGj6AEsMJZ5f1+KO2nsg2ZEZADKPGcbNNrzLRUOrQm6?=
 =?us-ascii?Q?bZ3jA9+ECKxdABRMKdUB2jBh2WBqZzA5+G/cEDGBx9lAUtYBV85JydRdiBo8?=
 =?us-ascii?Q?0oXeP9ftkky/q0b+vqk6XFthm0NFhKcH9zhprTytoClgVA2umpz6jtUNQeFD?=
 =?us-ascii?Q?cTq7at1dZgR0gR3LJEvQSzVpm8gMKWSwR06Nhyk96XkmHSlSnd2e07KPxM2y?=
 =?us-ascii?Q?wdVrFv+wnFphiAS8Q9gQnBERt3q7IA9f182CkXx7I/8qNp79TctIRbbKmvIv?=
 =?us-ascii?Q?EwVbB8qTTGqkLpyGtm3SZSE2/9oncldtUggQ/UpRsOSHwP6RWrS1cDhd5ool?=
 =?us-ascii?Q?C20l/3kogc/BOtR1NPAIHd1WNhw3vhEPnuViaBlCioD9tYlXBpfIl7R8GhWN?=
 =?us-ascii?Q?Gz/+mlxN6CrEG3ERw9tEfrP6cq+PUN9B7tLVxWtd3ht4F+rw7fwSjDxEWTAc?=
 =?us-ascii?Q?mrw7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:09:10.0370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: a40b1d0d-087c-41d0-78e6-08d89bc5e388
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 72OrdjIGN7GEdW3GJb3JvFylySj1ou2hNtfKkE1YhZ+entaU8qY+ztQ13LHhqmjWH64M7dNaFwp2++7eEmWjcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
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
index 7da8b6b3528c..3245ec003401 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -39,6 +39,7 @@
 #include <asm/cpuidle_haltpoll.h>
 #include <asm/ptrace.h>
 #include <asm/svm.h>
+#include <asm/e820/api.h>
 
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
 
@@ -384,6 +385,33 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
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
+	if (sev_live_migration_enabled() & (smp_processor_id() == 0)) {
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


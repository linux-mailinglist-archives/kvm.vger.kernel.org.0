Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24E435D16C
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbhDLTsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:48:25 -0400
Received: from mail-eopbgr770083.outbound.protection.outlook.com ([40.107.77.83]:40064
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237406AbhDLTsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:48:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=As6UZPsoAolH82Hsih2BwuSbGGE0ntQyEANPYnVa3+ZRDjeC+JGUX3iTgaQQjB5QsamrXdJUfjntLqSDiejQH8qd1gMfH/vk+b3PlAtk0cjmFML7sNdzLGwjUhKG+yi304FIuo75To69VUJKgqo62nyfbFKjKlXl+tmLmNQWkCFDZEOtx5XATaTW2vZInzH35dcG+h6MB/NJyW+3K7rRVcfEEtRrlojtr4e2DK9Dqsr8Lo9zKWeGGhkstQgPmbgHx5ly9mjaRZDph2EJAyEdd6DImL7ekwFUjCuVXvd+2hsCjAPEAJkJ1gIR142v8eweso9mPPmcomBJmlBSX+6Xkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMFsE5kyHk8b/BTrnc+Jh1LeIka8vWE7qzvszbJdnIY=;
 b=mjlG+107amHOhvRAlhj5suxm7CaglliuMqzny0+S9OLLX8W/hwNq1+sXjUrT/JLNKCmThgilWHB+bpngqka2BjLMm253PrqGhSY16kpg7vymuUWKvRFBaSkeIxoAYWhUXDndEmplTLPp8MPeHCq+a2hor6CzlN/u15OfwGjOHUedUlj3ylvPCnRbQav95eXxXLqCXkQ27nMqcq/7Ouu9WsfRNvbrfqupnFJRXYtGXuG5FGczY7Shg1RMYb7dfUJtK5M4BfzDESakz5lub+4MJ47XzQ8WYJPZ35RQdulEblz6VDkbzEtOqm5k0emWQuSwMNmEBjAVPCPQHPc4xbBJ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMFsE5kyHk8b/BTrnc+Jh1LeIka8vWE7qzvszbJdnIY=;
 b=elfZ7EUZl4sofAtDITy+IJAt8x6JXpMJMlAlpQ37MiDUPYpahWeXRqBC2927+ib1dNN8LMj7bvbDhjdXrb183x0aOabrNNAPcmcFY+Ue12JnK9yq5Hu+GAQzyHsqj6ifC2F5EvsKh3m4vDEh1a/RqP0VqGzh3Z2RxBZ9cKpjIPo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2415.namprd12.prod.outlook.com (2603:10b6:802:26::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 19:47:59 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:47:59 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com,
        kexec@lists.infradead.org
Subject: [PATCH v12 13/13] x86/kvm: Add kexec support for SEV Live Migration.
Date:   Mon, 12 Apr 2021 19:47:49 +0000
Message-Id: <c349516d85d9e3fc7404d564ff81d7ebecc1162c.1618254007.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618254007.git.ashish.kalra@amd.com>
References: <cover.1618254007.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:806:f2::9) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0004.namprd04.prod.outlook.com (2603:10b6:806:f2::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 19:47:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c70c258-1d23-4b85-27b7-08d8fdebdfc2
X-MS-TrafficTypeDiagnostic: SN1PR12MB2415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB241502C0F3EB6EEF869032208E709@SN1PR12MB2415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X97w1zOsn8k9dPw44sHZLVej/MdKKH++6KhTGngXkMoHKuBwwCwdlJTq/L2Q8rn5RW2Zt/SiDIaAeOWdzLjE2tzl5y8QGg4atcV118zSfkbYM2n5BuY35yQTAmc09o3V5kv6olBQfyHgc/hTAc0M4HMTgVbbafH0UsaECs4XcfSibPDM2gm2nCEaHMLbdSBlXoyc5HfjMBTuYkBrd6p4bSg0b2jFSJOaCmWjGPk4Vps7TYxVpmFq6TzDfo17sF0xQEavh3RzFGKRHcLQd3W5qL5BanelE74S8QGClSCJoWFw6C4F/OfcVjoG48YScKYFIm3uEYK+VBbVV37MquG7PHbrQkKf4oWNR8HdySjHQASs4CJS9+Vpn4vxUnJ9a8LYuUlunUaVWgN94APw4EjKJ1wrJ+RZ7SCIit8Z+bu1uC4TvXWmjibR4i9/QSWlnomyW4aRhZNKdN9ldJVJcYB/k6c7jHd4MxcJWfwLBV/oh5iHKohtE1UlJb0+QPkw1RieELjzcd2adv49Ud4oP9g27lMwBNPdWksspi1iz/I3dbmbUHoWpqrlbygx0K4PQ7mC+dszjOFf0c+nsyw70iTZOjuReaDQsNYvqkBAf87xc/W3i6U9Efk06vLq+xQm585bvjQZdVHyES5xmu0uOrOjIDWOJCZv7DwGHOhYi2XJSMU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(26005)(16526019)(186003)(86362001)(52116002)(6666004)(956004)(2616005)(2906002)(7696005)(6486002)(66946007)(66476007)(8676002)(7416002)(36756003)(6916009)(4326008)(478600001)(5660300002)(38350700002)(38100700002)(8936002)(316002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SG8qyNU1gCMJIQoYXc1YdYhdDv5bhe0yFw9IdsO/9UhAPSdWlvPUDD4mn0fa?=
 =?us-ascii?Q?ftsgH1PeHd7yZBvHy+o38d0g3IQEABnpNoObfKTqSHp+xrbOjMQf6ZdxljPA?=
 =?us-ascii?Q?C+8SgQwv9e90nSyGyYfiX3rx5f6z+bLlRgyGzdUlV8NFbPTwfg291+eJb6VP?=
 =?us-ascii?Q?/pbAEoZt8dvMVBOdsq7jFgLmTKLK/+ZDcBIMomtzUb/ar3qMC+uz3h1OJ+TJ?=
 =?us-ascii?Q?WKOiAF2hn6STXyrI5voAqXTByYO3k89cFS6bka8DuTk0k0uFUJIL6SYFPhoi?=
 =?us-ascii?Q?on5cA5ZVWkUksyzlT3nByM9Y0kBGgTFIrZ5QplDujsIRceV/ZDO/I6rvXqA7?=
 =?us-ascii?Q?whskCboZLy6e9FxgkgI4iNtbTm8aaMf4XJ7IdfUFlLqRO9qk9BwFow4cGKn8?=
 =?us-ascii?Q?LgzaQ+ae+Guk1ED+4v08ooxjCioP3KXQuCfvwUFuMjj7sTVTqzcbeqqtZ9Qv?=
 =?us-ascii?Q?r9gn9802SO+5ts24Jw0mOxJKDyszB/+2eXFyKbXhbMJOnTLzpSUme8+DOBuH?=
 =?us-ascii?Q?BdYwjT/NabVNvPi5CmuM0eBxntaCZhRX6zOWsz6VqEihh2ctzrpdByU0gl04?=
 =?us-ascii?Q?HYeaFcguuVaNz+vNTxfv1UAMhcCJ3C5hR67wBsd22pilfkQxLBI4CYA0QD42?=
 =?us-ascii?Q?oDGNatwKGtIqHuQZTz0I47LEdQ9kdWZfsmYpgzFeS8xQrO14Eev5kVMHqhgL?=
 =?us-ascii?Q?SDcy4rg4Li+AUITNEbUtDJifE7hqbGJp6Z7T29jXzOTcBn3Vo0Li7wJlbgD4?=
 =?us-ascii?Q?vWtH1HVN/Bc0DTui9gKkG/1rB5ImjIjGmb0Q4Vxm8cFYxZEYPq/Yo+U4Ai89?=
 =?us-ascii?Q?oBWDfc4Gql25ofaQLLCroG6EVd18sigD1GKnzKRPDp2fKNND5VivHLFy3YvA?=
 =?us-ascii?Q?HWTGSZ1i6xUiHMI3ua4nzW/ZTvRnrQNEPmi7D0ShVk/0IdLzkgdHB8pBGGVv?=
 =?us-ascii?Q?0Wbu9IeNXhFek2sn2WoGdaqACAfmXODO01oYCNj7zbHAxVMxEQiJJbQ7ixW+?=
 =?us-ascii?Q?6dsbYtSoFqvnsEvdDI/LUPoHnZrXXurCPvu0pjFgeXjjIB0Ef3B7bE97Z/Nz?=
 =?us-ascii?Q?bjz1URx9sQZjbd8IwFlcRAtkgmoWyoOPAoplvbvcKhcfx9Dv0kBLl3VmUzKa?=
 =?us-ascii?Q?3Aj2XTJ0yiyg+aRQ8b51IL5+IoFZuVRHvCyO4rjFG3BncNqGoE3PaKTGmOcX?=
 =?us-ascii?Q?QxvC/V+nonYRfctQoRixAwwGyyQoS/UKDcnSDDhzDq8t0rrH5ZEuUbaB6Aqa?=
 =?us-ascii?Q?/f3znxQbdm0Ft2elAv+j5Q/MSYDxCfdLN+K1IyGsQm8WHMKdjRdCJD+cW3dI?=
 =?us-ascii?Q?NHA3h2Gri6ihmRW+6kOLQaz4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c70c258-1d23-4b85-27b7-08d8fdebdfc2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 19:47:59.4015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lgzONNw0cC8DKx6QldL6boJBGcnSg4Xncte33uYVuZd5TIL6A7NfUIm1C1cpqH85T+As4WM+8nW1ojnbfx0Fgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2415
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


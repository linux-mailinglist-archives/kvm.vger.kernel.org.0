Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B3930E8EC
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbhBDAm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:42:58 -0500
Received: from mail-bn7nam10on2071.outbound.protection.outlook.com ([40.107.92.71]:5024
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234292AbhBDAms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:42:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZadKX8P/igw2ZHvJIMZ5u7MqvcscncOsAaI2RXAB358PdNijjx7F7VUgp/D2xEe5c3nF++2xMlgRR8tm7YxoQHbWSxIC67/MRx6hMKV62FOs97CxQ1m0HCNuMicrgA35P5kNK9S6IyiEljUKtmY/v0k8bs3GUnXwcJQZf1kEZgemYlP+UWwGwPCV3GRprlQ+t2tAB+jdKgOORjUQPLscWB2AXiuPFRvef7z0IrrXDjbZw8y0Rz7QHk9ajxn0MAcHBJ3QgML/xc9jQ47IMVsr4iwvgb361pBQUoiBCLaAo4uVOGoK8Nf25iwB2DHbDHy0uIJ+1G9ZlA9IUrF5Xzz3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVsZ6f30A6ym2d3RuBlKkyWNYJE4Ap9qCyiyezbM+18=;
 b=eLYP8LSLt7jog0ZEkxIb8656AkBu81XHQRu2bUH2whYRU7XtDZczOyYnKSZGjB0hbQk0WJ9H6AQkjgAvbyiO7tLkxlncYpB29QNGFzvw6/cmAa3BaDuPr4K/Q2l6cz3u2RWi5zltwBZO81TE8hcZujbX902zss/UnE/DelCuVLZ4p2/1vbi6cstdZXVaTGWW4M6w5HaHqwozv88f0BuJN0VUcodcKid3YTPZjz0DeBSFzPv86Cd4Snd7eiMLt90mj9sDkq6ewjgbXGtZODbngLT/hNnohI6OUXyWBOVEf8zrKniT8JVt3rOdaJpC7gnxdIhCf2EzcJKWhLIR91uiLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVsZ6f30A6ym2d3RuBlKkyWNYJE4Ap9qCyiyezbM+18=;
 b=hlZd4nCru+jA2FM+jvdR3JdSZqv4Xi0Us5V2K6ypld3BrEtOJjvXEOnO+mH1NqTRG3TW2uoIvSK7+XjeAG+Gqv0msty4sHYvSUcb4C7s/K7VVA3BXXUjhkWD7KcD0hq3CRGKFwLR7UWpvJVXDKiFx/Fhi3QmuebdvarXIPIwgTM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:40:43 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:40:43 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 15/16] KVM: x86: Add kexec support for SEV Live Migration.
Date:   Thu,  4 Feb 2021 00:40:33 +0000
Message-Id: <11de0243f7991ebe2b6a2acd4992cd7dcc5afb61.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0296.namprd04.prod.outlook.com
 (2603:10b6:806:123::31) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0296.namprd04.prod.outlook.com (2603:10b6:806:123::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.21 via Frontend Transport; Thu, 4 Feb 2021 00:40:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4fad794d-243f-47d5-b733-08d8c8a58077
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB438489F3BE4FC1BEBBE077738EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 44rV3XQjWoeSahV5L3/l2PjNuQ04ZgkevkN+kUywZgs9ZNM154GvXyZHvqBN4r947WvYi6uQRQaeLqL88YnHR0VtMHa9oELFM9bFE/ZfU0dOcMmnNPDj/0u0Aqwxgzu0Cv1T3bNyLQq4a0cTt9j1WbqRJh77+d8aCneIcQmcTSaCDKGh+9mcRBD02hxY5816lGcRCN8q32cqKGFB7Qm9M2Bl2dJk/KKEH2wU/Ww8SWxwLrOWm8+bOMC/roHybmaeHiiIYvOnxpDDNuVG0bNkGPrY/AJFSDlniOKg9umZlVjBeOgoyab/hU1h+nLoS+pCsDIBqFEiKUCBhYJG8Sq55uWUNttVY4658kAfsa3Menc6MO/w2XISUrs9xd2+tRzqMe8FhWwASfmdiT6id9SYkrbogI3CdbZmsGvcu/yvtAiRvd6kqF6UV2YijTeGczW259Jr4SyhelwOWNr+4xDu6g8a4uWw/cVuz/26pBwwHj8yOog/Jj81JiQCtlhpqLos5SZ5YQ2/i048sPtKq0Dngg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(8676002)(956004)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cKcC+FpQLQbevJTBZtnsN4Cd40MPxjOMEK8kt03k9kvsVLwZ/Ec+5Daqhb2p?=
 =?us-ascii?Q?5U6vxL2mVavr1u1HZRCh5C+I7btoVgZO4Gf0LWje/CBQOojBFDMIX1cXHef9?=
 =?us-ascii?Q?TuhWQmakq0f9/Mh4lJE1yj0QfnkKRzAgxpTFzfWwrZsDB213uJ9Yw98Vn9Ko?=
 =?us-ascii?Q?/utrNKbg3mIjE/bbQvUaAN+Hlvg5GpzgQwU575maQmjGXstzQ5TDXJqox/A5?=
 =?us-ascii?Q?WZHDTWYKIzk4/chAVsTX03vEOB8cwUAg5qBksy1vfWie5fcIF4mFemQ+oluN?=
 =?us-ascii?Q?zz4ivExUGSSyKqpzRzBWSqOcd+yI4HOn89FMUlxk5suttdQLTARJ0EUcww6D?=
 =?us-ascii?Q?v8clufuh4CfQKO/qUjy7nbNUtsVXp+YzR5xMmutuFDjq9QEPbKYEagobGoKr?=
 =?us-ascii?Q?P0MELy8O1xs485fgET44oWXpWgAibI+lsUG6hte82hfX/6OG+W4JacDgIPp1?=
 =?us-ascii?Q?WAySXy2IBn3veFpoctdmziMbu8NXLalXD/rO/8OXynl5VdpnJzHt0NqJ8TQV?=
 =?us-ascii?Q?X9GAWSrZTD52IM0hkM2w1VkhLYx9/kWc+JnGXhQ2UHnEzlSirCYpA+cSYd9r?=
 =?us-ascii?Q?2p6MoTOobzeQUhieQmyqecKy6lvm2NfQ8wz+xTHhnFB8sL87LDRbFH7hV0tW?=
 =?us-ascii?Q?Vd2qhc7oHgEyPBj9p/n3lEhH0W5TZd+l4jDihnrGeg5w+G9SqH0nPObvU1B4?=
 =?us-ascii?Q?1OHDLrhgSqKHudPW1fmSnC9bX2HlPgxvlgNE/RvkpvuJVkPZ3i5hlZUd6vSK?=
 =?us-ascii?Q?jI8Jw3PjS0oJfsp4fHHnXsd/i8l/5wIk/TBwtlDJYeF1ipU75DDz/qaeYqp6?=
 =?us-ascii?Q?VUkm536LVXAzjVpPQVGtGZeyz/UeGEGRY3UiyuE5ZH3vEryugt4hizV3zLub?=
 =?us-ascii?Q?SMcHY9wCWwqlOeyqfo6k7yBmVA9qX6f+DvqpNIs3xaSy3RelQ92AorbmRKik?=
 =?us-ascii?Q?1ZBonOt6luwlE3ziiQhyOamk7yZfjtY10pObaZAsyuZ5rSfe4Fp6fjh96II6?=
 =?us-ascii?Q?9TNkXcyBXEkmVTv845F5Jj8rRcgwrCE2/ivBbi3ji97thnblhtSySj9H/Hyo?=
 =?us-ascii?Q?cFMAWVUqosq7ROnNJh4dSSW89I8lkz4461ddEtG/60wcj+Xq2nMqcV/KnV+4?=
 =?us-ascii?Q?W05jOFjF0WvdCmn4z8pYfSHI/fP496EKb8tos6IjTg7oPu0PzQfRm9ZC+ehp?=
 =?us-ascii?Q?2q7ODbwD0SBVMy6FK6nsvk0eZsG4OLF6gD4fyZvMyaArBIzMtEiGpCIKLmcD?=
 =?us-ascii?Q?OOi+DKVewCgi08SfwTEOdL4TbpI5pmHonwli6QMnYMEGso/KQAvD+WEEMaKf?=
 =?us-ascii?Q?V5NoeF6OH+Wl+HRw0XbYQgeU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fad794d-243f-47d5-b733-08d8c8a58077
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:40:43.0249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cCTcsq2PBGdiJmUWnKH1ipQtZ0pgP4WApxDMr4H/RsM7j3mCIWOST/67bjk6IuRfaPaMTkANHrS1wFZLrz+ehg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
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
 arch/x86/kernel/kvm.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index c4b8029c1442..d61156db7797 100644
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


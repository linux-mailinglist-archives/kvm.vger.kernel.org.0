Return-Path: <kvm+bounces-18683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 779108D882A
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 19:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E25F01F22833
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 17:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7DA3137923;
	Mon,  3 Jun 2024 17:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rJEjuxPS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2087.outbound.protection.outlook.com [40.107.102.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3342B137902;
	Mon,  3 Jun 2024 17:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717436664; cv=fail; b=UdrKuGSP9gOoyUxhWWy7GtpDHU/sm3jjSaiLEQqVl7UQpOpkGT9K3Ia1YO09hL80obUd5G6yN7jbK1NFdboQ9nrtNenu7BblOOHPMCpwRb9KG5mXO0mkkNrCKI5OiGp4nMXx9tk5s9JXHuERl9gcp/4lZdZXy/S4zcJpUzpMUjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717436664; c=relaxed/simple;
	bh=cUtwdKFD3UNzkylrkHvpAGJAZAfWUo7hKjcGq/I5kH0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=R53KahjyLgfkT+QUXwOofSgmIdAq8p2qH4YGT7tb5yd9alF8aWYeTG8OBV9GuA7auO1XSjWSMSCetR3/xNsukpbU1ubRFL2uJVzXpcTVv84Hmh0icKO6fvUyNkKRSbh4nFFLJb07pkBx74qyhSCGjIKHTmqiXBcTAu1gZU/Hgoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rJEjuxPS; arc=fail smtp.client-ip=40.107.102.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjBU400UhOFqy+72QNo2W9kvbh20a5kqObL+zEYyJjz3TDayrXOzJ/SF4I6jZ6/cosJ26wb4DfT8XBK6Vc2THJOXmPp4DfWnnlvelQo/J3SeF6A/wkw8p5vfxWJKuJ0cFQ/Q68Heu0HL9jCni6VevPU31NQiGeFIPLPZ5bEjuldo+1M7cMjHbntBA1Eh4wYlfUj2Crv9YhP4ZgoWnYfm8BJT0t5BonmPcd6ySGRWrVrMb4KbZHCxUAuxQCtUYM2rzx0T0jeoPzdK8tR5kgLrwVkC97GqEs8DBMRP3AG1WKRiAmQZsiHpIZxXPUOr4CJjmP7YMUq31w+qiNbsSl7I2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V+P3YP8tuegFismlMf5tLgBjNPxX36gE5ANEY7VrZp4=;
 b=lOz5Zld8gnboSTooxN0dNSWCczsmuV8dznYFm1QadK0a5sRWYb2oepmCNorZusiD8GIAqfdBlG+7KT9aYf0A3iJnOLD2YYfDdGLJhBE3hfxN1E/tvpeZFN1FlOJDyyoY4qac1kJtsgO/9qxLR9eUo3hWNsQvVWG5LS9PpLxvDYzcH91eL1CmkRiIe35+z7bmLPywXdu3rxgN4RILURij8Wrx1kDz+4fmXCOwR/9Lan4/TFF6K8RGY/B62rej+hB0x+DIHreZNQvEufwN0aGnXP4gssVqu8FeBQAbFp4v+gc15hfg8xIwY0PZcbkIfkK97uEkzEszq5GT8tzXkQKtbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+P3YP8tuegFismlMf5tLgBjNPxX36gE5ANEY7VrZp4=;
 b=rJEjuxPSPV5h8x1Hk7e+V+jo6MEky9b8uvRcr4E9hMbdxvR7Ef91KJPDL1EOfOHScwyGDXToUOLiTCDLinPL8/ru+PI7gWfV2Ati0cpFM0eyb7oDGb2RFPHhUgJOixkBWMfXLyqPm6KbYnmYsLym2wGaeNSAgs4q1ryFLdHp7pI=
Received: from SN7PR04CA0013.namprd04.prod.outlook.com (2603:10b6:806:f2::18)
 by SJ0PR12MB5663.namprd12.prod.outlook.com (2603:10b6:a03:42a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Mon, 3 Jun
 2024 17:44:19 +0000
Received: from SN1PEPF000252A3.namprd05.prod.outlook.com
 (2603:10b6:806:f2:cafe::60) by SN7PR04CA0013.outlook.office365.com
 (2603:10b6:806:f2::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.30 via Frontend
 Transport; Mon, 3 Jun 2024 17:44:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A3.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Mon, 3 Jun 2024 17:44:19 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 3 Jun
 2024 12:44:18 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <babu.moger@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: Fix Undefined Behavior Sanitizer(UBSAN) error
Date: Mon, 3 Jun 2024 12:44:13 -0500
Message-ID: <98ad0dab3a2c66834e50e6d465dcae47dd80758b.1717436464.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A3:EE_|SJ0PR12MB5663:EE_
X-MS-Office365-Filtering-Correlation-Id: 56403a4d-5a4d-41f2-d837-08dc83f4cbd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aT9W2CDc3G3A9wZASqSwAlr85QtUXws2TvKi5JBIGF75V8OB1ZzqJ/VE8Yhp?=
 =?us-ascii?Q?emHgnjQSbbV2I6hm9W1nKLqLlX+3OFatlvOt00ZbAcgrQC30guMNolgJksAz?=
 =?us-ascii?Q?NOpuU2BSRPBdfk6x+yUyomIrJo7m3J/ttuPymHJz1pL0+ZY3MytLvueQbgds?=
 =?us-ascii?Q?Js+fyVhPfoEAvq/6tDe20oP4tvPxWVAY+pI4fVEeUso5liEixn/7X/1L4GDs?=
 =?us-ascii?Q?ArMwp+xjnE8vfv1Aavzh4x7wo+0+g1em1PRnIeDhLmC+B6iqJylt4d1cuLE9?=
 =?us-ascii?Q?kg0LySxHBPKOuJeoxW08mTL9VMswpIBdPSYLxzjO48AMbVqkybq2AfcFxJrg?=
 =?us-ascii?Q?xMbfiPA36dwiPYLd2LcS0DjFjPy5ik9fJX3KBrNmWPzTJdzT721MlhlFn7R7?=
 =?us-ascii?Q?Glx/bCXt2Geei7kFZXNuZdvbbr1PvaQlMtE8vTaxV/SOgqwBo4PPKILX2hhQ?=
 =?us-ascii?Q?zUtR0rI4A/QFMJ1XRlKSx3bB8/riKQ5HMx/I2jPyfxUT7Q1bnoywHLA/LLzN?=
 =?us-ascii?Q?Bwj/HtUbhfkr3Pvc7S20B4iqu6eDScem38d+S+Wh6K5yuGJOOtzL6de4VMb0?=
 =?us-ascii?Q?tRMieuHgnV+Pxh09usqF/L4zgrrLtTpEllFV5P1p2XiDqrD2AkgZGNO7BzWA?=
 =?us-ascii?Q?IWWBMBsBnM09FGdjGSRfWQU+wjULRj6DZkmlIOiGf4r4TyQnU454Yrvf9ATA?=
 =?us-ascii?Q?kr5Z532xG+TdQAjdUnkGf07bFgZbRPXv41Ao957KyLu7hhJcBNn8L+Zw9v+r?=
 =?us-ascii?Q?LunHTZpW3rFpyH4JOuhtXdVvnQHKqt5ehiiLdZc0r2+YA1s8gGPqvO0NHlGB?=
 =?us-ascii?Q?DKChk8+D9xY0fNlT/vXjUhWZmmbk+TogyR1zsqry7akVHe6EXXR06YRuWw+y?=
 =?us-ascii?Q?Q8nbAnq4xZeGkutc0UqdcYSfZOwYSZGsbdvkVg80F6tRI2uXMd6dvudz2T+s?=
 =?us-ascii?Q?T6/sHo3xrjDD7THsLy/YqJxWJczTmNHOq8bZW3zTsD/vdzGNzUqmzLW1Vo1V?=
 =?us-ascii?Q?CrrO8eVEUWfyPgXqMASfSJ0Q/guE83Y6T7YnfkfKovxfrFa9Yw/juVvhxh2Y?=
 =?us-ascii?Q?KtaXHejVVcSKn8JwdfrQpWfZYUVSJr4hEROViQLmBPI7AiQkW883FWYQPSHN?=
 =?us-ascii?Q?TCFPHbB4jtTyarZfCJdXlOuCDzO7eXKsA+FzDTfWXR9NQwTnciSQ9aujULSO?=
 =?us-ascii?Q?yfcdWgIXF+Tuwu38L8pP9m/KbFuoxQkNxWag2oxGFIviC7XF+xUZP69SH0Wx?=
 =?us-ascii?Q?81EekZ66CwXapQuPklEutUQgxyNo4KAGjwsVD1jFVUQv7h6S+/7S9kon75b7?=
 =?us-ascii?Q?BDQH8zdX4+yA4768gWK7gEdcQiNoK6tIrjqP22vJVKirKEpTBPWgFF0grZky?=
 =?us-ascii?Q?B0JxPUPNrG9qtKsRN4L4OJg2fJug?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 17:44:19.3994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56403a4d-5a4d-41f2-d837-08dc83f4cbd2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5663

System throws this following UBSAN: invalid-load error when the very first
VM is powered up on a freshly booted host machine. Happens only with 2P or
4P (multiple sockets) systems.

{  688.429145] ------------[ cut here ]------------
[  688.429156] UBSAN: invalid-load in arch/x86/kvm/../../../virt/kvm/kvm_main.c:655:10
[  688.437739] load of value 160 is not a valid value for type '_Bool'
[  688.444760] CPU: 370 PID: 8246 Comm: CPU 0/KVM Not tainted 6.8.2-amdsos-build58-ubuntu-22.04+ #1
[  688.444767] Hardware name: AMD Corporation Sh54p/Sh54p, BIOS WPC4429N 04/25/2024
[  688.444770] Call Trace:
[  688.444777]  <TASK>
[  688.444787]  dump_stack_lvl+0x48/0x60
[  688.444810]  ubsan_epilogue+0x5/0x30
[  688.444823]  __ubsan_handle_load_invalid_value+0x79/0x80
[  688.444827]  ? srso_alias_return_thunk+0x5/0xfbef5
[  688.444836]  ? flush_tlb_func+0xe9/0x2e0
[  688.444845]  kvm_mmu_notifier_invalidate_range_end.cold+0x18/0x4f [kvm]
[  688.444906]  __mmu_notifier_invalidate_range_end+0x63/0xe0
[  688.444917]  __split_huge_pmd+0x367/0xfc0
[  688.444928]  ? srso_alias_return_thunk+0x5/0xfbef5
[  688.444931]  ? alloc_pages_mpol+0x97/0x210
[  688.444941]  do_huge_pmd_wp_page+0x1cc/0x380
[  688.444946]  __handle_mm_fault+0x8ee/0xe50
[  688.444958]  handle_mm_fault+0xe4/0x4a0
[  688.444962]  __get_user_pages+0x190/0x840
[  688.444972]  get_user_pages_unlocked+0xe0/0x590
[  688.444977]  hva_to_pfn+0x114/0x550 [kvm]
[  688.445007]  ? srso_alias_return_thunk+0x5/0xfbef5
[  688.445011]  ? __gfn_to_pfn_memslot+0x3b/0xd0 [kvm]
[  688.445037]  kvm_faultin_pfn+0xed/0x5b0 [kvm]
[  688.445079]  kvm_tdp_page_fault+0x123/0x170 [kvm]
[  688.445109]  kvm_mmu_page_fault+0x244/0xaa0 [kvm]
[  688.445136]  ? srso_alias_return_thunk+0x5/0xfbef5
[  688.445138]  ? kvm_io_bus_get_first_dev+0x56/0xf0 [kvm]
[  688.445165]  ? srso_alias_return_thunk+0x5/0xfbef5
[  688.445171]  ? svm_vcpu_run+0x329/0x7c0 [kvm_amd]
[  688.445186]  vcpu_enter_guest+0x592/0x1070 [kvm]
[  688.445223]  kvm_arch_vcpu_ioctl_run+0x145/0x8a0 [kvm]
[  688.445254]  kvm_vcpu_ioctl+0x288/0x6d0 [kvm]
[  688.445279]  ? vcpu_put+0x22/0x50 [kvm]
[  688.445305]  ? srso_alias_return_thunk+0x5/0xfbef5
[  688.445307]  ? kvm_arch_vcpu_ioctl_run+0x346/0x8a0 [kvm]
[  688.445335]  __x64_sys_ioctl+0x8f/0xd0
[  688.445343]  do_syscall_64+0x77/0x120
[  688.445353]  ? srso_alias_return_thunk+0x5/0xfbef5
[  688.445355]  ? fire_user_return_notifiers+0x42/0x70
[  688.445363]  ? srso_alias_return_thunk+0x5/0xfbef5
[  688.445365]  ? syscall_exit_to_user_mode+0x82/0x1b0
[  688.445372]  ? srso_alias_return_thunk+0x5/0xfbef5
[  688.445377]  ? do_syscall_64+0x86/0x120
[  688.445380]  ? srso_alias_return_thunk+0x5/0xfbef5
[  688.445383]  ? do_syscall_64+0x86/0x120
[  688.445388]  ? srso_alias_return_thunk+0x5/0xfbef5
[  688.445392]  ? do_syscall_64+0x86/0x120
[  688.445396]  ? srso_alias_return_thunk+0x5/0xfbef5
[  688.445400]  ? do_syscall_64+0x86/0x120
[  688.445404]  ? do_syscall_64+0x86/0x120
[  688.445407]  ? do_syscall_64+0x86/0x120
[  688.445410]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[  688.445416] RIP: 0033:0x7fdf2ed1a94f
[  688.445421] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89
		     44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <41>
		     89 c0 3d 00 f0 ff ff 77 1f 48 8b 44 24 18 64 48 2b 04 25 28 00
[  688.445424] RSP: 002b:00007fc127bff460 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  688.445429] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007fdf2ed1a94f
[  688.445432] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000016
[  688.445434] RBP: 00005586f80dc350 R08: 00005586f6a0af10 R09: 00000000ffffffff
[  688.445436] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
[  688.445438] R13: 0000000000000001 R14: 0000000000000cf8 R15: 0000000000000000
[  688.445443]  </TASK>
[  688.445444] ---[ end trace ]---

However, VM boots up fine without any issues and operational.

The error is due to invalid assignment in kvm invalidate range end path.
There is no arch specific handler for this case and handler is assigned
to kvm_null_fn(). This is an empty function and returns void. Return value
of this function is assigned to boolean variable. UBSAN complains about
this incompatible assignment when kernel is compiled with CONFIG_UBSAN.

Fix the issue by adding a check for the null handler.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
Seems straight forward fix to me. Point me if you think otherwise. New
to this area of the code. First of all not clear to me why handler need
to be called when memory slot is not found in the hva range.
---
 virt/kvm/kvm_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14841acb8b95..ee8be1835214 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -653,7 +653,8 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 				if (IS_KVM_NULL_FN(range->handler))
 					break;
 			}
-			r.ret |= range->handler(kvm, &gfn_range);
+			if (!IS_KVM_NULL_FN(range->handler))
+				r.ret |= range->handler(kvm, &gfn_range);
 		}
 	}
 
-- 
2.34.1



Return-Path: <kvm+bounces-19451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56BE490556F
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:42:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42E851C20AAE
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38EC617E909;
	Wed, 12 Jun 2024 14:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AUilJGAK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9135917DE39;
	Wed, 12 Jun 2024 14:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203328; cv=fail; b=EXtXDNcd8sdlDloO0RjOwvnx3oR2OiPvTV6wY1yxNuxNN3ww5a1Lnmutq6ayj4ySysyZVtEiwyd7PX6W9WjuXEtGzdJbi/47ILY80gEqSSVSHPVjK2ih7lb094oRLpmyQ8sf5ce4RqwkHeWIARO7j9xgNmU5rU1KpBV4Tott67k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203328; c=relaxed/simple;
	bh=SFqCkHUeE3AHSEOm3msfGxs+Lvp80UWncGnPong7t1c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PBZxT/v11OmP7cttm9Hdo05d9iKXj4/3JjDZKA73ugnrfiIN+TV9O3D7QUE/3IxG90x+ifyf8D5m+/+w+BHoJqmYstFqxr5nzmvFvGVPz+GgDjd9aYgKoZzCA6fLjcIeKtG9yceHwHCo3b+3jgMtg7Z278SF4hwQBsLlffbgXqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AUilJGAK; arc=fail smtp.client-ip=40.107.92.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qp8TLqbQY61DmwFMdUb75YW/l5uxJtqjMG+bU6qpJjk053WCjUGsnKrEYSAy8tedXC5M+WS6nrO2KNT2xkDnsS5+W/Sv2kp+tup6ILwkWZSHqMHY0ss92SzvkJ4KLA1aclY2Y1ofv7fJYiylvmZJvuMcDfibr4EtZfnNeIY7EGfwVQMhgiQhlHE4u18deIG86GsVJyBM++JQoZkhGSHyfXKGUVMn+GN6UfjLcyC6L+jIfNWeECrfvGe17a2roxRbt9E1y+6viQqrmbZVKZ0XQF+WDKgtnP8vpkWNgSCArl+2NCW+LT8Uk6vcboeY71W7rBagxkPeCF7ALnlqWYykyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OkCY+4tbGXjEF8K1vmFpcBU8+jjVXdPukq/lyAhySeI=;
 b=nGIlSoNyrm1v3W4COMzYR1okdWyfWrR48B091Mx35L8qjmWnj0/krWKWAWnhkQ7jFxIiHMNasf8PQ5xUjlVjMsBcj4qVZHOUuIZJ/HGDSmtKWYvIUyePx+3ojRwV18vv/5VovYw+BrtZJOT6wD1OFdDfVK6X3nBR80VHbdJBQZjCPhB0FFaY6lYJjCOHpVqcsXVUerFMB+UsMky7B3UxW4O7k0ie8DQONgwMVBurmxaFROmHnsRHiq9VZMKD9MnPJGTidZlgxYksn+0xCF9VOPhATJ+W6x3fN3dEATdmzbE+oMaX5iu0dYJijIS24uHhyKfGpGATShGBiQ3O6uMApw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkCY+4tbGXjEF8K1vmFpcBU8+jjVXdPukq/lyAhySeI=;
 b=AUilJGAKsOTnzp1g8NFG4EHaq0ATnYHafa5jVINfUjEIpemnXChOUW1KtPLoZ+2Sc9tFHJEjsc47plxnyzGLDMWsrt+NS9rAbfJD5R9kIN2Z9cKCSC8A0IF3aOA63OfRX7U0o1JMI9UZLdvne5YlEueyxcql0kbzyos9vqH0cMw=
Received: from MN2PR19CA0040.namprd19.prod.outlook.com (2603:10b6:208:19b::17)
 by DS7PR12MB9041.namprd12.prod.outlook.com (2603:10b6:8:ea::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Wed, 12 Jun
 2024 14:42:03 +0000
Received: from BN3PEPF0000B36D.namprd21.prod.outlook.com
 (2603:10b6:208:19b:cafe::f0) by MN2PR19CA0040.outlook.office365.com
 (2603:10b6:208:19b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.19 via Frontend
 Transport; Wed, 12 Jun 2024 14:42:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B36D.mail.protection.outlook.com (10.167.243.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.0 via Frontend Transport; Wed, 12 Jun 2024 14:42:02 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 12 Jun
 2024 09:42:01 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>
CC: <babu.moger@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2] KVM: Fix Undefined Behavior Sanitizer(UBSAN) error
Date: Wed, 12 Jun 2024 09:41:51 -0500
Message-ID: <b8723d39903b64c241c50f5513f804390c7b5eec.1718203311.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <98ad0dab3a2c66834e50e6d465dcae47dd80758b.1717436464.git.babu.moger@amd.com>
References: <98ad0dab3a2c66834e50e6d465dcae47dd80758b.1717436464.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36D:EE_|DS7PR12MB9041:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a9f2c26-19de-4309-925a-08dc8aedd307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230032|1800799016|82310400018|376006|36860700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dTFlLY1zD1sVeAH4twj9ygoiLWo84y1NIOsP5wU5c0upGuljLW+uWe9J5xFa?=
 =?us-ascii?Q?52btuWCUBKZE74PA2dmQMv0e3HxeSchcITBCl9ct2Racph+kv0PY8q0QhYlx?=
 =?us-ascii?Q?nmbtgIPyBnvwotZ9KJB0yNGTzGSl09hpLqYheasbr6x5DKKzsFi3XCcya4D+?=
 =?us-ascii?Q?n/rQP6C+P5XsNn+CglWz/yC0CoAcfMYflkmQ1DE/fYB+GSCXTvehPOBeVQf5?=
 =?us-ascii?Q?BR46L/UMu0+LDO2qZdzQH3yO0pI2BJDaJjIiYBeOdz9D2smKvAl4V3i+785c?=
 =?us-ascii?Q?M3QikmZ/0SNicVeOJXsnf/lV2bHPPv/2BOMWFnrzfsxdgIouV5xp9oCk5nbh?=
 =?us-ascii?Q?4NpY8fK+S736u7MX1Pruy4VGLqe7gf8NNmKBllG9Y38dRyqeK7Nw6xZbJIew?=
 =?us-ascii?Q?stixuwveU/Ev70EV/6BHdKi3+QeVOIIiPOWDD/fgPYpv5Zsjeq5Z2ch615AZ?=
 =?us-ascii?Q?qcLD1KX8d7qwWeXOXPGeSFdB24s4m/D6OhqKzdLBdLj/IpvnUCUTjMgSAucs?=
 =?us-ascii?Q?IXrQ5+mrjYGmAiei3m2ZGKHIw0NvbAJiSAiLE3FOQ6RxNLJqGtRlay+Hybjp?=
 =?us-ascii?Q?km8tfKaGCtZM/FeAFBWGSxahFS5pSXU5o7oZGfoMyyyZTlKtx4NDJ+wdaxWL?=
 =?us-ascii?Q?sedPPT0+I7P0uDFCxsEnm7mwhrO81rteoXjGa/1Erg2rEVxKzH2ACLNb3QR5?=
 =?us-ascii?Q?WoGcSwpkSSAi5R3ZW0QEiBvjYJU2iEXzuCknrhr8Cdk3uJ9bt25PVBsOma+P?=
 =?us-ascii?Q?ZwYzjo3ODmrKGxUvfJJVOefrKJH9QIaXEdS9mQVB+iLiTgu7M/xR+Ko75WWW?=
 =?us-ascii?Q?OinHO+NZeunmYiL+Yi0PFufnsnSktEY2LbNVMcg8lQ5fGph3uQHMxPu+rxt1?=
 =?us-ascii?Q?S775bQJqFCXLs1EXBoLxmqqnBC5bd0hAN6KHJXHJemtHAHzoGGDjH2Q6LZNn?=
 =?us-ascii?Q?WS73A3Sy085tVYnxavn4agMR7j30Cc5pJdE4Gi992ZxAHYPyDO0YyGb5ncXX?=
 =?us-ascii?Q?PwdOyiQkHvWvg6MIxHPpXKyGu/BBozqYT54P9Zk2P8WZO3PAUHkBEUYWQX97?=
 =?us-ascii?Q?+DMjrNS4Ki2KT3a/NO9j+aOJhD/kN9PRyvVVaT/eJr8YwmgUFFmDv1wNq2/G?=
 =?us-ascii?Q?DEUIG2QcBZbfIpWjUzlCJFxG9kC5d9ncnGdON0jQWKWM8BUUBM/NontdBOYN?=
 =?us-ascii?Q?+LXOy7dM9Fgfp0MTB4E2XINUty78uzhOwSVztz8CowcfyYdd3zlxLo92r7Ej?=
 =?us-ascii?Q?8rq3b479vb1HGWc+Gb0+k+Y1Jq84Y0kdZyz6aGYVh2JGyQRa1G2BPOgbKa2N?=
 =?us-ascii?Q?HEap88RU8Y3X59QGF+bMmGEFh0wroCLQzyyI8efS8orWfgxQD4dYZMsI7Wjq?=
 =?us-ascii?Q?6mxTPEaNLGTAzxHy4UUrJUmcIbO24gcBswOTKpaUWIjt21mScA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230032)(1800799016)(82310400018)(376006)(36860700005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 14:42:02.9638
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a9f2c26-19de-4309-925a-08dc8aedd307
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9041

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

Fix the issue by breaking out of memslot loop when the handler is null.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
v2: Updated with Sean's patch. Added his sign-off-by.
---
 virt/kvm/kvm_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14841acb8b95..d65d3aa99650 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -651,7 +651,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 					range->on_lock(kvm);
 
 				if (IS_KVM_NULL_FN(range->handler))
-					break;
+					goto mmu_unlock;
 			}
 			r.ret |= range->handler(kvm, &gfn_range);
 		}
@@ -660,6 +660,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 	if (range->flush_on_ret && r.ret)
 		kvm_flush_remote_tlbs(kvm);
 
+mmu_unlock:
 	if (r.found_memslot)
 		KVM_MMU_UNLOCK(kvm);
 
-- 
2.34.1



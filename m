Return-Path: <kvm+bounces-10594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C76BA86DC40
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 08:44:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8174328A6D6
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 07:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841B169971;
	Fri,  1 Mar 2024 07:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3r59unbY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2041.outbound.protection.outlook.com [40.107.212.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22CF69952;
	Fri,  1 Mar 2024 07:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709279083; cv=fail; b=osjprU1biu3tOaSpQhy9kCuXUnW5WrmLRLoxQegxNgOKQ36sSN2ZIaQvyjl0/A91UMsSFy4t5uEiPF2KaFuD97KPCNLzu/MjPq2dJGBtqaNeItrtmI5J7d6U0veY1jc6Yg+ZAz/T1ucNjf0KF2Ma3whH38TH1Crmx9y+lGMZswU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709279083; c=relaxed/simple;
	bh=oaPwoVL3tzqhAc2007zK+7EWOmJEEXRv7u4awC5C2OI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ae1jyRpRvFH9MAjl77vVez03IP/MkhaO4hUCxPdCUtptHdtudAX/TvuYKrIw4z5hg9s1bYcRhTUcBnW6TyE00osRKx8zpVcGHpQgRRe/0hzrFgZV5tO4q8iGmU1hW6ahooyM/YSIM9pKsACQjT9GC7YQGvOGQ+cVIICQpar4Agw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3r59unbY; arc=fail smtp.client-ip=40.107.212.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMwAqj4ImHMgjqPRjUo/cjxBcHRR1+UMHXicjBjCt6+vxk26z0evGPpKKyxGzLTE6/Up0f8VX4f+wSMm79jzPp3KDRn9OxPQiedd393gtPy17AlHMJWOCAXEb4/dA8KeNQjRrJAmQgwumtXYpsRjqUK1dyCp1ZEU2w+UT6BjYW0fXY2nkUYKzckO/FeiU3Afs5unnskOCJYlaa73JW00si+I+EO0iRJRCqnDR4Ux2u+qz2TkCj/pUNmAvI1BaJ6v0kr2SCUSp1Fy5lIj2JrLQ2zPid7I3rugnWa1DhDLw2h29FE0tMADkBgIJawVvO/xL0uGIyM2nFGti73mZiL+mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDHhqAsCApQAa/bXgQs5jL1Hb9Zxs3xIbG93Hf4Sq9o=;
 b=dtLnX1g9dn0JSWX3CHzyLD9BBVdD2ROlA8YtWsdqr9XeRjP2yVtHNJKO6HH2VPXBoYN/NMCw0AthuKVnad4vQqnhaqgrVfd5IdgaHk4rBT+qoOQB1ekp/slO/nen7Jb8kSbdRpRerej4InDLaHU9NZ2wYiue1GT6qrherUZFuRvIYYw/UdvPV9gdWYMD1cEUZCFkDaznKInyTTsDmIZLT3M/SEOq5Lpgj6qdCmTDd43utdRgyKZwkO3yi0bagPHEMB5QntZKtaDlYZeTfYNXskqn/Q53UCJTikv17GnDS7bFxAmEPTfkbQtETz2ltIlUqcOaj1XiAwx4eQ1Y/OlNEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDHhqAsCApQAa/bXgQs5jL1Hb9Zxs3xIbG93Hf4Sq9o=;
 b=3r59unbY6ZmmWpcmMWk1RpPYoPbS69IkFxokza5b8uOJRGC0FLDfrKRN6bTdqviaFyOu37b6YFlToRItL25YqDGo7aovMwquRryJ88Sq9OQxXreYbN5qszCMz+NIxCDUpm7ehb/qdeg/jxgSZ0T2jL/gaOmz3qIeVt/LlAvh3xg=
Received: from DM6PR02CA0117.namprd02.prod.outlook.com (2603:10b6:5:1b4::19)
 by SN7PR12MB7131.namprd12.prod.outlook.com (2603:10b6:806:2a3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.47; Fri, 1 Mar
 2024 07:44:38 +0000
Received: from CY4PEPF0000EE30.namprd05.prod.outlook.com
 (2603:10b6:5:1b4:cafe::a7) by DM6PR02CA0117.outlook.office365.com
 (2603:10b6:5:1b4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.33 via Frontend
 Transport; Fri, 1 Mar 2024 07:44:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE30.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Fri, 1 Mar 2024 07:44:37 +0000
Received: from sindhu.amdval.net (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 1 Mar
 2024 01:44:31 -0600
From: Sandipan Das <sandipan.das@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <mlevitsk@redhat.com>,
	<vkuznets@redhat.com>, <mizhang@google.com>, <tao1.su@linux.intel.com>,
	<jmattson@google.com>, <andriy.shevchenko@linux.intel.com>,
	<ravi.bangoria@amd.com>, <ananth.narayan@amd.com>, <nikunj.dadhania@amd.com>,
	<santosh.shukla@amd.com>, <manali.shukla@amd.com>, <sandipan.das@amd.com>
Subject: [PATCH] KVM: x86: Do not mask LVTPC when handling a PMI on AMD platforms
Date: Fri, 1 Mar 2024 13:14:23 +0530
Message-ID: <20240301074423.643779-1-sandipan.das@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE30:EE_|SN7PR12MB7131:EE_
X-MS-Office365-Filtering-Correlation-Id: d7e232a8-504f-4f73-346e-08dc39c37276
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cru5drQmFEOMaV+eAjj0fh9ZPFXpogjohATEldYero5MFNZH+6LnRRRzHg1v0bLN2ozCVNKRZR3A2y+gw1dDx3qCMo5MYLQv6Shkci0NvybBIq0ue5D6pCqXWELI7yuSPxBb8MbEyxzgzK9rr0WCw/tXlJJJXYMmk9+ohQhrbDxEG8vpUhFNCPbFnICQBdLvgMwCI7/nx4qJKufZRckW1wyHcsGgPq9FsMAMl3vwwtVb0F/vkqfbP6eH6FB1X8zJCKX0g1CudCaVlsCBszzMZ1YMkE1A1qQQFaqmmY2t2GAZapvF455/EPddykEfizF+X/0hgHygsQJlRxaNLxNNDXLpx8Cj4Tni8Rg/H7rPPdq02d0Eer3C/J9YR0t7FZ3YL1jfwQcabF/49R/Elju5sNU0TAmM7gMRPDi+Gjt8d1EayD9FnnFXUs9lbYrIA8CacFiaK9auKdA/URZUIMdMTuwD1t/zGIU1T3wXjNLHFIBelQlv39Q4Y7ozmOM68jA96D1D8dMb05EVUgdOXNxyJTYYOwOnHo3yuC4UCof6YWSEYQmKgi1qIB9FXglDnqn/XCLR+sw5tMSJnypKPDL3r8PQbRIRoGaMQUj81ZFhReRjojdP077AZAbryhHWc0HZ12BQOijzc7W3aUJoXV6n4GtbbfiAJ8boYTW33E/neS7iWaxcWg9LjADkkkofKhSzMt/EVX86oYMvvFBJ03s0WRLinNp8KTuVesf66xwmffPbkUddApJhMmq3jpYzK9Xj
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2024 07:44:37.9491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e232a8-504f-4f73-346e-08dc39c37276
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE30.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7131

On AMD and Hygon platforms, the local APIC does not automatically set
the mask bit of the LVTPC register when handling a PMI and there is
no need to clear it in the kernel's PMI handler.

For guests, the mask bit is currently set by kvm_apic_local_deliver()
and unless it is cleared by the guest kernel's PMI handler, PMIs stop
arriving and break use-cases like sampling with perf record.

This does not affect non-PerfMonV2 guests because PMIs are handled in
the guest kernel by x86_pmu_handle_irq() which always clears the LVTPC
mask bit irrespective of the vendor.

Before:

  $ perf record -e cycles:u true
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.001 MB perf.data (1 samples) ]

After:

  $ perf record -e cycles:u true
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.002 MB perf.data (19 samples) ]

Fixes: a16eb25b09c0 ("KVM: x86: Mask LVTPC when handling a PMI")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3242f3da2457..0959a887c306 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2768,7 +2768,7 @@ int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
 		trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
 
 		r = __apic_accept_irq(apic, mode, vector, 1, trig_mode, NULL);
-		if (r && lvt_type == APIC_LVTPC)
+		if (r && lvt_type == APIC_LVTPC && !guest_cpuid_is_amd_or_hygon(apic->vcpu))
 			kvm_lapic_set_reg(apic, APIC_LVTPC, reg | APIC_LVT_MASKED);
 		return r;
 	}
-- 
2.34.1



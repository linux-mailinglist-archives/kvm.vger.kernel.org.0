Return-Path: <kvm+bounces-32908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E240D9E169F
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 10:04:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96771287F7E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF16E1E1048;
	Tue,  3 Dec 2024 09:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cjJJ5/ng"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B961E1028;
	Tue,  3 Dec 2024 09:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733216510; cv=fail; b=QWs7aZHAMgOksKbSSRTPD7qExe8TIWgDWDek7bhF1l3aG6FWwRrt/Zk51sz7lC2Ll1RFjPykVz+5yOzSSHmjKpWETHBlIFBTH8JOGFspIq8NRKnqbk+kEXvfEQIg/b/m4AQuJo3UrWi7oaLP5VDAvNov7Uz0xXwfEQ7K+w4SKrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733216510; c=relaxed/simple;
	bh=j+FEN0yRJGy4p/21ziBMRJ9XzjjBvYRFpKkjqXPHsQo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lSXqCDrCPExCvT0X7qSl9fUx8g4RlO7r8yMFNMGSHbA9/eQBhpEZRF/dBdsJUAhPQnk6Vv77DjWof98w+JeFjLwfL2OzYBl+LWN5DUCYeRm+B8y+9h+VSVU9an7Y/cfjWsqWHqDM7vQX7ozuNL3C8UEJ8IxN8v2VtJTL6GLVZS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cjJJ5/ng; arc=fail smtp.client-ip=40.107.93.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lOdBInXbiIVsIf2UJZZTDlt41XaA/YPh9XAbjiquDkjkNN5dptHbz966XgO7VvWnew9CEwVA1sawgBtANk8kOMS9QotFW6uGsPbn8jxxE8B//4tHr5vhxuIRe/sBW7JzhHJRCMnOhG+Z+XmHcqIL5XUtVTnLMXS2qIQY0L4Y7c+BkSIrw8eYMn4exvILMYGIdlGA9cx8tGzfGdXbQr4qPYO5lkSKhmy7QXWigzPv5nJuTDYScC/AkUb3wd+kXfr1c52MXq/zc1Gr/wMdw1jWMNhlsMA5gzDhQkqkBB2De8MYPofME5WGi42aQRRWQAh24OLvZwzolYaAJhhwrqeSQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZfRjAV92vPxcDMdOyZ3ULgVmfzT+uIw2EJDl1J3ZIo=;
 b=icBjrMPTnjqkjxLZrP4zxt9y9V8syY0CF9WwLSZX6hK7/sZMhhdNle6aYTkdDmW65hsr05eEfVscJHzYbUO4nYiRcDEB1BksMKWKfQhlSf5DqYG1bp3qapmuVWko9gnMFbMC1kPcQpjffXU4dZ2XqnXL1HgmKlZPvlNsL7d6PqfKgvftqrhzePAPTJ8DmhwFEX7GONGrSj+CnZE02x171cfcFBa3uMebo8z9IUXdL6TXcOhDETUGUcydKH9Cl5RuZ/3BkR1sZTGxlKHp+2j+LvkoKWYKyy2YWe0SBnkr2F5pG9V5bs+UPu3tncFuYn784yr73MpWEH6Ake4UraZ8bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZfRjAV92vPxcDMdOyZ3ULgVmfzT+uIw2EJDl1J3ZIo=;
 b=cjJJ5/ngTv/DawgF3HrdnLDEjhnRJfbz8zEVy4RmwlAtFRptstJHU3+3UP6D2AoAIPt2ax/VhpPcnha6bpu0wyI7tNdLrw/zGnErkMUc+rKBCSgAAFmm0lkItfDqi2t/l2PbqSJevnfVACZTcnW+s8W0bSJ8qgmQrcVowezcXUQ=
Received: from CH0PR04CA0048.namprd04.prod.outlook.com (2603:10b6:610:77::23)
 by SJ1PR12MB6027.namprd12.prod.outlook.com (2603:10b6:a03:48a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.14; Tue, 3 Dec
 2024 09:01:45 +0000
Received: from CH1PEPF0000A345.namprd04.prod.outlook.com
 (2603:10b6:610:77:cafe::54) by CH0PR04CA0048.outlook.office365.com
 (2603:10b6:610:77::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.19 via Frontend Transport; Tue,
 3 Dec 2024 09:01:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A345.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 09:01:45 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 03:01:40 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, "Juergen
 Gross" <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v15 10/13] tsc: Upgrade TSC clocksource rating
Date: Tue, 3 Dec 2024 14:30:42 +0530
Message-ID: <20241203090045.942078-11-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241203090045.942078-1-nikunj@amd.com>
References: <20241203090045.942078-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A345:EE_|SJ1PR12MB6027:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a8a9058-e891-4475-1221-08dd13791ce5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bK6Gjc8GAnVjD3q+olOuIqMRlIHQBQ2I99Q3/YntczQJVzHm11iEMd8et8nR?=
 =?us-ascii?Q?niOOmH1JsJzICeTvazkIWnfKRiMZnzlsyv535psEFuufCERoW0y2IMSlsALJ?=
 =?us-ascii?Q?7MEb/PKo5x8NzD3e3yINVHjDdXwH8RjsDbDyTEw0JOcE5LnhFE8MFDU3fn6E?=
 =?us-ascii?Q?l7Y6thEFBrcio2rI0aI87Czrl3HEJrFCpVbutt8lznJwnDeHbzrfZOzCc1e5?=
 =?us-ascii?Q?J7ThJTpBqQ7Mc9atjzSD2o3unY+ifz2nJnZyNpgRcNNmJEnppXrmOYzZp8Bd?=
 =?us-ascii?Q?ScrENgjrnsjerIjgkwvDNlpLFxqm74hyn62OCPmwCrNetvOXNluNZez3UigE?=
 =?us-ascii?Q?OxvZ6Xv9aUVpp9Lf/r/fc5rr7oJETF0m3S/a/zXoGhUPQ39HDuABaKYcHtZq?=
 =?us-ascii?Q?SgQeApNGNrQBjJa98DEjr3vom88cDvZ0Xu8jrwoDzLOgSLmaoiv/nUA9lZ/X?=
 =?us-ascii?Q?f8fbRUF3nJjo3gHEah4G+IBUJ8ytuEq6OEj3Zn/bEzrFT6Mt/OSx3Kh/5T4Y?=
 =?us-ascii?Q?+gifxRfvnIbxxePIiixgIF12dO5uezCPyRrMlghSvG93CStEd0CVmmux4bnS?=
 =?us-ascii?Q?bQI2x5Zf6BlUOba2Ybk97sYS6g+ZUoX5ahDt0cJQLOhLAT8b1RnzjH5S7Eip?=
 =?us-ascii?Q?qzn0/DmnNw+iDp5/Ln4DSiJBwrJSqy5eAw9ixgUVKe3F3cV4XUQCBns4PyTa?=
 =?us-ascii?Q?sKSjvn5fos6rQPLXzgIavYgTPLg1MIYorRgpBtz7kwxWKRplvb15vU0FcvrQ?=
 =?us-ascii?Q?jkML5qAbrhyJA38pLppaqx1ltlkcEM2o1gaVlQfCMwvhfS1OtC3nXyinzSYV?=
 =?us-ascii?Q?si0Td7eEmGuXUGXBuqO4cYujKGrlT85lGLmQ1T6DMchTJk3fLGNMVTymIRGj?=
 =?us-ascii?Q?KfEMLD+wSAy5GNGs2BNPUZyw0ClAyfvOvfESVGqRdJvuoTx0G589rawM8VvX?=
 =?us-ascii?Q?eMwcyKlWFn/06vHo6F4HslxIGWMbZPzheFV/ogZdtprsWS0/5SetVJ6WEkql?=
 =?us-ascii?Q?nlK9zJeG90ycrfro5CTeA1fU0kybj+V904VAlnxzt4ZKGsID+JS0xkGJ8skK?=
 =?us-ascii?Q?YehPyLHebdOIIKISyFR+GmKf9mp+FZn6MMugO+vs/oyP3vN8M6u4myUKaXYf?=
 =?us-ascii?Q?kpBmcSAEo1Uxj9KLb/YwdSDBTNFkj0LXuDfQTxQ3ov3Vv1SxE44Rj9kVlYbx?=
 =?us-ascii?Q?JjySJXr9VmGnFBmhHEr3EoX9ulCuHWrOtngtKd6iJ5CO4/NcYXKkA52TwmQ1?=
 =?us-ascii?Q?OqxDwA+V6yg0PX9JjmZbEhF//xnCBESw5Jhtk4kD3ga6ODbs9AujoKKNOOeq?=
 =?us-ascii?Q?crl0WozxtCqYkzxHX2ENXFkgNZA0CZvaIgyvZcb+bui5Jd39A0rB+s9oXpXp?=
 =?us-ascii?Q?jEomWHuKOF63OZDBIEPf6VdY6Co9wU2PvEXeGYtdU/sPIR1ip5E3d9QqmB1j?=
 =?us-ascii?Q?u+6YNpbLElkZ/FxOLMiMcQQaSaKwrita?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 09:01:45.2754
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a8a9058-e891-4475-1221-08dd13791ce5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A345.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6027

In virtualized environments running on modern CPUs, the underlying
platforms guarantees to have a stable, always running TSC, i.e. that the
TSC is a superior timesource as compared to other clock sources (such as
kvmclock, HPET, ACPI timer, APIC, etc.).

Upgrade the rating of the early and regular clock source to prefer TSC over
other clock sources when TSC is invariant, non-stop and stable.

Cc: Alexey Makhalov <alexey.makhalov@broadcom.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/tsc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index c0eef924b84e..900edcde0c9e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1265,6 +1265,21 @@ static void __init check_system_tsc_reliable(void)
 		tsc_disable_clocksource_watchdog();
 }
 
+static void __init upgrade_clock_rating(struct clocksource *tsc_early,
+					struct clocksource *tsc)
+{
+	/*
+	 * Upgrade the clock rating for TSC early and regular clocksource when
+	 * the underlying platform provides non-stop, invaraint and stable TSC.
+	 */
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
+	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
+	    !tsc_unstable) {
+		tsc_early->rating = 449;
+		tsc->rating = 450;
+	}
+}
+
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
@@ -1566,6 +1581,8 @@ void __init tsc_init(void)
 	if (tsc_clocksource_reliable || no_tsc_watchdog)
 		tsc_disable_clocksource_watchdog();
 
+	upgrade_clock_rating(&clocksource_tsc_early, &clocksource_tsc);
+
 	clocksource_register_khz(&clocksource_tsc_early, tsc_khz);
 	detect_art();
 }
-- 
2.34.1



Return-Path: <kvm+bounces-12231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80015880D64
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:45:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3035D28302B
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC29E38DE1;
	Wed, 20 Mar 2024 08:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xmOXEMb7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DA2374C3
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924326; cv=fail; b=t3Gmlv5cryUWuocc+kxV8OZA8nC/Izr8TVbR3fps+ta4+MMVdd7Xbmx99jnmRIkl0gNKsUR5d3pFn8CLnZNTSuoLKuFs/K/6gEOebXyN0pmthldtIiCo6pfHYlCxRM9LcHdq1GuHRkoQff7HLfUU8kgT3Qvu/E1/K/LPeuKPefY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924326; c=relaxed/simple;
	bh=FMTZw1QcmGt6JXWVAddgkcUb//DkPZsz3QfjviWP0Q0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NQW5UyHegJCcyL3Vrgp/iVQDvuPpc/xR0iT+WgQLg5x/qB+8GTktf9reBhYOg4J1F5Vyk03h7t4GffiN0j/fsTN22kveDwFbhb11aY4SnnVORgudk0t5IaPlHSNPA2lNAJ9j5fTVvbUFIjOxvsV1ZiVP+AsuXbtAPb0tsYERiHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xmOXEMb7; arc=fail smtp.client-ip=40.107.220.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J11K8/FYWFcjaa8DWWxykkw7maywhNRDTvcIEt0TP+HWe5uaV00MZ3b3xxedYLOrtBDE+hJ8CH1+Vcuo6YIUIo64ZkGyfgG+Nw4UwZdkU2QKD+EJipg2rUhf1Q5bjKM3T6tkGXaeL4oJm3+Kog6b5jrmK2A5BUX1lHyen9JWSBAIC/n/4rlSQb3o6+Re1Pn7xpzW0pQhe9PJdNzYgReyNtuH851wtdCJ9qN1bCGXqshRAc8wX7Lp+S3DP4TEjl0xOfuurAZ/PRg3Osq1SsANyQ6VI3K7wJ2NBq1ndRBbSRHu8e2iJYqy4s1Ac4EMrL1AOBogpL0HIgZTVHNK6IbGNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SxUlZfCZKFxzZ51lHY8et/IBOA6GjxRKwAqzIFVFHmw=;
 b=GFO9/cB6yKf2Tuo99Uyyfk9U0+URilzrrvf7F109grbFnfR7J7CWWgKNpvPEgTTAfh4AI3+/UtHAWO0w+geRLDI+ZiM9Nc+obr8QC9Q6ASjkEr1AbNpdeWQA8Bb330ra4JSFoW7ypiXh9PVdN7eu3pD/vVROg2l79jEH3PiIazSZJZEx9W0ZcY/wn+2lDht+d0uTHe2pSV3/nLbY8xlH5c4q7kICz4G0A/LNs0R9x3lLsNFonKsAFkpgv2XKfYtchbNaoS1RQVyzR+XCajMuwVxVf3N9zKbmAwKzby7Oe/BWRz2cUEhOUD/toaJ52H7xfbQ0OveUi+VqCVPfcuhISQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxUlZfCZKFxzZ51lHY8et/IBOA6GjxRKwAqzIFVFHmw=;
 b=xmOXEMb7HW7vdGQopYJUtVx2ojDOfHTI74spD7lLL0tPfOIfo1T4ik5fO4A7qmwv7ck9h0sz/2wvS5DhMeN5XI7e6elB6e6qoUvSJRlCuz9G+o9yY6t/VkWD6oyLR6lldnCF0cdaoTCymjEaxfr21nEVHlx+bdV1u5zP3EwaYDc=
Received: from BY3PR05CA0056.namprd05.prod.outlook.com (2603:10b6:a03:39b::31)
 by SA0PR12MB7464.namprd12.prod.outlook.com (2603:10b6:806:24b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28; Wed, 20 Mar
 2024 08:45:21 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:a03:39b:cafe::a6) by BY3PR05CA0056.outlook.office365.com
 (2603:10b6:a03:39b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12 via Frontend
 Transport; Wed, 20 Mar 2024 08:45:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:45:21 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:45:19 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 20/49] trace/kvm: Add trace for KVM_EXIT_MEMORY_FAULT
Date: Wed, 20 Mar 2024 03:39:16 -0500
Message-ID: <20240320083945.991426-21-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|SA0PR12MB7464:EE_
X-MS-Office365-Filtering-Correlation-Id: aaab97b4-14ac-4150-5487-08dc48ba13c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	r7/iU8P5DmtqFbofk+jDMUWSk7tzJOLjQsMwOOYTBxL+rNd4/hjs1QFoiQJQKLISDY+2hiB9JqTtQdy7y4aYTUR3RnaxusETrHiSd7D5oN6/xMXKWBfJ18VZKoAtsc72ki7tgr4rYHoyPaNvgr9YRZrFMSUbafFT3BCSWvqexxkf0z4ObODScs5XHm/B1038cArQh45rwA7H/22EggyTNkaG9IucjEewsfAs9DS4kbhxUemUA8jENcyM2WPCQyeiazqSEq8orBGgx4Gdv595YNvpJsv1agFz5L+ugRRv0tt8yS6zXXvaBuIirIm5281dd8VJ7SR9xXqj6Hguw1rZ3SrgZDycOAC96DiPRmubVjClBeXi43sOJmBcBl8LtoA2IPT+Q6Yq5nwKcmuHK4IBoeA3vYfnEof/KSAWh3X3t44aRdAmF8C96io9YC3RjTvZfu6SG6ZShA5fFw3U7MdaeIgq7/+h3pK+QS7eYuxc7rTyGmbcKUxsaSIjxS3n1kRFyytdlTDrZaJKeYc1wwlmZwo5oWL2WwMJbvuhVsH/h5FNswLje1ue6LnaZYB94JtJolfWI9uf+ieS6x89tf+2suSjrNhilX48RtHElMya07DaCFHQM1VdetlQX1sU281ww79I/WWZEJUkiyvQUfqvfaChtqOPBpXPZCOlsgLuVVCllNCkY06OYBhACjxC63lEkk9i/6P+rHlROADia7S/eRQ/wtCM1uI0J78IMTLAlBvpEdXYeePDVLS9b1m72S0W
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:45:21.0956
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aaab97b4-14ac-4150-5487-08dc48ba13c4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7464

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 accel/kvm/kvm-all.c    | 3 +++
 accel/kvm/trace-events | 1 +
 2 files changed, 4 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 6ae03c880f..b5872fdc07 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3145,6 +3145,9 @@ int kvm_cpu_exec(CPUState *cpu)
             }
             break;
         case KVM_EXIT_MEMORY_FAULT:
+            trace_kvm_memory_fault(run->memory_fault.gpa,
+                                   run->memory_fault.size,
+                                   run->memory_fault.flags);
             if (run->memory_fault.flags & ~KVM_MEMORY_EXIT_FLAG_PRIVATE) {
                 error_report("KVM_EXIT_MEMORY_FAULT: Unknown flag 0x%" PRIx64,
                              (uint64_t)run->memory_fault.flags);
diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
index 31175fed97..681ccb667d 100644
--- a/accel/kvm/trace-events
+++ b/accel/kvm/trace-events
@@ -32,3 +32,4 @@ kvm_interrupt_exit_request(void) ""
 kvm_io_window_exit(void) ""
 kvm_run_exit_system_event(int cpu_index, uint32_t event_type) "cpu_index %d, system_even_type %"PRIu32
 kvm_convert_memory(uint64_t start, uint64_t size, const char *msg) "start 0x%" PRIx64 " size 0x%" PRIx64 " %s"
+kvm_memory_fault(uint64_t start, uint64_t size, uint64_t flags) "start 0x%" PRIx64 " size 0x%" PRIx64 " flags 0x%" PRIx64
-- 
2.25.1



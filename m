Return-Path: <kvm+bounces-13093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EF55891F4B
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 16:02:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24B442890B3
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 15:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F221311B3;
	Fri, 29 Mar 2024 13:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TR1F/wU1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F5885C6C
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 13:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711718138; cv=fail; b=ZWKGEVVQqt8O7/6i3ctaeH3+W/T5heT0A/8kpUN586cdzgFfw+Kd2XFU5tdIoz+b7DQFw9AdlizEUWSkaoGVTDtpU2zgm7U6GKlAh0z07gHYBHB6SJGY6PsE7jEc1D/nSoKqpwehAzRkq0r1oW1YkgqRS31Mtg6FkfQjPe4U9iI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711718138; c=relaxed/simple;
	bh=wYiYQj0kie14jv7UGYUeia4l5fHUjUfPrIa6COaDOMI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jrUxONmDeZlFjDsPSwP3w90PhB4XEXQIKyTDo1zAcLdrU1575cgLfFGTzHNAHjoQO4aCbBe9k30JgsCABDHVlvoCVo2jFYj2fPlPtIhWXKTA/kDgDIU/dQiIvzbNc8YcNyoRrUNTemGqK9ujcwamtUwTW7BI4r4Swjv78C/+GW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TR1F/wU1; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPGTRFv3LGGUAsudVMxvhF1zyeqmdLkEotTScqw1Z3J0J4luzUKhMQAIeJo18yt2w1WW+Oeoi2VKIXZvNj6nUft+SuWUGkiRJBlwuvDNpJ+gUpOQ6fxQ/0eYvUJtY+lavHVb882nzBYxjq0Xme+kdQNEdsHfZmw0mEgSmp8Z1a4hYavzdTrRyuWahe+ZKABMwMR3szRGhoKQ+ETkJHo39x07Bgh812SR91UdNr5SsZ8y7dQeyodZJvsHZyReojbfTiL9zsLZCAN1GQ5qeebxv6k7R2aC0kNNlsqGkkZB7nYXsC65AKFZhPN4dCja53y/eSNXa49UNnJ4uzuXwh+1cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t++pxeaQYg1B05ixZqu0eMrYLhgdNCzzP4BMHNWc/ko=;
 b=KKWWXJCUXYiw0O2MqsJTErcKVdu+ARYW44xqjZjCWhYcILZoz2ARdpgOgIJYJl3DE7Ia0VGmflYbM8XLzBNqxNwx6jZcncyZ+c6CUQb2JnBJhrdm01yY5sSbN4RS5LLbMzwoxphtxTW0ydJnrYD2N/nEVLtpkL0DGnnYN8qwyrADW1lbiT8c3KTPelzVITc6BsS3XLLox0s7X44Jenkz0miq5vHcZ/Cl4xoDb8Pj80eHsWltMtNWVPFuIntY+RGGXqIByLylH6aGkN8LMs80mkHZy1alq2TS+QAuzN85UQHEFguTCQzRnYi8nIaIKbluE4+WDUrdkudz36SHCAam9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t++pxeaQYg1B05ixZqu0eMrYLhgdNCzzP4BMHNWc/ko=;
 b=TR1F/wU1WRZkuRPHKRD4eF63xPyjJ9LhIiSgXeOPWXkZLEDrAbCnAh/yj/Rhfy8gcfhJavqFEXe8tspCJcJNzrVY6K8Un+hCRs1fd5j909MzmSSgoYAISqSA6UDxWi5o/l8dr0m/4QxBkIlPCPyMNtdHQ8YH1VvqMguKF0N6vEQ=
Received: from MW4PR04CA0185.namprd04.prod.outlook.com (2603:10b6:303:86::10)
 by DS0PR12MB6414.namprd12.prod.outlook.com (2603:10b6:8:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 13:15:30 +0000
Received: from CO1PEPF000044FD.namprd21.prod.outlook.com
 (2603:10b6:303:86:cafe::87) by MW4PR04CA0185.outlook.office365.com
 (2603:10b6:303:86::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 13:15:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.0 via Frontend Transport; Fri, 29 Mar 2024 13:15:30 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 08:15:29 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: <andrew.jones@linux.dev>, <thomas.lendacky@amd.com>,
	<michael.roth@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>
Subject: [kvm-unit-tests PATCH v4 0/2] UEFI Improvements
Date: Fri, 29 Mar 2024 08:15:20 -0500
Message-ID: <20240329131522.806983-1-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FD:EE_|DS0PR12MB6414:EE_
X-MS-Office365-Filtering-Correlation-Id: 836527f7-bf13-4d1f-7e4b-08dc4ff24efe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7tZf++Lj9anNRDEeNyIpDlhY7MIdS0WnjkJyg4LkNF+ci02ilgTeErvfwSJSN7mdqTkEmuDXV1/7lmF2mJ7/CUU/0AmUZumJPBOdy5OwHSbVankhEAO0bS9Zm/GVynCYT5ld7oCf6vUhUeIXjM4BkbRMst8y5IKfsY21CRlJV+F5Mt5xCzzVRyojwMmwSZ5FxGX4gHtgYc4Sy9USwpoBdsBTzq+QH/p34KcjHiOEyKp6sEWjjWrzkyq4dgi8Ti0mOZ4CCxpPuTTkVf3dNjEhRQ7ib5cnDex9b9+hvDOOmvuIc7NtvEqLUAkNqrpy/5NwlubBE8ZtCLjUX+9/hFblulENjh4eUCICWiXTOmFqOBMCjfR6cGMzF54Zob5hfgeWNP/zu8MxGGYhRUyGM51IKBQ37BY9FRNi52Esm7YAGIT9gqRfl5L63WzwtYLIA0L4OdpRcklhih14h2eG29/Fx77OG1Ml3bD8eINJnelnHa3rNUjtgGh1i3ZX83o97N9gCbTAWcn7AnYAuIPpadPGwm+YpVGUlkFFPZUZ1LGl28n37um38i1rM6CCOLtsKS+THVRBXPEDRaAxpzR8/ZGu9MDwq/sBano8Vvdl65RXEi6JNi+TdE/DFueBxbNqDWRxnG0lJVVFCegWoMOCrYRhUFDWeg3ycODQ7bMYXN+wyUxphNZV1l5c3hk45HGzopOkNAzfNi6Xsa1Ye1W63Xkz2W02zGabumy7D5e5d6RMzqiMIeSBw5TvCodj6gYghat2
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400014)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 13:15:30.4186
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 836527f7-bf13-4d1f-7e4b-08dc4ff24efe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6414

Patch-1: Introduces a fix for x86 arch which is ACPI-based to not get
	 into the path of fdt.

Patch-2: KUT UEFI-based guest may sometimes fail to exit boot services
	 due to a possible memory map update that might have taken place
	 between efi_get_memory_map() call and efi_exit_boot_services()
	call. As per UEFI specification (2.10), we need to try and keep
	updating the memory map as long as we get Invalid key failure.

=========
Changelog
=========
v3 -> v4:
    * Dropped patches 3 & 4 from the series as they are not relevant to 
      UEFI improvements introduced in this patchset. This would aid in 
      easier review and upstreaming.
    * Addressed feedback (Andrew)
    * Included R-b tag from Andrew Jones.

v2 -> v3:
    * Included R-b tag from Andrew for Patch-1.
    * Updated patch-2 to not leak memory map information during 
      re-trials to efi_get_memory_map().

v1 -> v2:
    * Incorporated feedback (Andrew, Mike, Tom)
    * Updated patch-2 to keep trying to update memory map and calls to 
      exit boot services as long as there is a failure.
    * Split Page allocation and GHCB page attributes patch into two 
      patches.
 
Pavan Kumar Paluri (2):
  x86 EFI: Bypass call to fdt_check_header()
  x86/efi: Retry call to efi exit boot services

 lib/efi.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

-- 
2.34.1



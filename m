Return-Path: <kvm+bounces-54400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AD6AB2045D
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:51:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 670322A0462
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C765B221FCD;
	Mon, 11 Aug 2025 09:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jwsX7R8O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF8B19D082;
	Mon, 11 Aug 2025 09:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905764; cv=fail; b=p8swASRN+1CwiQgNE2812J7Nvt3q+FxfYrLhjHZyAhTAuxsuDAUIaVlHrbXYl1fh1r/aUrcHC6mDJRjPQAH62JXBWp1+ZmO0/LGgvYPD8tlkoWFyjQ3RRY/73bnkjrXLteVXjX4DF+itFyfIkDLksYekXvjoJszfONxL8VNKLNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905764; c=relaxed/simple;
	bh=MZkmRk5jTeVJY9lb/9xUh4UXDEbWAcopE+3bc51OlgM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=li6eI+8gspxF+xOw88l8EOrV69nvt3lS30SpJyI8nEQaygxIALxyXMhr/8+KOZbi/7hY5K5L1upyo+Xhsfvcm3xA+HcNmvBJui+flU/lEEFrpaZl2dFy3N23GIHOwnPrRQAeNMjRt5J4WbBWGy/cvfmwVzCLG/KIFJch90jTqfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jwsX7R8O; arc=fail smtp.client-ip=40.107.223.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y14MaeIlUtlKvHZ5CXElWtp7oWYcCO0bCIlQC9Tmi5ZDkZt+9W+yzPi7Jhp2WYK0vHAZoVqcb7vkOS+ZMnJWzNippCJ3f5MU+r62UzrDm0l60uFiAmDX699FyqLNKX9+Ibb/qSYRhkkLr99iIrdl0MVl/7K3lFxokg/GHILJD1MLkC/XutZRScUmg2tHXvF5IOpxvMCPFQhzH10uo0Z0s0bUFvPy7w4l8++1IHK80N1fHZHjbHm1M3TB/yXxjpfOmsmQp+bMkBFBdTLs8uPqmNyjhMzvTHE55kJgi8rEEr3PQRssFOpyKGmK3hLSpxyr5kVueRiNFIXlwwT1kS3iQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9/EPmcDBDyaxk95Qznv70DiFqenoxrM0GksnLFkl7Y=;
 b=NRaFqn7Er+pLhKws7GNcyW7Emcdd8l4axgjoIWDL2inguqqBJ9yzpCcQE0RpzAOZYuTADWWcyfFjZrEIUT5k8d2k/laOZseb0/zIwblgPFXzqKbBVzvLIqGtJTXVXc3lNuhgWZvKLyq0lnUfVYN/CwJpjemZRldJoMkHMn4RfEDNZDxZmMerNe9COsbKC9YwUnAswm2vUW5CuFMgn9PYvB8oe8Vkx9fXj5LMbRWiTgZSXgc9SjEjGUIM2Z0v4DuIJukFxVD4Uy1yC6BFyxureaZ5j8pAOtEosv5zQXnRxsn9Nh8ltnILgXPpG1YKL2qxQ6a2woh+S7QlWW6szbzSbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9/EPmcDBDyaxk95Qznv70DiFqenoxrM0GksnLFkl7Y=;
 b=jwsX7R8ONQxC0vHijQgCtvhXon636Zn4aLtItl8rDeFDdZjtRCEpOueyYMnPnu+GpucwhniuBywRFbPqb/2hYRV+jr7i1/qIVM2Ains2zz3wP7QWd1l7ekBEN5Jntujlmq9htYsByZJiQ72GFTi3gCyXSdOmWdVa92/5QYp0+1o=
Received: from CH3P221CA0022.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1e7::12)
 by DS0PR12MB8245.namprd12.prod.outlook.com (2603:10b6:8:f2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 09:49:17 +0000
Received: from CH2PEPF00000140.namprd02.prod.outlook.com
 (2603:10b6:610:1e7:cafe::b6) by CH3P221CA0022.outlook.office365.com
 (2603:10b6:610:1e7::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.21 via Frontend Transport; Mon,
 11 Aug 2025 09:49:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000140.mail.protection.outlook.com (10.167.244.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:49:17 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:49:09 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v9 12/18] x86/sev: Enable NMI support for Secure AVIC
Date: Mon, 11 Aug 2025 15:14:38 +0530
Message-ID: <20250811094444.203161-13-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000140:EE_|DS0PR12MB8245:EE_
X-MS-Office365-Filtering-Correlation-Id: d89bc47f-76dc-4dbe-d211-08ddd8bc568b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HrRe+4m+qy1Zvb8h/EdzqOS822rQWLeX3+2SlSXRNWvo9I0pXgHsLR36dOUk?=
 =?us-ascii?Q?cjtSNDGUVD1QgeV7ni99MD8XZAsFCadTHEIFcB6iWhFM9V/O/4KYzXwVSEyv?=
 =?us-ascii?Q?faHkUlT53DJKsInZKevtnfCl1ONQHPWzctLy1wxhv7Hbmb4oLaVuS+bbVaby?=
 =?us-ascii?Q?tAQUimh3k5gccr2njpPADYoXm05VDNudqWFq2SX2weFYSPVhzdAVy1jvoLcJ?=
 =?us-ascii?Q?mEtpw0NCbO53ZbQRO9YhPSJdDum+jd+53KuAC123mZXc8eO+FV001vheBpxU?=
 =?us-ascii?Q?ml+PzAAOyFAaTPPFYP3RqbYwlgLvXdm/Q2Yt3yHpm1Hquurvvzf/W7hZT0o9?=
 =?us-ascii?Q?85m9C3j3avuCitNfHq8JAsw2hbOlfbLPWrmrhvg2oh2Jlw/p1cq9M+3mHEZJ?=
 =?us-ascii?Q?3fPe0PFmFt81gQDUob+oO7hkHPGTK2xPOd7VuMsrKUUjVownde7RC0iZ+AW9?=
 =?us-ascii?Q?AxiZizBns1QZIxh+ippYOkM05N2SOy2kntisGs1oBUdzQC0bYeVHCZL9DKVz?=
 =?us-ascii?Q?LZvojwuGxEiRCgXRBbcwyVWUW0d0+S2CUqqdvL6yJnKVC/88xVT3GrEiwW5E?=
 =?us-ascii?Q?0CltEbzRNJwjfzerAxajf2cM4i6qoeqUymN/ul42+mnUeRRuGE4817qc4jpf?=
 =?us-ascii?Q?AXw45ayrGOU0BU/gNeWkZZv2uoSSgfu2Nz1DxK0U4kGE+ZvDA37cRB1SgoyH?=
 =?us-ascii?Q?FtZOQG0acAdgo7DihmiJi3+zBljyk6yOKFVGDknC+vcPxyQe1q2lZd33ZHtH?=
 =?us-ascii?Q?9s+YRRV11jEyXT1XAlQ6VpbYIbgPbOzfGvIlzgoaJ7QTJRIuaP+emD+iihLE?=
 =?us-ascii?Q?oNe00gQJU0Zq5Mcg5fscCWoT1cqr/146K98LkYJToCfX1KCsC9LGbkQUIgS+?=
 =?us-ascii?Q?IuFBtyq/b13lweiShJk9T9/AfkTXI67PHavFlPPpM41PbkIM76e6sdPzIDR1?=
 =?us-ascii?Q?YoPJI7BsPpl6C9mdl3secK+Fyy1udYz401P6iPAAtg+aTw1osf9RkgT5N3ku?=
 =?us-ascii?Q?99E2GV8Fta4IjovhB3ctNx4k+ssTz5hkrF2V0syFkMOkuY7vJiS5czWgEUuX?=
 =?us-ascii?Q?uN7F4UM7fy4tbpvFYfKQFbKo4nFwL7jri+HVJy5pCbfyHka13pJMPYXIfqxN?=
 =?us-ascii?Q?8GdrJrpUy1RU0Ov/TP5gErLLH9SAHbfNSw2vMOXg+V/Cz5HRuhu8IgGybe+u?=
 =?us-ascii?Q?a/z1jcGquTUsv4hGzK1jN5q/hm9zLZpKpqeK5WMWEC4W9+Pcvfp+RYHamI2J?=
 =?us-ascii?Q?YQTZdOa5KXDqgAe0aw7ls654bNRN48mj9i+Pde3VQDxTnn627TJ+3pWbcupZ?=
 =?us-ascii?Q?mz92ogQf5dqAam7ygRDzMtJq7dkOU9cl/LMaa0akW2KuTjmFytFyxKe4g92R?=
 =?us-ascii?Q?UMzmeHiHlZRc9XQAtv7CgxtINZzmSXIzW/kDZoRGvS5Q7BEq1mh3PTOgmx86?=
 =?us-ascii?Q?2F7r1wnk9TBmHOtsHUj03mzBddnauXmTEIcbm/tmSIwF/keOENONETQE6Veo?=
 =?us-ascii?Q?2iLP2XQ5VRO0XKNtLvnd3ynO/lK2k5jAw50u?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:49:17.3374
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d89bc47f-76dc-4dbe-d211-08ddd8bc568b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000140.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8245

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Now that support to send NMI IPI and support to inject NMI from
the hypervisor has been added, set V_NMI_ENABLE in VINTR_CTRL
field of VMSA to enable NMI for Secure AVIC guests.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 - Added Tianyu's Reviewed-by.

 arch/x86/coco/sev/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index e341d6239326..d7c53b3eeaa9 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -952,7 +952,7 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip, unsigned
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
 	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
-		vmsa->vintr_ctrl	|= V_GIF_MASK;
+		vmsa->vintr_ctrl	|= (V_GIF_MASK | V_NMI_ENABLE_MASK);
 
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
-- 
2.34.1



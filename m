Return-Path: <kvm+bounces-17225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F848C2BC2
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48F36B23CE9
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6982E13BAD6;
	Fri, 10 May 2024 21:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lT1MgQ8T"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227C513B5A4;
	Fri, 10 May 2024 21:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715376085; cv=fail; b=Tn1HMszWMVwpUtdtezGbOMfuIjfsWO3PP73xB96+SGmRj5GSsXp6eK4N7Ev5lqXWpRUJiGuiw1g93vfMk9nTlV5qVm9/hcfWWJvc8RaiU3XYjCWo//bH5RTa3Gqt169YPXbnnq1TWL4AD7+2KAPLQ6BvAPAxN8rpO25enWOyTY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715376085; c=relaxed/simple;
	bh=BcYxg/4Sp3zdr7LsH8asOGvULTnkzW+IZmjD4eZ0ayg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bFXqg0iCDFaJP204N/G5QYIkOFAps7BskT86TJlLs674ReC6JDbAASEHuYpS432fyHs1UJsvlplglOfBnBHjnx9bRBzhAlfinpPekjONsLsTS3mnS0KT/pBlu+m5ZbjyKi4B9pSP77U5bPytx3Vk/vlaVPjKWqvc/HR1y7wOiz0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lT1MgQ8T; arc=fail smtp.client-ip=40.107.244.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoeiPWiNfCkFBHv2twTlpMldEaSYgX8ZxDc5Ph41ihobfEE4e8jkXlAh10dreIoqp+JzO7rmxauZo1Npm3m9LgCA+JGS7v0nUURWVxnc7JdV37fd361kX//GpTZW3P+n2OBSAPRXnHblzeZTREzd6YmeuBDr1mxo5r7M/KWr9KoQhQHf/FYEj/YnEAWdDrbw8RqNW2bM02U0pWfdGOFiDrKy7Z2uOdOF9lwlxXIzjDF51z9u5EYoWQrESaW2sHEIZZGy2GS37ec8z1WHimmj+rubuGCWJdWKUbfgGv1YP5miRW1g3vlJUnizC6UiebWGei3hVWwGY8hgbOJUECt7Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/w7HkGwErEFXk5K+70K1QxZapZm3c5E5wfTsmBvpDxo=;
 b=nVxXK/SHNBhc8H0lEWFdjFEWh7PSxkeEDLxAW0Tsn0LS+gmyhK7zG28fm8qBEBx4ebK37ukWlKiiS4tnFVzRE6KYjxkFSxwtmHO4nCIgScncR75qPdIMEdXbPrzvzL/coQBfqurw5iJTdYS1kSN+EUjSzTC3r1t50jqMJs8c1XRCwwLr4Xm5Dsjat3eODnjMACL1NL7Q/5FoaCkPEKUynTNFP+AmPbZKdXS06lNlOxlFhGVYh5m2++bhjU/PUYXyRWFjefWhK9XObEnbBgot/vs2Oo36F8na031noySJ17DOR6nVMWrS+cLOCTCTlkhnPPNLKgM1JsRFpgPEjXmSYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/w7HkGwErEFXk5K+70K1QxZapZm3c5E5wfTsmBvpDxo=;
 b=lT1MgQ8TVR1s4/0hVLaKLp6Y86rOCntedzpRS5l3pB7hALaF6Y+hkne3PLB1AWC5eL8xYJEIrNqsDU6oLccScLEFGZMLAvjysjJmKSJLDq4DPAR8SJoM6S30AoPTlgJNwD5cYZPZXUePoRKyfvcccWESFVN+K4lz7PPbnRmvfGE=
Received: from BN9PR03CA0372.namprd03.prod.outlook.com (2603:10b6:408:f7::17)
 by DS0PR12MB6415.namprd12.prod.outlook.com (2603:10b6:8:cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.47; Fri, 10 May
 2024 21:21:18 +0000
Received: from BN2PEPF000044A2.namprd02.prod.outlook.com
 (2603:10b6:408:f7:cafe::51) by BN9PR03CA0372.outlook.office365.com
 (2603:10b6:408:f7::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.45 via Frontend
 Transport; Fri, 10 May 2024 21:21:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A2.mail.protection.outlook.com (10.167.243.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:21:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:21:16 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>
Subject: [PULL 02/19] KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
Date: Fri, 10 May 2024 16:10:07 -0500
Message-ID: <20240510211024.556136-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240510211024.556136-1-michael.roth@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A2:EE_|DS0PR12MB6415:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dea16b3-0fea-4fc1-ed40-08dc7137216b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NJcvsrAOvIkoldWYRBV30y5h+noi04Es/ucism8btk+Xeh3rTacyPojc1bPx?=
 =?us-ascii?Q?EGvs3bQleRO1RP21fr32E8AJjOVBhDPpM/TBs1vijv4lT8Z3DIoQOwyojfwZ?=
 =?us-ascii?Q?x3QkU3PE+WB7FKgzIskxGvdILt5nepxany1uprmrjjjZMaI2STlgG5Q3UGjK?=
 =?us-ascii?Q?B3LN1fa3Dc8Fho9TLDgs+aNfZSmVc2cyUxF+6nCYL8XczHgD4239Yj3YgEGk?=
 =?us-ascii?Q?SoTdzRNg5MU8zRYKEdPrIwi9sNyZ9bm6REUFahq5NUmZLAhiYzMkvGd+fXy7?=
 =?us-ascii?Q?i/81HrYkZJPC/qLrU3VldVys3GAM0gAfIXpkTKJfZ2cGZCwdYzd52Edbkq1N?=
 =?us-ascii?Q?2auh8Zs4a5tMh3ASSLkJMBQCgBjkzOUhQMET2AGuAkxfZkW5lbc7uDJ23xwt?=
 =?us-ascii?Q?kzu8P3ooMMWgugmi/bGEQWyWYFPJO5Hjfmlv+VnORxdGw0rJXXliF4Q7ZkgI?=
 =?us-ascii?Q?Mbg61rSoG0c1tjt/erJFnrrLC/pLHPD5PexvY/wROQgTi7aYPHtNqOzrJuvl?=
 =?us-ascii?Q?4M0e7pyriqXBXkWqY/AYKmz9IgGZihGQso4esN3+e9C+wEI5okxaE2ZmQFJl?=
 =?us-ascii?Q?qNrFw6zJlv9GpuErKAfqj2hmiHLFLZkrdZA6a+ISfqHFssqM+t5MnZ1uFjNk?=
 =?us-ascii?Q?wifqUMQirunGwX7fZJFDSUgw91r2p+F6lwGYZrqj1UnsQjc+46TcoE0Ahve8?=
 =?us-ascii?Q?E2VURbKF0RHzxBkVl4lctX7bJeiZLwk3aS2bGyQDA3KOUn9dXazl4VIG+amC?=
 =?us-ascii?Q?7IklXahhbx7CEJZItDWgn1iic/H8Qwm4ZnEFjEbVeY1NO1wn72VQ2NrXRBnJ?=
 =?us-ascii?Q?dTVgCSk7TPas2jfhGCvnUGV5CHruXrywaOQrLDiroCfnc1d7v7TJaq9W2ngP?=
 =?us-ascii?Q?X9lCBCu/e94Tm6Q/IH7dA4dnnUCK3185WKcPdw0eFN1aWO2qedFcUDD7/25U?=
 =?us-ascii?Q?XZfFXSzDErqT9wkhz8sT0g2+kLv808khhkl1MsEwbOUy9vtu7FH3hTbUH0bq?=
 =?us-ascii?Q?aMn1jT//zGtgVvrgRQh0zvkoAd1w7gvoiHNEiwlpNT3q7JKb0x7/Z9gnPT7x?=
 =?us-ascii?Q?JKrgkIuI0pLuv+sflIJ95m3KXDmCGTmSlndFUI5pVW8b+cMn+n+qEB5t/2eY?=
 =?us-ascii?Q?JY1iso6CkFlzRy4A2RtZBUVjWKHrBGC9kxviiGw4tMeNQ7MqV7zQRLSM/zIe?=
 =?us-ascii?Q?Bhy4UPaa1I6blRQ5sbrbKs1IIK4VqRD6Y8NzZMqSPQW16jp+QwNrXUt3npyu?=
 =?us-ascii?Q?eJkiGHqrwk5yEzz4BLfwy+NO99BhCh4X3+q6/hU+COz0PPWxw5XBQH50+J3d?=
 =?us-ascii?Q?GqCZ3lBDnT+7o8HwDmBVoG/GilB00pl7uCm2pzOo7CY0iDd8kCPajRoDta2A?=
 =?us-ascii?Q?8HROjmmJeoNfuVCPimPZbynLLEaP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:21:17.7160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dea16b3-0fea-4fc1-ed40-08dc7137216b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6415

SEV-SNP relies on private memory support to run guests, so make sure to
enable that support via the CONFIG_KVM_GENERIC_PRIVATE_MEM config
option.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-ID: <20240501085210.2213060-4-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index d64fb2b3eb69..5e72faca4e8f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -136,6 +136,7 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
+	select KVM_GENERIC_PRIVATE_MEM
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
-- 
2.25.1



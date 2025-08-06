Return-Path: <kvm+bounces-54193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B8C9B1CE0F
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1B9118C6F24
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F24823815D;
	Wed,  6 Aug 2025 20:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bpREdrFk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2066.outbound.protection.outlook.com [40.107.95.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05ED519E992;
	Wed,  6 Aug 2025 20:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754513255; cv=fail; b=Dy89F49hDfnaiiSmFXdhJSjZk+HPFTqYT7um/Us7Dvrmw1tACTXymuNSKrdShp3EJjLuYtjqc7gfYljavspNurZ6gltmPsjPdn8G3n1+oNDg5Gw7EW0LZzEKKl92fvDnn5yHWvnFK3YiXcn8wfgVZDjj1pIpk40VwfmnrUdASIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754513255; c=relaxed/simple;
	bh=LNFcM/5ZdouRceuuqXnbihoKPrmVlL0TZ+sxa7OWsDM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HmvBOLLLAQH+fwMMTIhu6M9BBtJi6gXcmMXqOUdH7WqY7muMG0fWzC5JrDKQe7RCIjyyAVxehYcqraltCbCWO38iFdfQpKkMKpNGvLvTX/Jb9FLMPz5t4VGU7A4l0g5W5uMVsS9Rkmi6oVeKAA0Es1p+HjpTbS7XJWJtPRk4BOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bpREdrFk; arc=fail smtp.client-ip=40.107.95.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gwKcoLUp/1793u7BnOlj/liRkD2qLbEYUFAwikVsPbD3BpSLWG1DcnE40zHbVUthGPK03YOKRgxtH8eiWYoJeTRGYIZrFhEW9yOJYq5R0hrkE9xSJxLOq8nkmRRIQaSXa6IXpEh/INAS+SgyWwDPBYzpR3Fb5uxRDvbQ+v5kjEGP/xCLBKUWHL46k0+f3BAVaV4eodFe3Ej5N9pkzlw6Vqb+OgeZzd36d864faL9NcRQf5dqn8N/MjPsik78kDN0cvwIM0W8WtBBd+COiPyJSRFEey5p+8Y69RCCGN32VSVzlALkpsl64mhaHDkw51TZqpai7v+JA0bofIBOsmVO5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8SMDLK1XV5M2HM95lKpMn5XEB01YvLiitg542+6OUGM=;
 b=wf2Ht6BgmHIV3OQVmQQSNBJj/YkdCn866ufNKneDnOxnvya2GyRQNvFw4ymkoI0VlsxRq9oU93Sdw+Ga23je0Oi9dzUvMd2oq0e5emzJ/Z6A2NHq6I2kta2ANej8sDEAiqvG9ifAhP5WO6LuKHjByjtP1fZfvpMQamv2qKtLCwx5CV6A7qLvBYgzOYdqU2KT4sdxIfZwXJSJCT0pMZvbEZKLxsxUDyhOnMSmcEDWpU31J4w59p8FX+gd1tiNcUTwJYJlXFA86gudJSxnK0SBFfVx3u8tAV+D9ka+xfcC5lBzifuzAV8p9yOzPk0BxqeCmHNNBr/1E2IdiJwwjAibgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8SMDLK1XV5M2HM95lKpMn5XEB01YvLiitg542+6OUGM=;
 b=bpREdrFkYECfqxgvik/SJQ2D2JKz0lKvryqM5WhID6FuK5479ZGVMaCULizMiV2BU9wOJiDm5ZBsoG6jhjHt59qC949jt0OrTaGbMhkoacyaPRTh7eYVufWy5nilJJRq6zqXsTY9JmY8sxuqr8MCdeHYqVQwJ+2ekrINBOnfORY=
Received: from BY3PR05CA0060.namprd05.prod.outlook.com (2603:10b6:a03:39b::35)
 by CY8PR12MB7291.namprd12.prod.outlook.com (2603:10b6:930:54::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Wed, 6 Aug
 2025 20:47:30 +0000
Received: from CY4PEPF0000E9D8.namprd05.prod.outlook.com
 (2603:10b6:a03:39b:cafe::fc) by BY3PR05CA0060.outlook.office365.com
 (2603:10b6:a03:39b::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.6 via Frontend Transport; Wed, 6
 Aug 2025 20:47:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D8.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Wed, 6 Aug 2025 20:47:29 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 6 Aug
 2025 15:47:28 -0500
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH 0/2] Support for SEV-ES guest shadow stack
Date: Wed, 6 Aug 2025 20:46:57 +0000
Message-ID: <20250806204659.59099-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D8:EE_|CY8PR12MB7291:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f1de29d-41a3-45ae-4960-08ddd52a7589
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LegiQbWlo5LgswTdSQh8hEnNTfg71xj06QCPWSUsNhoZ17inbNjIdgrD4UGe?=
 =?us-ascii?Q?e1Tv6YejzXm87V6iuIUzMsJ8yD1Gio4V2x/rgd/PXzKAIhDvxUC/XFChW1OQ?=
 =?us-ascii?Q?661Pkkq22MEumzdatNZ3mSs44rJfs6dDOIeDWfngsMiqaiRlz2EUTq4XiAyG?=
 =?us-ascii?Q?PF9ebfCrCPe9tolhuyi/CzQqTBvwKX7wWnRfR/R+Tu0Wr2MWpzgG8lJXkLXZ?=
 =?us-ascii?Q?DYWOWiKVyaVh/jm/SVr6aKEXDmG/wjXRcF17Vja6UUtpnUaiS3U5IQC8jfb0?=
 =?us-ascii?Q?ZLeQFFvgIsV3iy/GMzGIhylmVNMju9pGq7RwWEUeGXi6xQh/HMyo+LPxvwXJ?=
 =?us-ascii?Q?DcvhO7SX9vqKF7LNPExL3Fb3I7KkBYxxVOMb2n4BEObip5qfkFkDTy5rxk+o?=
 =?us-ascii?Q?eOHo24BcpYmyIRMc7dEbAcaKk3jhfe6j9BzQrCBscGeBpD6c2hkWTLAvzhhO?=
 =?us-ascii?Q?oD5Fk9Fl5jhBDwdodv3cj2hJxsNnNB5fGtrrxF37+/GTq/vDLqJ0+J/6upCD?=
 =?us-ascii?Q?CaYttTfzqQ/Djq3FnaYCPn3+GTdaBeSNBy85ahe996iLbdvqTpIVkCAQDxd9?=
 =?us-ascii?Q?30UsHm/Bg8taS858DPPgvIg9Q3ksagpKOgsb0cHRiWiwHjYBruQFxxBHM1z2?=
 =?us-ascii?Q?5gmjpv3B9ueTVmTlUjeSUbP20DFtjb3eIHawVUUycESL1Jvi2PZc/iykUZad?=
 =?us-ascii?Q?P7UmvH90Lb+/5wefX7jRuHwqRNUQi6EIW4TsYpLPl4oU33O3kzvLuyhu2bpV?=
 =?us-ascii?Q?E+mm9xOz0UtHSs42xSmlbG1+tJM7HkvY6TdiFSlB6x/tOtKN+vFLKWFDzTJG?=
 =?us-ascii?Q?fyWAyvxDwrxqSW1dgdIVK6ZJmpdl8hvjPVBMPqKBGyMTxo7x7Ny09rNowTTw?=
 =?us-ascii?Q?bmHE6ZrU7JD8V501tKaERGVa1b1MaP6en/Po4mwSo8D8JUmWow6pkiiXRCbt?=
 =?us-ascii?Q?xDhOt2sTXJczzPFO+/2/zdx5mnWgQeXhTyMMdpOqcKk1slb2/PPe0Qzlc81G?=
 =?us-ascii?Q?Gsg94gxYNyIHvmruTGz91djYSH26P7tJ8yqKI7X12i1YhWFfW/c8j5VR7g5n?=
 =?us-ascii?Q?Cn5AxgONR/sElSYp0MC05XduouKSZR25CCxTN1YAioZUaQ/btyYO2wK+gxUh?=
 =?us-ascii?Q?fHVocyNT+qxjyKj7wYHCoCUbXGrd570KlObvMXMgVsylCyPoT0wbcoSASV0x?=
 =?us-ascii?Q?MjFSbT5nQjQETQii7ODgson5zMtH5e1mURk0uHho+/VlZJSRGx5ZRRd8WWEH?=
 =?us-ascii?Q?sj2UofyTlnXjqp5FpQJTWCfmlc1My6LCCKnuBvovAqttk5t4CGHP2u1OG83y?=
 =?us-ascii?Q?lVXraAftqsLkTIRr4ePlZUTYlsda6bpE+85uhDF/xnynXl/AdgsNC24kro/9?=
 =?us-ascii?Q?zpmBTlqjLihH0ZBDfDQgS9UvQS2g8Iy7ljFuid7zcJh5+aaeWZ4FlLIuDsIf?=
 =?us-ascii?Q?4Qbwh2l7vf5bIADdNDnpMGrHix+0fcWNy1Yyccv9hvPJHcqOSL8spneMIz6d?=
 =?us-ascii?Q?54SdMNdp6Q3M2GqTPd6ZR4RpZTHfTaOsquDY?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 20:47:29.2877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f1de29d-41a3-45ae-4960-08ddd52a7589
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7291

For shadow stack support in SVM when using SEV-ES, the guest kernel needs to
save XSS to the GHCB in order for the hypervisor to determine the XSAVES save
area size.

This series can be applied independently of the hypervisor series in order to
support non-KVM hypervisors.

John Allen (2):
  x86/boot: Move boot_*msr helpers to asm/shared/msr.h
  x86/sev-es: Include XSS value in GHCB CPUID request

 arch/x86/boot/compressed/sev.c    |  7 ++++---
 arch/x86/boot/compressed/sev.h    |  6 +++---
 arch/x86/boot/cpucheck.c          | 16 ++++++++--------
 arch/x86/boot/msr.h               | 26 --------------------------
 arch/x86/coco/sev/vc-shared.c     | 11 +++++++++++
 arch/x86/include/asm/shared/msr.h | 15 +++++++++++++++
 arch/x86/include/asm/svm.h        |  1 +
 7 files changed, 42 insertions(+), 40 deletions(-)
 delete mode 100644 arch/x86/boot/msr.h

-- 
2.34.1



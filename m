Return-Path: <kvm+bounces-34491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62A1A9FFB17
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 16:43:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28860162559
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 15:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49CF1B3949;
	Thu,  2 Jan 2025 15:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YFRTs9X4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2074.outbound.protection.outlook.com [40.107.101.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8F11A4E9E
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 15:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735832612; cv=fail; b=A6zyRYJi4mHhyBn0dw1Gy7UHUtDT14UpZhTVgaHdSPWk3kmaDUETMUiiTJKCvDOC17VJtEYQvBMOd0C0PMeFPpyveopgKkg8HGfY89K1214ZQvybzuKTW89o8szvFa6xShQKBqkPibCOUTZViGZ0Qk1yXJKt7Ii8O1Ef6gLl5Gc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735832612; c=relaxed/simple;
	bh=dv3MXhq0kvgaqfRs6qEtzA98yxnjxoWE8lbYk1CyrSU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OxVTCRMq8u56kOoBxk0ZNoABpcqRLJjSrDIZJVhOp4IdQZDhB/SPQ55Pf8FS8+bXGUxAFQoob72r8e7VB2Hcjq61pdKHf3qlsyNC3ZCEFReEkzCjyvKw3xCe+vJ7lHpvh7iMZGD5TeJdFaSXA9dAs46TsT32N1errF931cyFrZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YFRTs9X4; arc=fail smtp.client-ip=40.107.101.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jrP9iIzxyzM7usX3NO7li75kCtOEvPl8ovL6IYeK4lY3TwB5xFdt3ol/MmhhK0UNrMmJCOgFo1b4ZK93OItuDVerdKxlps1ow4SBJMVaVLZ2koN8oAkBkmMerBS+F3JriSeH+5jQsLGModeKwcOH14kDocNjFo/klbkiDcc3mmSbL95DpZkmBpW765hOdKHqDDD1hgJDp6YQRMCgTuUtybxt8PoO1T3+LpRZrz5WPUJq6SGrw8rWs4ScYjEjJ/Qb1MFghl8j13CQUABxOWoK/oHqfvhg/lb4ga8h0oShGSRrL6LqlCbMOxIqXMZshFuTsHU90K20VA1L29mv6SAydw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eNjsWHD8bHtUm7QaW+5IVh6bkCvL9Bx8KL5kgwmUTiA=;
 b=vR4BsPfd4OAuviDx7BMBIU6RMeE9YmPL5l2BZW0ueH5Miril+HKSIqlndezdznUhiAK/HIaA1vmFG69OESZiCVNJvjcF4eS/fFpyds7mRzKgb+vyEA4rx9XK/p0QSvZ11uSAcjCcQavHAB/hEKViqx21rJjrEjQ5xw5Mod+3djLJb2A7UOniqUsjROtce4wKhuf+yEElHNJ2vbnsEJtkMOwoTrTUKbG3r55Py/BJDR32k5Jt859M0or7YvnZwZX1vOChUqASGOxnpwHOTyfua9ZpxlVVVptCSqLthpTFeSoIauCpYOpao/ok/54TZiRa4tQfbh0OcECe4lwcUj3FTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNjsWHD8bHtUm7QaW+5IVh6bkCvL9Bx8KL5kgwmUTiA=;
 b=YFRTs9X4gDqbVaVpQbFKx8RKqJVV5w6zDUANbKvT4C7HnbbEBZefJAWqRIE4h2oCxXjQqAtrxgIzfPs9WiCzWBZBsmBtfz+u01A5W4upx5VpUMKa2tDdH/mvXyEEcE0qTMd+JdKJ5cxR4u9pSOSfMgDnyyiZByXX8rNraDtTSbo=
Received: from BY1P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::17)
 by DM4PR12MB7621.namprd12.prod.outlook.com (2603:10b6:8:10a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.19; Thu, 2 Jan
 2025 15:43:23 +0000
Received: from SJ1PEPF00001CE2.namprd05.prod.outlook.com
 (2603:10b6:a03:59d:cafe::24) by BY1P220CA0013.outlook.office365.com
 (2603:10b6:a03:59d::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.14 via Frontend Transport; Thu,
 2 Jan 2025 15:43:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE2.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8314.11 via Frontend Transport; Thu, 2 Jan 2025 15:43:22 +0000
Received: from MIKCARGYRIS01.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 2 Jan
 2025 09:43:20 -0600
From: Costas Argyris <costas.argyris@amd.com>
To: KVM <kvm@vger.kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Tom Lendacky
	<thomas.lendacky@amd.com>
Subject: [PATCH] KVM: VMX: Reinstate __exit attribute for vmx_exit
Date: Thu, 2 Jan 2025 15:40:50 +0000
Message-ID: <20250102154050.2403-1-costas.argyris@amd.com>
X-Mailer: git-send-email 2.45.2.windows.1
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE2:EE_|DM4PR12MB7621:EE_
X-MS-Office365-Filtering-Correlation-Id: 04f8177c-2128-4255-d5e9-08dd2b44307d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7Pxm7S6ZQu/AKtmqkt5HbkPU+nfSBGCsJgfBDJLw6dtAU6PKyAw3xlLdTifr?=
 =?us-ascii?Q?XrW1mhzJdTScSecriHzc9F/e/aqoEss/2DZ5Dk3H2Ep1Ursq9zmBcY2T7iqE?=
 =?us-ascii?Q?enXB50QHs25wYCBJVDFsnk78uXvyA57w5m5G5uAmU2wEO/ueKuGnFcPOnsN7?=
 =?us-ascii?Q?4/9LHqK2SYro1R+TIyiyrqzsy797qrL5SxUeNlTlXUQTmIfC5b55AMWftvP5?=
 =?us-ascii?Q?UOO09B4fTA2iln8MCnrFSNcS+8Vi38R+NxdzHr/UEOORFIhsgVMYWWk33J0V?=
 =?us-ascii?Q?ftN09XX2Lq18Ht04kRaTryUoYgsOK8VaYqN2NxKt5cnGO8N8YOLEFT64pGTf?=
 =?us-ascii?Q?ouXVQM90tCoeUDYnqfEDB1Z5xxXP5ZpNxz3Qw5YjIei90MNH7RyS9Hyd1hFP?=
 =?us-ascii?Q?l65bEU03hrrVm1e3x7zfnGJkeO89umdB1Ybp4yAbDLwkTuRQbA+sdHcCdLIs?=
 =?us-ascii?Q?7B0HtBw/ghkSVnI+uWW6pGi7e3Eu/HsN2/GHARCiZhVoSRvd+0+yaw5ReVqC?=
 =?us-ascii?Q?vZboYaYkEftdlaSI+wXeda51sfSItG9IpVH5AOFlEU8sQ7dcYPMXoqSYZgbS?=
 =?us-ascii?Q?OX5tsTihO85g7MVvEDJ8Pdqj+3nRtwUo/em1+5dlv9CzdDovwJ0uTvdu26NK?=
 =?us-ascii?Q?8Dv+gMLzsPMErPg8dIyAuKikO2aajU8lmrphgrpsgmWQ/2iAHSpYAimpuKbb?=
 =?us-ascii?Q?ZiFGaf69r2ZVCpLEjwsQmrHnX347B/pIumvTR3A2EkQQTVbOwNAEegLQPqgx?=
 =?us-ascii?Q?Z1u18WbW2GETkFBjeFmWPYFzgoLD8kAyfGYrIe5zFT9PfObQKRWlp3EPPfob?=
 =?us-ascii?Q?aslBkOTPoP91wcFDKsWJFv99u5OeLmiaxkNkNZYfZrOZ8LfTT1h4ccK+7SIp?=
 =?us-ascii?Q?IZ3DAKR+/mTzAW4t7x7UlFaYnNeC8WhwtJzeaKuJJbMl+QUmon8Tp9AHIwFm?=
 =?us-ascii?Q?XYk7CIiPc85F5Cfq5ZqCEMVN8ca+cemy+jmelWHaFwplxLkl0ZG2Nnw+d71E?=
 =?us-ascii?Q?4W9KeeCyHLuYVxNlG+c+l+0Zubk2X15YAN07grRq23MgFhGH9JhxfqpwImpu?=
 =?us-ascii?Q?DuYhRGTpmhgjKqzGE/nNcVmlXotBUEobYW4UtMQ/nAwZqdsK5kk8MZwLAIMQ?=
 =?us-ascii?Q?qsuRybL3mlUrfE022VEOJh+nXcuQOJ7LAKgr7VYl1qZxXf9Xto/7zMdqgdGO?=
 =?us-ascii?Q?P1gFBk/sdPBqNDB03PMnzmAyvQLuWwhcLIslztXYqeRz+j7As/iW4L5PljIk?=
 =?us-ascii?Q?xDIVLG02xCYfP2I2JCCQiPL7IY1HZhMMRXQjtEEVRiqlunW+vdRjhtTx+buB?=
 =?us-ascii?Q?skfLFF0Cu0tlw8ziIhe6T3HDxqJ9QQoxzRr8vY//QcGSvq/JXNuIJvWQ+aVz?=
 =?us-ascii?Q?KcvdhlXnj0StxWFclOVtgvjYkCeV3uAU/kh0dr+xr2TR/19tDecRyopomv7S?=
 =?us-ascii?Q?u6enrHBOUHG0lxjUE+Au+hBVFuFA5GA0we42894l+ur42zNJjkeCfF+bPDR2?=
 =?us-ascii?Q?ajTqw0xoQ28vTFc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 15:43:22.6239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f8177c-2128-4255-d5e9-08dd2b44307d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7621

Commit a7b9020b06ec ("x86/l1tf: Handle EPT disabled state proper",
2018-07-13) dropped the "__exit" attribute from vmx_exit because
vmx_init was changed to call vmx_exit.

However, commit e32b120071ea (KVM: VMX: Do _all_ initialization
before exposing /dev/kvm to userspace, 2022-11-30) changed vmx_init
to call __vmx_exit instead of vmx_exit. This made it possible to
mark vmx_exit as "__exit" again, as it originally was, and enjoy
the benefits that it provides (the function can be discarded from
memory in situations where it cannot be called, like the module
being built-in or module unloading being disabled in the kernel).

Signed-off-by: Costas Argyris <costas.argyris@amd.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 893366e53732..b98174b44b89 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8597,7 +8597,7 @@ static void __vmx_exit(void)
 	vmx_cleanup_l1d_flush();
 }
 
-static void vmx_exit(void)
+static void __exit vmx_exit(void)
 {
 	kvm_exit();
 	__vmx_exit();
-- 
2.39.5



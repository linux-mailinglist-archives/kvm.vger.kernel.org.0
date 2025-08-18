Return-Path: <kvm+bounces-54907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B46FEB2B1F3
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 21:58:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29229188B222
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 19:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F64D274B55;
	Mon, 18 Aug 2025 19:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WxYjjG9W"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C65821171D;
	Mon, 18 Aug 2025 19:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755547116; cv=fail; b=MdUsMRZS/zXnSH898CzPIDKbvu9HqHP69U7h5ihQ50syN+RsbsQgDYcPRRLN4QfNcWV598sH1GGe/rswtDL2f8AIuU87sK5AmkjQBwghz101x0eujxymsdHI/wbRrK8N+lkS9HvpHnKhZ9vIjEqpmzjP/8udQlcLKDRqu9JOSl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755547116; c=relaxed/simple;
	bh=XoDJ4AOsJ0KXow+l6AmVloF32iepcuPpS/oLpVOwUJU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bJAoSMULVncWOM2Y3U06BvC2Psk4jX/57ED5VNxWhKmHwvdEvcc9N+kFiy4IJHcNazXsuGTwPcZnY2mJWgyAoyU2KqhxuJMP+IUbewrT5XF0Ef9pwFempF9K/B1fRHVRrLk/eQL6ltzN3hj66elON/q5kl6iW3paE4Xv33JDzJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WxYjjG9W; arc=fail smtp.client-ip=40.107.243.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aa34hmeyiPoN//x1bjzHjRkkgcqKnHlbdLce4Ah3VHMpGlfiyzUrJNE01s9dbjiF0qCsZPvYGnrkLg6rR1u59aEOaWXTxO286NEl1oYIptkvejTRx8DKNBX+ab7ehbR4IQ6S2Z4Hs12NQd4vDM4xc9g+EolwjZOzPP/t7F9FBNHSbyf/mziOx1TTx86sDetN8nJWMkQpNuWDbKczjHScRjvNn2nKnerkoSS751sC1iBkhrqpAcrur+c4Vy5xZ6steQK4CP4+UJKXbJNGpfifohaj4rTRNSsW9y2Tf8s93KliRIJBmNCq3oYQmIuCPht5qxy0VbjEOyU3888A+J1kiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A91v4TCcomHX9Wt9sCa6K/2lvGqaGUN7wG23ATi2x3U=;
 b=gM890ZPK7B7pnKE6+gBC+Et1eojcCLrTvdpT5zFOP7jics+68gOuCxqf8WkGqvBkU/sZV4rHHfnsxbyQI1Idk1GgVq3AzzonHJw34JPAVZF1Da9hmfI1gEDpD8hcJwhuQxe58OQukHS21hDYYd5TXrllbOiUIbBoxCYJBq4Vwt6BDsWYmydLfRR6W9Egnm2DpJSwCCevI9xE0dQpcnDvc/dqE7BZWHiQrD8VN5fc5FFwrwamWCdSOO+/jUaim6mQM4XAkSxPRf1fw++D34jLilhpfkUDZYg0IV7sBd3wZhtbJk+yk05zRS6L9NUpbRjP6/Ia2vTKKRLZuhWcvj5Kvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A91v4TCcomHX9Wt9sCa6K/2lvGqaGUN7wG23ATi2x3U=;
 b=WxYjjG9WPv40826aPpaecJdVojOOvIg5t9eZC7D5jPP1gXUf5nWs6uPMsVzXlelOdSdUblJNzVfEnLmJazEoLca8kJERx2TUIxUAs6xx8uohLaxkgAf3zZAKD/u4aF2YjLZSj/X/fonAM6cM4HRU1tY5/ms9lk+nk7urlD0XrC8=
Received: from BN8PR15CA0070.namprd15.prod.outlook.com (2603:10b6:408:80::47)
 by SA0PR12MB7001.namprd12.prod.outlook.com (2603:10b6:806:2c0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 19:58:31 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:408:80:cafe::61) by BN8PR15CA0070.outlook.office365.com
 (2603:10b6:408:80::47) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.19 via Frontend Transport; Mon,
 18 Aug 2025 19:58:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 18 Aug 2025 19:58:31 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 14:58:29 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v2 0/3] crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver
Date: Mon, 18 Aug 2025 19:58:15 +0000
Message-ID: <cover.1755545773.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|SA0PR12MB7001:EE_
X-MS-Office365-Filtering-Correlation-Id: 043d0cc5-8b57-4514-9ed8-08ddde919b33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gtRSlSbi2WcpCsXhTglqpw3OQlGfWjM8HQpNCITIyDqlVvqEXRr7nsBH/bbj?=
 =?us-ascii?Q?s2yFOsCswyrbiMQzWjOhK2KHJ/7Vquv4jo9mbaQ8/4qBrp4ONyUTTzQtkrhp?=
 =?us-ascii?Q?8BgBnntuT3Am3Wmwmun+VkpJ6/nB5YWVhcVGBxYSmtfe/FAlZ0/qFYy9jteL?=
 =?us-ascii?Q?+CgBXxMsxhOn1LmyhEAAmDBRUk6VK+rcWMoxCVExR8UQLBQbNb4NZYE2ZXrf?=
 =?us-ascii?Q?kwuwtxK0dELr+fdOg6WuiU74Ct68XLV4mNxWasJ5MJe9dbvsMzCK8vDQnWrl?=
 =?us-ascii?Q?Qn2rA269GbgEMgxiD0cwIFcna0CxZSkvBCDQBDCUEDsyBzKyxZb8c8L4vAL8?=
 =?us-ascii?Q?WGrShvo7GL5BAtEVXsqoWObC+8s3/ofW9uW34UsSB7Mj0aP+VrCoRO/gqiUk?=
 =?us-ascii?Q?5ZVqgF7AVbNZZfVtIEB9Ouppi0AtA8p3+1RH1DcQAxpwSgwuJ6odFYb+gU7j?=
 =?us-ascii?Q?wNq9YU6XFt2YVoQNO44Lou4HW9waVNApplTzZHQ6OT/22iCfkzKBDFWCp4dY?=
 =?us-ascii?Q?ov9UHmkS+NItUpMELOcbpLCBGD/yHG9fBFE7rbWmfTUE5Ep4+6SeNeIt/fzo?=
 =?us-ascii?Q?qa2h8OqfwATq5v799hBbaMBjJERp+iIDLqMBBiCrYpy9RRkoN5qERbBtvhmh?=
 =?us-ascii?Q?JwaErFMAu3d/Ny3YbSKKN2MM9E7zOOi9YkqmTwlv5G3Jztw9puzoI/jtbV8/?=
 =?us-ascii?Q?0GW+hBpA5UCV/O3TxLGKNlAIDxkxmQ22n7czK7+e3uQICkM4c1vX6asia8XO?=
 =?us-ascii?Q?b4TAuKOwhx+VTzWxYT+FhrEI1R5Qf35zHphCYUgCIOr2E+2L+TJfxkok/HN+?=
 =?us-ascii?Q?+lY/2rz+Caaco2PtpuVcJfKTTwAV6SSUApQXJBnvzeyLVt0Q+V8jLjDNOrhY?=
 =?us-ascii?Q?La7M6bXXdl1orJ1AkRfwva0FAXISwQX6Z03lIYN75BeuIjSHkML1PwP73hB5?=
 =?us-ascii?Q?a36uveAI5apDQJhs5Jc1Nq3R+8dObAPjzhNpp9xNCtZ4/MgO04vbdUISxnL7?=
 =?us-ascii?Q?+XHEadREK5/thr1kBpsq9tYEqLb6eogV52vChxceGqhbcHeaiwd30kllOR9k?=
 =?us-ascii?Q?Y1FMS62M9c3CQFtO+rP7Ttm2uiEPFm/BxMg1iJxosPHwikL+ABuvA9dTH+tL?=
 =?us-ascii?Q?rUmlql8kdaC3me4yZl72YGJgm+eCTRXFsOjH3JTAdTZUtsKDD3AnP1tw3p9W?=
 =?us-ascii?Q?dx9R9iuJRtkYj4AmW0E8BzZ6q5c0kNG7krg1wA1JefMf/NV9ZnLfR/9CaP5k?=
 =?us-ascii?Q?Jo2QjLksY0YCRescMdT1l86lvo5Iu4Szxx7fJrh/9tG08FKGzuIuaM7wyO3g?=
 =?us-ascii?Q?78Mc7wyC0Gu/HrFQcbEcvOz3tHjun5BYGJmCwoTA8j+U8EFP1AgPoGrNt5eK?=
 =?us-ascii?Q?MWyIHZLijKc+1NvLRzEvL5rFUvgSLU9tj4fRFzCVie9GtkodJ0IiX8ABfT/F?=
 =?us-ascii?Q?K7CWO95UI8mxX7Tgl2LuzRAeTSOXLJAl/uVZju07f/q3/bpREa0XmHmEvCFj?=
 =?us-ascii?Q?Dy9Hlqic5ZJWJk0w+RIPP9Iqtf76OqWeHjNGVeHYSm7OoNCwa4XpD7OKJA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 19:58:31.1513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 043d0cc5-8b57-4514-9ed8-08ddde919b33
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7001

From: Ashish Kalra <ashish.kalra@amd.com>

AMD Seamless Firmware Servicing (SFS) is a secure method to allow
non-persistent updates to running firmware and settings without
requiring BIOS reflash and/or system reset.

SFS does not address anything that runs on the x86 processors and
it can be used to update ASP firmware, modules, register settings
and update firmware for other microprocessors like TMPM, etc.

SFS driver support adds ioctl support to communicate the SFS
commands to the ASP/PSP by using the TEE mailbox interface.

The Seamless Firmware Servicing (SFS) driver is added as a
PSP sub-device.

Includes pre-patch to add new generic SEV API interface to allocate/free
hypervisor fixed pages which abstracts hypervisor fixed page allocation
and free for PSP sub devices. The API internally uses SNP_INIT_EX to
transition pages to HV-Fixed page state.

For detailed information, please look at the SFS specifications:
https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58604.pdf

v2:
- Change API interface from adding/removing HV_Fixed pages to
  allocate/free HV_Fixed pages.
- Move to guard() for all mutexes/spinlocks.
- Handle case of SFS capability bit being set on multiple PSPs, add
  protection based on sev_dev_init() and sev_misc_init().
- Add new sfs_command structure and use it for programming both the
  GetFirmareVersions and UpdatePackage command.
- Use sfs_user_get_fw_versions and sfs_user_update_package structures
  for copy_to_/copy_from_user for the iotcls.
- Fix payload_path buffer size to prevent buffer overrun/stack
  corruption issues and also sanitize user provided payload_name to
  ensure it is null-terminated and use snprintf() to setup payload_path.
- Add new quiet parameter to snp_leak_pages() API and additionally change 
  all existing users of this API to pass quiet=false parameter
  maintaining current behavior.
- Remove mutex_init() and mutex_destroy() calls for statically declared
  mutex.
- Fix comments and commit logs.

Ashish Kalra (3):
  x86/sev: Add new quiet parameter to snp_leak_pages() API
  crypto: ccp - Add new HV-Fixed page allocation/free API.
  crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver

 arch/x86/include/asm/sev.h          |   4 +-
 arch/x86/kvm/svm/sev.c              |   4 +-
 arch/x86/virt/svm/sev.c             |   5 +-
 drivers/crypto/ccp/Makefile         |   3 +-
 drivers/crypto/ccp/psp-dev.c        |  20 ++
 drivers/crypto/ccp/psp-dev.h        |   8 +-
 drivers/crypto/ccp/sev-dev.c        | 183 ++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h        |   3 +
 drivers/crypto/ccp/sfs.c            | 302 ++++++++++++++++++++++++++++
 drivers/crypto/ccp/sfs.h            |  47 +++++
 include/linux/psp-platform-access.h |   2 +
 include/uapi/linux/psp-sfs.h        |  87 ++++++++
 12 files changed, 659 insertions(+), 9 deletions(-)
 create mode 100644 drivers/crypto/ccp/sfs.c
 create mode 100644 drivers/crypto/ccp/sfs.h
 create mode 100644 include/uapi/linux/psp-sfs.h

-- 
2.34.1



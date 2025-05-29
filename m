Return-Path: <kvm+bounces-48003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 28BAEAC8387
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:18:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3D0C1BA3A1F
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 21:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A1829346F;
	Thu, 29 May 2025 21:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NfDXDblx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2079.outbound.protection.outlook.com [40.107.95.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF29920C469;
	Thu, 29 May 2025 21:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748553498; cv=fail; b=o+furSRnxHSSTPVj0CG7Zhp4Mt9+OlE7RN6QAsQIs7bwfwUS4MTHTeeqMmaeHz0htc+E1gNqMGV87/Kq+x8yg/EG91kIhGp1rIuclkLS+l3VTvLQApa3vNKkYmYl6qfQrilqfwFBlKQ9V4RSR3k6zlGdgaplYHewm8bX0eS5sDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748553498; c=relaxed/simple;
	bh=okWTGLFG5Ee1q6ejgQe/ild2rVG9jCtJoRd6sOrEQkI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KzBk77ApgxQr2A8vOE0b1DAAqoaqxe72fCUa+pwI2dwugdspU5OuG+MB4mgHsWS589WKlvXdkb9zrisbjONlmCyuoFbifx2ZDmPeyUf5YIzoskzVwZp8MeV2rVib2cpUyyVcHM0bMntxXKiOd95RRhQN5TLHvfJ2Ca48GzyxY+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NfDXDblx; arc=fail smtp.client-ip=40.107.95.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wdyEfztahxevI81rR0tFSdRqeG0L6p2KOpFSgitVIirgQzQKc//XtE4qxWa+3/Z5e062QrOABtY5sSk+QgNO8Lk89gMrXnRw4RIUJcEHQgpt/UguAZaoDskAA4+L/+bAVF818l5chEasOan7VF1iAavMa/UGCsPvZHTVVUVtp1UNXlCEIxAj4Zm5RyTwknfcfxlm/mycDTLFdbNJYf4h2YGY9WfQRmneUVyI996C5CG7kpYUo8VItBw3Ns2nKwfWlVvA21Qg3rO3uV6MA4Dpf4iKVCVvNAWc/iOGgMVJI1CETDwwbhp/ly6xVPJ95/YX9qJABPLjZPVjyIe58ag1Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LMg7YOdqnhhgV42SXhna/lh7FLM0idOOKhp4n+XyFmQ=;
 b=auXl7yGDCIF1XZf1WnFiOLoOIDiDh3N8pbubZshF0cNZwRNoyN8IlQvDEcxVIr85qZ9aORjFFKpQUawVrlETA2OZpVAliHVJI0TihT9dVfCbo6DZk7VxUgI0dgr/Cz02W0iLZGcwHH+Az1DGufcJpBhOH3nWG+RdU/mTIsBlaxca8TpfPJty1JGedsdr5i/6gT75i3SNo4LPeU2+ZsgwREF/s+6Roi/PTMn7zJph78XyioExf1OKtlei2w9zirWRs4VEUIFzyr36ucvzlMUESKBlFQXS7Ck5/Z/oGl7i4M4hhJoIYjA4nNIwcYJDFtc9cV+1NMXe9EjeLBGQxl3AFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMg7YOdqnhhgV42SXhna/lh7FLM0idOOKhp4n+XyFmQ=;
 b=NfDXDblx5J6C2j7p6ecyX619m2gLKVEvKE7hEEfNDuxsVG1uvQij20EMUIx44G7kRG41HyyDFSD8JNZqJBtEPs6tX/CB229XfFqf381hfpizmmHqVdMVlqeJ7AbLLTSZ3UJFqiWwp4XNcJBGtRZbklXdWHjBp+5Lzam0nFoDKQw=
Received: from CH0PR04CA0054.namprd04.prod.outlook.com (2603:10b6:610:77::29)
 by SJ0PR12MB6784.namprd12.prod.outlook.com (2603:10b6:a03:44f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Thu, 29 May
 2025 21:18:14 +0000
Received: from CH2PEPF0000009A.namprd02.prod.outlook.com
 (2603:10b6:610:77:cafe::46) by CH0PR04CA0054.outlook.office365.com
 (2603:10b6:610:77::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.27 via Frontend Transport; Thu,
 29 May 2025 21:18:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000009A.mail.protection.outlook.com (10.167.244.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Thu, 29 May 2025 21:18:12 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 May
 2025 16:18:11 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Subject: [PATCH 0/2] Remove some hardcoded SEV-SNP guest policy checks during guest launch
Date: Thu, 29 May 2025 16:17:58 -0500
Message-ID: <cover.1748553480.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009A:EE_|SJ0PR12MB6784:EE_
X-MS-Office365-Filtering-Correlation-Id: adc9dbb8-58ea-410c-8172-08dd9ef651cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c246hm6wA235FT1/zmyHLBmzZM2DsYXeCRhlUedH2P7z44IjUYDappbJqCsE?=
 =?us-ascii?Q?Lnah2cOo/5AU69qvclFJ1d7y2WhqA4OheQu5hKgmUhvwjOqChTXBd8zINsWy?=
 =?us-ascii?Q?jDIhKvjhHK7UBgjxl7xTVkoLOIjA/s4KpLaFqywl1QwczIFlDyYO+WzWTXBO?=
 =?us-ascii?Q?dchQRG+1/OfEVvi/4aDpmrvka7zatq55Ik0q6FWCNM537mlXZUahvmNgOWLS?=
 =?us-ascii?Q?lhP5c1UBm9ebMLK3jwLTgX33ak2yubY8YDAT/OUCzvHy4CZ/QGPsAdnv/hBL?=
 =?us-ascii?Q?+sbBZukzPmUd2xsehmghyMjrAGyjMFVJhVxJkK5E4UnlIeNJrrwOJIfAvnG4?=
 =?us-ascii?Q?p94YUigpwNTVpxl+30ji+4zyj+uoHy4/SJ1qFlfZV70bbqz+OvTDg1ZJ7QFI?=
 =?us-ascii?Q?aCOa7/d4T4OJ0nSuF+8hhjRRla6HKxW5B1hryRONqce2LlVa09x/ZtxND/k4?=
 =?us-ascii?Q?t9hFCBNfAc9aFXPRG7NkR6XrjqEhn176VvZEGH+aHyG44P6wWcgBUYbcDfaX?=
 =?us-ascii?Q?9L8uzZV2drva0vInR46V3GUdZzkRQlcMelt1gZUtP8RUJFDgKbLl8AVsI00V?=
 =?us-ascii?Q?BYKGWDjyFK+WfRatEbsxy2XIyoZn3CcpqGJnA3R0rNn8pgwnpCB6NKFNx3/n?=
 =?us-ascii?Q?13jgBOPRDT0Ti/tVKtN/l64I3rWE0FgV5yU20bW4cI5i6z982hhVm0a+0J0R?=
 =?us-ascii?Q?nU3JFWuu86o6upS73T6Sp4AJrAC99cpP90snrQoP4X2XgP1VkZztPdX3o+34?=
 =?us-ascii?Q?V5fgz5ClV47ILxEbWYq/83Y+LfSbg6wuqmdjkmJ3wCRpxhg7Jx+MkW6OGPpP?=
 =?us-ascii?Q?/5/7XCtJEf8IDXYUwO3hr6cu9CarLf3f+4+mtYKGT5/tLFnsaoMoUcVNQKXe?=
 =?us-ascii?Q?8Iy+SDcoXmexdYXGcZFhtEUVNzn4/avy2MW3owCJyAyfHqEyv80fb96YkYv2?=
 =?us-ascii?Q?Zl7JulhsgmjJ/M7PlvabzRKu9LSCGtthWaKVBtll9Tqq9lCekLfDQh1nEaWc?=
 =?us-ascii?Q?TKER/3x5oMBEvBmgXn+aWiEbHfo85UDMMJcNCe4ViV2+10DH24O8W4ExF0k7?=
 =?us-ascii?Q?Rnmz7ciCkylBjx9dzs5SqkiNwQhbPP/XAdTPXvD+J/osumcpg2bNUXmZs7tD?=
 =?us-ascii?Q?4dSHTqDT/T0ifWT05DOpxxwRSEQjwPe2Ru9RRO1lNJDNtsjcwM2jOvnKNE4G?=
 =?us-ascii?Q?W2Q/ArV/0dTWKgoZ60Nu1OMxjXQkvMGQpmH0CLGLP/EVLKkfga59v1rgQ0ED?=
 =?us-ascii?Q?Plzmu3rbaJJxK67zQKw3slTakS5t2wvKeHy6r6QbZiRRa40iAg9tZjDCF7b+?=
 =?us-ascii?Q?gMSfR/Xz7ayKOLZ/b8PWWJc5tsu7SSG6rit43X9NkBRElsK3FqzvtJZq5nLO?=
 =?us-ascii?Q?TLfx8gtHRy7qdNrOcJYL+c4yWbSWbK0EF0wz6txq+ZLz0oKmYX2FK/OoYoJ9?=
 =?us-ascii?Q?ukRDVSegx7o0G+BbkS/Cnm88CK/UG4KLis63GCPGL1gFPHcN91GWXf0iR/hK?=
 =?us-ascii?Q?Vl1Fdl/P/OZnvwjpXj7VRGDIAt2aRflSBWkd?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2025 21:18:12.7443
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adc9dbb8-58ea-410c-8172-08dd9ef651cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6784

This series removes some guest policy checks that can be better controlled
by the SEV firmware.

- Remove the check for the SMT policy bit. Currently, a check is made to
  ensure the SMT policy bit is set to 1. However, there is no reason for
  KVM to do this. The SMT policy bit, when 0, is used to ensure that SMT
  has been disabled *in the BIOS.* As this does not require any special
  support within KVM, the check can be safely removed to allow the SEV
  firmware to determine whether the system meets the policy.

- Remove the check for the SINGLE_SOCKET policy bit. Currently, a check
  is made to ensure the SINGLE_SOCKET policy bit is set to 0. However,
  there is no reason for KVM to do this. The SINGLE_SOCKET policy bit,
  when 1, is used to ensure that an SNP guest is only run on a single
  socket. When the system only consists of a single socket, the SEV
  firmware allows guest activation to succeed. However, if the system
  has more than one socket, the SEV firmware will fail guest activation
  when the SNP_ACTIVATE command is used (which is the activation command
  used by KVM).

The SMT policy patch should not be controversial. The SINGLE_SOCKET policy
patch could be a bit controversial, since, when you have the SINGLE_SOCKET
policy bit set, you can have a guest that can run without issue on a
single socket system, but suddenly fail when attempted to be started on a
system with more than one socket. But, as this is opt-in behavior from
userspace, this could be viewed as providing the protection that the guest
owner desires.

In order to support use of the SINGLE_SOCKET policy bit on a system with
more than one socket, the SNP_ACTIVATE_EX command must be used and proper
scheduling support performed.

The series is based off of:
  https://github.com/kvm-x86/linux.git next

Tom Lendacky (2):
  KVM: SVM: Allow SNP guest policy disallow running with SMT enabled
  KVM: SVM: Allow SNP guest policy to specify SINGLE_SOCKET

 arch/x86/kvm/svm/sev.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)


base-commit: 3f7b307757ecffc1c18ede9ee3cf9ce8101f3cc9
-- 
2.46.2



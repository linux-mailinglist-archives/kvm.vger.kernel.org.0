Return-Path: <kvm+bounces-57014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 327D0B49AF7
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 22:22:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85356188D1E6
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB432DAFBF;
	Mon,  8 Sep 2025 20:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4gsqnHNn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2083.outbound.protection.outlook.com [40.107.96.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FF22D9EFA;
	Mon,  8 Sep 2025 20:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757362858; cv=fail; b=qNPVSnyPFbmNv12DABI9i0JNhlaKjcoROgzEgXGq+h3/2VVuojsnpn461UNdP7qIRfOawvFVEn8bCkoMvfcJbVrWSYiMGOi2dBq2emEn4rTsyT4yqHu0K08LbXEDhfAn71d5R+SpXO04AiQjvz5hlo0WD8NSOp3wnDwd5gEPAv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757362858; c=relaxed/simple;
	bh=r3cQxjW1od6ObDaQPJ0gCEj8MDxGbwoRJv35KJwGMNk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nrjpCjssyY5uq7dGIVRTjX8e8M8IOHvIYuTqFOA4CbBPcGg3eI+9K57C/Q+YFxCKALC56sJ327V/UWsA0ORw17w95ggI6ToWLprwmcdoRQDTrrIrZLlEdJwhudXnEGweCy7hThpsRA8ghd8xe5TnQsNMF93uc4ZhZ2YPpHjKxSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4gsqnHNn; arc=fail smtp.client-ip=40.107.96.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HSCDbzwcUheNOGA3CqeG/p6z+QL9PCf5Umi6txKsBdtDYCgjyYdN1qDy7j9MM9sDMC5lW3wAhBQrcb+0G8N8YE4lh+n9PHmhKvizCHcV+jpVaDjD1TUbeZfl9gs8BT07eqYipRV1oikR3UFy0KlfRa8Vgv4VJywWtwjMbBYUGFMJsAjLaz4lYWa5tIivIo2T+w+eP7bkATclPhXBzE1U1YvcSY9eBDEyRzWv1X3um0H3cb4zXck9pONFLvKpUNjn/sd3Ndl21Eh4FKwCSOjNfe1IBA0sB1vrBaC7BwipksWvTlYX4AHwPDPLglGgHmyhG++eXdelffNrc7CdSQfNfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOQCUeDWG8d0ZBsyNlLCdxrCgSzWlsObDOoHI3LwepU=;
 b=j0BE1ytFWebsGj2D+t1niuHwaq9DYkcEWMOFKP9zbkaOcVYE9meFf+VPsTs3ogqkk2E32O/U6Nj7uz/8bMuy2MQcSL9WGSIswKb6qRWqrOQSSwiTbBwYoxc1zXfm8lqKEifNSJf+oRhocwak3Dnkrbyb5ig4lFyvrcz/FeVc01znyHPtw0vq4L4xCK17/mCQu1/5DmmUy12WGMyw4sup5U38XmWkNli5TDiKiJ3tD6jIVbACpJjdoSXX7494PfaDrH7VlNVRyoWeQIvsPLMMNM19XGFf0bh1TfzQlOPzaPniI23Qza1kzhZbPOF8ataCfCfAgOFnCAS/P/iPoIiByg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOQCUeDWG8d0ZBsyNlLCdxrCgSzWlsObDOoHI3LwepU=;
 b=4gsqnHNn6k/5UzjCwJzK2y0tkDSFHK1yzHxNfR1rWitBoGVitSy8Q9D2Vbf1gP8+NuDmbNhfbXQaOAqVrjGUZcDaGzvxvnvCYxm57sJqFzJ4HWWjjHbJNk2dfmYqUl03x3LQ6ri5ixKISZHI7/9DjHEx60OrkfgZpToHQIDeTqw=
Received: from SN4PR0501CA0108.namprd05.prod.outlook.com
 (2603:10b6:803:42::25) by IA1PR12MB8468.namprd12.prod.outlook.com
 (2603:10b6:208:445::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 20:20:51 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:803:42:cafe::a1) by SN4PR0501CA0108.outlook.office365.com
 (2603:10b6:803:42::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.11 via Frontend Transport; Mon,
 8 Sep 2025 20:20:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 20:20:50 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 8 Sep
 2025 13:20:49 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v2 0/2] Support for SEV-ES guest shadow stack
Date: Mon, 8 Sep 2025 20:20:32 +0000
Message-ID: <20250908202034.98854-1-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|IA1PR12MB8468:EE_
X-MS-Office365-Filtering-Correlation-Id: 7144f7ed-9300-4228-2eb1-08ddef15343b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iK4yBQzgknnDU7lpIxO7iFMQvZ0MgH824LwY6/BmlPKl7jyQhtjUb9raCljd?=
 =?us-ascii?Q?57I+7iYVXDF7Fb8c22oQj5v3JTYhcX8Mp5Ik+Il2EvrV1HsT6aoJ/mZSEfpM?=
 =?us-ascii?Q?4WeTFxTZise6n7ZJXsoKdD1YSqZc3zgY5B3qxGv+/B1+v5Wr245qT63aWIk5?=
 =?us-ascii?Q?qHFdeMqlnKTaKdFKFbofpaCfT7WAXbkk+6Wmu7SXbs8M0nUmtnlqbt10tBFi?=
 =?us-ascii?Q?FP+o46SoYSJ1mYQg5LHQ4x+ToO9vvDt4wtXM+2yE5Jl5qC2Dza11ILXnjCuw?=
 =?us-ascii?Q?iYEl0G83rvFp+1dHU1hTGp3RdkiAXZtJ/cDJnf4NLPlyDQIAsSsFZXqHeZr4?=
 =?us-ascii?Q?jU5c3EYax+wVMgxHeUo/9AXDMfcXCXWOTsFo/kVnPLj4ecraXu0C7ZybsJ42?=
 =?us-ascii?Q?lcC0Xttote4fsY2FYgzcKD5AD8TI2bJHziaNWunwf2G66k19dDfQuko7FBCI?=
 =?us-ascii?Q?bBAqtuLDQK7Nsqq+s1XFshr81QR6i5zkLF1ljW4Jf3xMjrGhV9YW+Twl79+H?=
 =?us-ascii?Q?GNq30Y6XNXgFe2tYwcuzdfv12JZLTlP1hd0YXs75gUCih+I4Mtd6ETMZxE+9?=
 =?us-ascii?Q?E1hvCpghZJpRnZM8wRQgIsgdAs0C8oKQsx6Lbkb3LJ3AknrFyTG0TkJH1fOz?=
 =?us-ascii?Q?r6YFCdM2LlnfMqgrjihaIggvgXLE0vgoIHQIECOz1oqWZJFe95ZxcocywoQb?=
 =?us-ascii?Q?4clRjlLyrCgupskqYmsfE4mfjzvpLhaUelnm8vcFXKBalS+9B/OAp/T0Q2jO?=
 =?us-ascii?Q?r66bZw2sW9XFOwp0HxBn/x4QwU6bStW/FXEOUrWd1JaXoutbNSqe8IPIO94Q?=
 =?us-ascii?Q?ZE56EcDv5hS/nGwxJi+LwHQJKTq5O9AxNq0K0jjgtj+b63xYcAuFreQs19e2?=
 =?us-ascii?Q?/gDioEKQC2kTm9cMRb41WTggLMcxlCpGVJ8qUcH9pbU8zT+C2jOxxZtEEHi0?=
 =?us-ascii?Q?pfOsX54R2JequORu3og0O7MoS19D2bmWrJU5iZnW0gj7MwRpK0DzJ0IMKbmu?=
 =?us-ascii?Q?6zW/hJpxIzcD5ZiLxdVMBLvrzVudwn2edREvTzI8kOFTihWI+9fwYXBtIuIc?=
 =?us-ascii?Q?Pje4WEVYLC44iINTFlKQLb1BDcRF+8Tsyz3HFTC7FaXbX362lQk21QMUtmni?=
 =?us-ascii?Q?26TFlMNkohlx3fnqDzo8APa0S7wnDi+BLQmHfYIgXxa9BL6uUE5j+rSOE50i?=
 =?us-ascii?Q?XlkCYUrv7TraWK9Bhp5QpziNGzd/OFc3AdDd9mmN37L6YaA0r5OYFu/LXA5z?=
 =?us-ascii?Q?StymRsFITMgPgPQ6p00Yh+XzBi1F+NvomCc/jJgaafTqwnbcwFe2y5vHu45Z?=
 =?us-ascii?Q?tnYLdjO5ojcWojd7ZDISTEji1CQ5TVmRA4HVC3y1Y0F7s+wrevB/1y+OdsbM?=
 =?us-ascii?Q?2pU1wA+rgpia1zYYqYFOIW/DimGJyIGyONvfKqtyWn6NFCSoJAqEkV4avS54?=
 =?us-ascii?Q?XYWATkVVa7tJP6RB1FCz3yo/+NAKzSdHndhDqHdW/lcgGxWZAtmkVtP0uC38?=
 =?us-ascii?Q?cd8fluIRIWbGSXakvuZ0JlV/JVeiyOzZu9g0?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 20:20:50.5523
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7144f7ed-9300-4228-2eb1-08ddef15343b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8468

For shadow stack support in SVM when using SEV-ES, the guest kernel
needs to save XSS to the GHCB in order for the hypervisor to determine
the XSAVES save area size.

This series can be applied independently of the hypervisor series in
order to support non-KVM hypervisors.
---
v2:
  - Update changelog for patch 2/2

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
2.47.3



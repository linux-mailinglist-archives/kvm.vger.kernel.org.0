Return-Path: <kvm+bounces-58703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F8C5B9BCFA
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 22:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9B587A7BE4
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 20:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DEC9322C9A;
	Wed, 24 Sep 2025 20:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sq5vIa1w"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012040.outbound.protection.outlook.com [40.107.209.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF41322A2D;
	Wed, 24 Sep 2025 20:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758744555; cv=fail; b=Bp84m7VY+vTpH1V2bq0GD3DzxmHWqx+IMUaDe6/5u5fRZw1LeSsB3lH3ooD92PRZPjI7hzk/bup25pHPF67Wh5ydiBRJ0d05ckLPU8SvmY+ksZSvciu3yWp5jwef86USaEm/ZiwSD0XxPumNhwKHh07BStKaJRw9lldzLxd/YNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758744555; c=relaxed/simple;
	bh=EkwRPBfFtHYrA7iphfjnP/gEUij3ucWw8bBK3PCKfWA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Gt/+FmubrGBeg/fJVYuC9rE63xOfBc8XzHeoxkD7kDO3AWA2Zr6h871U/WGLLRsBgJyqyPkR4Omx65Mw7/hAC8IfZsDPvwL+2BO/FuCYMfQawzL4CCO+RPyv6owsoQVl8BNLFqCPPdyO9AcZzi1bedT2Z2Nsj8Rx5sNSV13BkZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sq5vIa1w; arc=fail smtp.client-ip=40.107.209.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t62XGc7kVKA7EDAGrhugKbeVnjO7J1htvSwnrAKvk23sKvZau+X2v3xwB+dYZLfK8fLRL/6Pn/aDVM/rhP+v8Yx5jDCdcrw0F3EUDbToACzpCHv0FPJPnibq9bjqLOa+dI7beos2dss24SCucYX3nMKEGNu/Z142BT+v+wg3i3dcATu1gXM7w+dopjBLI6H6uH/KkbjyicPd54CeiLyUGQMcALq/sZ4CZL2mkC7eT6J+k4kv4DSJpFl/ECnKnvO07bOlFEHHBiLcsgtDdPfLRtlSQKSWfOwI7coG0K0dLbq9GDwoWJefZwmsEhu1MVF8LGRa13ZjBDHgt0Qu2+Mfog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWrRBO7PeXRWHMgV0CdbEHsDErQEmlEUk/AkLSWNnsI=;
 b=A/1hA8qHxqWZ8H/9SQn5sTyRvWgnFoTFgP2cGFLhS60Gy2J/cy6dGkBgsllzprErPRrVBDDYLQ6Jv5KvBDwe9cECmb+VvLadLEmf/BGhPkv85wczYZsvscNgKf5nEkaIC7ej1XKnEUtLgKA8O8sh2Se7EdVF5UTdNIVcRvbEWHRjTf7rFUEzTnhyBdqtX+AajYX4JwO4dTIp8sAom8Y9PBVJ0d0lMUmByc1RDbTUOgzsFIdqJYiDYQjATRrOwjPfdBEnKtS3HPd9+vsSbTHtkMMkUyLtvH6pP5sT1Np019o39H6yG38Q0N/s7jyp9x1gVEhycA1PB+iY/sPkSHrYqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWrRBO7PeXRWHMgV0CdbEHsDErQEmlEUk/AkLSWNnsI=;
 b=sq5vIa1wR7FxI7tyARv7X0x/SQpCdBL2YOiMtrtJiGfMWgijDkQ0J66q7Wc1rfuzUhjNEF4EZubSFZPp96lfIHay3fMSVmt1fmGoiJc6It9dbW7IqeijD485IyYF9385TGU3yFVOLEzkAIiGenGoVPh2eAATj6aSokioPxbJqFI=
Received: from CH2PR18CA0020.namprd18.prod.outlook.com (2603:10b6:610:4f::30)
 by CH2PR12MB4248.namprd12.prod.outlook.com (2603:10b6:610:7a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Wed, 24 Sep
 2025 20:09:10 +0000
Received: from CH3PEPF0000000D.namprd04.prod.outlook.com
 (2603:10b6:610:4f:cafe::89) by CH2PR18CA0020.outlook.office365.com
 (2603:10b6:610:4f::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.21 via Frontend Transport; Wed,
 24 Sep 2025 20:08:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF0000000D.mail.protection.outlook.com (10.167.244.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Wed, 24 Sep 2025 20:09:10 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 24 Sep
 2025 13:09:09 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v3 0/2] Support for SEV-ES guest shadow stack
Date: Wed, 24 Sep 2025 20:08:50 +0000
Message-ID: <20250924200852.4452-1-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000D:EE_|CH2PR12MB4248:EE_
X-MS-Office365-Filtering-Correlation-Id: bd3e2e4c-c434-4e14-91b5-08ddfba63949
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Kcl1hrpHps3J0N9dKRnQkvSdNPuncCS86eBQXdwa1zE2RaaEICwZWG9CPq7Y?=
 =?us-ascii?Q?LvCq4E7fD4+GFtDx5GDOvFw344Lj7ePA9UHopozxnsnvVOz8MIpjyCrZynlB?=
 =?us-ascii?Q?mPQ6QmPYKpyNF49YPpH9055tp6GP0CqekdFoJEP9DK3B/vbnGw/cVsg1LCJ5?=
 =?us-ascii?Q?7LGj8npGwY8ESNUlBnnETJniiuBpMZvEBkWl0AmGp6pOypJswXCPNb2OPizL?=
 =?us-ascii?Q?f0TKKRtHpkt/ys1TSn/QqmYZPgnQI850zTJb1nbLypXx+4EomH+5rlyokhHu?=
 =?us-ascii?Q?KYztc3Hc1e42DbwQ6FryRu8aD1XdRiLV513dFTVzmTg0K7wD8tH33cYz3fGk?=
 =?us-ascii?Q?d+3br5H2X/8U/lQObd687DA4bum+AAiRjarZqGrOtdZn0rAKHEoUc60gQmzg?=
 =?us-ascii?Q?ncr/OTrvEItZ8ke/hMC7xMo3LiMwSa8+h0VDKzYZvykU2iAwAHKgUpDA2r8R?=
 =?us-ascii?Q?tdqWS1fiZXBfY19UAcksh9CwOtMxEqO7m9LFy2H87/Tik748h2IaVoT8ch2m?=
 =?us-ascii?Q?N7xpcVhKMACeTqP7c9v2H77za7kgiXT86HJq7UskYIMscfX5IlSO9VRkF0/4?=
 =?us-ascii?Q?RGbybrtIuCzv0WsFjygpritWM3dUTZPqcSjK9KA/YAceYgmVzO8HdG40ZiFb?=
 =?us-ascii?Q?foCwVbFV12ewSEpO/W4LLrfYOnVSTAQXUtJBK/fJx1cPJtmS/kAC9JtDeiHf?=
 =?us-ascii?Q?/y6AT4FgZsfDDaIAa/Ktqaqise6yiItpFcrC9ie+t88rkMSYVuoPhzOwGBGT?=
 =?us-ascii?Q?UNDDvlJK13Xum1UiaWeZQPX1k5rFt82CSxr0fsZcx7s3TFVj5yllqaZO0o02?=
 =?us-ascii?Q?AUYcIsAgebpyA94l3AxszV7vMWcYl94aBESpFwzNqGIcfCzgJFZy8fKDwk3g?=
 =?us-ascii?Q?/aueHWHeTIX5U+6WwtmLB+ojeFCDNJNx9pIMjysTyJ0Lco1n9TfOLEscZRC5?=
 =?us-ascii?Q?cEEvWE+2Gs+m0sNb9vrPIscMmrFoyTC6oSvraEqgCCv7enIXoTupS1Br3w8v?=
 =?us-ascii?Q?zPPDqcBVYhwIRMBfSO/uAuvU/XHL6WYmNiRlcrLIBmbadhPHKArhhWRKRnx4?=
 =?us-ascii?Q?CpX+RFn4R+P7Mgb7NI/kzl6GRqruFCZ21A3CxL+liwyQDkqI55xw1HMFlSRv?=
 =?us-ascii?Q?XLTL1A9i3lfQIJOthg+tWsrWGRg0ePmwiBY33V9oJKvOGwjdYz9cTh8Q/sr/?=
 =?us-ascii?Q?JJyfbh+Wgr7BZiJSQNHvFsNW+wWlkljqaA72yRQEU1U5r0Gz9eKi3xZcEAwZ?=
 =?us-ascii?Q?SO4I3m2npHg42SeSIuYul5rHRd/WKjBo1BHdoLgVm83YAscoc1zEsTPDNz9e?=
 =?us-ascii?Q?Fu2aKYr5F6ZYo5ZkFmQtJIGL0Kc0ikHMFOWhEvUZKBIennspK17L9enm1kEJ?=
 =?us-ascii?Q?SUtGJArns/rh0bJkU2Gfn3cAKcJWSCipuSevnwucAtQ2FYjKmSrjH9zj6Z+H?=
 =?us-ascii?Q?bBTBPGOEXnNVMMKZTmmoSlkKCDCMhOfiLD+bv2JngGiYgLb8YTXwxP5guB4e?=
 =?us-ascii?Q?msg5bJybJrV5FQ4wxYSKoW9cAxPO7heMvF0j?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 20:09:10.0182
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd3e2e4c-c434-4e14-91b5-08ddfba63949
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4248

For shadow stack support in SVM when using SEV-ES, the guest kernel
needs to save XSS to the GHCB in order for the hypervisor to determine
the XSAVES save area size.

This series can be applied independently of the hypervisor series in
order to support non-KVM hypervisors.
---
v3:
  - Only CPUID.0xD.1 consumes XSS. Limit including XSS in GHCB for this
    case.
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



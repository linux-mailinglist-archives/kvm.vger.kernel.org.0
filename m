Return-Path: <kvm+bounces-64080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 94E57C77F06
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 09:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0122234FF76
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 08:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5BF33A706;
	Fri, 21 Nov 2025 08:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="A1K5KkIE"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010018.outbound.protection.outlook.com [40.93.198.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0B62F5301
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 08:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763714165; cv=fail; b=N2iR5HAoarD1IFduy/i6006/qBwlUl335v6j55mIrxw7SoEyHAOwvJZ2ow46eU8cG1hht3ENIOb3jYAh6gLhcHaMNaqP74epTtb2ryFHcPdopq08VmTF9K2kGp33DAGC6TNDZktEwQhU5La0VP9OnUJzqDTW8s8AGPna1sZSuv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763714165; c=relaxed/simple;
	bh=RGQE8A6rRJQNV2RUoRc8o9JO47Ey5ZkQlBT9XNIYh9U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ln0+KvI/qgLqd5O8r4c3UKMKc3jGEilYDOTt31NEeIknnXHyGh1FIOqISLKwjhVqM9vsdARJC7LwlyLy0Ttd2EdvQDv7OdlpNW5JeN+0iBYEKADeC+yjxCA6gndxxKTTI2L0iBox55mWHoSPkRWcn8EB4uc64qFZK5d8HE9yBt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=A1K5KkIE; arc=fail smtp.client-ip=40.93.198.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fyGnNffPk+VdJ+mpf4PrY/w7gUmFEFgyHgCSEznp0abWZ1DgZ2hoQs9cOa//qCz8qP9lZkcxMLhNDOt80BL149YyR2OEDXDrTsSqROLiVJv9opNFyeWScE03LrNjkrE+r0oNFHfg6b+6XOWIA2ovse/Muv6ImH/okt5PS6Me+30JT4/XdquHUM0CvUNbzJbPHA8r+3JKFVhZlvRtaym+ETLg2UkHMdWZbegucdSOMSySvFR9XgITsDRsF0CgAlWwlesQU7s3AoSZQBZPGKXH36uF1iooZewCUVeusF3+M6ql5UET7Kyczpk3Zjj1LsM+0Qb5CuOMseG7vOYwz/Nmrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ui9wLeLEoaZ7YJTeqzOZoUA6YtLQ0SBVuWYFoFLvLT8=;
 b=bRfx94SC0sFEYFX58W37iteuySxCNd7/bbMdF0MxGKvFS/BAAOb1HktaKjaCJcFym8Z9m2qYNnGvSSc3/tjaY3GcmntQTHgbLBChXM9RSY7p9b3wkNVXFp7Nc3CMbjLLgo0YGlMBpY39KPXEaRD/kf1Qk4kDQB001kVGNlqkMWqSwFqxnSnxmvq8IJNFstpDwv9Vty55NKtH1RdwDlguoJgEVkkmwStenFDc8n0/7/XYA/FRtHLrUhBlkQ65RlvyPhTYg/LM6e5VjPHU+aaaaAZWnArHQnBiPIb9LNd4ziv34l2B3CdoGnx4fXmphGojGXNHo4Y7DQsw5FWVgrcEFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ui9wLeLEoaZ7YJTeqzOZoUA6YtLQ0SBVuWYFoFLvLT8=;
 b=A1K5KkIERPwCtvtn/Wm9sfCiobud05PClOxGwcH20+CQgc0muN/MyjcMf/Am/CDARMnLk00YoC1bTaqQqn2VtmzFGA3R9muXtfzbs9FBjA6/+OFCEzla8RXsMMjYQnSPHPSxMLLclSCBLPMLQvgXzPkhxfuepagl0iz9ktWx2Uw=
Received: from MN0P222CA0010.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:531::16)
 by BL1PR12MB5876.namprd12.prod.outlook.com (2603:10b6:208:398::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 08:35:58 +0000
Received: from BN2PEPF000044AB.namprd04.prod.outlook.com
 (2603:10b6:208:531:cafe::db) by MN0P222CA0010.outlook.office365.com
 (2603:10b6:208:531::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.12 via Frontend Transport; Fri,
 21 Nov 2025 08:35:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044AB.mail.protection.outlook.com (10.167.243.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 08:35:58 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 00:35:55 -0800
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <pbonzini@redhat.com>, <zhao1.liu@intel.com>, <mtosatti@redhat.com>,
	<kvm@vger.kernel.org>
CC: <qemu-devel@nongnu.org>, <seanjc@google.com>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <ravi.bangoria@amd.com>, <babu.moger@amd.com>,
	<shivansh.dhiman@amd.com>
Subject: [PATCH 0/5] i386: Add support for CPUID 0x80000026 and Bus Lock Detect
Date: Fri, 21 Nov 2025 08:34:47 +0000
Message-ID: <20251121083452.429261-1-shivansh.dhiman@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AB:EE_|BL1PR12MB5876:EE_
X-MS-Office365-Filtering-Correlation-Id: 706bd63e-f75b-47cb-8ac1-08de28d8feb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3EtgqXTlt6G7a1EEiEUkpqmbFqPE+yk2oV+/wJbqhfU/3N17ocASZ0UQRG9x?=
 =?us-ascii?Q?o9RgVJyEx9CFivSCWstOmTtPVVsR9+eSdtCZRaL1zEqPEUAwnbrlbePUqYf+?=
 =?us-ascii?Q?T9qeyLt+Nz7DK7KasNfl7xi2HisCxfmlSrkplMUXNzn66h8dGW2G1UEhvD9A?=
 =?us-ascii?Q?OxspmnFelxTcrG2bxrzlQvy6991jA/Lb3V9EvvYShmeiGOP8zH/DZM4JpwLe?=
 =?us-ascii?Q?YeshHFAYlfE4WTBWr/rtY9qawQjdxHOvTgODCYJd0sVqA0X3aRxW0BASxQR5?=
 =?us-ascii?Q?wVcz+UBU9J2JX1NgZl/GlQRYHbZDzSKL7v5FcTZykaK2T0mO3lrvGv3fS/K9?=
 =?us-ascii?Q?u83W2feCCGiYFQ0eGuPKnbFON3nDdRoCesfDz+BIUgwMYU0DNMOeuzZPrwEr?=
 =?us-ascii?Q?83Mnc8VrdKFrJ5p+6tT/ZYuZz2go1p1WCFsCWBY8VxA9lqSOT50XZuHDB8/H?=
 =?us-ascii?Q?xW9bv0GOUnjkobXQRWvstIKno1tfLQACkMKcwuhrAwQiKECcQQ7BgOdmp/Or?=
 =?us-ascii?Q?vpZJfa3f+QvYvDYbdFX1cgdi5aFCKDTpOmcA73OXIPzr4zSanwAp4u2ysDpC?=
 =?us-ascii?Q?leGQj8Ltvo9rrhX+gK3L7LIFu08M+RlH8h9jm+DIhzPtDfE1BOJsL4Pdr/Y3?=
 =?us-ascii?Q?b+4O5xbJCgQc3BCawENL0VrhijY1wCklO1PtUXer82PbfNAgfpFyEguOPxlI?=
 =?us-ascii?Q?8ZwRTynrMusJbM7F0Lr/QbF5V44gcXa6rcxbOgx0ZYguSaCY70BHnS0pHzp6?=
 =?us-ascii?Q?kJx+z2Uxo2STejOUXz0FpCupMz8L/wXlJHhwz7rWtuOyQ/xgWzvD9wMYXnki?=
 =?us-ascii?Q?IXQOch6N2pxwGC10JcP/XX+NA+4YN5uJJ87x0D1LubKoGs3MGEMgiQdSJHUo?=
 =?us-ascii?Q?Kght9qMvxA3LvlrpjRZd//Sif6FRdgIYH0ZIo6GnY7K0fYvbYBKkTqc4Fe5D?=
 =?us-ascii?Q?sa4gFHE6ZMnYaHsn/dYuSpejTc39iSkvyYWORz3tx5lRQzddCkkq7ysAVzGt?=
 =?us-ascii?Q?yHFriQfzzPFxM0ZBtnatgsyHo8rRpZrNw4qUlfsy7n8nV+r3ad1vsSitA8a5?=
 =?us-ascii?Q?tbSVSm4nCskN6kXe4CBkf0PulgnEG1sitYC8pq4BEv6QTqeVtD/THxnDckuY?=
 =?us-ascii?Q?SEXJAPpsnyxoEhk2kDhw0JaBNcAxKMS0bMp1xYMYuPzqkDbE8W69lRXZK7bb?=
 =?us-ascii?Q?HQi4LpwlDGJ5VQ1xkWsMCpeAamVLPJFJG8hxqYVAYYi8punWzx35PY4u9gmP?=
 =?us-ascii?Q?7RrqaOW6wbE5MmXTT6+jDUkVC85X52+a6tTZ4k2dOTSR7s2mvlT4EdUooY9T?=
 =?us-ascii?Q?agPoHFCIVq5W8d3tmMKRZMY/z0nkAaBI/u9OJ3Z7PISiE1H7BuX7EnySZeBJ?=
 =?us-ascii?Q?y+u7Q1A2wknZetXEs2mWcpkvctKIILmRbHus9neHjp2gs3pHB9+RxytsbxiR?=
 =?us-ascii?Q?LwR+9/SQEMoQXLVi/2lBNp1n5eHCSchQdTsLn1HW6ZUW7CVGJuDn8M3fAYEe?=
 =?us-ascii?Q?HT/1Y3tCZZMK3tlFSLIvyyP+uS3NbDYFRPB0+SQBKm0iaPaJAKZzlrUGwqfV?=
 =?us-ascii?Q?1nsA4QaXkIInZgW9RiI7JenJ+tNQweEkn//LVfS8?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:35:58.4124
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 706bd63e-f75b-47cb-8ac1-08de28d8feb5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5876

This series introduces support for AMD's Extended CPU Topology CPUID leaf
(0x80000026) and Bus Lock Detect in QEMU. 

AMD's Extended CPU Topology presents the complete topology information to
guests via a single CPUID with multiple subleafs, each describing a specific
hierarchy level, viz. core, complex, die, socket. 

A new CPU property is added to gate this CPUID to AMD Zen 4+ CPUs. New
versions of EPYC-Genoa and EPYC-Turin are also created to include the
property. Tested the VM migrations with both newer and older CPU versions.

Bus Lock Detect signals when a process has acquired a bus lock. It is
enumerated with cpuid Fn0000_0007_ECX_x0 bit [24 / BUSLOCKTRAP]. It can be
enabled through MSR_IA32_DEBUGCTLMSR. When enabled, hardware clears DR6[11]
and raises a #DB exception on occurrence of Bus Lock if CPL > 0. More detail
about the feature can be found in AMD APM[1]. 

It is enabled for EPYC-Turin-v2. The KVM patch enabling Bus Lock Detect
for SVM can be found here:
https://lore.kernel.org/kvm/20251121081228.426974-1-shivansh.dhiman@amd.com/

Patches are prepared on master (4481234e).

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 13.1.3.6 Bus Lock Trap
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Best regards,
Shivansh
---
Ravi Bangoria (1):
  i386: Add Bus Lock Detect support

Shivansh Dhiman (4):
  i386: Implement CPUID 0x80000026
  i386: Add CPU property x-force-cpuid-0x80000026
  i386: Enable CPUID 80000026 for EPYC-Genoa/Turin vCPU
  i386: Add Bus Lock Detect support for EPYC-Turin-v2 model

 target/i386/cpu.c     | 103 ++++++++++++++++++++++++++++++++++++++++++
 target/i386/cpu.h     |  19 ++++++++
 target/i386/kvm/kvm.c |  21 ++++++++-
 3 files changed, 141 insertions(+), 2 deletions(-)

-- 
2.43.0



Return-Path: <kvm+bounces-62976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D1EC55E83
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 07:18:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 74D6A34BFD1
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 06:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D429A3203AB;
	Thu, 13 Nov 2025 06:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nksaa7VI"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010067.outbound.protection.outlook.com [52.101.85.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ECA16DEB3;
	Thu, 13 Nov 2025 06:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763014726; cv=fail; b=jwahDmpr/rDcq5HkvN4K7y+CsAt8YTJlws9OzxYhGDVv6lOc4H6zTlE7IN5pUrD2qppFVw1ye24bxxXJrLZrHW8MRWHL0LqmW6o67lhMrv3Jkzn1gNuE4I37UxDDnVXiPuT/stznV4O1AhYVCQZQbOQMV4IGGLal0NZwJyU/r/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763014726; c=relaxed/simple;
	bh=HABloeY4VYA/kZWMNp2E4T7niFsXX85xrM3uiX3ocPk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=g07OZZrDuYHq4dEVMMsdZWoOFR7XqekwWEy+jyOzPzkb0vZwPhv0HJZZ38jhhGgeTKDSrAyvpOkCNdtX0o9IjyIgCTrNVzLaF5vQ9xHEcsidIAZWtGmbB5x9yiS27U4kbktOsQ5YPW/v52jApP2YjZW/9m6Atye/PI5E7rdoDGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nksaa7VI; arc=fail smtp.client-ip=52.101.85.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PCBUo5QuGvsASK8Jxh/k3R84exKCzErPMJPCgvy6xbBuMcZE3Z2Xese5I6DkmECrzpltpex2zOnqWvaiqm6IOvQGdankSxK2xz8gFntel7XRMZ2/7whKLFjlEN3KSprcUOd0jP40CC+ZimjOFMeW7woEyGjzXF4n4cjt9WeEyji7iVkwtbCBjvJJvM5JkXdhoL6EBpiD3HqI3JElGts/vZVoSq/UPYs6lZ3onnxgBNWLCD6/RFSulmA5MYlVnyPsk1Gle0pYCqMImaoQTQ4vmCZU2Re/yO6zQejy5TbgvGD+OCJMTHuUKWz0bOfAigy+oWZ3/fpU2x5gScUjVooULg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ki5SfqZSgui8p9F3trBBcTU+6h7PjI5NoG/5+VpI8hM=;
 b=Da8XfgcqIbo7saqxjT6WaFhOVvTtiQhufIEL0jttUfrKRHmkDGm2SxHi3UMdnqodNN8OMJUZfCiURE3merPZp1u3GSzRvYRnTfTxAkWiNTJmQTg4xMfbnDKY5aCP38gF68tJuIHSnjh7nHR211ms6hRiktwpaAkpK42pXC9SQXtDsqlrRpEd0z6JTbgeQSPGGzlRUQ4mhtXqYlGHrPUo5WybF2xxcWsW9K3zDK2hOPVkVodIcHmZ4x9V/dBp35PF+ebrmu4mXiCHcJdPZJyZbGtZH/QvYZNQNz1T3r+SJgcbWGCKeAW+OZc0KmdV0VXyT6d17ohznr8fax7X/B7LiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ki5SfqZSgui8p9F3trBBcTU+6h7PjI5NoG/5+VpI8hM=;
 b=nksaa7VI4BpaQC7ast0n7Z7XObtcUSbWF8mLuSzkxQUNMKTyo8xsC/zNut5YCycrGLBVM1+oo08PgE+Ue/UDQXMWsekIwHs2aDdOEmzAKnQjBBFOOOnwC0DPsV6NUs/X1Ews9y6SUyj00YOtqgKPz8cK6sK/t1/BLbO05Uh31Ww=
Received: from CY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:930:17::19)
 by LV3PR12MB9215.namprd12.prod.outlook.com (2603:10b6:408:1a0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 06:18:40 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2603:10b6:930:17:cafe::43) by CY5PR17CA0030.outlook.office365.com
 (2603:10b6:930:17::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.17 via Frontend Transport; Thu,
 13 Nov 2025 06:18:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 06:18:40 +0000
Received: from sindhu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 12 Nov
 2025 22:18:36 -0800
From: Sandipan Das <sandipan.das@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Kan Liang
	<kan.liang@linux.intel.com>, Mingwei Zhang <mizhang@google.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, "Nikunj A . Dadhania" <nikunj@amd.com>, "Manali
 Shukla" <manali.shukla@amd.com>, Ravi Bangoria <ravi.bangoria@amd.com>,
	"Ananth Narayan" <ananth.narayan@amd.com>, Sandipan Das
	<sandipan.das@amd.com>
Subject: [RFC PATCH 0/7] KVM: SVM: Support for PMC virtualization
Date: Thu, 13 Nov 2025 11:48:20 +0530
Message-ID: <cover.1762960531.git.sandipan.das@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|LV3PR12MB9215:EE_
X-MS-Office365-Filtering-Correlation-Id: 774fdad7-3c9b-46c5-e807-08de227c7d39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnZjZkFrekRCTGV4TWRVU3JXRTJPbUhSa0o5WktKUjB3aXl1NnlHR3hGVlJO?=
 =?utf-8?B?UW54ZEplL3JuNE50N09uTWN6V3dBSVBYWGNkM3FtSVZsTUZwUHI0bFpiV0g2?=
 =?utf-8?B?MzRvUEcrcEhzYnNENC9YMG1tTWJRbG5jdWpWcUpaaklHVnoyektvRmVEN0dp?=
 =?utf-8?B?VDRXckwzQWpJMEwxU2dPTFpsRFFiODlNRlZsbkNzZ2M3TFFPNC9IRTFpN1k3?=
 =?utf-8?B?NUxlV0FObHRMVnZwa2IwVEx5UGVmNEdZMGEwWXZRRnhiQ0YxaFc4NlFPQzFj?=
 =?utf-8?B?cEFhL0JsUEo2M1pHdGRvRWZucElnb2Y3WWRpYmRkZDIzelZmS1hlVCt5Y2Fy?=
 =?utf-8?B?WUpkRmFwMHhNZGU2WUpVaStqL1NFTFRQK0NqTzZnWTlpendqSXplTS94am81?=
 =?utf-8?B?VE52MDErZ0hyZHhoMjhzWjlxQzhmZXpxM0VwTEZTelRYZUxDMzY3RWFabXpN?=
 =?utf-8?B?MFRwQjJPT1RHdVc4aWNNbkdqNVNkOEh6YVdEcFlJYlY1bXVVZVBHNmxzdlRE?=
 =?utf-8?B?dVhBczRBd05rSkdnR2I2UlJueDlwV3RUZE1WY2FicHpoV205cXJxbGpJd1dB?=
 =?utf-8?B?RHV5c1Q2WksvZnhYazlWQitSRlA2WHdvTTgzMmp4UWJVR3NKN2NPR0Y1U1Zt?=
 =?utf-8?B?WldYZXFiVW11YUk4eXdlT1Z2UVYyeW9nM0hFc0NPUThSVDRNd1lZWXlUV21V?=
 =?utf-8?B?UngvWHp1Y1ZKT0NYM2lGdjNZTkFmNTh5RzdLK0ZPb0JWM2pRVHFOTURyVlVx?=
 =?utf-8?B?SU9JTnFXRmV3TlpRWGlMblpCZndoY2MzY1RQR3VvOVR4cDF4bUhJU1F3Rkpi?=
 =?utf-8?B?bW5PUjhWMk1WTkptYmZWMThDVXNySlV6UWsxN2E1RWlOYzk3TWVsU0dWTFlD?=
 =?utf-8?B?ci9mZE0vbStLY3FYOVVTREFLbzJtb0Vrc0VvM1VPNkVISmlldkl4ODBWendB?=
 =?utf-8?B?RWgvdGQ0aDkwZGw2UTNvVW16WDdCNVZNVGZXTDJDNUVaNHZxckpvU0tEL01R?=
 =?utf-8?B?bnFEdTdtRktVREVTVkNEZkFZSmdZeUVuYXZEQ0J3NHRhR3NIMEZERTRGcGhK?=
 =?utf-8?B?VzFXRjZlR2l6Mk81V3daeE1DNHlpMUhJL3hrZFBrdVZRSEVqWTMvRGliRXgx?=
 =?utf-8?B?TmpzdW5XUUQ2Vm9SaUxDb25HV2FsbDAwL0tJT3U2eTVhZjFWa2NEaFVEWUtK?=
 =?utf-8?B?RFVUTG1CQUhnZ3RmVDVXTGFyNkZ6YlplL1Znc25UcUQzamp0ZVp1WTBWTU13?=
 =?utf-8?B?NmxGY0w0UkUxMk52OFlqc0oweStYcjUwUmZRenJyaFdRZHRncTVjZnZhbEE4?=
 =?utf-8?B?VTZVV1BNZHBkb1lrd0hLNVdPSEFhSHEyVUlJeFZlaE05dTlHUXZoRHBRTmdy?=
 =?utf-8?B?clBqRmV3MUJQd3BnSW10MjY4aGFUbXlSVzJTWEJ2bnpIbGdUZWZ3bzM1emtk?=
 =?utf-8?B?ZkJWTFBrVmVYQ0tCVXlwckFyOEc5QklUWm9OWEYrS3J5RWRvN3ZwZm9LV1Rp?=
 =?utf-8?B?c1l2cDkvZmM4U0NtZXU1Z0h4RkFjcFVhREEveVJqMTR2MC9hTlBMT2gyRHk0?=
 =?utf-8?B?NGExbmVubnNNRGFrdlVHbU9oLzMwRzZVL3JtQVRIanM1cnhCdmRxYWhXVElD?=
 =?utf-8?B?Z043cTYvejViNWVYT1pyR3U0ZkZNWmtTQXJJa3o1Q0tBMmo1eGxrcGNQMklw?=
 =?utf-8?B?RlRCNmd1dFU1VnJDNS9UNzFwaEtrOGtnZnNtelJaSkVMMlBhZFZ4Y3NsOXY4?=
 =?utf-8?B?WnhySG15RUptRm1ZUGFEaGVMdmRvYkRRTnBIaDhabXM5QUt2VWN6dG5JcWhM?=
 =?utf-8?B?NlZycDZJTngrV1hmWmhUSFFlcGs2blgzeE14ZWxWOU5zZm1kSW5FS0RuUVNZ?=
 =?utf-8?B?Y1hxSXJyZ3JvdUJuRmJuazhLenA3bWNqUjFEYUY4MmFCbW1lQnJuNnNFblpl?=
 =?utf-8?B?bmYvWEpaTDlmSTJNVm1wY29WMGNBZTNseGpnVjVWemoxU2N2VjNFckxmcHhr?=
 =?utf-8?B?L1RCVC9OR2FqOWZ2NzZ1bVZxTENQNmpMN1Z1V2VpSlMwOGJOdVdvOGQ3N1Qz?=
 =?utf-8?Q?aTvlwS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 06:18:40.4538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 774fdad7-3c9b-46c5-e807-08de227c7d39
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9215

AMD Zen 5 processors introduced PMC virtualization. When the feature is
enabled, hardware can restore and save the guest PMU state at VM-Entry
and VM-Exit respectively. The host PMU state still needs to be managed
by software and this is done with the help of the Mediated PMU framework
which can schedule the host perf events in or out.

This feature is documented under Section 15.39 in Volume 2 of the AMD64
Architecture Programmer’s Manual which can be found below.
https://bugzilla.kernel.org/attachment.cgi?id=306250

The guest PMU state is saved in the VMCB. Hence, struct kvm_pmu goes out
of sync and does not have the latest PMU state. In some cases, such as
during event filtering or instruction emulation, the VMCB needs to be
accessed for reading or writing the current register state. This is done
using host-initiated MSR accesses but the method may not be ideal and
perhaps requires additional PMU ops to be introduced. The goal is to
have data in vendor-specific structures like VMCB functions accessible
to some of the common KVM x86 PMU functions.

Any feedback is appreciated.

Patch Summary
  * The first three patches add new feature bits and capability flags
    to detect and advertise support for hardware PMU virtualization.
  * The fourth patch extends Mediated PMU to make use of hardware PMU
    virtualization.
  * The remaining patches add the vendor-specific changes for PMC
    virtualization.

TODOs
  * Add appropriate KVM PMU ops to access MSR states from the VMCB.
  * Make MSR states in the VMCB accessible via KVM_{GET,SET}_MSRS.
  * Support for SEV-ES and SEV-SNP guests.
  * Support for nested guests (nSVM).
  * Support for the IRPerfCount register which is a free-running
    instructions retired counter.

Testing
  * Used three different guest PMU configurations.
    * PerfMonV2 capable - 6 counters with Global Control and Status
      registers (Zen 4 and later).
    * PerfCtrExtCore capable - 6 counters but no Global Control and
      Status registers (Zen 3 and older).
    * Legacy Guest - 4 counters only (pre-Zen, older than Family 15h).
  * KVM Unit Tests passed.
  * Perf Fuzzer passed.

The patches should be applied over v5 of the Mediated PMU series [1]
along with an RDPMC interception fix [2].

[1] https://lore.kernel.org/all/20250806195706.1650976-1-seanjc@google.com/
[2] https://lore.kernel.org/all/aN1vfykNs8Dmv_g0@google.com/

Sandipan Das (7):
  perf: Add a capability for hardware virtualized PMUs
  x86/cpufeatures: Add PerfCtrVirt feature bit
  perf/x86/amd/core: Set PERF_PMU_CAP_VIRTUALIZED_VPMU
  KVM: x86/pmu: Add support for hardware virtualized PMUs
  KVM: SVM: Add VMCB fields for PMC virtualization
  KVM: SVM: Add support for PMC virtualization
  KVM: SVM: Adjust MSR index for legacy guests

 arch/x86/events/amd/core.c         |   3 +
 arch/x86/events/core.c             |   1 +
 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/perf_event.h  |   1 +
 arch/x86/include/asm/svm.h         |  12 ++-
 arch/x86/kvm/pmu.c                 |  94 ++++++++++++++++++-----
 arch/x86/kvm/pmu.h                 |   6 ++
 arch/x86/kvm/svm/pmu.c             | 115 +++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  52 +++++++++++++
 arch/x86/kvm/svm/svm.h             |   1 +
 arch/x86/kvm/vmx/pmu_intel.c       |   1 +
 arch/x86/kvm/x86.c                 |   4 +
 arch/x86/kvm/x86.h                 |   1 +
 include/linux/perf_event.h         |   1 +
 14 files changed, 273 insertions(+), 20 deletions(-)

-- 
2.43.0



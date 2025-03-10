Return-Path: <kvm+bounces-40569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F25F6A58C26
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:40:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B24593AB073
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC041CBEB9;
	Mon, 10 Mar 2025 06:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q3ryM5We"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2052.outbound.protection.outlook.com [40.107.100.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6181B87F0
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 06:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741588807; cv=fail; b=Tgbqh9LuuHaNbJ+ACarT8swuLkA2LfHsE05lmMkUcIYSKdGXjhyEaChCFlYwQQWBOnOhPpZabxbcne96iC5+R3QYgeDhX4pJs1FsOJ4JDe0nHRxMoR3YmFI68NrfT3kOXORhsPIO8PUCqm6xQ5keiUr/OixSml5M3uSAc9yTuYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741588807; c=relaxed/simple;
	bh=C01RHlyK3KvIBI3jg53T4GJ15bUueEaLC/KlxUJ7vu8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kJghB1iPuAyQQjpYp+c3Emwv2RXbmf50GOqbd6PdJ1eQsdoHF7vGxjuDQRgILd7Lnnt+Iv1QIQ0As+fETDGWQTbIuoSFQsRol1OWop6NUpHpSGxsq8fE/yi6NmHEmAEn9Iuc0O6XA9EaRqF3KQLR3quUWAlsSwigOXKVE/D5+GE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q3ryM5We; arc=fail smtp.client-ip=40.107.100.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Apz2n4b9HJXeOq7zoemYudGz90GpHxmfNuPytj+zlDi8jeUN8W5J8rfnHDRZnOzaXlabf5oNGtSb/bHcShBlOQfqzwKNVVr48C+d3l1tNPtv7U9zuzQtkUZy3rVoSr4XkFR4KDOaPvXIGDnCwWeG/bsyiQ9v9bGF60mJryjNpFTD9QjQfMFukQC9F2Qg+haT/abJmngCbBq9G4W2SVzNk8XaNMXadVVc8Xd4lvMe09EEi+qKNJPr/Ezii8BaLFp65VlPylWngqWMhY3ZUjVrFY/WObDbID94VawZjd8zDtcbkfGr+jX/66kO/9hAOdo6CmAh/nAVZwososfG+sCK8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tBQ39kPezKeyx94GNrpsQ+Pos2/B5b6hZX1K63Sorag=;
 b=r+FH8YARb4Vnr7DoCxM6KD3JLt9m96VZAlnVszYdyvnltODqrm8wViuhG7s5CFQiDH1cDWwn79UizwVzxw9CfLlMQHhQZZAMl5ddrkW3AgHgI89M6LH188qQ+XOo4SnGuAvlptzonaSzlDyx+LTP+uw1g7FiAVINHHXlp7tD3trzmIUX1sP6al5w38HalQYqELuH7K76O5U4+DKbnLGxWbE66MsY00O5MH7zrDd/Y7jR+/kM9ECgiP68ejCnyNA0QXUFzqBrMNfdSWMFd9HKaHcrplWxM/yJmwkiNLFdqHrlJ61hnsuWrs2YMR95eeUQh/XTuppAhJ7Gcr3oUK4gvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBQ39kPezKeyx94GNrpsQ+Pos2/B5b6hZX1K63Sorag=;
 b=q3ryM5WeNeeHyfDe5YPsZWzJuxtFp+8ila4JIhQFs9e6/3C6CxM5L/dnR78aNon/z81AxCXUcaUeWNszWWqdXNKR4vdMMIEeQPZ9E1ol8w5JbhlJH0YSIzcaB+IW5F287n4Iwtfy3LDqZBYQTh/JEyhSHuLbZcsWi4Vm6+8LvVY=
Received: from BY5PR16CA0007.namprd16.prod.outlook.com (2603:10b6:a03:1a0::20)
 by MW6PR12MB9000.namprd12.prod.outlook.com (2603:10b6:303:24b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 06:40:00 +0000
Received: from SJ5PEPF000001C8.namprd05.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::26) by BY5PR16CA0007.outlook.office365.com
 (2603:10b6:a03:1a0::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.24 via Frontend Transport; Mon,
 10 Mar 2025 06:40:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001C8.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 10 Mar 2025 06:40:00 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Mar
 2025 01:39:57 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v4 0/5] Enable Secure TSC for SEV-SNP
Date: Mon, 10 Mar 2025 12:09:38 +0530
Message-ID: <20250310063938.13790-1-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|MW6PR12MB9000:EE_
X-MS-Office365-Filtering-Correlation-Id: d8c969fc-633c-47c4-0910-08dd5f9e61d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?122eFIAovXv94+kpPIZ126mZR+EHL1GlXMqj1r7voiXJnVLIE9Il5149ewYn?=
 =?us-ascii?Q?G63KZTl2h5LBuLQ1dvbF540UmBzVudbhhrOKSEM2gvKQxaCxTzNnUK0fL+gJ?=
 =?us-ascii?Q?CTDQB0wc8SCNO8zObs6t6P4tLXV66QEzALsGol7Injt2fsI1ROgKcMXwBZel?=
 =?us-ascii?Q?VUYhTIb1gExAGrZAMiu52zvBSOLI/PQKVEOpIKldwm/oUglHxu2UnYSPrHeW?=
 =?us-ascii?Q?BD5zcZn8T1Nz1CEGCzMkisngeBDO3bMk+pkGOX7w+q/qTlYMIGjRLdhtIMIA?=
 =?us-ascii?Q?XXELFvORi8GgABiBZh9K2nuCW02R81dUksUtZPgR8it3Niu2c8tg6ceEVCsi?=
 =?us-ascii?Q?AWSAC9Z8xBsJNAiW306eQ97AKrDLZ891CYt+RNOkjZ7hHNH5BdYmAAX1Wftj?=
 =?us-ascii?Q?cSKJdTR1ItsilBs0nP7nrb/SRIrvjJNdc3FEipfBJxWpl2MmQ6/jvXh1uHBG?=
 =?us-ascii?Q?tKjsnssQW4oWGJp2wDKEJ+O+Am9tr80dcXil9D2x42UHZwC3b28ISJ+32ta8?=
 =?us-ascii?Q?2umFI3Sy+lMyofoP/0oNtbAS2jZ0r3UrxfO3dBDP/7aQUtGtyX7OUkRvxIyA?=
 =?us-ascii?Q?U6CgKunnmB4scI7O81gSbb7I9Q/13f0PIZFwP+MPLaDXdxZ05DriJKPaIr6D?=
 =?us-ascii?Q?lUuEx0IG1krdTDcuSqviuqeLSQpL4ZNGSl8DMx4SYtJmsbEUJtdfJ7aM2WqT?=
 =?us-ascii?Q?vTb60i5uQyX1X67WQ1W+UdZZuoFNq8xdSDdL/FcM7QTbJ62bcMyZVUQPH7vJ?=
 =?us-ascii?Q?Xr0W9nLTUlAkl1ubyd181gsMedAhXmT7sumZO/AKtQpuOSZOSzUQdUjOgdSO?=
 =?us-ascii?Q?/jqkGO4fiNhWk8mqfW6ZFPgdRy1EyhBh+AUPLV2jG3AX+HyPyPDXjT6u/4vI?=
 =?us-ascii?Q?+9IdNl+qeDJQnZlHuCvBRukHhAwug/bOwvHUhfDauCeCYYJhMj+SIrYdjGjl?=
 =?us-ascii?Q?M5HXmZHo2lLX9mH0GSwxAmUDdkoGnk/VEewBWvo5RLjyXRO0HWMYwV3FWuSs?=
 =?us-ascii?Q?qAJpYFw3z38FAAq2uXuwTUrhNeFJnF196VZIfe8wmy+cVjt23eRcqHkM4nDA?=
 =?us-ascii?Q?HiP8+PKX56FvgImxqENkcxcpRZ3RJp86DEPvVRncnoC0fLPdtrJ0UJ/WJ8zu?=
 =?us-ascii?Q?aYub1VomvLgmgpr9+epF37u4okNR9p0l75Og7aaJnte/OnqBzXrdXRy16VFr?=
 =?us-ascii?Q?+0pnx9kIZy+zvWd9VSFSRDK+J3XcVDXWqooNVzuX+gYzJRGM8KojuBAt3PGO?=
 =?us-ascii?Q?Fb1qsOEKY92k67c12GS9FuIQMufDOiWdfeCkJmp0JzwOTR4oA9oC4QueTmZG?=
 =?us-ascii?Q?1K6AdM6uKpDQw6MGG00oDXrXTJJfi0e+NM7Cd6kS/7P8GAYjvt/zLtstv4xb?=
 =?us-ascii?Q?QQoEqEGMel8ESQq3u2bCmaBpXqvbmhIQgvNQGvqfyUjpsf19G3lVP9dYcNvZ?=
 =?us-ascii?Q?0aBTvwSQIX3oZxsysQiYe0M7U6ZOVZsWN8GMHt/7JXRc/Ti4d/1wrFEnjSKf?=
 =?us-ascii?Q?kFrUHjAAXXuUXv0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 06:40:00.5451
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8c969fc-633c-47c4-0910-08dd5f9e61d3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB9000

The hypervisor controls TSC value calculations for the guest. A malicious
hypervisor can prevent the guest from progressing. The Secure TSC feature for
SEV-SNP allows guests to securely use the RDTSC and RDTSCP instructions. This
ensures the guest has a consistent view of time and prevents a malicious
hypervisor from manipulating time, such as making it appear to move backward or
advance too quickly. For more details, refer to the "Secure Nested Paging
(SEV-SNP)" section, subsection "Secure TSC" in APM Volume 2.

This patch set is also available at:

  https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest

and is based on kvm-x86/next

Testing Secure TSC
-----------------

Secure TSC guest patches are available as part of v6.14-rc1.

QEMU changes:
https://github.com/nikunjad/qemu/tree/snp-securetsc-latest

QEMU command line SEV-SNP with Secure TSC:

  qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
    -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on,stsc-freq=2000000000 \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    ...

Changelog:
----------
v4:
* Rebased on top of latest kvm-x86/next
* Collect Reviewed-by from Tom
* Use "KVM: SVM" instead of "crypto: ccp" (Tom)
* Clear the intercept in sev_es_init_vmcb() (Tom)
* Differentiate between guest and host MSR_IA32_TSC writes (Tom)

v3: https://lore.kernel.org/kvm/20250217102237.16434-1-nikunj@amd.com/
* Rebased on top of kvm-x86/next
* Collect Acked-by
* Separate patch to add missing desired_tsc_khz field (Tom)
* Invoke kvm_set_msr_common() for non-SecureTSC guests (Tom)
* To align desired_tsc_khz to 4-byte boundary, move the 2-byte pad0 above it (Tom)
* Update commit logs (Tom, Sean)

Ketan Chaturvedi (1):
  KVM: SVM: Enable Secure TSC for SNP guests

Nikunj A Dadhania (4):
  x86/cpufeatures: Add SNP Secure TSC
  KVM: SVM: Add missing member in SNP_LAUNCH_START command structure
  KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC enabled guests
  KVM: SVM: Prevent writes to TSC MSR when Secure TSC is enabled

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/include/uapi/asm/kvm.h    |  3 ++-
 arch/x86/kvm/svm/sev.c             | 22 ++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             | 20 ++++++++++++++++++++
 arch/x86/kvm/svm/svm.h             | 11 ++++++++++-
 include/linux/psp-sev.h            |  2 ++
 7 files changed, 58 insertions(+), 2 deletions(-)


base-commit: c9ea48bb6ee6b28bbc956c1e8af98044618fed5e
-- 
2.43.0



Return-Path: <kvm+bounces-34586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17E0DA025DD
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:47:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E533C16144C
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 244532BD11;
	Mon,  6 Jan 2025 12:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uowM9MTx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080BF1EA90;
	Mon,  6 Jan 2025 12:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167625; cv=fail; b=F7hTmJm7wIUc1AQrvwIHJf4ikGm9JeKpm90uJkrfwGLS23vtyzFlooixDCehLcJQZna7j91NzDJ95zDH+s1OcKmZcblz185C9P8Dsj7YzvWl+aItJl5UCH7Tp9PX5M9k8REdkDxJ0JfhKu5yILTTOwR22CQjU8wBse6rXHTZwvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167625; c=relaxed/simple;
	bh=z1x6jgOZT8hU761fzzQ4KDU3eN3rnyG2K8DeedNrpqo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VzchyjPmxfo3WssuJtBYLqda0wEbh4bKwp4DO2nni5mj1UhweClCd+uvq22wCFQDK1KUGXGFrtllIpTPAS94rAAv0eVJ2cPtygxYePyQ9z6oQJMzoKHN35ko1tZ7HlbHXjDhxnj44flz7kGF10r0B8U5JfKaMPR4kiOdhaNmV7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uowM9MTx; arc=fail smtp.client-ip=40.107.244.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qr6N5jyHHqeS+3DH7HNx880eNoGh0SKizntg6dO0he3017EGjhiI/3rCs5cP/1v5UGTucJ21dddXh1sV7fHnfNdp3NHAagu2VPjnjgjjNtyLGSNsyCSaQOLizEzMuJB8yACSk7h9w0a/UWRr8Jhjn8vJUXBuqqgvT4gilOoycQqnvrIv4TZ8qBY+2hhOfdXxkxftxXTqTZxU9Sy/bDwD3DY+911X+Ordm9Bse/BT6V7Y4RX0EwJiDuK8VwYn5SPh4P01H7D3Nc09r6lP8KGCsXgu8p9bx8tJRgR0e7ca5KG46sjxAiuHG7rKwfUSGw4z3J7HqSSvtkWhpRKARC3Rmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRM2IJVw/3C+Kvw9ajfQSWI3P1MhfXtRRcb5rhgs5KQ=;
 b=n6lwnTFZ/XQ1EJjAAhP2eNPM0sI+MkhKq4EoFH3v6uzTYnu991mHM0w1KPD6WAMEf1g8VWNUf2lBH7zOFBn7HjRY4kMEx5x4XKIhZJX6WYD6BSuxz7HrkDYCHbjWst6K+Z6P2Z/jNTCVpS8/jzUWq8GYIDAQ3RBNq2rATltk4ZEte39A5W429SK+5M8xQvtgVGHbsH5Hwds5PhR1OEEP0QppyaJZ0EdcrXjEx21fi3udkcNonb4bXRy0LBPwEUpkTbLfEIxkzuHqI+CQxqe5Uyvhirh+aN7YUTlyYPfBo7HllpIqtWZhCeT4GuiM8HHKiCAde/E0czyVRjNSopJCxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRM2IJVw/3C+Kvw9ajfQSWI3P1MhfXtRRcb5rhgs5KQ=;
 b=uowM9MTxLuz0tM4wm/Ijvn45Kzg4QVeDgAgqUWPkKdm7jp1xqcwLx0QScDHLrvFc7FKbL/OnRqULDoUP4F8upRZFgWsoMRZAi/sN74df14CoxQD74DLPyB/Q4zwdy/jY71s1tB4A6gHqeUq+du9ewH2nwGEWw4GytnsXZlWPRHo=
Received: from CY5PR22CA0009.namprd22.prod.outlook.com (2603:10b6:930:16::20)
 by SN7PR12MB7953.namprd12.prod.outlook.com (2603:10b6:806:345::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 12:46:55 +0000
Received: from CY4PEPF0000EDD3.namprd03.prod.outlook.com
 (2603:10b6:930:16:cafe::1f) by CY5PR22CA0009.outlook.office365.com
 (2603:10b6:930:16::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Mon,
 6 Jan 2025 12:46:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD3.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Mon, 6 Jan 2025 12:46:54 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 6 Jan
 2025 06:46:49 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>
CC: <kvm@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <pgonda@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <nikunj@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v16 00/13] Add Secure TSC support for SNP guests
Date: Mon, 6 Jan 2025 18:16:20 +0530
Message-ID: <20250106124633.1418972-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD3:EE_|SN7PR12MB7953:EE_
X-MS-Office365-Filtering-Correlation-Id: f8fa9db3-cff5-49c4-8d69-08dd2e50332d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pYxqq/Bqaz1T3zsyIZUeNdRU2W7JYnXnYqb+N/KQ1GpqDCJhVx8t+8iYPNaO?=
 =?us-ascii?Q?NuQm6gSZJD+l+GMF5VYvbIUWve57qBuh33jsk5gDSd80kxWc02r1BSf2D3wH?=
 =?us-ascii?Q?y4nJacwmEY1/vZlkMlbw0ZghgTsTUQtKexHEzxXjMmSQEUN7RayFH69poVv/?=
 =?us-ascii?Q?Ew94PYdm4wxFeHcztZwmHTvuoOV2tgqaW5c6EcUctOwH9+/tLSefYzjyxvPX?=
 =?us-ascii?Q?FE8EQFQqgU3WFeuoouTTZSptMDBe7sUMywkZ24j8Xh8HH0r//33wQGRnDADu?=
 =?us-ascii?Q?K7cE4ko5ZreLt0ymfDmnYQ+aGCd5RAMdy/K7chpNJMl3l4bEvvm9tLtVo6U9?=
 =?us-ascii?Q?HorSsYrpmTfIc2zd4Svd86lYNIgFPf21BmRvFMq/9Gs3Sy/JaktQSUhE0IhX?=
 =?us-ascii?Q?+8QPem5L4gpB9SsbW2KX395TKhfo3nurpMAq6flWZQQe49Sc0Vqnlzj+JSKs?=
 =?us-ascii?Q?aaud7xNBurpKoAmXRj112Zw9SX64JZIWhKLqFinVnP9+tHEoExZDyoaJDB9b?=
 =?us-ascii?Q?wLI/KjlNtxmRHQA4Qu2uAJKD6CQuXIEgqYz7A8eyhs33j7TCC/yVwJE2zQCI?=
 =?us-ascii?Q?zyFJH3M1wVB1QhaPCMSxBOiUJlQ3ddFMbvPD2I4VyzXfWZMJg+mNGGMnoc/l?=
 =?us-ascii?Q?cIAo1W9q8KSziFZ5HTuVtZDTtBT1h6DLP9kJLzZni0ew5n++tYXHZaEuXnPo?=
 =?us-ascii?Q?ugLoAO/A1pDGarvY2bYz1bglTWX4KEMqYMSvXmTvGVRejLg/5qzI7C31FzZq?=
 =?us-ascii?Q?TW4udMmk/TOZAodZ1/JxUahk42JdOg3ZyVRCr4oAwRKe2IVJeo4EflvVYU1f?=
 =?us-ascii?Q?P6HD6BbIPPlE2CFVlnqQ6qX8SVl7r85LeDrQQ+NI/hr10Dz0iYHFqlA9xHHr?=
 =?us-ascii?Q?m8JyWhuPGGyZp6yXLewBh6K7Zvg86GPYE7laqFrgX1fXyTo2yEzKrA6L4soA?=
 =?us-ascii?Q?SkCc97l6Thaw/SDv0+PZ5M2wIT4jZk7/KN+K4QUSaa7NKVlteE5QYbdhP2TO?=
 =?us-ascii?Q?fdfus5qfFTGH9TnXkDBURxj5J2gPEz6XzB0atdehkGDqtaVh3qr5YN2mp0AY?=
 =?us-ascii?Q?RKeCsv7uEwVJZrlDona1hSkkGgVYlUiGM+2oafsrOskxVguFLL0DH9qDeRol?=
 =?us-ascii?Q?3rZ6qr4M3ZSuP2B/DAo8umkrt1+SFEDYXniDEwfefmvINvwey7o8qWzCW/5E?=
 =?us-ascii?Q?WgRJud/aCE/1OTElsK6ISvhJp2FObNXq4yA0QiDovtRmhNwqm/FPuseqOUPW?=
 =?us-ascii?Q?2ADoQHngJKs1o96C3e8Gezg4dFOLeXs92M2ela2lX6a122bGjdXDpCLcO8fm?=
 =?us-ascii?Q?i6hqSTT1+DFdQjv+3SbHUpjsDN639bcx95qX3GkkWydXLSRKOTHqnXNcpbSA?=
 =?us-ascii?Q?y4+T5N+mDscvQq8r/0XV5skJtlljoeLjkKZdeVAS+/MkD5WKOLzuIvWWnAJM?=
 =?us-ascii?Q?2YBqc8YfVTVqBhq0I9wS5baRnan+7pGnPx0ZpQBRZ9WTPbxu/x2CDmV4RgHI?=
 =?us-ascii?Q?4lLJbdweXOcrDAQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:46:54.5644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8fa9db3-cff5-49c4-8d69-08dd2e50332d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7953

This patchset is also available at:

  https://github.com/AMDESE/linux-kvm/tree/sectsc-guest-latest

and is based on tip/master

Overview
--------

Secure TSC allows guests to securely use RDTSC/RDTSCP instructions as the
parameters being used cannot be changed by hypervisor once the guest is
launched. More details in the AMD64 APM Vol 2, Section "Secure TSC".

In order to enable secure TSC, SEV-SNP guests need to send a TSC_INFO guest
message before the APs are booted. Details from the TSC_INFO response will
then be used to program the VMSA before the APs are brought up. See "SEV
Secure Nested Paging Firmware ABI Specification" document (currently at
https://www.amd.com/system/files/TechDocs/56860.pdf) section "TSC Info"

SEV-guest driver has the implementation for guest and AMD Security
Processor communication. As the TSC_INFO needs to be initialized during
early boot before APs are started, move the guest messaging code from
sev-guest driver to sev/core.c and provide well defined APIs to the
sev-guest driver.

Patches:
01-02: Prepatch
03-04: Patches moving SNP guest messaging code from SEV guest driver to
       SEV common code
05-10: SecureTSC enablement patches
11-12: Generic TSC improvements
   15: SecureTSC enablement.

Testing SecureTSC
-----------------

SecureTSC hypervisor patches based on top of SEV-SNP Guest MEMFD series:
https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest

QEMU changes:
https://github.com/nikunjad/qemu/tree/snp-securetsc-latest

QEMU commandline SEV-SNP with SecureTSC:

  qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
    -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    ...

Changelog:
----------

v16:
* Rebased on latest tip/master
* prepatch: Remove is_vmpck_empty() and use memchr_inv() instead (Boris)
* prepatch: Uses GFP_KERNEL for snp_init_crypto() (Boris)
* Use memset during cleanup and fix memory leak (Boris/Francesco)
* Use tsp_resp with extra allocation and get rid of buf variable (Francesco)
* Drop RoBs and TBs, comment/commit message update
* Add switch case for #VC Secure TSC MSRs handling (Boris)
* Move CC_ATTR_GUEST_SNP_SECURE_TSC before host defines to group guest
  defines(Tom)
* Cache the TSC frequency in khz to avoid reading MSR and multiply every time
  (Tom)
* Drop the patch preventing FW_BUG for not running at P0 frequency (Boris)
* Limit clock rating upgrade to virtualized environments as part of
  CONFIG_PARAVIRT (Boris)
* Squash patch 9 and 12 to logically merge changes that switches to TSC from
  kvm-clock (Boris)

v15: https://lore.kernel.org/kvm/20241203090045.942078-1-nikunj@amd.com/
* Rebased on latest tip/master
* Update commits/comments (Boris)
* Add snp_msg_free() to free allocated buffers (Boris)
* Dynamically allocate buffers for sending TSC_INFO (Boris)
* Fix the build issue at patch#1 (Boris)
* Carve out tsc handling in __vc_handle_msr_tsc() (Boris)

Nikunj A Dadhania (13):
  virt: sev-guest: Remove is_vmpck_empty() helper
  virt: sev-guest: Replace GFP_KERNEL_ACCOUNT with GFP_KERNEL
  x86/sev: Carve out and export SNP guest messaging init routines
  x86/sev: Relocate SNP guest messaging routines to common code
  x86/sev: Add Secure TSC support for SNP guests
  x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
  x86/sev: Prevent GUEST_TSC_FREQ MSR interception for Secure TSC
    enabled guests
  x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled
    guests
  x86/sev: Mark Secure TSC as reliable clocksource
  x86/tsc: Switch Secure TSC guests away from kvm-clock
  x86/tsc: Upgrade TSC clocksource rating for guests
  x86/tsc: Switch to native sched clock
  x86/sev: Allow Secure TSC feature for SNP guests

 arch/x86/include/asm/msr-index.h        |   1 +
 arch/x86/include/asm/sev-common.h       |   1 +
 arch/x86/include/asm/sev.h              |  48 +-
 arch/x86/include/asm/svm.h              |   6 +-
 include/linux/cc_platform.h             |   8 +
 arch/x86/boot/compressed/sev.c          |   3 +-
 arch/x86/coco/core.c                    |   4 +
 arch/x86/coco/sev/core.c                | 652 +++++++++++++++++++++++-
 arch/x86/coco/sev/shared.c              |  10 +
 arch/x86/kernel/kvmclock.c              |  11 +
 arch/x86/kernel/tsc.c                   |  43 ++
 arch/x86/mm/mem_encrypt.c               |   2 +
 arch/x86/mm/mem_encrypt_amd.c           |   4 +
 drivers/virt/coco/sev-guest/sev-guest.c | 485 +-----------------
 arch/x86/Kconfig                        |   1 +
 drivers/virt/coco/sev-guest/Kconfig     |   1 -
 16 files changed, 791 insertions(+), 489 deletions(-)


base-commit: af2c8596bd2e455ae350ba1585bc938ee85aa38d
-- 
2.34.1



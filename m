Return-Path: <kvm+bounces-20247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD4F29125A8
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:40:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CC321F238B3
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91876155305;
	Fri, 21 Jun 2024 12:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dNuErk0x"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5794152166;
	Fri, 21 Jun 2024 12:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973570; cv=fail; b=nxFAYOjoahKWFNeg5WjjvHFa9QjqqucIVClwcaYrF8TTHo7XYSqQd70f/ZyVYbO8Wfl7Tddad91M8TDLe3lxA9jpAYossoYnPZBZ8IZ5Py7NwJENjwlTO7N7Hr1H+zE9s9QeIxLoF2rcyaZJrgYyyPWRJ+2GRIag6atDM/4nBi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973570; c=relaxed/simple;
	bh=/VXLvlwDqX4wjj5mcGJKe440pwBUa/S1hgULE0ooHS4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=moZudbRamracHIqEMzCpCownA6OFuci/hX60ekMguwrRRgop615aKgE/Pmy2sKbxCDfmhQbBhBRc0em1rFaWjfsTxTqKf2Hv/dzFXI43sahnAsul9PA14AYFmCXwq7M2bGvWfMQGLKMqNsQjBrsdycJiQc+KvZSm+IEbtlemRZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dNuErk0x; arc=fail smtp.client-ip=40.107.244.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=goSoJAVOtf1Wmr5UANGbFp8Cq4B74Suk1VRlT84Zn/rmqtz7HwuVRypifEbv+vU2yn06xdK+4HQKWOh2sTUz2zEim+xN0sn3a/893XnbqSql/ogOHtqABgXK7wcODoyFAF8M1q5tHV7r5Jo1vVUpTord3NdVNAbFP+ID2MHhP2LIww3YBw/PSZsCev+zeTlYnfR92izK7ih48yOekw8aJLDiSHSmjkSBxWkhX4LuCASyWlVfHY7EdGO5T15z8Wlz7ZDIiq3igR9vCzs9/dGA453hD67SgQS+BmgKhIxRlEaoYDPKQmV/ekE8xP5rhNX0nurCqKiMl28FSjCoq+dMHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zue+qDjinPt9koOGOlNw2EJLGxrmLQnPyPbgmmrWg+o=;
 b=Cm2ZlYoiY4rfBKTII7JjWnA7yulrdU0hEZp4IhiTHowWSKeNb58zeZ/Sf/cVCM44Ri3lZxrPaODE0RCyIKzZiCK6Y+pLWVwQLTRZ7cCrW+yut3b88I5sDZ4ehN8kdvXx5th1YEaVy6LYD6MjqN4ZaK+jCrB1/q4GUV0/iFfdHvFay0x7v7gNU2QEod7+y/ZMdTaIL/EZM9wk4RG5qq6pQAmhow7WPp59ytk+b+4JgYewCGecFCzOv2EO6vNbZOQaPVPWBaj+AhVaa0kErRyNZaCmaAPwJvxvl4WiTZ5/A8Rp+a5j58H2NHisyaQefn5G9DAiuloUHvurqgoy7w/HpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zue+qDjinPt9koOGOlNw2EJLGxrmLQnPyPbgmmrWg+o=;
 b=dNuErk0xeaiv7ocICJ+MVgSQLLlQIjori+HXXubZORn3HQViZ9i3BUNER7dv/QVHmTUy2vX8CBjLtF/9XqkwRHlSADwZ0xptwsfuHEy/30Me07B0WhSB6U2rsiE05wR7TFGtZccDx+t9eSj6SZ491HoAwlMleplScYe/x42D+L8=
Received: from PH7PR13CA0006.namprd13.prod.outlook.com (2603:10b6:510:174::19)
 by DS7PR12MB8322.namprd12.prod.outlook.com (2603:10b6:8:ed::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Fri, 21 Jun
 2024 12:39:26 +0000
Received: from SN1PEPF00036F3F.namprd05.prod.outlook.com
 (2603:10b6:510:174:cafe::b5) by PH7PR13CA0006.outlook.office365.com
 (2603:10b6:510:174::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 12:39:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3F.mail.protection.outlook.com (10.167.248.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:39:25 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:39:20 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 00/24] Add Secure TSC support for SNP guests
Date: Fri, 21 Jun 2024 18:08:39 +0530
Message-ID: <20240621123903.2411843-1-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3F:EE_|DS7PR12MB8322:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a3bfa16-1294-4bd4-f26c-08dc91ef2f85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|36860700010|7416011|376011|82310400023|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QcrnAlcJfOaedf4mYuKhBq9J2Ad8bIHOnT1GtasCfVi3+8dAmOYIPsmsibR9?=
 =?us-ascii?Q?BdYbt31qEjB3V6bJAiM5zoHrk9EQov83MUk9+D+brXdX4jmEAxSKcfuM4OvA?=
 =?us-ascii?Q?VFFKsE04DRqYfng5nQ0lDWeuUEjTa/cI7jcmKsQ/bPQ6iGsyXZq+ZitiUk1E?=
 =?us-ascii?Q?kYLDxSMI4sDnH5YB99H1Mwv6L7noD5I16JunhFPX8ey/m4DocVlpOADl0OHZ?=
 =?us-ascii?Q?Ykos4In0vnEzQcATLhUAZp+H98fAVrdNijpPziVpMTGcMpeU/pAm2VNKx9GT?=
 =?us-ascii?Q?zAlVmLUrQeFitkFwvcG41D2zbvrGTEWI7nQRhAxBCJ8nNHXGMmSLGSn1IvN0?=
 =?us-ascii?Q?ApJXwqRkizRkpdH7qPaonY7AIZ+Z0BkDSitHPi5nWnUUwUYQUNTynggH4tEJ?=
 =?us-ascii?Q?AGbN5m9CH8AUXM30ltyD9/D0LNRXI6qJWLtwFWC5HGCPqyXxvtn18w7zh3UO?=
 =?us-ascii?Q?1ipPWns6OxPn4u7nEtA6UNfYQNGcBBy+UIOOXzdVIEXB/UtPZaRtcW6V5ajy?=
 =?us-ascii?Q?/9IwqpdifDn23pWDTkw8dnSBLjiuoEY95zNCrUfQuY0nohhbZdPVhDY1hiGe?=
 =?us-ascii?Q?wGKWoxlMcXGsHRFrWfzEBN1gHaa1i3gLtgk461ZDGvA4ftGn5fvayYmIGI2f?=
 =?us-ascii?Q?A4DS0mHaPkbBYW6EY/uhAgFY6XBysT1x6LEQqJWtZjI6k5YG8X3YV+yxsBLW?=
 =?us-ascii?Q?1+76ew9U+uiXbH8DUx/6Ll1VUiJfKrWajR5tZlWrL25z0CssrCUezuUa6UYM?=
 =?us-ascii?Q?r1+POT6dT4iHLQ2nNshZkY1niuKpQP4rbxdD2R7lFRpfQ3IGpRZdVvji6y6h?=
 =?us-ascii?Q?oPtvhEaDfgUXRv7BgO1Gu5/7iSngn5kw9NlncsKm0QZbpgrtwHJpkGzUZxMP?=
 =?us-ascii?Q?Z6klJRWNR9lePrPRqKp5v3WmNgPzIaqxjKV8uF6FLK50Gf1QtFGDGUVPGcYi?=
 =?us-ascii?Q?LYMeRskEIeHunTZIkf0Ph2WFNXYR5RU1uyb7/jkVDc89gxc0zlU0xme3DeLg?=
 =?us-ascii?Q?OK/b3kS9Gmv7JX2NT2yWggdkPuN5KuJxmTqf4A7pV0YxknffwttXphR3UvVZ?=
 =?us-ascii?Q?mSNQQADyzV8+XceXWjTbPY2tom0wAC43TT1iS+bsvutR7lUsG3XEZ3gFh72N?=
 =?us-ascii?Q?x7mlWR3TwzWCgktx5CIPw4i4uZdIOmD+vt7XqDwpu6X6fnycJp9Lm5u/EFF8?=
 =?us-ascii?Q?2cIScIaB4FVtg6yd7YeZQiV93N+Dm5N13mN99V5k90dHm+bP0gVe1P+ZokjZ?=
 =?us-ascii?Q?ugE8ThC6XOAvqV9h3mZGpu8mWwR4BTugtzKW1U+Fdblb0/T4TbpB6Opy60+X?=
 =?us-ascii?Q?XVHn6z9shr9/sY09hbr+bfn5VMUIJu5Ya0L+raMNyhQuchln2jXclXqSXZYv?=
 =?us-ascii?Q?qLP8+dI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(36860700010)(7416011)(376011)(82310400023)(1800799021);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:39:25.8099
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a3bfa16-1294-4bd4-f26c-08dc91ef2f85
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8322

This patchset is also available at:

  https://github.com/AMDESE/linux-kvm/tree/sectsc-guest-latest

and is based on tip/x86/sev

commit: 06685975c209 ("x86/sev: Move SEV compilation units")
 
Overview
--------

Secure TSC allows guests to securely use RDTSC/RDTSCP instructions as the
parameters being used cannot be changed by hypervisor once the guest is
launched. More details in the AMD64 APM Vol 2, Section "Secure TSC".

During the boot-up of the secondary cpus, SecureTSC enabled guests need to
query TSC info from AMD Security Processor. This communication channel is
encrypted between the AMD Security Processor and the guest, the hypervisor
is just the conduit to deliver the guest messages to the AMD Security
Processor. Each message is protected with an AEAD (AES-256 GCM). See "SEV
Secure Nested Paging Firmware ABI Specification" document (currently at
https://www.amd.com/system/files/TechDocs/56860.pdf) section "TSC Info"

Use a minimal GCM library to encrypt/decrypt SNP Guest messages to
communicate with the AMD Security Processor which is available at early
boot.

SEV-guest driver has the implementation for guest and AMD Security
Processor communication. As the TSC_INFO needs to be initialized during
early boot before smp cpus are started, move most of the sev-guest driver
code to kernel/sev.c and provide well defined APIs to the sev-guest driver
to use the interface to avoid code-duplication.

Patches:
01-09: Preparatory patches for code movement and general cleanup/fixups
10-13: Patches moving SNP guest messaging code from SEV guest driver to
       SEV common code
14-16: Error handling and caching secrets page
17-24: SecureTSC enablement patches.

Testing SecureTSC
-----------------

SecureTSC hypervisor patches based on top of SEV-SNP Guest MEMFD series:
https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest

QEMU changes:
https://github.com/nikunjad/qemu/tree/snp-securetsc-latest

QEMU commandline SEV-SNP with SecureTSC:

  qemu-system-x86_64 -cpu EPYC-Milan-v2,+invtsc -smp 4 \
    -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    ...

Changelog:
----------
v10:
* Rebased on top of tip/x86/sev
* Added Reviewed-by from Tom
* Commit message updates
* Change the condition for better readability in get_vmpck()
* Make vmpck_id as u32 again and use VMPCK_MAX_NUM as the default value

v9: https://lore.kernel.org/lkml/20240531043038.3370793-1-nikunj@amd.com/
* Added Acked-by/Reviewed-by
* Removed Reviewed-by/Tested-by from patches that had significant changes
* Added patch to make payload a variable length array in snp_guest_msg
* Fix all your user-visible strings (vmpck => VMPCK) and readabilty.
* Separated patch for message sequence handling
* Handle failures from snp_init() in sme_enable()
* Preparatory patches:
  * Carved out simplify VMPCK and OS message sequence changes
  * Carved out SNP guest messaging init/exit for proper initialization and
    cleanup.
  * Move SNP command mutex down and make it private to sev.c
* Pure code movement patch and subsequent code changes patches
* Drop patches adding guest initiation hook enc_init() and call
  snp_secure_tsc_prepare() from mem_encrypt.c
* Use CC_ATTR_GUEST_SECURE_TSC and drop synthetic SecureTSC feature bit

v8: https://lore.kernel.org/lkml/20240215113128.275608-1-nikunj@amd.com/
v7: https://lore.kernel.org/kvm/20231220151358.2147066-1-nikunj@amd.com/
v6: https://lore.kernel.org/lkml/20231128125959.1810039-1-nikunj@amd.com/
v5: https://lore.kernel.org/lkml/20231030063652.68675-1-nikunj@amd.com/
v4: https://lore.kernel.org/lkml/20230814055222.1056404-1-nikunj@amd.com/
v3: https://lore.kernel.org/lkml/20230722111909.15166-1-nikunj@amd.com/
v2: https://lore.kernel.org/r/20230307192449.24732-1-bp@alien8.de/
v1: https://lore.kernel.org/r/20230130120327.977460-1-nikunj@amd.com

Nikunj A Dadhania (24):
  virt: sev-guest: Use AES GCM crypto library
  virt: sev-guest: Replace dev_dbg with pr_debug
  virt: sev-guest: Make payload a variable length array
  virt: sev-guest: Add SNP guest request structure
  virt: sev-guest: Fix user-visible strings
  virt: sev-guest: Simplify VMPCK and sequence number assignments
  virt: sev-guest: Store VMPCK index to SNP guest device structure
  virt: sev-guest: Take mutex in snp_send_guest_request()
  virt: sev-guest: Carve out SNP guest messaging init/exit
  x86/sev: Move core SEV guest driver routines to common code
  x86/sev: Replace dev_[err,alert] with pr_[err,alert]
  x86/sev: Make snp_issue_guest_request() static
  x86/sev: Make sev-guest driver functional again
  x86/sev: Handle failures from snp_init()
  x86/sev: Cache the secrets page address
  x86/sev: Drop sev_guest_platform_data structure
  x86/cc: Add CC_ATTR_GUEST_SECURE_TSC
  x86/sev: Add Secure TSC support for SNP guests
  x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
  x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled
    guests
  x86/kvmclock: Skip kvmclock when Secure TSC is available
  x86/sev: Mark Secure TSC as reliable
  x86/cpu/amd: Do not print FW_BUG for Secure TSC
  x86/sev: Enable Secure TSC for SNP guests

 arch/x86/include/asm/sev-common.h       |   1 +
 arch/x86/include/asm/sev.h              | 196 ++++++-
 arch/x86/include/asm/svm.h              |   6 +-
 drivers/virt/coco/sev-guest/sev-guest.h |  63 ---
 include/linux/cc_platform.h             |   8 +
 arch/x86/boot/compressed/sev.c          |   3 +-
 arch/x86/coco/core.c                    |   3 +
 arch/x86/coco/sev/core.c                | 581 +++++++++++++++++--
 arch/x86/coco/sev/shared.c              |  10 +
 arch/x86/kernel/cpu/amd.c               |   3 +-
 arch/x86/kernel/kvmclock.c              |   2 +-
 arch/x86/mm/mem_encrypt.c               |   4 +
 arch/x86/mm/mem_encrypt_amd.c           |   4 +
 arch/x86/mm/mem_encrypt_identity.c      |   7 +
 drivers/virt/coco/sev-guest/sev-guest.c | 719 +++---------------------
 arch/x86/Kconfig                        |   1 +
 drivers/virt/coco/sev-guest/Kconfig     |   3 -
 17 files changed, 846 insertions(+), 768 deletions(-)
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h


base-commit: 06685975c2090e180851a0ff175c140188b6b54a
-- 
2.34.1



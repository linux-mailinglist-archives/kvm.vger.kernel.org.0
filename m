Return-Path: <kvm+bounces-41160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CED55A63F83
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 06:23:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 017D4189041B
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 05:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9295218AAA;
	Mon, 17 Mar 2025 05:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C18Bw7Nz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2049.outbound.protection.outlook.com [40.107.102.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD35217705
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 05:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189008; cv=fail; b=UPsAqXrMHWeFERwmToVVJEkSpBPROZbho9lC8cSk9LCjaOP9BCJdqVTJqH8uIuo5muVnt6/gZRDJKdJvbeYeuYVitkudFz75+0VVU1XBcncwClLNHml+zHF96TyKKoLSetVYLtHgDjuSsXbiRSdTpy7w2hTTCOjU0PPxwv3Bb8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189008; c=relaxed/simple;
	bh=CtTNhiHzz3VcKOW7ixTSlCd7p0daypO257+DtrkDazQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sFlv5XOm86q6gAmZnv8RhxcUMGaE5fvysno4CF1gbJjj85MbbAaT93pjqzFnBNi8B2y1kAvhDibIcWLt4xPhtuF/0/0ZOCX9ogT/UIKt9RJA94O+gBfyNNKnsHSVENBFEP2Fkg4pbM3qM3pBtS9UxmRdu+hc4XQtTSUAiUInAKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C18Bw7Nz; arc=fail smtp.client-ip=40.107.102.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fiD+DYvsdMsKZ7crHLOhNns14FCfA3CadmVoBSGCxNXa728vEqwdWqLMxC/RBv1HQBfOKHj7Y5FyhU9F+55FUSHq+8AGMS+s1Sm1b1J355f48p+Gk8EhHQirpsdlEgoL/0EiAFHQ+yUuZpBMh0YiTudGGKsVoy4lmWXDnLl3UNnjUoqopMUcnoM8261X+HXikVPGfXTPblrfqrmQAK7/clX5Jv4GWcK8/v5bPkwayW1XkZHjWDRwX2a7zikPqdCBDuVGomnPL7vdgHp1QGMcW+mrFk5n+lYAsJR/M+URePhfc/3b3obC0XSXRQ/MxwUkHkVFDh8djseCskqQisofJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1UoBhTViCA+Hmv4JOLtkitSna4qYz818tok4i0hDMgE=;
 b=v6Uc31923P8EpJo1huy/v9PIwXgh5z6ON2Fl9MldB7qealfN97fOEXsHdZ6EZsKqvngm0ZQjMZvlubf+h6ARNXGWcJI7yWgci9W4Bq8CWKchHudEc94eHxoN+hHZg6V7OLAdPsAvKSwVVW6blCl+KjMo1zunm6JIZU96zI09L8XLCHeNI+E0YPzOzJ1JMlGNY+Pk+1MGpsAH3GF32pcHOV4gAGKMZ3yGNlmG2ajlyuSr/3Sd7PI6V0rZiiIOmGJPvyy+eOEWBBMP/WbRDSCceESkpQUbl96lgNCj8pzQ1f3Jd0cA9xDXPuMqZSbkPRsgeAIb0AjwiyJaXxfOTRdpkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UoBhTViCA+Hmv4JOLtkitSna4qYz818tok4i0hDMgE=;
 b=C18Bw7NzKRWN35arheMyEucttZ0Rfog4WFSjdeKSIES4dfEYe+jQLhOLJjKeLsCl4qv6rtp03MRTjfok7VsJgZSHU3wUz6P5lSYb4TG6jqSvvk6xlSE3CXVOm9fGVXP279AQi0FRTTvNhAxz5TDWIQXOLR35bX24t5CXbgGBLz4=
Received: from BL1PR13CA0199.namprd13.prod.outlook.com (2603:10b6:208:2be::24)
 by IA0PPFD4454CAA9.namprd12.prod.outlook.com (2603:10b6:20f:fc04::be5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 05:23:22 +0000
Received: from BN1PEPF00005FFD.namprd05.prod.outlook.com
 (2603:10b6:208:2be:cafe::f) by BL1PR13CA0199.outlook.office365.com
 (2603:10b6:208:2be::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.33 via Frontend Transport; Mon,
 17 Mar 2025 05:23:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00005FFD.mail.protection.outlook.com (10.167.243.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 17 Mar 2025 05:23:22 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 17 Mar
 2025 00:23:19 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v5 0/4] Enable Secure TSC for SEV-SNP
Date: Mon, 17 Mar 2025 10:53:04 +0530
Message-ID: <20250317052308.498244-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFD:EE_|IA0PPFD4454CAA9:EE_
X-MS-Office365-Filtering-Correlation-Id: db3a8389-e862-411c-da61-08dd6513d5ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZTE/ntK2zdvBY7wLXQecBV+1zfJuF3HP3dchK1KDK/RfdqtlW+TPtwtX8LBP?=
 =?us-ascii?Q?0utqQMkXJhYxWiuM0FcjDstJ9CHqcFYr8G/nDHSQ94acDbhAILBq1dX05K6/?=
 =?us-ascii?Q?ZW9vfeoGfkcDNxGV/TWlQzg6VccH9FqBHR3R/gRiFDoPH+Jk/FaDbdwfvhl7?=
 =?us-ascii?Q?5Dk1MZaxHRdj9IgoT+P+NEQG/S5P3Mqf4iu5ESa0NMWJkraLbicpt/Mf3dFV?=
 =?us-ascii?Q?OJxJbzcHi7VaMJ2kYROGOU2QxUSRl4mL1UEPiVDB0yZkIP+ryLLZ2hbB7hNV?=
 =?us-ascii?Q?4PIRICRWWCu2OwCxbV3sUk0HbAJOBmkZ9FrgeO3XKBUDM62qjL9invhmiT1N?=
 =?us-ascii?Q?TKR0GrCUN4QORuNjbDJZyr2cg0XGcSHgkL9rq0F+6b/Hxnc/Skf0IiZgsI52?=
 =?us-ascii?Q?5InQRsnzVcEgI6sRATVr0/j0rsDUYDnkseEuq2dAn/tHdEKr2SQfuroBiIXA?=
 =?us-ascii?Q?WXX2ClQnqSseb8M0rVEiX34rvByoqisWQp0kyglGhLCmDeqedqRFcHAR73TO?=
 =?us-ascii?Q?uPfmn2buAqGBuAmvv4uSnNQBPeYtNDoWcCFb4Ga3hHs7S1gMaalKRObbObZ+?=
 =?us-ascii?Q?6l53Uxdx203s8WkWKG5ArWuWe2N4oTiwC0xakkHi/Ht3pIBq1ZkV9X+dkv+p?=
 =?us-ascii?Q?jKISqoUXU3Uy6dri7Yd4k1jWsjk5Z+oiWMG/Q7TeG7RTPYJprWh9rNHCh0fk?=
 =?us-ascii?Q?dG05VpSoO2nyhpuRT18ErHfd08GlfqQg5qLAWz9YrREP2vGMwlU7ANjzznAq?=
 =?us-ascii?Q?pzly4CxPDPPkXa4TBmBeitvgQMFQnkAz5Wjc0Dk8RUroZE+3dEHP4+xH7ULP?=
 =?us-ascii?Q?DRjJcXzkYrtDZ3791qKw+Z89gCe46skl8cVPC+0ILzdSalezexSPVppv3LxO?=
 =?us-ascii?Q?4GqQhGzGlDmivly4h+u0y7VIDpOQ5zshWlMWNgf26QZrjERXSvbS8eP5bBVY?=
 =?us-ascii?Q?rixoh2ccH6gjrzDdZoKfr+XXaSLXhpDoJbSPNOVagcjBkBBcZE3FHSZQ2gPW?=
 =?us-ascii?Q?ZKMmgAfYeKiX2FlcFpzveKoZ+A7tVh8HnC6gO5opXbikZS9cJTtuNy7LuY4E?=
 =?us-ascii?Q?iW6PH19Bnxurt3fBYUQ/hIYbikCvlGgXDMwaaJkXdW9q0/w6xKtLLuoj4h+4?=
 =?us-ascii?Q?Hm2YFSkUrzM73R6vYK10bGxecaQvbPIupH0FAso72ewvHFGfillTWGqY7b7d?=
 =?us-ascii?Q?PCcXQsNs8GLFuHYsNBRpvI0qKl+OayxitHwwPDI9JJq6X6OHU6U/eu74fhZ1?=
 =?us-ascii?Q?J1WjWQofOe6Izs310ZfrZw1THgtinCc1CWT3bB8fs1ndOCR9TjL5ZiBf+gJe?=
 =?us-ascii?Q?WPgIZCP9gmpg3jFStl7WHIRHc2lLlNGDhjhF3U0u66rkXav4yYLlJ5ZNkbQa?=
 =?us-ascii?Q?9N6YgBkEjgX8hxKRAC78SANupvc3wd34ve19IVGPnldMPwi2yJJDM6Dn2tI9?=
 =?us-ascii?Q?UFNsLOpPRFkxBwKi7Chm7QFXNYnWfpbdON/9d0DcTMLekV+1hcZxR7m8pSdl?=
 =?us-ascii?Q?8KmlJffTkKTPsQI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 05:23:22.3928
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db3a8389-e862-411c-da61-08dd6513d5ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFD4454CAA9

The hypervisor controls TSC value calculations for the guest. A malicious
hypervisor can prevent the guest from progressing. The Secure TSC feature for
SEV-SNP allows guests to securely use the RDTSC and RDTSCP instructions. This
ensures the guest has a consistent view of time and prevents a malicious
hypervisor from manipulating time, such as making it appear to move backward or
advance too quickly. For more details, refer to the "Secure Nested Paging
(SEV-SNP)" section, subsection "Secure TSC" in APM Volume 2.

This patch set is also available at:

  https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest

and is based on kvm/queue

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
v5:
* Rebased on top of kvm/queue that includes protected TSC patches
  https://lore.kernel.org/kvm/20250314183422.2990277-1-pbonzini@redhat.com/
* Dropped patch 4/5 as it is not required after protected TSC patches
* Set guest_tsc_protected when Secure TSC is enabled (Paolo)
* Collect Reviewed-by from Tom
* Base the desired_tsc_freq on KVM's ABI (Sean)

v4: https://lore.kernel.org/kvm/20250310063938.13790-1-nikunj@amd.com/
* Rebased on top of latest kvm-x86/next
* Collect Reviewed-by from Tom
* Use "KVM: SVM" instead of "crypto: ccp" (Tom)
* Clear the intercept in sev_es_init_vmcb() (Tom)
* Differentiate between guest and host MSR_IA32_TSC writes (Tom)

Ketan Chaturvedi (1):
  KVM: SVM: Enable Secure TSC for SNP guests

Nikunj A Dadhania (3):
  x86/cpufeatures: Add SNP Secure TSC
  KVM: SVM: Add missing member in SNP_LAUNCH_START command structure
  KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC enabled guests

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/include/uapi/asm/kvm.h    |  3 ++-
 arch/x86/kvm/svm/sev.c             | 17 +++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  1 +
 arch/x86/kvm/svm/svm.h             | 11 ++++++++++-
 include/linux/psp-sev.h            |  2 ++
 7 files changed, 34 insertions(+), 2 deletions(-)


base-commit: 9f443c33263385cbb8565ab58db3f7983e769bed
-- 
2.43.0



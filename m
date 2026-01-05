Return-Path: <kvm+bounces-67006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 28B6BCF2172
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 07:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 740C6301FC3A
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 06:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 904052701DA;
	Mon,  5 Jan 2026 06:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jnq4F8+f"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011022.outbound.protection.outlook.com [40.93.194.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E63261573
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 06:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767595090; cv=fail; b=MrRNifUsmL/TrW0EBgrBKzK3xN/UyvdN/kf1+2yhzNZNGsmyxHrOd6p7M4lohxg/eVgA3PTwVmVE9TUrAkfW4JHGa2d3waFtkoHYsBchs4nWYA8AsGt17bv0I03DNGlrsEGkbDwR3fUo3wpedCfqeUqaBffPojiYKTTrvD1lKVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767595090; c=relaxed/simple;
	bh=hLsUJe1+l5OuY0phON/DS4MSlufHRPgPBFwUGNRcQ1s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CDHt4RT4F6s2KmKBAa7Clg9IoyXWVCFNWqCEzD3ZJXwUqld0T7a2cRRJD0HoEiwxrZsldkMRQZ93QOFp3r6brRTdnFasjmDqShZmRnLSojOuwzsoxnlGUGdiw0PhOxsrXNHXe5zEbIHGLZ32pMsJPYqyz+BjT2Iei5+ZK8ioisE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jnq4F8+f; arc=fail smtp.client-ip=40.93.194.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vo6F3ISzGJGIe5xT47Lz85JXNgO+zaSw/V4IW1eyI0QCRpJ+ArKkOKwC8V/oDwSIB4kvcqrUJzFphOEjzCbaKBGtPwtOSCo3pG/rGnMZLqn9gY1JTjSpoqEa8F/cET3N2CF7adsZuJbp4nDSsiGYAwlCzFTnf0OSILrz8fl7gm6+el91Ir7X//Iq5hsRBB6UuoPAVXWiZXwWtbaepT3M4QkNlMawh74FAtgLeOumCWcYabgQ2DnKxAG0ycTQNjpqfueDUMw4k5xyIg1bS6VMrCp4VTPeVu7bw6m5n5vkpNAwjMQbQOUSF2KF6lkSmUszxt/wh0IWn42YKSAqkyURHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tuv4CcJIXdNPj0KIchyl1hZ1XhDSt9MLWy4oUPGFxP8=;
 b=Im3DQNQFatJX8MMz60Zoz7ymmzNTi5UkwmsNx7QYt6pCKc8sZuKamKy1+Lj2c+1EYuAnS1mj4u1QiZ9jau7kUUaxm+Y+5Kgji0QbnxPj7BnmmUhPuf8GYZT/0rBXakDxQkxkJjbS3sFGuwal99zx/QYeY4BXEJdnpJb+dWJzIcS9arjl6WxY/Vkkr0h1SnNc11txFf1czOJlKR4gfoUY3YB1f20lWJRur29c9ZOAVF6HAciOWzq8Vh+ihekr+20Dej8ILAD3JEF3fRNV20GBl9+5UcLYUk4r4rZA5hxnbUU/LTIPT9HBu2zYvF2RAHxKuxIdw5QBhY0+J9JzX+67VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tuv4CcJIXdNPj0KIchyl1hZ1XhDSt9MLWy4oUPGFxP8=;
 b=jnq4F8+fzMUnycIKZL7Jk4qFYENSTiTVGH/KzYOjoN0017TqVHxmtSIBxnXakkxNp1LVrsTAoyTfWjU44TtFzndeDvTPFu0+VSPcI+YUDftcjYJX1akmXJg6Ix0omJqOcnQKuCcdGdZb0MoyjDKYVgFZwvf7rFSxi2RSguKreDw=
Received: from DS7P220CA0028.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:223::17) by
 DS7PR12MB5912.namprd12.prod.outlook.com (2603:10b6:8:7d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Mon, 5 Jan 2026 06:36:53 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:8:223:cafe::23) by DS7P220CA0028.outlook.office365.com
 (2603:10b6:8:223::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Mon, 5
 Jan 2026 06:36:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Mon, 5 Jan 2026 06:36:53 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 5 Jan
 2026 00:36:50 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v5 0/8] KVM: SVM: Add Page Modification Logging (PML) support
Date: Mon, 5 Jan 2026 06:36:14 +0000
Message-ID: <20260105063622.894410-1-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|DS7PR12MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: 1986a268-55e0-43cd-0f47-08de4c24d092
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RN/m3S9cW5XeWJajae1QlTltiuPBpUwKQ97uQ9JYAaXhUavxhQgQVYDrZJVH?=
 =?us-ascii?Q?b8Wti4orWEPASqBOv6pLkPYdmgmio++i27VVjhgu6KHWycUZF2oRJdZ13mNP?=
 =?us-ascii?Q?j3sYp1QFiFmGx+IV2XynrRmV47cngbLGnedgZYh9ss80W+DTD1/mc/SBl0mM?=
 =?us-ascii?Q?vPl+kT6qfIzvOMBId+KxuiAkTp6rWEoDUSIIOGMeqa1sw47hEyjuSFxUG2yH?=
 =?us-ascii?Q?1xzsnpQilQt2Dlp8qBNGaaPEzQqt0WLsJL9NETD65CMjaxxWEtFxrfnPjhEq?=
 =?us-ascii?Q?5wyWn+/Nk8kp0ZPX0cCzseKumW45v76JLeIXJSIV49x/JT8SaGRj1yy6f2CY?=
 =?us-ascii?Q?IEynl13wfRAKhOiIdhTaGwnAnVDMleRuDwwidF49P7stAvbhSwkgxiGVuWNi?=
 =?us-ascii?Q?76uyWvMU9EcN+jo3jMqRtOeK4N9je1q5j1Xy7PKtYRd3xajHMdBGeQraBoRa?=
 =?us-ascii?Q?w9n4erTKY6RE2bO0XZZPTIIoSI/U66fjnHq58hFJf47331EC2FBHeAmL60Zu?=
 =?us-ascii?Q?lktPi6DBr2FejSRCNDCC+ABJJFWWN5P9RyjNV8c4UHx42B0lIkElB3YmmOK2?=
 =?us-ascii?Q?iWePUQfzAQZ1UU8YXAmQhCI0uNJ8pGvPlrJ/LcdXeV9ytsWpCQ3Is8znUyHX?=
 =?us-ascii?Q?UEWCL/ayEAdroTU2nE87xBMxSCPSKQVMRpsoemN6pHVDEcX2QMBAExl7K6d3?=
 =?us-ascii?Q?BqMuDAkDiFeTeugfXi9JFrtULRE40mX3jI6QAVu1EQQLrEgQunqa6uySSh4U?=
 =?us-ascii?Q?IpBzgc5lvRkiH1s0canDDnr7xw339mvmJOtaAqCciAAbyyHizTQZmXarxVg5?=
 =?us-ascii?Q?y7sfDCiCKiTSN+WhmE7Jg2Xk1eH1fuCvkQtn5are9nxry4BopeOB7FAQPgYI?=
 =?us-ascii?Q?p3q1R21FGkLv2+lTqq3uAZ60LvlOKulyyCtgLvXwUrMBw1WE+KfP/osmntHa?=
 =?us-ascii?Q?JxnVeilcQ52xpcjDWzDVGP6VVpOsxXxXYRny/FGCjTpd/otzBvBHmQ3zdSoL?=
 =?us-ascii?Q?YcZUY4IkXfNzfQ/FTpr3MEjB0ITRAHVw77PNmFvwVFSow83PTS//YbJO8uxX?=
 =?us-ascii?Q?bW2BWAisRk0m+5nOETWSb+cl+Wq5VBUZU1w2rFi14pWBd/EnregQQf1URvIM?=
 =?us-ascii?Q?yfuqvMQwhwZV6V+9qnrO73jcA1TX7Dwb1IROYxSAyUk2TfX6dXx395Tq+6po?=
 =?us-ascii?Q?C0PRWLc1S+qgFa63vr+d+Et4J10AnVebMC++aCp4kavkT916Py2HLX0GHdOi?=
 =?us-ascii?Q?oyvnU200HHRMB0Cxegj8g5XBZz8G1bKE5HJ5Rhlg6XGA7YcMHSPDEcZKJOrl?=
 =?us-ascii?Q?ZGHfoLgvZFFnsUEdhrZ+IMZ8AZj0X+CHhETnCwMUrMc6MDrZJrkgdTS+viB4?=
 =?us-ascii?Q?By6HIoxXyzaRhz9OYenFzvgMJu40TsNBqTzDq4gPkRhdhbdYHViH+RnhyDsn?=
 =?us-ascii?Q?p+B1PI8l4o0Y8ZR5hmDQrgtl5r2nHJtudJqA946YFhOmoqiuHoU2DLuyIxvH?=
 =?us-ascii?Q?60DfPMj6sgrYRW63XSbk2FWVAR9ph2uCmUW44MiaRedgpOGByozxuN3VeuC2?=
 =?us-ascii?Q?mLP+g4lLykxgGdEvTJNmHpigYFzRuzUe8guZ3lgl?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 06:36:53.4152
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1986a268-55e0-43cd-0f47-08de4c24d092
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5912

This series implements Page Modification Logging (PML) for guests, bringing
hardware-assisted dirty logging support. PML is designed to track guest
modified memory pages. PML enables the hypervisor to identify which pages in a
guest's memory have been modified since the last checkpoint or during live
migration.

The PML feature uses two new VMCB fields (PML_ADDR and PML_INDEX) and
generates a VMEXIT when the 4KB log buffer becomes full.

The feature is enabled by default when hardware support is detected and
can be disabled via the 'pml' module parameter.

Changelog:
v5:
* Rebased on latest kvm/next
* Use EXPORT_SYMBOL_FOR_KVM_INTERNAL (Kai Huang)
* Use cpu_dirty_log_size instead of enable_pml for PML checks, with this patch
  moving enable_pml to common code is not needed (Kai Huang)
* Added SEV PML self test

v4: https://lore.kernel.org/kvm/20251013062515.3712430-1-nikunj@amd.com/
* Add couple of patches to enable_pml and nested CPU dirty logging to
  common code (Kai Huang)
* Rebased to latest kvm/next

v3: https://lore.kernel.org/kvm/20250925101052.1868431-1-nikunj@amd.com/
* Update comments with nested details (Kai Huang)
* Added nested.update_vmcb01_cpu_dirty_logging to update L1 PML (Kai Huang)
* Added patch to use BIT_ULL() instead of BIT() for 64-bit nested_ctl

v2: https://lore.kernel.org/kvm/20250915085938.639049-1-nikunj@amd.com/
* Rebased on latest kvm/next
* Added patch to move pml_pg field from struct vcpu_vmx to struct kvm_vcpu_arch
  to share the PML page. (Kai Huang)
* Dropped the SNP safe allocation optimization patch, will submit it separately.
* Update commit message adding explicit mention that AMD PML follows VMX behavior
  (Kai Huang)
* Updated SNP erratum comment to include PML buffer alongside VMCB, VMSA, and
  AVIC pages. (Kai Huang)

RFC: https://lore.kernel.org/kvm/20250825152009.3512-1-nikunj@amd.com/

Kai Huang (1):
  KVM: x86: Move nested CPU dirty logging logic to common code

Nikunj A Dadhania (7):
  KVM: x86: Carve out PML flush routine
  KVM: x86: Move PML page to common vcpu arch structure
  KVM: VMX: Use cpu_dirty_log_size instead of enable_pml for PML checks
  x86/cpufeatures: Add Page modification logging
  KVM: SVM: Use BIT_ULL for 64-bit nested_ctl bit definitions
  KVM: SVM: Add Page modification logging support
  selftests: KVM: x86: Add SEV PML dirty logging test

 arch/x86/include/asm/cpufeatures.h            |   1 +
 arch/x86/include/asm/kvm_host.h               |   5 +-
 arch/x86/include/asm/svm.h                    |  12 +-
 arch/x86/include/uapi/asm/svm.h               |   2 +
 arch/x86/kernel/cpu/scattered.c               |   1 +
 arch/x86/kvm/kvm_cache_regs.h                 |   7 +
 arch/x86/kvm/svm/nested.c                     |   9 +-
 arch/x86/kvm/svm/sev.c                        |   2 +-
 arch/x86/kvm/svm/svm.c                        |  85 +++++++-
 arch/x86/kvm/svm/svm.h                        |   3 +
 arch/x86/kvm/vmx/main.c                       |   4 +-
 arch/x86/kvm/vmx/nested.c                     |   5 -
 arch/x86/kvm/vmx/vmx.c                        |  71 ++----
 arch/x86/kvm/vmx/vmx.h                        |  10 +-
 arch/x86/kvm/vmx/x86_ops.h                    |   2 +-
 arch/x86/kvm/x86.c                            |  53 ++++-
 arch/x86/kvm/x86.h                            |   8 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/include/x86/sev.h |   4 +
 tools/testing/selftests/kvm/lib/x86/sev.c     |  18 +-
 .../testing/selftests/kvm/x86/sev_pml_test.c  | 203 ++++++++++++++++++
 21 files changed, 422 insertions(+), 84 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/sev_pml_test.c


base-commit: 0499add8efd72456514c6218c062911ccc922a99
-- 
2.48.1



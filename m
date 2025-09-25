Return-Path: <kvm+bounces-58721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A405B9E941
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:11:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 489FA38240C
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3059F2EA475;
	Thu, 25 Sep 2025 10:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CCN6N5RT"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012028.outbound.protection.outlook.com [40.107.200.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80112EA165
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758795079; cv=fail; b=Ga5Q48hDgi9ivYPIXjnVCwHnzpaJY9mE28xz2FeuYK9xHLe+YugEa5w/UCxQbqef5MdeYQX/jHYWYYEXOI9c2cj95cUD14jIEp2R7eF6ZEXNLs67Ou5U5pclKRGv5dNbp+Wr5w1FinD4fLi5QTb9Zx93bn3AQD9hvU4cEfzwxcA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758795079; c=relaxed/simple;
	bh=wYQgVd7BPBeKD2iwm1m5YXscF2P9BDzNin7urjxNM+o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YUYu/XmjOsflP7YnnKQMvharxBr82Y3sGEG4gu3ieVXYVi2hV3ex4R4DI0zGtBkno8iuIxQ97BSiMAYoSFvJZaVOR5tpo4ZUD430G9TzsQnZQ+t2mH6XeFu48uH83TVRfmkKoO7jnkKvPluuYQYOzsexcLCWb7xcvT6wWyGkVac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CCN6N5RT; arc=fail smtp.client-ip=40.107.200.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dxPgxqvXKHptt5wDJMsSumuvVyugsg7lzpdtQS12CmLrXkHelBhY7KxoUq+U8gdwknlQSfr/d+QzStL0n4TFzF0GxBwlQByJc6DuS8ObBWW/D4VieK7km7vbbHclJdDuyE+zh1q0TYGCoFE3oKRm2XPM+4dbiwzd1sZcbUaKIi0Pq0SdGXYjDjwO7faCavj4JOQkGtgnkbH7ruTbyTuztOBLLf7CvdNHNTc5HRJu+o1qWZjjK4pTaotVu8mKHK6X801z1NBMLvq6mbKPlwQTYIeCRodDfH4LEU4Cg9gPcJwwvnx8XeWsJYjNy7au/CmNYKzpqTqfexMA/TvV4/6zsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gm3BPqd5sYjublMLbPqD4BbuwIo0Z2ngFyzGSXPos5I=;
 b=GXHNohguV1ypBYW9as7ZDkMJNGB53Q7yfRQLOARolEq8u3JdLNoEojeNzWS13VNXfPYOXPYtaK+VWVzL7wFlD/bqF5DlYEwR4G6Cu2aJk8HG4BVzC2ikEnLvjEU67FgiR1EJjMkRqvzUa0ZfqmWtNehLzA9IVv9UGADKanJf7F4O1eUmZUh+fepigvIrR+bzlyhuGqx74F44Mh/Zmx7TfKIFEXlPwoiiTFz4JTIg8dLsdsg0vf69/6xH0kVSKCEs6C99rXnB2hAAq0XgXSSptQSYCsHPuHvSXLDDo3nSVYUxKYMmgXtvcWkGu2v4V/MPjPvB0vhpzO67Wr/U+R2c2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gm3BPqd5sYjublMLbPqD4BbuwIo0Z2ngFyzGSXPos5I=;
 b=CCN6N5RTQmJYv3f1bMGZEZ9Swu+QFdSu/3JmrAS9Uo43XPWvOobxMpIONgFIK7/Fbt4lZBPhZ/FraiJLgkZ9oDdqFP3NUYUgoKjp28XGdYlGbubY8Wr8ciAjTJeaR3UDncLvdtB0uHaplubWnoJPUiTHj9K5G58IbxSQoDq84CU=
Received: from CH5PR05CA0024.namprd05.prod.outlook.com (2603:10b6:610:1f0::29)
 by DS0PR12MB7629.namprd12.prod.outlook.com (2603:10b6:8:13e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Thu, 25 Sep
 2025 10:11:10 +0000
Received: from CH1PEPF0000A34B.namprd04.prod.outlook.com
 (2603:10b6:610:1f0:cafe::a7) by CH5PR05CA0024.outlook.office365.com
 (2603:10b6:610:1f0::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.4 via Frontend Transport; Thu,
 25 Sep 2025 10:11:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000A34B.mail.protection.outlook.com (10.167.244.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Thu, 25 Sep 2025 10:11:10 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 25 Sep
 2025 03:11:07 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v3 0/5] KVM: SVM: Add Page Modification Logging (PML) support
Date: Thu, 25 Sep 2025 10:10:47 +0000
Message-ID: <20250925101052.1868431-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34B:EE_|DS0PR12MB7629:EE_
X-MS-Office365-Filtering-Correlation-Id: 122547d7-2866-434d-b595-08ddfc1bd9ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eTs5LrrmdeQl7gMw+ekOdWgbFVb+3hYZwqKhv7Ae9V7+7kH8xnE1WCoZFDlO?=
 =?us-ascii?Q?x27YeajI15aR9cYqhvGI5kta3xGyTK6Yf3thWcvH2m+5S8qpmkT5grS+t2F9?=
 =?us-ascii?Q?kD4l4RYNbTW/uns72YllNEmpqhpHnEfL8zk6BFaJ4VNwEDhJNxzsW67vSBk0?=
 =?us-ascii?Q?S3BMw6GSZP1V9V+CVM131Jh7ZI/nGS7wxYBk83bJtqfu6uJOR2VDRadR8usk?=
 =?us-ascii?Q?vB8E83iANLxj6eaKkWuoWnA/NoJONoeEyWjbvcljnfciEGTjtn1vZCxkEubn?=
 =?us-ascii?Q?uXLjovEO0XDBsi3P/53R72dE+RPwkplMBVtNRJWB477I6QS1YP2T+Mjy0SAL?=
 =?us-ascii?Q?ZaUE1xzSQ+ZDBm5v5GBNjijPMUpE2xEWa5Upv2qUfnNKqT+2CWR3j04hoMU3?=
 =?us-ascii?Q?gT+BB4CnAqWejQc1P236fn8s6So4GcFdDNSKb5CJpzLI6LsAlnUe48RL8cKe?=
 =?us-ascii?Q?rJPWFyXSa4yzyY00D02AL/v5x1RPk3DgZZRWavOCg22CFX6wN8yaUirCaBEQ?=
 =?us-ascii?Q?GYpTlbEyVw/gbpfwfhLgOgnZ4w7kKLGou80URMlgavMgd+2CFmq6mJmeMrqb?=
 =?us-ascii?Q?8f0g8kGS83kHxuEUFZ6uUNkvlUqfgwGMncdk2H1xNrF+ElfBAehCE6/v+Lth?=
 =?us-ascii?Q?7zYTRrshVIlJA+aXs+ktj3hjsf2oHvjDtRbbHAAfrdTKpEepThH1chV71ls+?=
 =?us-ascii?Q?Zg6PYnqEqzZrDDkZpWBNX2YkGMdAlcJ0b5VG6IurB0y20NuQd0ejvlovb6zt?=
 =?us-ascii?Q?xtLDUJF7t/ztzuMsy0ecR7qTREil1PINjxqX9STMa3ZvV4KE179LNYzbiOum?=
 =?us-ascii?Q?aoJ0U9v95sNabvrpZpzPhHiJrmP03z0copT5wV/WMheY/EWrjvqaGE8KojOC?=
 =?us-ascii?Q?CVi3UOk583SeplxhgvVbdLAO3OcslNKQ8SRnHn+VocCHlbZFHsydzUqb0VPH?=
 =?us-ascii?Q?vUXwxqWbEptc5TNEecK4Pb6+kOGvZ3nbsI0z0A6O0sGroJtcGUtnomvvWADA?=
 =?us-ascii?Q?pBLOL0kuatMFiupINDkxS//Tztuf/ZGc4QsP7a6ok8fJ3/SdujAuqXlrYBdY?=
 =?us-ascii?Q?/lbm1Lfi6xhhXynol6PnFqlFhgM1UGvjKzf21Q5S+dZeMEOpDUxrJA2QVtk5?=
 =?us-ascii?Q?P7Q4AUOFADL3SNSvMhRrwDrDV98b+ly0U/VSL9eSDN66Di5IBIpIjD/u6iVg?=
 =?us-ascii?Q?yv27EJdXwjk1gyBLIaPelsW6lqk5xSLeUmH3UpwDsnR1gZV4mLOC4yWRZ948?=
 =?us-ascii?Q?VhoE/22BEqtbUTq32tcQTX9NG7qIsX1pWOsy6xZGIalyxMpgzsTQdHRSlHo3?=
 =?us-ascii?Q?CbUHoF3zb5C9ojhCDgY+fWSz54Zr1ATfO3oWkYYfai8EvR4yD8WYLWQ77ows?=
 =?us-ascii?Q?05bgUnADz2vVt/T4YjUvKAw5iAy7U8kUx53kz29yv7IpDlHmSqc/kR6U33GL?=
 =?us-ascii?Q?gbhlVIwBw9qxJDWLi/nVgx1cgnWfhcN8ZkyEboUXzegJkDzhSUCI7OCsX0cg?=
 =?us-ascii?Q?k3JKktRlklyZnAo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 10:11:10.2370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 122547d7-2866-434d-b595-08ddfc1bd9ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7629

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
v3:
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


Nikunj A Dadhania (5):
  KVM: x86: Carve out PML flush routine
  KVM: x86: Move PML page to common vcpu arch structure
  x86/cpufeatures: Add Page modification logging
  KVM: SVM: Use BIT_ULL for 64-bit nested_ctl bit definitions
  KVM: SVM: Add Page modification logging support

 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   2 +
 arch/x86/include/asm/svm.h         |  12 ++--
 arch/x86/include/uapi/asm/svm.h    |   2 +
 arch/x86/kernel/cpu/scattered.c    |   1 +
 arch/x86/kvm/svm/nested.c          |  13 +++-
 arch/x86/kvm/svm/sev.c             |   2 +-
 arch/x86/kvm/svm/svm.c             | 100 ++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h             |   5 ++
 arch/x86/kvm/vmx/vmx.c             |  48 ++++----------
 arch/x86/kvm/vmx/vmx.h             |   7 --
 arch/x86/kvm/x86.c                 |  31 +++++++++
 arch/x86/kvm/x86.h                 |   7 ++
 13 files changed, 179 insertions(+), 52 deletions(-)


base-commit: a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
-- 
2.48.1



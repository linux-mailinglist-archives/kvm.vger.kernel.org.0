Return-Path: <kvm+bounces-53891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC5F6B19FC9
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9598C167D7D
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 10:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4DFC24BC0A;
	Mon,  4 Aug 2025 10:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3CMUiUWr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A7015DBC1
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 10:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754303905; cv=fail; b=WhFElFBOio0FkPboUUeQxTPBgDWaP4wiOF66VKJL7sUAMOJQ0A+QffNUnYKf80SQV9DVek22S+w8GM4BSXtqS+WEBGg986K/QjKfR5S/YWtf6RfFA1PgrluyOlxWS5W9fmq5QY2VbicDLa/81WWiljfIaxOESs00SKAT+ItzLdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754303905; c=relaxed/simple;
	bh=OHDKSVH3nJowUfk3etksrRLhyRQQiNzyc01eXcj8yR8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EZ0bcKrrfaS3pJqlNDGbaHqm+IQ71kieEJxJmWlyPoHzWGVO7eGyZ1tHdqCP+s/RIWp1Ig8M82mu2A0AMrnb13UZFzoN9RvL3S/JzmivexvveH0h/OLPlin8KdKq5J1FPWzPwfKBzLauovAAyCeXq044J1zkMHVRVmUaHUevE+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3CMUiUWr; arc=fail smtp.client-ip=40.107.92.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WVr0sIs/tHDBbOyvUT7aW8P8PkFZl51lAJRJu9pba9iPYLWUOHePdry4RZ+mHZsoSMmy34507O+aoE9deIv6fnIYEW/nAvI3uJwLH+9buYxJUd7q0oxIqIMgwIbgXpaERIF+XZIIREtLDuDdkqHb3K8dRrvvMVPs1FtbF+t0M+uQEC5Ft/y4GGNxT526x9CjKRiOPJVP3uhy7xrvvpJO3llN2/QWgL/nZ9GB521Cg1yZN+WOtPLv6f/gQvYU/OVFv+Oe5gsxihpn3HEkq3UQQJTBiY13DwyG4EfSYjzE9G4EZOjmda47xY6CBroVXpgRi9S+KEAFeDLU0bmjrx/ZRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xCapequEP3azVt1+Mr/Egtf21HNDt7CWZIh3I/6PNBE=;
 b=HX12Ta4cy656ibVZmxxJu1NfjJmmZzWPcGZbVaKmNBUKIb95p9SEt+ViBkGcyHDrZeAUBr2KWB75NCBIkX/HAGuR8fe/Jg622cgB/JK7HsxtsKc7Vix+mWmQ8ObwXaYsIf4UX035dpcYj8UV4SA9KOS5V2BMCmQwAUP6A68pWV0WUz9CEq7BhBuheYOD95qWAjJoG3ZHdZ7QdwbEPobtdKpfFhKh/ifSqAWRZZHHn+hSA8TZRcXNsea0YHNhme7hjoG9czc/Is5Gh0gABA5DS8kEFLO9jZVfoBhWIu3vUOJMXlfiYRJ/LKpT3bKaHTVITO/QGo3blygkKMGby45p6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCapequEP3azVt1+Mr/Egtf21HNDt7CWZIh3I/6PNBE=;
 b=3CMUiUWrhQjzJjKuzyUriyo0xIbu4Z7GQ6ukiu80PJ5GpFRrsumfWI5z4JmxFt4AhvAXQeUTbai4TOs/Z8jXRatHcplHIrkXmEue9yvgrEL++GCt8sLPkvpsRkme65Xf+lA51j4GW3QHOoRQqSRIjxQZSa+HKikq4Q/gt71BA24=
Received: from BLAPR03CA0151.namprd03.prod.outlook.com (2603:10b6:208:32f::15)
 by SN7PR12MB8772.namprd12.prod.outlook.com (2603:10b6:806:341::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 10:38:20 +0000
Received: from BL6PEPF00022572.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::27) by BLAPR03CA0151.outlook.office365.com
 (2603:10b6:208:32f::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.21 via Frontend Transport; Mon,
 4 Aug 2025 10:38:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF00022572.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Mon, 4 Aug 2025 10:38:19 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 4 Aug
 2025 05:38:15 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>,
	<kai.huang@intel.com>
Subject: [PATCH v10 0/2] Enable Secure TSC for SEV-SNP 
Date: Mon, 4 Aug 2025 16:07:49 +0530
Message-ID: <20250804103751.7760-1-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022572:EE_|SN7PR12MB8772:EE_
X-MS-Office365-Filtering-Correlation-Id: 32e58bd1-2bba-47f9-18df-08ddd3430707
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1H5JUfhCMETipajuQMWmlXV2YhGY+w05ThcscgccdHpjAIZ/dnLG8om8qwhQ?=
 =?us-ascii?Q?bYsiOx5SuM9zgtsuvKHsP1p9UXGXVj6MzRlZKoLI8DMSlO8aDxGdYPymufEG?=
 =?us-ascii?Q?SvLB2lEBE9r4Nk34dFAcWCBAmmyhaTE6uocUiC75AnP0xPrqxjHpXd+zJ1Lh?=
 =?us-ascii?Q?FC+SXpBWmeZXWIok5vJT3UmwrHT0qRC42MH0dbwm+nAaq/+TyK46bMoD7JXZ?=
 =?us-ascii?Q?fZttfEO8XUYx3OOpr2VE2Aj+i6Y1whGXRMcpEmPl9FiehgRmqfVpXiMJsqR7?=
 =?us-ascii?Q?T3AtvPsWPidyfxiPS7YfQIiBd1RiV2GaeVBeP17RneFkElSXEQA9gdwqKCZ+?=
 =?us-ascii?Q?uBzUfd7oUSUvvM8te0WyltGAHMoxNlxlMWb9rDEG6ngMukYn1n4uI4BlEXt4?=
 =?us-ascii?Q?jmj7OrsUzI3FF10CTvFmCJHkihz58p4IMxerYn40m/Li7IWSBFiAdDw/SM2w?=
 =?us-ascii?Q?hM2rDdCMpSba6iclLbj7KhgtzpQ0wYysRjvanEBkUBAVvKMsu3vdthE6Ketd?=
 =?us-ascii?Q?Xsj+AbwNi8jAXdmvVF0QmvPgv39WwwgGmLDGC2TwbojqGOIRRAMc0qHjtkT7?=
 =?us-ascii?Q?2NfWBCsajfceZeWRyF9aVfPnkuXIvAQILSZn/GeAQ/8lnos/8ezgZsAxQBp3?=
 =?us-ascii?Q?5G+mwIulesZEPWYjwl915uk2XpyXyUDUy6yS9MeQB/mdHyvletSV14KVPBW0?=
 =?us-ascii?Q?zlJA7sq7UbjyXTUZEIE0NEhKtkxtNnM0/dO7BATr6q4XCjLpxFkJkLjC0W2a?=
 =?us-ascii?Q?XZpe2LsDZHZj2tYqiHV04v7H6ofL/XmsniFQrS8xDfN/nEHGKqEGi97Ky/B+?=
 =?us-ascii?Q?nRWWNXl/JBctohVKqM/iXvvOTtZOFRbg7QbkobsSGx3WHhDxATROpg6f/VQd?=
 =?us-ascii?Q?W67A1uniUGq8mIAzSsu08hH052fMlKNo4QsLXH2KR5lmYsUwuzbZZBHf4cfQ?=
 =?us-ascii?Q?+E4Eakaf0ZJV8y+qYw9EAGmr6/uEeeJrq11YxhouQWNaMhnyg+NrCM4ip7aA?=
 =?us-ascii?Q?eVJEXeTyrXU6ylGHBjseADKSo1VfSB0MLi23Mx6P0fKmTzaHURJ0QTh/qp89?=
 =?us-ascii?Q?gI/JwSja5ZVEtKTOPlLbQukY77bgbOxe08kunMP9oREtaJ1gNZP9EuEecMQn?=
 =?us-ascii?Q?Qzd9KCIw4bjaTQUfmSzmr5nkW1v40a5edxaF+qVoJ6H+ewduBDLQbxc5CRUw?=
 =?us-ascii?Q?JaAfs5SzZ0xyMnxLBKIR99z09mXfTJ0ERuPB9x8Bp60j5cVWGNBt2qrHLXD1?=
 =?us-ascii?Q?JaxsYV1KgtCNq1GucB73SALfWo730JytFLxiZuMSSaGRdpevWGy58f1xvgir?=
 =?us-ascii?Q?K77lcaHmHlBNXIjgjYU1ZUoofLNN/54azBJi89GiFjLsBTV7+GyCbd3rfgCJ?=
 =?us-ascii?Q?jW5tHmXJz+Suij46EbcE7XTD44wsXjfUV6VBqRxSdzWCy4GQNd+ol8ZKrFvy?=
 =?us-ascii?Q?vWUgrP9l4+SVITK2I+eSNvxH2ElQXBhcx73+VoU38y52v9iQyhVEkvl7VrjP?=
 =?us-ascii?Q?Iw7qpwoyJl0SB//cD6OXxy6M2SIlroo767/Sl/qUewfHqbvaOW6ATa8y4Q?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 10:38:19.0218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32e58bd1-2bba-47f9-18df-08ddd3430707
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022572.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8772

Patches are based on kvm/next with [1] applied

Testing Secure TSC
------------------

Secure TSC guest patches are available as part of v6.14.

QEMU changes:
https://github.com/AMDESE/qemu/tree/snp-securetsc-latest

QEMU command line SEV-SNP with Secure TSC:

  qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
    -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on,stsc-freq=2000000000 \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    ...

Changelog:
----------
v10:
* Rebased on kvm/next
* Collect RB from Kai Huang

v9: https://lore.kernel.org/kvm/20250716060836.2231613-1-nikunj@amd.com/
* Set guest_tsc_protected during guest vCPU creation (Kai Huang)
* Improve error handling (Kai Huang)
* Disable MSR_AMD64_GUEST_TSC_FREQ write interception (Sean)


1. https://lore.kernel.org/kvm/20250804090945.267199-1-nikunj@amd.com/

Nikunj A Dadhania (2):
  x86/cpufeatures: Add SNP Secure TSC
  KVM: SVM: Enable Secure TSC for SNP guests

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/kvm/svm/sev.c             | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  2 ++
 arch/x86/kvm/svm/svm.h             |  2 ++
 5 files changed, 33 insertions(+)


base-commit: 196d9e72c4b0bd68b74a4ec7f52d248f37d0f030
prerequisite-patch-id: 97788f545096df9ccc70cc99571d545fe4503f01
prerequisite-patch-id: 7a0edf8fa18231f19c781b4d412df4bafcb3d1ae
-- 
2.43.0



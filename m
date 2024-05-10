Return-Path: <kvm+bounces-17213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D56B8C2BA3
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:17:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53A86283F0E
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FAE313BAFB;
	Fri, 10 May 2024 21:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N7LUcOCX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ECD13B789;
	Fri, 10 May 2024 21:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715375852; cv=fail; b=fP9gPp+R8vc/d+WdgIEJQuydQZtbrjRRpghc7eY27IQcigp01vx83mR9M8TfeGFTVsACNAnbgoIQE80VzCSHHqKE5xX10+JDFCiarrbSBQDDkkvFAZPxPmPRskPpvVf1Emjnq4Ix5kNilF8B/U1qVhqtAgiCDrPzf4E76cOyxTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715375852; c=relaxed/simple;
	bh=SdxzBk3RSKT8Xyr1I4upt1yb/lQy+sKt+rrkfaA+Mj4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aXM8tbiPwMh4hKA4iyCzFnQlXIwDd/kqqKHDi3rgQxbeJYVxFl/GNrPfM1Zc9VZUdvP+3co35vr64orIYVQrBv260y3s899Rt0pvw5gX5CbRBU8xRobsAEYbzaKAe8VqzHpEzgi/WUD8Wyu6slsB0DDWAzuDQL1AJtuvOsHZFmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N7LUcOCX; arc=fail smtp.client-ip=40.107.236.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2rPu+9GqWSniPBphcn01u1c1DFKgwXY6ctADXryEGngTM2AqIRmmKn7is51Wst7oYrUZy0aCFY6l2NM+jjJcGnsSKTvPAKK6vFEHpRO+vB/pIzKqKKGLK4PraKQbqfDd7c+jhZOFwDtxSa0BDEDMZtqlpAdTB41GyEiPyMi0G6ubDmgFylBVy0lFeFhblMFbrMJDhT4vWMebC8p63IVziRAfSqHHYsd6trgvH7NTRyWJOGQLrlc8tpHKn0wX2rUZLAkbBm9gDAbmSGE+VZefZVvhxfTmkJ1CQXlwTTfyDmi4Wi/yccxRYFUO3QoF7rlOZ5IfOm/l8nNdWIp/NJEUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFOgtx+8wInZQOhGHCpVFujiDx2uDMkuyEfJfrAM41A=;
 b=E81UsNg92N7rU0aLqNtZYW4NRZscTkp+oLybX7iH+0ji4iAdCu52M3llZGrhS6Gby1qkYFJ1FFposjOWUCqruM7mpO2pezQKtRV4IHWrqdK+HPoNnhsQ+efsXVTBkVqanVugn5EAD/Zpbsa8SC7yQHTiZcmi1ylN8H7lXVSmYc70a90Cl6uJwfi2NkAbefGU3HpAPihm3+eB9y/zvF4FV1xV8wlXqhE6n30t+cehuVjh/frvDjyzJ8AkHOFbBcngI2Kq792oSvBg+3IXJdfDXtOWTglOlENjSc55N1SPUmtNurXRJZRGuT3mqJ9PluYihMpmd9vPJEV+3A25xoOF6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFOgtx+8wInZQOhGHCpVFujiDx2uDMkuyEfJfrAM41A=;
 b=N7LUcOCXbrgri0zpwT6WGXUQl+kgqYBNFnNjv/EI3Ex+mkz+mIPDW6IpoiDuNMf6Xo23zyowPmrrPzqMNZ45h+tuAeKw4MIZdOEr6FQVeMenzzaPswVulOQ38nGYzS+Bnc7S5+Jwkp7RaCugDjML59cHZXRotjLsG3iUpSj9MSQ=
Received: from BN8PR12CA0007.namprd12.prod.outlook.com (2603:10b6:408:60::20)
 by MN2PR12MB4472.namprd12.prod.outlook.com (2603:10b6:208:267::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Fri, 10 May
 2024 21:17:24 +0000
Received: from BN1PEPF00004685.namprd03.prod.outlook.com
 (2603:10b6:408:60:cafe::22) by BN8PR12CA0007.outlook.office365.com
 (2603:10b6:408:60::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51 via Frontend
 Transport; Fri, 10 May 2024 21:17:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004685.mail.protection.outlook.com (10.167.243.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:17:24 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:17:22 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, <linux-coco@lists.linux.dev>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <vkuznets@redhat.com>, <pgonda@google.com>,
	<rientjes@google.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<alpergun@google.com>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <papaluri@amd.com>
Subject: [PULL 00/19] KVM: Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
Date: Fri, 10 May 2024 16:10:05 -0500
Message-ID: <20240510211024.556136-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004685:EE_|MN2PR12MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bab16a6-029b-43df-fb3b-08dc71369644
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|7416005|376005|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UL7QpQskN+CXHSXI2Ypg1T68V4/ePlqEQ/DYzswkdS8SoYWMQUk6JKiIb6wx?=
 =?us-ascii?Q?yC1t5HRWiesM652zay6sW5LtJxd8oq+nGUZ1LCbdQdaIDCvfGfCy00FWriNw?=
 =?us-ascii?Q?Gufah6yDHCDCpPEGRdOEU7F6ZKI4tihPuasRSw1u/er580MzyKssoewg/v4n?=
 =?us-ascii?Q?hUhuDkMDRkBoXTFzkocpQ7yhIBtIkRgK+CSbUzc3WCXRCX4tHdBKdY/BVsCg?=
 =?us-ascii?Q?98B88JGEH5F044/ctuOxnTblPmviNuW/cM84BBPQUk4Pdjg87wQSUZ2BaZ6p?=
 =?us-ascii?Q?9T4qYk3VWWnF3qP5XpuIq4/42h010pGWfjL75dZXxVTrONR8fT8c3kUm8pa3?=
 =?us-ascii?Q?GVsLY+r8oDHD+npqD+xGOL3NQt3qZjkKp0w8hu8BQoWA3lYJTzJoPV/2BXaM?=
 =?us-ascii?Q?bQwqLCNx9xaKzSNUp2HkaF5Lzv1gJ9pqRyipRxNX2drG0jvPygzSa/6uuJtv?=
 =?us-ascii?Q?+y2YHX7kUemL5p9siPOx6lNPueLChtb8N3Q8dMiLX8jXKjGeaLn1+q79V0iC?=
 =?us-ascii?Q?B9XeCgW/+F4qa59SjJflNFy2Se47kOq/NqzaaWiNwD2D4RVxDBquMK+2zAqr?=
 =?us-ascii?Q?yJ7FSbG9rhAQN3cH8Vb0eNhHFzVmdbYarRi4GzwDvrU3w2xOwL3lI5LC9Mpo?=
 =?us-ascii?Q?N9JnE787rqwtOupY/1R7sOOIZ58E44FIXXNELGOOOKciRJi5M95M5vAtut4C?=
 =?us-ascii?Q?JW8NEowkAWwGe7cwp89GZoHxnkGAQUlqF6ziWyaVVU0dvfmhZnSPyhOVqK1M?=
 =?us-ascii?Q?eg0Y0P1K5ZU6ITxZTLCctHbA0H2OeLu9o7lxBmaq1C8St9tkxpfl1JeMIvHy?=
 =?us-ascii?Q?tqz/4RobqIQAg88KkHhfIvumshSzJFlNtmD7YE081bGbybPn6BKvM/L6uEYS?=
 =?us-ascii?Q?xMMpJr5xQBLQnKxZlyLL8hC7Yj+PEeYUgZ6YOffTZqQuR01ICUTVyDbUD9id?=
 =?us-ascii?Q?LOm0JCzDh5lUbdJvYO78GjOem7hnMMQNKlh6a8hh/72Xbp2xsnL41G4hV7vB?=
 =?us-ascii?Q?9Zt/UjSiMA9wjyWlZ/7USw6YcygyA94JVlkxXUtjWQBLkaDwYrxX1N+R+18E?=
 =?us-ascii?Q?ZGArfzRC6KYrvZJ/OlqW6IcqYks9XH1ZIIJpVrlsYpvoWuaePMh3Cwpb9HNs?=
 =?us-ascii?Q?HgXGWNfQgy+raTQBPjF0EIr+JJ+sIOFIAq+nRMYX+/Up+ibx36vNPyctb88q?=
 =?us-ascii?Q?4zMLhtdms4WjcX0RB7PUY3h3In0H0tUaovyRO72ClEGOc/D4YGm59e1ndoIv?=
 =?us-ascii?Q?VIElHnbaMpfM1DSZE1/iRu4RXdbIB13GengCUsu5Oih3jvkNR8Hl4/YAvNFN?=
 =?us-ascii?Q?eIDRaiYZOVMZ+teqe/clo6w0B3j1u759tY0mYzhzouChUA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(7416005)(376005)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:17:24.2731
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bab16a6-029b-43df-fb3b-08dc71369644
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004685.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4472

Hi Paolo,

This pull request contains v15 of the KVM SNP support patchset[1] along
with fixes and feedback from you and Sean regarding PSC request processing,
fast_page_fault() handling for SNP/TDX, and avoiding uncessary
PSMASH/zapping for KVM_EXIT_MEMORY_FAULT events. It's also been rebased
on top of kvm/queue (commit 1451476151e0), and re-tested with/without
2MB gmem pages enabled.

Thanks!

-Mike

[1] https://lore.kernel.org/kvm/20240501085210.2213060-1-michael.roth@amd.com/

The following changes since commit 1451476151e08e1e83ff07ce69dd0d1d025e976e:

  Merge commit 'kvm-coco-hooks' into HEAD (2024-05-10 13:20:42 -0400)

are available in the Git repository at:

  https://github.com/mdroth/linux.git tags/tags/kvm-queue-snp

for you to fetch changes up to 4b3f0135f759bb1a54bb28d644c38a7780150eda:

  crypto: ccp: Add the SNP_VLEK_LOAD command (2024-05-10 14:44:31 -0500)

----------------------------------------------------------------
Base x86 KVM support for running SEV-SNP guests:

 - add some basic infrastructure and introduces a new KVM_X86_SNP_VM
   vm_type to handle differences versus the existing KVM_X86_SEV_VM and
   KVM_X86_SEV_ES_VM types.

 - implement the KVM API to handle the creation of a cryptographic
   launch context, encrypt/measure the initial image into guest memory,
   and finalize it before launching it.

 - implement handling for various guest-generated events such as page
   state changes, onlining of additional vCPUs, etc.

 - implement the gmem/mmu hooks needed to prepare gmem-allocated pages
   before mapping them into guest private memory ranges as well as
   cleaning them up prior to returning them to the host for use as
   normal memory. Because those cleanup hooks supplant certain
   activities like issuing WBINVDs during KVM MMU invalidations, avoid
   duplicating that work to avoid unecessary overhead.

 - add support for the servicing of guest requests to handle things like
   attestation, as well as some related host-management interfaces to
   handle updating firmware's signing key for attestation requests

----------------------------------------------------------------
Ashish Kalra (1):
      KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP

Brijesh Singh (8):
      KVM: SEV: Add initial SEV-SNP support
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
      KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
      KVM: SEV: Add support to handle RMP nested page faults
      KVM: SVM: Add module parameter to enable SEV-SNP
      KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event

Michael Roth (9):
      KVM: MMU: Disable fast path if KVM_EXIT_MEMORY_FAULT is needed
      KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
      KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
      KVM: SEV: Add support to handle Page State Change VMGEXIT
      KVM: SEV: Implement gmem hook for initializing private pages
      KVM: SEV: Implement gmem hook for invalidating private pages
      KVM: x86: Implement hook for determining max NPT mapping level
      KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
      crypto: ccp: Add the SNP_VLEK_LOAD command

Tom Lendacky (1):
      KVM: SEV: Support SEV-SNP AP Creation NAE event

 Documentation/virt/coco/sev-guest.rst              |   19 +
 Documentation/virt/kvm/api.rst                     |   87 ++
 .../virt/kvm/x86/amd-memory-encryption.rst         |  110 +-
 arch/x86/include/asm/kvm_host.h                    |    2 +
 arch/x86/include/asm/sev-common.h                  |   25 +
 arch/x86/include/asm/sev.h                         |    3 +
 arch/x86/include/asm/svm.h                         |    9 +-
 arch/x86/include/uapi/asm/kvm.h                    |   48 +
 arch/x86/kvm/Kconfig                               |    3 +
 arch/x86/kvm/mmu.h                                 |    2 -
 arch/x86/kvm/mmu/mmu.c                             |   25 +-
 arch/x86/kvm/svm/sev.c                             | 1546 +++++++++++++++++++-
 arch/x86/kvm/svm/svm.c                             |   37 +-
 arch/x86/kvm/svm/svm.h                             |   52 +
 arch/x86/kvm/trace.h                               |   31 +
 arch/x86/kvm/x86.c                                 |   17 +
 drivers/crypto/ccp/sev-dev.c                       |   36 +
 include/linux/psp-sev.h                            |    4 +-
 include/uapi/linux/kvm.h                           |   23 +
 include/uapi/linux/psp-sev.h                       |   27 +
 include/uapi/linux/sev-guest.h                     |    9 +
 virt/kvm/guest_memfd.c                             |    4 +-
 22 files changed, 2086 insertions(+), 33 deletions(-)



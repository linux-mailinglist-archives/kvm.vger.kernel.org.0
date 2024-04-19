Return-Path: <kvm+bounces-15266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE87E8AAEE3
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:58:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75CD9283B7E
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA43485951;
	Fri, 19 Apr 2024 12:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GiI+U+bv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4A98592C
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 12:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531494; cv=fail; b=HD3JvHGq/LUqHDlCwHAOb/+g/dfDCA0+F0Fv2S6TqFvZe6kF7E2dZHS4li13oeEXUIEbYEGMeub8Ux9MoYAw40xNxdiDLWNltQWSRfNrY7BzhGJTAR5EUESn7Pt76Sew5X3rp+M0Cl0Zky82RPUw+bhziTRp4CUmFvPRQNnZW+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531494; c=relaxed/simple;
	bh=czcdZvVKvaqCxmIxAnhlpGD2V6+rSZKHGCmovUFLjYM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tl8gA1zKD44wzhcq06GSaenZKThsBiQng83POMBMw58fczlpw02tfNsGKCli6qMvFHU+LT7tBMmpl0Sced4mX6lYpvXZtbwSnB0cMOITzxcIYYxDOJUHbBgvrd6mRotOicpzR6yCno4IRI1mp6Ft/qTxmGDMRytgFykaJANPebk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GiI+U+bv; arc=fail smtp.client-ip=40.107.92.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PAd7uAOsmejJYF8tQj58BTVAlgXy6YOr+U8AxCUmlhVuoMheO1kA5D80ah+J+LGwv1obA8eO4gHUvTs3vGYCgfgu7Puqzmk48oiaeWTEYbuCK1FHph8RQS+NpFwlGVXuErTR3nDcGkM4I7AZEE0DaR2pdOzqAp9DZWHJ8jBadiNe0w6iucqVDIq924XuAt321TzMIGdkx/LZnXJL+/RJNw4K4RDdly9cG8K/8U1VG7JazJYmtme+qRakUTh3LpsIz+0ErPmI4HgIHlt78/r5dw1+33dWjo/hD44We1DigVjzK13iGWUMjSQTO1dfL6ZM0FRTVlYblWoKDxcQu7wcsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7IJ+IklMoApgTBabxXfJigQN5DPJIqnnhSY1xWnmmo=;
 b=MUJLCtWpAd2NsLHcr1dYGnKg1QKFBWSPn/VgfNMBXwNfWx691OEGGMx85rYUnWzk6gcDrCbGEvOHYdGRg08kJm4xnSsWcmcvlZZGuiUy5rKyxi3XSgCDO7yEHIT68HWwNfF3iKftJ8gsfFDWmlpN+1NQTEV6r7oWnpiMlRTATzqWdAy4Fp8+QP5ZUiLg7wXSW5g2HFaa1WK0lH+matebQKklxr3nLmvmumIVpQ8qJ+iyxbKInZeLbBIKM7k8iKS5mFhKLJhZleimsSnzYkQOijlHxdFKSc5ttIdkL+wYsLW/dqBR70EEaEMUa7M0FMlSwvLNGF/lDEjCRyGPjic1cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7IJ+IklMoApgTBabxXfJigQN5DPJIqnnhSY1xWnmmo=;
 b=GiI+U+bvvr9oQ6/tNg2at0vby597qAb0qOq3pVwNMsrv5VMiSKwo3c5diN9ytOIkdLA4iXUL+zvtudlGREvYKuly/vstxZ3lHX6Nf6mAorNETGWVJu6w/K82GcMyPKk1+Nmxk6ODtiEFIBMTUL6rdYbMxnohTu/GsAUKjdxUdnU=
Received: from BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) by
 SJ0PR12MB8139.namprd12.prod.outlook.com (2603:10b6:a03:4e8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.42; Fri, 19 Apr 2024 12:58:10 +0000
Received: from SN1PEPF00036F42.namprd05.prod.outlook.com
 (2603:10b6:a02:80:cafe::12) by BYAPR01CA0016.outlook.office365.com
 (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.26 via Frontend
 Transport; Fri, 19 Apr 2024 12:58:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F42.mail.protection.outlook.com (10.167.248.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 12:58:09 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 07:58:08 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests RFC PATCH 00/13] Introduce SEV-SNP Support
Date: Fri, 19 Apr 2024 07:57:46 -0500
Message-ID: <20240419125759.242870-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F42:EE_|SJ0PR12MB8139:EE_
X-MS-Office365-Filtering-Correlation-Id: c3a81df8-ee4b-448c-6dc4-08dc60705d4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+UHe6jnrll8bOVXSe5bCfIH6b7AxoVEItvIMm/qHe2+beEy/eJ8fpoZwJRmPkPm3d28g7ZZKiml8QtW9MBic73zOHSmRA4j9zkiLwZjvXgBco07wj2tSixOH6NKvfIkmli3qchwfE+u5qIshpgHFqWK/AC6TIzbH16NJJVLWOBXrtB7E/UAqxyL+mWJszf7x+zul2gqLwBAQ8J9+XEz37I36REWkMt1+1uMSB4IRNxdU69duYNeeYkxiErszIdPuwh3GSDUu1z2MAmpdU9zL1wAo7andMPsJOQ+4kaDDbu6LsAOUWKYoEWM05EvFZgwBMjezNPjI+Gzp4MLgwa66ALwp8exIiV/WZ9DVD/j8bGc1L2u2rTBAB0P7VDI/6dko5FreOkPc4wMYJzVQCGkOjWpnjZaaleZDB2YfIPluVIJzwHhFhE0GVUKU0/E7JLss1Xui+D2wni9BGjGuAV18W3Vq3OjWrBQNGs2J+x7aAQJWr3kbh7J8D1A+fHkfigziIsRMNfz6S8wD1D+wNK+I4JF7ZzmSdShUbpd3solfKuYWN+1yvD85Yo1gTodWj83ZxsvYhgPg6AJ2kTtXYruKaOIf1p2Qw4oNq7fctSfwmcYO2EvvudUxxGn8Lnzt6Y4kr2EhncXRpezyUUwd13n6293wHGl75wXuaNFEDISdK9bw64ArZZQl8ygbGDetrCZ0BbEmlJZloOHZReEaRTH7zRjVaIRVW2SqVjlwNeznqpr/AbspXl12QfwRPtOmIhMdNmbYChYJPg/xsa+RP/Puzw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(82310400014)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 12:58:09.6542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a81df8-ee4b-448c-6dc4-08dc60705d4e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F42.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8139

This series introduces support for SNP features to KVM-Unit-Tests
environment. Goal of this work is to use KUT to build and develop a test
suite for KVM hypervisor with SEV-SNP support to test basic
functionality as well as determine whether hypervisor can handle edge
cases that a normal SNP guest otherwise wouldn't perform/request.

These patches are rebased on top of [1] and are available at:
	https://github.com/pvpk1994/kvm-unit-tests-1/tree/SNP_RFC_v1

which is in-turn is rebased on top of kvm-unit-tests master tree
(Commit: e96011b32944):
	https://gitlab.com/kvm-unit-tests/kvm-unit-tests

============
Patch layout
============
Patches 1-2: Provide MMIO access support to the APIC page by unsetting
	     C-bit in guest page table for SEV-ES/SEV-SNP guest.

Patch 3: Enables support for running SEV-SNP tests in UEFI environment.

Patches 4-6: Enables support for SEV-SNP in KUT and provides an
	     acitvation test to determine whether SEV-SNP has been
	     enabled or not.

Patch 7: Sets up a new page table to enable page allocation support in
	 UEFI environment for SEV-SNP related tests that are introduced
	 in this patchset.

Patches 8-9: Enables support to perform page state changes
	     (Private <=> Shared) using GHCB MSR protocol.

Patches 10-11: Enables support to perform page state changes
	       (Private <=> Shared) using GHCB NAE events. These tests
	       support 2M and 4K pages.

Patches 12-13: Introduces tests that perform page state conversions within
	       a 2M range to demonstrate how hypervisor/qemu handle page
	       state conversions that a regular SNP guest would not
	       perform during its lifetime.

================================
Procedure to run this test-suite
================================
SEV-SNP KUT guest requires UEFI/OVMF to bootup. Information on how to
run the SEV-SNP tests with UEFI support can be found in
x86/efi/README.md introduced in this patchset.

Use the following (Kernel, OVMF, QEMU)  to run the SNP tests:
Use qemu (SNP supported) that is listed here:
    https://github.com/AMDESE/qemu/tree/snp-latest
    (Commit: a4f571b72e03 at the time of writing)

Use OVMF (SNP supported) available at:
    https://github.com/AMDESE/ovmf/tree/snp-latest
    (Commit: f992fee06f64 at the time of writing)

Use SNP host kernel available at:
    https://github.com/AMDESE/linux/tree/snp-host-latest
    (Commit: f9b5bc22b945 at the time of writing) 

The following scripts can help build QEMU, OVMF, kernel:
    https://github.com/AMDESE/AMDSEV/tree/snp-latest
    (Commit: 111ad2cc8dfd at the time of writing)

System can be configured as follows to run UEFI SNP tests:
    ./configure --enable-efi
     This will configure KUT to use #VC handler that it sets up once 
     GHCB page is mapped.

    ./configure --enable-efi --amdsev-efi-vc
    The above configuration option will build KUT and let SNP test use 
    #VC handler that is setup by OVMF throughout the lifetime of SNP 
    guest. 

The SNP tests introduced in this patchset run well with both the above
configuration options (--enable-efi & --enable-efi --amdsev-efi-vc).

Once configured, SEV-SNP support can be tested as follows:
    export QEMU=/path/to/qemu-system-x86_64
    export EFI_UEFI=/path/to/OVMF_CODE.fd
    export EFI_VARS=/path/to/OVMF_VARS.fd (if any)
    EFI_SNP=y ./x86/efi/run ./x86/amd_sev.efi

NOTE: Ensure the memory provided via "size=" above matches with the
memory passed in x86/efi/run ($TEST_DIR/run -m 1G). Otherwise, QEMU will
report about machine memory size mismatch with size of memory backend.

=====
TODOs
=====
  * Introduce an edge case for when page size is 2MB, the 
    page_state_change.cur_page must be incremented for each successful 
    4K page processed. (Documented in GHCB spec - Page State Change 
    section)
  * Addition of more edge cases in Page state changes to ensure 
    host/qemu handle these cases correctly.

==========
References
==========
[1] https://lore.kernel.org/all/20240411172944.23089-1-vsntk18@gmail.com/

Any feedback/review is very much appreciated!
Pavan

-----------------------------------------------------------------------
Pavan Kumar Paluri (13):
  x86/apic: Include asm/io.h and use those definitions to avoid
    duplication
  x86/apic: Add MMIO access support for SEV-ES/SNP guest with C-bit
    unset
  x86/efi: Add support for running tests with UEFI in SEV-SNP
    environment
  x86 AMD SEV-ES: Rename setup_amd_sev_es() to setup_vc_handler()
  x86 AMD SEV-SNP: Enable SEV-SNP support
  x86 AMD SEV-SNP: Add tests for presence of confidential computing blob
  x86 AMD SEV-ES: Set GHCB page attributes for a new page table
  x86 AMD SEV-SNP: Test Private->Shared Page state changes using GHCB
    MSR
  x86 AMD SEV-SNP: Test Shared->Private Page State Changes using GHCB
    MSR
  x86 AMD SEV-SNP: Change guest pages from Private->Shared using GHCB
    NAE
  x86 AMD SEV-SNP: Change guest pages from Shared->Private using GHCB
    NAE
  x86 AMD SEV-SNP: Test-1: Perform Intermix to 2M Private PSCs
  x86 AMD SEV-SNP: Test-2: Perform Intermix to 2M private to 2M shared
    PSCs

 lib/linux/efi.h      |   1 +
 lib/x86/amd_sev.c    |  22 +-
 lib/x86/amd_sev.h    |  95 +++++-
 lib/x86/amd_sev_vc.c |   2 +-
 lib/x86/apic.c       |  18 +-
 lib/x86/setup.c      |   8 +-
 lib/x86/svm.h        |   1 +
 lib/x86/vm.c         |   6 +
 x86/amd_sev.c        | 682 +++++++++++++++++++++++++++++++++++++++++++
 x86/efi/README.md    |   6 +
 x86/efi/run          |  37 ++-
 11 files changed, 858 insertions(+), 20 deletions(-)

-- 
2.34.1



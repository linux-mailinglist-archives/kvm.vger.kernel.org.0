Return-Path: <kvm+bounces-14036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1197789E5E1
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 01:08:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5253282FD3
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 23:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703C9158DA8;
	Tue,  9 Apr 2024 23:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JX7A0qtC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861B0156C6D
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 23:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712704094; cv=fail; b=TfRgTKA4AWhcTk+CJJIhmDarm+gfgp4XsVd1HcfM3w5sx9PSbXL/qo2FnV+J7WIBBWG/wReXL0OwpJ1kptnulDloKDTXXDseS8A9dvRbo+IyPdKmqeUQ3GVzzCI0wmid6ZIRVtoieQIcgX9yP1pLU/+HF/XEf8pIoxl7nALIl84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712704094; c=relaxed/simple;
	bh=rKP5LSGLiSESHsc8J9C++5MqIKxKJKM+q01+AX2EqNY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kEVuanlt0HWvNnGXQNJGpFam3U1wjtNlfxHlgXHxrZZO3nEKNMHkCOBXGK/F8x8YwY5KY7s+mLMcSchFU4WmiaHLmwKgJm9BYu8P130l/rxd5ryb5PKWgq7q5seS2iC1+yj9v2VnaGFlEGR4D7/VeEbdboYZH5T8CeQB3DQLrsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JX7A0qtC; arc=fail smtp.client-ip=40.107.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VEpoh+nxgS64MGLI2PDKeXc7GGvpR4ocpES2LupBSdigRKYfUVFBBKY1h0UrBNA0cLpC0pUqt20XfXDQ1YyQ81XJybhNwiGJLUNk7T1LpjW8sKyIAuPkrYXX+fcSZ2jFl3AmcI/4nQHgKKnBDOTD2OueA4apuJHQe3o14b8LCU0YRMta38gGaSQvS+o7S96kbjmArZIIIgvaLjaGEwusNTBaG55GYI8AT0DtSp3Pu9VL1udDOAEtIBCSiWUYS8SFRl1EnPk2KE9lzYVRwbSlslr+pzp6+11VcRruwvwwmUWWYisbBUnzUPbk+7Lax6ZCYo3bxNkGKEc0F80SQCM5NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4G1CqHhJI0OaJEVSj5PDKggnQO0brhCewZ2CVsOIBA=;
 b=UiS8zPGN0dIu22NumOoYtXKoFZjrU5dL47jjoE6MFCaPMWwTvuq3HxuwQTbMWDS0cmbrGa3M1VedFq2NsXfDNJWk/VxVjRzF9R+y+UqGUiEmnYzwYjS0l5zWAjbKbPORP83zKmkJsRAoZNQZQowiJcXC0GJCeM0MHO6GnBXSM7i4Qe0chjh8jTgl8/8sSmVsX8j8dGAV+Y0IxP0gd5W/OlYGlpWciDEIhBqqYPfap10d6pnOBDSkUmGHbBLKbgLQxrvgbq7lxz2v6vJnKHwCfYM+st65wF0OT++seBTuSd/OixYvZ9xReSFYuqGTvLl2LtJczINwtqZ3/Sk/jt6sag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4G1CqHhJI0OaJEVSj5PDKggnQO0brhCewZ2CVsOIBA=;
 b=JX7A0qtChq9OxU4ZkdbmuaO7xKl8Fg4WwkMTUVEqnKKdcCTFHGQIbtGR6F9i5Z02pLWnoXMsZxyhEKwTp5uxlF4DERhMJpS2msBwUyUtKO+fxnVnzC1tOHe4rYAvV+emkoenr8nHFNeWbpbA1xcVDPFLOmGsbvX4rLkYTkvBHtc=
Received: from PH7PR17CA0061.namprd17.prod.outlook.com (2603:10b6:510:325::11)
 by SN7PR12MB6716.namprd12.prod.outlook.com (2603:10b6:806:270::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 9 Apr
 2024 23:08:09 +0000
Received: from CY4PEPF0000FCC1.namprd03.prod.outlook.com
 (2603:10b6:510:325:cafe::7c) by PH7PR17CA0061.outlook.office365.com
 (2603:10b6:510:325::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.19 via Frontend
 Transport; Tue, 9 Apr 2024 23:08:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC1.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Tue, 9 Apr 2024 23:08:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 9 Apr
 2024 18:08:07 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>, Larry Dewey
	<Larry.Dewey@amd.com>, Roy Hopkins <roy.hopkins@suse.com>
Subject: [PATCH for-9.1 v1 0/3] Add SEV/SEV-ES machine compat options for KVM_SEV_INIT2
Date: Tue, 9 Apr 2024 18:07:40 -0500
Message-ID: <20240409230743.962513-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC1:EE_|SN7PR12MB6716:EE_
X-MS-Office365-Filtering-Correlation-Id: b3fa5fdb-8cff-4d77-0e0c-08dc58e9eba9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iKZfT5YcNqBGt2wh0emzBqAAZqqjtJxJeEEJUw80ifUlDS3AX87Wpn5jOZHc4dVc7n/GHW5+1AA66kUjgzFAebmCAh0WQqzd5T5pS/Ld+HyeX/mpJplYNG3/3aCEXR06qn9FvmhjuiaIU6YHK0yjoY871hOAGlPqNu4x6TRFN6UtqxFQ4A/sN/zSEhRWuOh3bLnYnV+opbCKxc3ttf1y+n1AhPdDkn01YVSFOxipj/sq/ZFS/5LF5Au1mCmNjdsL7pubndVVXrh3SaZA0u+BXDhXirActTZgt6liVQGWORAHDDkcw3OWw+880CW7u8IBbdwAm34sRpgRX99yGVDZ6iaUr+5y5OT+2ARqZ6ZSiOz0ugOSVU5QDh/V1H3u1+mHpCHYrZLQIvx6zPbloHU66/al5rHRcR2OBKc+IoFwh4e+7NBfO5ciIhQmLKCOLfCuIeRFOslyhZP1X2t4KToibdxe5e/af4Gwh1yuP/crjXllcVzRxDNNTXu8dREhQ+UPuJctd2NdJMhFmk4gZz91i6oCakgsTgDoWUf6FFRSj44dGK6bh2dDZwq1H4BNE/HyiwGIYNWf+VptGyTnIjcV58+T+pDt09NsyUrpPPPa1+mH7XN7QFPQcl2P5Ip7B0CntvQEHUy4sd35c8+h8Sl+vMaoeDQGOgWZlxzZXWSC9K3MZ3cuyR3id8dteoa4X+UcDD1VBB96fDP2zxCCcRPhMCcFlhKHSmOOKfDifVqmc+P6KjdAQeL2OfLScQaQtCHwen8GO45wP26ghcweusiE3w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 23:08:08.3023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3fa5fdb-8cff-4d77-0e0c-08dc58e9eba9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6716

These patches are also available at:

  https://github.com/amdese/qemu/commits/sev-init-legacy-v1

and are based on top Paolo's qemu-coco-queue branch containing the
following patches:

  [PATCH for-9.1 00/26] x86, kvm: common confidential computing subset
  https://lore.kernel.org/all/20240322181116.1228416-1-pbonzini@redhat.com/T/

Overview
--------

With the following patches applied from qemu-coco-queue:

  https://lore.kernel.org/all/20240319140000.1014247-1-pbonzini@redhat.com/

QEMU version 9.1+ will begin automatically making use of the new
KVM_SEV_INIT2 API for initializing SEV and SEV-ES (and eventually, SEV-SNP)
guests verses the older KVM_SEV_INIT/KVM_SEV_ES_INIT interfaces.

However, the older interfaces would silently avoid sync'ing FPU/XSAVE state
set by QEMU to each vCPU's VMSA prior to encryption. With KVM_SEV_INIT2,
this state will now be synced into the VMSA, resulting in measurements
changes and, theoretically, behaviorial changes, though the latter are
unlikely to be seen in practice. The specific VMSA changes are documented
in the section below for reference.

This series implements machine compatibility options for SEV/SEV-ES so that
only VMs created with QEMU 9.1+ will make use of KVM_SEV_INIT2 so that VMSA
differences can be accounted for beforehand, and older machine types will
continue using the older interfaces to avoid unexpected measurement
changes.

Specific VMSA changes
---------------------

With KVM_SEV_INIT2, rather than 0, QEMU/KVM will instead begin setting the
following fields in the VMSA before measurement/encryption:

  VMSA byte offset [1032:1033] = 80 1f (MXCSR, Multimedia Control Status
                                        Register)
  VMSA byte offset [1040:1041] = 7f 03 (FCW, FPU/x86 Control Word)

Setting FCW (FPU/x86 Control Word) to 0x37f is consistent with 11.5.7 of
APM Volume 2. MXCSR reset state is not defined for XSAVE, but QEMU's 0x1f80
value is consistent with machine reset state documented in APM Volume 2
4.2.2. As such, it is reasonable to begin including these in the VMSA
measurement calculations.

NOTE: section 11.5.7 also documents that FTW should be all 1's, whereas
      QEMU currently sets all zeroes. Should that be changed as part of
      this, or are there other reasons for setting 0?

Thanks,

Mike

----------------------------------------------------------------
Michael Roth (3):
      i386/sev: Add 'legacy-vm-type' parameter for SEV guest objects
      hw/i386: Add 9.1 machine types for i440fx/q35
      hw/i386/sev: Use legacy SEV VM types for older machine types

 hw/i386/pc.c         |  5 +++++
 hw/i386/pc_piix.c    | 13 ++++++++++++-
 hw/i386/pc_q35.c     | 12 +++++++++++-
 include/hw/i386/pc.h |  3 +++
 qapi/qom.json        | 11 ++++++++++-
 target/i386/sev.c    | 19 ++++++++++++++++++-
 6 files changed, 59 insertions(+), 4 deletions(-)





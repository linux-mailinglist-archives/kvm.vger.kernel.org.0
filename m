Return-Path: <kvm+bounces-16300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 688D78B8649
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:47:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FCE8281E92
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 07:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289634DA11;
	Wed,  1 May 2024 07:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="h1ByIOa/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF884D58A;
	Wed,  1 May 2024 07:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714549610; cv=fail; b=HLrAzU1Gta7Sn2LsbPnX9Xu4vKPx9yaZi275yJnTEwBfUEHms4sB8XZBHDygA6vha7o4M8c1acPFQhZ86j/No039Ey3sNTrNBnpTsAKCeObfJ6KNiJNLIPdobtW2M+j6yC5N2ZJKMlqasmlEhvasy0pAZV++pBpBm3FHWLM3mAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714549610; c=relaxed/simple;
	bh=K1+iQ+eLC1zz+PtZUfrbfGM8wwej7vCcJb1lV7B45CA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qFo0aQA1qDCBLQkxLfgDG5zfxTXKCpjs2p7JcD6yrmgY159Jl5lhAujJBSIcy4v183nDBgi/fJjBAUW10YpX283K12DM95aQ2MH/wdhdi9nJmZuI25BjqL06KhFS5tnYeLSTxjtyizoeezbn2j6epOt4timPjJVZMNZs/oV0j9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=h1ByIOa/; arc=fail smtp.client-ip=40.107.223.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RsxABI4p+QWdUr+6B3wbJVl/m24bHr112Ddu2JtiiRQH7NsTN897mYbLdWPrVEcv35B79CFVJq19i4s+k0g+lByKtCEir+v+NoDi02t14yfkL7kNwKR67tQ1OoqrcYJysw4/9T2R8q+ryzYF8a+AUEApivBPcUVjIUF4/lWYUhu+KTuTqWeKeZ8cgu7UJwxzNRRfWamwaHFv+XYlEN735RMxnMTgjSH1CAlUBBoa9pLN0TDweVF1IdyXaGlzrlh6ySapff13ytKSUuy0qtENw3KktCqocmCe+kkuCGMyXtHPDN9EwQF7N9IVPpsBM1SGgeFFvZle76iVX7caW6nDMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EgIEkJloiJzj3W0Di61zLbBQ2w7L1hwIk3Kwnb4p5pI=;
 b=FwZ7nsjkROGKl9SzCbnxkKcQGc1AQL371FJnDcFYDwxsDZfagdECKy+Txj3SdJaqYtlK/Ou5QmwrTSwcrg2OVIxfSfhdz1K1QMnGSMWz2UlA91q2cMG3p+NePhp59COYBcI1NwXFA4ZgpVwP1uiLRGu2T5oLubkPFmNbTHgg4HMIMLFkC48P+BcUIBG82GIPeLVjm3ydUObJwfWzjfmHmgiYfz2sToBdkS+imHEJ826bNY5MCKE+fag8WuxZ8AH0oLoSUC0+3PDpZN0tT6Il1/JTQWw3dV7HXdEbCLfJc64BHQbqVAhPLc6HnRi9yOCw3xrQwvUeyJQFWqprCIXjDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EgIEkJloiJzj3W0Di61zLbBQ2w7L1hwIk3Kwnb4p5pI=;
 b=h1ByIOa/ibJRxnk8NnEFQ2Q7tazAJJwD04TSKjivrnOXDQY4uzxVURShM5hoF63cdW0nqpLRL4/NTuKVXaRtpgYp//zrj9An3MmwX0faTLkIYGWITcYqWtpoS/NjT/BIRAVU+TFeY6Nnqxtz1q+gUOxv7VXB+uIQ5tE9yqqFzRY=
Received: from CY8PR12CA0028.namprd12.prod.outlook.com (2603:10b6:930:49::28)
 by CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 07:46:45 +0000
Received: from CY4PEPF0000EE31.namprd05.prod.outlook.com
 (2603:10b6:930:49:cafe::3e) by CY8PR12CA0028.outlook.office365.com
 (2603:10b6:930:49::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.27 via Frontend
 Transport; Wed, 1 May 2024 07:46:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE31.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 07:46:45 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 02:46:44 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>
Subject: [PATCH 0/4] Add SEV-ES hypervisor support for GHCB protocol version 2
Date: Wed, 1 May 2024 02:10:44 -0500
Message-ID: <20240501071048.2208265-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE31:EE_|CH3PR12MB8728:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ac0b4c8-1c12-498a-2450-08dc69b2d98c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|1800799015|376005|36860700004|82310400014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y2V4IXadIbYfRffWQ6IHa54nOFFuRPVOAd0Si1Opi3E2L73f0U8lKCsHheG+?=
 =?us-ascii?Q?pLTQp3Lyuwb2MF0INjwVbzXkBIHXhkb3T0e7lcvpIkIaTaA9GH35nwf0TLZx?=
 =?us-ascii?Q?q22QONIW1hTSL8gViKPAbpSb5CVjz0PnXSaaChO6K2+cjjFQ8G1WgIkNBQr7?=
 =?us-ascii?Q?apkmvfjvpzGjlauR1IfuXcwEO2y0ZbSiw2mypuvIGRjn/qCaJAaPZKW3iNXM?=
 =?us-ascii?Q?OnPQwOTe/5MrHpg6OZDpicFXM4CKPLTaXkzMjF4P+lDVzdn5mxs3PxsC93XS?=
 =?us-ascii?Q?MpKO/CixGuREh0o27NXqa1JwdHuPSMM8D7qiZhrPj3i1rohUgPTW0FYdGWi2?=
 =?us-ascii?Q?1Qh1VzxUprgSFFJ4zTBADFp0UmJuZT2Wl3TwIE0rL/ykkPNzKFEyS35A7EFr?=
 =?us-ascii?Q?3/24WorJzzlCZ2AVLeZ9Zy/bBClUHuw+R7Jdn+O/WK4PwiWO2WtN9/OKHg+G?=
 =?us-ascii?Q?gfjZJ55GUgs3sNtbZqMG9D2gmOyJBVf991oyX2lgz1xI97e/V4HVrXRA5cnv?=
 =?us-ascii?Q?oGvqB81xzzMI3nejWuNQLMvy6m0Zfqms8APucOkXrPF1fiKovN+X669XtlgZ?=
 =?us-ascii?Q?66jreSpWUcDyfw+qk44B6h2smlN82pZQcOzHMnWdoAsFFVaaedDTBDf4JjQ9?=
 =?us-ascii?Q?BrPOZEWSFHp/wcAL64l8kJNBPBCuZGUfgn/LmGyD0neb1LPCZnsrPCHsKliP?=
 =?us-ascii?Q?gDmC0YZP8+ddzbb0iOO0X06DFdvJ5qObTAwcaWFsQ22RTRMkKGe5LxDJEHUA?=
 =?us-ascii?Q?It66Lhx9Ksz2aAwuoKGTFxbT6QYyXJXOBAIWzHyiqUMZCVOiHj2d4S2l/qSv?=
 =?us-ascii?Q?/WcPrVAJkL6SZoH8jKawxSdf9arBhz3nhHq0ju1rsNHQvC5QsGLzTj3ch4q2?=
 =?us-ascii?Q?emsDd+LFTDZ41c/XJVDh28nXOPE1FS4xXX/oc5JkLV0unds1h9EsMRyYJ7RR?=
 =?us-ascii?Q?jwMpojApwJYXoS54TuLPcB+PWI+T/9g1eCZW4UrLf6DNWNPQ+03bphTIR/co?=
 =?us-ascii?Q?PaSCtNHcmrgOgqYtOrxPtY0uRQMp3evpp967NDCco694mjvPz0hT5I/ozYUZ?=
 =?us-ascii?Q?jYV2P3HppRFJTW9S9RdM2/Lr0C++TnGz0OBnsNRU4Bc6nLDQnf9u4p2QM4aG?=
 =?us-ascii?Q?YVUkazcT1B0xfRVNs0sMrvl3pWFGrgBevw/f761uuj6wqg0MX6D92+ZeBOvE?=
 =?us-ascii?Q?iJFMNvfxt2lmbWZ9F4MKTNA6Ik0SjlfRFulR0rTUsvTBK+rtEjF7+6U51t2b?=
 =?us-ascii?Q?EgrPncrXlMW3hgMG7G1JZiYyWZUn3JI22eeKBNlEQ7nSTwbBpGPMWUbYajml?=
 =?us-ascii?Q?BK9KW+asSIiYN0ro32VIk4u6Aaqjn4qqQIDuXBN3K4l4iQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 07:46:45.3682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac0b4c8-1c12-498a-2450-08dc69b2d98c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE31.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8728

This patchset is also available at:

  https://github.com/amdese/linux/commits/sev-init2-ghcb-v1

and is based on commit 20cc50a0410f (just before the v13 SNP patches) from:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=kvm-coco-queue

Overview
--------

While the main additions from GHCB protocol version 1 to version 2 revolve
mostly around SEV-SNP support, there are a number of changes applicable to
SEV-ES guests as well. This series plucks a handful patches from the SNP
hypervisor patchset that comprise the total set of GHCB-related changes that
are also applicable to SEV-ES, and then introduces a KVM_SEV_INIT2 field so
that userspace can control the maximum GHCB protocol version advertised to
guests to help manage compatibility across kernels/versions.

For more background discussion, see:

  https://lore.kernel.org/kvm/ZimnngU7hn7sKoSc@google.com/


Patch Layout
------------

01-03: These patches add support for all version 2 GHCB requests that
       are applicable to SEV-ES
04:    This patch switches the KVM_SEV_INIT2 default to GHCB protocol
       version 2, and extends it with a new parameter that userspace
       can use to control the specific GHCB version for a guest


Testing
-------

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/snp-v4-wip3c

A basic command-line invocation for SEV-ES would be:

 qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=sev0
  -object sev-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,ghcb-version=2

Feedback/review is very much appreciated.

-Mike


----------------------------------------------------------------
Brijesh Singh (1):
      KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests

Michael Roth (2):
      KVM: SEV: Add GHCB handling for termination requests
      KVM: SEV: Allow per-guest configuration of GHCB protocol version

Tom Lendacky (1):
      KVM: SEV: Add support to handle AP reset MSR protocol

 Documentation/virt/kvm/x86/amd-memory-encryption.rst |  11 ++++-
 arch/x86/include/asm/sev-common.h                    |   8 +++-
 arch/x86/include/uapi/asm/kvm.h                      |   4 +-
 arch/x86/kvm/svm/sev.c                               | 111 ++++++++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h                               |   2 +
 5 files changed, 120 insertions(+), 16 deletions(-)




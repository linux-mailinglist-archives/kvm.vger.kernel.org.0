Return-Path: <kvm+bounces-18466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5551A8D58F8
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 05:23:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD63E1F2542A
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 03:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3B8278285;
	Fri, 31 May 2024 03:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="au25WwJW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C856E77F08;
	Fri, 31 May 2024 03:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717125818; cv=fail; b=usC1A9dgTiYDN2pDO+AQBAdhkD+MQ3atyuzqeR/ZaXtNuDqsAjMa/TxQnS9ej4EkWrjcZFaT0mEHRPgdVc5AJLp3YHQdxr0+Xn0msbyAt6ZigCmS7Oxp4I9aj8dQaoJrgj6nx1X9HUDtIqMttvzRZb0N9Bvh2TD4Ab2v6qa0+4w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717125818; c=relaxed/simple;
	bh=ZwgiBZqaQI88yroGu5N/MjGk/2gYSLKq3x2Z4iIFJRc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bubpBcK5viKfzX0Id/VOOWfRBd79q2oE7Rc411fFeW4oYGvQ7fo1jF6keMXDcW0YcRewhU6Tr9ZSEzPO8+PtAhDCoSOigczigjeS4YnO/pRdjmVZh3uCluuyfzZoa14XfYuqQepUZZLF9HxOpToKpbbGf1VpKIbZ8ZuLISstcJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=au25WwJW; arc=fail smtp.client-ip=40.107.96.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUg+QoQHupTuXCNM3MFhMvwV9w/BUdnm568RKXNuh5sY0Fi4x4zq0xsu+YO2EfW1coICRuIZT9BGvXNwc5+GTtZmY48lkjMJJkXq+04H9ECe0m03q3795nmF++r/otY0uJxVDhyNzQmzV1D8RqUqltPCtP3poqMR9BCCWl3Rl4lKxQbm6IXpG406cpgBlUDRr8A8SyBV3nzh14AxVHmaMISeAW23lCpWhLnbOsHzg4Op57AXxWCGgaEPn+1OceiwuCpFn4tKzB8s2MRPUwJAe3o7THj+4mt79HtONxDF98VjqLe3ElNmREyKIyFbWLfacyPI9Pxp9VUiiCgjEd1//g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RaEz9Vd5MvS4r6jxNvhE8FeZrfx+dxdrJZwauFqwr7Y=;
 b=PcXRWd8ubftPIOkQO2A3Pzg9NFXxCzv95RH+xelKhivcEgPClgOXtAPcnvA12Bxdk+6I92LxqrIcQyDtoIOGz69wBm/n4doWmYghz72Gn244xhiVbePdiL9+pBW4fFHzk6l21/uBJg9ombl8xJEOKbu1LRXAkXGFgef6mLbQzk2b4+NAsAhIzVM0+SwufruJ/dyXuLXCKhBi0txu3Yw5KEx3GwRMQ40Cro4c2owii8DkcTKGJZMEhCmVGqgjo2c3dE2AkooR4MDHh+Dwi7mVaqkZwMeshRwpPzcgnEWWW5LY5imzYoimMZZO+5BUJ4hxHN8lANB1ymW56Y5XPt3eow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RaEz9Vd5MvS4r6jxNvhE8FeZrfx+dxdrJZwauFqwr7Y=;
 b=au25WwJWQhHssjDkgz2903XLUmpxSOWVGZwHHZv2VxLCYYmDNZFCTL4PMgDXiDiL1AdNx5gWiMBMPKKmOiHlKKPWMViVhlZj1cL/BU9Y4z00KRdvNTLJsKKLKzaP/B65G90YOvb8zS5Bzru+CVTvV7jl3GgmGoNoBdo8FiPq/yE=
Received: from SJ0PR03CA0060.namprd03.prod.outlook.com (2603:10b6:a03:33e::35)
 by PH8PR12MB7028.namprd12.prod.outlook.com (2603:10b6:510:1bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Fri, 31 May
 2024 03:23:32 +0000
Received: from CO1PEPF000042AD.namprd03.prod.outlook.com
 (2603:10b6:a03:33e:cafe::1e) by SJ0PR03CA0060.outlook.office365.com
 (2603:10b6:a03:33e::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30 via Frontend
 Transport; Fri, 31 May 2024 03:23:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AD.mail.protection.outlook.com (10.167.243.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 03:23:32 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 22:23:27 -0500
Date: Thu, 30 May 2024 22:22:49 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, <linux-coco@lists.linux.dev>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <vkuznets@redhat.com>, <pgonda@google.com>,
	<rientjes@google.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<alpergun@google.com>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <papaluri@amd.com>
Subject: Re: [PULL 00/19] KVM: Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <6nby33glecw46wrdws7vuokrqz4b72evrzdujcrsm6pujo62b6@xoxstkzsvwrj>
References: <20240510211024.556136-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240510211024.556136-1-michael.roth@amd.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AD:EE_|PH8PR12MB7028:EE_
X-MS-Office365-Filtering-Correlation-Id: ad5fd8c7-3ce2-4e45-c7bf-08dc81210c77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|36860700004|82310400017|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ktLJFypMUenAj332d1Gne1pfumPCb5647XBlcyx7PrET5Vem/vGd85eJvkC5?=
 =?us-ascii?Q?M4TJZFSdw+b7MdO5kc6kJVzrqeZqc7p7UnJYFW3ax8v4YbeSG4mM0OUwgff7?=
 =?us-ascii?Q?zyLwXUbn5TW0Z4LQHuJwUa0SvuekOcwsZHHhR3yYmXrpMUh7pchxO9IjlT44?=
 =?us-ascii?Q?hG8S6A52t+O6SisxHmLjFZax6xpPCoaEIunfn6OR3RECiLuVRJEvqadfdgLW?=
 =?us-ascii?Q?+RFUOcyoNDfwACfn6vtVVUM98JsCUnrDZg/AccFuS3tTSIt9kNH3KXhwcmXR?=
 =?us-ascii?Q?JondMPZGyz3ygZune4ui68/GGU4+X3Qu/zPH5UIl7WsEnEtY9lk9VXsyXUg4?=
 =?us-ascii?Q?pWqBBcX+PradVqZXut1Xsp8HGJaj0VIR6r0W92DLSRjvouKrW3I/zGj85KmG?=
 =?us-ascii?Q?qphDg+p5moK/rx1LtsDPPT2gPjOwJ0DhMxxK1tpHeT7C2ty4FCElOK5g0/8+?=
 =?us-ascii?Q?iTXbP7CYuL23n8YV2CEk4CU8EDy8tTqRWprg14ufYYE8DOr9q3WOLoBHIoo4?=
 =?us-ascii?Q?zG26MMwxVcVGfabinFPfH4JgWvuCGXwOkV7fzzF9o0qjpeyfQQUM/MgmDBSi?=
 =?us-ascii?Q?7fLBENpbQaQ7bcHPixlcBe+nNh6yhy4k5fynwAe5DRO+NidBoatcC8vIV6zk?=
 =?us-ascii?Q?n4wXuJZIMfI+fFBvc6jW0gxDfB9b3ucQvnPgAyeq3y0wieayeCrPuzj5u0fi?=
 =?us-ascii?Q?9bB+u03AUuO0QgLAYic5MW59nc96ftbnDNcK3iiJMlKEfi94xcQjeUW4VHVJ?=
 =?us-ascii?Q?7LpHvWUwXdn2ZEO+V3g1ZchGC6diD/ZwBUa9sWdqZA3buANHtOPvqFFHK4qp?=
 =?us-ascii?Q?FykK7BlT3ZZylWlE1HEi9tryNzPdGULH6UIYyT/Ano8aQFUU8iJUK+SHXFRA?=
 =?us-ascii?Q?mdUGdXS1hfRcBb5v/cEmWC0jMBxv8rRIkjLeNHm2zrFLqZ+YpbYy8on/zV0n?=
 =?us-ascii?Q?jE7vmYdsoyo+eo9G3rMaLDpcjeGqMF/QkFQq1H+U8QC0bmAL10I0d7qE6SED?=
 =?us-ascii?Q?dn5zLQVQN64GlBRYai4xOuXFy0Z3nPUyx9kfUP4gkgDUyWsGc/NlnslCuE1f?=
 =?us-ascii?Q?rdBDH7lDyvF72mm4SrH/W9E4X++ek6aOY2SU35gObae91SV7r1gxzpU7TKtC?=
 =?us-ascii?Q?awVKc11bmNxkRssRl9EPffvB8GnoFBgLCNSeLv7Mm97pBAcnFiMPqGQuw3z1?=
 =?us-ascii?Q?1hIxs6XmLEnguxu6OY3h8yV89J60uv0lxlSP3KtqrmH0tSZRG8+MNQhiOToQ?=
 =?us-ascii?Q?cEyHj4gO3tRIb8CaIf6Y5dAZVpQrr947ma1OGLncqXK5WHr+QWH26JOmF4ht?=
 =?us-ascii?Q?cyrA7ME9eZUU7+fKBsMEeKi7NurWcuIToudPSqhOg+z3eQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(36860700004)(82310400017)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 03:23:32.1129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad5fd8c7-3ce2-4e45-c7bf-08dc81210c77
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7028

On Fri, May 10, 2024 at 04:10:05PM -0500, Michael Roth wrote:
> Hi Paolo,
> 
> This pull request contains v15 of the KVM SNP support patchset[1] along
> with fixes and feedback from you and Sean regarding PSC request processing,
> fast_page_fault() handling for SNP/TDX, and avoiding uncessary
> PSMASH/zapping for KVM_EXIT_MEMORY_FAULT events. It's also been rebased
> on top of kvm/queue (commit 1451476151e0), and re-tested with/without
> 2MB gmem pages enabled.

As discussed during the PUCK call, here is a branch with fixup patches
that incorporate the additional review/testing that came in after these
patches were merged into kvm/next:

  https://github.com/mdroth/linux/commits/kvm-next-snp-fixes4/

They are intended to be squashed in but can also be applied on top if
that's preferable (but in that case the first 2 patches need to be
squashed together to maintain build bisectability):

 [SQUASH] KVM: SVM: Remove the need to trigger an UNBLOCK event on AP creation
   - drops handling for KVM_MP_STATE_UNINITIALIZED since no special
     handling for it will be needed until SVSM support is added in OVMF
     and the host kernel has the necessary support for running
     SVSM-enabled guests
   - to be squashed into:
     KVM: SEV: Support SEV-SNP AP Creation NAE event

 [SQUASH] KVM: SEV: Don't WARN() if RMP lookup fails when invalidating gmem pages
   - address the WARN() that Sean noticed when running guest_memfd_test
     kselftest on an AMD system without SNP enabled
   - to be squashed into:
     KVM: SEV: Implement gmem hook for invalidating private pages

 [SQUASH] KVM: SEV: Use new kvm_rmp_make_shared() naming
   - fixup to handle helper function being renamed in prior patch
   - to be squashed into:
     KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
     
 [SQUASH] KVM: SEV: Automatically switch reclaimed pages to shared
   - implement suggestion from Sean to always switch reclaimed pages to shared
     since that's what the callers all end up doing anyway
   - to be squashed into:
     KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command

As discussed at PUCK I will resubmit the guest requests patches
separately will all the pending changes incorporated.

Thanks!

-Mike

> 
> Thanks!
> 
> -Mike
> 
> [1] https://lore.kernel.org/kvm/20240501085210.2213060-1-michael.roth@amd.com/
> 
> The following changes since commit 1451476151e08e1e83ff07ce69dd0d1d025e976e:
> 
>   Merge commit 'kvm-coco-hooks' into HEAD (2024-05-10 13:20:42 -0400)
> 
> are available in the Git repository at:
> 
>   https://github.com/mdroth/linux.git tags/tags/kvm-queue-snp
> 
> for you to fetch changes up to 4b3f0135f759bb1a54bb28d644c38a7780150eda:
> 
>   crypto: ccp: Add the SNP_VLEK_LOAD command (2024-05-10 14:44:31 -0500)
> 
> ----------------------------------------------------------------
> Base x86 KVM support for running SEV-SNP guests:
> 
>  - add some basic infrastructure and introduces a new KVM_X86_SNP_VM
>    vm_type to handle differences versus the existing KVM_X86_SEV_VM and
>    KVM_X86_SEV_ES_VM types.
> 
>  - implement the KVM API to handle the creation of a cryptographic
>    launch context, encrypt/measure the initial image into guest memory,
>    and finalize it before launching it.
> 
>  - implement handling for various guest-generated events such as page
>    state changes, onlining of additional vCPUs, etc.
> 
>  - implement the gmem/mmu hooks needed to prepare gmem-allocated pages
>    before mapping them into guest private memory ranges as well as
>    cleaning them up prior to returning them to the host for use as
>    normal memory. Because those cleanup hooks supplant certain
>    activities like issuing WBINVDs during KVM MMU invalidations, avoid
>    duplicating that work to avoid unecessary overhead.
> 
>  - add support for the servicing of guest requests to handle things like
>    attestation, as well as some related host-management interfaces to
>    handle updating firmware's signing key for attestation requests
> 
> ----------------------------------------------------------------
> Ashish Kalra (1):
>       KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP
> 
> Brijesh Singh (8):
>       KVM: SEV: Add initial SEV-SNP support
>       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
>       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
>       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
>       KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
>       KVM: SEV: Add support to handle RMP nested page faults
>       KVM: SVM: Add module parameter to enable SEV-SNP
>       KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
> 
> Michael Roth (9):
>       KVM: MMU: Disable fast path if KVM_EXIT_MEMORY_FAULT is needed
>       KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
>       KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
>       KVM: SEV: Add support to handle Page State Change VMGEXIT
>       KVM: SEV: Implement gmem hook for initializing private pages
>       KVM: SEV: Implement gmem hook for invalidating private pages
>       KVM: x86: Implement hook for determining max NPT mapping level
>       KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
>       crypto: ccp: Add the SNP_VLEK_LOAD command
> 
> Tom Lendacky (1):
>       KVM: SEV: Support SEV-SNP AP Creation NAE event
> 
>  Documentation/virt/coco/sev-guest.rst              |   19 +
>  Documentation/virt/kvm/api.rst                     |   87 ++
>  .../virt/kvm/x86/amd-memory-encryption.rst         |  110 +-
>  arch/x86/include/asm/kvm_host.h                    |    2 +
>  arch/x86/include/asm/sev-common.h                  |   25 +
>  arch/x86/include/asm/sev.h                         |    3 +
>  arch/x86/include/asm/svm.h                         |    9 +-
>  arch/x86/include/uapi/asm/kvm.h                    |   48 +
>  arch/x86/kvm/Kconfig                               |    3 +
>  arch/x86/kvm/mmu.h                                 |    2 -
>  arch/x86/kvm/mmu/mmu.c                             |   25 +-
>  arch/x86/kvm/svm/sev.c                             | 1546 +++++++++++++++++++-
>  arch/x86/kvm/svm/svm.c                             |   37 +-
>  arch/x86/kvm/svm/svm.h                             |   52 +
>  arch/x86/kvm/trace.h                               |   31 +
>  arch/x86/kvm/x86.c                                 |   17 +
>  drivers/crypto/ccp/sev-dev.c                       |   36 +
>  include/linux/psp-sev.h                            |    4 +-
>  include/uapi/linux/kvm.h                           |   23 +
>  include/uapi/linux/psp-sev.h                       |   27 +
>  include/uapi/linux/sev-guest.h                     |    9 +
>  virt/kvm/guest_memfd.c                             |    4 +-
>  22 files changed, 2086 insertions(+), 33 deletions(-)
> 
> 


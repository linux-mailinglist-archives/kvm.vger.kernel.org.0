Return-Path: <kvm+bounces-11490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D558779FA
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 04:21:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCCF42816FC
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 03:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF882570;
	Mon, 11 Mar 2024 03:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5STDrMIB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CF215A5;
	Mon, 11 Mar 2024 03:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710127307; cv=fail; b=YQ8k5F7qTt3Sr6hpo2+9kJc0dIF75FfkZZCeAob0zh63x/OUJmzvCAt7jxN1CbV9vrG3LyWZwGd/QFqNPH/U0j9XmvNtzccjzD4uMPyNS55e2P7gtxDdVtR908tYD/1dbWHZXailRCwjqnxBsE5tkbs+TAzM6MdeVBlaxwhyZMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710127307; c=relaxed/simple;
	bh=eVa6zKJhCCp6BLH106HjwWgSTdWATjmTnVt0fVhGKnI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rgiuXnCDxmCpBV/CsLxs++nmJxvABhtQ/y13FXcIVrA1rnNrXm6Abf8gARSGaf9WYtlI5fixyi5eiJlr9QYudzdWWZxdtCOiLbUYEPH9xwvKXFT4bPJhZ/C8VOE6nrnkc29YYfXV2Mq2KFggV+/3N1DqvPyqAKEoSFuULe+t4Hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5STDrMIB; arc=fail smtp.client-ip=40.107.243.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=My2D71n+6Vn6+Tr2OT3Chhkkwehb1DXX17fN3Axo9DW0xcJkQLEle2oZyUB/+Z2Zs9c1OXvQA6ngO90BLKUnpLqi8fxykailSV6uOCEsex31KT97/kvnTKLrd44aW8y73lp6NdU+E1zg115HPSZo48SUyunk8pH1rlQluzs090C+4M4O1Do7u9E5KjJ2sYvKTpwBmBhCamWnfbSncncS7oynt1vcuP3hYnX+LA1MpHt2BNozwt7rPhRrjmKxq1ufeB637wrWvoHCQ4Q4UXMq/bGWIml4NKuCKdh2vAyzq84f7GfgtWmG8RHx0TTxSE3dtPAH0RV2NFr40UgNZtRYHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/RCeBPSXL/h40RKQ1oEU5vFY7v22q6fL16/szpkn7ag=;
 b=XVf1xXKioXJZflmopqs8PFMTeeeYrSoOUwrnzbQWka75vPvnHGONWfFe9ZuQTVrnllAcuF5sjj9m36OwuCWP56BOOGEN3HxctSOhqqDIconbFxeCghHH/DcHfzPGyxE6o4td09QKurWhaQW76+9W3vJYI+OuylwnOoyhZTfJdJRx0q4BG3boo82XB8ARh44P093dBSA8n5H1vQuBtZnDZknWA8khw6veVI4x8d2zCFqPzN6SMTPcQSSBa6ELnw3Q2EHVFHBAVqTRltOArLJAaW6c76ND5wGclu3KHP5KySR7MS0F/rAoguI+xg5E0WK+CIgTmyXXe5NxZGW0drbGng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/RCeBPSXL/h40RKQ1oEU5vFY7v22q6fL16/szpkn7ag=;
 b=5STDrMIBVgcXUB1QnfdykX4ftL67rk85VVN7O54kO019uFtfbeB+4l51EeMwI4XPemzYTcyE6EbTetw6Kt5/5jppiCFuZm9jS2oe+ekfVQWI6EGjkG7I3umBp3+E5nPxJvirLsyGOLiWgS1npw9wARPPkIF1wKLeEO+tmmtNt0c=
Received: from SA0PR12CA0018.namprd12.prod.outlook.com (2603:10b6:806:6f::23)
 by PH7PR12MB5976.namprd12.prod.outlook.com (2603:10b6:510:1db::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Mon, 11 Mar
 2024 03:21:42 +0000
Received: from SA2PEPF00001507.namprd04.prod.outlook.com
 (2603:10b6:806:6f:cafe::7b) by SA0PR12CA0018.outlook.office365.com
 (2603:10b6:806:6f::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35 via Frontend
 Transport; Mon, 11 Mar 2024 03:21:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001507.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7386.12 via Frontend Transport; Mon, 11 Mar 2024 03:21:42 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 10 Mar
 2024 22:21:07 -0500
Date: Sun, 10 Mar 2024 22:20:51 -0500
From: Michael Roth <michael.roth@amd.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <isaku.yamahata@gmail.com>,
	<linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>
Subject: Re: [RFC PATCH 0/8] KVM: Prepopulate guest memory API
Message-ID: <20240311032051.prixfnqgbsohns2e@amd.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1709288671.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001507:EE_|PH7PR12MB5976:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f848bd1-74d1-4c50-10b4-08dc417a5f64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yP4PJhjuDFUFLQ+Gl8MqA6rBe6seD25tFM1s+7rnM2ee/heqRIqgTo+ECasJjUIdiJz8T8PVRVm1ABN+VSEbhdSctp98lmJ09ekMwCS9JuCzblwOWwAr/RJbBB1FrnMSK4yGQdrZs41UTBgSZXUtubsjjF+16OVcMp3AEW3jWRkMTvI/HDRztULDjwAY+H35MGvqPkpvDGysEC4hiznQRKCx2fyaE754kZOQL5SXtyl7QoQIh0iPDvVBmjUEa+XL4MR7GQGXBEloideGR0ZWjaXPwO7X0vjT669+B/ULjeAL9bYKVdUT4RyqDPGIYZD1oalOTTwzLqrwlt2RJJLcKii1zrA15B7Xw7NA9Dz73+PD1ddyRdCIL9eo3wPueAOQiaCIvQrko4WDJHWl+3WB4A/ehw2w4WRHazlhTrUEIAd68meL7ps7v++S93qKe2vyHWaX9zuAxGDh8Gwngw8GvSE2CfEg3xWDqCWiQdo53PeMcz845h3W9TA2Ion4wYsUuOccjL0pWWgb2vOPp8sSgcymLikJm+8PtZhGziy2pgM3gs9Ag9dNYjy1mUt4tT6dN5KQNO6jqe8sd1GrolPg0ry0mk2OeKZU1HETIhTgJLHE8mVs8jyxXJqAPQ33d38Vjq+a1RlKrddvsmbvfHzP96UU6gKeRiQxtTLOWn70DQZN6cBiCxx3DxRnmVrIoOqAIsd5Zvc0rfn4scdkk57sPA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 03:21:42.1195
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f848bd1-74d1-4c50-10b4-08dc417a5f64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001507.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5976

On Fri, Mar 01, 2024 at 09:28:42AM -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> The objective of this RFC patch series is to develop a uAPI aimed at
> (pre)populating guest memory for various use cases and underlying VM
> technologies.
> 
> - Pre-populate guest memory to mitigate excessive KVM page faults during guest
>   boot [1], a need not limited to any specific technology.
> 
> - Pre-populating guest memory (including encryption and measurement) for
>   confidential guests [2].  SEV-SNP, TDX, and SW-PROTECTED VM.  Potentially
>   other technologies and pKVM.
> 
> The patches are organized as follows.
> - 1: documentation on uAPI KVM_MAP_MEMORY.
> - 2: archtechture-independent implementation part.
> - 3-4: refactoring of x86 KVM MMU as preparation.
> - 5: x86 Helper function to map guest page.
> - 6: x86 KVM arch implementation.
> - 7: Add x86-ops necessary for TDX and SEV-SNP.
> - 8: selftest for validation.
> 
> Discussion point:
> 
> uAPI design:
> - access flags
>   Access flags are needed for the guest memory population.  We have options for
>   their exposure to uAPI.
>   - option 1. Introduce access flags, possibly with the addition of a private
>               access flag.
>   - option 2. Omit access flags from UAPI.
>     Allow the kernel to deduce the necessary flag based on the memory slot and
>     its memory attributes.
> 
> - SEV-SNP and byte vs. page size
>   The SEV correspondence is SEV_LAUNCH_UPDATE_DATA.  Which dictates memory
>   regions to be in 16-byte alignment, not page size.  Should we define struct
>   kvm_memory_mapping in bytes rather than page size?

For SNP it's multiples of page size only, and I'm not sure it's worth
trying to work in legacy SEV support, since that pull in other
requirements like how the backing memory also needs to be pre-pinned via
a separate KVM ioctl that would need to be documented as an SEV-specific
requirement for this interface... it just doesn't seem worth it. And SEV
would still benefit from the more basic functionality of pre-mapping pages
just like any other guest so it still benefits in that regard.

That said, it would be a shame if we needed to clutter up the API as
soon as some user can along that required non-page-sized values. That
seems unlikely for the pre-mapping use case, but for CoCo maybe it's
worth checking if pKVM would have any requirements like that? Or just
going with byte-size parameters to play it safe?

> 
>   struct kvm_sev_launch_update_data {
>         __u64 uaddr;
>         __u32 len;
>   };
> 
> - TDX and measurement
>   The TDX correspondence is TDH.MEM.PAGE.ADD and TDH.MR.EXTEND.  TDH.MEM.EXTEND
>   extends its measurement by the page contents.
>   Option 1. Add an additional flag like KVM_MEMORY_MAPPING_FLAG_EXTEND to issue
>             TDH.MEM.EXTEND
>   Option 2. Don't handle extend. Let TDX vendor specific API
>             KVM_EMMORY_ENCRYPT_OP to handle it with the subcommand like
>             KVM_TDX_EXTEND_MEMORY.

For SNP this happens unconditionally via SNP_LAUNCH_UPDATE, and with some
additional measurements via SNP_LAUNCH_FINISH, and down the road when live
migration support is added that flow will be a bit different. So
personally I think it's better to leave separate for now. Maybe down the
road some common measurement/finalize interface can deprecate some of
the other MEMORY_ENCRYPT ioctls.

Even with this more narrowly-defined purpose it's really unfortunate we
have to bake any CoCo stuff into this interface at all. It would be great
if all it did was simply pre-map entries into nested page tables to boost
boot performance, and we had some separate CoCo-specific API to handle
intial loading/encryption of guest data. I understand with SecureEPT
considerations why we sort of need it here for TDX, but it already ends
up being awkward for the SNP_LAUNCH_UPDATE use-case because there's not
really any good reason for that handling to live inside KVM MMU hooks
like with TDX, so we'll probably end up putting it in a pre/post hook
where all the handling is completely separate from TDX flow and in the
process complicating the userspace API to with the additional parameters
needed for that even though other guest types are likely to never need
them.

(Alternatively we can handle SNP_LAUNCH_UPDATE via KVM MMU hooks like with
tdx_mem_page_add(), but then we'll need to plumb additional parameters
down into the KVM MMU code for stuff like the SNP page type. But maybe
it's worth it to have some level of commonality for x86 at least?)

But I'd be hesitant to bake more requirements into this pre-mapping
interface, it feels like we're already overloading it as is.

> 
> - TDX and struct kvm_memory_mapping:source
>   While the current patch series doesn't utilize
>   kvm_memory_mapping::source member.  TDX needs it to specify the source of
>   memory contents.

SNP will need it too FWIW.

-Mike

> 
> Implementation:
> - x86 KVM MMU
>   In x86 KVM MMU, I chose to use kvm_mmu_do_page_fault().  It's not confined to
>   KVM TDP MMU.  We can restrict it to KVM TDP MMU and introduce an optimized
>   version.
> 
> [1] https://lore.kernel.org/all/65262e67-7885-971a-896d-ad9c0a760907@polito.it/
> [2] https://lore.kernel.org/all/6a4c029af70d41b63bcee3d6a1f0c2377f6eb4bd.1690322424.git.isaku.yamahata@intel.com
> 
> Thanks,
> 
> Isaku Yamahata (8):
>   KVM: Document KVM_MAP_MEMORY ioctl
>   KVM: Add KVM_MAP_MEMORY vcpu ioctl to pre-populate guest memory
>   KVM: x86/mmu: Introduce initialier macro for struct kvm_page_fault
>   KVM: x86/mmu: Factor out kvm_mmu_do_page_fault()
>   KVM: x86/mmu: Introduce kvm_mmu_map_page() for prepopulating guest
>     memory
>   KVM: x86: Implement kvm_arch_{, pre_}vcpu_map_memory()
>   KVM: x86: Add hooks in kvm_arch_vcpu_map_memory()
>   KVM: selftests: x86: Add test for KVM_MAP_MEMORY
> 
>  Documentation/virt/kvm/api.rst                |  36 +++++
>  arch/x86/include/asm/kvm-x86-ops.h            |   2 +
>  arch/x86/include/asm/kvm_host.h               |   6 +
>  arch/x86/kvm/mmu.h                            |   3 +
>  arch/x86/kvm/mmu/mmu.c                        |  30 ++++
>  arch/x86/kvm/mmu/mmu_internal.h               |  70 +++++----
>  arch/x86/kvm/x86.c                            |  83 +++++++++++
>  include/linux/kvm_host.h                      |   4 +
>  include/uapi/linux/kvm.h                      |  15 ++
>  tools/include/uapi/linux/kvm.h                |  14 ++
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/map_memory_test.c    | 136 ++++++++++++++++++
>  virt/kvm/kvm_main.c                           |  74 ++++++++++
>  13 files changed, 448 insertions(+), 26 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/map_memory_test.c
> 
> 
> base-commit: 6a108bdc49138bcaa4f995ed87681ab9c65122ad
> -- 
> 2.25.1
> 
> 


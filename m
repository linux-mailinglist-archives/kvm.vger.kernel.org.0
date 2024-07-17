Return-Path: <kvm+bounces-21769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D759393374D
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 08:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DAD628213A
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 06:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0398171A5;
	Wed, 17 Jul 2024 06:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vGNr1ZPe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3B18BF3;
	Wed, 17 Jul 2024 06:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721198581; cv=fail; b=FSBoAqXOdOrpttZPyt8dm4mwM+nPa9lojVrkger8up64xJf5SllngTsHIAg4wWaqey5JuqsIqtDtFaA3ZTImlKpgphd5rwxSl5e4p9/c0Mw+yJ/kOXKj419zCV3+91Z2iL28Ez9lVWHVbd2senG9V9PI6+8NAt9KZdlTsaD4NN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721198581; c=relaxed/simple;
	bh=6nSgBeKnmQwrXti/EihHPYDbTi76Pusfft1E54EiTtU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XqsSZgO/FzkB6qd2ePCOvTNK8KowFVQa+t+YLFdj3mxEv/wQK+E/5Ug759mkYU6fnERFPK9P5xOIT0GKMHMeYj551Tcnhdqk6CODRQ+HPL+EO3xFPcjmbLrkFGmLJIu0qhXIKoGzCpHo+d38s1L1StHtAStficvphXAX3KYrjhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vGNr1ZPe reason="signature verification failed"; arc=fail smtp.client-ip=40.107.93.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t64wGeaxl7Adgo5BwM3FjCFi1G7dH4SRvI7Xp3Aekv/GUGjvzS4J0xEiemyGcYJ/9995r3/ySna1IFbAqElk1lMxwVzHqtO74JnkTtVwEWRQ5wtSfnkdy+vjDAjaXN+nLlwbp1n0X3tyHUolKV0NQO6miyQZl/W+f1ZpaKUZ8VoQ/5fanImGM9JOqYvdZAzcRrzh5DwSmpI2BlSt0oQCBZ0uf0j6u6+piicKM2TITo/vzCa9a2KvQRO1Lguz2gI+4tMgk1x/BYOlAhqnUJjxxl3s8GPoEEdcd1sWMR+lVx8gVet6qOJLhs8eCRUWkE41utiuR59YbrAfiYzMEY+iYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4n5msxTNlLe6+DTGR8RSQaHMO2PeiUqWjmtgD+/L/D8=;
 b=hxpyR2tTmo1JwmGVydhMen5SexZnuxFE71DGq5ooYR8ESboL2phDPaG+cL1s8IEXbouaAeDbvULvswnPBuMQd/B/EumuyCRb0JxSeuQW+2GY9qHN16ZlQT1AUV0pK50ZjoQmaTr6857XzuKYZ9V49ILOV5e82E6PRH4bFPqLVrhX8FeEuqytHqX9erJmcGtDf5qDidlrLnhseehLsz8iIbrDrUkB2aKswKdiID14B2SkGhlEyzWh0WcpabSGSyH/teMF1wuOkFGVBIQ+dCAMf4pYHoLgPaf3W8ouMXSHovxE/rlt6zk5I177sBA2nW7mQJEYFFN3dlhB79wjTuBRrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4n5msxTNlLe6+DTGR8RSQaHMO2PeiUqWjmtgD+/L/D8=;
 b=vGNr1ZPef8iTbjOrTa25MRW5o2wfrY5E1hA8OJyiT0sxRZB8f01fCvPIkL1G6zJNmkJtVtTUeWA5cy+Tg5ZdEwuh8EGjIsXEaLmjiTv1mzesuDCmQKFFmT/gexUCse8FCJROmIv+YsaO7iAqZZuGsAfFKgPTmxaA2I2DdyU0EQM=
Received: from SJ0PR05CA0031.namprd05.prod.outlook.com (2603:10b6:a03:33f::6)
 by DS7PR12MB8249.namprd12.prod.outlook.com (2603:10b6:8:ea::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23; Wed, 17 Jul
 2024 06:42:57 +0000
Received: from MWH0EPF000A6732.namprd04.prod.outlook.com
 (2603:10b6:a03:33f:cafe::c7) by SJ0PR05CA0031.outlook.office365.com
 (2603:10b6:a03:33f::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.13 via Frontend
 Transport; Wed, 17 Jul 2024 06:42:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6732.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Wed, 17 Jul 2024 06:42:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 17 Jul
 2024 01:42:53 -0500
Date: Wed, 17 Jul 2024 01:42:35 -0500
From: Michael Roth <michael.roth@amd.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>
Subject: Re: [PATCH 09/12] KVM: guest_memfd: move check for already-populated
 page to common code
Message-ID: <qlqbmmf2kfk5i7slue42xrb2f7il2scrqgx3xlsvxf4ujuqujb@v454fgzwhn7l>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-10-pbonzini@redhat.com>
 <73c62e76d83fe4e5990b640582da933ff3862cb1.camel@intel.com>
 <CABgObfbhTYDcVWwB5G=aYpFhAW1FZ5i665VFbbGC0UC=4GgEqQ@mail.gmail.com>
 <97796c0b86db5d98e03c119032f5b173f0f5de14.camel@intel.com>
 <n2nmszmuok75wzylgcqy2dz4lbrvfavewuxas56angjrkp3sl3@k4pj5k7uosfe>
 <CABgObfa=a3cKcKJHQRrCs-3Ty8ppSRou=dhi6Q+KdZnom0Zegw@mail.gmail.com>
 <i4gor4ugezj5ma4l6rnfqanylw6qsvh6rvlqk72ezuadxq6dkn@yqgr5iq3dqed>
 <00f105e249b7def9f5631fb2b0fa699688ece4c2.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00f105e249b7def9f5631fb2b0fa699688ece4c2.camel@intel.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6732:EE_|DS7PR12MB8249:EE_
X-MS-Office365-Filtering-Correlation-Id: b6b8b3ba-e43b-4e41-4797-08dca62bb12b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?JvVrXRyGBo2E3GxeXlH35J2sLV5bkaEsE38IzWzXz0XoLIKeLrPkGvW4IO?=
 =?iso-8859-1?Q?LeMrdU7v7yvgisue/pwWPFixdC5ZHBhTwVy5QpHpJAklL8LXl84l25UMjN?=
 =?iso-8859-1?Q?R9+ZCSYAeJyDy9VT31Gf6SYXWCxHJc+LpVQ1Mo9uWkrBiFrfGgWoqCJtn7?=
 =?iso-8859-1?Q?RB9oNxFH/NxvLog6oY4Ju9RgfcVVhuNEL1taatbAW6YXr4vwhyKnVUTiXh?=
 =?iso-8859-1?Q?x5XTQGW+WqdsFDODXWy6GlmeZH/dx8lk8Q5hDrh6OIXugFQK3u2K/LVqtA?=
 =?iso-8859-1?Q?HKiKM7yR8V5DJZz/W9zU+PFAOB7rZa9kGzfzny9W3ShnPwnLcSERhYbZx4?=
 =?iso-8859-1?Q?COfnxUQHTNKm7/G/fLoIsFLV/pDAyjcz/N7dTMInWyYQBSfXB6e4i5lkD5?=
 =?iso-8859-1?Q?z+i4kR/bC1AYqquxfym4tuYBAKFw1EYTYgZ2hh2cR/bs0Lbn+DcaVRxMUc?=
 =?iso-8859-1?Q?Cfyv5ggUdomlqIqalx8tX192Wt5k4+Szu67Dfjw8idFiGSab/evAHkddSe?=
 =?iso-8859-1?Q?ym1J35eNWGfikDL6/Q17ZJkaFaWwlbFnrKCH4jv/8ZinwGj7040awMv3lw?=
 =?iso-8859-1?Q?plQEFvYY6rQkC2jr52JE9cH87hyZSdDkwXMFTkRw5ziWNi5IsTcgfoursm?=
 =?iso-8859-1?Q?B6rS/erZPtj9yfutiw0+ZOJThVkTpFIotJFs9A+bQiHnWyOJh5suaE93ff?=
 =?iso-8859-1?Q?vejKRNayrvyamiafTlS/Z2Kv8NAdQEXRQsfOLMQt1taw8q/3UxqgUeYR0+?=
 =?iso-8859-1?Q?rPlP0GCYDWJbEGlIJQoz+y5itp6dz0vxulf+DGWgdToQAEEZvFVAtJbt07?=
 =?iso-8859-1?Q?7v0HlgVanKhacdztS/47fDDxBr8perH82DiOxUY/gAld4nl6OxeBDl/1rX?=
 =?iso-8859-1?Q?GXOUk7gu2MXOZHkCEJOUFRewPHqJeHJDeq7Jt1rLC9hlOP3EaWfLJqmRLI?=
 =?iso-8859-1?Q?4zcc+RcgWR2kkj2G9GMaHo7eB/SxnafeH6R85Hu/+/UhMPDISpYlJPTTVL?=
 =?iso-8859-1?Q?34isNyHoAnaJdcQB3hWNx5SJAYatzkckNHRejPbMYOm7yILvHvmxLaPQvn?=
 =?iso-8859-1?Q?ix5VXwD2l5Sd3615pSICgByMWTe3FpTwY7Fkf6V+8wEFzylD1bJnWCVrAi?=
 =?iso-8859-1?Q?8h5VLuFAxY26hRokbHU5JHAxiwUkusTmOGjpoAETvXg8zyM1aVPEOd2ng5?=
 =?iso-8859-1?Q?fp6yXj7/3LeAG7BZJ2C+vunlw8SxfuenANMXBSYPJosqjPMitd/j8fJGCE?=
 =?iso-8859-1?Q?ffmGhfr449frrqpHOPHfeGv/hjK2rhJ8kKJu9VYhv3GxgkJ4z8HsT5RsbH?=
 =?iso-8859-1?Q?3KocwadXPEdmzjxlR7pY4TyyuoW823ysQ5GKnEBJlJ0UG6MX8cUPV1Wlb9?=
 =?iso-8859-1?Q?nUKBrzq7lfs3BTWfK+B9Xpanp8ux/k78rIUKpNf4hb8RaW6fxEmEzlMm5Y?=
 =?iso-8859-1?Q?x8f4rEQXNGkX84isJTpf5pIaAhRpr17K4Euv7A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 06:42:56.4100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b8b3ba-e43b-4e41-4797-08dca62bb12b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6732.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8249

On Mon, Jul 15, 2024 at 10:57:35PM +0000, Edgecombe, Rick P wrote:
> On Mon, 2024-07-15 at 16:47 -0500, Michael Roth wrote:
> > Makes sense.
> > 
> > If we document mutual exclusion between ranges touched by
> > gmem_populate() vs ranges touched by actual userspace issuance of
> > KVM_PRE_FAULT_MEMORY (and make sure nothing too crazy happens if users
> > don't abide by the documentation), then I think most problems go away...
> > 
> > But there is still at least one awkward constraint for SNP:
> > KVM_PRE_FAULT_MEMORY cannot be called for private GPA ranges until after
> > SNP_LAUNCH_START is called. This is true even if the GPA range is not
> > one of the ranges that will get passed to
> > gmem_populate()/SNP_LAUNCH_UPDATE. The reason for this is that when
> > binding the ASID to the SNP context as part of SNP_LAUNCH_START, firmware
> > will perform checks to make sure that ASID is not already being used in
> > the RMP table, and that check will fail if KVM_PRE_FAULT_MEMORY triggered
> > for a private page before calling SNP_LAUNCH_START.
> > 
> > So we have this constraint that KVM_PRE_FAULT_MEMORY can't be issued
> > before SNP_LAUNCH_START. So it makes me wonder if we should just broaden
> > that constraint and for now just disallow KVM_PRE_FAULT_MEMORY prior to
> > finalizing a guest, since it'll be easier to lift that restriction later
> > versus discovering some other sort of edge case and need to
> > retroactively place restrictions.
> > 
> > I've taken Isaku's original pre_fault_memory_test and added a new
> > x86-specific coco_pre_fault_memory_test to try to better document and
> > exercise these corner cases for SEV and SNP, but I'm hoping it could
> > also be useful for TDX (hence the generic name). These are based on
> > Pratik's initial SNP selftests (which are in turn based on kvm/queue +
> > these patches):
> > 
> >   https://github.com/mdroth/linux/commits/snp-uptodate0-kst/
> >  
> > https://github.com/mdroth/linux/commit/dd7d4b1983ceeb653132cfd54ad63f597db85f74
> > 
> > 
> 
> From the TDX side it wouldn't be horrible to not have to worry about userspace
> mucking around with the mirrored page tables in unexpected ways during the
> special period. TDX already has its own "finalized" state in kvm_tdx, is there
> something similar on the SEV side we could unify with?

While trying to doing pre-mapping in sev_gmem_post_populate() like you've
done below for TDX, I hit another issue that I think would be avoided by
enforcing finalization (or otherwise needs some alternative fix within
this series).

I'd already mentioned the issue with gmem_prepare() putting pages in an
unexpected RMP state if called prior to initializing the same GPA range
in gmem_populate(). This get handled gracefully however when the
firmware call is issued to encrypt/measure the pages and it re-checks
the page's RMP state.

However, if another thread is issuing KVM_PRE_FAULT_MEMORY and triggers
a gmem_prepare() just after gmem_populate() places the pages in a
private RMP state, then gmem_prepare()->kvm_gmem_get_pfn() will trigger
the clear_highpage() call in kvm_gmem_prepare_folio() because the
uptodate flag isn't set until after sev_gmem_post_populate() returns.
So I ended up just calling kvm_arch_vcpu_pre_fault_memory() on the full
GPA range after the post-populate callback returns:

  https://github.com/mdroth/linux/commit/da4e7465ced1a708ff1c5e9ab27c570de7e8974e

...

But a much larger concern is that even without this series, but just
plain kvm/queue, KVM_PRE_FAULT_MEMORY can still race with
sev_gmem_post_populate() in bad ways, so I think for 6.11 we should
consider locking this finalization requirement in and applying
something like the below fix:

  https://github.com/mdroth/linux/commit/7095ba6ee8f050af11620daaf6c2219fd0bbb1c3

Or if that's potentially too big a chance to decide right now, we could
just make KVM_PRE_FAULT_MEMORY return EOPNOTSUPP for
kvm_arch_has_private_memory() until we've had more time to work out the
missing bits for CoCo there.

-Mike

> 
> I looked at moving from kvm_arch_vcpu_pre_fault_memory() to directly calling
> kvm_tdp_map_page(), so we could potentially put whatever check in
> kvm_arch_vcpu_pre_fault_memory(). It required a couple exports:
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 03737f3aaeeb..9004ac597a85 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -277,6 +277,7 @@ extern bool tdp_mmu_enabled;
>  #endif
>  
>  int kvm_tdp_mmu_get_walk_mirror_pfn(struct kvm_vcpu *vcpu, u64 gpa, kvm_pfn_t
> *pfn);
> +int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8
> *level);
>  
>  static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7bb6b17b455f..4a3e471ec9fe 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4721,8 +4721,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct
> kvm_page_fault *fault)
>         return direct_page_fault(vcpu, fault);
>  }
>  
> -static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> -                           u8 *level)
> +int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8
> *level)
>  {
>         int r;
>  
> @@ -4759,6 +4758,7 @@ static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t
> gpa, u64 error_code,
>                 return -EIO;
>         }
>  }
> +EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
>  
>  long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>                                     struct kvm_pre_fault_memory *range)
> @@ -5770,6 +5770,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  out:
>         return r;
>  }
> +EXPORT_SYMBOL_GPL(kvm_mmu_load);
>  
>  void kvm_mmu_unload(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 9ac0821eb44b..7161ef68f3da 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2809,11 +2809,13 @@ struct tdx_gmem_post_populate_arg {
>  static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>                                   void __user *src, int order, void *_arg)
>  {
> +       u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
>         struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>         struct tdx_gmem_post_populate_arg *arg = _arg;
>         struct kvm_vcpu *vcpu = arg->vcpu;
>         struct kvm_memory_slot *slot;
>         gpa_t gpa = gfn_to_gpa(gfn);
> +       u8 level = PG_LEVEL_4K;
>         struct page *page;
>         kvm_pfn_t mmu_pfn;
>         int ret, i;
> @@ -2832,6 +2834,10 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t
> gfn, kvm_pfn_t pfn,
>                 goto out_put_page;
>         }
>  
> +       ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
> +       if (ret < 0)
> +               goto out_put_page;
> +
>         read_lock(&kvm->mmu_lock);
>  
>         ret = kvm_tdp_mmu_get_walk_mirror_pfn(vcpu, gpa, &mmu_pfn);
> @@ -2910,6 +2916,7 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu,
> struct kvm_tdx_cmd *c
>         mutex_lock(&kvm->slots_lock);
>         idx = srcu_read_lock(&kvm->srcu);
>  
> +       kvm_mmu_reload(vcpu);
>         ret = 0;
>         while (region.nr_pages) {
>                 if (signal_pending(current)) {
> 


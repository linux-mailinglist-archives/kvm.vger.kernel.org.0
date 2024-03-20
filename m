Return-Path: <kvm+bounces-12323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 234C888181F
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 20:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD384285ED9
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 19:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2082885925;
	Wed, 20 Mar 2024 19:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3aZFfbXA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC506A34D
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 19:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710964121; cv=fail; b=EB9X3RGvVRALY1R/47U2EzgLgJViHAXb5Ix2i+ObiLCH3Th2XWNtrIg1uPLwmD3HZ9048hJwgcfU5IKx75K+LiwsK3hLJ2P5qOpNj9sjPBJSp41OPkE1nR2SECTM5zKC7fy2dZBPcv26vVIxHqB9t+G1uL5kA7Ktbo1jLiPjk9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710964121; c=relaxed/simple;
	bh=qdvIUwOT+97cSefb4DrXihuZQUwuLnstHkpso2XUZx8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHjl6aOZHCmufYwtG2hw+LYCf8XElDZHA6ntN6cVpTCqNEPCRUqJu13owoAxEonyhKdcOSZ84fOO7zHUA0sKycL2n+huhzkM0y6KiyRra7+26Gc7hU5ZtZ9na5yEsXX7UXx09NxXcumkkhcw8ZR35UlPqIgqLSip1z2ovJ1BJoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3aZFfbXA; arc=fail smtp.client-ip=40.107.237.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6UxG+pvGUcZKQ4BqFFJZBCunEpA8CJOVO2rpHcuGY/NFNsEChTECYtLpcnH3XnabKXE+k5uJqY3Mmyw4NXJ/AnXqgfYJbSO2L2Pw1Psa4B22EQmsjZkgg8fUM37ZIlwyhJHdFrpJPB4K0vLauG/24O5PVa+aiuydKmUNz4xNY7hbKwynIX7YgYlJ6Qw/I26R6BIy/tIeJjUwyGaeQDwMlRn6mfkKbD+rlKMEtbG1tdBvo/1kDrdsaE7qXozEBJORVaHderGvLb0RjuL7ArxeFJ/nQQDbZBW1kFEqoFtQ1xWteeG4XyNi+Jatu/mQ49f43iskL5bqNraKRwoIHxbkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOB7bEVoZCnQ1QqKsleDnjUv2vl2SO9ocRy1UYKddww=;
 b=SWHEDd+t764/zoGUd+c/GYQwKeCFBmXVIiM5TJPHNXLmdyPAkkO7ruTPQ/YsaWahMeRRXchMGsjVAghsbME2lFNcv8Js1c4PJ+jumvl8FDntrFh7pP2a2hz3TRZHYNK9V8cyct7mHreeGDQT4MCy8Q4SIWR8CnHrNG+O4SA7nWajqC+QcTPV7Br1jhtEI9Aamfh+3X9RLvtkPMcXlKADl4KexOstg8AFZp8YE35AMBi94Xvzjvu5TUov7TYSwpFc2WM7LZHqZUh9v9zctoN+w890xgcdhHRTH7qniGIC02VIPLtJVY7F7odxMVh5vOOfakgkQXf2oCzidJ/ZCoTDjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOB7bEVoZCnQ1QqKsleDnjUv2vl2SO9ocRy1UYKddww=;
 b=3aZFfbXAjoRCIWI5IHKmzhHjLQV8/srLHnX+uG3PoaqKa0OZgUuGKke0zDHCRd0K0ZU+QzOu0EHZHz3O9/0Pa7AtYGQOp6Crv0Qw5P8U107HVQI9HZcmxQvAxix+8dxNvJyMpSuAi0rT7qS/QXGJZZYhhe7x1O7RgZrVQ4+6K9s=
Received: from BY3PR10CA0008.namprd10.prod.outlook.com (2603:10b6:a03:255::13)
 by SA3PR12MB8021.namprd12.prod.outlook.com (2603:10b6:806:305::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26; Wed, 20 Mar
 2024 19:48:34 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:a03:255:cafe::28) by BY3PR10CA0008.outlook.office365.com
 (2603:10b6:a03:255::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27 via Frontend
 Transport; Wed, 20 Mar 2024 19:48:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 19:48:34 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 14:48:29 -0500
Date: Wed, 20 Mar 2024 14:47:54 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 19/49] kvm: Make kvm_convert_memory() obey
 ram_block_discard_is_enabled()
Message-ID: <20240320194754.yfu7zrfwvzdwuw23@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-20-michael.roth@amd.com>
 <d6acfbef-96a1-42bc-8866-c12a4de8c57c@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d6acfbef-96a1-42bc-8866-c12a4de8c57c@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|SA3PR12MB8021:EE_
X-MS-Office365-Filtering-Correlation-Id: d997ffaa-1d3e-4ad1-7b3e-08dc4916ba5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mAscZMIM5gHuN67KsoMjy3ZIY/VdOMsrBa4MahnFXeHY8YFEJDXdpsQRB+hsFCSm0OD12R1OviYysnslJp3ETJ6t/eiwkdEQrLYBrqcCez3nUZfbhFpNNz4dulQn+4MDEW06IMTg7YcmYNkNG49EmbrNXpuJhZIhpv53Dcd9kCFFyeTe9jby2lRXgbFu/dYJe26fi52Dp44G8n/p040coWYLDMr9/250KAxpdpbgT8BbpD/GzniTiWwITZeZZeNuS650uBkRik4uaF1pqiU1LxIlgJYha/38ykppb/5ntZlJWOTmDTdVtLKK2M+hZfL+6SR65RCLkbqHBF5GFHpBshGmfqGUiC3MxWZX9cU8aoIzp2Vke17LMiOMW8m17vTStuOHOEQtXW4JLzRsMR6sy0QgrTLr3jhepvnnAL0xlYk/k4BLFPWZDn+1jDxBG/75gmCu+zSF9o3xh4fZ3Da3js8qRxuF8bJPrS4OEioc9JHQt6sPYXSfzSMjcUUTuQjaMBj0PmmEBDwZPk5FfIlLMypcihd0s+vPPiceJ/G5dx1SiEb6Dv+9zXDvmgU0NSDHpR6oNgC1zemZUOY+6hCuTcHrTzer9i4g/uGJo3/47+QAyYxjHfsDjx5Lwayj7yf7snzSPsn+q+Qcw0NTsUZ9cbS82NvdXSwRcm6nxqz4GfjBrSzvYE+NFp48pGV63NDBoq+spEmMGdcQtF0xnJIesA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 19:48:34.3289
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d997ffaa-1d3e-4ad1-7b3e-08dc4916ba5f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8021

On Wed, Mar 20, 2024 at 05:26:00PM +0100, Paolo Bonzini wrote:
> On 3/20/24 09:39, Michael Roth wrote:
> > Some subsystems like VFIO might disable ram block discard for
> > uncoordinated cases. Since kvm_convert_memory()/guest_memfd don't
> > implement a RamDiscardManager handler to convey discard operations to
> > various listeners like VFIO. > Because of this, sequences like the
> > following can result due to stale IOMMU mappings:
> 
> Alternatively, should guest-memfd memory regions call
> ram_block_discard_require(true)?  This will prevent VFIO from operating, but
> it will avoid consuming twice the memory.
> 
> If desirable, guest-memfd support can be changed to implement an extension
> of RamDiscardManager that notifies about private/shared memory changes, and
> then guest-memfd would be able to support coordinated discard.  But I wonder

In an earlier/internal version of the SNP+gmem patches (when there was still
a dedicated hostmem-memfd-private backend for restrictedmem/gmem), we had a
rough implementation of RamDiscardManager that did this:

  https://github.com/AMDESE/qemu/blob/snp-latest-gmem-v12/backends/hostmem-memfd-private.c#L75

Now that gmem handling is mostly done transparently to the HostMem
backend in use I'm not sure what the right place would be to implement
something similar, but maybe it can be done in a more generic way.

There were some notable downsides to that approach though that I'm a
little hazy on now, but I think they were both kernel limitations:

  - VFIO seemed to have some limitation where it expects that the
    DMA mapping for a particular iova will be unmapped/mapped with
    the same granularity, but for an SNP guest there's no guarantee
    that if you flip a 2MB page from shared->private, that it won't
    later be flipped private->shared again but this time with a 4K
    granularity/sub-range. I think the current code still treats
    this as an -EINVAL case. So we end up needing to do everything
    with 4K granularity, which I *think* results in 4K IOMMU page
    table mappings, but I'd need to confirm.

  - VFIO doesn't seem to be optimized for this sort of use case and
    generally expects a much larger granularity and defaults to 64K
    max DMA entries, so for a 16GB guest you need to configure VFIO
    with something like:

      vfio_iommu_type1.dma_entry_limit=4194304

    I didn't see any reason to suggest that's problematic but it
    makes we wonder if there's other stuff me might run into.

> if that's doable at all - how common are shared<->private flips, and is it
> feasible to change the IOMMU page tables every time?

- For OVMF+guest kernel that don't do lazy-acceptance:

  I think the bulk of the flipping is during boot where most of
  shared GPA ranges get converted to private memory, and then
  later on the guest kernel switches memory back to to shared
  for stuff like SWIOTLB, and after that I think DMA mappings
  would be fairly stable.

- For OVMF+guest kernel that support lazy-acceptance:

  The first 4GB get converted to private, and the rest remains
  shared until guest kernel needs to allocate memory from it.
  I'm not sure if SWIOTLB allocation is optimized to avoid
  unecessary flipping if it's allocated from that pool of
  still-shared memory, but normal/private allocations will
  result in a steady stream of DMA unmap operations as the
  guest faults in its working set.

> 
> If the real solution is SEV-TIO (which means essentially guest_memfd support
> for VFIO), calling ram_block_discard_require(true) may be the simplest
> stopgap solution.

Hard to guess how cloud vendors will feel about waiting for trusted I/O.
It does make sense in the context of CoCo to expect them to wait, but
would be nice to have a stop-gap to offer like disabling discard, since
it has minimal requirements on the QEMU/VFIO side and might be enough to
get early adopters up and running at least.

All that said, if you think something based around RamDiscardManager
seems tenable given all above then we can re-visit that approach as well.

-Mike

> 
> Paolo
> 
> >    - convert page shared->private
> >    - discard shared page
> >    - convert page private->shared
> >    - new page is allocated
> >    - issue DMA operations against that shared page
> > 
> > Address this by taking ram_block_discard_is_enabled() into account when
> > deciding whether or not to discard pages.
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >   accel/kvm/kvm-all.c | 8 ++++++--
> >   1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > index 53ce4f091e..6ae03c880f 100644
> > --- a/accel/kvm/kvm-all.c
> > +++ b/accel/kvm/kvm-all.c
> > @@ -2962,10 +2962,14 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
> >                   */
> >                   return 0;
> >               } else {
> > -                ret = ram_block_discard_range(rb, offset, size);
> > +                ret = ram_block_discard_is_disabled()
> > +                      ? ram_block_discard_range(rb, offset, size)
> > +                      : 0;
> >               }
> >           } else {
> > -            ret = ram_block_discard_guest_memfd_range(rb, offset, size);
> > +            ret = ram_block_discard_is_disabled()
> > +                  ? ram_block_discard_guest_memfd_range(rb, offset, size)
> > +                  : 0;
> >           }
> >       } else {
> >           error_report("Convert non guest_memfd backed memory region "
> 


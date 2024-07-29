Return-Path: <kvm+bounces-22530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B1DE9400DE
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 00:08:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E89EC1F2333E
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 22:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F260618EFC5;
	Mon, 29 Jul 2024 22:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="t6rxrE1U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2046.outbound.protection.outlook.com [40.107.236.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25AB18757E;
	Mon, 29 Jul 2024 22:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722290927; cv=fail; b=MQhjVXe1b40owhQqECzf6bUrK0RkSWGAmIe5Ig1UqCloJbdhbrliuKNivJUs+TPmnQ1h9WDXziRqmEEWIYx2R9ZrbG0aXukTnh7UN4jCkhbq/aqWNxCKKL+yTXfFHDG5FwMGosv8R7UT0/QmDu/R4GCL3VYUq/rilucf+QnyezU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722290927; c=relaxed/simple;
	bh=h/Jea3ba/siVbVzpVDiXOI+mHo/ShVR05rmYrt49Xug=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WP9CyLAev/HgxdamP8m/dLRq9a3jgi7bwYTxGglXgeTrXlAn9UGMeY3TCYhPEaUKc1IvGeIzco6SVLq7InPGXi5ZDU0hLawk8+tPlq3+4akwEYVang5iMzmMFQtTMaJ8Qe+z4REfT63z4cUcZlgHGQdMiUCVCsHx6Inc0T+2Hss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=t6rxrE1U; arc=fail smtp.client-ip=40.107.236.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=isbh/OZBD8oJnl/efj93jPJ0h9pbDise/W9YMmhtnk1ABbIvsTHKCxDIkt3J8HvcLtQ0rDhvp7Xao49VwpdIBihZEyxkq5ZGt+7CkMp5LK2fYjZDrWy7RwakK+XBeWg2mSKIBsXrk+tqG+06ZUXPuuox9PNBw9IFiqBj2/A+h2cxuAPX7XOMkWL1tdrXlEJHkmruMXmHdbdmlBSgutINnZtd012UIn0Z2P+sepOH/N45v7X4BYZeCI7TitJN7sEg1I/2x/KHvvz6rxSkFf9fpAWV5ag9H1GauTI94ZYpihTjsQai7ZFMweDYUA5L2ZEwuZ2k1i8Kmgu8FYjFLKCwaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W1UvtlIXz+cWcy/9ltuMe44PyswphSqZiwWNgStrAl4=;
 b=C3tLJpXem0a/5tK7F7hXQppTU7GOyydfngX0FFPJTbXh9Sg43XF7P2MK3Sw6z6AS8HOm9nRnA+INdEogp39Say66Pa8mo8zO/5ywUonfve2MI30/GjCraQwCTYw2Qwt46/YQGu85Qkd6/Qztl+Fj4xqd4sV6LVAb0PdqMpBQOCMNLGhsZO6yd6IQVtkAbWGt5BfzFXVQjWGaZqWE2odpZ+8WqLUbiqKMhz6Uz7lua/I2PexdeIBRjl38WSNuN/hyKvKmvzwuC9tIiBZtPh74U85gQNL1fdjPGh3KcDCfcEAKpuChaHRB+aQEWmXMhzvRsMzbp41SbXeC5+9GS8t0Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1UvtlIXz+cWcy/9ltuMe44PyswphSqZiwWNgStrAl4=;
 b=t6rxrE1UU2WhQPzDakVoS/K9Pq4K4Q3Dxq4OuBXVsXPsJ7MjwHw0ttnOy48rNq7ARfkGPATDqgIA8Bp8ODgC2qhjYRH0/4Lc3m4mXxJ1Ua2VtYnwz70rGjv83Mp6K9RHMna3+h23I+E2BkVeWBbqA1/pJtDaPVBcM8LCYAD3HBk=
Received: from CH2PR14CA0060.namprd14.prod.outlook.com (2603:10b6:610:56::40)
 by PH0PR12MB5646.namprd12.prod.outlook.com (2603:10b6:510:143::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.26; Mon, 29 Jul
 2024 22:08:40 +0000
Received: from CH2PEPF0000009F.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::ee) by CH2PR14CA0060.outlook.office365.com
 (2603:10b6:610:56::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.34 via Frontend
 Transport; Mon, 29 Jul 2024 22:08:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000009F.mail.protection.outlook.com (10.167.244.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Mon, 29 Jul 2024 22:08:40 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 29 Jul
 2024 17:08:40 -0500
Date: Mon, 29 Jul 2024 16:40:37 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH v2 07/14] KVM: guest_memfd: delay
 kvm_gmem_prepare_folio() until the memory is passed to the guest
Message-ID: <20240729214037.4m3ptinila3vnhmm@amd.com>
References: <20240726185157.72821-1-pbonzini@redhat.com>
 <20240726185157.72821-8-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240726185157.72821-8-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009F:EE_|PH0PR12MB5646:EE_
X-MS-Office365-Filtering-Correlation-Id: 66742e52-ff1c-4912-4100-08dcb01b00f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m6VUrCqVfxDE9IF/+QFkuHQtNbN73DwpoiKHLDEgvcQcd9YkuYTWInEkeYs8?=
 =?us-ascii?Q?04Up66574qKwq5/DN96B1ahpNOVHAjTEeiFcIJJuV8E0yAup0gtzNxQJxTQR?=
 =?us-ascii?Q?F/M33BzoWTU9D0+igtoFiCxkV1YsYGDyFbHZ8nyv0rFsf5nzryl1KLJpruGN?=
 =?us-ascii?Q?fV28IF0hnK8TOCUxqVPO/2FYRIIX4IG0DT/AuygPbCfldyKcSiTOw4XcqPY2?=
 =?us-ascii?Q?Mh6Z0f95S1X5+ZOAQIXQceGKN6wl+hPRp51cocOjC3vLOE9QQKGL2GI03OB6?=
 =?us-ascii?Q?zGyOLxoJ0as1FNcOZFtudpDGmuPGAQT1eFkvGic8t+FjdAI8n0JqIVJPaoU+?=
 =?us-ascii?Q?h+cAHI6oskXLKWKN6iMON1d5NjIc7kM9NKe7zgOBqqivpCGojLFNi97zs02S?=
 =?us-ascii?Q?LC51oGQQ6OJ/hlWeOgpVFXPvLLT2sWbRlO5zXgmLxv9LiaaE3SAQb2pKuCcq?=
 =?us-ascii?Q?yGyq2CRXuWA3WcXpgnkQd9HuVvEzRG3/r8fyuNA1fc/DDpdE+kdt5AqAWxfd?=
 =?us-ascii?Q?cQip7DK0aUNA5ezHc5rUGIECSzAS/VDu3s832CP2PaDJTiZTdbEB5JMoi7qJ?=
 =?us-ascii?Q?GczPAjSkSbwNr55hntHiPQYVty3/+b9EhE1bUbfapGg557W6gJf0gUZNq2+A?=
 =?us-ascii?Q?CX+cSRTIjp3CIhjkZIUfPQHkrrrUTfjf7Tv0r9rqwYwlagaOA7n/K9ufyMJ+?=
 =?us-ascii?Q?XezJOHcGd7M3YBqrBvJFhvao2EXqAbfaD4+doJrkgNfVRJPay1Qljm7BNQTn?=
 =?us-ascii?Q?uXODlRBy2Xxdz/giH6xE5VRKkI6lPDBNoJgBbRz/WXEDl0k4V6lnJkne/SVS?=
 =?us-ascii?Q?baybWnhIqr8GySEN6JseUhSzEZyYOvMOq6cusm8TD8jHZFflmrzf3LnPVn4r?=
 =?us-ascii?Q?hFtAqF/UxWebPQmyiYx5HkwTKQxVaKASGV+MLP02BWnJWt7lfYFSsz/KEkOL?=
 =?us-ascii?Q?vWb62ekVBn1T2CJkTOHYdneXNJTBDH0ArnC3W+pdI9dzLXoEE6cS1HdHknQw?=
 =?us-ascii?Q?AV+P+ayN654mxMWTYfFORyAdkBxNdEdcPYGxN8+OcmPQfQlIWPVMdwnwyk2u?=
 =?us-ascii?Q?cROMBDPiH50/oUYRl4YBnNlwkW8XOZAovm+VQZSk+AL9P1pJsNwwOpX9ecHF?=
 =?us-ascii?Q?MyB8HbrUjyICVXVqWBfvTNwMYb1x6wnNZKzpQm91VJ8EGc6QkBbZW/RpisXh?=
 =?us-ascii?Q?yQdHZqz+OgjezOJhRFUQlnPMbayX31caDPYDv18nB1nuslPub0PZWb80tQag?=
 =?us-ascii?Q?Vq5Vz+PdsX/SnNFA2qJveKPodATAqgZV/v86aFHxrdbH8l4s8BU4a5EZU/yh?=
 =?us-ascii?Q?TQYyMCkfYyZwMYOVn+SooBcoHWQujmoRXN3TwLWl/+d2rbV4WfuNDLhhFHAZ?=
 =?us-ascii?Q?VJvxe2VqyrnWKzNhAHQ2C/9mcSVGgLwg7MBt3TC5dDaW6qQUlghSVRTPNAb0?=
 =?us-ascii?Q?Kyh5ZMsTlaknO3WzdwqWprXFdX0uUBoU?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2024 22:08:40.5861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66742e52-ff1c-4912-4100-08dcb01b00f8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5646

On Fri, Jul 26, 2024 at 02:51:50PM -0400, Paolo Bonzini wrote:
> Initializing the contents of the folio on fallocate() is unnecessarily
> restrictive.  It means that the page is registered with the firmware and
> then it cannot be touched anymore.  In particular, this loses the
> possibility of using fallocate() to pre-allocate the page for SEV-SNP
> guests, because kvm_arch_gmem_prepare() then fails.
> 
> It's only when the guest actually accesses the page (and therefore
> kvm_gmem_get_pfn() is called) that the page must be cleared from any
> stale host data and registered with the firmware.  The up-to-date flag
> is clear if this has to be done (i.e. it is the first access and
> kvm_gmem_populate() has not been called).
> 
> All in all, there are enough differences between kvm_gmem_get_pfn() and
> kvm_gmem_populate(), that it's better to separate the two flows completely.
> Extract the bulk of kvm_gmem_get_folio(), which take a folio and end up
> setting its up-to-date flag, to a new function kvm_gmem_prepare_folio();
> these are now done only by the non-__-prefixed kvm_gmem_get_pfn().
> As a bonus, __kvm_gmem_get_pfn() loses its ugly "bool prepare" argument.
> 
> One difference is that fallocate(PUNCH_HOLE) can now race with a
> page fault.  Potentially this causes a page to be prepared and into the
> filemap even after fallocate(PUNCH_HOLE).  This is harmless, as it can be
> fixed by another hole punching operation, and can be avoided by clearing
> the private-page attribute prior to invoking fallocate(PUNCH_HOLE).
> This way, the page fault will cause an exit to user space.
> 
> The previous semantics, where fallocate() could be used to prepare
> the pages in advance of running the guest, can be accessed with
> KVM_PRE_FAULT_MEMORY.
> 
> For now, accessing a page in one VM will attempt to call
> kvm_arch_gmem_prepare() in all of those that have bound the guest_memfd.
> Cleaning this up is left to a separate patch.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/guest_memfd.c | 110 ++++++++++++++++++++++++-----------------
>  1 file changed, 66 insertions(+), 44 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 9271aba9b7b3..5af278c7adba 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -25,7 +25,7 @@ static inline kvm_pfn_t folio_file_pfn(struct folio *folio, pgoff_t index)
>  	return folio_pfn(folio) + (index & (folio_nr_pages(folio) - 1));
>  }
>  
> -static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
> +static int __kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
>  {
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
>  	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
> @@ -59,49 +59,63 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
>  	return 0;
>  }
>  
> -/* Returns a locked folio on success.  */
> -static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prepare)
> +/*
> + * Process @folio, which contains @gfn, so that the guest can use it.
> + * The folio must be locked and the gfn must be contained in @slot.
> + * On successful return the guest sees a zero page so as to avoid
> + * leaking host data and the up-to-date flag is set.
> + */
> +static int kvm_gmem_prepare_folio(struct file *file, struct kvm_memory_slot *slot,
> +				  gfn_t gfn, struct folio *folio)
>  {
> -	struct folio *folio;
> +	unsigned long nr_pages, i;
> +	pgoff_t index;
> +	int r;
>  
> -	/* TODO: Support huge pages. */
> -	folio = filemap_grab_folio(inode->i_mapping, index);
> -	if (IS_ERR(folio))
> -		return folio;
> +	if (folio_test_uptodate(folio))
> +		return 0;
> +
> +	nr_pages = folio_nr_pages(folio);
> +	for (i = 0; i < nr_pages; i++)
> +		clear_highpage(folio_page(folio, i));
>  
>  	/*
> -	 * Use the up-to-date flag to track whether or not the memory has been
> -	 * zeroed before being handed off to the guest.  There is no backing
> -	 * storage for the memory, so the folio will remain up-to-date until
> -	 * it's removed.
> +	 * Preparing huge folios should always be safe, since it should
> +	 * be possible to split them later if needed.
>  	 *
> -	 * TODO: Skip clearing pages when trusted firmware will do it when
> -	 * assigning memory to the guest.
> +	 * Right now the folio order is always going to be zero, but the
> +	 * code is ready for huge folios.  The only assumption is that
> +	 * the base pgoff of memslots is naturally aligned with the
> +	 * requested page order, ensuring that huge folios can also use
> +	 * huge page table entries for GPA->HPA mapping.
> +	 *
> +	 * The order will be passed when creating the guest_memfd, and
> +	 * checked when creating memslots.
>  	 */
> -	if (!folio_test_uptodate(folio)) {
> -		unsigned long nr_pages = folio_nr_pages(folio);
> -		unsigned long i;
> -
> -		for (i = 0; i < nr_pages; i++)
> -			clear_highpage(folio_page(folio, i));
> -	}
> -
> -	if (prepare) {
> -		int r =	kvm_gmem_prepare_folio(inode, index, folio);
> -		if (r < 0) {
> -			folio_unlock(folio);
> -			folio_put(folio);
> -			return ERR_PTR(r);
> -		}
> +	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));

For this patchset, I think the WARN_ON() is appropriate since without
mapping_set_large_folios() we'd only ever expect 4K pages, in which
case gmem.pgoff would necessarilly be naturally-aligned to 4K and
it'll be good to notice if that unexpectedly changes.

However, it's worth noting now that that likely will change once THP
is enabled, since QEMU will generally set gmem.pgoff to be the same
as slot.base_gfn rather than doing any sort of padding out.

For instance, filemap considers gmem.pgoff=0 to be the start of the
virtual range it backs, and will allocate large folio's on
2MB-aligned gmem.pgoff values. However, QEMU might align some slots
on non-2MB-aligned gmem.pgoff boundaries to handle things like legacy
regions. E.g., the following example:

  kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x0 gpa=0x0 size=0x0 ua=0x7fc257e00000 guest_memfd=19 guest_memfd_offset=0x0 ret=0
  kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0xc0000 ua=0x7fc257e00000 guest_memfd=19 guest_memfd_offset=0x0 ret=0
  kvm_set_user_memory AddrSpace#0 Slot#3 flags=0x4 gpa=0xc0000 size=0x20000 ua=0x7fc06de00000 guest_memfd=534 guest_memfd_offset=0x0 ret=0
  kvm_set_user_memory AddrSpace#0 Slot#4 flags=0x4 gpa=0xe0000 size=0x7ff20000 ua=0x7fc257ee0000 guest_memfd=19 guest_memfd_offset=0xe0000 ret=0

will result in everything at GFN 0xe0 and up (slot 4) being associated
with a gmem.pgoff value of 0xe0, so it will always fail the WARN_ON().
But:

  a) GFN 0xe0 might still be backed by a large folio that's rooted at
     gmem.pgoff==0. It's still technically possible to prepare the
     entire 2MB folio in the RMP table/etc., since KVM MMU will split
     the NPT mapping and trigger an RMP #PF to psmash the 2MB RMP
     entry if necessary.
  b) GFN 0x200 and up could still be backed by large folios even
     though they'd trigger this WARN_ON().

Once we move to more granular per-4K tracking rather than per-folio
tracking I think a lot of this nuance goes away however (or maybe
requires some re-thinking), so probably makes sense to revisit in
the context of that work, but I thought it was worth mentioning.

Reviewed-by: Michael Roth <michael.roth@amd.com>


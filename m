Return-Path: <kvm+bounces-21794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E8F5934445
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 23:54:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 314CC1C20C76
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 21:54:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6C23187878;
	Wed, 17 Jul 2024 21:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UMz3lbM3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2082.outbound.protection.outlook.com [40.107.236.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39EF4688;
	Wed, 17 Jul 2024 21:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721253247; cv=fail; b=efkpNkcqj5gCE7UQujXUDPCV6BSxyMt89pDkL0JPwxxMjiuH49xRdwmjOmH7VqdVEeSaqSicwvj1PcZ/kAX+ecxP/VqhOJfMmvccGAo3m9WdkZZHnzX/Wn26bOZQPXsyEHlv3fuqWCeKnqiWKRzbyPeKAbpRba3ckBBRHRFUrBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721253247; c=relaxed/simple;
	bh=CgYOqED6A5NDioGJrNflfxHYGx4O8DYowZLueda4DmY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+inOILuz9s+kn+bETvh2O8JuTvgdmLaCfNh4QpIjXHehxOPIjT+mEzfnocGSmiQvlTbhznFIi+bu43qEkxw1PCgw9jHwweHkePQAkP7dxd9c3MkqEfA3juBgZZ7V4ryAxUWxmKWbAQxQmdoZBO+TMMGFpi/MPNO2Xl3dUzue2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UMz3lbM3; arc=fail smtp.client-ip=40.107.236.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yw+lXqYRU5QKrCn5Yip3ynqYUouR2Q38zvA1DqPdUlTR2tJY59oBl7bl+7vLh98oVp+MxU5c0Dvxh3n7/aNKs1A038FUYEF2lOBdcFxpmJYH8/SXYqlTlOv5wJCG+iL7C7ggbT3qw22IR3UuOCMbQTuQtTtFJjLBDj71hjeHiQ1Xjjg/kj5M7pbL7eraWxvnNpIcA8KlicYqs3LYmfEAicOZzurUrz1LeLTX2sltVvMXq2qU6vXm53JBZWA/iAj1wqk1q05my43cho+3034JsRwfTtIpawbX5e97v5G5RKS6DyXWjekVckULBQof9nvSzlfvsjB1+Abi96fb/M+ZYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DQPAdKMruIN/YIttKIp9hMaw1hu+W/0zkca4kq7Y4NQ=;
 b=iXNjcaV08UIC87AqxvYgxerSfBYJjvKjl9msHL4k88mExP9Kc6RM+RgItf389VvhUMHq/yVcEuESTM6FXB7fLZm7m6MeCRK8sOy4QbuQarVWH7G+5pfNGplo/7pMFRtfwyDFrotRrgPdkplf0aG190X3Z4ObbxuLj6NqPVfNSf3SFMXvZEh73/X4xsTPDO0b3wFWb80Qs0kRXFAIOLY93rBCad/fGZJhSoJAwil9YYe5UOdTBQs8nhiJ2qOHg2CvG5kMto+NR3VLAzBAzy3+mC6Xm0PuITANavP7BDEe7m8MfXGROV8stfh0PY6EFL9hGKWKzISTiInvBGROnNtFwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQPAdKMruIN/YIttKIp9hMaw1hu+W/0zkca4kq7Y4NQ=;
 b=UMz3lbM3HunVIMD5oWTpBkCN2603CoeUdSzd/yGwUt/7sff0ODdmEeumMWniAR+XUn1YmqSL8iVvz/DMxhD4Xl5n1Y2pIoJgKk5lfFkS/054d+YoMZ/3EPF4HtARTN0ESwy9UQx4Dy+WE+6vTtzg4sCiIPrkSF6rs4/GXwLQ6Rw=
Received: from BN9PR03CA0868.namprd03.prod.outlook.com (2603:10b6:408:13d::33)
 by MW6PR12MB8757.namprd12.prod.outlook.com (2603:10b6:303:239::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Wed, 17 Jul
 2024 21:53:58 +0000
Received: from BN1PEPF00006000.namprd05.prod.outlook.com
 (2603:10b6:408:13d:cafe::e2) by BN9PR03CA0868.outlook.office365.com
 (2603:10b6:408:13d::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.18 via Frontend
 Transport; Wed, 17 Jul 2024 21:53:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00006000.mail.protection.outlook.com (10.167.243.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Wed, 17 Jul 2024 21:53:58 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 17 Jul
 2024 16:53:57 -0500
Date: Wed, 17 Jul 2024 16:28:57 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 06/12] KVM: guest_memfd: delay kvm_gmem_prepare_folio()
 until the memory is passed to the guest
Message-ID: <20240717212857.2ymcgikwn6rbulxp@amd.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-7-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240711222755.57476-7-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006000:EE_|MW6PR12MB8757:EE_
X-MS-Office365-Filtering-Correlation-Id: d61a7c4f-a426-4200-6149-08dca6aaf5f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Btr2x+ATsJJMGLEjXGz3PWAKV/PQ7fK8a4QVAREjTbCeYyZfsf5ai+1Z1Zia?=
 =?us-ascii?Q?LKRU1kgYMTEbNT3Hkxb020/vV+AXlSG0B+UXNPR/jGp03conBbapaqBsxsF0?=
 =?us-ascii?Q?zLc1SRXIwfuKy4gbcTyJf8fvUP8W/VbkUw0zK+b+wT1FaWyTr1fykj+RU8a1?=
 =?us-ascii?Q?CRUz2wqm7mlUUOGayQUq5/hYJX7nl1Xijkj+iGq9Wh6tGPwDQyWQt4S2BRcm?=
 =?us-ascii?Q?3Mh85WwHfaLRXCyCxZOgS+14hnBrGO57Z5MHItrFTAlxaO4p+dYB+AlErly1?=
 =?us-ascii?Q?FEPixv1QpWLPuqeWav51vvXMv/MKf/mFBCMCnY7n590iCh0CDoPjAqFtQ6sX?=
 =?us-ascii?Q?sLczPSpPJ6iWdN6Zql/JrNXijALI4oZafwru0vBF0zQwSjvlDpjUKRqd/650?=
 =?us-ascii?Q?/+hnrG1SBmEJVqZnj3YsscrkYpmRKir2xVWksP4f/mH+xPzsTZpefQTziLdZ?=
 =?us-ascii?Q?6ZPy7zCdn4YZqH6TuoA+2LrKwDoMOZEm3nYNweh/PZxKU9rJr1NlVwcHTKMR?=
 =?us-ascii?Q?tzcXah9hQVNqEJhfQZeHeLP0m0MZYD8dROT7Eu/6ntidbeKb6tTUO8Z1RrpK?=
 =?us-ascii?Q?ixYqxQHsTnXwxVj8kmxyKzZyl5761rvyUzVjzJRz9i865tZN8sgLAw71V0r2?=
 =?us-ascii?Q?/Tov1gQBxc3jRnsndBOv640T0I9i7FdFjL9JO1eF1c6i73GfDjxFsMHQBcjV?=
 =?us-ascii?Q?r0ncmKsYPB9opMT7PZahEKG/+vLV1rfKzuE5pVq/H49SYhfGx0zX1jXXo6qN?=
 =?us-ascii?Q?MV3Mnac89l4+L7f/TxYRbeONkUZkiV8YYJ5jNqjxNvgOJ48W6H+xwMIVF6gx?=
 =?us-ascii?Q?22N4RTieDi50DpgUM4ERJx7IWrKVJncn6vuZprPLnmLyPyxpy76+MvPOLNAz?=
 =?us-ascii?Q?2GzZnDzqW7g2Q6bGs05+0Hz9prRlFskqMEDuAt6HigWbn0o7+9H6U2hm6wWS?=
 =?us-ascii?Q?oZ4Q5yWf8BPebot4SpN+ZwOfqfP5lze88KyA1wS+5diMZsE1UAGuLVi4gI5i?=
 =?us-ascii?Q?hMEpFKTlkMgwTnd6vIx1Zt6Es1lwe3L4bbBvW0ods+9rBvuovu4VUEf+bxg3?=
 =?us-ascii?Q?WA+G1tvwZD1zfqscNjqws1CGcS22NjFEW7n9h1weoz7ca/ViXGdnOzIBUW4o?=
 =?us-ascii?Q?nud3FeZmmJH42xuPXvM3dd4wjjxqpvzqE8lbR2FgstR2VVXZOq78l6Ca4w3M?=
 =?us-ascii?Q?8A1Y5CIrlLZ5f8gDm7gQ+QzcC/vgztjGnK6nE24A21eTdsQR8VgiliXGVIP9?=
 =?us-ascii?Q?T0vOFgMJjCAK4sWNK0LiJNSkKpPEPcrNOMtzouPfKqOcVBvbig/Vp716iLPo?=
 =?us-ascii?Q?QU4mniXr6+iQ+5u0ae0t7fbD282QZjq4ZmjmGLLXGdw6L0+kPRO8jDjTmT4c?=
 =?us-ascii?Q?rhBdSFhVZbqrN9QnVCGnjG+0gCd0aolVA7PU0comPmcy7aAKKw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 21:53:58.0267
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d61a7c4f-a426-4200-6149-08dca6aaf5f7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006000.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8757

On Thu, Jul 11, 2024 at 06:27:49PM -0400, Paolo Bonzini wrote:
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
>  virt/kvm/guest_memfd.c | 107 ++++++++++++++++++++++++-----------------
>  1 file changed, 63 insertions(+), 44 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 9271aba9b7b3..f637327ad8e1 100644
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
> @@ -59,49 +59,60 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
>  	return 0;
>  }
>  
> -/* Returns a locked folio on success.  */
> -static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prepare)
> +/* Process @folio, which contains @gfn (which in turn is contained in @slot),

Need a line break after "/*"

> + * so that the guest can use it.  On successful return the guest sees a zero
> + * page so as to avoid leaking host data and the up-to-date flag is set.

Might be worth noting that the folio must be locked so that the
up-to-date flag can be read/set. Or maybe WARN_ONCE() just to avoid any
subtle races slipping in.

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
> +	 * Right now the folio order is always going to be zero,
> +	 * but the code is ready for huge folios, the only
> +	 * assumption being that the base pgoff of memslots is
> +	 * naturally aligned according to the folio's order.
> +	 * The desired order will be passed when creating the
> +	 * guest_memfd and checked when creating memslots.
>  	 *
> -	 * TODO: Skip clearing pages when trusted firmware will do it when
> -	 * assigning memory to the guest.
> +	 * By making the base pgoff of the memslot naturally aligned
> +	 * to the folio's order, huge folios are safe to prepare, no
> +	 * matter what page size is used to map memory into the guest.
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
> +	index = gfn - slot->base_gfn + slot->gmem.pgoff;
> +	index = ALIGN_DOWN(index, 1 << folio_order(folio));

I think, when huge folio support is added, we'd also need to make sure
that the huge folio is completely contained within the GPA range
covered by the memslot. For instance, Sean's original THP patch does
this to ensure the order that KVM MMU uses does not result in it
trying to map GFNs beyond the end of the memslot:

  @@ -533,9 +577,24 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
   	page = folio_file_page(folio, index);
   
   	*pfn = page_to_pfn(page);
  -	if (max_order)
  +	if (!max_order)
  +		goto success;
  +
  +	*max_order = compound_order(compound_head(page));
  +	if (!*max_order)
  +		goto success;
  +
  +	/*
  +	 * The folio can be mapped with a hugepage if and only if the folio is
  +	 * fully contained by the range the memslot is bound to.  Note, the
  +	 * caller is responsible for handling gfn alignment, this only deals
  +	 * with the file binding.
  +	 */
  +	huge_index = ALIGN(index, 1ull << *max_order);
  +	if (huge_index < ALIGN(slot->gmem.pgoff, 1ull << *max_order) ||
  +	    huge_index + (1ull << *max_order) > slot->gmem.pgoff + slot->npages)
   		*max_order = 0;

  https://lore.kernel.org/kvm/20231027182217.3615211-1-seanjc@google.com/T/#mccbd3e8bf9897f0ddbf864e6318d6f2f208b269c

so maybe we'd want to similarly limit the order that
kvm_gmem_prepare_folio() ends up using to match up with that...

...but maybe it's not necessary. I don't think this causes any
problems currently: if a 2nd memslot, e.g.:

       ________________________
      |Slot2       |Slot1      |
      |------------|-----------|
  GPA |4MB         |2.5MB      |0MB
      +------------+-----------+

overlaps with a folio allocated for another memslot using that same
gmemfd, and the pages are already in a prepared state, then it's
fair to skip re-preparing the range. As long as KVM MMU does not
create mappings for GFN ranges beyond the end of the memslot (e.g.
via the above snippet from Sean's patch), then the guest will
naturally end up with 4K mappings for the range in question, which
will trigger an RMP #NPF which will get quickly resolved with a
PSMASH to split the 2MB RMP entry if some other slot trigger the
preparation of the folio.

With mapping_large_folio_support() not being set yet these conditions
are always met, but when it gets enabled we'd need the above logic
to limit the max_order passed to KVM MMU, so it might make sense to
add a comment on that.

Looks good otherwise.

-Mike

>  
> +	r = __kvm_gmem_prepare_folio(file_inode(file), index, folio);
> +	if (!r)
>  		folio_mark_uptodate(folio);
> -	}
>  
> -	/*
> -	 * Ignore accessed, referenced, and dirty flags.  The memory is
> -	 * unevictable and there is no storage to write back to.
> -	 */
> -	return folio;
> +	return r;
> +}
> +
> +/*
> + * Returns a locked folio on success.  The caller is responsible for
> + * setting the up-to-date flag before the memory is mapped into the guest.
> + * There is no backing storage for the memory, so the folio will remain
> + * up-to-date until it's removed.
> + *
> + * Ignore accessed, referenced, and dirty flags.  The memory is
> + * unevictable and there is no storage to write back to.
> + */
> +static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
> +{
> +	/* TODO: Support huge pages. */
> +	return filemap_grab_folio(inode->i_mapping, index);
>  }
>  
>  static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
> @@ -201,7 +212,7 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
>  			break;
>  		}
>  
> -		folio = kvm_gmem_get_folio(inode, index, true);
> +		folio = kvm_gmem_get_folio(inode, index);
>  		if (IS_ERR(folio)) {
>  			r = PTR_ERR(folio);
>  			break;
> @@ -555,7 +566,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>  /* Returns a locked folio on success.  */
>  static struct folio *
>  __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
> -		   gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prepare)
> +		   gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
>  {
>  	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
>  	struct kvm_gmem *gmem = file->private_data;
> @@ -572,7 +583,7 @@ __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
>  		return ERR_PTR(-EIO);
>  	}
>  
> -	folio = kvm_gmem_get_folio(file_inode(file), index, prepare);
> +	folio = kvm_gmem_get_folio(file_inode(file), index);
>  	if (IS_ERR(folio))
>  		return folio;
>  
> @@ -594,17 +605,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  {
>  	struct file *file = kvm_gmem_get_file(slot);
>  	struct folio *folio;
> +	int r = 0;
>  
>  	if (!file)
>  		return -EFAULT;
>  
> -	folio = __kvm_gmem_get_pfn(file, slot, gfn, pfn, max_order, true);
> -	fput(file);
> -	if (IS_ERR(folio))
> -		return PTR_ERR(folio);
> +	folio = __kvm_gmem_get_pfn(file, slot, gfn, pfn, max_order);
> +	if (IS_ERR(folio)) {
> +		r = PTR_ERR(folio);
> +		goto out;
> +	}
>  
> +	r = kvm_gmem_prepare_folio(file, slot, gfn, folio);
>  	folio_unlock(folio);
> -	return 0;
> +	if (r < 0)
> +		folio_put(folio);
> +
> +out:
> +	fput(file);
> +	return r;
>  }
>  EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
>  
> @@ -643,7 +662,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  			break;
>  		}
>  
> -		folio = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &max_order, false);
> +		folio = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &max_order);
>  		if (IS_ERR(folio)) {
>  			ret = PTR_ERR(folio);
>  			break;
> -- 
> 2.43.0
> 
> 
> 


Return-Path: <kvm+bounces-21466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47A4192F47F
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 05:51:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05E172832CF
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 03:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 207D711CAF;
	Fri, 12 Jul 2024 03:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ATqS7REA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E714101C5;
	Fri, 12 Jul 2024 03:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720756286; cv=fail; b=TfBimODUcdG9JLcBB+jFtP4Ohyp7bo0o5EwVIhDlouiRCrrRVYWj06H0PtQgLr8jNnmP3GVh8GknFKC4EAvBb8HN5yJaivCZicBgZCwCTYGZjrqlJ/BOsMa8iSnQWJSkQmd0MT/T5vAvMxFT5NOtM/p7FQq9LvI5IhBkQZuLfXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720756286; c=relaxed/simple;
	bh=Xu+gnozfrdV7mjqKui39dTOlNTUKJkPjYXW+WrTQUvI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ac+b1KPe5ge+6qetDYLCNahSvw1QHZpFLE1V60iIF4ZhsxnKwEeUjEm5RIgA3JW6JGCey5A1XWaLqHU8lSQw32TmPOSvZ2hWk/O4pBOAhbdCyX+Sf16UlJTNb+R6WCM2jc/2Q7kStOYGpISq5yAFG9r0pMbwKvm7heggkXj7Dkk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ATqS7REA; arc=fail smtp.client-ip=40.107.223.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iizTXMgrYurhxN5nGfE0Wfp167MJDou1ARq9qLfNP4aTDwoIeQhFz5b72rDfYEmiZ2D3QdqRaAnYJVaR7JonPFt3cwMV4ylcAM+qYQ1qNbfBBCGJgmsBL7TIK9uHruxdxMJa+fenjX1WWO/3wdWvp4G1uENjaCLY3SDyNwVHDxcUvDdEP9HItNkuzRmhLyRM0RRihEOxdQiSIpAU9eMayrzP8/v1CpPpEQPVzTZmtizLFtL5+V9AFEmq5Z9Kyi44fiud7lAYkYEqXBjYPpEls6qz8iCTAUH7hWtnf14LbY0uZVZlv+pFQ5z97Jyspig5pfO0FImmBllgZK3YN554JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SDGANwTbpgKrfggEZLCeMtNnmvMKXTwbJ79Y8cQQRIw=;
 b=FYI6XP+Ye92xJ6im9/r4fEJjTiwLWv9tnVbyfGfLFe08+nvwCCjgVzs142pGpuEWZm139GTQLkWB2fIXCMwGASM7eck7WOHSUUyiyWXqfqyEGXw+UutAYEoAJg7C/SWs3thArAUa8+usovyJkcjLWB0GBjqNCiRfBQbUlvEs6C2hl5FCPqquY4fndPb2M8zGvkquH05haNlBL6KdwEqA7qLawGZUy6WnbvGEh0E/vlnPgXWCA09i7JofeQxp6p8WZJwxWTkCwy9dOUtchujRQoLDvnz+ohmtpZJ6UI/oSb1bmm9/nVBdpTCoib+lGQ0JVCLJd+F0HdSpKEY5lie4lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDGANwTbpgKrfggEZLCeMtNnmvMKXTwbJ79Y8cQQRIw=;
 b=ATqS7REAfHNoagH+ZTQv+2we8fGJEEqO0MM/hsuJaUHG4GItxUX0QxfYwlKn+r9AjUkQbphYYgqiPqTrA0ISg+uwvHbaz2HReRqw07W+im6r+ySZuryFljMerMEcFHfBq60cDnrB0lNzuJvkI1m+qleeUd03ZjJPOEchb00SQ1g=
Received: from CH5P222CA0018.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::29)
 by IA0PR12MB8087.namprd12.prod.outlook.com (2603:10b6:208:401::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23; Fri, 12 Jul
 2024 03:51:21 +0000
Received: from CH2PEPF00000142.namprd02.prod.outlook.com
 (2603:10b6:610:1ee:cafe::96) by CH5P222CA0018.outlook.office365.com
 (2603:10b6:610:1ee::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23 via Frontend
 Transport; Fri, 12 Jul 2024 03:51:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000142.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7762.17 via Frontend Transport; Fri, 12 Jul 2024 03:51:20 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 11 Jul
 2024 22:51:19 -0500
Date: Thu, 11 Jul 2024 22:51:02 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <vbabka@suse.cz>,
	<david@redhat.com>, <seanjc@google.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH] mm, virt: merge AS_UNMOVABLE and AS_INACCESSIBLE
Message-ID: <lbnfhvqkofcbpneoduic3bfitbpzkh275zuajvlzkewp26e5to@b3gt4k6ekklr>
References: <20240711180305.15626-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240711180305.15626-1-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000142:EE_|IA0PR12MB8087:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aba0a19-898e-4d47-9142-08dca225e478
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3aUFEemkj5Br9ADlRpAClsGycX1DlV7okJ3cN3QWB46jETvRnQSqwGDXUS1d?=
 =?us-ascii?Q?FP9eMSDBx+b1Of7CPpSAhBfL+I9UUvqN7Po/w5/L3Pt5UuFFH2aprVExdBeJ?=
 =?us-ascii?Q?hg6S13IWfD+L4I2WK2quN8G22CYg0zJI+r2RQm25vL3fuUD73NGiNwbTxgCp?=
 =?us-ascii?Q?8589lRet/iPfKjLBFsRvvtWfct5hTeBhro+Aoan0vCoFmQyOoBeqPFVOXt0z?=
 =?us-ascii?Q?5jVEN91u0vHRlikZZh0lVpeiPPkLqTFUie3iuj4/ReQ3q+TG10ndeDdl74/r?=
 =?us-ascii?Q?eMPoKdzgsPffEW9yAE09SCC+3StRmH2UzcMr9lpQwU+rwrf6bzkIzzqNw8NY?=
 =?us-ascii?Q?r56jHvhSugSLVfORMvBl91uPed7467cK9T7pIFzFmRtyH2Na4x3jOL+QpMCb?=
 =?us-ascii?Q?V8kFDLI+1syw9qsgmZts69v0jLUrI90auveD0YzXGXL/sTPM1qMK3pyK5e3C?=
 =?us-ascii?Q?34riHWslcX/k4HH31PH3QsAWfNCUmiMthfeK25QT13qwvUO5erg6/awYlCED?=
 =?us-ascii?Q?Y4iwlciVNW24aCUS9B+f8ogQCgyXU+d0lMozm09DPHCfUlpmL5KJiaod6FZ+?=
 =?us-ascii?Q?eXH72pKBj/JgfImQ6EnkNWS11JJmHhoag/A6d9UCHGDIkyQlioekjO60Cd/r?=
 =?us-ascii?Q?Ji5jNYJFbHJ9JV8dGAGqti5i0y95TUKeBkmwgt6g52ugQWKAyYWj6N3znmRL?=
 =?us-ascii?Q?iYIQv0SUq8fHoXKd7m/+ATGBMlDya8jA80yU4muiyuxEawnf/WFMGVH+I1CT?=
 =?us-ascii?Q?VDLKo//DVA51SsC1emxswWK2tZiJWDXlEDF4dLVGpQEFWfUAZ74NZNJzdrQ7?=
 =?us-ascii?Q?1EBVmufcEDL4miHyot29NE+rDm3tdayZMPoaOg2ICtxiOouXjUANQ/NzqA7+?=
 =?us-ascii?Q?342s7nlPg3HTx7681gg9duic0C84KiX7zG3BSFp1VIVX9/FJkO9Y29EkVVki?=
 =?us-ascii?Q?Gyqhs4vbEozYtVHK34oyM9mpm7CbxPIhkWcExcyVCcHMTyHBYKlAxD6N5r5q?=
 =?us-ascii?Q?ssmictpK4CMnJk+9auYZ1GfqZ/cDIAmBPiKbaAjfUDvc+uMOordhjbvW8ipY?=
 =?us-ascii?Q?g7UGnc3fkyhLvQ31GV3vdpfydpI/cHdmTOyjtfh4Xt88j7rB7MjShMjm1SZJ?=
 =?us-ascii?Q?en75fpeq9R+1VtYafQ79GnB82bORsldgU2mipTzARESBjSnGEHeNRpq5cCgs?=
 =?us-ascii?Q?xeb1cajuoXH6K1uvIQUgRzhL87ED1aT1FjYo4tkuPyE7YM2b6rM5WVcfcE8z?=
 =?us-ascii?Q?9HSaOrzRf1w46dbVA4+2rdftbUmvXvGXFuxa8VRhtrOYABFp07n1gCOv61gE?=
 =?us-ascii?Q?nVfRnYmqv5C5seI511gd5NvC6QcMzzTXzP9JFzrhBG0c07atXkKy20xHbU2U?=
 =?us-ascii?Q?8WoHkK1asQLXGG/3/kUfdWpMA3E9JeERN3dGhqrdF/orDtJHZCwrQjzvsARd?=
 =?us-ascii?Q?FgTUemwDPWgtRZg+5FsSm4JMZDBpgiPw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2024 03:51:20.9582
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aba0a19-898e-4d47-9142-08dca225e478
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000142.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8087

On Thu, Jul 11, 2024 at 02:03:05PM -0400, Paolo Bonzini wrote:
> The flags AS_UNMOVABLE and AS_INACCESSIBLE were both added just for guest_memfd;
> AS_UNMOVABLE is already in existing versions of Linux, while AS_INACCESSIBLE was
> acked for inclusion in 6.11.
> 
> But really, they are the same thing: only guest_memfd uses them, at least for
> now, and guest_memfd pages are unmovable because they should not be
> accessed by the CPU.
> 
> So merge them into one; use the AS_INACCESSIBLE name which is more comprehensive.
> At the same time, this fixes an embarrassing bug where AS_INACCESSIBLE was used
> as a bit mask, despite it being just a bit index.
> 
> The bug was mostly benign, becaus AS_INACCESSIBLE's bit representation (1010)
> corresponded to setting AS_UNEVICTABLE (which is already set) and AS_ENOSPC
> (except no async writes can happen on the guest_memfd).  So the AS_INACCESSIBLE
> flag simply had no effect.

*facepalm*. Thank you for catching this.

> 
> Fixes: 1d23040caa8b ("KVM: guest_memfd: Use AS_INACCESSIBLE when creating guest_memfd inode")
> Fixes: c72ceafbd12c ("mm: Introduce AS_INACCESSIBLE for encrypted/confidential memory")
> Cc: linux-mm@kvack.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I re-tested the AS_INACCESSIBLE handling with SNP. I also tested with
Sean's patch that enables THP support in gmem to test it since that was
the more problematic case.

Tested-by: Michael Roth <michael.roth@amd.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>

> ---
>  include/linux/pagemap.h | 14 +++++++-------
>  mm/compaction.c         | 12 ++++++------
>  mm/migrate.c            |  2 +-
>  mm/truncate.c           |  2 +-
>  virt/kvm/guest_memfd.c  |  3 +--
>  5 files changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index ce7bac8f81da..e05585eda771 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -208,8 +208,8 @@ enum mapping_flags {
>  	AS_RELEASE_ALWAYS,	/* Call ->release_folio(), even if no private data */
>  	AS_STABLE_WRITES,	/* must wait for writeback before modifying
>  				   folio contents */
> -	AS_UNMOVABLE,		/* The mapping cannot be moved, ever */
> -	AS_INACCESSIBLE,	/* Do not attempt direct R/W access to the mapping */
> +	AS_INACCESSIBLE,	/* Do not attempt direct R/W access to the mapping,
> +				   including to move the mapping */
>  };
>  
>  /**
> @@ -310,20 +310,20 @@ static inline void mapping_clear_stable_writes(struct address_space *mapping)
>  	clear_bit(AS_STABLE_WRITES, &mapping->flags);
>  }
>  
> -static inline void mapping_set_unmovable(struct address_space *mapping)
> +static inline void mapping_set_inaccessible(struct address_space *mapping)
>  {
>  	/*
> -	 * It's expected unmovable mappings are also unevictable. Compaction
> +	 * It's expected inaccessible mappings are also unevictable. Compaction
>  	 * migrate scanner (isolate_migratepages_block()) relies on this to
>  	 * reduce page locking.
>  	 */
>  	set_bit(AS_UNEVICTABLE, &mapping->flags);
> -	set_bit(AS_UNMOVABLE, &mapping->flags);
> +	set_bit(AS_INACCESSIBLE, &mapping->flags);
>  }
>  
> -static inline bool mapping_unmovable(struct address_space *mapping)
> +static inline bool mapping_inaccessible(struct address_space *mapping)
>  {
> -	return test_bit(AS_UNMOVABLE, &mapping->flags);
> +	return test_bit(AS_INACCESSIBLE, &mapping->flags);
>  }
>  
>  static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
> diff --git a/mm/compaction.c b/mm/compaction.c
> index e731d45befc7..714afd9c6df6 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1172,22 +1172,22 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  		if (((mode & ISOLATE_ASYNC_MIGRATE) && is_dirty) ||
>  		    (mapping && is_unevictable)) {
>  			bool migrate_dirty = true;
> -			bool is_unmovable;
> +			bool is_inaccessible;
>  
>  			/*
>  			 * Only folios without mappings or that have
>  			 * a ->migrate_folio callback are possible to migrate
>  			 * without blocking.
>  			 *
> -			 * Folios from unmovable mappings are not migratable.
> +			 * Folios from inaccessible mappings are not migratable.
>  			 *
>  			 * However, we can be racing with truncation, which can
>  			 * free the mapping that we need to check. Truncation
>  			 * holds the folio lock until after the folio is removed
>  			 * from the page so holding it ourselves is sufficient.
>  			 *
> -			 * To avoid locking the folio just to check unmovable,
> -			 * assume every unmovable folio is also unevictable,
> +			 * To avoid locking the folio just to check inaccessible,
> +			 * assume every inaccessible folio is also unevictable,
>  			 * which is a cheaper test.  If our assumption goes
>  			 * wrong, it's not a correctness bug, just potentially
>  			 * wasted cycles.
> @@ -1200,9 +1200,9 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  				migrate_dirty = !mapping ||
>  						mapping->a_ops->migrate_folio;
>  			}
> -			is_unmovable = mapping && mapping_unmovable(mapping);
> +			is_inaccessible = mapping && mapping_inaccessible(mapping);
>  			folio_unlock(folio);
> -			if (!migrate_dirty || is_unmovable)
> +			if (!migrate_dirty || is_inaccessible)
>  				goto isolate_fail_put;
>  		}
>  
> diff --git a/mm/migrate.c b/mm/migrate.c
> index dd04f578c19c..50b60fb414e9 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -965,7 +965,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>  
>  		if (!mapping)
>  			rc = migrate_folio(mapping, dst, src, mode);
> -		else if (mapping_unmovable(mapping))
> +		else if (mapping_inaccessible(mapping))
>  			rc = -EOPNOTSUPP;
>  		else if (mapping->a_ops->migrate_folio)
>  			/*
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 60388935086d..581977d2356f 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -233,7 +233,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  	 * doing a complex calculation here, and then doing the zeroing
>  	 * anyway if the page split fails.
>  	 */
> -	if (!(folio->mapping->flags & AS_INACCESSIBLE))
> +	if (!mapping_inaccessible(folio->mapping))
>  		folio_zero_range(folio, offset, length);
>  
>  	if (folio_has_private(folio))
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 9148b9679bb1..1c509c351261 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -416,11 +416,10 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	inode->i_private = (void *)(unsigned long)flags;
>  	inode->i_op = &kvm_gmem_iops;
>  	inode->i_mapping->a_ops = &kvm_gmem_aops;
> -	inode->i_mapping->flags |= AS_INACCESSIBLE;
>  	inode->i_mode |= S_IFREG;
>  	inode->i_size = size;
>  	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> -	mapping_set_unmovable(inode->i_mapping);
> +	mapping_set_inaccessible(inode->i_mapping);
>  	/* Unmovable mappings are supposed to be marked unevictable as well. */
>  	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>  
> -- 
> 2.43.0
> 


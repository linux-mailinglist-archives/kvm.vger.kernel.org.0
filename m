Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F637ABBEC
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 00:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjIVWmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 18:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjIVWmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 18:42:44 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A86419A;
        Fri, 22 Sep 2023 15:42:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFri7Z8K6rvw4iaEn2C+F4z1hNkgi9raa6wTjJzqAVPEztgDy/Ldl79KSBDhEnDcRaAy0f9n7wXV91anbUtDFJM/I8DK+gY7fyT9KmLi0Wd2QnpCd4KSbji4x77mGaZx+JO36MEL35a7NMNdf+E4OyGvuChKXVSl8+BOYHw3WI8FmbmAptS4hLkYRV6rhwzk/7nXbJOKToYIp+XM5tWu0CMFcIOHGRlUUEm5tzZ+PF0TL8zN9/uPeWeYQJvfRDkp4Bv3HnkQYm8r24CqmABHiK4PFBtz8VtS5ScnlSY/tkyXwlBoDTU1nIbIItmWs65W3Ir1HpBBeKPtM16jF0huFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1b0fGXgHL1/FpSSPt4zUwYj4quMJgtJXPNQ9z7lP4Y=;
 b=Lv3yZiAzEFGHJBHGIOieGHYbN3Bot43aZExQA2phQsQ8ES1ELK9ARcmHOJFSk+OLGM4Vtc5t0C5VRy+KpXVGOy4F3QV+EMIvS21iRbuNnbvKYsZ4/Y9UjfM8+NmjS/8OvubDWGERSaqn0jq5xMzv/BbzRBBNig62Lu01YSXpsZbGOmi7v3hFikSxa7M8OPuG9VCwj4XwrAUmTap84yz5vKG7e6D15OU8LqTPxiax7bNifkSviJeSQ1Prl0wS7GvPsZuQhVICMWOu5aD0olMrrpVvYALFcqOF9dorynbJcpqd98I2yFoCawXI/R5Bxd/xCE4QCn9nhbTX9Hr8LL7L3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1b0fGXgHL1/FpSSPt4zUwYj4quMJgtJXPNQ9z7lP4Y=;
 b=A28zhM+zlttlFDaSzDVnS0q97FPyRWLDtPN21PE6uneWkRdBgy58WdblHcUcR4XQgbekCozlIE/7Vr7KsmNyAT2hToYKZ89E3XodivwiUz+gVfKEL7jLYder5NJqHM3d3KAE1/O3QDSlGk9nUo8tY3vg9pHjlauOPhXvwbOoX/o=
Received: from DM6PR07CA0115.namprd07.prod.outlook.com (2603:10b6:5:330::6) by
 DS7PR12MB8251.namprd12.prod.outlook.com (2603:10b6:8:e3::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.21; Fri, 22 Sep 2023 22:42:35 +0000
Received: from DS3PEPF000099D3.namprd04.prod.outlook.com
 (2603:10b6:5:330:cafe::26) by DM6PR07CA0115.outlook.office365.com
 (2603:10b6:5:330::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.32 via Frontend
 Transport; Fri, 22 Sep 2023 22:42:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D3.mail.protection.outlook.com (10.167.17.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.14 via Frontend Transport; Fri, 22 Sep 2023 22:42:34 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Fri, 22 Sep
 2023 17:42:33 -0500
Date:   Fri, 22 Sep 2023 17:42:10 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 06/13] KVM: Disallow hugepages for incompatible gmem
 bindings, but let 'em succeed
Message-ID: <20230922224210.6klwbphnsk5j2wft@amd.com>
References: <20230921203331.3746712-1-seanjc@google.com>
 <20230921203331.3746712-7-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230921203331.3746712-7-seanjc@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D3:EE_|DS7PR12MB8251:EE_
X-MS-Office365-Filtering-Correlation-Id: c9905f4c-a0c4-43fd-b4b2-08dbbbbd370d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: awgcrhkABNFMS4pwZCLsvtyyMZ/UOy/DlpAScvS0rO5KBbOgXVsKjdSOJgD/QoaxL5aO6y2wk+vPS1HoFgxqNHi0hSZByapmMmXKYgwmuBwAbYZY2HUZEuy89A5JSHf6XQN3ATdjGaB3RWyba5MEVSnpgCmWDtRIvsMBFaJDSFhpso5SkkozvpG00z5psqdv9QgQMVWzJNf7uiGSPqimvMU5NIFggTSxbEzQxhIPFALXhqBz/t8nU2R1llO2S6yUOG+3OQLr9mmly9fuKvpeTF70BNqXCSSFH9ip+LCc+FZP3UaHW2zH3MtqGP7OxnlqLm9GXvS47wbRQQ8VoLRtWPJsFQg9dHt/6A317L1zY2y5uTsDtcJHDVB29iyz5lrbLQRoK0H/3ARFzZRB3MG6U18/8boLFhDZI2SodnX4FDpHih8CeRoWH52AtJmeaGk+0sJGS1Q0gR3IyqS7NcW3V5UMPtstxyCvEEfUl1tzuEsCHLliSK3+RfrrtLylSZvUB1eFYiJOJ4q+dRoXM6eiZuGReXoG+7Rlv8hDWMfdDPXvAUwdKsAu1kiPjPpYFamA/1zXP0Ek44NiozpxLfoV/diyUKHXq9aKSORKzq84rmhB2pIlXY6qgJofyubSBydckStt59AtjOhAMBYKijWF6CNtBwaKT9M7yFdgxlNVzvmCuDwdyn0OjeOa69TBgOqmQzVRLlySa3q7XzWljtt5L990nY7muFfgiR5xbbYIxTxSvBSdIEazSXZYMZCVjQjuwTe+8nT1qJ7dlo3LErzcM7+gY4cNM+eflxW8wRFecy0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(136003)(396003)(346002)(82310400011)(451199024)(1800799009)(230921699003)(186009)(40470700004)(36840700001)(46966006)(356005)(82740400003)(40460700003)(70206006)(2616005)(40480700001)(70586007)(36860700001)(86362001)(336012)(26005)(6666004)(81166007)(426003)(478600001)(47076005)(1076003)(966005)(16526019)(5660300002)(41300700001)(4326008)(8936002)(54906003)(2906002)(6916009)(8676002)(44832011)(36756003)(316002)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 22:42:34.9134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9905f4c-a0c4-43fd-b4b2-08dbbbbd370d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS3PEPF000099D3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8251
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 01:33:23PM -0700, Sean Christopherson wrote:
> Remove the restriction that a guest_memfd instance that supports hugepages
> can *only* be bound by memslots that are 100% compatible with hugepage
> mappings, and instead force KVM to use an order-0 mapping if the binding
> isn't compatible with hugepages.
> 
> The intent of the draconian binding restriction was purely to simplify the
> guest_memfd implementation, e.g. to avoid repeatining the existing logic in
> KVM x86ial for precisely tracking which GFNs support hugepages.  But
> checking that the binding's offset and size is compatible is just as easy
> to do when KVM wants to create a mapping.
> 
> And on the other hand, completely rejecting bindings that are incompatible
> with hugepages makes it practically impossible for userspace to use a
> single guest_memfd instance for all guest memory, e.g. on x86 it would be
> impossible to skip the legacy VGA hole while still allowing hugepage
> mappings for the rest of guest memory.
> 
> Suggested-by: Michael Roth <michael.roth@amd.com>
> Link: https://lore.kernel.org/all/20230918163647.m6bjgwusc7ww5tyu@amd.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/guest_mem.c | 54 ++++++++++++++++++++++----------------------
>  1 file changed, 27 insertions(+), 27 deletions(-)
> 
> diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
> index 68528e9cddd7..4f3a313f5532 100644
> --- a/virt/kvm/guest_mem.c
> +++ b/virt/kvm/guest_mem.c
> @@ -434,20 +434,6 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags,
>  	return err;
>  }
>  
> -static bool kvm_gmem_is_valid_size(loff_t size, u64 flags)
> -{
> -	if (size < 0 || !PAGE_ALIGNED(size))
> -		return false;
> -
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if ((flags & KVM_GUEST_MEMFD_ALLOW_HUGEPAGE) &&
> -	    !IS_ALIGNED(size, HPAGE_PMD_SIZE))
> -		return false;
> -#endif
> -
> -	return true;
> -}
> -
>  int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  {
>  	loff_t size = args->size;
> @@ -460,9 +446,15 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  	if (flags & ~valid_flags)
>  		return -EINVAL;
>  
> -	if (!kvm_gmem_is_valid_size(size, flags))
> +	if (size < 0 || !PAGE_ALIGNED(size))
>  		return -EINVAL;
>  
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	if ((flags & KVM_GUEST_MEMFD_ALLOW_HUGEPAGE) &&
> +	    !IS_ALIGNED(size, HPAGE_PMD_SIZE))
> +		return -EINVAL;
> +#endif
> +
>  	return __kvm_gmem_create(kvm, size, flags, kvm_gmem_mnt);
>  }
>  
> @@ -470,7 +462,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		  unsigned int fd, loff_t offset)
>  {
>  	loff_t size = slot->npages << PAGE_SHIFT;
> -	unsigned long start, end, flags;
> +	unsigned long start, end;
>  	struct kvm_gmem *gmem;
>  	struct inode *inode;
>  	struct file *file;
> @@ -489,16 +481,9 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		goto err;
>  
>  	inode = file_inode(file);
> -	flags = (unsigned long)inode->i_private;
>  
> -	/*
> -	 * For simplicity, require the offset into the file and the size of the
> -	 * memslot to be aligned to the largest possible page size used to back
> -	 * the file (same as the size of the file itself).
> -	 */
> -	if (!kvm_gmem_is_valid_size(offset, flags) ||
> -	    !kvm_gmem_is_valid_size(size, flags))
> -		goto err;
> +	if (offset < 0 || !PAGE_ALIGNED(offset))
> +		return -EINVAL;
>  
>  	if (offset + size > i_size_read(inode))
>  		goto err;
> @@ -599,8 +584,23 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	page = folio_file_page(folio, index);
>  
>  	*pfn = page_to_pfn(page);
> -	if (max_order)
> -		*max_order = compound_order(compound_head(page));
> +	if (!max_order)
> +		goto success;
> +
> +	*max_order = compound_order(compound_head(page));
> +	if (!*max_order)
> +		goto success;
> +
> +	/*
> +	 * For simplicity, allow mapping a hugepage if and only if the entire
> +	 * binding is compatible, i.e. don't bother supporting mapping interior
> +	 * sub-ranges with hugepages (unless userspace comes up with a *really*
> +	 * strong use case for needing hugepages within unaligned bindings).
> +	 */
> +	if (!IS_ALIGNED(slot->gmem.pgoff, 1ull << *max_order) ||
> +	    !IS_ALIGNED(slot->npages, 1ull << *max_order))
> +		*max_order = 0;

Thanks for working this in. Unfortunately on x86 the bulk of guest memory
ends up getting slotted directly above legacy regions at GFN 0x100, so the
associated slot still ends failing these alignment checks if it tries to
match the gmemfd offsets up with the shared RAM/memfd offsets.

I tried to work around it in userspace by padding the gmemfd offset of
each slot to the next 2M boundary, but that also requires dynamically
growing the gmemfd inode to account for the padding of each new slot and
it gets ugly enough that I'm not sure it's any better than your
suggested alternative of using a unique gmemfd for each slot.

But what if we relax the check to simply make sure that any large folio
must is fully-contained by the range of the slot is bound to? It *seems*
like that would still avoid stuff like mapping 2M pages in the NPT (or
setting up 2M RMP table entries) that aren't fully contained by a slot
while still allowing the bulk of guest memory to get mapped as 2M. Are
there other edge cases to consider?

The following seems to work for a basic 16GB SNP guest at least:

diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index 9109bf5751ee..e73128d4ebc2 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -618,6 +618,7 @@ int __kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
                       gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prep)
 {
        pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
+       pgoff_t huge_index;
        struct kvm_gmem *gmem;
        struct folio *folio;
        struct page *page;
@@ -662,9 +663,12 @@ int __kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
         * sub-ranges with hugepages (unless userspace comes up with a *really*
         * strong use case for needing hugepages within unaligned bindings).
         */
-       if (!IS_ALIGNED(slot->gmem.pgoff, 1ull << *max_order) ||
-           !IS_ALIGNED(slot->npages, 1ull << *max_order))
+       huge_index = round_down(index, 1ull << *max_order);
+       if (huge_index < ALIGN(slot->gmem.pgoff, 1ull << *max_order) ||
+           huge_index + (1ull << *max_order) > slot->gmem.pgoff + slot->npages) {
+               pr_debug("%s: GFN %llx failed alignment checks\n", __func__, gfn);
                *max_order = 0;
+       }
 success:
        r = 0;

-Mike

> +success:
>  	r = 0;
>  
>  out_unlock:
> -- 
> 2.42.0.515.g380fc7ccd1-goog
> 

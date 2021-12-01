Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C0A465637
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 20:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245030AbhLATRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 14:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239282AbhLATRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 14:17:21 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BD0C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 11:14:00 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id s37so14937911pga.9
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 11:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kMtCS1HVMuUkGMmdU6m3Fo5XO/k/kmM0ddsEsZqhO80=;
        b=GqsSG0Yy4jXIZZ85SiIdN4tWGPE7ZKauilf7lzPULfS6wMOfuZNqsYJVyFKDlNmpfp
         pJHVn0GtMcDS+Kv9JTahVYfNSqTGt+SkbdmczukIfNLELR1NEP97x7DhX/ZY6kN4YyWn
         vJaEbn8GrOtocqu2k5dxTe0hdfTbVIh1GEyZJGaVMGX1rXepxfgh9iHLKpxCeKdfSKwI
         aZDgEZqfEe60lgLSa1HUpC02fiAnMhJ6jagqZBNItjFAoU23BUDAtfGvN1bngattJAFS
         176ko/sa/fTOhMwSuyKQL/cLqdI3mGs6AwyTeaop6GDEKNo5uNMvTQnNh1OwpzqHbBZz
         jySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kMtCS1HVMuUkGMmdU6m3Fo5XO/k/kmM0ddsEsZqhO80=;
        b=WeIc5hXds9xaSqTTWEhF/n3E6MuI80gVSJHbMUHfcAR6R6wq0ektSSBavA1rHFtmcC
         8phZhwpSmLNS/M83qGIoJIh5vtbucGWPl6c8qPfQNNTMHBm0k41ayOqeyTBqD1vJF0mD
         1blK4CKWSjC6YTnoV2Y+lXDHGCbg2iT8hEgvXQHYhlEFiCH9ah4bXKT9XHmI7pEwLWaF
         JLDY1x97pvZhleIGaXy5i3VozkGYjCGdf86XtDLzyF0VHEtn4Agv7ttTqTOL48JKFAG2
         9Zp7Orn4Q0oSgFwt3EMBS8OFa0/WCv/p6ndrUxXqpbZawJcXNDdfCV69cHR85PW6TOGX
         CQEA==
X-Gm-Message-State: AOAM531BVVPEFkUB7XpCjveAGHdK3kjzJWu/Ix5H5VAVs+ttbVBMfrWu
        7+R8QsWYXvtDlIbygwgzi91inA==
X-Google-Smtp-Source: ABdhPJzenremNGpwo2T6RNhtcxAF7LRxo2eLSPHOrk+QNnPVXMC//7HnEKS7YkW8cEfCA501KvH7zA==
X-Received: by 2002:a63:4551:: with SMTP id u17mr6113581pgk.568.1638386039713;
        Wed, 01 Dec 2021 11:13:59 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u9sm592626pfi.23.2021.12.01.11.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 11:13:59 -0800 (PST)
Date:   Wed, 1 Dec 2021 19:13:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 04/15] KVM: x86/mmu: Factor out logic to atomically
 install a new page table
Message-ID: <YafJc1GHcxTG19p7@google.com>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119235759.1304274-5-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021, David Matlack wrote:
> Factor out the logic to atomically replace an SPTE with an SPTE that
> points to a new page table. This will be used in a follow-up commit to
> split a large page SPTE into one level lower.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 53 ++++++++++++++++++++++++++------------
>  1 file changed, 37 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index cc9fe33c9b36..9ee3f4f7fdf5 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -945,6 +945,39 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>  	return ret;
>  }
>  
> +/*
> + * tdp_mmu_install_sp_atomic - Atomically replace the given spte with an
> + * spte pointing to the provided page table.
> + *
> + * @kvm: kvm instance
> + * @iter: a tdp_iter instance currently on the SPTE that should be set
> + * @sp: The new TDP page table to install.
> + * @account_nx: True if this page table is being installed to split a
> + *              non-executable huge page.
> + *
> + * Returns: True if the new page table was installed. False if spte being
> + *          replaced changed, causing the atomic compare-exchange to fail.
> + *          If this function returns false the sp will be freed before
> + *          returning.
> + */
> +static bool tdp_mmu_install_sp_atomic(struct kvm *kvm,
> +				      struct tdp_iter *iter,
> +				      struct kvm_mmu_page *sp,
> +				      bool account_nx)
> +{
> +	u64 spte;
> +
> +	spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);

This can easily go on one line.

	u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
> +
> +	if (tdp_mmu_set_spte_atomic(kvm, iter, spte)) {
> +		tdp_mmu_link_page(kvm, sp, account_nx);
> +		return true;
> +	} else {
> +		tdp_mmu_free_sp(sp);
> +		return false;

I don't think this helper should free the sp on failure, even if that's what all
paths end up doing.  When reading the calling code, it really looks like the sp
is being leaked because the allocation and free are in different contexts.  That
the sp is consumed on success is fairly intuitive given the "install" action, but
freeing on failure not so much.

And for the eager splitting, freeing on failure is wasteful.  It's extremely
unlikely to happen often, so in practice it's unlikely to be an issue, but it's
certainly odd since the loop is likely going to immediately allocate another sp,
either for the current spte or for the next spte.

Side topic, tdp_mmu_set_spte_atomic() and friends really should return 0/-EBUSY.
Boolean returns for errors usually end in tears sooner or later.

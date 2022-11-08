Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E9F621ABA
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 18:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbiKHRc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 12:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbiKHRcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 12:32:55 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC83205DF
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 09:32:54 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b11so14442590pjp.2
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 09:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MZQogisLwSbHOyDO71y6h2hjs6z+bsUaVgj9CQLEAfY=;
        b=mWSwnjPBmtefrBI+Iv0duFPnOzCbI+xLnGb4gIOhNj2oRlYQHCAXeGHSxCrCIXib4F
         TcYlVNSWew3+4v/Vh/tEbzFmhwQQpFIKb2Io7uDDcDbX/a77BF9FSjaMXeEU++5fPhS4
         wV4oFDAIzEo4EbvvedPbLZpon8RpRn/+aywB0ORZKFjnFf5anz1VRyEl9E1MinpaOmFu
         HoIxULC2Ncxn6Cydk2NciCR03SQQcgMlG8IRliTbt+7wN9gxJE1SFOnATOKg+Yh8S/d3
         7OqLqoru/4rMnjq8YknOH+EwinZ+wY/uWT+vIB1gXFy8QjyiLQKuuOgBM/Lmb19aGxjj
         VQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MZQogisLwSbHOyDO71y6h2hjs6z+bsUaVgj9CQLEAfY=;
        b=eB1vrJdqe3lTP/cAkLW5Okp3LP2hJPCb6MZvoCF2VTKjjh4AsViMIfpRRjl6l/+GEo
         ROpBcALtsfu5dOFyvNWZHn1QzIPRP5Cggob1a6Th7bDXy9pta1rocOQlIVYxNS4qPAWz
         DUllSDQCOsKFnZGi9DfZAqi6qcp+y11rkgwn2RipL/gdDTJOws3vU2Oukvdhi07C4RgD
         k1i4XQyJ4eLu/fZMkkkO1e2BrFTF1lMeaqs429+TB9Gr4haiBhwDOI9Dn/TZNgGiousK
         Ru9F1wbaipAS2oaofee06rRUtfuEEIjRcA+ovv34PByAVCBbHxdssM23CiXk1aAkimgL
         zpoQ==
X-Gm-Message-State: ACrzQf20ct/n3apYTFsctrNAunHVWCeNNR/UANC/6G0qy1Sk2EndrvJB
        ow6NWiQKo5ZMuwtN5RSm3GQM/w==
X-Google-Smtp-Source: AMsMyM4SbHj0OwMh/2EDaILPZtJz4V8czRxVapV6b6KiX6mxR2ahLNCtnWToon3uWrPRYLECAa+7uw==
X-Received: by 2002:a17:903:32c8:b0:187:2718:5313 with SMTP id i8-20020a17090332c800b0018727185313mr44861840plr.82.1667928774219;
        Tue, 08 Nov 2022 09:32:54 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902c11500b00174c1855cd9sm7172411pli.267.2022.11.08.09.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 09:32:53 -0800 (PST)
Date:   Tue, 8 Nov 2022 17:32:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: move memslot invalidation later than possible
 failures
Message-ID: <Y2qSwlN26qWi3ZqH@google.com>
References: <20221108084416.11447-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108084416.11447-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022, Yan Zhao wrote:
> For memslot delete and move, kvm_invalidate_memslot() is required before
> the real changes committed.
> Besides swapping to an inactive slot, kvm_invalidate_memslot() will call
> kvm_arch_flush_shadow_memslot() and further kvm_page_track_flush_slot() in
> arch x86.
> And according to the definition in kvm_page_track_notifier_node, users can
> drop write-protection for the pages in the memory slot on receiving
> .track_flush_slot.

Ugh, that's a terrible API.  The entire page track API is a mess, e.g. KVMGT is
forced to grab its own references to KVM and also needs to manually acquire/release
mmu_lock in some flows but not others.

Anyways, this is a flaw in the page track API that should be fixed.  Flushing a
slot should not be overloaded to imply "this slot is gone", it should be a flush
command, no more, no less.

AFAICT, KVMGT never flushes anything, so fixing the bug should be a simple matter
of adding another hook that's invoked when the memory region change is committed.

That would allow KVMGT to fix another bug.  If a memory region is moved and the
new region partially overlaps the old region, KVMGT technically probably wants to
retain its write-protection scheme.  Though that's probably not worth supporting,
might be better to say "don't move memory regions if KVMGT is enabled", because
AFAIK there is no VMM that actually moves memory regions (KVM's MOVE support was
broken for years and no one noticed).

Actually, given that MOVE + KVMGT probably doesn't work regardless of where the
region is moved to, maybe we can get away with rejecting MOVE if an external
page tracker cares about the slot in question.

> However, if kvm_prepare_memory_region() fails, the later
> kvm_activate_memslot() will only swap back the original slot, leaving
> previous write protection not recovered.
> 
> This may not be a problem for kvm itself as a page tracker user, but may
> cause problem to other page tracker users, e.g. kvmgt, whose
> write-protected pages are removed from the write-protected list and not
> added back.
> 
> So call kvm_prepare_memory_region first for meta data preparation before
> the slot invalidation so as to avoid failure and recovery.

IIUC, this is purely a theoretical bug and practically speaking can't be a problem
in practice, at least not without completely breaking KVMGT.

On DELETE, kvm_prepare_memory_region() will never fail on x86 (s390's ultravisor
protected VM case is the only scenario where DELETE can fail on any architecture).
The common code in kvm_prepare_memory_region() does nothing for DELETE, ditto for
kvm_arch_prepare_memory_region().

And for MOVE, it can only fail in two scenarios: (1) the end gfn is beyond the
max gfn, i.e. userspace gave bad input or (2) the new memslot is unaligned but
the old memslot was not, and so KVM needs to allocate new metadata due to the new
memslot needed larger arrays.

As above MOVE is not handled correctly by KVMGT, so I highly doubt there is a VMM
that supports KVMGT and moves relevant memory regions, let alove does something
that can result in MOVE failing _and_ moves the memslot that KVMGT is shadowing.

Heh, and MOVE + KVM_MEM_LOG_DIRTY_PAGES is also arguably broken, as KVM reuses
the existing dirty bitmap but doesn't shift the dirty bits.  This is likely
another combination that KVM can simply reject.

Assuming this is indeed purely theoretical, that should be called out in the
changelog.  Or as above, simply disallow MOVE in this case, which probably has
my vote.

> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  virt/kvm/kvm_main.c | 40 +++++++++++++++-------------------------
>  1 file changed, 15 insertions(+), 25 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 25d7872b29c1..5f29011f432d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1827,45 +1827,35 @@ static int kvm_set_memslot(struct kvm *kvm,
>  	 */
>  	mutex_lock(&kvm->slots_arch_lock);
>  
> -	/*
> -	 * Invalidate the old slot if it's being deleted or moved.  This is
> -	 * done prior to actually deleting/moving the memslot to allow vCPUs to
> -	 * continue running by ensuring there are no mappings or shadow pages
> -	 * for the memslot when it is deleted/moved.  Without pre-invalidation
> -	 * (and without a lock), a window would exist between effecting the
> -	 * delete/move and committing the changes in arch code where KVM or a
> -	 * guest could access a non-existent memslot.
> -	 *
> -	 * Modifications are done on a temporary, unreachable slot.  The old
> -	 * slot needs to be preserved in case a later step fails and the
> -	 * invalidation needs to be reverted.
> -	 */
>  	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
>  		invalid_slot = kzalloc(sizeof(*invalid_slot), GFP_KERNEL_ACCOUNT);
>  		if (!invalid_slot) {
>  			mutex_unlock(&kvm->slots_arch_lock);
>  			return -ENOMEM;
>  		}
> -		kvm_invalidate_memslot(kvm, old, invalid_slot);
>  	}
>  
>  	r = kvm_prepare_memory_region(kvm, old, new, change);
>  	if (r) {
> -		/*
> -		 * For DELETE/MOVE, revert the above INVALID change.  No
> -		 * modifications required since the original slot was preserved
> -		 * in the inactive slots.  Changing the active memslots also
> -		 * release slots_arch_lock.
> -		 */
> -		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> -			kvm_activate_memslot(kvm, invalid_slot, old);
> +		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
>  			kfree(invalid_slot);
> -		} else {
> -			mutex_unlock(&kvm->slots_arch_lock);
> -		}
> +
> +		mutex_unlock(&kvm->slots_arch_lock);
>  		return r;
>  	}
>  
> +	/*
> +	 * Invalidate the old slot if it's being deleted or moved.  This is
> +	 * done prior to actually deleting/moving the memslot to allow vCPUs to
> +	 * continue running by ensuring there are no mappings or shadow pages
> +	 * for the memslot when it is deleted/moved.  Without pre-invalidation
> +	 * (and without a lock), a window would exist between effecting the
> +	 * delete/move and committing the changes in arch code where KVM or a
> +	 * guest could access a non-existent memslot.
> +	 */
> +	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> +		kvm_invalidate_memslot(kvm, old, invalid_slot);

I'm not 100% sure that simply moving kvm_invalidate_memslot() is functionally
correct.  It might be, but there are so many subtleties in this code that I don't
want to change this ordering unless absolutely necessary, or at least not without
an in-depth analysis and a pile of tests.  E.g. it's possible one or more
architectures relies on unmapping, flushing, and invalidating the old region
prior to preparing the new region, e.g. to reuse arch memslot data.

> +
>  	/*
>  	 * For DELETE and MOVE, the working slot is now active as the INVALID
>  	 * version of the old slot.  MOVE is particularly special as it reuses
> -- 
> 2.17.1
> 

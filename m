Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37556366D2
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 18:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbiKWRSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 12:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239221AbiKWRSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 12:18:05 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B16490BD
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 09:18:02 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id n17so17293371pgh.9
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 09:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wrS07cTC5K5Tj39aOQ2pHWaQp/nnwsNDHjx9FaHsOZw=;
        b=hKlCMfoNbebyaz0GGzRhHybmF6QIFeHL8ypqHOA7H6Qu3U3+67CjMYRiCpvMZQj2iU
         UldfcZ77FGWYA0tbPU17LtXHlHC/16+lOUJtKYU0MxXlE0+uaJlph2jtIch1d0yCCiFk
         bJ6FTNxHvLyxmxWeMlOeI2OPXO5QepiHfZGGTzGMErdK6B7zrbaKhertNIjZ4TGfNfrl
         623Kf+4oiQs12tLhvUhwXFygPjCOBLcGkPBESqAR4c3A9jJ+N90VmbY/YnSsnoQfO9em
         dcWD5MsbKEQKIT1Kgy6K+CX2dGLTHmRfXdw2/Hlp2TvF1u0ujiYkyd1ky9jl+SrzAOGY
         LAZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wrS07cTC5K5Tj39aOQ2pHWaQp/nnwsNDHjx9FaHsOZw=;
        b=qbxYWR5yzbOkL+dst/lBEVXnAZO/vPrYFUdCqEvOxoq3Afx+DvWFdoQ2OJCv2Oo0JJ
         ssIMHEAfy9PH7GcrejwqVHkqd1Bsybf/Hrax9G9msxhH6BUClXxSbSCYVeMaZcsIcvq/
         aeNhbL/EAXnFJQ25+0k0bIne9YkvZldC2a1779L6WU7E0QbekY4MIIAs96mPIHQ6dulV
         AkViz0yXqDhVApCARx4mONKTCeqKvpD8QQcT6tLWv1DWCYWxHUc7vJ0pTOcj9wFS7HBr
         M8A+ii2DBxV0tUcT5qOIspVmXk2ocCjkfc/bzf2I4KjXxk1zXueclOqtHAATt6rvRXfE
         Qk+g==
X-Gm-Message-State: ANoB5pmrLdNtBTSrTOnzHscoApIBSnm3bh5CaQdzaG78ZfCY3ZwZd8RN
        AHH0RTpu4hYnNbJJ5/LQdU4S7A==
X-Google-Smtp-Source: AA0mqf5NHQuFjEK1f1dMpwRtz5Fe72kx+Dmi96MPegsu5xq9WODjpbMEGJeg5dmaj/0E09k5vBEadA==
X-Received: by 2002:a65:4948:0:b0:46e:be03:d9b5 with SMTP id q8-20020a654948000000b0046ebe03d9b5mr8014187pgs.495.1669223882291;
        Wed, 23 Nov 2022 09:18:02 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i29-20020a63131d000000b00460ea630c1bsm10936999pgl.46.2022.11.23.09.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 09:18:01 -0800 (PST)
Date:   Wed, 23 Nov 2022 17:17:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        mhal@rbox.co
Subject: Re: [PATCH 2/4] KVM: x86/xen: Compatibility fixes for shared
 runstate area
Message-ID: <Y35VxflJBVjzloaj@google.com>
References: <20221119094659.11868-1-dwmw2@infradead.org>
 <20221119094659.11868-2-dwmw2@infradead.org>
 <Y30XVDXmkAIlRX4N@google.com>
 <a12c8e6123cf702bc882988f9da3be7bd096a2e3.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a12c8e6123cf702bc882988f9da3be7bd096a2e3.camel@infradead.org>
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

On Tue, Nov 22, 2022, David Woodhouse wrote:
> On Tue, 2022-11-22 at 18:39 +0000, Sean Christopherson wrote:
> > On Sat, Nov 19, 2022, David Woodhouse wrote:
> > > From: David Woodhouse <
> > > dwmw@amazon.co.uk
> > > >
> > > 
> > > The guest runstate area can be arbitrarily byte-aligned. In fact, even
> > > when a sane 32-bit guest aligns the overall structure nicely, the 64-bit
> > > fields in the structure end up being unaligned due to the fact that the
> > > 32-bit ABI only aligns them to 32 bits.
> > > 
> > > So setting the ->state_entry_time field to something|XEN_RUNSTATE_UPDATE
> > > is buggy, because if it's unaligned then we can't update the whole field
> > > atomically; the low bytes might be observable before the _UPDATE bit is.
> > > Xen actually updates the *byte* containing that top bit, on its own. KVM
> > > should do the same.
> > 
> > I think we're using the wrong APIs to update the runstate.  The VMCS/VMCB pages
> > _need_ the host pfn, i.e. need to use a gpc (eventually).  The Xen PV stuff on the
> > other hand most definitely doesn't need to know the pfn.
> > 
> > The event channel code would be difficult to convert due to lack of uaccess
> > primitives, but I don't see anything in the runstate code that prevents KVM from
> > using a gfn_to_hva_cache.  That will naturally handle page splits by sending them
> > down a slow path and would yield far simpler code.
> > 
> > If taking the slow path is an issue, then the guest really should be fixed to not
> > split pages.  And if that's not an acceptable answer, the gfn_to_hva_cache code
> > could be updated to use the fast path if the region is contiguous in the host
> > virtual address space.
> > 
> 
> Yeah, that's tempting. Going back to gfn_to_hva_cache was the first
> thing I tried. There are a handful of complexifying factors, none of
> which are insurmountable if we try hard enough.
> 
>  • Even if we fix the gfn_to_hva_cache to still use the fast path for
>    more than the first page, it's still possible for the runstate to
>    cross from one memslot to an adjacent one. We probably still need
>    two of them, which is a large part of the ugliness of this patch.

Hrm.  What if KVM requires that the runstate be contiguous in host virtual address
space?  That wouldn't violate Xen's ABI since it's a KVM restriction, and it can't
break backwards compatibility since KVM doesn't even handle page splits, let alone
memslot splits.  AFAIK, most (all?) userspace VMMs make guest RAM virtually
contiguous anyways.

Probably a moot point since I don't see a way around the "page got swapped out"
issue.

>  • Accessing it via the userspace HVA requires coping with the case
>    where the vCPU is being scheduled out, and it can't sleep. The
>    previous code before commit 34d41d19e dealt with that by using 
>    pagefault_disable() and depending on the GHC fast path. But even
>    so...
> 
>  • We also could end up having to touch page B, page A then page B
>    again, potentially having to abort and leave the runstate with
>    the XEN_RUNSTATE_UPDATE bit still set. I do kind of prefer the
>    version which checks that both pages are present before it starts
>    writing anything to the guest.

Ugh, and because of the in-atomic case, there's nothing KVM can do to remedy page B
getting swapped out.  Actually, it doesn't even require a B=>A=>B pattern.  Even
without a page split, the backing page could get swapped out between setting and
clearing.

> As I said, they're not insurmountable but that's why I ended up with
> the patch you see, after first attempting to use a gfn_to_hva_cache
> again. Happy to entertain suggestions.

What if we use a gfn_to_pfn_cache for the page containing XEN_RUNSTATE_UPDATE,
and then use kvm_vcpu_write_guest_atomic() if there's a page split?  That would
avoid needing to acquire mutliple gpc locks, and the update could use a single
code flow by always constructing an on-stack representation.  E.g. very roughly:

	*update_bit = (vx->runstate_entry_time | XEN_RUNSTATE_UPDATE) >> 56;
	smp_wmb();

	if (khva)
		memcpy(khva, rs_state, user_len);
	else
		kvm_vcpu_write_guest_in_atomic(vcpu, gpa, rs_state, user_len);
	smp_wmb();

	*update_bit = vx->runstate_entry_time >> 56;
	smp_wmb();

where "khva" is NULL if there's a page split.

> I note we have a kvm_read_guest_atomic() and briefly pondered adding a
> 'write' version of same... but that doesn't seem to cope with crossing
> memslots either; it also assumes its caller only uses it to access
> within a single page.

We should fix the lack of page split handling.  There are no bugs because KVM
only uses the helper for cases where the accesses are naturally aligned, but that's
bound to bite someone eventually.  That would be an oppurtunity to dedup the code
that handles "segments" (ugh), e.g. instead of

	gfn_t gfn = gpa >> PAGE_SHIFT;
	int seg;
	int offset = offset_in_page(gpa);
	int ret;

	while ((seg = next_segment(len, offset)) != 0) {
		ret = kvm_vcpu_read_guest_page(vcpu, gfn, data, offset, seg);
		if (ret < 0)
			return ret;
		offset = 0;
		len -= seg;
		data += seg;
		++gfn;
	}
	return 0;

provide a macro that allows

	kvm_for_each_chunk(...)
		ret = kvm_vcpu_read_guest_page(vcpu, gfn, data, offset, seg);
		if (ret)
			return ret;
	}
	
I also think we should rename the "atomic" helpers to be "in_atomic" (or inatomic
if we want to follow the kernel's terrible nomenclature, which I always read as
"not atomic").  I always think read_guest_atomic() means an "atomic read".

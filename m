Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B0550013A
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 23:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiDMVfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 17:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiDMVfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 17:35:43 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A9F716CC
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 14:33:19 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id j8so3016942pll.11
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 14:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tZlAD5fqgFM2QExUPeWddWgN2PhF0f8As7E1Iy62Sqc=;
        b=NxZph/RNKcpblF39tpcYyH0y5XlEa2IJ39wMSt4xAsFB0jRBpAS76njl8RnmxFWZiB
         7tj0af+oerLhqXNIqVMP8d/RreCfs/GByJM2hEo2hHJTAc6kBb7e7XIUCrX2CBlMaEnn
         WcFhWn+tN1exyA5s0FtU2LEHa5uNHPvdX1zOCTG1xhGBsHmNDNjeA1VNUqZBLlAbaR+6
         lTgC2djbnhbRlQSpsAsrQIEpBaXNDYzvkKHyMqpdArcVc6Ma7IWtiyHtWFQF6GZRE3gn
         ulnpuRMDh5T0Ldi72DJT1FZ+NE8D9T3LIzrS/q2VWdBKgi+6llNgf7FaAft5aVAr9NdM
         JEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tZlAD5fqgFM2QExUPeWddWgN2PhF0f8As7E1Iy62Sqc=;
        b=EL0iFEW80x3LW5TP9UQviOws2zfasrntibzCjtkFasKdJk12zdoLMrKNOjRHm++0vL
         G22YZeGISli9vZ34pAWwkgIlRiPFXMsyvpon1S3BKnx9QsoTq4AET1YJ2JhxZ3sxsphg
         oNffqhdfLe06at/LZlrcJawLovCWzwD+1gLjwi4p/946mH57f5IkaRT2tptrEVTP27Cw
         4WbPtomU33MwYpfRQyZ3EdmyiXcIblcQCDlv8COXCSuFRcIV3zj+DCCaU1eh0WxrAWcx
         UFVuzObtorUA/MH/KU1liV3GAY0OhcCv5RIBdBF/M0bGcJIAtTddB52rnImguOlf2h36
         NDMA==
X-Gm-Message-State: AOAM530f3/UpwZmlJfyVISrSeIGxjfaUtywfgM8PenIwvN0KokazKuvD
        juVHuEQtXTGI2m70lupoDCnLyQ==
X-Google-Smtp-Source: ABdhPJz+/6KkXgMO9ZczIVF9SuO4E65kGjYfy4szxgnVaWlBRAWRXI8Nk1aYzzkwGnPqdZn1ZWuStQ==
X-Received: by 2002:a17:90b:4cc5:b0:1cb:ba0f:9623 with SMTP id nd5-20020a17090b4cc500b001cbba0f9623mr138176pjb.85.1649885598749;
        Wed, 13 Apr 2022 14:33:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j7-20020a056a00130700b004b9f7cd94a4sm32420pfu.56.2022.04.13.14.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 14:33:18 -0700 (PDT)
Date:   Wed, 13 Apr 2022 21:33:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 4/4] x86: nSVM: Build up the nested
 page table dynamically
Message-ID: <YldBmpd3k0sO3IEH@google.com>
References: <20220324053046.200556-1-manali.shukla@amd.com>
 <20220324053046.200556-5-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324053046.200556-5-manali.shukla@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 24, 2022, Manali Shukla wrote:
> Current implementation of nested page table does the page
> table build up statistically with 2048 PTEs and one pml4 entry.
> That is why current implementation is not extensible.
> 
> New implementation does page table build up dynamically based
> on the RAM size of the VM which enables us to have separate
> memory range to test various npt test cases.
> 
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  x86/svm.c     | 163 ++++++++++++++++++++++++++++++++++----------------

Ok, so I got fairly far into reviewing this (see below, but it can be ignored)
before realizing that all this new code is nearly identical to what's in lib/x86/vm.c.
E.g. find_pte_level() and install_pte() can probably used almost verbatim.

Instead of duplicating code, can you extend vm.c to as necessary?  It might not
even require any changes.  I'll happily clean up vm.c in the future, e.g. to fix
the misleading nomenclature and open coded horrors, but for your purposes I think
you should be able to get away with a bare minimum of changes.

>  x86/svm.h     |  17 +++++-
>  x86/svm_npt.c |   4 +-
>  3 files changed, 130 insertions(+), 54 deletions(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index d0d523a..67dbe31 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -8,6 +8,7 @@
>  #include "desc.h"
>  #include "msr.h"
>  #include "vm.h"
> +#include "fwcfg.h"
>  #include "smp.h"
>  #include "types.h"
>  #include "alloc_page.h"
> @@ -16,38 +17,67 @@
>  #include "vmalloc.h"
>  
>  /* for the nested page table*/
> -u64 *pte[2048];
> -u64 *pde[4];
> -u64 *pdpe;
>  u64 *pml4e;
>  
>  struct vmcb *vmcb;
>  
> -u64 *npt_get_pte(u64 address)
> +u64* get_npt_pte(u64 *pml4,

Heh, the usual way to handle wrappers is to add underscores, i.e.

u64 *npt_get_pte(u64 address)
{
    return __npt_get_pte(npt_get_pml4e(), address, 1);
}

swapping the order just results in namespacing wierdness and doesn't convey to the
reader that this is an "inner" helper.

> u64 guest_addr, int level)

Assuming guest_addr is a gpa, call it gpa to avoid ambiguity over virtual vs.
physical.

>  {
> -	int i1, i2;
> +    int l;
> +    u64 *pt = pml4, iter_pte;

Please point pointers and non-pointers on separate lines.  And just "pte" for
the tmp, it's not actually used as an iterator.  And with that, I have a slight
preference for page_table over pt so that it's not mistaken for pte.

> +    unsigned offset;

No bare unsigned please.  And "offset" is the wrong terminology, "index" or "idx"
is preferable.  An offset is usually an offset in bytes, this indexes into a u64
array.

Ugh, looks like that awful name comes from PGDIR_OFFSET in lib/x86/asm/page.h.
The offset, at least in Intel SDM terminology, it specifically the last N:0 bits
of the virtual address (or guest physical) that are the offset into the physical
page, e.g. 11:0 for a 4kb page, 20:0 for a 2mb page.

> +
> +    assert(level >= 1 && level <= 4);

The upper bound should be NPT_PAGE_LEVEL, or root_level (see below).

> +    for(l = NPT_PAGE_LEVEL; ; --l) {

Nit, need a space after "for".

Also, can you plumb in the root level?  E.g. have npt_get_pte() hardcode the
root in this case.  At some point this will hopefully support 5-level NPT, at
which point hardcoding the root will require updating more code than should be
necessary.

> +        offset = (guest_addr >> (((l - 1) * NPT_PGDIR_WIDTH) + 12))
> +                 & NPT_PGDIR_MASK;

Not your code (I think), but NPT_PGDIR_MASK is an odd name since it's common to
all.  The easiest thing would be to loosely follow KVM.  Actually, I think it
makes sense to grab the PT64_ stuff from KVM

#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
#define PT64_LEVEL_BITS 9
#define PT64_LEVEL_SHIFT(level) \
		(PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS)
#define PT64_INDEX(address, level)\
	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))


and then use those instead of having dedicated NPT_* defines.  That makes it more
obvious that (a) SVM/NPT tests are 64-bit only and (b) there's nothing special
about NPT with respect to "legacy" 64-bit paging.

That will provide a nice macro, PT64_INDEX, to replace the open coded calcuations.

> +        if (l == level)
> +            break;
> +        if (!(iter_pte & NPT_PRESENT))
> +            return false;

Return "false" works, but it's all kinds of wrong.  This should either assert or
return NULL.

> +        pt = (u64*)(iter_pte & PT_ADDR_MASK);
> +    }
> +    offset = (guest_addr >> (((l - 1) * NPT_PGDIR_WIDTH) + 12))
> +             & NPT_PGDIR_MASK;

Hmm, this is unnecessary because the for-loop can't terminate on its own, it
can only exit on "l == level", and offset is already correct in that case.

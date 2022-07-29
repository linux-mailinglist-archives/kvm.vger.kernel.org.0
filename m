Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9541B585214
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 17:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbiG2PIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 11:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236797AbiG2PID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 11:08:03 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940237FE5C
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:08:02 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so5579980pjl.0
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=CvT5d2Uml4zSYK74zNGu6gfXjeWpkRQwLmz3buaPtes=;
        b=l6Kkj/TiL0A33Ps7q+Lj2N4BqxMTHm6c5+Hf7aDbC1bWNTo5CGQj2ZGxiT31ad2qCr
         TUvj+2uAqPqiG0ZExrrTMudERXR+yW1OgUwp8G0RWLXae1TbE9+GFJAaBZlvvwJ1Diw5
         ca8eaU3YeTw0eQg2JxIVMBi/k0ANOBMnwD5HznKNFIZFljmw1oo5VpFTPBqHY7YgPuQ+
         7T1xizLPeyX4MYfBYnBBoGRBnUAKWcdfOORA40WO+NGuOnZVa33RR3MxHZZiq9j1YJIL
         VHr4FgCwpfe+nNEv/LsSJV1FVUOw2jn++bZNS6kDSRmLhX39OmkNXx/N1s+vCDXX1m+n
         6eKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=CvT5d2Uml4zSYK74zNGu6gfXjeWpkRQwLmz3buaPtes=;
        b=7cRY8eJGkS9X15fc3nMCDjKwcEb5enawYq4t2rqdTnoyOmUQ3d8bxAZX3qwa8S19l/
         MATvn6EyD9YsQutpZ+B67Coo+qe9lKeSN0F898OeW9coh0B4Ify0RxgZb89OqIKjSJc4
         RIyGB8Ql4Lfq2pRV0g7DdC47RQ7AL4C4uugb9YebEZfLRjfL969cgsE0I67VSBrdb56k
         zl/01mkUV7klhHdoikNeZhIh4BS4H9aNeA+bqHxc9JLzwkyEMXQmxsJxvC3PBHNQ8uEj
         DHLcZ9g2Q97ENdT/PZHhsL4P7AVHOTwKHAy1nr9+CBpSEC3TQUJF5PWuBUtpAYSOfH9A
         pZsw==
X-Gm-Message-State: ACgBeo19C9zA+/Kqwt+udgQ3kwEL0AXHvCybn1ot7ehlpCmP0MmW0xio
        6vZdA29tuf1ao/ppLrlRZwEYpySMj4vGpw==
X-Google-Smtp-Source: AA6agR5Wvr+L32gHkej9UgwrHzDHH7qVdbrxRlzLjnTkIDFbEIEx5UPc7lnO+jzihd9V9k4+U9eIkA==
X-Received: by 2002:a17:902:ce05:b0:16b:e725:6f6c with SMTP id k5-20020a170902ce0500b0016be7256f6cmr4355459plg.110.1659107281282;
        Fri, 29 Jul 2022 08:08:01 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b126-20020a621b84000000b0052859441ad3sm2948663pfb.214.2022.07.29.08.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:08:00 -0700 (PDT)
Date:   Fri, 29 Jul 2022 15:07:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Fully re-evaluate MMIO caching when
 SPTE masks change
Message-ID: <YuP3zGmpiALuXfW+@google.com>
References: <20220728221759.3492539-1-seanjc@google.com>
 <20220728221759.3492539-3-seanjc@google.com>
 <9104e22da628fef86a6e8a02d9d2e81814a9d598.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9104e22da628fef86a6e8a02d9d2e81814a9d598.camel@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 29, 2022, Kai Huang wrote:
> On Thu, 2022-07-28 at 22:17 +0000, Sean Christopherson wrote:
> > Fully re-evaluate whether or not MMIO caching can be enabled when SPTE
> > masks change; simply clearing enable_mmio_caching when a configuration
> > isn't compatible with caching fails to handle the scenario where the
> > masks are updated, e.g. by VMX for EPT or by SVM to account for the C-bit
> > location, and toggle compatibility from false=>true.
> > 
> > Snapshot the original module param so that re-evaluating MMIO caching
> > preserves userspace's desire to allow caching.  Use a snapshot approach
> > so that enable_mmio_caching still reflects KVM's actual behavior.
> > 

..

> > @@ -340,6 +353,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
> >  	BUG_ON((u64)(unsigned)access_mask != access_mask);
> >  	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
> >  
> > +	/*
> > +	 * Reset to the original module param value to honor userspace's desire
> > +	 * to (dis)allow MMIO caching.  Update the param itself so that
> > +	 * userspace can see whether or not KVM is actually using MMIO caching.
> > +	 */
> > +	enable_mmio_caching = allow_mmio_caching;
> 
> I think the problem comes from MMIO caching mask/value are firstly set in
> kvm_mmu_reset_all_pte_masks() (which calls kvm_mmu_set_mmio_spte_mask() and may
> change enable_mmio_caching), and later vendor specific code _may_ or _may_not_
> call kvm_mmu_set_mmio_spte_mask() again to adjust the mask/value.  And when it
> does, the second call from vendor specific code shouldn't depend on the
> 'enable_mmio_caching' value calculated in the first call in 
> kvm_mmu_reset_all_pte_masks().

Correct.

> Instead of using 'allow_mmio_caching', should we just remove
> kvm_mmu_set_mmio_spte_mask() in kvm_mmu_reset_all_pte_masks() and enforce vendor
> specific code to always call kvm_mmu_set_mmio_spte_mask() depending on whatever
> hardware feature the vendor uses?

Hmm, I'd rather not force vendor code to duplicate the "basic" functionality.
It's somewhat silly to preserve the common path since both SVM and VMX need to
override it, but on the other hand those overrides are conditional.

Case in point, if I'm reading the below patch correctly, svm_shadow_mmio_mask will
be left '0' if the platform doesn't support memory encryption (svm_adjust_mmio_mask()
will bail early).  That's a solvable problem, but then I think KVM just ends up
punting this issue to SVM to some extent.

Another flaw in the below patch is that enable_mmio_caching doesn't need to be
tracked on a per-VM basis.  VMX with EPT can have different masks, but barring a
massive change in KVM or hardware, there will never be a scenario where caching is
enabled for one VM but not another.

And isn't the below patch also broken for TDX?  For TDX, unless things have changed,
the mask+value is supposed to be SUPPRES_VE==0 && RWX==0.  So either KVM is generating
the wrong mask (MAXPHYADDR < 51), or KVM is incorrectly marking MMIO caching as disabled
in the TDX case.

Lastly, in prepration for TDX, enable_mmio_caching should be changed to key off
of the _mask_, not the value.  E.g. for TDX, the value will be '0', but the mask
should be SUPPRESS_VE | RWX.

> I am suggesting this way because in Isaku's TDX patch
> 
> [PATCH v7 037/102] KVM: x86/mmu: Track shadow MMIO value/mask on a per-VM basis
> 
> we will enable per-VM MMIO mask/value, which will remove global
> shadow_mmio_mask/shadow_mmio_value, and I am already suggesting something
> similar:
> 
> https://lore.kernel.org/all/20220719084737.GU1379820@ls.amr.corp.intel.com/
> 

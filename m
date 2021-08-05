Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772223E1A8F
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 19:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbhHERjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 13:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbhHERj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 13:39:29 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2BEC0613D5
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 10:39:14 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ca5so10616982pjb.5
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 10:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=25dI2qwAi7TSMZKSjGmJYglQgYbrwOJcxN6GHCDQJtY=;
        b=uFTSZPbFCNjb65mQPn0Er3edoI5Tmo52V5M7wb5ifPkYDUeTgC/9MnNHvvfC5T4c6D
         fg9Hf9rnez9xcFsdyFWGWwMsaYVxXUtpI3M0YlwSoG00LC07NRKudSF7L7svQjkGaWlm
         SnDiKDpT/ncc0KXEeCLwfBU4UOqtHjsqxieGTHZe1/TRJQvEF3XilbYTdFQ6iTWGwGVO
         bf63iXpy7D3DFsaAmEVEOEROXRQ+dA8w5RfaWGPayfYPszXElngWAshhZgXFVYSGvIYI
         vAewl8g3XCgeJLYC7KC756Imz2qE8gu7BOzxLBF0o4EioAMBrMAR7grb9J+qR6SyWhXS
         ReZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=25dI2qwAi7TSMZKSjGmJYglQgYbrwOJcxN6GHCDQJtY=;
        b=Eu6KfPZhLOTyHWeEqD/facs4mcrnvpIMp41RGSFcQ6yEIW/1STkdReOlvYUToABiW9
         1/Lkkk7KCPB57YA4x+ccAjvbzLg9Jk2r6dIpR7weEIiGnN5vyiet1+/ZlPIXHdGrgk1b
         5gp/YKctClY6/QNJHfo91t1V86J6IMIGcgTbZdGG/99muFyRSpBYXtvGeaRViCFjwoPJ
         q9bkjAO+0P0wtRHuk+DLWYufsPLBJxQwxv7m1AaK0r5y1ttjzbPf34SuptUJDb8JYtQc
         ldBOdG45cxOubV5X9Lcr1TbXF+DbVXAvNl0Qee6Mfk35hijDJfZT23vxrtwjryR3LtCV
         rboA==
X-Gm-Message-State: AOAM532FkA2wf49ZezhkH3yFPmSztWySWsSQBzO1KuPHvjuU7vXtrwJH
        qLu3YStrxPULQHYuRjytpauc/g==
X-Google-Smtp-Source: ABdhPJwQ/vFVl7z3DmEv/wlvSs11OrMFHcZMvxz1lW0lUCxyJlJX0BFvN1tmkExqXFlN2th6Y5N+dA==
X-Received: by 2002:a17:90a:8049:: with SMTP id e9mr16826271pjw.160.1628185153210;
        Thu, 05 Aug 2021 10:39:13 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j3sm7677397pfe.98.2021.08.05.10.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 10:39:12 -0700 (PDT)
Date:   Thu, 5 Aug 2021 17:39:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "erdemaktas@google.com" <erdemaktas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "ckuehl@redhat.com" <ckuehl@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [RFC PATCH v2 41/69] KVM: x86: Add infrastructure for stolen GPA
 bits
Message-ID: <YQwiPNRYHtnMA5AL@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <c958a131ded780808a687b0f25c02127ca14418a.1625186503.git.isaku.yamahata@intel.com>
 <20210805234424.d14386b79413845b990a18ac@intel.com>
 <YQwMkbBFUuNGnGFw@google.com>
 <78b802bbcf72a087bcf118340eae89f97024d09c.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78b802bbcf72a087bcf118340eae89f97024d09c.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021, Edgecombe, Rick P wrote:
> On Thu, 2021-08-05 at 16:06 +0000, Sean Christopherson wrote:
> > On Thu, Aug 05, 2021, Kai Huang wrote:
> > > And removing 'gfn_stolen_bits' in 'struct kvm_mmu_page' could also save
> > > some memory.
> > 
> > But I do like saving memory...  One potentially bad idea would be to
> > unionize gfn and stolen bits by shifting the stolen bits after they're
> > extracted from the gpa, e.g.
> > 
> > 	union {
> > 		gfn_t gfn_and_stolen;
> > 		struct {
> > 			gfn_t gfn:52;
> > 			gfn_t stolen:12;
> > 		}
> > 	};
> > 
> > the downsides being that accessing just the gfn would require an additional
> > masking operation, and the stolen bits wouldn't align with reality.
> 
> It definitely seems like the sp could be packed more efficiently.

Yeah, in general it could be optimized.  But for TDP/direct MMUs, we don't care
thaaat much because there are relatively few shadow pages, versus indirect MMUs
with thousands or tens of thousands of shadow pages.  Of course, indirect MMUs
are also the most gluttonous due to the unsync_child_bitmap, gfns, write flooding
count, etc...

If we really want to reduce the memory footprint for the common case (TDP MMU),
the crud that's used only by indirect shadow pages could be shoved into a
different struct by abusing the struct layout and and wrapping accesses to the
indirect-only fields with casts/container_of and helpers, e.g.

struct kvm_mmu_indirect_page {
	struct kvm_mmu_page this;

	gfn_t *gfns;
	unsigned int unsync_children;
	DECLARE_BITMAP(unsync_child_bitmap, 512);

#ifdef CONFIG_X86_32
	/*
	 * Used out of the mmu-lock to avoid reading spte values while an
	 * update is in progress; see the comments in __get_spte_lockless().
	 */
	int clear_spte_count;
#endif

	/* Number of writes since the last time traversal visited this page.  */
	atomic_t write_flooding_count;
}


> One other idea is the stolen bits could just be recovered from the role
> bits with a helper, like how the page fault error code stolen bits
> encoding version of this works.

As in, a generic "stolen_gfn_bits" in the role instead of a per-feature role bit?
That would avoid the problem of per-feature role bits leading to a pile of
marshalling code, and wouldn't suffer the masking cost when accessing ->gfn,
though I'm not sure that matters much.

> If the stolen bits are not fed into the hash calculation though it
> would change the behavior a bit. Not sure if for better or worse. Also
> the calculation of hash collisions would need to be aware.

The role is already factored into the collision logic.

> FWIW, I kind of like something like Sean's proposal. It's a bit
> convoluted, but there are more unused bits in the gfn than the role.

And tightly bound, i.e. there can't be more than gfn_t gfn+gfn_stolen bits.

> Also they are a little more related.



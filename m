Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67A24868BB
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 18:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241966AbiAFRir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 12:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241820AbiAFRiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 12:38:46 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34954C061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 09:38:46 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id c9-20020a17090a1d0900b001b2b54bd6c5so9426714pjd.1
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 09:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GYSLa7pA0gp7wUV13RWv0MqLP9/s7fLzmxP/zsHVRcY=;
        b=j41IMR6KZD4U5nPOCrxqCiJ3wofNvmQirr4AuGkd9syR7UwLMOkJGZE8Du7VF6G8CM
         oun7bZn44mafPumkXhw8PTvxpax0sh0VY1fW5SVDZPC0Bm4HeRPdVihDD7b+4Tjn5ZRs
         FAak69mzOIRufLQhcgc/XRF+u7Fmdo/1GoESmVcW7qq2ZL0grgEGzWcqLW6Qx5BDLsCv
         Uoal1Nh1zhGGNw8z9slwCJRoz+Cf+iuRjqBzcK3D+Z3Vlne8u6qwnyQmeUR2C69blu5R
         00hcEFLtFOFtpTR3FxUuDkOfxvbx4VLlRmYFvzbcq4ph7/i2sYx2rqq6XnUdC4voOKmx
         pcjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GYSLa7pA0gp7wUV13RWv0MqLP9/s7fLzmxP/zsHVRcY=;
        b=P6uq4lYcDUNOOZbpjuhyCtjXj/qb0FNvLj9wcziUCWJfhCktXvbip23ZTojSBQHLIg
         7cFpGlXfb6O4/3pFPs3Uub9aRJM33UOehZLFncrFnRbkD32s4y9RVr6GD2XOGcMVz7rS
         XLdCKBsCLtZPb/eRKRZ6RhmIhiX0aXE1VPjz9YIoYDSqkJ1C1gIYXm/a1QbXhocZYRam
         vcXmbBiK4dXY3gpO2tNMdZfRACHZvaRNpYV4y/HZvDHdSEcjrb1Jbfo28WLXC1S5re26
         bKWqA63X/H4G62RRtyTzR6mEmMUCh63wxDqJUmLRryoMlbFPOl3rckf34F2CvX7IkJy0
         C2UA==
X-Gm-Message-State: AOAM531ONd07uDFvVmTo+mskMvbEaOhNrMylql7YrRF2zG5KkgmWzS+j
        Xbz6+HbWB/ZPxG38urwUJlEz2A==
X-Google-Smtp-Source: ABdhPJzk/FdRU8abIcTFrHj96waF/NHjFtuzEZL1JeXq9Pfy+bowljtCmFDhyszaZc3ia0wyc8/eDQ==
X-Received: by 2002:a17:902:8a94:b0:149:218c:b10a with SMTP id p20-20020a1709028a9400b00149218cb10amr58950325plo.114.1641490725484;
        Thu, 06 Jan 2022 09:38:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p22sm3271867pfo.57.2022.01.06.09.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 09:38:44 -0800 (PST)
Date:   Thu, 6 Jan 2022 17:38:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Chia-I Wu <olv@chromium.org>
Subject: Re: [PATCH v5 4/4] KVM: mmu: remove over-aggressive warnings
Message-ID: <YdcpIQgMZJrqswKU@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-5-stevensd@google.com>
 <Yc4G23rrSxS59br5@google.com>
 <CAD=HUj5Q6rW8UyxAXUa3o93T0LBqGQb7ScPj07kvuM3txHMMrQ@mail.gmail.com>
 <YdXrURHO/R82puD4@google.com>
 <YdXvUaBUvaRPsv6m@google.com>
 <CAD=HUj736L5oxkzeL2JoPV8g1S6Rugy_TquW=PRt73YmFzP6Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=HUj736L5oxkzeL2JoPV8g1S6Rugy_TquW=PRt73YmFzP6Jw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022, David Stevens wrote:
> On Thu, Jan 6, 2022 at 4:19 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Jan 05, 2022, Sean Christopherson wrote:
> > > Ah, I got royally confused by ensure_pfn_ref()'s comment
> > >
> > >   * Certain IO or PFNMAP mappings can be backed with valid
> > >   * struct pages, but be allocated without refcounting e.g.,
> > >   * tail pages of non-compound higher order allocations, which
> > >   * would then underflow the refcount when the caller does the
> > >   * required put_page. Don't allow those pages here.
> > >                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > that doesn't apply here because kvm_faultin_pfn() uses the low level
> > > __gfn_to_pfn_page_memslot().
> >
> > On fifth thought, I think this is wrong and doomed to fail.  By mapping these pages
> > into the guest, KVM is effectively saying it supports these pages.  But if the guest
> > uses the corresponding gfns for an action that requires KVM to access the page,
> > e.g. via kvm_vcpu_map(), ensure_pfn_ref() will reject the access and all sorts of
> > bad things will happen to the guest.
> >
> > So, why not fully reject these types of pages?  If someone is relying on KVM to
> > support these types of pages, then we'll fail fast and get a bug report letting us
> > know we need to properly support these types of pages.  And if not, then we reduce
> > KVM's complexity and I get to keep my precious WARN :-)
> 
> Our current use case here is virtio-gpu blob resources [1]. Blob
> resources are useful because they avoid a guest shadow buffer and the
> associated memcpys, and as I understand it they are also required for
> virtualized vulkan.
> 
> One type of blob resources requires mapping dma-bufs allocated by the
> host directly into the guest. This works on Intel platforms and the
> ARM platforms I've tested. However, the amdgpu driver sometimes
> allocates higher order, non-compound pages via ttm_pool_alloc_page.

Ah.  In the future, please provide this type of information in the cover letter,
and in this case, a paragraph in patch 01 is also warranted.  The context of _why_
is critical information, e.g. having something in the changelog explaining the use
case is very helpful for future developers wondering why on earth KVM supports
this type of odd behavior.

> These are the type of pages which KVM is currently rejecting. Is this
> something that KVM can support?

I'm not opposed to it.  My complaint is that this series is incomplete in that it
allows mapping the memory into the guest, but doesn't support accessing the memory
from KVM itself.  That means for things to work properly, KVM is relying on the
guest to use the memory in a limited capacity, e.g. isn't using the memory as
general purpose RAM.  That's not problematic for your use case, because presumably
the memory is used only by the vGPU, but as is KVM can't enforce that behavior in
any way.

The really gross part is that failures are not strictly punted to userspace;
the resulting error varies significantly depending on how the guest "illegally"
uses the memory.

My first choice would be to get the amdgpu driver "fixed", but that's likely an
unreasonable request since it sounds like the non-KVM behavior is working as intended.

One thought would be to require userspace to opt-in to mapping this type of memory
by introducing a new memslot flag that explicitly states that the memslot cannot
be accessed directly by KVM, i.e. can only be mapped into the guest.  That way,
KVM has an explicit ABI with respect to how it handles this type of memory, even
though the semantics of exactly what will happen if userspace/guest violates the
ABI are not well-defined.  And internally, KVM would also have a clear touchpoint
where it deliberately allows mapping such memslots, as opposed to the more implicit
behavior of bypassing ensure_pfn_ref().

If we're clever, we might even be able to share the flag with the "guest private
memory"[*] concept being pursued for confidential VMs.

[*] https://lore.kernel.org/all/20211223123011.41044-1-chao.p.peng@linux.intel.com

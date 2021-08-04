Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C603DF9ED
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 05:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhHDDMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 23:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbhHDDMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 23:12:38 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C55C061798;
        Tue,  3 Aug 2021 20:12:04 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id f8so515647ilr.4;
        Tue, 03 Aug 2021 20:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VgjNmTtUCekqMJuPhdkOwY12hWYBqmEMHhuoCL31ByI=;
        b=Qh1t8Q1W0M0NYHbZCM8FYnt1o7Y1swpfS+HFC+xGi5tg1ljs5fPfZqzL3FQtwmS3V0
         9FfKHWI+Bi+SSHR0phWapRc/BLyuU35jX3snHlYBqvHFShsXF22A69yOixLvncKs0ZGW
         JE1WFo13S2Th0dem/yf1nEprLwv+P9/jnvYrBIx1YyUW1t7PmiOi0rzmYm9HEL6/fLr3
         4wUbeTaWEeTMjSzcrozmhfgvjgXA7naqdLNgvkvsI8Z9iblO0yFQoHegXpfuwspfHlB6
         gYuHS/+vwoh/CIk8OFhpU4x2cCkdmxGzBc8qCC4NuXr1MIF5RLogPr2PePccqsm/kIyr
         ydEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VgjNmTtUCekqMJuPhdkOwY12hWYBqmEMHhuoCL31ByI=;
        b=aJQi+Df6zNqBR7DVsuy2rsoCuOpOwpKZs8t2r2ZY3smSqUHW9pa3W6sM3QbFNOqzZn
         ksO6WyzmCqH7/2OvKfEEfbip818rTpSQP2nkZxs2s6x2xO0bfiZORihdaQf3m8uh0+JW
         UzEbT5CP0XMCR0FZzOAviNzps798TTkBZ4GEFRh+BwasRKSX5zqZRH7ywNfV2PEKB/rO
         RHOBX5jl2j73QjmYR3t9otGLqEBE7+Dxez1tFFQDDbntOb8JBxrM+779lQ7WCBDORisM
         KidC6pI/rSVdGgvPUlTMLNpTRMAOceD4UIp16ucm8dxKUBcZ8c/hPViy5C22hTZUelra
         /HIw==
X-Gm-Message-State: AOAM5324Fr5ZfC7i9KU+7gn2nf/nTXAXqlWMnIZ9w2Q2ir/CvVuTm/41
        5Djd20+9uE/iFpoOXFvmFH9RyaYtI2b5s1GRkgM=
X-Google-Smtp-Source: ABdhPJwKxDgXCokuxlcg93EAaGtZ655oYlj6+j9UfPEMcGJrEXqf9j5cNroVlNKgXBC0RaeX2KF22HGG2DMiz6j7VtI=
X-Received: by 2002:a05:6e02:10a:: with SMTP id t10mr289427ilm.52.1628046724057;
 Tue, 03 Aug 2021 20:12:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-2-sean.j.christopherson@intel.com> <CAJhGHyCPyu6BVZwqvySeT2LSr81Xospdv2O=ssvTQv0Rvky0UA@mail.gmail.com>
 <YQljNBBp/EousNBk@google.com>
In-Reply-To: <YQljNBBp/EousNBk@google.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Wed, 4 Aug 2021 11:11:52 +0800
Message-ID: <CAJhGHyDbCbP3+oN-EpX_KLYKpzDhotpwASAxMSRScGjtdRNOtA@mail.gmail.com>
Subject: Re: [PATCH v3 01/37] KVM: VMX: Flush all EPTP/VPID contexts on remote
 TLB flush
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 3, 2021 at 11:39 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Aug 03, 2021, Lai Jiangshan wrote:
> > (I'm replying to a very old email, so many CCs are dropped.)
> >
> > On Sat, Mar 21, 2020 at 5:33 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > Flush all EPTP/VPID contexts if a TLB flush _may_ have been triggered by
> > > a remote or deferred TLB flush, i.e. by KVM_REQ_TLB_FLUSH.  Remote TLB
> > > flushes require all contexts to be invalidated, not just the active
> > > contexts, e.g. all mappings in all contexts for a given HVA need to be
> > > invalidated on a mmu_notifier invalidation.  Similarly, the instigator
> > > of the deferred TLB flush may be expecting all contexts to be flushed,
> > > e.g. vmx_vcpu_load_vmcs().
> > >
> > > Without nested VMX, flushing only the current EPTP/VPID context isn't
> > > problematic because KVM uses a constant VPID for each vCPU, and
> >
> > Hello, Sean
> >
> > Is the patch optimized for cases where nested VMX is active?
>
> Well, this patch isn't, but KVM has since been optimized to do full EPT/VPID
> flushes only when "necessary".  Necessary in quotes because the two uses can
> technically be further optimized, but doing so would incur significant complexity.

Hello, thanks for your reply.

I know there might be a lot of possible optimizations to be considered, many of
which are too complicated to be implemented.

The optimization I considered yesterday is "ept_sync_global() V.S.
ept_sync_context(this_vcpu's)" in the case: when the VM is using EPT and
doesn't allow nested VMs.  (And I failed to express it yesterday)

In this case, the vCPU uses only one single root_hpa, and I think ept sync
for single context is enough for both cases you listed below.

When the context is flushed, the TLB for the vCPU is clean to run.

If kvm changes the mmu->root_hpa, it is kvm's responsibility to request
another flush which is implemented.

In other words, KVM_REQ_TLB_FLUSH == KVM_REQ_TLB_FLUSH_CURRENT in this case.
And before this patch, kvm flush only the single context rather than global.

>
> Use #1 is remote flushes from the MMU, which don't strictly require a global flush,
> but KVM would need to propagate more information (mmu_role?) in order for responding
> vCPUs to determine what contexts needs to be flushed.  And practically speaking,
> for MMU flushes there's no meaningful difference when using TDP without nested
> guests as the common case will be that each vCPU has a single active EPTP and
> that EPTP will be affected by the MMU changes, i.e. needs to be flushed.

I don't see when we need "to determine what contexts" since the vcpu is
using only one context in this case which is the assumption in my mind,
could you please correct me if I'm wrong.

Thanks,
Lai.

>
> Use #2 is in VMX's pCPU migration path.  Again, not strictly necessary as KVM could
> theoretically track which pCPUs have run a particular vCPU and when that pCPU last
> flushed EPT contexts, but fully solving the problem would be quite complex.  Since
> pCPU migration is always going to be a slow path, the extra complexity would be
> very difficult to justify.
>
> > I think the non-nested cases are normal cases.
> >
> > Although the related code has been changed, the logic of the patch
> > is still working now, would it be better if we restore the optimization
> > for the normal cases (non-nested)?
>
> As above, vmx_flush_tlb_all() hasn't changed, but the callers have.

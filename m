Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D23E3E0443
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 17:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239121AbhHDPd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 11:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239117AbhHDPd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 11:33:56 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF88C061798
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 08:33:44 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j18-20020a17090aeb12b029017737e6c349so6062129pjz.0
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 08:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wbpJGFJvkzZydOUQtVC29IDIfUVRd4suNfnW9QERB1s=;
        b=ghjlb3IIlrpXwg9tf/3YPnZxi59R8nep+PS0uvgImD5ovEeb1R9C8KN5TD0CqkzPIl
         C+MZlUN3uG/hpoG4HSOibtxj1dn8X1EucpL3+qt1lK3atvdHx7h4o1kVNUCF88RQp5Yd
         AHCshzjKU0fTgCOBav3Kq7H/xvuk/UHJZhir1dX8OXuE8Ks8OxqwFof4CwiMTrn8rUB5
         xHdXl98hETf3tAYgQ5Xe8ZzsPzINRG4vrb8gniGmie/IrhKfXJhqbiylR0ajA+Yfr8w3
         cmLJH07SROXVr0xlbhRQeGuwv4h43WJ+QAkQkwW4bzACh1PS9MzEyRsRIyaks4hUSPtF
         ik1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wbpJGFJvkzZydOUQtVC29IDIfUVRd4suNfnW9QERB1s=;
        b=npD4FOuIIv/Irl3//aQEPx7RALz1zxFk/wOkN/PDgufk15LHDKTCCuwm4u0Pto2zNo
         34vNzGxcgYnQc5HnwL+kte79unbGRSnO5tLhTErFBZii/fLPZzn/lv7tQ9Ziu9IJhB2N
         tRMvKpFjshGGwNamlFlFnfcQsBwd4Moc2GpMFxyAM00LrYwdp7D5vNnAzHVIR+ty3G6/
         8wrhXPOrqEpUBycxKlgniBvKuP3wbg7cIVNUY6FD3N9vh5XEzoJ1a8ismMObGoJPNrxt
         1Zx6ARFUQfd5/kkE/0p6ZOxuHZvpLzxG2EifFyNcy0tfsOqRHjRTvqAb/UV1abyFuL0K
         yHUQ==
X-Gm-Message-State: AOAM533NaLrwFJmphbVSac8iXaspfFpQ6SzZ38twrJ4/Kg/spejXLtYy
        yXlujZCEc315IvvglAJBbtbwPw==
X-Google-Smtp-Source: ABdhPJz+jPJPIq2h8V9H/5cEj7w9hHV/H2WUf6f+RgjDCV4oPt733HkSZIkPpwyAlT1+bzkyTE6/TQ==
X-Received: by 2002:a17:902:d4cc:b029:12b:9b9f:c38d with SMTP id o12-20020a170902d4ccb029012b9b9fc38dmr23444486plg.41.1628091223364;
        Wed, 04 Aug 2021 08:33:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x19sm3996157pgk.37.2021.08.04.08.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:33:42 -0700 (PDT)
Date:   Wed, 4 Aug 2021 15:33:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/37] KVM: VMX: Flush all EPTP/VPID contexts on
 remote TLB flush
Message-ID: <YQqzU26ok3MXCzs8@google.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-2-sean.j.christopherson@intel.com>
 <CAJhGHyCPyu6BVZwqvySeT2LSr81Xospdv2O=ssvTQv0Rvky0UA@mail.gmail.com>
 <YQljNBBp/EousNBk@google.com>
 <CAJhGHyDbCbP3+oN-EpX_KLYKpzDhotpwASAxMSRScGjtdRNOtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyDbCbP3+oN-EpX_KLYKpzDhotpwASAxMSRScGjtdRNOtA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021, Lai Jiangshan wrote:
> The optimization I considered yesterday is "ept_sync_global() V.S.
> ept_sync_context(this_vcpu's)" in the case: when the VM is using EPT and
> doesn't allow nested VMs.  (And I failed to express it yesterday)
> 
> In this case, the vCPU uses only one single root_hpa,

This is not strictly guaranteed.  kvm_mmu_page_role tracks efer.NX, cr0.wp, and
cr4.SMEP/SMAP (if cr0.wp=0), which means that KVM will create a a different root
if the guest toggles any of those bits.  I'm pretty sure that can be changed and
will look into doing so in the near future[*], but even that wouldn't guarantee
a single root.

SMM is also incorporated in the page role and will result in a different roots
for SMM vs. non-SMM.  This is mandatory because SMM has its own memslot view.

A CPUID.MAXPHYADDR change can also change the role, but in this case zapping all
roots will always be the correct/desired behavior.

[*] https://lkml.kernel.org/r/YQGj8gj7fpWDdLg5@google.com

> and I think ept sync for single context is enough for both cases you listed below.
> 
> When the context is flushed, the TLB for the vCPU is clean to run.
> 
> If kvm changes the mmu->root_hpa, it is kvm's responsibility to request
> another flush which is implemented.

KVM needs to flush when it allocates a new root, largely because it has no way
of knowing if some other entity previously created a CR3/EPTP at that HPA, but
KVM isn't strictly required to flush when switching to a previous/cached root.

Currently this is a moot point because kvm_post_set_cr0(), kvm_post_set_cr4(),
set_efer(), and kvm_smm_changed() all do kvm_mmu_reset_context() instead of
attempting a fast PGD switch, but I am hoping to change this as well, at least
for the non-SMM cases.

> In other words, KVM_REQ_TLB_FLUSH == KVM_REQ_TLB_FLUSH_CURRENT in this case.
> And before this patch, kvm flush only the single context rather than global.
> 
> >
> > Use #1 is remote flushes from the MMU, which don't strictly require a global flush,
> > but KVM would need to propagate more information (mmu_role?) in order for responding
> > vCPUs to determine what contexts needs to be flushed.  And practically speaking,
> > for MMU flushes there's no meaningful difference when using TDP without nested
> > guests as the common case will be that each vCPU has a single active EPTP and
> > that EPTP will be affected by the MMU changes, i.e. needs to be flushed.
> 
> I don't see when we need "to determine what contexts" since the vcpu is
> using only one context in this case which is the assumption in my mind,
> could you please correct me if I'm wrong.

As it exists today, I believe you're correct that KVM will only ever have a
single reachable TDP root, but only because of overzealous kvm_mmu_reset_context()
usage.  The SMM case in particular could be optimized to not zap all roots (whether
or not it's worth optimizing is another question).

All that said, the easiest way to query the number of reachable roots would be to
check the previous/cached root.

But, even if we can guarantee there's exactly one reachable root, I would be
surprised if doing INVEPT.context instead of INVEPT.global actually provided any
meaningful performance benefit.  Using INVEPT.context is safe if and only if there
are no other TLB entries for this vCPU, and KVM must invalidate on pCPU migration,
so there can't be collateral damage in that sense.

That leaves the latency of INVEPT as the only possible performance delta, and that
will be uarch specific.  It's entirely possible INVEPT.global is slower, but again
I would be surprised if it is so much slower than INVEPT.context that it actually
impacts guest performance given that its use is limited to slow paths.

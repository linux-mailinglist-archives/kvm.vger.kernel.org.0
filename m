Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EE1393A39
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 02:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbhE1A1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 20:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbhE1A1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 20:27:54 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F7CC061574
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 17:26:18 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y202so1923721pfc.6
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 17:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jfKJjdbN+4DQtjPEpX3uCd+w5dzOr3n8hSCgp5RxnpE=;
        b=osymOpvBI+/3/qFdiYrxBqmhbyNl/HSaiueObC3aBEK6k19qyX39F/euezWR30Lv43
         rnOZqYmtdlawMzR58Bld35H31ZYIyZFhPgTsEeMvijUrXjO4Ls/tBzAcDC/cPbwYZkg1
         js50Pdxdq+3bvD7TS6zXkAU7IrVGk54YnexJiJzZM7Z9EnBilY+obzqSIqJlcI4H/g1C
         nebnSiv65PU6f6zQZlL2vpjSAXMFNTYfKsPvzsPWc1psgtS3RkqQZMviy/oKOfqQU+2I
         OLsJWBJyorJ3b+3vK0c6HTFpnAdLEnVzkCEVGAaEy0WInGefXk1m0pv0VTViUBM3aImz
         8fBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jfKJjdbN+4DQtjPEpX3uCd+w5dzOr3n8hSCgp5RxnpE=;
        b=Au6JCV28fiIqRwyo7CRN6pOdvnmwUHPgmF6cKoHrQAp4AitNq4m6H8TCzqE3obVM25
         nffVLl8S/7VnRtFHqb60/Doc9V4lFu6hB22v4zOxbfw7lrq2hgZzl5Thq43/2cn6UoNG
         DiddWR32ntJDPwbtyzS4/dwUMZtSH17uTubH4FUr3ToUdi3EKPkXyF9hyfHLgSKvVJEO
         Opy392FOoUdTkgI6xGdpisei3P05sLgSRe2tZtC0gx+BXXDWVoU1D8/jcCfyw4x4hmwF
         7tYMlrVevE6WrCCDeDsOeAaD2GLAToSxUGJ6QNTqrFcy82s8MJvq9hzD7A4g047FL3eU
         uDdQ==
X-Gm-Message-State: AOAM531phyVJ6BSTIfI6y/k6bVq4qwhys26iQP8ErQDCg3fHc0V4Pg5i
        GhTRmxuTk+vgRF8roWQ+uYtFcg==
X-Google-Smtp-Source: ABdhPJxUIZ35EU+VYc9PqZf7JgWm+tdhfnA90/4/EWrKCbXvMEpgbtor5FEgjYZzQIBmVf7MRW7G0A==
X-Received: by 2002:a63:5243:: with SMTP id s3mr6164029pgl.247.1622161578159;
        Thu, 27 May 2021 17:26:18 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id f17sm2829294pgi.26.2021.05.27.17.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 17:26:17 -0700 (PDT)
Date:   Fri, 28 May 2021 00:26:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <laijs@linux.alibaba.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH] KVM: X86: fix tlb_flush_guest()
Message-ID: <YLA4peMjgeVvKlEn@google.com>
References: <20210527023922.2017-1-jiangshanlai@gmail.com>
 <78ad9dff-9a20-c17f-cd8f-931090834133@redhat.com>
 <YK/FGYejaIu6EzSn@google.com>
 <d96f8c11-19e6-2c2d-91ff-6a7a51fa1b9c@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d96f8c11-19e6-2c2d-91ff-6a7a51fa1b9c@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 28, 2021, Lai Jiangshan wrote:
> 
> On 2021/5/28 00:13, Sean Christopherson wrote:
> > And making a request won't work without revamping the order of request handling
> > in vcpu_enter_guest(), e.g. KVM_REQ_MMU_RELOAD and KVM_REQ_MMU_SYNC are both
> > serviced before KVM_REQ_STEAL_UPDATE.
> 
> Yes, it just fixes the said problem in the simplest way.
> I copied KVM_REQ_MMU_RELOAD from kvm_handle_invpcid(INVPCID_TYPE_ALL_INCL_GLOBAL).
> (If the guest is not preempted, it will call invpcid_flush_all() and will be handled
> by this way)

The problem is that record_steal_time() is called after KVM_REQ_MMU_RELOAD
in vcpu_enter_guest() and so the reload request won't be recognized until the
next VM-Exit.  It works for kvm_handle_invpcid() because vcpu_enter_guest() is
guaranteed to run between the invcpid code and VM-Enter.

> The improvement code will go later, and will not be backported.

I would argue that introducing a potential performance regression is in itself a
bug.  IMO, going straight to kvm_mmu_sync_roots() is not high risk.

> The proper way to flush guest is to use code in
> 
> https://lore.kernel.org/lkml/20210525213920.3340-1-jiangshanlai@gmail.com/
> as:
> +		kvm_mmu_sync_roots(vcpu);
> +		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu); //or just call flush_current directly
> +		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> +			vcpu->arch.mmu->prev_roots[i].need_sync = true;
> 
> If need_sync patch is not accepted, we can just use kvm_mmu_sync_roots(vcpu)
> to keep the current pagetable and use kvm_mmu_free_roots() to free all the other
> roots in prev_roots.

I like the idea, I just haven't gotten around to reviewing that patch yet.

> > Cleaning up and documenting the MMU related requests is on my todo list, but the
> > immediate fix should be tiny and I can do my cleanups on top.
> > 
> > I believe the minimal fix is:
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 81ab3b8f22e5..b0072063f9bf 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3072,6 +3072,9 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
> >   static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
> >   {
> >          ++vcpu->stat.tlb_flush;
> > +
> > +       if (!tdp_enabled)
> > +               kvm_mmu_sync_roots(vcpu);
> 
> it doesn't handle prev_roots which are also needed as
> shown in kvm_handle_invpcid(INVPCID_TYPE_ALL_INCL_GLOBAL).

Ya, I belated realized this :-)

> >          static_call(kvm_x86_tlb_flush_guest)(vcpu);
> 
> For tdp_enabled, I think it is better to use kvm_x86_tlb_flush_current()
> to make it consistent with other shadowpage code.
> 
> >   }
> > 

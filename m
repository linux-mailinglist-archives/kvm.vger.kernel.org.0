Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D29409E5F
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 22:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244787AbhIMUu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 16:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243614AbhIMUuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 16:50:50 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5134EC061760
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 13:49:34 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id w8so10571851pgf.5
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 13:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RQzEqr1T7I8/HrHx9Rq66MMtYgsgD2oLAEmtDI7OqZc=;
        b=ReajyV3aNSWB9Ex6i0PV7gE/Sw74DD1JlmY5sIWimUGbwjzc0vlZLYKRZ8T3/GLr5i
         Uzykzo2P9MS3votUbXRI/aPYnFWT643UyEHtQ4asGVkhXUTYzWCYkgLN3nktoiYMIroZ
         ojr7GoUPsr1YwajKKUtVgT8sbz6g4+prdFvsF0eH4dW2mjPtRjpz3cm3F13rLgd9GRVm
         ACh7FmwEaLkjBZ26tcrgbzmRfpS1Vx+tMVAojDj+pYvpyemNCc4on/PY6fmEu7cQPB/d
         qO5BArNVR+MrPrk63MIfa6M8u9BzS8M3hD6OcQxaCoVcvKSDYju8uiMOspBTNjZHI8lK
         jlUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RQzEqr1T7I8/HrHx9Rq66MMtYgsgD2oLAEmtDI7OqZc=;
        b=XWGksdQsJYOZ2d/uWC0HEpWL5U4k/aptA98/CO+I06mC3Xhy5LzfZ00lCoH4o/06Rt
         WlKnhCjaBtGGKac5Hn9UJeUNGSCHiwBIldigajGXyF4mNj0MHSo5pV/o+4aS3NsvHrzc
         v9Rf4OiGCH5VXu2mgIb6vQcL6JATTwPSe6EsJh3UcQg9AP/HxgLdLh4EG1Go1alfq+6M
         nRphNhyZyeFfYSlhCWr5TP/4vHIwOxlX8YzoaDRN3E/QHJvgcZ9Y89uKugbwtVqUwSJJ
         Q0I7AjILOuttrENv0MyhTsgbaOlmCSUMoDXCaSeVcLegnRcJFkhSzOEgDPN90o56p4Qf
         LZDA==
X-Gm-Message-State: AOAM532XFBM+cfNW/X5yoS9cXXGgj21GuBtZOsqfCPNkEQsW4PopdGDA
        zqiFFGJzT+cM9/Pe+mhuTDKRgQ==
X-Google-Smtp-Source: ABdhPJwHxjctwbqGCRw/0LuBqIOm5OxixfKTnteCD/n3TDXUgaqGwmu9s2pBs0WTHi/errQYlfpEdw==
X-Received: by 2002:a63:790b:: with SMTP id u11mr12493490pgc.71.1631566173604;
        Mon, 13 Sep 2021 13:49:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c23sm8859073pgb.74.2021.09.13.13.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 13:49:33 -0700 (PDT)
Date:   Mon, 13 Sep 2021 20:49:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: X86: Synchronize the shadow pagetable before
 link it
Message-ID: <YT+5WZsT4bfFSezR@google.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
 <20210824075524.3354-3-jiangshanlai@gmail.com>
 <YTFhCt87vzo4xDrc@google.com>
 <0103c8b2cccea601bd3474f47d982b37e9536921.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0103c8b2cccea601bd3474f47d982b37e9536921.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021, Maxim Levitsky wrote:
> On Thu, 2021-09-02 at 23:40 +0000, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 4853c033e6ce..03293cd3c7ae 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2143,8 +2143,10 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> >  			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> >  		}
> > 
> > -		if (sp->unsync_children)
> > -			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> > +		if (sp->unsync_children) {
> > +			kvm_make_all_cpus_request(KVM_REQ_MMU_SYNC, vcpu);
> 
> I don't know the KVM mmu well so I miss something here most likely,
> but why to switch to kvm_make_all_cpus_request?
> 
> MMU is shared by all VCPUs, and the process of its syncing should also do
> remote TLB flushes when needed?
> 
> Another thing I don't fully understand is why this patch is needed. If we
> link an SP which has unsync children, we raise KVM_REQ_MMU_SYNC, which I
> think means that *this* vCPU will sync the whole MMU on next guest entry,
> including these unsync child SPs. Could you explain this?

Answering all three questions at once, the problem is that KVM links in a new SP
that points at unsync'd SPs _before_ servicing KVM_REQ_MMU_SYNC.  While the vCPU
is guaranteed to service KVM_REQ_MMU_SYNC before entering the guest, that doesn't
hold true for other vCPUs.  As a result, there's a window where a different vCPU
can consume the stale, unsync SP via the new SP.

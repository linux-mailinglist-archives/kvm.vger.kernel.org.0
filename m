Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4821F46D6FC
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 16:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbhLHPdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 10:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbhLHPdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 10:33:20 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079AAC0617A1
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 07:29:49 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id v19so1740617plo.7
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 07:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bx79bbHOGAPyS128gUbYFagJafFBhzXxPcU12ZQb0E8=;
        b=Vt5xnwihkJBpinleu5NTk74MbcMLbdmjQzByL2C9+F0d3I6Oq36ZAMXQX/2tCNJAGc
         H3rXgk//b19rfZDA7bi6xKtUSi81e3XNAIV2KPOnPw0Mb4WLHizUDCWNi7I6j2JYNFy5
         OP6PREYWlEu2bi5bC5cIyvG6Rmic+Nj3gWB1HQVdh5z1GdSrraB6CZaqCYxwCnRGyAD9
         aFDa9s9gCLnbGPGQ24gwRSNfT302xkqjJnJF6vIt+1Led+K3W2NZUoM/LzYjB+4sWozD
         yEyBJA35t8MNmOg5RdbrBrgPjFfWMqnepFkDWdMLmrEnvnU6qIVdw14MQuex5RbPmPuW
         ElFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bx79bbHOGAPyS128gUbYFagJafFBhzXxPcU12ZQb0E8=;
        b=SaDA41K8VAiB8ABM7IKI69pdRdv8c5JQ1IhZbt2kakwUdfI4OeMrWpH2yyBbIbvCr3
         mTH0Wegz6pab5eh1xAolw0PNw5T014lKoqLab8Ju0vHqbptXY8El+iLbM0cY5gz8DqV+
         CYbsGI/xJHesT9EUM1APBjGm7ph9oa2dlKGm7xEzIVMZwuGXEe1PDM+MaG4ybGe32gbL
         EmrmnycNvzDYRzalETv6UNPytyE0CAUZKjGHONBeSCTplONKrGfGquEfuhViI3hGX7lC
         P27sIKt4ifukO03Qn6lbG+ghoQzL7Jk5NeVp4tkgqWHolbb6zT7eKSL+nWiZywa+tIka
         8UlA==
X-Gm-Message-State: AOAM531hGuFQ7c3WY1BWLLFA7cyl+g41VXnIC2dIbc/Yq7IH/HR3DKm/
        T6LQJyekjQAuPdk214d8fNKNNw==
X-Google-Smtp-Source: ABdhPJz+SIcHsVJGySFxa1mWVPAQ0geg175PKcgHrd298fQsw0ChdI1MTWwKPIhULfZCgTtOBXh/ig==
X-Received: by 2002:a17:90b:4c0b:: with SMTP id na11mr8222021pjb.53.1638977388334;
        Wed, 08 Dec 2021 07:29:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id rj8sm7136438pjb.0.2021.12.08.07.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 07:29:47 -0800 (PST)
Date:   Wed, 8 Dec 2021 15:29:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <laijs@linux.alibaba.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>
Subject: Re: [PATCH 17/15] KVM: X86: Ensure pae_root to be reconstructed for
 shadow paging if the guest PDPTEs is changed
Message-ID: <YbDPaFcwmgfnKqTW@google.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211111144634.88972-1-jiangshanlai@gmail.com>
 <Ya/5MOYef4L4UUAb@google.com>
 <04d4d0bc-0ef4-f9a3-593b-149f835c74be@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04d4d0bc-0ef4-f9a3-593b-149f835c74be@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 08, 2021, Lai Jiangshan wrote:
> 
> 
> On 2021/12/8 08:15, Sean Christopherson wrote:
> > > 
> > > The commit 21823fbda552("KVM: x86: Invalidate all PGDs for the current
> > > PCID on MOV CR3 w/ flush") skips kvm_mmu_free_roots() after
> > > load_pdptrs() when rewriting the CR3 with the same value.
> > 
> > This isn't accurate, prior to that commit KVM wasn't guaranteed to do
> > kvm_mmu_free_roots() if it got a hit on the current CR3 or if a previous CR3 in
> > the cache matched the new CR3 (the "cache" has done some odd things in the past).
> > 
> > So I think this particular flavor would be:
> > 
> >    Fixes: 7c390d350f8b ("kvm: x86: Add fast CR3 switch code path")
> 
> If guest is 32bit, fast_cr3_switch() always return false, and
> kvm_mmu_free_roots() is always called, and no cr3 goes in prev_root.

Oh, duh, PAE paging.

> > > +		/*
> > > +		 * Ensure the dirty PDPTEs to be loaded for VMX with EPT
> > > +		 * enabled or pae_root to be reconstructed for shadow paging.
> > > +		 */
> > > +		if (tdp_enabled)
> > > +			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> > > +		else
> > > +			kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
> > 
> > Shouldn't matter since it's legacy shadow paging, but @mmu should be used instead
> > of vcpu->arch.mmuvcpu->arch.mmu.
> 
> @mmu is the "guest mmu" (vcpu->arch.walk_mmu), which is used to walk
> including loading pdptr.
> 
> vcpu->arch.mmu is for host constructing mmu for shadowed or tdp mmu
> which is used in host side management including kvm_mmu_free_roots().
> 
> Even they are the same pointer now for !tdp, the meaning is different.  I prefer
> to distinguish them even before kvm_mmu is split different for guest mmu
> (vcpu->arch.walk_mmu) and host constructing mmu (vcpu->arch.mmu).

I see where you're coming from.  I was viewing it from the perspective of,
"they're the same thing for shadow paging, why reread mmu?".

I'm ok with explicitly referencing arch.mmu, but maybe add a comment?

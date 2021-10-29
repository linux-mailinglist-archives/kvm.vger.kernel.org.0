Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D75D4402DB
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 21:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhJ2TJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 15:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhJ2TJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 15:09:09 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57985C061714
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 12:06:40 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x66so10033471pfx.13
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 12:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ldj1ddyxFxyQn1P+7U21zE8sjEfcNWeGvgdcMjeN8ow=;
        b=GpXuydJMaY5WU3GNXnra8fb0QxJ21K1yg/2Yfr+9y9SdyTweeX/PFEXrDKILHAxhHt
         p6K5FRUHJXAGqi5tOfGlbq3rqnFQCU2R2JiBWlJZtHgQeo8lZksJS8JLuVaKUFln8+UQ
         QB5PdKrNUElX3lot09fgygBgsJvl3WiOqXY3AzxtQyOGbuiadFHr5lhNGeSbw5ZHhmLs
         H0LM4w/AkVBucc8LLr9ItQ1HNz4qJIAUROHDyt2qdPFHUZa7n3x55AsaTmHdFJI1KCih
         uKoXNahx5vdoJcc6I7BJ01DbFRWPY4qTxQsVCnXeB2j8/VlGXuCaFN6C5fzY4NSdp0Ir
         g0aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ldj1ddyxFxyQn1P+7U21zE8sjEfcNWeGvgdcMjeN8ow=;
        b=2WQjfiMfLBKhvgial01qWpo1xxq2qpOx3t8pLYlY8hXUxk5SrDfhm0/CkxrTkUeRnl
         76qXy58cas3VPU1V4XQ2njuW4c032m/KIXG6wg0qLAkx0viDoL+Tr4duLwFx9Y9wAVil
         5gCMwPCLFojyFncnPyNFIYCSuJhSGZJR3rSmBi9pXs6tR6VwQxev39thlKLTJeTfdL45
         JlLXydbljRIT/Fb+xSz6Rxmr/3+T7BE1YD4Cb/sRXocW3nGmqYeyCZl4JcT1zquiwJkN
         lDxeHKG0JFDZIwJYdgyDNxdCoKcCorJTSUJgeZib+qp351EA2zdpEQkpTe5nZ1kouDfO
         hodg==
X-Gm-Message-State: AOAM532UrYelGq4PHMzHj0J4aU/EfqHHEaQSKyuQAh+k9u3mNvN1ED3t
        XtGgn81yaOO8Mhotoabi9yxAIw==
X-Google-Smtp-Source: ABdhPJze0lQCEEqIKDMf/2e7SXLtpJ3is5kITQ6qUJHlSXMzFeN48xOz6hwg/+xzSFZScLJ2N/rB6g==
X-Received: by 2002:a63:8aca:: with SMTP id y193mr1486059pgd.362.1635534399609;
        Fri, 29 Oct 2021 12:06:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m22sm7408458pfo.71.2021.10.29.12.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 12:06:39 -0700 (PDT)
Date:   Fri, 29 Oct 2021 19:06:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ajay Garg <ajaygargnsit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] KVM: x86: Shove vp_bitmap handling down into
 sparse_set_to_vcpu_mask()
Message-ID: <YXxGO5/xO8KWfnKj@google.com>
References: <20211028213408.2883933-1-seanjc@google.com>
 <87pmrokn16.fsf@vitty.brq.redhat.com>
 <YXwF+jSnDq9ONTQJ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXwF+jSnDq9ONTQJ@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 29, 2021, Sean Christopherson wrote:
> On Fri, Oct 29, 2021, Vitaly Kuznetsov wrote:
> > > +	/* If vp_index == vcpu_idx for all vCPUs, fill vcpu_mask directly. */
> > > +	if (likely(!has_mismatch))
> > > +		bitmap = (u64 *)vcpu_mask;
> > > +
> > > +	memset(bitmap, 0, sizeof(vp_bitmap));
> > 
> > ... but in the unlikely case has_mismatch == true 'bitmap' is still
> > uninitialized here, right? How doesn't it crash?
> 
> I'm sure it does crash.  I'll hack the guest to actually test this.

Crash confirmed.  But I don't feel too bad about my one-line goof because the
existing code botches sparse VP_SET, i.e. _EX flows.  The spec requires the guest
to explicit specify the number of QWORDS in the variable header[*], e.g. VP_SET
in this case, but KVM ignores that and does a harebrained calculation to "count"
the number of sparse banks.  It does this by counting the number of bits set in
valid_bank_mask, which is comically broken because (a) the whole "sparse" thing
should be a clue that they banks are not packed together, (b) the spec clearly
states that "bank = VPindex / 64", (c) the sparse_bank madness makes this waaaay
more complicated than it needs to be, and (d) the massive sparse_bank allocation
on the stack is completely unnecessary because KVM simply ignores everything that
wouldn't fit in vp_bitmap.

To reproduce, stuff vp_index in descending order starting from KVM_MAX_VCPUS - 1.

	hv_vcpu->vp_index = KVM_MAX_VCPUS - vcpu->vcpu_idx - 1;

E.g. with an 8 vCPU guest, KVM will calculate sparse_banks_len=1, read zeros, and
do nothing, hanging the guest because it never sends IPIs.

So v2 will be completely different because the "fix" for the KASAN issue is to
get rid of sparse_banks entirely.

[1] https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/hypercall-interface#variable-sized-hypercall-input-headers
[2] https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/datatypes/hv_vp_set#sparse-virtual-processor-set

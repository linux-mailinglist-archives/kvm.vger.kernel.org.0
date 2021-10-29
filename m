Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A208440328
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 21:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhJ2T3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 15:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbhJ2T3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 15:29:14 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7745C061766
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 12:26:45 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id r5so7488476pls.1
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 12:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W0F/ULHmaZ6yiKdcrFiyrI98oNqQ2Wlj0UyZO4mnwig=;
        b=F47FKuzCq49W4X+gP6en7fn4kYhmztJOYUcBSV26Z8eok7j07w09fLc+8XItP5aMYe
         Z/RfI//diXfKeNL4X/3Qnb0hzZOXA9nXpn55U5d6hKHllYKNVk7OPOFHUVmO1ItFZoMg
         azPecgxZus3DPs7bqOdXvPMy77BDMDdrvWES2qgOJp6q5/yA+6f3lw9uuB/EO5lMDoI/
         kD/IrulQy3tQRv5PYfqc0kY5Qp0c2ylbex2KFRJocKKo0xsTSWTPTj2i0dXzXxO+Swp8
         3rk/odoV1H2LP0hv7GbojKNqT5GU2d13Jyx1MECfsVJy6NkAClfkGVsipB4LvasW47PR
         skTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W0F/ULHmaZ6yiKdcrFiyrI98oNqQ2Wlj0UyZO4mnwig=;
        b=NMwXQ9JLshDl+Z5nX5FsT52AUVLiBK5UjPxtj01gWphEAKAjUpQVJGgZNZ9mDrBYhy
         1Q/zGeHIzi5fdajWL5qEkZgmpLW3wOr7ZaRzUh9hjaiiQjv5BffZA/q9gyALjDl1/x21
         /S7eIBrJSV7Wbu7ralb+d3Iece1bYXSNG+qSTiEi3eIC0ClCijA1qGlBmkg78pbc9BnK
         im+ShZ9Sju4f8FPbxaObukp8sSScQ3kp13QcpnUcm1k4ahyL2fykcUYVDnmSUvCqHaPx
         mcPFsVA9Tg9Jc2KgWmRI456sgXiLWyMb8NueK/SDGPxpDONtQwpW1zLqLLy7zV2uA3iK
         1MDg==
X-Gm-Message-State: AOAM530YIxJm3NtunxX1kZZQimUk3GnQTl/ZowAUjklGIDbHHc6Og5gQ
        1ohG+KIyQ0WXQMwcd6h/qp2zQQ==
X-Google-Smtp-Source: ABdhPJwW8BXMaJw7SFj0kyzLqqWfj6DzD2/RqEruvPjTrn6wlXc1lGIxiYDfcNVKF5ztZtzeCxQu7g==
X-Received: by 2002:a17:902:bf02:b0:13f:cfdd:804e with SMTP id bi2-20020a170902bf0200b0013fcfdd804emr11296417plb.1.1635535604654;
        Fri, 29 Oct 2021 12:26:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 17sm6670375pgr.10.2021.10.29.12.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 12:26:44 -0700 (PDT)
Date:   Fri, 29 Oct 2021 19:26:40 +0000
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
Message-ID: <YXxK8CcIk2MiVw2p@google.com>
References: <20211028213408.2883933-1-seanjc@google.com>
 <87pmrokn16.fsf@vitty.brq.redhat.com>
 <YXwF+jSnDq9ONTQJ@google.com>
 <YXxGO5/xO8KWfnKj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXxGO5/xO8KWfnKj@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 29, 2021, Sean Christopherson wrote:
> On Fri, Oct 29, 2021, Sean Christopherson wrote:
> > On Fri, Oct 29, 2021, Vitaly Kuznetsov wrote:
> > > > +	/* If vp_index == vcpu_idx for all vCPUs, fill vcpu_mask directly. */
> > > > +	if (likely(!has_mismatch))
> > > > +		bitmap = (u64 *)vcpu_mask;
> > > > +
> > > > +	memset(bitmap, 0, sizeof(vp_bitmap));
> > > 
> > > ... but in the unlikely case has_mismatch == true 'bitmap' is still
> > > uninitialized here, right? How doesn't it crash?
> > 
> > I'm sure it does crash.  I'll hack the guest to actually test this.
> 
> Crash confirmed.  But I don't feel too bad about my one-line goof because the
> existing code botches sparse VP_SET, i.e. _EX flows.  The spec requires the guest
> to explicit specify the number of QWORDS in the variable header[*], e.g. VP_SET
> in this case, but KVM ignores that and does a harebrained calculation to "count"
> the number of sparse banks.  It does this by counting the number of bits set in
> valid_bank_mask, which is comically broken because (a) the whole "sparse" thing
> should be a clue that they banks are not packed together, (b) the spec clearly
> states that "bank = VPindex / 64", (c) the sparse_bank madness makes this waaaay
> more complicated than it needs to be, and (d) the massive sparse_bank allocation
> on the stack is completely unnecessary because KVM simply ignores everything that
> wouldn't fit in vp_bitmap.
> 
> To reproduce, stuff vp_index in descending order starting from KVM_MAX_VCPUS - 1.
> 
> 	hv_vcpu->vp_index = KVM_MAX_VCPUS - vcpu->vcpu_idx - 1;
> 
> E.g. with an 8 vCPU guest, KVM will calculate sparse_banks_len=1, read zeros, and
> do nothing, hanging the guest because it never sends IPIs.
 
Ugh, I can't read.  The example[*] clarifies that the "sparse" VP_SET packs things
into BankContents.  I don't think I imagined my guest hanging though, so something
is awry.  Back to debugging...

[*] https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/datatypes/hv_vp_set#processor-set-example

> So v2 will be completely different because the "fix" for the KASAN issue is to
> get rid of sparse_banks entirely.
> 
> [1] https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/hypercall-interface#variable-sized-hypercall-input-headers
> [2] https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/datatypes/hv_vp_set#sparse-virtual-processor-set

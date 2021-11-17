Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59501454CC0
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 19:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239846AbhKQSHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 13:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239853AbhKQSHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 13:07:19 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3F7C061764
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 10:04:21 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id g28so2964990pgg.3
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 10:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zDX6ist1CW/Kt9E+Nmm14/qAnVEcGr3fNDAT3kZwsGc=;
        b=BG3WtmivGHTx48BrWAR+lm3sahWCjRDWXAsYqxvgczJT/rw4Jds7UzRchVhye/Wwql
         U8e9I33eQFEyJXH1Z0ikLVqgVEcnFsVhSclSQX5My5aXKj33itxaHx0EWvb64qL6gdXO
         4nvIOBG6EpJ8JzKwvKQSjojdpmcJqziuR37dBuJH7ESjMaYZZ4lblvRXkW1h8wHfdRzQ
         6agcwgQ7cOz+jkYJVwF0LTUMKmmJEswrFzBG/a+BhsVGhEoiNgGEHpZCYnHZ+o8nbEOC
         h/1hHj3rOvk4cgkjcFP2jwXkVy6knjk+HrV1swbHSJaJLw7GybFOi6p5YtZfxYUvfhOW
         QxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zDX6ist1CW/Kt9E+Nmm14/qAnVEcGr3fNDAT3kZwsGc=;
        b=uuCwd16XT2JIj9ZUjRyKApOYxZHRXWGShYTdo/YShJknFHVJnK7+Rk4Vi+NjOr+jGG
         Rd4T3YIWZge41AKt0Bj4lKRMcXbWvKfxjBquHNMYtPc5VIZuspEvAyHUtOx7StfUE+s2
         yhurH20gXhgTrbtWIkR9N6FEVvRYNcnB/ID7ByBgzozu1l/Ap5P2ZUkyX2PHvStO9s4o
         J2rv3FLwShEkVsE8fFADzNBjzxVeJUuBkW4c+1j8psUNi3s/aoznJwPPxET1oEtVBup8
         rk4jfLTKVl2YVxBME7PDacuRI5M072R/ztnSLDCwlCLexos+RfV8DQ97E4kV87vSF+v+
         OgSQ==
X-Gm-Message-State: AOAM530/ccoBAlZs47Undbr7DTSYg8GMl5e36nX5cMYTIIa5u8FlOrsN
        j+KRneHZtRMeJ9cJpaIRflXcYg==
X-Google-Smtp-Source: ABdhPJy9qodD7Yj26nxESHdjefY2nw7+RNXAjwWjuhKH7pnA7/hQihrB+OgGC5GMtDTTZpjF5A/iYQ==
X-Received: by 2002:a05:6a00:2443:b0:44e:ec:f388 with SMTP id d3-20020a056a00244300b0044e00ecf388mr49907957pfj.7.1637172260453;
        Wed, 17 Nov 2021 10:04:20 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g21sm312318pfc.95.2021.11.17.10.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 10:04:19 -0800 (PST)
Date:   Wed, 17 Nov 2021 18:04:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Hou Wenlong <houwenlong93@linux.alibaba.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Skip tlb flush if it has been done in
 zap_gfn_range()
Message-ID: <YZVEINlaIIMUO221@google.com>
References: <5e16546e228877a4d974f8c0e448a93d52c7a5a9.1637140154.git.houwenlong93@linux.alibaba.com>
 <d95f29e5-efef-4a58-420c-a446c3a684e9@redhat.com>
 <YZU10wflDOJ5S/PY@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZU10wflDOJ5S/PY@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 17, 2021, Sean Christopherson wrote:
> On Wed, Nov 17, 2021, Paolo Bonzini wrote:
> > On 11/17/21 10:20, Hou Wenlong wrote:
> > > If the parameter flush is set, zap_gfn_range() would flush remote tlb
> > > when yield, then tlb flush is not needed outside. So use the return
> > > value of zap_gfn_range() directly instead of OR on it in
> > > kvm_unmap_gfn_range() and kvm_tdp_mmu_unmap_gfn_range().
> > > 
> > > Fixes: 3039bcc744980 ("KVM: Move x86's MMU notifier memslot walkers to generic code")
> > > Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> > > ---
> > >   arch/x86/kvm/mmu/mmu.c     | 2 +-
> > >   arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
> > >   2 files changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 354d2ca92df4..d57319e596a9 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1582,7 +1582,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> > >   		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
> > >   	if (is_tdp_mmu_enabled(kvm))
> > > -		flush |= kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
> > > +		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
> > >   	return flush;
> > >   }
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index 7c5dd83e52de..9d03f5b127dc 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -1034,8 +1034,8 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
> > >   	struct kvm_mmu_page *root;
> > >   	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
> > > -		flush |= zap_gfn_range(kvm, root, range->start, range->end,
> > > -				       range->may_block, flush, false);
> > > +		flush = zap_gfn_range(kvm, root, range->start, range->end,
> > > +				      range->may_block, flush, false);
> > >   	return flush;
> > >   }
> > > 
> > 
> > Queued both, thanks.
> 
> Please replace patch 02 with the below.  Hou's patch isn't wrong, but it's nowhere
> near agressive enough in purging the unecessary flush.  I was too slow in writing
> a changelog for this patch in my local repo.

Even better, take Ben's patch :-)

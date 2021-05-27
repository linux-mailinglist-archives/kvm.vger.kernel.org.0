Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C20393634
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 21:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbhE0T0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 15:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbhE0T0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 15:26:49 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B707C061760
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 12:25:15 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f22so681431pgb.9
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 12:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dy2taTgwwYXF8T7BA2RvIvYOzohHJC1sakBN5DAw9rU=;
        b=kZsyyPidY3aMZ6sqg+Z8jRUlIrkGioM3ep3zOC+GWJ/I5O6FebpsXhBqee2pgxMdaK
         D4RscqYo3TTr6WS+tbx4CHHoJUwmM0tp6VIJZQPNZtlBMcCMa9f3Ecr8Q7x9nqblEVO4
         e9Ds/KfXTDGN/qzW2kfox+IHlKdp4IeU9Jjy0wwMPmQJJm80wZq9yTthXCQ7I5Fd9rnA
         SpNnjq/HzoWt+MizRz7gW/dm4RhhgVWSvgCE8ck/MOzLbpJSoy8EOGp1WEHEt8slX2as
         HMAUVMMXWN7p7TvGRZaQws69G1e1XnZpQou9llvapTU16fUhKnsQipEK9Ij3ujPALB3Z
         pNvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dy2taTgwwYXF8T7BA2RvIvYOzohHJC1sakBN5DAw9rU=;
        b=X0fwkKTTCnxFwh73xtwO6ULrri2k6/6XJF7RXOGQY4SzN/az06l/GNxzvJcDw3iot6
         BPjXCvkmQOip0ws8VrauLq4DxnW9Dl7I+Wmo8NUnO+PCuXE3X3pWD6EU7VA/FFoN5KFN
         zu1p3MLBbDPgwUg6dwpTUYKR4uBdEJbc2VExjsmAWQieOBr2f18q7Ap/x0FCFy+lpF5n
         F897mfXxEhqbkf2FdyjQdkV0Tu/YmOcLUYp5wby44JXZrvKXzQZx1Spq/6fHnHpShTyA
         4YVdPEMQ3YIADNC2P2rSta0yJK/hpl2J4uQDBQkmTrmYPNJiEHqKjgsos48dGSbuuClS
         bwkA==
X-Gm-Message-State: AOAM531FtFPzo+YB6CMVmortXlD559qFRjeuXoJ4HL9c1P2OIdaLjvfN
        DxDa+mbpErGfpzNZ79xnWLnHrA==
X-Google-Smtp-Source: ABdhPJyOBR1O+ukgTb9QYRm07VqzhdPl1b/vlMPwpQ/uazP+BwhlCHyueKOh0qx08a+vevxEpvmukw==
X-Received: by 2002:a62:3003:0:b029:28e:74d9:1e16 with SMTP id w3-20020a6230030000b029028e74d91e16mr59428pfw.21.1622143514581;
        Thu, 27 May 2021 12:25:14 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id j17sm2566731pff.77.2021.05.27.12.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 12:25:13 -0700 (PDT)
Date:   Thu, 27 May 2021 19:25:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 43/43] KVM: x86: Drop pointless @reset_roots from
 kvm_init_mmu()
Message-ID: <YK/yFuf4qpnSQooy@google.com>
References: <20210424004645.3950558-1-seanjc@google.com>
 <20210424004645.3950558-44-seanjc@google.com>
 <YK/u6N18S9gG7Fua@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK/u6N18S9gG7Fua@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 27, 2021, Sean Christopherson wrote:
> On Fri, Apr 23, 2021, Sean Christopherson wrote:
> > Remove the @reset_roots param from kvm_init_mmu(), the one user,
> > kvm_mmu_reset_context() has already unloaded the MMU and thus freed and
> > invalidated all roots.  This also happens to be why the reset_roots=true
> > paths doesn't leak roots; they're already invalid.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu.h        |  2 +-
> >  arch/x86/kvm/mmu/mmu.c    | 13 ++-----------
> >  arch/x86/kvm/svm/nested.c |  2 +-
> >  arch/x86/kvm/vmx/nested.c |  2 +-
> >  4 files changed, 5 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 88d0ed5225a4..63b49725fb24 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -65,7 +65,7 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
> >  void
> >  reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
> >  
> > -void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots);
> > +void kvm_init_mmu(struct kvm_vcpu *vcpu);
> >  void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
> >  			     gpa_t nested_cr3);
> >  void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 930ac8a7e7c9..ff3e200b32dd 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4793,17 +4793,8 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
> >  	update_last_nonleaf_level(vcpu, g_context);
> >  }
> >  
> > -void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots)
> > +void kvm_init_mmu(struct kvm_vcpu *vcpu)
> >  {
> > -	if (reset_roots) {
> > -		uint i;
> > -
> > -		vcpu->arch.mmu->root_hpa = INVALID_PAGE;
> > -
> > -		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> > -			vcpu->arch.mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
> 
> Egad!  This is wrong.  mmu->root_hpa is guaranteed to be INVALID_PAGE, but the
> prev_roots are not!  I'll drop this patch and do cleanup of this code in a
> separate series.

*sigh*  Jumped the gun, I was right the first time.  kvm_mmu_free_roots() does
invalidate prev_roots[*] via mmu_free_root_page().  I still think I'll drop this
patch from this series, I don't think there's anything in this series that is
needed to purge @reset_roots.

	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
		if (roots_to_free & KVM_MMU_ROOT_PREVIOUS(i))
			mmu_free_root_page(kvm, &mmu->prev_roots[i].hpa,  <-- tricky little devil
					   &invalid_list);


> 
> > -	}
> > -
> >  	if (mmu_is_nested(vcpu))
> >  		init_kvm_nested_mmu(vcpu);
> >  	else if (tdp_enabled)

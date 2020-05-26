Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2E01E31CD
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 23:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390396AbgEZV6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 17:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389342AbgEZV6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 17:58:35 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E1AC061A0F
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 14:58:34 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id h188so13261831lfd.7
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 14:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Px/8eL6gy0y1doNzDdCIOLFBQlXLPgLx7xu3e8vyF/U=;
        b=KopPaZ0IGTL1h5Fa3DgF2keyZ6Sn2lIlcsxrYtdh4+TNEWlO+T6nw+1BBjll6MYrfO
         f8PDIODCbvm1qTVgEq1rgPIX7hHCUjrqO/IrDoxF3m7OjrkSeIsxbl/DzBGYo8OF1PYD
         ZPlesWPJYQFUMojDJE/kXG4UBRWLbRxlHloaBhUDU7J4JRNFgsmTeNGWSfQ3DNL/H4As
         ys0EpIHoVtuVdxYBPB+v4ThmrEC2qjP4nSbz+IF0XZMQbb6dRK9Xs8DZjLsijNv5piAO
         zNrNGYrt21gVlSrIVLMMLBc4nDJOJZO53gLvOr9J8xe81/vjR/o2eJRGaAXGSTLDVIl+
         Gdxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Px/8eL6gy0y1doNzDdCIOLFBQlXLPgLx7xu3e8vyF/U=;
        b=oMUOtySR9pAqBnPzrl8Bcn5E7/5eHuJkBLnpRvz4VtV9xMKt6itXs9TGQD3IJspft7
         kpJdjWEUfThUieiYdmmGX+Ed1A/H+q/sCj0M8WrGu2W5WiNhiY251fT3KRUZEGC2HAHY
         WgAAAyKOeoUk7PKOxwLHRsr3FcuPgoEv0goad9B0DmIOH1Yy+JGIks4btdY8KG6fQlR9
         VUkazfedfIVfgnwBZi6/y3MPfbFcCGroCctZmmNCWLUy8dFTpO7dKhbCy+GFjQfUusE5
         CDtghQCEV0JSjHk4WB3ba3LNqZnRSx7rYMcdYq5ZHDR88ZzMPGpCzgEDB4Q7FqM723kf
         FC9A==
X-Gm-Message-State: AOAM530k6JgSRAdoJ+0PQ5lrLSPR0R7GagDS59sMi8ELmEsqJRNGNjz0
        y4vqHQ/W1+IOZDcBaImEin0rNg==
X-Google-Smtp-Source: ABdhPJzbUfKEuw57QLKjh/yXbdltLDPSM/7zrh/Fka2lvyAmkVwKa3CcSlUVTDJWG//BpUp+anU9MQ==
X-Received: by 2002:a19:8b06:: with SMTP id n6mr1434644lfd.66.1590530313005;
        Tue, 26 May 2020 14:58:33 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id l8sm226720ljc.59.2020.05.26.14.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 14:58:32 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 0F32410230F; Wed, 27 May 2020 00:58:34 +0300 (+03)
Date:   Wed, 27 May 2020 00:58:34 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC 10/16] KVM: x86: Enabled protected memory extension
Message-ID: <20200526215834.zhlm5xjekzk5efrn@box>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-11-kirill.shutemov@linux.intel.com>
 <20200526061609.GE13247@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526061609.GE13247@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 09:16:09AM +0300, Mike Rapoport wrote:
> On Fri, May 22, 2020 at 03:52:08PM +0300, Kirill A. Shutemov wrote:
> > Wire up hypercalls for the feature and define VM_KVM_PROTECTED.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  arch/x86/Kconfig     | 1 +
> >  arch/x86/kvm/cpuid.c | 3 +++
> >  arch/x86/kvm/x86.c   | 9 +++++++++
> >  include/linux/mm.h   | 4 ++++
> >  4 files changed, 17 insertions(+)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 58dd44a1b92f..420e3947f0c6 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -801,6 +801,7 @@ config KVM_GUEST
> >  	select ARCH_CPUIDLE_HALTPOLL
> >  	select X86_MEM_ENCRYPT_COMMON
> >  	select SWIOTLB
> > +	select ARCH_USES_HIGH_VMA_FLAGS
> >  	default y
> >  	---help---
> >  	  This option enables various optimizations for running under the KVM
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 901cd1fdecd9..94cc5e45467e 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -714,6 +714,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >  			     (1 << KVM_FEATURE_POLL_CONTROL) |
> >  			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
> >  
> > +		if (VM_KVM_PROTECTED)
> > +			entry->eax |=(1 << KVM_FEATURE_MEM_PROTECTED);
> > +
> >  		if (sched_info_on())
> >  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> >  
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index c17e6eb9ad43..acba0ac07f61 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7598,6 +7598,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  		kvm_sched_yield(vcpu->kvm, a0);
> >  		ret = 0;
> >  		break;
> > +	case KVM_HC_ENABLE_MEM_PROTECTED:
> > +		ret = kvm_protect_all_memory(vcpu->kvm);
> > +		break;
> > +	case KVM_HC_MEM_SHARE:
> > +		ret = kvm_protect_memory(vcpu->kvm, a0, a1, false);
> > +		break;
> > +	case KVM_HC_MEM_UNSHARE:
> > +		ret = kvm_protect_memory(vcpu->kvm, a0, a1, true);
> > +		break;
> >  	default:
> >  		ret = -KVM_ENOSYS;
> >  		break;
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 4f7195365cc0..6eb771c14968 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -329,7 +329,11 @@ extern unsigned int kobjsize(const void *objp);
> >  # define VM_MAPPED_COPY	VM_ARCH_1	/* T if mapped copy of data (nommu mmap) */
> >  #endif
> >  
> > +#if defined(CONFIG_X86_64) && defined(CONFIG_KVM)
> 
> This would be better spelled as ARCH_WANTS_PROTECTED_MEMORY, IMHO.

Sure. I though it's good enough for RFC :)

> > +#define VM_KVM_PROTECTED VM_HIGH_ARCH_4
> 
> Maybe this should be VM_HIGH_ARCH_5 so that powerpc could enable this
> feature eventually?

Okay-okay.

-- 
 Kirill A. Shutemov

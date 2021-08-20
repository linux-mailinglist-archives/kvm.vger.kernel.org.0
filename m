Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0EB3F3728
	for <lists+kvm@lfdr.de>; Sat, 21 Aug 2021 01:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhHTXDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 19:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhHTXDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 19:03:30 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BAFC061575
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 16:02:51 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 17so10656240pgp.4
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 16:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=thperbLeZy4D1cKcAccwsCOjx816j4EPZBiedY+rWn0=;
        b=ke/DAhMcxXaHsYBoAqTIVQQflNxKxg6NoGz5YspO+KNjLIEqA8fv30J86A7A6M7P1l
         ydNP2V3TN5eFwx5Vr5qXqSj+Bjf2BL2IQ4DYLwAvcWtZei4r/BFo5bpuIKTdf9UFHjCn
         344DbBrjo3/XB1eTPtM/u1qXI4G8UecMuv+xALvw3E7Df/hdq+Hx9L3Ed/Jc/JM7ge92
         UDL145tdP3LxDSbkdlWsQReBpbl0kkD65osCf0oj1qd1Jzs/vjZ2BeD8trPh7HOHFZfG
         oTV6t+mB00aN3R7MCIpIggUpzq05Qr3dVD3JJpwTUZTo0+DQZbYJP1vlGgdlQgQVGRNk
         r0NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=thperbLeZy4D1cKcAccwsCOjx816j4EPZBiedY+rWn0=;
        b=VFdP1HoVW7cBmSf6aP/Bz5k47jHwiJQTq1qejR1152dESmm5dN5VM/KFzlENVSL7zF
         0YjXM6Q9Tz5zP6FeYaZAVh1NeDPuXGbxu712teg8ij8ceA9/8IwwCQ6Nq7LEqZq8fOlq
         4XkjgNUMsf2W+goI95C2VEzXQHUSWRgKGXI1f3QhzzkX5ZmbiYGUkPYFsSdIzxHKAB5O
         0kSdoJCCBHbdDQp6JHmlgY4TS6zxys3d5C21pp8t2nmMjvzxRnCdUxOF3kvVvmhG4hcc
         dip1HnfS+ZR7K17wfR0bTd3zPLyUplhsNyFOyIiEqwB5U5B5IHf93GYLj3ueh/kzj/0E
         O41w==
X-Gm-Message-State: AOAM533VC3KdWK18XiyNCdONmjE/rQ/SpOEb+q/to3szZEoBGZqG/ec2
        PlpcSA40OaW5gVH/ULi2v31hqQ==
X-Google-Smtp-Source: ABdhPJyz3lUfEJBM2mYxXTWxHNSpUlnKnC5ccqbY5Ws9fE2RLyhyQHXJwFV6Mapxh6Zt8Jn2w989hw==
X-Received: by 2002:a63:1a65:: with SMTP id a37mr20919245pgm.338.1629500571260;
        Fri, 20 Aug 2021 16:02:51 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 6sm8151870pfg.108.2021.08.20.16.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 16:02:50 -0700 (PDT)
Date:   Fri, 20 Aug 2021 23:02:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [RFC PATCH 3/6] KVM: x86/mmu: Pass the memslot around via struct
 kvm_page_fault
Message-ID: <YSA0lImSHy6BIQll@google.com>
References: <20210813203504.2742757-1-dmatlack@google.com>
 <20210813203504.2742757-4-dmatlack@google.com>
 <YR6Iyc3PNqUey7LM@google.com>
 <CALzav=crHjGo0fBg2=npaJyQSS9cvQ6b8nbU0W_4fX_ABC4O+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=crHjGo0fBg2=npaJyQSS9cvQ6b8nbU0W_4fX_ABC4O+Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021, David Matlack wrote:
> On Thu, Aug 19, 2021 at 9:37 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Aug 13, 2021, David Matlack wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 3352312ab1c9..fb2c95e8df00 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -2890,7 +2890,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
> > >
> > >  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > >  {
> > > -     struct kvm_memory_slot *slot;
> > > +     struct kvm_memory_slot *slot = fault->slot;
> > >       kvm_pfn_t mask;
> > >
> > >       fault->huge_page_disallowed = fault->exec && fault->nx_huge_page_workaround_enabled;
> > > @@ -2901,8 +2901,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> > >       if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))
> > >               return;
> > >
> > > -     slot = gfn_to_memslot_dirty_bitmap(vcpu, fault->gfn, true);
> > > -     if (!slot)
> > > +     if (kvm_slot_dirty_track_enabled(slot))
> >
> > This is unnecessarily obfuscated.
> 
> Ugh. It's pure luck too. I meant to check if the slot is null here.

Ha, better to be lucky than good ;-)

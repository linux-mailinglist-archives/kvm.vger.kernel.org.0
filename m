Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C70F1C98B6
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 20:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgEGSFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 14:05:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25636 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726514AbgEGSFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 14:05:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588874713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ZT8uf+8nR83y0d403Od1JUqxjPNizjmPd+u74qytwY=;
        b=D2jslFUT5Rl7HJZ/VlZce5w0OQMurEQ1B0h2GRkieAUEdthSHmt+mYIyyzxLiCzVKVQ2sC
        4POOBExoDBQ8gxUkqm/Zfwv7SrggrppXKUY4O7OlQ7CsmXlp2AWuGR+XkxMtQPHvqWvL1I
        akr0Upcq/knyALRi9cDF1JvbqPjChgE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-LYbaVjWiNZSP57J2hG_2eQ-1; Thu, 07 May 2020 14:05:11 -0400
X-MC-Unique: LYbaVjWiNZSP57J2hG_2eQ-1
Received: by mail-qv1-f70.google.com with SMTP id dh14so6684278qvb.4
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 11:05:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7ZT8uf+8nR83y0d403Od1JUqxjPNizjmPd+u74qytwY=;
        b=g0ZcDmbySf7PRNlLgAUl67V+54A2vzzU0mV7Uu47Lq3MG+Sbe7Q09QrqdAysJ7NyfD
         GCRGzYrxJdpVcgjqf4AOR8a+zFyjJhIfAS0Rw4gCVN+nSHTMmwYU8f77pUc6CptaR3do
         JVxXoNT8Gfi4AvJZsBYD/evNZmoZiSDF4on15XKLbP05hDEpIF+q55/d6JgT+AsKT6dV
         xOljnEIqs3uJqnop6Sf6anqKEVTNNMHbYT1iOm8oDAEIm70aPnqmOg19teDqcZg/E3aG
         UfRwk5Wc4zU0VnHLoUU0iHzk35IEmeyJuVWS9D+Y0ncaF0P5IX39Cb4FlZMjeEeAYVKA
         rCvg==
X-Gm-Message-State: AGi0Pua/ZitpPIQvQqwQnJNpRDOWdPtIrDB34XBkF592+zpqtjWFu8/r
        lmN49v6UcbUapLVRgC2hIu1w64SghYerV8tNvxV7q21ZatrbpUASC0yIkoXuK4AVzq86bkJBd3b
        ePFntMj6b8w/b
X-Received: by 2002:a37:8d07:: with SMTP id p7mr16276235qkd.500.1588874711175;
        Thu, 07 May 2020 11:05:11 -0700 (PDT)
X-Google-Smtp-Source: APiQypLaD9wsQNdumwebtoAZ7rJYDUyJERvx2DqBTrcl3tFL8/q8qwbOR3ce/0xUX7ee+QK3N2tBXw==
X-Received: by 2002:a37:8d07:: with SMTP id p7mr16276184qkd.500.1588874710644;
        Thu, 07 May 2020 11:05:10 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id o16sm4104750qko.38.2020.05.07.11.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 11:05:09 -0700 (PDT)
Date:   Thu, 7 May 2020 14:05:08 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 9/9] KVM: VMX: pass correct DR6 for GD userspace exit
Message-ID: <20200507180508.GH228260@xz-x1>
References: <20200507115011.494562-1-pbonzini@redhat.com>
 <20200507115011.494562-10-pbonzini@redhat.com>
 <20200507161854.GF228260@xz-x1>
 <7abe5f7b-2b5a-4e32-34e2-f37d0afef00a@redhat.com>
 <20200507163839.GG228260@xz-x1>
 <db06ffa7-1e3c-14e5-28b8-5053f4383ecf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <db06ffa7-1e3c-14e5-28b8-5053f4383ecf@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 07:42:25PM +0200, Paolo Bonzini wrote:
> On 07/05/20 18:38, Peter Xu wrote:
> > On Thu, May 07, 2020 at 06:21:18PM +0200, Paolo Bonzini wrote:
> >> On 07/05/20 18:18, Peter Xu wrote:
> >>>>  		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> >>>> -			vcpu->run->debug.arch.dr6 = vcpu->arch.dr6;
> >>>> +			vcpu->run->debug.arch.dr6 = DR6_BD | DR6_RTM | DR6_FIXED_1;
> >>> After a second thought I'm thinking whether it would be okay to have BS set in
> >>> that test case.  I just remembered there's a test case in the kvm-unit-test
> >>> that checks explicitly against BS leftover as long as dr6 is not cleared
> >>> explicitly by the guest code, while the spec seems to have no explicit
> >>> description on this case.
> >>
> >> Yes, I noticed that test as well.  But I don't like having different
> >> behavior for Intel and AMD, and the Intel behavior is more sensible.
> >> Also...
> > 
> > Do you mean the AMD behavior is more sensible instead? :)
> 
> No, I mean within the context of KVM_EXIT_DEBUG: the Intel behavior is
> to only include the latest debug exception in kvm_run's DR6 field, while
> the AMD behavior would be to include all of them.  This was an
> implementation detail (it happens because Intel sets kvm_run's DR6 from
> the exit qualification of #DB), but it's more sensible too.
> 
> In addition:
> 
> * AMD was completely broken until this week, so the behavior of
> KVM_EXIT_DEBUG is defined de facto by kvm_intel.ko.  Userspace has not
> been required to set DR6 with KVM_SET_GUEST_DEBUG, and since we can
> emulate that on AMD, we should.
> 
> * we have to fix anyway the fact that on AMD a KVM_EXIT_DEBUG is
> clobbering the contents of the guest's DR6
> 
> >>> Intead of above, I'm thinking whether we should allow the userspace to also
> >>> change dr6 with the KVM_SET_GUEST_DEBUG ioctl when they wanted to (right now
> >>> iiuc dr6 from userspace is completely ignored), instead of offering a fake dr6.
> >>> Or to make it simple, maybe we can just check BD bit only?
> >>
> >> ... I'm afraid that this would be a backwards-incompatible change, and
> >> it would require changes in userspace.  If you look at v2, emulating the
> >> Intel behavior in AMD turns out to be self-contained and relatively
> >> elegant (will be better when we finish cleaning up nested SVM).
> > 
> > I'm still trying to read the other patches (I need some more digest because I'm
> > even less familiar with nested...).  I agree that it would be good to keep the
> > same behavior across Intel/AMD.  Actually that also does not violate Intel spec
> > because the AMD one is stricter.
> 
> Again, careful---we're talking about KVM_EXIT_DEBUG, not the #DB exception.

OK I get your point now.  Thanks,

-- 
Peter Xu


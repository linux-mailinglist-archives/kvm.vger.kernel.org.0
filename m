Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3703E9B35
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 01:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhHKXZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 19:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbhHKXZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 19:25:53 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF05C0613D3
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 16:25:29 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id oa17so6201964pjb.1
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 16:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6xileyVBDLPQbiU9ENYdYPcfwma8KlRoGAsn6NAw+A0=;
        b=I8nlsUwTR2aHK896/rsgb60Kd9Dn8Y5VCb+a/hhYGJmqUvLVsOpVgThQTr5atV2vS3
         o2cktuR/yFT4pIYVxRM/dnSCbgBAtoYdC5fuJ4atfKhvMjMjWukZZ2XgJ8ckBOnKKTB8
         os43aGmbO9pCTiOKmsllCOotn8lEBTQW7HHRSuW4rQB9D8YEqVcDTljv4YSmOU4tPVEN
         Wb0r0eWybnIkESpn5dt17sCCEw/MEQnOhBGzicF3dETZRaoytzBF5VEwJ4qSw7mDXhNI
         JPZNN4uHn/eYlsjz3g49tXvwRu+Vg36tALMgbBETQS/Ag+LCRGvCX/heSjVQZ55OFLMl
         Q6lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6xileyVBDLPQbiU9ENYdYPcfwma8KlRoGAsn6NAw+A0=;
        b=oAwDsU6+n6OQ5qPzUMcRBBnTNmJVRCMPaySHD575Hd+/pj9BpMEK/rP9DRUBJy7q56
         M80MF+CNrObom50yLShhd095TrvEADdpByl6236hJNnF6nOQ0YC2vmdDQbJ9+0qdqRxn
         e271PLQ4fM7z9UjmTBEEF97DwQi3WXMPL0ZTAJOJdtYvp3npQyHNWrx/9F4qMXCEtFob
         /XEJhLZw1er2IXCGCe17GreIFxAdSfjA9poHWW0VfaRNeAq7iVqSUZ7CUmCwx35zmUlR
         LrRx8/jyY1q7x0yL1l/fBfO4eloLMvQQB5202+H5KMjk3f/XLCubD3pyp4SjZucRuOVc
         a38w==
X-Gm-Message-State: AOAM530u/3JbX1ALL/HlH1DyTXceeKhnr5p11fdTgHbKHKt3ekYnlEHN
        ur+tbxlk3ivNNus8JoBB6uiVVg==
X-Google-Smtp-Source: ABdhPJwlMPaOnhQdc3QZNKgjkZAJdR7ZQ+aQ+voxjHn5QUCyQXJAVaw5e/ZWZMphd8YE3Ymjt4kfCQ==
X-Received: by 2002:a17:902:8e84:b029:12c:8742:1d02 with SMTP id bg4-20020a1709028e84b029012c87421d02mr1106099plb.38.1628724328540;
        Wed, 11 Aug 2021 16:25:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l11sm657772pfd.187.2021.08.11.16.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 16:25:28 -0700 (PDT)
Date:   Wed, 11 Aug 2021 23:25:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: nSVM: temporarly save vmcb12's efer, cr0 and
 cr4 to avoid TOC/TOU races
Message-ID: <YRRcYvLoE+q5/Gbx@google.com>
References: <20210809145343.97685-1-eesposit@redhat.com>
 <20210809145343.97685-3-eesposit@redhat.com>
 <21b14e5711dff386ced705a385f85301761b50a5.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21b14e5711dff386ced705a385f85301761b50a5.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021, Maxim Levitsky wrote:
> On Mon, 2021-08-09 at 16:53 +0200, Emanuele Giuseppe Esposito wrote:
> > @@ -1336,7 +1335,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> >  	if (!(save->cr0 & X86_CR0_PG) ||
> >  	    !(save->cr0 & X86_CR0_PE) ||
> >  	    (save->rflags & X86_EFLAGS_VM) ||
> > -	    !nested_vmcb_valid_sregs(vcpu, save))
> > +	    !nested_vmcb_valid_sregs(vcpu, save, save->efer, save->cr0,
> > +				     save->cr4))
> >  		goto out_free;
> >  
> >  	/*
> The disadvantage of my approach is that fields are copied twice, once from
> vmcb12 to its local copy, and then from the local copy to vmcb02, however
> this approach is generic in such a way that TOC/TOI races become impossible.
> 
> The disadvantage of your approach is that only some fields are copied and
> there is still a chance of TOC/TOI race in the future.

The partial copy makes me nervous too.  I also don't like pulling out select
registers and passing them by value; IMO the resulting code is harder to follow
and will be more difficult to maintain, e.g. it won't scale if the list of regs
to check grows.

But I don't think we need to copy _everything_.   There's also an opportunity to
clean up svm_set_nested_state(), though the ABI ramifications may be problematic.

Instead of passing vmcb_control_area and vmcb_save_area to nested_vmcb_valid_sregs()
and nested_vmcb_valid_sregs(), pass svm_nested_state and force the helpers to extract
the save/control fields from the nested state.  If a new check is added to KVM, it
will be obvious (and hopefully fail) if the state being check is not copied from vmcb12.

Regarding svm_set_nested_state(), if we can clobber svm->nested.ctl and svm->nested.save
(doesn't exist currently) on a failed ioctl(), then the temporary allocations for those
can be replaced with using svm->nested as the buffer.

And to mitigate the cost of copying to a kernel-controlled cache, we should use
the VMCB Clean bits as they're intended.

  Each set bit in the VMCB Clean field allows the processor to load one guest
  register or group of registers from the hardware cache;

E.g. copy from vmcb12 iff the clean bit is clear.  Then we could further optimize
nested VMRUN to skip checks based on clean bits.

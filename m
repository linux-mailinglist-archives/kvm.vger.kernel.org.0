Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654D920B91F
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 21:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgFZTL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 15:11:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58310 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725780AbgFZTL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 15:11:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593198685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oMtqF4vi6DX6dXlsvQVICwp3FFeCPzU9wJWbHt5gbk0=;
        b=M3xt43n7H00ecpZbK5DRbBPBvTVX1fZpXH/NvLQywX7V3KWThOKwRaA0v+Vp2hvn0TzBqe
        XBAmBSQDPSvRhKrryxYLXkZk1k14jXSeWIm7BR27a6JKSYo/Y2Bh3gHmZS4U5p6A1HpUit
        Msiha/E4GQp6MbtEf++zETGWOBoVg+s=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-xHDcUrPfMO2mp3XnqEgz-w-1; Fri, 26 Jun 2020 15:11:22 -0400
X-MC-Unique: xHDcUrPfMO2mp3XnqEgz-w-1
Received: by mail-qv1-f72.google.com with SMTP id v1so7032822qvx.8
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 12:11:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oMtqF4vi6DX6dXlsvQVICwp3FFeCPzU9wJWbHt5gbk0=;
        b=kKQNOVD078jNwa+E0EtUozsljKlCn5RMtDANI1tbPGOhZKBzgJrvoNqWfvLdhTnRTJ
         bkLb13mcjqCfsl4zYEeR7KsuVaB+irPgqBrqfcTSSfTJrIS3G56QhpHx2mPoMecEk/aj
         TCHI6dUfdZdIJgAt53rEvr4iWgYJofd4C4zxe7H/pkCBeWUxLxYQF6kL1T+OAXZWlVZp
         uM1cUnZYtS+p55ac4kY6gad+wM1h5h/x9+Kwwx8SRMDKa9U7beV08KmQ2vAqLczh0tU1
         ZmhSR4ma4OeYvHFvjC347QaDfASLXKN3+EzqmndIg6TkGuVdPT5ULAFtCr/n9xVNneLB
         Yvew==
X-Gm-Message-State: AOAM5335um9za/k2IPdC3EUZjSNYpKCixTWAlHTSxg2sJZJagMi173RE
        ePtyTGvKXWjIoPDwvNchfVts6PEjDl6JqetNe1vT0cS6RO3/NDVmaj0bfayQC/obz3bLi7ks8K4
        OOOq5RUjdZdKK
X-Received: by 2002:a0c:e554:: with SMTP id n20mr4623340qvm.14.1593198681682;
        Fri, 26 Jun 2020 12:11:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpLVlhU1X6J3CS20kGcMtpRORBsaRk1S+ucab60PTn/peBSUj/R0YxVh2GO7NrepuCA38VxQ==
X-Received: by 2002:a0c:e554:: with SMTP id n20mr4623305qvm.14.1593198681307;
        Fri, 26 Jun 2020 12:11:21 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id x197sm8784816qka.74.2020.06.26.12.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 12:11:20 -0700 (PDT)
Date:   Fri, 26 Jun 2020 15:11:18 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200626191118.GC175520@xz-x1>
References: <20200622220442.21998-1-peterx@redhat.com>
 <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com>
 <20200626180732.GB175520@xz-x1>
 <20200626181820.GG6583@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200626181820.GG6583@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 26, 2020 at 11:18:20AM -0700, Sean Christopherson wrote:
> On Fri, Jun 26, 2020 at 02:07:32PM -0400, Peter Xu wrote:
> > On Thu, Jun 25, 2020 at 09:25:40AM -0700, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 5eb618dbf211..64322446e590 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -1013,9 +1013,9 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
> > >                 *ebx = entry->ebx;
> > >                 *ecx = entry->ecx;
> > >                 *edx = entry->edx;
> > > -               if (function == 7 && index == 0) {
> > > +               if (function == 7 && index == 0 && (*ebx | (F(RTM) | F(HLE))) {
> > >                         u64 data;
> > > -                       if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
> > > +                       if (!kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data) &&
> > >                             (data & TSX_CTRL_CPUID_CLEAR))
> > >                                 *ebx &= ~(F(RTM) | F(HLE));
> > >                 }
> > > 
> > > 
> > > On VMX, MSR_IA32_TSX_CTRL will be added to the so called shared MSR array
> > > regardless of whether or not it is being advertised to userspace (this is
> > > a bug in its own right).  Using the host_initiated variant means KVM will
> > > incorrectly bypass VMX's ARCH_CAP_TSX_CTRL_MSR check, i.e. incorrectly
> > > clear the bits if userspace is being weird and stuffed MSR_IA32_TSX_CTRL
> > > without advertising it to the guest.
> > 
> > Btw, would it be more staightforward to check "vcpu->arch.arch_capabilities &
> > ARCH_CAP_TSX_CTRL_MSR" rather than "*ebx | (F(RTM) | F(HLE))" even if we want
> > to have such a fix?
> 
> Not really, That ends up duplicating the check in vmx_get_msr().  From an
> emulation perspective, this really is a "guest" access to the MSR, in the
> sense that it the virtual CPU is in the guest domain, i.e. not a god-like
> entity that gets to break the rules of emulation.

I can't say I agree that it's a guest behavior.  IMHO kvm plays the role as the
virtual processor.  If the bit in a cpuid entry depends on another MSR bit,
then the read of that MSR value is a "processor behavior", which in our case is
still a host behavior.  It's exactly because we thought it was a guest behavior
so we got confused when we saw the error message of "ignored rdmsr" the first
time but see the guest has no reason to do so...  So even if you want to keep
those error messages, I'd really appreciate if they can show something else so
we know it's not a guest rdmsr instruction.

To me, the existing tsx code is not a bug at all (IMHO the evil thing is the
tricky knobs and the fact that it hides deep, and that's why I really want to
move this series forward), and instead I think it's quite elegant to write
things like below...

  if (!__kvm_read_msr(&data) && (data & XXX))
    ...

It's definitely subjective so I can't argu much... However it's slightly
similar to rdmsr_safe and friends in that we don't need to remember two flags
(cap+msr) but only the msr (and I bet I'm not the only one who likes it, just
see the massive callers of all the "safe" versioned msr friends...).

Considering the fact that we still have the unexpected warning message on some
hosts with upgraded firmwares which potentially breaks some realtime systems,
do you think below simple and clear patch acceptable to you?

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 901cd1fdecd9..052c93997965 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1005,7 +1005,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
                *ebx = entry->ebx;
                *ecx = entry->ecx;
                *edx = entry->edx;
-               if (function == 7 && index == 0) {
+               if (function == 7 && index == 0 &&
+                   vcpu->arch.arch_capabilities & ARCH_CAP_TSX_CTRL_MSR) {
                        u64 data;
                        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
                            (data & TSX_CTRL_CPUID_CLEAR))

Then we can further discuss whether and how we'd like to refactor the knobs and
around.

Thanks,

-- 
Peter Xu


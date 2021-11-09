Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE5E44B05C
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 16:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237261AbhKIPdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 10:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236923AbhKIPc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 10:32:56 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8074BC061764
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 07:30:10 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id e65so18815579pgc.5
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 07:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3EqcySUYEoHd2AgFzsEj9Knlfuk7MnGFiKAJ/T+gQM4=;
        b=CXtmBHAQoA7Oin7W4K7yTwMQO6LgmHro8A6oQsigaeq95O0vDZQWrbzV7qlAB/BK74
         gRA1LZc3J6gMpEZijVCZEEzenPGaneqzvP1AAnHo/opAQJoW7kJn481nhRuoJeK91B0S
         jxP6MGeb+9ML68/9jFaO2oM+I3veY+W2FhMg79qqSFRSM/IzMuPd5gdOLRuhh31y4h5q
         RquJZzKxADsmvggR4qAd1nQCULwnG04VHwf/uYbPDCA0FOQmyPQsuq8YgBY5vEXL5MOC
         DTZMn1B038JdZd0EksiiFQnJJZsCKufner8vUSdQpeihklAbX6WTdEEgFev2JRZEFofY
         gCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3EqcySUYEoHd2AgFzsEj9Knlfuk7MnGFiKAJ/T+gQM4=;
        b=TDaaltIZY4DpX81BbxH85yvyXUlN14UsjQuZzem/R7y6c4CmPcYVvJfWJfJh3VgbrZ
         0utLGoXQnjTIGz7tKaMH1ApExdoCCbnsJ/2aEjBe0opCAw8hRfcpdDIL0wjDp6vSAMsn
         qnT958Ki1uZZm+TEjP+0PdHBkTXcRvh0mQh+xuETEyz6gq1h5thRrDnVkkJdjPxjRJd6
         biu5jXojmB1jXJNcqCiJYFGFIAG5BPi9o+f+MtxIm5cvloSJrgTZTtkdavEDr2zKnHFo
         j90vEAaJjYRog5Byrfo7Z1jxAdwTUhlGGUKgLhvA5jz6bHMboY36CuSJj/Qd/ehA52Jz
         ezlQ==
X-Gm-Message-State: AOAM531ZuUD0yvH+b5bdcjBaB48vISdIQXFcAZczzj+tk4XE0OvqMO6/
        n6kM/hp0eXWu2915ru6tqmS7bQ==
X-Google-Smtp-Source: ABdhPJxW/Vf5ZzQVboiiwImKBQiI1NzEed2ct/59SKb7DgL0vrXUaMSOqt3Ac0QahWaG4YaudJKvtg==
X-Received: by 2002:a62:5ec2:0:b0:44d:47e2:4b3b with SMTP id s185-20020a625ec2000000b0044d47e24b3bmr91078717pfb.38.1636471809613;
        Tue, 09 Nov 2021 07:30:09 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t4sm20638284pfj.13.2021.11.09.07.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 07:30:09 -0800 (PST)
Date:   Tue, 9 Nov 2021 15:30:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/7] KVM: X86: Expose IA32_PKRS MSR
Message-ID: <YYqT/cOm3Psf1gj1@google.com>
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
 <20210811101126.8973-4-chenyi.qiang@intel.com>
 <YYliC1kdT9ssX/f7@google.com>
 <85414ca6-e135-2371-cbce-0f595a7b7a26@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85414ca6-e135-2371-cbce-0f595a7b7a26@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 09, 2021, Chenyi Qiang wrote:
> 
> On 11/9/2021 1:44 AM, Sean Christopherson wrote:
> > Hrm.  Ideally this would be open coded in vmx_set_msr().  Long term, the RESET/INIT
> > paths should really treat MSR updates as "normal" host_initiated writes instead of
> > having to manually handle every MSR.
> > 
> > That would be a bit gross to handle in vmx_vcpu_reset() since it would have to
> > create a struct msr_data (because __kvm_set_msr() isn't exposed to vendor code),
> > but since vcpu->arch.pkrs is relevant to the MMU I think it makes sense to
> > initiate the write from common x86.
> > 
> > E.g. this way there's not out-of-band special code, vmx_vcpu_reset() is kept clean,
> > and if/when SVM gains support for PKRS this particular path Just Works.  And it would
> > be an easy conversion for my pipe dream plan of handling MSRs at RESET/INIT via a
> > list of MSRs+values.
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index ac83d873d65b..55881d13620f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11147,6 +11147,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >          kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
> >          kvm_rip_write(vcpu, 0xfff0);
> > 
> > +       if (kvm_cpu_cap_has(X86_FEATURE_PKS))
> > +               __kvm_set_msr(vcpu, MSR_IA32_PKRS, 0, true);
> > +
> 
> Got it. In addition, is it necessary to add on-INIT check? like:
> 
> if (kvm_cpu_cap_has(X86_FEATURE_PKS) && !init_event)
> 	__kvm_set_msr(vcpu, MSR_IA32_PKRS, 0, true);
> 
> PKRS should be preserved on INIT, not cleared. The SDM doesn't make this
> clear either.

Hmm, but your cover letter says:

  To help patches review, one missing info in SDM is that PKSR will be
  cleared on Powerup/INIT/RESET, which should be listed in Table 9.1
  "IA-32 and Intel 64 Processor States Following Power-up, Reset, or INIT"

Which honestly makes me a little happy because I thought I was making stuff up
for a minute :-)

So which is it?

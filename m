Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2F0455E8C
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 15:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhKROwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 09:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhKROwj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 09:52:39 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA9EC06173E
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 06:49:39 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u17so5435469plg.9
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 06:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yfgOishc+iyGnpLtUV02QcOrbhlHMbh/VRP7OyAqEeU=;
        b=I7gH33SMM5K528hZc6oE7o1NwZqPOQ14ApO241MZe44zhrW7cwQufQUf1DTDuXQQJj
         6o100rddBL1u5trO+IAK9O6mdBmPUMTRX+Aw56d/IzRlHp6zeI7+m68y9LpcJcbdGzWG
         nwUm1j+c6PItm4wk76vOblRyU2c4Ivz8vPeEs5w3E2NzgF7VcpsD/2HXbURoqIroyWtb
         57XZoA5ZmlOORhMW4VOpYow0829BbFn3jvX7vXl4qkQfrshfkScZ80Jr4vifMbISvA+J
         f62pJlOWdatUUUmG9U7cR/egTojvWT+/cVkJqbGFlCO5/i/TiRF8bq0a+GPjYCkL1FBT
         Ftwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yfgOishc+iyGnpLtUV02QcOrbhlHMbh/VRP7OyAqEeU=;
        b=CKls7FBlnC+IXI4gMEqFH42sVenRZplUsjOgFCtMaUPP3lKqF4RMJa9PQ3ytVo90Gh
         xiYERkJ4/kK/zwZAD7gwfyPV1BWB9reIr04Rl2wSWjnEZaCRnavGzQicIBR+f+Jr40qu
         poIQlNOzHHbC7sIM9WyQPaYWK2hMFITaf7n+G2WI+SEGix+XdeDUnQsqcGbuWA0kHhvJ
         KeoM+qOBODQ+VYni7eJ/1GP53QnxXHIA5rNFV85Vf7dAc9RWBhsS4r7bgIhMqBqXUkCL
         DK+KCe+/iAWOmXbiiMae/8nmQXFng2Evt5zW8z+JZQUs++0usovEVnSZ1Tn0dLLIFzVX
         AVxA==
X-Gm-Message-State: AOAM530/EvowTq5AbPLtCX6mlvfrBZMjI+ilUdv0soaLAvi5hHy33+9T
        aVCWACe1h1s641+HCfAsoFFNYnAVpM1qJg==
X-Google-Smtp-Source: ABdhPJyUILYN6gmH9Qpi1vIeNx6IWkRkXkdABwGeC0vvHQ0h8OAD7bS8b6z47Bl/9u03gMPcQjWINA==
X-Received: by 2002:a17:90b:4f4c:: with SMTP id pj12mr11150375pjb.217.1637246978538;
        Thu, 18 Nov 2021 06:49:38 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k20sm4241488pfc.83.2021.11.18.06.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 06:49:37 -0800 (PST)
Date:   Thu, 18 Nov 2021 14:49:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 3/4] x86/kvm: add max number of vcpus for hyperv
 emulation
Message-ID: <YZZn/iWsi2H845w6@google.com>
References: <20211116141054.17800-1-jgross@suse.com>
 <20211116141054.17800-4-jgross@suse.com>
 <YZVrDpjW0aZjFxo1@google.com>
 <bfe38122-0ddd-d9bc-4927-942b051a39c4@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfe38122-0ddd-d9bc-4927-942b051a39c4@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021, Juergen Gross wrote:
> On 17.11.21 21:50, Sean Christopherson wrote:
> > > @@ -166,7 +166,7 @@ static struct kvm_vcpu *get_vcpu_by_vpidx(struct kvm *kvm, u32 vpidx)
> > >   	struct kvm_vcpu *vcpu = NULL;
> > >   	int i;
> > > -	if (vpidx >= KVM_MAX_VCPUS)
> > > +	if (vpidx >= min(KVM_MAX_VCPUS, KVM_MAX_HYPERV_VCPUS))
> > 
> > IMO, this is conceptually wrong.  KVM should refuse to allow Hyper-V to be enabled
> > if the max number of vCPUs exceeds what can be supported, or should refuse to create
> 
> TBH, I wasn't sure where to put this test. Is there a guaranteed
> sequence of ioctl()s regarding vcpu creation (or setting the max
> number of vcpus) and the Hyper-V enabling?

For better or worse (mostly worse), like all other things CPUID, Hyper-V is a per-vCPU
knob.  If KVM can't detect the impossible condition at compile time, kvm_check_cpuid()
is probably the right place to prevent enabling Hyper-V on an unreachable vCPU.

> > the vCPUs.  I agree it makes sense to add a Hyper-V specific limit, since there are
> > Hyper-V structures that have a hard limit, but detection of violations should be a
> > BUILD_BUG_ON, not a silent failure at runtime.
> > 
> 
> A BUILD_BUG_ON won't be possible with KVM_MAX_VCPUS being selecteble via
> boot parameter.

I was thinking that there would still be a KVM-defined max that would cap whatever
comes in from userspace.

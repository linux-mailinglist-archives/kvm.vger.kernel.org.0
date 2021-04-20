Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6923660BA
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 22:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhDTURU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 16:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbhDTURT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 16:17:19 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00CDC06138A
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 13:16:47 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id p67so21467082pfp.10
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 13:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=baguO7314vCrN8/3Lvu6Ck0/6YUj93gK/SeIRlHPkHY=;
        b=VDk6YLqqHBjXELr908Vy3WBsu/P3T1SUqT+ZE+rHFrt/R8+YWT9gMDUBRfkEmzdvrH
         n2heHViq5NBoovkpWFoJ9szOnoaDxi0rQNrCxGxXw+go42e2mkquPT5Kn1c7hw/UZGAK
         SHxReazCEAgCJd3ktuLdhBRBu5hNh4DOGBm+1lIe0NjGPMbcR3KZQ0w/f8nrgB+CX5Uz
         wItuzAE2l0q92ZY28tv0EmYCx4IIh8LSjN8Xrz7J8Wg9OTlhyUTGoTonMJLfygkOTxxl
         JiloQ2+INXgN+FVI5Bc65zkU3dsdO9rQc4jouA3KmoeAT339FhlBhZmIyKqljJqnbQDt
         fDeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=baguO7314vCrN8/3Lvu6Ck0/6YUj93gK/SeIRlHPkHY=;
        b=aFereVjxzCOJU+JOyb+wckp/BQZMErqqzD8X2BZYr8aap8dHeZgHIRJtg7eCLgB8cf
         aQnD9WjXdjnPUCmmOkYpjZw4Gz5P7hHTH2PClHKyXZy7etwuVegrlGEETuaR2Ae6F1rt
         U73eu29bQyhFJLkKqyZIZmEi5YH3x5y7ZCAhir6Ces1lhcIINhSiENW0wu1PtDbnX3TX
         r5r4wHy9XT+e8Ka3L7wOTy9t+qd38eHvbtNjG/9mfsFBtiM7OkM2GazT0jFHRlWZcAjw
         lHrepENcNwtCxtjxWrC9xhSpN9cPbrCPtcTnGTNVGfy+BiZJGA3aXnN4pAPTvavXzM+F
         SKqg==
X-Gm-Message-State: AOAM532g/dDrFlGcdWfum4StJ270FQmIDBBEfzxAI3zfbUDRQAJNLyf5
        9k8ThQtSCyI1dYAwC5Dz7jO/TQ==
X-Google-Smtp-Source: ABdhPJzHP5mB0IkvpDfWhhTGznEdghO0p6TOY9+Gmafh1xpRpiI1fIGjEWEv/6LcbyNjpPa6ucTahw==
X-Received: by 2002:a17:90b:1955:: with SMTP id nk21mr7031347pjb.198.1618949806996;
        Tue, 20 Apr 2021 13:16:46 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id k15sm16500650pfi.0.2021.04.20.13.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 13:16:46 -0700 (PDT)
Date:   Tue, 20 Apr 2021 20:16:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        srutherford@google.com, joro@8bytes.org, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, venu.busireddy@oracle.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org, Ashish Kalra <ashish.kalra@amd.com>
Subject: Re: [PATCH 0/3] KVM: x86: guest interface for SEV live migration
Message-ID: <YH82qgTLCKUoSyNa@google.com>
References: <20210420112006.741541-1-pbonzini@redhat.com>
 <YH8P26OibEfxvJAu@google.com>
 <05129de6-c8d9-de94-89e7-6257197433ef@redhat.com>
 <YH8lMTMzfD7KugRg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH8lMTMzfD7KugRg@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021, Sean Christopherson wrote:
> On Tue, Apr 20, 2021, Paolo Bonzini wrote:
> > On 20/04/21 19:31, Sean Christopherson wrote:
> > > > +	case KVM_HC_PAGE_ENC_STATUS: {
> > > > +		u64 gpa = a0, npages = a1, enc = a2;
> > > > +
> > > > +		ret = -KVM_ENOSYS;
> > > > +		if (!vcpu->kvm->arch.hypercall_exit_enabled)
> > > 
> > > I don't follow, why does the hypercall need to be gated by a capability?  What
> > > would break if this were changed to?
> > > 
> > > 		if (!guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS))
> > 
> > The problem is that it's valid to take KVM_GET_SUPPORTED_CPUID and send it
> > unmodified to KVM_SET_CPUID2.  For this reason, features that are
> > conditional on other ioctls, or that require some kind of userspace support,
> > must not be in KVM_GET_SUPPORTED_CPUID.  For example:
> > 
> > - TSC_DEADLINE because it is only implemented after KVM_CREATE_IRQCHIP (or
> > after KVM_ENABLE_CAP of KVM_CAP_IRQCHIP_SPLIT)
> > 
> > - MONITOR only makes sense if userspace enables KVM_CAP_X86_DISABLE_EXITS
> > 
> > X2APIC is reported even though it shouldn't be.  Too late to fix that, I
> > think.
> > 
> > In this particular case, if userspace sets the bit in CPUID2 but doesn't
> > handle KVM_EXIT_HYPERCALL, the guest will probably trigger some kind of
> > assertion failure as soon as it invokes the HC_PAGE_ENC_STATUS hypercall.
> 
> Gah, I was thinking of the MSR behavior and forgot that the hypercall exiting
> behavior intentionally doesn't require extra filtering.
> 
> It's also worth noting that guest_pv_has() is particularly useless since it
> will unconditionally return true for older VMMs that dont' enable
> KVM_CAP_ENFORCE_PV_FEATURE_CPUID.
> 
> Bummer.

Oh!  Almost forgot my hail mary idea.  Instead of a new capability, can we
reject the hypercall if userspace has _not_ set KVM_CAP_ENFORCE_PV_FEATURE_CPUID?

			if (vcpu->arch.pv_cpuid.enforce &&
			    !guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS)
				break;

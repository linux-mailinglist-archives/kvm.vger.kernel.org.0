Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9282544EDF6
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 21:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhKLUk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 15:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbhKLUkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 15:40:55 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6889AC061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 12:38:04 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id y5so9468627pfb.4
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 12:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y3lkkCoH31qkZVjCCR/E7oVCSTtI0bujwimpGP/k3sA=;
        b=StN5hrm4hrP1PWbwCsad9xfHaY2mzd5NEqWZg7LjTXOZ+9O/G/vIJYTO874W0+OU7r
         02e49SdXYQFdhvavIZ0/Bgod8n3+ZPrZX9t5taGeiSaOJLczRlhgUsuiblb4EI1jSGr+
         NZWJGqOvikolAUKZstOfQnFkDiHpXy5LCm6OqCEgEmOlPoBi5L0xsKFKfGSbbt3WMQV8
         erURs1+sPIwc1Q6/kxoa4st6fVGOE95gxJmsH2gSpF6ktwp5Vr5qTsL65Ap/O7SZjEtY
         by6NXYeQrLcf7ijygDNbUjhgeRcyqonZeu3bZGNg0RmLBhW2BQofEnHhp2HQOsR5EwSx
         4itw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y3lkkCoH31qkZVjCCR/E7oVCSTtI0bujwimpGP/k3sA=;
        b=UzgIiddC1zgZmjksARuhIlAlr2OwSpjuOvuMoGTb4/IUzIbuTVkJIqlLaA1Hx+Qamq
         wf+hCac4qMiqEpIG85jRgURYfy/ulJsXZtMbrraNtZtUy7gIW+yCao8yxzRWTynV7eu8
         2ZkqzsATRxKiE4PDlk8jhcb8Ob5XyLBX0h2ZuTomtLL35kz0RXQ0OnLr8CxIOtknftut
         oiCAklmWEXrKtKVP2M0kZrbNJaERKvlPx6gGdezH7oFszIukO2B+xc19b/slOeDpyz2N
         FKonkAx1S5gYfW8anr3KWAuSoB5RGRtcwBEPaIkl5/ifkcIsLIGJsdp1+j8jOfNMeLwW
         ygQQ==
X-Gm-Message-State: AOAM532uWFiYWogDyPPobBOHqhZTHsWMv7dFWMAW8gscww4JWB+2MbTH
        SDO6fRWkBVcwSvxqe/GbJN/Ftw==
X-Google-Smtp-Source: ABdhPJzHagE7e/zPwAVgF1qVOvwX2AZJfu6+gEOKjv7ntsak1VhR4NZPtnwdBehCWj1cbnfgo9fw4g==
X-Received: by 2002:a63:9508:: with SMTP id p8mr11607250pgd.413.1636749483738;
        Fri, 12 Nov 2021 12:38:03 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id qe12sm12567812pjb.29.2021.11.12.12.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 12:38:02 -0800 (PST)
Date:   Fri, 12 Nov 2021 20:37:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YY7Qp8c/gTD1rT86@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YY7I6sgqIPubTrtA@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YY7I6sgqIPubTrtA@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021, Borislav Petkov wrote:
> On Fri, Nov 12, 2021 at 07:48:17PM +0000, Sean Christopherson wrote:
> > Yes, but IMO inducing a fault in the guest because of _host_ bug is wrong.
> 
> What do you suggest instead?

Let userspace decide what is mapped shared and what is mapped private.  The kernel
and KVM provide the APIs/infrastructure to do the actual conversions in a thread-safe
fashion and also to enforce the current state, but userspace is the control plane.

It would require non-trivial changes in userspace if there are multiple processes
accessing guest memory, e.g. Peter's networking daemon example, but it _is_ fully
solvable.  The exit to userspace means all three components (guest, kernel, 
and userspace) have full knowledge of what is shared and what is private.  There
is zero ambiguity:

  - if userspace accesses guest private memory, it gets SIGSEGV or whatever.  
  - if kernel accesses guest private memory, it does BUG/panic/oops[*]
  - if guest accesses memory with the incorrect C/SHARED-bit, it gets killed.

This is the direction KVM TDX support is headed, though it's obviously still a WIP.

And ideally, to avoid implicit conversions at any level, hardware vendors' ABIs
define that:

  a) All convertible memory, i.e. RAM, starts as private.
  b) Conversions between private and shared must be done via explicit hypercall.

Without (b), userspace and thus KVM have to treat guest accesses to the incorrect
type as implicit conversions.

[*] Sadly, fully preventing kernel access to guest private is not possible with
    TDX, especially if the direct map is left intact.  But maybe in the future
    TDX will signal a fault instead of poisoning memory and leaving a #MC mine.

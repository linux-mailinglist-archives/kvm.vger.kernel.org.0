Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C30731D064
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 19:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhBPSsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 13:48:03 -0500
Received: from mail.skyhub.de ([5.9.137.197]:44550 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229876AbhBPSsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 13:48:02 -0500
Received: from zn.tnic (p200300ec2f07cd005a29834948e41e58.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:cd00:5a29:8349:48e4:1e58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0D0911EC0323;
        Tue, 16 Feb 2021 19:47:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1613501240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=S1+zTXofmptbJ7hj5gnp3DaFD84OwWhQA5YvGqxjSc4=;
        b=AIwHTWHdBV90Q7VJb1TiORCqOReY9onvPxp5D9VoVAyxq2MVZrLUcYVFstztudEe8LnVIW
        qKYG1ZMNvYKx3tpZDdfyzA169LWzl5+K4tXUoXqYX5zx1bUvee7RcEQ4UPsxakb5i/pumh
        HR/4Jl0diQYc4q/nLjpiKipqO159fc0=
Date:   Tue, 16 Feb 2021 19:47:18 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [RFC PATCH v5 08/26] x86/sgx: Expose SGX architectural
 definitions to the kernel
Message-ID: <20210216184718.GE10592@zn.tnic>
References: <cover.1613221549.git.kai.huang@intel.com>
 <1d6fe6bd392b604091b57842c15cc5460aa92593.1613221549.git.kai.huang@intel.com>
 <YCsrNqcB1C0Tyxz9@kernel.org>
 <cdc73d737d634e778de4c691ca4fd080@intel.com>
 <20210216103218.GB10592@zn.tnic>
 <a792bf6271da4fddb537085845cf868f@intel.com>
 <20210216114851.GD10592@zn.tnic>
 <9dca76b9-a0f9-a7aa-5d85-f8b43f89a3d2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9dca76b9-a0f9-a7aa-5d85-f8b43f89a3d2@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021 at 07:18:27AM -0800, Dave Hansen wrote:
> On 2/16/21 3:48 AM, Borislav Petkov wrote:
> > What I'm trying to point you at is, to not give some artificial reasons
> > why the headers should be separate - artificial as the SDM says it
> > is architectural and so on - but give a reason from software design
> > perspective why the separation is needed: better build times, less
> > symbols exposed to modules, blabla and so on.
> 
> I think I actually suggested this sgx_arch.h split for SGX in the first
> place.
> 
> I was reading the patches and I had a really hard time separating the
> hardware and software structures.  There would be a 'struct sgx_foo {}'
> and some chit chat about what it did...  and I still had no idea if it
> was an architectural structure or not.
> 
> This way, it's 100% crystal clear what Linux is defining and what the
> hardware defines from the diff context.

Yap, that's a valid reason in my book. And arch.h has at the top:

 * Contains data structures defined by the SGX architecture.  Data structures
 * defined by the Linux software stack should not be placed here.

and by now we already have:

$ git ls-files | grep \/sgx.h
arch/x86/include/uapi/asm/sgx.h
arch/x86/kernel/cpu/sgx/sgx.h

two sgx.h headers.

So how about we have a single

  arch/x86/include/asm/sgx.h

header which contains the architectural definitions at the *top* and at
their end, there'll be a:

/* Do not put any hardware-defined SGX structure representations below this line! */

and after that line begin the other, software definitions?

Then that arch/x86/kernel/cpu/sgx/sgx.h can be renamed to private.h
because it is included only there so you'll have:

arch/x86/include/uapi/asm/sgx.h	- user API crap
arch/x86/include/asm/sgx.h - shared with other kernel facilities
arch/x86/kernel/cpu/sgx/internal.h - SGX-internal definitions

How does that look?

And we do have similar header structure with other features...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

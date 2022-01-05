Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820E44856D0
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 17:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241999AbiAEQpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 11:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241989AbiAEQpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 11:45:45 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D13C061201
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 08:45:45 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id z3so29663189plg.8
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 08:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JzhaTzKc19y3Wpdk/3J2jH8xYo/xM6G6LVHFT+aj3mw=;
        b=aLR3XPzMRrTZJboycEOPjD3N3ADRjWxJrADrUM1vAgyD9yRB/cjUqNuxpD6D1zOAmh
         OTlxK6M59BBTMdKbHLb9g6+g7lOOh6VZ4/qDWuPwogwqXeIz//BWdDMmse71XKun02Lu
         G04xPe73oSZqxQ/sy9Lj5nEW4XoOHJ/pcEv6sVHzjo/DrPyZjd3XxDfC4rApX5sJJNuM
         7NKta/ZTK/r2ZYTqrHgT17CPS9TWRex9/ZhxhmcmEHTpTUtPhnpmYSK9l7CEiPZWu2xz
         o+vWlB3XVpmKTtJuS6YG2Z7qNp9iowJUszGZWjwe44ltq3lZukQ4WbMgvfWWg0n7//yf
         aZsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JzhaTzKc19y3Wpdk/3J2jH8xYo/xM6G6LVHFT+aj3mw=;
        b=ycR+kl5GJQtEqMJNIRfpO3F5pVqJh4vUd1ki6w+x5nmMAqxMbfx/82KOH6x6LX6tHw
         Z32mJMSzAUug1FcNL5ebG6AJN8cGH9rz9lXdHypTzl90zo/f0pCJob6ls/zbKQAz7sQM
         OuCoDSpB1LvhlKE5mLcsyrRSA/gL168bz0C5NJIUJOBcL2sEt8Jyr1FHdPm0GhpoKQgl
         LH/wwbzFhMzF5Hi6r+rKXK0jrvHuY1pCZTmK62J1HfRQ5ixKCuwLYBWFjRJsuDCe+eFg
         Yk/QVNVOmjxTyrBGX7XhL1x/XLSH4xWe8Jtk0hV3Pvwf/YMmsWLyDa2dbqRRFIDyI8Mo
         vI3Q==
X-Gm-Message-State: AOAM5320bI/NmjOuy0gL0mNFE4RT5pvKyY7OPl9GOQIejilOo9HtjLTW
        Gabd4d0xxloYJSxTWrgyvEHrWA==
X-Google-Smtp-Source: ABdhPJyUMGeECuuJZDVhCnWrGj1J1NoGFjgCRrQnkt+A+rXmyUORqD/IbRnzmnd1id6Y/amClQGp1Q==
X-Received: by 2002:a17:903:11c9:b0:149:bef4:2d7d with SMTP id q9-20020a17090311c900b00149bef42d7dmr13255819plh.48.1641401144538;
        Wed, 05 Jan 2022 08:45:44 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m14sm48537966pfk.3.2022.01.05.08.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 08:45:43 -0800 (PST)
Date:   Wed, 5 Jan 2022 16:45:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 5/6] KVM: X86: Alloc pae_root shadow page
Message-ID: <YdXLNEwCY8cqV7KS@google.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
 <20211210092508.7185-6-jiangshanlai@gmail.com>
 <YdTCKoTgI5IgOvln@google.com>
 <CAJhGHyAOyR6yGdyxsKydt_+HboGjxc-psbbSCqsrBo4WgUgQsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyAOyR6yGdyxsKydt_+HboGjxc-psbbSCqsrBo4WgUgQsQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022, Lai Jiangshan wrote:
> On Wed, Jan 5, 2022 at 5:54 AM Sean Christopherson <seanjc@google.com> wrote:
> 
> > >
> > > default_pae_pdpte is needed because the cpu expect PAE pdptes are
> > > present when VMenter.
> >
> > That's incorrect.  Neither Intel nor AMD require PDPTEs to be present.  Not present
> > is perfectly ok, present with reserved bits is what's not allowed.
> >
> > Intel SDM:
> >   A VM entry that checks the validity of the PDPTEs uses the same checks that are
> >   used when CR3 is loaded with MOV to CR3 when PAE paging is in use[7].  If MOV to CR3
> >   would cause a general-protection exception due to the PDPTEs that would be loaded
> >   (e.g., because a reserved bit is set), the VM entry fails.
> >
> >   7. This implies that (1) bits 11:9 in each PDPTE are ignored; and (2) if bit 0
> >      (present) is clear in one of the PDPTEs, bits 63:1 of that PDPTE are ignored.
> 
> But in practice, the VM entry fails if the present bit is not set in the
> PDPTE for the linear address being accessed (when EPT enabled at least).  The
> host kvm complains and dumps the vmcs state.

That doesn't make any sense.  If EPT is enabled, KVM should never use a pae_root.
The vmcs.GUEST_PDPTRn fields are in play, but those shouldn't derive from KVM's
shadow page tables.

And I doubt there is a VMX ucode bug at play, as KVM currently uses '0' in its
shadow page tables for not-present PDPTEs.

If you can post/provide the patches that lead to VM-Fail, I'd be happy to help
debug.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF030219E3B
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 12:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgGIKvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 06:51:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36208 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgGIKvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 06:51:38 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594291896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZBseBq/So0/jIR32rElntMZUFEP+pJqhChMmzOIuleE=;
        b=wmYPZM9LjhbQ94b7RWQizzuz2YV8n0dhxkZsYadTgdAYGNAlkpNrVzSwA02JfQnKLdOUQf
        TUQ1+Cvioo0db9ObXHeRcytzonuGuWq8r/DNO+TWYJjlFNuxTzTa+rzAYmG3qBsXDlhjzp
        coqgEpHeDaS39bSIXpPH04WGLIGA95TA4wVEZjplPxAhEWyau39N9ZTnoj1tK8j0LbYagQ
        G9uBSvEUt6LZw/lj2ijpi2sp2EZ+pcPnXQVr2JBWaeKpCKz+/13rXfVJ0BS/bRfPaMjKp6
        nlbRcQA0P9BJbx0rSFEt1/Xn+1t816z7ETLfq3sPm/lrDHCWpuIZDWXDD8tMCw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594291896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZBseBq/So0/jIR32rElntMZUFEP+pJqhChMmzOIuleE=;
        b=tnsXg0F5uad7JSmxfc+jFCoIt8UpX45DiDXmLbSwnjtgf/nlO7eiJW1WhwQlcVDyDZ7W1q
        uJ1/dfvgIjwZ+cAQ==
To:     Abhishek Bhardwaj <abhishekbh@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Abhishek Bhardwaj <abhishekbh@google.com>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v5] x86/speculation/l1tf: Add KConfig for setting the L1D cache flush mode
In-Reply-To: <20200708194715.4073300-1-abhishekbh@google.com>
References: <20200708194715.4073300-1-abhishekbh@google.com>
Date:   Thu, 09 Jul 2020 12:51:34 +0200
Message-ID: <87y2ntotah.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Abhishek Bhardwaj <abhishekbh@google.com> writes:
> This change adds a new kernel configuration that sets the l1d cache
> flush setting at compile time rather than at run time.
>
> The reasons for this change are as follows -
>
>  - Kernel command line arguments are getting unwieldy. These parameters
>  are not a scalable way to set the kernel config. They're intended as a
>  super limited way for the bootloader to pass info to the kernel and
>  also as a way for end users who are not compiling the kernel themselves
>  to tweak the kernel behavior.
>
>  - Also, if a user wants this setting from the start. It's a definite
>  smell that it deserves to be a compile time thing rather than adding
>  extra code plus whatever miniscule time at runtime to pass an
>  extra argument.
>
>  - Finally, it doesn't preclude the runtime / kernel command line way.
>  Users are free to use those as well.

TBH, I don't see why this is a good idea.

 1) I'm not following your argumentation that the command line option is
    a poor Kconfig replacement. The L1TF mode is a boot time (module
    load time) decision and the command line parameter is there to
    override the carefully chosen and sensible default behaviour.

 2) You can add the desired mode to the compiled in (partial) kernel
    command line today.

 3) Boot loaders are well capable of handling large kernel command lines
    and the extra time spend for reading the parameter does not matter
    at all.

 4) It's just a tiny part of the whole speculation maze. If we go there
    for L1TF then we open the flood gates for a gazillion other config
    options.

 5) It's completely useless for distro kernels.

 6) The implementation is horrible. We have proper choice selectors
    which allow to add parseable information instead of random numbers
    and a help text.

Sorry, you need to find better arguments than 'unwieldy and smell' to
make this palatable.

Thanks,

        tglx

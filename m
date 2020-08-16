Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15F9245693
	for <lists+kvm@lfdr.de>; Sun, 16 Aug 2020 09:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgHPHqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 03:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgHPHqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 03:46:35 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B485C061756;
        Sun, 16 Aug 2020 00:46:35 -0700 (PDT)
Received: from zn.tnic (p200300ec2f26be007c9cc0121ac29095.dip0.t-ipconnect.de [IPv6:2003:ec:2f26:be00:7c9c:c012:1ac2:9095])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AC73A1EC0330;
        Sun, 16 Aug 2020 09:46:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1597563990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=orU/2UHEPqbphgi2h5zYUySy0tNug++gwBP5RMomZx8=;
        b=ryAvVoBB7dofMH54oKh7GUdS6rl8SW6NORtfEWKemwrofbikfJgnw9HakyWw2xsM0J5HlM
        Ak5YNB+QlpAon7kGOXdh8/QXYlPTmdF60nbF7r7oOXEWCNZoZoNTxri1EfgcHhL7w+guMp
        +0qDBRtbL10T+Tri4OlSsNqIPs40UKk=
Date:   Sun, 16 Aug 2020 09:47:25 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Abhishek Bhardwaj <abhishekbh@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Anthony Steinhauser <asteinhauser@google.com>,
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
        x86@kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH v5] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
Message-ID: <20200816074725.GF21914@zn.tnic>
References: <20200708194715.4073300-1-abhishekbh@google.com>
 <87y2ntotah.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87y2ntotah.fsf@nanos.tec.linutronix.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+ Masami.

On Thu, Jul 09, 2020 at 12:51:34PM +0200, Thomas Gleixner wrote:
> Abhishek Bhardwaj <abhishekbh@google.com> writes:
> > This change adds a new kernel configuration that sets the l1d cache
> > flush setting at compile time rather than at run time.
> >
> > The reasons for this change are as follows -
> >
> >  - Kernel command line arguments are getting unwieldy. These parameters
> >  are not a scalable way to set the kernel config. They're intended as a
> >  super limited way for the bootloader to pass info to the kernel and
> >  also as a way for end users who are not compiling the kernel themselves
> >  to tweak the kernel behavior.
> >
> >  - Also, if a user wants this setting from the start. It's a definite
> >  smell that it deserves to be a compile time thing rather than adding
> >  extra code plus whatever miniscule time at runtime to pass an
> >  extra argument.
> >
> >  - Finally, it doesn't preclude the runtime / kernel command line way.
> >  Users are free to use those as well.
> 
> TBH, I don't see why this is a good idea.
> 
>  1) I'm not following your argumentation that the command line option is
>     a poor Kconfig replacement. The L1TF mode is a boot time (module
>     load time) decision and the command line parameter is there to
>     override the carefully chosen and sensible default behaviour.
> 
>  2) You can add the desired mode to the compiled in (partial) kernel
>     command line today.
> 
>  3) Boot loaders are well capable of handling large kernel command lines
>     and the extra time spend for reading the parameter does not matter
>     at all.

Also, there's Documentation/admin-guide/bootconfig.rst which extends
cmdline options handling even more and allows for passing options in a
file. Maybe that'll help in this case too.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

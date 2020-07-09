Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5633421AAB0
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 00:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgGIWnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 18:43:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:16869 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgGIWnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 18:43:22 -0400
IronPort-SDR: W254WfSYLz9y3snHU1ThpiJ4HHSL1SWGswMBrhwaX/uTbTbXdsJ40qJ8evdk4TUbMJK0e/Z92q
 eoz/QynY+0Dw==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="166211008"
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="166211008"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 15:43:20 -0700
IronPort-SDR: XnG1/K4S8johhaed4MZaJxAY9dVPUcsKf/c+9XPpsZbSCq6wllfw9WrpJHAZbDIYlbrM8JCbuj
 iToHPDTAiL0Q==
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="267535283"
Received: from smtp.ostc.intel.com ([10.54.29.231])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 15:43:20 -0700
Received: from localhost (mtg-dev.jf.intel.com [10.54.74.10])
        by smtp.ostc.intel.com (Postfix) with ESMTP id 95AC46177;
        Thu,  9 Jul 2020 15:43:19 -0700 (PDT)
Date:   Thu, 9 Jul 2020 15:43:19 -0700
From:   mark gross <mgross@linux.intel.com>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Abhishek Bhardwaj <abhishekbh@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86 <x86@kernel.org>
Subject: Re: [PATCH v5] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
Message-ID: <20200709224319.GC12345@mtg-dev.jf.intel.com>
Reply-To: mgross@linux.intel.com
References: <20200708194715.4073300-1-abhishekbh@google.com>
 <87y2ntotah.fsf@nanos.tec.linutronix.de>
 <CAD=FV=WCu7o41iyn27vNBWo4f_X_XVy+PPPjBKc+70g5jd5+8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=WCu7o41iyn27vNBWo4f_X_XVy+PPPjBKc+70g5jd5+8w@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 09, 2020 at 12:42:57PM -0700, Doug Anderson wrote:
> Hi,
> 
> On Thu, Jul 9, 2020 at 3:51 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Abhishek Bhardwaj <abhishekbh@google.com> writes:
> > > This change adds a new kernel configuration that sets the l1d cache
> > > flush setting at compile time rather than at run time.
> > >
> > > The reasons for this change are as follows -
> > >
> > >  - Kernel command line arguments are getting unwieldy. These parameters
> > >  are not a scalable way to set the kernel config. They're intended as a
> > >  super limited way for the bootloader to pass info to the kernel and
> > >  also as a way for end users who are not compiling the kernel themselves
> > >  to tweak the kernel behavior.
> > >
> > >  - Also, if a user wants this setting from the start. It's a definite
> > >  smell that it deserves to be a compile time thing rather than adding
> > >  extra code plus whatever miniscule time at runtime to pass an
> > >  extra argument.
> > >
> > >  - Finally, it doesn't preclude the runtime / kernel command line way.
> > >  Users are free to use those as well.
> >
> > TBH, I don't see why this is a good idea.
> >
> >  1) I'm not following your argumentation that the command line option is
> >     a poor Kconfig replacement. The L1TF mode is a boot time (module
> >     load time) decision and the command line parameter is there to
> >     override the carefully chosen and sensible default behaviour.
> 
> When you say that the default behavior is carefully chosen and
> sensible, are you saying that (in your opinion) there would never be a
> good reason for someone distributing a kernel to others to change the
> default?  Certainly I agree that having the kernel command line
> parameter is nice to allow someone to override whatever the person
> building the kernel chose, but IMO it's not a good way to change the
> default built-in to the kernel.
> 
> The current plan (as I understand it) is that we'd like to ship
> Chromebook kernels with this option changed from the default that's
> there now.  In your opinion, is that a sane thing to do?
> 
> 
> >  2) You can add the desired mode to the compiled in (partial) kernel
> >     command line today.
> 
> This might be easier on x86 than it is on ARM.  ARM (and ARM64)
> kernels only have two modes: kernel provides cmdline and bootloader
> provides cmdline.  There are out-of-mainline ANDROID patches to
> address this but nothing in mainline.
> 
> The patch we're discussing now is x86-only so it's not such a huge
> deal, but the fact that combining the kernel and bootloader
> commandline never landed in mainline for arm/arm64 means that this
> isn't a super common/expected thing to do.
> 
> 
> >  3) Boot loaders are well capable of handling large kernel command lines
> >     and the extra time spend for reading the parameter does not matter
> >     at all.
> 
> Long command lines can still be a bit of a chore for humans to deal
> with.  Many times I've needed to look at "/proc/cmdline" and make
> sense of it.  The longer the command line is and the more cruft
> stuffed into it the more of a chore it is.  Yes, this is just one
> thing to put in the command line, but if 10 different drivers all have
> their "one thing" to put there it gets really long.  If 100 different
> drivers all want their one config option there it gets really really
> long.  IMO the command line should be a last resort place to put
> things and should just contain:

This takes me back to my years doing android kernel work for Intel, I'm glad
those are over.  Yes, the android kernel command lines got hideous, I think we
even had patches to make the cmdline buffer bigger than the default was.

From a practical point of view the command line was part of the boot image and
cryptography protected so it was a handy way to securely communicate parameters
from the platform to the kernel, drivers and even just user mode.  It got
pretty ugly but, it worked (mostly).

What I don't get is why pick on l1tf in isolation?  There are a bunch of
command line parameters similar to l1tf.  Would a more general option make
sense?

Anyway, I think there is a higher level issue you are poking at that might be
better addressed by talking about it directly.

--mark



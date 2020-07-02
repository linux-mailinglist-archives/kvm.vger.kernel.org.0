Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08337212F59
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 00:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgGBWPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 18:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgGBWPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 18:15:16 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8412BC08C5DD
        for <kvm@vger.kernel.org>; Thu,  2 Jul 2020 15:15:16 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t27so20664204ill.9
        for <kvm@vger.kernel.org>; Thu, 02 Jul 2020 15:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lcJAZjj8xewF97TwahN5y7Et+lrdL5BLJ9rAmJHlt1A=;
        b=WBlUeMpgJQDKEDr6LjGfbHL+WCZTjSL7sdTk3Er+AOhPtLqBsqC8FMT3017u+4ojX4
         NMLBegMXmRc6lbCAfWFJf75lGJnl9q5EP6QDTszdA9UcYkQyysEpsbtLr1iC7Xx0qsah
         rUeoDIYTMOeWWLfa8FBqN4StcBcX89Qv6PPJsVkB8QNMlV9WmT67j3517lvJpCcntFhm
         uBVmKsHhCyiEKXjai1Dpu9CwVlCVCAL97IiCiChQhWYRp5RR6MxKfyhMjGOZ0dWBheRJ
         JyWtYovv+ZQAcoFrBYibIKxIt7hvLCSLv4zV4GRNLwPkJnf1lbnOvi2uwNwytCpODpCB
         n4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lcJAZjj8xewF97TwahN5y7Et+lrdL5BLJ9rAmJHlt1A=;
        b=WAe7LMSmOW+EHknLu9VTDtInjolNqh28AcjwUi4Lb18kRMxw2KThX8jMOtHbMqeS/y
         5gdQWLko6KYhv7EZZKoSDP5TGyHOacbipu5PutK1feRLSJKVn49KrMhPsDLMaKepyKod
         tnEyDDJtyBY7mIr3is+e7GuUZJho3mXqZhVBEpwrqJc+ouTAXaZNpEbzVOpCHG/EZPkH
         EdJpy8KtD8E73kgZS3iIbPFkVj57uAg6ko1ic7RtjpIUrY1GjtsQIl+RzUWMjIrd+lnT
         GnODMkPt41PE+zT5GUom3jqwQuPkWTV3A4LludLYuFiE1xiICq3vIAZJsQRewODN4hI9
         KAKQ==
X-Gm-Message-State: AOAM531VaGz1lRCBXc5X3cdQXVR8HXmKMlDuqaBanFZFDbuVXbYeP3LI
        RjZhZKonTiLy2mU7SLJid2QG5IhV/Mye43BJhd+tig==
X-Google-Smtp-Source: ABdhPJwutdoMSAMPPZKN4tGNoXxVk81W7gmwa77ORx/9+vAJ3jHdPFToEHlBk3Jz0SPEj3C1/QpsDK9V8T2HdSvwIXM=
X-Received: by 2002:a92:cd01:: with SMTP id z1mr14965787iln.103.1593728115606;
 Thu, 02 Jul 2020 15:15:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200702213807.2511503-1-abhishekbh@google.com> <9c648d11-6b52-c755-d0a6-58f035ccd99d@infradead.org>
In-Reply-To: <9c648d11-6b52-c755-d0a6-58f035ccd99d@infradead.org>
From:   Abhishek Bhardwaj <abhishekbh@google.com>
Date:   Thu, 2 Jul 2020 15:14:38 -0700
Message-ID: <CA+noqojQ9FmvQ3k7r1Yh5bdrtDF4+eDd-Spo4PG7fdMSVxVP1w@mail.gmail.com>
Subject: Re: [PATCH v2] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
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
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 2, 2020 at 3:01 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Hi--
>
> On 7/2/20 2:38 PM, Abhishek Bhardwaj wrote:
> > This change adds a new kernel configuration that sets the l1d cache
> > flush setting at compile time rather than at run time.
> >
> > Signed-off-by: Abhishek Bhardwaj <abhishekbh@google.com>
> >
> > ---
> >
> > Changes in v2:
> > - Fix typo in the help of the new KConfig.
> >
> >  arch/x86/kernel/cpu/bugs.c |  8 ++++++++
> >  arch/x86/kvm/Kconfig       | 17 +++++++++++++++++
> >  2 files changed, 25 insertions(+)
> >
> > diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> > index 0b71970d2d3d2..1dcc875cf5547 100644
> > --- a/arch/x86/kernel/cpu/bugs.c
> > +++ b/arch/x86/kernel/cpu/bugs.c
> > @@ -1406,7 +1406,15 @@ enum l1tf_mitigations l1tf_mitigation __ro_after_init = L1TF_MITIGATION_FLUSH;
> >  #if IS_ENABLED(CONFIG_KVM_INTEL)
> >  EXPORT_SYMBOL_GPL(l1tf_mitigation);
> >  #endif
> > +#if (CONFIG_KVM_VMENTRY_L1D_FLUSH == 1)
> > +enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NEVER;
> > +#elif (CONFIG_KVM_VMENTRY_L1D_FLUSH == 2)
> > +enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_COND;
> > +#elif (CONFIG_KVM_VMENTRY_L1D_FLUSH == 3)
> > +enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_ALWAYS;
> > +#else
> >  enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
> > +#endif
> >  EXPORT_SYMBOL_GPL(l1tf_vmx_mitigation);
> >
> >  /*
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index b277a2db62676..d375dcedd447d 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -107,4 +107,21 @@ config KVM_MMU_AUDIT
> >        This option adds a R/W kVM module parameter 'mmu_audit', which allows
> >        auditing of KVM MMU events at runtime.
> >
> > +config KVM_VMENTRY_L1D_FLUSH
> > +     int "L1D cache flush settings (1-3)"
> > +     range 1 3
> > +     default "2"
> > +     depends on KVM && X86 && X86_64
>
> Why does this apply only to KVM?
Sorry, I don't know what this means. The runtime options this aims to
emulate applied to kvm driver.
Hence, this kernel config applies to KVM ?

>
> and the "X86 && X86_64" is more than is needed. Just "X86_64" alone
> should be enough.
Fixed in v3.

>
>
> > +     help
> > +      This setting determines the L1D cache flush behavior before a VMENTER.
> > +      This is similar to setting the option / parameter to
> > +      kvm-intel.vmentry_l1d_flush.
> > +      1 - Never flush.
> > +      2 - Conditionally flush.
> > +      3 - Always flush.
> > +
> > +# OK, it's a little counter-intuitive to do this, but it puts it neatly under
> > +# the virtualization menu.
> > +source "drivers/vhost/Kconfig"
This was a bad copy paste. Removed in v3.
>
>
> I don't quite understand why this 'source' line is here.
> Can you explain more about that, please?
>
> It puts "VHOST drivers" in the menu 2 times, in 2 totally unrelated
> places.  Seems like it could be confusing.
>
> > +
> >  endif # VIRTUALIZATION
>
>
> --
> ~Randy
>


-- 
Abhishek

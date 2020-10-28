Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B9129DE78
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 01:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgJ2Ayp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 20:54:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725910AbgJ2Ayo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Oct 2020 20:54:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603932882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQwNE0TPo9PmUoHBzVicSANl5+Gp3N2w2kA4mvcohBs=;
        b=VfWCgbr3ZfHiwY54EayU2H81+E1RyyS1/HeHISm9r/C+l6JBSWBGFzz4QHiM/l9Mmg8jhL
        zcgy+DELhLdeHqBbhqSKtAs19D+3vzuLTZKxPv1MmyJyskW6mettjQj6yOED0Yy/LdFF4B
        j3IhnAdhGb6n8uE8LdLiq4CJQce4eSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-rWUT70SKPSCIbRIkriC5sw-1; Wed, 28 Oct 2020 04:51:28 -0400
X-MC-Unique: rWUT70SKPSCIbRIkriC5sw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B40D91009E27;
        Wed, 28 Oct 2020 08:51:26 +0000 (UTC)
Received: from starship (unknown [10.35.206.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1162710013C1;
        Wed, 28 Oct 2020 08:51:17 +0000 (UTC)
Message-ID: <afcd052fcf583526f72b80a779dc50f49cd0ae95.camel@redhat.com>
Subject: Re: [PATCH v6 2/4] KVM: x86: report negative values from wrmsr
 emulation to userspace
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Qian Cai <cai@redhat.com>, kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 28 Oct 2020 10:51:16 +0200
In-Reply-To: <c0d5290b9e2dfc7692ed5575babf73092156ca90.camel@redhat.com>
References: <20200922211025.175547-1-mlevitsk@redhat.com>
         <20200922211025.175547-3-mlevitsk@redhat.com>
         <849d7acb00b3dadc3fc7db1e574c03dc74a06270.camel@redhat.com>
         <c0d5290b9e2dfc7692ed5575babf73092156ca90.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-10-27 at 16:31 -0400, Qian Cai wrote:
> On Mon, 2020-10-26 at 15:40 -0400, Qian Cai wrote:
> > On Wed, 2020-09-23 at 00:10 +0300, Maxim Levitsky wrote:
> > > This will allow the KVM to report such errors (e.g -ENOMEM)
> > > to the userspace.
> > > 
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > 
> > Reverting this and its dependency:
> > 
> > 72f211ecaa80 KVM: x86: allow kvm_x86_ops.set_efer to return an error value
> > 
> > on the top of linux-next (they have also unfortunately merged into the
> > mainline
> > at the same time) fixed an issue that a simple Intel KVM guest is unable to
> > boot
> > below.
> 
> So I debug this a bit more. This also breaks nested virt (VMX). We have here:
> 
> [  345.504403] kvm [1491]: vcpu0 unhandled rdmsr: 0x4e data 0x0
> [  345.758560] kvm [1491]: vcpu0 unhandled rdmsr: 0x1c9 data 0x0
> [  345.758594] kvm [1491]: vcpu0 unhandled rdmsr: 0x1a6 data 0x0
> [  345.758619] kvm [1491]: vcpu0 unhandled rdmsr: 0x1a7 data 0x0
> [  345.758644] kvm [1491]: vcpu0 unhandled rdmsr: 0x3f6 data 0x0
> [  345.951601] kvm [1493]: vcpu1 unhandled rdmsr: 0x4e data 0x0
> [  351.857036] kvm [1493]: vcpu1 unhandled wrmsr: 0xc90 data 0xfffff
> 
> After this commit, -ENOENT is returned to vcpu_enter_guest() causes the
> userspace to abort.

Thank you very much for debugging it!

Yestarday I tried pretty much everything to reproduce it on my intel's laptop 
but I wasn't able.

I tried kvm/queue, then latest mainline, linux-next on my laptop
and all worked and even booted nested guests.

For qemu side,
I even tried RHEL's qemu, exact version as you tested.

I got really unlucky here that it seems that none of my guests ever write
an unknown msr.
Now with the information you provided, it is trivial to reproduce it 
even on my AMD machine -
All I need to do is to write an unknown msr, 
something like 'wrmsr 0x1234 0x0' using wrmsr tool.

And for the root cause of this, this is the fallout of last minute rebase of my code on top
of the userspace msr feature. I missed this -ENOENT logic that clashes with mine.

> 
> kvm_msr_ignored_check()
>   kvm_set_msr()
>     kvm_emulate_wrmsr()
>       vmx_handle_exit()
>         vcpu_enter_guest()
> 
> Something like below will unbreak the userspace, but does anyone has a better
> idea?

Checking for -ENOENT might be a right solution but I'll check now in depth,
what else interactions are affected and if this can be done closer to the
place where it happens.

Also, I am more inclined to add a new positive error code (similiar to KVM_MSR_RET_INVALID)
to indicate 'msr not found' error since this error condition is arch defined.

My reasoning is that positive error values should be used for error conditions
that cause #GP to the guest, while negative error values should only be used
for internal errors which are propogated to qemu userspace and usually kill
the guest.

I'll prepare a patch for this very soon.

Best regards,
	Maxim Levitsky 


> 
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1748,7 +1748,7 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>                 return 0;
>  
>         /* Signal all other negative errors to userspace */
> -       if (r < 0)
> +       if (r < 0 && r != -ENOENT)
>                 return r;
>  
>         /* MSR write failed? Inject a #GP */
> 



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34C3FC08FD
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 17:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbfI0PzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 11:55:23 -0400
Received: from mail.skyhub.de ([5.9.137.197]:53804 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727825AbfI0PzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 11:55:23 -0400
Received: from zn.tnic (p200300EC2F0ABB004403369600A4C2F6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:bb00:4403:3696:a4:c2f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 127891EC03F6;
        Fri, 27 Sep 2019 17:55:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1569599718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=uDKIwsSdhiq49Jr8VbsUJz/fuURLdvZ3MjV0Tdg/1DM=;
        b=cJIke0L3NQjBir2sSLlzbq3h05qwXvqcpAWEZN8eInNglGGg0EFRt1UGnfRgA/E11AAHQ0
        j9Dy4UZ8BXV/FdFW4VrIIJ/+knC0yTZ0TY6epsIm8Jtht69ZlW5N3TSlkdehIGHhRQ4oD+
        F5pjsFVd0OVcMsmqZMg5+lmkyHEyZjU=
Date:   Fri, 27 Sep 2019 17:55:18 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Waiman Long <longman@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: Set VMENTER_L1D_FLUSH_NOT_REQUIRED if
 !X86_BUG_L1TF
Message-ID: <20190927155518.GB23002@zn.tnic>
References: <20190826193023.23293-1-longman@redhat.com>
 <6bc37d29-b691-28d6-d4dc-9402fa82093a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6bc37d29-b691-28d6-d4dc-9402fa82093a@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 01:29:28PM -0400, Waiman Long wrote:
> On 8/26/19 3:30 PM, Waiman Long wrote:
> > The l1tf_vmx_mitigation is only set to VMENTER_L1D_FLUSH_NOT_REQUIRED
> > when the ARCH_CAPABILITIES MSR indicates that L1D flush is not required.
> > However, if the CPU is not affected by L1TF, l1tf_vmx_mitigation will
> > still be set to VMENTER_L1D_FLUSH_AUTO. This is certainly not the best
> > option for a !X86_BUG_L1TF CPU.
> >
> > So force l1tf_vmx_mitigation to VMENTER_L1D_FLUSH_NOT_REQUIRED to make it
> > more explicit in case users are checking the vmentry_l1d_flush parameter.
> >
> > Signed-off-by: Waiman Long <longman@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 42ed3faa6af8..a00ce3d6bbfd 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7896,6 +7896,8 @@ static int __init vmx_init(void)
> >  			vmx_exit();
> >  			return r;
> >  		}
> > +	} else {
> > +		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
> >  	}
> >  
> >  #ifdef CONFIG_KEXEC_CORE
> 
> Ping. Any comment on that one?

I'd move that logic with the if (boot_cpu_has(X86_BUG_L1TF)) check inside
vmx_setup_l1d_flush() so that I have this:

        if (!boot_cpu_has_bug(X86_BUG_L1TF)) {
                l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
                return 0;
        }

	if (!enable_ept) {
		...

	}

inside the function and outside am left with:

	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
        if (r) {
		vmx_exit();
                return r;
	}

only. This way I'm concentrating the whole l1tf_vmx_mitigation picking
apart in one place.

Also, note that X86_BUG flags are checked with boot_cpu_has_bug() even
if it boils down to the same thing now.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

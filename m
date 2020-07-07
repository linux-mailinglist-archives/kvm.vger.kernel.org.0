Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01FB216B85
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 13:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgGGLbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 07:31:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32865 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728001AbgGGLbM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 07:31:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594121470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W4e4p5dLUhje1SEFTTrCpD000/W8kMbUlw2wtOztRIY=;
        b=aqSlLTz4s4Y2Y77zZyYs3JwzQhZEldlPSdALOJ85ddwgI4IVClJGDDS4UFpxz3aiqem2p5
        JvVPY0w4D6sMvekbRZZQlPqw7LihfzQBgbHtU69gI0SsFKankqNVGb6IFKO7CJS9RW5H1r
        kGOk0LWmPRGSIFzbT4DHMo/y5TieCvg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-Pk7q_zGqMpqTU48Rs7fcuA-1; Tue, 07 Jul 2020 07:31:07 -0400
X-MC-Unique: Pk7q_zGqMpqTU48Rs7fcuA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F3E1A0BD7;
        Tue,  7 Jul 2020 11:31:05 +0000 (UTC)
Received: from starship (unknown [10.35.206.237])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7021579CE2;
        Tue,  7 Jul 2020 11:30:58 +0000 (UTC)
Message-ID: <a0ab28aa726df404962dbc1c6d1f833947cc149b.camel@redhat.com>
Subject: Re: [PATCH] kvm: x86: rewrite kvm_spec_ctrl_valid_bits
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>
Date:   Tue, 07 Jul 2020 14:30:57 +0300
In-Reply-To: <20200707061105.GH5208@linux.intel.com>
References: <20200702174455.282252-1-mlevitsk@redhat.com>
         <20200702181606.GF3575@linux.intel.com>
         <3793ae0da76fe00036ed0205b5ad8f1653f58ef2.camel@redhat.com>
         <20200707061105.GH5208@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-07-06 at 23:11 -0700, Sean Christopherson wrote:
> On Sun, Jul 05, 2020 at 12:40:25PM +0300, Maxim Levitsky wrote:
> > > Rather than compute the mask every time, it can be computed once on module
> > > load and stashed in a global.  Note, there's a RFC series[*] to support
> > > reprobing bugs at runtime, but that has bigger issues with existing KVM
> > > functionality to be addressed, i.e. it's not our problem, yet :-).
> > > 
> > > [*] https://lkml.kernel.org/r/1593703107-8852-1-git-send-email-mihai.carabas@oracle.com
> > 
> > Thanks for the pointer!
> >  
> > Note though that the above code only runs once, since after a single
> > successful (non #GP) set of it to non-zero value, it is cleared in MSR bitmap
> > for both reads and writes on both VMX and SVM.
> 
> For me the performance is secondary to documenting the fact that the host
> valid bits are fixed for a given instance of the kernel.  There's enough
> going on in kvm_spec_ctrl_valid_bits_host() that's it's not super easy to
> see that it's a "constant" value.
> 
> > This is done because of performance reasons which in this case are more
> > important than absolute correctness.  Thus to some extent the guest checks in
> > the above are pointless.
> >  
> > If you ask me, I would just remove the kvm_spec_ctrl_valid_bits, and pass
> > this msr to guest right away and not on first access.
> 
> That would unnecessarily penalize guests that don't utilize the MSR as KVM
> would need to do a RDMSR on every VM-Exit to grab the guest's value.
I haven't thought about this, this makes sense.

> 
> One oddity with this whole thing is that by passing through the MSR, KVM is
> allowing the guest to write bits it doesn't know about, which is definitely
> not normal.  It also means the guest could write bits that the host VMM
> can't.
> 
> Somehwat crazy idea inbound... rather than calculating the valid bits in
> software, what if we throw the value at the CPU and see if it fails?  At
> least that way the host and guest are subject to the same rules.  E.g.
> 
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2062,11 +2062,19 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                     !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
>                         return 1;
> 
> -               if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
> -                       return 1;
> -
> +               ret = 0;
>                 vmx->spec_ctrl = data;
> -               if (!data)
> +
> +               local_irq_disable();
> +               if (rdmsrl_safe(MSR_IA32_SPEC_CTRL, &data))
> +                       ret = 1;
> +               else if (wrmsrl_safe(MSR_IA32_SPEC_CTRL, vmx->spec_ctrl))
> +                       ret = 1;
> +               else
> +                       wrmsrl(MSR_IA32_SPEC_CTRL, data))
> +               local_irq_enable();
> +
> +               if (ret || !vmx->spec_ctrl)
>                         break;
> 
>                 /*
> 
I don't mind this as well, knowing that this is done only one per VM run anyway.

Best regards,
	Maxim Levitsky



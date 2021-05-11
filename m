Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FBA37A6FE
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 14:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhEKMqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 08:46:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231617AbhEKMqC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 08:46:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620737096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6iTnaUeJqbp8O8yiL1HQxGb5W+6nedaCgjZ90KKHYts=;
        b=V6aHK1IqyAP42ciOfvf25ju+mvoVQb+gFp8OowFSzsJMOUyVLhCnXPV716iwAL6yMuqIUJ
        SPSV1M6zPhxW8FKmZX4s58lAzRwj2x3A8SJVvVU0i7lXEPq6PgHr353z3o+TAwcU2YeKyJ
        XkB1ByG/fE5XqBX2algE/LLz1QqLKho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-Igy2inHDP6Cd7wQENrTfRg-1; Tue, 11 May 2021 08:44:54 -0400
X-MC-Unique: Igy2inHDP6Cd7wQENrTfRg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3035D801817;
        Tue, 11 May 2021 12:44:53 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D33210016FC;
        Tue, 11 May 2021 12:44:49 +0000 (UTC)
Message-ID: <875fa1ff9a85ff601a05030eaa24a1db45a71f36.camel@redhat.com>
Subject: Re: [PATCH 6/8] KVM: VMX: Make vmx_write_l1_tsc_offset() work with
 nested TSC scaling
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Stamatis, Ilias" <ilstam@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "ilstam@mailbox.org" <ilstam@mailbox.org>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Date:   Tue, 11 May 2021 15:44:48 +0300
In-Reply-To: <9e0973a1adef19158e0c09a642b8c733556e272c.camel@amazon.com>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <20210506103228.67864-7-ilstam@mailbox.org>
         <a83fa70e3111f9c9bcbc5204569d084229815b9a.camel@redhat.com>
         <9e0973a1adef19158e0c09a642b8c733556e272c.camel@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-10 at 16:08 +0000, Stamatis, Ilias wrote:
> On Mon, 2021-05-10 at 16:54 +0300, Maxim Levitsky wrote:
> > On Thu, 2021-05-06 at 10:32 +0000, ilstam@mailbox.org wrote:
> > > From: Ilias Stamatis <ilstam@amazon.com>
> > > 
> > > Calculating the current TSC offset is done differently when nested TSC
> > > scaling is used.
> > > 
> > > Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx.c | 26 ++++++++++++++++++++------
> > >  1 file changed, 20 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 49241423b854..df7dc0e4c903 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -1797,10 +1797,16 @@ static void setup_msrs(struct vcpu_vmx *vmx)
> > >               vmx_update_msr_bitmap(&vmx->vcpu);
> > >  }
> > > 
> > > -static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> > > +/*
> > > + * This function receives the requested offset for L1 as an argument but it
> > > + * actually writes the "current" tsc offset to the VMCS and returns it. The
> > > + * current offset might be different in case an L2 guest is currently running
> > > + * and its VMCS02 is loaded.
> > > + */
> > 
> > (Not related to this patch) It might be a good idea to rename this callback
> > instead of this comment, but I am not sure about it.
> > 
> 
> Yes! I was planning to do this on v2 anyway as the name of that function
> is completely misleading/wrong IMHO.
> 
> I think that even the comment inside it that explains that when L1
> doesn't trap WRMSR then L2 TSC writes overwrite L1's TSC is misplaced.
> It should go one or more levels above I believe.
> 
> This function simply
> updates the TSC offset in the current VMCS depending on whether L1 or L2
> is executing. 
> 
> > > +static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
> > >  {
> > >       struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> > > -     u64 g_tsc_offset = 0;
> > > +     u64 cur_offset = l1_offset;
> > > 
> > >       /*
> > >        * We're here if L1 chose not to trap WRMSR to TSC. According
> > > @@ -1809,11 +1815,19 @@ static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> > >        * to the newly set TSC to get L2's TSC.
> > >        */
> > >       if (is_guest_mode(vcpu) &&
> > > -         (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING))
> > > -             g_tsc_offset = vmcs12->tsc_offset;
> > > +         (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)) {
> > > +             if (vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_TSC_SCALING) {
> > > +                     cur_offset = kvm_compute_02_tsc_offset(
> > > +                                     l1_offset,
> > > +                                     vmcs12->tsc_multiplier,
> > > +                                     vmcs12->tsc_offset);
> > > +             } else {
> > > +                     cur_offset = l1_offset + vmcs12->tsc_offset;
> > > +             }
> > > +     }
> > > 
> > > -     vmcs_write64(TSC_OFFSET, offset + g_tsc_offset);
> > > -     return offset + g_tsc_offset;
> > > +     vmcs_write64(TSC_OFFSET, cur_offset);
> > > +     return cur_offset;
> > >  }
> > > 
> > >  /*
> > 
> > This code would be ideal to move to common code as SVM will do basically
> > the same thing.
> > Doesn't have to be done now though.
> > 
> 
> Hmm, how can we do the feature availability checking in common code?

We can add a vendor callback for this.

Just a few thoughts about how I think we can implement
the nested TSC scaling in (mostly) common code:


Assuming that the common code knows that:
1. Nested guest is running (already the case)

2. The format of the scaling multiplier is known 
(thankfully both SVM and VMX use fixed point binary number.

SVM is using 8.32 format and VMX using 16.48 format.

The common code already knows this via
kvm_max_tsc_scaling_ratio/kvm_tsc_scaling_ratio_frac_bits.

3. the value of nested TSC scaling multiplier 
is known to the common code.

(a callback to VMX/SVM code to query the TSC scaling value, 
and have it return 1 when TSC scaling is disabled should work)


Then the common code can do the whole thing, and only
let the SVM/VMX code write the actual multiplier.

As far as I know on the SVM, the TSC scaling works like that:

1. SVM has a CPUID bit to indicate that tsc scaling is supported.
(X86_FEATURE_TSCRATEMSR)

When this bit is set, TSC scale ratio is unconditionally enabled (but
can be just 1), and it is set via a special MSR (MSR_AMD64_TSC_RATIO)
rather than a field in VMCB (someone at AMD did cut corners...).

However since the TSC scaling is only effective when a guest is running,
that MSR can be treated almost as if it was just another VMCB field.

The TSC scale value is 32 bit fraction and another 8 bits the integer value
(as opposed to 48 bit fraction on VMX and 16 bits integer value).

I don't think that there are any other differences.

I should also note that I can do all of the above myself if 
I end up implementing the nested TSC scaling on AMD 
so I don't object much to the way that this patch series is done.

Best regards,
	Maxim Levitsky

> 
> > Best regards,
> >         Maxim Levitsky
> > 



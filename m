Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C7C214B94
	for <lists+kvm@lfdr.de>; Sun,  5 Jul 2020 11:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgGEJkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jul 2020 05:40:43 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22628 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726467AbgGEJkm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Jul 2020 05:40:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593942040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R3S9naE26LLsywlsiEVd6KhNGZPK/yDfgjAfGIlEZ8Q=;
        b=QdHUpFJb84A11/z3rmthx0n2SamFWk0booyKYcTDgiugzOGjnZ7ZjOR5gBcqZXzgemYhkt
        0Lojco9R9ENRva5tZLNKCLZGM8UWfgvnG0S1Sa/mGuXpFLdyIEHrkyfyQP2dTEVLiiqgMK
        iXS6TywPfbIk1hT4OK6khjBJYPGEAyM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-hD2BViJVP0Og5_7dP_yKXA-1; Sun, 05 Jul 2020 05:40:34 -0400
X-MC-Unique: hD2BViJVP0Og5_7dP_yKXA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4258C800D5C;
        Sun,  5 Jul 2020 09:40:32 +0000 (UTC)
Received: from starship (unknown [10.35.206.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C67310013D0;
        Sun,  5 Jul 2020 09:40:27 +0000 (UTC)
Message-ID: <3793ae0da76fe00036ed0205b5ad8f1653f58ef2.camel@redhat.com>
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
Date:   Sun, 05 Jul 2020 12:40:25 +0300
In-Reply-To: <20200702181606.GF3575@linux.intel.com>
References: <20200702174455.282252-1-mlevitsk@redhat.com>
         <20200702181606.GF3575@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-07-02 at 11:16 -0700, Sean Christopherson wrote:
> On Thu, Jul 02, 2020 at 08:44:55PM +0300, Maxim Levitsky wrote:
> > There are few cases when this function was creating a bogus #GP condition,
> > for example case when and AMD host supports STIBP but doesn't support SSBD.
> > 
> > Follow the rules for AMD and Intel strictly instead.
> 
> Can you elaborate on the conditions that are problematic, e.g. what does
> the guest expect to exist that KVM isn't providing?

Hi Sean Christopherson!
Sorry that I haven't explained the issue here.
I explained it in bugzilla I opened in details and forgot to explain it
in the commit message.
https://bugzilla.redhat.com/show_bug.cgi?id=1853447
 
 
The issue is that on my cpu (3970X), it does not support IBRS,
but it does support STIBP, and thus guest gets the STIBP cpuid bits enabled
(both the amd one and KVM also enables the intel's cpuid bit for this feature).
 
Then, when guest actually starts to use STIBP, it gets #GP because both of these conditions
potentially don't allow STIBP bit to be set when IBRS is not supported:
 
	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS))
		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL) &&
	    !boot_cpu_has(X86_FEATURE_AMD_IBRS))
		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
 
Most likely it fails on the second condition, since X86_FEATURE_SPEC_CTRL
is enabled in the guest because host does support IBPB which X86_FEATURE_SPEC_CTRL also cover.
 
But the host doesn't support X86_FEATURE_SPEC_CTRL and it doesn't support X86_FEATURE_AMD_IBRS
thus second condition clears the SPEC_CTRL_STIBP wrongly.
 
Now in addition to that, I long ago had known that win10 guests on my machine started to
crash when qemu added ability to pass through X86_FEATURE_AMD_IBRS.
I haven't paid much attention to that other than bisecting this and adding '-amd-stibp' to my cpu flags.
 
I did notice that I am not the only one to have that issue, for example
https://www.reddit.com/r/VFIO/comments/gf53o8/upgrading_to_qemu_5_broke_my_setup_windows_bsods/
https://forum.level1techs.com/t/amd-fix-for-host-passthrough-on-qemu-5-0-0-kernel-5-6/157710
 
Now after I debugged this issue in Linux, it occured to me that this might be the same issue as in Windows,
and indeed it is. The only difference is that Windows doesn't start to play with STIBP when Intel
specific cpuid bit is set on AMD machine (which KVM sets for long time) but starts to enable it when AMD specific
bit is set, that is X86_FEATURE_AMD_IBRS, the bit that qemu recently started to set and it gets the same #GP and crashes.
 
From findings on my machine, if we cross-reference this with the above posts, I can assume that many Ryzens have this configuration 
of no support for IBRS but support STIBP.
In fact I don't see the kernel use IBRS much (it seem only used around firmware calls or so), so it makes sense
that AMD chose to not enable it.
 
For the fix itself,
I can fix this by only changing the above condition, but then I read the AMD whitepaper on
this and they mention that bits in IA32_SPEC_CTRL don't #GP even if not supported,
and to implement this correctly would be too complicated with current logic,
thus I rewrote the logic to be as simple as possible and as close to the official docs as possible
as well.
 

> 
> > AMD #GP rules for IA32_SPEC_CTRL can be found here:
> > https://bugzilla.kernel.org/show_bug.cgi?id=199889
> > 
> > Fixes: 6441fa6178f5 ("KVM: x86: avoid incorrect writes to host MSR_IA32_SPEC_CTRL")
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c | 57 ++++++++++++++++++++++++++++++++++------------
> >  1 file changed, 42 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 00c88c2f34e4..a6bed4670b7f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10670,27 +10670,54 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
> >  
> > -u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
> > +
> > +static u64 kvm_spec_ctrl_valid_bits_host(void)
> > +{
> > +	uint64_t bits = 0;
> > +
> > +	if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
> > +		bits |= SPEC_CTRL_IBRS;
> > +	if (boot_cpu_has(X86_FEATURE_INTEL_STIBP))
> > +		bits |= SPEC_CTRL_STIBP;
> > +	if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD))
> > +		bits |= SPEC_CTRL_SSBD;
> > +
> > +	if (boot_cpu_has(X86_FEATURE_AMD_IBRS) || boot_cpu_has(X86_FEATURE_AMD_STIBP))
> > +		bits |= SPEC_CTRL_STIBP | SPEC_CTRL_IBRS;
> > +
> > +	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
> > +		bits |= SPEC_CTRL_STIBP | SPEC_CTRL_IBRS | SPEC_CTRL_SSBD;
> > +
> > +	return bits;
> > +}
> 
> Rather than compute the mask every time, it can be computed once on module
> load and stashed in a global.  Note, there's a RFC series[*] to support
> reprobing bugs at runtime, but that has bigger issues with existing KVM
> functionality to be addressed, i.e. it's not our problem, yet :-).
> 
> [*] https://lkml.kernel.org/r/1593703107-8852-1-git-send-email-mihai.carabas@oracle.com

Thanks for the pointer!
 
Note though that the above code only runs once, since after a single successful (non #GP) set
of it to non-zero value, it is cleared in MSR bitmap for both reads and writes on
both VMX and SVM.
This is done because of performance reasons which in this case are more important than absolute correctness.
Thus to some extent the guest checks in the above are pointless.
 
If you ask
me, I would just remove the kvm_spec_ctrl_valid_bits, and pass this msr to guest
right away and not on first access.
 
I talked with Paulo about this and his opinion if I understand correctly is that the
above is
a best effort correctness wise since at least we emulate the bits correctly on first access.

> 
> > +
> > +static u64 kvm_spec_ctrl_valid_bits_guest(struct kvm_vcpu *vcpu)
> >  {
> > -	uint64_t bits = SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD;
> > +	uint64_t bits = 0;
> >  
> > -	/* The STIBP bit doesn't fault even if it's not advertised */
> > -	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
> > -	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS))
> > -		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
> > -	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL) &&
> > -	    !boot_cpu_has(X86_FEATURE_AMD_IBRS))
> > -		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
> > +	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
> > +		bits |= SPEC_CTRL_IBRS;
> > +	if (guest_cpuid_has(vcpu, X86_FEATURE_INTEL_STIBP))
> > +		bits |= SPEC_CTRL_STIBP;
> > +	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL_SSBD))
> > +		bits |= SPEC_CTRL_SSBD;
> >  
> > -	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL_SSBD) &&
> > -	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
> > -		bits &= ~SPEC_CTRL_SSBD;
> > -	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) &&
> > -	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
> > -		bits &= ~SPEC_CTRL_SSBD;
> > +	if (guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
> > +			guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP))
> 
> Bad indentation.
True.

> 
> > +		bits |= SPEC_CTRL_STIBP | SPEC_CTRL_IBRS;
> > +	if (guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
> > +		bits |= SPEC_CTRL_STIBP | SPEC_CTRL_IBRS | SPEC_CTRL_SSBD;
> 
> Would it be feasible to split into two patches?  The first (tagged Fixes:)
> to make the functional changes without inverting the logic or splitting, and
> then do the cleanup?  It's really hard to review this patch because I can't
> easily tease out what's different in terms of functionality.

The new logic follows (hopefully) Intel's spec and AMD spec.
I will try to split it though.



> 
> >  	return bits;
> >  }
> > +
> > +u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
> > +{
> > +	return kvm_spec_ctrl_valid_bits_host() &
> > +	       kvm_spec_ctrl_valid_bits_guest(vcpu);
> > +}
> > +
> > +
> >  EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
> >  
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
> > -- 
> > 2.25.4
> > 

Thanks for the review,
	Best regards,
		Maxim Levitsky




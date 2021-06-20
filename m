Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFDA3AE0E9
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 00:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhFTW1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Jun 2021 18:27:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229897AbhFTW1m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 20 Jun 2021 18:27:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624227929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=crwPYk9/LCjPOHjUmfS2MavxdcK4sFFcOYXWTbXDKlk=;
        b=iAu5azhfdFP8nQAdWXMqWBdAFkV26dzyKQGgV6Ga+1THjppaYKr4nmKX8UNcdB5J+q2wc6
        4yNTBd0rMuJBsie7pfmScvrYG9TviRywE1bMRZMv50cmMIyWZ8rQovblWHyUEFW3lhGZ51
        PUmySUu8qixt/0KT2CTtPIzUB0+oCe0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-cldV6BLFPKSG5AdxXLOuTw-1; Sun, 20 Jun 2021 18:25:27 -0400
X-MC-Unique: cldV6BLFPKSG5AdxXLOuTw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0541636268;
        Sun, 20 Jun 2021 22:25:25 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 492C460C9D;
        Sun, 20 Jun 2021 22:25:20 +0000 (UTC)
Message-ID: <7df87b7f0b2e029b483d08611e70291aab4e4d0b.camel@redhat.com>
Subject: Re: [PATCH v3 8/8] KVM: x86: avoid loading PDPTRs after migration
 when possible
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>
Date:   Mon, 21 Jun 2021 01:25:18 +0300
In-Reply-To: <YM0H3Hvs8/3+twnc@google.com>
References: <20210607090203.133058-1-mlevitsk@redhat.com>
         <20210607090203.133058-9-mlevitsk@redhat.com> <YM0H3Hvs8/3+twnc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-06-18 at 20:53 +0000, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 11260e83518f..eadfc9caf500 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -815,6 +815,8 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
> >  
> >  	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
> >  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> > +	vcpu->arch.pdptrs_restored_oob = false;
> > +
> >  out:
> >  
> >  	return ret;
> > @@ -10113,6 +10115,7 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
> >  
> >  		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> >  		mmu_reset_needed = 1;
> > +		vcpu->arch.pdptrs_restored_oob = true;
> 
> Setting pdptrs_restored_oob[*] here and _only_ clearing it on successful
> load_pdptrs() is not robust.  Potential problems once the flag is set:

Hi Sean Christopherson!
Thanks for the review!

I also thought about the exact same thing when I submitted the last version of
this patches (prior version didn't clear the flag at all but I noticed that
while doing self review of my patches).


> 
>   1.  Userspace calls KVM_SET_SREGS{,2} without valid PDPTRs.  Flag is now stale.

True. It isn't that big issue though since the only way to this is to also disable PAE mode
in CR4 during the call or before it, thus PDPTRs becomes irrelevant.
Once PAE is enabled again, PDPTRs will be loaded again, resetting this flag.

Something to note is that we also don't clear available/dirty status of VCPU_EXREG_PDPTR
in this case.



>   2.  kvm_check_nested_events() VM-Exits to L1 before the flag is processed.
>       Flag is now stale.

Also true. However this means that we enter L1 now, and once we are ready to enter
L2 again, we will load PDPTRS from guest memory as thankfully VM entries in PAE mode
do load PDPTRS from guest memory (both on Intel and AMD).



> 
> (2) might not be problematic in practice since the "normal" load_pdptrs()
> should reset the flag on the next VM-Enter, but it's really, really hard to tell.
> E.g. what if an SMI causes an exit and _that_ non-VM-Enter reload of L2 state
> is the first to trip the flag?  The bool is essentially an extension of
> KVM_REQ_GET_NESTED_STATE_PAGES, I think it makes sense to clear the flag whenever
> KVM_REQ_GET_NESTED_STATE_PAGES is cleared.

Could you expalain a bit better about SMM case? When SMM entry is done, at least Intel
spec is silent on if PDPTRs are preserved in SMRAM (and it doesn't have any place allocated
for them).

We currently don't preserve PDTPRS on SMM entry and we reload them via CR3/CR0 write 
when we exit SMM.

Ah I see now, on VMX the non VM-Enter code path is also used for returns from SMM,
and it sets the KVM_REQ_GET_NESTED_STATE_PAGES, so this is a real issue.
If SMM code enabled PAE, and then KVM_SET_SREGS2 was used, and followed by
RSM, we indeed have a risk of not loading the PDPTRs.

I think that this is best fixed by resetting this flag in vmx_leave_smm,
since RSM loads PDPTRS from memory always otherwise.

I also note that we don't do KVM_REQ_GET_NESTED_STATE_PAGES on SVM,
on return from SMM at all,
thus on SVM I think I broke the resume from SMM to a guest if the guest is PAE.
Oh well....

I will now extend the testing I usually do to SMM and prepare a patch to fix this.

> 
> Another thing that's not obvious is the required ordering between KVM_SET_SREGS2
> and KVM_SET_NESTED_STATE.  AFAICT it's not documented, but that may be PEBKAC on
> my end.  E.g. what happens if walk_mmu == &root_mmu (L1 active in targte KVM)
> when SET_SREGS2 is called, and _then_ KVM_SET_NESTED_STATE is called?

Isn't that exactly the current ordering (and reason why I had to do this patch series)
First the KVM_SET_SREGS is called indeed prior to KVM_SET_NESTED_STATE and it can
potentially load wrong PDPTRS, and then KVM_SET_NESTED_STATE is called which used
to 'fix' this by reloading them always.



> 
> [*] pdptrs_from_userspace in Paolo's tree.
> 


I think that strictly speaking this flag should be cleared when PAE mode is disabled,
and together with clearing of availablity of VCPU_EXREG_PDPTR.

I don't agree that this flag is an extension of the KVM_REQ_GET_NESTED_STATE_PAGES.
I think this flag is more like an extra property of VCPU_EXREG_PDPTR.
In addition to being dirty/available, this "register" can be loaded from memory
or restored from migration stream.

Thanks again for the review,
Best regards,
	Maxim Levitsky


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3B32F6082
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 12:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbhANLtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 06:49:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60575 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726919AbhANLtI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 06:49:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610624861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KJCiyPYZTNhq1kKkty7sXVGcoXJ6M0psKDMUOgP2lPE=;
        b=Dun9pJN5a/2FavC97gb7kEAL4ttni50IOwuhHnXHi5zRVHcm0vwI7Jhpo3ovMUSo0aRQVc
        W6Z2x8/XCGG9gHF4fnitPX0xJF/KrzNlom4oyi755vEKZpj9FROhClFT9o6dEYj+KB9CBB
        hDdItp1gJIjjWN9rg/rCLjg1J1ZuiXU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-XaxpEonTP4O0k4dRUyyHdg-1; Thu, 14 Jan 2021 06:47:39 -0500
X-MC-Unique: XaxpEonTP4O0k4dRUyyHdg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9693107ACF8;
        Thu, 14 Jan 2021 11:47:37 +0000 (UTC)
Received: from starship (unknown [10.35.206.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E77E45D6AD;
        Thu, 14 Jan 2021 11:47:30 +0000 (UTC)
Message-ID: <db574a30f50a2f556dc983f18f78f28c933fdac7.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered
 by VM instructions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Bandan Das <bsd@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, dgilbert@redhat.com
Date:   Thu, 14 Jan 2021 13:47:28 +0200
In-Reply-To: <jpgsg76kjsm.fsf@linux.bootlegged.copy>
References: <20210112063703.539893-1-wei.huang2@amd.com>
         <X/37QBMHxH8otaMa@google.com> <jpgsg76kjsm.fsf@linux.bootlegged.copy>
Content-Type: multipart/mixed; boundary="=-EPygeQZyFJqIITg/+qQu"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-EPygeQZyFJqIITg/+qQu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2021-01-12 at 15:00 -0500, Bandan Das wrote:
> Sean Christopherson <seanjc@google.com> writes:
> ...
> > > -	if ((emulation_type & EMULTYPE_VMWARE_GP) &&
> > > -	    !is_vmware_backdoor_opcode(ctxt)) {
> > > -		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> > > -		return 1;
> > > +	if (emulation_type & EMULTYPE_PARAVIRT_GP) {
> > > +		vminstr = is_vm_instr_opcode(ctxt);
> > > +		if (!vminstr && !is_vmware_backdoor_opcode(ctxt)) {
> > > +			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> > > +			return 1;
> > > +		}
> > > +		if (vminstr)
> > > +			return vminstr;
> > 
> > I'm pretty sure this doesn't correctly handle a VM-instr in L2 that hits a bad
> > L0 GPA and that L1 wants to intercept.  The intercept bitmap isn't checked until
> > x86_emulate_insn(), and the vm*_interception() helpers expect nested VM-Exits to
> > be handled further up the stack.

Actually IMHO this exactly what we want. We want L0 to always intercept
these #GPs, and hide them from the guest.

What we do need to do (and I prepared and attached a patch for that, is that if we run
a guest, we want to inject corresponding vmexit (like SVM_EXIT_VMRUN)
instead of emulating the instruction.
The attached patch does this, and it made my kvm unit test pass,
even if the test was run in a VM (with an unpatched kernel).

This together with setting that X86_FEATURE_SVME_ADDR_CHK bit for
the guest will allow us to hide that errata completely from the guest
which is a very good thing.
(for example for guests that we can't modify)


Best regards,
	Maxim Levitsky



> > 
> So, the condition is that L2 executes a vmload and #GPs on a reserved address, jumps to L0 - L0 doesn't
> check if L1 has asked for the instruction to be intercepted and goes on with emulating
> vmload and returning back to L2 ?



> 
> > >  	}
> > >  
> > >  	/*
> > > -- 
> > > 2.27.0
> > > 


--=-EPygeQZyFJqIITg/+qQu
Content-Disposition: attachment; filename="patch.diff"
Content-Type: text/x-patch; name="patch.diff"; charset="UTF-8"
Content-Transfer-Encoding: base64

Y29tbWl0IDI4YWI4OWFhYTExMzgwMzA2YmFmYmY0OTI2NTIyMmYyYTJkYTcxZGEKQXV0aG9yOiBN
YXhpbSBMZXZpdHNreSA8bWxldml0c2tAcmVkaGF0LmNvbT4KRGF0ZTogICBUaHUgSmFuIDE0IDEw
OjUzOjI1IDIwMjEgKzAyMDAKCiAgICBrdm06IHg4NjogZml4IHRoYXQgZXJyYXRhIGZvciBuZXN0
ZWQgZ3Vlc3RzCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2bS9zdm0uYyBiL2FyY2gveDg2
L2t2bS9zdm0vc3ZtLmMKaW5kZXggYzMxZTAwNTI1MmQ2OS4uOWNmYTU5NDZmYWM2OSAxMDA2NDQK
LS0tIGEvYXJjaC94ODYva3ZtL3N2bS9zdm0uYworKysgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5j
CkBAIC0yMDI3LDYgKzIwMjcsMjYgQEAgc3RhdGljIGludCBzdm1fZW11bGF0ZV92bV9pbnN0cihz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU4IG1vZHJtKQogewogCXN0cnVjdCB2Y3B1X3N2bSAqc3Zt
ID0gdG9fc3ZtKHZjcHUpOwogCisJaWYgKGlzX2d1ZXN0X21vZGUodmNwdSkpIHsKKwkJc3dpdGNo
IChtb2RybSkgeworCQljYXNlIDB4ZDg6IC8qIFZNUlVOICovCisJCQlzdm0tPnZtY2ItPmNvbnRy
b2wuZXhpdF9jb2RlID0gU1ZNX0VYSVRfVk1SVU47CisJCQlicmVhazsKKwkJY2FzZSAweGRhOiAv
KiBWTUxPQUQgKi8KKwkJCXN2bS0+dm1jYi0+Y29udHJvbC5leGl0X2NvZGUgPSBTVk1fRVhJVF9W
TUxPQUQ7CisJCQlicmVhazsKKwkJY2FzZSAweGRiOiAvKiBWTVNBVkUgKi8KKwkJCXN2bS0+dm1j
Yi0+Y29udHJvbC5leGl0X2NvZGUgPSBTVk1fRVhJVF9WTUxPQUQ7CisJCQlicmVhazsKKwkJZGVm
YXVsdDoKKwkJCWdvdG8gaW5qZWN0X2V4Y2VwdGlvbjsKKwkJfQorCisJCXN2bS0+dm1jYi0+Y29u
dHJvbC5leGl0X2luZm9fMSA9IDA7CisJCXN2bS0+dm1jYi0+Y29udHJvbC5leGl0X2luZm9fMiA9
IDA7CisJCXJldHVybiBuZXN0ZWRfc3ZtX3ZtZXhpdChzdm0pOworCX0KKwogCXN3aXRjaCAobW9k
cm0pIHsKIAljYXNlIDB4ZDg6IC8qIFZNUlVOICovCiAJCXJldHVybiB2bXJ1bl9pbnRlcmNlcHRp
b24oc3ZtKTsKQEAgLTIwMzUsNiArMjA1NSw3IEBAIHN0YXRpYyBpbnQgc3ZtX2VtdWxhdGVfdm1f
aW5zdHIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1OCBtb2RybSkKIAljYXNlIDB4ZGI6IC8qIFZN
U0FWRSAqLwogCQlyZXR1cm4gdm1zYXZlX2ludGVyY2VwdGlvbihzdm0pOwogCWRlZmF1bHQ6Citp
bmplY3RfZXhjZXB0aW9uOgogCQkvKiBpbmplY3QgYSAjR1AgZm9yIGFsbCBvdGhlciBjYXNlcyAq
LwogCQlrdm1fcXVldWVfZXhjZXB0aW9uX2UodmNwdSwgR1BfVkVDVE9SLCAwKTsKIAkJcmV0dXJu
IDE7Cg==



--=-EPygeQZyFJqIITg/+qQu--


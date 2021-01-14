Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA352F6068
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 12:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbhANLkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 06:40:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726545AbhANLkw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 06:40:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610624365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FWSCsULV8D2VOcK8u1F6d/iVpJrDsWQFMD1WA7PL7GA=;
        b=TaTnP/gJtnaaqrux+2+zVsoSVsClTMrpf9TVCk3HOn5xLZGWgo6jIhOzAK5irr5BAUzbe2
        YF19HDCZ8wkdy7OQsKDTdhzw+bA8B13vL4zKUtPt4lgJ2RJecL1TRnS3ru5wZQmKppKCPJ
        FGN8+Hg0XnWOs9kPlFx4oS9eGKjfiN0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-AlMHmV3NPcKz0DLidKap6Q-1; Thu, 14 Jan 2021 06:39:21 -0500
X-MC-Unique: AlMHmV3NPcKz0DLidKap6Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F27BF1842143;
        Thu, 14 Jan 2021 11:39:19 +0000 (UTC)
Received: from starship (unknown [10.35.206.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE22860C69;
        Thu, 14 Jan 2021 11:39:12 +0000 (UTC)
Message-ID: <932e6ab3da191bd342e354ad7e4d05c835f785e9.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Add support for VMCB address check change
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com
Date:   Thu, 14 Jan 2021 13:39:11 +0200
In-Reply-To: <X/316tCByxsBQP5t@google.com>
References: <20210112063703.539893-1-wei.huang2@amd.com>
         <20210112063703.539893-2-wei.huang2@amd.com> <X/316tCByxsBQP5t@google.com>
Content-Type: multipart/mixed; boundary="=-EVQygRQtbtdeLy3t4p4U"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-EVQygRQtbtdeLy3t4p4U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2021-01-12 at 11:18 -0800, Sean Christopherson wrote:
> On Tue, Jan 12, 2021, Wei Huang wrote:
> > New AMD CPUs have a change that checks VMEXIT intercept on special SVM
> > instructions before checking their EAX against reserved memory region.
> > This change is indicated by CPUID_0x8000000A_EDX[28]. If it is 1, KVM
> > doesn't need to intercept and emulate #GP faults for such instructions
> > because #GP isn't supposed to be triggered.
> > 
> > Co-developed-by: Bandan Das <bsd@redhat.com>
> > Signed-off-by: Bandan Das <bsd@redhat.com>
> > Signed-off-by: Wei Huang <wei.huang2@amd.com>
> > ---
> >  arch/x86/include/asm/cpufeatures.h | 1 +
> >  arch/x86/kvm/svm/svm.c             | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index 84b887825f12..ea89d6fdd79a 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -337,6 +337,7 @@
> >  #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
> >  #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
> >  #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
> > +#define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
> 
> Heh, KVM should advertise this to userspace by setting the kvm_cpu_cap bit.  KVM
> KVM forwards relevant VM-Exits to L1 without checking if rAX points at an
> invalid L1 GPA.


I agree that we should be able to fix/hide the errata from the L1,
and expose this bit to L1 to avoid it trying to apply this workaround
itself when it itself runs nested guests.

Note that there is currently a bug in this patch series, that prevents
this workaround to work for a guest that runs nested guests itself (e.g L3):

(when we intercept the #GP, and we are running
a nested guest, we should do a vmexit with SVM_EXIT_VMRUN/VMSAVE/etc exit
reason instead of running the instruction), but this can be fixed,
I did it locally and it works.

(lightly tested) patch for that attached.

Best regards,
	Maxim Levitsky
> 
> >  /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
> >  #define X86_FEATURE_AVX512VBMI		(16*32+ 1) /* AVX512 Vector Bit Manipulation instructions*/
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 74620d32aa82..451b82df2eab 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -311,7 +311,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> >  	svm->vmcb->save.efer = efer | EFER_SVME;
> >  	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
> >  	/* Enable GP interception for SVM instructions if needed */
> > -	if (efer & EFER_SVME)
> > +	if ((efer & EFER_SVME) && !boot_cpu_has(X86_FEATURE_SVME_ADDR_CHK))
> >  		set_exception_intercept(svm, GP_VECTOR);
> >  
> >  	return 0;
> > -- 
> > 2.27.0
> > 






--=-EVQygRQtbtdeLy3t4p4U
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


--=-EVQygRQtbtdeLy3t4p4U--


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD4D355098
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 12:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242469AbhDFKMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 06:12:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20151 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234019AbhDFKM3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 06:12:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617703942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5DZOHw5xnAUj4vS/h0xMRQ76Ng9d8UzoQePr3Ea26wo=;
        b=X2W6QzzlgXLwlRDzXzOTjumlQTqBYWPmGkkMl3Dm5xFU5VWSl5vPFl9gLXNoqLKZ5x660M
        /RgsY4f6ayK5WubJlPW4aWnJgImOV/MxFV3DBtQltkaN2euOKP2HmBeNXSZq67fAQevg9H
        QWctNXNz/CINPBylYRpifrMdGLRXz2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-x6gvMrAgOKel0WNrbk0Anw-1; Tue, 06 Apr 2021 06:12:20 -0400
X-MC-Unique: x6gvMrAgOKel0WNrbk0Anw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 750EF83DD3F;
        Tue,  6 Apr 2021 10:12:18 +0000 (UTC)
Received: from starship (unknown [10.35.206.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5840B59443;
        Tue,  6 Apr 2021 10:12:14 +0000 (UTC)
Message-ID: <8ffa121b8be00cd30c93830c476a448cee895abc.camel@redhat.com>
Subject: Re: [PATCH 5/6] KVM: nSVM: avoid loading PDPTRs after migration
 when possible
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Date:   Tue, 06 Apr 2021 13:12:13 +0300
In-Reply-To: <YGtCeiyzUrRbbNKG@google.com>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
         <20210401141814.1029036-6-mlevitsk@redhat.com>
         <YGtCeiyzUrRbbNKG@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-04-05 at 17:01 +0000, Sean Christopherson wrote:
> On Thu, Apr 01, 2021, Maxim Levitsky wrote:
> > if new KVM_*_SREGS2 ioctls are used, the PDPTRs are
> > part of the migration state and thus are loaded
> > by those ioctls.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index ac5e3e17bda4..b94916548cfa 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -373,10 +373,9 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
> >  		return -EINVAL;
> >  
> >  	if (!nested_npt && is_pae_paging(vcpu) &&
> > -	    (cr3 != kvm_read_cr3(vcpu) || pdptrs_changed(vcpu))) {
> > +	    (cr3 != kvm_read_cr3(vcpu) || !kvm_register_is_available(vcpu, VCPU_EXREG_PDPTR)))
> >  		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)))
> 
> What if we ditch the optimizations[*] altogether and just do:
> 
> 	if (!nested_npt && is_pae_paging(vcpu) &&
> 	    CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
> 		return -EINVAL;
> 
> Won't that obviate the need for KVM_{GET|SET}_SREGS2 since KVM will always load
> the PDPTRs from memory?  IMO, nested migration with shadowing paging doesn't
> warrant this level of optimization complexity.

Its not an optimization, it was done to be 100% within the X86 spec. 
PDPTRs are internal cpu registers which are loaded only when
CR3/CR0/CR4 are written by the guest, guest entry loads CR3, or 
when guest exit loads CR3 (I checked both Intel and AMD manuals).

In addition to that when NPT is enabled, AMD drops this siliness and 
just treats PDPTRs as normal paging entries, while on Intel side 
when EPT is enabled, PDPTRs are stored in VMCS.

Nested migration is neither of these cases, thus PDPTRs should be 
stored out of band.
Same for non nested migration.

This was requested by Jim Mattson, and I went ahead and 
implemented it, even though I do understand that no sane OS 
relies on PDPTRs to be unsync v.s the actual page
table containing them.

Best regards,
	Maxim Levitsky


> 
> [*] For some definitions of "optimization", since the extra pdptrs_changed()
>     check in the existing code is likely a net negative.
> 
> >  			return -EINVAL;
> > -	}
> >  
> >  	/*
> >  	 * TODO: optimize unconditional TLB flush/MMU sync here and in



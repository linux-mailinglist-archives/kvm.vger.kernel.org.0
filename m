Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC672EC722
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 00:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbhAFX50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 18:57:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbhAFX50 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Jan 2021 18:57:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609977360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cjDyoQgR4+M9JyvM9051ALlS1QRgqHD8UEz36SRbsyU=;
        b=GJK5F/67/EdZcm4LzMXzPasEnm/kqDZJPonwmw2V0hTbEZb9sBCUpXz3zof+GK2PNB3nQE
        IO0oPN3AwA9M/QC7ye5p4MbDRUocrL/SzkyiFI77S7CbQccaxyVHcmbY/0r9cyijO2vYWW
        BKM9R3idVMMrZxHyDyUQY9TmwUu7wBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-s9svPryjMkqmV43MsbksdQ-1; Wed, 06 Jan 2021 18:55:58 -0500
X-MC-Unique: s9svPryjMkqmV43MsbksdQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02E93801817;
        Wed,  6 Jan 2021 23:55:57 +0000 (UTC)
Received: from starship (unknown [10.35.206.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1152310016FA;
        Wed,  6 Jan 2021 23:55:49 +0000 (UTC)
Message-ID: <747878595173b72dfa95f73f4e73c6cabb199bd8.camel@redhat.com>
Subject: Re: [PATCH 5/6] KVM: nSVM: always leave the nested state first on
 KVM_SET_NESTED_STATE
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>
Date:   Thu, 07 Jan 2021 01:55:48 +0200
In-Reply-To: <X/X13wD58Oi/0XpX@google.com>
References: <20210106105001.449974-1-mlevitsk@redhat.com>
         <20210106105001.449974-6-mlevitsk@redhat.com> <X/X13wD58Oi/0XpX@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-01-06 at 09:39 -0800, Sean Christopherson wrote:
> On Wed, Jan 06, 2021, Maxim Levitsky wrote:
> > This should prevent bad things from happening if the user calls the
> > KVM_SET_NESTED_STATE twice.
> 
> This doesn't exactly inspire confidence, nor does it provide much help to
> readers that don't already know why KVM should "leave nested" before processing
> the rest of kvm_state.
> 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index c1a3d0e996add..3aa18016832d0 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1154,8 +1154,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> >  	if (is_smm(vcpu) && (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
> >  		return -EINVAL;
> >  
> > +	svm_leave_nested(svm);
> 
> nVMX sets a really bad example in that it does vmx_leave_nested(), and many
> other things, long before it has vetted the incoming state.  That's not the end
> of the word as the caller is likely going to exit if this ioctl() fails, but it
> would be nice to avoid such behavior with nSVM, especially since it appears to
> be trivially easy to do svm_leave_nested() iff the ioctl() will succeed.

I agree with you. So if I understand correctly I should move the unconditional 
svm_leave_nested(svm) after all the checks are done? I 

Best regards,
	Maxim Levitsky

> 
> > +
> >  	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
> > -		svm_leave_nested(svm);
> >  		svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
> >  		return 0;
> >  	}
> > -- 
> > 2.26.2
> > 



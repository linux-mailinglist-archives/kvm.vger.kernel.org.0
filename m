Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD22C2EC71C
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 00:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbhAFXzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 18:55:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726918AbhAFXzi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Jan 2021 18:55:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609977251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+xDcXzm9y5pEimgXpveqhDSEufujttVDu3XNu82fIqU=;
        b=hQsyo3DrqU4rbzihNQUPx75c3LPV/ttMwCiBYUvLrmYrGysJkdIgGQ8emYrwjUMGxfqiCC
        kRwQJ87IOtIOJ8AOw1qpwBelj8Indwf8Y9PpoXQcHMaqyMTcAcOBcCyqCjFkcKNnhYARwq
        nnkyJIhXoQQWX6b9sb74kVKv9R0NSpI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-pkYhRmgnPpG7XgXQqMc6Vg-1; Wed, 06 Jan 2021 18:54:08 -0500
X-MC-Unique: pkYhRmgnPpG7XgXQqMc6Vg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0288410054FF;
        Wed,  6 Jan 2021 23:54:06 +0000 (UTC)
Received: from starship (unknown [10.35.206.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25A625D9CD;
        Wed,  6 Jan 2021 23:54:01 +0000 (UTC)
Message-ID: <d4dd81b7bfd4c977ff4b4e1fa6da98e0f06c5fc0.camel@redhat.com>
Subject: Re: [PATCH 4/6] KVM: nSVM: correctly restore nested_run_pending on
 migration
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
Date:   Thu, 07 Jan 2021 01:54:00 +0200
In-Reply-To: <X/XzBUTPRhwVPCGx@google.com>
References: <20210106105001.449974-1-mlevitsk@redhat.com>
         <20210106105001.449974-5-mlevitsk@redhat.com> <X/XzBUTPRhwVPCGx@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-01-06 at 09:27 -0800, Sean Christopherson wrote:
> On Wed, Jan 06, 2021, Maxim Levitsky wrote:
> > The code to store it on the migration exists, but no code was restoring it.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 6208d3a5a3fdb..c1a3d0e996add 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1203,6 +1203,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> >  	 * in the registers, the save area of the nested state instead
> >  	 * contains saved L1 state.
> >  	 */
> > +
> > +	if (kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING)
> > +		svm->nested.nested_run_pending = true;
> 
> This should be:

Yes, if someone already set the nested state before, but
I also sent a patch that forces nesteded mode exit in this
case.

Still 100% agree, that this would be better.
Thanks for the review,

Best regards,
	Maxim Levitsky

> 
> 	svm->nested.nested_run_pending =
> 		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
> 
> > +
> >  	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
> >  	hsave->save = *save;
> >  
> > -- 
> > 2.26.2
> > 



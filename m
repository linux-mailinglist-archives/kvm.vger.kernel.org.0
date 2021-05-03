Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B5C371688
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 16:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhECOZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 10:25:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229616AbhECOZY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 10:25:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620051871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=98YMn44MI3AF28P/LGOwR7TI74pmmlNtJhmCw9kvmpc=;
        b=Au8K1PRhXkc7gjDAAvkEpLoblT5iC8sDFRuM9kb/BjnXZTelV4RRzN/5Fed4e53OsXPbG6
        7QmKZC3AgUHVkQhpzNmvSp3OZmYLMyPE3mbgxRTmnbaPYyj7YnLUVrIV/LFo75M29J7Ijk
        HasT5JSLgjbr0UklkvVRFoWSCPDmOBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-ymysQEVmPJaQCMMW76RL2g-1; Mon, 03 May 2021 10:24:27 -0400
X-MC-Unique: ymysQEVmPJaQCMMW76RL2g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95225107ACFC;
        Mon,  3 May 2021 14:24:25 +0000 (UTC)
Received: from starship (unknown [10.40.193.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B46661156;
        Mon,  3 May 2021 14:24:21 +0000 (UTC)
Message-ID: <21c774b2c1a4f5f90f615ac55b3eac22043854f2.camel@redhat.com>
Subject: Re: [PATCH 4/5] KVM: nSVM: force L1's GIF to 1 when setting the
 nested state
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Cathy Avery <cavery@redhat.com>
Date:   Mon, 03 May 2021 17:24:20 +0300
In-Reply-To: <7d2fe4a1-9603-8bea-e7f1-fb3c24198941@redhat.com>
References: <20210503125446.1353307-1-mlevitsk@redhat.com>
         <20210503125446.1353307-5-mlevitsk@redhat.com>
         <7d2fe4a1-9603-8bea-e7f1-fb3c24198941@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-03 at 16:00 +0200, Paolo Bonzini wrote:
> On 03/05/21 14:54, Maxim Levitsky wrote:
> > While after a reset the GIF value is already 1,
> > it doesn't have to have this value if the nested state
> > is loaded later.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >   arch/x86/kvm/svm/nested.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 32400cba608d..12a12ae940fa 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1314,6 +1314,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> >   	else
> >   		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
> >   
> > +	/* Force L1's GIF to true */
> > +	svm_set_gif(svm, true);
> > +
> >   	svm->nested.nested_run_pending =
> >   		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
> >   
> > 
> 
> Hmm, not sure about this one.  It is possible in principle to do CLGI in 
> L2 with the intercept disabled.

I need to think about this a bit more. 
In theory we have L0 GIF, the L1 GIF and the L2 GIF.
L0 GIF is always KVM's, so no problem.
L1 GIF can be toggled with L1 executing clgi/stgi, and it will be either stored in 
vmcb.int_ctl (vmcb01 or vmcb02) or in hflags depending if vGIF is enabled.
(the L1 owned bits are copied in nested_vmcb02_prepare_control)

For L2 we never advertise virtual gif and we don't let it set V_GIF_ENABLE_MASK
in int_ctl, so it either intercepts clgi/stgi and does its own businesses with it
or it doesn't intercept it in which case L2 indeed just modifies L1 GIF.


> 
> You need to use
> 
> svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));


Assuming that the above is correct, then indeed, this should be done,
so I'll send a patch for this.
Thanks a lot!!

Best regards,
	Maxim Levitsky



> 
> instead.
> 
> Paolo
> 



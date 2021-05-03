Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E85371698
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 16:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhECO14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 10:27:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229567AbhECO1z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 10:27:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620052021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6dspLzh/pMWW3XSTEBBhGvhFVlVkfRpL/2O1QA930Zk=;
        b=fZoGmgRKI58AmgtHwMoFQyibc2hdZzW+S4g3vAKwceS6eFgpy8rF+B4obDq6BHM6Vitls2
        YIQs2Efc5oytzqJwFfgrOWAuRdtwGIXI2UZ/vYa7bNGcbpMPUHDpASfp0ZGak0FuvCxZKP
        SGRtjukvR6FzSuPyrYAlFhFYNMUKr0I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-1Z7EDIFkPCaf2cszL0zlXg-1; Mon, 03 May 2021 10:26:57 -0400
X-MC-Unique: 1Z7EDIFkPCaf2cszL0zlXg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9F1C107ACE6;
        Mon,  3 May 2021 14:26:55 +0000 (UTC)
Received: from starship (unknown [10.40.193.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A82219D7C;
        Mon,  3 May 2021 14:26:51 +0000 (UTC)
Message-ID: <4f0bef0224a947a4ac3862175b4bce21eb0c0701.camel@redhat.com>
Subject: Re: [PATCH 5/5] KVM: nSVM: set a dummy exit reason in L1 vmcb when
 loading the nested state
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
Date:   Mon, 03 May 2021 17:26:50 +0300
In-Reply-To: <a3a08464-d67c-fe71-6b2a-01b9ee58312c@redhat.com>
References: <20210503125446.1353307-1-mlevitsk@redhat.com>
         <20210503125446.1353307-6-mlevitsk@redhat.com>
         <a3a08464-d67c-fe71-6b2a-01b9ee58312c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-03 at 16:02 +0200, Paolo Bonzini wrote:
> On 03/05/21 14:54, Maxim Levitsky wrote:
> > Since the nested migration is a result of a VMRUN, this makes it
> > possible to keep a warning that L1 vmcb should always have
> > VMRUN exit reason when switching back to it, which
> > otherwise triggers incorrectly.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Does this fix "KVM: nSVM: If VMRUN is single-stepped, queue the #DB 
> intercept in nested_svm_vmexit()"?  I don't like this, and also vmcb12 
> is not initialized here (nested_load_control_from_vmcb12 is using the 
> state passed in from userspace instead).

> 
> I think you should just remove the WARN instead.
All right, I'll do this!

Best regards,
	Maxim Levitsky


> 
> Paolo
> 
> > ---
> >   arch/x86/kvm/svm/nested.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 12a12ae940fa..146be4b5084b 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1338,6 +1338,12 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> >   	svm->vmcb01.ptr->save.rip = save->rip;
> >   	svm->vmcb01.ptr->save.cpl = 0;
> >   
> > +	/*
> > +	 * For consistency sake, restore the L1 exit reason
> > +	 * (that happened prior to the migration) to SVM_EXIT_VMRUN.
> > +	 */
> > +	svm->vmcb->control.exit_code = SVM_EXIT_VMRUN;
> > +
> >   	nested_load_control_from_vmcb12(svm, ctl);
> >   
> >   	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> > 



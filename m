Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5247927464E
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 18:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIVQOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 12:14:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23757 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726686AbgIVQOD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 12:14:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600791241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i+fhWxS4Uy1qIr1hOIXhMJfQNFY0bG4QU0yaQGULSxo=;
        b=idrm1a3Et8FEBd1uNMCxCblhLCzICwODof1v5qXNANsP2s3ZveVM0R1EtOgNKiA5D2j97k
        +veh+3glVTmOzE6yjCvwbJzB/wXZ2EvuvVNi/D/czDK/BcXvb9R6b541y1YELGqSwy5CmI
        iPO/RcYi8eKx8IWzyozhTW4/0r2v54A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-tUo3N-E1Nk-u8r_-0JjVoQ-1; Tue, 22 Sep 2020 12:13:56 -0400
X-MC-Unique: tUo3N-E1Nk-u8r_-0JjVoQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6367802B45;
        Tue, 22 Sep 2020 16:13:54 +0000 (UTC)
Received: from starship (unknown [10.35.206.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F22A78810;
        Tue, 22 Sep 2020 16:13:51 +0000 (UTC)
Message-ID: <83dc0dc731ba7348af05a5124da3435024185594.camel@redhat.com>
Subject: Re: [PATCH v5 2/4] KVM: x86: report negative values from wrmsr to
 userspace
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Tue, 22 Sep 2020 19:13:49 +0300
In-Reply-To: <20200921160812.GA23989@linux.intel.com>
References: <20200921131923.120833-1-mlevitsk@redhat.com>
         <20200921131923.120833-3-mlevitsk@redhat.com>
         <20200921160812.GA23989@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-09-21 at 09:08 -0700, Sean Christopherson wrote:
> On Mon, Sep 21, 2020 at 04:19:21PM +0300, Maxim Levitsky wrote:
> > This will allow us to make some MSR writes fatal to the guest
> > (e.g when out of memory condition occurs)
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/emulate.c | 7 +++++--
> >  arch/x86/kvm/x86.c     | 5 +++--
> >  2 files changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index 1d450d7710d63..d855304f5a509 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -3702,13 +3702,16 @@ static int em_dr_write(struct x86_emulate_ctxt *ctxt)
> >  static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
> >  {
> >  	u64 msr_data;
> > +	int ret;
> >  
> >  	msr_data = (u32)reg_read(ctxt, VCPU_REGS_RAX)
> >  		| ((u64)reg_read(ctxt, VCPU_REGS_RDX) << 32);
> > -	if (ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data))
> > +
> > +	ret = ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data);
> > +	if (ret > 0)
> >  		return emulate_gp(ctxt, 0);
> >  
> > -	return X86EMUL_CONTINUE;
> > +	return ret < 0 ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
> >  }
> >  
> >  static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 063d70e736f7f..b6c67ab7c4f34 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1612,15 +1612,16 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
> >  {
> >  	u32 ecx = kvm_rcx_read(vcpu);
> >  	u64 data = kvm_read_edx_eax(vcpu);
> > +	int ret = kvm_set_msr(vcpu, ecx, data);
> >  
> > -	if (kvm_set_msr(vcpu, ecx, data)) {
> > +	if (ret > 0) {
> >  		trace_kvm_msr_write_ex(ecx, data);
> >  		kvm_inject_gp(vcpu, 0);
> >  		return 1;
> >  	}
> >  
> >  	trace_kvm_msr_write(ecx, data);
> 
> Tracing the access as non-faulting feels wrong.  The WRMSR has not completed,
> e.g. if userspace cleanly handles -ENOMEM and restarts the guest, KVM would
> trace the WRMSR twice.

I guess you are right. Since in this case we didn't actually executed the
instruction (exception can also be thought as an execution of an instruction,
since it leads to the exception handler), but in
this case we just fail
and let the userspace do something so we can restart from the same point again.
 
So I'll go with your suggestion.

Thanks for the review,
	Best regards,
		Maxim Levitsky

> 
> What about:
> 
> 	int ret = kvm_set_msr(vcpu, ecx, data);
> 
> 	if (ret < 0)
> 		return ret;
> 
> 	if (ret) {
> 		trace_kvm_msr_write_ex(ecx, data);
> 		kvm_inject_gp(vcpu, 0);
> 		return 1;
> 	}
> 
> 	trace_kvm_msr_write(ecx, data);
> 	return kvm_skip_emulated_instruction(vcpu);
> 
> > -	return kvm_skip_emulated_instruction(vcpu);
> > +	return ret < 0 ? ret : kvm_skip_emulated_instruction(vcpu);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
> >  
> > -- 
> > 2.26.2
> > 



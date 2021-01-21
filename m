Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AF72FF12A
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 17:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbhAUQ4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 11:56:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41702 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728446AbhAUQ4t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 11:56:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611248116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kL6em8lUDn+x8F+MRbdRS53NsgVwSOH4SLh4BSpmdfg=;
        b=ZmJ+nZFLZyKLMrOeXfQgrxWzPGoag9khSX1rJBtW9r4UZFtey9bgblmEvE67kSKgPS6rQQ
        APQPunbRK64lwX4xfm19Vr6qFEC1o3Ui0RuRGMGd0FLAuMdkKYJvDWFQXQ+GxsPmTCunXr
        jO71rqOEWBq3fv8bU1t4sL8/qHgikYY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-yBS3MqV1OzCmjqyoZRLMrw-1; Thu, 21 Jan 2021 11:55:14 -0500
X-MC-Unique: yBS3MqV1OzCmjqyoZRLMrw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FBB1100C604;
        Thu, 21 Jan 2021 16:55:12 +0000 (UTC)
Received: from starship (unknown [10.35.206.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E9E4761E0;
        Thu, 21 Jan 2021 16:55:02 +0000 (UTC)
Message-ID: <cd4e3b9a5d5e4b47fa78bfb0ce447e856b18f8c8.camel@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: SVM: Add emulation support for #GP
 triggered by SVM instructions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Wei Huang <whuang2@amd.com>, Wei Huang <wei.huang2@amd.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
Date:   Thu, 21 Jan 2021 18:55:01 +0200
In-Reply-To: <c77f4f42-657a-6643-8432-a07ccf3b221e@amd.com>
References: <20210121065508.1169585-1-wei.huang2@amd.com>
         <20210121065508.1169585-3-wei.huang2@amd.com>
         <cc55536e913e79d7ca99cbeb853586ca5187c5a9.camel@redhat.com>
         <c77f4f42-657a-6643-8432-a07ccf3b221e@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-01-21 at 10:06 -0600, Wei Huang wrote:
> 
> On 1/21/21 8:07 AM, Maxim Levitsky wrote:
> > On Thu, 2021-01-21 at 01:55 -0500, Wei Huang wrote:
> > > From: Bandan Das <bsd@redhat.com>
> > > 
> > > While running SVM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
> > > CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
> > > before checking VMCB's instruction intercept. If EAX falls into such
> > > memory areas, #GP is triggered before VMEXIT. This causes problem under
> > > nested virtualization. To solve this problem, KVM needs to trap #GP and
> > > check the instructions triggering #GP. For VM execution instructions,
> > > KVM emulates these instructions.
> > > 
> > > Co-developed-by: Wei Huang <wei.huang2@amd.com>
> > > Signed-off-by: Wei Huang <wei.huang2@amd.com>
> > > Signed-off-by: Bandan Das <bsd@redhat.com>
> > > ---
> > >  arch/x86/kvm/svm/svm.c | 99 ++++++++++++++++++++++++++++++++++--------
> > >  1 file changed, 81 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 7ef171790d02..6ed523cab068 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -288,6 +288,9 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> > >  		if (!(efer & EFER_SVME)) {
> > >  			svm_leave_nested(svm);
> > >  			svm_set_gif(svm, true);
> > > +			/* #GP intercept is still needed in vmware_backdoor */
> > > +			if (!enable_vmware_backdoor)
> > > +				clr_exception_intercept(svm, GP_VECTOR);
> > Again I would prefer a flag for the errata workaround, but this is still
> > better.
> 
> Instead of using !enable_vmware_backdoor, will the following be better?
> Or the existing form is acceptable.
> 
> if (!kvm_cpu_cap_has(X86_FEATURE_SVME_ADDR_CHK))
> 	clr_exception_intercept(svm, GP_VECTOR);

To be honest I would prefer to have a module param named something like
'enable_svm_gp_errata_workaround' that would have 3 state value: (0,1,-1),
aka true,false,auto

0,1 - would mean force disable/enable the workaround.
-1 - auto select based on X86_FEATURE_SVME_ADDR_CHK.

0 could be used if for example someone is paranoid in regard to attack surface.
-#define USER_BASE      (1 << 24)
+#define USER_BASE      (1 << 25)
This isn't that much importaint to me though, so if you prefer you can leave it as is
as well.

> 
> > >  
> > >  			/*
> > >  			 * Free the nested guest state, unless we are in SMM.
> > > @@ -309,6 +312,9 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> > >  
> > >  	svm->vmcb->save.efer = efer | EFER_SVME;
> > >  	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
> > > +	/* Enable #GP interception for SVM instructions */
> > > +	set_exception_intercept(svm, GP_VECTOR);
> > > +
> > >  	return 0;
> > >  }
> > >  
> > > @@ -1957,24 +1963,6 @@ static int ac_interception(struct vcpu_svm *svm)
> > >  	return 1;
> > >  }
> > >  
> > > -static int gp_interception(struct vcpu_svm *svm)
> > > -{
> > > -	struct kvm_vcpu *vcpu = &svm->vcpu;
> > > -	u32 error_code = svm->vmcb->control.exit_info_1;
> > > -
> > > -	WARN_ON_ONCE(!enable_vmware_backdoor);
> > > -
> > > -	/*
> > > -	 * VMware backdoor emulation on #GP interception only handles IN{S},
> > > -	 * OUT{S}, and RDPMC, none of which generate a non-zero error code.
> > > -	 */
> > > -	if (error_code) {
> > > -		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
> > > -		return 1;
> > > -	}
> > > -	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
> > > -}
> > > -
> > >  static bool is_erratum_383(void)
> > >  {
> > >  	int err, i;
> > > @@ -2173,6 +2161,81 @@ static int vmrun_interception(struct vcpu_svm *svm)
> > >  	return nested_svm_vmrun(svm);
> > >  }
> > >  
> > > +enum {
> > > +	NOT_SVM_INSTR,
> > > +	SVM_INSTR_VMRUN,
> > > +	SVM_INSTR_VMLOAD,
> > > +	SVM_INSTR_VMSAVE,
> > > +};
> > > +
> > > +/* Return NOT_SVM_INSTR if not SVM instrs, otherwise return decode result */
> > > +static int svm_instr_opcode(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> > > +
> > > +	if (ctxt->b != 0x1 || ctxt->opcode_len != 2)
> > > +		return NOT_SVM_INSTR;
> > > +
> > > +	switch (ctxt->modrm) {
> > > +	case 0xd8: /* VMRUN */
> > > +		return SVM_INSTR_VMRUN;
> > > +	case 0xda: /* VMLOAD */
> > > +		return SVM_INSTR_VMLOAD;
> > > +	case 0xdb: /* VMSAVE */
> > > +		return SVM_INSTR_VMSAVE;
> > > +	default:
> > > +		break;
> > > +	}
> > > +
> > > +	return NOT_SVM_INSTR;
> > > +}
> > > +
> > > +static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
> > > +{
> > > +	int (*const svm_instr_handlers[])(struct vcpu_svm *svm) = {
> > > +		[SVM_INSTR_VMRUN] = vmrun_interception,
> > > +		[SVM_INSTR_VMLOAD] = vmload_interception,
> > > +		[SVM_INSTR_VMSAVE] = vmsave_interception,
> > > +	};
> > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > +
> > > +	return svm_instr_handlers[opcode](svm);
> > > +}
> > > +
> > > +/*
> > > + * #GP handling code. Note that #GP can be triggered under the following two
> > > + * cases:
> > > + *   1) SVM VM-related instructions (VMRUN/VMSAVE/VMLOAD) that trigger #GP on
> > > + *      some AMD CPUs when EAX of these instructions are in the reserved memory
> > > + *      regions (e.g. SMM memory on host).
> > > + *   2) VMware backdoor
> > > + */
> > > +static int gp_interception(struct vcpu_svm *svm)
> > > +{
> > > +	struct kvm_vcpu *vcpu = &svm->vcpu;
> > > +	u32 error_code = svm->vmcb->control.exit_info_1;
> > > +	int opcode;
> > > +
> > > +	/* Both #GP cases have zero error_code */
> > 
> > I would have kept the original description of possible #GP reasons
> > for the VMWARE backdoor and that WARN_ON_ONCE that was removed.
> > 
> 
> Will do
> 
> > > +	if (error_code)
> > > +		goto reinject;
> > > +
> > > +	/* Decode the instruction for usage later */
> > > +	if (x86_emulate_decoded_instruction(vcpu, 0, NULL, 0) != EMULATION_OK)
> > > +		goto reinject;
> > > +
> > > +	opcode = svm_instr_opcode(vcpu);
> > > +	if (opcode)
> > 
> > I prefer opcode != NOT_SVM_INSTR.
> > 
> > > +		return emulate_svm_instr(vcpu, opcode);
> > > +	else
> > 
> > 'WARN_ON_ONCE(!enable_vmware_backdoor)' I think can be placed here.
> > 
> > 
> > > +		return kvm_emulate_instruction(vcpu,
> > > +				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
> > 
> > I tested the vmware backdoor a bit (using the kvm unit tests) and I found out a tiny pre-existing bug
> > there:
> > 
> > We shouldn't emulate the vmware backdoor for a nested guest, but rather let it do it.
> > 
> > The below patch (on top of your patches) works for me and allows the vmware backdoor 
> > test to pass when kvm unit tests run in a guest.
> > 
> 
> This fix can be a separate patch? This problem exist even before this
> patchset.

It should indeed be a separate patch, but it won't hurt to add it
to this series IMHO if you have time for that.

I just pointed that out because I found this bug during testing,
to avoid forgetting about it.

BTW, on unrelated note, currently the smap test is broken in kvm-unit tests.
I bisected it to commit 322cdd6405250a2a3e48db199f97a45ef519e226

It seems that the following hack (I have no idea why it works,
since I haven't dug deep into the area 'fixes', the smap test for me)

-#define USER_BASE      (1 << 24)
+#define USER_BASE      (1 << 25)


Best regards,
	Maxim Levitsky

> 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index fe97b0e41824a..4557fdc9c3e1b 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2243,7 +2243,7 @@ static int gp_interception(struct vcpu_svm *svm)
> >  	opcode = svm_instr_opcode(vcpu);
> >  	if (opcode)
> >  		return emulate_svm_instr(vcpu, opcode);
> > -	else
> > +	else if (!is_guest_mode(vcpu))
> >  		return kvm_emulate_instruction(vcpu,
> >  				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
> >  
> > 
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > > +
> > > +reinject:
> > > +	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
> > > +	return 1;
> > > +}
> > > +
> > >  void svm_set_gif(struct vcpu_svm *svm, bool value)
> > >  {
> > >  	if (value) {
> > 
> > 
> > 
> > 





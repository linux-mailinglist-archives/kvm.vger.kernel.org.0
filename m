Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8B31DBBAA
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgETRjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:39:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26832 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbgETRjM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 13:39:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589996350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NInuWIKxvhv+pr0Of+enAgQVb1EI3zbw0YcjpeUMr/0=;
        b=ecQ7aNc7cYhwB+k60TS5IHUVJkUpeEAAzgjKJY/8++wp1E3hZBBRpSmz7SCmgQmkTWxj+p
        a6E+yMO4eAvC3HtFE4oxF6dl4GMoxFGA6GVCn3O8MeP9ohTxw0ALDFpkqjcj3z9HP2Lk3o
        ekvUwD0WVhPWZkwoucxrnooOwMSa8cs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-2RLpIsTEPVGJjQ_3ZAVsPA-1; Wed, 20 May 2020 13:39:08 -0400
X-MC-Unique: 2RLpIsTEPVGJjQ_3ZAVsPA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 713198005AA;
        Wed, 20 May 2020 17:39:07 +0000 (UTC)
Received: from starship (unknown [10.35.207.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 275F648D6B;
        Wed, 20 May 2020 17:39:05 +0000 (UTC)
Message-ID: <45f5ed0e1bb89ac186ef0d7f79f4ec4be0be6403.camel@redhat.com>
Subject: Re: [PATCH 2/2] kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL
 unconditionally
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 20 May 2020 20:39:04 +0300
In-Reply-To: <87sgfusf26.fsf@vitty.brq.redhat.com>
References: <20200520160740.6144-1-mlevitsk@redhat.com>
         <20200520160740.6144-3-mlevitsk@redhat.com>
         <874ksatvkr.fsf@vitty.brq.redhat.com>
         <0c1a0c81bbdcfaf4ae9af545f4a38439b1a56d11.camel@redhat.com>
         <87sgfusf26.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-05-20 at 19:15 +0200, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Wed, 2020-05-20 at 18:33 +0200, Vitaly Kuznetsov wrote:
> > > Maxim Levitsky <mlevitsk@redhat.com> writes:
> > > 
> > > > This msr is only available when the host supports WAITPKG feature.
> > > > 
> > > > This breaks a nested guest, if the L1 hypervisor is set to ignore
> > > > unknown msrs, because the only other safety check that the
> > > > kernel does is that it attempts to read the msr and
> > > > rejects it if it gets an exception.
> > > > 
> > > > Fixes: 6e3ba4abce KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
> > > > 
> > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > ---
> > > >  arch/x86/kvm/x86.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index fe3a24fd6b263..9c507b32b1b77 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -5314,6 +5314,10 @@ static void kvm_init_msr_list(void)
> > > >  			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
> > > >  			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
> > > >  				continue;
> > > > +			break;
> > > > +		case MSR_IA32_UMWAIT_CONTROL:
> > > > +			if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
> > > > +				continue;
> > > 
> > > I'm probably missing something but (if I understand correctly) the only
> > > effect of dropping MSR_IA32_UMWAIT_CONTROL from msrs_to_save would be
> > > that KVM userspace won't see it in e.g. KVM_GET_MSR_INDEX_LIST. But why
> > > is this causing an issue? I see both vmx_get_msr()/vmx_set_msr() have
> > > 'host_initiated' check:
> > > 
> > >        case MSR_IA32_UMWAIT_CONTROL:
> > >                 if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
> > >                         return 1;
> > 
> > Here it fails like that:
> > 
> > 1. KVM_GET_MSR_INDEX_LIST returns this msrs, and qemu notes that
> >    it is supported in 'has_msr_umwait' global var
> > 
> > 2. Qemu does kvm_arch_get/put_registers->kvm_get/put_msrs->ioctl(KVM_GET_MSRS)
> >    and while doing this it adds MSR_IA32_UMWAIT_CONTROL to that msr list.
> >    That reaches 'svm_get_msr', and this one knows nothing about MSR_IA32_UMWAIT_CONTROL.
> > 
> > So the difference here is that vmx_get_msr not called at all.
> > I can add this msr to svm_get_msr instead but that feels wrong since this feature
> > is not yet supported on AMD.
> > When AMD adds support for this feature, then the VMX specific code can be moved to
> > kvm_get_msr_common I guess.
> > 
> > 
> 
> Oh, SVM, I missed that completely) 
> 
> > > so KVM userspace should be able to read/write this MSR even when there's
> > > no hardware support for it. Or who's trying to read/write it?
> > > 
> > > Also, kvm_cpu_cap_has() check is not equal to vmx_has_waitpkg() which
> > > checks secondary execution controls.
> > 
> > I was afraid that something like that will happen, but in this particular
> > case we can only check CPUID support and if supported, the then it means
> > we are dealing with intel system and thus vmx_get_msr will be called and
> > ignore that msr.
> > 
> > Calling vmx_has_waitpkg from the common code doesn't seem right, and besides,
> > it checks the secondary controls which are set by the host and can change,
> > at least in theory during runtime (I don't know if KVM does this).
> > 
> > Note that if I now understand correctly, the 'host_initiated' means
> > that MSR read/write is done by the host itself and not on behalf of the guest.
> 
> Yes, it does that. 
> 
> We have kvm_x86_ops.has_emulated_msr() mechanism, can we use it here?
> E.g. completely untested
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 38f6aeefeb55..c19a9542e6c3 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3471,6 +3471,8 @@ static bool svm_has_emulated_msr(int index)
>         case MSR_IA32_MCG_EXT_CTL:
>         case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
>                 return false;
> +       case MSR_IA32_UMWAIT_CONTROL:
> +               return false;
>         default:
>                 break;
>         }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d786c7d27ce5..f45153ef3b81 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1183,7 +1183,6 @@ static const u32 msrs_to_save_all[] = {
>         MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
>         MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
>         MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
> -       MSR_IA32_UMWAIT_CONTROL,
>  
>         MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
>         MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
> @@ -1266,6 +1265,7 @@ static const u32 emulated_msrs_all[] = {
>         MSR_IA32_VMX_PROCBASED_CTLS2,
>         MSR_IA32_VMX_EPT_VPID_CAP,
>         MSR_IA32_VMX_VMFUNC,
> +       MSR_IA32_UMWAIT_CONTROL,
>  
>         MSR_K7_HWCR,
>         MSR_KVM_POLL_CONTROL,
> 
I don't see any reason why the above won't work, and to be honest
I also took a look at this but to me it wasn't clear what the purpose
of the emulated msrs is, this is why I took the approach in the patch I had sent.

It 'seems' (although this is not enforced anywhere) that emulated msr list is
intended for MSRs that are emulated by KVM, which means that KVM traps these msrs,
and give guest arbitrary values it thinks that the guest should see.

However MSR_IA32_UMWAIT_CONTROL appears to be exposed directly to the guest
without any traps, with the virtualization done by cpu, and the only intervention
we do is to set a value to be load when guest mode is entered and value to be
loaded when guest mode is done (using VMX msr entry/exit msr lists),
I see that done by atomic_switch_umwait_control_msr.

So I am not sure if we should add it to emulated_msrs_all list.

Paulo, what do you think about this? I personally don't mind how to fix
this as long as it works and everyone agrees on the patch.

Best regards,
	Maxim Levitsky





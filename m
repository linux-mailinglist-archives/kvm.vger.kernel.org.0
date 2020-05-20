Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58281DBA60
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 18:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgETQ4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 12:56:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44171 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726576AbgETQ4w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 12:56:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589993810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QaZb1dScaBd+ZKT5FJJNAu4zg30y7sIbqMztcEcLgo4=;
        b=NJmZATl7RI35wLZFIyNWR31qRXP80q1smB9lOVz9jH1hyM3X0FL6+TCm1293d8hOr/mIfz
        eOzn7sLxO4yVKdWZfvuL6qMxhZxVx/rERj3bd5x/YQwhVVpHz0k6Wg5+SHLFGFB4VxsNFh
        BK69v4uOh2S5yZYxty8p+cOZeyQ20pc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-NywVvRHRMOe8vsWxjz5dnA-1; Wed, 20 May 2020 12:56:48 -0400
X-MC-Unique: NywVvRHRMOe8vsWxjz5dnA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D603E81A3FF;
        Wed, 20 May 2020 16:56:47 +0000 (UTC)
Received: from starship (unknown [10.35.207.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3FFD5D994;
        Wed, 20 May 2020 16:56:44 +0000 (UTC)
Message-ID: <0c1a0c81bbdcfaf4ae9af545f4a38439b1a56d11.camel@redhat.com>
Subject: Re: [PATCH 2/2] kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL
 unconditionally
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Wed, 20 May 2020 19:56:43 +0300
In-Reply-To: <874ksatvkr.fsf@vitty.brq.redhat.com>
References: <20200520160740.6144-1-mlevitsk@redhat.com>
         <20200520160740.6144-3-mlevitsk@redhat.com>
         <874ksatvkr.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-05-20 at 18:33 +0200, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > This msr is only available when the host supports WAITPKG feature.
> > 
> > This breaks a nested guest, if the L1 hypervisor is set to ignore
> > unknown msrs, because the only other safety check that the
> > kernel does is that it attempts to read the msr and
> > rejects it if it gets an exception.
> > 
> > Fixes: 6e3ba4abce KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index fe3a24fd6b263..9c507b32b1b77 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5314,6 +5314,10 @@ static void kvm_init_msr_list(void)
> >  			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
> >  			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
> >  				continue;
> > +			break;
> > +		case MSR_IA32_UMWAIT_CONTROL:
> > +			if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
> > +				continue;
> 
> I'm probably missing something but (if I understand correctly) the only
> effect of dropping MSR_IA32_UMWAIT_CONTROL from msrs_to_save would be
> that KVM userspace won't see it in e.g. KVM_GET_MSR_INDEX_LIST. But why
> is this causing an issue? I see both vmx_get_msr()/vmx_set_msr() have
> 'host_initiated' check:
> 
>        case MSR_IA32_UMWAIT_CONTROL:
>                 if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
>                         return 1;

Here it fails like that:

1. KVM_GET_MSR_INDEX_LIST returns this msrs, and qemu notes that
   it is supported in 'has_msr_umwait' global var

2. Qemu does kvm_arch_get/put_registers->kvm_get/put_msrs->ioctl(KVM_GET_MSRS)
   and while doing this it adds MSR_IA32_UMWAIT_CONTROL to that msr list.
   That reaches 'svm_get_msr', and this one knows nothing about MSR_IA32_UMWAIT_CONTROL.

So the difference here is that vmx_get_msr not called at all.
I can add this msr to svm_get_msr instead but that feels wrong since this feature
is not yet supported on AMD.
When AMD adds support for this feature, then the VMX specific code can be moved to
kvm_get_msr_common I guess.



> 
> so KVM userspace should be able to read/write this MSR even when there's
> no hardware support for it. Or who's trying to read/write it?
> 
> Also, kvm_cpu_cap_has() check is not equal to vmx_has_waitpkg() which
> checks secondary execution controls.

I was afraid that something like that will happen, but in this particular
case we can only check CPUID support and if supported, the then it means
we are dealing with intel system and thus vmx_get_msr will be called and
ignore that msr.

Calling vmx_has_waitpkg from the common code doesn't seem right, and besides,
it checks the secondary controls which are set by the host and can change,
at least in theory during runtime (I don't know if KVM does this).

Note that if I now understand correctly, the 'host_initiated' means that MSR read/write
is done by the host itself and not on behalf of the guest.


Best regards,
	Maxim Levitsky

> 
> >  		default:
> >  			break;
> >  		}



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8242D37A6C0
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 14:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhEKMdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 08:33:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231355AbhEKMdo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 08:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620736357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CcWopp5S9fmkDJojoBrzYstW1LltVDnydiI8RYzIKJA=;
        b=SAUjSFkNzaI1q3bll5LxlpN+fBPw3Kg7682aXdeCxQr6n1Iuu4t6ALv4i7cCukdiFND97G
        thwR+tbrYT7/FfDLFKjprMZRFb7MgLFlwBxoCejcSx89bv6KBkb9rOT5ZYtdTrqPXWjmp9
        ozr388sX2itznUt6DbXtR8fMPYlwj98=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-PbakJF1bPSyuL4nYzEf6CQ-1; Tue, 11 May 2021 08:32:33 -0400
X-MC-Unique: PbakJF1bPSyuL4nYzEf6CQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2502107ACC7;
        Tue, 11 May 2021 12:32:31 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A05549CA0;
        Tue, 11 May 2021 12:32:27 +0000 (UTC)
Message-ID: <4f233c7120067c331a767e55ae8513c945e0f1ba.camel@redhat.com>
Subject: Re: [PATCH 02/15] KVM: x86: Emulate RDPID only if RDTSCP is
 supported
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Tue, 11 May 2021 15:32:26 +0300
In-Reply-To: <YJlrZJrVhUKCbnba@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-3-seanjc@google.com>
         <bc90b793ac351f9426710d354bf0c3621f36e763.camel@redhat.com>
         <YJlrZJrVhUKCbnba@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-10 at 17:20 +0000, Sean Christopherson wrote:
> On Mon, May 10, 2021, Maxim Levitsky wrote:
> > On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> > > Do not advertise emulation support for RDPID if RDTSCP is unsupported.
> > > RDPID emulation subtly relies on MSR_TSC_AUX to exist in hardware, as
> > > both vmx_get_msr() and svm_get_msr() will return an error if the MSR is
> > > unsupported, i.e. ctxt->ops->get_msr() will fail and the emulator will
> > > inject a #UD.
> > > 
> > > Note, RDPID emulation also relies on RDTSCP being enabled in the guest,
> > > but this is a KVM bug and will eventually be fixed.
> > > 
> > > Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/cpuid.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index f765bf7a529c..c96f79c9fff2 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -637,7 +637,8 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
> > >  	case 7:
> > >  		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> > >  		entry->eax = 0;
> > > -		entry->ecx = F(RDPID);
> > > +		if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
> > > +			entry->ecx = F(RDPID);
> > >  		++array->nent;
> > >  	default:
> > >  		break;
> > 
> > Just to make sure that I understand this correctly:
> > 
> > This is what I know:
> > 
> > Both RDTSCP and RDPID are instructions that read IA32_TSC_AUX
> > (and RDTSCP also reads the TSC).
> > 
> > Both instructions have their own CPUID bits (X86_FEATURE_RDPID, X86_FEATURE_RDTSCP)
> > If either of these CPUID bits are present, IA32_TSC_AUX should be supported.
> 
> Yep.
> 
> > RDPID is a newer feature, thus I can at least for the sanity sake assume that
> > usually a CPU will either have neither of the features, have only RDTSCP,
> > and IA32_AUX, or have both RDSCP and RDPID.
> 
> Yep.
> 
> > If not supported in hardware KVM only emulates RDPID as I see.
> 
> Yep.
> 
> > Why btw? Performance wise guest that only wants the IA32_AUX in userspace,
> > is better to use RDTSCP and pay the penalty of saving/restoring of the
> > unwanted registers, than use RDPID with a vmexit.
> 
> FWIW, Linux doesn't even fall back to RDTSCP.  If RDPID isn't supported, Linux
> throws the info into the limit of a dummy segment in the GDT and uses LSL to get
> at the data.  Turns out that RDTSCP is too slow for its intended use case :-)
> 
> > My own guess for an answer to this question is that RDPID emulation is there
> > to aid migration from a host that does support RDPID to a host that doesn't.
> 
> That's my assumption as well.  Paolo's commit is a bit light on why emulation
> was added in the first place, but emulating to allow migrating to old hardware
> is the only motivation I can come up with.

Cool thanks!
Best regards,
	Maxim Levitsky

> 
> commit fb6d4d340e0532032c808a9933eaaa7b8de435ab
> Author: Paolo Bonzini <pbonzini@redhat.com>
> Date:   Tue Jul 12 11:04:26 2016 +0200
> 
>     KVM: x86: emulate RDPID
> 
>     This is encoded as F3 0F C7 /7 with a register argument.  The register
>     argument is the second array in the group9 GroupDual, while F3 is the
>     fourth element of a Prefix.
> 
> > Having said all that, assuming that we don't want to emulate the RDTSCP too,
> > when it is not supported, then this patch does make sense.
> > 
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751701DC0F8
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 23:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgETVJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 17:09:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34792 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728117AbgETVJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 17:09:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590008995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rljt0JKhDnaA5kYo7V7yvh9gpRilhTrRqKa1LMsBGTA=;
        b=arYIx2dmhwTfLofrXAow1qYu8OEbFWxRJIIDcWca1PMrBU1jrN++hzlwQc4jboGvEr54vc
        NbPq6P1j5BOdHw2CX8mgeXRZ5bGLiOmKUJz3PExeFjVnnqzwwhgDQoUCseEVhe4LCpW3tu
        YwYo+5f8L0XABIEYyG4INwxes2NWF2E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-VzS7pN-BP9KFN01tPauI1A-1; Wed, 20 May 2020 17:09:53 -0400
X-MC-Unique: VzS7pN-BP9KFN01tPauI1A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F06B9107ACCA;
        Wed, 20 May 2020 21:09:52 +0000 (UTC)
Received: from starship (unknown [10.35.206.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3B1060C20;
        Wed, 20 May 2020 21:09:51 +0000 (UTC)
Message-ID: <8747006dabe787d5b4945f4dd9c2e2923335d87c.camel@redhat.com>
Subject: Re: [PATCH 2/2] kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL
 unconditionally
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Thu, 21 May 2020 00:09:50 +0300
In-Reply-To: <b8ca9ea1-2958-3ab4-2e86-2edbee1ca9d9@redhat.com>
References: <20200520160740.6144-1-mlevitsk@redhat.com>
         <20200520160740.6144-3-mlevitsk@redhat.com>
         <b8ca9ea1-2958-3ab4-2e86-2edbee1ca9d9@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-05-20 at 23:05 +0200, Paolo Bonzini wrote:
> On 20/05/20 18:07, Maxim Levitsky wrote:
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
> >  		default:
> >  			break;
> >  		}
> 
> The patch is correct, and matches what is done for the other entries of
> msrs_to_save_all.  However, while looking at it I noticed that
> X86_FEATURE_WAITPKG is actually never added, and that is because it was
> also not added to the supported CPUID in commit e69e72faa3a0 ("KVM: x86:
> Add support for user wait instructions", 2019-09-24), which was before
> the kvm_cpu_cap mechanism was added.
> 
> So while at it you should also fix that.  The right way to do that is to
> add a
> 
>         if (vmx_waitpkg_supported())
>                 kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
> 
> in vmx_set_cpu_caps.
> 
> Thanks,

Thank you very much for finding this. I didn't expect this to be broken.
I will send a new version with this fix as well tomorrow.

Best regards,
	Maxim Levitsky


> 
> Paolo
> 



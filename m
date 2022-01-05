Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6DF8485179
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 11:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239536AbiAEKyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 05:54:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56436 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235027AbiAEKyh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 05:54:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641380076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CCm5DtPQVf0xyWNYGicow5IQtvnuRR38jpxIbuWuROY=;
        b=C98iME7TFkFtRdeTfPPllncs02c2oHDMIdqbE5zSGNjb+b1LILshZdOkDE41e+WsPieyTb
        UnhVMEImyimlrQn26IGG2my7es9OE6+DHSwO1hzO5nNw86mgPjLEZWkjoNbBZBkVF/hK8P
        /4XQpmWlg9d8kFBwDdoANfnL38GH4Lg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-z8UtHD6IMeqzexi25U1ZyQ-1; Wed, 05 Jan 2022 05:54:31 -0500
X-MC-Unique: z8UtHD6IMeqzexi25U1ZyQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8FAA801AAB;
        Wed,  5 Jan 2022 10:54:27 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84B0372434;
        Wed,  5 Jan 2022 10:54:20 +0000 (UTC)
Message-ID: <dd7caa75ae9aef07d51043c01f073c6c23a3a445.camel@redhat.com>
Subject: Re: [PATCH v2 2/5] KVM: SVM: allow to force AVIC to be enabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Date:   Wed, 05 Jan 2022 12:54:19 +0200
In-Reply-To: <YdTJPTSsM1feVwt/@google.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
         <20211213104634.199141-3-mlevitsk@redhat.com> <YdTJPTSsM1feVwt/@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-01-04 at 22:25 +0000, Sean Christopherson wrote:
> On Mon, Dec 13, 2021, Maxim Levitsky wrote:
> > Apparently on some systems AVIC is disabled in CPUID but still usable.
> > 
> > Allow the user to override the CPUID if the user is willing to
> > take the risk.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index c9668a3b51011..468cc385c35f0 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -206,6 +206,9 @@ module_param(tsc_scaling, int, 0444);
> >  static bool avic;
> >  module_param(avic, bool, 0444);
> >  
> > +static bool force_avic;
> > +module_param_unsafe(force_avic, bool, 0444);
> > +
> >  bool __read_mostly dump_invalid_vmcb;
> >  module_param(dump_invalid_vmcb, bool, 0644);
> >  
> > @@ -4656,10 +4659,14 @@ static __init int svm_hardware_setup(void)
> >  			nrips = false;
> >  	}
> >  
> > -	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
> > +	enable_apicv = avic = avic && npt_enabled && (boot_cpu_has(X86_FEATURE_AVIC) || force_avic);
> >  
> >  	if (enable_apicv) {
> > -		pr_info("AVIC enabled\n");
> > +		if (!boot_cpu_has(X86_FEATURE_AVIC)) {
> > +			pr_warn("AVIC is not supported in CPUID but force enabled");
> > +			pr_warn("Your system might crash and burn");
> > +		} else
> 
> Needs curly braces, though arguably the "AVIC enabled" part should be printed
> regardless of boot_cpu_has(X86_FEATURE_AVIC).
> 
> > +			pr_info("AVIC enabled\n");
> 
> This is all more than a bit terrifying, though I can see the usefuless for a
> developer.  At the very least, this should taint the kernel.  This should also
> probably be buried behind a Kconfig that is itself buried behind EXPERT.
> 
I used 'module_param_unsafe' which does taint the kernel.

Best regards,
	Maxim Levitsky


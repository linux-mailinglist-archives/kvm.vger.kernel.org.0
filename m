Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2953F150403
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 11:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgBCKP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 05:15:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40270 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgBCKP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 05:15:56 -0500
Received: from 189-68-179-241.dsl.telesp.net.br ([189.68.179.241] helo=calabresa)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1iyYlF-0006lq-8V; Mon, 03 Feb 2020 10:15:21 +0000
Date:   Mon, 3 Feb 2020 07:15:14 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: do not setup pv tlb flush when not
 paravirtualized
Message-ID: <20200203101514.GG40679@calabresa>
References: <20200131155655.49812-1-cascardo@canonical.com>
 <87wo94ng9d.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo94ng9d.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 03, 2020 at 10:59:10AM +0100, Vitaly Kuznetsov wrote:
> Thadeu Lima de Souza Cascardo <cascardo@canonical.com> writes:
> 
> > kvm_setup_pv_tlb_flush will waste memory and print a misguiding message
> > when KVM paravirtualization is not available.
> >
> > Intel SDM says that the when cpuid is used with EAX higher than the
> > maximum supported value for basic of extended function, the data for the
> > highest supported basic function will be returned.
> >
> > So, in some systems, kvm_arch_para_features will return bogus data,
> > causing kvm_setup_pv_tlb_flush to detect support for pv tlb flush.
> >
> > Testing for kvm_para_available will work as it checks for the hypervisor
> > signature.
> >
> > Besides, when the "nopv" command line parameter is used, it should not
> > continue as well, as kvm_guest_init will no be called in that case.
> >
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > ---
> >  arch/x86/kernel/kvm.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 81045aabb6f4..d817f255aed8 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -736,6 +736,9 @@ static __init int kvm_setup_pv_tlb_flush(void)
> >  {
> >  	int cpu;
> >  
> > +	if (!kvm_para_available() || nopv)
> > +		return 0;
> > +
> >  	if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
> >  	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> >  	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> 
> The patch will fix the immediate issue, but why kvm_setup_pv_tlb_flush()
> is just an arch_initcall() which will be executed regardless of the fact
> if we are running on KVM or not?
> 
> In Hyper-V we setup PV TLB flush from ms_hyperv_init_platform() -- which
> only happens if Hyper-V platform was detected. Why don't we do it from
> kvm_init_platform() in KVM?
> 
> -- 
> Vitaly
> 

Because we can't call the allocator that early.

Also, see the thread where this was "decided", the v6 of the original patch:

https://lore.kernel.org/kvm/20171129162118.GA10661@flask/

Regards.
Cascardo.

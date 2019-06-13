Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF80544B7F
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 21:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfFMTB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 15:01:28 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:36126 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfFMTB2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 15:01:28 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hbUy1-0000Pv-7Q; Thu, 13 Jun 2019 21:00:57 +0200
Date:   Thu, 13 Jun 2019 21:00:56 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
cc:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org,
        Prasanna Panchamukhi <panchamukhi@arista.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Cathy Avery <cavery@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>,
        Mohammed Gamal <mmorsy@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Sasha Levin <sashal@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        devel@linuxdriverproject.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/hyperv: Disable preemption while setting reenlightenment
 vector
In-Reply-To: <8736kff6q3.fsf@vitty.brq.redhat.com>
Message-ID: <alpine.DEB.2.21.1906132059020.1791@nanos.tec.linutronix.de>
References: <20190611212003.26382-1-dima@arista.com> <8736kff6q3.fsf@vitty.brq.redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jun 2019, Vitaly Kuznetsov wrote:
> Dmitry Safonov <dima@arista.com> writes:
> > diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> > index 1608050e9df9..0bdd79ecbff8 100644
> > --- a/arch/x86/hyperv/hv_init.c
> > +++ b/arch/x86/hyperv/hv_init.c
> > @@ -91,7 +91,7 @@ EXPORT_SYMBOL_GPL(hv_max_vp_index);
> >  static int hv_cpu_init(unsigned int cpu)
> >  {
> >  	u64 msr_vp_index;
> > -	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[smp_processor_id()];
> > +	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[cpu];
> >  	void **input_arg;
> >  	struct page *pg;
> >  
> > @@ -103,7 +103,7 @@ static int hv_cpu_init(unsigned int cpu)
> >  
> >  	hv_get_vp_index(msr_vp_index);
> >  
> > -	hv_vp_index[smp_processor_id()] = msr_vp_index;
> > +	hv_vp_index[cpu] = msr_vp_index;
> >  
> >  	if (msr_vp_index > hv_max_vp_index)
> >  		hv_max_vp_index = msr_vp_index;
> 
> The above is unrelated cleanup (as cpu == smp_processor_id() for
> CPUHP_AP_ONLINE_DYN callbacks), right? As I'm pretty sure these can'd be
> preempted.

They can be preempted, but they are guaranteed to run on the upcoming CPU,
i.e. smp_processor_id() is allowed even in preemptible context as the task
cannot migrate.

Thanks,

	tglx

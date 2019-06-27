Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E49758E11
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 00:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfF0Wjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 18:39:54 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60004 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfF0Wjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 18:39:54 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgd3D-0001yR-93; Fri, 28 Jun 2019 00:39:31 +0200
Date:   Fri, 28 Jun 2019 00:39:30 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Dmitry Safonov <dima@arista.com>
cc:     linux-kernel@vger.kernel.org,
        Dmitry Safonov <0x7f454c46@gmail.com>,
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
        Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Sasha Levin <sashal@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        devel@linuxdriverproject.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCHv2] x86/hyperv: Hold cpus_read_lock() on assigning
 reenlightenment vector
In-Reply-To: <20190617163955.25659-1-dima@arista.com>
Message-ID: <alpine.DEB.2.21.1906280033510.32342@nanos.tec.linutronix.de>
References: <20190617163955.25659-1-dima@arista.com>
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

On Mon, 17 Jun 2019, Dmitry Safonov wrote:
> @@ -196,7 +196,16 @@ void set_hv_tscchange_cb(void (*cb)(void))
>  	/* Make sure callback is registered before we write to MSRs */
>  	wmb();
>  
> +	/*
> +	 * As reenlightenment vector is global, there is no difference which
> +	 * CPU will register MSR, though it should be an online CPU.
> +	 * hv_cpu_die() callback guarantees that on CPU teardown
> +	 * another CPU will re-register MSR back.
> +	 */
> +	cpus_read_lock();
> +	re_ctrl.target_vp = hv_vp_index[raw_smp_processor_id()];
>  	wrmsrl(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));
> +	cpus_read_unlock();

Should work

>  	wrmsrl(HV_X64_MSR_TSC_EMULATION_CONTROL, *((u64 *)&emu_ctrl));
>  }
>  EXPORT_SYMBOL_GPL(set_hv_tscchange_cb);
> @@ -239,6 +248,7 @@ static int hv_cpu_die(unsigned int cpu)
>  
>  	rdmsrl(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));
>  	if (re_ctrl.target_vp == hv_vp_index[cpu]) {
> +		lockdep_assert_cpus_held();

So you're not trusting the hotplug core code to hold the lock when it
brings a CPU down and invokes that callback? Come on

>  		/* Reassign to some other online CPU */
>  		new_cpu = cpumask_any_but(cpu_online_mask, cpu);

Thanks,

	tglx

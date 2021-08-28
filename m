Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148383FA767
	for <lists+kvm@lfdr.de>; Sat, 28 Aug 2021 21:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhH1TqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Aug 2021 15:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhH1TqT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Aug 2021 15:46:19 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389A5C061756;
        Sat, 28 Aug 2021 12:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XaDJo/Xp/thzakG+AyFw4gfOeYqXSd+OvToP2IAZADw=; b=iaSYaDXqR2I0RfntlzqVugj0Nj
        rXYt5kYTwyGKSPywFnw4fyUzTY9LAxxbRjtQkmlvftPwsUj5uPz2F5YspCjIPUg0EU+uNCyGQ3m1z
        lWBYQwuSheYbXudKlCIc8TNjxaN9C6VQgIvcLqNM4nad3zEOcmW0XTeahuIU8N5XEWm3P7Ut9+abN
        Q8fQ7zTfRTZ3R7RoF/QygqFwsUOnFQLkR+lOFf7wq4T+6b6moR3EFv7YMAVF9pd5Ox3uQjzGFISAV
        ivzAchA/SXjNJ8WNIC5WtqGO0JdesSU+G3xE61VeRun7z2ArlsfJGMdbJCaLwzEcpgePCOVpe7U2B
        vRqaWBQQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mK4Fb-00Dvei-M3; Sat, 28 Aug 2021 19:44:23 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id A026C98679D; Sat, 28 Aug 2021 21:44:21 +0200 (CEST)
Date:   Sat, 28 Aug 2021 21:44:21 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: Re: [PATCH v2 01/13] perf: Ensure perf_guest_cbs aren't reloaded
 between !NULL check and deref
Message-ID: <20210828194421.GB4353@worktop.programming.kicks-ass.net>
References: <20210828003558.713983-1-seanjc@google.com>
 <20210828003558.713983-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210828003558.713983-2-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 05:35:46PM -0700, Sean Christopherson wrote:

> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 2d510ad750ed..6b0405e578c1 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1237,6 +1237,14 @@ extern void perf_event_bpf_event(struct bpf_prog *prog,
>  				 u16 flags);
>  
>  extern struct perf_guest_info_callbacks *perf_guest_cbs;
> +static inline struct perf_guest_info_callbacks *perf_get_guest_cbs(void)
> +{
> +	/* Reg/unreg perf_guest_cbs waits for readers via synchronize_rcu(). */
> +	lockdep_assert_preemption_disabled();
> +
> +	/* Prevent reloading between a !NULL check and dereferences. */
> +	return READ_ONCE(perf_guest_cbs);
> +}

Nice..

>  extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
>  extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
>  
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 464917096e73..2126f6327321 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6491,14 +6491,19 @@ struct perf_guest_info_callbacks *perf_guest_cbs;
>  
>  int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
>  {
> -	perf_guest_cbs = cbs;
> +	if (WARN_ON_ONCE(perf_guest_cbs))
> +		return -EBUSY;
> +
> +	WRITE_ONCE(perf_guest_cbs, cbs);
> +	synchronize_rcu();

You're waiting for all NULL users to go away? :-) IOW, we can do without
this synchronize_rcu() call.

>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
>  
>  int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
>  {
> -	perf_guest_cbs = NULL;

	if (WARN_ON_ONCE(perf_guest_cbs != cbs))
		return -EBUSY;

?

> +	WRITE_ONCE(perf_guest_cbs, NULL);
> +	synchronize_rcu();
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);

Yes, this ought to work fine.

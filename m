Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA1D7DE37
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 16:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbfHAOs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 10:48:26 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46366 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfHAOsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 10:48:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FVxP2v3HSjN6nIrTmQY1MmXZ4a26DwBVy18A1yxDdt8=; b=P0Rj7mqbyuYvFdd0q6pQeHYl0
        q747aTpMZ22E6YzbbPJ1dmW36LDqN0j9PraHO7LjbYSTsA2KNDYf96eCftrUt0mlj+io53lKQaBk1
        kSElFmfkZeVkryaw+R9OgRCBiglpNmIe1kFBb4y+iu/irJaeUsQuieiGW5T+iPsoBhTodA0elX1+j
        Xu6KvKonSX05mIgmCSmRbP2cD2XvC2zgn1KTXUMnbUnIZrvUI52vsYuaQe6w98qcqTl1AeHU2pXPE
        hT0pCVt/kQJgmYTbObMwYStlAFf3+sTh+pS2DYtQJMRfhvoElh6TtVTp/OQYhu6Mf3Tn/TQc+3jSg
        Auk7R0f0w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1htCNM-0003HG-GM; Thu, 01 Aug 2019 14:48:16 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CDBFB2029F4C9; Thu,  1 Aug 2019 16:48:14 +0200 (CEST)
Date:   Thu, 1 Aug 2019 16:48:14 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [patch 1/5] tracehook: Provide TIF_NOTIFY_RESUME handling for KVM
Message-ID: <20190801144814.GC31398@hirez.programming.kicks-ass.net>
References: <20190801143250.370326052@linutronix.de>
 <20190801143657.785902257@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801143657.785902257@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 01, 2019 at 04:32:51PM +0200, Thomas Gleixner wrote:
> +#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
> +/**
> + * tracehook_handle_notify_resume - Notify resume handling for virt
> + *
> + * Called with interrupts and preemption enabled from VMENTER/EXIT.
> + */
> +void tracehook_handle_notify_resume(void)
> +{
> +	local_irq_disable();
> +	while (test_and_clear_thread_flag(TIF_NOTIFY_RESUME)) {
> +		local_irq_enable();
> +		tracehook_notify_resume(NULL);
> +		local_irq_disable();
> +	}
> +	local_irq_enable();

I'm confused by the IRQ state swizzling here, what is it doing?

> +}
> +EXPORT_SYMBOL_GPL(tracehook_handle_notify_resume);
> +#endif
> 
> 

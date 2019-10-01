Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB855C2EC2
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 10:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfJAIW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 04:22:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44998 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfJAIW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 04:22:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8nRscgxPVr7Aw7OjiSCDHF3qOKmeVYA2WPuMroRvj+A=; b=PGX16Tb1iIBI20tXU25hwOqCR
        FHZMvtRwbYSpFmZxGuePXEEstPH0A/x7Ilpr7f37QQCEwhtQ26m9s/CJGrRdM9TkPDvL69H/GDG4l
        1m41KfDH+U38RM6A1p/cbkfpWPMxO1cARfEp5mmBGMV0bnlmKxia/ENuIZ0LnE+ScgugfVEK7xnfJ
        z/meiaKQkEgIi98kEdHZqjXPSa3yB5M0aUuxJlx5NK8+yrueOdfqZhfGvzs+mtm/E7yEX5xheWTq2
        eITSE9P2ir+qZYRHOES9LSyHXLodix1LyjPDBAnne1wfHrBR5BrtcI105EmUr6KFzKvuVyafyU0QG
        i+sRIn1+g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iFDQL-0004ge-Lz; Tue, 01 Oct 2019 08:22:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8D8A230477A;
        Tue,  1 Oct 2019 10:21:30 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CD72223E90CDA; Tue,  1 Oct 2019 10:22:18 +0200 (CEST)
Date:   Tue, 1 Oct 2019 10:22:18 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: x86/vPMU: Reuse perf_event to avoid unnecessary
 pmc_reprogram_counter
Message-ID: <20191001082218.GK4519@hirez.programming.kicks-ass.net>
References: <20190930072257.43352-1-like.xu@linux.intel.com>
 <20190930072257.43352-3-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930072257.43352-3-like.xu@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 03:22:56PM +0800, Like Xu wrote:
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 46875bbd0419..74bc5c42b8b5 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -140,6 +140,35 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  	clear_bit(pmc->idx, (unsigned long*)&pmc_to_pmu(pmc)->reprogram_pmi);
>  }
>  
> +static void pmc_pause_counter(struct kvm_pmc *pmc)
> +{
> +	if (!pmc->perf_event)
> +		return;
> +
> +	pmc->counter = pmc_read_counter(pmc);
> +
> +	perf_event_disable(pmc->perf_event);
> +
> +	/* reset count to avoid redundant accumulation */
> +	local64_set(&pmc->perf_event->count, 0);

Yuck, don't frob in data structures you don't own.

Just like you exported the IOC_PERIOD thing, so too is there a
IOC_RESET.

Furthermore; wth do you call pmc_read_counter() _before_ doing
perf_event_disable() ? Doing it the other way around is much cheaper,
even better, you can use perf_event_count() after disable.

> +}
> +
> +static bool pmc_resume_counter(struct kvm_pmc *pmc)
> +{
> +	if (!pmc->perf_event)
> +		return false;
> +
> +	/* recalibrate sample period and check if it's accepted by perf core */
> +	if (perf_event_period(pmc->perf_event,
> +			(-pmc->counter) & pmc_bitmask(pmc)))
> +		return false;

I'd do the reset here, but then you have 3 function in a row that do
perf_event_ctx_lock()+perf_event_ctx_unlock(), which is rather
expensive.

> +
> +	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
> +	perf_event_enable(pmc->perf_event);
> +	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
> +	return true;
> +}

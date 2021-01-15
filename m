Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543032F7E8E
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 15:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730446AbhAOOsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 09:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730439AbhAOOsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 09:48:09 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A205C061793;
        Fri, 15 Jan 2021 06:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nJTc/pAdfA38jUmc+xoUyUrdzRZSuGL4fw7w4qEDkgo=; b=JwAZ9NHR5n4Bsz2eU3EhYVhsdJ
        KSYfAK+6+e4uNW42H5ZjjkLVXZgswQn3vjNORESYccY5F49xqQKs5H+Xw8CW3Q5OqlkMwk13cBhZ8
        rH/ptiHkeXnP0R8gUKlnTpByCacjh5sg9Y5FpvCu9hpQweSpOnn2OPOdVfe+i6QtC8EhfUtOx3h8r
        9P/GOwjYO1xze3D1/kpQYO1pSxRzYjO6SG/ymVo4WaW0fEBoPisLJVAWCOBzfAjGKRgZMOcX68Wll
        jlKh5+nZLfC515ogtRE5JmZSgPlWR7vp5KTMbq5szhvBclKLPdMAfn1jsfTiG9CycNmIoUA2Nv22C
        4pQrgoYQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l0QMX-0093Hd-E5; Fri, 15 Jan 2021 14:46:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AB3F7301324;
        Fri, 15 Jan 2021 15:46:04 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9CA3A20D6F7BA; Fri, 15 Jan 2021 15:46:04 +0100 (CET)
Date:   Fri, 15 Jan 2021 15:46:04 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/17] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR
 emulation for extended PEBS
Message-ID: <YAGqrIqTxNU/PMxo@hirez.programming.kicks-ass.net>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-7-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104131542.495413-7-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 04, 2021 at 09:15:31PM +0800, Like Xu wrote:

> +	if (cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask) {
> +		arr[1].msr = MSR_IA32_PEBS_ENABLE;
> +		arr[1].host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask;
> +		arr[1].guest = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
> +		/*
> +		 * The guest PEBS will be disabled once the host PEBS is enabled
> +		 * since the both enabled case may brings a unknown PMI to
> +		 * confuse host and the guest PEBS overflow PMI would be missed.
> +		 */
> +		if (arr[1].host)
> +			arr[1].guest = 0;
> +		arr[0].guest |= arr[1].guest;
> +		*nr = 2;

Elsewhere you write:

> When we have a PEBS PMI due to guest workload and vm-exits,
> the code path from vm-exit to the host PEBS PMI handler may also
> bring PEBS PMI and mark the status bit. The current PMI handler
> can't distinguish them and would treat the later one as a suspicious
> PMI and output a warning.

So the reason isn't that spurious PMIs are tedious, but that the
hardware is actually doing something weird.

Or am I not reading things straight?

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9485B357030
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 17:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353514AbhDGP0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 11:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243029AbhDGP0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 11:26:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114A2C061756;
        Wed,  7 Apr 2021 08:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jY0P2UufmdE70kZeDZbxVkRO7U3IMhijRe4MI2XThGo=; b=VaxFPZtMMZoPMFhKnxruK4TAIr
        Blzrz/XgpiuDBZ+WWc8+cpoWKhwPvAqnZL+zTgyYTPaIPkewMoQL7f5YoMEOEkRZELVXtWH1f4l04
        bJ6Z22Uk+Uq+MBke9EjkMEwP+rBoH5MP6C4B6hDbMtatH9nwPRVYfS9RKQnhZWi6YZm3fXmEYn2ry
        0ioRhmAjAKdxJNnzpcY697rSELXkaeUzn9MUNRIsBCUU/iwv3sPRMMXyTjCRlFr9ILPQwrP++T0Zr
        d6jvQKhgHrSiuUDJENprfbLuIo7Sco1xNphUesmL6fOeEEimdWv3+2DiO6dJnc+rOXg/3bRCxkfAE
        j/SLCgmw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lUA3g-005Gnz-7H; Wed, 07 Apr 2021 15:25:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E313A300219;
        Wed,  7 Apr 2021 17:25:30 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D2DBF2BF82B41; Wed,  7 Apr 2021 17:25:30 +0200 (CEST)
Date:   Wed, 7 Apr 2021 17:25:30 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>
Subject: Re: [PATCH v4 07/16] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR
 emulation for extended PEBS
Message-ID: <YG3O6rpx2bSt5D+O@hirez.programming.kicks-ass.net>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
 <20210329054137.120994-8-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329054137.120994-8-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Mon, Mar 29, 2021 at 01:41:28PM +0800, Like Xu wrote:
> +	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
> +		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
> +			pmu->pebs_enable_mask = ~pmu->global_ctrl;
> +			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
> +			for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
> +				pmu->fixed_ctr_ctrl_mask &=
> +					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));

{ }

> +		} else
> +			pmu->pebs_enable_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);

{ }

> +	} else {
> +		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;

as you already do here..

> +	}
>  }

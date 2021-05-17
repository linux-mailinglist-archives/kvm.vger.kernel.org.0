Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF0C3826B7
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 10:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhEQIUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 04:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235623AbhEQIT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 04:19:58 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9E0C06174A;
        Mon, 17 May 2021 01:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ebgCnld2n4PAoHyPpWIkEqhlb5U8FfLblu7QnX1Ihas=; b=F77xpAPRdcBWfTtIJB6ARA1+xM
        lYpavD2ob8Wi7ucTR1D5zGOJAnG3s4lECdILvNMqZC91JNMX9QeTixNMVyLPr+qqpYYZlLzKz5wi7
        9IblGeAZ4oaJEj7EbHD3bHA7F3+n78JnKM1UPVHDtUvoO0BxOLqAetRXehZfRe56LqcudQymyazXj
        TuZUJlqhjJgoIrANzyLSAnZfnkQblVBxIIHLELFTZ5saGB+RLjAnr44r1uE7ejoSnOGcrjwz0o8yV
        Rd5vZNkOjfXQKsnFfo9TeNGK0an+e3Uf1PzkFcjX6WLwgYFJepSyGdj2Z5ufkSWFU7G1fvVz6FNYq
        UnD1iHEg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1liYS2-00ECLN-Qs; Mon, 17 May 2021 08:18:11 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2116A30022C;
        Mon, 17 May 2021 10:18:10 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0AA292D1FEA3D; Mon, 17 May 2021 10:18:10 +0200 (CEST)
Date:   Mon, 17 May 2021 10:18:09 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Luwei Kang <luwei.kang@intel.com>
Subject: Re: [PATCH v6 05/16] KVM: x86/pmu: Introduce the ctrl_mask value for
 fixed counter
Message-ID: <YKImwdg7LO/OPvVJ@hirez.programming.kicks-ass.net>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-6-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511024214.280733-6-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 10:42:03AM +0800, Like Xu wrote:
> The mask value of fixed counter control register should be dynamic
> adjusted with the number of fixed counters. This patch introduces a
> variable that includes the reserved bits of fixed counter control
> registers. This is needed for later Ice Lake fixed counter changes.
> 
> Co-developed-by: Luwei Kang <luwei.kang@intel.com>
> Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/vmx/pmu_intel.c    | 6 +++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 55efbacfc244..49b421bd3dd8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -457,6 +457,7 @@ struct kvm_pmu {
>  	unsigned nr_arch_fixed_counters;
>  	unsigned available_event_types;
>  	u64 fixed_ctr_ctrl;
> +	u64 fixed_ctr_ctrl_mask;
>  	u64 global_ctrl;
>  	u64 global_status;
>  	u64 global_ovf_ctrl;
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index d9dbebe03cae..ac7fe714e6c1 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -400,7 +400,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_CORE_PERF_FIXED_CTR_CTRL:
>  		if (pmu->fixed_ctr_ctrl == data)
>  			return 0;
> -		if (!(data & 0xfffffffffffff444ull)) {
> +		if (!(data & pmu->fixed_ctr_ctrl_mask)) {

Don't we already have hardware with more than 3 fixed counters?

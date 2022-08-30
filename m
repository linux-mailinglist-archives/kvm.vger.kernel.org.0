Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A470C5A6C07
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 20:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiH3SYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 14:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiH3SYl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 14:24:41 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711A856B9D
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:24:40 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id x23so11925611pll.7
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=ORzmu3cToEXn/JrE0yYz4OUtzs3Wj8GxmB/541angU0=;
        b=pVjliP8f3ulCYXc/Z66/V583yR3MCrpaSmL0b0NVDIthObIOMjoIalL/jWRkNlTWMf
         96oSLaumwMmDF/3cXLvKaPk31KveDIagqGoKVWAEGcDcjOHQF6/wdd8BMAX6UxyiAvMp
         v6D7afGE9QuYbjUmfkf0AFqRmuT0EIKeVV81maqB/2ZavVuwfDcbTb4esAuu2cjP4oE/
         fgkRJPJIrjmIKzhmipulA1fcJEqqW0kKs6JJRgt48BYUOLi/RiIxcDnlNoWpdwDPsRsR
         jQ/Wsa2S757PM5CvdF5B39CC2XWeatCXy9rrrfxhdwMjtIfA5UIwEGANQAVGhL+p39pd
         h+Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ORzmu3cToEXn/JrE0yYz4OUtzs3Wj8GxmB/541angU0=;
        b=68hzS21cgfDVd7+rK0x3rlF8maUvsK6GRFLk/P2nEZ8b/kFbv2b4U9BSx4azVdgzak
         wssyCsqNy2e206QjqJm2YbtEgh/7gANrcJOYxT0Fkyxl/zOvrPYhGP8pVdpTW1Y7FWmi
         Pmo9SqJ1i3hkABdaVcVOGcU1FvwTWgnxh/Puhtw4slyoBk/IuZjxEp8qtlar95J9t+KT
         +GDDnYDe/H/WTUImukKLuWfh33Bk6Du/TvpgWS/i3ZEDd1FPKKyoP1Zjn5ZN5Gi83Z+A
         RxzgeFusC2nkpe2U5xUQPVcIh5ENFBgX4jgsiwz5aCtVDwy+b8aa55HNu/H/rlc1xo+w
         5kUg==
X-Gm-Message-State: ACgBeo0mf6SEmlWv34LpMCI5Q7TdZ/dMLcL13HzE6K+ecN1qBiNe/BuK
        3+QQrIpdQ5vxgWqVxN02xKRbFud0DTKeIA==
X-Google-Smtp-Source: AA6agR41DEPzBCPzj+CfnNFZhKQiq7WpNnkcNOsei7TbTovXf+3m5l+2RxDrtmyf7PUjOcHxJEZQ3Q==
X-Received: by 2002:a17:90b:4d8f:b0:1fc:314a:17e8 with SMTP id oj15-20020a17090b4d8f00b001fc314a17e8mr25483476pjb.152.1661883879863;
        Tue, 30 Aug 2022 11:24:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n4-20020a170902d2c400b001754064ac31sm87087plc.280.2022.08.30.11.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 11:24:39 -0700 (PDT)
Date:   Tue, 30 Aug 2022 18:24:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RESEND v2 8/8] KVM: x86/svm/pmu: Rewrite get_gp_pmc_amd()
 for more counters scalability
Message-ID: <Yw5V5H+e8pBahl5b@google.com>
References: <20220823093221.38075-1-likexu@tencent.com>
 <20220823093221.38075-9-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823093221.38075-9-likexu@tencent.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022, Like Xu wrote:
>  static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>  					     enum pmu_type type)
>  {
>  	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
> +	unsigned int idx;
>  
>  	if (!vcpu->kvm->arch.enable_pmu)
>  		return NULL;
>  
>  	switch (msr) {
> -	case MSR_F15H_PERF_CTL0:
> -	case MSR_F15H_PERF_CTL1:
> -	case MSR_F15H_PERF_CTL2:
> -	case MSR_F15H_PERF_CTL3:
> -	case MSR_F15H_PERF_CTL4:
> -	case MSR_F15H_PERF_CTL5:
> +	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
>  		if (!guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
>  			return NULL;
> -		fallthrough;

> +		idx = (unsigned int)((msr - MSR_F15H_PERF_CTL0) / 2);

> +		if ((msr == (MSR_F15H_PERF_CTL0 + 2 * idx)) !=
> +		    (type == PMU_TYPE_EVNTSEL))

This is more complicated than it needs to be.  CTLn is even, CTRn is odd (I think
I got the logic right, but the below is untested).

And this all needs a comment.


		/*
		 * Each PMU counter has a pair of CTL and CTR MSRs.  CTLn MSRs
		 * (accessed via EVNTSEL) are even, CTRn MSRs are odd.
		 */
		idx = (unsigned int)((msr - MSR_F15H_PERF_CTL0) / 2);
		if (!(msr & 0x1) != (type == PMU_TYPE_EVNTSEL))
			return NULL;

> +			return NULL;
> +		break;

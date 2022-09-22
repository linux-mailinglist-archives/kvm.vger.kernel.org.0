Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A3D5E702B
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 01:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiIVXSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 19:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiIVXSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 19:18:35 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B760B113B41
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 16:18:34 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so3996395pjm.1
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 16:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Eme5osJY/5Rp5DNysRQpWmI+9C4cuy494dQr0Mrz++U=;
        b=U4HMgxJv8HiCFr+ZpfVQFqtuL/hvqdCxrScPAUlRiPZ8w2zaESpOwbe3aYI1f+OsGP
         kCDeIHcmpYNvFEEmJ9CGKglHZ2VG1fnxSv+Oy5OYHrprE/+yreyXsGQXzA9ku+2UgHPf
         24tOYfpxzc3M4JaEprRQQFkgLcDnwZBjgKTOiOBCy8qRg1522UIJK+4iPuIZDUc4NL31
         czxHW0DNhTFdZt0E+zXcBwQBybwUu2+/LmjJaLlg9zvu6pPRR5HtjjgPBT9xhLq5BVhj
         QuSt+mGCWkgKn9oYD1RVyYlF6zDhRhgqH81SgbO/XJrEGppEUDy4YozPxGDuilyZL/TH
         gnOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Eme5osJY/5Rp5DNysRQpWmI+9C4cuy494dQr0Mrz++U=;
        b=T0bgDWVs8paYc+q5aClaaz4SW3j0qLoi3+2OoRtanHSmB+xkJefn5t28+8Ckypjp7j
         +weRjkyO6URnHdYOgCHczNpHN4fj0lF6FGIaYfW/tRRy+7BXb/nXGdWVFklEYg+JfQFk
         2mryIfBZ1ts2Q3/If8ZhEgMoKcFxyy0UAn9Gh1K6EUvmXJqAsePILdv3glhicsAwYXHt
         QH1G3UHUBIMeLX1GECP3j4sRnY6Qqs8NECA0s8N1ns7dU6I/Pl8SAUvwfhgABqlx7mXV
         7tiR6hjxNi0biHxz1lU7SdJcdo9YTNtAsn8DM1LXdkxp5mN1TcMhoVWcndKjcPubD2HG
         acxQ==
X-Gm-Message-State: ACrzQf2tqSbJDKLECvLr12CqKE1Z9pFivbb0aX/ygr9CmjSgUrVclreB
        dc5MTF1VTaXg26gCHm3tSsQhkk6q17oYAg==
X-Google-Smtp-Source: AMsMyM6Yd4hPVohyroGHyhGlFVS57e/aux4+7M8gZbth9BxNgR+b/9debuQ+TJmQ/TF8MG8fimP7Vw==
X-Received: by 2002:a17:902:d484:b0:178:1b69:1488 with SMTP id c4-20020a170902d48400b001781b691488mr5674839plg.156.1663888714133;
        Thu, 22 Sep 2022 16:18:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b6-20020a62a106000000b00542e190f6bcsm4961571pff.102.2022.09.22.16.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 16:18:33 -0700 (PDT)
Date:   Thu, 22 Sep 2022 23:18:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] KVM: x86/pmu: Defer reprogram_counter() to
 kvm_pmu_handle_event()
Message-ID: <YyztRtbEwBFaoKfQ@google.com>
References: <20220831085328.45489-1-likexu@tencent.com>
 <20220831085328.45489-5-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831085328.45489-5-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022, Like Xu wrote:
> @@ -542,7 +541,9 @@ static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
>  static inline bool cpl_is_matched(struct kvm_pmc *pmc)
>  {
>  	bool select_os, select_user;
> -	u64 config = pmc->current_config;
> +	u64 config = pmc_is_gp(pmc) ? pmc->eventsel :
> +		(u64)fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
> +				      pmc->idx - INTEL_PMC_IDX_FIXED);

Don't use a ternary here, the same conditional exists immediately below, i.e.
this can simply be:

	u64 config;

	if (pmc_is_gp(pmc)) {
		config = pmc->eventsel;
		select_os = config & ARCH_PERFMON_EVENTSEL_OS;
		select_user = config & ARCH_PERFMON_EVENTSEL_USR;
	} else {
		config = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
					  pmc->idx - INTEL_PMC_IDX_FIXED);
		select_os = config & 0x1;
		select_user = config & 0x2;
	}

Note, there's no need to cast to a u64; fixed_ctr_ctrl is a u64, and even if it
gets temporarily truncated to a u8, the relevant path only checks bits 0 and 1.

>  
>  	if (pmc_is_gp(pmc)) {
>  		select_os = config & ARCH_PERFMON_EVENTSEL_OS;
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 5cc5721f260b..847e7112a5d3 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -183,7 +183,11 @@ static inline void kvm_init_pmu_capability(void)
>  					     KVM_PMC_MAX_FIXED);
>  }
>  
> -void reprogram_counter(struct kvm_pmc *pmc);
> +static inline void kvm_pmu_request_counter_reprogam(struct kvm_pmc *pmc)
> +{
> +	__set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);

Given that everything else that accesses reprogram_pmi uses atomic accesses, please
make this atomic as well, i.e. use set_bit().  Even if reprogram_pmi is currently
guaranteed to be accessed only from the CPU that has loaded the vCPU (no idea if
that's true), I am planning on fixing the PMU filter (KVM doesn't force reprogramming
on filter changes) by setting all bits in reprogram_pmi from a separate CPU, at
which point this needs to be atomic.

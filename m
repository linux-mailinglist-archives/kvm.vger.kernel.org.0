Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EEF683218
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 17:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjAaQCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 11:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjAaQCR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 11:02:17 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88B84F84C
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:02:08 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id e8-20020a17090a9a8800b0022c387f0f93so14471998pjp.3
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qolkKFUWF1fSIOK1T3Eb09EPST5XmPMDbV9tDFNFExo=;
        b=jWnk1TOM6LONcmHCt2iwS2FTGiUVyhcrd5IpPf7TYQhlOKo6WBzLAns2wMLbQKY9f9
         CUvVEnd+x4W3Wyksza/ixN1WtO2uzqz55zGDyvot7M/9/HDKGscvfmKdOGtURPo9HDnt
         6vhmN4Fh+IgoG8e4Rx/unRp4tB9F2x1ZiVSl1EFGe79gN5jaLVowThk4XBjj9lpCVYob
         gqz8F+yLkjnnXIBZUDTotPqgQByeR7zNHI9eldQ5X8OhZX3lbFNgP1I8JENUpSm2KmRx
         rm2HiC+Cob/A8iIQh1f0+xwlAkDVpFNF7HhhJyKdbrhxEGYMHeXmu9AEEF1NDEJXd06L
         v3RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qolkKFUWF1fSIOK1T3Eb09EPST5XmPMDbV9tDFNFExo=;
        b=M2spaGIND60uDWPbg6LptOB5nPMsFywo/FzUvwj04iu4IrnczciQp5164Fjq0mj6uo
         GkyBTWMJqnbMcH/jVXFANEKHGQ2IZjwp3miZ/PRzkSxkvPOfy0xas0C8/3yev0X1UPyl
         SLpfDSwoLPPUaveBb2eV/MunB3A/nYQiHSi6RzSUjhBX13kVhOj8r9QI0oqqjGpP//tm
         tm2rCznfpYL79gPNA2JD9REMv9A1if/o8xTsEEy+dxPQXkEWbmKIN3zjRuo/WO5JH4R4
         Czd8kby7G6uGqTZIvAIkCYvWWNHjIkPmM8Da32muw18qbXnJsAAQHo037jUkmu6382QN
         OY/Q==
X-Gm-Message-State: AO0yUKUsT1sAyfYvS2VtgbgK9sCHCSMjBk9nwjpiKoGRRZF8Lpkq4oWg
        dlT7eUaeCaJ9rHK/aEgVWaMX/cuZDgJJkGQitaY=
X-Google-Smtp-Source: AK7set+KL+QXJKcsXfji2x/PfH7A3BpcIIHPo1gbiHQ83HR6xcjyD+XYz5o6CplbFB72OmNmakpHyw==
X-Received: by 2002:a05:6a20:6d15:b0:a4:efde:2ed8 with SMTP id fv21-20020a056a206d1500b000a4efde2ed8mr1491710pzb.0.1675180927925;
        Tue, 31 Jan 2023 08:02:07 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id cw10-20020a056a00450a00b0057a9b146592sm9565264pfb.186.2023.01.31.08.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 08:02:07 -0800 (PST)
Date:   Tue, 31 Jan 2023 16:02:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianfeng Gao <jianfeng.gao@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] KVM: x86/pmu: Disable all vPMU features support on
 Intel hybrid CPUs
Message-ID: <Y9k7eyfmXjqW9lYF@google.com>
References: <20230131085031.88939-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131085031.88939-1-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Disable KVM support for virtualizing PMUs on hosts with hybrid PMUs until
> KVM gains a sane way to enumeration the hybrid vPMU to userspace and/or
> gains a mechanism to let userspace opt-in to the dangers of exposing a
> hybrid vPMU to KVM guests.
> 
> Virtualizing a hybrid PMU, or at least part of a hybrid PMU, is possible,
> but it requires userspace to pin vCPUs to pCPUs to prevent migrating a
> vCPU between a big core and a little core, requires the VMM to accurately
> enumerate the topology to the guest (if exposing a hybrid CPU to the
> guest), and also requires the VMM to accurately enumerate the vPMU
> capabilities to the guest.
> 
> The last point is especially problematic, as KVM doesn't control which
> pCPU it runs on when enumerating KVM's vPMU capabilities to userspace.
> For now, simply disable vPMU support on hybrid CPUs to avoid inducing
> seemingly random #GPs in guests.
> 
> Reported-by: Jianfeng Gao <jianfeng.gao@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> v1: https://lore.kernel.org/all/20230120004051.2043777-1-seanjc@google.com/
>  arch/x86/kvm/pmu.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 79988dafb15b..6a3995657e1e 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -166,9 +166,11 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>  
>  	 /*
>  	  * For Intel, only support guest architectural pmu
> -	  * on a host with architectural pmu.
> +	  * on a non-hybrid host with architectural pmu.
>  	  */
> -	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
> +	if (!kvm_pmu_cap.num_counters_gp ||
> +	    (is_intel && (!kvm_pmu_cap.version ||
> +			  boot_cpu_has(X86_FEATURE_HYBRID_CPU))))

Why do this here instead of in perf_get_x86_pmu_capability()[*]?  The issue isn't
restricted to Intel CPUs, it just so happens that Intel is the only x86 vendor
that has shipped hybrid CPUs/PMUs.  Similarly, it's entirely possible to create a
hybrid CPU with a fully homogeneous PMU.  IMO KVM should rely on the PMU's is_hybrid()
and not the generic X86_FEATURE_HYBRID_CPU flag.

[*] https://lore.kernel.org/all/20230120004051.2043777-1-seanjc@google.com

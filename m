Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F1667DC1A
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 03:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbjA0CGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 21:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbjA0CFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 21:05:43 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D4546704
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 18:03:15 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id nn18-20020a17090b38d200b0022bfb584987so3552496pjb.2
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 18:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QlnC2FACLz4TVazdbeeDFs7ZKh+4cFrx8LwVyzMk1F8=;
        b=loBlZtwcLsVlfXwQIERwIJ+CvIOKfjyag+u+fc7ru6Zxx3Fdk5sbWOUYc98VITpEgU
         dfk+Z+14ls4uR+LOpmvabY0SZH22k3D/rg95JtaWxgMKNFOodruDeiw+25R4/6tMVPb2
         gAyCAFCAmwQDN0X0tXZyaHBJnmehybBqSZgdYXH3QHlQ9gfCd+kXH0hNzkGkb8hl6Y1c
         Si2uIeSghkSBj6GSlBIHCwtA0ewSS2odWWIi0evy6WsoHJYjiFRV+bDZu2Hv/P7fsI6X
         xT1nm7jnQ9il8SLu9MU4qeRUAO85eAnTvJmiCpR1DATPSUgw5oLJjE6VWv8eG2U3Md7L
         6IiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QlnC2FACLz4TVazdbeeDFs7ZKh+4cFrx8LwVyzMk1F8=;
        b=eUi7PcBTnjJjZMiHt9MglpRQ1M39jeQOO0WmLGsOGjpxrbsmhF7jQeA1PxJG9th0Sm
         fSNsGaNLl40iWDc83v1ZjlL610QtiU9j2oMcRJrjMLzoWLErPU6Uz8mPuqmfukQoeFbD
         zucyEq3h4il1o6gaqwu63yzQgnLmyCHVjr+UnkKsj9LCheLT1AmlJ4QKfCQV+FzYgjH/
         zRA/sQN5A4sViBoLqmlkxC23ac9ALngBGyY+E/FgYK7xCRwzw+4xjBvMG0BBydIdKvAz
         axoUpwhDCevgfw5G5W65BZIVe+rhZhPEQ6SW1IDNnwXn32uaJOhhkx4Pqu+pjhwfu5e+
         Lulg==
X-Gm-Message-State: AO0yUKX087kC9+EGQ3/zBgE9d4rDx7popZuFfq1h0siz52lqNb1tghRW
        dFj57C3Lcab5OPw5MDLjERHdmQtE8DsxYTaqrb8=
X-Google-Smtp-Source: AK7set/q3kh0Y5amuDKghvzE2jA+7uNs0NPpCTSEeqflEwH2JIUjGWc2BNZcQcGyU16D8fjoov2vnQ==
X-Received: by 2002:a17:902:c9d2:b0:189:6624:58c0 with SMTP id q18-20020a170902c9d200b00189662458c0mr1152283pld.3.1674784994516;
        Thu, 26 Jan 2023 18:03:14 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u5-20020a170902e80500b00194974a2b3asm1619966plg.151.2023.01.26.18.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 18:03:14 -0800 (PST)
Date:   Fri, 27 Jan 2023 02:03:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v3 1/8] KVM: x86/pmu: Rename pmc_is_enabled() to
 pmc_is_globally_enabled()
Message-ID: <Y9Mw3pcW/SL/Mna8@google.com>
References: <20221111102645.82001-1-likexu@tencent.com>
 <20221111102645.82001-2-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111102645.82001-2-likexu@tencent.com>
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

On Fri, Nov 11, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The name of function pmc_is_enabled() is a bit misleading. A PMC can
> be disabled either by PERF_CLOBAL_CTRL or by its corresponding EVTSEL.
> Add the global semantic to its name.
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---

...

> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 684393c22105..e57f707fb940 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -83,7 +83,7 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
>  #undef __KVM_X86_PMU_OP
>  }
>  
> -static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
> +static inline bool pmc_is_globally_enabled(struct kvm_pmc *pmc)
>  {
>  	return static_call(kvm_x86_pmu_pmc_is_enabled)(pmc);

This doesn't compile.  v3, and I'm getting pings, and the very first patch doesn't
compile.

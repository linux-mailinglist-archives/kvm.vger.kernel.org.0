Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48997675A32
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 17:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjATQlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 11:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjATQlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 11:41:01 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9C34699
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 08:41:00 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id lp10so2695932pjb.4
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 08:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Dug0yTxCp+eWKDK5G8TD/37FZQw5LWkxB2o6dVF2fs=;
        b=LuCQVk+PIu+b14JunqNk/F7UzLUP/9GGJh/U1K/8MOuPR2AdROuguQl75Q8+uXEeyW
         8hsrSsA8I6zOXIPJFbbwQ0HNgyuhTp3gX6KgKtFMjthZIfvmPQqGz1DGkvhHs55Ohg8F
         Q08kB8ApIYJ4IBaMjNOLKmnGCohR17wPMPGZ9HVSIyCU22ntOwFIM6Wa/AWTrOL7ZAEK
         zgUfSwUM+rR4hzZCuxrQ/R1lt3uqx2kXEFA1jHkEkNMxC1UyVgWw5kk2caAWDSa5oX6N
         QAfyH79iRhXh58dB1eFZ8h0krwWXt/iKDMLqHv+WvY1J3nsWuXMF/nbAxFPClhml+Z/A
         c07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Dug0yTxCp+eWKDK5G8TD/37FZQw5LWkxB2o6dVF2fs=;
        b=c9c5rq/Dv/R7jHw0M77D9OeZE9902FUZQivN675T5m5E7XUgob1ccPayd+SKf2ZRoj
         77dkP2wyiFP3lzsjn0AAzNK1NNu1gyv4a6FJySd0+ECfr3g63eTDFilkT/HRNiSajVpF
         oTOomadGyx1YjgMBSyg0/NlcOBVJP84us0OCPPIdBJdJVr+pXI22gMGBJpIr3EHupjNq
         nv2Fpy5ifEV0isaRriqUnAo8q7Q9xpGFE7ALHMoPCqsDIHJWxatlVaAYMWWCw3eAtvda
         oezahTETtUPp4K0K37R+wwnpsSUBBRwUlTuzra3FkT55VhoXc+oEhcWqOzk+6vzwiA/n
         kDyg==
X-Gm-Message-State: AFqh2kqudW4qiyPhxiU71MybFWO2vQFFJ0uhI3JWPSsGyYJ3W4SAsYLA
        dJIHUweAdv/UJlqz9HTzhNnyDw==
X-Google-Smtp-Source: AMrXdXvwWdNPAPAF8UxRTsgHqn40PKQFZvGXeCSFJn5ZyOS5jsUniT/7u/n0z55pGLEOuSrm+Vtvog==
X-Received: by 2002:a17:90a:6905:b0:229:f4e9:75c7 with SMTP id r5-20020a17090a690500b00229f4e975c7mr293720pjj.0.1674232859561;
        Fri, 20 Jan 2023 08:40:59 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id gn24-20020a17090ac79800b001ef8ab65052sm1752488pjb.11.2023.01.20.08.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 08:40:58 -0800 (PST)
Date:   Fri, 20 Jan 2023 16:40:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dionna Glaze <dionnaglaze@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <jroedel@suse.de>,
        Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 1/2] kvm: sev: Add SEV-SNP guest request throttling
Message-ID: <Y8rEFpbMV58yJIKy@google.com>
References: <20230119213426.379312-1-dionnaglaze@google.com>
 <20230119213426.379312-2-dionnaglaze@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119213426.379312-2-dionnaglaze@google.com>
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

AMD folks, unless y'all object to the concept itself, can this be tacked onto the
SNP series?  Responsibility for responding to feedback and making changes can still
be punted to Dionna (or whoever), I just get briefly confused every time this series
is posted because I think it's addressing a problem that needs attention _now_.

On Thu, Jan 19, 2023, Dionna Glaze wrote:
> The AMD-SP is a precious resource that doesn't have a scheduler other
> than a mutex lock queue. To avoid customers from causing a DoS, a
> module_param-set rate limit is added with a default of 2 requests
> per 2 seconds.
> 
> These defaults were chosen empirically with a the assumption that
> current server-grade SEV-SNP machines will rarely exceed 128 VMs under
> usual circumstance.
> 
> The throttling code is 2 << 32 given that invalid length is 1 and 2 is
> the next available code. This was suggested by Tom Lendacky, and will
> be included in a new revision of the GHCB specification.

Why does throttling just punt back to the guest?  E.g. why not exit to userspace
and let userspace stall the vCPU?  Is the guest expected to schedule out the task
that's trying to make the request?

> @@ -158,6 +158,7 @@ struct snp_psc_desc {
>  
>  /* Guest message request error code */
>  #define SNP_GUEST_REQ_INVALID_LEN	BIT_ULL(32)
> +#define SNP_GUEST_REQ_THROTTLED		(((u64)2) << 32)

Someone please add macros to define the shift and generate error codes, the above
is way too hard to read for such a simple concept.  E.g. I want to see something
like

 #define SNP_GUEST_REQ_INVALID_LEN	SNP_GUEST_REQ_ERROR_CODE(1)

>  #define GHCB_MSR_TERM_REQ		0x100
>  #define GHCB_MSR_TERM_REASON_SET_POS	12
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d0e58cffd1ed..cd9372ce6fc2 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -58,6 +58,14 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
>  /* enable/disable SEV-SNP support */
>  static bool sev_snp_enabled = true;
>  module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
> +
> +/* Throttle guest requests to a burst # per this many seconds */
> +unsigned int guest_request_throttle_s = 2;

"seconds" seems like to coarse of a granularity, e.g. if userspace wants to allow
one request every half-second.  Why not go with milliseconds?  As a bonus, the (IMO)
odd "s" gets replaced with the more intuitive "ms".

That said, I wonder if this should be a per-VM capability, not a module param.
Since the throttling is per VM and not per user, making it a module param doesn't
prevent a malicious user or even a compromised VMM from spamming the PSP, e.g. just
spin up a big pile o' VMs.

> +module_param(guest_request_throttle_s, int, 0444);
> +
> +/* Throttle guest requests to this many per the above many seconds */
> +unsigned int guest_request_throttle_burst = 2;
> +module_param(guest_request_throttle_burst, int, 0444);
>  #else
>  #define sev_enabled false
>  #define sev_es_enabled false
> @@ -333,6 +341,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  			goto e_free;
>  
>  		mutex_init(&sev->guest_req_lock);
> +		ratelimit_state_init(&sev->snp_guest_msg_rs,
> +				guest_request_throttle_s * HZ,
> +				guest_request_throttle_burst);
>  		ret = sev_snp_init(&argp->error, false);
>  	} else {
>  		ret = sev_platform_init(&argp->error);
> @@ -3595,6 +3606,14 @@ static void snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data, unsig
>  		*rc = SEV_RET_INVALID_ADDRESS;
>  }
>  
> +static bool snp_throttle_guest_request(struct kvm_sev_info *sev) {

Curly brace goes on its own line for functions.

> +	if (__ratelimit(&sev->snp_guest_msg_rs))
> +		return false;
> +
> +	pr_info_ratelimited("svm: too many guest message requests\n");

Drop the printk, it doesn't help understand _which_ guest is being throttled.
If userspace really wants to get notified, then KVM should exit to userspace
instead of throttling manually.

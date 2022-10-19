Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23869605346
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 00:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiJSWmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 18:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiJSWml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 18:42:41 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2DB1849B9
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:42:40 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h185so17556247pgc.10
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ybaWlg1ZOb9tf6BoYXGE+JxAOPDJSnV1U2JSb8C6jhg=;
        b=fRyFC/xu0gEI0/Yko+s6wRiRi1fj7TwEbX0ITNtDzJaohmAbiEcUEkV/NuVmSRILBF
         XEVVbZF9S+QtAjmxppefEnypPqmImHmSw47C5LZ5zL335SEJ4U5zy1N23WLpMudAgE4N
         eibZjgP5F5NS2O7v/h5v1Xetuuk4tke4OgAWjpzLyvJHRe+MRwhACPMqdHmAmP0iESdt
         g7ulhK2AYdKzrhg+7Y4FGBwSEfl/9gG2Xs03CVEk2NTST7y3MNdkloxD1h4dHpVZ1Cv0
         gx91R8Z4BDL3aYhFpxWxumJj/G7Qp7C3KexHpGLg2tXi5myFlyRpmghmx6IdyNz+dz8/
         5s5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ybaWlg1ZOb9tf6BoYXGE+JxAOPDJSnV1U2JSb8C6jhg=;
        b=KRJfeoWLGKLkp14wZqoHIKubGSx6QgqdqLaxjYRzpp6FoqTI+imLFYiTFYiHJBNiCS
         dCLwOBBgRt/Ni6jISUVzQZZDTVE9o3Wkf6nheMQHyRQrmGSJVKyVta5dBXqYest+iju4
         TBS8KygciV1Vvuc6aIlVLGVMeVMWnIHjtY6my0iRPbWsm9LTuZMVrKWS2Bf7eKR9E/KJ
         lAV1KH+jR1Kn6mh6tNPriaTrJjQsnIl9RLokgoSDnWmOX+Wdzpox6V76qpWbcghaOfgx
         K7XVwv7BcVdwu+FxgmPdLy/zGco7vzGHXfrkkKuuVXJtrvbjzl5fjcvCLWBt0DqOCq0L
         cSHA==
X-Gm-Message-State: ACrzQf1i+mzEXuSTvAYTrU8jNZQWs3N/9BtMYSenNk5NMXlc6FH1Rhib
        ACFyX0cvdlgmI4Is8mn3oGa7Iy0leNOY9w==
X-Google-Smtp-Source: AMsMyM7RFCnBb6dUVQcSh8KOGDW6LuISnZpKxy6kcS+eeILzkWDPMi7UOxAOu7LQnVJC/xwW1iO9iA==
X-Received: by 2002:a63:1608:0:b0:45a:355a:9420 with SMTP id w8-20020a631608000000b0045a355a9420mr9102165pgl.354.1666219359824;
        Wed, 19 Oct 2022 15:42:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b10-20020a17090a5a0a00b0020b7de675a4sm398508pjd.41.2022.10.19.15.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 15:42:39 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:42:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
Message-ID: <Y1B9XFeGw5Q/k3Ax@google.com>
References: <20220929225203.2234702-1-jmattson@google.com>
 <20220929225203.2234702-2-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929225203.2234702-2-jmattson@google.com>
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

On Thu, Sep 29, 2022, Jim Mattson wrote:
> KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
> actually supports. CPUID.80000006H:EDX[17:16] are reserved bits and
> should be masked off.
> 
> Fixes: 43d05de2bee7 ("KVM: pass through CPUID(0x80000006)")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index ea4e213bcbfb..90f9c295825d 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1125,6 +1125,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		break;
>  	case 0x80000006:
>  		/* L2 cache and TLB: pass through host info. */

Might be worth tweaking the comment, e.g. to

		/* L2 cache and TLB: advertise host info, sans reserved bits. */

> +		entry->edx &= ~GENMASK(17, 16);
>  		break;
>  	case 0x80000007: /* Advanced power management */
>  		/* invariant TSC is CPUID.80000007H:EDX[8] */
> -- 
> 2.38.0.rc1.362.ged0d419d3c-goog
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA7596A78C3
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 02:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjCBBRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 20:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjCBBRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 20:17:24 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FE5567B1;
        Wed,  1 Mar 2023 17:17:22 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id i5so14276733pla.2;
        Wed, 01 Mar 2023 17:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677719842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=asFV0wGttlVazBKFWSu0J8Ni3xIQFqSo2qkdIFlJQKM=;
        b=KGFQt4L2o8msWE6M0Pud1dSz6VpD0RAi8a6X8llUhCirSMC/35UnSarlg4XpVoq37H
         qGnr4j0nHXaApYM5pHDNSycL6kkDn1MRRZ/6/wCIU90EJCnV7rcLuMfur5ue0XLlIN3p
         vplgxh+WaPnG9TvDGvr0X46wCoc9IFE6L/YO5O+uf9pY8sg2Gm2yxq+6T2bGSQ17WXRH
         kZvVr5yel+ugBj6UlpRlzrp/C1ClMB5F2CKucZ9zXnMN82AKI3XOp9DAiwh91YTpW6SC
         vPiz3DBFEf8bbGJCzV6P1fAWG2DAjAxqQQYf7fhFwD96NqVuE2I1g3jrICDsgtL36XXb
         Sj9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677719842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=asFV0wGttlVazBKFWSu0J8Ni3xIQFqSo2qkdIFlJQKM=;
        b=as4stbgyCf+xvyfwouiiCPvhr4bRsXQD8ct79kVR490EGjeIunePoCxBl72YA3uXUV
         VAaNNBwy+gD+ytaLSX06bUaQue8CWU8XvaMUz2fFDGCmqeXeeBcNa8LB7RkWrt35pBgh
         4GtT5hfgQKZvmG17GlCl4pJMfj3HwOLSt+d4nRt2ZdHRQsv3TKO/qKr0o1cK5thJRT0z
         mXId0N0/xWI7Bkq3Lj/9G0eSmHZpvmjdxbofTtHpDHrfn4O2Lmul2j4EHRNy8ZhRKyd1
         4cc8EXcvNjjvx1aD4DGwfyalkbXRiu6Kx5Gaf7IFTJ0odcv49pszWVYuY/cQ17uIOLGE
         Vcnw==
X-Gm-Message-State: AO0yUKXtZVBnN2qLVHfALAGrWCrbWgtSilqQ4l6CsZf3hvrBVj7/z5X9
        C4iN8mUYD0cczRrskwcEtdtLxal0HPA=
X-Google-Smtp-Source: AK7set+Ml9u7/fpwHpO9q3mZQBekravHYVltx92gpYRbnBdLshqkvqyDwdfWkOt1AyPaY1Q0VnCTeA==
X-Received: by 2002:a05:6a20:1581:b0:cd:929d:27fc with SMTP id h1-20020a056a20158100b000cd929d27fcmr10584100pzj.45.1677719841859;
        Wed, 01 Mar 2023 17:17:21 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id c5-20020a6566c5000000b00503000f0492sm1701005pgw.14.2023.03.01.17.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 17:17:21 -0800 (PST)
Date:   Wed, 1 Mar 2023 17:17:19 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com
Subject: Re: [PATCH v1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Message-ID: <20230302011719.GB2069594@ls.amr.corp.intel.com>
References: <20230301133841.18007-1-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230301133841.18007-1-wei.w.wang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 09:38:41PM +0800,
Wei Wang <wei.w.wang@intel.com> wrote:

> Current KVM_BUG and KVM_BUG_ON assumes that 'cond' passed from callers is
> 32-bit as it casts 'cond' to the type of int. This will be wrong if 'cond'
> provided by a caller is 64-bit, e.g. an error code of 0xc0000d0300000000
> will be converted to 0, which is not expected. Improves the implementation
> by using !!(cond) in KVM_BUG and KVM_BUG_ON. Compared to changing 'int' to
> 'int64_t', this has less LOCs.

This changes its semantics. cond is evaluated twice. Also the return value
of KVM_BUG_ON() is changed to bool. typeof?
Perhaps return type of bool is okay, though.

Thanks,


> Fixes: 0b8f11737cff ("KVM: Add infrastructure and macro to mark VM as bugged")
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> ---
>  include/linux/kvm_host.h | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f06635b24bd0..d77ddf82c5c8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -881,20 +881,16 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
>  
>  #define KVM_BUG(cond, kvm, fmt...)				\
>  ({								\
> -	int __ret = (cond);					\
> -								\
> -	if (WARN_ONCE(__ret && !(kvm)->vm_bugged, fmt))		\
> +	if (WARN_ONCE(!!cond && !(kvm)->vm_bugged, fmt))	\
>  		kvm_vm_bugged(kvm);				\
> -	unlikely(__ret);					\
> +	unlikely(!!cond);					\
>  })
>  
>  #define KVM_BUG_ON(cond, kvm)					\
>  ({								\
> -	int __ret = (cond);					\
> -								\
> -	if (WARN_ON_ONCE(__ret && !(kvm)->vm_bugged))		\
> +	if (WARN_ON_ONCE(!!(cond) && !(kvm)->vm_bugged))	\
>  		kvm_vm_bugged(kvm);				\
> -	unlikely(__ret);					\
> +	unlikely(!!(cond));					\
>  })
>  
>  static inline void kvm_vcpu_srcu_read_lock(struct kvm_vcpu *vcpu)
> -- 
> 2.27.0
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

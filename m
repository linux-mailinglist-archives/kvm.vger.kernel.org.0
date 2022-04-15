Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20784502BD2
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354465AbiDOOYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354478AbiDOOYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:24:11 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946DC69486;
        Fri, 15 Apr 2022 07:21:33 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bh17so15604390ejb.8;
        Fri, 15 Apr 2022 07:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=08pfEuyLiFmPHxey+T5VgpFceM9bwO2n4GmdqLEQlVc=;
        b=GB9aMwZ3gJcqu2BKR+IN+hR48poSHukDJxGnGzokdAQ+Lndz7ZjWILiFS1UAkXW89+
         b6hROebMXuZrFMahuTLeIOJ8t7LAvpzCNRchpEhd5fwfJsRHaauwnmsmooEMWWXZ++yL
         3lAHUOOo2gtYAmrvz2d3EWp2TbU/MmHdUlOdK3m6mO+Ey4GUGiF6z54UB7n67Tnoqs5/
         wrwsfIHaKVqEziJRb3yKliqUcruYNIO6OKcOyA3Pf09hTTt85XGIL8Qajo8l5nAkZ8+q
         SJuzDIl26VID/DK+VnlJ5RJP7FYSTMuvjN/FjEENDnxT7MceQMtbQgjAW22wLQZ8xFfT
         2RDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=08pfEuyLiFmPHxey+T5VgpFceM9bwO2n4GmdqLEQlVc=;
        b=SfVaBaVWMmMVwOlR3DtHBDSaPhgodI6fP1nYHZddVe0X1OS05Nu8oJSs0LrCapvoUw
         rzJpKTkdMir2TvBRFsJN75wbN55W2gqccvdtV99gkgSNRRLKBnYjrWPGIpMNFSg+Cuqm
         7ck9/kbY/EWRZDoQKwD9gaYUG7J5xjTv6+dWbcOVjtn9bxHKyv7QMbTjG6R7d/qTsq+m
         PpVnJwrBJtQFMjO5UE+vhVyD6AkYQQW6BfApbguhw6mfXxXb+B1KiTJwqv5hLxaaDJ7p
         9hpjgzRa0wbNEx16AVQEkFgAoDrYnC101SSYDtFi2a/dl5ynMAQKdLxyEHjbPp+qGF4v
         KIog==
X-Gm-Message-State: AOAM532z6NvRS4ipUorPtoQ9UdeFFbXh9U1YZM9qnbqigdTNbSlEIQDB
        P37A3QO9acMihzOXGZcNYqM=
X-Google-Smtp-Source: ABdhPJy6D30gSEs5AmXyDE2/N8v9BXaFZOLMA/lUKPgmI8twyUI3L/SzXSqGQganb+33NYwailZedw==
X-Received: by 2002:a17:906:7746:b0:6ce:a12e:489f with SMTP id o6-20020a170906774600b006cea12e489fmr6298375ejn.551.1650032492096;
        Fri, 15 Apr 2022 07:21:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id er15-20020a056402448f00b0042110981d13sm2380526edb.48.2022.04.15.07.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 07:21:31 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <5fd8d6dd-07be-9bf1-1ad9-5536c4e40182@redhat.com>
Date:   Fri, 15 Apr 2022 16:20:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 071/104] KVM: TDX: restore debug store when TD exit
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <c7f81bd80af0f57ff2fabef24a218fb43c3d0e3c.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <c7f81bd80af0f57ff2fabef24a218fb43c3d0e3c.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Because debug store is clobbered, restore it on TD exit.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/events/intel/ds.c | 1 +
>   arch/x86/kvm/vmx/tdx.c     | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
> index 376cc3d66094..cdba4227ad3b 100644
> --- a/arch/x86/events/intel/ds.c
> +++ b/arch/x86/events/intel/ds.c
> @@ -2256,3 +2256,4 @@ void perf_restore_debug_store(void)
>   
>   	wrmsrl(MSR_IA32_DS_AREA, (unsigned long)ds);
>   }
> +EXPORT_SYMBOL_GPL(perf_restore_debug_store);
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 3cb2fbd1c12c..37cf7d43435d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -620,6 +620,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   	tdx_vcpu_enter_exit(vcpu, tdx);
>   
>   	tdx_user_return_update_cache();
> +	perf_restore_debug_store();
>   	tdx_restore_host_xsave_state(vcpu);
>   	tdx->host_state_need_restore = true;
>   

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

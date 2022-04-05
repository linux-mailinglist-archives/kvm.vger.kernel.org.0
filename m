Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39AC64F444B
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 00:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238997AbiDEOr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 10:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386144AbiDEOTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 10:19:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BC472BCC
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 06:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649164115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8SLg2V/rMLaWaYTpjzTRS0k/QFp5WFOGLvjyUFHrKJY=;
        b=Vyje00f4vebmWZc9RYkLZ3OC01/OSe0zL9Z8mZP2cIxa+p4AvHykIPwBN0CUjsbgxerMUi
        QGlLFiYo4sWaZ4/YXDenGJc6ay18Ywq4qtX0u5vf/JYQX8lQOag1d0LKgzRv5M9IQYINRn
        dDCCGi8+OSzkauBGEOhAj4nfsP89ZFE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-hiDN1o1UNZupCsjXMwN6Kg-1; Tue, 05 Apr 2022 09:08:34 -0400
X-MC-Unique: hiDN1o1UNZupCsjXMwN6Kg-1
Received: by mail-wr1-f71.google.com with SMTP id t15-20020adfdc0f000000b001ef93643476so2455839wri.2
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 06:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8SLg2V/rMLaWaYTpjzTRS0k/QFp5WFOGLvjyUFHrKJY=;
        b=8JwjTUzBO3YCyKEUalQuBscsHBpUr6usMHsy9lI8dGarRU15CoMS0o+sGWpRTfXvpc
         Ij3NjyiHP1xhmQgA9zICPA1Jh13/s5iqYaLFPVI1l59f7ucCXvWBO0qwpDgO6Givo2Xb
         +AH8mLVUXTln9efSHleoHWNh+vkZAlQBTKsmrS9QvtjsvaK5hn/aTbWYhY7tfFZZG6J4
         xeruN047yMgo6HAU42Jr7ZxUKOQbTCtSkmRI7UNVS8wjtG4e8QTc2gPfGaoF0SDjCw9m
         ZhMH9SS0SHklPEnL5SuUaooM3bqo72yqAk1FqqGnnni11FyXuYTC/wr0+7JUs7VWpzdy
         3urQ==
X-Gm-Message-State: AOAM533KGpW/a+BlsBtz2aEXEvqBX+WIumzOhhoqd/RKXeVo7b/oNieS
        hW9Uc+eCucTmB8a0iE2T7Xaxd/+qmb0A9HWTP/grkCPLBtvj0L0gK1f8NLoUxpxUpgTIXK7URjU
        PJc9uqbU3tEnR
X-Received: by 2002:a7b:cd03:0:b0:37b:fc83:a4e2 with SMTP id f3-20020a7bcd03000000b0037bfc83a4e2mr3047622wmj.193.1649164112937;
        Tue, 05 Apr 2022 06:08:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxw4wTRpI39IlAgBO5ZQoXo4KftgHSb5XxaFNxwDYQkGsSuCa17GkEpnsUsvkMa8CN+RPq1fQ==
X-Received: by 2002:a7b:cd03:0:b0:37b:fc83:a4e2 with SMTP id f3-20020a7bcd03000000b0037bfc83a4e2mr3047597wmj.193.1649164112715;
        Tue, 05 Apr 2022 06:08:32 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id m127-20020a1ca385000000b0038e6e7ac0b5sm2141613wme.38.2022.04.05.06.08.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 06:08:31 -0700 (PDT)
Message-ID: <5fbf4af9-9e6c-3fc7-c021-869e93662845@redhat.com>
Date:   Tue, 5 Apr 2022 15:08:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 023/104] x86/cpu: Add helper functions to
 allocate/free MKTME keyid
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <a1d1e4f26c6ef44a557e873be2818e6a03e12038.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <a1d1e4f26c6ef44a557e873be2818e6a03e12038.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> MKTME keyid is assigned to guest TD.  The memory controller encrypts guest
> TD memory with key id.  Add helper functions to allocate/free MKTME keyid
> so that TDX KVM assign keyid.
> 
> Also export MKTME global keyid that is used to encrypt TDX module and its
> memory.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/tdx.h |  6 ++++++
>   arch/x86/virt/vmx/tdx.c    | 33 ++++++++++++++++++++++++++++++++-
>   2 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 9a8dc6afcb63..73bb472bd515 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -139,6 +139,9 @@ int tdx_detect(void);
>   int tdx_init(void);
>   bool platform_has_tdx(void);
>   const struct tdsysinfo_struct *tdx_get_sysinfo(void);
> +u32 tdx_get_global_keyid(void);
> +int tdx_keyid_alloc(void);
> +void tdx_keyid_free(int keyid);
>   #else
>   static inline void tdx_detect_cpu(struct cpuinfo_x86 *c) { }
>   static inline int tdx_detect(void) { return -ENODEV; }
> @@ -146,6 +149,9 @@ static inline int tdx_init(void) { return -ENODEV; }
>   static inline bool platform_has_tdx(void) { return false; }
>   struct tdsysinfo_struct;
>   static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
> +static inline u32 tdx_get_global_keyid(void) { return 0; };
> +static inline int tdx_keyid_alloc(void) { return -EOPNOTSUPP; }
> +static inline void tdx_keyid_free(int keyid) { }
>   #endif /* CONFIG_INTEL_TDX_HOST */
>   
>   #endif /* !__ASSEMBLY__ */
> diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
> index e45f188479cb..d714106321d4 100644
> --- a/arch/x86/virt/vmx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx.c
> @@ -113,7 +113,13 @@ static int tdx_cmr_num;
>   static struct tdsysinfo_struct tdx_sysinfo;
>   
>   /* TDX global KeyID to protect TDX metadata */
> -static u32 tdx_global_keyid;
> +static u32 __read_mostly tdx_global_keyid;
> +
> +u32 tdx_get_global_keyid(void)
> +{
> +	return tdx_global_keyid;
> +}
> +EXPORT_SYMBOL_GPL(tdx_get_global_keyid);
>   
>   static bool enable_tdx_host;
>   
> @@ -189,6 +195,31 @@ static void detect_seam(struct cpuinfo_x86 *c)
>   		detect_seam_ap(c);
>   }
>   
> +/* TDX KeyID pool */
> +static DEFINE_IDA(tdx_keyid_pool);
> +
> +int tdx_keyid_alloc(void)
> +{
> +	if (WARN_ON_ONCE(!tdx_keyid_start || !tdx_keyid_num))
> +		return -EINVAL;
> +
> +	/* The first keyID is reserved for the global key. */
> +	return ida_alloc_range(&tdx_keyid_pool, tdx_keyid_start + 1,
> +			       tdx_keyid_start + tdx_keyid_num - 1,
> +			       GFP_KERNEL);
> +}
> +EXPORT_SYMBOL_GPL(tdx_keyid_alloc);
> +
> +void tdx_keyid_free(int keyid)
> +{
> +	/* keyid = 0 is reserved. */
> +	if (!keyid || keyid <= 0)
> +		return;
> +
> +	ida_free(&tdx_keyid_pool, keyid);
> +}
> +EXPORT_SYMBOL_GPL(tdx_keyid_free);
> +
>   static void detect_tdx_keyids_bsp(struct cpuinfo_x86 *c)
>   {
>   	u64 keyid_part;

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>


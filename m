Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF96C7C6F83
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 15:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378847AbjJLNoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 09:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343605AbjJLNod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 09:44:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4406BC9
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 06:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697118224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3YeQNCi5I9TqMhLfVG8VlYOgAuXpSTrcqQ3sfxubQaM=;
        b=UW5dTLEieNc5/Pr17cOxrw8f+cyypi0QSoZLDcLsxAEYhq7vcRStRCJTdfEqD5zyWdya0q
        ge8/gseJE2tqqi4KqnuALWIwrjh5ha9dKgO3jrJgaJqEahj6/nqtx9NG0zQNSumF0PNm62
        puOHFG0dGFN6kr5CAvkCRmQu9oktp/M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-tWgr9eC4MH-SNiK40qzABA-1; Thu, 12 Oct 2023 09:43:43 -0400
X-MC-Unique: tWgr9eC4MH-SNiK40qzABA-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5218b9647a8so787573a12.1
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 06:43:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697118221; x=1697723021;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3YeQNCi5I9TqMhLfVG8VlYOgAuXpSTrcqQ3sfxubQaM=;
        b=gHnIxjq4DaEcUGvXEdQ1zx6PSLLoqp8s6KZzgBICxKTJyDEYj3EcQRWVbfGXV209iZ
         /9i/Ft3vUA9L79/j6tBiHp8aF2WCQn0r+FBgxFk88kAlekAHwdyLzmFk/AQpjj1VCdF2
         674AgFftkaT5ll/BwqLyTgRaHBsvfDBMup3vBcmTIEDQMY6rz5urdkU8Mlk9xl1thy64
         6p3LanIEMd5tc22WreMYMf0qLkMcUDNxEq7YRzvdLJSOyux1BA8G8Jg03JoKOQTfEqZx
         EPNwQR0HkmTkDNx2kRD5fIIqnjrUtjzeVIR60NWBL+c7Eg4fvN3C/FwbNk8QsBnVcT6G
         TsLw==
X-Gm-Message-State: AOJu0Yz3Ql09SZ0zdIPGohmLumpJ2XXq+7fiUf7InBfBipLj2DIQTtXQ
        0DTnVqV0OMDG1K6O9v8Hx2+4ZJbsOYYw+5RGxjEKEYQ4zsWyMLXvDK9vASK6x3MVkah7DoYoFIe
        /0IYW1sDt6QWf
X-Received: by 2002:a05:6402:371a:b0:53d:af00:1682 with SMTP id ek26-20020a056402371a00b0053daf001682mr5374478edb.40.1697118221757;
        Thu, 12 Oct 2023 06:43:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYrju74xO7Ncjxi1ob/0f1czuvGBIQLn9BbOM3AmEu++kZS53RZ8hOyqwr78oMVbrKwJ/ffw==
X-Received: by 2002:a05:6402:371a:b0:53d:af00:1682 with SMTP id ek26-20020a056402371a00b0053daf001682mr5374460edb.40.1697118221361;
        Thu, 12 Oct 2023 06:43:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id d5-20020aa7ce05000000b005346a263bb1sm10062063edv.63.2023.10.12.06.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Oct 2023 06:43:40 -0700 (PDT)
Message-ID: <9faf1a1a-af49-5f6f-9f33-6cf57f884c44@redhat.com>
Date:   Thu, 12 Oct 2023 15:43:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] kvm/sev: remove redundant MISC_CG_RES_SEV_ES
Content-Language: en-US
To:     =?UTF-8?Q?Jos=c3=a9_Pekkarinen?= <jose.pekkarinen@foxhound.fi>,
        seanjc@google.com, skhan@linuxfoundation.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20231010174932.29769-1-jose.pekkarinen@foxhound.fi>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20231010174932.29769-1-jose.pekkarinen@foxhound.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/23 19:49, José Pekkarinen wrote:
> SEV-ES is an extra encrypted state that shares common resources
> with SEV. Using an extra CG for its purpose doesn't seem to
> provide much value. This patch will clean up the control group
> along with multiple checks that become redundant with it.
> 
> The patch will also remove a redundant logic on sev initialization
> that produces SEV-ES to be disabled, while supported by the cpu
> and requested by the user through the sev_es parameter.

In what sense is it shared?  The SEV ASIDs and the SEV-ES ASIDs are 
separate (and in both cases limited) resources, and therefore they have 
separate cgroups.

Paolo

> Signed-off-by: José Pekkarinen<jose.pekkarinen@foxhound.fi>
> ---
>   arch/x86/kvm/svm/sev.c      | 18 +++---------------
>   include/linux/misc_cgroup.h |  2 --
>   2 files changed, 3 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 07756b7348ae..8a06d92187cf 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -37,13 +37,9 @@
>    * this file are not used but this file still gets compiled into the KVM AMD
>    * module.
>    *
> - * We will not have MISC_CG_RES_SEV and MISC_CG_RES_SEV_ES entries in the enum
> - * misc_res_type {} defined in linux/misc_cgroup.h.
> - *
>    * Below macros allow compilation to succeed.
>    */
>   #define MISC_CG_RES_SEV MISC_CG_RES_TYPES
> -#define MISC_CG_RES_SEV_ES MISC_CG_RES_TYPES
>   #endif
>   
>   #ifdef CONFIG_KVM_AMD_SEV
> @@ -125,13 +121,13 @@ static bool __sev_recycle_asids(int min_asid, int max_asid)
>   
>   static int sev_misc_cg_try_charge(struct kvm_sev_info *sev)
>   {
> -	enum misc_res_type type = sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
> +	enum misc_res_type type = MISC_CG_RES_SEV;
>   	return misc_cg_try_charge(type, sev->misc_cg, 1);
>   }
>   
>   static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
>   {
> -	enum misc_res_type type = sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
> +	enum misc_res_type type = MISC_CG_RES_SEV;
>   	misc_cg_uncharge(type, sev->misc_cg, 1);
>   }
>   
> @@ -2167,7 +2163,7 @@ void __init sev_set_cpu_caps(void)
>   void __init sev_hardware_setup(void)
>   {
>   #ifdef CONFIG_KVM_AMD_SEV
> -	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
> +	unsigned int eax, ebx, ecx, edx, sev_asid_count;
>   	bool sev_es_supported = false;
>   	bool sev_supported = false;
>   
> @@ -2236,14 +2232,7 @@ void __init sev_hardware_setup(void)
>   	if (!boot_cpu_has(X86_FEATURE_SEV_ES))
>   		goto out;
>   
> -	/* Has the system been allocated ASIDs for SEV-ES? */
> -	if (min_sev_asid == 1)
> -		goto out;
> -
> -	sev_es_asid_count = min_sev_asid - 1;
> -	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
>   	sev_es_supported = true;
> -
>   out:
>   	if (boot_cpu_has(X86_FEATURE_SEV))
>   		pr_info("SEV %s (ASIDs %u - %u)\n",
> @@ -2271,7 +2260,6 @@ void sev_hardware_unsetup(void)
>   	bitmap_free(sev_reclaim_asid_bitmap);
>   
>   	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
> -	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
>   }
>   
>   int sev_cpu_init(struct svm_cpu_data *sd)
> diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
> index c238207d1615..23d3cd153f60 100644
> --- a/include/linux/misc_cgroup.h
> +++ b/include/linux/misc_cgroup.h
> @@ -15,8 +15,6 @@ enum misc_res_type {
>   #ifdef CONFIG_KVM_AMD_SEV
>   	/* AMD SEV ASIDs resource */
>   	MISC_CG_RES_SEV,
> -	/* AMD SEV-ES ASIDs resource */
> -	MISC_CG_RES_SEV_ES,
>   #endif
>   	MISC_CG_RES_TYPES
>   };
> -- 


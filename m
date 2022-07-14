Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6595749D8
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 11:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237883AbiGNJ5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 05:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiGNJ5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 05:57:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C9AF50040
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 02:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657792642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=due5AmS56nwKHQURWRio6Jj0V5YHWUHW3moonKZbp+k=;
        b=XbjtAppqdL0Rn9G17Soll7jGZSA4lg7LvjagYZgXvoKLBxbxrDOCUeTFFu7DkyEqoZVAi3
        8mkZiOMfgSOxUXmFBAFUR4RGhX6tcyAmNPXDoB/nYT+vtQG/kH8FpYfh/OfJ83v3p31JTD
        7n3jEcfsEnSqFZ2petpUn3eOu/SYpuc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-vRNTPLUdOt2R2n0NO-Vo6w-1; Thu, 14 Jul 2022 05:57:18 -0400
X-MC-Unique: vRNTPLUdOt2R2n0NO-Vo6w-1
Received: by mail-wm1-f70.google.com with SMTP id 23-20020a05600c229700b003a2eda0c59cso529982wmf.7
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 02:57:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=due5AmS56nwKHQURWRio6Jj0V5YHWUHW3moonKZbp+k=;
        b=ZLeIu2cu3l/cMq+7SD1roF5QLkm5h2BvrupFFkmgDCWSakBCWRkef21GRETW8zyEHp
         GlBToM/Az/LvzIHhA4AKiKod9S/Xf37AM4S4yLmT+ASWywqq8IvGAiIFVkqhkR7obXti
         hM8vwuO/cmrLcvk1vbNpWFEf/ZtNtB1FwbmiXGppUGQX0apjS/YkeZtOoFSCKyfnQLEw
         b5ECfyQivzVcls98IUhJTeJcrTzVMcJNEOqBxMC5gJP7b0wnyl2CVm4yhvdmjsAqmF0t
         CyQO/WuQVjEQZ0QdKGRA6qt7f09KBlb3QeHFNfyxkANvYvpAZL07p1xVXI8O9kHUett2
         LuxQ==
X-Gm-Message-State: AJIora+v9w8x7Wza8E8dBdpkiH5oJg9DDdVlqGliC4TMJvCYiPN0LSk1
        wiiJ/aVYp2SOnrDyfZGmPCJp9CZXNAVg2b/4eGg8bdWEUB1EuE77gpCCe5XLIhRHpj+Vxklza+r
        p8eo00if25H99
X-Received: by 2002:a5d:6e8d:0:b0:21d:7adc:7102 with SMTP id k13-20020a5d6e8d000000b0021d7adc7102mr7322826wrz.9.1657792637714;
        Thu, 14 Jul 2022 02:57:17 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1thfI/HeBALlz1MpWK7X8M2igq3/FhpwNnjJ1ZYgqajB1pTOb1ykpm1uWMRTuBXxCFL8QuxDg==
X-Received: by 2002:a5d:6e8d:0:b0:21d:7adc:7102 with SMTP id k13-20020a5d6e8d000000b0021d7adc7102mr7322802wrz.9.1657792637491;
        Thu, 14 Jul 2022 02:57:17 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id o12-20020adfca0c000000b0021dbaa4f38dsm1287018wrh.18.2022.07.14.02.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 02:57:16 -0700 (PDT)
Message-ID: <aff0dd9ba5d5730435a92e6a90dc15bb6eae5977.camel@redhat.com>
Subject: Re: [PATCH v4 03/25] x86/hyperv: Update 'struct
 hv_enlightened_vmcs' definition
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 14 Jul 2022 12:57:15 +0300
In-Reply-To: <20220714091327.1085353-4-vkuznets@redhat.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
         <20220714091327.1085353-4-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-14 at 11:13 +0200, Vitaly Kuznetsov wrote:
> Updated Hyper-V Enlightened VMCS specification lists several new
> fields for the following features:
> 
> - PerfGlobalCtrl
> - EnclsExitingBitmap
> - Tsc Scaling
> - GuestLbrCtl
> - CET
> - SSP
> 
> Update the definition. The updated definition is available only when
> CPUID.0x4000000A.EBX BIT(0) is '1'. Add a define for it as well.
> 
> Note: The latest TLFS is available at
> https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/tlfs
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index 6f0acc45e67a..ebc27017fa48 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -138,6 +138,17 @@
>  #define HV_X64_NESTED_GUEST_MAPPING_FLUSH              BIT(18)
>  #define HV_X64_NESTED_MSR_BITMAP                       BIT(19)
>  
> +/*
> + * Nested quirks. These are HYPERV_CPUID_NESTED_FEATURES.EBX bits.
> + *
> + * Note: HV_X64_NESTED_EVMCS1_2022_UPDATE is not currently documented in any
> + * published TLFS version. When the bit is set, nested hypervisor can use
> + * 'updated' eVMCSv1 specification (perf_global_ctrl, s_cet, ssp, lbr_ctl,
> + * encls_exiting_bitmap, tsc_multiplier fields which were missing in 2016
> + * specification).
> + */
> +#define HV_X64_NESTED_EVMCS1_2022_UPDATE               BIT(0)
> +
>  /*
>   * This is specific to AMD and specifies that enlightened TLB flush is
>   * supported. If guest opts in to this feature, ASID invalidations only
> @@ -559,9 +570,20 @@ struct hv_enlightened_vmcs {
>         u64 partition_assist_page;
>         u64 padding64_4[4];
>         u64 guest_bndcfgs;
> -       u64 padding64_5[7];
> +       u64 guest_ia32_perf_global_ctrl;
> +       u64 guest_ia32_s_cet;
> +       u64 guest_ssp;
> +       u64 guest_ia32_int_ssp_table_addr;
> +       u64 guest_ia32_lbr_ctl;
> +       u64 padding64_5[2];
>         u64 xss_exit_bitmap;
> -       u64 padding64_6[7];
> +       u64 encls_exiting_bitmap;
> +       u64 host_ia32_perf_global_ctrl;
> +       u64 tsc_multiplier;
> +       u64 host_ia32_s_cet;
> +       u64 host_ssp;
> +       u64 host_ia32_int_ssp_table_addr;
> +       u64 padding64_6;
>  } __packed;
>  
>  #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE                    0

All look good now.

I really don't like the new 'online' TLFS spec - as you said,
they can indeed change it any moment without any traces.

Seems it was done with good intentions, and it much easier to use,
but they should also provide a PDF, or at least some form or archive of
these web pages.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



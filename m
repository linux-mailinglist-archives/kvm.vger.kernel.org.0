Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE9159875E
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 17:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344286AbiHRPWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 11:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343621AbiHRPWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 11:22:19 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B22476770
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 08:22:04 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id h28so1819390pfq.11
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 08:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=rhQW8wtozjWF3HGibH/hmWhRxd+6MVNHu/SAHJnuLEc=;
        b=f6//pOErDLPHd1qSNJ6w7EtZZP4/zk0eXgK/NqZ4rp9ZIZ9+nXwDrJL8Yw2ms9c4V+
         q5IpxVxScLGFYwKqNz+zjrAkdGx86VokP+XBDEn3iZMSTHDeWgpPDWnatT0RQafS0goZ
         OkVfnHhwCLHp4BN/vYZMDsL/sIn3BIWsrhlQIyf8K0FcVZt0oMlX02n6UqFB5UchDYLt
         6mcNkn95UkGiGa2/3E8bNMO4mRpXGtk2zDC6ptlHJ6PUyZhWvOS0tz7ekEljcsa0gkBu
         2dupBQln9wtns+ZxbM8UNXKtUBprK8Zla5FoFoCNBUJT2XL2sBXHcsYKq2Yr541a+TD6
         HxuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=rhQW8wtozjWF3HGibH/hmWhRxd+6MVNHu/SAHJnuLEc=;
        b=E2gfIp6Ff2nua8VibMpftetpEYdEK98krzhpNOzdlZ2qF/pBd/eDM5AnjjRPRV1pRP
         /vy1fVutxBPiN2xOyShBD721lfRsoegIP7u8nq2+3T2boCzNTaoB88/PQvHN2+2WK7Z3
         tCKirjOE15cntjMnU+C+n8m579vKeviWEkP59zLVbJZ1M/VcQle3VPpBSJYX8tgcnoBe
         6RdDIv3YMH1neW+zLlo3+1iVJ4qCDSuQ8EDfjmsqgM6gURcv7zVWdXSBayBFcM1y09dF
         Asa6mntAF3U6R4mPvgKbebmHxOnZYOxw+HUJGOHCXlmXJWUhKbTyu71meHJR0wK9yigB
         pxZQ==
X-Gm-Message-State: ACgBeo3MnJ1jJ+3LiiaeYCAFroQULw5ZhKR4SULYZ6GpWRkNjU7Q/3pq
        EojO7q4SmbCrehppfCXCNeoUYg==
X-Google-Smtp-Source: AA6agR5vNg4AZiDCWVBlsHoSfs5B2gPrwRDzidwiEq69ooGPNnoP7C38ZuFXqwZu2MlDx6G13n/pJw==
X-Received: by 2002:a63:f003:0:b0:429:fde8:4992 with SMTP id k3-20020a63f003000000b00429fde84992mr2676470pgh.134.1660836122834;
        Thu, 18 Aug 2022 08:22:02 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n11-20020a63a50b000000b0041c8e489cc2sm1423692pgf.19.2022.08.18.08.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 08:22:02 -0700 (PDT)
Date:   Thu, 18 Aug 2022 15:21:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/26] x86/hyperv: Update 'struct hv_enlightened_vmcs'
 definition
Message-ID: <Yv5ZFgztDHzzIQJ+@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802160756.339464-4-vkuznets@redhat.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
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
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index 6f0acc45e67a..ebc27017fa48 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -138,6 +138,17 @@
>  #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
>  #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
>  
> +/*
> + * Nested quirks. These are HYPERV_CPUID_NESTED_FEATURES.EBX bits.

The "quirks" part is very confusing, largely because KVM has a well-established
quirks mechanism.  I also don't see "quirks" anywhere in the TLFS documentation.
Can the "Nested quirks" part simply be dropped?

> + *
> + * Note: HV_X64_NESTED_EVMCS1_2022_UPDATE is not currently documented in any
> + * published TLFS version. When the bit is set, nested hypervisor can use
> + * 'updated' eVMCSv1 specification (perf_global_ctrl, s_cet, ssp, lbr_ctl,
> + * encls_exiting_bitmap, tsc_multiplier fields which were missing in 2016
> + * specification).
> + */
> +#define HV_X64_NESTED_EVMCS1_2022_UPDATE		BIT(0)

This bit is now defined[*], but the docs says it's only for perf_global_ctrl.  Are
we expecting an update to the TLFS?

	Indicates support for the GuestPerfGlobalCtrl and HostPerfGlobalCtrl fields
	in the enlightened VMCS.

[*] https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/feature-discovery#hypervisor-nested-virtualization-features---0x4000000a

> +
>  /*
>   * This is specific to AMD and specifies that enlightened TLB flush is
>   * supported. If guest opts in to this feature, ASID invalidations only
> @@ -559,9 +570,20 @@ struct hv_enlightened_vmcs {
>  	u64 partition_assist_page;
>  	u64 padding64_4[4];
>  	u64 guest_bndcfgs;
> -	u64 padding64_5[7];
> +	u64 guest_ia32_perf_global_ctrl;
> +	u64 guest_ia32_s_cet;
> +	u64 guest_ssp;
> +	u64 guest_ia32_int_ssp_table_addr;
> +	u64 guest_ia32_lbr_ctl;
> +	u64 padding64_5[2];
>  	u64 xss_exit_bitmap;
> -	u64 padding64_6[7];
> +	u64 encls_exiting_bitmap;
> +	u64 host_ia32_perf_global_ctrl;
> +	u64 tsc_multiplier;
> +	u64 host_ia32_s_cet;
> +	u64 host_ssp;
> +	u64 host_ia32_int_ssp_table_addr;
> +	u64 padding64_6;
>  } __packed;
>  
>  #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE			0
> -- 
> 2.35.3
> 

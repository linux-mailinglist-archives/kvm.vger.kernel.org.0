Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538BD59877E
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 17:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344370AbiHRP3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 11:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344357AbiHRP3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 11:29:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F9D267D
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 08:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660836567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BsS/ws8PW+id0ON/BYeR+QEPGH6otJZmVRxUjUdHJZw=;
        b=hPvQgm2Qv/A04sDb7q9i/kXeoIsTzXSiFF33izE22pTvYN2/Q5jLu4MX+ztI8qBv2dlZG/
        NvGjNLVcRvuqJxbUakSmp3nPNj20CYp/6whDKHRc7tQp5gqI+RBNXAdLOJ0OJnwjrw8CWI
        iE2OQBKb82xgNpOvJtDPd4TJw3Yb8yA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-518-IlcTwzK7PeSe1rhr1RuR8A-1; Thu, 18 Aug 2022 11:29:26 -0400
X-MC-Unique: IlcTwzK7PeSe1rhr1RuR8A-1
Received: by mail-ed1-f69.google.com with SMTP id y16-20020a056402359000b0043db5186943so1153243edc.3
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 08:29:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=BsS/ws8PW+id0ON/BYeR+QEPGH6otJZmVRxUjUdHJZw=;
        b=RUXlBETHFWLcHksvp4p7e8stYfUjy9w7fbH+ctXXRR1zDp9qzbcnvIAWdV1dt1dTr0
         w9+yZw0JDY7idqU9DXYQJ2LxcqPvxq0fd7nRwBOaVcva+aglGJzZBD1JUWRKqU6Dul90
         eTv9WdX76OoILkeG2od+aRKd7XAZr8J8Sjs7BuFL1D5AeXvwIPqy/zOqR0AbJ6Hnc6qN
         jXcR6cKhUduzibq4m0mnMsJ3wpAVSceDgPTNU5/a6+kNiNPTT7okbI/z3J9cisGEuoNd
         KW49MO7VXNbMUEUNCOMeX3HF1Nnm1KFa5RrKFYjpDMf5EfNUhiovgX9YXB/vz48NRa0d
         qanQ==
X-Gm-Message-State: ACgBeo3lSQAoy1C5C4vN3CL6H1e+26gWVIb+Z3yDo+GlCJbclK492PFJ
        03oElC8+ditqwQYnS/tjywxZPWZZeki7DmBap+6PzqbQIU0jAdzwPp5LKERvlLeyiTJasJd/YP9
        HOTC+BKSX5F2Q
X-Received: by 2002:a17:906:8cb0:b0:739:4c35:75d8 with SMTP id qr48-20020a1709068cb000b007394c3575d8mr2143919ejc.711.1660836565362;
        Thu, 18 Aug 2022 08:29:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6ASJ7PrAhP1AxtzslI2uK+cdyhUoC0lq1YKdkkov99E4p7dL/Ue1WdJx9EeNbvpu3Z5stuxQ==
X-Received: by 2002:a17:906:8cb0:b0:739:4c35:75d8 with SMTP id qr48-20020a1709068cb000b007394c3575d8mr2143910ejc.711.1660836565158;
        Thu, 18 Aug 2022 08:29:25 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id e9-20020a056402330900b0043af8007e7fsm1355944eda.3.2022.08.18.08.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 08:29:24 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/26] x86/hyperv: Update 'struct
 hv_enlightened_vmcs' definition
In-Reply-To: <Yv5ZFgztDHzzIQJ+@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-4-vkuznets@redhat.com>
 <Yv5ZFgztDHzzIQJ+@google.com>
Date:   Thu, 18 Aug 2022 17:29:23 +0200
Message-ID: <875yiptvsc.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
>> Updated Hyper-V Enlightened VMCS specification lists several new
>> fields for the following features:
>> 
>> - PerfGlobalCtrl
>> - EnclsExitingBitmap
>> - Tsc Scaling
>> - GuestLbrCtl
>> - CET
>> - SSP
>> 
>> Update the definition. The updated definition is available only when
>> CPUID.0x4000000A.EBX BIT(0) is '1'. Add a define for it as well.
>> 
>> Note: The latest TLFS is available at
>> https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/tlfs
>> 
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/include/asm/hyperv-tlfs.h | 26 ++++++++++++++++++++++++--
>>  1 file changed, 24 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
>> index 6f0acc45e67a..ebc27017fa48 100644
>> --- a/arch/x86/include/asm/hyperv-tlfs.h
>> +++ b/arch/x86/include/asm/hyperv-tlfs.h
>> @@ -138,6 +138,17 @@
>>  #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
>>  #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
>>  
>> +/*
>> + * Nested quirks. These are HYPERV_CPUID_NESTED_FEATURES.EBX bits.
>
> The "quirks" part is very confusing, largely because KVM has a well-established
> quirks mechanism.  I also don't see "quirks" anywhere in the TLFS documentation.
> Can the "Nested quirks" part simply be dropped?
>

Yes, it's completely made up (just like I made up
HV_X64_NESTED_EVMCS1_2022_UPDATE), let's drop it.

>> + *
>> + * Note: HV_X64_NESTED_EVMCS1_2022_UPDATE is not currently documented in any
>> + * published TLFS version. When the bit is set, nested hypervisor can use
>> + * 'updated' eVMCSv1 specification (perf_global_ctrl, s_cet, ssp, lbr_ctl,
>> + * encls_exiting_bitmap, tsc_multiplier fields which were missing in 2016
>> + * specification).
>> + */
>> +#define HV_X64_NESTED_EVMCS1_2022_UPDATE		BIT(0)
>
> This bit is now defined[*], but the docs says it's only for perf_global_ctrl.  Are
> we expecting an update to the TLFS?
>
> 	Indicates support for the GuestPerfGlobalCtrl and HostPerfGlobalCtrl fields
> 	in the enlightened VMCS.
>
> [*] https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/feature-discovery#hypervisor-nested-virtualization-features---0x4000000a
>

Oh well, better this than nothing. I'll ping the people who told me
about this bit that their description is incomplete.

>> +
>>  /*
>>   * This is specific to AMD and specifies that enlightened TLB flush is
>>   * supported. If guest opts in to this feature, ASID invalidations only
>> @@ -559,9 +570,20 @@ struct hv_enlightened_vmcs {
>>  	u64 partition_assist_page;
>>  	u64 padding64_4[4];
>>  	u64 guest_bndcfgs;
>> -	u64 padding64_5[7];
>> +	u64 guest_ia32_perf_global_ctrl;
>> +	u64 guest_ia32_s_cet;
>> +	u64 guest_ssp;
>> +	u64 guest_ia32_int_ssp_table_addr;
>> +	u64 guest_ia32_lbr_ctl;
>> +	u64 padding64_5[2];
>>  	u64 xss_exit_bitmap;
>> -	u64 padding64_6[7];
>> +	u64 encls_exiting_bitmap;
>> +	u64 host_ia32_perf_global_ctrl;
>> +	u64 tsc_multiplier;
>> +	u64 host_ia32_s_cet;
>> +	u64 host_ssp;
>> +	u64 host_ia32_int_ssp_table_addr;
>> +	u64 padding64_6;
>>  } __packed;
>>  
>>  #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE			0
>> -- 
>> 2.35.3
>> 
>

-- 
Vitaly


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C6C54B054
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 14:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356889AbiFNMMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 08:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356909AbiFNMMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 08:12:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9DF7320D
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 05:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655208735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d25xRoBQKRAgDG7iS47n8JHMGxyJKkyKtJs+59Z9jLk=;
        b=Y1QNMh9YnpZZBh00BI+fx7HuE5jUpfyNFNWiOfQcaIlQ1I7toSNCkfMp6BPlZuiX9wc+fL
        4fpNcoK6DD7mvZIDBmkRSHMVPFUGgoYWZC8dK6rlE5Yad8tuoCwa1xaBbe5G5Arxx2F3eA
        nBkyR/XSwNO1DcrAOWMT//lMpoiyXJY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-DtGkXNEBMneSzNwu0oJnJw-1; Tue, 14 Jun 2022 08:12:14 -0400
X-MC-Unique: DtGkXNEBMneSzNwu0oJnJw-1
Received: by mail-ed1-f69.google.com with SMTP id g8-20020a056402090800b00433940d207eso6087415edz.1
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 05:12:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=d25xRoBQKRAgDG7iS47n8JHMGxyJKkyKtJs+59Z9jLk=;
        b=GkosXvDV8vZLPiPcvmcPzUhayLdLPUIBmTO/vFHnjK8FumWQnRiy3QJrOxGuaD0r2X
         5gH2rD5UJaHoXRx6T4Yf0OmQC5zxyMQziJ1NuUbkNjUvtkI1ErXf8NldaPzgZ9EzBzJ9
         Eq4M+kjbYJozZci0dWnKCyQ+A5TxZiT6OuKBuKop5ZLj53zBqAk+okVK30epT9bhYVhD
         XHrolyZvxQigSM6OhPz43AUKFJxtPb3oxctZIuQrv2cNpI8IF8COotGHWjVBuKb9eHAE
         xiH8P/wt3BBhk8Uqd9m6ah4vFY7Qij4kwJseGemle5nyG2mDIQ1xTSKYXIsJIv1kLG6A
         pgVQ==
X-Gm-Message-State: AJIora9NXfNR18lV39Adkz98A3RCEY4QqhLPCnBMdN7czPa+mz3q4bsg
        XYwF2QJ4svo5pU52rmls8iEOYUW6fJBD8zV82RA12QE+CbEG1TOr0KKCvjVW9POSEqfN7aUTWVR
        Ncgd0KCpzpuiN
X-Received: by 2002:a17:906:6a1a:b0:711:ec13:b7bc with SMTP id qw26-20020a1709066a1a00b00711ec13b7bcmr3968837ejc.688.1655208733240;
        Tue, 14 Jun 2022 05:12:13 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vwaLRxXVn7myO45bdvHsZKXRkI9DCKejCwsiPHmTwtfJ4ri3r55aSyki+hrnXTHrc4Vxdijw==
X-Received: by 2002:a17:906:6a1a:b0:711:ec13:b7bc with SMTP id qw26-20020a1709066a1a00b00711ec13b7bcmr3968803ejc.688.1655208732976;
        Tue, 14 Jun 2022 05:12:12 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j10-20020a50d00a000000b004319b12371asm7035004edf.47.2022.06.14.05.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:12:12 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Cc:     mail@anirudhrb.com, kumarpraveen@linux.microsoft.com,
        wei.liu@kernel.org, robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
In-Reply-To: <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
Date:   Tue, 14 Jun 2022 14:12:11 +0200
Message-ID: <87v8t3igv8.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 6/13/22 18:16, Anirudh Rayabharam wrote:
>> +	if (!kvm_has_tsc_control)
>> +		msrs->secondary_ctls_high &= ~SECONDARY_EXEC_TSC_SCALING;
>> +
>>   	msrs->secondary_ctls_low = 0;
>>   	msrs->secondary_ctls_high &=
>>   		SECONDARY_EXEC_DESC |
>> @@ -6667,8 +6670,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>>   		SECONDARY_EXEC_RDRAND_EXITING |
>>   		SECONDARY_EXEC_ENABLE_INVPCID |
>>   		SECONDARY_EXEC_RDSEED_EXITING |
>> -		SECONDARY_EXEC_XSAVES |
>> -		SECONDARY_EXEC_TSC_SCALING;
>> +		SECONDARY_EXEC_XSAVES;
>>   
>>   	/*
>
> This is wrong because it _always_ disables SECONDARY_EXEC_TSC_SCALING,
> even if kvm_has_tsc_control == true.
>
> That said, I think a better implementation of this patch is to just add
> a version of evmcs_sanitize_exec_ctrls that takes a struct
> nested_vmx_msrs *, and call it at the end of nested_vmx_setup_ctl_msrs like
>
> 	evmcs_sanitize_nested_vmx_vsrs(msrs);
>
> Even better (but I cannot "mentally test it" offhand) would be just
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e802f71a9e8d..b3425ce835c5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1862,7 +1862,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		 * sanity checking and refuse to boot. Filter all unsupported
>   		 * features out.
>   		 */
> -		if (!msr_info->host_initiated &&
> +		if (static_branch_unlikely(&enable_evmcs) ||
>   		    vmx->nested.enlightened_vmcs_enabled)
>   			nested_evmcs_filter_control_msr(msr_info->index,
>   							&msr_info->data);
>
> I cannot quite understand the host_initiated check, so I'll defer to
> Vitaly on why it is needed. Most likely, removing it would cause some
> warnings in QEMU with e.g. "-cpu Haswell,+vmx"; but I think it's a
> userspace bug and we should remove that part of the condition. 

I forgot the details, of course, but 31de3d2500e4 says:

```
    With fine grained VMX feature enablement QEMU>=4.2 tries to do KVM_SET_MSRS
    with default (matching CPU model) values and in case eVMCS is also enabled,
    fails.
```

so it certainly was a workaround for QEMU.

-- 
Vitaly


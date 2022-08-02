Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0D0587CAB
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 14:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbiHBMxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 08:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiHBMxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 08:53:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22B1614D0A
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 05:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659444780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5ikm4kV/UdS8r7b2LACfyNidZ5DHXkyUZcz44yJZqUQ=;
        b=jQedbfTF9mHdZE+XopWO7fc/gAs0fvr+jaFTZ1Fac069gF2zVEoe+1wne4y8SVHD9p//vN
        EY2kBed9M5z+NHE/1wPgaDfxwaEdv0sqrGM1SWsaIx7/tyoxRINNYpp3fSJEd6Cwu8Xb/4
        Gln67NeBnlsTptOkFGVqCBqZj2LJceU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-M7_CmAL6OtadxLYBqMf0Pw-1; Tue, 02 Aug 2022 08:52:58 -0400
X-MC-Unique: M7_CmAL6OtadxLYBqMf0Pw-1
Received: by mail-wm1-f72.google.com with SMTP id i131-20020a1c3b89000000b003a4f0932ec3so1047wma.0
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 05:52:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5ikm4kV/UdS8r7b2LACfyNidZ5DHXkyUZcz44yJZqUQ=;
        b=ja94p4VOBvryq7t5uwJANtx0bqXg/Ug67LOVdNLgF9CgC5LbHJmCnxLXWyFn2fRCPj
         /J50S3ydI1MPj1ZlNMGG4Sh39D8AkpOaAmD9hmPuDXdWfHG6iBCIb8kghFVwad83H5bj
         kV2seEEk0Jh8iriGA0bp3zB4l3BiyFZoFFPnT3j5w9G4sB1/8dL2Txszkn8VuFpE8yM4
         pk0rewFcFpm1t/A0BJ8mQ0Ei3UYekmsrvlolJFDZPdvVw0nblisHRUCypypmDHM2rVS3
         Q5Zv1PLLBvsVwe/TP/Xh3hD6qS+2BnpBLjc0ueHJnQOMYXJkNSbNkoifoRIzMHRH+3eC
         UOPg==
X-Gm-Message-State: ACgBeo21bEZCtSPsv/Br0k0As8q1zgcKwAuYqpB6LfD/N7klpA10WWaU
        Bum4N9hzimZsOoQXsVya2v6i1syzM1hFt5ZjW15um+LDkb5Lz4GwKZUuwqU/oZbhrGqw1iJ32ag
        mF0Pi7n+gPox9
X-Received: by 2002:adf:efc3:0:b0:21f:15aa:1b40 with SMTP id i3-20020adfefc3000000b0021f15aa1b40mr11167761wrp.159.1659444777642;
        Tue, 02 Aug 2022 05:52:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR53vslDjhAhACNp2Z0SdysXb8V4ku9F/Q9BfjcKTCX8Mhagp7O22Wv6hJv6kZKMItFdg5F7vg==
X-Received: by 2002:adf:efc3:0:b0:21f:15aa:1b40 with SMTP id i3-20020adfefc3000000b0021f15aa1b40mr11167735wrp.159.1659444777341;
        Tue, 02 Aug 2022 05:52:57 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ba4-20020a0560001c0400b002205f0890eesm8621527wrb.77.2022.08.02.05.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 05:52:56 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 14/25] KVM: VMX: Tweak the special handling of
 SECONDARY_EXEC_ENCLS_EXITING in setup_vmcs_config()
In-Reply-To: <YtnPEem7q1i+4VBN@google.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-15-vkuznets@redhat.com>
 <YtnPEem7q1i+4VBN@google.com>
Date:   Tue, 02 Aug 2022 14:52:55 +0200
Message-ID: <87o7x224ew.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
>> SECONDARY_EXEC_ENCLS_EXITING is conditionally added to the 'optional'
>> checklist in setup_vmcs_config() but there's little value in doing so.
>> First, as the control is optional, we can always check for its
>> presence, no harm done. Second, the only real value cpu_has_sgx() check
>> gives is that on the CPUs which support SECONDARY_EXEC_ENCLS_EXITING but
>> don't support SGX, the control is not getting enabled. It's highly unlikely
>> such CPUs exist but it's possible that some hypervisors expose broken vCPU
>> models.
>
> It's not just broken vCPU models, SGX can be "soft-disabled" on bare metal, e.g. if
> software writes MCE control MSRs or there's an uncorrectable #MC (may not be the
> case on all platforms).  This is architectural behavior and needs to be handled in
> KVM.  Obviously if SGX gets disabled after KVM is loaded then we're out of luck, but
> having the ENCL-exiting control without SGX being enabled is 100% valid.
>
> As for why KVM bothers with the check, it's to work around a suspected hardware
> or XuCode bug (I'm still a bit shocked that's public now :-) ) where SGX got
> _hard_ disabled across S3 on some CPUs and made the fields magically disappear.
> The workaround was to soft-disable SGX in BIOS so that KVM wouldn't attempt to
> enable the ENCLS-exiting control

Oh, thanks for this insight, I had no idea! I'll adjust my commit
message accordingly.

>
>> Preserve cpu_has_sgx() check but filter the result of adjust_vmx_controls()
>> instead of the input.
>> 
>> Reviewed-by: Jim Mattson <jmattson@google.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/vmx/vmx.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index ce54f13d8da1..566be73c6509 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2528,9 +2528,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>  			SECONDARY_EXEC_PT_CONCEAL_VMX |
>>  			SECONDARY_EXEC_ENABLE_VMFUNC |
>>  			SECONDARY_EXEC_BUS_LOCK_DETECTION |
>> -			SECONDARY_EXEC_NOTIFY_VM_EXITING;
>> -		if (cpu_has_sgx())
>> -			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
>> +			SECONDARY_EXEC_NOTIFY_VM_EXITING |
>> +			SECONDARY_EXEC_ENCLS_EXITING;
>> +
>>  		if (adjust_vmx_controls(min2, opt2,
>>  					MSR_IA32_VMX_PROCBASED_CTLS2,
>>  					&_cpu_based_2nd_exec_control) < 0)
>> @@ -2577,6 +2577,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>  		vmx_cap->vpid = 0;
>>  	}
>>  
>> +	if (!cpu_has_sgx())
>> +		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_ENCLS_EXITING;
>> +
>>  	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
>>  		u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
>>  
>> -- 
>> 2.35.3
>> 
>

-- 
Vitaly


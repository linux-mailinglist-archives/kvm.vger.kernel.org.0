Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494CC5FC581
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 14:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiJLMlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 08:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiJLMk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 08:40:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6B0C7065
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 05:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665578456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V4PET4IVn842CPc9kqbnyaF1hjwBFJjyklLZTxjKQUA=;
        b=cEdIzSqj89K9qTNwSVV+BCmxfhuyI7kYhFPbOB0DLHA16ChxGClV9o70+ttcHHrdj33j1b
        N/NjI9ZubK2NXwJmhfebX1kl/KcKL1WgVhEaQn3k9jvfJD6pOskysMBEM5YY10fzgFUDrS
        lRdwMgIDJTPUehfexB3K9FxQrC7Kw5c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-562-s27sPheqPxO9ZQRxEqw3bQ-1; Wed, 12 Oct 2022 08:40:55 -0400
X-MC-Unique: s27sPheqPxO9ZQRxEqw3bQ-1
Received: by mail-wr1-f70.google.com with SMTP id r4-20020adfbb04000000b0022e5ec02713so4956751wrg.18
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 05:40:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V4PET4IVn842CPc9kqbnyaF1hjwBFJjyklLZTxjKQUA=;
        b=k8oNqZgl7S4FElIsdx8QEhNkOl8zVC1WHtu1yLsxIfFbw7Fry1WCGtczfPNZiw4SzP
         L/ySadZBMxer/yCkz0nR3k6/ruHFPrVdICkiBI+iSNYBuijBDp7pCpf7riD9FPxXg526
         PeD3RjxdbT/i9fvydloV/gmuu95pQpBvDodU36YfxBdPlhaCwS7JVZECgQnKC+iwAeXz
         Gwbdwkfm43BGLS0Tu+R8Fx5zbHMxtm9W6mjsVgRURuIkd9yetEl9RglEckqTAFRAOLke
         HszJ9yqG5btvOlniT/vSCMGnimTuB3/qAYGm/UuIHx6RR0lVXFdX/PF4+Vv5xWVm5uBB
         fvOw==
X-Gm-Message-State: ACrzQf0S0xB+tW9l+wU7l33vHrYNC3CdE4atVMgXgxXZRDaUytedBxg/
        vSFHp5yjz1ZbgCEO/7mXnS6UmUpW5jwqjpWjM2elKmyuoKtbPBIEf9bleJvBjuAomu/wBeK9Jui
        oVjWKVElHz3Ff
X-Received: by 2002:adf:f301:0:b0:22e:4479:c1ba with SMTP id i1-20020adff301000000b0022e4479c1bamr18010295wro.133.1665578454615;
        Wed, 12 Oct 2022 05:40:54 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7qIVCyeWKildFEGP/RIqDFvG6GG0zeSXyIH6WUGqkiQOJh0eBqGfO3EEFyhJ9XcwTTzGqZVQ==
X-Received: by 2002:adf:f301:0:b0:22e:4479:c1ba with SMTP id i1-20020adff301000000b0022e4479c1bamr18010278wro.133.1665578454345;
        Wed, 12 Oct 2022 05:40:54 -0700 (PDT)
Received: from ovpn-194-196.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g17-20020a05600c001100b003c6bbe910fdsm2079979wmc.9.2022.10.12.05.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 05:40:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/6] KVM: selftests: Test Hyper-V invariant TSC control
In-Reply-To: <Y0XGuk4vwJBTU9oN@google.com>
References: <20220922143655.3721218-1-vkuznets@redhat.com>
 <20220922143655.3721218-7-vkuznets@redhat.com>
 <Y0XGuk4vwJBTU9oN@google.com>
Date:   Wed, 12 Oct 2022 14:40:52 +0200
Message-ID: <87v8op6wq3.fsf@ovpn-194-196.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Sep 22, 2022, Vitaly Kuznetsov wrote:
>> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
>> index d4bd18bc580d..18b44450dfb8 100644
>> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
>> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
>> @@ -46,20 +46,33 @@ struct hcall_data {
>>  
>>  static void guest_msr(struct msr_data *msr)
>>  {
>> -	uint64_t ignored;
>> +	uint64_t msr_val = 0;
>>  	uint8_t vector;
>>  
>>  	GUEST_ASSERT(msr->idx);
>>  
>> -	if (!msr->write)
>> -		vector = rdmsr_safe(msr->idx, &ignored);
>> -	else
>> +	if (!msr->write) {
>> +		vector = rdmsr_safe(msr->idx, &msr_val);
>
> This is subtly going to do weird things if the RDMSR faults.  rdmsr_safe()
> overwrites @val with whatever happens to be in EDX:EAX if the RDMSR faults, i.e.
> this may yield garbage instead of '0'.  Arguably rdmsr_safe() is a bad API, but
> at the same time the caller really shouldn't consume the result if RDMSR faults
> (though aligning with the kernel is also valuable).
>
> Aha!  Idea.  Assuming none of the MSRs are write-only, what about adding a prep
> patch to rework this code so that it verifies RDMSR returns what was written when
> a fault didn't occur.
>

There is at least one read-only MSR which comes to mind:
HV_X64_MSR_EOI. Also, some of the MSRs don't preserve the written value,
e.g. HV_X64_MSR_RESET which always reads as '0'.

I do, however, like the additional check that RDMSR returns what was
written to the MSR, we will just need an additional flag in 'struct
msr_data' ('check_written_value' maybe?).

-- 
Vitaly


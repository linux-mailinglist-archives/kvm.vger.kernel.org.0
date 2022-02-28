Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC80D4C66BC
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 11:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbiB1KDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 05:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbiB1KCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 05:02:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 825A636681
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 01:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646042319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aa8PdEAcGufSdiHlrYI98SIoUuXszzG1ntEv83vyr9M=;
        b=QtnxSjNZlurKxT0eJRFhcLDy/kanjDkel9T9OpRqXugPHsTlQBqF865M2spPEUMqqQgoBG
        dN+J+sghDimqGkKoexTr1DdKc1wkEkprGmgPDrMa6YWElUgqEFyIpO8cvWa0a5Z6Xec2EQ
        Tp0+T0/t4785uleXov+306R6VT+okB8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-OCYzyk97O8Kz9wvdFOHnug-1; Mon, 28 Feb 2022 04:58:38 -0500
X-MC-Unique: OCYzyk97O8Kz9wvdFOHnug-1
Received: by mail-qv1-f69.google.com with SMTP id x16-20020a0ce250000000b00432ec6eaf85so4447334qvl.15
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 01:58:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=aa8PdEAcGufSdiHlrYI98SIoUuXszzG1ntEv83vyr9M=;
        b=8HCYpj8zXHQkXk5G9sBjzM2LYnK2HiIiBlkVUHEPc/y+MZBc3rLDi9M1+yeWm17fqi
         r7zQo47EOklH2Psljv+Kf4RHfZv134j48MQ/Z1g2CNbiscqEGwVx6fJ30+vwpsl3BVzo
         Ns86ovbnzXQOG09U+909B7qkE2gQLDL6dqw2jGko10rKDvRMntNG4t/CrcerFzNt2GBS
         rNdIVbIXUN1DpfPRcdBgvzLsfo18xM758C6Gy7MUAo/T8XzF1BmBGGnaX/Hj1xbp4ymM
         Q11HoVStHgUNa8lRQT917AmPvsAK7C82Qe/ihBNU3jN6tN8xpg97IYH8KBEpyzI6u3RT
         9IKA==
X-Gm-Message-State: AOAM5323GvVm7a0KSqJnyvIUz1EkZAhjR2X1dCnugYuQ+X1bPa98d3et
        MtgnOnNuAOEWGdH3yaFtay/KPd3HchHL/e7uf5+4bDsBLkV1/NRysvqDPAhFMILkWL/mcbHmAKs
        kveyOSmO47XfN
X-Received: by 2002:a0c:cdc9:0:b0:42d:b04:4d9e with SMTP id a9-20020a0ccdc9000000b0042d0b044d9emr13580298qvn.64.1646042317394;
        Mon, 28 Feb 2022 01:58:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyo4xrAts4HPJKrn8HlYd8J0DNmB0KTGjISkhsfaMgrIblP695pg/lQKPjldmsC5IyKfzlgSA==
X-Received: by 2002:a0c:cdc9:0:b0:42d:b04:4d9e with SMTP id a9-20020a0ccdc9000000b0042d0b044d9emr13580292qvn.64.1646042317153;
        Mon, 28 Feb 2022 01:58:37 -0800 (PST)
Received: from fedora (ec2-3-80-233-239.compute-1.amazonaws.com. [3.80.233.239])
        by smtp.gmail.com with ESMTPSA id v72-20020a37614b000000b00648ebe9d4a5sm4879265qkb.116.2022.02.28.01.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 01:58:36 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/4] KVM: x86: hyper-v: Drop redundant 'ex' parameter
 from kvm_hv_send_ipi()
In-Reply-To: <506c34bc80d1bb740ddf38e6476ad0e16c097282.camel@redhat.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
 <20220222154642.684285-2-vkuznets@redhat.com>
 <506c34bc80d1bb740ddf38e6476ad0e16c097282.camel@redhat.com>
Date:   Mon, 28 Feb 2022 10:58:33 +0100
Message-ID: <87y21vcnxy.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Tue, 2022-02-22 at 16:46 +0100, Vitaly Kuznetsov wrote:
>> 'struct kvm_hv_hcall' has all the required information already,
>> there's no need to pass 'ex' additionally.
>> 
>> No functional change intended.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/hyperv.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index 6e38a7d22e97..15b6a7bd2346 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -1875,7 +1875,7 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
>>  	}
>>  }
>>  
>> -static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
>> +static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>>  {
>>  	struct kvm *kvm = vcpu->kvm;
>>  	struct hv_send_ipi_ex send_ipi_ex;
>> @@ -1889,7 +1889,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>>  	u32 vector;
>>  	bool all_cpus;
>>  
>> -	if (!ex) {
>> +	if (hc->code == HVCALL_SEND_IPI) {
>
> I am thinking, if we already touch this code,
> why not to use switch here instead on the hc->code,
> so that we can catch this function being called with something else than
> HVCALL_SEND_IPI_EX

I'm not against this second line of defense but kvm_hv_send_ipi() is
only called explicitly from kvm_hv_hypercall()'s switch so something is
really screwed up if we end up seeing something different from
HVCALL_SEND_IPI_EX/HVCALL_SEND_IPI here.

I'm now working on a bigger series for TLB flush improvements, will use
your suggestion there, thanks!

>
>>  		if (!hc->fast) {
>>  			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi,
>>  						    sizeof(send_ipi))))
>> @@ -2279,14 +2279,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>>  			break;
>>  		}
>> -		ret = kvm_hv_send_ipi(vcpu, &hc, false);
>> +		ret = kvm_hv_send_ipi(vcpu, &hc);
>>  		break;
>>  	case HVCALL_SEND_IPI_EX:
>>  		if (unlikely(hc.fast || hc.rep)) {
>>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>>  			break;
>>  		}
>> -		ret = kvm_hv_send_ipi(vcpu, &hc, true);
>> +		ret = kvm_hv_send_ipi(vcpu, &hc);
>>  		break;
>>  	case HVCALL_POST_DEBUG_DATA:
>>  	case HVCALL_RETRIEVE_DEBUG_DATA:
>
>
>
> Other than this minor nitpick:
>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>
>
> Best regards,
> 	Maxim Levitsky
>

-- 
Vitaly


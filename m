Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6080B4C66C1
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 11:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbiB1KEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 05:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbiB1KDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 05:03:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1CC49BF61
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 02:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646042549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LQykvnwn3SvuemPhxL6ZnbbVzqao/qIJLsXksMomzg8=;
        b=bteBBcogLIz9H1OIWQ13ZcQHQsVIzMXLeneQyCrlEJD72NKUz5y33n6NZ+TiDcumm/XBqg
        GYHf5DhxyTyevKIaHwHDTPaKYorCnD6nMLwX/ZOi3I1rN8MgqYoC07aHmQmNtr7RUhZbIN
        KuOSY3CoEjpY+4Z/QfwQBGVPr50CdNs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-a3qn3CeuMt2jnhRcvSuPuw-1; Mon, 28 Feb 2022 05:02:25 -0500
X-MC-Unique: a3qn3CeuMt2jnhRcvSuPuw-1
Received: by mail-qk1-f199.google.com with SMTP id r20-20020a37a814000000b00648f4cddf6bso10571197qke.5
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 02:02:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LQykvnwn3SvuemPhxL6ZnbbVzqao/qIJLsXksMomzg8=;
        b=1t6LBv0/HZ3+A2SGakInmdadkyTIQUv3nucGYyD51QUz3evn0+4/Fk26N6HsuXSMaw
         0mDXDHCsjG1Nz9+xTdnonI8N3lvGJ+z6eOsz1s/HsIQ0cvw0iGEIbYCSdnCoCvzcy+RJ
         gpLppwqFRY2r0u07YBEdUUdRIMKDpxxfZT3nUWbIoOaKS+0pNbk01x9gVFRJgs03y569
         MV2jPCErzaw4T1RFzlDLxnL32xXNKZvXoBujxjIXQqeOoC4WcM5oL6PfwlgKnC788e7D
         WVSlSyEH3vknU6YvZZlgZGgHtxhS/eqIQpzEZJqQD7v3rtbk6/+lAaLKNeVUtgaypHgO
         8jBA==
X-Gm-Message-State: AOAM53044t6I1oh5PgyEuTfDnKhnAIEk/V6L0r1CvjOgL8VBPIZykTko
        6/YcgwYE/lPz07tr8RPzhWqd0zYEAhe2cwaE6ic84rUfU3NnteoVkAv+LVVr80JZy4XCcNvkBsW
        XequTJHToSSQd
X-Received: by 2002:a37:8602:0:b0:62c:de8f:ad74 with SMTP id i2-20020a378602000000b0062cde8fad74mr11054848qkd.142.1646042544520;
        Mon, 28 Feb 2022 02:02:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzlJPDHDfa3H5fRTOWAtYRpgsWoC6Sm9bnbFfHNNg9fn2aCVPAskop5qSLWf0BQLd3CqPJQvg==
X-Received: by 2002:a37:8602:0:b0:62c:de8f:ad74 with SMTP id i2-20020a378602000000b0062cde8fad74mr11054838qkd.142.1646042544244;
        Mon, 28 Feb 2022 02:02:24 -0800 (PST)
Received: from fedora (ec2-3-80-233-239.compute-1.amazonaws.com. [3.80.233.239])
        by smtp.gmail.com with ESMTPSA id d4-20020a05620a136400b0060dda40b3ecsm4792367qkl.30.2022.02.28.02.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 02:02:23 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4/4] KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM
 fast hypercall
In-Reply-To: <6d01c59eab7f31eef1b4249a85869600410336b7.camel@redhat.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
 <20220222154642.684285-5-vkuznets@redhat.com>
 <6d01c59eab7f31eef1b4249a85869600410336b7.camel@redhat.com>
Date:   Mon, 28 Feb 2022 11:02:20 +0100
Message-ID: <87v8wzcnrn.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Tue, 2022-02-22 at 16:46 +0100, Vitaly Kuznetsov wrote:
>> It has been proven on practice that at least Windows Server 2019 tries
>> using HVCALL_SEND_IPI_EX in 'XMM fast' mode when it has more than 64 vCPUs
>> and it needs to send an IPI to a vCPU > 63. Similarly to other XMM Fast
>> hypercalls (HVCALL_FLUSH_VIRTUAL_ADDRESS_{LIST,SPACE}{,_EX}), this
>> information is missing in TLFS as of 6.0b. Currently, KVM returns an error
>> (HV_STATUS_INVALID_HYPERCALL_INPUT) and Windows crashes.
>> 
>> Note, HVCALL_SEND_IPI is a 'standard' fast hypercall (not 'XMM fast') as
>> all its parameters fit into RDX:R8 and this is handled by KVM correctly.
>> 
>> Fixes: d8f5537a8816 ("KVM: hyper-v: Advertise support for fast XMM hypercalls")
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/hyperv.c | 52 ++++++++++++++++++++++++++++---------------
>>  1 file changed, 34 insertions(+), 18 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index 6dda93bf98ae..3060057bdfd4 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -1890,6 +1890,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>>  	int sparse_banks_len;
>>  	u32 vector;
>>  	bool all_cpus;
>> +	int i;
>>  
>>  	if (hc->code == HVCALL_SEND_IPI) {
>>  		if (!hc->fast) {
>> @@ -1910,9 +1911,15 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>>  
>>  		trace_kvm_hv_send_ipi(vector, sparse_banks[0]);
>>  	} else {
>> -		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi_ex,
>> -					    sizeof(send_ipi_ex))))
>> -			return HV_STATUS_INVALID_HYPERCALL_INPUT;
>> +		if (!hc->fast) {
>> +			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi_ex,
>> +						    sizeof(send_ipi_ex))))
>> +				return HV_STATUS_INVALID_HYPERCALL_INPUT;
>> +		} else {
>> +			send_ipi_ex.vector = (u32)hc->ingpa;
>> +			send_ipi_ex.vp_set.format = hc->outgpa;
>> +			send_ipi_ex.vp_set.valid_bank_mask = sse128_lo(hc->xmm[0]);
>> +		}
>>  
>>  		trace_kvm_hv_send_ipi_ex(send_ipi_ex.vector,
>>  					 send_ipi_ex.vp_set.format,
>> @@ -1920,8 +1927,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>>  
>>  		vector = send_ipi_ex.vector;
>>  		valid_bank_mask = send_ipi_ex.vp_set.valid_bank_mask;
>> -		sparse_banks_len = bitmap_weight(&valid_bank_mask, 64) *
>> -			sizeof(sparse_banks[0]);
>> +		sparse_banks_len = bitmap_weight(&valid_bank_mask, 64);
> Is this change intentional? 
>

Yes it is. Previously, 'sparse_banks_len' was the number of bytes to
read, now it's in u64-s.

(see below)

> I haven't fully reviewed this, because kvm/queue seem to have a bit different
> version of this, and I didn't fully follow on all of this.
>
>>  
>>  		all_cpus = send_ipi_ex.vp_set.format == HV_GENERIC_SET_ALL;
>>  
>> @@ -1931,12 +1937,27 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>>  		if (!sparse_banks_len)
>>  			goto ret_success;
>>  
>> -		if (kvm_read_guest(kvm,
>> -				   hc->ingpa + offsetof(struct hv_send_ipi_ex,
>> -							vp_set.bank_contents),
>> -				   sparse_banks,
>> -				   sparse_banks_len))
>> -			return HV_STATUS_INVALID_HYPERCALL_INPUT;
>> +		if (!hc->fast) {
>> +			if (kvm_read_guest(kvm,
>> +					   hc->ingpa + offsetof(struct hv_send_ipi_ex,
>> +								vp_set.bank_contents),
>> +					   sparse_banks,
>> +					   sparse_banks_len * sizeof(sparse_banks[0])))

^^^ here ^^^

>> +				return HV_STATUS_INVALID_HYPERCALL_INPUT;
>> +		} else {
>> +			/*
>> +			 * The lower half of XMM0 is already consumed, each XMM holds
>> +			 * two sparse banks.
>> +			 */
>> +			if (sparse_banks_len > (2 * HV_HYPERCALL_MAX_XMM_REGISTERS - 1))
>> +				return HV_STATUS_INVALID_HYPERCALL_INPUT;

And here. This is the reason for change: it's more convenient to count
it 'xmm halves' than in bytes.

>> +			for (i = 0; i < sparse_banks_len; i++) {
>> +				if (i % 2)
>> +					sparse_banks[i] = sse128_lo(hc->xmm[(i + 1) / 2]);
>> +				else
>> +					sparse_banks[i] = sse128_hi(hc->xmm[i / 2]);
>> +			}
>> +		}
>>  	}
>>  
>>  check_and_send_ipi:
>> @@ -2098,6 +2119,7 @@ static bool is_xmm_fast_hypercall(struct kvm_hv_hcall *hc)
>>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
>>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
>>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
>> +	case HVCALL_SEND_IPI_EX:
>>  		return true;
>>  	}
>>  
>> @@ -2265,14 +2287,8 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>>  		ret = kvm_hv_flush_tlb(vcpu, &hc);
>>  		break;
>>  	case HVCALL_SEND_IPI:
>> -		if (unlikely(hc.rep)) {
>> -			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>> -			break;
>> -		}
>> -		ret = kvm_hv_send_ipi(vcpu, &hc);
>> -		break;
>>  	case HVCALL_SEND_IPI_EX:
>> -		if (unlikely(hc.fast || hc.rep)) {
>> +		if (unlikely(hc.rep)) {
>>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>>  			break;
>>  		}
>
>

-- 
Vitaly


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114915ADB0C
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 00:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiIEWAa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 18:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbiIEWAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 18:00:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F180426ACD
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 15:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662415214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NycFywALOql0/ca0A4x2CHoaBZkltjZTIH9JQYcZImU=;
        b=F4P1HODa8WNlGJHSo7hkR90GC8d1j+m66h408OGWwnos+gsHP7AW65pnYG3Xh7GJ0ak9lD
        nLtGUn7DIbFNK52ozcla7nLb27w9G36ZdNOSx9ikYjLOUGvayyDyvA/ynUZuzZt0//vUMF
        j4+6HZRvda/oZlbXCRtZvak45Hh4b78=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-668-q25sJZ1WMlWELE2oI2HfSA-1; Mon, 05 Sep 2022 18:00:12 -0400
X-MC-Unique: q25sJZ1WMlWELE2oI2HfSA-1
Received: by mail-ed1-f70.google.com with SMTP id w17-20020a056402269100b0043da2189b71so6286490edd.6
        for <kvm@vger.kernel.org>; Mon, 05 Sep 2022 15:00:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NycFywALOql0/ca0A4x2CHoaBZkltjZTIH9JQYcZImU=;
        b=l2CqDelp6iDwIahYiTcKN0aviX9us720XfVZZgN6XgfyYbry2KhXFGhtWdsRXfmyEh
         ZwGq5OqYCDymAqlUJ0psE7bUYwQmbgETWsbYJWD9rQfKH7zABkNxXARxopJbM+7RdfxC
         IRxA2M5bVy/3BibZEnlcPLWmmTsREi4CCuuXZlzWNrEty9TTPuvfJUztio+72rEYhtaj
         qgTNGyZoQHTBpl69B+MeaesMDdvjZQVsb86//0teQSq78am0AkCk9TQ2iyp405x5AvvW
         ogBsNYu+9CqLYqiMwBdu9zAMUqBjuMXwU2s3lMJK3BrdBpTJlbMNF4DiCxhR0uM10RDi
         7eug==
X-Gm-Message-State: ACgBeo01uu2UpBmM/HWQkN5MiDOvK7mAIvsO4rQ1VKqGs4xxqoijBfdc
        K9xLq09/r3C+13IqJqIbMqSwyzf83KpbafiWCejZFQBVtj5zZKvw2+nDklifuUMI+kjwtsBRmG5
        YHN//BORXkBbZ
X-Received: by 2002:a17:907:7208:b0:73d:7097:ac6f with SMTP id dr8-20020a170907720800b0073d7097ac6fmr38643636ejc.388.1662415211692;
        Mon, 05 Sep 2022 15:00:11 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7hM8eM+Xiuv8kXwmqBlg+wcV9zQxoLA+piVkr8Rq4/+ovIa7+JXsHqtDA1/MKLFHEQun/FjQ==
X-Received: by 2002:a17:907:7208:b0:73d:7097:ac6f with SMTP id dr8-20020a170907720800b0073d7097ac6fmr38643619ejc.388.1662415211492;
        Mon, 05 Sep 2022 15:00:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id q3-20020a17090676c300b007030c97ae62sm5550526ejn.191.2022.09.05.15.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 15:00:11 -0700 (PDT)
Message-ID: <b36e658d-500e-6d56-6abd-0c9e8026de1a@redhat.com>
Date:   Mon, 5 Sep 2022 23:59:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 03/23] KVM: SVM: Process ICR on AVIC IPI delivery
 failure due to invalid target
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20220903002254.2411750-1-seanjc@google.com>
 <20220903002254.2411750-4-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220903002254.2411750-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/22 02:22, Sean Christopherson wrote:
> Emulate ICR writes on AVIC IPI failures due to invalid targets using the
> same logic as failures due to invalid types.  AVIC acceleration fails if
> _any_ of the targets are invalid, and crucially VM-Exits before sending
> IPIs to targets that _are_ valid.  In logical mode, the destination is a
> bitmap, i.e. a single IPI can target multiple logical IDs.  Doing nothing
> causes KVM to drop IPIs if at least one target is valid and at least one
> target is invalid.
> 
> Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/avic.c | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 4fbef2af1efc..6a3d225eb02c 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -502,14 +502,18 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>   	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
>   
>   	switch (id) {
> +	case AVIC_IPI_FAILURE_INVALID_TARGET:
>   	case AVIC_IPI_FAILURE_INVALID_INT_TYPE:
>   		/*
>   		 * Emulate IPIs that are not handled by AVIC hardware, which
> -		 * only virtualizes Fixed, Edge-Triggered INTRs.  The exit is
> -		 * a trap, e.g. ICR holds the correct value and RIP has been
> -		 * advanced, KVM is responsible only for emulating the IPI.
> -		 * Sadly, hardware may sometimes leave the BUSY flag set, in
> -		 * which case KVM needs to emulate the ICR write as well in
> +		 * only virtualizes Fixed, Edge-Triggered INTRs, and falls over
> +		 * if _any_ targets are invalid, e.g. if the logical mode mask
> +		 * is a superset of running vCPUs.
> +		 *
> +		 * The exit is a trap, e.g. ICR holds the correct value and RIP
> +		 * has been advanced, KVM is responsible only for emulating the
> +		 * IPI.  Sadly, hardware may sometimes leave the BUSY flag set,
> +		 * in which case KVM needs to emulate the ICR write as well in
>   		 * order to clear the BUSY flag.
>   		 */
>   		if (icrl & APIC_ICR_BUSY)
> @@ -525,8 +529,6 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>   		 */
>   		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
>   		break;
> -	case AVIC_IPI_FAILURE_INVALID_TARGET:
> -		break;
>   	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
>   		WARN_ONCE(1, "Invalid backing page\n");
>   		break;

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E597A6569F6
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 12:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiL0LbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 06:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiL0LbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 06:31:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66055B1D5
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 03:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672140622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oGv9k8005FBNEl5oXuDWY94GE+vOxjP7VpH4ecTd4rU=;
        b=O0s2vtjCXeBCImflNtXe8r7MilgbCKtIy+bhshdNkDVKphPDeD0zfPk2T1fT7w4WqIMiah
        s5DRiBPPpTdrdjnFOyJfC5fp/eS1D3ciVdWYdmzth3i1qppNbLMXBuLTnkKxsSSJuc46k5
        SgQu+2xP4Tr4dxC99Cr9J1ORPj8Cjo4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-223-IB9XA1v5MCawwgwcffOXFQ-1; Tue, 27 Dec 2022 06:30:21 -0500
X-MC-Unique: IB9XA1v5MCawwgwcffOXFQ-1
Received: by mail-ed1-f71.google.com with SMTP id c12-20020a05640227cc00b004853521ef55so2921779ede.8
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 03:30:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oGv9k8005FBNEl5oXuDWY94GE+vOxjP7VpH4ecTd4rU=;
        b=7UDEZSLC8I6fdPn9oKf22aksuX1uckHFPIlKFYxGXGNyKgNmU2yjq/JLpKSW08rVrW
         oKnEsiOGokGOvpebDc9ypDJyTUaItgg9KqUb8npak0aZn4pMZ5whoxkAtccaLm7rgsyA
         js9x1yYleVZQDyAkLnVbHqR4P5OTMBztJUIPlj68wAmg0idO0yaLr0Qf8uZG8gVRYR4n
         4jJHsf4H13jaSGGEwom4a442nyACuzoh9ih3hYfOieAa0VZDDLCjngIgPTd/1Qq1/BTt
         JHnluJMqR28giQy+7URD2lklwX0ji5VpcCJG0MQOucoSCu7ojgLnjZqya0BmaNtIcD/+
         LLig==
X-Gm-Message-State: AFqh2krD03vG5Tcj9elwlKwB5uyZrIrm8pxzrvBSuG9XVqYB/oqFp1Vg
        MpCZ5JBBfhznWIcmHErDTzdPKiDfVmmycraTR4tnlIxra4x9t3YssdhLGVergXhiQXYykDEH6M9
        T/FNiDQUTvQCc
X-Received: by 2002:a17:906:60cb:b0:84b:b481:6188 with SMTP id f11-20020a17090660cb00b0084bb4816188mr8790618ejk.64.1672140620077;
        Tue, 27 Dec 2022 03:30:20 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtu3f76H+toSIJ9WDPQZhTt310Tkxh5P/vCKasw2HN49sYmKeuJlbnWgpwEXfI4aEG4fmqMiA==
X-Received: by 2002:a17:906:60cb:b0:84b:b481:6188 with SMTP id f11-20020a17090660cb00b0084bb4816188mr8790602ejk.64.1672140619837;
        Tue, 27 Dec 2022 03:30:19 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id p11-20020a1709060dcb00b00782fbb7f5f7sm5838806eji.113.2022.12.27.03.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 03:30:19 -0800 (PST)
Message-ID: <1f157cca-a71e-cdee-4427-e1f4bb1b1115@redhat.com>
Date:   Tue, 27 Dec 2022 12:30:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v4 19/32] KVM: x86: Explicitly track all possibilities for
 APIC map's logical modes
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20221001005915.2041642-1-seanjc@google.com>
 <20221001005915.2041642-20-seanjc@google.com>
 <96c369fb2042e8722256d36c9b2ccf4a930752d1.camel@redhat.com>
 <Y5y7VK9yk5qbfKVN@google.com> <Y50AhU1UwocNE/+M@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y50AhU1UwocNE/+M@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/22 00:34, Sean Christopherson wrote:
> On Fri, Dec 16, 2022, Sean Christopherson wrote:
>> On Thu, Dec 08, 2022, Maxim Levitsky wrote:
> 
> ...
> 
>>>> @@ -282,7 +291,8 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>>>>   		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
>>>>   			new->phys_map[xapic_id] = apic;
>>>>   
>>>> -		if (!kvm_apic_sw_enabled(apic))
>>>> +		if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED ||
>>>> +		    !kvm_apic_sw_enabled(apic))
>>>>   			continue;
>>> Very minor nitpick: it feels to me that code that updates the logical mode of the
>>> map, might be better to be in a function, or in 'if', like
>>
>> An if-statement would be rough due to the indentation.  A function works well
>> though, especially if both the physical and logical chunks are put into helpers.
>> E.g. the patch at the bottom (with other fixup for this patch) yields:
>>
>> 	new->max_apic_id = max_id;
>> 	new->logical_mode = KVM_APIC_MODE_SW_DISABLED;
>>
>> 	kvm_for_each_vcpu(i, vcpu, kvm) {
>> 		if (!kvm_apic_present(vcpu))
>> 			continue;
>>
>> 		if (kvm_recalculate_phys_map(new, vcpu, &xapic_id_mismatch)) {
>> 			kvfree(new);
>> 			new = NULL;
>> 			goto out;
>> 		}
>>
>> 		kvm_recalculate_logical_map(new, vcpu);
>> 	}
>>
>> I'll tack that patch on at the end of the series if it looks ok.

Yes, please send as a follow up.

Paolo


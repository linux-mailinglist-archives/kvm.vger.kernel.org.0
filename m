Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED05A4BA6CB
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 18:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243614AbiBQROq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 12:14:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243612AbiBQROp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 12:14:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE15829C11C
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 09:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645118069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ySllJiCMAwsjkuMx220zAOxJL394IVe/OENqIOoj1Ko=;
        b=XFU5cr8oDDrDJ5rVeWqCxmP5KWRKYEk4/DpqrCtEKE+5umr7yOYXuNaMHiADTvramIaLSb
        60mhDTDNMRqzNq796xfcxPaSMw3MJQHqJgfe704Wmx86W5krAb/ZF6l0h5YE8693j6B13E
        RAPY61s1eoaXi/+6xBT5CKVNY8qO/rA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-SVGs6POOOXyVQBnb9Yrmig-1; Thu, 17 Feb 2022 12:14:27 -0500
X-MC-Unique: SVGs6POOOXyVQBnb9Yrmig-1
Received: by mail-ej1-f70.google.com with SMTP id v2-20020a170906292200b006a94a27f903so1821989ejd.8
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 09:14:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ySllJiCMAwsjkuMx220zAOxJL394IVe/OENqIOoj1Ko=;
        b=yUwLgnPmiSZM9wYn1GW312avTSA6Yw9hDWes2yBVFqRQrxZ9wMu/426UKmDE/ufSPw
         DZ+q4WFYR7KdaTlfEMKofhe8dVdy5c3RGuon58SA8zQfv2CDcYI/pw1gJGpflKBDjZFc
         brra+FsWA8G3RrOeR/v/exHV3mhcldtbNLGUng/pzPhERD5A0acv+IsFh2kpAGonm6uB
         JvvumDrwdcOMoiqIk0kuQZIomlJRcPzYfv+Q8XlSo3IdYiJ7sLJOBw9NrBrHq35fKk3r
         v4/tbWiNUAb/zstUrcTr8APm+ivYRGQJZf4d1ygsSS/JOk9z2Ny1HRcJDsmWCPtb79FY
         +6BA==
X-Gm-Message-State: AOAM5324fznQ/Y8jOjZRS9o0jdg0LoF9lI3qOn9YwDe6y80fDZVJX+tl
        l87bTSkmeNSVJiZWbn6ABtYMYaVK5Yjfn0281tTnpIcSSlOVX3jNZQ+kDCtHfHrzWNlxHnn5G38
        oIX8RAsvd79PT
X-Received: by 2002:a05:6402:42cb:b0:410:678d:61d with SMTP id i11-20020a05640242cb00b00410678d061dmr3757937edc.123.1645118066248;
        Thu, 17 Feb 2022 09:14:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzlFC9NsD76Yn6hapmFTVoreXyoZKxWzktvzRuShycjqRli8lkrss4IaFOHIrw3/9/zMRpVhg==
X-Received: by 2002:a05:6402:42cb:b0:410:678d:61d with SMTP id i11-20020a05640242cb00b00410678d061dmr3757923edc.123.1645118066052;
        Thu, 17 Feb 2022 09:14:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id u23sm1062871edo.64.2022.02.17.09.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 09:14:25 -0800 (PST)
Message-ID: <de6a1b73-c623-4776-2f14-b00917b7d22a@redhat.com>
Date:   Thu, 17 Feb 2022 18:14:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] kvm: x86: Disable KVM_HC_CLOCK_PAIRING if tsc is in
 always catchup mode
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anton Romanov <romanton@google.com>, mtosatti@redhat.com,
        kvm@vger.kernel.org
References: <20220215200116.4022789-1-romanton@google.com>
 <87zgmqq4ox.fsf@redhat.com> <Yg5sl9aWzVJKAMKc@google.com>
 <87pmnlpj8u.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87pmnlpj8u.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/22 17:09, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
>> On Wed, Feb 16, 2022, Vitaly Kuznetsov wrote:
> 
> ...
>>
>>> Also, EOPNOTSUPP makes it sound like the hypercall is unsupported, I'd
>>> suggest changing this to KVM_EFAULT.
>>
>> Eh, it's consistent with the above check though, where KVM returns KVM_EOPNOTSUPP
>> due to the vclock mode being incompatible.  This is more or less the same, it's
>> just a different "mode".  KVM_EFAULT suggests that the guest did something wrong
>> and/or that the guest can remedy the problem in someway, e.g. by providing a
>> different address.  This issue is purely in the host's domain.
> 
> Ack, Paolo's already made the change back to KVM_EOPNOTSUPP upon commit
> (but I still mildly dislike using 'EOPNOTSUPP' for a temporary condition
> on the host).

It's not temporary, always-catchup is set on KVM_SET_TSC_KHZ and never 
goes away.

Paolo


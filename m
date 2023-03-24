Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1617D6C7D27
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 12:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjCXLX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 07:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjCXLX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 07:23:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6632B25B90
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 04:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679656958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y31Rz44TEwSQC9KX97iibt6OL6RtzpKo/j/apW3i2Tc=;
        b=jS8NDhfPoO71kgJWu4KrUmHBwNdQFR46UUSrsu9AnlMqtbw4Gf/4b4BlClRgLby+R1hbCD
        egdRP17dO74J27yS1yJGli7CdveO5zk+mLBbJbWQuWswHNq68cnH0kUD0I3/UqpZg4nlEx
        1x/O7IcW+fUW5Py17GSxp/WxnuUl2zI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-_IZDBWegOzu7JrF-dXBADg-1; Fri, 24 Mar 2023 07:22:37 -0400
X-MC-Unique: _IZDBWegOzu7JrF-dXBADg-1
Received: by mail-ed1-f71.google.com with SMTP id k30-20020a50ce5e000000b00500544ebfb1so2742707edj.7
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 04:22:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679656956;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y31Rz44TEwSQC9KX97iibt6OL6RtzpKo/j/apW3i2Tc=;
        b=LcCR1qoB5e+5PE2e2h504cgtsPTZnQe5I+7ZbTxvV5MTDPCkkGnJzIkgIXJjmB3Up2
         U6li78LEkqJaPrIJjUhboarFduSH1Ygrxg/wuio9ZxiNoCcKnb/mKqWukz3o1fFITLVI
         rmoTYaDjIMB47gea3yfHNvR4dx9FVBDQ0u/LMAeIijUCSHBZjAHmd707jYwRKlLLMotF
         lzuINz4zqk7YGmJtq2O9G6rGnU9X/p1uIVMFuEzNQ5S93VqkvejHj6ExAsaUvsT2XyYP
         EyAT6vsE2Pj4yR+m0ffM/ZcHGm/JloC8R8Up41sbV1sRt4NbaeSY/tmkQSKd0EXv4SZr
         lfeg==
X-Gm-Message-State: AAQBX9eq71HLC4+JaFk0KlRpK+xYI58UfVuplFHH6NCjYByK2/GTPDiR
        RTIg6BlBsTIsHmj2WSaNZhcLpll14R++rPyOUMTk4Zd3dPGUwPr5/wX4wY1I3iw+prRr9w7SBWC
        v/l1QOU8ARwr6
X-Received: by 2002:a05:6402:6c1:b0:4fb:4354:ab2e with SMTP id n1-20020a05640206c100b004fb4354ab2emr2452274edy.28.1679656956136;
        Fri, 24 Mar 2023 04:22:36 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z6fyfd5gCMg/7AcVDCAIEh81DrDIzmgBAv1m67pEiILxvBRDCw/izCGtzBehGd1wRQT7d5qg==
X-Received: by 2002:a05:6402:6c1:b0:4fb:4354:ab2e with SMTP id n1-20020a05640206c100b004fb4354ab2emr2452254edy.28.1679656955824;
        Fri, 24 Mar 2023 04:22:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id s30-20020a50ab1e000000b004c5d1a15bd5sm10469869edc.69.2023.03.24.04.22.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 04:22:34 -0700 (PDT)
Message-ID: <723bf800-9666-dfb6-e7cc-653adb0203b4@redhat.com>
Date:   Fri, 24 Mar 2023 12:22:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Simon Veith <sveith@amazon.de>
Cc:     dwmw2@infradead.org, dff@amazon.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, oupton@google.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com
References: <f3a957786a82bdd41fe558c40ec93c3fb9ea2ee2.camel@infradead.org>
 <20230202165950.483430-1-sveith@amazon.de> <ZBIjImc+xEMhJkQM@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: add KVM_VCPU_TSC_VALUE attribute
In-Reply-To: <ZBIjImc+xEMhJkQM@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/23 20:57, Sean Christopherson wrote:
>> In the case of live migration, using the KVM_VCPU_TSC_OFFSET approach to
>> preserve the TSC value and apply a known offset would require
>> duplicating the TSC scaling computations in userspace to account for
>> frequency differences between source and destination TSCs.
>>
>> Hence, if userspace wants to set the TSC to some known value without
>> having to deal with TSC scaling, and while also being resilient against
>> scheduling delays, neither KVM_SET_MSRS nor KVM_VCPU_TSC_VALUE are
>> suitable options.
>
> Requiring userspace to handle certain aspects of TSC scaling doesn't seem
> particularly onerous, at least not relative to all the other time insanity.  In
> other words, why should KVM take on more complexity and a mostly-redundant uAPI?

Yeah, it seems like the problem is that KVM_GET_CLOCK return host 
unscaled TSC units (which was done because the guest TSC frequency is at 
least in theory per-CPU, and KVM_GET_CLOCK is a vm ioctl)?

Perhaps it's more important (uAPI-wise) for KVM to return the precise 
guest/host TSC ratio via a vcpu device attribute?

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B774F86DE
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 20:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346756AbiDGSG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 14:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiDGSGZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 14:06:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABE8810C509
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 11:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649354663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nRFJljjnl0/LbZGDUkKF42YGnBscKy1ev/zQc0PM1uc=;
        b=ejzPMlxyO7JkZBSLeAJVR0vy/BxTQNv5yFVksQHbxNOuRNe5xiNGKQSYukAfFs0hSAAOkX
        vaPmSdHH2Cuw0Oc7+161s41I2eRxOSAEXTlcUdeQt8QlhiYxlKomlczCou+tHg/nZpBou8
        S9yiIfnUWAYT8nZTSdOajbMhQ9WgKIY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-vExLJ6-0MI2ajiQ7U7DwyQ-1; Thu, 07 Apr 2022 14:04:22 -0400
X-MC-Unique: vExLJ6-0MI2ajiQ7U7DwyQ-1
Received: by mail-ej1-f72.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so3482784ejw.9
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 11:04:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nRFJljjnl0/LbZGDUkKF42YGnBscKy1ev/zQc0PM1uc=;
        b=ZvBaIwSRUghbUmxG4uRnLieNrM4Xr9LL0pr61JHtjBpzkCmUkeU3JLKY/hBC0pLRVO
         hNB5202VW+ivjp5XvCeaZBb9rFlzVQuoQT/Pdr1KiUGn4xBpwcAucrvW9vxW+DbJ5dQl
         sAgIN+vthFGwvH5fZXrT0ZEIW56Pntu9T1qioE9NE6xXq0USSD7VwBX5qZ+UBjQ4Tc+P
         PH2yN/8q7TdKMQSqNNKIvOa5TWsP4pRytSLK7oF35WXsstPGqZrwVPbQsKChOY5jIiuR
         zto3AfxWcVCderEN3/6n15tYnTRGcjSlOhgZZoE3D+rVV9vRBHNWMGe3gt2xqSsLeUxo
         ue9Q==
X-Gm-Message-State: AOAM53196MDdLC7K/EG/mOxPggLET4CXKUSjisWso47iHnAjBxHDlRWV
        wLSWnjHq/u7+47Lo39Qcz/0SSti0GNNiSRlGH9MtgMkEbCeOQKxNK/pvfJyCvIaw7vVlQJAvYWO
        2bx8ptKw2NFO4
X-Received: by 2002:a17:907:97d4:b0:6e7:e45a:ad48 with SMTP id js20-20020a17090797d400b006e7e45aad48mr14777694ejc.23.1649354661472;
        Thu, 07 Apr 2022 11:04:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyldtGU4PtEc7n/56F2p1bsLlSz6Nky10D1TyZ0u/HZi4G392Q8V3S/9Oo2bWPnLkgMrz/Tg==
X-Received: by 2002:a17:907:97d4:b0:6e7:e45a:ad48 with SMTP id js20-20020a17090797d400b006e7e45aad48mr14777677ejc.23.1649354661268;
        Thu, 07 Apr 2022 11:04:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id b14-20020a170906d10e00b006e803595901sm3592516ejz.172.2022.04.07.11.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 11:04:20 -0700 (PDT)
Message-ID: <6f1169f1-6205-c4d3-1ab0-2e11808f9b10@redhat.com>
Date:   Thu, 7 Apr 2022 20:04:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 089/104] KVM: TDX: Add a placeholder for handler of
 TDX hypercalls (TDG.VP.VMCALL)
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b84fcd9927e49716de913b0fe910018788aaba46.1646422845.git.isaku.yamahata@intel.com>
 <3042130fce467c30f07e58581da966fc405a4c6c.camel@intel.com>
 <23189be4-4410-d47e-820c-a3645d5b9e6d@redhat.com>
 <Yk73ta7nwuI1NnlC@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yk73ta7nwuI1NnlC@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/22 16:39, Sean Christopherson wrote:
> On Thu, Apr 07, 2022, Paolo Bonzini wrote:
>> On 4/7/22 06:15, Kai Huang wrote:
>>>> +static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>>>> +
>>>> +	if (unlikely(tdx->tdvmcall.xmm_mask))
>>>> +		goto unsupported;
>>> Put a comment explaining this logic?
>>>
>>
>> This only seems to be necessary for Hyper-V hypercalls, which however are
>> not supported by this series in TDX guests (because the kvm_hv_hypercall
>> still calls kvm_*_read, likewise for Xen).
>>
>> So for now this conditional can be dropped.
> 
> I'd prefer to keep the sanity check, it's a cheap and easy way to detect a clear
> cut guest bug.

I don't think it's necessarily a guest bug, just silly but valid behavior.

Paolo

   E.g. KVM would be within its rights to write garbage the XMM
> registers in this case.  Even though KVM isn't to be trusted, KVM can still be
> nice to the guest.



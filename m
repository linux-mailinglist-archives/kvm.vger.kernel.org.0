Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C98D4AC88B
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 19:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbiBGSbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 13:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiBGS2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 13:28:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E629C0401D9
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 10:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644258483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L8l1BOEIY2OBosYgwFF1j9N/+xINTmSDtFSsrBkIXmg=;
        b=F8FElqlgdhYAVTYYK5Y2ELne58KPb5fTUOfyknMUnLXZi7BY3egHhq4l4npQaTlsc9Oo4A
        Ehy0TTNNKKg9QbatqweQeoK6tMQ+YJipwzTot0wjxb2+/aETvUbQoMFDBHU5R6BNV6dXWN
        53Y1ct7SykKFV+/6eZOLmj4h6wppME8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-8LgdfTB8OOKGoDbqXbgvww-1; Mon, 07 Feb 2022 13:28:02 -0500
X-MC-Unique: 8LgdfTB8OOKGoDbqXbgvww-1
Received: by mail-ej1-f71.google.com with SMTP id o4-20020a170906768400b006a981625756so4686066ejm.0
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 10:28:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=L8l1BOEIY2OBosYgwFF1j9N/+xINTmSDtFSsrBkIXmg=;
        b=mT8G9v69dSrYMqpyrZr4V1usUYh9jCp/iQ6UtLOLgYkNSq552dobPe4uHid7YRlXn9
         bDa8d9XwS8c3tYoTyhXl1OlKnKSgiCyVaWODMU/4gdIVED2O+jkrrXdfWgXNHlTw/vVu
         HsXLKkWoSz4HtORtbBKf7gQWWb3vgJi5IctOG/z6nApislM1vMBqEX0Z1uWJv0pcL2LZ
         LhRNLWcVqADjFdv7W/iOJK4Naw1OIIObHoSTGARfJ5lQxXYw0tCBXIpx81YRQlNuPlgf
         WLtj6uM6BkRcbasgIxcRloNtCz+1IXBZA1BdcSS6MikvxzDmrCDAbBHbTo/waykSfvMf
         1w5Q==
X-Gm-Message-State: AOAM532M5wsFXAhUtsKWEPOp71dHj6uNuCbfKWWrluHrO0sY0BUcV9tb
        A3ecWVPUviJoxHbaXq82xfOU7hf0LM1mAcxRfQulWEe9sNCfVFjWnrN0jEF832LufXomJg0vu1r
        dcFwgOrOApR1B
X-Received: by 2002:a17:907:9482:: with SMTP id dm2mr748041ejc.39.1644258480679;
        Mon, 07 Feb 2022 10:28:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwxC89e758MKNYiX02HtPi7BMKa8suYfqxG0Z6ryHnIKTrNVg+TMFHABGWVJvktM0C2lfs+hw==
X-Received: by 2002:a17:907:9482:: with SMTP id dm2mr748026ejc.39.1644258480429;
        Mon, 07 Feb 2022 10:28:00 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id hg8sm759582ejc.185.2022.02.07.10.27.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 10:27:59 -0800 (PST)
Message-ID: <8f94b1fd-9a92-55f8-a810-eba09a194445@redhat.com>
Date:   Mon, 7 Feb 2022 19:27:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 1/7] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20220204204705.3538240-1-oupton@google.com>
 <20220204204705.3538240-2-oupton@google.com>
 <ce6e9ae4-2e5b-7078-5322-05b7a61079b4@redhat.com>
 <YgFjaY18suUJjkLL@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgFjaY18suUJjkLL@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/7/22 19:22, Oliver Upton wrote:
> Hi Paolo,
> 
> On Mon, Feb 07, 2022 at 06:21:30PM +0100, Paolo Bonzini wrote:
>> On 2/4/22 21:46, Oliver Upton wrote:
>>> Since commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls
>>> when guest MPX disabled"), KVM has taken ownership of the "load
>>> IA32_BNDCFGS" and "clear IA32_BNDCFGS" VMX entry/exit controls. The ABI
>>> is that these bits must be set in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS
>>> MSRs if the guest's CPUID supports MPX, and clear otherwise.
>>>
>>> However, KVM will only do so if userspace sets the CPUID before writing
>>> to the corresponding MSRs. Of course, there are no ordering requirements
>>> between these ioctls. Uphold the ABI regardless of ordering by
>>> reapplying KVMs tweaks to the VMX control MSRs after userspace has
>>> written to them.
>>
>> I don't understand this patch.  If you first write the CPUID and then the
>> MSR, the consistency is upheld by these checks:
>>
>>          if (!is_bitwise_subset(data, supported, GENMASK_ULL(31, 0)))
>>                  return -EINVAL;
>>
>>          if (!is_bitwise_subset(supported, data, GENMASK_ULL(63, 32)))
>>                  return -EINVAL;
> 
> Right, this works if KVM chose to clear the bit, but userspace is trying
> to set it. If KVM chose to set the bit, and userspace attempts to clear
> it, these checks would pass.

Okay, that's what I expected too but I thought it would be okay that the 
checks pass.  Are you trying to undo an involuntary API change, and if 
so why was the change a bug and not a fix?

Paolo


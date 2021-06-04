Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4F839B3A9
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 09:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhFDHTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 03:19:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40701 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhFDHTh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Jun 2021 03:19:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622791071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oYiGBrwOVwQzTkg4cxNvQnAUyjlM8dxbSVyQ8B6K+H0=;
        b=Q9jt1ohKzlREsRBALsF2PdX+TbAb6WQurW/IWqmBo8GHx3+yMgvVkEIkrLNMggCd+JSDfK
        PeCMNXEHRGtjHXB7v7M8M6Vw9ZPQT4oDNXM2AraAuyUH4s+NcHh24aLqDhUTDSG+/EOOb5
        iTDyRPDit1AzKNwycWbaGpI/74yQ0ko=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-3_09RFvROBqj19A24MajPQ-1; Fri, 04 Jun 2021 03:17:50 -0400
X-MC-Unique: 3_09RFvROBqj19A24MajPQ-1
Received: by mail-ed1-f71.google.com with SMTP id j13-20020aa7de8d0000b029038fc8e57037so4563397edv.0
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 00:17:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oYiGBrwOVwQzTkg4cxNvQnAUyjlM8dxbSVyQ8B6K+H0=;
        b=iNP2SSrnzkPVyiDPX6z7vC2bYIfrxQo8WhIMmEo2UQjwsEo7kRtmths2rbptbPzads
         FgHo/beJch1V26aVYhFg/olXZVmJVPe4dHnYkW28IDo+iZYSBo3e3mBlysQVR7/cmn5/
         nMXIW/sw7Ury4SLopJmvZDG/G1HbaPolT+dHRIjzBQYO4AsT1gTB7CtTqhOUyljsFBoD
         nV/eNeFnO3MYKDrs08JdwzhbxvJzuHRTayA2yV0Ki1HQmUascEp6XX7zKjRAqv9TZvQH
         4ZhkTFIn5Pi2k+YZdNI4V1DrdqQNk3VJNWCxePQQf0JlzJpPK9fsU4dNesLyAV8kuVUB
         H2eQ==
X-Gm-Message-State: AOAM532UD1vqFyirxmTUJLB0jxSvIQN63m9B/olO1xbf/6DwYIjIKf8A
        0jRs0ALTEp6zgBNOPW3C4F096jXQioYwH1NhJfmNWicvipEb+Ou+lgfrVr4v7e6aGVkjXZIM6W8
        x6ZAWy6Or78Su
X-Received: by 2002:a17:906:1982:: with SMTP id g2mr2940211ejd.184.1622791069074;
        Fri, 04 Jun 2021 00:17:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNA+cR803OKErcII3/XiBGdUlseY07tlmT5T9SKrsahaFVgc/V2SdsxWbxXtho/hDOs9RuiA==
X-Received: by 2002:a17:906:1982:: with SMTP id g2mr2940199ejd.184.1622791068902;
        Fri, 04 Jun 2021 00:17:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id um5sm2430354ejb.109.2021.06.04.00.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 00:17:48 -0700 (PDT)
Subject: Re: [RFC][PATCH] kvm: add suspend pm-notifier
To:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210603164315.682994-1-senozhatsky@chromium.org>
 <YLkRB3qxjrXB99He@hirez.programming.kicks-ass.net>
 <YLl2QeoziEVHvRAO@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1a460c63-89d6-b7ae-657b-2c4b841c9562@redhat.com>
Date:   Fri, 4 Jun 2021 09:17:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YLl2QeoziEVHvRAO@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/21 02:39, Sergey Senozhatsky wrote:
>>>   
>>> +void kvm_arch_pm_notifier(struct kvm *kvm)
>>> +{
>>> +}
>>> +
>>>   long kvm_arch_vm_ioctl(struct file *filp,
>>>   		       unsigned int ioctl, unsigned long arg)
>>>   {
>> What looks like you wants a __weak function.
> True. Thanks for the suggestion.
> 
> I thought about it, but I recalled that tglx had  __strong opinions
> on __weak functions.
> 

Alternatively, you can add a Kconfig symbol to virt/kvm/Kconfig and 
select it from arch/x86/kvm.

Paolo


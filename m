Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AA042F7AC
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 18:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241123AbhJOQIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 12:08:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53567 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241045AbhJOQId (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 12:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634313985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1aoeziL0xzFFKN0RHg65RlSBhdoiRCAVh5QP+AQQgH4=;
        b=i1SUPcDs3oIIZHFEWYFEwP41d6M3TQ//2oRSjIqbPHrmwbnTFI0PLIDeICKgpk2YQWX7fm
        DrFqgoaO56HU/xBoFjn40bkW/wD82Qq052AZGidhRRTZFB/IRDGrFUI1JnnlaUmm+3Xjl4
        1Aari674lZnumfYwX1cz8gvjkkzzmx4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-LTt9Cn4PPl6I3ggib1-Ivw-1; Fri, 15 Oct 2021 12:06:24 -0400
X-MC-Unique: LTt9Cn4PPl6I3ggib1-Ivw-1
Received: by mail-ed1-f72.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso8598034edj.20
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 09:06:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1aoeziL0xzFFKN0RHg65RlSBhdoiRCAVh5QP+AQQgH4=;
        b=lrHzHFcFw/71hc9cru7niS7TceGU/7hLm2UNwVeHTFXbLxSwIY0ZD1sDYu9X6vR3vY
         cha3cQfKSfmhJISnmZpdMjhzCGq+aBID/iGw/5WNX3PU6nyh7Yn8z7I1Nq/o/cBvEoNL
         u7qD0UPrj59Anik/nX1RYaol+2R4M4gIAnKhooWwKshD/yBkmkENDni931j137wgiRe5
         X+nJbT9U1DI3gTCtHtIgXYltYUcsV5wYQlA7muCbSOs42bwavUaRh1lvr1B/a+pzIvlo
         ignt3eQ3lVmp72u1uIhRiIiFUCKCIF/B4Uk9cIjc8+JYNYN8JxPAZB4Z0WoZIcfYKW3g
         rbpw==
X-Gm-Message-State: AOAM531Wsw384xOAYj2Nl13QzWWJDxiRUw9/1O/syAMzfLfE41urRU8l
        Un7hDw1DFS5adA1XJEOVUm2vz9hiBxhlsKeazAzqBY9T1m9aUEccEabjZUXZFIyrpBxuaOIMZhc
        /tzsIDDJRqV/P
X-Received: by 2002:a05:6402:2345:: with SMTP id r5mr18689605eda.202.1634313983387;
        Fri, 15 Oct 2021 09:06:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzg0/9UNg7sGN4xD0y08rcDfbbj0LEzqB1J+T+jKrBu5AmUtRQ0wDHH8hA8gYlX5601Yl9lrw==
X-Received: by 2002:a05:6402:2345:: with SMTP id r5mr18689580eda.202.1634313983137;
        Fri, 15 Oct 2021 09:06:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ck9sm4514467ejb.56.2021.10.15.09.06.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 09:06:22 -0700 (PDT)
Message-ID: <5785637f-2b1a-b4c7-1f9e-67711f284264@redhat.com>
Date:   Fri, 15 Oct 2021 18:06:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86: Account for 32-bit kernels when handling
 address in TSC attrs
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211007231647.3553604-1-seanjc@google.com>
 <CAOQ_Qsj9yiChnBZmotdYFYgsd=C0J5XXR8mthdiC+iXX22F7jw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAOQ_Qsj9yiChnBZmotdYFYgsd=C0J5XXR8mthdiC+iXX22F7jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/21 16:35, Oliver Upton wrote:
> On Thu, Oct 7, 2021 at 6:16 PM Sean Christopherson <seanjc@google.com> wrote:
>>
>> When handling TSC attributes, cast the userspace provided virtual address
>> to an unsigned long before casting it to a pointer to fix warnings on
>> 32-bit kernels due to casting a 64-bit integer to a 32-bit pointer.
>>
>> Add a check that the truncated address matches the original address, e.g.
>> to prevent userspace specifying garbage in bits 63:32.
>>
>>    arch/x86/kvm/x86.c: In function ‘kvm_arch_tsc_get_attr’:
>>    arch/x86/kvm/x86.c:4947:22: error: cast to pointer from integer of different size
>>     4947 |  u64 __user *uaddr = (u64 __user *)attr->addr;
>>          |                      ^
>>    arch/x86/kvm/x86.c: In function ‘kvm_arch_tsc_set_attr’:
>>    arch/x86/kvm/x86.c:4967:22: error: cast to pointer from integer of different size
>>     4967 |  u64 __user *uaddr = (u64 __user *)attr->addr;
>>          |                      ^
>>
>> Cc: Oliver Upton <oupton@google.com>
>> Fixes: 469fde25e680 ("KVM: x86: Expose TSC offset controls to userspace")
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   arch/x86/kvm/x86.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
> 
> Reviewed-by: Oliver Upton <oupton@google.com>
> 

Squashed, thanks.

Paolo


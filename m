Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F7D371718
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 16:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhECOxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 10:53:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229595AbhECOxm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 10:53:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620053568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rkdgV17Gm02P7t7dZkmC73s5tJJWZNXKdgqQub3pjBY=;
        b=Z9R+A1YFoONAQqsmN5uOSFwMX2BpeGKs/PRrSOuI0rA7pDyUaE37PlnXwAwLfOVVOS1H/6
        IsXsOIWwRkruqfzctMOGdB1raRExw2om83f4jZpQY75oOP7cwx0wLSXP+6YLqTEChpdv5Y
        1KVcQUybDZzeuIKV2V+HQfhU7zHF+Fk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-nj-RWGftO1GSx2uTngzwUg-1; Mon, 03 May 2021 10:52:47 -0400
X-MC-Unique: nj-RWGftO1GSx2uTngzwUg-1
Received: by mail-ej1-f71.google.com with SMTP id w2-20020a1709062f82b0290378745f26d5so2136867eji.6
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 07:52:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rkdgV17Gm02P7t7dZkmC73s5tJJWZNXKdgqQub3pjBY=;
        b=ShkgwNpI4zrmbHD1Z5olqHDAACoVfhpfKnoCY1bzSS67Wl2E0zK7mRx6gvDdJF/EHc
         Z/aqGvQNly2KM4CDoZTrHxCcVz05pdHKhcbdpdsUD1EIIfQW227VVVwK50dka4liFEqS
         GeY7mJqYUdKVPhsq01SLIUSr6VDchNI3QFNPZIJ9Knt+ALx8yKKTrR1oZIOtx+Z37Zng
         7349GelEDWZHYTh7RPafswfP62gsWJdC11/csfUovIij+MhnxFwLbEBkviOeTyCdDQIh
         hgfhErW58ckFKiFwZZpV1BJ1awVpi2ZkU082JKOiYb2DOjR3N4Rh81WII+hjD9BHcvLP
         mjPg==
X-Gm-Message-State: AOAM5304apogR7sQ+QMWHas6H+w+QOh3I5SwhAqLvoAIXbR/QrlU2/O9
        w7w5I+u+YGL1151rTeqOPTBzVHujSOpuGtIjwaa59rZmvTJBiNqgq4EA6fOoGsgUgDbRNudf2bK
        GDrgCrHO8LL96
X-Received: by 2002:a17:906:6717:: with SMTP id a23mr2683768ejp.502.1620053566165;
        Mon, 03 May 2021 07:52:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMnE2sNfuuwJIyaATAlZeh5FXkX8/38mwdTCXyAo7/QwZgnvkrmG3xAH0wA2P0O2Bp4tbR1w==
X-Received: by 2002:a17:906:6717:: with SMTP id a23mr2683754ejp.502.1620053566011;
        Mon, 03 May 2021 07:52:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e4sm11109708ejh.98.2021.05.03.07.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 07:52:45 -0700 (PDT)
Subject: Re: [PATCH] kvm: exit halt polling on need_resched() as well
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        kvm@vger.kernel.org, jmattson@google.com, dmatlack@google.com
Cc:     Benjamin Segall <bsegall@google.com>
References: <20210429162233.116849-1-venkateshs@chromium.org>
 <ea54b776-c15a-e718-d7c9-ae8df7f24de3@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2d4ebb6d-02d8-193c-c7e9-64ec233add6e@redhat.com>
Date:   Mon, 3 May 2021 16:52:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <ea54b776-c15a-e718-d7c9-ae8df7f24de3@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/21 19:43, Christian Borntraeger wrote:
> 
> 
> On 29.04.21 18:22, Venkatesh Srinivas wrote:
>> From: Benjamin Segall <bsegall@google.com>
>>
>> single_task_running() is usually more general than need_resched()
>> but CFS_BANDWIDTH throttling will use resched_task() when there
>> is just one task to get the task to block. This was causing
>> long-need_resched warnings and was likely allowing VMs to
>> overrun their quota when halt polling.
>>
>> Signed-off-by: Ben Segall <bsegall@google.com>
>> Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
> 
> would that qualify for stable?

Good idea indeed, I added the Cc.

Paolo

>> ---
>>   virt/kvm/kvm_main.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 2799c6660cce..b9f12da6af0e 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -2973,7 +2973,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>>                   goto out;
>>               }
>>               poll_end = cur = ktime_get();
>> -        } while (single_task_running() && ktime_before(cur, stop));
>> +        } while (single_task_running() && !need_resched() &&
>> +             ktime_before(cur, stop));
>>       }
>>
>>       prepare_to_rcuwait(&vcpu->wait);
>>
> 


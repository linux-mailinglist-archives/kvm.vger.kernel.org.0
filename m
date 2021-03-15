Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0534933C1A0
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 17:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhCOQYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 12:24:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232445AbhCOQXo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 12:23:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615825424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3wdZ2o2UMvoAMlrjWoFf17ZzvfbNLm3Hw3Ulncm86lM=;
        b=heE/TPvyDvuRjmUu1q8P5l2hLARjFkXSMtq5VzX+fmOnXStXygb8PnsbwP1Hg7bgNXsLw5
        a4BP8coNQrd71GTHY9kCJAye3Lze1GgMky3FJKQAD99S1v6ZHbE5CBHkKLswfr5wbfwmCo
        x1jyM8C/9NJ9YCcZxI8D3uRARb15OBc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-BPA3bdVYNFOvdqzVgFWEKg-1; Mon, 15 Mar 2021 12:23:42 -0400
X-MC-Unique: BPA3bdVYNFOvdqzVgFWEKg-1
Received: by mail-wm1-f70.google.com with SMTP id y9so3013305wma.4
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 09:23:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3wdZ2o2UMvoAMlrjWoFf17ZzvfbNLm3Hw3Ulncm86lM=;
        b=dXQcQJkpv9E//ZQ+2jftY+tE9CungrCqyWQ2h3KwbbenejnMwT/diyNcFf29Y1bITH
         m8TAgyTgPeiC5v4XqriMoQStSKsxuk0eew1Ql0dwXEUT8Op88CPk8OkCE3Wy2cDjh1eq
         LQ9yNsf7XwS525zGYojCT/YHJRPeTdSo2ioGhl8T4Pa29IVHvAABgBY2FPhEXWeHEo1G
         Q89tJmrHfp1IjlAsr48pKBsLygZ9EPianxu9hCHhLNYcSByGo/WrMJanJGGu77BsTcmV
         pfoaYvyZcg0ZrO2o0EmaR2gDQEH/df3Yw2FpS4pZuCeiw7F/v+d3Cq3dNn6yzWo4bsEi
         LvaQ==
X-Gm-Message-State: AOAM532G0B9iypoMZlMh9oouIXiVrGVPpUj+gH/tjt0vlEDmQHQfdo6g
        BF0aHFCftDvFt3CVy4RLL2CcHZsTYcjCS67DooiZoFr08tTPY89sSd6KR6LdsY2PJ1xyj46mAK1
        duEAjGVHx28gy
X-Received: by 2002:a7b:c38d:: with SMTP id s13mr499085wmj.44.1615825420886;
        Mon, 15 Mar 2021 09:23:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx48wpeFGkULhUPziop+7I6XIylLHEf7uh9fFC7HbtW8j8rz7mfnHbK8sHo+NqkbmpdQHaE9Q==
X-Received: by 2002:a7b:c38d:: with SMTP id s13mr499067wmj.44.1615825420735;
        Mon, 15 Mar 2021 09:23:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id v13sm22098238wrt.45.2021.03.15.09.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 09:23:40 -0700 (PDT)
Subject: Re: [PATCH 2/4] KVM: x86: hyper-v: Prevent using not-yet-updated TSC
 page by secondary CPUs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <20210315143706.859293-1-vkuznets@redhat.com>
 <20210315143706.859293-3-vkuznets@redhat.com>
 <6b392d7e-8135-53a9-9040-f6f5e316c6cb@redhat.com>
 <87im5s8l9g.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <92bccdca-b6bb-5c09-c5a1-5c75e5a3887d@redhat.com>
Date:   Mon, 15 Mar 2021 17:23:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <87im5s8l9g.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/03/21 16:55, Vitaly Kuznetsov wrote:
>> I think we should instead write 0 to the page in kvm_gen_update_masterclock.
>
> We can do that but we will also need to invalidate
> hv->tsc_ref.tsc_sequence to prevent MSR based clocksource
> (HV_X64_MSR_TIME_REF_COUNT -> get_time_ref_counter()) from using stale
> hv->tsc_ref.tsc_scale/tsc_offset values (in case we had them
> calculated).

Yes, we're talking about the same thing (invalidating tsc_sequence is 
done by writing 0 to it).

Paolo

> Also, we can't really disable TSC page for nested scenario when guest
> opted for reenlightenment (PATCH4) but we're not going to update the
> page anyway so there's not much different.
> 


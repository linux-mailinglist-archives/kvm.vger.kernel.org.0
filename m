Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3FB355B7B
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 20:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238637AbhDFSgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 14:36:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47920 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229681AbhDFSgI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 14:36:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617734160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=onYMsdqIwwMtCr/o99OSThEm1roisnCtNhad6j+yKxI=;
        b=DP1oBKkaMKfC0/V4yNtpA34Qwm0u7TjkQz5XC08KFt+A4nBfGZZprISbV1n7icqZNH8pKv
        Yw3qBUd5qTUrx1czaxgNRoa/v328J0S9hB12f/TlvPyBlNpQGDHNNUKKghjPa3IJJsz1PV
        qQXJ4+ecn/DoIdW1LT9ZQBxaA2Pzdu8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-kSz48qipNxO6AEOfYzZ__g-1; Tue, 06 Apr 2021 14:35:58 -0400
X-MC-Unique: kSz48qipNxO6AEOfYzZ__g-1
Received: by mail-ed1-f72.google.com with SMTP id i12so10911118edu.23
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 11:35:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=onYMsdqIwwMtCr/o99OSThEm1roisnCtNhad6j+yKxI=;
        b=llnkAhQlCSxGxq4Sa1+NRNvELZE7VdlLZrMJZhfXyNOPg0GRGSfWTsQTF3btalAN0k
         IpfdY2l6l0F5HxZ3AxqW72qFpRpbK+S1QN9T/Zy5WH2P76mvbvTD0jt06FDbVyUS+U06
         XlkckJ6n/h0kf3ZEdm/EZ6RN65YuV04ssF2yy+KfsbzspGKepiLdaYTF1EEu4AgfpWKl
         Uf2bbfQPGhdD4kt9wtkD1/AFfNs2afi1PdGgBuLRkyRnI/y/7DjhXTvuRujCJWZzC4LM
         6snK3nWP8ZmFL9kv0wINNFqdG2TRcFZSOZKY4a4dum7HbzHn9A2WnU7f3BqNjUHU+u6s
         G2Bg==
X-Gm-Message-State: AOAM530UVT09EzFPGBl+IQHS60oFWgBRz+k25vmd1ZB8MN9lozK4maWF
        UT56//s0Gwk8aER4ybYS5ORYUbgFZPdLY7gJMK6qaK7ClQVCTwiZsPdRmRvsPBYbXbG9U4uY5au
        r0bnCNfw0LAjO
X-Received: by 2002:a17:906:c09:: with SMTP id s9mr1792131ejf.145.1617734156987;
        Tue, 06 Apr 2021 11:35:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+m3afEzHGEFBRSYcpNWuNWxD4R4p0GKyEey8a1eUb3RGjB3HAAYaJy/46vwEJJQyto184DQ==
X-Received: by 2002:a17:906:c09:: with SMTP id s9mr1792113ejf.145.1617734156774;
        Tue, 06 Apr 2021 11:35:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b24sm1413630ejq.75.2021.04.06.11.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 11:35:56 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: preserve pending TLB flush across calls to
 kvm_tdp_mmu_zap_sp
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, stable@vger.kernel.org
References: <20210406162550.3732490-1-pbonzini@redhat.com>
 <YGynf54vwWpyxhz4@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d93cb5c8-e54a-6f5a-c660-9d044ff2c743@redhat.com>
Date:   Tue, 6 Apr 2021 20:35:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGynf54vwWpyxhz4@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/04/21 20:25, Greg KH wrote:
> On Tue, Apr 06, 2021 at 12:25:50PM -0400, Paolo Bonzini wrote:
>> Right now, if a call to kvm_tdp_mmu_zap_sp returns false, the caller
>> will skip the TLB flush, which is wrong.  There are two ways to fix
>> it:
>>
>> - since kvm_tdp_mmu_zap_sp will not yield and therefore will not flush
>>    the TLB itself, we could change the call to kvm_tdp_mmu_zap_sp to
>>    use "flush |= ..."
>>
>> - or we can chain the flush argument through kvm_tdp_mmu_zap_sp down
>>    to __kvm_tdp_mmu_zap_gfn_range.
>>
>> This patch does the former to simplify application to stable kernels.
>>
>> Cc: seanjc@google.com
>> Fixes: 048f49809c526 ("KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping")
>> Cc: <stable@vger.kernel.org> # 5.10.x: 048f49809c: KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping
>> Cc: <stable@vger.kernel.org> # 5.10.x: 33a3164161: KVM: x86/mmu: Don't allow TDP MMU to yield when recovering NX pages
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/mmu/mmu.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Is this for only the stable kernels, or is it addressed toward upstream
> merges?
> 
> Confused,

It's for upstream.  I'll include it (with the expected "[ Upstream 
commit abcd ]" header) when I post the complete backport.  I'll send 
this patch to Linus as soon as I get a review even if I don't have 
anything else in the queue, so (as a general idea) the full backport 
should be sent and tested on Thursday-Friday.

Paolo


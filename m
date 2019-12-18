Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A125B124E11
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 17:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfLRQmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 11:42:06 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55452 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727121AbfLRQmF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 11:42:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576687324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BATXLD2735eSsv+Ci71FjK/3o7MP7Rj1HcsBjxTaRLs=;
        b=X3ZhmMLam4JU9zMxGovo41TzSS5xMyR63vFtQoYgzWeqVjWi/ljHXaOXpr5RJp2cHtsJGB
        YesKCyKTtWaVa9C+NPy5HM3qrz/mLfLfRKaUwqjo+QS+Dfakpntu4wZmHzq9OCGh9SkStd
        GuiaqlW0V27RyHcPtjqpNt4qPFBqmGM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434--kgY7L2zODydy00M-v6SMw-1; Wed, 18 Dec 2019 11:42:03 -0500
X-MC-Unique: -kgY7L2zODydy00M-v6SMw-1
Received: by mail-wm1-f69.google.com with SMTP id b9so646657wmj.6
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 08:42:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BATXLD2735eSsv+Ci71FjK/3o7MP7Rj1HcsBjxTaRLs=;
        b=dbjiF7PKWgtYMs/rGJTMnAFmLHg66SlKYMnrsnd2b81Yabb6LU8fI88nr3uDJQ3yOk
         KdkH66hi2jDurq9nDqSgcCp37lzN2IcDeUJ1oZHlVs9TSiSKiLK5v30WYFrzVP6KYHQd
         Oc6MsJufQz/qoeCB+nEsRRHNyFqAeEnJfrvLkaj9nX06iYui0X6hwAvni5lzn12Mw7ib
         ALn3zGdW9T8rSkz9J+mnbq5T1rpYatwGpC7pFhB1uEn/DiaRnHSsfAN9NF3/Q14TD0m8
         MGQuhdnwG1rd4bQzC+xVb7W6pltkz7Db2EgnlWfK7q4rp1v2dWpSGcYWF7xbUrAZQcym
         jSBQ==
X-Gm-Message-State: APjAAAWMjwS2rTlgZMYfs+mApJ1Y6WHCHIfm/imYrQWbGnbDY9xKgAn+
        i6gIbS/niV5rPFPgAYuaaijEHsfj4Td78onjvsEunH1FPZwUI8ZEzFn3F0GR19SkFhc/SQb/9ky
        P9Sd4yTLIWiSl
X-Received: by 2002:a1c:5f06:: with SMTP id t6mr4411546wmb.32.1576687321978;
        Wed, 18 Dec 2019 08:42:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqy0w+0Foy8IN6Dsyw16t2SmXcya+bZVFa5MJ9MWOrDPKOP3jRs72UuDNTN4AafsY1gZ0dSTCw==
X-Received: by 2002:a1c:5f06:: with SMTP id t6mr4411519wmb.32.1576687321761;
        Wed, 18 Dec 2019 08:42:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ac09:bce1:1c26:264c? ([2001:b07:6468:f312:ac09:bce1:1c26:264c])
        by smtp.gmail.com with ESMTPSA id v188sm3223075wma.10.2019.12.18.08.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 08:42:01 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Peter Xu <peterx@redhat.com>
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20191213202324.GI16429@xz-x1>
 <bc15650b-df59-f508-1090-21dafc6e8ad1@redhat.com>
 <E167A793-B42A-422D-8D46-B992CB6EBE69@redhat.com>
 <d59ac0eb-e65a-a46f-886e-6df80a2b142f@redhat.com>
 <20191217153837.GC7258@xz-x1>
 <ecb949d1-4539-305f-0a84-1704834e37ba@redhat.com>
 <20191217164244.GE7258@xz-x1>
 <c6d00ced-64ff-34af-99dd-abbcbac67836@redhat.com>
 <20191217194114.GG7258@xz-x1>
 <838084bf-efd7-009c-62ce-f11493242867@redhat.com>
 <20191218163238.GC26669@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <577e68a6-22ad-d8a2-81f3-1f71b02d0a18@redhat.com>
Date:   Wed, 18 Dec 2019 17:41:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191218163238.GC26669@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/12/19 17:32, Peter Xu wrote:
>> With PML it is.  Without PML, however, it would be much slower to
>> synchronize the dirty bitmap from KVM to userspace (one atomic operation
>> per page instead of one per 64 pages) and even impossible to have the
>> dirty ring.
>
> Indeed, however I think it'll be faster for hardware to mark page as
> dirty.  So could it be a tradeoff on whether we want the "collection"
> to be faster or "marking page dirty" to be faster?  IMHO "marking page
> dirty" could be even more important sometimes because that affects
> guest responsiveness (blocks vcpu execution), while the collection
> procedure can happen in parrallel with that.

The problem is that the marking page dirty will be many many times
slower, because you don't have this

                        if (!dirty_bitmap[i])
                                continue;

and instead you have to scan the whole of the page tables even if a
handful of bits are set (reading  4K of memory for every 2M of guest
RAM).  This can be quite bad for the TLB too.  It is certainly possible
that it turns out to be faster but I would be quite surprised and, with
PML, that is more or less moot.

Thanks,

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1DA011F0D3
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 08:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbfLNH5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Dec 2019 02:57:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22030 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725871AbfLNH5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Dec 2019 02:57:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576310249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x9Bb0Zg6nYlZHmt3Jv+uUkpX8UNR1qjNTKqsdhP1H0A=;
        b=gDZ/rVIuePzwNsQmYfSDMzGmiHy7uBjuW4lXM8D8R3GlWX+h+DdAwLgiCIjHdMMlo7UIlH
        Osq4VOLjtOeMTNIGjU3x452IZZTc4tSpJlRXPhzzZUBEgzyVy+pRY97OUNmSsxIiW1YGsA
        Po1J1u0QgQM0bsm3bZT3zSQpAQTQJIY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-1W9AXZuHMgynL_F5mYmoOA-1; Sat, 14 Dec 2019 02:57:28 -0500
X-MC-Unique: 1W9AXZuHMgynL_F5mYmoOA-1
Received: by mail-wr1-f71.google.com with SMTP id 90so675864wrq.6
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 23:57:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x9Bb0Zg6nYlZHmt3Jv+uUkpX8UNR1qjNTKqsdhP1H0A=;
        b=KC5D4iPh9QB+0Hwo8pbcYvWv/8KXsBGqKT0vfD+YMGIJzxk40vdJdmxC3TwQE1Is/R
         B3U+nmswNVf5oJtL1jk7n7Gaf+HxC2QyyYaLVw75et2qtj9XTQdYR+94jpyNrJI8VltK
         6RN3oCI8DDVUWU2HFwiEhgBrosIvGtlinu5WMosXPDdomqF2Bq6ynBEPSVkJ+7+nx9Ii
         m9zCzwbaqlx8sa30oMrZ0TEyRl2CJqYb5XaWS3sNVHTmDrLUukfGNyFrqk15Uvjg4A87
         QM5iMqACmWfqB2x6ESDA1kGJ8v0XfmvpRM8VYtToDvNkABWzhZ27kt37vy+4uD4BeSyf
         LLVg==
X-Gm-Message-State: APjAAAUyaXeSlxo5DI9BdV77AFON9LfqFeygSwDzf+mWxYZBLu0J6U8k
        81GU4K0/Hcj9lNF7etSwmrQH26XCaNp7A6X0sCpdNqPgjJrMYOcoibtxiWR06Jwatp26mWu4wI9
        IPU1zNiraNpf6
X-Received: by 2002:a7b:c1d8:: with SMTP id a24mr18263331wmj.130.1576310247425;
        Fri, 13 Dec 2019 23:57:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqxUPZl8ZJUZZxd6OiscWyJHrZpVYfPirrw/vPJCsP1enhyrIyTxhigfjg1mAw+ULmy66b/+CA==
X-Received: by 2002:a7b:c1d8:: with SMTP id a24mr18263308wmj.130.1576310247108;
        Fri, 13 Dec 2019 23:57:27 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:cde8:2463:95a9:1d81? ([2001:b07:6468:f312:cde8:2463:95a9:1d81])
        by smtp.gmail.com with ESMTPSA id n3sm13470462wmc.27.2019.12.13.23.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 23:57:26 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Peter Xu <peterx@redhat.com>,
        Christophe de Dinechin <christophe.de.dinechin@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com> <m1lfrihj2n.fsf@dinechin.org>
 <20191213202324.GI16429@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bc15650b-df59-f508-1090-21dafc6e8ad1@redhat.com>
Date:   Sat, 14 Dec 2019 08:57:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191213202324.GI16429@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/19 21:23, Peter Xu wrote:
>> What is the benefit of using u16 for that? That means with 4K pages, you
>> can share at most 256M of dirty memory each time? That seems low to me,
>> especially since it's sufficient to touch one byte in a page to dirty it.
>>
>> Actually, this is not consistent with the definition in the code ;-)
>> So I'll assume it's actually u32.
> Yes it's u32 now.  Actually I believe at least Paolo would prefer u16
> more. :)

It has to be u16, because it overlaps the padding of the first entry.

Paolo

> I think even u16 would be mostly enough (if you see, the maximum
> allowed value currently is 64K entries only, not a big one).  Again,
> the thing is that the userspace should be collecting the dirty bits,
> so the ring shouldn't reach full easily.  Even if it does, we should
> probably let it stop for a while as explained above.  It'll be
> inefficient only if we set it to a too-small value, imho.
> 


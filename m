Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E33F122B43
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 13:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfLQMTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 07:19:12 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51204 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726164AbfLQMTM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Dec 2019 07:19:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576585150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dqg01LKWcSSGVHIQsUHqk7EvSOdnDyxLHyBMZ00zNzI=;
        b=WkaUI7LW13p0lEcYyEw3KI0XVKySCHobANJgCH3dwOGJ/CnCDPvPIGBMOlX1QWUFM4D7vX
        9rf/5B6kVmiEnVwGBoUF1+Om6vCsJn0qZhJ+1vDY6EKRfZz5w/TBxZWgVbSMl5xrUFA4MO
        lgRiAxsGMt7ZlGYbrUOxkdWl92u9Y88=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-aNMEuxFmPYedqg4ap2qH3Q-1; Tue, 17 Dec 2019 07:19:08 -0500
X-MC-Unique: aNMEuxFmPYedqg4ap2qH3Q-1
Received: by mail-wr1-f71.google.com with SMTP id u12so3584388wrt.15
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 04:19:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dqg01LKWcSSGVHIQsUHqk7EvSOdnDyxLHyBMZ00zNzI=;
        b=rbpKesrcmn3S4Id/k2+0tb0A1VNqHjkus1KkOlhu1/zE5TMzLxkxkrEvZx4vcoseBn
         ptVTIh6gSMGFtdasBR5Lo/EpbDpvc23MEbcFFz0AgEGtlJf+IGhGHHGUPYJcpqg8AgCQ
         yrLH2OUHH94EaaP8Y25VokjrptjRU7BkpAy/VpPe0fF9ZTaK+hu0pe90E1uj8yoKTlh2
         of2Yzm652Q8TzFMpjqxZlUZ9DMkNJwe3XPs5ysb4zVOXBWMEvru9g+NvWdM37j2185oP
         n+T19Yr2NtG0kqtMScSI53facIss5LEgy/U2NZAxCLYsIMKrTIs8Ii9EOW+551qxMBEw
         lmKQ==
X-Gm-Message-State: APjAAAX50eaQY4EAsgX4RwlTQTlrjxHnHydz/NGshWxfx7GygzFOrUID
        2F91L0W1WJ/u/TGe8+H3kV+prYu993fZ42EWMkNXGdct4KYce78dae7QD2hpmCatmOWqEWxxnWH
        NTfquIR6Wmdtn
X-Received: by 2002:adf:fa0b:: with SMTP id m11mr36185371wrr.98.1576585147125;
        Tue, 17 Dec 2019 04:19:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqwaiitjL7kRxtCYWSVVnB8Pj3l3qeQjc4n4PlSKBP2tfw9KS5qKi2jIS35RGTD+4QTB8cSseg==
X-Received: by 2002:adf:fa0b:: with SMTP id m11mr36185356wrr.98.1576585146887;
        Tue, 17 Dec 2019 04:19:06 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:503f:4ffc:fc4a:f29a? ([2001:b07:6468:f312:503f:4ffc:fc4a:f29a])
        by smtp.gmail.com with ESMTPSA id o6sm2949280wmb.4.2019.12.17.04.19.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 04:19:06 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Christophe de Dinechin <dinechin@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com> <m1lfrihj2n.fsf@dinechin.org>
 <20191213202324.GI16429@xz-x1>
 <bc15650b-df59-f508-1090-21dafc6e8ad1@redhat.com>
 <E167A793-B42A-422D-8D46-B992CB6EBE69@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d59ac0eb-e65a-a46f-886e-6df80a2b142f@redhat.com>
Date:   Tue, 17 Dec 2019 13:19:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <E167A793-B42A-422D-8D46-B992CB6EBE69@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/19 13:16, Christophe de Dinechin wrote:
> 
> 
>> On 14 Dec 2019, at 08:57, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 13/12/19 21:23, Peter Xu wrote:
>>>> What is the benefit of using u16 for that? That means with 4K pages, you
>>>> can share at most 256M of dirty memory each time? That seems low to me,
>>>> especially since it's sufficient to touch one byte in a page to dirty it.
>>>>
>>>> Actually, this is not consistent with the definition in the code ;-)
>>>> So I'll assume it's actually u32.
>>> Yes it's u32 now.  Actually I believe at least Paolo would prefer u16
>>> more. :)
>>
>> It has to be u16, because it overlaps the padding of the first entry.
> 
> Wow, now that’s subtle.
> 
> That definitely needs a union with the padding to make this explicit.
> 
> (My guess is you do that to page-align the whole thing and avoid adding a
> page just for the counters)

Yes, that was the idea but Peter decided to scrap it. :)

Paolo

>>
>> Paolo
>>
>>> I think even u16 would be mostly enough (if you see, the maximum
>>> allowed value currently is 64K entries only, not a big one).  Again,
>>> the thing is that the userspace should be collecting the dirty bits,
>>> so the ring shouldn't reach full easily.  Even if it does, we should
>>> probably let it stop for a while as explained above.  It'll be
>>> inefficient only if we set it to a too-small value, imho.
>>>
>>
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E0311697B
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 10:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfLIJhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 04:37:06 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30038 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727160AbfLIJhF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Dec 2019 04:37:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575884224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yz/Z2Uyi82Tsm+Aa8fxJXMQfCMt+llfBcTS4k9m0UwA=;
        b=NLboOS2m/G+Zd6wUxfu/3bT0gSWQrJhZqtQpoBV8hTT+YPqMVHqoC4fu3+jl8iFiJDLtPx
        3DEGtgHblFLW9E5Zb1QFamIsQOPoJf6hTVZfDMhuUKAHmb/PeZG1wYtcCdAyyLYD8CQfBF
        kPomYTQBylJA8bpncxs4LxkfNcDYras=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-Bt1ECc4YP9iZ_QrEkeRT6Q-1; Mon, 09 Dec 2019 04:37:03 -0500
Received: by mail-wm1-f71.google.com with SMTP id q21so3630091wmc.7
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 01:37:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yz/Z2Uyi82Tsm+Aa8fxJXMQfCMt+llfBcTS4k9m0UwA=;
        b=dQ/wQobn9za+R2+523FGwlBh3ll3YdxoIPi/K8LmRFeXwyHebJz3BlX3Cm7u1DkArz
         q8geDKh3OtYZcRt1YyDUg+/z2R60MzItTr6ie055Cba0QxXwUQKMy81JOSATDJsFIua6
         mx69wZBEnHbwaiIRRFBEq+FesfuhFjA/Kb5HmH1AclSm53HJw3zZgETec/5YQ5y2JrEa
         Oe6AfQn9ZENYX65s1WvbKdgx3bApGpieVngj2UZOdJMDQX29De/DqYPDUbqvByf4twOr
         LIXpomhMky87cR08r9SO0CIWuEzHpCll5vYe44kdMjxRTFlVztVal2ANlnVxUah9zEbM
         p6bA==
X-Gm-Message-State: APjAAAX4dQkZw9VekAR7lS5cF5MV1wY/dIVXsDW63zrzQ6x30/h8O2+6
        7WbGE69HfZ0v8U03aS/egV7ZJ1RiidykJsqhzgYk81BuP1ckwckKBNdBUNkrxACtrCG1PV3P9NG
        Urk+XJrXqEw2D
X-Received: by 2002:a1c:e909:: with SMTP id q9mr24499559wmc.30.1575884221781;
        Mon, 09 Dec 2019 01:37:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqzAW5LiyEF46zD4Bc+SWJqctxeL2ft11pv6kleMPxWl5MUVH4VkiuoT9F9bBt7G0hp8RX36XA==
X-Received: by 2002:a1c:e909:: with SMTP id q9mr24499533wmc.30.1575884221452;
        Mon, 09 Dec 2019 01:37:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id n30sm12564626wmd.3.2019.12.09.01.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 01:37:00 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191202201036.GJ4063@linux.intel.com> <20191202211640.GF31681@xz-x1>
 <20191202215049.GB8120@linux.intel.com>
 <fd882b9f-e510-ff0d-db43-eced75427fc6@redhat.com>
 <20191203184600.GB19877@linux.intel.com>
 <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
 <20191207002904.GA29396@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <224ef677-4f25-fb61-2450-b95816333876@redhat.com>
Date:   Mon, 9 Dec 2019 10:37:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191207002904.GA29396@linux.intel.com>
Content-Language: en-US
X-MC-Unique: Bt1ECc4YP9iZ_QrEkeRT6Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/19 01:29, Sean Christopherson wrote:
> On Wed, Dec 04, 2019 at 11:05:47AM +0100, Paolo Bonzini wrote:
>> On 03/12/19 19:46, Sean Christopherson wrote:
>>> Rather than reserve entries, what if vCPUs reserved an entire ring?  Create
>>> a pool of N=nr_vcpus rings that are shared by all vCPUs.  To mark pages
>>> dirty, a vCPU claims a ring, pushes the pages into the ring, and then
>>> returns the ring to the pool.  If pushing pages hits the soft limit, a
>>> request is made to drain the ring and the ring is not returned to the pool
>>> until it is drained.
>>>
>>> Except for acquiring a ring, which likely can be heavily optimized, that'd
>>> allow parallel processing (#1), and would provide a facsimile of #2 as
>>> pushing more pages onto a ring would naturally increase the likelihood of
>>> triggering a drain.  And it might be interesting to see the effect of using
>>> different methods of ring selection, e.g. pure round robin, LRU, last used
>>> on the current vCPU, etc...
>>
>> If you are creating nr_vcpus rings, and draining is done on the vCPU
>> thread that has filled the ring, why not create nr_vcpus+1?  The current
>> code then is exactly the same as pre-claiming a ring per vCPU and never
>> releasing it, and using a spinlock to claim the per-VM ring.
> 
> Because I really don't like kvm_get_running_vcpu() :-)

I also don't like it particularly, but I think it's okay to wrap it into
a nicer API.

> Binding the rings to vCPUs also makes for an inflexible API, e.g. the
> amount of memory required for the rings scales linearly with the number of
> vCPUs, or maybe there's a use case for having M:N vCPUs:rings.

If we can get rid of the dirty bitmap, the amount of memory is probably
going to be smaller anyway.  For example at 64k per ring, 256 rings
occupy 16 MiB of memory, and that is the cost of dirty bitmaps for 512
GiB of guest memory, and that's probably what you can expect for the
memory of a 256-vCPU guest (at least roughly: if the memory is 128 GiB,
the extra 12 MiB for dirty page rings don't really matter).

Paolo

> That being said, I'm pretty clueless when it comes to implementing and
> tuning the userspace side of this type of stuff, so feel free to ignore my
> thoughts on the API.
> 


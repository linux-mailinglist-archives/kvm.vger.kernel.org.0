Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD94912012A
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 10:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfLPJ3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 04:29:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48653 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726937AbfLPJ3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 04:29:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576488580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D+soKtjNipH8IpDTofIGrq0aj+9fNzPNczOVUstfi40=;
        b=YHy2J2ANtL/NS06duqsMVaAdoVJIVDklL4VJ5gJbwexSKuw+uhJXSITBHLr0HA1Gx7IEJp
        3oCqh3uaDJRHXmwan72jXynthl5YyZ4Htej+N9Px71gBEz4oXgjtzbLALJvXO5UR1UjdkP
        sZcx5RMl7puW2p+6ZEALVL0G50Y0om0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-NN7ZHUJJOiOheMb9gPUqSQ-1; Mon, 16 Dec 2019 04:29:39 -0500
X-MC-Unique: NN7ZHUJJOiOheMb9gPUqSQ-1
Received: by mail-wr1-f72.google.com with SMTP id b13so2052634wrx.22
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 01:29:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D+soKtjNipH8IpDTofIGrq0aj+9fNzPNczOVUstfi40=;
        b=ho9Ksjngmd+JNr3hHUgUdufGQMMslMidCPOhxa7jxOdsWWcBzozIGCzJTrB+zC4Q+0
         2rOEIvh+6FggcRPofzz4g0OqeZZGMsrH5kEWucPbK2lKChJkS93C47N5VJ/rOyrUgfJF
         paWykQO9VZzbuqmmfHiOZrNF91ZuDl4fJ1zoQExqwqKgofW0Zx5Dqs0LD0PCyNv/GB5z
         I3MlKkCmgLLpo0JlEis/lmWk1IaXm7U38Q9bOMc5RQABXKrFRzvhXdqEwokmS7pqU7vy
         paVUnILepoBOqrLhodwV6qEd1DxB7rgSbaCeKZO+up5NzzTOptGHf009gGPNfUTI/sRr
         UWCw==
X-Gm-Message-State: APjAAAWAXptIwR5IHok8G3n+/Fv0cBoeNstXPb2kYaRzMrY3MnUS0r3V
        mlmLSGXFup0H0mNQZYlEMWdDxE3pQNr32VWWrfkYriyB6JyZ4DL2BWcu6/pO/dhg5cy/k3HtLEu
        DS5tzWOmqpgO+
X-Received: by 2002:a05:6000:12:: with SMTP id h18mr27350897wrx.87.1576488578200;
        Mon, 16 Dec 2019 01:29:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqxcZPae2fpcmqbfNpMEm7htf9LRZYX5o97SGgIiTkAX1Z/FX+jXlRQPGctSI6IqUy1eUKeLNg==
X-Received: by 2002:a05:6000:12:: with SMTP id h18mr27350870wrx.87.1576488577987;
        Mon, 16 Dec 2019 01:29:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:cde8:2463:95a9:1d81? ([2001:b07:6468:f312:cde8:2463:95a9:1d81])
        by smtp.gmail.com with ESMTPSA id v14sm20958683wrm.28.2019.12.16.01.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 01:29:37 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Peter Xu <peterx@redhat.com>
Cc:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com> <m1lfrihj2n.fsf@dinechin.org>
 <20191213202324.GI16429@xz-x1>
 <bc15650b-df59-f508-1090-21dafc6e8ad1@redhat.com>
 <20191214162644.GK16429@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0f084179-2a5d-e8d9-5870-3cc428105596@redhat.com>
Date:   Mon, 16 Dec 2019 10:29:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191214162644.GK16429@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/12/19 17:26, Peter Xu wrote:
> On Sat, Dec 14, 2019 at 08:57:26AM +0100, Paolo Bonzini wrote:
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
> Hmm, could you explain?
> 
> Note that here what Christophe commented is on dirty_index,
> reset_index of "struct kvm_dirty_ring", so imho it could really be
> anything we want as long as it can store a u32 (which is the size of
> the elements in kvm_dirty_ring_indexes).
> 
> If you were instead talking about the previous union definition of
> "struct kvm_dirty_gfns" rather than "struct kvm_dirty_ring", iiuc I've
> moved those indices out of it and defined kvm_dirty_ring_indexes which
> we expose via kvm_run, so we don't have that limitation as well any
> more?

Yeah, I meant that since the size has (had) to be u16 in the union, it
need not be bigger in kvm_dirty_ring.

I don't think having more than 2^16 entries in the *per-CPU* ring buffer
makes sense; lagging in recording dirty memory by more than 256 MiB per
CPU would mean a large pause later on resetting the ring buffers (your
KVM_CLEAR_DIRTY_LOG patches found the sweet spot to be around 1 GiB for
the whole system).

So I liked the union, but if you removed it you might as well align the
producer and consumer indices to 64 bytes so that they are in separate
cache lines.

Paolo


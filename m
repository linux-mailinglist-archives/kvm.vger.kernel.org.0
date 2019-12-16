Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA6061209C0
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 16:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbfLPPb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 10:31:58 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50999 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728225AbfLPPb6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 10:31:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576510317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b4ukn9jg5iLQIvGzXAVPG9KPLZpvMGtjikA+c6QsDvA=;
        b=hJVc+R9+/TiZe3hnaBI2XKmeoRfJMqiFauOZYEqYCoBVofozMsSBIeK1Y7W+Tdy/HeZjcG
        XLTrtuWVt/+WWbTmpd/40i9dFSaySlsQhF2AUU5mcjelVGHDptfCsC7rtJ/62jrQvP6TYE
        1S7h76RqMCuBBJjYvVYWyfNpjICaGIc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-8aFhhfhwM2-bPnAMjG7gPw-1; Mon, 16 Dec 2019 10:31:56 -0500
X-MC-Unique: 8aFhhfhwM2-bPnAMjG7gPw-1
Received: by mail-wm1-f70.google.com with SMTP id b9so960959wmj.6
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 07:31:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b4ukn9jg5iLQIvGzXAVPG9KPLZpvMGtjikA+c6QsDvA=;
        b=gRM+64hkQiw77kdgT/ahNynyD1t0zq+Ip1l1y3//DXM7P/xxsvY0IeLAxUtH2SK2fb
         K8ir7Ooa4icsFwd9eFZpeGRAG0eXPKFS9+ZVZfGVtnorLHEPxkApnthEIm5nv3K1AyYw
         F4WNmOAEMCXVJy/Cc3Cp6z0IEDzux1mjw4QLOMB7a8fYa9ef+/39KAcSDaXHdApemalg
         irIRZlW8r4ZO9JMnO/9CbSOObafPWb2pE90QUlUIePhTobE79nTlOvhEIW7bOQr78Q3/
         gCXvjP7CibHMlM4nVp0uYpAoCwnairktgSL9abmQ9q/OCwHTkRuoBaHb8m98TUEW1KuG
         UkXA==
X-Gm-Message-State: APjAAAWW7O1uUWUQ0wzzQSPY//xCOu9wDPMZmHAyREXjsArpBt7BWy1d
        C7Ba0n9frrYo4Mz/hl13e1wwPYoSHknCiPKOKSmE3RiXc2bjBZ7xcUEj0K+qBq6o63Wpmq02BpX
        GDj7usx9bMvJi
X-Received: by 2002:a5d:4c85:: with SMTP id z5mr30176066wrs.42.1576510312172;
        Mon, 16 Dec 2019 07:31:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqzSt8LzC5weKbJysR0X7nBKyx8pcDL+THj78l8aUphiEurT2I+K1QUcSiZnvcelJLAhVItfpA==
X-Received: by 2002:a5d:4c85:: with SMTP id z5mr30176037wrs.42.1576510311911;
        Mon, 16 Dec 2019 07:31:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:cde8:2463:95a9:1d81? ([2001:b07:6468:f312:cde8:2463:95a9:1d81])
        by smtp.gmail.com with ESMTPSA id t190sm12991878wmt.44.2019.12.16.07.31.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 07:31:51 -0800 (PST)
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
 <0f084179-2a5d-e8d9-5870-3cc428105596@redhat.com>
 <20191216152647.GD83861@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fa25d729-a2fb-85af-a968-1dedc754a55d@redhat.com>
Date:   Mon, 16 Dec 2019 16:31:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191216152647.GD83861@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/12/19 16:26, Peter Xu wrote:
> On Mon, Dec 16, 2019 at 10:29:36AM +0100, Paolo Bonzini wrote:
>> On 14/12/19 17:26, Peter Xu wrote:
>>> On Sat, Dec 14, 2019 at 08:57:26AM +0100, Paolo Bonzini wrote:
>>>> On 13/12/19 21:23, Peter Xu wrote:
>>>>>> What is the benefit of using u16 for that? That means with 4K pages, you
>>>>>> can share at most 256M of dirty memory each time? That seems low to me,
>>>>>> especially since it's sufficient to touch one byte in a page to dirty it.
>>>>>>
>>>>>> Actually, this is not consistent with the definition in the code ;-)
>>>>>> So I'll assume it's actually u32.
>>>>> Yes it's u32 now.  Actually I believe at least Paolo would prefer u16
>>>>> more. :)
>>>>
>>>> It has to be u16, because it overlaps the padding of the first entry.
>>>
>>> Hmm, could you explain?
>>>
>>> Note that here what Christophe commented is on dirty_index,
>>> reset_index of "struct kvm_dirty_ring", so imho it could really be
>>> anything we want as long as it can store a u32 (which is the size of
>>> the elements in kvm_dirty_ring_indexes).
>>>
>>> If you were instead talking about the previous union definition of
>>> "struct kvm_dirty_gfns" rather than "struct kvm_dirty_ring", iiuc I've
>>> moved those indices out of it and defined kvm_dirty_ring_indexes which
>>> we expose via kvm_run, so we don't have that limitation as well any
>>> more?
>>
>> Yeah, I meant that since the size has (had) to be u16 in the union, it
>> need not be bigger in kvm_dirty_ring.
>>
>> I don't think having more than 2^16 entries in the *per-CPU* ring buffer
>> makes sense; lagging in recording dirty memory by more than 256 MiB per
>> CPU would mean a large pause later on resetting the ring buffers (your
>> KVM_CLEAR_DIRTY_LOG patches found the sweet spot to be around 1 GiB for
>> the whole system).
> 
> That's right, 1G could probably be a "common flavor" for guests in
> that case.
> 
> Though I wanted to use u64 only because I wanted to prepare even
> better for future potential changes as long as it won't hurt much.

No u64, please.  u32 I can agree with, 16-bit *should* be enough but it
is a bit tight, so let's make it 32-bit if we drop the union idea.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC22511AD21
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 15:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbfLKOPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 09:15:06 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31781 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729228AbfLKOPG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 09:15:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576073705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6CNeNviiAcs4FnRFrCRUNmQuCuRCLUA+6sORydEute8=;
        b=itfmDOO4f72ScNBDS63oMYEIc443gavH4hjlo3ANfdAItEcGqVIr96jiJACAEKJdvDMG+e
        fiz7b19poJqUZJja+8TFWzHtCnOO0SxiF5ZfgwNIQH6eldN+wdNIUucLQksqjUBxTFk+tl
        ZGvZyRYS3r11MkSOytpc9at71QjNKtI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-rTAcecnuNlOeL0l791wrCQ-1; Wed, 11 Dec 2019 09:15:02 -0500
Received: by mail-wm1-f71.google.com with SMTP id 18so2439893wmp.0
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 06:15:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6CNeNviiAcs4FnRFrCRUNmQuCuRCLUA+6sORydEute8=;
        b=AkEGb2+2kuN+vRoU9/77UMCzHd7m6bTnnyxjZYV9G1VBqhALS8q4m1VokKwLyqvyC4
         ziQvX+yJM5bVtffi7flGEHNErshVS3iTJUZ7JSbth3xslaMNLj1fmZe3Y3y8UWpT8z5P
         swuUe0X0lpTXl1Z2ZSHjEnNIttQAGErlE02vvgWK/+sklsVYOJ/enLWZUBFk96TkMJtA
         ypjwZlyip0YIokE7cHaKvoSTDKeEvMdzDqAmO04RKlN/TQzjGyDaK1ORDc4pDt2KwgSg
         c6lrszPipoYoBpbExfdQCVaPkEwV7AaFYR85fOLZ5gKW5l70ZxoU/eRNEU7oC8DilVtB
         EWkg==
X-Gm-Message-State: APjAAAVcN63uV1owGOGarlFZtEQoJyns7RKL2jFkLMqu7qCAjRmZnGXn
        nxZGgxHFrSaLPS2FnvWwR2o+emmdSBisXZD9OJTqTuYwl87pLKT0qf0lDb6MrMInK9DN/+X3tS4
        AGwMJ92dQ1LIh
X-Received: by 2002:adf:f78d:: with SMTP id q13mr4120181wrp.365.1576073701686;
        Wed, 11 Dec 2019 06:15:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqzGa5r2SnfhcT6zQ4xQrq1x+BOmqjrJJ7OwIvx4uM3tEJhG56oMXjTsdcZ1Mf8aHncadmBgtw==
X-Received: by 2002:adf:f78d:: with SMTP id q13mr4120155wrp.365.1576073701421;
        Wed, 11 Dec 2019 06:15:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id h17sm2459307wrs.18.2019.12.11.06.15.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 06:15:00 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     "Michael S. Tsirkin" <mst@redhat.com>, Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191211063830-mutt-send-email-mst@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fd9025cc-bb52-8ac8-fece-9bc857d3d5d1@redhat.com>
Date:   Wed, 11 Dec 2019 15:14:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191211063830-mutt-send-email-mst@kernel.org>
Content-Language: en-US
X-MC-Unique: rTAcecnuNlOeL0l791wrCQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/19 13:53, Michael S. Tsirkin wrote:
>> +
>> +struct kvm_dirty_ring_indexes {
>> +	__u32 avail_index; /* set by kernel */
>> +	__u32 fetch_index; /* set by userspace */
>
> Sticking these next to each other seems to guarantee cache conflicts.

I don't think that's an issue because you'd have a conflict anyway on
the actual entry; userspace anyway has to read the kernel-written index,
which will cause cache traffic.

> Avail/Fetch seems to mimic Virtio's avail/used exactly.

No, avail_index/fetch_index is just the producer and consumer indices
respectively.  There is only one ring buffer, not two as in virtio.

> I am not saying
> you must reuse the code really, but I think you should take a hard look
> at e.g. the virtio packed ring structure. We spent a bunch of time
> optimizing it for cache utilization. It seems kernel is the driver,
> making entries available, and userspace the device, using them.
> Again let's not develop a thread about this, but I think
> this is something to consider and discuss in future versions
> of the patches.

Even in the packed ring you have two cache lines accessed, one for the
index and one for the descriptor.  Here you have one, because the data
is embedded in the ring buffer.

> 
>> +};
>> +
>> +While for each of the dirty entry it's defined as:
>> +
>> +struct kvm_dirty_gfn {
> 
> What does GFN stand for?
> 
>> +        __u32 pad;
>> +        __u32 slot; /* as_id | slot_id */
>> +        __u64 offset;
>> +};
> 
> offset of what? a 4K page right? Seems like a waste e.g. for
> hugetlbfs... How about replacing pad with size instead?

No, it's an offset in the memslot (which will usually be >4GB for any VM
with bigger memory than that).

Paolo


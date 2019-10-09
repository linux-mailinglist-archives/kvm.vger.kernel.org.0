Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB2FD081B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 09:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbfJIHPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 03:15:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34348 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbfJIHPI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 03:15:08 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04A8781DE7
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 07:15:08 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id q9so612044wmj.9
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 00:15:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=beb9HIPPbmhFYNfmtVdjyRkfC7WTvuQw9rrgx9e5c6M=;
        b=lIBBJ4ML+ErzTsy1Tf9KiUnHMcAIL4H5CN70y70HbSrFD+ZIQoTQEfpX74xqzyTh3o
         /eQP9aKUtF6Jzqetth01/06sfwmNAmEPz0lQ17ACvNn7gxAQBjBg/gMh0kTZY7IJuG8p
         E0n2pJSvACF9aOOpQB6wbk9QEC22+k77aIcSE2kphXO7ZpjHmDhPVdKd9k5MVFg2i4qF
         1bpH6lnF8yrHQP/4WCjvv7ljc5wRiC9oFYgvtrBaCUr+Sxz5GGoO+DGMvttPzBTPGQrl
         oN0mmk7qS0xbmAsvd2fz57dtmswfBDU7GhsLqztB2pjXpFd5xuo3oZDk0P7E+1hKSRk3
         UKmA==
X-Gm-Message-State: APjAAAUZ6iSM/mZ35/NwT9kV7sJXGA/iaEOsSbU7JVZR4+j+pkHXhpyR
        XhaFphNZ7XdS8r4tiGUTBeuh+QXxO7Z2BlRaOZ5nRhoXUPADzJN4UGob3GpCOfc4fa4lsqaYvoo
        JPd1138dDozwH
X-Received: by 2002:a5d:6b52:: with SMTP id x18mr1575154wrw.66.1570605306455;
        Wed, 09 Oct 2019 00:15:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxPFUqVF+FuXSVZebBE01RgJNMCK667U9tuBkMMoSGONMCEMKv2PzRhAgecz0WXe0Zf1FUUMg==
X-Received: by 2002:a5d:6b52:: with SMTP id x18mr1575084wrw.66.1570605305611;
        Wed, 09 Oct 2019 00:15:05 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id h14sm1686671wro.44.2019.10.09.00.15.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 00:15:05 -0700 (PDT)
Subject: Re: [PATCH 3/3] KVM: x86/vPMU: Add lazy mechanism to release
 perf_event per vPMC
To:     Like Xu <like.xu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
References: <20190930072257.43352-1-like.xu@linux.intel.com>
 <20190930072257.43352-4-like.xu@linux.intel.com>
 <20191001082321.GL4519@hirez.programming.kicks-ass.net>
 <e77fe471-1c65-571d-2b9e-d97c2ee0706f@linux.intel.com>
 <20191008121140.GN2294@hirez.programming.kicks-ass.net>
 <d492e08e-bf14-0a8b-bc8c-397f8893ddb5@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <bfd23868-064e-4bf5-4dfb-211d36c409c1@redhat.com>
Date:   Wed, 9 Oct 2019 09:15:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d492e08e-bf14-0a8b-bc8c-397f8893ddb5@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 05:14, Like Xu wrote:
>>
>>
>>> I'm not sure is this your personal preference or is there a technical
>>> reason such as this usage is not incompatible with union syntax?
>>
>> Apparently it 'works', so there is no hard technical reason, but
>> consider that _Bool is specified as an integer type large enough to
>> store the values 0 and 1, then consider it as a base type for a
>> bitfield. That's just disguisting.
> 
> It's reasonable. Thanks.

/me chimes in since this is KVM code after all...

For stuff like hardware registers, bitfields are probably a bad idea
anyway, so let's only consider the case of space optimization.

bool:2 would definitely cause an eyebrow raise, but I don't see why
bool:1 bitfields are a problem.  An integer type large enough to store
the values 0 and 1 can be of any size bigger than one bit.

bool bitfields preserve the magic behavior where something like this:

  foo->x = y;

(x is a bool bitfield) would be compiled as

  foo->x = (y != 0);

which can be a plus or a minus depending on the point of view. :)
Either way, bool bitfields are useful if you are using bitfields for
space optimization, especially if you have existing code using bool and
it might rely on the idiom above.

However, in this patch bitfields are unnecessary and they result in
worse code from the compiler.  There is plenty of padding in struct
kvm_pmu, with or without bitfields, so I'd go with "u8 event_count; bool
enable_cleanup;" (or better "need_cleanup").

Thanks,

Paolo

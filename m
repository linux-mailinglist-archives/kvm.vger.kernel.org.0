Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4440F376246
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 10:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbhEGInY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 04:43:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233340AbhEGInX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 04:43:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620376944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xfCXoiSRUf8EHAREMqARq69JqzDyk9XVPqTBvkTg9rI=;
        b=gVXu3HtBW746PzK5QEAJ6LcGT94mF1scIFBKDJN3KUOnvf57yzYyECOOakQqDMQS9UfhOa
        mJBCAfO7sSEdeHssy8zXg9RJH3Pa97uf3yjq4u/JgYg8ihSmX7phxHGpoR+Qjqr1YZQPpp
        YdLhXM0C7Sff084CZi/2KheHANc58vw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-mG9DIUbCNEWUSoJE15qIJg-1; Fri, 07 May 2021 04:42:22 -0400
X-MC-Unique: mG9DIUbCNEWUSoJE15qIJg-1
Received: by mail-wm1-f71.google.com with SMTP id n9-20020a1c40090000b02901401bf40f9dso3670303wma.0
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 01:42:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xfCXoiSRUf8EHAREMqARq69JqzDyk9XVPqTBvkTg9rI=;
        b=kb7/pJQSdn0ShhPIEgR8szXD0r2ZX+P+KPvIz8pRqSSVIKe2R8Fi26MvdSDJbN/2KD
         4sg+mW5uya99JCt5YMU8Jo7FKoP893Dg1QbvAL3xcSb1qjXdNkU/qWsqVoeosUz275Lz
         EA18IkywtnLaS11ej/OHgNQrtgj45msJpaoud86wd8bT4ybXZ30af7NpT//dQvTijw36
         gmN2sRaTRPth3tvLAv0ogVesE9ArZlSvKPsc8liC0TYkiogt1xgPBq5kDJpNVWE4Ek+r
         R6zD7iZSWVD/fJD+hVZdOOiRtxJxh9YTK2w2wNbh+H9fworybRDsqstk/wljzqmnuveW
         XQYA==
X-Gm-Message-State: AOAM531FDOtWBFOTzE0VzTdtOj1h2NC6wAm3/iAcVimb8QbJde2epgma
        3J6XnXhAr5R56FhLPerHdyW3hmxnVkjDjJO0Tg3YRevG8Y9OchInhwm22QTbPlcFS4rOX1GOPH5
        Zl0UtyuukD17h
X-Received: by 2002:a5d:400f:: with SMTP id n15mr6846898wrp.274.1620376941330;
        Fri, 07 May 2021 01:42:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoFMyEIZk1TCndnag6cii3qK499Zt0/XLGrLq/Nt25lWx4sb8T0QrY1Xct3knS7xGtliLwCw==
X-Received: by 2002:a5d:400f:: with SMTP id n15mr6846875wrp.274.1620376941115;
        Fri, 07 May 2021 01:42:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id n10sm7744773wrw.37.2021.05.07.01.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 01:42:20 -0700 (PDT)
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <20210506184241.618958-1-bgardon@google.com>
 <20210506184241.618958-8-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 7/8] KVM: x86/mmu: Protect rmaps independently with
 SRCU
Message-ID: <e2e73709-f247-1a60-4835-f3fad37ab736@redhat.com>
Date:   Fri, 7 May 2021 10:42:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506184241.618958-8-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/21 20:42, Ben Gardon wrote:
> In preparation for lazily allocating the rmaps when the TDP MMU is in
> use, protect the rmaps with SRCU. Unfortunately, this requires
> propagating a pointer to struct kvm around to several functions.

Thinking more about it, this is not needed because all reads of the rmap 
array are guarded by the load-acquire of kvm->arch.memslots_have_rmaps. 
  That is, the pattern is always

	if (!load-acquire(memslot_have_rmaps))
		return;
	... = __gfn_to_rmap(...)

				slots->arch.rmap[x] = ...
				store-release(memslot_have_rmaps, true)

where the load-acquire/store-release have the same role that 
srcu_dereference/rcu_assign_pointer had before this patch.

We also know that any read that misses the check has the potential for a 
NULL pointer dereference, so it *has* to be like that.

That said, srcu_dereference has zero cost unless debugging options are 
enabled, and it *is* true that the rmap can disappear if kvm->srcu is 
not held, so I lean towards keeping this change and just changing the 
commit message like this:

---------
Currently, rmaps are always allocated and published together with a new 
memslot, so the srcu_dereference for the memslots array already ensures 
that the memory pointed to by slots->arch.rmap is zero at the time 
slots->arch.rmap.  However, they still need to be accessed in an SRCU 
read-side critical section, as the whole memslot can be deleted outside 
SRCU.
--------

Thanks,

Paolo

> 
> Suggested-by: Paolo Bonzini<pbonzini@redhat.com>
> Signed-off-by: Ben Gardon<bgardon@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 57 +++++++++++++++++++++++++-----------------
>   arch/x86/kvm/x86.c     |  6 ++---
>   2 files changed, 37 insertions(+), 26 deletions(-)


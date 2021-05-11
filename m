Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C9E37AC60
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhEKQve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:51:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230315AbhEKQve (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 12:51:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620751827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cnwdGkgKmaN8zzfAAS7qNH7BwBjA9G28KHF0c1OyQG0=;
        b=Wg417G9ztoX9Of7fw0/+W+3yGSwVxiieZaI4oqklefnPClSOr2wOHuVinE5R4hf0cdVPOa
        8mNZr2n80yHYkPQp9EDPbzJJjzhEtuFGqsHlncWvccBZL9/VTjUjf6VD8b4BP95toFqn5V
        yEdZMDV8XowTMAUuFDNQIkm+LXcXu10=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-zXpGwfiKOkKUufdkAsxVYA-1; Tue, 11 May 2021 12:46:39 -0400
X-MC-Unique: zXpGwfiKOkKUufdkAsxVYA-1
Received: by mail-ed1-f71.google.com with SMTP id c21-20020a0564021015b029038c3f08ce5aso5780081edu.18
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 09:46:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cnwdGkgKmaN8zzfAAS7qNH7BwBjA9G28KHF0c1OyQG0=;
        b=lwqZL4+X0+mtEbE67NwS8AXOKHiLZDCbwHh5lZFxUBpK45NUimo4EBUAws+tbxd5ch
         pEOwAxDjKK3SNCHMCz0qvXV8ns34BvexJXG3zwYHvV+jAqsAlLe+F7PEDqe2gURQogmW
         BV0RsEpW6ekQzUd/qmz8YBr+/M71pi45TgJqPob8PMQ/mtyIh4tgRtfCGj3xxgW9SErW
         BbABIgqhe5VvFC9sXOO4oC78ITFAqaf7CmYWsJPUZyOz61TugaJmLPxP74gpcc8gMIWu
         tBv//XDSPmWY1y92mqsFu0/c39AHWw6yEjhWSjC0J3OyL/DLssKNrv1YeSD4r0qZkT9d
         ES5A==
X-Gm-Message-State: AOAM5302REP9cQzbnpj42XhPMIAYh/4YmTNGy5kZ438lfdUEqzsGMZYr
        fRAWj1MpbCjzj9MmJE1j90GL4ZmmFmneKcT5SbqwkdPm18r4qAKpoHm4Iczmbj+3ek0fFdXmJZb
        YcJ060U0BP49a
X-Received: by 2002:a05:6402:694:: with SMTP id f20mr37798720edy.93.1620751597988;
        Tue, 11 May 2021 09:46:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZsj+woOL7rt9mKKDk9AjJ5cyFGZu5rwkhBqXLFiJ/8dEHGTCF7YQ2kHbp4XDVYXNlahzHYQ==
X-Received: by 2002:a05:6402:694:: with SMTP id f20mr37798701edy.93.1620751597858;
        Tue, 11 May 2021 09:46:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t9sm15798392edf.70.2021.05.11.09.46.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 09:46:10 -0700 (PDT)
Subject: Re: [PATCH v3 7/8] KVM: x86/mmu: Protect rmaps independently with
 SRCU
To:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <20210506184241.618958-1-bgardon@google.com>
 <20210506184241.618958-8-bgardon@google.com>
 <e2e73709-f247-1a60-4835-f3fad37ab736@redhat.com>
 <YJlxQe1AXljq5yhQ@google.com>
 <a13b6960-3628-2899-5fbf-0765f97aa9eb@redhat.com>
 <YJl7V1arDXyC6i5P@google.com>
 <CANgfPd9LDnEs1EoEu2tXZVvLGkFhNSByJ-oLCkqb02xxmgkifQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9f8b39f9-58ce-c795-ae76-b0d7bb823b13@redhat.com>
Date:   Tue, 11 May 2021 18:45:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd9LDnEs1EoEu2tXZVvLGkFhNSByJ-oLCkqb02xxmgkifQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/05/21 18:22, Ben Gardon wrote:
>> Yes, and I'm arguing that annotating the rmaps as __rcu is wrong because they
>> themselves are not protected by SRCU.  The memslot that contains the rmaps is
>> protected by SRCU, and because of that asserting SRCU is held for read will hold
>> true.  But, if the memslot code were changed to use a different protection scheme,
>> e.g. a rwlock for argument's sake, then the SRCU assertion would fail even though
>> the rmap logic itself didn't change.
>
> I'm inclined to agree with Sean that the extra RCU annotations are
> probably unnecessary since we're already doing the srcu dereference
> for all the slots. I'll move all these RCU annotations to their own
> patch and put it at the end of the series when I send v4.
> 

Fair enough, you can even remove them then.

Paolo


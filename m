Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A9721BC6D
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 19:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgGJRkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 13:40:15 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39361 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727038AbgGJRkP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 13:40:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594402813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/IkQPdXSHaUMhvBTo4/ZFo40yEF0ln1C5QCttyzLIBw=;
        b=bHiPWiXMrqPPkzIMvizKgKmxc9Bj0mZmW/F6e3wTctqISoZ+NE43aUQHNHS0kdeBqsVP0e
        y8frQcsI7AdrNpl7m4/Sh/OP8Esz1+wAQ4GfkxEVK04At9lfpe2PDcGCE5flzz0rYSYs1z
        DoS0OZilBZSMuHI7x9D+RuJBh75V+z0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-35iUq_cEPHeFSCXnConv6g-1; Fri, 10 Jul 2020 13:40:12 -0400
X-MC-Unique: 35iUq_cEPHeFSCXnConv6g-1
Received: by mail-wm1-f69.google.com with SMTP id c81so7412116wmd.2
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 10:40:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/IkQPdXSHaUMhvBTo4/ZFo40yEF0ln1C5QCttyzLIBw=;
        b=WVLuGFed2MXhvTaCPNcfUrimnz0mS9VKBvaWOkE3ON+Um3Mo9tgJW88OqDzXYK9geR
         ilsETVYREgDnDr4qekhbG8F6/9NCv9hblo8JwJBkRjIHuk4bvtHEv0x9D7AwelDJzPDo
         2LjzKE7xL54EIxKa8Nn6qdO74RSMYr2uCIPdzhJqgwV70kQdB31l/Fz08skAxCuZuHMi
         1jispF224MucE9mtKN1TNykT9VnFY2dECZS62aAEKBYHRQ/DQiZH5khOD/1V7qkXHQye
         1XMRGpNTjmLRLbSZpER6nXA6tIpmLhYe/fEO5Zi/qET5Ec2OeeKKxjD6aDrKBQVYcj4y
         x65g==
X-Gm-Message-State: AOAM530I5H48DSCl7vDweRZwtvxg58V0eX+iJTqJXAUBgQAhAKQkJQ8T
        L8u0jlVlNOE+qW9JZg0u2UgEo8nFNvPiwyQQEnKoOD8zajCWzMs3/ilThb5zXyE7r6ZNeI4a2MJ
        U/qK3L49PtYzU
X-Received: by 2002:adf:f209:: with SMTP id p9mr65624123wro.86.1594402811226;
        Fri, 10 Jul 2020 10:40:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgdBFsI6NpM0cOEYE9Zd0CxeHVbzpJqrUECEdskVqorMpkRotRA6xd/OKf7+5nsRvVTo8ujA==
X-Received: by 2002:adf:f209:: with SMTP id p9mr65624106wro.86.1594402811022;
        Fri, 10 Jul 2020 10:40:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id c15sm10333052wme.23.2020.07.10.10.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 10:40:10 -0700 (PDT)
Subject: Re: [PATCH v3 0/9] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Jim Mattson <jmattson@google.com>
Cc:     Mohammed Gamal <mgamal@redhat.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200710154811.418214-1-mgamal@redhat.com>
 <CALMp9eRfZ50iyrED0-LU75VWhHu_kVoB2Qw55VzEFzZ=0QCGow@mail.gmail.com>
 <0c892b1e-6fe6-2aa7-602e-f5fadc54c257@redhat.com>
 <CALMp9eQXHGnXo4ACX2-qYww4XdRODMn-O6CAvhupib67Li9S2w@mail.gmail.com>
 <9e784c62-15ee-63b7-4942-474493bac536@redhat.com>
 <CALMp9eRGTedw-wNL4HcrJOpAQBa_Qsqcir0BtJ-dEO6EhvWGqA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5d9e2483-81ba-1d94-5324-08245ced7d0e@redhat.com>
Date:   Fri, 10 Jul 2020 19:40:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRGTedw-wNL4HcrJOpAQBa_Qsqcir0BtJ-dEO6EhvWGqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/20 19:26, Jim Mattson wrote:
>> Intel only has MAXPHYADDR > 46 on LA57 machines (because in general OSes
>> like to have a physical 1:1 map into the kernel part of the virtual
>> address space, so having a higher MAXPHYADDR would be of limited use
>> with 48-bit linear addresses).
> We all know that the direct map is evil. :-)
> 
> Sorry it took me so long to get there. I didn't realize that Linux was
> incapable of using more physical memory than it could map into the
> kernel's virtual address space. (Wasn't that the whole point of PAE
> originally?)

Yes, but it's so slow that Linux preferred not to go that way for 64-bit
kernels.

That said, that justification for MAXPHYADDR==46 came from Intel
processor architects, and when they say "OSes" they usually refer to a
certain vendor from the Pacific north-west.

Paolo


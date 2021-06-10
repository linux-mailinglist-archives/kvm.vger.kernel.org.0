Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0FC3A247F
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 08:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhFJG2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 02:28:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49981 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229634AbhFJG2E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 02:28:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623306368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VGs+0yvbM3aZSFiSqmWvFiKGejTxJX5EbFXyaERoXAM=;
        b=gub3oqk/sPspP9JBKwSqsTVv22miyh9g6qJTPm954EwYhjtwdebgZ+1kj6tPOiuuUqgwTf
        /ebpS4itpS9WCVV9D+f3hiFixvhgh/OP2IPrmniquO0KEQMT2iQAOg14Zq2LrMfjfFMs3x
        A1EgXO1IlP3BNXGVf1yokY5azEEP1hI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-7Bnei4soNyq5y5OgDqt2pQ-1; Thu, 10 Jun 2021 02:26:07 -0400
X-MC-Unique: 7Bnei4soNyq5y5OgDqt2pQ-1
Received: by mail-wr1-f70.google.com with SMTP id r17-20020a5d52d10000b0290119976473fcso395298wrv.15
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 23:26:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VGs+0yvbM3aZSFiSqmWvFiKGejTxJX5EbFXyaERoXAM=;
        b=Enemd0vgiH8zDbTIkGjZRvPUbhfdI8/fv8VO9Ij7AGW5WWwZuJU9LstVocAIco7L+4
         DN3sQnpk4MpcNX9uwT+hTlBoAQ8sxytwqAv00BjOGDpIckuENHRlDvkvvLWep+USV7NZ
         uvmWX/f9QxBUZkkOe2nkM5ths1E6aEgsjtVuDTJj++dm3Iud53EAhHgxk7ljbIpAxprt
         jAtRuPZC2JM3KRywh6pulL6jcHQl/lwRYRyDzK7DxjHz2rVElKWRe30t9bEvoXeAqGg8
         AMEiwJe6Qk5y7khn+3PVDS4mW5s3h1wXPcg+H54I8yz2y1WGOB5k8nGhiabqe7611c2x
         e/Xw==
X-Gm-Message-State: AOAM532N6532cNd2HQaZvRXh+eOOtxtgyXThMSe5MvImsvgwtP2SkY+p
        Vw5VSYW7mEiEbcIjt+dYbfp3exwEj49Jv+BQD4iUr/sp4QfwGmRL/V4XQNYWP5xF7B2DIzPMVOY
        qSB7Ey5+jcRtt
X-Received: by 2002:a05:6000:1542:: with SMTP id 2mr3538351wry.4.1623306366238;
        Wed, 09 Jun 2021 23:26:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBGG55buqU3+VfqpCmTr0MOmTfLZq6Ft4s83qkvKAaEg+eogzlxEYnXIApfOL9adnMCh2brA==
X-Received: by 2002:a05:6000:1542:: with SMTP id 2mr3538326wry.4.1623306366038;
        Wed, 09 Jun 2021 23:26:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k16sm1840159wmr.42.2021.06.09.23.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 23:26:05 -0700 (PDT)
Subject: Re: [PATCH 02/10] KVM: arm64: Implement initial support for
 KVM_CAP_SYSTEM_COUNTER_STATE
To:     Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20210608214742.1897483-1-oupton@google.com>
 <20210608214742.1897483-3-oupton@google.com> <877dj3z68p.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9c5f19f9-b303-573a-aa2a-cf5a91110db8@redhat.com>
Date:   Thu, 10 Jun 2021 08:26:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <877dj3z68p.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 12:23, Marc Zyngier wrote:
>> Implement initial support for KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls
>> to migrate the value of CNTVOFF_EL2. These ioctls yield precise control
>> of the virtual counter-timers to userspace, allowing it to define its
>> own heuristics for managing vCPU offsets.
> I'm not really in favour of inventing a completely new API, for
> multiple reasons:
> 
> - CNTVOFF is an EL2 concept. I'd rather not expose it as such as it
>    becomes really confusing with NV (which does expose its own CNTVOFF
>    via the ONE_REG interface)
> 
> - You seem to allow each vcpu to get its own offset. I don't think
>    that's right. The architecture defines that all PEs have the same
>    view of the counters, and an EL1 guest should be given that
>    illusion.
> 
> - by having a parallel save/restore interface, you make it harder to
>    reason about what happens with concurrent calls to both interfaces
> 
> - the userspace API is already horribly bloated, and I'm not overly
>    keen on adding more if we can avoid it.
> 
> I'd rather you extend the current ONE_REG interface and make it modal,
> either allowing the restore of an absolute value or an offset for
> CNTVCT_EL0. This would also keep a consistent behaviour when restoring
> vcpus. The same logic would apply to the physical offset.

What about using KVM_GET/SET_DEVICE_ATTR?  It makes sense that the guest 
value for nested virt goes through ONE_REG, while the host value goes 
through DEVICE_ATTR.

Paolo


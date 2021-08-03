Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203423DEA87
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 12:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbhHCKK7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 06:10:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235296AbhHCKKx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 06:10:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627985436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DYi9zCYb/+nOBKs9RrX6QQsVbPNcDstKhS42LRE6Yz8=;
        b=EdE+icpJEI6vQMXDqA9r7TZ0WEF68ZagmUVTshjS0JRR7xnz8qEAyQR/7onsaCKiZBZwUF
        ICYoTVvULeu1VPm1nCBymqKxF4rVyxbmJjqzD+WPLzAa/LfMscwUqaydO43syC3Yr0dr6f
        7CrSRcdlc25sFBhBXrMo6sIze/j39rI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-XC_1T0snPRqUKWECulHkNA-1; Tue, 03 Aug 2021 06:10:35 -0400
X-MC-Unique: XC_1T0snPRqUKWECulHkNA-1
Received: by mail-ed1-f69.google.com with SMTP id dn10-20020a05640222eab02903bd023ea9f6so5375970edb.14
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 03:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DYi9zCYb/+nOBKs9RrX6QQsVbPNcDstKhS42LRE6Yz8=;
        b=ebUDHh5iDR7geQltj8ew20nAMFepR1VrqmWQPyEu818RH7HgRN+D+EWSk38RuBFJXi
         KoJic6QJN8n6bNPbVfKAKg5CwOflSpeiJQ8e4EdPur5cDeE0GUFE1Tak8YRGoNC3ip37
         G0gYmtg56LUZvsZuGPzXrxYNTFakjBJgw+TUF+eq3G/CzkyQ4mseAi+P6ui/LRXxhvNU
         Ns+dJF4qylqkk/fpt4s0nJorSTBZ51lYfiUiLWSedcZXTw/ZnuxfaQ2HymN1tpJLxgB6
         mfsQbOdtVTKb9cUQad1hXkQSl96nvbOyB0/VWYNWyqljPGl+zGX7VdUI2FbNxenRSAbc
         ufcw==
X-Gm-Message-State: AOAM531IUD/Q/+Lc2IHiR879HU1Ipg71Iab8G+ZZB1tf0+K57VoIyhYk
        sWdpfzUCemlLlIvD/wa+RcocgWMbomO3M2kMDgRK6XoO1tL0fHTwxkWO4hWYbqrUlhOTbfCjaGX
        vtARYhTf6ZRV9
X-Received: by 2002:aa7:c956:: with SMTP id h22mr24263128edt.378.1627985434345;
        Tue, 03 Aug 2021 03:10:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzV6j8DyxbzH8cVAeRDt3PX6sEhA8DSM2O3imatGfwfc+elhTpl5iBBXYFc80r43C859Om4EA==
X-Received: by 2002:aa7:c956:: with SMTP id h22mr24263081edt.378.1627985433847;
        Tue, 03 Aug 2021 03:10:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id i14sm7857712edx.30.2021.08.03.03.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 03:10:33 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: x86: hyper-v: Check if guest is allowed to use
 XMM registers for hypercall input
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
References: <20210730122625.112848-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <44b5e202-7c38-db93-25c7-c91a0ba7eb65@redhat.com>
Date:   Tue, 3 Aug 2021 12:10:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210730122625.112848-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/21 14:26, Vitaly Kuznetsov wrote:
> "KVM: x86: hyper-v: Fine-grained access check to Hyper-V hypercalls and
> MSRs" and "Add support for XMM fast hypercalls" series were developed
> at the same time so the later landed without a proper feature bit check
> for 'strict' (KVM_CAP_HYPERV_ENFORCE_CPUID) mode. Add it now.
> 
> TLFS states that "Availability of the XMM fast hypercall interface is
> indicated via the “Hypervisor Feature Identification” CPUID Leaf
> (0x40000003, see section 2.4.4) ... Any attempt to use this interface
> when the hypervisor does not indicate availability will result in a #UD
> fault."
> 
> Vitaly Kuznetsov (4):
>    KVM: x86: hyper-v: Check access to hypercall before reading XMM
>      registers
>    KVM: x86: Introduce trace_kvm_hv_hypercall_done()
>    KVM: x86: hyper-v: Check if guest is allowed to use XMM registers for
>      hypercall input
>    KVM: selftests: Test access to XMM fast hypercalls
> 
>   arch/x86/kvm/hyperv.c                         | 18 ++++++--
>   arch/x86/kvm/trace.h                          | 15 +++++++
>   .../selftests/kvm/include/x86_64/hyperv.h     |  5 ++-
>   .../selftests/kvm/x86_64/hyperv_features.c    | 41 +++++++++++++++++--
>   4 files changed, 71 insertions(+), 8 deletions(-)
> 

Queued, thanks.

Paolo


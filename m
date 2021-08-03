Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA933DEAB3
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 12:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbhHCKRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 06:17:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235135AbhHCKRk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 06:17:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627985848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DYi9zCYb/+nOBKs9RrX6QQsVbPNcDstKhS42LRE6Yz8=;
        b=P9WRLEGnA/hIXpcTqOu5l7EnSqTd2lfyK9elFxYtiFuUl23BMPfZCHDdcK2gAdeoGTwHTP
        pknEngCamVP24ryhDtaO+voC6a/+zuKh1VWe51xX/uKexPAbveIBsMgA0VYKy8Ux/D+gG8
        CPsofO8R6k3lOygR1Cf7YyCc9iBBPok=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-6PzY0kzRPUm-t85dHYMLcg-1; Tue, 03 Aug 2021 06:17:28 -0400
X-MC-Unique: 6PzY0kzRPUm-t85dHYMLcg-1
Received: by mail-ed1-f71.google.com with SMTP id y22-20020a0564023596b02903bd9452ad5cso2472721edc.20
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 03:17:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DYi9zCYb/+nOBKs9RrX6QQsVbPNcDstKhS42LRE6Yz8=;
        b=Lk/jiPQrphdmAZ41hBgNRV1tAwydkZU6SFjYItD5KywBSXpREabFreRI0qNQ15XWKK
         ibDg8KwMd5B60FnJ+Ye7ygGNHHVh8zSGwrX4gYOh8jfNkqCIpMXTTRQODjaf+48DnDEU
         lEjfZJzg1FxixL89QJNg20E+DPeFAZGyUpUlXGB9vzfF9fROOvinY+Fxtnyjc/QRTRDB
         cbHNRr8JCRvEai0ZxiITk9CXddGq0VsIkFrJw1dGYlZQ+JKKaoyEsQlmrxjhw187XVVC
         Wy2KSGhHoqjkS09yBHSKVClIG7TK9jEWnEJlsXMgugRU+heNCVkzqW1WVPvIZLuNPgPd
         6jgw==
X-Gm-Message-State: AOAM531k1W+rh9D3v7Nc726PI9WPvChKJ3LneulPBWS63p1dk/nRLQC9
        x1AbhrQVUOXGl+p1PyOqWmS1mGCcDvXXRt6gG2OoCi+BExrAZYUUHLvzWzQSmBsDXQbb8OHarOr
        yWJ/QRBvHQWHW
X-Received: by 2002:a50:d509:: with SMTP id u9mr24862215edi.35.1627985846731;
        Tue, 03 Aug 2021 03:17:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDS1D+kAoCLsIYfZDG+RsOKE9AsTRgy/bfs4niMLVxVR1QrN7uNK38I4Dok8Un0Xu/9yTj4Q==
X-Received: by 2002:a50:d509:: with SMTP id u9mr24862205edi.35.1627985846600;
        Tue, 03 Aug 2021 03:17:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id p23sm7850198edt.71.2021.08.03.03.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 03:17:26 -0700 (PDT)
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
Message-ID: <291904b2-a7f4-2b04-0822-7a723d09db02@redhat.com>
Date:   Tue, 3 Aug 2021 12:17:23 +0200
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EA63AC8E0
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 12:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhFRKeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 06:34:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233746AbhFRKeR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 06:34:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624012328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hfAvw0hgq0EhOtnnmtyXispMmzn0udfGL2kHrYegWv0=;
        b=AaZ4T/gKtA9YLc3UFA2R7YuDmiuLM8KOOmYzo2ljdS8Z0dRJ3OevZCDA6IzWdlnxhmyLX1
        +hgQZuKlzDhHqzfNmGXNj6XQDgjhSecmEPUTNT6451DBr/7ghH8I9n50tVL0klSXrtz6dq
        ix/54dbkBLH7lMrJbfx53QAJCsfrJg0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-j0Z2cwuSOKC3ACii8PFRRw-1; Fri, 18 Jun 2021 06:32:06 -0400
X-MC-Unique: j0Z2cwuSOKC3ACii8PFRRw-1
Received: by mail-ej1-f70.google.com with SMTP id w22-20020a17090652d6b029048a3391d9f6so248491ejn.12
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 03:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hfAvw0hgq0EhOtnnmtyXispMmzn0udfGL2kHrYegWv0=;
        b=KsH/uQuGHRUa+5DX9aHCOPHQsaFRMpwVp7eN2Qng9Hq9y1aDBMPc42K/grDvhNxd1b
         dCvCOZVUQHJftGXugsylHSIBlMw/xl8CPE0zQim5ORscO7/aCMfWPL1x8JqDbVeC+7gV
         Y65yLHktw40ilkvqJUWPJ8tFlB3zaJUrwhKKcuRPghEtB4vzcPlJo9ujm9orusCt7Kje
         pL4BDoGc4MjVuUZl3a0bpoA+swDwbeCTw3b5qOsn0SxbELWatD0DXUYf3R0nvL+K9U6e
         0KkvEmXcDpeT0f8a2EQ6I82Y3/pdjMfAAf9ioy+2bcffDsL8Xq7kfZOtXDA5WDe/ReHt
         S83A==
X-Gm-Message-State: AOAM532pZk/lqJzLSSIR34pQT2eetY3k+CxmcaB2jplh4pwq7f4t3bT8
        C6tIT0G2hjgxqnOgVJL2cTishNxmK/p3kkxFIBuScrtQ1a8EH+jTm00qcHtF+FFa6ZaHzR6fBv+
        wlJErgVvx31U+
X-Received: by 2002:a17:906:6d59:: with SMTP id a25mr2090258ejt.83.1624012325552;
        Fri, 18 Jun 2021 03:32:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxSSyuG/lp7VKy9v50YMmn7y8mIz2ZyCGQj3rEnS1eNbeDJb9F7YHyHC8OBkKI0VatG7L01w==
X-Received: by 2002:a17:906:6d59:: with SMTP id a25mr2090238ejt.83.1624012325419;
        Fri, 18 Jun 2021 03:32:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o5sm5925198edq.8.2021.06.18.03.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 03:32:04 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: x86: Require EFER.NX support unless EPT is on
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210615164535.2146172-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <388739c8-6881-8fa7-2025-53b9a464c4cb@redhat.com>
Date:   Fri, 18 Jun 2021 12:32:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210615164535.2146172-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/21 18:45, Sean Christopherson wrote:
> KVM has silently required EFER.NX support for shadow paging for well over
> a year, and for NPT for roughly the same amount of time.  Attempting to
> run any VM with shadow paging on a system without NX support will fail due
> to invalid state, while enabling nx_huge_pages with NPT and no NX will
> explode due to setting a reserved bit in the page tables.
> 
> I really, really wanted to require NX across the board, because the lack
> of bug reports for the shadow paging change strongly suggests no one is
> running KVM on a CPU that truly doesn't have NX.  But, Intel CPUs let
> firmware disable NX via MISC_ENABLES, so it's plausible that there are
> users running KVM with EPT and no NX.
> 
> Sean Christopherson (4):
>    KVM: VMX: Refuse to load kvm_intel if EPT and NX are disabled
>    KVM: SVM: Refuse to load kvm_amd if NX support is not available
>    KVM: x86: WARN and reject loading KVM if NX is supported but not
>      enabled
>    KVM: x86: Simplify logic to handle lack of host NX support
> 
>   arch/x86/kvm/cpuid.c   | 13 +++++--------
>   arch/x86/kvm/svm/svm.c | 13 ++++++++++---
>   arch/x86/kvm/vmx/vmx.c |  6 ++++++
>   arch/x86/kvm/x86.c     |  3 +++
>   4 files changed, 24 insertions(+), 11 deletions(-)
> 

Queued 1-3, thanks.

Paolo


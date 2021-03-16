Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5542533DC61
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 19:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbhCPSRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 14:17:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236066AbhCPSQx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 14:16:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615918612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rWvC3plWxRUcrq0wECmuV30Rqwzs1WlHNCdPKpsOEDg=;
        b=bvp8OtNSIYFOe6W11diCLTs+405fTImwpwvsMlbLYu+SG2XwcQXq4Ni7lPovqsQb9Eo0Vl
        y4mrz9odklcOQJA7eBmcmY67X+qc4oe+TDUxHIh7NnsupE5TXeuvDl2BrCifQK8ix6XPEB
        YQt7hbXLQDNgpaVViKqNrDiJFKQ3PsM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-4Se4VUZBMGWhmc6R-MZtFg-1; Tue, 16 Mar 2021 14:16:49 -0400
X-MC-Unique: 4Se4VUZBMGWhmc6R-MZtFg-1
Received: by mail-wr1-f69.google.com with SMTP id x9so16931989wro.9
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 11:16:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rWvC3plWxRUcrq0wECmuV30Rqwzs1WlHNCdPKpsOEDg=;
        b=UGzzYp8IXE/+Z/yl3k3M0bI5F+nJqixwradlTGR0bYvaDa85bsnJjL4K3rFY1W36Eh
         iy9OqGFrOXwJ0WjIysUuEkqDRO1oG8JPK4UCoQ5Y8RKI4QGlJZbr14jL3mUtltrJFW/l
         qEJu0eG/Uc+zuhOgM9VIFh0RtThPZOmfYLtfvx+og1l3viJDVRdYR6y0B0kfGfJJgX3y
         qybmhQIJIxlYcscHQcg5jW5abiNgIPr0LV6GCckmP4TAxA1IvYOgT8H64KgSzUjmI3VN
         shqidB6M/adxzpUTA/lK/4ctZs/8tRFl7frp8Yhfd/Vtc2R8HPKWh4GC7R+WVGPyEu5t
         1Xjg==
X-Gm-Message-State: AOAM533mCsaSupIAoRcnpPcSmt5m6aFJM9VMlbVRchH8UW7HiIQ7w011
        pwYbfrEydVaGHXzNeOYckb5339faMevrwFVNmYWgxvjAqLIFnn4SnHwMJB+dqWMpU5FyYC7YvEk
        eTxR/N57A6fNs
X-Received: by 2002:a5d:58ce:: with SMTP id o14mr369718wrf.4.1615918608479;
        Tue, 16 Mar 2021 11:16:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYoG+t52TxYVDOkJgWCB+uFgojkq4p3glPLifuvRtEpvSPpFLQps7WXsAkJ7+8ZJoRrt1lPw==
X-Received: by 2002:a5d:58ce:: with SMTP id o14mr369695wrf.4.1615918608272;
        Tue, 16 Mar 2021 11:16:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s3sm22977552wrt.93.2021.03.16.11.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 11:16:47 -0700 (PDT)
Subject: Re: [PATCH v3 0/4] Fix RCU warnings in TDP MMU
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20210315233803.2706477-1-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1b03ae88-2b5c-5806-1cac-0e44a2395d0c@redhat.com>
Date:   Tue, 16 Mar 2021 19:16:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210315233803.2706477-1-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/03/21 00:37, Ben Gardon wrote:
> The Linux Test Robot found a few RCU warnings in the TDP MMU:
> https://www.spinics.net/lists/kernel/msg3845500.html
> https://www.spinics.net/lists/kernel/msg3845521.html
> 
> Fix these warnings and cleanup a hack in tdp_mmu_iter_cond_resched.
> 
> Tested by compiling as suggested in the test robot report and confirmed
> that the warnings go away with this series applied. Also ran
> kvm-unit-tests on an Intel Skylake machine with the TDP MMU enabled and
> confirmed that the series introduced no new failures.
> 
> Ben Gardon (3):
>    KVM: x86/mmu: Fix RCU usage in handle_removed_tdp_mmu_page
>    KVM: x86/mmu: Fix RCU usage when atomically zapping SPTEs
>    KVM: x86/mmu: Factor out tdp_iter_return_to_root
> 
> Sean Christopherson (1):
>    KVM: x86/mmu: Store the address space ID in the TDP iterator
> 
>   arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
>   arch/x86/kvm/mmu/tdp_iter.c     | 30 +++++++++++++++----------
>   arch/x86/kvm/mmu/tdp_iter.h     |  4 +++-
>   arch/x86/kvm/mmu/tdp_mmu.c      | 40 +++++++++++++--------------------
>   4 files changed, 41 insertions(+), 38 deletions(-)
> 

Queued, thanks.

Paolo


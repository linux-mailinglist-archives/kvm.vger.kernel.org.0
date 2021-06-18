Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BAA3AC914
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 12:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhFRKr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 06:47:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229522AbhFRKr3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 06:47:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624013120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B88T5AJCK5YM/NihTXbrtf5xFF1uQNN5f31NLCAWxUE=;
        b=AazzUXxKJZ37MwXzUL8btHxWBn6kUCzSDLWIBSMuMQXE6cgG2V2xBa3wtvzI71qHpYxAn9
        93tzIm8wQMX6A0mESiLS5mG1RXP2DCA3FmJSb8bsXkVQVCScHt29Vs2CDOASvDAYcE/tR2
        pQJ3CktyYm6OggpOgDAcPK93vp36XOM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-JS3iKXdAP_eG-np9GK8gzA-1; Fri, 18 Jun 2021 06:45:18 -0400
X-MC-Unique: JS3iKXdAP_eG-np9GK8gzA-1
Received: by mail-ed1-f71.google.com with SMTP id x12-20020a05640226ccb0290393aaa6e811so3304162edd.19
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 03:45:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B88T5AJCK5YM/NihTXbrtf5xFF1uQNN5f31NLCAWxUE=;
        b=OXU2V1KOf0WqWCbodxT4F4liUWmNI5tTt3AMr7v8PD5uq+hF12E0dbTi3a++rG+bud
         7XoDmTlMF1n4pAJW8fObkVHIk2OlS7tNOD/V9mJYG555Vstfkpw0sEMnF3tPh+s70o0U
         OBjq+fyFQHAYDPny7CjkK0BHAnn80duclGTHIlyu0Q3uUy6I1iezv8Ym8KGc0t0QMvId
         Og5B350A8exsHWwkGnMlj33+R+E1j0DTJvlBikvEEo8505MBdyzaTzrW8J+zkylHy9AW
         ZBq6rDbPR5siPBRtvkGjSbJvq3SzH/cfectxwDLJ9NUY0E3PGrxtQHUFUhs1oLHuIPm+
         yNyQ==
X-Gm-Message-State: AOAM530VcYEOZ5eQ9FqC/uYI1wyDiHLIXUhAosqQfGFcQhaD189X5O9Q
        r0kQuZO1KIGXnv1/KMibFaJf+CpvMKo2MJFnkHXTgpmp/9kQUtX88s7cs9RuSRkgMVXrT3KRPv2
        pG85hl0mecxgu
X-Received: by 2002:aa7:c7c7:: with SMTP id o7mr4115488eds.231.1624013117658;
        Fri, 18 Jun 2021 03:45:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/Ky9UuducRUNK/NclX1X7eayLfMaKt/2E7c7RWemwx5HaH0JwLBmpOZ5vC55EWB3+26ujOQ==
X-Received: by 2002:aa7:c7c7:: with SMTP id o7mr4115469eds.231.1624013117528;
        Fri, 18 Jun 2021 03:45:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id jl25sm505485ejc.94.2021.06.18.03.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 03:45:16 -0700 (PDT)
Subject: Re: [PATCH 0/5] KVM: x86/mmu: Clean up is_tdp_mmu_root and root_hpa
 checks
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>
References: <20210617231948.2591431-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <41def4cb-f9dc-4b45-05af-6d2ac10e634d@redhat.com>
Date:   Fri, 18 Jun 2021 12:45:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210617231948.2591431-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/21 01:19, David Matlack wrote:
> This series is spun off from Sean's suggestions on [PATCH 1/8] of my TDP
> MMU Fast Page Fault series [1].
> 
> Patches 1-2 and 4 cleans up some redundant code in the page fault handling path:
>   - Redundant checks for TDP MMU enablement.
>   - Redundant checks for root_hpa validity.
> 
> Patch 3 refactors is_tdp_mmu_root into a simpler function prototype.
> 
> Note to reviewers: I purposely opted not to remove the root_hpa check
> from is_tdp_mmu even though it is theoretically redundant in the current
> code. My rational is that it could be called from outside the page fault
> handling code in the future where root_hpa can be invalid. This seems
> more likely to happen than with the other functions since is_tdp_mmu()
> is not inherently tied to page fault handling.
> 
> The cost of getting this wrong is high since the result would be we end
> up calling executing pfn_to_page(-1 >> PAGE_SHIFT)->private in
> to_shadow_page. A better solution might be to move the VALID_PAGE check
> into to_shadow_page but I did not want to expand the scope of this
> series.
> 
> To test this series I ran all kvm-unit-tests and KVM selftests on an
> Intel Cascade Lake machine.
> 
> [1] https://lore.kernel.org/kvm/YMepDK40DLkD4DSy@google.com/
> 
> David Matlack (4):
>    KVM: x86/mmu: Remove redundant is_tdp_mmu_root check
>    KVM: x86/mmu: Remove redundant is_tdp_mmu_enabled check
>    KVM: x86/mmu: Refactor is_tdp_mmu_root into is_tdp_mmu
>    KVM: x86/mmu: Remove redundant root_hpa checks
> 
>   arch/x86/kvm/mmu/mmu.c     | 19 ++++++-------------
>   arch/x86/kvm/mmu/tdp_mmu.c |  5 -----
>   arch/x86/kvm/mmu/tdp_mmu.h |  5 ++---
>   3 files changed, 8 insertions(+), 21 deletions(-)
> 

Queued, thanks.

Paolo


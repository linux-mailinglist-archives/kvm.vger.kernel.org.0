Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FE9326059
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 10:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhBZJmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 04:42:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37195 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230437AbhBZJkZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Feb 2021 04:40:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614332338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C/g8o8uK4e+SnXcWE/NkM7/ygwSQ3LN2AhyHaIpuq5w=;
        b=Y7JcH1xaI6Xz/C9+oe/HeF977+ebrF6c60M7vQYN1VEYB+oOyP4pQo40O85VsRMiJMCuXT
        pYs7ovSoeaTpS1gnn2DjC0/rNK2JqxZnfd9MTpxhc9EYNWHatJbC+XvQek41VndUe80QKg
        BmnW/BE9nOzkye7kA4RXu9NQqRAlb3Q=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292--TS8c3Y6PTS02N_T3xp-Xw-1; Fri, 26 Feb 2021 04:38:56 -0500
X-MC-Unique: -TS8c3Y6PTS02N_T3xp-Xw-1
Received: by mail-wr1-f72.google.com with SMTP id u15so4445553wrn.3
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 01:38:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C/g8o8uK4e+SnXcWE/NkM7/ygwSQ3LN2AhyHaIpuq5w=;
        b=eM7p6lCNTFqvXnPObd839HSwHoctZXNNPSvmHt27PoPWlnfd/kSv3LcMXlOojKwM2E
         9Bhq09kVexicBVIxEGtPRl7N3g7rb9rA8txblnlhTBbRANJfLoJu0nvZ8Cs3z2wgNSOx
         mCgOxRDjLGRMJkClsjLbolSXhGOAUqYPZY1Dha4JNNnmub15nuHJdoNDUC5y7VgCuHms
         LnowzJvUTQZeMLijBj5evjDr6t5Rwi74qreXt1BPTT83CR9sPK59RUoDymFkrWGrRWWW
         9aqdwhOtxaSDcfh5+1eUaYV1kREDlLLXsmYFaqba5Lth5+KgQsIk79bv9eMEOx43KkvD
         LUkg==
X-Gm-Message-State: AOAM532UKEz3wk7p/oBOnc1/T7R01uxtDIoS/A3O+ujlhZ+IoxyIyAI0
        Gxoj8MTu6D08IcNvx49XRxexqqDFaOB7aAikNTSPkrxJ2CTM/yIX9w8xOIj6tXM/RlAVSE7ffOv
        2bdTHkoFs5qqJ
X-Received: by 2002:a5d:6342:: with SMTP id b2mr1390883wrw.421.1614332335243;
        Fri, 26 Feb 2021 01:38:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzHAcXIEpeKoC/43txGCct46GRjcVNlj/dx1/fWoaoFmEXYCtVIBXwLVni8w3cKlbOQyeX79A==
X-Received: by 2002:a5d:6342:: with SMTP id b2mr1390868wrw.421.1614332335074;
        Fri, 26 Feb 2021 01:38:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s23sm10619916wmc.35.2021.02.26.01.38.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 01:38:54 -0800 (PST)
Subject: Re: [PATCH 00/24] KVM: x86/mmu: Introduce MMU_PRESENT and fix bugs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
References: <20210225204749.1512652-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cac684b9-b195-1b7b-0557-d5d62659b3b3@redhat.com>
Date:   Fri, 26 Feb 2021 10:38:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/02/21 21:47, Sean Christopherson wrote:
> This series adds the simple idea of tagging shadow-present SPTEs with
> a single bit, instead of looking for non-zero SPTEs that aren't MMIO and
> aren't REMOVED.  Doing so reduces KVM's code footprint by 2k bytes on
> x86-64, and presumably adds a tiny performance boost in related paths.
> 
> But, actually adding MMU_PRESENT without breaking one flow or another is
> a bit of a debacle.  The main issue is that EPT doesn't have many low
> available bits, and PAE doesn't have any high available bits.  And, the
> existing MMU_WRITABLE and HOST_WRITABLE flags aren't optional, i.e. are
> needed for all flavors of paging.  The solution I settled on is to let
> make the *_WRITABLE bit configurable so that EPT can use high available
> bits.
> 
> Of course, I forgot the above PAE restriction multiple times, and
> journeyed down several dead ends.  The most notable failed idea was
> using the AD_* masks in bits 52 and 53 to denote shadow-present SPTEs.
> That would have been quite clever as it would provide the same benefits
> without burning another available bit.
> 
> Along the many failed attempts, I collected a variety of bug fixes and
> cleanups, mostly things found by inspection after doing a deep dive to
> figure out what I broke.
> 
> Sean Christopherson (24):
>    KVM: x86/mmu: Set SPTE_AD_WRPROT_ONLY_MASK if and only if PML is
>      enabled
>    KVM: x86/mmu: Check for shadow-present SPTE before querying A/D status
>    KVM: x86/mmu: Bail from fast_page_fault() if SPTE is not
>      shadow-present
>    KVM: x86/mmu: Disable MMIO caching if MMIO value collides with L1TF
>    KVM: x86/mmu: Retry page faults that hit an invalid memslot
>    KVM: x86/mmu: Don't install bogus MMIO SPTEs if MMIO caching is
>      disabled
>    KVM: x86/mmu: Handle MMIO SPTEs directly in mmu_set_spte()
>    KVM: x86/mmu: Drop redundant trace_kvm_mmu_set_spte() in the TDP MMU
>    KVM: x86/mmu: Rename 'mask' to 'spte' in MMIO SPTE helpers
>    KVM: x86/mmu: Stop using software available bits to denote MMIO SPTEs
>    KVM: x86/mmu: Add module param to disable MMIO caching (for testing)
>    KVM: x86/mmu: Rename and document A/D scheme for TDP SPTEs
>    KVM: x86/mmu: Use MMIO SPTE bits 53 and 52 for the MMIO generation
>    KVM: x86/mmu: Document dependency bewteen TDP A/D type and saved bits
>    KVM: x86/mmu: Move initial kvm_mmu_set_mask_ptes() call into MMU
>      proper
>    KVM: x86/mmu: Co-locate code for setting various SPTE masks
>    KVM: x86/mmu: Move logic for setting SPTE masks for EPT into the MMU
>      proper
>    KVM: x86/mmu: Make Host-writable and MMU-writable bit locations
>      dynamic
>    KVM: x86/mmu: Use high bits for host/mmu writable masks for EPT SPTEs
>    KVM: x86/mmu: Use a dedicated bit to track shadow/MMU-present SPTEs
>    KVM: x86/mmu: Tweak auditing WARN for A/D bits to !PRESENT (was MMIO)
>    KVM: x86/mmu: Use is_removed_spte() instead of open coded equivalents
>    KVM: x86/mmu: Use low available bits for removed SPTEs
>    KVM: x86/mmu: Dump reserved bits if they're detected on non-MMIO SPTE
> 
>   Documentation/virt/kvm/locking.rst |  49 +++++----
>   arch/x86/include/asm/kvm_host.h    |   3 -
>   arch/x86/kvm/mmu.h                 |  15 +--
>   arch/x86/kvm/mmu/mmu.c             |  87 +++++++---------
>   arch/x86/kvm/mmu/mmu_internal.h    |  16 +--
>   arch/x86/kvm/mmu/paging_tmpl.h     |   2 +-
>   arch/x86/kvm/mmu/spte.c            | 157 ++++++++++++++++++++---------
>   arch/x86/kvm/mmu/spte.h            | 135 +++++++++++++++++--------
>   arch/x86/kvm/mmu/tdp_mmu.c         |  22 ++--
>   arch/x86/kvm/svm/svm.c             |   2 +-
>   arch/x86/kvm/vmx/vmx.c             |  24 +----
>   arch/x86/kvm/x86.c                 |   3 -
>   12 files changed, 290 insertions(+), 225 deletions(-)
> 

Queued (patch 1 for 5.12, the rest for 5.13).

Paolo


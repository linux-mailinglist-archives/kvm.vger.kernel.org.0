Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECF94CED99
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 21:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbiCFUIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Mar 2022 15:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiCFUIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Mar 2022 15:08:12 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4DF1D0EA
        for <kvm@vger.kernel.org>; Sun,  6 Mar 2022 12:07:19 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so12339911pjl.4
        for <kvm@vger.kernel.org>; Sun, 06 Mar 2022 12:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gil5ranxrEJQ6Leg6l42UoKvzbmcu5Ve8XhC1QPDDh8=;
        b=Y8HpHgHECt/Zx/Om11L0P313HOLC4xvjSlEdMDGyN80Kbp6fI7BJUX4GMLqOEsro1t
         qwV8njf8GH/M0ju7kRVfUeyOyOOAni5GhoUw4Q/nT9ILPtzqiHzEBioYxda4UJSG9n/k
         sjii8cyE+T6B5lQKE5m3+mzV8BQI96TIMoDrAx27orzo2pOuCZSrnfOLtum1KkHOZii4
         8iFGBLAEDRnEdLZi67NYTqVylV4DCQ277DIEBHppKAwBUL7Jc7Z44gtPhGgKh+6B2qDF
         3NtcTdkirnZav2k7Zaw7B6tTO8tjWBYCrNFVulRmqz97qyaBGTDlYlEPLZcVva8C2idB
         bjKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gil5ranxrEJQ6Leg6l42UoKvzbmcu5Ve8XhC1QPDDh8=;
        b=WWW7agaq67BurtGcRd+/t6Vq/1B4FhHTnl6reGhA3GhI0nJNX1BEq5fYBfcYfI++q3
         QcWag/zIpWqFW11iXRfe4FnDel7BRAme5I8vcKMLJJqZRam1cQIb3IfA48KT1QO8W41o
         Gym7QCPzLTghLe4FGvLpQvDFYrCPTiloUiC5j/NBo8I+JU2HdV+lC7sFBbpzAJAJTZ3D
         oop5r4aU39pwOrdIpALu+JRKa4ws76U1KqejwecPbWQ2pRpmYBnCS/zsEQY3CrDjYKE8
         D3rwkJSZgzFMFgg+jdsv1hy4mlIZpIBaX3Awq0JaLPRVrs7F7L75r5ObeQycgCUdlM0i
         nHIA==
X-Gm-Message-State: AOAM530KPMahKfVjqkFaqkRYpZ5uSXTYL9jxktTuqsf0/aIebDiGzVWa
        IULsLPn0joMsBFGw47LCBzSMTA==
X-Google-Smtp-Source: ABdhPJxmr7dUAsczuQV6y0q70V9lG/wZoht0kvNb2atRV5xwDENR0kx8e9qzWQbN73L5E0dUtC0+HA==
X-Received: by 2002:a17:902:aa8d:b0:150:c60:29a4 with SMTP id d13-20020a170902aa8d00b001500c6029a4mr9015870plr.40.1646597238817;
        Sun, 06 Mar 2022 12:07:18 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id p16-20020a056a000b5000b004f669806cd9sm13318385pfo.87.2022.03.06.12.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 12:07:18 -0800 (PST)
Date:   Sun, 6 Mar 2022 20:07:14 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] KVM: SVM: Defer page pinning for SEV guests
Message-ID: <YiUUcuEuWbQrPs2E@google.com>
References: <20220118110621.62462-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118110621.62462-1-nikunj@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022, Nikunj A Dadhania wrote:
> SEV guest requires the guest's pages to be pinned in host physical
> memory as migration of encrypted pages is not supported. The memory
> encryption scheme uses the physical address of the memory being
> encrypted. If guest pages are moved by the host, content decrypted in
> the guest would be incorrect thereby corrupting guest's memory.
> 
> For SEV/SEV-ES guests, the hypervisor doesn't know which pages are
> encrypted and when the guest is done using those pages. Hypervisor
> should treat all the guest pages as encrypted until the guest is
> destroyed.
"Hypervisor should treat all the guest pages as encrypted until they are
deallocated or the guest is destroyed".

Note: in general, the guest VM could ask the user-level VMM to free the
page by either free the memslot or free the pages (munmap(2)).

> 
> Actual pinning management is handled by vendor code via new
> kvm_x86_ops hooks. MMU calls in to vendor code to pin the page on
> demand. Metadata of the pinning is stored in architecture specific
> memslot area. During the memslot freeing path guest pages are
> unpinned.

"During the memslot freeing path and deallocation path"

> 
> Initially started with [1], where the idea was to store the pinning
> information using the software bit in the SPTE to track the pinned
> page. That is not feasible for the following reason:
> 
> The pinned SPTE information gets stored in the shadow pages(SP). The
> way current MMU is designed, the full MMU context gets dropped
> multiple number of times even when CR0.WP bit gets flipped. Due to
> dropping of the MMU context (aka roots), there is a huge amount of SP
> alloc/remove churn. Pinned information stored in the SP gets lost
> during the dropping of the root and subsequent SP at the child levels.
> Without this information making decisions about re-pinnning page or
> unpinning during the guest shutdown will not be possible
> 
> [1] https://patchwork.kernel.org/project/kvm/cover/20200731212323.21746-1-sean.j.christopherson@intel.com/ 
> 

A general feedback: I really like this patch set and I think doing
memory pinning at fault path in kernel and storing the metadata in
memslot is the right thing to do.

This basically solves all the problems triggered by the KVM based API
that trusts the user-level VMM to do the memory pinning.

Thanks.
> Nikunj A Dadhania (4):
>   KVM: x86/mmu: Add hook to pin PFNs on demand in MMU
>   KVM: SVM: Add pinning metadata in the arch memslot
>   KVM: SVM: Implement demand page pinning
>   KVM: SEV: Carve out routine for allocation of pages
> 
> Sean Christopherson (2):
>   KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by SEV/TDX
>   KVM: SVM: Pin SEV pages in MMU during sev_launch_update_data()
> 
>  arch/x86/include/asm/kvm-x86-ops.h |   3 +
>  arch/x86/include/asm/kvm_host.h    |   9 +
>  arch/x86/kvm/mmu.h                 |   3 +
>  arch/x86/kvm/mmu/mmu.c             |  41 +++
>  arch/x86/kvm/mmu/tdp_mmu.c         |   7 +
>  arch/x86/kvm/svm/sev.c             | 423 +++++++++++++++++++----------
>  arch/x86/kvm/svm/svm.c             |   4 +
>  arch/x86/kvm/svm/svm.h             |   9 +-
>  arch/x86/kvm/x86.c                 |  11 +-
>  9 files changed, 359 insertions(+), 151 deletions(-)
> 
> -- 
> 2.32.0
> 

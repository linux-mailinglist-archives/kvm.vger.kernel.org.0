Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18C63A2CFE
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 15:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhFJNa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 09:30:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230365AbhFJNaz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 09:30:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623331739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PlqPawYArazO4EePzETjFqSxt008hDP9xscnSm3Mc0w=;
        b=dKPIxFJ6BRoY81iV9SeeAUBLpKBJZHNpT6Q64+YZ8eJbsYqlqjiz29gSSiddlUsyJBVRnB
        A0+V2OJacPXk/9GXfpPIeDTqd+jyGw8YZwQgxxZ8SaA/BF026BeHZbknMaTe+SmSY+Nnjy
        2Xar5aewRylPtsL/YUloniBHsQ2YsN4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-LakVb6YeOO6oLwb5IiEmQg-1; Thu, 10 Jun 2021 09:28:57 -0400
X-MC-Unique: LakVb6YeOO6oLwb5IiEmQg-1
Received: by mail-wr1-f72.google.com with SMTP id x9-20020a5d49090000b0290118d8746e06so901274wrq.10
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 06:28:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PlqPawYArazO4EePzETjFqSxt008hDP9xscnSm3Mc0w=;
        b=LifGKVRCABSiaTItDVH9YLXswwFOddyR1yoqgmG/rQ1G9LJv1J4VObwctUW4O8ij7Z
         R5lbEUl53MANGGyYsuyL9s4DEhQfArhUW9grss6QIjrDzya5yn3WDXLNgAOTQ03OGedt
         aQwtfc9pUy5zVODjivlaRAykW8al1VVFwFElnwZqgIPapA9DsG0jbqAlaC8IufehpqDP
         EBSEg6NHW9xJ5LFgENV+LY9Ld7duypxmGR2j9sZchtg0ZA010T+/caAh+OtYZboPBa32
         JxAwXHGjlg67L5OCFiEj95RiWqmI/XR1JA9rWiO15UaAMzM3biwUGy7rWgeN9Lc3nZbn
         nD2w==
X-Gm-Message-State: AOAM530u8CBNMu2/euIxg9gzcEe6ka82/lWUt2C3mAgtyOTZgE+4799j
        LQoq464q1IWajMTFRSMaK7BQj5L6fNQRY/1ZkyIShCPpX9AykTMn8hDKv4ahazbrajpen2Uy6k9
        C5dETNeTNB4cT
X-Received: by 2002:a05:6000:1889:: with SMTP id a9mr5575600wri.288.1623331736723;
        Thu, 10 Jun 2021 06:28:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAv1xai1qFmu7u1yp22S9GYwfnxl8Ag90DTPRjFRmef50BS0D0Bsl8/7GwaQ8GVD+a8zOcMA==
X-Received: by 2002:a05:6000:1889:: with SMTP id a9mr5575578wri.288.1623331736489;
        Thu, 10 Jun 2021 06:28:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id v132sm10354950wmb.14.2021.06.10.06.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 06:28:55 -0700 (PDT)
Subject: Re: [PATCH 0/9] KVM: x86: Fix NULL pointer #GP due to RSM bug
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
References: <20210609185619.992058-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <685b11c1-54a6-3a52-8157-4a10a95251ca@redhat.com>
Date:   Thu, 10 Jun 2021 15:28:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609185619.992058-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 20:56, Sean Christopherson wrote:
> Fix a NULL pointer dereference in gfn_to_rmap() that occurs if RSM fails,
> reported by syzbot.
> 
> The immediate problem is that the MMU context's role gets out of sync
> because KVM clears the SMM flag in the vCPU at the start of RSM emulation,
> but only resets the MMU context if RSM succeeds.  The divergence in vCPU
> vs. MMU role with respect to the SMM flag causes explosions if the non-SMM
> memslots have gfn ranges that are not present in the SMM memslots, because
> the MMU expects that the memslot for a shadow page cannot magically
> disappear.
> 
> The other obvious problem is that KVM doesn't emulate triple fault on RSM
> failure, e.g. it keeps running the vCPU in a frankenstate instead of
> exiting to userspace.  Fixing that would squash the syzbot repro, but
> would not fix the underlying issue because nothing prevents userspace from
> calling KVM_RUN on a vCPU that hit shutdown (yay lack of a shutdown state).
> But, it's easy to fix and definitely worth doing.
> 
> Everything after the two bug fixes is cleanup.
> 
> Ben Gardon has an internal patch or two that guards against the NULL
> pointer dereference in gfn_to_rmap().  I'm planning on getting that
> functionality posted (needs a little massaging) so that these types of
> snafus don't crash the host (this isn't the first time I've introduced a
> bug that broke gfn_to_rmap(), though thankfully it's the first time such
> a bug has made it upstream, knock on wood).
> 
> Amusingly, adding gfn_to_rmap() NULL memslot checks might even be a
> performance improvement.  Because gfn_to_rmap() doesn't check the memslot
> before using it, and because the compiler can see the search_memslots()
> returns NULL/0, gcc often/always generates dedicated (and hilarious) code
> for NULL, e.g. this #GP was caused by an explicit load from 0:
> 
>    48 8b 14 25 00 00 00 00	mov    0x0,%rdx
> 
> 
> Sean Christopherson (9):
>    KVM: x86: Immediately reset the MMU context when the SMM flag is
>      cleared
>    KVM: x86: Emulate triple fault shutdown if RSM emulation fails
>    KVM: x86: Replace .set_hflags() with dedicated .exiting_smm() helper
>    KVM: x86: Invoke kvm_smm_changed() immediately after clearing SMM flag
>    KVM: x86: Move (most) SMM hflags modifications into kvm_smm_changed()
>    KVM: x86: Move "entering SMM" tracepoint into kvm_smm_changed()
>    KVM: x86: Rename SMM tracepoint to make it reflect reality
>    KVM: x86: Drop .post_leave_smm(), i.e. the manual post-RSM MMU reset
>    KVM: x86: Drop "pre_" from enter/leave_smm() helpers
> 
>   arch/x86/include/asm/kvm-x86-ops.h |  4 +--
>   arch/x86/include/asm/kvm_host.h    |  4 +--
>   arch/x86/kvm/emulate.c             | 31 ++++++++++-------
>   arch/x86/kvm/kvm_emulate.h         |  7 ++--
>   arch/x86/kvm/svm/svm.c             |  8 ++---
>   arch/x86/kvm/trace.h               |  2 +-
>   arch/x86/kvm/vmx/vmx.c             |  8 ++---
>   arch/x86/kvm/x86.c                 | 53 +++++++++++++++---------------
>   8 files changed, 61 insertions(+), 56 deletions(-)
> 

Queued 2-9 too for 5.14, with Vitaly's suggested change for patch 2.

Paolo


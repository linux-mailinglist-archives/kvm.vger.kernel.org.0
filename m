Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AB531EC09
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 17:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbhBRQJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 11:09:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233207AbhBRM75 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 07:59:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613653068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VRBSOwBTk74QepJAodCHBRew2o7UuH2NYYoJ6oB9xBU=;
        b=fbhlcec4BKRhsqprO4hX7OxTnssB8o7jck4dIcC86BuInjij3qLjB1NRimz2STJ0Sy/idG
        Z0c2DaI//rUVQcchPfTVE0LBDhyidthXjJ+Ln+kYcXiiuGelQ5fzEwNWhQOyR/3nTONHEg
        Vng5YHvGxCFR2zhBVdnANioTGE8404M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-YGsn3altM0OsDmcaoGxgrw-1; Thu, 18 Feb 2021 07:57:46 -0500
X-MC-Unique: YGsn3altM0OsDmcaoGxgrw-1
Received: by mail-wr1-f69.google.com with SMTP id l10so933628wry.16
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 04:57:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VRBSOwBTk74QepJAodCHBRew2o7UuH2NYYoJ6oB9xBU=;
        b=ZaMQWBoFGobNCCXtiUr9D41izb+qocpKqcSRk053iAvizY/ytWFSrgaupMQR8fFQDN
         SqKhBaQuUMeN7HhyhFyZcHTGsrZIWUnnwJcQtgU6ijFXyuarWoppRqvvUzcY7p2R3vTl
         WWuZMz9wsT/GghFK61anA+g2MIZvJ8aaOP/A9bXOHgBytkBZyrRxGsKisHq9HTPHeinC
         cZe+2X+Q8HB9w9iGkdnP7kXf0JUbnH3dfEWUEaZpYKiNuQ5/gklIHZ5bN21DtiP2w3mH
         y9y03Z4/y3IUU7yC9gJ0YwuDo3oj5yPUeF8apjs2S5SqQy0ggNMF8nJNDGQSGKxCMfsW
         /zzA==
X-Gm-Message-State: AOAM533fHWeHYFnfxVi2qWygOVxa90j3rJRMAZOWsyZwgVBmpg0XoABq
        CqM0+K30l+ZoxKJF0FkfP1gYqkpQ1HTI8lDCkrf8S6BtXulcKMJ5hLU8xz+g4w62BeVYRkwh58y
        vDRKDvpETrXzt
X-Received: by 2002:adf:dd42:: with SMTP id u2mr4269238wrm.309.1613653065646;
        Thu, 18 Feb 2021 04:57:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwmKgJNEY9XeTh9H6cj5Vv2AaoaMEJQ4Obvr940pmBWuu8wEeNw8xBBGOd5j68sbqGFO6qDFg==
X-Received: by 2002:adf:dd42:: with SMTP id u2mr4269225wrm.309.1613653065447;
        Thu, 18 Feb 2021 04:57:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id w2sm8986242wmg.27.2021.02.18.04.57.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 04:57:44 -0800 (PST)
Subject: Re: [PATCH 00/14] KVM: x86/mmu: Dirty logging fixes and improvements
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
References: <20210213005015.1651772-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b5ab72f2-970f-64bd-891c-48f1c303548d@redhat.com>
Date:   Thu, 18 Feb 2021 13:57:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210213005015.1651772-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/21 01:50, Sean Christopherson wrote:
> Paolo, this is more or less ready, but on final read-through before
> sending I realized it would be a good idea to WARN during VM destruction
> if cpu_dirty_logging_count is non-zero.  I wanted to get you this before
> the 5.12 window opens in case you want the TDP MMU fixes for 5.12.  I'll
> do the above change and retest next week (note, Monday is a US holiday).
> 
> On to the code...
> 
> This started out as a small tweak to collapsible SPTE zapping in the TDP
> MMU, and ended up as a rather large overhaul of CPU dirty logging, a.k.a.
> PML.
> 
> Four main highlights:
> 
>    - Do a more precise check on whether or not a SPTE should be zapped to
>      rebuild it as a large page.
>    - Disable PML when running L2.  PML is fully emulated for L1 VMMs, thus
>      enabling PML in L2 can only hurt and never help.
>    - Drop the existing PML kvm_x86_ops.  They're basically trampolines into
>      the MMU, and IMO do far more harm than good.
>    - Turn on PML only when it's needed instead of setting all dirty bits to
>      soft disable PML.
> 
> What led me down the rabbit's hole of ripping out the existing PML
> kvm_x86_ops isn't really shown here.  Prior to incorporating Makarand's
> patch, which allowed for the wholesale remove of setting dirty bits,
> I spent a bunch of time poking around the "set dirty bits" code.  My
> original changes optimized that path to skip setting dirty bits in the
> nested MMU, since the nested MMU relies on write-protection and not PML.
> That in turn allowed the TDP MMU zapping to completely skip walking the
> rmaps, but doing so based on a bunch of callbacks was a twisted mess.
> 
> Happily, those patches got dropped in favor of nuking the code entirely.
> 
> Ran selftest and unit tests, and migrated actual VMs on AMD and Intel,
> with and without TDP MMU, and with and without EPT.  The AMD system I'm
> testing on infinite loops on the reset vector due to a #PF when NPT is
> disabled, so that didn't get tested.  That reproduces with kvm/next,
> I'll dig into it next week (no idea if it's a KVM or hardware issue).
> 
> For actual migration, I ran kvm-unit-tests in L1 along with stress to
> hammer memory, and verified migration was effectively blocked until the
> stress threads were killed (I didn't feel like figuring out how to
> throttle the VM).
> 
> Makarand Sonare (1):
>    KVM: VMX: Dynamically enable/disable PML based on memslot dirty
>      logging
> 
> Sean Christopherson (13):
>    KVM: x86/mmu: Expand collapsible SPTE zap for TDP MMU to ZONE_DEVICE
>      pages
>    KVM: x86/mmu: Don't unnecessarily write-protect small pages in TDP MMU
>    KVM: x86/mmu: Split out max mapping level calculation to helper
>    KVM: x86/mmu: Pass the memslot to the rmap callbacks
>    KVM: x86/mmu: Consult max mapping level when zapping collapsible SPTEs
>    KVM: nVMX: Disable PML in hardware when running L2
>    KVM: x86/mmu: Expand on the comment in
>      kvm_vcpu_ad_need_write_protect()
>    KVM: x86/mmu: Make dirty log size hook (PML) a value, not a function
>    KVM: x86: Move MMU's PML logic to common code
>    KVM: x86: Further clarify the logic and comments for toggling log
>      dirty
>    KVM: x86/mmu: Don't set dirty bits when disabling dirty logging w/ PML
>    KVM: x86: Fold "write-protect large" use case into generic
>      write-protect
>    KVM: x86/mmu: Remove a variety of unnecessary exports
> 
>   arch/x86/include/asm/kvm-x86-ops.h |   6 +-
>   arch/x86/include/asm/kvm_host.h    |  36 +----
>   arch/x86/kvm/mmu/mmu.c             | 203 +++++++++--------------------
>   arch/x86/kvm/mmu/mmu_internal.h    |   7 +-
>   arch/x86/kvm/mmu/tdp_mmu.c         |  66 +---------
>   arch/x86/kvm/mmu/tdp_mmu.h         |   3 +-
>   arch/x86/kvm/vmx/nested.c          |  34 +++--
>   arch/x86/kvm/vmx/vmx.c             |  94 +++++--------
>   arch/x86/kvm/vmx/vmx.h             |   2 +
>   arch/x86/kvm/x86.c                 | 145 +++++++++++++--------
>   10 files changed, 230 insertions(+), 366 deletions(-)
> 

Queued 1-9 and 14 until you clarify my doubt about patch 10, thanks.

Paolo


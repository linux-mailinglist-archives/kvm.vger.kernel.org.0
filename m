Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7982B2826
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2019 00:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403918AbfIMWLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 18:11:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40832 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403839AbfIMWLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 18:11:16 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7690BCCFE6
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 22:11:15 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id r187so1414620wme.0
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 15:11:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hr2S3cXatEQEjg97ibO0S46MGU+IMBQToXpc/8fv2pA=;
        b=sztpskuMTK3jVdXyIugtjWSeH+ylE42fKwKwof1ubVvT5QsnOE7+yKDpABKJzlZm8U
         +ZJods0DmpFS2MbUNMrhdAqsFliwC0N6FhmwvqzJj4725HhljZizpojDYL9rEgFrXjpC
         mZT+vn9oqobZyRuWKlla1RvfP3bkNxKBrQbiade6QmlVqj1sIZJ48vVWupW0kdbzp2ab
         uzQoxBYX+zsJ5Pku6c0vL0c3Q76RvhoU9CUkRRChmQjQdRX34R2biEDQjRddNz4dtfOK
         Y6C6lcvPxEjhM7qypC5M/U+8kE0QM7fWDPhgm/3Pcge4GBkUg42iaxF34UZFxvR7UnWl
         AsyA==
X-Gm-Message-State: APjAAAUuSWyCAzGBtP9nomRE2m10hwTgw+tP5c/MiMLo7oqboxz7852F
        1S9vWJ9YEgt59CxNZ/Nf45WTpH1+Ar5Ct7o4Svx8ztJrNWXNpsDA4fhQ9o7QHOuxHBmXsDRTpk2
        S74Kvo66S8uWF
X-Received: by 2002:a5d:6288:: with SMTP id k8mr40466676wru.209.1568412674070;
        Fri, 13 Sep 2019 15:11:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwvg5mcGBMQcH69oTg4Zy/5SDck0mdoQ+L7PhYICLf0u+uCx46qLIxP64BzdPr6T4XAIhrtHA==
X-Received: by 2002:a5d:6288:: with SMTP id k8mr40466656wru.209.1568412673788;
        Fri, 13 Sep 2019 15:11:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3166:d768:e1a7:aab8? ([2001:b07:6468:f312:3166:d768:e1a7:aab8])
        by smtp.gmail.com with ESMTPSA id r16sm34574925wrc.81.2019.09.13.15.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Sep 2019 15:11:13 -0700 (PDT)
Subject: Re: [PATCH 00/11] KVM: x86/mmu: Restore fast invalidate/zap flow
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Harvey <jamespharvey20@gmail.com>,
        Alex Willamson <alex.williamson@redhat.com>
References: <20190913024612.28392-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d40b0e36-8a6a-d79e-4242-dda24a209bcd@redhat.com>
Date:   Sat, 14 Sep 2019 00:11:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190913024612.28392-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/09/19 04:46, Sean Christopherson wrote:
> Restore the fast invalidate flow for zapping shadow pages and use it
> whenever vCPUs can be active in the VM.  This fixes (in theory, not yet
> confirmed) a regression reported by James Harvey where KVM can livelock
> in kvm_mmu_zap_all() when it's invoked in response to a memslot update.
> 
> The fast invalidate flow was removed as it was deemed to be unnecessary
> after its primary user, memslot flushing, was reworked to zap only the
> memslot in question instead of all shadow pages.  Unfortunately, zapping
> only the memslot being (re)moved during a memslot update introduced a
> regression for VMs with assigned devices.  Because we could not discern
> why zapping only the relevant memslot broke device assignment, or if the
> regression extended beyond device assignment, we reverted to zapping all
> shadow pages when a memslot is (re)moved.
> 
> The revert to "zap all" failed to account for subsequent changes that
> have been made to kvm_mmu_zap_all() between then and now.  Specifically,
> kvm_mmu_zap_all() now conditionally drops reschedules and drops mmu_lock
> if a reschedule is needed or if the lock is contended.  Dropping the lock
> allows other vCPUs to add shadow pages, and, with enough vCPUs, can cause
> kvm_mmu_zap_all() to get stuck in an infinite loop as it can never zap all
> pages before observing lock contention or the need to reschedule.
> 
> The reasoning behind having kvm_mmu_zap_all() conditionally reschedule was
> that it would only be used when the VM is inaccesible, e.g. when its
> mm_struct is dying or when the VM itself is being destroyed.  In that case,
> playing nice with the rest of the kernel instead of hogging cycles to free
> unused shadow pages made sense.
> 
> Since it's unlikely we'll root cause the device assignment regression any
> time soon, and that simply removing the conditional rescheduling isn't
> guaranteed to return us to a known good state, restore the fast invalidate
> flow for zapping on memslot updates, including mmio generation wraparound.
> Opportunisticaly tack on a bug fix and a couple enhancements.
> 
> Alex and James, it probably goes without saying... please test, especially
> patch 01/11 as a standalone patch as that'll likely need to be applied to
> stable branches, assuming it works.  Thanks!
> 
> Sean Christopherson (11):
>   KVM: x86/mmu: Reintroduce fast invalidate/zap for flushing memslot
>   KVM: x86/mmu: Treat invalid shadow pages as obsolete
>   KVM: x86/mmu: Use fast invalidate mechanism to zap MMIO sptes
>   KVM: x86/mmu: Revert "Revert "KVM: MMU: show mmu_valid_gen in shadow
>     page related tracepoints""
>   KVM: x86/mmu: Revert "Revert "KVM: MMU: add tracepoint for
>     kvm_mmu_invalidate_all_pages""
>   KVM: x86/mmu: Revert "Revert "KVM: MMU: zap pages in batch""
>   KVM: x86/mmu: Revert "Revert "KVM: MMU: collapse TLB flushes when zap
>     all pages""
>   KVM: x86/mmu: Revert "Revert "KVM: MMU: reclaim the zapped-obsolete
>     page first""
>   KVM: x86/mmu: Revert "KVM: x86/mmu: Remove is_obsolete() call"
>   KVM: x86/mmu: Explicitly track only a single invalid mmu generation
>   KVM: x86/mmu: Skip invalid pages during zapping iff root_count is zero
> 
>  arch/x86/include/asm/kvm_host.h |   4 +-
>  arch/x86/kvm/mmu.c              | 154 ++++++++++++++++++++++++++++----
>  arch/x86/kvm/mmutrace.h         |  42 +++++++--
>  arch/x86/kvm/x86.c              |   1 +
>  4 files changed, 173 insertions(+), 28 deletions(-)
> 

Thanks, I'm testing patch 1 and should send a pull request to Linus
tomorrow morning as soon as I get the results.

Paolo

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33A3414212
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 08:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhIVGoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 02:44:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232834AbhIVGoG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 02:44:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632292956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WYW/P0Q1oqTDlsP5noOn+TZGFQp14YjumKQL9bn9bmM=;
        b=OwDlj4XQQpZT4OsqQaH31/flFA59cMPL27LqTTDDH7+e3S6KXkHQkCB1/NpJTOXokjOvJc
        kcWkh4xmATgF6Hm6EAO9v7SyeI8C/fzLdH8EywdpI339GOnUzdJ9cNVw+Phso+FKXikfnr
        Yuq8eq/NQ7Yxhdn1JzoPP1zcqQxlt6k=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-yg-USikqMvGHavswAWduXg-1; Wed, 22 Sep 2021 02:42:35 -0400
X-MC-Unique: yg-USikqMvGHavswAWduXg-1
Received: by mail-ed1-f70.google.com with SMTP id r7-20020aa7c147000000b003d1f18329dcso1830313edp.13
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 23:42:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WYW/P0Q1oqTDlsP5noOn+TZGFQp14YjumKQL9bn9bmM=;
        b=uXmVtMDJeuKnLQAy7U5bcjRePuu7E9iFA/DUSzHe5NTIWsMGz1jrprRBJDAeFV7eXy
         TTAA7KhteGyfju2pCmiMLJiTjJggV9rpufoVf2TMp5dEjzYz6eoN6ETbV2AY2iB+JKY3
         JNt4ICEd+2MJfBhTh3Mb/FVstkRlPUmUv5xhSGW9UL/bD5uOEbh5N29DDiWESr36nuSi
         0JE6AzT4UFi/RlNPnlrM5sXAG3+hbWWwtzVurXKDKaNNfdo2NJ71IZE4bzdV32eGcLq9
         07VpsTa4hSEVdNxvmY/ljAqWMO4wFE5aTwFx2gv37fZyzgGsKo7cN1j/HW/y/SAr7aYr
         N9rw==
X-Gm-Message-State: AOAM532zVk69xbBKYaYbkpsAtviXFl8eTcAqNwR3VDESGo3LMD0unQ6b
        po7EGe8qXHHXOPfIgVLXP2VnKkTh3CPgH+K9yxHh9STCiaJ3d6IYpS5YnOj+9x2tl99cdNAnprK
        /CiKXdxXkh4GO
X-Received: by 2002:a17:906:369a:: with SMTP id a26mr39372079ejc.539.1632292954036;
        Tue, 21 Sep 2021 23:42:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkdDvJZEuqy4z2jeakskcrSYfL6dBq85KTjMRgyfnCoMn+hPyF2F91qCQRXVCbzc6p2Cz+kg==
X-Received: by 2002:a17:906:369a:: with SMTP id a26mr39372025ejc.539.1632292953733;
        Tue, 21 Sep 2021 23:42:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dh16sm622370edb.63.2021.09.21.23.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 23:42:33 -0700 (PDT)
Subject: Re: [PATCH v3 00/16] perf: KVM: Fix, optimize, and clean up callbacks
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-csky@vger.kernel.org,
        linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
References: <20210922000533.713300-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <edecd594-fb34-f4c9-964d-75ae16eadff6@redhat.com>
Date:   Wed, 22 Sep 2021 08:42:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922000533.713300-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/21 02:05, Sean Christopherson wrote:
> Peter, I left the Intel PT mess as-is.  Having to pass a NULL pointer
> from KVM arm64 seemed to be a lesser evil than more exports and multiple
> registration paths.
> 
> This is a combination of ~2 series to fix bugs in the perf+KVM callbacks,
> optimize the callbacks by employing static_call, and do a variety of
> cleanup in both perf and KVM.
> 
> Patch 1 fixes a mostly-theoretical bug where perf can deref a NULL
> pointer if KVM unregisters its callbacks while they're being accessed.
> In practice, compilers tend to avoid problematic reloads of the pointer
> and the PMI handler doesn't lose the race against module unloading,
> i.e doesn't hit a use-after-free.
> 
> Patches 2 and 3 fix an Intel PT handling bug where KVM incorrectly
> eats PT interrupts when PT is supposed to be owned entirely by the host.
> 
> Patches 4-9 clean up perf's callback infrastructure and switch to
> static_call for arm64 and x86 (the only survivors).
> 
> Patches 10-16 clean up related KVM code and unify the arm64/x86 callbacks.
> 
> Based on "git://git.kernel.org/pub/scm/virt/kvm/kvm.git queue", commit
> 680c7e3be6a3 ("KVM: x86: Exit to userspace ...").

Looks nice apart from a couple nits, I will gladly accept a topic branch 
with both the perf and the KVM parts.

Thanks,

Paolo

> v3:
>    - Add wrappers for guest callbacks to that stubs can be provided when
>      GUEST_PERF_EVENTS=n.
>    - s/HAVE_GUEST_PERF_EVENTS/GUEST_PERF_EVENTS and select it from KVM
>      and XEN_PV instead of from top-level arm64/x86. [Paolo]
>    - Drop an unnecessary synchronize_rcu() when registering callbacks. [Peter]
>    - Retain a WARN_ON_ONCE() when unregistering callbacks if the caller
>      didn't provide the correct pointer. [Peter]
>    - Rework the static_call patch to move it all to common perf.
>    - Add a patch to drop the (un)register stubs, made possible after
>      having KVM+XEN_PV select GUEST_PERF_EVENTS.
>    - Split dropping guest callback "support" for arm, csky, etc... to a
>      separate patch, to make introducing GUEST_PERF_EVENTS cleaner.
>    
> v2 (relative to static_call v10):
>    - Split the patch into the semantic change (multiplexed ->state) and
>      introduction of static_call.
>    - Don't use '0' for "not a guest RIP".
>    - Handle unregister path.
>    - Drop changes for architectures that can be culled entirely.
> 
> v2 (relative to v1):
>    - https://lkml.kernel.org/r/20210828003558.713983-6-seanjc@google.com
>    - Drop per-cpu approach. [Peter]
>    - Fix mostly-theoretical reload and use-after-free with READ_ONCE(),
>      WRITE_ONCE(), and synchronize_rcu(). [Peter]
>    - Avoid new exports like the plague. [Peter]
> 
> v1:
>    - https://lkml.kernel.org/r/20210827005718.585190-1-seanjc@google.com
> 
> v10 static_call:
>    - https://lkml.kernel.org/r/20210806133802.3528-2-lingshan.zhu@intel.com
> 
> 
> Like Xu (1):
>    perf/core: Rework guest callbacks to prepare for static_call support
> 
> Sean Christopherson (15):
>    perf: Ensure perf_guest_cbs aren't reloaded between !NULL check and
>      deref
>    KVM: x86: Register perf callbacks after calling vendor's
>      hardware_setup()
>    KVM: x86: Register Processor Trace interrupt hook iff PT enabled in
>      guest
>    perf: Stop pretending that perf can handle multiple guest callbacks
>    perf: Drop dead and useless guest "support" from arm, csky, nds32 and
>      riscv
>    perf: Add wrappers for invoking guest callbacks
>    perf: Force architectures to opt-in to guest callbacks
>    perf/core: Use static_call to optimize perf_guest_info_callbacks
>    KVM: x86: Drop current_vcpu for kvm_running_vcpu + kvm_arch_vcpu
>      variable
>    KVM: x86: More precisely identify NMI from guest when handling PMI
>    KVM: Move x86's perf guest info callbacks to generic KVM
>    KVM: x86: Move Intel Processor Trace interrupt handler to vmx.c
>    KVM: arm64: Convert to the generic perf callbacks
>    KVM: arm64: Drop perf.c and fold its tiny bits of code into arm.c /
>      pmu.c
>    perf: Drop guest callback (un)register stubs
> 
>   arch/arm/kernel/perf_callchain.c   | 28 ++------------
>   arch/arm64/include/asm/kvm_host.h  |  9 ++++-
>   arch/arm64/kernel/perf_callchain.c | 13 ++++---
>   arch/arm64/kvm/Kconfig             |  1 +
>   arch/arm64/kvm/Makefile            |  2 +-
>   arch/arm64/kvm/arm.c               | 11 +++++-
>   arch/arm64/kvm/perf.c              | 62 ------------------------------
>   arch/arm64/kvm/pmu.c               |  8 ++++
>   arch/csky/kernel/perf_callchain.c  | 10 -----
>   arch/nds32/kernel/perf_event_cpu.c | 29 ++------------
>   arch/riscv/kernel/perf_callchain.c | 10 -----
>   arch/x86/events/core.c             | 13 ++++---
>   arch/x86/events/intel/core.c       |  5 +--
>   arch/x86/include/asm/kvm_host.h    |  7 +++-
>   arch/x86/kvm/Kconfig               |  1 +
>   arch/x86/kvm/pmu.c                 |  2 +-
>   arch/x86/kvm/svm/svm.c             |  2 +-
>   arch/x86/kvm/vmx/vmx.c             | 25 +++++++++++-
>   arch/x86/kvm/x86.c                 | 58 +++++-----------------------
>   arch/x86/kvm/x86.h                 | 17 ++++++--
>   arch/x86/xen/Kconfig               |  1 +
>   arch/x86/xen/pmu.c                 | 32 +++++++--------
>   include/kvm/arm_pmu.h              |  1 +
>   include/linux/kvm_host.h           | 10 +++++
>   include/linux/perf_event.h         | 41 ++++++++++++++------
>   init/Kconfig                       |  4 ++
>   kernel/events/core.c               | 39 +++++++++++++------
>   virt/kvm/kvm_main.c                | 44 +++++++++++++++++++++
>   28 files changed, 235 insertions(+), 250 deletions(-)
>   delete mode 100644 arch/arm64/kvm/perf.c
> 


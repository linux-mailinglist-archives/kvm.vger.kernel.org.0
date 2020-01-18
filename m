Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C583614194A
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 21:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgARUBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 15:01:11 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31620 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726674AbgARUBK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 18 Jan 2020 15:01:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579377668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GhV5VFuQrQc9r/3XEQ6PGMYgwgxMdO2z2+l/Tu57i24=;
        b=Mnj2VjfmL7la61UlLl2iUJ5X6QCFoUmWD07K62sGrCEuBQC9nJWLm4PmUU5tzBteojtDrT
        +RdBhW/wg3xDmB+Vqbh4L6k/wFYBnegQn3vrs7rBdSeYaxALVkjja+aBvb2Cn7IUcq4N2w
        teIxmvOdVlmYIqA1Tv1Y8RQnYNwEsO8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-fXKGCD-ePx-hnfy8FbUr6Q-1; Sat, 18 Jan 2020 15:01:07 -0500
X-MC-Unique: fXKGCD-ePx-hnfy8FbUr6Q-1
Received: by mail-wr1-f71.google.com with SMTP id 90so11991829wrq.6
        for <kvm@vger.kernel.org>; Sat, 18 Jan 2020 12:01:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GhV5VFuQrQc9r/3XEQ6PGMYgwgxMdO2z2+l/Tu57i24=;
        b=eBcDctPW6PB96u3hTIt+6+myRTl8Ir1zBXLwy5ioeuIesJFJgK1qs5LjkkfkB32yLo
         ZOr16PNtiT3fvrxlT2GDHhUKNCmaFMqrs32l0XNY7MATfKd/6MDZFPtG7dkdi0nOns0d
         542O+Np2svMCCZcUVdpZSy61FWDk6PUn0YEzWHmcvAgpypoHWAYpUHk8Jx2JYdff5iG0
         Wrh3jHtRBv0wSpvkGaN9odvZ6/etEdsrlo44sW2KZclSeIhhhLJyUxnrNyu32E9RL+Ac
         /tCl2E3II/TaIgjEmomLXDWKmixd4VwdW68sM33/2ehzltcrkm9eWwfTMAOaDj5R4vaI
         U7sQ==
X-Gm-Message-State: APjAAAX7jWbS65w40aLqDIvLc/4dTXJT7SS7bYDb/NfmpQ9QI2JbdcCj
        fQysi4M0lImoqafLlZF9HNFXn+FfftI+0rJBxYSnVZp2RernyrYuohlRntnwExLNjs5UN4ey/Wu
        nV3zc/m1/u+35
X-Received: by 2002:adf:b60f:: with SMTP id f15mr10168439wre.372.1579377666357;
        Sat, 18 Jan 2020 12:01:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqyiRC3IqnoQxBsM17Oy6gnYbiWwmQOp2vlMdwOkISyap6ZIXyi3L1uJMx7IGcuKnNuVMBYAvQ==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr10168402wre.372.1579377666048;
        Sat, 18 Jan 2020 12:01:06 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v8sm38452671wrw.2.2020.01.18.12.01.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 12:01:05 -0800 (PST)
Subject: Re: [PATCH v2 00/45] KVM: Refactor vCPU creation
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3be0000b-3da9-3321-6e56-7dbb434ba764@redhat.com>
Date:   Sat, 18 Jan 2020 21:01:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191218215530.2280-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued.  Paul, David, please test kvm/next in a couple days.

Paolo

On 18/12/19 22:54, Sean Christopherson wrote:
> The end goal of this series is to strip down the interface between common
> KVM code and arch specific code so that there is precisely one arch hook
> for creating a vCPU and one hook for destroying a vCPU.  In addition to
> cleaning up the code base, simplifying the interface gives architectures
> more freedom to organize their vCPU creation code.  Details below.
> 
> v2:
>   - Rebase to commit e41a90be9659 ("KVM: x86/mmu: WARN if root_hpa is
>     invalid when handling a page fault").  A few minor x86 (VMX) conflicts,
>     and one straightforward arm conflict with commit 8564d6372a7d ("KVM:
>     arm64: Support stolen time reporting via shared structure") in patch
>     "KVM: ARM: Move all vcpu init code into kvm_arch_vcpu_create()".
>   - Collect Reviews and Acks [Christoffer, Greg].
>   - Fix a warning in "KVM: arm64: Free sve_state via arm specific hook"
>     by using a "void" return type [Christoffer].
>   - Fix a bug in "KVM: PPC: Move kvm_vcpu_init() invocation to common code"
>     where the call in kvmppc_core_vcpu_create_e500mc() was inadvertantly
>     left behind.
> 
> 
> KVM's vCPU creation code is comically messy.  kvm_vm_ioctl_create_vcpu()
> calls three separate arch hooks: init(), create() and setup().  The init()
> call is especially nasty as it's hidden away in a common KVM function,
> kvm_init_vcpu(), that for all intents and purposes must be immediately
> invoked after the vcpu object is allocated.
> 
> Not to be outdone, vCPU destruction also has three arch hooks: uninit(),
> destroy() and free(), the latter of which isn't actually invoked by common
> KVM code, but the hook declaration still exists because architectures are
> relying on its forward declaration.
> 
> Eliminating the extra arch hooks is relatively straightforward, just
> tedious.  For the most part, there is no fundamental constraint that
> necessitated the proliferation of arch hooks, rather they crept in over
> time, usually when x86-centric code was moved out of generic KVM and into
> x86 code.
> 
> E.g. kvm_arch_vcpu_setup() was added to allow x86 to do vcpu_load(), which
> can only be done after preempt_notifier initialization, but adding setup()
> overlooked the fact that the preempt_notifier was only initialized after
> kvm_arch_vcpu_create() because preemption support was added when x86's MMU
> setup (the vcpu_load() user) was called from common KVM code.
> 
> For all intents and purposes, there is no true functional change in this
> series.  The order of some allocations will change, and a few memory leaks
> are fixed, but the actual functionality of a guest should be unaffected.
> 
> Patches 01-03 are bug fixes in error handling paths that were found by
> inspection when refactoring the associated code.
> 
> Patches 04-43 refactor each arch implementation so that the unwanted arch
> hooks can be dropped without a functional change, e.g. move code out of
> kvm_arch_vcpu_setup() so that all implementations are empty, then drop the
> functions and caller.
> 
> Patches 44-45 are minor clean up to eliminate kvm_vcpu_uninit().
> 
> The net result is to go from this:
> 
>         vcpu = kvm_arch_vcpu_create(kvm, id);
>                |
>                |-> kvm_vcpu_init()
>                    |
>                    |-> kvm_arch_vcpu_init()
> 
>         if (IS_ERR(vcpu)) {
>                 r = PTR_ERR(vcpu);
>                 goto vcpu_decrement;
>         }
> 
>         preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
> 
>         r = kvm_arch_vcpu_setup(vcpu);
>         if (r)
>                 goto vcpu_destroy;
> 
> 
> Sean Christopherson (45):
>   KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails
>   KVM: PPC: Book3S PR: Free shared page if mmu initialization fails
>   KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails
>   KVM: VMX: Allocate VPID after initializing VCPU
>   KVM: VMX: Use direct vcpu pointer during vCPU create/free
>   KVM: SVM: Use direct vcpu pointer during vCPU create/free
>   KVM: x86: Allocate vcpu struct in common x86 code
>   KVM: x86: Move FPU allocation to common x86 code
>   KVM: x86: Move allocation of pio_data page down a few lines
>   KVM: x86: Move kvm_vcpu_init() invocation to common code
>   KVM: PPC: e500mc: Add build-time assert that vcpu is at offset 0
>   KVM: PPC: Allocate vcpu struct in common PPC code
>   KVM: PPC: Book3S PR: Allocate book3s and shadow vcpu after common init
>   KVM: PPC: e500mc: Move reset of oldpir below call to kvm_vcpu_init()
>   KVM: PPC: Move kvm_vcpu_init() invocation to common code
>   KVM: MIPS: Use kvm_vcpu_cache to allocate vCPUs
>   KVM: MIPS: Drop kvm_arch_vcpu_free()
>   KVM: PPC: Drop kvm_arch_vcpu_free()
>   KVM: arm: Drop kvm_arch_vcpu_free()
>   KVM: x86: Remove spurious kvm_mmu_unload() from vcpu destruction path
>   KVM: x86: Remove spurious clearing of async #PF MSR
>   KVM: x86: Drop kvm_arch_vcpu_free()
>   KVM: Remove kvm_arch_vcpu_free() declaration
>   KVM: Add kvm_arch_vcpu_precreate() to handle pre-allocation issues
>   KVM: s390: Move guts of kvm_arch_vcpu_init() into
>     kvm_arch_vcpu_create()
>   KVM: s390: Invoke kvm_vcpu_init() before allocating sie_page
>   KVM: MIPS: Invoke kvm_vcpu_uninit() immediately prior to freeing vcpu
>   KVM: x86: Invoke kvm_vcpu_uninit() immediately prior to freeing vcpu
>   KVM: Introduce kvm_vcpu_destroy()
>   KVM: Move vcpu alloc and init invocation to common code
>   KVM: Unexport kvm_vcpu_cache and kvm_vcpu_{un}init()
>   KVM: Move initialization of preempt notifier to kvm_vcpu_init()
>   KVM: x86: Move guts of kvm_arch_vcpu_setup() into
>     kvm_arch_vcpu_create()
>   KVM: MIPS: Move .vcpu_setup() call to kvm_arch_vcpu_create()
>   KVM: s390: Manually invoke vcpu setup during kvm_arch_vcpu_create()
>   KVM: PPC: BookE: Setup vcpu during kvmppc_core_vcpu_create()
>   KVM: Drop kvm_arch_vcpu_setup()
>   KVM: x86: Move all vcpu init code into kvm_arch_vcpu_create()
>   KVM: MIPS: Move all vcpu init code into kvm_arch_vcpu_create()
>   KVM: ARM: Move all vcpu init code into kvm_arch_vcpu_create()
>   KVM: PPC: Move all vcpu init code into kvm_arch_vcpu_create()
>   KVM: arm64: Free sve_state via arm specific hook
>   KVM: Drop kvm_arch_vcpu_init() and kvm_arch_vcpu_uninit()
>   KVM: Move putting of vcpu->pid to kvm_vcpu_destroy()
>   KVM: Move vcpu->run page allocation out of kvm_vcpu_init()
> 
>  arch/arm/include/asm/kvm_host.h    |   2 +-
>  arch/arm/kvm/guest.c               |   5 -
>  arch/arm64/include/asm/kvm_host.h  |   2 +-
>  arch/arm64/kvm/guest.c             |   5 -
>  arch/arm64/kvm/reset.c             |   2 +-
>  arch/mips/kvm/mips.c               |  84 ++++-------
>  arch/powerpc/include/asm/kvm_ppc.h |   6 +-
>  arch/powerpc/kvm/book3s.c          |   9 +-
>  arch/powerpc/kvm/book3s_hv.c       |  27 +---
>  arch/powerpc/kvm/book3s_pr.c       |  33 ++---
>  arch/powerpc/kvm/booke.c           |  65 ++++----
>  arch/powerpc/kvm/e500.c            |  34 +----
>  arch/powerpc/kvm/e500mc.c          |  28 +---
>  arch/powerpc/kvm/powerpc.c         |  70 ++++-----
>  arch/s390/include/asm/kvm_host.h   |   1 -
>  arch/s390/kvm/kvm-s390.c           | 110 +++++++-------
>  arch/x86/include/asm/kvm_host.h    |   2 +-
>  arch/x86/kvm/svm.c                 |  52 +------
>  arch/x86/kvm/vmx/vmx.c             |  72 +++------
>  arch/x86/kvm/x86.c                 | 230 ++++++++++++++---------------
>  include/linux/kvm_host.h           |  13 +-
>  virt/kvm/arm/arm.c                 |  80 ++++------
>  virt/kvm/kvm_main.c                |  71 +++++----
>  23 files changed, 385 insertions(+), 618 deletions(-)
> 


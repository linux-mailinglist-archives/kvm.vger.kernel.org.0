Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A7C1A2205
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 14:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgDHM2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 08:28:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:57632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbgDHM2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 08:28:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 66C7CAC44;
        Wed,  8 Apr 2020 12:28:07 +0000 (UTC)
Subject: Re: [RFC PATCH 00/26] Runtime paravirt patching
To:     Ankur Arora <ankur.a.arora@oracle.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, bp@alien8.de,
        vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <d7f8bff3-526a-6a84-2e81-677cfbac0111@suse.com>
Date:   Wed, 8 Apr 2020 14:28:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08.04.20 07:02, Ankur Arora wrote:
> A KVM host (or another hypervisor) might advertise paravirtualized
> features and optimization hints (ex KVM_HINTS_REALTIME) which might
> become stale over the lifetime of the guest. For instance, the

Then this hint is wrong if it can't be guaranteed.

> host might go from being undersubscribed to being oversubscribed
> (or the other way round) and it would make sense for the guest
> switch pv-ops based on that.

I think using pvops for such a feature change is just wrong.

What comes next? Using pvops for being able to migrate a guest from an
Intel to an AMD machine?

...

> There are four main sets of patches in this series:
> 
>   1. PV-ops management (patches 1-10, 20): mostly infrastructure and
>   refactoring pieces to make paravirt patching usable at runtime. For the
>   most part scoped under CONFIG_PARAVIRT_RUNTIME.
> 
>   Patches 1-7, to persist part of parainstructions in memory:
>    "x86/paravirt: Specify subsection in PVOP macros"
>    "x86/paravirt: Allow paravirt patching post-init"
>    "x86/paravirt: PVRTOP macros for PARAVIRT_RUNTIME"
>    "x86/alternatives: Refactor alternatives_smp_module*
>    "x86/alternatives: Rename alternatives_smp*, smp_alt_module
>    "x86/alternatives: Remove stale symbols
>    "x86/paravirt: Persist .parainstructions.runtime"
> 
>   Patches 8-10, develop the inerfaces to safely switch pv-ops:
>    "x86/paravirt: Stash native pv-ops"
>    "x86/paravirt: Add runtime_patch()"
>    "x86/paravirt: Add primitives to stage pv-ops"
> 
>   Patch 20 enables switching of pv_lock_ops:
>    "x86/paravirt: Enable pv-spinlocks in runtime_patch()"
> 
>   2. Non-emulated text poking (patches 11-19)
> 
>   Patches 11-13 are mostly refactoring to split __text_poke() into map,
>   unmap and poke/memcpy phases with the poke portion being re-entrant
>    "x86/alternatives: Remove return value of text_poke*()"
>    "x86/alternatives: Use __get_unlocked_pte() in text_poke()"
>    "x86/alternatives: Split __text_poke()"
> 
>   Patches 15, 17 add the actual poking state-machine:
>    "x86/alternatives: Non-emulated text poking"
>    "x86/alternatives: Add patching logic in text_poke_site()"
> 
>   with patches 14 and 18 containing the pieces for BP handling:
>    "x86/alternatives: Handle native insns in text_poke_loc*()"
>    "x86/alternatives: Handle BP in non-emulated text poking"
> 
>   and patch 19 provides the ability to use the state-machine above in an
>   NMI context (fixes some potential deadlocks when handling inter-
>   dependent operations and multiple NMIs):
>    "x86/alternatives: NMI safe runtime patching".
> 
>   Patch 16 provides the interface (paravirt_runtime_patch()) to use the
>   poking mechanism developed above and patch 21 adds a selftest:
>    "x86/alternatives: Add paravirt patching at runtime"
>    "x86/alternatives: Paravirt runtime selftest"
> 
>   3. KVM guest changes to be able to use this (patches 22-23,25-26):
>    "kvm/paravirt: Encapsulate KVM pv switching logic"
>    "x86/kvm: Add worker to trigger runtime patching"
>    "x86/kvm: Guest support for dynamic hints"
>    "x86/kvm: Add hint change notifier for KVM_HINT_REALTIME".
> 
>   4. KVM host changes to notify the guest of a change (patch 24):
>    "x86/kvm: Support dynamic CPUID hints"
> 
> Testing:
> With paravirt patching, the code is mostly stable on Intel and AMD
> systems under kernbench and locktorture with paravirt toggling (with,
> without synthetic NMIs) in the background.
> 
> Queued spinlock performance for locktorture is also on expected lines:
>   [ 1533.221563] Writes:  Total: 1048759000  Max/Min: 0/0   Fail: 0
>   # toggle PV spinlocks
> 
>   [ 1594.713699] Writes:  Total: 1111660545  Max/Min: 0/0   Fail: 0
>   # PV spinlocks (in ~60 seconds) = 62,901,545
> 
>   # toggle native spinlocks
>   [ 1656.117175] Writes:  Total: 1113888840  Max/Min: 0/0   Fail: 0
>    # native spinlocks (in ~60 seconds) = 2,228,295
> 
> The alternatives testing is more limited with it being used to rewrite
> mostly harmless X86_FEATUREs with load in the background.
> 
> Patches also at:
> 
> ssh://git@github.com/terminus/linux.git alternatives-rfc-upstream-v1
> 
> Please review.
> 
> Thanks
> Ankur
> 
> [1] The precise change in memory footprint depends on config options
> but the following example inlines queued_spin_unlock() (which forms
> the bulk of the added state). The added footprint is the size of the
> .parainstructions.runtime section:
> 
>   $ objdump -h vmlinux|grep .parainstructions
>   Idx Name              		Size      VMA
>   	LMA                File-off  Algn
>    27 .parainstructions 		0001013c  ffffffff82895000
>    	0000000002895000   01c95000  2**3
>    28 .parainstructions.runtime  0000cd2c  ffffffff828a5140
>    	00000000028a5140   01ca5140  2**3
> 
>    $ size vmlinux
>    text       data       bss        dec      hex       filename
>    13726196   12302814   14094336   40123346 2643bd2   vmlinux
> 
> Ankur Arora (26):
>    x86/paravirt: Specify subsection in PVOP macros
>    x86/paravirt: Allow paravirt patching post-init
>    x86/paravirt: PVRTOP macros for PARAVIRT_RUNTIME
>    x86/alternatives: Refactor alternatives_smp_module*
>    x86/alternatives: Rename alternatives_smp*, smp_alt_module
>    x86/alternatives: Remove stale symbols
>    x86/paravirt: Persist .parainstructions.runtime
>    x86/paravirt: Stash native pv-ops
>    x86/paravirt: Add runtime_patch()
>    x86/paravirt: Add primitives to stage pv-ops
>    x86/alternatives: Remove return value of text_poke*()
>    x86/alternatives: Use __get_unlocked_pte() in text_poke()
>    x86/alternatives: Split __text_poke()
>    x86/alternatives: Handle native insns in text_poke_loc*()
>    x86/alternatives: Non-emulated text poking
>    x86/alternatives: Add paravirt patching at runtime
>    x86/alternatives: Add patching logic in text_poke_site()
>    x86/alternatives: Handle BP in non-emulated text poking
>    x86/alternatives: NMI safe runtime patching
>    x86/paravirt: Enable pv-spinlocks in runtime_patch()
>    x86/alternatives: Paravirt runtime selftest
>    kvm/paravirt: Encapsulate KVM pv switching logic
>    x86/kvm: Add worker to trigger runtime patching
>    x86/kvm: Support dynamic CPUID hints
>    x86/kvm: Guest support for dynamic hints
>    x86/kvm: Add hint change notifier for KVM_HINT_REALTIME
> 
>   Documentation/virt/kvm/api.rst        |  17 +
>   Documentation/virt/kvm/cpuid.rst      |   9 +-
>   arch/x86/Kconfig                      |  14 +
>   arch/x86/Kconfig.debug                |  13 +
>   arch/x86/entry/entry_64.S             |   5 +
>   arch/x86/include/asm/alternative.h    |  20 +-
>   arch/x86/include/asm/kvm_host.h       |   6 +
>   arch/x86/include/asm/kvm_para.h       |  17 +
>   arch/x86/include/asm/paravirt.h       |  10 +-
>   arch/x86/include/asm/paravirt_types.h | 230 ++++--
>   arch/x86/include/asm/text-patching.h  |  18 +-
>   arch/x86/include/uapi/asm/kvm_para.h  |   2 +
>   arch/x86/kernel/Makefile              |   1 +
>   arch/x86/kernel/alternative.c         | 987 +++++++++++++++++++++++---
>   arch/x86/kernel/kvm.c                 | 191 ++++-
>   arch/x86/kernel/module.c              |  42 +-
>   arch/x86/kernel/paravirt.c            |  16 +-
>   arch/x86/kernel/paravirt_patch.c      |  61 ++
>   arch/x86/kernel/pv_selftest.c         | 264 +++++++
>   arch/x86/kernel/pv_selftest.h         |  15 +
>   arch/x86/kernel/setup.c               |   2 +
>   arch/x86/kernel/vmlinux.lds.S         |  16 +
>   arch/x86/kvm/cpuid.c                  |   3 +-
>   arch/x86/kvm/x86.c                    |  39 +
>   include/asm-generic/kvm_para.h        |  12 +
>   include/asm-generic/vmlinux.lds.h     |   8 +
>   include/linux/kvm_para.h              |   5 +
>   include/linux/mm.h                    |  16 +-
>   include/linux/preempt.h               |  17 +
>   include/uapi/linux/kvm.h              |   4 +
>   kernel/locking/lock_events.c          |   2 +-
>   mm/memory.c                           |   9 +-
>   32 files changed, 1850 insertions(+), 221 deletions(-)
>   create mode 100644 arch/x86/kernel/pv_selftest.c
>   create mode 100644 arch/x86/kernel/pv_selftest.h
> 

Quite a lot of code churn and hacks for a problem which should not
occur on a well administrated machine.

Especially the NMI dependencies make me not wanting to Ack this series.


Juergen

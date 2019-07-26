Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3546375FD5
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 09:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfGZH2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 03:28:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:46750 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725864AbfGZH2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 03:28:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 18647AF47;
        Fri, 26 Jul 2019 07:28:23 +0000 (UTC)
Subject: Re: [PATCH v3 4/9] x86/mm/tlb: Flush remote and local TLBs
 concurrently
To:     Nadav Amit <namit@vmware.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190719005837.4150-1-namit@vmware.com>
 <20190719005837.4150-5-namit@vmware.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <3fc06d95-5f17-4642-cd91-49a0f70057c0@suse.com>
Date:   Fri, 26 Jul 2019 09:28:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190719005837.4150-5-namit@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.07.19 02:58, Nadav Amit wrote:
> To improve TLB shootdown performance, flush the remote and local TLBs
> concurrently. Introduce flush_tlb_multi() that does so. Introduce
> paravirtual versions of flush_tlb_multi() for KVM, Xen and hyper-v (Xen
> and hyper-v are only compile-tested).
> 
> While the updated smp infrastructure is capable of running a function on
> a single local core, it is not optimized for this case. The multiple
> function calls and the indirect branch introduce some overhead, and
> might make local TLB flushes slower than they were before the recent
> changes.
> 
> Before calling the SMP infrastructure, check if only a local TLB flush
> is needed to restore the lost performance in this common case. This
> requires to check mm_cpumask() one more time, but unless this mask is
> updated very frequently, this should impact performance negatively.
> 
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: x86@kernel.org
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: linux-hyperv@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: kvm@vger.kernel.org
> Cc: xen-devel@lists.xenproject.org
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>   arch/x86/hyperv/mmu.c                 | 10 +++---
>   arch/x86/include/asm/paravirt.h       |  6 ++--
>   arch/x86/include/asm/paravirt_types.h |  4 +--
>   arch/x86/include/asm/tlbflush.h       |  8 ++---
>   arch/x86/include/asm/trace/hyperv.h   |  2 +-
>   arch/x86/kernel/kvm.c                 | 11 +++++--
>   arch/x86/kernel/paravirt.c            |  2 +-
>   arch/x86/mm/tlb.c                     | 47 ++++++++++++++++++---------
>   arch/x86/xen/mmu_pv.c                 | 11 +++----
>   include/trace/events/xen.h            |  2 +-
>   10 files changed, 62 insertions(+), 41 deletions(-)

Xen and paravirt parts: Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen

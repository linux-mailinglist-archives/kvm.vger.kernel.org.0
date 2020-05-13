Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BFD1D174E
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 16:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388913AbgEMOQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 10:16:53 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59430 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388895AbgEMOQw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 10:16:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589379411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PS89PFbaJnSwYMjQXVxl9VtXtII/zrxWxjZd/P8u9aY=;
        b=DOvMOj98ZbC2sCGQ9Zi9T2bB4pHDeJAiW5S7b3TgNGcb0q7qaK+h2Hzs5Bz8vD09M2LdCu
        RJYItkzQ+X89q/pnGMBklYd1Z3hAFEcUipwZIREl5MbJw3Fe+kyLF4tNX3Fc+zkkoc/dMq
        2wOJ/MDGBLVjBr+xvk/sbTSR+D26v7Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-tMocgKD2Pe24Zd0c9o7nZg-1; Wed, 13 May 2020 10:16:47 -0400
X-MC-Unique: tMocgKD2Pe24Zd0c9o7nZg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A84451005510;
        Wed, 13 May 2020 14:16:45 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-240.rdu2.redhat.com [10.10.115.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23AFE5D9C5;
        Wed, 13 May 2020 14:16:45 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id A1D74220206; Wed, 13 May 2020 10:16:44 -0400 (EDT)
Date:   Wed, 13 May 2020 10:16:44 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] KVM: x86: Interrupt-based mechanism for async_pf
 'page present' notifications
Message-ID: <20200513141644.GD173965@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511164752.2158645-1-vkuznets@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 11, 2020 at 06:47:44PM +0200, Vitaly Kuznetsov wrote:
> Concerns were expressed around (ab)using #PF for KVM's async_pf mechanism,
> it seems that re-using #PF exception for a PV mechanism wasn't a great
> idea after all. The Grand Plan is to switch to using e.g. #VE for 'page
> not present' events and normal APIC interrupts for 'page ready' events.
> This series does the later.

Hi Vitaly,

How does any of this impact nested virtualization code (if any).

I have tried understanding that logic, but I have to admit, I could
never get it.

arch/x86/kvm/mmu/mmu.c

int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
                                u64 fault_address, char *insn, int insn_len)
{
        switch (vcpu->arch.apf.host_apf_reason) {
		case KVM_PV_REASON_PAGE_NOT_PRESENT:
			kvm_async_pf_task_wait(fault_address, 0);
		case KVM_PV_REASON_PAGE_READY:
			kvm_async_pf_task_wake(fault_address);
	}
}

Vivek

> 
> Changes since RFC:
> - Using #PF for 'page ready' is deprecated and removed [Paolo Bonzini]
> - 'reason' field in 'struct kvm_vcpu_pv_apf_data' is not used for 'page ready'
>   notifications and 'pageready_token' is not used for 'page not present' events
>   [Paolo Bonzini]
> - Renamed MSR_KVM_ASYNC_PF2 -> MSR_KVM_ASYNC_PF_INT [Peter Xu]
> - Drop 'enabled' field from MSR_KVM_ASYNC_PF_INT [Peter Xu]
> - Other minor changes supporting the above.
> 
> Vitaly Kuznetsov (8):
>   Revert "KVM: async_pf: Fix #DF due to inject "Page not Present" and
>     "Page Ready" exceptions simultaneously"
>   KVM: x86: extend struct kvm_vcpu_pv_apf_data with token info
>   KVM: introduce kvm_read_guest_offset_cached()
>   KVM: x86: interrupt based APF page-ready event delivery
>   KVM: x86: acknowledgment mechanism for async pf page ready
>     notifications
>   KVM: x86: announce KVM_FEATURE_ASYNC_PF_INT
>   KVM: x86: Switch KVM guest to using interrupts for page ready APF
>     delivery
>   KVM: x86: drop KVM_PV_REASON_PAGE_READY case from
>     kvm_handle_page_fault()
> 
>  Documentation/virt/kvm/cpuid.rst     |   6 ++
>  Documentation/virt/kvm/msr.rst       | 106 ++++++++++++++------
>  arch/s390/include/asm/kvm_host.h     |   2 +
>  arch/x86/entry/entry_32.S            |   5 +
>  arch/x86/entry/entry_64.S            |   5 +
>  arch/x86/include/asm/hardirq.h       |   3 +
>  arch/x86/include/asm/irq_vectors.h   |   6 +-
>  arch/x86/include/asm/kvm_host.h      |   7 +-
>  arch/x86/include/asm/kvm_para.h      |   6 ++
>  arch/x86/include/uapi/asm/kvm_para.h |  11 ++-
>  arch/x86/kernel/irq.c                |   9 ++
>  arch/x86/kernel/kvm.c                |  42 ++++++--
>  arch/x86/kvm/cpuid.c                 |   3 +-
>  arch/x86/kvm/mmu/mmu.c               |  10 +-
>  arch/x86/kvm/x86.c                   | 142 ++++++++++++++++++---------
>  include/linux/kvm_host.h             |   3 +
>  include/uapi/linux/kvm.h             |   1 +
>  virt/kvm/async_pf.c                  |  10 ++
>  virt/kvm/kvm_main.c                  |  19 +++-
>  19 files changed, 295 insertions(+), 101 deletions(-)
> 
> -- 
> 2.25.4
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5201CF934
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 17:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730675AbgELPcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 11:32:19 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52262 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726388AbgELPcS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 11:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589297536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3znfxGl3Y8dtZtdYEiFhfu/pKUx/1DihfE1tclQt+xI=;
        b=ecYA9Iugrm7rlvHrBbr/SEOjUkAI+YPDW5MqUTslSmRBb7goFc7M2ocxIqp8E5To8eHCMZ
        H8xZNkt7IuL4sNdsK44WPbiqghpowLstCkx0IDZwilCl4vjw2sUO3K9OQVhj1hBUC317hn
        p2KpK2n92jVWDCHG7J/qS5LTdnWJ3S8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-_q3gu77AM26zTzK1ED8dgQ-1; Tue, 12 May 2020 11:32:13 -0400
X-MC-Unique: _q3gu77AM26zTzK1ED8dgQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E5B419200C0;
        Tue, 12 May 2020 15:32:11 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-85.rdu2.redhat.com [10.10.116.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E5FE6E9E0;
        Tue, 12 May 2020 15:32:10 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id AE9CE220C05; Tue, 12 May 2020 11:32:09 -0400 (EDT)
Date:   Tue, 12 May 2020 11:32:09 -0400
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
Message-ID: <20200512153209.GC138129@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511164752.2158645-1-vkuznets@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

Are there any corresponding qemu patches as well to enable new
functionality. Wanted to test it.

Thanks
Vivek

On Mon, May 11, 2020 at 06:47:44PM +0200, Vitaly Kuznetsov wrote:
> Concerns were expressed around (ab)using #PF for KVM's async_pf mechanism,
> it seems that re-using #PF exception for a PV mechanism wasn't a great
> idea after all. The Grand Plan is to switch to using e.g. #VE for 'page
> not present' events and normal APIC interrupts for 'page ready' events.
> This series does the later.
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


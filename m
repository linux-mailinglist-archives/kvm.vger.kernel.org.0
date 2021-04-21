Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C4B366FC8
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 18:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241636AbhDUQRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 12:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240787AbhDUQRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 12:17:13 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3AEC06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 09:16:40 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c3so10522133pfo.3
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 09:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6YAaioJLT+SHwsUFt7vAixpepx1vJZRRO+UjgC4Tkys=;
        b=aGKkzZV3ocJ1HLPskvjsf5S/rCab5V3wLhFtozZDHdlMv64QewtqYFSzNlbHHnYrnZ
         6YqKZ6G9rpO4ktkuFqoDBYQZMgfVwmgWpimuU/IO/A24pEgNHgfsooY9YqzqJN/85+MV
         uAK8OglJf+gAQGytsmT8OlaMwuSekVScx6st5+LL+9f4g1aWZ1XGMbSWn9F4oVwVN1du
         o/SDqklCl7pj5mV7GDUWx6xAR6oweYBfgHXjYRoVcAb4zsmrsON+3OXpPqxrNUs0nBPM
         0UFha+JJIxQbgHrmUqGIzIS2ZruQSnTZ7ADIxne0GMJRJtocYm2g7aiYnApi3C6vk05H
         kuBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6YAaioJLT+SHwsUFt7vAixpepx1vJZRRO+UjgC4Tkys=;
        b=HbvTScU8hFjgywm7FxoqHlX9Wh29+LZPqQkS9lL0wKiBboOLsZ7nPgFLArDsthBL1A
         dPumhbMU2J6Lq9kjkhQ7p3q8nnuV5CPB4SUQJx1FUMVIw059SR1DMPOO1ekKITgTWCNx
         sryzWXjspBPPZuQRsuEtswjeIvreyJwqm96n1aAfItSk5CokAvJAY73qAMY8a40Idf56
         tJw4pmQsLMStOJOYgZWTfJEQ2DyqtgigMEVNhJfedYhTp90rcwmtKTrfsC0CmJFs3NmL
         ON7kCX/9EvGiXk/zi67jUWaAslbvF+NABJJMbd4BKrz0HSm0d/6/mazHpF6sHqQe7B/j
         VnEg==
X-Gm-Message-State: AOAM532xQw9LJsnO3GmTasPSf2+h0vfWO/SzJrcU4VU8rdBM7fG2gxJo
        I0D6ME1GeEOShoEaVTFFLf2YRw==
X-Google-Smtp-Source: ABdhPJw46wH9qX8gafeiiekQUVV3KuYQm9n5pnGiavRQ2uhMY/W7EalG7qd2UN7+8OogubznJyicbA==
X-Received: by 2002:a65:584e:: with SMTP id s14mr22007280pgr.229.1619021799667;
        Wed, 21 Apr 2021 09:16:39 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id n85sm2196283pfd.170.2021.04.21.09.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 09:16:38 -0700 (PDT)
Date:   Wed, 21 Apr 2021 16:16:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pl@sslab.ics.keio.ac.jp,
        kono@sslab.ics.keio.ac.jp
Subject: Re: [RFC PATCH 2/2] Boost vCPUs based on IPI-sender and receiver
 information
Message-ID: <YIBP47T8yvOcg0SN@google.com>
References: <20210421150831.60133-1-kentaishiguro@sslab.ics.keio.ac.jp>
 <20210421150831.60133-3-kentaishiguro@sslab.ics.keio.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421150831.60133-3-kentaishiguro@sslab.ics.keio.ac.jp>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021, Kenta Ishiguro wrote:
> This commit monitors IPI communication between vCPUs and leverages the
> relationship between vCPUs to select boost candidates.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
> ---
>  arch/x86/kvm/lapic.c     | 14 ++++++++++++++
>  arch/x86/kvm/vmx/vmx.c   |  2 ++
>  include/linux/kvm_host.h |  5 +++++
>  virt/kvm/kvm_main.c      | 26 ++++++++++++++++++++++++--
>  4 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index cc369b9ad8f1..c8d967ddecf9 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1269,6 +1269,18 @@ void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
>  }
>  EXPORT_SYMBOL_GPL(kvm_apic_set_eoi_accelerated);
>  
> +static void mark_ipi_receiver(struct kvm_lapic *apic, struct kvm_lapic_irq *irq)
> +{
> +	struct kvm_vcpu *dest_vcpu;
> +	u64 prev_ipi_received;
> +
> +	dest_vcpu = kvm_get_vcpu_by_id(apic->vcpu->kvm, irq->dest_id);
> +	if (READ_ONCE(dest_vcpu->sched_outed)) {

dest_vcpu needs to be checked for NULL.

> +		prev_ipi_received = READ_ONCE(dest_vcpu->ipi_received);
> +		WRITE_ONCE(dest_vcpu->ipi_received, prev_ipi_received | (1 << apic->vcpu->vcpu_id));
> +	}
> +}
> +
>  void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
>  {
>  	struct kvm_lapic_irq irq;
> @@ -1287,6 +1299,8 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
>  
>  	trace_kvm_apic_ipi(icr_low, irq.dest_id);
>  
> +	mark_ipi_receiver(apic, &irq);
> +
>  	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq, NULL);
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 29b40e092d13..ced50935a38b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6718,6 +6718,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  		vmcs_write32(PLE_WINDOW, vmx->ple_window);
>  	}
>  
> +	WRITE_ONCE(vcpu->ipi_received, 0);

Given that ipi_received is cleared when the vCPU is run, is there actually an
observable advantage to tracking which vCPU sent the IPI?  I.e. how do the
numbers look if ipi_received is a simple bool, and kvm_vcpu_on_spin() yields to
any vCPU that has an IPI pending?

>  	/*
>  	 * We did this in prepare_switch_to_guest, because it needs to
>  	 * be within srcu_read_lock.

...

> @@ -4873,6 +4894,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
>  		WRITE_ONCE(vcpu->preempted, true);
>  		WRITE_ONCE(vcpu->ready, true);
>  	}
> +	WRITE_ONCE(vcpu->sched_outed, true);

s/sched_outed/scheduled_out to be more grammatically correct.

It might also make sense to introduce the flag in a separate path.  Or even
better, can the existing "preempted" and "ready" be massaged so that we don't
have three flags that are tracking the same basic thing, with slightly different
semantics?

>  	kvm_arch_vcpu_put(vcpu);
>  	__this_cpu_write(kvm_running_vcpu, NULL);
>  }
> -- 
> 2.30.2
> 

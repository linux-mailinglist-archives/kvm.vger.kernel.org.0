Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20AC40024D
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 17:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349691AbhICP3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 11:29:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235536AbhICP3a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 11:29:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630682910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pZkDhvwFytLIQ3GqCYeXEIXo1n/CTQnLIJFcfLYdv6Y=;
        b=SLJs9RyXI/uNhVcMoFI72ce2KQpGDHFyLz6KWDCjyx/sffJBDtjjV9MCjhpDQ/Tpm/TSjU
        705vpGwVMeAPaqhcnE6L0MGp6ftkoCsE3GP7mfxUrmAwMYdfiDstDoI78H+QBj3Yub+Fl1
        quOqUTNqu0QT2cnY/B4765T7g+Y/V7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-m7YFGk6JNdeaXCKC--F62w-1; Fri, 03 Sep 2021 11:28:29 -0400
X-MC-Unique: m7YFGk6JNdeaXCKC--F62w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9C28C7442;
        Fri,  3 Sep 2021 15:28:27 +0000 (UTC)
Received: from localhost (unknown [10.22.8.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 999E360861;
        Fri,  3 Sep 2021 15:28:27 +0000 (UTC)
Date:   Fri, 3 Sep 2021 11:28:26 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/6] x86/kvm: fix vcpu-id indexed array sizes
Message-ID: <20210903152826.75rbaedvlud3potn@habkost.net>
References: <20210701154105.23215-1-jgross@suse.com>
 <20210701154105.23215-2-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210701154105.23215-2-jgross@suse.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 01, 2021 at 05:41:00PM +0200, Juergen Gross wrote:
> KVM_MAX_VCPU_ID is the maximum vcpu-id of a guest, and not the number
> of vcpu-ids. Fix array indexed by vcpu-id to have KVM_MAX_VCPU_ID+1
> elements.

I don't think that's true.  kvm_vm_ioctl_create_vcpu() refuses to
create a VCPU with id==KVM_MAX_VCPU_ID.
Documentation/virt/kvm/api.rst also states that
"The vcpu id is an integer in the range [0, max_vcpu_id)."

> 
> Note that this is currently no real problem, as KVM_MAX_VCPU_ID is
> an odd number, resulting in always enough padding being available at
> the end of those arrays.
> 
> Nevertheless this should be fixed in order to avoid rare problems in
> case someone is using an even number for KVM_MAX_VCPU_ID.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  arch/x86/kvm/ioapic.c | 2 +-
>  arch/x86/kvm/ioapic.h | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 698969e18fe3..ff005fe738a4 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -96,7 +96,7 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
>  static void rtc_irq_eoi_tracking_reset(struct kvm_ioapic *ioapic)
>  {
>  	ioapic->rtc_status.pending_eoi = 0;
> -	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID);
> +	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID + 1);
>  }
>  
>  static void kvm_rtc_eoi_tracking_restore_all(struct kvm_ioapic *ioapic);
> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
> index 660401700075..11e4065e1617 100644
> --- a/arch/x86/kvm/ioapic.h
> +++ b/arch/x86/kvm/ioapic.h
> @@ -43,13 +43,13 @@ struct kvm_vcpu;
>  
>  struct dest_map {
>  	/* vcpu bitmap where IRQ has been sent */
> -	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID);
> +	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID + 1);
>  
>  	/*
>  	 * Vector sent to a given vcpu, only valid when
>  	 * the vcpu's bit in map is set
>  	 */
> -	u8 vectors[KVM_MAX_VCPU_ID];
> +	u8 vectors[KVM_MAX_VCPU_ID + 1];
>  };
>  
>  
> -- 
> 2.26.2
> 

-- 
Eduardo


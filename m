Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1B218244
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 00:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbfEHW1c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 18:27:32 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:13602 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfEHW1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 18:27:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1557354452; x=1588890452;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=cc3iF2rKFnOXjc//hOXLvQ08PQaVcNXzHDybdjruEbQ=;
  b=dwVJVYB4/449toBO4fYzfpHwFCpDog9nF1ky9sew4PXZmaBjR0Qu5btV
   guvRgUcPGoTXL6qKD1Hyfk0hyoYt2UbTI1brF3zGFJ1HHvpljIzaInZ/t
   P5+IYWMlFSQkSWI55EI+MgJkMXVb6+/3oyFJa57+AL6wnLHZl8y/+HVMb
   M=;
X-IronPort-AV: E=Sophos;i="5.60,447,1549929600"; 
   d="scan'208";a="401390028"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 08 May 2019 22:27:29 +0000
Received: from u7588a65da6b65f.ant.amazon.com (pdx2-ws-svc-lb17-vlan3.amazon.com [10.247.140.70])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x48MRR58051082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Wed, 8 May 2019 22:27:28 GMT
Received: from u7588a65da6b65f.ant.amazon.com (localhost [127.0.0.1])
        by u7588a65da6b65f.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x48MRPM6012270;
        Thu, 9 May 2019 00:27:25 +0200
Subject: Re: [PATCH 4/6] kvm: lapic: Add apicv activate/deactivate helper
 function
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "joro@8bytes.org" <joro@8bytes.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
References: <20190322115702.10166-1-suravee.suthikulpanit@amd.com>
 <20190322115702.10166-5-suravee.suthikulpanit@amd.com>
From:   =?UTF-8?Q?Jan_H=2e_Sch=c3=b6nherr?= <jschoenh@amazon.de>
Openpgp: preference=signencrypt
Message-ID: <813c8c15-af74-6d77-4a30-2e0ee4b05006@amazon.de>
Date:   Thu, 9 May 2019 00:27:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190322115702.10166-5-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/2019 12.57, Suthikulpanit, Suravee wrote:
> Introduce a helper function for setting lapic parameters when
> activate/deactivate apicv.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/lapic.c | 23 ++++++++++++++++++-----
>  arch/x86/kvm/lapic.h |  1 +
>  2 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 95295cf81283..9c5cd1a98928 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2126,6 +2126,22 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  
>  }
>  
> +void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_lapic *apic = vcpu->arch.apic;
> +	bool active = vcpu->arch.apicv_active;
> +
> +	if (active) {
> +		/* irr_pending is always true when apicv is activated. */
> +		apic->irr_pending = true;
> +		apic->isr_count = 1;
> +	} else {
> +		apic->irr_pending = !!count_vectors(apic->regs + APIC_IRR);

What about:
		apic->irr_pending = apic_search_irr(apic) != -1;
instead? (more in line with the logic in apic_clear_irr())


Related to this, I wonder if we need to ensure to execute
kvm_x86_ops->sync_pir_to_irr() just before apicv_active transitions
from true to false, so that we don't miss an interrupt and irr_pending
is set correctly in this function (on Intel at least).

Hmm... there seems to be other stuff as well, that depends on
vcpu->arch.apicv_active, which is not updated on a transition. For
example: posted interrupts, CR8 intercept, and a potential asymmetry
via avic_vcpu_load()/avic_vcpu_put() because the bottom half
of just one of the two functions may be skipped...

Do these need to be handled in some way?

Regards
Jan

> +		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
> +	}
> +}
> +EXPORT_SYMBOL(kvm_apic_update_apicv);
> +
>  void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> @@ -2170,8 +2186,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  		kvm_lapic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
>  		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
>  	}
> -	apic->irr_pending = vcpu->arch.apicv_active;
> -	apic->isr_count = vcpu->arch.apicv_active ? 1 : 0;
> +	kvm_apic_update_apicv(vcpu);
>  	apic->highest_isr_cache = -1;
>  	update_divide_count(apic);
>  	atomic_set(&apic->lapic_timer.pending, 0);
> @@ -2433,9 +2448,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
>  	update_divide_count(apic);
>  	start_apic_timer(apic);
> -	apic->irr_pending = true;
> -	apic->isr_count = vcpu->arch.apicv_active ?
> -				1 : count_vectors(apic->regs + APIC_ISR);
> +	kvm_apic_update_apicv(vcpu);
>  	apic->highest_isr_cache = -1;
>  	if (vcpu->arch.apicv_active) {
>  		kvm_x86_ops->apicv_post_state_restore(vcpu);
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index ff6ef9c3d760..b657605cfec0 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -88,6 +88,7 @@ void kvm_apic_update_ppr(struct kvm_vcpu *vcpu);
>  int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
>  		     struct dest_map *dest_map);
>  int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
> +void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
>  
>  bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
>  		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
> 


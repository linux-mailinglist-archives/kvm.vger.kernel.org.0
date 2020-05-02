Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150DA1C2593
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 15:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgEBNNR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 09:13:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50462 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727818AbgEBNNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 09:13:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588425195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9jh53eKwLaSENNrS5+URLLbE0XH5d1BcS8Oj4M+VZ1g=;
        b=Qw64zMS643lApe8SWGob6QSsZzgmcjDZacOF+2RDwxATv6A9+eawH4I20CVXKc8P3Ctnzv
        KF1nhhgDONV+OdjcUOp2xNg9Zf0KMYQ0uSqIfAvfwKNVz0I/CKD8RkfYo9AOh99fNWsO/B
        VO1LeCRnhIrED7apFx6hYdXqoJi0reo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-Cperd1PLO-ey5Nl2NvZz3Q-1; Sat, 02 May 2020 09:13:14 -0400
X-MC-Unique: Cperd1PLO-ey5Nl2NvZz3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86F041895A29;
        Sat,  2 May 2020 13:13:12 +0000 (UTC)
Received: from starship (unknown [10.35.206.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FB0660BE1;
        Sat,  2 May 2020 13:13:09 +0000 (UTC)
Message-ID: <35c7c404406729dc05d0977c9d322655f2b1c4a9.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: Fixes posted interrupt check for IRQs
 delivery modes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        Alexander Graf <graf@amazon.com>
Date:   Sat, 02 May 2020 16:13:08 +0300
In-Reply-To: <1586239989-58305-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1586239989-58305-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-04-07 at 01:13 -0500, Suravee Suthikulpanit wrote:
> Current logic incorrectly uses the enum ioapic_irq_destination_types
> to check the posted interrupt destination types. However, the value
> was
> set using APIC_DM_XXX macros, which are left-shifted by 8 bits.
> 
> Fixes by using the APIC_DM_FIXED and APIC_DM_LOWEST instead.
> 
> Fixes: (fdcf75621375 'KVM: x86: Disable posted interrupts for non-
> standard IRQs delivery modes')
> Cc: Alexander Graf <graf@amazon.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h
> b/arch/x86/include/asm/kvm_host.h
> index 98959e8..f15e5b3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1664,8 +1664,8 @@ void kvm_set_msi_irq(struct kvm *kvm, struct
> kvm_kernel_irq_routing_entry *e,
>  static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
>  {
>  	/* We can only post Fixed and LowPrio IRQs */
> -	return (irq->delivery_mode == dest_Fixed ||
> -		irq->delivery_mode == dest_LowestPrio);
> +	return (irq->delivery_mode == APIC_DM_FIXED ||
> +		irq->delivery_mode == APIC_DM_LOWEST);
>  }
>  
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)

I confirm that this patch fixes AVIC posted interrupts on my 3970X.
Low byte of the delivery mode is the vector, while high byte is the
delivery mode, and the vector is masked in 
kvm_set_msi_irq, thus indeed the delivery mode is in high 8 bytes.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


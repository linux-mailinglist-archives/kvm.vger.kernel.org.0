Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E3F42815B
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 14:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhJJMtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 08:49:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33129 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231842AbhJJMtO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 10 Oct 2021 08:49:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633870035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YkLueNpEbRl5qinSVfMvo4zcnNOyRMqcIvp24LoixTE=;
        b=POX/S62VhBjqLSwiPdWNPe/fV6Ej/lmQRZJO5eeTTM2RiBeVgIHDDMX8kOt1dTNsl69Bk4
        //F1fDl27whrhvQ0OgKDZTvMRmwB34pyYFoztFntryUlvMlj7uoIC2z4ytmwKx7NriGeHi
        tgrzr9w7e1na8IZMEV1XlpostS2ldaQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-VtjM5XUUNC6BHo1qC-oBHA-1; Sun, 10 Oct 2021 08:47:10 -0400
X-MC-Unique: VtjM5XUUNC6BHo1qC-oBHA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C02941006AA3;
        Sun, 10 Oct 2021 12:47:08 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA60757CA0;
        Sun, 10 Oct 2021 12:47:05 +0000 (UTC)
Message-ID: <eecb66f6a0829b5f81b11e69537d943280b5719c.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Use vCPU's APICv status when handling
 APIC_ACCESS memslot
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 10 Oct 2021 15:47:04 +0300
In-Reply-To: <20211009010135.4031460-2-seanjc@google.com>
References: <20211009010135.4031460-1-seanjc@google.com>
         <20211009010135.4031460-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 18:01 -0700, Sean Christopherson wrote:
> Query the vCPU's APICv status, not the overall VM's status, when handling
> a page fault that hit the APIC Access Page memslot.  If an APICv status
> update is pending, using the VM's status is non-deterministic as the
> initiating vCPU may or may not have updated overall VM's status.  E.g. if
> a vCPU hits an APIC Access page fault with APICv disabled and a different
> vCPU is simultaneously performing an APICv update, the page fault handler
> will incorrectly skip the special APIC access page MMIO handling.
> 
> Using the vCPU's status in the page fault handler is correct regardless
> of any pending APICv updates, as the vCPU's status is accurate with
> respect to the last VM-Enter, and thus reflects the context in which the
> page fault occurred.

Actually I don't think that this patch is correct, and the current code is correct.

- The page fault can happen if one of the following is true:

	- AVIC is currently inhibited.
	
	- AVIC is currently inhibited but is in the process of being uninhibited.

	- AVIC is not inhibited but has never been accessed by a VCPU after it was uninihibited.

	This will *usually* cause this code to populate the corresponding SPTE entry and re-enter the guest which 
	  will make the AVIC work on instruction re-execution without a page fault.

        It depends if the page fault code sees new or old value of the global inhibition state, which is not possible
	to avoid, as the page fault can happen anytime.

        If the code doesn't populate the SPTE entry, the access will be emulated (which is correct too, and next access
	will page fault again and that fault will re-install the SPTE.


Note that AVIC's SPTE is *VM global*, just like all other SPTEs.

- The decision is here to poplute the SPTE and retry or just emulate the APIC read/write without populating it.

  Since AVIC read/writes the same apic register page, reading it now, or populating the SPTE, enabling AVIC and letting the AVIC read/write it should read/write the same values.

  Thus the real decision here is if to populate the SPTE or not.

- If AVIC is currently inhibited on this VCPU, but global AVIC inhibit is already OFF, we do want
  to populute the SPTE, and prior to guest entry we will update the vCPU inhibit state to disable inhibition on this VCPU.

So its the global AVIC inhibit state, is what is correct to use for this decision IMHO.

Best regards,
	Maxim Levitsky


> 
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Fixes: 9cc13d60ba6b ("KVM: x86/mmu: allow APICv memslot to be enabled but invisible")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 24a9f4c3f5e7..d36e205b90a5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3853,7 +3853,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  		 * when the AVIC is re-enabled.
>  		 */
>  		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
> -		    !kvm_apicv_activated(vcpu->kvm)) {
> +		    !kvm_vcpu_apicv_active(vcpu)) {
>  			*r = RET_PF_EMULATE;
>  			return true;
>  		}



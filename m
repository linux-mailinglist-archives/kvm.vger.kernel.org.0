Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDA5428149
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 14:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhJJMkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 08:40:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230500AbhJJMkB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 10 Oct 2021 08:40:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633869482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SHPEZkzx4aJGCaDO+FrRniDoOaTUcTMIUDzNCqN3F/M=;
        b=FmOFWqX0HWJPwqOLaoVdzxliWaRP73KDXCaqjIWO9XQmehg+xSVWfyTujlhQw72J6z+r96
        sLr+MrWiRW2rLNojGC+RdaeoX077mGvjPtkh2cjzC9nQ5Ud/G6JL+oNSfl44e8Y3lDInZy
        S0nfT8L+0TJ0G06ugnqXCDab0RHCS8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-3clG0ISkMliTq5WIfFDT2w-1; Sun, 10 Oct 2021 08:38:01 -0400
X-MC-Unique: 3clG0ISkMliTq5WIfFDT2w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EFE410A8E05;
        Sun, 10 Oct 2021 12:37:59 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3070F5D6CF;
        Sun, 10 Oct 2021 12:37:56 +0000 (UTC)
Message-ID: <9e9e91149ab4fa114543b69eaf493f84d2f33ce2.camel@redhat.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fix and cleanup for recent AVIC changes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 10 Oct 2021 15:37:56 +0300
In-Reply-To: <20211009010135.4031460-1-seanjc@google.com>
References: <20211009010135.4031460-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 18:01 -0700, Sean Christopherson wrote:
> Belated "code review" for Maxim's recent series to rework the AVIC inhibit
> code.  Using the global APICv status in the page fault path is wrong as
> the correct status is always the vCPU's, since that status is accurate
> with respect to the time of the page fault.  In a similar vein, the code
> to change the inhibit can be cleaned up since KVM can't rely on ordering
> between the update and the request for anything except consumers of the
> request.
> 
> Sean Christopherson (2):
>   KVM: x86/mmu: Use vCPU's APICv status when handling APIC_ACCESS
>     memslot
>   KVM: x86: Simplify APICv update request logic
> 
>  arch/x86/kvm/mmu/mmu.c |  2 +-
>  arch/x86/kvm/x86.c     | 16 +++++++---------
>  2 files changed, 8 insertions(+), 10 deletions(-)
> 

Are you sure about it? Let me explain how the algorithm works:

- kvm_request_apicv_update:

	- take kvm->arch.apicv_update_lock

	- if inhibition state doesn't really change (kvm->arch.apicv_inhibit_reasons still zero or non zero)
		- update kvm->arch.apicv_inhibit_reasons
		- release the lock

	- raise KVM_REQ_APICV_UPDATE
		* since kvm->arch.apicv_update_lock is taken, all vCPUs will be kicked out of guest
		  mode and will be either doing someing in the KVM (like page fault) or stuck on trying to process that request
                  the important thing is that no vCPU will be able to get back to the guest mode.

	- update the kvm->arch.apicv_inhibit_reasons
		* since we hold vm->arch.apicv_update_lock vcpus can't see the new value

	- update the SPTE that covers the APIC's mmio window:

		- if we enable AVIC, then do nothing.
			
			* First vCPU to access it will page fault and populate that SPTE

			* If we race with page fault again no problem, worst case the page fault
			  doesn't populte the SPTE, and we will get another page fault later
			  and it will. 

			  -> SPTE not present + AVIC enabled is not a problem, it just causes
			  a spurious page fault, and then retried at which point AVIC is used.

			  It is nice to re-install the SPTE as fast as possible to avoid such
			  faults for performance reasons.

		- if we disable AVIC, then we zap the spte:

			* page fault should not happen just before zapping as AVIC is enabled on the vCPUs now.
			  even if it does happen, it doesn't matter if it does populate the SPTE, as we will zap it anyway.

			* during the zapping we take the mmu lock and use mmu notifier counter hack
			  to avoid racing with page fault that can happen concurrently with it.

			* if page fault on another vCPU happens after the zapping, it will see the correct 
			  kvm->arch.apicv_inhibit_reasons (but likely incorrect its own vCPU AVIC inhibit state)
			  and will not re-populate the SPTE.

			  -> and SPTE present + AVIC inhibited on this vCPU is the problem,
			  as this will cause writes to AVIC to disappear into that dummy page mapped by that SPTE.

			  That is why patch 1 IMHO is wrong.

	- release the kvm->arch.apicv_update_lock
		* at that point all vCPUs can re-enter but they all will process the KVM_REQ_APICV_UPDATE
		  prior to that, which will update their AVIC state.


Best regards,
	Maxim Levitsky




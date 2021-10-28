Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE47243DD7F
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 11:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhJ1JPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 05:15:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43908 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhJ1JPK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 05:15:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635412363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l1MWdjra8eZcIIlx8zcoZvMR0jtyOa/xjrbhOVDWvpc=;
        b=WywqvnrFTYkLtUSeQ/iRa9W2PIlFGAfjP9Gf/493Ftda1l/I7ySjwth1XQ/nnoqAa9IRsC
        meiefUgcCyasnehZWpFq5q/cpcxyXMNoAfua03PSEBnPyTAN3aOcZKIWQhWfUoXORs6YyX
        aTJjddpiwf+xhUKRw3bde8X47WRd5Fk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-sp4eSFtgN52tnt6kECXjIQ-1; Thu, 28 Oct 2021 05:12:40 -0400
X-MC-Unique: sp4eSFtgN52tnt6kECXjIQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE71D1966321;
        Thu, 28 Oct 2021 09:12:36 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4625A5F707;
        Thu, 28 Oct 2021 09:12:15 +0000 (UTC)
Message-ID: <c6c19d79bc8c7747d91a9dba1c1e671e9d138761.camel@redhat.com>
Subject: Re: [PATCH v2 20/43] KVM: VMX: Skip Posted Interrupt updates if
 APICv is hard disabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Date:   Thu, 28 Oct 2021 12:12:13 +0300
In-Reply-To: <20211009021236.4122790-21-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-21-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Explicitly skip posted interrupt updates if APICv is disabled in all of
> KVM, or if the guest doesn't have an in-kernel APIC.  The PI descriptor
> is kept up-to-date if APICv is inhibited, e.g. so that re-enabling APICv
> doesn't require a bunch of updates, but neither the module param nor the
> APIC type can be changed on-the-fly.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 3263056784f5..351666c41bbc 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -28,11 +28,14 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  	unsigned int dest;
>  
>  	/*
> -	 * In case of hot-plug or hot-unplug, we may have to undo
> -	 * vmx_vcpu_pi_put even if there is no assigned device.  And we
> -	 * always keep PI.NDST up to date for simplicity: it makes the
> -	 * code easier, and CPU migration is not a fast path.
> +	 * To simplify hot-plug and dynamic toggling of APICv, keep PI.NDST and
> +	 * PI.SN up-to-date even if there is no assigned device or if APICv is
> +	 * deactivated due to a dynamic inhibit bit, e.g. for Hyper-V's SyncIC.
>  	 */
> +	if (!enable_apicv || !lapic_in_kernel(vcpu))
> +		return;
> +
> +	/* Nothing to do if PI.SN==0 and the vCPU isn't being migrated. */
>  	if (!pi_test_sn(pi_desc) && vcpu->cpu == cpu)
>  		return;
>  
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


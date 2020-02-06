Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEB3154192
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 11:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgBFKKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 05:10:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59579 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727543AbgBFKKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 05:10:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580983836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HntMcso/by+scG4HWfnTWo6j4dO4LNt2T9PXEOn4Vv4=;
        b=bWCIq2KmwBj14oR4VIqEaz8EvFv8aS5LaG2lXcOYus8CvBn0xE5SObF3wnUFiKRR55mcnm
        KayZhJVLkH0LBrsFibGm1+/itKU3BDiZylgRMwPtKlVDRJjBsvaSObCujb+Z22/zEWgFvz
        jbhQBQFWjHw7terWC23wexPz17GcAVc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-dD9geQcxNhmOE6SBv-7AgQ-1; Thu, 06 Feb 2020 05:10:35 -0500
X-MC-Unique: dD9geQcxNhmOE6SBv-7AgQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF8641835A27;
        Thu,  6 Feb 2020 10:10:33 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6BEF5DA7C;
        Thu,  6 Feb 2020 10:10:29 +0000 (UTC)
Date:   Thu, 6 Feb 2020 11:10:27 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 35/37] KVM: s390: protvirt: Mask PSW interrupt bits for
 interception 104 and 112
Message-ID: <20200206111027.3f7fd6c4.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-36-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-36-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:55 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> We're not allowed to inject interrupts on those intercept codes. As our

Spell out what these codes actually are?

> PSW is just a copy of the real one that will be replaced on the next
> exit, we can mask out the interrupt bits in the PSW to make sure that we
> do not inject anything.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d4dc156e2c3e..137ae5dc9101 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4050,6 +4050,7 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
>  	return vcpu_post_run_fault_in_sie(vcpu);
>  }
>  
> +#define PSW_INT_MASK (PSW_MASK_EXT | PSW_MASK_IO | PSW_MASK_MCHECK)
>  static int __vcpu_run(struct kvm_vcpu *vcpu)
>  {
>  	int rc, exit_reason;
> @@ -4082,10 +4083,15 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>  		}
>  		exit_reason = sie64a(vcpu->arch.sie_block,
>  				     vcpu->run->s.regs.gprs);
> +		/* This will likely be moved into a new function. */

Hm?

>  		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>  			memcpy(vcpu->run->s.regs.gprs,
>  			       sie_page->pv_grregs,
>  			       sizeof(sie_page->pv_grregs));
> +			if (vcpu->arch.sie_block->icptcode == ICPT_PV_INSTR ||
> +			    vcpu->arch.sie_block->icptcode == ICPT_PV_PREF) {
> +				vcpu->arch.sie_block->gpsw.mask &= ~PSW_INT_MASK;
> +			}
>  		}
>  		local_irq_disable();
>  		__enable_cpu_timer_accounting(vcpu);


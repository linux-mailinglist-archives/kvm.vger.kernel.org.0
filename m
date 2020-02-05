Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4FBC153080
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 13:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgBEMXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 07:23:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33482 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726944AbgBEMXL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 07:23:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580905390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WgtRU8921KOz0R/un0ply1/beSjVVXMaR52ovLvQgPo=;
        b=efcm82GwtYa9Z8ih2d7iAJebyz2ysbhgENzGtSyLovDSG2LxrsiSZPjyi24uYq+MNXhiOv
        W2VA2Jy7Dsyhog1Z5Z9weYn2CcVICcnl1zXMWVL7nlB7XuR16iuC5Ny7rrVAwbrYgboKBs
        na5FR80Cde77TZnZhy+mGMXXqlMCdgE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-6C9mV_0hMvaxegC6S5qwYA-1; Wed, 05 Feb 2020 07:23:06 -0500
X-MC-Unique: 6C9mV_0hMvaxegC6S5qwYA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 672E68010CB;
        Wed,  5 Feb 2020 12:23:05 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7800C5C1B5;
        Wed,  5 Feb 2020 12:23:01 +0000 (UTC)
Date:   Wed, 5 Feb 2020 13:22:59 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 16/37] KVM: s390: protvirt: Add SCLP interrupt handling
Message-ID: <20200205132259.75521fad.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-17-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-17-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:36 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> The sclp interrupt is kind of special. The ultravisor polices that we
> do not inject and sclp interrupt with payload if no sccb is outstanding.
> On the other hand we have "asynchronous" event interrupts, e.g. for
> console input.
> We separate both variants into sclp interrupt and sclp event interrupt.
> The sclp interrupt is masked until a previous servc instruction has
> finished (sie exit 108).
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  6 ++-
>  arch/s390/kvm/intercept.c        | 25 +++++++++
>  arch/s390/kvm/interrupt.c        | 92 ++++++++++++++++++++++++++------
>  arch/s390/kvm/kvm-s390.c         |  2 +
>  4 files changed, 108 insertions(+), 17 deletions(-)
> 

> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 4b3fbbde1674..c22214967214 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -444,8 +444,33 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
>  	return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
>  }
>  
> +static int handle_pv_sclp(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
> +
> +	spin_lock(&fi->lock);
> +	/*
> +	 * 2 cases:
> +	 * a: an sccb answering interrupt was already pending or in flight.
> +	 *    As the sccb value is not used we can simply set some more bits
> +	 *    and make sure that we deliver something

The sccb value is not used because the firmware handles this?

> +	 * b: an error sccb interrupt needs to be injected so we also inject
> +	 *    something and let firmware do the right thing.
> +	 * This makes sure, that both errors and real sccb returns will only
> +	 * be delivered when we are unmasked.

What makes this sure? That we only unmask here?

> +	 */
> +	fi->srv_signal.ext_params |= 0x43000;
> +	set_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs);
> +	clear_bit(IRQ_PEND_EXT_SERVICE, &fi->masked_irqs);
> +	spin_unlock(&fi->lock);
> +	return 0;
> +}
> +
>  static int handle_pv_not(struct kvm_vcpu *vcpu)
>  {
> +	if (vcpu->arch.sie_block->ipa == 0xb220)
> +		return handle_pv_sclp(vcpu);
> +
>  	return handle_instruction(vcpu);
>  }
>  


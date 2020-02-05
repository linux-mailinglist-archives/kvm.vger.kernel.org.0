Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9163B1528AD
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 10:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgBEJvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 04:51:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52734 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727068AbgBEJvY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 04:51:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580896283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=ytGvTXipw8DnkRr9xmN70vayZGALA+KyOoO/895ayWQ=;
        b=BXL7Sav884tpl6xouLjwReiWTt/8v5tqSbOGf2+zm7LaciKOUVPPTHWlWQsDqMiE54FRP+
        QUr3dByT30EsMFSkrdKMtA63H0K3lSMoLDeGmO4W6HYqmndCuWDiNZwRpOGKQx+BlXLaVM
        +vW9h1mX5Ld++g6QqcEu5C/D7KQjSc0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-Mn4sXiNIOOizLYFVnKUqZQ-1; Wed, 05 Feb 2020 04:51:20 -0500
X-MC-Unique: Mn4sXiNIOOizLYFVnKUqZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7F428010F9;
        Wed,  5 Feb 2020 09:51:18 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-132.ams2.redhat.com [10.36.116.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 779A360BF4;
        Wed,  5 Feb 2020 09:51:14 +0000 (UTC)
Subject: Re: [RFCv2 15/37] KVM: s390: protvirt: Implement interruption
 injection
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-16-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f6980d81-f1a9-10a0-9783-8835eae2c124@redhat.com>
Date:   Wed, 5 Feb 2020 10:51:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-16-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Michael Mueller <mimu@linux.ibm.com>
>=20
> The patch implements interruption injection for the following
> list of interruption types:
>=20
>   - I/O
>     __deliver_io (III)
>=20
>   - External
>     __deliver_cpu_timer (IEI)
>     __deliver_ckc (IEI)
>     __deliver_emergency_signal (IEI)
>     __deliver_external_call (IEI)
>=20
>   - cpu restart
>     __deliver_restart (IRI)
>=20
> The service interrupt is handled in a followup patch.
>=20
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> [fixes]
> ---
>  arch/s390/include/asm/kvm_host.h |  8 +++
>  arch/s390/kvm/interrupt.c        | 93 ++++++++++++++++++++++----------
>  2 files changed, 74 insertions(+), 27 deletions(-)
>=20
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/k=
vm_host.h
> index a45d10d87a8a..989cea7a5591 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -563,6 +563,14 @@ enum irq_types {
>  #define IRQ_PEND_MCHK_MASK ((1UL << IRQ_PEND_MCHK_REP) | \
>  			    (1UL << IRQ_PEND_MCHK_EX))
> =20
> +#define IRQ_PEND_MCHK_REP_MASK (1UL << IRQ_PEND_MCHK_REP)
> +
> +#define IRQ_PEND_EXT_II_MASK ((1UL << IRQ_PEND_EXT_CPU_TIMER)  | \
> +			      (1UL << IRQ_PEND_EXT_CLOCK_COMP) | \
> +			      (1UL << IRQ_PEND_EXT_EMERGENCY)  | \
> +			      (1UL << IRQ_PEND_EXT_EXTERNAL)   | \
> +			      (1UL << IRQ_PEND_EXT_SERVICE))
> +
>  struct kvm_s390_interrupt_info {
>  	struct list_head list;
>  	u64	type;
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index c06c89d370a7..ecdec6960a60 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -387,6 +387,12 @@ static unsigned long deliverable_irqs(struct kvm_v=
cpu *vcpu)
>  		__clear_bit(IRQ_PEND_EXT_SERVICE, &active_mask);
>  	if (psw_mchk_disabled(vcpu))
>  		active_mask &=3D ~IRQ_PEND_MCHK_MASK;
> +	/* PV guest cpus can have a single interruption injected at a time. *=
/
> +	if (kvm_s390_pv_is_protected(vcpu->kvm) &&
> +	    vcpu->arch.sie_block->iictl !=3D IICTL_CODE_NONE)
> +		active_mask &=3D ~(IRQ_PEND_EXT_II_MASK |
> +				 IRQ_PEND_IO_MASK |
> +				 IRQ_PEND_MCHK_REP_MASK);

I don't quite understand why there is a difference between
IRQ_PEND_MCHK_REP and IRQ_PEND_MCHK_EX here? Why not simply use
IRQ_PEND_MCHK_MASK here? Could you elaborate? (and maybe add a sentence
to the patch description)

> @@ -533,7 +547,6 @@ static int __must_check __deliver_pfault_init(struc=
t kvm_vcpu *vcpu)
>  	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
>  					 KVM_S390_INT_PFAULT_INIT,
>  					 0, ext.ext_params2);
> -

Nit: Unnecessary white space change.

Apart from that, the patch look ok to me.

 Thomas


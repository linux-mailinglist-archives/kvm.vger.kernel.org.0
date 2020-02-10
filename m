Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A21157DB8
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 15:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgBJOr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 09:47:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33529 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727671AbgBJOr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 09:47:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581346077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/VUZOjhgHwT3xKMQgFEK/et87DmDmqg+EbvUA2vG1GQ=;
        b=gGtAvKneCWP8bekG6bkI8yHtUGQnfmzgE3jBj3OVTqW2d1w4xTd+KmtKNK6WjD1Z/3jUFf
        tOIt7jexb95AP0CVdnyScIizYgt/QtNAfUVw/NQDQzAWlZa0BtNcR2sAoGwXJzn03FAkcB
        MtwXaTJ8UZfmhxwtk9dJVairl+j3+4M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-rZMNOUnQPBiX0E-vNeidlw-1; Mon, 10 Feb 2020 09:47:53 -0500
X-MC-Unique: rZMNOUnQPBiX0E-vNeidlw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8179118FE862;
        Mon, 10 Feb 2020 14:47:51 +0000 (UTC)
Received: from gondolin (ovpn-117-244.ams2.redhat.com [10.36.117.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95C6D5C1D6;
        Mon, 10 Feb 2020 14:47:46 +0000 (UTC)
Date:   Mon, 10 Feb 2020 15:47:43 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 32/35] KVM: s390: protvirt: Mask PSW interrupt bits for
 interception 104 and 112
Message-ID: <20200210154743.004f9bdb.cohuck@redhat.com>
In-Reply-To: <305c63ba-b9f1-aa88-7006-709c85006cda@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
        <20200207113958.7320-33-borntraeger@de.ibm.com>
        <20200210142845.2188b008.cohuck@redhat.com>
        <305c63ba-b9f1-aa88-7006-709c85006cda@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Feb 2020 14:48:06 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index b53cabc15d9d..52a5196fe975 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4089,6 +4089,12 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>                         memcpy(vcpu->run->s.regs.gprs,
>                                sie_page->pv_grregs,
>                                sizeof(sie_page->pv_grregs));
> +                       /*
> +                        * We're not allowed to inject interrupts on intercepts
> +                        * that leave the guest state in an "in-beetween" state

s/beetween/between/ here as well :)

> +                        * where the next SIE entry will do a continuation.
> +                        * Fence interrupts in our "internal" PSW.
> +                        */
>                         if (vcpu->arch.sie_block->icptcode == ICPT_PV_INSTR ||
>                             vcpu->arch.sie_block->icptcode == ICPT_PV_PREF) {
>                                 vcpu->arch.sie_block->gpsw.mask &= ~PSW_INT_MASK;

With that on top,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


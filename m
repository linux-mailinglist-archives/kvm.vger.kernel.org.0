Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD9A15419B
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 11:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgBFKNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 05:13:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27190 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727864AbgBFKNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 05:13:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580984026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1IGCwwm9dppdAjQF6+LFq3Yo9jruYxPsncBKAB9L0LA=;
        b=iSQwyiGA7KrnSvAQRCWnlhB1jlDNknPpSGmpco0cb8dZDke16AlmM3RSWDRvKbedXjBUhU
        Mrb80iG65/vqRfSbSS5a91OIH1OMLEj9VZA3yJgdwTJzEBof8aARs/Nt4naVJKi4VhYimt
        PNPr/8wQB7fYLfOJy4m8/S/P/eZkHi4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-Its-yZkQPO27w4fWrZcy0g-1; Thu, 06 Feb 2020 05:13:42 -0500
X-MC-Unique: Its-yZkQPO27w4fWrZcy0g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E00131137878;
        Thu,  6 Feb 2020 10:13:40 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B27B51059100;
        Thu,  6 Feb 2020 10:13:34 +0000 (UTC)
Date:   Thu, 6 Feb 2020 11:13:32 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 36/37] KVM: s390: protvirt: do not inject interrupts
 after start
Message-ID: <20200206111332.26e455e8.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-37-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-37-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:56 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> As PSW restart is handled by the ultravisor (and we only get a start
> notification) we must re-check the PSW after a start before injecting
> interrupts.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 137ae5dc9101..3e4716b3fc02 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4451,6 +4451,12 @@ void kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
>  	/* Let's tell the UV that we want to start again */
>  	kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_OPR);
>  	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_STOPPED);
> +	/*
> +	 * The real PSW might have changed due to an interpreted RESTART.

"a RESTART interpreted by the ultravisor" ?

> +	 * We block all interrupts and let the next sie exit refresh our view.
> +	 */
> +	if (kvm_s390_pv_is_protected(vcpu->kvm))
> +		vcpu->arch.sie_block->gpsw.mask &= ~PSW_INT_MASK;
>  	/*
>  	 * Another VCPU might have used IBS while we were offline.
>  	 * Let's play safe and flush the VCPU at startup.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


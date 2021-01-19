Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835252FBD0A
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 17:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389504AbhASQ5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 11:57:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32516 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390680AbhASQzf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 11:55:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611075249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=atKdoWTs/5WSIAH1EWyl3o9F/p/2dp+BRd7oUt8pH/A=;
        b=aLh0KItI71yyZuTEs0ayNiIbdPQglJ/y0qdU60RZM72F0AQttjyLfTpjOH5yfwj9E0004K
        jZse6axFXRRLCKWuvAww67UzFTrdkPwdYSGGdiflFPx0VpA+GhSK3qGVlPyVbq4W2GA2h4
        ih1I0WEUsRtXjfuXGxeY7aeqhkD/NVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-0rYlN_9OOfSUvEm-obQGyQ-1; Tue, 19 Jan 2021 11:54:05 -0500
X-MC-Unique: 0rYlN_9OOfSUvEm-obQGyQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AB648066F0;
        Tue, 19 Jan 2021 16:54:04 +0000 (UTC)
Received: from gondolin (ovpn-113-246.ams2.redhat.com [10.36.113.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77A8010190AA;
        Tue, 19 Jan 2021 16:54:02 +0000 (UTC)
Date:   Tue, 19 Jan 2021 17:53:59 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 1/1] KVM: s390: diag9c forwarding
Message-ID: <20210119175359.1a5ea5be.cohuck@redhat.com>
In-Reply-To: <20210118131739.7272-2-borntraeger@de.ibm.com>
References: <20210118131739.7272-1-borntraeger@de.ibm.com>
        <20210118131739.7272-2-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Jan 2021 14:17:39 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Pierre Morel <pmorel@linux.ibm.com>
> 
> When we receive intercept a DIAG_9C from the guest we verify
> that the target real CPU associated with the virtual CPU
> designated by the guest is running and if not we forward the
> DIAG_9C to the target real CPU.
> 
> To avoid a diag9c storm we allow a maximal rate of diag9c forwarding.
> 
> The rate is calculated as a count per second defined as a
> new parameter of the s390 kvm module: diag9c_forwarding_hz .
> 
> The default value is to not forward diag9c.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  1 +
>  arch/s390/include/asm/smp.h      |  1 +
>  arch/s390/kernel/smp.c           |  1 +
>  arch/s390/kvm/diag.c             | 31 ++++++++++++++++++++++++++++---
>  arch/s390/kvm/kvm-s390.c         |  6 ++++++
>  arch/s390/kvm/kvm-s390.h         |  8 ++++++++
>  6 files changed, 45 insertions(+), 3 deletions(-)
> 

(...)

> @@ -167,9 +180,21 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
>  	if (!tcpu)
>  		goto no_yield;
>  
> -	/* target already running */
> -	if (READ_ONCE(tcpu->cpu) >= 0)
> -		goto no_yield;
> +	/* target VCPU already running */

Maybe make this /* target guest VPCU already running */...

> +	if (READ_ONCE(tcpu->cpu) >= 0) {
> +		if (!diag9c_forwarding_hz || diag9c_forwarding_overrun())
> +			goto no_yield;
> +
> +		/* target CPU already running */

...and this /* target host CPU already running */? I just read this
several times and was confused before I spotted the difference :)

> +		if (!vcpu_is_preempted(tcpu->cpu))
> +			goto no_yield;
> +		smp_yield_cpu(tcpu->cpu);
> +		VCPU_EVENT(vcpu, 5,
> +			   "diag time slice end directed to %d: yield forwarded",
> +			   tid);
> +		vcpu->stat.diagnose_9c_forward++;
> +		return 0;
> +	}
>  
>  	if (kvm_vcpu_yield_to(tcpu) <= 0)
>  		goto no_yield;

(...)


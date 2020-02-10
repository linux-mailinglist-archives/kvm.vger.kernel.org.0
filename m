Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B20D2157B4A
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 14:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730350AbgBJN3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 08:29:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60498 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730895AbgBJN3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 08:29:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581341339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gq71Hxz8lPCoO50Y4SMfijDCLv9ZuZM+6sSmcsA+EKA=;
        b=XfFlgMc3eerPdx6QsKuC9d8XjOTohMr60NMDdddv5vfRBjrinKdytwcLClE6WZWnqdeDuM
        YJNqBv8/0oPit6UYBvHvh8h6WgWV8lhmJYFgzhjC7yiLNGyF1JtF+qWsMkHd+JGJHKjcnA
        nt3ebxPmoFFvT8t9NEPTNKeWjcChJ5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-W15Y3zPpMfG8b-IDZ88zuQ-1; Mon, 10 Feb 2020 08:28:55 -0500
X-MC-Unique: W15Y3zPpMfG8b-IDZ88zuQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAFEE1857345;
        Mon, 10 Feb 2020 13:28:53 +0000 (UTC)
Received: from gondolin (ovpn-117-244.ams2.redhat.com [10.36.117.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CBF390062;
        Mon, 10 Feb 2020 13:28:47 +0000 (UTC)
Date:   Mon, 10 Feb 2020 14:28:45 +0100
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
Message-ID: <20200210142845.2188b008.cohuck@redhat.com>
In-Reply-To: <20200207113958.7320-33-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
        <20200207113958.7320-33-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Feb 2020 06:39:55 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> We're not allowed to inject interrupts on intercepts that leave the
> guest state in an "in-beetween" state where the next SIE entry will do a

s/beetween/between/

> continuation.  Namely secure instruction interception and secure prefix

s/continuation. Namely/continuation, namely,/

Add which one is 104 and which one is 112, so you can match up the
description with the subject?


> interception.
> As our PSW is just a copy of the real one that will be replaced on the
> next exit, we can mask out the interrupt bits in the PSW to make sure
> that we do not inject anything.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index ced2bac251a6..8c7b27287b91 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4052,6 +4052,7 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
>  	return vcpu_post_run_fault_in_sie(vcpu);
>  }
>  
> +#define PSW_INT_MASK (PSW_MASK_EXT | PSW_MASK_IO | PSW_MASK_MCHECK)
>  static int __vcpu_run(struct kvm_vcpu *vcpu)
>  {
>  	int rc, exit_reason;
> @@ -4088,6 +4089,10 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>  			memcpy(vcpu->run->s.regs.gprs,
>  			       sie_page->pv_grregs,
>  			       sizeof(sie_page->pv_grregs));

Add a comment, as suggested by Thomas last time?

> +			if (vcpu->arch.sie_block->icptcode == ICPT_PV_INSTR ||
> +			    vcpu->arch.sie_block->icptcode == ICPT_PV_PREF) {
> +				vcpu->arch.sie_block->gpsw.mask &= ~PSW_INT_MASK;
> +			}
>  		}
>  		local_irq_disable();
>  		__enable_cpu_timer_accounting(vcpu);


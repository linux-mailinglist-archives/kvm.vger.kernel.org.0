Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844BD156B4F
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2020 17:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbgBIQHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Feb 2020 11:07:33 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28022 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727692AbgBIQHd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 9 Feb 2020 11:07:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581264451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=ZAc1dgNxPNHyfCKWvg9DMIElxZOkY394u4FbZX4RzhM=;
        b=B4uEk2oGkXmHgviplk5X+dYgGSFI94EClldMV0yx1e/KehtCAnaF5HYGup0XdBDDNoXW65
        nFYJvdEdXL8MVIC7WCcDiRIKLVV2uExXwuQgc/+IKe23pf1BHnWIIpbYvwyuH0ZTsHZIIA
        HKjcH8XgDkjUW7lycvYjs8HSiTgPYeY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-FjvMHkHzNQCpX4_EPQ6pEg-1; Sun, 09 Feb 2020 11:07:26 -0500
X-MC-Unique: FjvMHkHzNQCpX4_EPQ6pEg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 112F78017CC;
        Sun,  9 Feb 2020 16:07:25 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-108.ams2.redhat.com [10.36.116.108])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 05A2F87B01;
        Sun,  9 Feb 2020 16:07:19 +0000 (UTC)
Subject: Re: [PATCH 32/35] KVM: s390: protvirt: Mask PSW interrupt bits for
 interception 104 and 112
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-33-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <66cb29f7-b190-2faa-ab32-9cfd149fa3e4@redhat.com>
Date:   Sun, 9 Feb 2020 17:07:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-33-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/2020 12.39, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> We're not allowed to inject interrupts on intercepts that leave the
> guest state in an "in-beetween" state where the next SIE entry will do a
> continuation.  Namely secure instruction interception and secure prefix
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
> +			if (vcpu->arch.sie_block->icptcode == ICPT_PV_INSTR ||
> +			    vcpu->arch.sie_block->icptcode == ICPT_PV_PREF) {
> +				vcpu->arch.sie_block->gpsw.mask &= ~PSW_INT_MASK;
> +			}
>  		}
>  		local_irq_disable();
>  		__enable_cpu_timer_accounting(vcpu);
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>


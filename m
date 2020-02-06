Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B651543B0
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 13:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgBFMDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 07:03:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37351 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727511AbgBFMDQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 07:03:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580990595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=5wv9UW8LCZhEnRE7mfuulHPc0NgSC/UJJK94ldJSXjs=;
        b=Zgs761vAhHh6o3Edm8u6aNGdfY4JfjtUfDUqDCm29fQNG9TMhKuQrJIPddvF5Q4CgDAQXR
        6LJNzQYsdsOEjY97ntJAm58jhqEB19eU5q2iauMTgjsBDJy1s1Ilv0xTUY6vfmhgxYlev/
        R76duajnHEXjMHzRu8xfly9XziFoPKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-IU5j0ABuOdKESYBP6r9VHw-1; Thu, 06 Feb 2020 07:03:13 -0500
X-MC-Unique: IU5j0ABuOdKESYBP6r9VHw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B8E9800D54;
        Thu,  6 Feb 2020 12:03:12 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-151.ams2.redhat.com [10.36.116.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CE5D8DC16;
        Thu,  6 Feb 2020 12:03:08 +0000 (UTC)
Subject: Re: [RFCv2 35/37] KVM: s390: protvirt: Mask PSW interrupt bits for
 interception 104 and 112
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-36-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8e133c67-bc2e-d464-185c-7c744c235048@redhat.com>
Date:   Thu, 6 Feb 2020 13:03:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-36-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> We're not allowed to inject interrupts on those intercept codes. As our
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

As already mentioned by Cornelia: Please remove the above comment.

>  		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>  			memcpy(vcpu->run->s.regs.gprs,
>  			       sie_page->pv_grregs,
>  			       sizeof(sie_page->pv_grregs));

... but I'd like to suggest to add a comment before the following
if-statement with some information from the patch description. Otherwise
this will later be one of the code spots where you scratch your head
while looking at it and wonder why this masking of bits is done here.

> +			if (vcpu->arch.sie_block->icptcode == ICPT_PV_INSTR ||
> +			    vcpu->arch.sie_block->icptcode == ICPT_PV_PREF) {
> +				vcpu->arch.sie_block->gpsw.mask &= ~PSW_INT_MASK;
> +			}
>  		}
>  		local_irq_disable();
>  		__enable_cpu_timer_accounting(vcpu);
> 

 Thomas


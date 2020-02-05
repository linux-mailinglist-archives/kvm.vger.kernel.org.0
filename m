Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3713515306B
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 13:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBEMJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 07:09:43 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25751 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727064AbgBEMJm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 07:09:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580904581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=3FeX0qcVjZhGhdNKUN1Dz1tdR0M/F9FKpQW37uv0Ap8=;
        b=H6QDSGNRcCZZyjGEWuonTcCG5R+srTganJNmWOsnNcUYGlFcpoeSgY6LLQmR+FdMB1sSxh
        I7pEWbAvcryeAV8NwZiNC4A36uZemsT3rb3KUD8xZY6USr8Dw6s7rcNELzExywBsBwqPKS
        T++mH4RwsZ7i6gYk0KgXzjQjMxdP6FI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-A4yf4JVpOLqpr_h9YveUBw-1; Wed, 05 Feb 2020 07:09:39 -0500
X-MC-Unique: A4yf4JVpOLqpr_h9YveUBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3EC81800D42;
        Wed,  5 Feb 2020 12:09:38 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-132.ams2.redhat.com [10.36.116.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BB185DA7B;
        Wed,  5 Feb 2020 12:09:34 +0000 (UTC)
Subject: Re: [RFCv2 24/37] KVM: s390: protvirt: Write sthyi data to
 instruction data area
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-25-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5aed683a-3b65-f65a-0259-029170c23e6a@redhat.com>
Date:   Wed, 5 Feb 2020 13:09:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-25-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> STHYI data has to go through the bounce buffer.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/intercept.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 4b1effa44e41..06d1fa83ef4c 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -392,7 +392,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
>  		goto out;
>  	}
>  
> -	if (addr & ~PAGE_MASK)
> +	if (!kvm_s390_pv_is_protected(vcpu->kvm) && (addr & ~PAGE_MASK))
>  		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>  
>  	sctns = (void *)get_zeroed_page(GFP_KERNEL);
> @@ -403,10 +403,15 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
>  
>  out:
>  	if (!cc) {
> -		r = write_guest(vcpu, addr, reg2, sctns, PAGE_SIZE);
> -		if (r) {
> -			free_page((unsigned long)sctns);
> -			return kvm_s390_inject_prog_cond(vcpu, r);
> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +			memcpy((void *)(vcpu->arch.sie_block->sidad & PAGE_MASK), sctns,

I think it would look nicer with sida_origin() here.

> +			       PAGE_SIZE);
> +		} else {
> +			r = write_guest(vcpu, addr, reg2, sctns, PAGE_SIZE);
> +			if (r) {
> +				free_page((unsigned long)sctns);
> +				return kvm_s390_inject_prog_cond(vcpu, r);
> +			}
>  		}
>  	}
>  
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABA81529BD
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 12:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgBELSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 06:18:37 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60261 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727234AbgBELSg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 06:18:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580901515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=aShMuuYspLvdzRHGPaZOlJaWvyWh0j58p3q+WI/32Wg=;
        b=MzkDSWrQP/odYNpUHgEPkatF97O5eOo5DCN8N/dASEh12dKKkH8201RO5rdUN9v/A6yKkE
        y+Pa3CkzxkS1x5pKJ20rK86gzLqI28Dzdqa9Wx5zTqxarViyumqG4QiD8yKXwvIhoDBPsK
        6TLUWoWa1LpuEP0K96+e4xSP5tCRE30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-WOxYNJLiNimbV4ZXzUcLZw-1; Wed, 05 Feb 2020 06:18:32 -0500
X-MC-Unique: WOxYNJLiNimbV4ZXzUcLZw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CCC65EB;
        Wed,  5 Feb 2020 11:18:30 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-132.ams2.redhat.com [10.36.116.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E99A60BFB;
        Wed,  5 Feb 2020 11:18:26 +0000 (UTC)
Subject: Re: [RFCv2 20/37] KVM: s390: protvirt: Add new gprs location handling
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-21-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a031e057-65f4-7288-63e4-cfa19b37707c@redhat.com>
Date:   Wed, 5 Feb 2020 12:18:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-21-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Guest registers for protected guests are stored at offset 0x380.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  4 +++-
>  arch/s390/kvm/kvm-s390.c         | 11 +++++++++++
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index f5ca53574406..125511ec6eb0 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -343,7 +343,9 @@ struct kvm_s390_itdb {
>  struct sie_page {
>  	struct kvm_s390_sie_block sie_block;
>  	struct mcck_volatile_info mcck_info;	/* 0x0200 */
> -	__u8 reserved218[1000];		/* 0x0218 */
> +	__u8 reserved218[360];		/* 0x0218 */
> +	__u64 pv_grregs[16];		/* 0x380 */

s/0x380/0x0380/ to align with the other comments

> +	__u8 reserved400[512];

Maybe add a /* 0x0400 */ comment ... though it's obvious from the name
already.

>  	struct kvm_s390_itdb itdb;	/* 0x0600 */
>  	__u8 reserved700[2304];		/* 0x0700 */
>  };
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 39bf39a10cf2..1945180b857a 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3996,6 +3996,7 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
>  static int __vcpu_run(struct kvm_vcpu *vcpu)
>  {
>  	int rc, exit_reason;
> +	struct sie_page *sie_page = (struct sie_page *)vcpu->arch.sie_block;
>  
>  	/*
>  	 * We try to hold kvm->srcu during most of vcpu_run (except when run-
> @@ -4017,8 +4018,18 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>  		guest_enter_irqoff();
>  		__disable_cpu_timer_accounting(vcpu);
>  		local_irq_enable();
> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +			memcpy(sie_page->pv_grregs,
> +			       vcpu->run->s.regs.gprs,
> +			       sizeof(sie_page->pv_grregs));
> +		}
>  		exit_reason = sie64a(vcpu->arch.sie_block,
>  				     vcpu->run->s.regs.gprs);
> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +			memcpy(vcpu->run->s.regs.gprs,
> +			       sie_page->pv_grregs,
> +			       sizeof(sie_page->pv_grregs));
> +		}
>  		local_irq_disable();
>  		__enable_cpu_timer_accounting(vcpu);
>  		guest_exit_irqoff();
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>


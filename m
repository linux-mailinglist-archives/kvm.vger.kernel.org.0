Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C8A156B3F
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2020 16:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbgBIPxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Feb 2020 10:53:00 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24277 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727692AbgBIPw7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 9 Feb 2020 10:52:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581263578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=PXqYkrJEUfbPZYMcdYFfKznLDKNNxPST/3SEG2KtpTI=;
        b=TM21yy6q4mGPadocQ5Gr/H0TSAt3wf+H8CikZkfgoT5OZeCmtqy5HR6oamFCt68OcRU2BY
        rINpQWrgJ8k9W3f408gJQtCEzqUrs5vzpv5H5GRfhS7mdOxSNCm5y2Onob94IyFd01XO3z
        VQgRXykrhvYcdUO9uqJPWK3PxLKfI2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-olUFV6ONMyuTeHDrikzwtQ-1; Sun, 09 Feb 2020 10:52:54 -0500
X-MC-Unique: olUFV6ONMyuTeHDrikzwtQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3920D8017CC;
        Sun,  9 Feb 2020 15:52:53 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-108.ams2.redhat.com [10.36.116.108])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A4CDA10021B2;
        Sun,  9 Feb 2020 15:52:47 +0000 (UTC)
Subject: Re: [PATCH 26/35] KVM: s390: protvirt: Add program exception
 injection
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
 <20200207113958.7320-27-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cbdd3e0a-1c88-51a2-04b4-1e507dbf1093@redhat.com>
Date:   Sun, 9 Feb 2020 16:52:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-27-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/2020 12.39, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Only two program exceptions can be injected for a protected guest:
> specification and operand.
> 
> For both, a code needs to be specified in the interrupt injection
> control of the state description, as the guest prefix page is not
> accessible to KVM for such guests.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/interrupt.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index c28fa09cb557..2df6459ab98b 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -837,6 +837,21 @@ static int __must_check __deliver_external_call(struct kvm_vcpu *vcpu)
>  	return rc ? -EFAULT : 0;
>  }
>  
> +static int __deliver_prog_pv(struct kvm_vcpu *vcpu, u16 code)
> +{
> +	switch (code) {
> +	case PGM_SPECIFICATION:
> +		vcpu->arch.sie_block->iictl = IICTL_CODE_SPECIFICATION;
> +		break;
> +	case PGM_OPERAND:
> +		vcpu->arch.sie_block->iictl = IICTL_CODE_OPERAND;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
>  static int __must_check __deliver_prog(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
> @@ -857,6 +872,9 @@ static int __must_check __deliver_prog(struct kvm_vcpu *vcpu)
>  	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_PROGRAM_INT,
>  					 pgm_info.code, 0);
>  
> +	if (kvm_s390_pv_is_protected(vcpu->kvm))
> +		return __deliver_prog_pv(vcpu, pgm_info.code & ~PGM_PER);
> +
>  	switch (pgm_info.code & ~PGM_PER) {
>  	case PGM_AFX_TRANSLATION:
>  	case PGM_ASX_TRANSLATION:
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>


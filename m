Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAE91153070
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 13:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgBEMNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 07:13:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30573 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726277AbgBEMNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 07:13:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580904811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=06IsHV2aYDRonHTGjC87qFivVlsz0PtymrsSVSrsboA=;
        b=Y0t/CywvQexM/fkSu4mIJIggSxNKgryuwbDkqmtHpE1PhYiiye03em4CrBw+Rx9UJzE9O9
        WhqadHXKHU0xNA/t+zFhaSUSvqmsX6fuIY7B//3DLYUWIS/RSYLGQzvaZlAwSrbCxnlS0D
        c9w7Axij2iKao7ocyhHRHpFimWwZLJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-5eZuAM-ePM6nB9-D9NNW_w-1; Wed, 05 Feb 2020 07:13:26 -0500
X-MC-Unique: 5eZuAM-ePM6nB9-D9NNW_w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 854031081FAB;
        Wed,  5 Feb 2020 12:13:25 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-132.ams2.redhat.com [10.36.116.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 15BB32133;
        Wed,  5 Feb 2020 12:13:20 +0000 (UTC)
Subject: Re: [RFCv2 25/37] KVM: s390: protvirt: STSI handling
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-26-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3625b3bc-ddfb-2424-3ab0-6cd217af5856@redhat.com>
Date:   Wed, 5 Feb 2020 13:13:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-26-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Save response to sidad and disable address checking for protected
> guests.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/priv.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index ed52ffa8d5d4..06c7e7a10825 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -872,7 +872,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>  
>  	operand2 = kvm_s390_get_base_disp_s(vcpu, &ar);
>  
> -	if (operand2 & 0xfff)
> +	if (!kvm_s390_pv_is_protected(vcpu->kvm) && (operand2 & 0xfff))
>  		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>  
>  	switch (fc) {
> @@ -893,8 +893,13 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>  		handle_stsi_3_2_2(vcpu, (void *) mem);
>  		break;
>  	}
> +	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +		memcpy((void *)vcpu->arch.sie_block->sidad, (void *)mem,

That should use sida_origin() or "...->sidad & PAGE_MASK".

> +		       PAGE_SIZE);
> +		rc = 0;
> +	} else
> +		rc = write_guest(vcpu, operand2, ar, (void *)mem, PAGE_SIZE);

Coding style: If one branch of the if-statement uses curly braces,
please add them to the other branch as well.

> -	rc = write_guest(vcpu, operand2, ar, (void *)mem, PAGE_SIZE);
>  	if (rc) {
>  		rc = kvm_s390_inject_prog_cond(vcpu, rc);
>  		goto out;
> 

 Thomas


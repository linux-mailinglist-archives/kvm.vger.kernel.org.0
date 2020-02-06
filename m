Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5BC1543B3
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 13:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgBFMDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 07:03:51 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25070 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727756AbgBFMDv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 07:03:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580990630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=VmfmiH+qFLzcD3uiXR/gYR2YpmzfAI20s+ApaCZr8Pc=;
        b=W0TgyP+wUQ9GP/EiiJVc6ACTm7PC/eVQwsqRprZt3lYx+zlpWpjNA/p+o1J6NDcoeH0bkQ
        +eTV0YJopoeO5HoK6uTvidszjZwEiigGb3Sp6t8sfIG8GyWemEEvzpRGaAoCHsw7KHVIMc
        IDVoiQV0QBxj85S1VLevrFA41xur9KM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-du4VTv0xOTOUmTGWzTuOlg-1; Thu, 06 Feb 2020 07:03:48 -0500
X-MC-Unique: du4VTv0xOTOUmTGWzTuOlg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 608F8800EB2;
        Thu,  6 Feb 2020 12:03:47 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-151.ams2.redhat.com [10.36.116.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 28E015C1B0;
        Thu,  6 Feb 2020 12:03:42 +0000 (UTC)
Subject: Re: [RFCv2 36/37] KVM: s390: protvirt: do not inject interrupts after
 start
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-37-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <59df3424-e164-3f1b-5ff3-aaaadc8056d8@redhat.com>
Date:   Thu, 6 Feb 2020 13:03:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-37-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
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
> +	 * We block all interrupts and let the next sie exit refresh our view.
> +	 */
> +	if (kvm_s390_pv_is_protected(vcpu->kvm))
> +		vcpu->arch.sie_block->gpsw.mask &= ~PSW_INT_MASK;
>  	/*
>  	 * Another VCPU might have used IBS while we were offline.
>  	 * Let's play safe and flush the VCPU at startup.
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>


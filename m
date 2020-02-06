Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239611542BC
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 12:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgBFLMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 06:12:23 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53878 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727455AbgBFLMX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 06:12:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580987542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=xSKeacvHhgfUH+4C1q0l8bqk3r8GWYJFE/e9vsPOFXc=;
        b=OwODi1pY95D0fMhZESUc0aCuerUpCkR4c8MmAOgyP667H+Y2OITNQbOSng4gq5n30+3Dc7
        FwcobSLWcsGq36bGZT0ejvT+GaYcrTAvQ2Crdr62drLcWPmUomVBJFnk5u8zpJn5JcvZTn
        TtzHSjPANGwAj+Lb8UZDgjpDXyO4haM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-CUOh02iOMTawW5rF4B-kOg-1; Thu, 06 Feb 2020 06:12:18 -0500
X-MC-Unique: CUOh02iOMTawW5rF4B-kOg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F1551081FA7;
        Thu,  6 Feb 2020 11:12:17 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-151.ams2.redhat.com [10.36.116.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F0DC790CD;
        Thu,  6 Feb 2020 11:12:12 +0000 (UTC)
Subject: Re: [RFCv2 32/37] KVM: s390: protvirt: Report CPU state to Ultravisor
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-33-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5ce5a57c-86ef-9e75-f677-004c567fea49@redhat.com>
Date:   Thu, 6 Feb 2020 12:12:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-33-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> VCPU states have to be reported to the ultravisor for SIGP
> interpretation.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 3ab5091ded6c..da8aeb24362a 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4434,7 +4434,8 @@ void kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
>  		 */
>  		__disable_ibs_on_all_vcpus(vcpu->kvm);
>  	}
> -
> +	/* Let's tell the UV that we want to start again */
> +	kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_OPR);
>  	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_STOPPED);
>  	/*
>  	 * Another VCPU might have used IBS while we were offline.
> @@ -4462,6 +4463,8 @@ void kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
>  	kvm_s390_clear_stop_irq(vcpu);
>  
>  	kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
> +	/* Let's tell the UV that we successfully stopped the vcpu */
> +	kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_STP);
>  	__disable_ibs_on_vcpu(vcpu);
>  
>  	for (i = 0; i < online_vcpus; i++) {

As already mentioned, I'd move the kvm_s390_pv_set_cpu_state() from the
previous patch to this one here.

Anyway,
Reviewed-by: Thomas Huth <thuth@redhat.com>


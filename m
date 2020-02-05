Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D3E153074
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 13:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgBEMQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 07:16:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44722 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726277AbgBEMQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 07:16:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580904980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=DVFGSMvqzcMplmR4/wi6Dy/P4aOG3hLI83Oa1Apyzs0=;
        b=VGzBHwHp+WMfaujX1E20a7SdoYDVE9A39rjGfg9ZpmbLeeoMyE1SXqD3uZgtBUJVltrJvI
        n4D01DrvRbOoh1KhXOZgsmPoiSbTIIAAD2L2Am/rfgSAV+YcOQ2bHw+OKPNIwSoSDR3+7Y
        HdWso3C88aNbmU2IfaNHt+QHuTDvNR4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-HiN8RJTANaK-hTi6OxLLKg-1; Wed, 05 Feb 2020 07:16:18 -0500
X-MC-Unique: HiN8RJTANaK-hTi6OxLLKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0E05140B;
        Wed,  5 Feb 2020 12:16:17 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-132.ams2.redhat.com [10.36.116.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 519071001B05;
        Wed,  5 Feb 2020 12:16:13 +0000 (UTC)
Subject: Re: [RFCv2 26/37] KVM: s390: protvirt: disallow one_reg
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-27-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e97e34a8-8eb8-f849-520e-b93656dca62b@redhat.com>
Date:   Wed, 5 Feb 2020 13:16:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-27-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> A lot of the registers are controlled by the Ultravisor and never
> visible to KVM. Some fields in the sie control block are overlayed,
> like gbea. As no userspace uses the ONE_REG interface on s390 it is safe
> to disable this for protected guests.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6e74c7afae3a..b9692d722c1e 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4641,6 +4641,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	case KVM_SET_ONE_REG:
>  	case KVM_GET_ONE_REG: {
>  		struct kvm_one_reg reg;
> +		r = -EINVAL;
> +		if (kvm_s390_pv_is_protected(vcpu->kvm))
> +			break;
>  		r = -EFAULT;
>  		if (copy_from_user(&reg, argp, sizeof(reg)))
>  			break;

Reviewed-by: Thomas Huth <thuth@redhat.com>

PS:
Not sure, but maybe it would be also be good to add a sentence to
Documentation/virt/kvm/api.txt ?


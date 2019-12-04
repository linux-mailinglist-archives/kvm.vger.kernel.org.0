Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE3D112785
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 10:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfLDJdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 04:33:05 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56729 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725994AbfLDJdF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Dec 2019 04:33:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575451984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=lyNlM5R23ky1JXhL31JK3tXLx6wPkKQ8Mv3R9kr9PRA=;
        b=T9oBVT+QonR+LKG1XtYp8r4iKrLkPqB9I8P9ipsTwKDXeHAxbTMnhf8DzJDdGc8w6vL9xC
        zCsIO5+zxLmBpTmg5Ozn4vvoHeapWJ1wVop2tYcZWDPvSnIGu8N9kPL7qeiIceiIO6MnOn
        mfx+SvogH+mUR3g95yooYnmlb+KNUg0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-SmosZg6KOEWZqrCPE7FcHA-1; Wed, 04 Dec 2019 04:33:01 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2BF118543A4;
        Wed,  4 Dec 2019 09:32:59 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-39.ams2.redhat.com [10.36.117.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4F19600C8;
        Wed,  4 Dec 2019 09:32:55 +0000 (UTC)
Subject: Re: [PATCH v2] KVM: s390: Add new reset vcpu API
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, mihajlov@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20191203162055.3519-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c22eefd7-2c99-ec8e-3b5c-fabb343230a9@redhat.com>
Date:   Wed, 4 Dec 2019 10:32:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191203162055.3519-1-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: SmosZg6KOEWZqrCPE7FcHA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/12/2019 17.20, Janosch Frank wrote:
> The architecture states that we need to reset local IRQs for all CPU
> resets. Because the old reset interface did not support the normal CPU
> reset we never did that.
> 
> Now that we have a new interface, let's properly clear out local IRQs
> and let this commit be a reminder.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 13 +++++++++++++
>  include/uapi/linux/kvm.h |  4 ++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d9e6bf3d54f0..602214c5616c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -529,6 +529,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_S390_CMMA_MIGRATION:
>  	case KVM_CAP_S390_AIS:
>  	case KVM_CAP_S390_AIS_MIGRATION:
> +	case KVM_CAP_S390_VCPU_RESETS:
>  		r = 1;
>  		break;
>  	case KVM_CAP_S390_HPAGE_1M:
> @@ -3287,6 +3288,13 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
>  	return r;
>  }
>  
> +static int kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
> +{
> +	kvm_clear_async_pf_completion_queue(vcpu);
> +	kvm_s390_clear_local_irqs(vcpu);
> +	return 0;
> +}
> +
>  static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>  {
>  	kvm_s390_vcpu_initial_reset(vcpu);
> @@ -4363,7 +4371,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		r = kvm_arch_vcpu_ioctl_set_initial_psw(vcpu, psw);
>  		break;
>  	}
> +	case KVM_S390_NORMAL_RESET:
> +		r = kvm_arch_vcpu_ioctl_normal_reset(vcpu);
> +		break;
>  	case KVM_S390_INITIAL_RESET:
> +		/* fallthrough */
> +	case KVM_S390_CLEAR_RESET:
>  		r = kvm_arch_vcpu_ioctl_initial_reset(vcpu);
>  		break;

Isn't clear reset supposed to do more than the initial reset? If so, I'd
rather expect it the other way round:

	case KVM_S390_CLEAR_RESET:
		/* fallthrough */
	case KVM_S390_INITIAL_RESET:
		r = kvm_arch_vcpu_ioctl_initial_reset(vcpu);
		break;

... so you can later add the additional stuff before the "/* fallthrough
*/"?

 Thomas


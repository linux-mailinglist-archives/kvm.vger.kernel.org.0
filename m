Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2596C110248
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 17:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfLCQ2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 11:28:15 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44529 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727073AbfLCQ2P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Dec 2019 11:28:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575390494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YqwpuKtnDubpLXH4usVkrSMU1DYBVfWJge8/U62NBA0=;
        b=hzmHJC8dbUqeXecNteLRjm0+1y0oS9l9G5ZubL/JOjLLmwSnDFSy338dnFvOL9WuJ3I4t/
        tQkRBn9tVg8TzS8ryup81SliXQSD0Cv6NLu86xhNUCWxrWZR4qeKqY5ybr56m3jVv7pwVM
        qXTTddH6wHOFVDqpt51yA8TlqCcNxBU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-qE2RYTeFMXO4sV2prbycvw-1; Tue, 03 Dec 2019 11:28:10 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 835EB18042C5;
        Tue,  3 Dec 2019 16:28:09 +0000 (UTC)
Received: from gondolin (ovpn-116-214.ams2.redhat.com [10.36.116.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F9EE1001902;
        Tue,  3 Dec 2019 16:28:04 +0000 (UTC)
Date:   Tue, 3 Dec 2019 17:28:02 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, mihajlov@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v2] KVM: s390: Add new reset vcpu API
Message-ID: <20191203172802.7d67d31d.cohuck@redhat.com>
In-Reply-To: <20191203162055.3519-1-frankja@linux.ibm.com>
References: <20191203162055.3519-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: qE2RYTeFMXO4sV2prbycvw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  3 Dec 2019 11:20:55 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> The architecture states that we need to reset local IRQs for all CPU
> resets. Because the old reset interface did not support the normal CPU
> reset we never did that.
> 
> Now that we have a new interface, let's properly clear out local IRQs
> and let this commit be a reminder.

Well, the new interface did not appear magically, this patch introduces
it :) (The whole sentence is a bit confusing; what is this commit
supposed to remind us of?)

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

The cover letter probably should also mention that clear reset falls
back to initial reset for now?

>  		break;
>  	case KVM_SET_ONE_REG:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 52641d8ca9e8..f4fc865775a5 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1000,6 +1000,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PMU_EVENT_FILTER 173
>  #define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
>  #define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
> +#define KVM_CAP_S390_VCPU_RESETS 180
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -1461,6 +1462,9 @@ struct kvm_enc_region {
>  /* Available with KVM_CAP_ARM_SVE */
>  #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
>  
> +#define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
> +#define KVM_S390_CLEAR_RESET    _IO(KVMIO,   0xc4)
> +
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
>  	/* Guest initialization commands */

Looks sane, but please also document the new ioctls and the new cap.


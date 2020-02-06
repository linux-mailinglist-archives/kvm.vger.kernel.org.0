Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32A8515424B
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 11:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgBFKqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 05:46:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28969 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728033AbgBFKqG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 05:46:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580985965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=82TVg9x6TQ6gnN7vaZKEdY/CFtgKqEPGXw0Oqdx4wt0=;
        b=ERSSZIPRQUX7z8VOAo9xHvESyH76lrs7sa2cb5w1mRbt2O46Kqb5mX0rSjLx0WzsoNnzaW
        93DWs/ojGLHRsSaHsYn9IGU4K9AQKajR5t+Lwn+hV1PMNsy41I5TQfg8xhI+LOACp0sfF/
        2aRDxODCidfruuN3sZ9sHCGHnkLmCyg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-CFRDYWFANTKuI-WZfKT8fw-1; Thu, 06 Feb 2020 05:46:01 -0500
X-MC-Unique: CFRDYWFANTKuI-WZfKT8fw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04F231922964;
        Thu,  6 Feb 2020 10:46:00 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB9951001B08;
        Thu,  6 Feb 2020 10:45:54 +0000 (UTC)
Date:   Thu, 6 Feb 2020 11:45:52 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 37/37] KVM: s390: protvirt: Add UV cpu reset calls
Message-ID: <20200206114552.766d3a53.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-38-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-38-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:57 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> For protected VMs, the VCPU resets are done by the Ultravisor, as KVM
> has no access to the VCPU registers.
> 
> As the Ultravisor will only accept a call for the reset that is
> needed, we need to fence the UV calls when chaining resets.

Stale note, chaining resets is gone?

"Note that the ultravisor will only accept a call for the exact reset
that has been requested." ?

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 3e4716b3fc02..f7a3f84be064 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4699,6 +4699,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	void __user *argp = (void __user *)arg;
>  	int idx;
>  	long r;
> +	u32 ret;
>  
>  	vcpu_load(vcpu);
>  
> @@ -4720,14 +4721,33 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	case KVM_S390_CLEAR_RESET:
>  		r = 0;
>  		kvm_arch_vcpu_ioctl_clear_reset(vcpu);
> +		if (kvm_s390_pv_handle_cpu(vcpu)) {
> +			r = uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
> +					  UVC_CMD_CPU_RESET_CLEAR, &ret);
> +			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET CLEAR VCPU: cpu %d rc %x rrc %x",
> +				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);

I think VCPU_EVENT() already traces the vcpu_id, doesn't it?

> +		}
>  		break;
>  	case KVM_S390_INITIAL_RESET:
>  		r = 0;
>  		kvm_arch_vcpu_ioctl_initial_reset(vcpu);
> +		if (kvm_s390_pv_handle_cpu(vcpu)) {
> +			r = uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
> +					  UVC_CMD_CPU_RESET_INITIAL,
> +					  &ret);
> +			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET INITIAL VCPU: cpu %d rc %x rrc %x",
> +				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
> +		}
>  		break;
>  	case KVM_S390_NORMAL_RESET:
>  		r = 0;
>  		kvm_arch_vcpu_ioctl_normal_reset(vcpu);
> +		if (kvm_s390_pv_handle_cpu(vcpu)) {
> +			r = uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
> +					  UVC_CMD_CPU_RESET, &ret);
> +			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET NORMAL VCPU: cpu %d rc %x rrc %x",
> +				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
> +		}
>  		break;
>  	case KVM_SET_ONE_REG:
>  	case KVM_GET_ONE_REG: {

Otherwise, looks good.


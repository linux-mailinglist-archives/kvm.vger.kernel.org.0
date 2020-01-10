Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61098136B0C
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 11:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgAJK2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 05:28:34 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25989 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727168AbgAJK2d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jan 2020 05:28:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578652112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BifiIJVkMV1xiw4GKGkPu4F376TG1KVCMJLUS+7vE6Y=;
        b=Uc448yZBuTDznXKwpdi+gN/Q6PDeCfq0x1Ee6vSrZr5XAGf3SIBzluG5rupiK6gTi5ABZc
        oiSnyGeM00GcJIU65nb1TV1We/zBVcQbErHoSMxFsdo0auq891NNzohTJ31JuBD5t+DKw5
        AzOdOcLrhfkp+zXtf14GzGPVej0xGcg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-m1ChCMWNO22Gag9adrLnzQ-1; Fri, 10 Jan 2020 05:28:31 -0500
X-MC-Unique: m1ChCMWNO22Gag9adrLnzQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2869A80269D;
        Fri, 10 Jan 2020 10:28:30 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 702005C28D;
        Fri, 10 Jan 2020 10:28:26 +0000 (UTC)
Date:   Fri, 10 Jan 2020 11:28:24 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [PATCH v6] KVM: s390: Add new reset vcpu API
Message-ID: <20200110112824.16047937.cohuck@redhat.com>
In-Reply-To: <20200110101906.54291-1-frankja@linux.ibm.com>
References: <20200110101906.54291-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Jan 2020 05:19:06 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> The architecture states that we need to reset local IRQs for all CPU
> resets. Because the old reset interface did not support the normal CPU
> reset we never did that on a normal reset.
> 
> Let's implement an interface for the missing normal and clear resets
> and reset all local IRQs, registers and control structures as stated
> in the architecture.
> 
> Userspace might already reset the registers via the vcpu run struct,
> but as we need the interface for the interrupt clearing part anyway,
> we implement the resets fully and don't rely on userspace to reset the
> rest.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
> 
> Based on the irc discussion.
> 
> ---
>  Documentation/virt/kvm/api.txt |  43 ++++++++++++
>  arch/s390/kvm/kvm-s390.c       | 115 +++++++++++++++++++++++----------
>  include/uapi/linux/kvm.h       |   5 ++
>  3 files changed, 130 insertions(+), 33 deletions(-)
> 

(...)

> +static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
> +
> +	/* Clear reset is a superset of the initial reset */
> +	kvm_arch_vcpu_ioctl_normal_reset(vcpu);
> +
> +	memset(&regs->gprs, 0, sizeof(regs->gprs));
> +	/*
> +	 * Will be picked up via save_fpu_regs() in the initial reset
> +	 * fallthrough.

Didn't you want to remove that? (Especially now that we don't
fallthrough anymore.)

> +	 */
> +	memset(&regs->vrs, 0, sizeof(regs->vrs));
> +	memset(&regs->acrs, 0, sizeof(regs->acrs));
> +
> +	regs->etoken = 0;
> +	regs->etoken_extension = 0;
> +
> +	memset(&regs->gscb, 0, sizeof(regs->gscb));
> +	if (MACHINE_HAS_GS) {
> +		preempt_disable();
> +		__ctl_set_bit(2, 4);
> +		if (current->thread.gs_cb) {
> +			vcpu->arch.host_gscb = current->thread.gs_cb;
> +			save_gs_cb(vcpu->arch.host_gscb);
> +		}
> +		if (vcpu->arch.gs_enabled) {
> +			current->thread.gs_cb = (struct gs_cb *)
> +				&vcpu->run->s.regs.gscb;
> +			restore_gs_cb(current->thread.gs_cb);
> +		}
> +		preempt_enable();
> +	}
>  }
>  
>  int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> @@ -4363,8 +4403,17 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		r = kvm_arch_vcpu_ioctl_set_initial_psw(vcpu, psw);
>  		break;
>  	}
> +	case KVM_S390_CLEAR_RESET:
> +		r = 0;
> +		kvm_arch_vcpu_ioctl_clear_reset(vcpu);

I'd probably have switched those two lines, but that's a really a
bikeshed thing :)

> +		break;
>  	case KVM_S390_INITIAL_RESET:
> -		r = kvm_arch_vcpu_ioctl_initial_reset(vcpu);
> +		r = 0;
> +		kvm_arch_vcpu_ioctl_initial_reset(vcpu);
> +		break;
> +	case KVM_S390_NORMAL_RESET:
> +		r = 0;
> +		kvm_arch_vcpu_ioctl_normal_reset(vcpu);
>  		break;
>  	case KVM_SET_ONE_REG:
>  	case KVM_GET_ONE_REG: {

With the comment removed,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4B6136EE8
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 15:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgAJOCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 09:02:52 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45910 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726387AbgAJOCv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jan 2020 09:02:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578664970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Ks4jaOFI+hDvByk1zB8wXe4w+A95wWGsZALSmwo7SE=;
        b=TqDfC1ugam15xa2FAlLxUHqgD3l84sgize7OBpwWcZ0F9SS6YBd9FyVtbDD5UsOi3iVute
        iCxaa8RYYRiO5+Ma69rtD1yLngDbqttsUM8Fzvo7cx7H6uyFWBVJpt710pMmdOGMVIRUZJ
        vz3EE9W3H/SQf/tvHdegwd0Zn21URyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-gXCo2IavPOKzWQFXPWDP_w-1; Fri, 10 Jan 2020 09:02:47 -0500
X-MC-Unique: gXCo2IavPOKzWQFXPWDP_w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FA7CDB22;
        Fri, 10 Jan 2020 14:02:46 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED05C86CCE;
        Fri, 10 Jan 2020 14:02:42 +0000 (UTC)
Date:   Fri, 10 Jan 2020 15:01:58 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [PATCH] KVM: s390: Cleanup initial cpu reset
Message-ID: <20200110150158.36ded698.cohuck@redhat.com>
In-Reply-To: <20200110134824.37963-1-frankja@linux.ibm.com>
References: <b01c38bf-5887-25d8-b787-271e5c2292e2@redhat.com>
        <20200110134824.37963-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Jan 2020 08:48:24 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> The code seems to be quite old and uses lots of unneeded spaces for
> alignment, which doesn't really help with readability.
> 
> Let's:
> * Get rid of the extra spaces
> * Remove the ULs as they are not needed on 0s
> * Define constants for the CR 0 and 14 initial values
> * Use the sizeof of the gcr array to memset it to 0
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
> 
> Something like this?

+1, like.

> Did I forget something?
> 
> ---
>  arch/s390/include/asm/kvm_host.h |  5 +++++
>  arch/s390/kvm/kvm-s390.c         | 18 +++++++-----------
>  2 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 02f4c21c57f6..37747db884bd 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -122,6 +122,11 @@ struct mcck_volatile_info {
>  	__u32 reserved;
>  };
>  
> +#define CR0_INITIAL (CR0_UNUSED_56 | CR0_INTERRUPT_KEY_SUBMASK | \
> +		     CR0_MEASUREMENT_ALERT_SUBMASK)
> +#define CR14_INITIAL (CR14_UNUSED_32 | CR14_UNUSED_33 | \
> +		      CR14_EXTERNAL_DAMAGE_SUBMASK)

Maybe CR<n>_INITIAL_MASK?

> +
>  #define CPUSTAT_STOPPED    0x80000000
>  #define CPUSTAT_WAIT       0x10000000
>  #define CPUSTAT_ECALL_PEND 0x08000000
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d9e6bf3d54f0..c163311e7f3d 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2847,19 +2847,15 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
>  {
>  	/* this equals initial cpu reset in pop, but we don't switch to ESA */
> -	vcpu->arch.sie_block->gpsw.mask = 0UL;
> -	vcpu->arch.sie_block->gpsw.addr = 0UL;
> +	vcpu->arch.sie_block->gpsw.mask = 0;
> +	vcpu->arch.sie_block->gpsw.addr = 0;
>  	kvm_s390_set_prefix(vcpu, 0);
>  	kvm_s390_set_cpu_timer(vcpu, 0);
> -	vcpu->arch.sie_block->ckc       = 0UL;
> -	vcpu->arch.sie_block->todpr     = 0;
> -	memset(vcpu->arch.sie_block->gcr, 0, 16 * sizeof(__u64));
> -	vcpu->arch.sie_block->gcr[0]  = CR0_UNUSED_56 |
> -					CR0_INTERRUPT_KEY_SUBMASK |
> -					CR0_MEASUREMENT_ALERT_SUBMASK;
> -	vcpu->arch.sie_block->gcr[14] = CR14_UNUSED_32 |
> -					CR14_UNUSED_33 |
> -					CR14_EXTERNAL_DAMAGE_SUBMASK;
> +	vcpu->arch.sie_block->ckc = 0;
> +	vcpu->arch.sie_block->todpr = 0;
> +	memset(vcpu->arch.sie_block->gcr, 0, sizeof(vcpu->arch.sie_block->gcr));
> +	vcpu->arch.sie_block->gcr[0] = CR0_INITIAL;
> +	vcpu->arch.sie_block->gcr[14] = CR14_INITIAL;
>  	/* make sure the new fpc will be lazily loaded */
>  	save_fpu_regs();
>  	current->thread.fpu.fpc = 0;

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


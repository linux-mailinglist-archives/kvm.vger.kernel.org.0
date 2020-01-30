Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 131BA14D80F
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 10:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgA3JAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 04:00:44 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37954 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726865AbgA3JAo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 04:00:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580374843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=VpabKsHBnueYgPZXbl+1Nx+nzN84UYT1WlPVpGqgtWY=;
        b=VWku9FaASFhtCYfLe38SFsfee2Uhx++0zdKu0eUDxQFSiwqnNVN9v+vJ/0Z0SZrrR0VrON
        Dd3K1q1w/gBXWzWg/CJnEa4AS6dnICQV5ZliBK643Lc9dV60Ga7ejrQD0RT4sJV/1BaG/t
        i0G05p9Z0ZQFbpiznCPs367ridE2jzc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-YYc8KxXzOziX97RBcxbPIA-1; Thu, 30 Jan 2020 04:00:39 -0500
X-MC-Unique: YYc8KxXzOziX97RBcxbPIA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA66B477;
        Thu, 30 Jan 2020 09:00:37 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-117.ams2.redhat.com [10.36.117.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5D6377921;
        Thu, 30 Jan 2020 09:00:33 +0000 (UTC)
Subject: Re: [PATCH v8 1/4] KVM: s390: Add new reset vcpu API
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20200129200312.3200-1-frankja@linux.ibm.com>
 <20200129200312.3200-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6db0a9db-db80-d9dd-f943-5fa45bc145bb@redhat.com>
Date:   Thu, 30 Jan 2020 10:00:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200129200312.3200-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/01/2020 21.03, Janosch Frank wrote:
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
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  Documentation/virt/kvm/api.txt |  43 ++++++++++++++
>  arch/s390/kvm/kvm-s390.c       | 103 +++++++++++++++++++++++----------
>  include/uapi/linux/kvm.h       |   5 ++
>  3 files changed, 122 insertions(+), 29 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index ebb37b34dcfc..73448764f544 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -4168,6 +4168,42 @@ This ioctl issues an ultravisor call to terminate the secure guest,
>  unpins the VPA pages and releases all the device pages that are used to
>  track the secure pages by hypervisor.
>  
> +4.122 KVM_S390_NORMAL_RESET
> +
> +Capability: KVM_CAP_S390_VCPU_RESETS
> +Architectures: s390
> +Type: vcpu ioctl
> +Parameters: none
> +Returns: 0
> +
> +This ioctl resets VCPU registers and control structures according to
> +the cpu reset definition in the POP (Principles Of Operation).
> +
> +4.123 KVM_S390_INITIAL_RESET
> +
> +Capability: none
> +Architectures: s390
> +Type: vcpu ioctl
> +Parameters: none
> +Returns: 0
> +
> +This ioctl resets VCPU registers and control structures according to
> +the initial cpu reset definition in the POP. However, the cpu is not
> +put into ESA mode. This reset is a superset of the normal reset.
> +
> +4.124 KVM_S390_CLEAR_RESET
> +
> +Capability: KVM_CAP_S390_VCPU_RESETS
> +Architectures: s390
> +Type: vcpu ioctl
> +Parameters: none
> +Returns: 0
> +
> +This ioctl resets VCPU registers and control structures according to
> +the clear cpu reset definition in the POP. However, the cpu is not put
> +into ESA mode. This reset is a superset of the initial reset.
> +
> +
>  5. The kvm_run structure
>  ------------------------
>  
> @@ -5396,3 +5432,10 @@ handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
>  flush hypercalls by Hyper-V) so userspace should disable KVM identification
>  in CPUID and only exposes Hyper-V identification. In this case, guest
>  thinks it's running on Hyper-V and only use Hyper-V hypercalls.
> +
> +8.22 KVM_CAP_S390_VCPU_RESETS
> +
> +Architectures: s390
> +
> +This capability indicates that the KVM_S390_NORMAL_RESET and
> +KVM_S390_CLEAR_RESET ioctls are available.
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index c5f520de39a6..6aebaf08db64 100644
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
> @@ -2844,31 +2845,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  
>  }
>  
> -static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
> -{
> -	/* this equals initial cpu reset in pop, but we don't switch to ESA */
> -	vcpu->arch.sie_block->gpsw.mask = 0;
> -	vcpu->arch.sie_block->gpsw.addr = 0;
> -	kvm_s390_set_prefix(vcpu, 0);
> -	kvm_s390_set_cpu_timer(vcpu, 0);
> -	vcpu->arch.sie_block->ckc = 0;
> -	vcpu->arch.sie_block->todpr = 0;
> -	memset(vcpu->arch.sie_block->gcr, 0, sizeof(vcpu->arch.sie_block->gcr));
> -	vcpu->arch.sie_block->gcr[0] = CR0_INITIAL_MASK;
> -	vcpu->arch.sie_block->gcr[14] = CR14_INITIAL_MASK;
> -	/* make sure the new fpc will be lazily loaded */
> -	save_fpu_regs();
> -	current->thread.fpu.fpc = 0;
> -	vcpu->arch.sie_block->gbea = 1;
> -	vcpu->arch.sie_block->pp = 0;
> -	vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
> -	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
> -	kvm_clear_async_pf_completion_queue(vcpu);
> -	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
> -		kvm_s390_vcpu_stop(vcpu);
> -	kvm_s390_clear_local_irqs(vcpu);
> -}
> -
>  void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  {
>  	mutex_lock(&vcpu->kvm->lock);
> @@ -3283,10 +3259,70 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
>  	return r;
>  }
>  
> -static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
> +static void kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
>  {
> -	kvm_s390_vcpu_initial_reset(vcpu);
> -	return 0;
> +	vcpu->arch.sie_block->gpsw.mask &= ~PSW_MASK_RI;
> +	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
> +	memset(vcpu->run->s.regs.riccb, 0, sizeof(vcpu->run->s.regs.riccb));
> +
> +	kvm_clear_async_pf_completion_queue(vcpu);
> +	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
> +		kvm_s390_vcpu_stop(vcpu);
> +	kvm_s390_clear_local_irqs(vcpu);
> +}
> +
> +static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
> +{
> +	/* Initial reset is a superset of the normal reset */
> +	kvm_arch_vcpu_ioctl_normal_reset(vcpu);
> +
> +	/* this equals initial cpu reset in pop, but we don't switch to ESA */
> +	vcpu->arch.sie_block->gpsw.mask = 0;
> +	vcpu->arch.sie_block->gpsw.addr = 0;
> +	kvm_s390_set_prefix(vcpu, 0);
> +	kvm_s390_set_cpu_timer(vcpu, 0);
> +	vcpu->arch.sie_block->ckc = 0;
> +	vcpu->arch.sie_block->todpr = 0;
> +	memset(vcpu->arch.sie_block->gcr, 0, sizeof(vcpu->arch.sie_block->gcr));
> +	vcpu->arch.sie_block->gcr[0] = CR0_INITIAL_MASK;
> +	vcpu->arch.sie_block->gcr[14] = CR14_INITIAL_MASK;

Is your "KVM: s390: Cleanup initial cpu reset" patch already queued
somewhere? If not, please add it to this series so that it is clear
where the CR*_INITIAL_MASK macros come from.

Apart from that (and the save_fpu_regs() problem that should be fixed
first), the patch looks fine to me now.

 Thomas


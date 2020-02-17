Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E3F161077
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 11:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgBQK5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 05:57:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55812 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727503AbgBQK5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 05:57:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581937033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=0Scpa3b0TzPivhBJvorpeAnXyDU/GJd07Htz7fcMK+E=;
        b=cF8GR/Frtg5uGYmoiXOjWypsD0gPbvF9jxrGJvwYIungS3gcyVh8CoqYqAGtZAMJQtpdbS
        ibghh/R+fIMzuX725ePfPmR7BoFfoK8ud/agldukAYZPMoRZc3Rgii0PiF1xWGNDKlgRBb
        XBlWglXd3+pX4DKD2r4VCdV6IHTj67k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-5CQTUQieN6aW3uH9T3uWiA-1; Mon, 17 Feb 2020 05:57:08 -0500
X-MC-Unique: 5CQTUQieN6aW3uH9T3uWiA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9CE21005512;
        Mon, 17 Feb 2020 10:57:06 +0000 (UTC)
Received: from [10.36.117.64] (ovpn-117-64.ams2.redhat.com [10.36.117.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6BFC5C100;
        Mon, 17 Feb 2020 10:56:59 +0000 (UTC)
Subject: Re: [PATCH v2 09/42] KVM: s390: protvirt: Add initial vm and cpu
 lifecycle handling
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-10-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <9cac0f98-e593-b6ae-9d53-d3c77ea090a1@redhat.com>
Date:   Mon, 17 Feb 2020 11:56:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214222658.12946-10-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[...]
> =20
> +static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> +{
> +	int r =3D 0;
> +	void __user *argp =3D (void __user *)cmd->data;
> +
> +	switch (cmd->cmd) {
> +	case KVM_PV_VM_CREATE: {
> +		r =3D -EINVAL;
> +		if (kvm_s390_pv_is_protected(kvm))
> +			break;

Isn't this racy? I think there has to be a way to make sure the PV state
can't change. Is there any and I am missing something obvious? (is
suspect we need the kvm->lock)

> +
> +		r =3D kvm_s390_pv_alloc_vm(kvm);
> +		if (r)
> +			break;
> +
> +		mutex_lock(&kvm->lock);
> +		kvm_s390_vcpu_block_all(kvm);
> +		/* FMT 4 SIE needs esca */
> +		r =3D sca_switch_to_extended(kvm);
> +		if (r) {
> +			kvm_s390_pv_dealloc_vm(kvm);
> +			kvm_s390_vcpu_unblock_all(kvm);
> +			mutex_unlock(&kvm->lock);
> +			break;
> +		}
> +		r =3D kvm_s390_pv_create_vm(kvm, &cmd->rc, &cmd->rrc);
> +		kvm_s390_vcpu_unblock_all(kvm);
> +		mutex_unlock(&kvm->lock);
> +		break;
> +	}
> +	case KVM_PV_VM_DESTROY: {
> +		r =3D -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm))
> +			break;
> +

dito

> +		/* All VCPUs have to be destroyed before this call. */
> +		mutex_lock(&kvm->lock);
> +		kvm_s390_vcpu_block_all(kvm);
> +		r =3D kvm_s390_pv_destroy_vm(kvm, &cmd->rc, &cmd->rrc);
> +		if (!r)
> +			kvm_s390_pv_dealloc_vm(kvm);
> +		kvm_s390_vcpu_unblock_all(kvm);
> +		mutex_unlock(&kvm->lock);
> +		break;
> +	}
> +	case KVM_PV_VM_SET_SEC_PARMS: {

I'd name this "KVM_PV_VM_SET_PARMS" instead.

> +		struct kvm_s390_pv_sec_parm parms =3D {};
> +		void *hdr;
> +
> +		r =3D -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm))
> +			break;
> +

dito

> +		r =3D -EFAULT;
> +		if (copy_from_user(&parms, argp, sizeof(parms)))
> +			break;
> +
> +		/* Currently restricted to 8KB */
> +		r =3D -EINVAL;
> +		if (parms.length > PAGE_SIZE * 2)
> +			break;
> +
> +		r =3D -ENOMEM;
> +		hdr =3D vmalloc(parms.length);
> +		if (!hdr)
> +			break;
> +
> +		r =3D -EFAULT;
> +		if (!copy_from_user(hdr, (void __user *)parms.origin,
> +				    parms.length))
> +			r =3D kvm_s390_pv_set_sec_parms(kvm, hdr, parms.length,
> +						      &cmd->rc, &cmd->rrc);
> +
> +		vfree(hdr);
> +		break;
> +	}
> +	case KVM_PV_VM_UNPACK: {
> +		struct kvm_s390_pv_unp unp =3D {};
> +
> +		r =3D -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm))
> +			break;
> +

dito

> +		r =3D -EFAULT;
> +		if (copy_from_user(&unp, argp, sizeof(unp)))
> +			break;
> +
> +		r =3D kvm_s390_pv_unpack(kvm, unp.addr, unp.size, unp.tweak,
> +				       &cmd->rc, &cmd->rrc);
> +		break;
> +	}
> +	case KVM_PV_VM_VERIFY: {
> +		r =3D -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm))> +			break;

dito

> +
> +		r =3D uv_cmd_nodata(kvm_s390_pv_handle(kvm),
> +				  UVC_CMD_VERIFY_IMG, &cmd->rc, &cmd->rrc);
> +		KVM_UV_EVENT(kvm, 3, "PROTVIRT VERIFY: rc %x rrc %x", cmd->rc,
> +			     cmd->rrc);
> +		break;
> +	}
> +	default:
> +		return -ENOTTY;
> +	}
> +	return r;
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>  		       unsigned int ioctl, unsigned long arg)
>  {
> @@ -2262,6 +2376,25 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		mutex_unlock(&kvm->slots_lock);
>  		break;
>  	}
> +	case KVM_S390_PV_COMMAND: {
> +		struct kvm_pv_cmd args;
> +
> +		r =3D 0;
> +		if (!is_prot_virt_host()) {
> +			r =3D -EINVAL;
> +			break;
> +		}
> +		if (copy_from_user(&args, argp, sizeof(args))) {
> +			r =3D -EFAULT;
> +			break;
> +		}
> +		r =3D kvm_s390_handle_pv(kvm, &args);
> +		if (copy_to_user(argp, &args, sizeof(args))) {
> +			r =3D -EFAULT;
> +			break;
> +		}
> +		break;
> +	}
>  	default:
>  		r =3D -ENOTTY;
>  	}
> @@ -2525,6 +2658,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lo=
ng type)
> =20
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
> +	u16 rc, rrc;
> +
>  	VCPU_EVENT(vcpu, 3, "%s", "free cpu");
>  	trace_kvm_s390_destroy_vcpu(vcpu->vcpu_id);
>  	kvm_s390_clear_local_irqs(vcpu);
> @@ -2537,6 +2672,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> =20
>  	if (vcpu->kvm->arch.use_cmma)
>  		kvm_s390_vcpu_unsetup_cmma(vcpu);
> +	if (kvm_s390_pv_handle_cpu(vcpu))
> +		kvm_s390_pv_destroy_cpu(vcpu, &rc, &rrc);
>  	free_page((unsigned long)(vcpu->arch.sie_block));
>  }
> =20
> @@ -2558,10 +2695,15 @@ static void kvm_free_vcpus(struct kvm *kvm)
> =20
>  void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
> +	u16 rc, rrc;
>  	kvm_free_vcpus(kvm);
>  	sca_dispose(kvm);
> -	debug_unregister(kvm->arch.dbf);
>  	kvm_s390_gisa_destroy(kvm);
> +	if (kvm_s390_pv_is_protected(kvm)) {
> +		kvm_s390_pv_destroy_vm(kvm, &rc, &rrc);
> +		kvm_s390_pv_dealloc_vm(kvm);
> +	}
> +	debug_unregister(kvm->arch.dbf);
>  	free_page((unsigned long)kvm->arch.sie_page2);
>  	if (!kvm_is_ucontrol(kvm))
>  		gmap_remove(kvm->arch.gmap);
> @@ -2657,6 +2799,9 @@ static int sca_switch_to_extended(struct kvm *kvm=
)
>  	unsigned int vcpu_idx;
>  	u32 scaol, scaoh;
> =20
> +	if (kvm->arch.use_esca)
> +		return 0;
> +
>  	new_sca =3D alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL|__GFP_ZERO=
);
>  	if (!new_sca)
>  		return -ENOMEM;
> @@ -2908,6 +3053,7 @@ static void kvm_s390_vcpu_setup_model(struct kvm_=
vcpu *vcpu)
>  static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>  {
>  	int rc =3D 0;
> +	u16 uvrc, uvrrc;
> =20
>  	atomic_set(&vcpu->arch.sie_block->cpuflags, CPUSTAT_ZARCH |
>  						    CPUSTAT_SM |
> @@ -2975,6 +3121,9 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *v=
cpu)
> =20
>  	kvm_s390_vcpu_crypto_setup(vcpu);
> =20
> +	if (kvm_s390_pv_is_protected(vcpu->kvm))
> +		rc =3D kvm_s390_pv_create_cpu(vcpu, &uvrc, &uvrrc);

With an explicit KVM_PV_VCPU_CREATE, this does not belong here. When
hotplugging CPUs, user space has to do that manually. But as I said
already, this user space API could be improved. (below)

> +
>  	return rc;
>  }
> =20
> @@ -4352,6 +4501,38 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp=
,
>  	return -ENOIOCTLCMD;
>  }
> =20
> +static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu *vcpu,
> +				   struct kvm_pv_cmd *cmd)
> +{
> +	int r =3D 0;
> +
> +	if (!kvm_s390_pv_is_protected(vcpu->kvm))
> +		return -EINVAL;
> +
> +	if (cmd->flags)
> +		return -EINVAL;
> +
> +	switch (cmd->cmd) {
> +	case KVM_PV_VCPU_CREATE: {
> +		if (kvm_s390_pv_handle_cpu(vcpu))
> +			return -EINVAL;
> +
> +		r =3D kvm_s390_pv_create_cpu(vcpu, &cmd->rc, &cmd->rrc);
> +		break;
> +	}
> +	case KVM_PV_VCPU_DESTROY: {
> +		if (!kvm_s390_pv_handle_cpu(vcpu))
> +			return -EINVAL;
> +
> +		r =3D kvm_s390_pv_destroy_cpu(vcpu, &cmd->rc, &cmd->rrc);
> +		break;
> +	}
> +	default:
> +		r =3D -ENOTTY;
> +	}
> +	return r;
> +}
> +
>  long kvm_arch_vcpu_ioctl(struct file *filp,
>  			 unsigned int ioctl, unsigned long arg)
>  {
> @@ -4493,6 +4674,25 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  					   irq_state.len);
>  		break;
>  	}
> +	case KVM_S390_PV_COMMAND_VCPU: {
> +		struct kvm_pv_cmd args;
> +
> +		r =3D 0;
> +		if (!is_prot_virt_host()) {
> +			r =3D -EINVAL;
> +			break;
> +		}
> +		if (copy_from_user(&args, argp, sizeof(args))) {
> +			r =3D -EFAULT;
> +			break;
> +		}
> +		r =3D kvm_s390_handle_pv_vcpu(vcpu, &args);
> +		if (copy_to_user(argp, &args, sizeof(args))) {
> +			r =3D -EFAULT;
> +			break;
> +		}
> +		break;
> +	}
>  	default:
>  		r =3D -ENOTTY;


Can we please discuss why we can't

- Get rid of KVM_S390_PV_COMMAND_VCPU
- Do the allocation in KVM_PV_VM_CREATE
- Rename KVM_PV_VM_CREATE -> KVM_PV_ENABLE
- Rename KVM_PV_VM_DESTROY -> KVM_PV_DISABLE

This user space API is unnecessary complicated and confusing.

--=20
Thanks,

David / dhildenb


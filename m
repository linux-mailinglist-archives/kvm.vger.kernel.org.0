Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A97616FEED
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 13:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgBZM04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 07:26:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32641 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726579AbgBZM04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 07:26:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582720014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QWhxHToUIqEcThcdCcjqKvcJE1lo575pzZryC31y0DU=;
        b=RAdBfUyBxjnBfpyfTcegfVH4Wlw6CRxY9Lf7CRUPTlgtPTzoXVzWmba/UrlxeyrrS0qfql
        SZR+sKVojGdKkIdjnMHhRoQaevUpl1AAoCuTrcyXw2QgiqAdprI/eb2AeBOo6TSLWqANS0
        wcvSIH/mYLs2vU1G4gDBaBIM1KX5zJM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-_IgPqQmMMwqpVC4MkGmX_g-1; Wed, 26 Feb 2020 07:26:50 -0500
X-MC-Unique: _IgPqQmMMwqpVC4MkGmX_g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AED63DBA3;
        Wed, 26 Feb 2020 12:26:48 +0000 (UTC)
Received: from gondolin (ovpn-117-69.ams2.redhat.com [10.36.117.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 057858C06A;
        Wed, 26 Feb 2020 12:26:43 +0000 (UTC)
Date:   Wed, 26 Feb 2020 13:26:40 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     david@redhat.com, Ulrich.Weigand@de.ibm.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH v4.5 09/36] KVM: s390: protvirt: Add initial vm and cpu
 lifecycle handling
Message-ID: <20200226132640.36c32fd3.cohuck@redhat.com>
In-Reply-To: <20200225214822.3611-1-borntraeger@de.ibm.com>
References: <f80a0b58-5ed2-33b7-5292-2c4899d765b7@redhat.com>
        <20200225214822.3611-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 16:48:22 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> This contains 3 main changes:
> 1. changes in SIE control block handling for secure guests
> 2. helper functions for create/destroy/unpack secure guests
> 3. KVM_S390_PV_COMMAND ioctl to allow userspace dealing with secure
> machines
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  24 ++-
>  arch/s390/include/asm/uv.h       |  69 ++++++++
>  arch/s390/kvm/Makefile           |   2 +-
>  arch/s390/kvm/kvm-s390.c         | 209 +++++++++++++++++++++++-
>  arch/s390/kvm/kvm-s390.h         |  33 ++++
>  arch/s390/kvm/pv.c               | 269 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h         |  31 ++++
>  7 files changed, 633 insertions(+), 4 deletions(-)
>  create mode 100644 arch/s390/kvm/pv.c

(...)

> +static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> +{
> +	int r = 0;
> +	u16 dummy;
> +	void __user *argp = (void __user *)cmd->data;
> +
> +	switch (cmd->cmd) {
> +	case KVM_PV_ENABLE: {
> +		r = -EINVAL;
> +		if (kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		/*
> +		 *  FMT 4 SIE needs esca. As we never switch back to bsca from
> +		 *  esca, we need no cleanup in the error cases below
> +		 */
> +		r = sca_switch_to_extended(kvm);
> +		if (r)
> +			break;
> +
> +		r = kvm_s390_pv_init_vm(kvm, &cmd->rc, &cmd->rrc);
> +		if (r)
> +			break;
> +
> +		r = kvm_s390_cpus_to_pv(kvm, &cmd->rc, &cmd->rrc);
> +		if (r)
> +			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
> +		break;
> +	}
> +	case KVM_PV_DISABLE: {
> +		r = -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		r = kvm_s390_cpus_from_pv(kvm, &cmd->rc, &cmd->rrc);
> +		/*
> +		 * If a CPU could not be destroyed, destroy VM will also fail.
> +		 * There is no point in trying to destroy it. Instead return
> +		 * the rc and rrc from the first CPU that failed destroying.
> +		 */
> +		if (r)
> +			break;
> +		r = kvm_s390_pv_deinit_vm(kvm, &cmd->rc, &cmd->rrc);
> +		break;
> +	}

IIUC, we may end up in an odd state in the failure case, because we
might not be able to free up the donated memory, depending on what goes
wrong. Can userspace do anything useful with the vm if that happens?

Even more important, userspace cannot cause repeated donations by
repeatedly calling this ioctl, right?

> +	case KVM_PV_SET_SEC_PARMS: {
> +		struct kvm_s390_pv_sec_parm parms = {};
> +		void *hdr;
> +
> +		r = -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&parms, argp, sizeof(parms)))
> +			break;
> +
> +		/* Currently restricted to 8KB */
> +		r = -EINVAL;
> +		if (parms.length > PAGE_SIZE * 2)
> +			break;
> +
> +		r = -ENOMEM;
> +		hdr = vmalloc(parms.length);
> +		if (!hdr)
> +			break;
> +
> +		r = -EFAULT;
> +		if (!copy_from_user(hdr, (void __user *)parms.origin,
> +				    parms.length))
> +			r = kvm_s390_pv_set_sec_parms(kvm, hdr, parms.length,
> +						      &cmd->rc, &cmd->rrc);
> +
> +		vfree(hdr);
> +		break;
> +	}
> +	case KVM_PV_UNPACK: {
> +		struct kvm_s390_pv_unp unp = {};
> +
> +		r = -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&unp, argp, sizeof(unp)))
> +			break;
> +
> +		r = kvm_s390_pv_unpack(kvm, unp.addr, unp.size, unp.tweak,
> +				       &cmd->rc, &cmd->rrc);
> +		break;
> +	}
> +	case KVM_PV_VERIFY: {
> +		r = -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		r = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
> +				  UVC_CMD_VERIFY_IMG, &cmd->rc, &cmd->rrc);
> +		KVM_UV_EVENT(kvm, 3, "PROTVIRT VERIFY: rc %x rrc %x", cmd->rc,
> +			     cmd->rrc);
> +		break;
> +	}
> +	default:
> +		return -ENOTTY;

Nit: why not r = -ENOTTY, so you get a single exit point?

> +	}
> +	return r;
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>  		       unsigned int ioctl, unsigned long arg)
>  {
> @@ -2262,6 +2419,27 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		mutex_unlock(&kvm->slots_lock);
>  		break;
>  	}
> +	case KVM_S390_PV_COMMAND: {
> +		struct kvm_pv_cmd args;
> +
> +		r = 0;
> +		if (!is_prot_virt_host()) {
> +			r = -EINVAL;
> +			break;
> +		}
> +		if (copy_from_user(&args, argp, sizeof(args))) {
> +			r = -EFAULT;
> +			break;
> +		}

The api states that args.flags must be 0... better enforce that?

> +		mutex_lock(&kvm->lock);
> +		r = kvm_s390_handle_pv(kvm, &args);
> +		mutex_unlock(&kvm->lock);
> +		if (copy_to_user(argp, &args, sizeof(args))) {
> +			r = -EFAULT;
> +			break;
> +		}
> +		break;
> +	}
>  	default:
>  		r = -ENOTTY;
>  	}

(...)

> @@ -2558,10 +2741,19 @@ static void kvm_free_vcpus(struct kvm *kvm)
>  
>  void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
> +	u16 rc, rrc;

Nit: missing empty line.

>  	kvm_free_vcpus(kvm);
>  	sca_dispose(kvm);
> -	debug_unregister(kvm->arch.dbf);
>  	kvm_s390_gisa_destroy(kvm);
> +	/*
> +	 * We are already at the end of life and kvm->lock is not taken.
> +	 * This is ok as the file descriptor is closed by now and nobody
> +	 * can mess with the pv state. To avoid lockdep_assert_held from
> +	 * complaining we do not use kvm_s390_pv_is_protected.
> +	 */
> +	if (kvm_s390_pv_get_handle(kvm))
> +		kvm_s390_pv_deinit_vm(kvm, &rc, &rrc);
> +	debug_unregister(kvm->arch.dbf);
>  	free_page((unsigned long)kvm->arch.sie_page2);
>  	if (!kvm_is_ucontrol(kvm))
>  		gmap_remove(kvm->arch.gmap);

(...)

> @@ -4540,6 +4744,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	if (mem->guest_phys_addr + mem->memory_size > kvm->arch.mem_limit)
>  		return -EINVAL;
>  
> +	/* When we are protected we should not change the memory slots */

s/protected/protected,/

> +	if (kvm_s390_pv_is_protected(kvm))
> +		return -EINVAL;
>  	return 0;
>  }
>  

(...)

> +static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
> +{
> +	unsigned long base = uv_info.guest_base_stor_len;
> +	unsigned long virt = uv_info.guest_virt_var_stor_len;

base_len and virt_len? Makes the code below less confusing.

> +	unsigned long npages = 0, vlen = 0;
> +	struct kvm_memory_slot *memslot;
> +
> +	kvm->arch.pv.stor_var = NULL;
> +	kvm->arch.pv.stor_base = __get_free_pages(GFP_KERNEL, get_order(base));
> +	if (!kvm->arch.pv.stor_base)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Calculate current guest storage for allocation of the
> +	 * variable storage, which is based on the length in MB.
> +	 *
> +	 * Slots are sorted by GFN
> +	 */
> +	mutex_lock(&kvm->slots_lock);
> +	memslot = kvm_memslots(kvm)->memslots;
> +	npages = memslot->base_gfn + memslot->npages;
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	kvm->arch.pv.guest_len = npages * PAGE_SIZE;
> +
> +	/* Allocate variable storage */
> +	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
> +	vlen += uv_info.guest_virt_base_stor_len;
> +	kvm->arch.pv.stor_var = vzalloc(vlen);
> +	if (!kvm->arch.pv.stor_var)
> +		goto out_err;
> +	return 0;
> +
> +out_err:
> +	kvm_s390_pv_dealloc_vm(kvm);
> +	return -ENOMEM;
> +}
> +
> +/* this should not fail, but if it does we must not free the donated memory */

s/does/does,/

> +int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> +{
> +	int cc;
> +
> +	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
> +			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
> +	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
> +	atomic_set(&kvm->mm->context.is_protected, 0);
> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
> +	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
> +	/* Inteded memory leak on "impossible" error */
> +	if (!cc)
> +		kvm_s390_pv_dealloc_vm(kvm);
> +	return cc ? -EIO : 0;
> +}

(...)

> +struct kvm_pv_cmd {
> +	__u32 cmd;	/* Command to be executed */
> +	__u16 rc;	/* Ultravisor return code */
> +	__u16 rrc;	/* Ultravisor return reason code */
> +	__u64 data;	/* Data or address */
> +	__u32 flags;    /* flags for future extensions. Must be 0 for now */
> +	__u32 reserved[3];
> +};
> +
> +/* Available with KVM_CAP_S390_PROTECTED */
> +#define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
> +
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
>  	/* Guest initialization commands */


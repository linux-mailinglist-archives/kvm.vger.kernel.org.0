Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5CA528110
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 11:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbiEPJwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 05:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239666AbiEPJwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 05:52:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C6FF9FE0
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 02:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652694727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XtXjZxXWFDdtLIyrTlAqPCm9pGQekq0cADtQFNExb48=;
        b=ZkHgg4YVGcTuh45U+cibcSIiM+Mi0QTU2B5zxl7Ti7/80E/7EelMlfkT7Ta9hM3uh5JWNX
        +kPLxFvZSQCQDz9tGbpZWaa3jKQzt9dzjjdbtY6A5ywQ8XH751I0ko9O6mXtPLXNL72pPg
        LuIadgmwLM+M0Fq8lHFLI036LcRDnkQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-PHGuYsTUP7SUcc73322AgA-1; Mon, 16 May 2022 05:52:04 -0400
X-MC-Unique: PHGuYsTUP7SUcc73322AgA-1
Received: by mail-wm1-f71.google.com with SMTP id bg7-20020a05600c3c8700b0039468585269so6515326wmb.3
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 02:52:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=XtXjZxXWFDdtLIyrTlAqPCm9pGQekq0cADtQFNExb48=;
        b=qDVqlbNWNL/nsmUNm2OaM1e+NmHoLCPXEpocFGgB/ZvKBWBUuaWPEL2n1MypjpRr03
         XjLEE/vw4Y99WSzrH9Aaqz8v/iAEYfl1+W9Ns3HI1jfJnwaIPPJxDWnMpHLjN+OKHJM8
         0xwmi+cUYNpAPBC+3VKVF7JmGS+FmXITe+wwAEXUnI0Wjt05/32+eUJKwwEm72ummbih
         H4pw6BGBwrxA+wciTTyxKGmFgoTSIyX7R9QS04yFcWHM3gkB2/P3QYbZyaF+JylzfOBo
         5jLzblIZ4QOb1ZRgg42Z/NWCeYwGZGKUDsrYsyxlSJuMk29in59zyIObuwSTU3IvoDQ5
         AGdg==
X-Gm-Message-State: AOAM533BUcJv/NaTeD8aiwg0CDs/1NRRru2Itrj0a1UPKYD94oQlLJWH
        XNbhOCIF8LMeT7YLv+buaF8+p5wrnuqiQTz+2nRqShVycgCVjz7ZCUQJOMSH3GE6KOQORniY1Ra
        puB/+Gnm+oVAK
X-Received: by 2002:a5d:6483:0:b0:20c:5c21:5c8c with SMTP id o3-20020a5d6483000000b0020c5c215c8cmr13442454wri.86.1652694722896;
        Mon, 16 May 2022 02:52:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyC41wL9nhYxHtHMa52PW/vx0YnI9nXC+FM8fS+8Br7469FFpyJcGexaoWXlNdGCsjbLx1f5g==
X-Received: by 2002:a5d:6483:0:b0:20c:5c21:5c8c with SMTP id o3-20020a5d6483000000b0020c5c215c8cmr13442434wri.86.1652694722578;
        Mon, 16 May 2022 02:52:02 -0700 (PDT)
Received: from [192.168.0.2] (ip-109-43-178-142.web.vodafone.de. [109.43.178.142])
        by smtp.gmail.com with ESMTPSA id x14-20020a1c7c0e000000b003942a244f3fsm12390428wmc.24.2022.05.16.02.52.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 02:52:02 -0700 (PDT)
Message-ID: <7b13aca2-fb3e-3b84-8d3d-e94966fac5f2@redhat.com>
Date:   Mon, 16 May 2022 11:52:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
 <20220513191509.272897-21-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v7 20/22] KVM: s390: add KVM_S390_ZPCI_OP to manage guest
 zPCI devices
In-Reply-To: <20220513191509.272897-21-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/2022 21.15, Matthew Rosato wrote:
> The KVM_S390_ZPCI_OP ioctl provides a mechanism for managing
> hardware-assisted virtualization features for s390X zPCI passthrough.

s/s390X/s390x/

> Add the first 2 operations, which can be used to enable/disable
> the specified device for Adapter Event Notification interpretation.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   Documentation/virt/kvm/api.rst | 45 +++++++++++++++++++
>   arch/s390/kvm/kvm-s390.c       | 23 ++++++++++
>   arch/s390/kvm/pci.c            | 81 ++++++++++++++++++++++++++++++++++
>   arch/s390/kvm/pci.h            |  2 +
>   include/uapi/linux/kvm.h       | 31 +++++++++++++
>   5 files changed, 182 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 4a900cdbc62e..a7cd5ebce031 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5645,6 +5645,51 @@ enabled with ``arch_prctl()``, but this may change in the future.
>   The offsets of the state save areas in struct kvm_xsave follow the contents
>   of CPUID leaf 0xD on the host.
>   
> +4.135 KVM_S390_ZPCI_OP
> +--------------------
> +
> +:Capability: KVM_CAP_S390_ZPCI_OP
> +:Architectures: s390
> +:Type: vcpu ioctl

vcpu? ... you're wiring it up in  kvm_arch_vm_ioctl() later, so I assume 
it's rather a VM ioctl?

> +:Parameters: struct kvm_s390_zpci_op (in)
> +:Returns: 0 on success, <0 on error
> +
> +Used to manage hardware-assisted virtualization features for zPCI devices.
> +
> +Parameters are specified via the following structure::
> +
> +  struct kvm_s390_zpci_op {
> +	/* in */

If all is "in", why is there a copy_to_user() in the code later?

> +	__u32 fh;		/* target device */
> +	__u8  op;		/* operation to perform */
> +	__u8  pad[3];
> +	union {
> +		/* for KVM_S390_ZPCIOP_REG_AEN */
> +		struct {
> +			__u64 ibv;	/* Guest addr of interrupt bit vector */
> +			__u64 sb;	/* Guest addr of summary bit */

If this is really a vcpu ioctl, what kind of addresses are you talking about 
here? virtual addresses? real addresses? absolute addresses?

> +			__u32 flags;
> +			__u32 noi;	/* Number of interrupts */
> +			__u8 isc;	/* Guest interrupt subclass */
> +			__u8 sbo;	/* Offset of guest summary bit vector */
> +			__u16 pad;
> +		} reg_aen;
> +		__u64 reserved[8];
> +	} u;
> +  };
> +
> +The type of operation is specified in the "op" field.
> +KVM_S390_ZPCIOP_REG_AEN is used to register the VM for adapter event
> +notification interpretation, which will allow firmware delivery of adapter
> +events directly to the vm, with KVM providing a backup delivery mechanism;
> +KVM_S390_ZPCIOP_DEREG_AEN is used to subsequently disable interpretation of
> +adapter event notifications.
> +
> +The target zPCI function must also be specified via the "fh" field.  For the
> +KVM_S390_ZPCIOP_REG_AEN operation, additional information to establish firmware
> +delivery must be provided via the "reg_aen" struct.
> +
> +The "reserved" field is meant for future extensions.

Maybe also mention the "pad" fields? And add should these also be 
initialized to 0 by the calling userspace program?

>   5. The kvm_run structure
>   ========================
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index b95b25490018..1af7cea9d579 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -618,6 +618,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_S390_PROTECTED:
>   		r = is_prot_virt_host();
>   		break;
> +	case KVM_CAP_S390_ZPCI_OP:
> +		if (kvm_s390_pci_interp_allowed())
> +			r = 1;
> +		else
> +			r = 0;

Could be shortened to:

		r = kvm_s390_pci_interp_allowed();

> +		break;
>   	default:
>   		r = 0;
>   	}
> @@ -2633,6 +2639,23 @@ long kvm_arch_vm_ioctl(struct file *filp,
>   			r = -EFAULT;
>   		break;
>   	}
> +	case KVM_S390_ZPCI_OP: {
> +		struct kvm_s390_zpci_op args;
> +
> +		r = -EINVAL;
> +		if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
> +			break;
> +		if (copy_from_user(&args, argp, sizeof(args))) {
> +			r = -EFAULT;
> +			break;
> +		}
> +		r = kvm_s390_pci_zpci_op(kvm, &args);
> +		if (r)
> +			break;
> +		if (copy_to_user(argp, &args, sizeof(args)))
> +			r = -EFAULT;

So this copy_to_user() indicates that information is returned to userspace 
... but below, the ioctl is declared with _IOW only ... this does not match. 
Should it be declared with _IOWR or should the copy_to_user() be dropped?

> +		break;
> +	}
>   	default:
>   		r = -ENOTTY;
>   	}
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index 1393a1604494..6e6254016be4 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -585,6 +585,87 @@ void kvm_s390_pci_clear_list(struct kvm *kvm)
>   	spin_unlock(&kvm->arch.kzdev_list_lock);
>   }
>   
> +static struct zpci_dev *get_zdev_from_kvm_by_fh(struct kvm *kvm, u32 fh)
> +{
> +	struct zpci_dev *zdev = NULL;
> +	struct kvm_zdev *kzdev;
> +
> +	spin_lock(&kvm->arch.kzdev_list_lock);
> +	list_for_each_entry(kzdev, &kvm->arch.kzdev_list, entry) {
> +		if (kzdev->zdev->fh == fh) {
> +			zdev = kzdev->zdev;
> +			break;
> +		}
> +	}
> +	spin_unlock(&kvm->arch.kzdev_list_lock);
> +
> +	return zdev;
> +}
> +
> +static int kvm_s390_pci_zpci_reg_aen(struct zpci_dev *zdev,
> +				     struct kvm_s390_zpci_op *args)
> +{
> +	struct zpci_fib fib = {};
> +
> +	fib.fmt0.aibv = args->u.reg_aen.ibv;
> +	fib.fmt0.isc = args->u.reg_aen.isc;
> +	fib.fmt0.noi = args->u.reg_aen.noi;
> +	if (args->u.reg_aen.sb != 0) {
> +		fib.fmt0.aisb = args->u.reg_aen.sb;
> +		fib.fmt0.aisbo = args->u.reg_aen.sbo;
> +		fib.fmt0.sum = 1;
> +	} else {
> +		fib.fmt0.aisb = 0;
> +		fib.fmt0.aisbo = 0;
> +		fib.fmt0.sum = 0;
> +	}
> +
> +	if (args->u.reg_aen.flags & KVM_S390_ZPCIOP_REGAEN_HOST)
> +		return kvm_s390_pci_aif_enable(zdev, &fib, true);
> +	else
> +		return kvm_s390_pci_aif_enable(zdev, &fib, false);

Alternatively (just a matter of taste):

	bool hostflag;
	...
	hostflag = (args->u.reg_aen.flags & KVM_S390_ZPCIOP_REGAEN_HOST);
	return kvm_s390_pci_aif_enable(zdev, &fib, hostflag);

> +}
> +
> +int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args)
> +{
> +	struct kvm_zdev *kzdev;
> +	struct zpci_dev *zdev;
> +	int r;
> +
> +	zdev = get_zdev_from_kvm_by_fh(kvm, args->fh);
> +	if (!zdev)
> +		return -ENODEV;
> +
> +	mutex_lock(&zdev->kzdev_lock);
> +	mutex_lock(&kvm->lock);
> +
> +	kzdev = zdev->kzdev;
> +	if (!kzdev) {
> +		r = -ENODEV;
> +		goto out;
> +	}
> +	if (kzdev->kvm != kvm) {
> +		r = -EPERM;
> +		goto out;
> +	}
> +
> +	switch (args->op) {
> +	case KVM_S390_ZPCIOP_REG_AEN:

Please also check here that args->u.reg_aen.flags does not have any bits set 
that we don't support here (otherwise, this could cause some trouble when 
introducing additional flags later).

> +		r = kvm_s390_pci_zpci_reg_aen(zdev, args);
> +		break;
> +	case KVM_S390_ZPCIOP_DEREG_AEN:
> +		r = kvm_s390_pci_aif_disable(zdev, false);
> +		break;
> +	default:
> +		r = -EINVAL;
> +	}
> +
> +out:
> +	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&zdev->kzdev_lock);
> +	return r;
> +}
> +
>   int kvm_s390_pci_init(void)
>   {
>   	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
> index fb2b91b76e0c..0351382e990f 100644
> --- a/arch/s390/kvm/pci.h
> +++ b/arch/s390/kvm/pci.h
> @@ -59,6 +59,8 @@ void kvm_s390_pci_aen_exit(void);
>   void kvm_s390_pci_init_list(struct kvm *kvm);
>   void kvm_s390_pci_clear_list(struct kvm *kvm);
>   
> +int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args);
> +
>   int kvm_s390_pci_init(void);
>   void kvm_s390_pci_exit(void);
>   
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6a184d260c7f..1d3d41523d10 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1152,6 +1152,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_DISABLE_QUIRKS2 213
>   /* #define KVM_CAP_VM_TSC_CONTROL 214 */
>   #define KVM_CAP_SYSTEM_EVENT_DATA 215
> +#define KVM_CAP_S390_ZPCI_OP 216
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> @@ -2068,4 +2069,34 @@ struct kvm_stats_desc {
>   /* Available with KVM_CAP_XSAVE2 */
>   #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
>   
> +/* Available with KVM_CAP_S390_ZPCI_OP */
> +#define KVM_S390_ZPCI_OP	  _IOW(KVMIO,  0xd0, struct kvm_s390_zpci_op)

Please double-check whether this should be _IOWR instead (see above).

> +struct kvm_s390_zpci_op {
> +	/* in */
> +	__u32 fh;		/* target device */
> +	__u8  op;		/* operation to perform */
> +	__u8  pad[3];
> +	union {
> +		/* for KVM_S390_ZPCIOP_REG_AEN */
> +		struct {
> +			__u64 ibv;	/* Guest addr of interrupt bit vector */
> +			__u64 sb;	/* Guest addr of summary bit */
> +			__u32 flags;
> +			__u32 noi;	/* Number of interrupts */
> +			__u8 isc;	/* Guest interrupt subclass */
> +			__u8 sbo;	/* Offset of guest summary bit vector */
> +			__u16 pad;
> +		} reg_aen;
> +		__u64 reserved[8];
> +	} u;
> +};
> +
> +/* types for kvm_s390_zpci_op->op */
> +#define KVM_S390_ZPCIOP_REG_AEN		0
> +#define KVM_S390_ZPCIOP_DEREG_AEN	1
> +
> +/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
> +#define KVM_S390_ZPCIOP_REGAEN_HOST	(1 << 0)
> +
>   #endif /* __LINUX_KVM_H */

  Thomas


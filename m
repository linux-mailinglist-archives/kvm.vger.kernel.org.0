Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE0C7B2865
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 00:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbjI1WXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 18:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbjI1WXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 18:23:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEA4CC4
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 15:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695939703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mFHyzwss0VIynmY6kq9IQqsmynTMCUyfW9NTpB4UhBc=;
        b=f+m1TfsdGmzdcATD1igpfaixeNlJMr8Z4zzvHvDqJPwuD+uEW+6dfPZrdfRCMs05CbmGXH
        kKVwQnjfGG7/tkRhmx6Y0z3N7dfcUNCPH+sYOxoB4K84iDAeNKGmJxj48uOM4l0zGoAlk/
        Gqkfb0uvDqAVY1JNjo9SBpopEnSmI7Y=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-SnfdhNRMNQKt4ri0L9Af5g-1; Thu, 28 Sep 2023 18:21:41 -0400
X-MC-Unique: SnfdhNRMNQKt4ri0L9Af5g-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7983537d6c1so1688505939f.3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 15:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695939701; x=1696544501;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mFHyzwss0VIynmY6kq9IQqsmynTMCUyfW9NTpB4UhBc=;
        b=QhQJqHGMvRqQzicdz8GS1kPqsMwm3DsMAMXhomp5JzE6jLYFADKxS6Oi5uk7fEiSQq
         30bMiZLhr44hVXoq2OC0/q5E04wiwK+Cu0xjkZpD9cMQBeilxLPYT1BwQ/vs9W1vjYt9
         yIMZyI8FKKL2sOtMNrCYlCPq1OBzOqWE1d1VvgbSP52J4hxNRp3mAa7FcibVeo9u/XQB
         zYyUvOkkOCUzSykDLd+HJDXt3vizEpr8Aq29NwMd+aF83kBvr+sKm1BTWU4/Kh+D3SJa
         o5J5E2wVbXZxHWeDFp1AFAHFFGtz/L9SpaNNF2z9lvt3S8dXoPrnJ57+OpBsjDvEGkOj
         MsNA==
X-Gm-Message-State: AOJu0Yz04H9H3vSwnItnrh194MnWxQqW2fvKvLoShwl+lFj5Cb3vIpqr
        REUD9VWJrQ/f0upsRZdvp8y3zJtGlFAqzUcOe7rS3XxmcerZ0mYqJqa79lpv+fRG91CKdEV/VFB
        vs2s5vMsOVHbw
X-Received: by 2002:a5e:dc47:0:b0:79f:d671:c732 with SMTP id s7-20020a5edc47000000b0079fd671c732mr2854277iop.10.1695939700859;
        Thu, 28 Sep 2023 15:21:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiCbLuQ0Q0F99MyiikSRjNnpDxGqSEfKTVOj2RSJeVdREsU50q+AO2JmnXeHZUyrPp7Fb80Q==
X-Received: by 2002:a5e:dc47:0:b0:79f:d671:c732 with SMTP id s7-20020a5edc47000000b0079fd671c732mr2854217iop.10.1695939700529;
        Thu, 28 Sep 2023 15:21:40 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id t23-20020a02c497000000b0042b10d42c90sm4610172jam.113.2023.09.28.15.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 15:21:39 -0700 (PDT)
Date:   Thu, 28 Sep 2023 16:21:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Andy Lutomirski <luto@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Anish Ghulati <aghulati@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Andrew Thornton <andrewth@google.com>
Subject: Re: [PATCH 05/26] vfio: KVM: Pass get/put helpers from KVM to VFIO,
 don't do circular lookup
Message-ID: <20230928162109.42391b48.alex.williamson@redhat.com>
In-Reply-To: <20230916003118.2540661-6-seanjc@google.com>
References: <20230916003118.2540661-1-seanjc@google.com>
        <20230916003118.2540661-6-seanjc@google.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Sep 2023 17:30:57 -0700
Sean Christopherson <seanjc@google.com> wrote:

> Explicitly pass KVM's get/put helpers to VFIO when attaching a VM to
> VFIO instead of having VFIO do a symbol lookup back into KVM.  Having both
> KVM and VFIO do symbol lookups increases the overall complexity and places
> an unnecessary dependency on KVM (from VFIO) without adding any value.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/vfio/vfio.h      |  2 ++
>  drivers/vfio/vfio_main.c | 74 +++++++++++++++++++---------------------
>  include/linux/vfio.h     |  4 ++-
>  virt/kvm/vfio.c          |  9 +++--
>  4 files changed, 47 insertions(+), 42 deletions(-)


Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

 
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index a1f741365075..eec51c7ee822 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -19,6 +19,8 @@ struct vfio_container;
>  
>  struct vfio_kvm_reference {
>  	struct kvm			*kvm;
> +	bool				(*get_kvm)(struct kvm *kvm);
> +	void				(*put_kvm)(struct kvm *kvm);
>  	spinlock_t			lock;
>  };
>  
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index e77e8c6aae2f..1f58ab6dbcd2 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -16,7 +16,6 @@
>  #include <linux/fs.h>
>  #include <linux/idr.h>
>  #include <linux/iommu.h>
> -#include <linux/kvm_host.h>
>  #include <linux/list.h>
>  #include <linux/miscdevice.h>
>  #include <linux/module.h>
> @@ -1306,38 +1305,22 @@ EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
>  void vfio_device_get_kvm_safe(struct vfio_device *device,
>  			      struct vfio_kvm_reference *ref)
>  {
> -	void (*pfn)(struct kvm *kvm);
> -	bool (*fn)(struct kvm *kvm);
> -	bool ret;
> -
>  	lockdep_assert_held(&device->dev_set->lock);
>  
> +	/*
> +	 * Note!  The "kvm" and "put_kvm" pointers *must* be transferred to the
> +	 * device so that the device can put its reference to KVM.  KVM can
> +	 * invoke vfio_device_set_kvm() to detach from VFIO, i.e. nullify all
> +	 * pointers in @ref, even if a device holds a reference to KVM!  That
> +	 * also means that detaching KVM from VFIO only prevents "new" devices
> +	 * from using KVM, it doesn't invalidate KVM references in existing
> +	 * devices.
> +	 */
>  	spin_lock(&ref->lock);
> -
> -	if (!ref->kvm)
> -		goto out;
> -
> -	pfn = symbol_get(kvm_put_kvm);
> -	if (WARN_ON(!pfn))
> -		goto out;
> -
> -	fn = symbol_get(kvm_get_kvm_safe);
> -	if (WARN_ON(!fn)) {
> -		symbol_put(kvm_put_kvm);
> -		goto out;
> +	if (ref->kvm && ref->get_kvm(ref->kvm)) {
> +		device->kvm = ref->kvm;
> +		device->put_kvm = ref->put_kvm;
>  	}
> -
> -	ret = fn(ref->kvm);
> -	symbol_put(kvm_get_kvm_safe);
> -	if (!ret) {
> -		symbol_put(kvm_put_kvm);
> -		goto out;
> -	}
> -
> -	device->put_kvm = pfn;
> -	device->kvm = ref->kvm;
> -
> -out:
>  	spin_unlock(&ref->lock);
>  }
>  
> @@ -1353,28 +1336,37 @@ void vfio_device_put_kvm(struct vfio_device *device)
>  
>  	device->put_kvm(device->kvm);
>  	device->put_kvm = NULL;
> -	symbol_put(kvm_put_kvm);
> -
>  clear:
>  	device->kvm = NULL;
>  }
>  
>  static void vfio_device_set_kvm(struct vfio_kvm_reference *ref,
> -				struct kvm *kvm)
> +				struct kvm *kvm,
> +				bool (*get_kvm)(struct kvm *kvm),
> +				void (*put_kvm)(struct kvm *kvm))
>  {
> +	if (WARN_ON_ONCE(kvm && (!get_kvm || !put_kvm)))
> +		return;
> +
>  	spin_lock(&ref->lock);
>  	ref->kvm = kvm;
> +	ref->get_kvm = get_kvm;
> +	ref->put_kvm = put_kvm;
>  	spin_unlock(&ref->lock);
>  }
>  
> -static void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
> +static void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm,
> +			       bool (*get_kvm)(struct kvm *kvm),
> +			       void (*put_kvm)(struct kvm *kvm))
>  {
>  #if IS_ENABLED(CONFIG_VFIO_GROUP)
> -	vfio_device_set_kvm(&group->kvm_ref, kvm);
> +	vfio_device_set_kvm(&group->kvm_ref, kvm, get_kvm, put_kvm);
>  #endif
>  }
>  
> -static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm)
> +static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm,
> +				     bool (*get_kvm)(struct kvm *kvm),
> +				     void (*put_kvm)(struct kvm *kvm))
>  {
>  	struct vfio_device_file *df = file->private_data;
>  
> @@ -1383,27 +1375,31 @@ static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm)
>  	 * be propagated to vfio_device::kvm when the file is bound to
>  	 * iommufd successfully in the vfio device cdev path.
>  	 */
> -	vfio_device_set_kvm(&df->kvm_ref, kvm);
> +	vfio_device_set_kvm(&df->kvm_ref, kvm, get_kvm, put_kvm);
>  }
>  
>  /**
>   * vfio_file_set_kvm - Link a kvm with VFIO drivers
>   * @file: VFIO group file or VFIO device file
>   * @kvm: KVM to link
> + * @get_kvm: Callback to get a reference to @kvm
> + * @put_kvm: Callback to put a reference to @kvm
>   *
>   * When a VFIO device is first opened the KVM will be available in
>   * device->kvm if one was associated with the file.
>   */
> -void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
> +void vfio_file_set_kvm(struct file *file, struct kvm *kvm,
> +		       bool (*get_kvm)(struct kvm *kvm),
> +		       void (*put_kvm)(struct kvm *kvm))
>  {
>  	struct vfio_group *group;
>  
>  	group = vfio_group_from_file(file);
>  	if (group)
> -		vfio_group_set_kvm(group, kvm);
> +		vfio_group_set_kvm(group, kvm, get_kvm, put_kvm);
>  
>  	if (vfio_device_from_file(file))
> -		vfio_device_file_set_kvm(file, kvm);
> +		vfio_device_file_set_kvm(file, kvm, get_kvm, put_kvm);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
>  #endif
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e80955de266c..35e970e3d3fb 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -312,7 +312,9 @@ static inline bool vfio_file_has_dev(struct file *file, struct vfio_device *devi
>  bool vfio_file_is_valid(struct file *file);
>  bool vfio_file_enforced_coherent(struct file *file);
>  #if IS_ENABLED(CONFIG_KVM)
> -void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
> +void vfio_file_set_kvm(struct file *file, struct kvm *kvm,
> +		       bool (*get_kvm)(struct kvm *kvm),
> +		       void (*put_kvm)(struct kvm *kvm));
>  #endif
>  
>  #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index ca24ce120906..f14fcbb34bc6 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -37,13 +37,18 @@ struct kvm_vfio {
>  
>  static void kvm_vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>  {
> -	void (*fn)(struct file *file, struct kvm *kvm);
> +	void (*fn)(struct file *file, struct kvm *kvm,
> +		   bool (*get_kvm)(struct kvm *kvm),
> +		   void (*put_kvm)(struct kvm *kvm));
>  
>  	fn = symbol_get(vfio_file_set_kvm);
>  	if (!fn)
>  		return;
>  
> -	fn(file, kvm);
> +	if (kvm)
> +		fn(file, kvm, kvm_get_kvm_safe, kvm_put_kvm);
> +	else
> +		fn(file, kvm, NULL, NULL);
>  
>  	symbol_put(vfio_file_set_kvm);
>  }


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFF67535CF
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 10:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbjGNI5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 04:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235546AbjGNI5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 04:57:22 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DAD2715;
        Fri, 14 Jul 2023 01:57:20 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4fbe5161fbeso497480e87.0;
        Fri, 14 Jul 2023 01:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689325039; x=1691917039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jjpa6Gtsy7eHo061V6qjF+H6+yaNOmG8ZshAiM616fE=;
        b=SnvKVdMnkBhC+e2kBxdmIUHLFW1pm+E7dgElSs1kqZF+mDcvuZg+HSXflXSNNxcIqG
         KuzK9SnF14QSfquUh2CQk+1HCzt6rkA7AOG7ZLg+X9dAUuOrPkVOiW0K/gpctKIyUQAc
         2/2RrmMwfTlqvfghu2m1KWcFfRwOP6sQ9cVZ7ELbJPRbsX7rZOPnhoViealotB4FOicx
         BVhIM094aOzXLLz+8XXGDQzw2Wg9NkGcmoj9O36Dp5HKqMBy7X376dKbfLdgW1G+bRK5
         /MJqMOH/b4X2f5lnafGwLhuawvrJF30IRv6RfQ6AbmZyHfxcCjg+KmjBBmK+Zs1qnayX
         pkvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689325039; x=1691917039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jjpa6Gtsy7eHo061V6qjF+H6+yaNOmG8ZshAiM616fE=;
        b=SmILWfhhg5H1+uPqbUNyhD8M9ngeE274n6NeHXxMm79Hm3D0v1YZ6/sUGOZVQrVpsc
         4DjULdrfZtQLp6+cg8yUE4iOdhf97+z0a6/CtmLJtR6Eb+pLA9YxGASy18pPv49WG6k5
         FJiJKXGop3T0uIlQauwM2BF2hUMB6bI+Ym/MWI7/MaV0GgQfEq7/XjWwF4iLv6+jmnG9
         s0vnUBtAf38/yQbZ08JdIH2mzp9LQilB6rbbDVgEI7PcXUqbT2nHwec6IlU8/MvhTUpQ
         /BMkvNfcrgf9/ulSaIF9hg/SPiPfolLWTu4Ss6X55F0Euit8a5wxBAMO8EsTco5bmi8c
         UJiA==
X-Gm-Message-State: ABy/qLahZNwhUsdYhSRaV3F3D+mboCj8e9hAyLQORBp4zO7yGpUD0XTq
        fAPRVIwjuOoCMh0V6CACCkoCPW8MPD8=
X-Google-Smtp-Source: APBJJlGbfJ2wit+h/0+Ml80ZPRYZTs2vtOJhg8ima9cqioTzqLx5CQYzj96ijcB40HTSQAZLJEPxAA==
X-Received: by 2002:ac2:47f9:0:b0:4f6:86ba:283b with SMTP id b25-20020ac247f9000000b004f686ba283bmr2758985lfp.4.1689325038572;
        Fri, 14 Jul 2023 01:57:18 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id u2-20020ac248a2000000b004fb9d7b9914sm1403025lfg.185.2023.07.14.01.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jul 2023 01:57:18 -0700 (PDT)
Date:   Fri, 14 Jul 2023 11:57:15 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: Re: [RFC PATCH v3 08/11] KVM: Fix set_mem_attr ioctl when error
 case
Message-ID: <20230714115715.000026fe.zhi.wang.linux@gmail.com>
In-Reply-To: <ZLB0ytO7y4NOLWpL@google.com>
References: <cover.1687991811.git.isaku.yamahata@intel.com>
        <358fb191b3690a5cbc2c985d3ffc67224df11cf3.1687991811.git.isaku.yamahata@intel.com>
        <ZLB0ytO7y4NOLWpL@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jul 2023 15:03:54 -0700
Sean Christopherson <seanjc@google.com> wrote:

> On Wed, Jun 28, 2023, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > kvm_vm_ioctl_set_mem_attributes() discarded an error code of xa_err()
> > unconditionally.  If an error occurred at the beginning, return error.
> > 
> > Fixes: 3779c214835b ("KVM: Introduce per-page memory attributes")
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > ---
> > Changes v2 -> v3:
> > - Newly added
> > ---
> >  virt/kvm/kvm_main.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 422d49634c56..fdef56f85174 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2423,6 +2423,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> >  	gfn_t start, end;
> >  	unsigned long i;
> >  	void *entry;
> > +	int err = 0;
> >  
> >  	/* flags is currently not used. */
> >  	if (attrs->flags)
> > @@ -2447,14 +2448,17 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> >  	KVM_MMU_UNLOCK(kvm);
> >  
> >  	for (i = start; i < end; i++) {
> > -		if (xa_err(xa_store(&kvm->mem_attr_array, i, entry,
> > -				    GFP_KERNEL_ACCOUNT)))
> > +		err = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
> > +				      GFP_KERNEL_ACCOUNT));
> > +		if (err)
> >  			break;
> >  	}
> >  
> >  	KVM_MMU_LOCK(kvm);
> > -	if (i > start)
> > +	if (i > start) {
> > +		err = 0;
> >  		kvm_mem_attrs_changed(kvm, attrs->attributes, start, i);
> > +	}
> >  	kvm_mmu_invalidate_end(kvm);
> >  	KVM_MMU_UNLOCK(kvm);
> >  
> > @@ -2463,7 +2467,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> >  	attrs->address = i << PAGE_SHIFT;
> >  	attrs->size = (end - i) << PAGE_SHIFT;
> >  
> > -	return 0;
> > +	return err;  
> 
> Aha!  Idea (stolen from commit afb2acb2e3a3 ("KVM: Fix vcpu_array[0] races")).
> Rather than deal with a potential error partway through the updates, reserve all
> xarray entries head of time.  That way the ioctl() is all-or-nothing, e.g. KVM
> doesn't need to update the address+size to capture progress, and userspace doesn't
> have to retry (which is probably pointless anyways since failure to allocate an
> xarray entry likely means the system/cgroup is under intense memory pressure).
> 
> Assuming it works (compile tested only), I'll squash this:
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 46fbb4e019a6..8cb972038dab 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -2278,7 +2278,7 @@ struct kvm_s390_zpci_op {
>  
>  /* Available with KVM_CAP_MEMORY_ATTRIBUTES */
>  #define KVM_GET_SUPPORTED_MEMORY_ATTRIBUTES    _IOR(KVMIO,  0xd2, __u64)
> -#define KVM_SET_MEMORY_ATTRIBUTES              _IOWR(KVMIO,  0xd3, struct kvm_memory_attributes)
> +#define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd3, struct kvm_memory_attributes)
>  
>  struct kvm_memory_attributes {
>         __u64 address;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9584491c0cd3..93e82e3f1e1f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2425,6 +2425,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>         gfn_t start, end;
>         unsigned long i;
>         void *entry;
> +       int r;
>  
>         /* flags is currently not used. */
>         if (attrs->flags)
> @@ -2439,18 +2440,32 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>         start = attrs->address >> PAGE_SHIFT;
>         end = (attrs->address + attrs->size - 1 + PAGE_SIZE) >> PAGE_SHIFT;
>  
> +       if (WARN_ON_ONCE(start == end))
> +               return -EINVAL;
> +
>         entry = attrs->attributes ? xa_mk_value(attrs->attributes) : NULL;
>  
>         mutex_lock(&kvm->slots_lock);
>  
> +       /*
> +        * Reserve memory ahead of time to avoid having to deal with failures
> +        * partway through setting the new attributes.
> +        */
> +       for (i = start; i < end; i++) {
> +               r = xa_reserve(&kvm->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
> +               if (r)
> +                       goto out_unlock;
> +       }
> +
>         KVM_MMU_LOCK(kvm);
>         kvm_mmu_invalidate_begin(kvm);
>         kvm_mmu_invalidate_range_add(kvm, start, end);
>         KVM_MMU_UNLOCK(kvm);
>  
>         for (i = start; i < end; i++) {
> -               if (xa_err(xa_store(&kvm->mem_attr_array, i, entry,
> -                                   GFP_KERNEL_ACCOUNT)))
> +               r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
> +                                   GFP_KERNEL_ACCOUNT));
> +               if (KVM_BUG_ON(r, kvm))
>                         break;
>         }
>

IIUC, If an error happenes here, we should bail out and call xa_release()?
Or the code below (which is not shown here) still changes the memory attrs
partially.
 
> @@ -2460,12 +2475,10 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>         kvm_mmu_invalidate_end(kvm);
>         KVM_MMU_UNLOCK(kvm);
>  
> +out_unlock:
>         mutex_unlock(&kvm->slots_lock);
>  
> -       attrs->address = i << PAGE_SHIFT;
> -       attrs->size = (end - i) << PAGE_SHIFT;
> -
> -       return 0;
> +       return r;
>  }
>  #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
>  
> @@ -5078,9 +5091,6 @@ static long kvm_vm_ioctl(struct file *filp,
>                         goto out;
>  
>                 r = kvm_vm_ioctl_set_mem_attributes(kvm, &attrs);
> -
> -               if (!r && copy_to_user(argp, &attrs, sizeof(attrs)))
> -                       r = -EFAULT;
>                 break;
>         }
>  #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
> 


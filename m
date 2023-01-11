Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A09666657
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 23:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbjAKWnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 17:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjAKWnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 17:43:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA5DB8E
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 14:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673476972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jR8DH+yt39DdleP1XP6J24wkUCA0AkPLm1ok6VP20Bg=;
        b=TJoJ0kUAezF/UMI/rjG0IaA5HXgy8QbkbC5F1InzjWygLpNzd1aUU1WR/wCUe73IWEjGNS
        38GZQL3no9tIPVl80ZoIfqkf+qtyLbvlj+LixxJ3ptUuWBBndpPy92dP24ChfYeSgbdfFk
        PBV4CFFAuTRjnQm9KEWYVK2fC32hYlA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-170-Ea9-_vFFP2SAFGp44HyxiA-1; Wed, 11 Jan 2023 17:42:51 -0500
X-MC-Unique: Ea9-_vFFP2SAFGp44HyxiA-1
Received: by mail-wm1-f70.google.com with SMTP id c7-20020a1c3507000000b003d355c13ba8so8331394wma.6
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 14:42:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jR8DH+yt39DdleP1XP6J24wkUCA0AkPLm1ok6VP20Bg=;
        b=lS2FlYe0LrjJSuJZy2JZMxzAAgF7yocc+xWqY0tKbVLZZv8k0okMJEiF57aXrXjR5p
         ErgT9ytcjgacQOB4QRGgUBM9qUTFVWnHOHMD4BCty/Mzl4MeoXzkwXRgxIwoAdeKMNOy
         SbQx608KPXx31ECvV5ahls4Lw3jMmwaUB3QoFZuVImt81zSqGxV3h95eYKiQtgl7jGYu
         kXQoaeOhF2B5QLpH6b1Y4t4Yd9rrdef31XtjFWY+UbdAaDnxC1GTfdoz1SfXdKrIfULe
         7acYEechpNrW5NWCm1d/Ifp7KOiS9tunfSyga/7nRQMemMVz55IaIURwabbQRFEF05jE
         MeJw==
X-Gm-Message-State: AFqh2kpLirLlrQoampEdKb/ephq3sk7xsNAAAneJE8wjntcadJ/XvByA
        2xUkxLMVKP1hNznkAPlPEjAu2rObclkEPPu47bynpYHxtR61U/h42BbeWEsFYvsX2l+cvCCXyQx
        quO8SZ9/xEzHI
X-Received: by 2002:a05:600c:1ca3:b0:3d3:591a:bfda with SMTP id k35-20020a05600c1ca300b003d3591abfdamr57062084wms.27.1673476970089;
        Wed, 11 Jan 2023 14:42:50 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtPfqnrRLbp78OianK5W9csZ/fE+qEr4nWTW16dCaZYZEh0uLC5LYwdyJprh9cAPT+ltFYwOw==
X-Received: by 2002:a05:600c:1ca3:b0:3d3:591a:bfda with SMTP id k35-20020a05600c1ca300b003d3591abfdamr57062068wms.27.1673476969706;
        Wed, 11 Jan 2023 14:42:49 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id m17-20020a05600c3b1100b003cfbbd54178sm7525179wms.2.2023.01.11.14.42.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 14:42:49 -0800 (PST)
Message-ID: <0e1b1673-a6f2-1f61-eb51-d9d4d6194a2a@redhat.com>
Date:   Wed, 11 Jan 2023 23:42:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 4/4] KVM: x86/xen: Avoid deadlock by adding
 kvm->arch.xen.xen_lock leaf node lock
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>, paul <paul@xen.org>,
        Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
References: <20230111180651.14394-1-dwmw2@infradead.org>
 <20230111180651.14394-4-dwmw2@infradead.org>
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230111180651.14394-4-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/23 19:06, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> In commit 14243b387137a ("KVM: x86/xen: Add KVM_IRQ_ROUTING_XEN_EVTCHN
> and event channel delivery") the clever version of me left some helpful
> notes for those who would come after him:
> 
>         /*
>          * For the irqfd workqueue, using the main kvm->lock mutex is
>          * fine since this function is invoked from kvm_set_irq() with
>          * no other lock held, no srcu. In future if it will be called
>          * directly from a vCPU thread (e.g. on hypercall for an IPI)
>          * then it may need to switch to using a leaf-node mutex for
>          * serializing the shared_info mapping.
>          */
>         mutex_lock(&kvm->lock);
> 
> In commit 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")
> the other version of me ran straight past that comment without reading it,
> and introduced a potential deadlock by taking vcpu->mutex and kvm->lock
> in the wrong order.
> 
> Solve this as originally suggested, by adding a leaf-node lock in the Xen
> state rather than using kvm->lock for it.
> 
> Fixes: 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

Same as my patch except that this one is for an older tree and is
missing this:

@@ -1958,7 +1950,7 @@ static int kvm_xen_eventfd_reset(struct kvm *kvm)
  
  	all_evtchnfds = kmalloc_array(n, sizeof(struct evtchnfd *), GFP_KERNEL);
  	if (!all_evtchnfds) {
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.xen.xen_lock);
  		return -ENOMEM;
  	}
  
FWIW my commit message was this:

     Using kvm->lock is incorrect because the rule is that kvm->lock is held
     outside vcpu->mutex.  This is relatively rare and generally the locks
     are held independently, which is why the incorrect use did not cause
     deadlocks left and right; on x86 in fact it only happens for SEV's
     move-context ioctl, a niche feature whose intersection with Xen is
     pretty much empty.  But still, locking rules are locking rules and
     the comment in kvm_xen_set_evtchn already hinted that using a separate
     leaf mutex would be needed as soon as event channel hypercalls would
     be supported.

Queued all four, thanks.

Paolo

> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/xen.c              | 65 +++++++++++++++------------------
>   2 files changed, 30 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2f5bf581d00a..4ef0143fa682 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1115,6 +1115,7 @@ struct msr_bitmap_range {
>   
>   /* Xen emulation context */
>   struct kvm_xen {
> +	struct mutex xen_lock;
>   	u32 xen_version;
>   	bool long_mode;
>   	bool runstate_update_flag;
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 809b82bdb9c3..8bebc41f8f9e 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -608,26 +608,26 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>   		if (!IS_ENABLED(CONFIG_64BIT) && data->u.long_mode) {
>   			r = -EINVAL;
>   		} else {
> -			mutex_lock(&kvm->lock);
> +			mutex_lock(&kvm->arch.xen.xen_lock);
>   			kvm->arch.xen.long_mode = !!data->u.long_mode;
> -			mutex_unlock(&kvm->lock);
> +			mutex_unlock(&kvm->arch.xen.xen_lock);
>   			r = 0;
>   		}
>   		break;
>   
>   	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
> -		mutex_lock(&kvm->lock);
> +		mutex_lock(&kvm->arch.xen.xen_lock);
>   		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
> -		mutex_unlock(&kvm->lock);
> +		mutex_unlock(&kvm->arch.xen.xen_lock);
>   		break;
>   
>   	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
>   		if (data->u.vector && data->u.vector < 0x10)
>   			r = -EINVAL;
>   		else {
> -			mutex_lock(&kvm->lock);
> +			mutex_lock(&kvm->arch.xen.xen_lock);
>   			kvm->arch.xen.upcall_vector = data->u.vector;
> -			mutex_unlock(&kvm->lock);
> +			mutex_unlock(&kvm->arch.xen.xen_lock);
>   			r = 0;
>   		}
>   		break;
> @@ -637,9 +637,9 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>   		break;
>   
>   	case KVM_XEN_ATTR_TYPE_XEN_VERSION:
> -		mutex_lock(&kvm->lock);
> +		mutex_lock(&kvm->arch.xen.xen_lock);
>   		kvm->arch.xen.xen_version = data->u.xen_version;
> -		mutex_unlock(&kvm->lock);
> +		mutex_unlock(&kvm->arch.xen.xen_lock);
>   		r = 0;
>   		break;
>   
> @@ -648,9 +648,9 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>   			r = -EOPNOTSUPP;
>   			break;
>   		}
> -		mutex_lock(&kvm->lock);
> +		mutex_lock(&kvm->arch.xen.xen_lock);
>   		kvm->arch.xen.runstate_update_flag = !!data->u.runstate_update_flag;
> -		mutex_unlock(&kvm->lock);
> +		mutex_unlock(&kvm->arch.xen.xen_lock);
>   		r = 0;
>   		break;
>   
> @@ -665,7 +665,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>   {
>   	int r = -ENOENT;
>   
> -	mutex_lock(&kvm->lock);
> +	mutex_lock(&kvm->arch.xen.xen_lock);
>   
>   	switch (data->type) {
>   	case KVM_XEN_ATTR_TYPE_LONG_MODE:
> @@ -704,7 +704,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>   		break;
>   	}
>   
> -	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&kvm->arch.xen.xen_lock);
>   	return r;
>   }
>   
> @@ -712,7 +712,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>   {
>   	int idx, r = -ENOENT;
>   
> -	mutex_lock(&vcpu->kvm->lock);
> +	mutex_lock(&vcpu->kvm->arch.xen.xen_lock);
>   	idx = srcu_read_lock(&vcpu->kvm->srcu);
>   
>   	switch (data->type) {
> @@ -940,7 +940,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>   	}
>   
>   	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> -	mutex_unlock(&vcpu->kvm->lock);
> +	mutex_unlock(&vcpu->kvm->arch.xen.xen_lock);
>   	return r;
>   }
>   
> @@ -948,7 +948,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>   {
>   	int r = -ENOENT;
>   
> -	mutex_lock(&vcpu->kvm->lock);
> +	mutex_lock(&vcpu->kvm->arch.xen.xen_lock);
>   
>   	switch (data->type) {
>   	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO:
> @@ -1031,7 +1031,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>   		break;
>   	}
>   
> -	mutex_unlock(&vcpu->kvm->lock);
> +	mutex_unlock(&vcpu->kvm->arch.xen.xen_lock);
>   	return r;
>   }
>   
> @@ -1124,7 +1124,7 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
>   	     xhc->blob_size_32 || xhc->blob_size_64))
>   		return -EINVAL;
>   
> -	mutex_lock(&kvm->lock);
> +	mutex_lock(&kvm->arch.xen.xen_lock);
>   
>   	if (xhc->msr && !kvm->arch.xen_hvm_config.msr)
>   		static_branch_inc(&kvm_xen_enabled.key);
> @@ -1133,7 +1133,7 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
>   
>   	memcpy(&kvm->arch.xen_hvm_config, xhc, sizeof(*xhc));
>   
> -	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&kvm->arch.xen.xen_lock);
>   	return 0;
>   }
>   
> @@ -1676,15 +1676,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
>   		mm_borrowed = true;
>   	}
>   
> -	/*
> -	 * For the irqfd workqueue, using the main kvm->lock mutex is
> -	 * fine since this function is invoked from kvm_set_irq() with
> -	 * no other lock held, no srcu. In future if it will be called
> -	 * directly from a vCPU thread (e.g. on hypercall for an IPI)
> -	 * then it may need to switch to using a leaf-node mutex for
> -	 * serializing the shared_info mapping.
> -	 */
> -	mutex_lock(&kvm->lock);
> +	mutex_lock(&kvm->arch.xen.xen_lock);
>   
>   	/*
>   	 * It is theoretically possible for the page to be unmapped
> @@ -1713,7 +1705,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
>   		srcu_read_unlock(&kvm->srcu, idx);
>   	} while(!rc);
>   
> -	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&kvm->arch.xen.xen_lock);
>   
>   	if (mm_borrowed)
>   		kthread_unuse_mm(kvm->mm);
> @@ -1829,7 +1821,7 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
>   	int ret;
>   
>   	/* Protect writes to evtchnfd as well as the idr lookup.  */
> -	mutex_lock(&kvm->lock);
> +	mutex_lock(&kvm->arch.xen.xen_lock);
>   	evtchnfd = idr_find(&kvm->arch.xen.evtchn_ports, port);
>   
>   	ret = -ENOENT;
> @@ -1860,7 +1852,7 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
>   	}
>   	ret = 0;
>   out_unlock:
> -	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&kvm->arch.xen.xen_lock);
>   	return ret;
>   }
>   
> @@ -1923,10 +1915,10 @@ static int kvm_xen_eventfd_assign(struct kvm *kvm,
>   		evtchnfd->deliver.port.priority = data->u.evtchn.deliver.port.priority;
>   	}
>   
> -	mutex_lock(&kvm->lock);
> +	mutex_lock(&kvm->arch.xen.xen_lock);
>   	ret = idr_alloc(&kvm->arch.xen.evtchn_ports, evtchnfd, port, port + 1,
>   			GFP_KERNEL);
> -	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&kvm->arch.xen.xen_lock);
>   	if (ret >= 0)
>   		return 0;
>   
> @@ -1944,9 +1936,9 @@ static int kvm_xen_eventfd_deassign(struct kvm *kvm, u32 port)
>   {
>   	struct evtchnfd *evtchnfd;
>   
> -	mutex_lock(&kvm->lock);
> +	mutex_lock(&kvm->arch.xen.xen_lock);
>   	evtchnfd = idr_remove(&kvm->arch.xen.evtchn_ports, port);
> -	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&kvm->arch.xen.xen_lock);
>   
>   	if (!evtchnfd)
>   		return -ENOENT;
> @@ -1963,7 +1955,7 @@ static int kvm_xen_eventfd_reset(struct kvm *kvm)
>   	struct evtchnfd *evtchnfd;
>   	int i;
>   
> -	mutex_lock(&kvm->lock);
> +	mutex_lock(&kvm->arch.xen.xen_lock);
>   	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i) {
>   		idr_remove(&kvm->arch.xen.evtchn_ports, evtchnfd->send_port);
>   		synchronize_srcu(&kvm->srcu);
> @@ -1971,7 +1963,7 @@ static int kvm_xen_eventfd_reset(struct kvm *kvm)
>   			eventfd_ctx_put(evtchnfd->deliver.eventfd.ctx);
>   		kfree(evtchnfd);
>   	}
> -	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&kvm->arch.xen.xen_lock);
>   
>   	return 0;
>   }
> @@ -2063,6 +2055,7 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
>   
>   void kvm_xen_init_vm(struct kvm *kvm)
>   {
> +	mutex_init(&kvm->arch.xen.xen_lock);
>   	idr_init(&kvm->arch.xen.evtchn_ports);
>   	kvm_gpc_init(&kvm->arch.xen.shinfo_cache, kvm, NULL, KVM_HOST_USES_PFN);
>   }


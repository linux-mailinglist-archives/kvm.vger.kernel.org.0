Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D871675C57
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 18:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjATR7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 12:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjATR7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 12:59:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3D048605
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 09:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674237522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WmRfpj48RyjRyZDGGPZo2d8kT+rAwJ1anTjm2/PHafk=;
        b=TyBKQjbEcKKajw7PDEF0Ig/cbAnPhKR9IUYDxsNGj3EyQ+LQpnrRj9k/rfIttKamnJVBFf
        /DjEbia6lWmCsEc7dXkHrD/p3Zdpa6GTTGHAvL9fUDNE72QUbXiRIjD+Kfe2IvbrzQRCce
        0znWtQjgFOuQ7Ao4w4dEBl+yjWMdWdg=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-651-9T0mwCu1O5OUUYvzd0MM0A-1; Fri, 20 Jan 2023 12:58:41 -0500
X-MC-Unique: 9T0mwCu1O5OUUYvzd0MM0A-1
Received: by mail-il1-f200.google.com with SMTP id g11-20020a056e021a2b00b0030da3e7916fso4227371ile.18
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 09:58:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WmRfpj48RyjRyZDGGPZo2d8kT+rAwJ1anTjm2/PHafk=;
        b=PYPxY40BvqjaIov6oGcAf/wnAhpxmwfd8ovVrIH50YwNtP7sLn5oKzUkJyV6TfBH9P
         d3KkcztXBAh497gj0huxXwPps7wSwSOmSsTs8CaQU1cA0ow2UDP2VvEUzsJqgbZp81dE
         sHDhJqs/2ABIWtN/fGQHxtH6FOLKahy6a6DJyxwNF9vHh0oA22Sc9zHWGGmhCaJr/YlO
         hNYPyfsa9DmIXBtA0iioOLVrorzjNGI5XrGHyoK9fPB4Ql9VfKz3+zEkVxBf0rkLqMro
         SijP7KmeOXbrawtmfLeyQaiwYzA43BB32y5GOAJ9rcEsDwBer4s0OKvdSoVB8FWDNLRQ
         Gu9w==
X-Gm-Message-State: AFqh2kph+ic7rDI8Gre/Kmgm+z4x0APdybnLmAJHujZ5J84jCIHJCn9J
        nftqwn0+PEWqee0JpblzLzSW9QnBFGtywfqfCGQcQZVHgPEHSpwqcS8Kqeer7ZrblTUMqBuCA/j
        aX1fZVaOucoB7
X-Received: by 2002:a5d:91ce:0:b0:704:ce06:81fd with SMTP id k14-20020a5d91ce000000b00704ce0681fdmr10190702ior.12.1674237520797;
        Fri, 20 Jan 2023 09:58:40 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvWHZw0KBjfw/OOejn5eFckg+3ECBCwnEWHdhh2gOLwwb1mg/roN1/n+BWFUPswaGH+Cbf2rg==
X-Received: by 2002:a5d:91ce:0:b0:704:ce06:81fd with SMTP id k14-20020a5d91ce000000b00704ce0681fdmr10190681ior.12.1674237520535;
        Fri, 20 Jan 2023 09:58:40 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id j2-20020a026302000000b0038a48cfededsm12514918jac.15.2023.01.20.09.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 09:58:40 -0800 (PST)
Date:   Fri, 20 Jan 2023 10:58:37 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     pbonzini@redhat.com, mjrosato@linux.ibm.com, jgg@nvidia.com,
        kevin.tian@intel.com, cohuck@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, seanjc@google.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/vfio: Fix potential deadlock on vfio group_lock
Message-ID: <20230120105837.254a0b0a.alex.williamson@redhat.com>
In-Reply-To: <20230120150528.471752-1-yi.l.liu@intel.com>
References: <20230120150528.471752-1-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Jan 2023 07:05:28 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> Currently it is possible that the final put of a KVM reference comes from
> vfio during its device close operation.  This occurs while the vfio group
> lock is held; however, if the vfio device is still in the kvm device list,
> then the following call chain could result in a deadlock:
> 
> VFIO holds group->group_lock/group_rwsem
>   -> kvm_put_kvm
>    -> kvm_destroy_vm
>     -> kvm_destroy_devices
>      -> kvm_vfio_destroy
>       -> kvm_vfio_file_set_kvm
>        -> vfio_file_set_kvm
>         -> try to hold group->group_lock/group_rwsem  
> 
> The key function is the kvm_destroy_devices() which triggers destroy cb
> of kvm_device_ops. It calls back to vfio and try to hold group_lock. So
> if this path doesn't call back to vfio, this dead lock would be fixed.
> Actually, there is a way for it. KVM provides another point to free the
> kvm-vfio device which is the point when the device file descriptor is
> closed. This can be achieved by providing the release cb instead of the
> destroy cb. Also rename kvm_vfio_destroy() to be kvm_vfio_release().
> 
> 	/*
> 	 * Destroy is responsible for freeing dev.
> 	 *
> 	 * Destroy may be called before or after destructors are called
> 	 * on emulated I/O regions, depending on whether a reference is
> 	 * held by a vcpu or other kvm component that gets destroyed
> 	 * after the emulated I/O.
> 	 */
> 	void (*destroy)(struct kvm_device *dev);
> 
> 	/*
> 	 * Release is an alternative method to free the device. It is
> 	 * called when the device file descriptor is closed. Once
> 	 * release is called, the destroy method will not be called
> 	 * anymore as the device is removed from the device list of
> 	 * the VM. kvm->lock is held.
> 	 */
> 	void (*release)(struct kvm_device *dev);
> 
> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  virt/kvm/vfio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 495ceabffe88..e94f3ea718e5 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -336,7 +336,7 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
>  	return -ENXIO;
>  }
>  
> -static void kvm_vfio_destroy(struct kvm_device *dev)
> +static void kvm_vfio_release(struct kvm_device *dev)
>  {
>  	struct kvm_vfio *kv = dev->private;
>  	struct kvm_vfio_group *kvg, *tmp;
> @@ -363,7 +363,7 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type);
>  static struct kvm_device_ops kvm_vfio_ops = {
>  	.name = "kvm-vfio",
>  	.create = kvm_vfio_create,
> -	.destroy = kvm_vfio_destroy,
> +	.release = kvm_vfio_release,
>  	.set_attr = kvm_vfio_set_attr,
>  	.has_attr = kvm_vfio_has_attr,
>  };

Applied to vfio for-linus branch for v6.2, along with Matthew's R-b,
the comment update, and the extra reference link.  Once we get a
linux-next build I'll send a pull request, along with Matthew's
reserved region fix.  Thanks,

Alex


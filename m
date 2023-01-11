Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5818E666425
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 20:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjAKTzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 14:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjAKTy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 14:54:57 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4727205
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 11:54:55 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id v23so12997527plo.1
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 11:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ee/v08QHfLLFjdeXhNUw+rKnRh9GF2x4adAxhgB0GYM=;
        b=mUty29aJZngvM3haGgNz0VtX+oT1nq5NwGEIr+ywfTh11/SN5fAx8wJb3/AxwaV1IB
         4fOLCF8Gt45RMnvd0FJPDGVCRtB65sGAnTnl2gvNSr25eaYWay+OCHLe12RQxNxI+uJ7
         5kYKYjDUcHYnrs6l3M6L1KbEQhYV5D62TF38qCYkTXwjaK+f5NtvUlZlCgscCq8J7O5a
         cFrNZdYpUthCuh4JWxIaHdv6KkGy7YvA0hNl80XsdOfzgo+Wyt1R1n7GaAcPdN90cK1L
         tDvuY4iQ5Oi8XKJAFnLQc0Wu9A0lE/lOWo/eVhjs/O0IKSk8JTk8UHczuiPeZ6NLNiPn
         S1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ee/v08QHfLLFjdeXhNUw+rKnRh9GF2x4adAxhgB0GYM=;
        b=YUPnTMjMSXFLW+yFn6NDArytoyiHD29v4ryWJ/wa5EhJsY1/DubnUJluDTmrYNQN3L
         TRe2r58Y/uZJIwnuHpQS/DL4y9rp+UUP2jUlCkxBsXumdtueBhcPyzo3q1G8dNKF/s5d
         z/P/DXmYaeguS2NR3k8E0UPxr3geoY24MIuEnxEK46pliqtdMVQCatAb7nxXROdoR4jE
         g7n6I/QzWH/1XXj6602vEaV7yO72iJtHPDsKVcq9OyQaMumFLsKOw9L6mQvl83sai/Il
         G9w95ih6i9ak0UY+dmP4v+FyOdoxxrhBj9t0FMmLw5YtnXGJoxya4qFhjG5dz8Ixpj5B
         MO6A==
X-Gm-Message-State: AFqh2krEkkG2jxYrC0gJw6gdSVqAultCj0bggcEoe1PfyElW6YNXYhmE
        7gWR0h4n938KmWwDPZWKojKhGw==
X-Google-Smtp-Source: AMrXdXsUGcan4Od1kkbsywDEb3Eqlo0h8a16FR71K8XMA8z2GmZHxW9H5FaMeLYfZPUCz0pASaTbQw==
X-Received: by 2002:a05:6a20:c527:b0:9d:c38f:9bdd with SMTP id gm39-20020a056a20c52700b0009dc38f9bddmr557202pzb.2.1673466895257;
        Wed, 11 Jan 2023 11:54:55 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t18-20020a62d152000000b00580f445d1easm10245195pfl.216.2023.01.11.11.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 11:54:54 -0800 (PST)
Date:   Wed, 11 Jan 2023 19:54:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, pbonzini@redhat.com, jgg@nvidia.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: async kvm_destroy_vm for vfio devices
Message-ID: <Y78UCz5oeuntSQtK@google.com>
References: <20230109201037.33051-1-mjrosato@linux.ibm.com>
 <20230109201037.33051-2-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109201037.33051-2-mjrosato@linux.ibm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 09, 2023, Matthew Rosato wrote:
> Currently it is possible that the final put of a KVM reference comes from
> vfio during its device close operation.  This occurs while the vfio group
> lock is held; however, if the vfio device is still in the kvm device list,
> then the following call chain could result in a deadlock:
> 
> kvm_put_kvm
>  -> kvm_destroy_vm
>   -> kvm_destroy_devices
>    -> kvm_vfio_destroy
>     -> kvm_vfio_file_set_kvm
>      -> vfio_file_set_kvm
>       -> group->group_lock/group_rwsem
> 
> Avoid this scenario by adding kvm_put_kvm_async which will perform the
> kvm_destroy_vm asynchronously if the refcount reaches 0.

Something feels off.  If KVM's refcount is 0, then accessing device->group->kvm
in vfio_device_open() can't happen unless there's a refcounting bug somewhere.

E.g. if this snippet holds group_lock

		mutex_lock(&device->group->group_lock);
		device->kvm = device->group->kvm;

		if (device->ops->open_device) {
			ret = device->ops->open_device(device);
			if (ret)
				goto err_undo_count;
		}
		vfio_device_container_register(device);
		mutex_unlock(&device->group->group_lock);

and kvm_vfio_destroy() has already been invoked and is waiting on group_lock in
vfio_file_set_kvm(), then device->ops->open_device() is being called with a
non-NULL device->kvm that has kvm->users_count==0.  And intel_vgpu_open_device()
at least uses kvm_get_kvm(), i.e. assumes kvm->users_count > 0.

If there's no refcounting bug then kvm_vfio_destroy() doesn't need to call
kvm_vfio_file_set_kvm() since the only way there isn't a refcounting bug is if
group->kvm is unreachable.  This seems unlikely.

Assuming there is indeed a refcounting issue, one solution would be to harden all
->open_device() implementations to use kvm_get_kvm_safe().  I'd prefer not to have
to do that since it will complicate those implementations and also requires KVM
to support an async put.

Rather than force devices to get KVM references, why not handle that in common
VFIO code and drop KVM refcountin from devices?  Worst case scenario KVM is pinned
by a device that doesn't need KVM but is in a group associated with KVM.  If that's
a concern, it seems easy enough to add a flag to vfio_device_ops to enumerate
whether or not the device depends on KVM.

---
 drivers/vfio/vfio_main.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 6e8804fe0095..fb43212d77a0 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -772,6 +772,13 @@ static struct file *vfio_device_open(struct vfio_device *device)
 		 * reference and release it during close_device.
 		 */
 		mutex_lock(&device->group->group_lock);
+
+		if (device->group->kvm &&
+		    !kvm_get_kvm_safe(device->group->kvm->kvm)) {
+			ret = -ENODEV;
+			goto err_undo_count;
+		}
+
 		device->kvm = device->group->kvm;
 
 		if (device->ops->open_device) {
@@ -823,8 +830,10 @@ static struct file *vfio_device_open(struct vfio_device *device)
 err_undo_count:
 	mutex_unlock(&device->group->group_lock);
 	device->open_count--;
-	if (device->open_count == 0 && device->kvm)
+	if (device->open_count == 0 && device->kvm) {
+		kvm_put_kvm(device->kvm);
 		device->kvm = NULL;
+	}
 	mutex_unlock(&device->dev_set->lock);
 	module_put(device->dev->driver->owner);
 err_unassign_container:
@@ -1039,8 +1048,10 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	}
 	mutex_unlock(&device->group->group_lock);
 	device->open_count--;
-	if (device->open_count == 0)
+	if (device->open_count == 0 && device->kvm) {
+		kvm_put_kvm(device->kvm);
 		device->kvm = NULL;
+	}
 	mutex_unlock(&device->dev_set->lock);
 
 	module_put(device->dev->driver->owner);

base-commit: d52444c7a90fc551b4c3b0bda7d3f0b2ca9fc84d
-- 

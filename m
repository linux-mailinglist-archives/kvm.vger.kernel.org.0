Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9337332017
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 08:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCIHzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 02:55:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60668 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhCIHzY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 02:55:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615276519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WZ7hVbFtAfAlsLxF3sBWRHqYsATODtQIRzg0KaNK+3A=;
        b=YiHN9/O+0tZNzgEMQoMOniFkb/4+knjHNtP97od2FfUxt9W50NGJT07+/sgVzLOxSy94Xi
        sEt8Ub1D9ek95139sExGPkG6Of00UPh3iqaLKJcmJgAuoQDS/+rNhEaNN946c1HBAyXRrz
        Ad00y2OSz9OF8pPasvomWpvGy2oG9g4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-E14vFBF5PFuXI_Z2nUEwxg-1; Tue, 09 Mar 2021 02:55:14 -0500
X-MC-Unique: E14vFBF5PFuXI_Z2nUEwxg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79062881282;
        Tue,  9 Mar 2021 07:55:12 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-195.pek2.redhat.com [10.72.12.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D7DF2CFB1;
        Tue,  9 Mar 2021 07:54:59 +0000 (UTC)
Subject: Re: [RFC v3 4/5] KVM: add ioregionfd context
To:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com, mst@redhat.com,
        cohuck@redhat.com, john.levon@nutanix.com
References: <cover.1613828726.git.eafanasova@gmail.com>
 <4436ef071e55d88ff3996b134cc2303053581242.1613828727.git.eafanasova@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2ee8cb35-3043-fc06-9973-c8bb33a90d40@redhat.com>
Date:   Tue, 9 Mar 2021 15:54:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <4436ef071e55d88ff3996b134cc2303053581242.1613828727.git.eafanasova@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/21 8:04 下午, Elena Afanasova wrote:
> Add support for ioregionfd cmds/replies serialization.


Let's be verbose here, e.g why and how it needs serailization.


>
> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> ---
> v3:
>   - add comment
>   - drop kvm_io_bus_finish/prepare()
>
>   virt/kvm/ioregion.c | 164 ++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 135 insertions(+), 29 deletions(-)
>
> diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> index 1e1c7772d274..d53e3d1cd2ff 100644
> --- a/virt/kvm/ioregion.c
> +++ b/virt/kvm/ioregion.c
> @@ -1,10 +1,39 @@
>   // SPDX-License-Identifier: GPL-2.0-only
>   #include <linux/kvm_host.h>
> -#include <linux/fs.h>
> +#include <linux/wait.h>
>   #include <kvm/iodev.h>
>   #include "eventfd.h"
>   #include <uapi/linux/ioregion.h>
>   
> +/* ioregions that share the same rfd are serialized so that only one vCPU
> + * thread sends a struct ioregionfd_cmd to userspace at a time. This
> + * ensures that the struct ioregionfd_resp received from userspace will
> + * be processed by the one and only vCPU thread that sent it.
> + *
> + * A waitqueue is used to wake up waiting vCPU threads in order. Most of
> + * the time the waitqueue is unused and the lock is not contended.
> + * For best performance userspace should set up ioregionfds so that there
> + * is no contention (e.g. dedicated ioregionfds for queue doorbell
> + * registers on multi-queue devices).
> + */
> +struct ioregionfd {
> +	wait_queue_head_t	  wq;


If we can generalize this at kvm iodevice level, that would be better.


> +	struct file		 *rf;
> +	struct kref		  kref;
> +	bool			  busy;
> +};
> +
> +struct ioregion {
> +	struct list_head	  list;
> +	u64			  paddr;   /* guest physical address */
> +	u64			  size;    /* size in bytes */
> +	struct file		 *wf;
> +	u64			  user_data; /* opaque token used by userspace */
> +	struct kvm_io_device	  dev;
> +	bool			  posted_writes;
> +	struct ioregionfd	 *ctx;
> +};
> +
>   void
>   kvm_ioregionfd_init(struct kvm *kvm)
>   {
> @@ -13,29 +42,28 @@ kvm_ioregionfd_init(struct kvm *kvm)
>   	INIT_LIST_HEAD(&kvm->ioregions_pio);
>   }
>   
> -struct ioregion {
> -	struct list_head     list;
> -	u64                  paddr;  /* guest physical address */
> -	u64                  size;   /* size in bytes */
> -	struct file         *rf;
> -	struct file         *wf;
> -	u64                  user_data; /* opaque token used by userspace */
> -	struct kvm_io_device dev;
> -	bool                 posted_writes;
> -};


It's better to squash this patch to the implementation of the ioregion 
fd. (We don't want to have a patch to fix bug of previous patch, and 
this may ease the reviewers).


> -
>   static inline struct ioregion *
>   to_ioregion(struct kvm_io_device *dev)
>   {
>   	return container_of(dev, struct ioregion, dev);
>   }
>   
> +/* assumes kvm->slots_lock held */
> +static void ctx_free(struct kref *kref)
> +{
> +	struct ioregionfd *ctx = container_of(kref, struct ioregionfd, kref);
> +
> +	kfree(ctx);
> +}
> +
>   /* assumes kvm->slots_lock held */
>   static void
>   ioregion_release(struct ioregion *p)
>   {
> -	if (p->rf)
> -		fput(p->rf);
> +	if (p->ctx) {
> +		fput(p->ctx->rf);
> +		kref_put(&p->ctx->kref, ctx_free);
> +	}
>   	fput(p->wf);
>   	list_del(&p->list);
>   	kfree(p);
> @@ -90,6 +118,30 @@ ioregion_save_ctx(struct kvm_vcpu *vcpu, bool in, gpa_t addr, u8 state, void *va
>   	vcpu->ioregion_ctx.in = in;
>   }
>   
> +static inline void
> +ioregion_lock_ctx(struct ioregionfd *ctx)
> +{
> +	if (!ctx)
> +		return;
> +
> +	spin_lock(&ctx->wq.lock);
> +	wait_event_interruptible_exclusive_locked(ctx->wq, !ctx->busy);


Any reason that a simple mutex_lock_interruptible() can't work here?

Thanks


> +	ctx->busy = true;
> +	spin_unlock(&ctx->wq.lock);
> +}
> +
> +static inline void
> +ioregion_unlock_ctx(struct ioregionfd *ctx)
> +{
> +	if (!ctx)
> +		return;
> +
> +	spin_lock(&ctx->wq.lock);
> +	ctx->busy = false;
> +	wake_up_locked(&ctx->wq);
> +	spin_unlock(&ctx->wq.lock);
> +}
> +
>   static int
>   ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
>   	      int len, void *val)
> @@ -115,11 +167,15 @@ ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
>   		}
>   	}
>   
> +	ioregion_lock_ctx(p->ctx);
> +
>   send_cmd:
>   	memset(&buf, 0, sizeof(buf));
>   	if (!pack_cmd(&buf.cmd, addr - p->paddr, len, IOREGIONFD_CMD_READ,
> -		      1, p->user_data, NULL))
> -		return -EOPNOTSUPP;
> +		      1, p->user_data, NULL)) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
>   
>   	ret = kernel_write(p->wf, &buf.cmd, sizeof(buf.cmd), 0);
>   	state = (ret == sizeof(buf.cmd)) ? GET_REPLY : SEND_CMD;
> @@ -129,14 +185,15 @@ ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
>   	}
>   	if (ret != sizeof(buf.cmd)) {
>   		ret = (ret < 0) ? ret : -EIO;
> -		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
> +		ret = (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
> +		goto out;
>   	}
> -	if (!p->rf)
> +	if (!p->ctx)
>   		return 0;
>   
>   get_repl:
>   	memset(&buf, 0, sizeof(buf));
> -	ret = kernel_read(p->rf, &buf.resp, sizeof(buf.resp), 0);
> +	ret = kernel_read(p->ctx->rf, &buf.resp, sizeof(buf.resp), 0);
>   	state = (ret == sizeof(buf.resp)) ? COMPLETE : GET_REPLY;
>   	if (signal_pending(current) && state == GET_REPLY) {
>   		ioregion_save_ctx(vcpu, 1, addr, state, val);
> @@ -144,12 +201,17 @@ ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
>   	}
>   	if (ret != sizeof(buf.resp)) {
>   		ret = (ret < 0) ? ret : -EIO;
> -		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
> +		ret = (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
> +		goto out;
>   	}
>   
>   	memcpy(val, &buf.resp.data, len);
> +	ret = 0;
>   
> -	return 0;
> +out:
> +	ioregion_unlock_ctx(p->ctx);
> +
> +	return ret;
>   }
>   
>   static int
> @@ -177,11 +239,15 @@ ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
>   		}
>   	}
>   
> +	ioregion_lock_ctx(p->ctx);
> +
>   send_cmd:
>   	memset(&buf, 0, sizeof(buf));
>   	if (!pack_cmd(&buf.cmd, addr - p->paddr, len, IOREGIONFD_CMD_WRITE,
> -		      p->posted_writes ? 0 : 1, p->user_data, val))
> -		return -EOPNOTSUPP;
> +		      p->posted_writes ? 0 : 1, p->user_data, val)) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
>   
>   	ret = kernel_write(p->wf, &buf.cmd, sizeof(buf.cmd), 0);
>   	state = (ret == sizeof(buf.cmd)) ? GET_REPLY : SEND_CMD;
> @@ -191,13 +257,14 @@ ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
>   	}
>   	if (ret != sizeof(buf.cmd)) {
>   		ret = (ret < 0) ? ret : -EIO;
> -		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
> +		ret = (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
> +		goto out;
>   	}
>   
>   get_repl:
>   	if (!p->posted_writes) {
>   		memset(&buf, 0, sizeof(buf));
> -		ret = kernel_read(p->rf, &buf.resp, sizeof(buf.resp), 0);
> +		ret = kernel_read(p->ctx->rf, &buf.resp, sizeof(buf.resp), 0);
>   		state = (retƒ == sizeof(buf.resp)) ? COMPLETE : GET_REPLY;
>   		if (signal_pending(current) && state == GET_REPLY) {
>   			ioregion_save_ctx(vcpu, 0, addr, state, (void *)val);
> @@ -205,11 +272,16 @@ ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
>   		}
>   		if (ret != sizeof(buf.resp)) {
>   			ret = (ret < 0) ? ret : -EIO;
> -			return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
> +			ret = (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
> +			goto out;
>   		}
>   	}
> +	ret = 0;
>   
> -	return 0;
> +out:
> +	ioregion_unlock_ctx(p->ctx);
> +
> +	return ret;
>   }
>   
>   /*
> @@ -285,6 +357,33 @@ get_bus_from_flags(__u32 flags)
>   	return KVM_MMIO_BUS;
>   }
>   
> +/* assumes kvm->slots_lock held */
> +static bool
> +ioregion_get_ctx(struct kvm *kvm, struct ioregion *p, struct file *rf, int bus_idx)
> +{
> +	struct ioregion *_p;
> +	struct list_head *ioregions;
> +
> +	ioregions = get_ioregion_list(kvm, bus_idx);
> +	list_for_each_entry(_p, ioregions, list)
> +		if (file_inode(_p->ctx->rf)->i_ino == file_inode(rf)->i_ino) {
> +			p->ctx = _p->ctx;
> +			kref_get(&p->ctx->kref);
> +			return true;
> +		}
> +
> +	p->ctx = kzalloc(sizeof(*p->ctx), GFP_KERNEL_ACCOUNT);
> +	if (!p->ctx)
> +		return false;
> +
> +	p->ctx->rf = rf;
> +	p->ctx->busy = false;
> +	init_waitqueue_head(&p->ctx->wq);
> +	kref_get(&p->ctx->kref);
> +
> +	return true;
> +}
> +
>   int
>   kvm_set_ioregion_idx(struct kvm *kvm, struct kvm_ioregion *args, enum kvm_bus bus_idx)
>   {
> @@ -309,11 +408,10 @@ kvm_set_ioregion_idx(struct kvm *kvm, struct kvm_ioregion *args, enum kvm_bus bu
>   	}
>   
>   	INIT_LIST_HEAD(&p->list);
> +	p->wf = wfile;
>   	p->paddr = args->guest_paddr;
>   	p->size = args->memory_size;
>   	p->user_data = args->user_data;
> -	p->rf = rfile;
> -	p->wf = wfile;
>   	p->posted_writes = args->flags & KVM_IOREGION_POSTED_WRITES;
>   
>   	mutex_lock(&kvm->slots_lock);
> @@ -322,6 +420,12 @@ kvm_set_ioregion_idx(struct kvm *kvm, struct kvm_ioregion *args, enum kvm_bus bu
>   		ret = -EEXIST;
>   		goto unlock_fail;
>   	}
> +
> +	if (rfile && !ioregion_get_ctx(kvm, p, rfile, bus_idx)) {
> +		ret = -ENOMEM;
> +		goto unlock_fail;
> +	}
> +
>   	kvm_iodevice_init(&p->dev, &ioregion_ops);
>   	ret = kvm_io_bus_register_dev(kvm, bus_idx, p->paddr, p->size,
>   				      &p->dev);
> @@ -335,6 +439,8 @@ kvm_set_ioregion_idx(struct kvm *kvm, struct kvm_ioregion *args, enum kvm_bus bu
>   
>   unlock_fail:
>   	mutex_unlock(&kvm->slots_lock);
> +	if (p->ctx)
> +		kref_put(&p->ctx->kref, ctx_free);
>   	kfree(p);
>   fail:
>   	if (rfile)


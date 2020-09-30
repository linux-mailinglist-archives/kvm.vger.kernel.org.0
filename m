Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF16E27EAA6
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 16:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbgI3OJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 10:09:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730104AbgI3OJm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 10:09:42 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601474980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BW7uLfGCMrQUZdSLMLVihbl9+TW3zw87gKappFOf/4A=;
        b=I80fZHMM+ETj+KZOxmIertbQM1lbmPaD639LKtobeKYkOflyC+/I8u3+03cl+iu5cDQePl
        OZaa29MVGxvLY67XY7TUlAOrkbAR+Xz5PyHTmeUrZu7KUSKB+K/Lla0SC1UDQXuOQafCLv
        gQC96yS7Dre51xr3jfvYJ2A80lSC8/8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-aNxpaBMePuOl9nE1WlTolw-1; Wed, 30 Sep 2020 10:09:34 -0400
X-MC-Unique: aNxpaBMePuOl9nE1WlTolw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E36C186DD2B;
        Wed, 30 Sep 2020 14:09:30 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 810415C1D0;
        Wed, 30 Sep 2020 14:09:20 +0000 (UTC)
Date:   Wed, 30 Sep 2020 08:09:19 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     guomin_chen@sina.com
Cc:     Cornelia Huck <cohuck@redhat.com>, Jiang Yi <giangyi@amazon.com>,
        Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        guomin chen <gchen.guomin@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqbypass: fix error handle when
 irq_bypass_register_producer() return fails
Message-ID: <20200930080919.1a9c66f8@x1.home>
In-Reply-To: <1601470479-26848-1-git-send-email-guomin_chen@sina.com>
References: <1601470479-26848-1-git-send-email-guomin_chen@sina.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Please version your postings so we know which one to consider as the
current proposal.

On Wed, 30 Sep 2020 20:54:39 +0800
guomin_chen@sina.com wrote:

> From: guomin chen <guomin_chen@sina.com>
> 
> When the producer object registration fails,In the future, due to
> incorrect matching when unregistering, list_del(&producer->node)
> may still be called, then trigger a BUG:
> 
>     vfio-pci 0000:db:00.0: irq bypass producer (token 0000000060c8cda5) registration fails: -16
>     vfio-pci 0000:db:00.0: irq bypass producer (token 0000000060c8cda5) registration fails: -16
>     vfio-pci 0000:db:00.0: irq bypass producer (token 0000000060c8cda5) registration fails: -16
>     ...
>     list_del corruption, ffff8f7fb8ba0828->next is LIST_POISON1 (dead000000000100)
>     ------------[ cut here ]------------
>     kernel BUG at lib/list_debug.c:47!
>     invalid opcode: 0000 [#1] SMP NOPTI
>     CPU: 29 PID: 3914 Comm: qemu-kvm Kdump: loaded Tainted: G      E
>     -------- - -4.18.0-193.6.3.el8.x86_64 #1
>     Hardware name: Lenovo ThinkSystem SR650 -[7X06CTO1WW]-/-[7X06CTO1WW]-,
>     BIOS -[IVE636Z-2.13]- 07/18/2019
>     RIP: 0010:__list_del_entry_valid.cold.1+0x12/0x4c
>     Code: ce ff 0f 0b 48 89 c1 4c 89 c6 48 c7 c7 40 85 4d 88 e8 8c bc
>           ce ff 0f 0b 48 89 fe 48 89 c2 48 c7 c7 d0 85 4d 88 e8 78 bc
>           ce ff <0f> 0b 48 c7 c7 80 86 4d 88 e8 6a bc ce ff 0f 0b 48
>           89 f2 48 89 fe
>     RSP: 0018:ffffaa9d60197d20 EFLAGS: 00010246
>     RAX: 000000000000004e RBX: ffff8f7fb8ba0828 RCX: 0000000000000000
>     RDX: 0000000000000000 RSI: ffff8f7fbf4d6a08 RDI: ffff8f7fbf4d6a08
>     RBP: 0000000000000000 R08: 000000000000084b R09: 000000000000005d
>     R10: 0000000000000000 R11: ffffaa9d60197bd0 R12: ffff8f4fbe863000
>     R13: 00000000000000c2 R14: 0000000000000000 R15: 0000000000000000
>     FS:  00007f7cb97fa700(0000) GS:ffff8f7fbf4c0000(0000)
>     knlGS:0000000000000000
>     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     CR2: 00007fcf31da4000 CR3: 0000005f6d404001 CR4: 00000000007626e0
>     DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>     DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>     PKRU: 55555554
>     Call Trace:
>         irq_bypass_unregister_producer+0x9b/0xf0 [irqbypass]
>         vfio_msi_set_vector_signal+0x8c/0x290 [vfio_pci]
>         ? load_fixmap_gdt+0x22/0x30
>         vfio_msi_set_block+0x6e/0xd0 [vfio_pci]
>         vfio_pci_ioctl+0x218/0xbe0 [vfio_pci]
>         ? kvm_vcpu_ioctl+0xf2/0x5f0 [kvm]
>         do_vfs_ioctl+0xa4/0x630
>         ? syscall_trace_enter+0x1d3/0x2c0
>         ksys_ioctl+0x60/0x90
>         __x64_sys_ioctl+0x16/0x20
>         do_syscall_64+0x5b/0x1a0
>         entry_SYSCALL_64_after_hwframe+0x65/0xca
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Jiang Yi <giangyi@amazon.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: guomin chen <guomin_chen@sina.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 13 +++++++++++--
>  drivers/vhost/vdpa.c              |  7 +++++++
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 1d9fb25..c371943 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -352,12 +352,21 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
>  	vdev->ctx[vector].producer.token = trigger;
>  	vdev->ctx[vector].producer.irq = irq;
>  	ret = irq_bypass_register_producer(&vdev->ctx[vector].producer);
> -	if (unlikely(ret))
> +	if (unlikely(ret)) {
>  		dev_info(&pdev->dev,
>  		"irq bypass producer (token %p) registration fails: %d\n",
>  		vdev->ctx[vector].producer.token, ret);
>  
> -	vdev->ctx[vector].trigger = trigger;
> +		kfree(vdev->ctx[vector].name);
> +		eventfd_ctx_put(trigger);
> +
> +		cmd = vfio_pci_memory_lock_and_enable(vdev);
> +		free_irq(irq, trigger);
> +		vfio_pci_memory_unlock_and_restore(vdev, cmd);
> +
> +		vdev->ctx[vector].trigger = NULL;
> +	} else
> +		vdev->ctx[vector].trigger = trigger;
>  
>  	return 0;
>  }

Once again, the irq bypass registration cannot cause the vector setup
to fail, either by returning an error code or failing to configure the
vector while returning success.  It's my assertion that we simply need
to set the producer.token to NULL on failure such that unregistering
the producer will not generate a match, as you've done below.  The
vector still works even if this registration fails.

> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 796fe97..4e082b8 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -107,6 +107,13 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>  	vq->call_ctx.producer.token = vq->call_ctx.ctx;
>  	vq->call_ctx.producer.irq = irq;
>  	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
> +	if (unlikely(ret)) {
> +		/*
> +		 * If registration failed,
> +		 * there is no need to unregister later.
> +		 */
> +		vq->call_ctx.producer.token = NULL;
> +	}
>  	spin_unlock(&vq->call_ctx.ctx_lock);
>  }
>  

'ret' is otherwise unused in this function, so we could simply remove
ret and change this to

	if (irq_bypass_register_producer(&vq->call_ctx.producer)) {
		/* avoid generating bogus match on unregister */
		vq->call_ctx.producer.token = NULL;
	}

Also please submit vfio and vdpa as separate patches so that the
respective maintainer for each area can handle them.  Thanks,

Alex


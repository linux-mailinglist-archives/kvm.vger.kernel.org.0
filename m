Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B62127D9F8
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 23:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgI2VZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 17:25:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728362AbgI2VZm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 17:25:42 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601414740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3Yfdgp8pa810wWFeD1/eInC7Ulkin4K7UvZPCo2vMg=;
        b=a56Mw4eqnteIaOmLF+EZbSB1k+XrHSbqei3EJTGwSG0hIZD0PGFklrnv5G42+CsvXfzWXy
        WUkB4Ht8K6LhLgXmdP7k3xhU3/HbfoqRn/56cgaTnKSk0ERVKRUaz6NsYz/zNGb7qZxSBl
        vkK9yA0Q/UXXYiwacL/kI0zbgFfeGfM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-Q7jF-_DROkmnbCBidqoBFw-1; Tue, 29 Sep 2020 17:25:38 -0400
X-MC-Unique: Q7jF-_DROkmnbCBidqoBFw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CCD28018A7;
        Tue, 29 Sep 2020 21:25:37 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E35955D9DC;
        Tue, 29 Sep 2020 21:25:25 +0000 (UTC)
Date:   Tue, 29 Sep 2020 15:25:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     guomin_chen@sina.com
Cc:     Cornelia Huck <cohuck@redhat.com>, Jiang Yi <giangyi@amazon.com>,
        Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, gchen.guomin@gmail.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        jasowang@redhat.com
Subject: Re: [PATCH] vfio/pci: when irq_bypass_register_producer() return
 fails,  we need to clean it up and return -EINVAL. instead of return true.
Message-ID: <20200929152525.24900f6c@x1.home>
In-Reply-To: <20200929145435.7a4fbac9@x1.home>
References: <1601208668-6285-1-git-send-email-guomin_chen@sina.com>
        <20200929145435.7a4fbac9@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Sep 2020 14:54:35 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Sun, 27 Sep 2020 20:11:08 +0800
> guomin_chen@sina.com wrote:
> 
> > From: guomin chen <guomin_chen@sina.com>
> > 
> > Since eventfd "fds" is passed as a parameter by the upper-level
> > application,when "fds" has multiple identical 'fd', it causes
> > multiple different vfio_pci_irq_ctx->trigger and producer->token 
> > pointing to the same eventfd file. Although all but the first one 
> > can register successfully,all others fail to register.
> > 
> > So when others producer released later, the list_del(&producer->node)
> > will be called due to the different producer->token pointing to the 
> > same eventfd file, then triggering the BUG():
> > 
> >     vfio-pci 0000:db:00.0: irq bypass producer (token 0000000060c8cda5) registration fails: -16
> >     vfio-pci 0000:db:00.0: irq bypass producer (token 0000000060c8cda5) registration fails: -16
> >     vfio-pci 0000:db:00.0: irq bypass producer (token 0000000060c8cda5) registration fails: -16
> >     vfio-pci 0000:db:00.0: irq bypass producer (token 0000000060c8cda5) registration fails: -16
> >     vfio-pci 0000:db:00.0: irq bypass producer (token 0000000060c8cda5) registration fails: -16
> >     list_del corruption, ffff8f7fb8ba0828->next is LIST_POISON1 (dead000000000100)
> >     ------------[ cut here ]------------
> >     kernel BUG at lib/list_debug.c:47!
> >     invalid opcode: 0000 [#1] SMP NOPTI
> >     CPU: 29 PID: 3914 Comm: qemu-kvm Kdump: loaded Tainted: G      E 
> >     -------- - -4.18.0-193.6.3.el8.x86_64 #1
> >     Hardware name: Lenovo ThinkSystem SR650 -[7X06CTO1WW]-/-[7X06CTO1WW]-, 
> >     BIOS -[IVE636Z-2.13]- 07/18/2019
> >     RIP: 0010:__list_del_entry_valid.cold.1+0x12/0x4c
> >     Code: ce ff 0f 0b 48 89 c1 4c 89 c6 48 c7 c7 40 85 4d 88 e8 8c bc
> > 	  ce ff 0f 0b 48 89 fe 48 89 c2 48 c7 c7 d0 85 4d 88 e8 78 bc
> > 	  ce ff <0f> 0b 48 c7 c7 80 86 4d 88 e8 6a bc ce ff 0f 0b 48 
> > 	  89 f2 48 89 fe
> >     RSP: 0018:ffffaa9d60197d20 EFLAGS: 00010246
> >     RAX: 000000000000004e RBX: ffff8f7fb8ba0828 RCX: 0000000000000000
> >     RDX: 0000000000000000 RSI: ffff8f7fbf4d6a08 RDI: ffff8f7fbf4d6a08
> >     RBP: 0000000000000000 R08: 000000000000084b R09: 000000000000005d
> >     R10: 0000000000000000 R11: ffffaa9d60197bd0 R12: ffff8f4fbe863000
> >     R13: 00000000000000c2 R14: 0000000000000000 R15: 0000000000000000
> >     FS:  00007f7cb97fa700(0000) GS:ffff8f7fbf4c0000(0000) 
> >     knlGS:0000000000000000
> >     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >     CR2: 00007fcf31da4000 CR3: 0000005f6d404001 CR4: 00000000007626e0
> >     DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >     DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >     PKRU: 55555554
> >     Call Trace:
> >         irq_bypass_unregister_producer+0x9b/0xf0 [irqbypass]
> >         vfio_msi_set_vector_signal+0x8c/0x290 [vfio_pci]
> >         ? load_fixmap_gdt+0x22/0x30
> >         vfio_msi_set_block+0x6e/0xd0 [vfio_pci]
> >         vfio_pci_ioctl+0x218/0xbe0 [vfio_pci]
> >         ? kvm_vcpu_ioctl+0xf2/0x5f0 [kvm]
> >         do_vfs_ioctl+0xa4/0x630
> >         ? syscall_trace_enter+0x1d3/0x2c0
> >         ksys_ioctl+0x60/0x90
> >         __x64_sys_ioctl+0x16/0x20
> >         do_syscall_64+0x5b/0x1a0
> >         entry_SYSCALL_64_after_hwframe+0x65/0xca
> > 
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Cornelia Huck <cohuck@redhat.com>
> > Cc: Jiang Yi <giangyi@amazon.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: guomin chen <guomin_chen@sina.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_intrs.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> > index 1d9fb25..dd3a495 100644
> > --- a/drivers/vfio/pci/vfio_pci_intrs.c
> > +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> > @@ -352,10 +352,21 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
> >  	vdev->ctx[vector].producer.token = trigger;
> >  	vdev->ctx[vector].producer.irq = irq;
> >  	ret = irq_bypass_register_producer(&vdev->ctx[vector].producer);
> > -	if (unlikely(ret))
> > -		dev_info(&pdev->dev,
> > +	if (unlikely(ret)) {
> > +		dev_err(&pdev->dev,
> >  		"irq bypass producer (token %p) registration fails: %d\n",
> >  		vdev->ctx[vector].producer.token, ret);
> > +
> > +		kfree(vdev->ctx[vector].name);
> > +		eventfd_ctx_put(trigger);
> > +
> > +		cmd = vfio_pci_memory_lock_and_enable(vdev);
> > +		free_irq(irq, trigger);
> > +		vfio_pci_memory_unlock_and_restore(vdev, cmd);
> > +
> > +		vdev->ctx[vector].trigger = NULL;
> > +		return -EINVAL;
> > +	}
> >  
> >  	vdev->ctx[vector].trigger = trigger;
> >    
> 
> This is not the correct solution.  Registering an IRQ bypass is an
> accelerator, not a requirement.  Failure should never cause the ioctl
> to fail.  The scenario you describe is a valid user configuration, the
> issue is that the de-registration passes a bogus producer object that
> was never successfully registered, causing a false match.  Therefore I
> believe the solution is to simply clear the token on registration
> failure to prevent that bogus match.  That should result in all the
> additional producer objects with the same trigger harmlessly falling
> out of the unregister function.  Can you validate and post such a
> patch?  Thanks,

BTW, vhost_vdpa_setup_vq_irq() has the same bug (Cc MST & Jason).
Thanks,

Alex


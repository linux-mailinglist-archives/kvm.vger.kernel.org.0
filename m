Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1C01FCBE4
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 13:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgFQLLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 07:11:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21652 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725536AbgFQLLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 07:11:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592392270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=syCj2SGtc29UR1l0pH8HnE/qBKvnb/ZgNc7oqht2v/k=;
        b=WdVPNHXEdf3NReG+vhjxldQSxIni1iaaB104eZ7Hq5DIrvtAMWV1n8VWXl/bDzT5g9gmGF
        yUQuRteO1QYxqDTJnTK6IWp/NkC4/i1K4dubTMUuDTJBXebizFi9xSym3MMRNrSNgc/uzk
        mgaLI06aqhFdum5uulKKQUMZDY1YRpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-WYURySGxM-eei_-0bkmXEw-1; Wed, 17 Jun 2020 07:11:08 -0400
X-MC-Unique: WYURySGxM-eei_-0bkmXEw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2D6A109132C;
        Wed, 17 Jun 2020 11:11:07 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84EE15D9D3;
        Wed, 17 Jun 2020 11:11:03 +0000 (UTC)
Date:   Wed, 17 Jun 2020 13:11:01 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: s390: reduce number of IO pins to 1
Message-ID: <20200617131101.36d2475e.cohuck@redhat.com>
In-Reply-To: <6953c580-9b99-1c76-b6eb-510dcb70894c@de.ibm.com>
References: <20200617083620.5409-1-borntraeger@de.ibm.com>
        <d17de7d7-6cca-672a-5519-c67fc147f6a5@redhat.com>
        <6953c580-9b99-1c76-b6eb-510dcb70894c@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 17 Jun 2020 13:04:52 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 17.06.20 12:19, David Hildenbrand wrote:
> > On 17.06.20 10:36, Christian Borntraeger wrote:  
> >> The current number of KVM_IRQCHIP_NUM_PINS results in an order 3
> >> allocation (32kb) for each guest start/restart. This can result in OOM
> >> killer activity even with free swap when the memory is fragmented
> >> enough:
> >>
> >> kernel: qemu-system-s39 invoked oom-killer: gfp_mask=0x440dc0(GFP_KERNEL_ACCOUNT|__GFP_COMP|__GFP_ZERO), order=3, oom_score_adj=0
> >> kernel: CPU: 1 PID: 357274 Comm: qemu-system-s39 Kdump: loaded Not tainted 5.4.0-29-generic #33-Ubuntu
> >> kernel: Hardware name: IBM 8562 T02 Z06 (LPAR)
> >> kernel: Call Trace:
> >> kernel: ([<00000001f848fe2a>] show_stack+0x7a/0xc0)
> >> kernel:  [<00000001f8d3437a>] dump_stack+0x8a/0xc0
> >> kernel:  [<00000001f8687032>] dump_header+0x62/0x258
> >> kernel:  [<00000001f8686122>] oom_kill_process+0x172/0x180
> >> kernel:  [<00000001f8686abe>] out_of_memory+0xee/0x580
> >> kernel:  [<00000001f86e66b8>] __alloc_pages_slowpath+0xd18/0xe90
> >> kernel:  [<00000001f86e6ad4>] __alloc_pages_nodemask+0x2a4/0x320
> >> kernel:  [<00000001f86b1ab4>] kmalloc_order+0x34/0xb0
> >> kernel:  [<00000001f86b1b62>] kmalloc_order_trace+0x32/0xe0
> >> kernel:  [<00000001f84bb806>] kvm_set_irq_routing+0xa6/0x2e0
> >> kernel:  [<00000001f84c99a4>] kvm_arch_vm_ioctl+0x544/0x9e0
> >> kernel:  [<00000001f84b8936>] kvm_vm_ioctl+0x396/0x760
> >> kernel:  [<00000001f875df66>] do_vfs_ioctl+0x376/0x690
> >> kernel:  [<00000001f875e304>] ksys_ioctl+0x84/0xb0
> >> kernel:  [<00000001f875e39a>] __s390x_sys_ioctl+0x2a/0x40
> >> kernel:  [<00000001f8d55424>] system_call+0xd8/0x2c8
> >>
> >> As far as I can tell s390x does not use the iopins as we bail our for
> >> anything other than KVM_IRQ_ROUTING_S390_ADAPTER and the chip/pin is
> >> only used for KVM_IRQ_ROUTING_IRQCHIP. So let us use a small number to
> >> reduce the memory footprint.
> >>
> >> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >> ---
> >>  arch/s390/include/asm/kvm_host.h | 8 ++++----
> >>  1 file changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> >> index cee3cb6455a2..6ea0820e7c7f 100644
> >> --- a/arch/s390/include/asm/kvm_host.h
> >> +++ b/arch/s390/include/asm/kvm_host.h
> >> @@ -31,12 +31,12 @@
> >>  #define KVM_USER_MEM_SLOTS 32
> >>  
> >>  /*
> >> - * These seem to be used for allocating ->chip in the routing table,
> >> - * which we don't use. 4096 is an out-of-thin-air value. If we need
> >> - * to look at ->chip later on, we'll need to revisit this.
> >> + * These seem to be used for allocating ->chip in the routing table, which we
> >> + * don't use. 1 is as small as we can get to reduce the needed memory. If we
> >> + * need to look at ->chip later on, we'll need to revisit this.
> >>   */
> >>  #define KVM_NR_IRQCHIPS 1
> >> -#define KVM_IRQCHIP_NUM_PINS 4096
> >> +#define KVM_IRQCHIP_NUM_PINS 1
> >>  #define KVM_HALT_POLL_NS_DEFAULT 50000
> >>  
> >>  /* s390-specific vcpu->requests bit members */
> >>  
> > 
> > Guess it doesn't make sense to wrap all the "->chip" handling in a
> > separate set of defines.
> > 
> > Reviewed-by: David Hildenbrand <david@redhat.com>  
> 
> I guess this is just the most simple solution. I am asking myself if I should add
> cc stable of Fixes as I was able to trigger this by having several guests with a
> reboot loop and several guests that trigger memory overcommitment.
> 

Not sure if I would count this as a real bug -- it's mostly just that a
large enough memory allocation may fail or draw the wrath of the oom
killer. It still sucks; but I'm wondering why we trigger this after
seven years.


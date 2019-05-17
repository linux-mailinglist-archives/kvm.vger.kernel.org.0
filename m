Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AABFB211F7
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 04:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfEQCYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 22:24:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbfEQCYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 22:24:01 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0D9A6308FF32
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 02:24:01 +0000 (UTC)
Received: from xz-x1 (dhcp-15-205.nay.redhat.com [10.66.15.205])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 11BFB6A24F;
        Fri, 17 May 2019 02:23:56 +0000 (UTC)
Date:   Fri, 17 May 2019 10:23:54 +0800
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH] kvm: Check irqchip mode before assign irqfd
Message-ID: <20190517022354.GM16681@xz-x1>
References: <20190505085642.6773-1-peterx@redhat.com>
 <20190505092022.GL29750@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190505092022.GL29750@xz-x1>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 17 May 2019 02:24:01 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 05, 2019 at 05:20:22PM +0800, Peter Xu wrote:
> On Sun, May 05, 2019 at 04:56:42PM +0800, Peter Xu wrote:
> > When assigning kvm irqfd we didn't check the irqchip mode but we allow
> > KVM_IRQFD to succeed with all the irqchip modes.  However it does not
> > make much sense to create irqfd even without the kernel chips.  Let's
> > provide a arch-dependent helper to check whether a specific irqfd is
> > allowed by the arch.  At least for x86, it should make sense to check:
> > 
> > - when irqchip mode is NONE, all irqfds should be disallowed, and,
> > 
> > - when irqchip mode is SPLIT, irqfds that are with resamplefd should
> >   be disallowed.
> > 
> > For either of the case, previously we'll silently ignore the irq or
> > the irq ack event if the irqchip mode is incorrect.  However that can
> > cause misterious guest behaviors and it can be hard to triage.  Let's
> > fail KVM_IRQFD even earlier to detect these incorrect configurations.
> > 
> > CC: Paolo Bonzini <pbonzini@redhat.com>
> > CC: Radim Krčmář <rkrcmar@redhat.com>
> > CC: Alex Williamson <alex.williamson@redhat.com>
> > CC: Eduardo Habkost <ehabkost@redhat.com>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> 
> Note: haven't tested, but IIUC QEMU's vfio will naturally fall back to
> no-irqfd mode (actually virtio seems to also have this but virtio
> should not be affected after all) if the KVM_IRQFD ioctl failed so I
> feel like this patch could also at least fix the broken guests
> reported besides any future fixes from QEMU side on the issue:
> 
> https://bugs.launchpad.net/qemu/+bug/1826422

Ping - Paolo, should patch still worth to have before the complete fix
between split irqchip & resamplefds?

Thanks,

-- 
Peter Xu

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523EE1DFB95
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 01:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388123AbgEWXGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 19:06:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51550 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388082AbgEWXGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 19:06:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590275170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lhu/kTFieytwhBfr5HP0IL0qZ1WKf06pn6VE9qR+1dI=;
        b=f8WjgnFNxCqwJJvU60pRYqfAtt6rw4cSKDxb4G5qYNZoFhg93qOrfqaf83iVIGaPLMlvzN
        X2Ab223oESjB49AI6b2Ni41drJte7u4883ami6WFH+EPQ527cQAS5AdNqQ2oh+vkZpYlhZ
        Agb0AvrdVOWMTt+ualiFKq48kp+jr6I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-3XezQTksN6mvlh47jhwi-Q-1; Sat, 23 May 2020 19:06:07 -0400
X-MC-Unique: 3XezQTksN6mvlh47jhwi-Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CD7A835B40;
        Sat, 23 May 2020 23:06:06 +0000 (UTC)
Received: from x1.home (ovpn-114-203.phx2.redhat.com [10.3.114.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54C8F1BCBE;
        Sat, 23 May 2020 23:06:02 +0000 (UTC)
Date:   Sat, 23 May 2020 17:06:02 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca, cai@lca.pw
Subject: Re: [PATCH v3 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
Message-ID: <20200523170602.5eb09a66@x1.home>
In-Reply-To: <20200523193417.GI766834@xz-x1>
References: <159017449210.18853.15037950701494323009.stgit@gimli.home>
        <159017506369.18853.17306023099999811263.stgit@gimli.home>
        <20200523193417.GI766834@xz-x1>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 23 May 2020 15:34:17 -0400
Peter Xu <peterx@redhat.com> wrote:

> Hi, Alex,
> 
> On Fri, May 22, 2020 at 01:17:43PM -0600, Alex Williamson wrote:
> > @@ -1346,15 +1526,32 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> >  {
> >  	struct vm_area_struct *vma = vmf->vma;
> >  	struct vfio_pci_device *vdev = vma->vm_private_data;
> > +	vm_fault_t ret = VM_FAULT_NOPAGE;
> > +
> > +	mutex_lock(&vdev->vma_lock);
> > +	down_read(&vdev->memory_lock);  
> 
> I remembered to have seen the fault() handling FAULT_FLAG_RETRY_NOWAIT at least
> in the very first version, but it's not here any more...  Could I ask what's
> the reason behind?  I probably have missed something along with the versions,
> I'm just not sure whether e.g. this would potentially block a GUP caller even
> if it's with FOLL_NOWAIT.

This is largely what v2 was about, from the cover letter:

    Locking in 3/ is substantially changed to avoid the retry scenario
    within the fault handler, therefore a caller who does not allow
    retry will no longer receive a SIGBUS on contention.

The discussion thread starts here:

https://lore.kernel.org/kvm/20200501234849.GQ26002@ziepe.ca/

Feel free to interject if there's something that doesn't make sense,
the idea is that since we've fixed the lock ordering we never need to
release one lock to wait for another, therefore we can wait for the
lock.  I'm under the impression that we can wait for the lock
regardless of the flags under these conditions.

> Side note: Another thing I thought about when reading this patch - there seems
> to have quite some possibility that the VFIO_DEVICE_PCI_HOT_RESET ioctl will
> start to return -EBUSY now.  Not a problem for this series, but maybe we should
> rememeber to let the userspace handle -EBUSY properly as follow up too, since I
> saw QEMU seemed to not handle -EBUSY for host reset path right now.

I think this has always been the case, whether it's the device lock or
this lock, the only way I know to avoid potential deadlock is to use
the 'try' locking semantics.  In normal scenarios I expect access to
sibling devices is quiesced at this point, so a user driver actually
wanting to achieve a reset shouldn't be affected by this.  Thanks,

Alex


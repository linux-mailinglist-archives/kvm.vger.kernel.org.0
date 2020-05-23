Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E261DFBFD
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 01:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388237AbgEWXxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 19:53:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46726 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388106AbgEWXxE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 23 May 2020 19:53:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590277982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d5MrxvWGXldufWJs7NZEwPFjZd8K8vtfRkxI4AQZlGI=;
        b=cgLRwB4GMIwOCRaVFOMo1ODhW9c5l/hovmjGxxEKNljeBFtXNdUtSMjjX6gxenSwXhOOCj
        pVlp87WKohsBz/Y2XyynlJTzFbz0lpdSd8zb9lbtY0rUdpIIYcCVliTIT5JU0B1DW+VK4t
        8+IoFhNS7DW1kfCi+L5Mh2kAsTzMClA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-TVCz48wgN5GyupUZqpKpyg-1; Sat, 23 May 2020 19:53:00 -0400
X-MC-Unique: TVCz48wgN5GyupUZqpKpyg-1
Received: by mail-qv1-f69.google.com with SMTP id cf17so14233526qvb.1
        for <kvm@vger.kernel.org>; Sat, 23 May 2020 16:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d5MrxvWGXldufWJs7NZEwPFjZd8K8vtfRkxI4AQZlGI=;
        b=IpW2Vev+X6v45JeQKNSK00WZS3v4OweVtFzqu/9rSxk6FlfKyt0QuRRRy0aEZPux6x
         fsruPjZrPyGo3h3tTLeVcERNjDQD2zgKD5II+oqxvoIpReZUdJaqhGq4XmgygqKA85aO
         Kshqp+/KDoEA3/6d92YbkiasSaBDuEKj62V5KjrJ0yeSyBT1r60FoMXApULrBKMji3bJ
         PlVMzMvmX0Sx3mXNZz/HITgGpQxOlwIJVbLPIa8sDnMYmOSrI6CSASsghxu6rbSgYSST
         gXZSoMl2NEUEgcBd+rHvepw/shfPqme3QcwzoEyI9mI7Djx33e+cJzWbXqGNMQq4JNDW
         pi2w==
X-Gm-Message-State: AOAM5324+1OPy4wN1rVv5FvB85JbXoXT8SK/yNz5jCMIkx7WJZB9O2fy
        18Jp6h/5VAsV+IVtijKQ+Sl//75CaL+TBas3aRSvrPbdZ474TnDTaYxt9MuQdHuO/E9Ir6rIByy
        JWS4Hc4sQ6fi0
X-Received: by 2002:ac8:44da:: with SMTP id b26mr714071qto.232.1590277980461;
        Sat, 23 May 2020 16:53:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzd+LSpddoLxFiIcA0YLSw6zts0WQ9RwwRPpO+xy4rpZASSnwuYtQt3y4PM6BzIUDMtUDgyBQ==
X-Received: by 2002:ac8:44da:: with SMTP id b26mr714062qto.232.1590277980189;
        Sat, 23 May 2020 16:53:00 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id g14sm7981038qtr.52.2020.05.23.16.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 16:52:59 -0700 (PDT)
Date:   Sat, 23 May 2020 19:52:57 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca, cai@lca.pw
Subject: Re: [PATCH v3 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
Message-ID: <20200523235257.GC939059@xz-x1>
References: <159017449210.18853.15037950701494323009.stgit@gimli.home>
 <159017506369.18853.17306023099999811263.stgit@gimli.home>
 <20200523193417.GI766834@xz-x1>
 <20200523170602.5eb09a66@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200523170602.5eb09a66@x1.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 23, 2020 at 05:06:02PM -0600, Alex Williamson wrote:
> On Sat, 23 May 2020 15:34:17 -0400
> Peter Xu <peterx@redhat.com> wrote:
> 
> > Hi, Alex,
> > 
> > On Fri, May 22, 2020 at 01:17:43PM -0600, Alex Williamson wrote:
> > > @@ -1346,15 +1526,32 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> > >  {
> > >  	struct vm_area_struct *vma = vmf->vma;
> > >  	struct vfio_pci_device *vdev = vma->vm_private_data;
> > > +	vm_fault_t ret = VM_FAULT_NOPAGE;
> > > +
> > > +	mutex_lock(&vdev->vma_lock);
> > > +	down_read(&vdev->memory_lock);  
> > 
> > I remembered to have seen the fault() handling FAULT_FLAG_RETRY_NOWAIT at least
> > in the very first version, but it's not here any more...  Could I ask what's
> > the reason behind?  I probably have missed something along with the versions,
> > I'm just not sure whether e.g. this would potentially block a GUP caller even
> > if it's with FOLL_NOWAIT.
> 
> This is largely what v2 was about, from the cover letter:
> 
>     Locking in 3/ is substantially changed to avoid the retry scenario
>     within the fault handler, therefore a caller who does not allow
>     retry will no longer receive a SIGBUS on contention.
> 
> The discussion thread starts here:
> 
> https://lore.kernel.org/kvm/20200501234849.GQ26002@ziepe.ca/

[1]

> 
> Feel free to interject if there's something that doesn't make sense,
> the idea is that since we've fixed the lock ordering we never need to
> release one lock to wait for another, therefore we can wait for the
> lock.  I'm under the impression that we can wait for the lock
> regardless of the flags under these conditions.

I see; thanks for the link.  Sorry I should probably follow up the discussion
and ask the question earlier, anyway...

For what I understand now, IMHO we should still need all those handlings of
FAULT_FLAG_RETRY_NOWAIT like in the initial version.  E.g., IIUC KVM gup will
try with FOLL_NOWAIT when async is allowed, before the complete slow path.  I'm
not sure what would be the side effect of that if fault() blocked it.  E.g.,
the caller could be in an atomic context.

But now I also agree that VM_FAULT_SIGBUS is probably not correct there in the
initial version [1] - I thought it was OK initially (after all after the
multiple fault retry series we should always be with FAULT_FLAG_ALLOW_RETRY..).
However after some thinking... it should be the common slow path where retry is
simply not allowed.  So IMHO instead of SIGBUS there, we should also use all
the slow path of the locks.  That'll be safe then because it's never going to
be with FAULT_FLAG_RETRY_NOWAIT (FAULT_FLAG_RETRY_NOWAIT depends on
FAULT_FLAG_ALLOW_RETRY).

A reference code could be __lock_page_or_retry() where the lock_page could wait
just like we taking the sems/mutexes, and the previous SIGBUS case would
corresponds to this chunk of __lock_page_or_retry():

	} else {
		if (flags & FAULT_FLAG_KILLABLE) {
			int ret;

			ret = __lock_page_killable(page);
			if (ret) {
				up_read(&mm->mmap_sem);
				return 0;
			}
		} else
			__lock_page(page);
		return 1;
	}

Thanks,

-- 
Peter Xu


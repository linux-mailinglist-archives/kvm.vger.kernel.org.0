Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC5A13DEF1
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 16:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgAPPhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 10:37:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39424 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726730AbgAPPhm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 10:37:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579189061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rxATJWJ4rcj/wFapXV73v8XDh+PJUvOaeSFeG4RlODo=;
        b=dN4qqa3u9nEQ01SHGpEwgDoTqMONFWWOlFt7TXpAA99e28tFbagsw3vac/ojAqiN3QJr8i
        nPSTDx2W75IAhOBdNkJ+0EX5Hw6NFH0ZH70YK6exOndyIo7/1mxi3Tnv5aOy1pWyRUPWdv
        +94/vdjWsIQiO4c/dqnqi1NtaEjhzKc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-46WynO7RPH-Cvo2cy4apiw-1; Thu, 16 Jan 2020 10:37:37 -0500
X-MC-Unique: 46WynO7RPH-Cvo2cy4apiw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A0C386A063;
        Thu, 16 Jan 2020 15:37:36 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44B9166D22;
        Thu, 16 Jan 2020 15:37:30 +0000 (UTC)
Date:   Thu, 16 Jan 2020 08:37:29 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [PATCH v2 2/2] drm/i915/gvt: subsitute kvm_read/write_guest
 with vfio_dma_rw
Message-ID: <20200116083729.40983f38@w520.home>
In-Reply-To: <20200116054941.GB1759@joy-OptiPlex-7040>
References: <20200115034132.2753-1-yan.y.zhao@intel.com>
        <20200115035455.12417-1-yan.y.zhao@intel.com>
        <20200115130651.29d7e9e0@w520.home>
        <20200116054941.GB1759@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Jan 2020 00:49:41 -0500
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Thu, Jan 16, 2020 at 04:06:51AM +0800, Alex Williamson wrote:
> > On Tue, 14 Jan 2020 22:54:55 -0500
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > As a device model, it is better to read/write guest memory using vfio
> > > interface, so that vfio is able to maintain dirty info of device IOVAs.
> > > 
> > > Compared to kvm interfaces kvm_read/write_guest(), vfio_dma_rw() has ~600
> > > cycles more overhead on average.
> > > 
> > > -------------------------------------
> > > |    interface     | avg cpu cycles |
> > > |-----------------------------------|
> > > | kvm_write_guest  |     1554       |
> > > | ----------------------------------|
> > > | kvm_read_guest   |     707        |
> > > |-----------------------------------|
> > > | vfio_dma_rw(w)   |     2274       |
> > > |-----------------------------------|
> > > | vfio_dma_rw(r)   |     1378       |
> > > -------------------------------------  
> > 
> > In v1 you had:
> > 
> > -------------------------------------
> > |    interface     | avg cpu cycles |
> > |-----------------------------------|
> > | kvm_write_guest  |     1546       |
> > | ----------------------------------|
> > | kvm_read_guest   |     686        |
> > |-----------------------------------|
> > | vfio_iova_rw(w)  |     2233       |
> > |-----------------------------------|
> > | vfio_iova_rw(r)  |     1262       |
> > -------------------------------------
> > 
> > So the kvm numbers remained within +0.5-3% while the vfio numbers are
> > now +1.8-9.2%.  I would have expected the algorithm change to at least
> > not be worse for small accesses and be better for accesses crossing
> > page boundaries.  Do you know what happened?
> >  
> I only tested the 4 interfaces in GVT's environment, where most of the
> guest memory accesses are less than one page.
> And the different fluctuations should be caused by the locks.
> vfio_dma_rw contends locks with other vfio accesses which are assumed to
> be abundant in the case of GVT.

Hmm, so maybe it's time to convert vfio_iommu.lock from a mutex to a
rwsem?  Thanks,

Alex

> > > Comparison of benchmarks scores are as blow:
> > > ------------------------------------------------------
> > > |  avg score  | kvm_read/write_guest  | vfio_dma_rw  |
> > > |----------------------------------------------------|
> > > |   Glmark2   |         1284          |    1296      |
> > > |----------------------------------------------------|
> > > |  Lightsmark |         61.24         |    61.27     |
> > > |----------------------------------------------------|
> > > |  OpenArena  |         140.9         |    137.4     |
> > > |----------------------------------------------------|
> > > |   Heaven    |          671          |     670      |
> > > ------------------------------------------------------
> > > No obvious performance downgrade found.
> > > 
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > ---
> > >  drivers/gpu/drm/i915/gvt/kvmgt.c | 26 +++++++-------------------
> > >  1 file changed, 7 insertions(+), 19 deletions(-)
> > > 
> > > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > > index bd79a9718cc7..17edc9a7ff05 100644
> > > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > > @@ -1966,31 +1966,19 @@ static int kvmgt_rw_gpa(unsigned long handle, unsigned long gpa,
> > >  			void *buf, unsigned long len, bool write)
> > >  {
> > >  	struct kvmgt_guest_info *info;
> > > -	struct kvm *kvm;
> > > -	int idx, ret;
> > > -	bool kthread = current->mm == NULL;
> > > +	int ret;
> > > +	struct intel_vgpu *vgpu;
> > > +	struct device *dev;
> > >  
> > >  	if (!handle_valid(handle))
> > >  		return -ESRCH;
> > >  
> > >  	info = (struct kvmgt_guest_info *)handle;
> > > -	kvm = info->kvm;
> > > -
> > > -	if (kthread) {
> > > -		if (!mmget_not_zero(kvm->mm))
> > > -			return -EFAULT;
> > > -		use_mm(kvm->mm);
> > > -	}
> > > -
> > > -	idx = srcu_read_lock(&kvm->srcu);
> > > -	ret = write ? kvm_write_guest(kvm, gpa, buf, len) :
> > > -		      kvm_read_guest(kvm, gpa, buf, len);
> > > -	srcu_read_unlock(&kvm->srcu, idx);
> > > +	vgpu = info->vgpu;
> > > +	dev = mdev_dev(vgpu->vdev.mdev);
> > >  
> > > -	if (kthread) {
> > > -		unuse_mm(kvm->mm);
> > > -		mmput(kvm->mm);
> > > -	}
> > > +	ret = write ? vfio_dma_rw(dev, gpa, buf, len, true) :
> > > +			vfio_dma_rw(dev, gpa, buf, len, false);  
> > 
> > As Paolo suggested previously, this can be simplified:
> > 
> > ret = vfio_dma_rw(dev, gpa, buf, len, write);
> >  
> > >  
> > >  	return ret;  
> > 
> > Or even more simple, remove the ret variable:
> > 
> > return vfio_dma_rw(dev, gpa, buf, len, write);
> >   
> oh, it seems that I missed Paolo's mail. will change it. thank you!
> 
> Thanks
> Yan
> >   
> > >  }  
> >   
> 


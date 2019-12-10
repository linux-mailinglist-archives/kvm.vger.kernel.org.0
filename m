Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D07DC117C0B
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 01:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfLJADt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 19:03:49 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41084 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727276AbfLJADt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Dec 2019 19:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575936226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zlkiQxJLIa+Ed4l2NQZX8EhOJaqRxW+CVdkaxr7VUiI=;
        b=GsAjozbwOXiM0rrYYXyK8vdjrvF+lbL/uBwo7ePjQyUaOnb1L0+x7QcbTM3g94oZVAIxN5
        uMAxyJuKrFWGgfqPrh58HAQ08AztkHtNzopPN+g6aLXhpg3GFELQsyEVmN73HZECrdsoZ/
        Gho5GF14KpuwPWO8K7r+PgaxUREf7zE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-eLrsh0tuMhSM4dFr0yZOJg-1; Mon, 09 Dec 2019 19:03:45 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52EB41804485;
        Tue, 10 Dec 2019 00:03:43 +0000 (UTC)
Received: from x1.home (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FCE860148;
        Tue, 10 Dec 2019 00:03:40 +0000 (UTC)
Date:   Mon, 9 Dec 2019 17:03:39 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [RFC PATCH 1/9] vfio/pci: introduce mediate ops to intercept
 vfio-pci ops
Message-ID: <20191209170339.2cb3d06e@x1.home>
In-Reply-To: <20191209034225.GK31791@joy-OptiPlex-7040>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
        <20191205032536.29653-1-yan.y.zhao@intel.com>
        <20191205165519.106bd210@x1.home>
        <20191206075655.GG31791@joy-OptiPlex-7040>
        <20191206142226.2698a2be@x1.home>
        <20191209034225.GK31791@joy-OptiPlex-7040>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: eLrsh0tuMhSM4dFr0yZOJg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 8 Dec 2019 22:42:25 -0500
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Sat, Dec 07, 2019 at 05:22:26AM +0800, Alex Williamson wrote:
> > On Fri, 6 Dec 2019 02:56:55 -0500
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > On Fri, Dec 06, 2019 at 07:55:19AM +0800, Alex Williamson wrote:  
> > > > On Wed,  4 Dec 2019 22:25:36 -0500
> > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >     
> > > > > when vfio-pci is bound to a physical device, almost all the hardware
> > > > > resources are passthroughed.
> > > > > Sometimes, vendor driver of this physcial device may want to mediate some
> > > > > hardware resource access for a short period of time, e.g. dirty page
> > > > > tracking during live migration.
> > > > > 
> > > > > Here we introduce mediate ops in vfio-pci for this purpose.
> > > > > 
> > > > > Vendor driver can register a mediate ops to vfio-pci.
> > > > > But rather than directly bind to the passthroughed device, the
> > > > > vendor driver is now either a module that does not bind to any device or
> > > > > a module binds to other device.
> > > > > E.g. when passing through a VF device that is bound to vfio-pci modules,
> > > > > PF driver that binds to PF device can register to vfio-pci to mediate
> > > > > VF's regions, hence supporting VF live migration.
> > > > > 
> > > > > The sequence goes like this:
> > > > > 1. Vendor driver register its vfio_pci_mediate_ops to vfio-pci driver
> > > > > 
> > > > > 2. vfio-pci maintains a list of those registered vfio_pci_mediate_ops
> > > > > 
> > > > > 3. Whenever vfio-pci opens a device, it searches the list and call
> > > > > vfio_pci_mediate_ops->open() to check whether a vendor driver supports
> > > > > mediating this device.
> > > > > Upon a success return value of from vfio_pci_mediate_ops->open(),
> > > > > vfio-pci will stop list searching and store a mediate handle to
> > > > > represent this open into vendor driver.
> > > > > (so if multiple vendor drivers support mediating a device through
> > > > > vfio_pci_mediate_ops, only one will win, depending on their registering
> > > > > sequence)
> > > > > 
> > > > > 4. Whenever a VFIO_DEVICE_GET_REGION_INFO ioctl is received in vfio-pci
> > > > > ops, it will chain into vfio_pci_mediate_ops->get_region_info(), so that
> > > > > vendor driver is able to override a region's default flags and caps,
> > > > > e.g. adding a sparse mmap cap to passthrough only sub-regions of a whole
> > > > > region.
> > > > > 
> > > > > 5. vfio_pci_rw()/vfio_pci_mmap() first calls into
> > > > > vfio_pci_mediate_ops->rw()/vfio_pci_mediate_ops->mmaps().
> > > > > if pt=true is rteturned, vfio_pci_rw()/vfio_pci_mmap() will further
> > > > > passthrough this read/write/mmap to physical device, otherwise it just
> > > > > returns without touch physical device.
> > > > > 
> > > > > 6. When vfio-pci closes a device, vfio_pci_release() chains into
> > > > > vfio_pci_mediate_ops->release() to close the reference in vendor driver.
> > > > > 
> > > > > 7. Vendor driver unregister its vfio_pci_mediate_ops when driver exits
> > > > > 
> > > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > > 
> > > > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > > > ---
> > > > >  drivers/vfio/pci/vfio_pci.c         | 146 ++++++++++++++++++++++++++++
> > > > >  drivers/vfio/pci/vfio_pci_private.h |   2 +
> > > > >  include/linux/vfio.h                |  16 +++
> > > > >  3 files changed, 164 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > > > > index 02206162eaa9..55080ff29495 100644
> > > > > --- a/drivers/vfio/pci/vfio_pci.c
> > > > > +++ b/drivers/vfio/pci/vfio_pci.c
> > > > > @@ -54,6 +54,14 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
> > > > >  MODULE_PARM_DESC(disable_idle_d3,
> > > > >  		 "Disable using the PCI D3 low power state for idle, unused devices");
> > > > >  
> > > > > +static LIST_HEAD(mediate_ops_list);
> > > > > +static DEFINE_MUTEX(mediate_ops_list_lock);
> > > > > +struct vfio_pci_mediate_ops_list_entry {
> > > > > +	struct vfio_pci_mediate_ops	*ops;
> > > > > +	int				refcnt;
> > > > > +	struct list_head		next;
> > > > > +};
> > > > > +
> > > > >  static inline bool vfio_vga_disabled(void)
> > > > >  {
> > > > >  #ifdef CONFIG_VFIO_PCI_VGA
> > > > > @@ -472,6 +480,10 @@ static void vfio_pci_release(void *device_data)
> > > > >  	if (!(--vdev->refcnt)) {
> > > > >  		vfio_spapr_pci_eeh_release(vdev->pdev);
> > > > >  		vfio_pci_disable(vdev);
> > > > > +		if (vdev->mediate_ops && vdev->mediate_ops->release) {
> > > > > +			vdev->mediate_ops->release(vdev->mediate_handle);
> > > > > +			vdev->mediate_ops = NULL;
> > > > > +		}
> > > > >  	}
> > > > >  
> > > > >  	mutex_unlock(&vdev->reflck->lock);
> > > > > @@ -483,6 +495,7 @@ static int vfio_pci_open(void *device_data)
> > > > >  {
> > > > >  	struct vfio_pci_device *vdev = device_data;
> > > > >  	int ret = 0;
> > > > > +	struct vfio_pci_mediate_ops_list_entry *mentry;
> > > > >  
> > > > >  	if (!try_module_get(THIS_MODULE))
> > > > >  		return -ENODEV;
> > > > > @@ -495,6 +508,30 @@ static int vfio_pci_open(void *device_data)
> > > > >  			goto error;
> > > > >  
> > > > >  		vfio_spapr_pci_eeh_open(vdev->pdev);
> > > > > +		mutex_lock(&mediate_ops_list_lock);
> > > > > +		list_for_each_entry(mentry, &mediate_ops_list, next) {
> > > > > +			u64 caps;
> > > > > +			u32 handle;    
> > > > 
> > > > Wouldn't it seem likely that the ops provider might use this handle as
> > > > a pointer, so we'd want it to be an opaque void*?
> > > >    
> > > yes, you are right, handle as a pointer is much better. will change it.
> > > Thanks :)
> > >   
> > > > > +
> > > > > +			memset(&caps, 0, sizeof(caps));    
> > > > 
> > > > @caps has no purpose here, add it if/when we do something with it.
> > > > It's also a standard type, why are we memset'ing it rather than just
> > > > =0??
> > > >     
> > > > > +			ret = mentry->ops->open(vdev->pdev, &caps, &handle);
> > > > > +			if (!ret)  {
> > > > > +				vdev->mediate_ops = mentry->ops;
> > > > > +				vdev->mediate_handle = handle;
> > > > > +
> > > > > +				pr_info("vfio pci found mediate_ops %s, caps=%llx, handle=%x for %x:%x\n",
> > > > > +						vdev->mediate_ops->name, caps,
> > > > > +						handle, vdev->pdev->vendor,
> > > > > +						vdev->pdev->device);    
> > > > 
> > > > Generally not advisable to make user accessible printks.
> > > >    
> > > ok.
> > >   
> > > > > +				/*
> > > > > +				 * only find the first matching mediate_ops,
> > > > > +				 * and add its refcnt
> > > > > +				 */
> > > > > +				mentry->refcnt++;
> > > > > +				break;
> > > > > +			}
> > > > > +		}
> > > > > +		mutex_unlock(&mediate_ops_list_lock);
> > > > >  	}
> > > > >  	vdev->refcnt++;
> > > > >  error:
> > > > > @@ -736,6 +773,14 @@ static long vfio_pci_ioctl(void *device_data,
> > > > >  			info.size = pdev->cfg_size;
> > > > >  			info.flags = VFIO_REGION_INFO_FLAG_READ |
> > > > >  				     VFIO_REGION_INFO_FLAG_WRITE;
> > > > > +
> > > > > +			if (vdev->mediate_ops &&
> > > > > +					vdev->mediate_ops->get_region_info) {
> > > > > +				vdev->mediate_ops->get_region_info(
> > > > > +						vdev->mediate_handle,
> > > > > +						&info, &caps, NULL);
> > > > > +			}    
> > > > 
> > > > These would be a lot cleaner if we could just call a helper function:
> > > > 
> > > > void vfio_pci_region_info_mediation_hook(vdev, info, caps, etc...)
> > > > {
> > > >    if (vdev->mediate_ops 
> > > >        vdev->mediate_ops->get_region_info)
> > > > 	vdev->mediate_ops->get_region_info(vdev->mediate_handle,
> > > > 					   &info, &caps, NULL);
> > > > }
> > > > 
> > > > I'm not thrilled with all these hooks, but not open coding every one of
> > > > them might help.    
> > > 
> > > ok. got it.  
> > > >     
> > > > > +
> > > > >  			break;
> > > > >  		case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
> > > > >  			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> > > > > @@ -756,6 +801,13 @@ static long vfio_pci_ioctl(void *device_data,
> > > > >  				}
> > > > >  			}
> > > > >  
> > > > > +			if (vdev->mediate_ops &&
> > > > > +					vdev->mediate_ops->get_region_info) {
> > > > > +				vdev->mediate_ops->get_region_info(
> > > > > +						vdev->mediate_handle,
> > > > > +						&info, &caps, NULL);
> > > > > +			}
> > > > > +
> > > > >  			break;
> > > > >  		case VFIO_PCI_ROM_REGION_INDEX:
> > > > >  		{
> > > > > @@ -794,6 +846,14 @@ static long vfio_pci_ioctl(void *device_data,
> > > > >  			}
> > > > >  
> > > > >  			pci_write_config_word(pdev, PCI_COMMAND, orig_cmd);
> > > > > +
> > > > > +			if (vdev->mediate_ops &&
> > > > > +					vdev->mediate_ops->get_region_info) {
> > > > > +				vdev->mediate_ops->get_region_info(
> > > > > +						vdev->mediate_handle,
> > > > > +						&info, &caps, NULL);
> > > > > +			}
> > > > > +
> > > > >  			break;
> > > > >  		}
> > > > >  		case VFIO_PCI_VGA_REGION_INDEX:
> > > > > @@ -805,6 +865,13 @@ static long vfio_pci_ioctl(void *device_data,
> > > > >  			info.flags = VFIO_REGION_INFO_FLAG_READ |
> > > > >  				     VFIO_REGION_INFO_FLAG_WRITE;
> > > > >  
> > > > > +			if (vdev->mediate_ops &&
> > > > > +					vdev->mediate_ops->get_region_info) {
> > > > > +				vdev->mediate_ops->get_region_info(
> > > > > +						vdev->mediate_handle,
> > > > > +						&info, &caps, NULL);
> > > > > +			}
> > > > > +
> > > > >  			break;
> > > > >  		default:
> > > > >  		{
> > > > > @@ -839,6 +906,13 @@ static long vfio_pci_ioctl(void *device_data,
> > > > >  				if (ret)
> > > > >  					return ret;
> > > > >  			}
> > > > > +
> > > > > +			if (vdev->mediate_ops &&
> > > > > +					vdev->mediate_ops->get_region_info) {
> > > > > +				vdev->mediate_ops->get_region_info(
> > > > > +						vdev->mediate_handle,
> > > > > +						&info, &caps, &cap_type);
> > > > > +			}
> > > > >  		}
> > > > >  		}
> > > > >  
> > > > > @@ -1151,6 +1225,16 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
> > > > >  	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
> > > > >  		return -EINVAL;
> > > > >  
> > > > > +	if (vdev->mediate_ops && vdev->mediate_ops->rw) {
> > > > > +		int ret;
> > > > > +		bool pt = true;
> > > > > +
> > > > > +		ret = vdev->mediate_ops->rw(vdev->mediate_handle,
> > > > > +				buf, count, ppos, iswrite, &pt);
> > > > > +		if (!pt)
> > > > > +			return ret;
> > > > > +	}
> > > > > +
> > > > >  	switch (index) {
> > > > >  	case VFIO_PCI_CONFIG_REGION_INDEX:
> > > > >  		return vfio_pci_config_rw(vdev, buf, count, ppos, iswrite);
> > > > > @@ -1200,6 +1284,15 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
> > > > >  	u64 phys_len, req_len, pgoff, req_start;
> > > > >  	int ret;
> > > > >  
> > > > > +	if (vdev->mediate_ops && vdev->mediate_ops->mmap) {
> > > > > +		int ret;
> > > > > +		bool pt = true;
> > > > > +
> > > > > +		ret = vdev->mediate_ops->mmap(vdev->mediate_handle, vma, &pt);
> > > > > +		if (!pt)
> > > > > +			return ret;
> > > > > +	}    
> > > > 
> > > > There must be a better way to do all these.  Do we really want to call
> > > > into ops for every rw or mmap, have the vendor code decode a region,
> > > > and maybe or maybe not have it handle it?  It's pretty ugly.  Do we    
> > > 
> > > do you think below flow is good ?
> > > 1. in mediate_ops->open(), return
> > > (1) region[] indexed by region index, if a mediate driver supports mediating
> > > region[i], region[i].ops->get_region_info, regions[i].ops->rw, or
> > > regions[i].ops->mmap is not null.
> > > (2) irq_info[] indexed by irq index, if a mediate driver supports mediating
> > > irq_info[i], irq_info[i].ops->get_irq_info or irq_info[i].ops->set_irq_info
> > > is not null.
> > > 
> > > Then, vfio_pci_rw/vfio_pci_mmap/vfio_pci_ioctl only call into those
> > > non-null hooks.  
> > 
> > Or would it be better to always call into the hooks and the vendor
> > driver is allowed to selectively replace the hooks for regions they
> > want to mediate.  For example, region[i].ops->rw could by default point
> > to vfio_pci_default_rw() and the mediation driver would have a
> > mechanism to replace that with its own vendorABC_vfio_pci_rw().  We
> > could export vfio_pci_default_rw() such that the vendor driver would be
> > responsible for calling it as necessary.
> >  
> good idea :)
> 
> > > > need the mediation provider to be able to dynamically setup the ops per    
> > > May I confirm that you are not saying dynamic registering mediate ops
> > > after vfio-pci already opened a device, right?  
> > 
> > I'm not necessarily excluding or advocating for that.
> >   
> ok. got it.
> 
> > > > region and export the default handlers out for them to call?
> > > >    
> > > could we still keep checking return value of the hooks rather than
> > > export default handlers? Otherwise at least vfio_pci_default_ioctl(),
> > > vfio_pci_default_rw(), and vfio_pci_default_mmap() need to be exported.  
> > 
> > The ugliness of vfio-pci having all these vendor branches is what I'm
> > trying to avoid, so I really am not a fan of the idea or mechanism that
> > the vfio-pci core code is directly involving a mediation driver and
> > handling the return for every entry point.
> >  
> I see :)
> > > > > +
> > > > >  	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> > > > >  
> > > > >  	if (vma->vm_end < vma->vm_start)
> > > > > @@ -1629,8 +1722,17 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
> > > > >  
> > > > >  static void __exit vfio_pci_cleanup(void)
> > > > >  {
> > > > > +	struct vfio_pci_mediate_ops_list_entry *mentry, *n;
> > > > > +
> > > > >  	pci_unregister_driver(&vfio_pci_driver);
> > > > >  	vfio_pci_uninit_perm_bits();
> > > > > +
> > > > > +	mutex_lock(&mediate_ops_list_lock);
> > > > > +	list_for_each_entry_safe(mentry, n,  &mediate_ops_list, next) {
> > > > > +		list_del(&mentry->next);
> > > > > +		kfree(mentry);
> > > > > +	}
> > > > > +	mutex_unlock(&mediate_ops_list_lock);    
> > > > 
> > > > Is it even possible to unload vfio-pci while there are mediation
> > > > drivers registered?  I don't think the module interactions are well
> > > > thought out here, ex. do you really want i40e to have build and runtime
> > > > dependencies on vfio-pci?  I don't think so.
> > > >     
> > > Currently, yes, i40e has build dependency on vfio-pci.
> > > It's like this, if i40e decides to support SRIOV and compiles in vf
> > > related code who depends on vfio-pci, it will also have build dependency
> > > on vfio-pci. isn't it natural?  
> > 
> > No, this is not natural.  There are certainly i40e VF use cases that
> > have no interest in vfio and having dependencies between the two
> > modules is unacceptable.  I think you probably want to modularize the
> > i40e vfio support code and then perhaps register a table in vfio-pci
> > that the vfio-pci code can perform a module request when using a
> > compatible device.  Just and idea, there might be better options.  I
> > will not accept a solution that requires unloading the i40e driver in
> > order to unload the vfio-pci driver.  It's inconvenient with just one
> > NIC driver, imagine how poorly that scales.
> >   
> what about this way:
> mediate driver registers a module notifier and every time when
> vfio_pci is loaded, register to vfio_pci its mediate ops?
> (Just like in below sample code)
> This way vfio-pci is free to unload and this registering only gives
> vfio-pci a name of what module to request.
> After that,
> in vfio_pci_open(), vfio-pci requests the mediate driver. (or puts
> the mediate driver when mediate driver does not support mediating the
> device)
> in vfio_pci_release(), vfio-pci puts the mediate driver.
> 
> static void register_mediate_ops(void)
> {
>         int (*func)(struct vfio_pci_mediate_ops *ops) = NULL;
> 
>         func = symbol_get(vfio_pci_register_mediate_ops);
> 
>         if (func) {
>                 func(&igd_dt_ops);
>                 symbol_put(vfio_pci_register_mediate_ops);
>         }
> }
> 
> static int igd_module_notify(struct notifier_block *self,
>                               unsigned long val, void *data)
> {
>         struct module *mod = data;
>         int ret = 0;
> 
>         switch (val) {
>         case MODULE_STATE_LIVE:
>                 if (!strcmp(mod->name, "vfio_pci"))
>                         register_mediate_ops();
>                 break;
>         case MODULE_STATE_GOING:
>                 break;
>         default:
>                 break;
>         }
>         return ret;
> }
> 
> static struct notifier_block igd_module_nb = {
>         .notifier_call = igd_module_notify,
>         .priority = 0,
> };
> 
> 
> 
> static int __init igd_dt_init(void)
> {
> 	...
> 	register_mediate_ops();
> 	register_module_notifier(&igd_module_nb);
> 	...
> 	return 0;
> }


No, this is bad.  Please look at MODULE_ALIAS() and request_module() as
used in the vfio-platform for loading reset driver modules.  I think
the correct approach is that vfio-pci should perform a request_module()
based on the device being probed.  Having the mediation provider
listening for vfio-pci and registering itself regardless of whether we
intend to use it assumes that we will want to use it and assumes that
the mediation provider module is already loaded.  We should be able to
support demand loading of modules that may serve no other purpose than
providing this mediation.  Thanks,

Alex

> > > > >  }
> > > > >  
> > > > >  static void __init vfio_pci_fill_ids(void)
> > > > > @@ -1697,6 +1799,50 @@ static int __init vfio_pci_init(void)
> > > > >  	return ret;
> > > > >  }
> > > > >  
> > > > > +int vfio_pci_register_mediate_ops(struct vfio_pci_mediate_ops *ops)
> > > > > +{
> > > > > +	struct vfio_pci_mediate_ops_list_entry *mentry;
> > > > > +
> > > > > +	mutex_lock(&mediate_ops_list_lock);
> > > > > +	mentry = kzalloc(sizeof(*mentry), GFP_KERNEL);
> > > > > +	if (!mentry) {
> > > > > +		mutex_unlock(&mediate_ops_list_lock);
> > > > > +		return -ENOMEM;
> > > > > +	}
> > > > > +
> > > > > +	mentry->ops = ops;
> > > > > +	mentry->refcnt = 0;    
> > > > 
> > > > It's kZalloc'd, this is unnecessary.
> > > >    
> > > right :)   
> > > > > +	list_add(&mentry->next, &mediate_ops_list);    
> > > > 
> > > > Check for duplicates?
> > > >     
> > > ok. will do it.  
> > > > > +
> > > > > +	pr_info("registered dm ops %s\n", ops->name);
> > > > > +	mutex_unlock(&mediate_ops_list_lock);
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > +EXPORT_SYMBOL(vfio_pci_register_mediate_ops);
> > > > > +
> > > > > +void vfio_pci_unregister_mediate_ops(struct vfio_pci_mediate_ops *ops)
> > > > > +{
> > > > > +	struct vfio_pci_mediate_ops_list_entry *mentry, *n;
> > > > > +
> > > > > +	mutex_lock(&mediate_ops_list_lock);
> > > > > +	list_for_each_entry_safe(mentry, n,  &mediate_ops_list, next) {
> > > > > +		if (mentry->ops != ops)
> > > > > +			continue;
> > > > > +
> > > > > +		mentry->refcnt--;    
> > > > 
> > > > Whose reference is this removing?
> > > >     
> > > I intended to prevent mediate driver from calling unregister mediate ops
> > > while there're still opened devices in it.
> > > after a successful mediate_ops->open(), mentry->refcnt++.
> > > after calling mediate_ops->release(). mentry->refcnt--.
> > > 
> > > (seems in this RFC, I missed a mentry->refcnt-- after calling
> > > mediate_ops->release())
> > > 
> > >   
> > > > > +		if (!mentry->refcnt) {
> > > > > +			list_del(&mentry->next);
> > > > > +			kfree(mentry);
> > > > > +		} else
> > > > > +			pr_err("vfio_pci unregister mediate ops %s error\n",
> > > > > +					mentry->ops->name);    
> > > > 
> > > > This is bad, we should hold a reference to the module providing these
> > > > ops for each use of it such that the module cannot be removed while
> > > > it's in use.  Otherwise we enter a very bad state here and it's
> > > > trivially accessible by an admin remove the module while in use.    
> > > mediate driver is supposed to ref its own module on a success
> > > mediate_ops->open(), and deref its own module on mediate_ops->release().
> > > so, it can't be accidentally removed.  
> > 
> > Where was that semantic expressed in this series?  We should create
> > interfaces that are hard to use incorrectly.  It is far too easy for a
> > vendor driver to overlook such a requirement, which means fixing the
> > same bugs repeatedly for each vendor.  It needs to be improved.  Thanks,  
> 
> right. will improve it.
> 
> Thanks
> Yan
> 


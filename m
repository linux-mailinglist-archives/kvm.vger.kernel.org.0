Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069442D4798
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 18:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732658AbgLIRKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 12:10:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55898 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731212AbgLIRKg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 12:10:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607533749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1qPoOFTvwR3YmRqPpDyUkhdJjDsVNxA196Sib8E6mcE=;
        b=gjZR9oH4fFjvgE/BGXH3bEI7W2MFjaZoNqGpb8DJIyxjsSrHhtnjKPN61cTw9ehBRHgdJf
        7vG9qTVhBoVlE2Xlf7KenCUhq7jiHRaxqQnVd1SgRCh4nxIHXtZxhOLj/W8MaeHkSM3XML
        xgm3nn5yJD9hcw9/bKqNreeG/Rl5SP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-AfMT5IbOMk22RxQARQvoxg-1; Wed, 09 Dec 2020 12:09:03 -0500
X-MC-Unique: AfMT5IbOMk22RxQARQvoxg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89FAB59;
        Wed,  9 Dec 2020 17:09:02 +0000 (UTC)
Received: from omen.home (ovpn-112-10.phx2.redhat.com [10.3.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E5FB10023AC;
        Wed,  9 Dec 2020 17:09:02 +0000 (UTC)
Date:   Wed, 9 Dec 2020 10:09:01 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Colin Xu <Colin.Xu@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fonn, Swee Yee" <swee.yee.fonn@intel.com>
Subject: Re: [RFC PATCH] vfio/pci: Allow force needs_pm_restore as specified
 by device:vendor
Message-ID: <20201209100901.174a73db@omen.home>
In-Reply-To: <29124528-f02a-008e-fab1-60f6b6e643b7@intel.com>
References: <20201125021824.27411-1-colin.xu@intel.com>
        <20201125085312.63510f9f@w520.home>
        <7e7a83ca-8530-1afa-4b85-2ef76fb99a5c@intel.com>
        <20201127083529.6c4a780c@x1.home>
        <29124528-f02a-008e-fab1-60f6b6e643b7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 9 Dec 2020 13:14:00 +0800
Colin Xu <Colin.Xu@intel.com> wrote:

> On 11/27/20 11:35 PM, Alex Williamson wrote:
> > On Fri, 27 Nov 2020 11:53:39 +0800
> > Colin Xu <Colin.Xu@intel.com> wrote:
> >  
> >> On 11/25/20 11:53 PM, Alex Williamson wrote:  
> >>> On Wed, 25 Nov 2020 10:18:24 +0800
> >>> Colin Xu <colin.xu@intel.com> wrote:
> >>>     
> >>>> Force specific device listed in params pm_restore_ids to follow
> >>>> device state save/restore as needs_pm_restore.
> >>>> Some device has NoSoftRst so will skip current state save/restore enabled
> >>>> by needs_pm_restore. However once the device experienced power state
> >>>> D3<->D0 transition, either by idle_d3 or the guest driver changes PM_CTL,
> >>>> the guest driver won't get correct devie state although the configure
> >>>> space doesn't change.  
> >>> It sounds like you're describing a device that incorrectly exposes
> >>> NoSoftRst when there is in fact some sort of internal reset that
> >>> requires reprogramming config space.  What device requires this?  How
> >>> is a user to know when this option is required?  It seems like this
> >>> would be better handled via a quirk in PCI core that sets a device flag
> >>> that the NoSoftRst value is incorrect for the specific affected
> >>> devices.  Thanks,
> >>>
> >>> Alex  
> >> Thanks for the feedback.
> >>
> >> The device found are: Comet Lake PCH Serial IO I2C Controller
> >> [8086:06e8]
> >> [8086:06e9]
> >>
> >> Yes you're right, there is no straight way for user to know the device.
> >> The above device I found is during pass through them to VM. Although
> >> adding such param may help in certain scenario, it still too
> >> device-specific but not common in most cases.  
> >
> > The chipset i2c controller seems like a pretty suspicious device for
> > Intel to advocate assigning to a VM.  Are you assigning this to satisfy
> > the isolation issue that we often see where a device like a NIC is
> > grouped together with platform management devices due to lack of
> > multifunction ACS?  If that's the case, I would think it would make
> > more sense to investigate from the perspective of whether there is
> > actually DMA isolation between those integrated, multifunction devices
> > and if so, implement ACS quirks to expose that isolation.  Thanks,
> >
> > Alex  
> 
> Hi Alex,
> 
> Sorry for late reply. E-mail incorrectly filtered so didn't see this one 
> until manual search.
> 
> The mentioned two I2C controller are in same iommu group and there is NO 
> other device in the same group. The I2C controller is integrated in PCH 
> chipset and there are other devices integrated too, but in different 
> group. When assigning them to a VM, both are assigned, and function 0 is 
> set with multifunction=on. If iommu driver group no other device in the 
> same group, could we assume there is no DMA isolation issue?


Yes, we should always have DMA isolation between IOMMU groups.  My
concern is that I understand these i2c devices to generally provide
access to system/chipset management features, therefore by assigning
them to a VM you're granting that VM not only access to a single
device, but potentially management features which can affect the host
system.  This would generally not be advised for security reasons, so
these configurations are usually only created due to IOMMU grouping
restrictions.  It seems here that you're intentionally assigning these
devices to a VM.  Why?  If this is a development exercise to support
creation of drivers for these devices in a VM, great!  I'm just trying
to figure out if Intel is endorsing this configuration for some
generally useful purpose.  Thanks,

Alex
 
> >>>> Cc: Swee Yee Fonn <swee.yee.fonn@intel.com>
> >>>> Signed-off-by: Colin Xu <colin.xu@intel.com>
> >>>> ---
> >>>>    drivers/vfio/pci/vfio_pci.c | 66 ++++++++++++++++++++++++++++++++++++-
> >>>>    1 file changed, 65 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> >>>> index e6190173482c..50a4141c9e1d 100644
> >>>> --- a/drivers/vfio/pci/vfio_pci.c
> >>>> +++ b/drivers/vfio/pci/vfio_pci.c
> >>>> @@ -34,6 +34,15 @@
> >>>>    #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
> >>>>    #define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
> >>>>    
> >>>> +#define VFIO_MAX_PM_DEV 32
> >>>> +struct vfio_pm_devs {
> >>>> +	struct {
> >>>> +		unsigned short  vendor;
> >>>> +		unsigned short  device;
> >>>> +	} ids[VFIO_MAX_PM_DEV];
> >>>> +	u32 count;
> >>>> +};
> >>>> +
> >>>>    static char ids[1024] __initdata;
> >>>>    module_param_string(ids, ids, sizeof(ids), 0);
> >>>>    MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio driver, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multiple comma separated entries can be specified");
> >>>> @@ -64,6 +73,10 @@ static bool disable_denylist;
> >>>>    module_param(disable_denylist, bool, 0444);
> >>>>    MODULE_PARM_DESC(disable_denylist, "Disable use of device denylist. Disabling the denylist allows binding to devices with known errata that may lead to exploitable stability or security issues when accessed by untrusted users.");
> >>>>    
> >>>> +static char pm_restore_ids[1024] __initdata;
> >>>> +module_param_string(pm_restore_ids, pm_restore_ids, sizeof(pm_restore_ids), 0);
> >>>> +MODULE_PARM_DESC(pm_restore_ids, "comma separated device in format of \"vendor:device\"");
> >>>> +
> >>>>    static inline bool vfio_vga_disabled(void)
> >>>>    {
> >>>>    #ifdef CONFIG_VFIO_PCI_VGA
> >>>> @@ -260,10 +273,50 @@ static bool vfio_pci_nointx(struct pci_dev *pdev)
> >>>>    	return false;
> >>>>    }
> >>>>    
> >>>> +static struct vfio_pm_devs pm_devs = {0};
> >>>> +static void __init vfio_pci_fill_pm_ids(void)
> >>>> +{
> >>>> +	char *p, *id;
> >>>> +	int idx = 0;
> >>>> +
> >>>> +	/* no ids passed actually */
> >>>> +	if (pm_restore_ids[0] == '\0')
> >>>> +		return;
> >>>> +
> >>>> +	/* add ids specified in the module parameter */
> >>>> +	p = pm_restore_ids;
> >>>> +	while ((id = strsep(&p, ","))) {
> >>>> +		unsigned int vendor, device = PCI_ANY_ID;
> >>>> +		int fields;
> >>>> +
> >>>> +		if (!strlen(id))
> >>>> +			continue;
> >>>> +
> >>>> +		fields = sscanf(id, "%x:%x", &vendor, &device);
> >>>> +
> >>>> +		if (fields != 2) {
> >>>> +			pr_warn("invalid vendor:device string \"%s\"\n", id);
> >>>> +			continue;
> >>>> +		}
> >>>> +
> >>>> +		if (idx < VFIO_MAX_PM_DEV) {
> >>>> +			pm_devs.ids[idx].vendor = vendor;
> >>>> +			pm_devs.ids[idx].device = device;
> >>>> +			pm_devs.count++;
> >>>> +			idx++;
> >>>> +			pr_info("add [%04x:%04x] for needs_pm_restore\n",
> >>>> +				vendor, device);
> >>>> +		} else {
> >>>> +			pr_warn("Exceed maximum %d, skip adding [%04x:%04x] for needs_pm_restore\n",
> >>>> +				VFIO_MAX_PM_DEV, vendor, device);
> >>>> +		}
> >>>> +	}
> >>>> +}
> >>>> +
> >>>>    static void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
> >>>>    {
> >>>>    	struct pci_dev *pdev = vdev->pdev;
> >>>> -	u16 pmcsr;
> >>>> +	u16 pmcsr, idx;
> >>>>    
> >>>>    	if (!pdev->pm_cap)
> >>>>    		return;
> >>>> @@ -271,6 +324,16 @@ static void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
> >>>>    	pci_read_config_word(pdev, pdev->pm_cap + PCI_PM_CTRL, &pmcsr);
> >>>>    
> >>>>    	vdev->needs_pm_restore = !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET);
> >>>> +
> >>>> +	for (idx = 0; idx < pm_devs.count; idx++) {
> >>>> +		if (vdev->pdev->vendor == pm_devs.ids[idx].vendor &&
> >>>> +		    vdev->pdev->device == pm_devs.ids[idx].device) {
> >>>> +			vdev->needs_pm_restore = true;
> >>>> +			pr_info("force [%04x:%04x] to needs_pm_restore\n",
> >>>> +				vdev->pdev->vendor, vdev->pdev->device);
> >>>> +			break;
> >>>> +		}
> >>>> +	}
> >>>>    }
> >>>>    
> >>>>    /*
> >>>> @@ -2423,6 +2486,7 @@ static int __init vfio_pci_init(void)
> >>>>    		goto out_driver;
> >>>>    
> >>>>    	vfio_pci_fill_ids();
> >>>> +	vfio_pci_fill_pm_ids();
> >>>>    
> >>>>    	if (disable_denylist)
> >>>>    		pr_warn("device denylist disabled.\n");  
> 


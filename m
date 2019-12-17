Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 776EA122542
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 08:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfLQHVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 02:21:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:25160 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbfLQHVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 02:21:07 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 23:21:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,324,1571727600"; 
   d="scan'208";a="266493368"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Dec 2019 23:21:02 -0800
Date:   Tue, 17 Dec 2019 02:12:48 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v10 Kernel 1/5] vfio: KABI for migration interface for
 device state
Message-ID: <20191217071248.GG21868@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1576527700-21805-1-git-send-email-kwankhede@nvidia.com>
 <1576527700-21805-2-git-send-email-kwankhede@nvidia.com>
 <20191216154406.023f912b@x1.home>
 <f773a92a-acbd-874d-34ba-36c1e9ffe442@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f773a92a-acbd-874d-34ba-36c1e9ffe442@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 02:28:44PM +0800, Kirti Wankhede wrote:
> 
> 
> On 12/17/2019 4:14 AM, Alex Williamson wrote:
> > On Tue, 17 Dec 2019 01:51:36 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > 
> >> - Defined MIGRATION region type and sub-type.
> >>
> >> - Defined vfio_device_migration_info structure which will be placed at 0th
> >>    offset of migration region to get/set VFIO device related information.
> >>    Defined members of structure and usage on read/write access.
> >>
> >> - Defined device states and added state transition details in the comment.
> >>
> >> - Added sequence to be followed while saving and resuming VFIO device state
> >>
> >> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >> Reviewed-by: Neo Jia <cjia@nvidia.com>
> >> ---
> >>   include/uapi/linux/vfio.h | 180 ++++++++++++++++++++++++++++++++++++++++++++++
> >>   1 file changed, 180 insertions(+)
> >>
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index 9e843a147ead..a0817ba267c1 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h
> >> @@ -305,6 +305,7 @@ struct vfio_region_info_cap_type {
> >>   #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
> >>   #define VFIO_REGION_TYPE_GFX                    (1)
> >>   #define VFIO_REGION_TYPE_CCW			(2)
> >> +#define VFIO_REGION_TYPE_MIGRATION              (3)
> >>   
> >>   /* sub-types for VFIO_REGION_TYPE_PCI_* */
> >>   
> >> @@ -379,6 +380,185 @@ struct vfio_region_gfx_edid {
> >>   /* sub-types for VFIO_REGION_TYPE_CCW */
> >>   #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
> >>   
> >> +/* sub-types for VFIO_REGION_TYPE_MIGRATION */
> >> +#define VFIO_REGION_SUBTYPE_MIGRATION           (1)
> >> +
> >> +/*
> >> + * Structure vfio_device_migration_info is placed at 0th offset of
> >> + * VFIO_REGION_SUBTYPE_MIGRATION region to get/set VFIO device related migration
> >> + * information. Field accesses from this structure are only supported at their
> >> + * native width and alignment, otherwise the result is undefined and vendor
> >> + * drivers should return an error.
> >> + *
> >> + * device_state: (read/write)
> >> + *      To indicate vendor driver the state VFIO device should be transitioned
> >> + *      to. If device state transition fails, write on this field return error.
> >> + *      It consists of 3 bits:
> >> + *      - If bit 0 set, indicates _RUNNING state. When its clear, that indicates
> > 
> > s/its/it's/
> > 
> >> + *        _STOP state. When device is changed to _STOP, driver should stop
> >> + *        device before write() returns.
> >> + *      - If bit 1 set, indicates _SAVING state. When set, that indicates driver
> >> + *        should start gathering device state information which will be provided
> >> + *        to VFIO user space application to save device's state.
> >> + *      - If bit 2 set, indicates _RESUMING state. When set, that indicates
> >> + *        prepare to resume device, data provided through migration region
> >> + *        should be used to resume device.
> >> + *      Bits 3 - 31 are reserved for future use. User should perform
> >> + *      read-modify-write operation on this field.
> >> + *
> >> + *  +------- _RESUMING
> >> + *  |+------ _SAVING
> >> + *  ||+----- _RUNNING
> >> + *  |||
> >> + *  000b => Device Stopped, not saving or resuming
> >> + *  001b => Device running state, default state
> >> + *  010b => Stop Device & save device state, stop-and-copy state
> >> + *  011b => Device running and save device state, pre-copy state
> >> + *  100b => Device stopped and device state is resuming
> >> + *  101b => Invalid state
> > 
> > Eventually this would be intended for post-copy, if supported by the
> > device, right?
> > 
> 
> No, as per Yan mentioned in earlier version, _RESUMING + _RUNNING can't 
> be used for post-copy. New flag will be required for post-copy.
> 
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg658768.html

sorry, I didn't mean _RESUMING + _RUNNING can't be used for post-copy.
I just mean another POSCOPY state needs to be introduced. But I'm not
sure what _RESUMING state is for.
actually, we do nothing in response to _RESUMING state, no matter precopy
or poscopy.
If in your side_RESUMING state means it is allowed to restore device data,
then I think _RESUMING + _RUNNING is a valid state for postcopy.

Thanks
Yan

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB47FAB2B
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 08:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbfKMHnt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 13 Nov 2019 02:43:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:18891 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfKMHns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 02:43:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 23:43:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,299,1569308400"; 
   d="scan'208";a="355397473"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga004.jf.intel.com with ESMTP; 12 Nov 2019 23:43:46 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 12 Nov 2019 23:43:45 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Nov 2019 23:43:45 -0800
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 12 Nov 2019 23:43:45 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.215]) with mapi id 14.03.0439.000;
 Wed, 13 Nov 2019 15:43:44 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Lu, Baolu" <baolu.lu@intel.com>, "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables)
 to host
Thread-Topic: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables)
 to host
Thread-Index: AQHVimn49qwPncOwpUK3oA3gYR4tBqd/6QGAgAdz7JCAAASEAIABX3gg
Date:   Wed, 13 Nov 2019 07:43:43 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0F8A70@SHSMSX104.ccr.corp.intel.com>
References: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
        <1571919983-3231-4-git-send-email-yi.l.liu@intel.com>
        <20191107162041.31e620a4@x1.home>
        <A2975661238FB949B60364EF0F2C25743A0F6894@SHSMSX104.ccr.corp.intel.com>
 <20191112102534.75968ccd@x1.home>
In-Reply-To: <20191112102534.75968ccd@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjUxMjc4YzQtNzJjZC00YjE2LTk2MDYtYzIyZDcyZmRkZWJiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiN1MxSjB3XC9LNkk0eDhmR3V6eU9QODdOZUQ3b1dsQTNOdWo3SEVyTHF5a2hSY0NGY25QbHlTVGw1VnhkZUNPVnUifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, November 13, 2019 1:26 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables) to host
> 
> On Tue, 12 Nov 2019 11:21:40 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > > From: Alex Williamson < alex.williamson@redhat.com >
> > > Sent: Friday, November 8, 2019 7:21 AM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables) to host
> > >
> > > On Thu, 24 Oct 2019 08:26:23 -0400
> > > Liu Yi L <yi.l.liu@intel.com> wrote:
> > >
> > > > This patch adds vfio support to bind guest translation structure
> > > > to host iommu. VFIO exposes iommu programming capability to user-
> > > > space. Guest is a user-space application in host under KVM solution.
> > > > For SVA usage in Virtual Machine, guest owns GVA->GPA translation
> > > > structure. And this part should be passdown to host to enable nested
> > > > translation (or say two stage translation). This patch reuses the
> > > > VFIO_IOMMU_BIND proposal from Jean-Philippe Brucker, and adds new
> > > > bind type for binding guest owned translation structure to host.
> > > >
> > > > *) Add two new ioctls for VFIO containers.
> > > >
> > > >   - VFIO_IOMMU_BIND: for bind request from userspace, it could be
> > > >                    bind a process to a pasid or bind a guest pasid
> > > >                    to a device, this is indicated by type
> > > >   - VFIO_IOMMU_UNBIND: for unbind request from userspace, it could be
> > > >                    unbind a process to a pasid or unbind a guest pasid
> > > >                    to a device, also indicated by type
> > > >   - Bind type:
> > > > 	VFIO_IOMMU_BIND_PROCESS: user-space request to bind a process
> > > >                    to a device
> > > > 	VFIO_IOMMU_BIND_GUEST_PASID: bind guest owned translation
> > > >                    structure to host iommu. e.g. guest page table
> > > >
> > > > *) Code logic in vfio_iommu_type1_ioctl() to handle
> VFIO_IOMMU_BIND/UNBIND
> > > >
[...]
> > > > +static long vfio_iommu_type1_unbind_gpasid(struct vfio_iommu *iommu,
> > > > +					    void __user *arg,
> > > > +					    struct vfio_iommu_type1_bind *bind)
> > > > +{
> > > > +	struct iommu_gpasid_bind_data gbind_data;
> > > > +	unsigned long minsz;
> > > > +	int ret = 0;
> > > > +
> > > > +	minsz = sizeof(*bind) + sizeof(gbind_data);
> > > > +	if (bind->argsz < minsz)
> > > > +		return -EINVAL;
> > >
> > > But gbind_data can change size if new vendor specific data is added to
> > > the union, so kernel updates break existing userspace.  Fail.
> >
> > yes, we have a version field in struct iommu_gpasid_bind_data. How
> > about doing sanity check per versions? kernel knows the gbind_data
> > size of specific versions. Does it make sense? If yes, I'll also apply it
> > to the other sanity check in this series to avoid userspace fail after
> > kernel update.
> 
> Has it already been decided that the version field will be updated for
> every addition to the union?

No, just my proposal. Jacob may help to explain the purpose of version
field. But if we may be too  "frequent" for an uapi version number updating
if we inc version for each change in the union part. I may vote for the
second option from you below.

> It seems there are two options, either
> the version definition includes the possible contents of the union,
> which means we need to support multiple versions concurrently in the
> kernel to maintain compatibility with userspace and follow deprecation
> protocols for removing that support, or we need to consider version to
> be the general form of the structure and interpret the format field to
> determine necessary length to copy from the user.

As I mentioned above, may be better to let @version field only over the
general fields and let format to cover the possible changes in union. e.g.
IOMMU_PASID_FORMAT_INTEL_VTD2 may means version 2 of Intel
VT-d bind. But either way, I think we need to let kernel maintain multiple
versions to support compatible userspace. e.g. may have multiple versions
iommu_gpasid_bind_data_vtd struct in the union part.

> 
> > > > +
> > > > +	if (copy_from_user(&gbind_data, arg, sizeof(gbind_data)))
> > > > +		return -EFAULT;
> > > > +
> > > > +	mutex_lock(&iommu->lock);
> > > > +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > > > +		ret = -EINVAL;
> > > > +		goto out_unlock;
> > > > +	}
> > > > +
> > > > +	ret = vfio_iommu_type1_do_guest_unbind(iommu, &gbind_data);
> > > > +
> > > > +out_unlock:
> > > > +	mutex_unlock(&iommu->lock);
> > > > +	return ret;
> > > > +}
> > > > +
> > > >  static long vfio_iommu_type1_ioctl(void *iommu_data,
> > > >  				   unsigned int cmd, unsigned long arg)
> > > >  {
> > > > @@ -2484,6 +2582,44 @@ static long vfio_iommu_type1_ioctl(void
> *iommu_data,
> > > >  		default:
> > > >  			return -EINVAL;
> > > >  		}
> > > > +
> > > > +	} else if (cmd == VFIO_IOMMU_BIND) {
> > > > +		struct vfio_iommu_type1_bind bind;
> > > > +
> > > > +		minsz = offsetofend(struct vfio_iommu_type1_bind, bind_type);
> > > > +
> > > > +		if (copy_from_user(&bind, (void __user *)arg, minsz))
> > > > +			return -EFAULT;
> > > > +
> > > > +		if (bind.argsz < minsz)
> > > > +			return -EINVAL;
> > > > +
> > > > +		switch (bind.bind_type) {
> > > > +		case VFIO_IOMMU_BIND_GUEST_PASID:
> > > > +			return vfio_iommu_type1_bind_gpasid(iommu,
> > > > +					(void __user *)(arg + minsz), &bind);
> > >
> > > Why are we defining BIND_PROCESS if it's not supported?  How does the
> > > user learn it's not supported?
> >
> > I think I should drop it so far since I only add BIND_GUEST_PASID. I think
> > Jean Philippe may need it in his native SVA enabling patchset. For the way
> > to let user learn it, may be using VFIO_IOMMU_GET_INFO as you mentioned
> > below?
> >
> > >
> > > > +		default:
> > > > +			return -EINVAL;
> > > > +		}
> > > > +
> > > > +	} else if (cmd == VFIO_IOMMU_UNBIND) {
> > > > +		struct vfio_iommu_type1_bind bind;
> > > > +
> > > > +		minsz = offsetofend(struct vfio_iommu_type1_bind, bind_type);
> > > > +
> > > > +		if (copy_from_user(&bind, (void __user *)arg, minsz))
> > > > +			return -EFAULT;
> > > > +
> > > > +		if (bind.argsz < minsz)
> > > > +			return -EINVAL;
> > > > +
> > > > +		switch (bind.bind_type) {
> > > > +		case VFIO_IOMMU_BIND_GUEST_PASID:
> > > > +			return vfio_iommu_type1_unbind_gpasid(iommu,
> > > > +					(void __user *)(arg + minsz), &bind);
> > > > +		default:
> > > > +			return -EINVAL;
> > > > +		}
> > > >  	}
> > > >
> > > >  	return -ENOTTY;
> > > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > > index 04de290..78e8c64 100644
> > > > --- a/include/uapi/linux/vfio.h
> > > > +++ b/include/uapi/linux/vfio.h
> > > > @@ -832,6 +832,50 @@ struct vfio_iommu_type1_pasid_request {
> > > >   */
> > > >  #define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 27)
> > > >
> > > > +enum vfio_iommu_bind_type {
> > > > +	VFIO_IOMMU_BIND_PROCESS,
> > > > +	VFIO_IOMMU_BIND_GUEST_PASID,
> > > > +};
> > > > +
> > > > +/*
> > > > + * Supported types:
> > > > + *	- VFIO_IOMMU_BIND_GUEST_PASID: bind guest pasid, which
> invoked
> > > > + *			by guest, it takes iommu_gpasid_bind_data in data.
> > > > + */
> > > > +struct vfio_iommu_type1_bind {
> > > > +	__u32				argsz;
> > > > +	enum vfio_iommu_bind_type	bind_type;
> > > > +	__u8				data[];
> > > > +};
> > >
> > > I don't think enum defines a compiler invariant data size.  We can't
> > > use it for a kernel/user interface.  Also why no flags field as is
> > > essentially standard for every vfio ioctl?  Couldn't we specify
> > > process/guest-pasid with flags?
> >
> > I remember there is an early comment in community which pointed out
> > that using flags potentially allows to config multiples types in one IOCTL.
> > Regards to it, defining explicit emums avoids it. But I agree with you,
> > it makes variant size. I'll fix it if this matter more.
> >
> > > For that matter couldn't we specify
> > > bind/unbind using a single ioctl?  I think that would be more
> > > consistent with the pasid alloc/free ioctl in the previous patch.
> >
> > yes, let me make it in next version.
> >
> > > Why are we appending opaque data to the end of the structure when
> > > clearly we expect a struct iommu_gpasid_bind_data?
> >
> > This is due to the intention to support BIND_GUEST_PASID and
> > BIND_PROCESS with a single IOCTL. Maybe we can use a separate
> > IOCTL for BIND_PROCESS. what's your opinion here?
> 
> If the ioctls have similar purpose and form, then re-using a single
> ioctl might make sense, but BIND_PROCESS is only a place-holder in this
> series, which is not acceptable.  A dual purpose ioctl does not
> preclude that we could also use a union for the data field to make the
> structure well specified.

yes, BIND_PROCESS is only a place-holder here. From kernel p.o.v., both
BIND_GUEST_PASID and BIND_PROCESS are bind requests from userspace.
So the purposes are aligned. Below is the content the @data[] field
supposed to convey for BIND_PROCESS. If we use union, it would leave
space for extending it to support BIND_PROCESS. If only data[], it is a little
bit confusing why we define it in such manner if BIND_PROCESS is included
in this series. Please feel free let me know which one suits better.

+struct vfio_iommu_type1_bind_process {
+	__u32	flags;
+#define VFIO_IOMMU_BIND_PID		(1 << 0)
+	__u32	pasid;
+	__s32	pid;
+};
https://patchwork.kernel.org/patch/10394927/

> > > That bind data
> > > structure expects a format (ex. IOMMU_PASID_FORMAT_INTEL_VTD).  How
> does
> > > a user determine what formats are accepted from within the vfio API (or
> > > even outside of the vfio API)?
> >
> > The info is provided by vIOMMU emulator (e.g. virtual VT-d). The vSVA patch
> > from Jacob has a sanity check on it.
> > https://lkml.org/lkml/2019/10/28/873
> 
> The vIOMMU emulator runs at a layer above vfio.  How does the vIOMMU
> emulator know that the vfio interface supports virtual VT-d?  IMO, it's
> not acceptable that the user simply assume that an Intel host platform
> supports VT-d.  For example, consider what happens when we need to
> define IOMMU_PASID_FORMAT_INTEL_VTDv2.  How would the user learn that
> VTDv2 is supported and the original VTD format is not supported?

I guess this may be another info VFIO_IOMMU_GET_INFO should provide.
It makes sense that vfio be aware of what platform it is running on. right?
After vfio gets the info, may let vfio fill in the format info. Is it the correct
direction?

> 
> > > > +
> > > > +/*
> > > > + * VFIO_IOMMU_BIND - _IOWR(VFIO_TYPE, VFIO_BASE + 28, struct
> > > vfio_iommu_bind)
> > >                             ^
> > > The semantics appear to just be _IOW, nothing is written back to the
> > > userspace buffer on return.
> >
> > will fix it. thanks.
> >
> > > > + *
> > > > + * Manage address spaces of devices in this container. Initially a TYPE1
> > > > + * container can only have one address space, managed with
> > > > + * VFIO_IOMMU_MAP/UNMAP_DMA.
> > > > + *
> > > > + * An IOMMU of type VFIO_TYPE1_NESTING_IOMMU can be managed by
> both
> > > MAP/UNMAP
> > > > + * and BIND ioctls at the same time. MAP/UNMAP acts on the stage-2 (host)
> page
> > > > + * tables, and BIND manages the stage-1 (guest) page tables. Other types of
> > > > + * IOMMU may allow MAP/UNMAP and BIND to coexist, where MAP/UNMAP
> > > controls
> > > > + * non-PASID traffic and BIND controls PASID traffic. But this depends on the
> > > > + * underlying IOMMU architecture and isn't guaranteed.
> > > > + *
> > > > + * Availability of this feature depends on the device, its bus, the underlying
> > > > + * IOMMU and the CPU architecture.
> > >
> > > And the user discovers this is available by...?  There's no probe here,
> > > are they left only to setup a VM to the point of trying to use this
> > > before they fail the ioctl?  Could VFIO_IOMMU_GET_INFO fill this gap?
> > > Thanks,
> >
> > I think VFIO_IOMMU_GET_INFO could help. let me extend it to fill this gap
> > if you agree.
> 
> It's a start.  Thanks,

Got it. will show the code in next version. Thanks for your patient review.

> Alex

Regards,
Yi Liu

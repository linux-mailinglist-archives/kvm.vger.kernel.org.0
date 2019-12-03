Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01D5E10F3D2
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 01:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfLCAMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 19:12:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20891 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725775AbfLCAMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 19:12:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575331918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QwslN0ESh7G3atu+sEDSOpZk2f+hv1EosGWGmAtx8T4=;
        b=Tmb5uQfqSwgliGyQdwp64BDqG3ugRDmnKH+8eJtbyDW8OhG93j5TinHxIY/G1DTFjsjcSL
        MyDuy52r9uKkZPntH46Mpy20bJk1WCBfmcFGFJgPCFGQYv7mLNxFQXfX5cR7pR4F4XZ9pQ
        1367h9bwIRbSbIIdPn4aYACt+rUrhO8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-8rNTbQokON28R37LVCUJpA-1; Mon, 02 Dec 2019 19:11:55 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00256800D41;
        Tue,  3 Dec 2019 00:11:53 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81CC65D6A7;
        Tue,  3 Dec 2019 00:11:49 +0000 (UTC)
Date:   Mon, 2 Dec 2019 17:11:49 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables)
 to host
Message-ID: <20191202171149.12092335@x1.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A10D40B@SHSMSX104.ccr.corp.intel.com>
References: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
        <1571919983-3231-4-git-send-email-yi.l.liu@intel.com>
        <20191107162041.31e620a4@x1.home>
        <A2975661238FB949B60364EF0F2C25743A0F6894@SHSMSX104.ccr.corp.intel.com>
        <20191112102534.75968ccd@x1.home>
        <A2975661238FB949B60364EF0F2C25743A0F8A70@SHSMSX104.ccr.corp.intel.com>
        <20191113102913.GA40832@lophozonia>
        <A2975661238FB949B60364EF0F2C25743A10D40B@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 8rNTbQokON28R37LVCUJpA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Nov 2019 07:45:18 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> Thanks for the review. Here I'd like to conclude the major opens in this
> thread and see if we can get some agreements to prepare a new version.
> 
> a) IOCTLs for BIND_GPASID and BIND_PROCESS, share a single IOCTL or two
>    separate IOCTLs?
>    Yi: It may be helpful to have separate IOCTLs. The bind data conveyed
>    for BIND_GPASID and BIND_PROCESS are totally different, and the struct
>    iommu_gpasid_bind_data has vendor specific data and may even have more
>    versions in future. To better maintain it, I guess separate IOCTLs for
>    the two bind types would be better. The structure for BIND_GPASID is
>    as below:
> 
>         struct vfio_iommu_type1_bind {
>                 __u32                           argsz;
>                 struct iommu_gpasid_bind_data   bind_data;
>         };


We've been rather successful at extending ioctls in vfio and I'm
generally opposed to rampant ioctl proliferation.  If we added @flags
to the above struct (as pretty much the standard for vfio ioctls), then
we could use it to describe the type of binding to perform and
therefore the type of data provided.  I think my major complaint here
was that we were defining PROCESS but not implementing it.  We can
design the ioctl to enable it, but not define it until it's implemented.
 
> b) how kernel-space learns the number of bytes to be copied (a.k.a. the
>    usage of @version field and @format field of struct
>    iommu_gpasid_bind_data)
>    Yi: Jean has an excellent recap in prior reply on the plan of future
>    extensions regards to @version field and @format field. Based on the
>    plan, kernel space needs to parse the @version field and @format field
>    to get the length of the current BIND_GPASID request. Also kernel needs
>    to maintain the new and old structure versions. Follow specific
>    deprecation policy in future.

Yes, it seems reasonable, so from the struct above (plus @flags) we
could determine we have struct iommu_gpasid_bind_data as the payload
and read that using @version and @format as outlined.

> c) how can vIOMMU emulator know that the vfio interface supports to config
>    dual stage translation for vIOMMU?
>    Yi: may do it via VFIO_IOMMU_GET_INFO.

Yes please.

> d) how can vIOMMU emulator know what @version and @format should be set
>    in struct iommu_gpasid_bind_data?
>    Yi: currently, we have two ways. First one, may do it via
>    VFIO_IOMMU_GET_INFO. This is a natural idea as here @version and @format
>    are used in vfio apis. It makes sense to let vfio to provide related info
>    to vIOMMU emulator after checking with vendor specific iommu driver. Also,
>    there is idea to do it via sysfs (/sys/class/iommu/dmar#) as we have plan
>    to do IOMMU capability sync between vIOMMU and pIOMMU via sysfs. I have
>    two concern on this option. Current iommu sysfs only provides vendor
>    specific hardware infos. I'm not sure if it is good to expose infos
>    defined in IOMMU generic layer via iommu sysfs. If this concern is not
>    a big thing, I'm fine with both options.

This seems like the same issue we had with IOMMU reserved regions, I'd
prefer that a user can figure out how to interact with the vfio
interface through the vfio interface.  Forcing the user to poke around
in sysfs requires the user to have read permissions to sysfs in places
they otherwise wouldn't need.  Thanks,

Alex

> > From: Jean-Philippe Brucker [mailto:jean-philippe@linaro.org]
> > Sent: Wednesday, November 13, 2019 6:29 PM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables) to host
> > 
> > On Wed, Nov 13, 2019 at 07:43:43AM +0000, Liu, Yi L wrote:  
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Wednesday, November 13, 2019 1:26 AM
> > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > Subject: Re: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables) to host
> > > >
> > > > On Tue, 12 Nov 2019 11:21:40 +0000
> > > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > > >  
> > > > > > From: Alex Williamson < alex.williamson@redhat.com >
> > > > > > Sent: Friday, November 8, 2019 7:21 AM
> > > > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > Subject: Re: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables) to  
> > host  
> > > > > >
> > > > > > On Thu, 24 Oct 2019 08:26:23 -0400
> > > > > > Liu Yi L <yi.l.liu@intel.com> wrote:
> > > > > >  
> > > > > > > This patch adds vfio support to bind guest translation structure
> > > > > > > to host iommu. VFIO exposes iommu programming capability to user-
> > > > > > > space. Guest is a user-space application in host under KVM solution.
> > > > > > > For SVA usage in Virtual Machine, guest owns GVA->GPA translation
> > > > > > > structure. And this part should be passdown to host to enable nested
> > > > > > > translation (or say two stage translation). This patch reuses the
> > > > > > > VFIO_IOMMU_BIND proposal from Jean-Philippe Brucker, and adds new
> > > > > > > bind type for binding guest owned translation structure to host.
> > > > > > >
> > > > > > > *) Add two new ioctls for VFIO containers.
> > > > > > >
> > > > > > >   - VFIO_IOMMU_BIND: for bind request from userspace, it could be
> > > > > > >                    bind a process to a pasid or bind a guest pasid
> > > > > > >                    to a device, this is indicated by type
> > > > > > >   - VFIO_IOMMU_UNBIND: for unbind request from userspace, it could be
> > > > > > >                    unbind a process to a pasid or unbind a guest pasid
> > > > > > >                    to a device, also indicated by type
> > > > > > >   - Bind type:
> > > > > > > 	VFIO_IOMMU_BIND_PROCESS: user-space request to bind a  
> > process  
> > > > > > >                    to a device
> > > > > > > 	VFIO_IOMMU_BIND_GUEST_PASID: bind guest owned translation
> > > > > > >                    structure to host iommu. e.g. guest page table
> > > > > > >
> > > > > > > *) Code logic in vfio_iommu_type1_ioctl() to handle  
> > > > VFIO_IOMMU_BIND/UNBIND  
> > > > > > >  
> > > [...]  
> > > > > > > +static long vfio_iommu_type1_unbind_gpasid(struct vfio_iommu *iommu,
> > > > > > > +					    void __user *arg,
> > > > > > > +					    struct vfio_iommu_type1_bind  
> > *bind)  
> > > > > > > +{
> > > > > > > +	struct iommu_gpasid_bind_data gbind_data;
> > > > > > > +	unsigned long minsz;
> > > > > > > +	int ret = 0;
> > > > > > > +
> > > > > > > +	minsz = sizeof(*bind) + sizeof(gbind_data);
> > > > > > > +	if (bind->argsz < minsz)
> > > > > > > +		return -EINVAL;  
> > > > > >
> > > > > > But gbind_data can change size if new vendor specific data is added to
> > > > > > the union, so kernel updates break existing userspace.  Fail.  
> > 
> > I guess we could take minsz up to the vendor-specific data, copy @format,
> > and then check the size of vendor-specific data?
> >   
> > > > >
> > > > > yes, we have a version field in struct iommu_gpasid_bind_data. How
> > > > > about doing sanity check per versions? kernel knows the gbind_data
> > > > > size of specific versions. Does it make sense? If yes, I'll also apply it
> > > > > to the other sanity check in this series to avoid userspace fail after
> > > > > kernel update.  
> > > >
> > > > Has it already been decided that the version field will be updated for
> > > > every addition to the union?  
> > >
> > > No, just my proposal. Jacob may help to explain the purpose of version
> > > field. But if we may be too  "frequent" for an uapi version number updating
> > > if we inc version for each change in the union part. I may vote for the
> > > second option from you below.
> > >  
> > > > It seems there are two options, either
> > > > the version definition includes the possible contents of the union,
> > > > which means we need to support multiple versions concurrently in the
> > > > kernel to maintain compatibility with userspace and follow deprecation
> > > > protocols for removing that support, or we need to consider version to
> > > > be the general form of the structure and interpret the format field to
> > > > determine necessary length to copy from the user.  
> > >
> > > As I mentioned above, may be better to let @version field only over the
> > > general fields and let format to cover the possible changes in union. e.g.
> > > IOMMU_PASID_FORMAT_INTEL_VTD2 may means version 2 of Intel
> > > VT-d bind. But either way, I think we need to let kernel maintain multiple
> > > versions to support compatible userspace. e.g. may have multiple versions
> > > iommu_gpasid_bind_data_vtd struct in the union part.  
> > 
> > I couldn't find where the @version field originated in our old
> > discussions, but I believe our plan for allowing future extensions was:
> > 
> > * Add new vendor-specific data by introducing a new format
> >   (IOMMU_PASID_FORMAT_INTEL_VTD2,
> > IOMMU_PASID_FORMAT_ARM_SMMUV2...), and
> >   extend the union.
> > 
> > * Add a new common field, if it fits in the existing padding bytes, by
> >   adding a flag (IOMMU_SVA_GPASID_*).
> > 
> > * Add a new common field, if it doesn't fit in the current padding bytes,
> >   or completely change the structure layout, by introducing a new version
> >   (IOMMU_GPASID_BIND_VERSION_2). In that case the kernel has to handle
> >   both new and old structure versions. It would have both
> >   iommu_gpasid_bind_data and iommu_gpasid_bind_data_v2 structs.
> > 
> > I think iommu_cache_invalidate_info and iommu_page_response use the same
> > scheme. iommu_fault is a bit more complicated because it's
> > kernel->userspace and requires some negotiation:
> > https://lore.kernel.org/linux-iommu/77405d39-81a4-d9a8-5d35-
> > 27602199867a@arm.com/
> > 
> > [...]  
> > > > If the ioctls have similar purpose and form, then re-using a single
> > > > ioctl might make sense, but BIND_PROCESS is only a place-holder in this
> > > > series, which is not acceptable.  A dual purpose ioctl does not
> > > > preclude that we could also use a union for the data field to make the
> > > > structure well specified.  
> > >
> > > yes, BIND_PROCESS is only a place-holder here. From kernel p.o.v., both
> > > BIND_GUEST_PASID and BIND_PROCESS are bind requests from userspace.
> > > So the purposes are aligned. Below is the content the @data[] field
> > > supposed to convey for BIND_PROCESS. If we use union, it would leave
> > > space for extending it to support BIND_PROCESS. If only data[], it is a little
> > > bit confusing why we define it in such manner if BIND_PROCESS is included
> > > in this series. Please feel free let me know which one suits better.
> > >
> > > +struct vfio_iommu_type1_bind_process {
> > > +	__u32	flags;
> > > +#define VFIO_IOMMU_BIND_PID		(1 << 0)
> > > +	__u32	pasid;
> > > +	__s32	pid;
> > > +};
> > > https://patchwork.kernel.org/patch/10394927/  
> > 
> > Note that I don't plan to upstream BIND_PROCESS at the moment. It was
> > useful for testing but I don't know of anyone actually needing it.
> >   
> > > > > > That bind data
> > > > > > structure expects a format (ex. IOMMU_PASID_FORMAT_INTEL_VTD).  How  
> > > > does  
> > > > > > a user determine what formats are accepted from within the vfio API (or
> > > > > > even outside of the vfio API)?  
> > > > >
> > > > > The info is provided by vIOMMU emulator (e.g. virtual VT-d). The vSVA patch
> > > > > from Jacob has a sanity check on it.
> > > > > https://lkml.org/lkml/2019/10/28/873  
> > > >
> > > > The vIOMMU emulator runs at a layer above vfio.  How does the vIOMMU
> > > > emulator know that the vfio interface supports virtual VT-d?  IMO, it's
> > > > not acceptable that the user simply assume that an Intel host platform
> > > > supports VT-d.  For example, consider what happens when we need to
> > > > define IOMMU_PASID_FORMAT_INTEL_VTDv2.  How would the user learn that
> > > > VTDv2 is supported and the original VTD format is not supported?  
> > >
> > > I guess this may be another info VFIO_IOMMU_GET_INFO should provide.
> > > It makes sense that vfio be aware of what platform it is running on. right?
> > > After vfio gets the info, may let vfio fill in the format info. Is it the correct
> > > direction?  
> > 
> > I thought you were planning to put that information in sysfs?  We last
> > discussed this over a year ago so I don't remember where we left it. I
> > know Alex isn't keen on putting in sysfs what can be communicated through
> > VFIO, but it is a convenient way to describe IOMMU features:
> > http://www.linux-arm.org/git?p=linux-
> > jpb.git;a=commitdiff;h=665370d5b5e0022c24b2d2b57975ef6fe7b40870;hp=7ce780
> > d838889b53f5e04ba5d444520621261eda
> > 
> > My problem with GET_INFO was that it could be difficult to extend, and
> > to describe things like variable-size list of supported page table
> > formats, but I guess the new info capabilities make this easier.
> > 
> > Thanks,
> > Jean  
> 


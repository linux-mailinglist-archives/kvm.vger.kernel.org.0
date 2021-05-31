Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9793D3959C3
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 13:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEaLfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 07:35:19 -0400
Received: from mga17.intel.com ([192.55.52.151]:56009 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231182AbhEaLfR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 07:35:17 -0400
IronPort-SDR: OOEj1Ll8t73mtPAJo3B7KCGA0C6HbGRT4E5gaI+iITft5Gt1XA8n+HheZ5H2Gt8u3aDDI8owcC
 23roy8TAGvdg==
X-IronPort-AV: E=McAfee;i="6200,9189,10000"; a="183699259"
X-IronPort-AV: E=Sophos;i="5.83,237,1616482800"; 
   d="scan'208";a="183699259"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 04:33:35 -0700
IronPort-SDR: VI08a3ICQdt3LXpP8fMTc3PXfsz/TioOgrQ6m2gkjeFqWI5vKpyuH1gdUOcdaU6+DOuv98tB01
 QGySn8FNWTeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,237,1616482800"; 
   d="scan'208";a="446576175"
Received: from yiliu-dev.bj.intel.com (HELO yiliu-dev) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 31 May 2021 04:33:28 -0700
Date:   Mon, 31 May 2021 19:31:57 +0800
From:   Liu Yi L <yi.l.liu@linux.intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     yi.l.liu@intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Alex Williamson \(alex.williamson@redhat.com\)" 
        <alex.williamson@redhat.com>, "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Jiang, Dave" <dave.jiang@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210531193157.5494e6c6@yiliu-dev>
In-Reply-To: <20210528233649.GB3816344@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210528233649.GB3816344@nvidia.com>
Organization: IAGS/SSE(OTC)
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 May 2021 20:36:49 -0300, Jason Gunthorpe wrote:

> On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
> 
> > 2.1. /dev/ioasid uAPI
> > +++++++++++++++++
> > 
> > /*
> >   * Check whether an uAPI extension is supported. 
> >   *
> >   * This is for FD-level capabilities, such as locked page pre-registration. 
> >   * IOASID-level capabilities are reported through IOASID_GET_INFO.
> >   *
> >   * Return: 0 if not supported, 1 if supported.
> >   */
> > #define IOASID_CHECK_EXTENSION	_IO(IOASID_TYPE, IOASID_BASE + 0)  
> 
>  
> > /*
> >   * Register user space memory where DMA is allowed.
> >   *
> >   * It pins user pages and does the locked memory accounting so sub-
> >   * sequent IOASID_MAP/UNMAP_DMA calls get faster.
> >   *
> >   * When this ioctl is not used, one user page might be accounted
> >   * multiple times when it is mapped by multiple IOASIDs which are
> >   * not nested together.
> >   *
> >   * Input parameters:
> >   *	- vaddr;
> >   *	- size;
> >   *
> >   * Return: 0 on success, -errno on failure.
> >   */
> > #define IOASID_REGISTER_MEMORY	_IO(IOASID_TYPE, IOASID_BASE + 1)
> > #define IOASID_UNREGISTER_MEMORY	_IO(IOASID_TYPE, IOASID_BASE + 2)  
> 
> So VA ranges are pinned and stored in a tree and later references to
> those VA ranges by any other IOASID use the pin cached in the tree?
> 
> It seems reasonable and is similar to the ioasid parent/child I
> suggested for PPC.
> 
> IMHO this should be merged with the all SW IOASID that is required for
> today's mdev drivers. If this can be done while keeping this uAPI then
> great, otherwise I don't think it is so bad to weakly nest a physical
> IOASID under a SW one just to optimize page pinning.
> 
> Either way this seems like a smart direction
> 
> > /*
> >   * Allocate an IOASID. 
> >   *
> >   * IOASID is the FD-local software handle representing an I/O address 
> >   * space. Each IOASID is associated with a single I/O page table. User 
> >   * must call this ioctl to get an IOASID for every I/O address space that is
> >   * intended to be enabled in the IOMMU.
> >   *
> >   * A newly-created IOASID doesn't accept any command before it is 
> >   * attached to a device. Once attached, an empty I/O page table is 
> >   * bound with the IOMMU then the user could use either DMA mapping 
> >   * or pgtable binding commands to manage this I/O page table.  
> 
> Can the IOASID can be populated before being attached?

perhaps a MAP/UNMAP operation on a gpa_ioasid?

> 
> >   * Device attachment is initiated through device driver uAPI (e.g. VFIO)
> >   *
> >   * Return: allocated ioasid on success, -errno on failure.
> >   */
> > #define IOASID_ALLOC	_IO(IOASID_TYPE, IOASID_BASE + 3)
> > #define IOASID_FREE	_IO(IOASID_TYPE, IOASID_BASE + 4)  
> 
> I assume alloc will include quite a big structure to satisfy the
> various vendor needs?
>
> 
> > /*
> >   * Get information about an I/O address space
> >   *
> >   * Supported capabilities:
> >   *	- VFIO type1 map/unmap;
> >   *	- pgtable/pasid_table binding
> >   *	- hardware nesting vs. software nesting;
> >   *	- ...
> >   *
> >   * Related attributes:
> >   * 	- supported page sizes, reserved IOVA ranges (DMA mapping);
> >   *	- vendor pgtable formats (pgtable binding);
> >   *	- number of child IOASIDs (nesting);
> >   *	- ...
> >   *
> >   * Above information is available only after one or more devices are
> >   * attached to the specified IOASID. Otherwise the IOASID is just a
> >   * number w/o any capability or attribute.  
> 
> This feels wrong to learn most of these attributes of the IOASID after
> attaching to a device.

but an IOASID is just a software handle before attached to a specific
device. e.g. before attaching to a device, we have no idea about the
supported page size in underlying iommu, coherent etc.

> The user should have some idea how it intends to use the IOASID when
> it creates it and the rest of the system should match the intention.
> 
> For instance if the user is creating a IOASID to cover the guest GPA
> with the intention of making children it should indicate this during
> alloc.
> 
> If the user is intending to point a child IOASID to a guest page table
> in a certain descriptor format then it should indicate it during
> alloc.

Actually, we have only two kinds of IOASIDs so far. One is used as parent
and another is child. For child, this proposal has defined IOASID_CREATE_NESTING
for it. But yeah, I think it is doable to indicate the type in ALLOC. But
for child IOASID, there require one more step to config its parent IOASID
or may include such info in the ioctl input as well.
 
> device bind should fail if the device somehow isn't compatible with
> the scheme the user is tring to use.

yeah, I guess you mean to fail the device attach when the IOASID is a
nesting IOASID but the device is behind an iommu without nesting support.
right?

> 
> > /*
> >   * Map/unmap process virtual addresses to I/O virtual addresses.
> >   *
> >   * Provide VFIO type1 equivalent semantics. Start with the same 
> >   * restriction e.g. the unmap size should match those used in the 
> >   * original mapping call. 
> >   *
> >   * If IOASID_REGISTER_MEMORY has been called, the mapped vaddr
> >   * must be already in the preregistered list.
> >   *
> >   * Input parameters:
> >   *	- u32 ioasid;
> >   *	- refer to vfio_iommu_type1_dma_{un}map
> >   *
> >   * Return: 0 on success, -errno on failure.
> >   */
> > #define IOASID_MAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 6)
> > #define IOASID_UNMAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 7)  
> 
> What about nested IOASIDs?

at first glance, it looks like we should prevent the MAP/UNMAP usage on
nested IOASIDs. At least hardware nested translation only allows MAP/UNMAP
on the parent IOASIDs and page table bind on nested IOASIDs. But considering
about software nesting, it seems still useful to allow MAP/UNMAP usage
on nested IOASIDs. This is how I understand it, how about your opinion
on it? do you think it's better to allow MAP/UNMAP usage only on parent
IOASIDs as a start?

> 
> > /*
> >   * Create a nesting IOASID (child) on an existing IOASID (parent)
> >   *
> >   * IOASIDs can be nested together, implying that the output address 
> >   * from one I/O page table (child) must be further translated by 
> >   * another I/O page table (parent).
> >   *
> >   * As the child adds essentially another reference to the I/O page table 
> >   * represented by the parent, any device attached to the child ioasid 
> >   * must be already attached to the parent.
> >   *
> >   * In concept there is no limit on the number of the nesting levels. 
> >   * However for the majority case one nesting level is sufficient. The
> >   * user should check whether an IOASID supports nesting through 
> >   * IOASID_GET_INFO. For example, if only one nesting level is allowed,
> >   * the nesting capability is reported only on the parent instead of the
> >   * child.
> >   *
> >   * User also needs check (via IOASID_GET_INFO) whether the nesting 
> >   * is implemented in hardware or software. If software-based, DMA 
> >   * mapping protocol should be used on the child IOASID. Otherwise, 
> >   * the child should be operated with pgtable binding protocol.
> >   *
> >   * Input parameters:
> >   *	- u32 parent_ioasid;
> >   *
> >   * Return: child_ioasid on success, -errno on failure;
> >   */
> > #define IOASID_CREATE_NESTING	_IO(IOASID_TYPE, IOASID_BASE + 8)  
> 
> Do you think another ioctl is best? Should this just be another
> parameter to alloc?

either is fine. This ioctl is following one of your previous comment.

https://lore.kernel.org/linux-iommu/20210422121020.GT1370958@nvidia.com/

> 
> > /*
> >   * Bind an user-managed I/O page table with the IOMMU
> >   *
> >   * Because user page table is untrusted, IOASID nesting must be enabled 
> >   * for this ioasid so the kernel can enforce its DMA isolation policy 
> >   * through the parent ioasid.
> >   *
> >   * Pgtable binding protocol is different from DMA mapping. The latter 
> >   * has the I/O page table constructed by the kernel and updated 
> >   * according to user MAP/UNMAP commands. With pgtable binding the 
> >   * whole page table is created and updated by userspace, thus different 
> >   * set of commands are required (bind, iotlb invalidation, page fault, etc.).
> >   *
> >   * Because the page table is directly walked by the IOMMU, the user 
> >   * must  use a format compatible to the underlying hardware. It can 
> >   * check the format information through IOASID_GET_INFO.
> >   *
> >   * The page table is bound to the IOMMU according to the routing 
> >   * information of each attached device under the specified IOASID. The
> >   * routing information (RID and optional PASID) is registered when a 
> >   * device is attached to this IOASID through VFIO uAPI. 
> >   *
> >   * Input parameters:
> >   *	- child_ioasid;
> >   *	- address of the user page table;
> >   *	- formats (vendor, address_width, etc.);
> >   * 
> >   * Return: 0 on success, -errno on failure.
> >   */
> > #define IOASID_BIND_PGTABLE		_IO(IOASID_TYPE, IOASID_BASE + 9)
> > #define IOASID_UNBIND_PGTABLE	_IO(IOASID_TYPE, IOASID_BASE + 10)  
> 
> Also feels backwards, why wouldn't we specify this, and the required
> page table format, during alloc time?

here the model is user-space gets the page table format from kernel and
decide if it can proceed. So what you are suggesting is user-space should
tell kernel the page table format it has in ALLOC and kenrel should fail
the ALLOC if the user-space page table format is not compatible with underlying
iommu?

> 
> > /*
> >   * Bind an user-managed PASID table to the IOMMU
> >   *
> >   * This is required for platforms which place PASID table in the GPA space.
> >   * In this case the specified IOASID represents the per-RID PASID space.
> >   *
> >   * Alternatively this may be replaced by IOASID_BIND_PGTABLE plus a
> >   * special flag to indicate the difference from normal I/O address spaces.
> >   *
> >   * The format info of the PASID table is reported in IOASID_GET_INFO.
> >   *
> >   * As explained in the design section, user-managed I/O page tables must
> >   * be explicitly bound to the kernel even on these platforms. It allows
> >   * the kernel to uniformly manage I/O address spaces cross all platforms.
> >   * Otherwise, the iotlb invalidation and page faulting uAPI must be hacked
> >   * to carry device routing information to indirectly mark the hidden I/O
> >   * address spaces.
> >   *
> >   * Input parameters:
> >   *	- child_ioasid;
> >   *	- address of PASID table;
> >   *	- formats (vendor, size, etc.);
> >   *
> >   * Return: 0 on success, -errno on failure.
> >   */
> > #define IOASID_BIND_PASID_TABLE	_IO(IOASID_TYPE, IOASID_BASE + 11)
> > #define IOASID_UNBIND_PASID_TABLE	_IO(IOASID_TYPE, IOASID_BASE + 12)  
> 
> Ditto
> 
> > 
> > /*
> >   * Invalidate IOTLB for an user-managed I/O page table
> >   *
> >   * Unlike what's defined in include/uapi/linux/iommu.h, this command 
> >   * doesn't allow the user to specify cache type and likely support only
> >   * two granularities (all, or a specified range) in the I/O address space.
> >   *
> >   * Physical IOMMU have three cache types (iotlb, dev_iotlb and pasid
> >   * cache). If the IOASID represents an I/O address space, the invalidation
> >   * always applies to the iotlb (and dev_iotlb if enabled). If the IOASID
> >   * represents a vPASID space, then this command applies to the PASID
> >   * cache.
> >   *
> >   * Similarly this command doesn't provide IOMMU-like granularity
> >   * info (domain-wide, pasid-wide, range-based), since it's all about the
> >   * I/O address space itself. The ioasid driver walks the attached
> >   * routing information to match the IOMMU semantics under the
> >   * hood. 
> >   *
> >   * Input parameters:
> >   *	- child_ioasid;
> >   *	- granularity
> >   * 
> >   * Return: 0 on success, -errno on failure
> >   */
> > #define IOASID_INVALIDATE_CACHE	_IO(IOASID_TYPE, IOASID_BASE + 13)  
> 
> This should have an IOVA range too?
> 
> > /*
> >   * Page fault report and response
> >   *
> >   * This is TBD. Can be added after other parts are cleared up. Likely it 
> >   * will be a ring buffer shared between user/kernel, an eventfd to notify 
> >   * the user and an ioctl to complete the fault.
> >   *
> >   * The fault data is per I/O address space, i.e.: IOASID + faulting_addr
> >   */  
> 
> Any reason not to just use read()?

a ring buffer may be mmap to user-space, thus reading fault data from kernel
would be faster. This is also how Eric's fault reporting is doing today.

https://lore.kernel.org/linux-iommu/20210411114659.15051-5-eric.auger@redhat.com/

> >
> > 2.2. /dev/vfio uAPI
> > ++++++++++++++++  
> 
> To be clear you mean the 'struct vfio_device' API, these are not
> IOCTLs on the container or group?
> 
> > /*
> >    * Bind a vfio_device to the specified IOASID fd
> >    *
> >    * Multiple vfio devices can be bound to a single ioasid_fd, but a single
> >    * vfio device should not be bound to multiple ioasid_fd's.
> >    *
> >    * Input parameters:
> >    *  - ioasid_fd;
> >    *
> >    * Return: 0 on success, -errno on failure.
> >    */
> > #define VFIO_BIND_IOASID_FD           _IO(VFIO_TYPE, VFIO_BASE + 22)
> > #define VFIO_UNBIND_IOASID_FD _IO(VFIO_TYPE, VFIO_BASE + 23)  
> 
> This is where it would make sense to have an output "device id" that
> allows /dev/ioasid to refer to this "device" by number in events and
> other related things.

perhaps this is the device info Jean Philippe wants in page fault reporting
path?

-- 
Regards,
Yi Liu

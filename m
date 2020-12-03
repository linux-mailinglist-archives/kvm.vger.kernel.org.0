Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD772CE2D3
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 00:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgLCXkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 18:40:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727495AbgLCXkR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 18:40:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607038730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hli72dy0cTfWhnPynSoKT4NTzeaVrDo6tur3icwmqMo=;
        b=BBFcD+fGbqljUsC8WwdYc26pSRXGZ/sQpCdKcPlqMgI4t0Vr7X80zmPjqfneMIWSrkuxEs
        T1pyuuGDboFaPF2HGKqyRVPFhlmZafBe2tt1ogjOf322Jiz+YxkgCj2f0q8D9GNJJgo4V7
        00oCq674VZZzTwkG4IIuFI2R+aHzGxE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-96hGfTrJOeWIf2I_ZaQ1-A-1; Thu, 03 Dec 2020 18:38:46 -0500
X-MC-Unique: 96hGfTrJOeWIf2I_ZaQ1-A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EDBC835DE0;
        Thu,  3 Dec 2020 23:38:45 +0000 (UTC)
Received: from w520.home (ovpn-112-10.phx2.redhat.com [10.3.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B59301A890;
        Thu,  3 Dec 2020 23:38:44 +0000 (UTC)
Date:   Thu, 3 Dec 2020 16:38:44 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Gao, Fred" <fred.gao@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Zhenyu Wang" <zhenyuw@linux.intel.com>,
        "Fonn, Swee Yee" <swee.yee.fonn@intel.com>
Subject: Re: [PATCH v1] vfio/pci: Add support for opregion v2.0+
Message-ID: <20201203163844.2bcc4b85@w520.home>
In-Reply-To: <DM5PR11MB16436AACB3AE89CC8C4ED4199DF20@DM5PR11MB1643.namprd11.prod.outlook.com>
References: <20201202171249.17083-1-fred.gao@intel.com>
        <20201202115723.27df527b@w520.home>
        <DM5PR11MB16436AACB3AE89CC8C4ED4199DF20@DM5PR11MB1643.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Dec 2020 09:21:03 +0000
"Gao, Fred" <fred.gao@intel.com> wrote:

> Thanks Alex for the timely review.
> 
> > -----Original Message-----
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, December 3, 2020 2:57 AM
> > To: Gao, Fred <fred.gao@intel.com>
> > Cc: kvm@vger.kernel.org; intel-gfx@lists.freedesktop.org; Zhenyu Wang
> > <zhenyuw@linux.intel.com>; Fonn, Swee Yee <swee.yee.fonn@intel.com>
> > Subject: Re: [PATCH v1] vfio/pci: Add support for opregion v2.0+
> > 
> > On Thu,  3 Dec 2020 01:12:49 +0800
> > Fred Gao <fred.gao@intel.com> wrote:
> >   
> > > When VBT data exceeds 6KB size and cannot be within mailbox #4
> > > starting from opregion v2.0+, Extended VBT region, next to opregion,
> > > is used to hold the VBT data, so the total size will be opregion size
> > > plus extended VBT region size.
> > >
> > > For opregion 2.1+: since rvda is relative offset from opregion base,
> > > rvda as extended VBT start offset should be same as opregion size.
> > >
> > > For opregion 2.0: the only difference between opregion 2.0 and 2.1 is
> > > rvda addressing mode besides the version. since rvda is physical host
> > > VBT address and cannot be directly used in guest, it is faked into
> > > opregion 2.1's relative offset.
> > >
> > > Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> > > Signed-off-by: Swee Yee Fonn <swee.yee.fonn@intel.com>
> > > Signed-off-by: Fred Gao <fred.gao@intel.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci_igd.c | 44
> > > +++++++++++++++++++++++++++++++++
> > >  1 file changed, 44 insertions(+)
> > >
> > > diff --git a/drivers/vfio/pci/vfio_pci_igd.c
> > > b/drivers/vfio/pci/vfio_pci_igd.c index 53d97f459252..78919a289914
> > > 100644
> > > --- a/drivers/vfio/pci/vfio_pci_igd.c
> > > +++ b/drivers/vfio/pci/vfio_pci_igd.c
> > > @@ -21,6 +21,17 @@
> > >  #define OPREGION_SIZE		(8 * 1024)
> > >  #define OPREGION_PCI_ADDR	0xfc
> > >
> > > +/*
> > > + * opregion 2.0: rvda is the physical VBT address.  
> > 
> > What's rvda?  What's VBT?  
> Rvda is a struct member in opregion mailbox 3 ,
>  same definition in i915's struct opregion_asle.
>   I,e  Physical address of raw VBT data (v2.0) or 
> Relative address from opregion (v2.1).
> 
> VBT: video bios table ,
>         the data is  stored in  opregion mailbox 4 before opregion v2.0.
>         After opregion v2.0+ , VBT data is larger than mailbox 4, 
>         so Extended VBT region, next to opregion  is used to hold the data.


Are these published anywhere?  I can only find revision 1.0 available.


> > > + *
> > > + * opregion 2.1+: rvda is unsigned, relative offset from
> > > + * opregion base, and should never point within opregion.
> > > + */
> > > +#define OPREGION_RDVA		0x3ba
> > > +#define OPREGION_RDVS		0x3c2
> > > +#define OPREGION_VERSION	22  
> > 
> > Why is this specified as decimal and the others in hex?  This makes it seem
> > like the actual version rather than the offset of a version register.  
> 
> Yes, it is an offset, will redefine the opregion version offset in hex. 
> > > +
> > > +
> > >  static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user  
> > *buf,  
> > >  			      size_t count, loff_t *ppos, bool iswrite)  { @@ -  
> > 58,6 +69,7  
> > > @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
> > >  	u32 addr, size;
> > >  	void *base;
> > >  	int ret;
> > > +	u16 version;
> > >
> > >  	ret = pci_read_config_dword(vdev->pdev, OPREGION_PCI_ADDR,  
> > &addr);  
> > >  	if (ret)
> > > @@ -83,6 +95,38 @@ static int vfio_pci_igd_opregion_init(struct
> > > vfio_pci_device *vdev)
> > >
> > >  	size *= 1024; /* In KB */
> > >
> > > +	/* Support opregion v2.0+ */
> > > +	version = le16_to_cpu(*(__le16 *)(base + OPREGION_VERSION));
> > > +	if (version >= 0x0200) {
> > > +		u64 rvda;
> > > +		u32 rvds;
> > > +
> > > +		rvda = le64_to_cpu(*(__le64 *)(base + OPREGION_RDVA));
> > > +		rvds = le32_to_cpu(*(__le32 *)(base + OPREGION_RDVS));
> > > +		if (rvda && rvds) {
> > > +			u32 offset;
> > > +
> > > +			if (version == 0x0200)
> > > +				offset = (rvda - (u64)addr);  
> > 
> > Unnecessary outer ()  
> Thx, will remove in new patch.
> > > +			else
> > > +				offset = rvda;
> > > +
> > > +			pci_WARN(vdev->pdev, offset != size,
> > > +				"Extended VBT does not follow opregion !\n"
> > > +				"opregion version 0x%x:offset 0x%x\n",  
> > version, offset);  
> > > +
> > > +			if (version == 0x0200) {
> > > +				/* opregion version v2.0 faked to v2.1 */
> > > +				*(__le16 *)(base + OPREGION_VERSION) =
> > > +					cpu_to_le16(0x0201);
> > > +				/* rvda faked to relative offset */
> > > +				(*(__le64 *)(base + OPREGION_RDVA)) =
> > > +					cpu_to_le64((rvda - (u64)addr));  
> > 
> > We're writing to the OpRegion and affecting all future use of it, seems
> > dangerous.  
> 
>   from the opregion v2.0+ specification 
> since there is only RVDA difference between opregion v2.0 and v2.1 besides the version
>   It is the simplest solution and should not impact the future use.

*Should* not, but I'm not so confident without a spec to reference.


> > > +			}
> > > +			size = offset + rvds;  
> > 
> > 
> > We warn about VBT (whatever that is) not immediately following the
> > OpRegion, but then we go ahead and size the thing that we expose to
> > userspace to allow read access to everything between the OpRegion and
> > VBT??  
> From the specification , there should no hole between opregion and VBT.
> But I am not sure if some vendor BIOS will make the hole.
> Can we return the error if this abnormal thing happens ?

It seems rather dangerous to allow a user to have read access to an
unknown extent of unknown data... right?  Thanks,

Alex


> > > +		}
> > > +	}
> > > +
> > >  	if (size != OPREGION_SIZE) {
> > >  		memunmap(base);
> > >  		base = memremap(addr, size, MEMREMAP_WB);  
> 


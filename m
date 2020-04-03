Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364FA19DCB5
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 19:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404394AbgDCR0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 13:26:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38636 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391148AbgDCR0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 13:26:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585934759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fxlus5C28S6z3p137AWR5E1nqEkIO+TaN2d1By/neww=;
        b=E63m4nkyJ65SO2pd98RZcysiDnDyesv7CwA9sGiw6ObjnhiOVke6Qh2cFKBsTzjJl4mR3n
        291aqaQc+hBtluz+a140N98gSTfMPFVnxVNLYQZcFHwE3yN24svBd7GqT5jXdTn2aqTE0d
        Gebjlx58k7JMXtATDB6U72aXaqY4lrM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-x_QF543ePCCH1KBbIQ0ceQ-1; Fri, 03 Apr 2020 13:25:54 -0400
X-MC-Unique: x_QF543ePCCH1KBbIQ0ceQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85AA6107ACC7;
        Fri,  3 Apr 2020 17:25:52 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20618953D1;
        Fri,  3 Apr 2020 17:25:45 +0000 (UTC)
Date:   Fri, 3 Apr 2020 11:25:45 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: Re: [PATCH v1 2/2] vfio/pci: Emulate PASID/PRI capability for VFs
Message-ID: <20200403112545.6c115ba3@w520.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A2204FE@SHSMSX104.ccr.corp.intel.com>
References: <1584880394-11184-1-git-send-email-yi.l.liu@intel.com>
        <1584880394-11184-3-git-send-email-yi.l.liu@intel.com>
        <20200402165954.48d941ee@w520.home>
        <A2975661238FB949B60364EF0F2C25743A2204FE@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 3 Apr 2020 07:53:55 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, April 3, 2020 7:00 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v1 2/2] vfio/pci: Emulate PASID/PRI capability for VFs
> > 
> > On Sun, 22 Mar 2020 05:33:14 -0700
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > From: Liu Yi L <yi.l.liu@intel.com>
> > >
> > > Per PCIe r5.0, sec 9.3.7.14, if a PF implements the PASID Capability, the
> > > PF PASID configuration is shared by its VFs.  VFs must not implement their
> > > own PASID Capability.
> > >
> > > Per PCIe r5.0, sec 9.3.7.11, VFs must not implement the PRI Capability. If
> > > the PF implements PRI, it is shared by the VFs.
> > >
> > > On bare metal, it has been fixed by below efforts.
> > > to PASID/PRI are
> > > https://lkml.org/lkml/2019/9/5/996
> > > https://lkml.org/lkml/2019/9/5/995
> > >
> > > This patch adds emulated PASID/PRI capabilities for VFs when assigned to
> > > VMs via vfio-pci driver. This is required for enabling vSVA on pass-through
> > > VFs as VFs have no PASID/PRI capability structure in its configure space.
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > Cc: Eric Auger <eric.auger@redhat.com>
> > > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci_config.c | 325  
> > ++++++++++++++++++++++++++++++++++++-  
> > >  1 file changed, 323 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > > index 4b9af99..84b4ea0 100644
> > > --- a/drivers/vfio/pci/vfio_pci_config.c
> > > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > > @@ -1509,11 +1509,304 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
> > >  	return 0;
> > >  }
> > >
> > > +static int vfio_fill_custom_vconfig_bytes(struct vfio_pci_device *vdev,
> > > +					int offset, uint8_t *data, int size)
> > > +{
> > > +	int ret = 0, data_offset = 0;
> > > +
> > > +	while (size) {
> > > +		int filled;
> > > +
> > > +		if (size >= 4 && !(offset % 4)) {
> > > +			__le32 *dwordp = (__le32 *)&vdev->vconfig[offset];
> > > +			u32 dword;
> > > +
> > > +			memcpy(&dword, data + data_offset, 4);
> > > +			*dwordp = cpu_to_le32(dword);  
> > 
> > Why wouldn't we do:
> > 
> > *dwordp = cpu_to_le32(*(u32 *)(data + data_offset));
> > 
> > or better yet, increment data on each iteration for:
> > 
> > *dwordp = cpu_to_le32(*(u32 *)data);  
> 
> I'll refine it.
> 
> > vfio_fill_vconfig_bytes() does almost this same thing, getting
> > the data
> > from config space rather than a buffer, so please figure out how to
> > avoid duplicating the logic.  
> 
> This patch is to emulate the PASID/PRI capability for VF. And per
> my understanding, the cap data from PF's config space cannot be
> filled to VF's vconfig directly. Take the control register in PASID
> capability structure as an example. If PASID cap is enabled in PF,
> the PASID enable bit in the control register will be set. If the cap
> data is filled to VF's vconfig directly, then guest will see a default
> enabled PASID capability in the VF. I guess it is not good. But, I may
> be wrong. If no such requirement, I can use vfio_fill_vconfig_bytes()
> directly, no need to do copy and modify and then copy.
> 
> Also, if still needs to do the copy and modification, I may modify
> the vfio_fill_vconfig_bytes() to pass in the buffer and an indicator
> to tell vfio_fill_vconfig_bytes() whether fetch data from buffer or
> from config space.

Why is vconfig not your buffer?  We're building config space emulation
before the user has access to the device, so it's really not an issue
to copy the PF config into the VF vconfig, then modify the enable bit
in the vconfig space.

> > > +			filled = 4;
> > > +		} else if (size >= 2 && !(offset % 2)) {
> > > +			__le16 *wordp = (__le16 *)&vdev->vconfig[offset];
> > > +			u16 word;
> > > +
> > > +			memcpy(&word, data + data_offset, 2);
> > > +			*wordp = cpu_to_le16(word);
> > > +			filled = 2;
> > > +		} else {
> > > +			u8 *byte = &vdev->vconfig[offset];
> > > +
> > > +			memcpy(byte, data + data_offset, 1);  
> > 
> > This one is really silly.
> > 
> > vdev->vconfig[offset] = *data;  
> 
> got it.
> 
> > > +			filled = 1;
> > > +		}
> > > +
> > > +		offset += filled;
> > > +		data_offset += filled;
> > > +		size -= filled;
> > > +	}
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static int vfio_pci_get_ecap_content(struct pci_dev *pdev,
> > > +					int cap, int cap_len, u8 *content)
> > > +{
> > > +	int pos, offset, len = cap_len, ret = 0;
> > > +
> > > +	pos = pci_find_ext_capability(pdev, cap);
> > > +	if (!pos)
> > > +		return -EINVAL;
> > > +
> > > +	offset = 0;
> > > +	while (len) {
> > > +		int fetched;
> > > +
> > > +		if (len >= 4 && !(pos % 4)) {
> > > +			u32 *dwordp = (u32 *) (content + offset);
> > > +			u32 dword;
> > > +			__le32 *dwptr = (__le32 *) &dword;
> > > +
> > > +			ret = pci_read_config_dword(pdev, pos, &dword);
> > > +			if (ret)
> > > +				return ret;
> > > +			*dwordp = le32_to_cpu(*dwptr);  
> > 
> > WHAT???  pci_read_config_dword() returns cpu endian data!  
> 
> my bad. will remove the silly le32_to_cpu() convert.
> 
> > > +			fetched = 4;
> > > +		} else if (len >= 2 && !(pos % 2)) {
> > > +			u16 *wordp = (u16 *) (content + offset);
> > > +			u16 word;
> > > +			__le16 *wptr = (__le16 *) &word;
> > > +
> > > +			ret = pci_read_config_word(pdev, pos, &word);
> > > +			if (ret)
> > > +				return ret;
> > > +			*wordp = le16_to_cpu(*wptr);
> > > +			fetched = 2;
> > > +		} else {
> > > +			u8 *byte = (u8 *) (content + offset);
> > > +
> > > +			ret = pci_read_config_byte(pdev, pos, byte);
> > > +			if (ret)
> > > +				return ret;
> > > +			fetched = 1;
> > > +		}
> > > +
> > > +		pos += fetched;
> > > +		offset += fetched;
> > > +		len -= fetched;
> > > +	}
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +struct vfio_pci_pasid_cap_data {
> > > +	u32 id:16;
> > > +	u32 version:4;
> > > +	u32 next:12;
> > > +	union {
> > > +		u16 cap_reg_val;
> > > +		struct {
> > > +			u16 rsv1:1;
> > > +			u16 execs:1;
> > > +			u16 prvs:1;
> > > +			u16 rsv2:5;
> > > +			u16 pasid_bits:5;
> > > +			u16 rsv3:3;
> > > +		};
> > > +	} cap_reg;
> > > +	union {
> > > +		u16 control_reg_val;
> > > +		struct {
> > > +			u16 paside:1;
> > > +			u16 exece:1;
> > > +			u16 prve:1;
> > > +			u16 rsv4:13;
> > > +		};
> > > +	} control_reg;
> > > +};
> > > +
> > > +static int vfio_pci_add_pasid_cap(struct vfio_pci_device *vdev,
> > > +				    struct pci_dev *pdev,
> > > +				    u16 epos, u16 *next, __le32 **prevp)
> > > +{
> > > +	u8 *map = vdev->pci_config_map;
> > > +	int ecap = PCI_EXT_CAP_ID_PASID;
> > > +	int len = pci_ext_cap_length[ecap];
> > > +	struct vfio_pci_pasid_cap_data pasid_cap;
> > > +	struct vfio_pci_pasid_cap_data vpasid_cap;
> > > +	int ret;
> > > +
> > > +	/*
> > > +	 * If no cap filled in this function, should make sure the next
> > > +	 * pointer points to current epos.
> > > +	 */
> > > +	*next = epos;
> > > +
> > > +	if (!len) {
> > > +		pr_info("%s: VF %s hiding PASID capability\n",
> > > +				__func__, dev_name(&vdev->pdev->dev));
> > > +		ret = 0;
> > > +		goto out;
> > > +	}  
> > 
> > No!  Why?  This is dead code.  
> 
> will remove it. thanks.
> 
> > > +
> > > +	/* Add PASID capability*/
> > > +	ret = vfio_pci_get_ecap_content(pdev, ecap,
> > > +					len, (u8 *)&pasid_cap);  
> > 
> > 
> > Why wouldn't we just use vfio_fill_config_bytes() rather than this
> > ridiculous approach of coping it to a buffer, modifying it and copying
> > it out?  
> 
> As the above reply, if copying PF's config space data to VF's vconfig
> directly is fine, then I can drop them.
> 
> > > +	if (ret)
> > > +		goto out;
> > > +
> > > +	if (!pasid_cap.control_reg.paside) {
> > > +		pr_debug("%s: its PF's PASID capability is not enabled\n",
> > > +			dev_name(&vdev->pdev->dev));
> > > +		ret = 0;
> > > +		goto out;
> > > +	}  
> > 
> > What happens if the PF's PASID gets disabled while we're using it??  
> 
> This is actually the open I highlighted in cover letter. Per the reply
> from Baolu, this seems to be an open for bare-metal all the same.
> https://lkml.org/lkml/2020/3/31/95

Seems that needs to get sorted out before we can expose this.  Maybe
some sort of registration with the PF driver that PASID is being used
by a VF so it cannot be disabled?

> > > +
> > > +	memcpy(&vpasid_cap, &pasid_cap, len);
> > > +
> > > +	vpasid_cap.id = 0x18;  
> > 
> > What is going on here?
> > 
> > #define PCI_EXT_CAP_ID_LTR      0x18    /* Latency Tolerance Reporting */  
> 
> my bad... This one was used in development phase. not needed in formal
> patch. really sorry for the mislead.. will remove it.
> 
> > > +	vpasid_cap.next = 0;
> > > +	/* clear the control reg for guest */
> > > +	memset(&vpasid_cap.control_reg, 0x0,
> > > +			sizeof(vpasid_cap.control_reg));  
> > 
> > So we zero a couple registers and that's why we need a structure to
> > define the entire capability and this crazy copy to a cpu endian
> > buffer.  No.  
> 
> there are two reasons for define a structure for the capability. For
> one, to check if PASID capability is enabled in PF. For two, to zero
> the control registers to ensure the guest see a clean control register.
> But if it is not necessary to do the two operations, it can be dropped.

Neither of these require the structures you've defined and I haven't
convinced myself that the bit fields don't have their own issues with
endianness.  Please drop them.

> > > +
> > > +	memset(map + epos, vpasid_cap.id, len);  
> > 
> > See below.
> >   
> > > +	ret = vfio_fill_custom_vconfig_bytes(vdev, epos,
> > > +					(u8 *)&vpasid_cap, len);
> > > +	if (!ret) {
> > > +		/*
> > > +		 * Successfully filled in PASID cap, update
> > > +		 * the next offset in previous cap header,
> > > +		 * and also update caller about the offset
> > > +		 * of next cap if any.
> > > +		 */
> > > +		u32 val = epos;
> > > +		**prevp &= cpu_to_le32(~(0xffcU << 20));
> > > +		**prevp |= cpu_to_le32(val << 20);
> > > +		*prevp = (__le32 *)&vdev->vconfig[epos];
> > > +		*next = epos + len;  
> > 
> > Could we make this any more complicated?  
> 
> yeah, I should have added some comments.
> 
> 	/* update the next field of prior cap structure */
> 	**prevp &= cpu_to_le32(~(0xffcU << 20));
> 	**prevp |= cpu_to_le32(val << 20);
> 	/* update the prevp pointer to point to the current cap */
> 	*prevp = (__le32 *)&vdev->vconfig[epos];
> 	*next = epos + len;

The main loop when processing capabilities already has this sort of
logic.  Please figure out a way to not duplicate it.

> > > +	}
> > > +
> > > +out:
> > > +	return ret;
> > > +}
> > > +
> > > +struct vfio_pci_pri_cap_data {
> > > +	u32 id:16;
> > > +	u32 version:4;
> > > +	u32 next:12;
> > > +	union {
> > > +		u16 control_reg_val;
> > > +		struct {
> > > +			u16 enable:1;
> > > +			u16 reset:1;
> > > +			u16 rsv1:14;
> > > +		};
> > > +	} control_reg;
> > > +	union {
> > > +		u16 status_reg_val;
> > > +		struct {
> > > +			u16 rf:1;
> > > +			u16 uprgi:1;
> > > +			u16 rsv2:6;
> > > +			u16 stop:1;
> > > +			u16 rsv3:6;
> > > +			u16 pasid_required:1;
> > > +		};
> > > +	} status_reg;
> > > +	u32 prq_capacity;
> > > +	u32 prq_quota;
> > > +};
> > > +
> > > +static int vfio_pci_add_pri_cap(struct vfio_pci_device *vdev,
> > > +				    struct pci_dev *pdev,
> > > +				    u16 epos, u16 *next, __le32 **prevp)
> > > +{
> > > +	u8 *map = vdev->pci_config_map;
> > > +	int ecap = PCI_EXT_CAP_ID_PRI;
> > > +	int len = pci_ext_cap_length[ecap];
> > > +	struct vfio_pci_pri_cap_data pri_cap;
> > > +	struct vfio_pci_pri_cap_data vpri_cap;
> > > +	int ret;
> > > +
> > > +	/*
> > > +	 * If no cap filled in this function, should make sure the next
> > > +	 * pointer points to current epos.
> > > +	 */
> > > +	*next = epos;
> > > +
> > > +	if (!len) {
> > > +		pr_info("%s: VF %s hiding PRI capability\n",
> > > +				__func__, dev_name(&vdev->pdev->dev));
> > > +		ret = 0;
> > > +		goto out;
> > > +	}
> > > +
> > > +	/* Add PASID capability*/
> > > +	ret = vfio_pci_get_ecap_content(pdev, ecap,
> > > +					len, (u8 *)&pri_cap);
> > > +	if (ret)
> > > +		goto out;
> > > +
> > > +	if (!pri_cap.control_reg.enable) {
> > > +		pr_debug("%s: its PF's PRI capability is not enabled\n",
> > > +			dev_name(&vdev->pdev->dev));
> > > +		ret = 0;
> > > +		goto out;
> > > +	}
> > > +
> > > +	memcpy(&vpri_cap, &pri_cap, len);
> > > +
> > > +	vpri_cap.id = 0x19;  
> > 
> > #define PCI_EXT_CAP_ID_SECPCI   0x19    /* Secondary PCIe Capability */
> > 
> > ???  
> 
> my bad... This line was used in development phase. not needed in formal
> patch. really sorry for the mislead.. will remove it.
> 
> > > +	vpri_cap.next = 0;
> > > +	/* clear the control reg for guest */
> > > +	memset(&vpri_cap.control_reg, 0x0,
> > > +			sizeof(vpri_cap.control_reg));
> > > +
> > > +	memset(map + epos, vpri_cap.id, len);
> > > +	ret = vfio_fill_custom_vconfig_bytes(vdev, epos,
> > > +					(u8 *)&vpri_cap, len);
> > > +	if (!ret) {
> > > +		/*
> > > +		 * Successfully filled in PASID cap, update
> > > +		 * the next offset in previous cap header,
> > > +		 * and also update caller about the offset
> > > +		 * of next cap if any.
> > > +		 */
> > > +		u32 val = epos;
> > > +		**prevp &= cpu_to_le32(~(0xffcU << 20));
> > > +		**prevp |= cpu_to_le32(val << 20);
> > > +		*prevp = (__le32 *)&vdev->vconfig[epos];
> > > +		*next = epos + len;
> > > +	}
> > > +
> > > +out:
> > > +	return ret;
> > > +}
> > > +
> > > +static int vfio_pci_add_emulated_cap_for_vf(struct vfio_pci_device *vdev,
> > > +			struct pci_dev *pdev, u16 start_epos, __le32 *prev)
> > > +{
> > > +	__le32 *__prev = prev;
> > > +	u16 epos = start_epos, epos_next = start_epos;
> > > +	int ret = 0;
> > > +
> > > +	/* Add PASID capability*/
> > > +	ret = vfio_pci_add_pasid_cap(vdev, pdev, epos,
> > > +					&epos_next, &__prev);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	/* Add PRI capability */
> > > +	epos = epos_next;
> > > +	ret = vfio_pci_add_pri_cap(vdev, pdev, epos,
> > > +				   &epos_next, &__prev);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > >  static int vfio_ecap_init(struct vfio_pci_device *vdev)
> > >  {
> > >  	struct pci_dev *pdev = vdev->pdev;
> > >  	u8 *map = vdev->pci_config_map;
> > > -	u16 epos;
> > > +	u16 epos, epos_max;
> > >  	__le32 *prev = NULL;
> > >  	int loops, ret, ecaps = 0;
> > >
> > > @@ -1521,6 +1814,7 @@ static int vfio_ecap_init(struct vfio_pci_device *vdev)
> > >  		return 0;
> > >
> > >  	epos = PCI_CFG_SPACE_SIZE;
> > > +	epos_max = PCI_CFG_SPACE_SIZE;
> > >
> > >  	loops = (pdev->cfg_size - PCI_CFG_SPACE_SIZE) / PCI_CAP_SIZEOF;
> > >
> > > @@ -1545,6 +1839,9 @@ static int vfio_ecap_init(struct vfio_pci_device *vdev)
> > >  			}
> > >  		}
> > >
> > > +		if (epos_max <= (epos + len))
> > > +			epos_max = epos + len;
> > > +
> > >  		if (!len) {
> > >  			pci_info(pdev, "%s: hiding ecap %#x@%#x\n",
> > >  				 __func__, ecap, epos);
> > > @@ -1604,6 +1901,18 @@ static int vfio_ecap_init(struct vfio_pci_device *vdev)
> > >  	if (!ecaps)
> > >  		*(u32 *)&vdev->vconfig[PCI_CFG_SPACE_SIZE] = 0;
> > >
> > > +#ifdef CONFIG_PCI_ATS
> > > +	if (pdev->is_virtfn) {
> > > +		struct pci_dev *physfn = pdev->physfn;
> > > +
> > > +		ret = vfio_pci_add_emulated_cap_for_vf(vdev,
> > > +					physfn, epos_max, prev);
> > > +		if (ret)
> > > +			pr_info("%s, failed to add special caps for VF %s\n",
> > > +				__func__, dev_name(&vdev->pdev->dev));
> > > +	}
> > > +#endif  
> > 
> > I can only imagine that we should place the caps at the same location
> > they exist on the PF, we don't know what hidden registers might be
> > hiding in config space.  
> 
> but we are not sure whether the same location is available on VF. In
> this patch, it actually places the emulated cap physically behind the
> cap which lays farthest (its offset is largest) within VF's config space
> as the PCIe caps are linked in a chain.

But, as we've found on Broadcom NICs (iirc), hardware developers have a
nasty habit of hiding random registers in PCI config space, outside of
defined capabilities.  I feel like IGD might even do this too, is that
true?  So I don't think we can guarantee that just because a section of
config space isn't part of a defined capability that its unused.  It
only means that it's unused by common code, but it might have device
specific purposes.  So of the PCIe spec indicates that VFs cannot
include these capabilities and virtialization software needs to
emulate them, we need somewhere safe to place them in config space, and
simply placing them off the end of known capabilities doesn't give me
any confidence.  Also, hardware has no requirement to make compact use
of extended config space.  The first capability must be at 0x100, the
very next capability could consume all the way to the last byte of the
4K extended range, and the next link in the chain could be somewhere in
the middle.  Thanks,

Alex
 
> > > +
> > >  	return 0;
> > >  }
> > >
> > > @@ -1748,6 +2057,17 @@ static size_t vfio_pci_cap_remaining_dword(struct  
> > vfio_pci_device *vdev,  
> > >  	return i;
> > >  }
> > >
> > > +static bool vfio_pci_need_virt_perm(struct pci_dev *pdev, u8 cap_id)
> > > +{
> > > +#ifdef CONFIG_PCI_ATS
> > > +	return (pdev->is_virtfn &&
> > > +		(cap_id == PCI_EXT_CAP_ID_PASID ||
> > > +		 cap_id == PCI_EXT_CAP_ID_PRI));
> > > +#else
> > > +	return false;
> > > +#endif
> > > +}
> > > +
> > >  static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
> > >  				 size_t count, loff_t *ppos, bool iswrite)
> > >  {
> > > @@ -1781,7 +2101,8 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_device  
> > *vdev, char __user *buf,  
> > >  	if (cap_id == PCI_CAP_ID_INVALID) {
> > >  		perm = &unassigned_perms;
> > >  		cap_start = *ppos;
> > > -	} else if (cap_id == PCI_CAP_ID_INVALID_VIRT) {
> > > +	} else if (cap_id == PCI_CAP_ID_INVALID_VIRT ||
> > > +		   vfio_pci_need_virt_perm(pdev, cap_id)) {  
> > 
> > Why not simply fill the map with PCI_CAP_ID_INVALID_VIRT?  
> 
> good idea. thanks.
> 
> > >  		perm = &virt_perms;
> > >  		cap_start = *ppos;
> > >  	} else {  
> > 
> > This is really not close to acceptable as is.  Sorry.  Thanks,  
> 
> really sorry for the silly mistakes, I can try to make a new version
> after we got a decision on whether needs to do data copy and medication
> before filling into vconfig.
> 
> Thanks,
> Yi Liu
> 


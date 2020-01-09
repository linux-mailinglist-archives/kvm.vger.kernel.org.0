Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C2A136379
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 23:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbgAIWsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 17:48:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44108 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729499AbgAIWso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 17:48:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578610122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4g2mUG1S11VdHZCfMr80HAZET9umkdwy1eo1orQPHII=;
        b=NwXmZIP9srr68rDQjKouMN8IaaRrQcQ8Vh2ajcGUMdCfFRcr8mCn1lgpa35oW0NGhMoH1/
        V//sK/HYnbCFiNYn58BesoRWiUI5eUFyMB4fJz6qkaj62oFBvrYLQb80smvgDvUt1uqHks
        9e5qj4clJoIGgzS3oX1Gw06AEoZzvvQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-AVsXJM00N1OJ4cr3sBM5xA-1; Thu, 09 Jan 2020 17:48:39 -0500
X-MC-Unique: AVsXJM00N1OJ4cr3sBM5xA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64893800D41;
        Thu,  9 Jan 2020 22:48:38 +0000 (UTC)
Received: from w520.home (ovpn-116-128.phx2.redhat.com [10.3.116.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C243960FA2;
        Thu,  9 Jan 2020 22:48:37 +0000 (UTC)
Date:   Thu, 9 Jan 2020 15:48:37 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     kwankhede@nvidia.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kevin.tian@intel.com, joro@8bytes.org,
        peterx@redhat.com, baolu.lu@linux.intel.com
Subject: Re: [PATCH v4 09/12] vfio: split vfio_pci_private.h into two files
Message-ID: <20200109154837.278274f7@w520.home>
In-Reply-To: <1578398509-26453-10-git-send-email-yi.l.liu@intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-10-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/uRpTlX5YVNlQmhq.F/OsyI_"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--MP_/uRpTlX5YVNlQmhq.F/OsyI_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue,  7 Jan 2020 20:01:46 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch splits the vfio_pci_private.h to be a private file
> in drivers/vfio/pci and a common file under include/linux/. It
> is a preparation for supporting vfio_pci common code sharing
> outside drivers/vfio/pci/.
> 
> The common header file is shrunk from the previous copied
> vfio_pci_common.h. The original vfio_pci_private.h is shrunk
> accordingly as well.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_private.h | 133 +-----------------------------------
>  include/linux/vfio_pci_common.h     |  86 ++---------------------
>  2 files changed, 7 insertions(+), 212 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index 499dd04..c4976a9 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -12,6 +12,7 @@
>  #include <linux/pci.h>
>  #include <linux/irqbypass.h>
>  #include <linux/types.h>
> +#include <linux/vfio_pci_common.h>
>  
>  #ifndef VFIO_PCI_PRIVATE_H
>  #define VFIO_PCI_PRIVATE_H
> @@ -39,121 +40,12 @@ struct vfio_pci_ioeventfd {
>  	int			count;
>  };
>  
> -struct vfio_pci_irq_ctx {
> -	struct eventfd_ctx	*trigger;
> -	struct virqfd		*unmask;
> -	struct virqfd		*mask;
> -	char			*name;
> -	bool			masked;
> -	struct irq_bypass_producer	producer;
> -};

I think this can stay here, vfio_pci_common.h just needs a forward
declaration.

> -
> -struct vfio_pci_device;
> -struct vfio_pci_region;
> -
> -struct vfio_pci_regops {
> -	size_t	(*rw)(struct vfio_pci_device *vdev, char __user *buf,
> -		      size_t count, loff_t *ppos, bool iswrite);
> -	void	(*release)(struct vfio_pci_device *vdev,
> -			   struct vfio_pci_region *region);
> -	int	(*mmap)(struct vfio_pci_device *vdev,
> -			struct vfio_pci_region *region,
> -			struct vm_area_struct *vma);
> -	int	(*add_capability)(struct vfio_pci_device *vdev,
> -				  struct vfio_pci_region *region,
> -				  struct vfio_info_cap *caps);
> -};
> -
> -struct vfio_pci_region {
> -	u32				type;
> -	u32				subtype;
> -	const struct vfio_pci_regops	*ops;
> -	void				*data;
> -	size_t				size;
> -	u32				flags;
> -};
> -
>  struct vfio_pci_dummy_resource {
>  	struct resource		resource;
>  	int			index;
>  	struct list_head	res_next;
>  };
>  
> -struct vfio_pci_reflck {
> -	struct kref		kref;
> -	struct mutex		lock;
> -};

I think we can abstract this a little further to make it unnecessary to
put this in common as well.  See attached.

> -
> -struct vfio_pci_device {
> -	struct pci_dev		*pdev;
> -	void __iomem		*barmap[PCI_STD_NUM_BARS];
> -	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
> -	u8			*pci_config_map;
> -	u8			*vconfig;
> -	struct perm_bits	*msi_perm;
> -	spinlock_t		irqlock;
> -	struct mutex		igate;
> -	struct vfio_pci_irq_ctx	*ctx;
> -	int			num_ctx;
> -	int			irq_type;
> -	int			num_regions;
> -	struct vfio_pci_region	*region;
> -	u8			msi_qmax;
> -	u8			msix_bar;
> -	u16			msix_size;
> -	u32			msix_offset;
> -	u32			rbar[7];
> -	bool			pci_2_3;
> -	bool			virq_disabled;
> -	bool			reset_works;
> -	bool			extended_caps;
> -	bool			bardirty;
> -	bool			has_vga;
> -	bool			needs_reset;
> -	bool			nointx;
> -	bool			needs_pm_restore;
> -	struct pci_saved_state	*pci_saved_state;
> -	struct pci_saved_state	*pm_save;
> -	struct vfio_pci_reflck	*reflck;
> -	int			refcnt;
> -	int			ioeventfds_nr;
> -	struct eventfd_ctx	*err_trigger;
> -	struct eventfd_ctx	*req_trigger;
> -	struct list_head	dummy_resources_list;
> -	struct mutex		ioeventfds_lock;
> -	struct list_head	ioeventfds_list;
> -	bool			nointxmask;
> -#ifdef CONFIG_VFIO_PCI_VGA
> -	bool			disable_vga;
> -#endif
> -	bool			disable_idle_d3;
> -};
> -
> -#define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
> -#define is_msi(vdev) (vdev->irq_type == VFIO_PCI_MSI_IRQ_INDEX)
> -#define is_msix(vdev) (vdev->irq_type == VFIO_PCI_MSIX_IRQ_INDEX)
> -#define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
> -#define irq_is(vdev, type) (vdev->irq_type == type)

I think these can stay in the private header too.

> -
> -extern const struct pci_error_handlers vfio_err_handlers;
> -
> -static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
> -{
> -	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
> -}
> -
> -static inline bool vfio_vga_disabled(struct vfio_pci_device *vdev)
> -{
> -#ifdef CONFIG_VFIO_PCI_VGA
> -	return vdev->disable_vga;
> -#else
> -	return true;
> -#endif
> -}

vfio_vga_disabled() is only used in vfio_pci_common.c, I think it can
remain in private.

> -
> -extern void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
> -				bool nointxmask, bool disable_idle_d3);
> -
>  extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
>  extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
>  
> @@ -180,29 +72,6 @@ extern void vfio_pci_uninit_perm_bits(void);
>  extern int vfio_config_init(struct vfio_pci_device *vdev);
>  extern void vfio_config_free(struct vfio_pci_device *vdev);
>  
> -extern int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
> -					unsigned int type, unsigned int subtype,
> -					const struct vfio_pci_regops *ops,
> -					size_t size, u32 flags, void *data);
> -
> -extern int vfio_pci_set_power_state(struct vfio_pci_device *vdev,
> -				    pci_power_t state);
> -extern unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga);
> -extern int vfio_pci_enable(struct vfio_pci_device *vdev);
> -extern void vfio_pci_disable(struct vfio_pci_device *vdev);
> -extern long vfio_pci_ioctl(void *device_data,
> -			unsigned int cmd, unsigned long arg);
> -extern ssize_t vfio_pci_read(void *device_data, char __user *buf,
> -			size_t count, loff_t *ppos);
> -extern ssize_t vfio_pci_write(void *device_data, const char __user *buf,
> -			size_t count, loff_t *ppos);
> -extern int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma);
> -extern void vfio_pci_request(void *device_data, unsigned int count);
> -extern void vfio_pci_fill_ids(char *ids, struct pci_driver *driver);
> -extern int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
> -extern void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
> -extern void vfio_pci_probe_power_state(struct vfio_pci_device *vdev);
> -
>  #ifdef CONFIG_VFIO_PCI_IGD
>  extern int vfio_pci_igd_init(struct vfio_pci_device *vdev);
>  #else
> diff --git a/include/linux/vfio_pci_common.h b/include/linux/vfio_pci_common.h
> index 499dd04..862cd80 100644
> --- a/include/linux/vfio_pci_common.h
> +++ b/include/linux/vfio_pci_common.h
> @@ -1,5 +1,8 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  /*
> + * VFIO PCI API definition
> + *
> + * Derived from original vfio/pci/vfio_pci_private.h:
>   * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
>   *     Author: Alex Williamson <alex.williamson@redhat.com>
>   *
> @@ -13,31 +16,8 @@
>  #include <linux/irqbypass.h>
>  #include <linux/types.h>
>  
> -#ifndef VFIO_PCI_PRIVATE_H
> -#define VFIO_PCI_PRIVATE_H
> -
> -#define VFIO_PCI_OFFSET_SHIFT   40
> -
> -#define VFIO_PCI_OFFSET_TO_INDEX(off)	(off >> VFIO_PCI_OFFSET_SHIFT)
> -#define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
> -#define VFIO_PCI_OFFSET_MASK	(((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
> -
> -/* Special capability IDs predefined access */
> -#define PCI_CAP_ID_INVALID		0xFF	/* default raw access */
> -#define PCI_CAP_ID_INVALID_VIRT		0xFE	/* default virt access */
> -
> -/* Cap maximum number of ioeventfds per device (arbitrary) */
> -#define VFIO_PCI_IOEVENTFD_MAX		1000
> -
> -struct vfio_pci_ioeventfd {
> -	struct list_head	next;
> -	struct virqfd		*virqfd;
> -	void __iomem		*addr;
> -	uint64_t		data;
> -	loff_t			pos;
> -	int			bar;
> -	int			count;
> -};
> +#ifndef VFIO_PCI_COMMON_H
> +#define VFIO_PCI_COMMON_H
>  
>  struct vfio_pci_irq_ctx {
>  	struct eventfd_ctx	*trigger;
> @@ -73,12 +53,6 @@ struct vfio_pci_region {
>  	u32				flags;
>  };
>  
> -struct vfio_pci_dummy_resource {
> -	struct resource		resource;
> -	int			index;
> -	struct list_head	res_next;
> -};
> -
>  struct vfio_pci_reflck {
>  	struct kref		kref;
>  	struct mutex		lock;
> @@ -154,32 +128,6 @@ static inline bool vfio_vga_disabled(struct vfio_pci_device *vdev)
>  extern void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
>  				bool nointxmask, bool disable_idle_d3);
>  
> -extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
> -extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
> -
> -extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev,
> -				   uint32_t flags, unsigned index,
> -				   unsigned start, unsigned count, void *data);
> -
> -extern ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev,
> -				  char __user *buf, size_t count,
> -				  loff_t *ppos, bool iswrite);
> -
> -extern ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
> -			       size_t count, loff_t *ppos, bool iswrite);
> -
> -extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
> -			       size_t count, loff_t *ppos, bool iswrite);
> -
> -extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
> -			       uint64_t data, int count, int fd);
> -
> -extern int vfio_pci_init_perm_bits(void);
> -extern void vfio_pci_uninit_perm_bits(void);
> -
> -extern int vfio_config_init(struct vfio_pci_device *vdev);
> -extern void vfio_config_free(struct vfio_pci_device *vdev);
> -
>  extern int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
>  					unsigned int type, unsigned int subtype,
>  					const struct vfio_pci_regops *ops,
> @@ -203,26 +151,4 @@ extern int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
>  extern void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
>  extern void vfio_pci_probe_power_state(struct vfio_pci_device *vdev);
>  
> -#ifdef CONFIG_VFIO_PCI_IGD
> -extern int vfio_pci_igd_init(struct vfio_pci_device *vdev);
> -#else
> -static inline int vfio_pci_igd_init(struct vfio_pci_device *vdev)
> -{
> -	return -ENODEV;
> -}
> -#endif
> -#ifdef CONFIG_VFIO_PCI_NVLINK2
> -extern int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev);
> -extern int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev);
> -#else
> -static inline int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev)
> -{
> -	return -ENODEV;
> -}
> -
> -static inline int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
> -{
> -	return -ENODEV;
> -}
> -#endif
> -#endif /* VFIO_PCI_PRIVATE_H */
> +#endif /* VFIO_PCI_COMMON_H */


--MP_/uRpTlX5YVNlQmhq.F/OsyI_
Content-Type: application/octet-stream; name=return-to-private
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=return-to-private

VGhlc2UgZG9uJ3Qgc2VlbSB0byBiZSBuZWNlc3NhcnkgaW4gY29tbW9uIGhlYWRlcgoKRnJvbTog
QWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4KCgotLS0KIGRyaXZl
cnMvdmZpby9wY2kvdmZpb19wY2lfcHJpdmF0ZS5oIHwgICAyOSArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKwogaW5jbHVkZS9saW51eC92ZmlvX3BjaV9jb21tb24uaCAgICAgfCAgIDMxICsr
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMzEgaW5zZXJ0
aW9ucygrKSwgMjkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3BjaS92
ZmlvX3BjaV9wcml2YXRlLmggYi9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX3ByaXZhdGUuaApp
bmRleCBjNDk3NmE5NDhhYWEuLmJmMTk5NWNmNDE3ZCAxMDA2NDQKLS0tIGEvZHJpdmVycy92Zmlv
L3BjaS92ZmlvX3BjaV9wcml2YXRlLmgKKysrIGIvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9w
cml2YXRlLmgKQEAgLTQwLDEyICs0MCw0MSBAQCBzdHJ1Y3QgdmZpb19wY2lfaW9ldmVudGZkIHsK
IAlpbnQJCQljb3VudDsKIH07CiAKK3N0cnVjdCB2ZmlvX3BjaV9pcnFfY3R4IHsKKwlzdHJ1Y3Qg
ZXZlbnRmZF9jdHgJKnRyaWdnZXI7CisJc3RydWN0IHZpcnFmZAkJKnVubWFzazsKKwlzdHJ1Y3Qg
dmlycWZkCQkqbWFzazsKKwljaGFyCQkJKm5hbWU7CisJYm9vbAkJCW1hc2tlZDsKKwlzdHJ1Y3Qg
aXJxX2J5cGFzc19wcm9kdWNlcglwcm9kdWNlcjsKK307CisKIHN0cnVjdCB2ZmlvX3BjaV9kdW1t
eV9yZXNvdXJjZSB7CiAJc3RydWN0IHJlc291cmNlCQlyZXNvdXJjZTsKIAlpbnQJCQlpbmRleDsK
IAlzdHJ1Y3QgbGlzdF9oZWFkCXJlc19uZXh0OwogfTsKIAorc3RydWN0IHZmaW9fcGNpX3JlZmxj
ayB7CisJc3RydWN0IGtyZWYJCWtyZWY7CisJc3RydWN0IG11dGV4CQlsb2NrOworfTsKKworI2Rl
ZmluZSBpc19pbnR4KHZkZXYpICh2ZGV2LT5pcnFfdHlwZSA9PSBWRklPX1BDSV9JTlRYX0lSUV9J
TkRFWCkKKyNkZWZpbmUgaXNfbXNpKHZkZXYpICh2ZGV2LT5pcnFfdHlwZSA9PSBWRklPX1BDSV9N
U0lfSVJRX0lOREVYKQorI2RlZmluZSBpc19tc2l4KHZkZXYpICh2ZGV2LT5pcnFfdHlwZSA9PSBW
RklPX1BDSV9NU0lYX0lSUV9JTkRFWCkKKyNkZWZpbmUgaXNfaXJxX25vbmUodmRldikgKCEoaXNf
aW50eCh2ZGV2KSB8fCBpc19tc2kodmRldikgfHwgaXNfbXNpeCh2ZGV2KSkpCisjZGVmaW5lIGly
cV9pcyh2ZGV2LCB0eXBlKSAodmRldi0+aXJxX3R5cGUgPT0gdHlwZSkKKworc3RhdGljIGlubGlu
ZSBib29sIHZmaW9fdmdhX2Rpc2FibGVkKHN0cnVjdCB2ZmlvX3BjaV9kZXZpY2UgKnZkZXYpCit7
CisjaWZkZWYgQ09ORklHX1ZGSU9fUENJX1ZHQQorCXJldHVybiB2ZGV2LT5kaXNhYmxlX3ZnYTsK
KyNlbHNlCisJcmV0dXJuIHRydWU7CisjZW5kaWYKK30KKwogZXh0ZXJuIHZvaWQgdmZpb19wY2lf
aW50eF9tYXNrKHN0cnVjdCB2ZmlvX3BjaV9kZXZpY2UgKnZkZXYpOwogZXh0ZXJuIHZvaWQgdmZp
b19wY2lfaW50eF91bm1hc2soc3RydWN0IHZmaW9fcGNpX2RldmljZSAqdmRldik7CiAKZGlmZiAt
LWdpdCBhL2luY2x1ZGUvbGludXgvdmZpb19wY2lfY29tbW9uLmggYi9pbmNsdWRlL2xpbnV4L3Zm
aW9fcGNpX2NvbW1vbi5oCmluZGV4IDQzOTY2NmE4Y2U3YS4uZmE1NzJkMzg4MTExIDEwMDY0NAot
LS0gYS9pbmNsdWRlL2xpbnV4L3ZmaW9fcGNpX2NvbW1vbi5oCisrKyBiL2luY2x1ZGUvbGludXgv
dmZpb19wY2lfY29tbW9uLmgKQEAgLTE5LDE3ICsxOSwxMCBAQAogI2lmbmRlZiBWRklPX1BDSV9D
T01NT05fSAogI2RlZmluZSBWRklPX1BDSV9DT01NT05fSAogCi1zdHJ1Y3QgdmZpb19wY2lfaXJx
X2N0eCB7Ci0Jc3RydWN0IGV2ZW50ZmRfY3R4CSp0cmlnZ2VyOwotCXN0cnVjdCB2aXJxZmQJCSp1
bm1hc2s7Ci0Jc3RydWN0IHZpcnFmZAkJKm1hc2s7Ci0JY2hhcgkJCSpuYW1lOwotCWJvb2wJCQlt
YXNrZWQ7Ci0Jc3RydWN0IGlycV9ieXBhc3NfcHJvZHVjZXIJcHJvZHVjZXI7Ci19OwotCitzdHJ1
Y3QgdmZpb19wY2lfaXJxX2N0eDsKIHN0cnVjdCB2ZmlvX3BjaV9kZXZpY2U7CiBzdHJ1Y3QgdmZp
b19wY2lfcmVnaW9uOworc3RydWN0IHZmaW9fcGNpX3JlZmxjazsKIAogc3RydWN0IHZmaW9fcGNp
X3JlZ29wcyB7CiAJc2l6ZV90CSgqcncpKHN0cnVjdCB2ZmlvX3BjaV9kZXZpY2UgKnZkZXYsIGNo
YXIgX191c2VyICpidWYsCkBAIC01MywxMSArNDYsNiBAQCBzdHJ1Y3QgdmZpb19wY2lfcmVnaW9u
IHsKIAl1MzIJCQkJZmxhZ3M7CiB9OwogCi1zdHJ1Y3QgdmZpb19wY2lfcmVmbGNrIHsKLQlzdHJ1
Y3Qga3JlZgkJa3JlZjsKLQlzdHJ1Y3QgbXV0ZXgJCWxvY2s7Ci19OwotCiBzdHJ1Y3QgdmZpb19w
Y2lfZGV2aWNlIHsKIAlzdHJ1Y3QgcGNpX2RldgkJKnBkZXY7CiAJdm9pZCBfX2lvbWVtCQkqYmFy
bWFwW1BDSV9TVERfTlVNX0JBUlNdOwpAQCAtMTAzLDEyICs5MSw2IEBAIHN0cnVjdCB2ZmlvX3Bj
aV9kZXZpY2UgewogCWJvb2wJCQlkaXNhYmxlX2lkbGVfZDM7CiB9OwogCi0jZGVmaW5lIGlzX2lu
dHgodmRldikgKHZkZXYtPmlycV90eXBlID09IFZGSU9fUENJX0lOVFhfSVJRX0lOREVYKQotI2Rl
ZmluZSBpc19tc2kodmRldikgKHZkZXYtPmlycV90eXBlID09IFZGSU9fUENJX01TSV9JUlFfSU5E
RVgpCi0jZGVmaW5lIGlzX21zaXgodmRldikgKHZkZXYtPmlycV90eXBlID09IFZGSU9fUENJX01T
SVhfSVJRX0lOREVYKQotI2RlZmluZSBpc19pcnFfbm9uZSh2ZGV2KSAoIShpc19pbnR4KHZkZXYp
IHx8IGlzX21zaSh2ZGV2KSB8fCBpc19tc2l4KHZkZXYpKSkKLSNkZWZpbmUgaXJxX2lzKHZkZXYs
IHR5cGUpICh2ZGV2LT5pcnFfdHlwZSA9PSB0eXBlKQotCiBleHRlcm4gY29uc3Qgc3RydWN0IHBj
aV9lcnJvcl9oYW5kbGVycyB2ZmlvX3BjaV9lcnJfaGFuZGxlcnM7CiAKIHN0YXRpYyBpbmxpbmUg
Ym9vbCB2ZmlvX3BjaV9pc192Z2Eoc3RydWN0IHBjaV9kZXYgKnBkZXYpCkBAIC0xMTYsMTUgKzk4
LDYgQEAgc3RhdGljIGlubGluZSBib29sIHZmaW9fcGNpX2lzX3ZnYShzdHJ1Y3QgcGNpX2RldiAq
cGRldikKIAlyZXR1cm4gKHBkZXYtPmNsYXNzID4+IDgpID09IFBDSV9DTEFTU19ESVNQTEFZX1ZH
QTsKIH0KIAotc3RhdGljIGlubGluZSBib29sIHZmaW9fdmdhX2Rpc2FibGVkKHN0cnVjdCB2Zmlv
X3BjaV9kZXZpY2UgKnZkZXYpCi17Ci0jaWZkZWYgQ09ORklHX1ZGSU9fUENJX1ZHQQotCXJldHVy
biB2ZGV2LT5kaXNhYmxlX3ZnYTsKLSNlbHNlCi0JcmV0dXJuIHRydWU7Ci0jZW5kaWYKLX0KLQog
ZXh0ZXJuIHZvaWQgdmZpb19wY2lfcmVmcmVzaF9jb25maWcoc3RydWN0IHZmaW9fcGNpX2Rldmlj
ZSAqdmRldiwKIAkJCQlib29sIG5vaW50eG1hc2ssIGJvb2wgZGlzYWJsZV9pZGxlX2QzKTsKIAo=

--MP_/uRpTlX5YVNlQmhq.F/OsyI_
Content-Type: application/octet-stream; name=abstract-reflck
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=abstract-reflck

TWFrZSBpdCAobW9yZSkgYWJzdHJhY3QKCkZyb206IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxs
aWFtc29uQHJlZGhhdC5jb20+CgoKLS0tCiBkcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpLmMgICAg
ICAgICAgIHwgICAxMCArKysrKy0tLS0tCiBkcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2NvbW1v
bi5jICAgIHwgICAxNyArKysrKysrKysrKysrKystLQogaW5jbHVkZS9saW51eC92ZmlvX3BjaV9j
b21tb24uaCAgICAgICB8ICAgIDQgKysrLQogc2FtcGxlcy92ZmlvLW1kZXYtcGNpL3ZmaW9fbWRl
dl9wY2kuYyB8ICAgMTAgKysrKystLS0tLQogNCBmaWxlcyBjaGFuZ2VkLCAyOCBpbnNlcnRpb25z
KCspLCAxMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9f
cGNpLmMgYi9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpLmMKaW5kZXggNzA0NzY2NzE0YzExLi4x
ZTlkNmU0ZTljODEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdmZpby9wY2kvdmZpb19wY2kuYworKysg
Yi9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpLmMKQEAgLTU4LDE0ICs1OCwxNCBAQCBzdGF0aWMg
dm9pZCB2ZmlvX3BjaV9yZWxlYXNlKHZvaWQgKmRldmljZV9kYXRhKQogewogCXN0cnVjdCB2Zmlv
X3BjaV9kZXZpY2UgKnZkZXYgPSBkZXZpY2VfZGF0YTsKIAotCW11dGV4X2xvY2soJnZkZXYtPnJl
Zmxjay0+bG9jayk7CisJdmZpb19wY2lfcmVmbGNrX2xvY2sodmRldik7CiAKIAlpZiAoISgtLXZk
ZXYtPnJlZmNudCkpIHsKIAkJdmZpb19zcGFwcl9wY2lfZWVoX3JlbGVhc2UodmRldi0+cGRldik7
CiAJCXZmaW9fcGNpX2Rpc2FibGUodmRldik7CiAJfQogCi0JbXV0ZXhfdW5sb2NrKCZ2ZGV2LT5y
ZWZsY2stPmxvY2spOworCXZmaW9fcGNpX3JlZmxja191bmxvY2sodmRldik7CiAKIAltb2R1bGVf
cHV0KFRISVNfTU9EVUxFKTsKIH0KQEAgLTgwLDcgKzgwLDcgQEAgc3RhdGljIGludCB2ZmlvX3Bj
aV9vcGVuKHZvaWQgKmRldmljZV9kYXRhKQogCiAJdmZpb19wY2lfcmVmcmVzaF9jb25maWcodmRl
diwgbm9pbnR4bWFzaywgZGlzYWJsZV9pZGxlX2QzKTsKIAotCW11dGV4X2xvY2soJnZkZXYtPnJl
Zmxjay0+bG9jayk7CisJdmZpb19wY2lfcmVmbGNrX2xvY2sodmRldik7CiAKIAlpZiAoIXZkZXYt
PnJlZmNudCkgewogCQlyZXQgPSB2ZmlvX3BjaV9lbmFibGUodmRldik7CkBAIC05MSw3ICs5MSw3
IEBAIHN0YXRpYyBpbnQgdmZpb19wY2lfb3Blbih2b2lkICpkZXZpY2VfZGF0YSkKIAl9CiAJdmRl
di0+cmVmY250Kys7CiBlcnJvcjoKLQltdXRleF91bmxvY2soJnZkZXYtPnJlZmxjay0+bG9jayk7
CisJdmZpb19wY2lfcmVmbGNrX3VubG9jayh2ZGV2KTsKIAlpZiAocmV0KQogCQltb2R1bGVfcHV0
KFRISVNfTU9EVUxFKTsKIAlyZXR1cm4gcmV0OwpAQCAtMjAwLDcgKzIwMCw3IEBAIHN0YXRpYyB2
b2lkIHZmaW9fcGNpX3JlbW92ZShzdHJ1Y3QgcGNpX2RldiAqcGRldikKIAlpZiAoIXZkZXYpCiAJ
CXJldHVybjsKIAotCXZmaW9fcGNpX3JlZmxja19wdXQodmRldi0+cmVmbGNrKTsKKwl2ZmlvX3Bj
aV9yZWZsY2tfcHV0KHZkZXYpOwogCiAJdmZpb19pb21tdV9ncm91cF9wdXQocGRldi0+ZGV2Lmlv
bW11X2dyb3VwLCAmcGRldi0+ZGV2KTsKIAlrZnJlZSh2ZGV2LT5yZWdpb24pOwpkaWZmIC0tZ2l0
IGEvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb21tb24uYyBiL2RyaXZlcnMvdmZpby9wY2kv
dmZpb19wY2lfY29tbW9uLmMKaW5kZXggZWRkYTdlNGRjMmU3Li5jMDQ2Mjc5OWZjOGQgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvdmZpby9wY2kvdmZpb19wY2lfY29tbW9uLmMKKysrIGIvZHJpdmVycy92
ZmlvL3BjaS92ZmlvX3BjaV9jb21tb24uYwpAQCAtMTI1OCw2ICsxMjU4LDE4IEBAIEVYUE9SVF9T
WU1CT0xfR1BMKHZmaW9fcGNpX2Vycl9oYW5kbGVycyk7CiAKIHN0YXRpYyBERUZJTkVfTVVURVgo
cmVmbGNrX2xvY2spOwogCit2b2lkIHZmaW9fcGNpX3JlZmxja19sb2NrKHN0cnVjdCB2ZmlvX3Bj
aV9kZXZpY2UgKnZkZXYpCit7CisJbXV0ZXhfbG9jaygmdmRldi0+cmVmbGNrLT5sb2NrKTsKK30K
K0VYUE9SVF9TWU1CT0wodmZpb19wY2lfcmVmbGNrX2xvY2spOworCit2b2lkIHZmaW9fcGNpX3Jl
Zmxja191bmxvY2soc3RydWN0IHZmaW9fcGNpX2RldmljZSAqdmRldikKK3sKKwltdXRleF91bmxv
Y2soJnZkZXYtPnJlZmxjay0+bG9jayk7Cit9CitFWFBPUlRfU1lNQk9MKHZmaW9fcGNpX3JlZmxj
a191bmxvY2spOworCiBzdGF0aWMgc3RydWN0IHZmaW9fcGNpX3JlZmxjayAqdmZpb19wY2lfcmVm
bGNrX2FsbG9jKHZvaWQpCiB7CiAJc3RydWN0IHZmaW9fcGNpX3JlZmxjayAqcmVmbGNrOwpAQCAt
MTMzMyw5ICsxMzQ1LDEwIEBAIHN0YXRpYyB2b2lkIHZmaW9fcGNpX3JlZmxja19yZWxlYXNlKHN0
cnVjdCBrcmVmICprcmVmKQogCW11dGV4X3VubG9jaygmcmVmbGNrX2xvY2spOwogfQogCi12b2lk
IHZmaW9fcGNpX3JlZmxja19wdXQoc3RydWN0IHZmaW9fcGNpX3JlZmxjayAqcmVmbGNrKQordm9p
ZCB2ZmlvX3BjaV9yZWZsY2tfcHV0KHN0cnVjdCB2ZmlvX3BjaV9kZXZpY2UgKnZkZXYpCiB7Ci0J
a3JlZl9wdXRfbXV0ZXgoJnJlZmxjay0+a3JlZiwgdmZpb19wY2lfcmVmbGNrX3JlbGVhc2UsICZy
ZWZsY2tfbG9jayk7CisJa3JlZl9wdXRfbXV0ZXgoJnZkZXYtPnJlZmxjay0+a3JlZiwKKwkJICAg
ICAgIHZmaW9fcGNpX3JlZmxja19yZWxlYXNlLCAmcmVmbGNrX2xvY2spOwogfQogRVhQT1JUX1NZ
TUJPTF9HUEwodmZpb19wY2lfcmVmbGNrX3B1dCk7CiAKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGlu
dXgvdmZpb19wY2lfY29tbW9uLmggYi9pbmNsdWRlL2xpbnV4L3ZmaW9fcGNpX2NvbW1vbi5oCmlu
ZGV4IGZhNTcyZDM4ODExMS4uODA5MGQ1NDY5MTgzIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4
L3ZmaW9fcGNpX2NvbW1vbi5oCisrKyBiL2luY2x1ZGUvbGludXgvdmZpb19wY2lfY29tbW9uLmgK
QEAgLTEyMCw4ICsxMjAsMTAgQEAgZXh0ZXJuIHNzaXplX3QgdmZpb19wY2lfd3JpdGUodm9pZCAq
ZGV2aWNlX2RhdGEsIGNvbnN0IGNoYXIgX191c2VyICpidWYsCiBleHRlcm4gaW50IHZmaW9fcGNp
X21tYXAodm9pZCAqZGV2aWNlX2RhdGEsIHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hKTsKIGV4
dGVybiB2b2lkIHZmaW9fcGNpX3JlcXVlc3Qodm9pZCAqZGV2aWNlX2RhdGEsIHVuc2lnbmVkIGlu
dCBjb3VudCk7CiBleHRlcm4gdm9pZCB2ZmlvX3BjaV9maWxsX2lkcyhjaGFyICppZHMsIHN0cnVj
dCBwY2lfZHJpdmVyICpkcml2ZXIpOworZXh0ZXJuIHZvaWQgdmZpb19wY2lfcmVmbGNrX2xvY2so
c3RydWN0IHZmaW9fcGNpX2RldmljZSAqdmRldik7CitleHRlcm4gdm9pZCB2ZmlvX3BjaV9yZWZs
Y2tfdW5sb2NrKHN0cnVjdCB2ZmlvX3BjaV9kZXZpY2UgKnZkZXYpOwogZXh0ZXJuIGludCB2Zmlv
X3BjaV9yZWZsY2tfYXR0YWNoKHN0cnVjdCB2ZmlvX3BjaV9kZXZpY2UgKnZkZXYpOwotZXh0ZXJu
IHZvaWQgdmZpb19wY2lfcmVmbGNrX3B1dChzdHJ1Y3QgdmZpb19wY2lfcmVmbGNrICpyZWZsY2sp
OworZXh0ZXJuIHZvaWQgdmZpb19wY2lfcmVmbGNrX3B1dChzdHJ1Y3QgdmZpb19wY2lfZGV2aWNl
ICp2ZGV2KTsKIGV4dGVybiB2b2lkIHZmaW9fcGNpX3Byb2JlX3Bvd2VyX3N0YXRlKHN0cnVjdCB2
ZmlvX3BjaV9kZXZpY2UgKnZkZXYpOwogCiAjZW5kaWYgLyogVkZJT19QQ0lfQ09NTU9OX0ggKi8K
ZGlmZiAtLWdpdCBhL3NhbXBsZXMvdmZpby1tZGV2LXBjaS92ZmlvX21kZXZfcGNpLmMgYi9zYW1w
bGVzL3ZmaW8tbWRldi1wY2kvdmZpb19tZGV2X3BjaS5jCmluZGV4IGIxODAzNTZiYjRlZS4uYzk4
MzI4Y2I0ZTNmIDEwMDY0NAotLS0gYS9zYW1wbGVzL3ZmaW8tbWRldi1wY2kvdmZpb19tZGV2X3Bj
aS5jCisrKyBiL3NhbXBsZXMvdmZpby1tZGV2LXBjaS92ZmlvX21kZXZfcGNpLmMKQEAgLTE2NCw3
ICsxNjQsNyBAQCBzdGF0aWMgaW50IHZmaW9fbWRldl9wY2lfb3BlbihzdHJ1Y3QgbWRldl9kZXZp
Y2UgKm1kZXYpCiAKIAl2ZmlvX3BjaV9yZWZyZXNoX2NvbmZpZyh2ZGV2LCBub2ludHhtYXNrLCBk
aXNhYmxlX2lkbGVfZDMpOwogCi0JbXV0ZXhfbG9jaygmdmRldi0+cmVmbGNrLT5sb2NrKTsKKwl2
ZmlvX3BjaV9yZWZsY2tfbG9jayh2ZGV2KTsKIAogCWlmICghdmRldi0+cmVmY250KSB7CiAJCXJl
dCA9IHZmaW9fcGNpX2VuYWJsZSh2ZGV2KTsKQEAgLTE3NSw3ICsxNzUsNyBAQCBzdGF0aWMgaW50
IHZmaW9fbWRldl9wY2lfb3BlbihzdHJ1Y3QgbWRldl9kZXZpY2UgKm1kZXYpCiAJfQogCXZkZXYt
PnJlZmNudCsrOwogZXJyb3I6Ci0JbXV0ZXhfdW5sb2NrKCZ2ZGV2LT5yZWZsY2stPmxvY2spOwor
CXZmaW9fcGNpX3JlZmxja191bmxvY2sodmRldik7CiAJaWYgKCFyZXQpCiAJCXByX2luZm8oIlN1
Y2NlZWRlZCB0byBvcGVuIG1kZXY6ICVzIG9uIHBmOiAlc1xuIiwKIAkJZGV2X25hbWUobWRldl9k
ZXYobWRldikpLCBkZXZfbmFtZSgmcG1kZXYtPnZkZXYtPnBkZXYtPmRldikpOwpAQCAtMTk1LDE0
ICsxOTUsMTQgQEAgc3RhdGljIHZvaWQgdmZpb19tZGV2X3BjaV9yZWxlYXNlKHN0cnVjdCBtZGV2
X2RldmljZSAqbWRldikKIAlwcl9pbmZvKCJSZWxlYXNlIG1kZXY6ICVzIG9uIHBmOiAlc1xuIiwK
IAkJZGV2X25hbWUobWRldl9kZXYobWRldikpLCBkZXZfbmFtZSgmcG1kZXYtPnZkZXYtPnBkZXYt
PmRldikpOwogCi0JbXV0ZXhfbG9jaygmdmRldi0+cmVmbGNrLT5sb2NrKTsKKwl2ZmlvX3BjaV9y
ZWZsY2tfbG9jayh2ZGV2KTsKIAogCWlmICghKC0tdmRldi0+cmVmY250KSkgewogCQl2ZmlvX3Nw
YXByX3BjaV9lZWhfcmVsZWFzZSh2ZGV2LT5wZGV2KTsKIAkJdmZpb19wY2lfZGlzYWJsZSh2ZGV2
KTsKIAl9CiAKLQltdXRleF91bmxvY2soJnZkZXYtPnJlZmxjay0+bG9jayk7CisJdmZpb19wY2lf
cmVmbGNrX3VubG9jayh2ZGV2KTsKIAogCW1vZHVsZV9wdXQoVEhJU19NT0RVTEUpOwogfQpAQCAt
MzQxLDcgKzM0MSw3IEBAIHN0YXRpYyB2b2lkIHZmaW9fbWRldl9wY2lfZHJpdmVyX3JlbW92ZShz
dHJ1Y3QgcGNpX2RldiAqcGRldikKIAlpZiAoIXZkZXYpCiAJCXJldHVybjsKIAotCXZmaW9fcGNp
X3JlZmxja19wdXQodmRldi0+cmVmbGNrKTsKKwl2ZmlvX3BjaV9yZWZsY2tfcHV0KHZkZXYpOwog
CiAJa2ZyZWUodmRldi0+cmVnaW9uKTsKIAltdXRleF9kZXN0cm95KCZ2ZGV2LT5pb2V2ZW50ZmRz
X2xvY2spOwo=

--MP_/uRpTlX5YVNlQmhq.F/OsyI_--


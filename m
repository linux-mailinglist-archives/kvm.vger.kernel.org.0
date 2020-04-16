Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF4F1AD2C8
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 00:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgDPWWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 18:22:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:33211 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728842AbgDPWWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 18:22:12 -0400
IronPort-SDR: MmFF4Tq8SNfxceDdd3Wz9RcZEg1lxnLP4m6MLeQsDGa1ekbKg97dvAkl8y9KrRBt0NgcEhdp5j
 KaWj5CGDomRQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 15:22:08 -0700
IronPort-SDR: LUu+P/YXcM5WENDHKF6o+pp4tD+Jid2CSFsujp8cMYNQ9xFFZEwJVrsSdcbAt+tJX7QcL0weLo
 WU/iEZhc9aAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,392,1580803200"; 
   d="scan'208";a="454501925"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga005.fm.intel.com with ESMTP; 16 Apr 2020 15:22:03 -0700
Date:   Thu, 16 Apr 2020 18:12:26 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     "Lu, Baolu" <baolu.lu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
Subject: Re: [PATCH v1 0/2] vfio/pci: expose device's PASID capability to VMs
Message-ID: <20200416221224.GA16688@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1584880394-11184-1-git-send-email-yi.l.liu@intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D801252@SHSMSX104.ccr.corp.intel.com>
 <ce615f64-a19b-a365-8f8e-ca29f69cc6c0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce615f64-a19b-a365-8f8e-ca29f69cc6c0@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 31, 2020 at 03:08:25PM +0800, Lu, Baolu wrote:
> On 2020/3/31 14:35, Tian, Kevin wrote:
> >> From: Liu, Yi L<yi.l.liu@intel.com>
> >> Sent: Sunday, March 22, 2020 8:33 PM
> >>
> >> From: Liu Yi L<yi.l.liu@intel.com>
> >>
> >> Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
> >> Intel platforms allows address space sharing between device DMA and
> >> applications. SVA can reduce programming complexity and enhance security.
> >>
> >> To enable SVA, device needs to have PASID capability, which is a key
> >> capability for SVA. This patchset exposes the device's PASID capability
> >> to guest instead of hiding it from guest.
> >>
> >> The second patch emulates PASID capability for VFs (Virtual Function) since
> >> VFs don't implement such capability per PCIe spec. This patch emulates such
> >> capability and expose to VM if the capability is enabled in PF (Physical
> >> Function).
> >>
> >> However, there is an open for PASID emulation. If PF driver disables PASID
> >> capability at runtime, then it may be an issue. e.g. PF should not disable
> >> PASID capability if there is guest using this capability on any VF related
> >> to this PF. To solve it, may need to introduce a generic communication
> >> framework between vfio-pci driver and PF drivers. Please feel free to give
> >> your suggestions on it.
> > I'm not sure how this is addressed on bate metal today, i.e. between normal
> > kernel PF and VF drivers. I look at pasid enable/disable code in intel-iommu.c.
> > There is no check on PF/VF dependency so far. The cap is toggled when
> > attaching/detaching the PF to its domain. Let's see how IOMMU guys
> > respond, and if there is a way for VF driver to block PF driver from disabling
> > the pasid cap when it's being actively used by VF driver, then we may
> > leverage the same trick in VFIO when emulation is provided to guest.
> 
> IOMMU subsystem doesn't expose any APIs for pasid enabling/disabling.
> The PCI subsystem does. It handles VF/PF like below.
> 
> /**
>   * pci_enable_pasid - Enable the PASID capability
>   * @pdev: PCI device structure
>   * @features: Features to enable
>   *
>   * Returns 0 on success, negative value on error. This function checks
>   * whether the features are actually supported by the device and returns
>   * an error if not.
>   */
> int pci_enable_pasid(struct pci_dev *pdev, int features)
> {
>          u16 control, supported;
>          int pasid = pdev->pasid_cap;
> 
>          /*
>           * VFs must not implement the PASID Capability, but if a PF
>           * supports PASID, its VFs share the PF PASID configuration.
>           */
>          if (pdev->is_virtfn) {
>                  if (pci_physfn(pdev)->pasid_enabled)
>                          return 0;
>                  return -EINVAL;
>          }
> 
> /**
>   * pci_disable_pasid - Disable the PASID capability
>   * @pdev: PCI device structure
>   */
> void pci_disable_pasid(struct pci_dev *pdev)
> {
>          u16 control = 0;
>          int pasid = pdev->pasid_cap;
> 
>          /* VFs share the PF PASID configuration */
>          if (pdev->is_virtfn)
>                  return;
> 
> 
> It doesn't block disabling PASID on PF even VFs are possibly using it.
>
hi
I'm not sure, but is it possible for pci_enable_pasid() and
pci_disable_pasid() to do the same thing as pdev->driver->sriov_configure,
e.g. pci_sriov_configure_simple() below.

It checks whether there are VFs are assigned in pci_vfs_assigned(dev).
and we can set the VF in assigned status if vfio_pci_open() is performed
on the VF.


int pci_sriov_configure_simple(struct pci_dev *dev, int nr_virtfn)
{
        int rc;

        might_sleep();

        if (!dev->is_physfn)
                return -ENODEV;

        if (pci_vfs_assigned(dev)) {
                pci_warn(dev, "Cannot modify SR-IOV while VFs are assigned\n");
                return -EPERM;
        }

        if (nr_virtfn == 0) {
                sriov_disable(dev);
                return 0;
        }

        rc = sriov_enable(dev, nr_virtfn);
        if (rc < 0)
                return rc;

        return nr_virtfn;
}

Thanks
Yan

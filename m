Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4161156D42
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 01:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgBJAn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Feb 2020 19:43:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:57022 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgBJAn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Feb 2020 19:43:57 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Feb 2020 16:43:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,423,1574150400"; 
   d="scan'208";a="280491112"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Feb 2020 16:43:54 -0800
Date:   Sun, 9 Feb 2020 19:34:36 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [RFC PATCH v2 1/9] vfio/pci: split vfio_pci_device into public
 and private parts
Message-ID: <20200210003436.GA3520@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200131020803.27519-1-yan.y.zhao@intel.com>
 <20200131020956.27604-1-yan.y.zhao@intel.com>
 <20200207124831.391d5f70@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207124831.391d5f70@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 08, 2020 at 03:48:31AM +0800, Alex Williamson wrote:
> On Thu, 30 Jan 2020 21:09:56 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > split vfio_pci_device into two parts:
> > (1) a public part,
> >     including pdev, num_region, irq_type which are accessible from
> >     outside of vfio.
> > (2) a private part,
> >     a pointer to vfio_pci_device_private, only accessible within vfio
> > 
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c         | 209 +++++++++++++++-------------
> >  drivers/vfio/pci/vfio_pci_config.c  | 157 +++++++++++----------
> >  drivers/vfio/pci/vfio_pci_igd.c     |  16 +--
> >  drivers/vfio/pci/vfio_pci_intrs.c   | 171 ++++++++++++-----------
> >  drivers/vfio/pci/vfio_pci_nvlink2.c |  16 +--
> >  drivers/vfio/pci/vfio_pci_private.h |   5 +-
> >  drivers/vfio/pci/vfio_pci_rdwr.c    |  36 ++---
> >  include/linux/vfio.h                |   7 +
> >  8 files changed, 321 insertions(+), 296 deletions(-)
> 
> I think the typical solution to something like this would be...
> 
> struct vfio_pci_device {
> 	...
> };
> 
> struct vfio_pci_device_private {
> 	struct vfio_pci_device vdev;
> 	...
> };
> 
> External code would be able to work with the vfio_pci_device and
> internal code would do a container_of() to get access to the private
> fields.  What's done here is pretty ugly and not very cache friendly.
> Thanks,
>
got it, it's much better!
will change it. Thanks!

Yan


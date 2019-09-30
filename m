Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB0AC20B6
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 14:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730846AbfI3MjL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 30 Sep 2019 08:39:11 -0400
Received: from mga06.intel.com ([134.134.136.31]:8586 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730679AbfI3MjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 08:39:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 05:39:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,567,1559545200"; 
   d="scan'208";a="342630734"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga004.jf.intel.com with ESMTP; 30 Sep 2019 05:39:08 -0700
Received: from fmsmsx118.amr.corp.intel.com (10.18.116.18) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Sep 2019 05:39:07 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx118.amr.corp.intel.com (10.18.116.18) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Sep 2019 05:39:07 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.166]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.176]) with mapi id 14.03.0439.000;
 Mon, 30 Sep 2019 20:39:05 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Xia, Chenbo" <chenbo.xia@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>
Subject: RE: [PATCH v2 08/13] vfio/pci: protect cap/ecap_perm bits
 alloc/free with atomic op
Thread-Topic: [PATCH v2 08/13] vfio/pci: protect cap/ecap_perm bits
 alloc/free with atomic op
Thread-Index: AQHVZIuSW1mIoWgNgkSfDOTBS2NuQac81ygAgAcKJ3A=
Date:   Mon, 30 Sep 2019 12:38:41 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0B55BE@SHSMSX104.ccr.corp.intel.com>
References: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
        <1567670370-4484-9-git-send-email-yi.l.liu@intel.com>
 <20190925203620.301c66ca@x1.home>
In-Reply-To: <20190925203620.301c66ca@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiY2M4Mzk5MDQtYWI5MC00MjQ3LWE1YTctOWYwN2FjYzFkM2E4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQU9BQlV2TzZXVXhFNFJqMHc1YlVmQ0NzR2VcL2wyTmp3WStLdjZZVFgrZXgrQnJ5UkE1N01pVUIzb0dtYW1Rd3UifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Thursday, September 26, 2019 10:36 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v2 08/13] vfio/pci: protect cap/ecap_perm bits alloc/free with
> atomic op
> 
> On Thu,  5 Sep 2019 15:59:25 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > There is a case in which cap_perms and ecap_perms can be reallocated
> > by different modules. e.g. the vfio-mdev-pci sample driver. To secure
> > the initialization of cap_perms and ecap_perms, this patch adds an
> > atomic variable to track the user of cap/ecap_perms bits. First caller
> > of vfio_pci_init_perm_bits() will initialize the bits. While the last
> > caller of vfio_pci_uninit_perm_bits() will free the bits.
> 
> Yes, but it still allows races; we're not really protecting the data.
> If driver A begins freeing the shared data in the uninit path, driver B could start
> allocating shared data in the init path and we're left with either use after free issues
> or memory leaks.  Probably better to hold a semaphore around the allocation/free
> and a non-atomic for reference counting.  Thanks,

That's true. We just want to have only one copy of the bits. As long as the
race is under control, it is acceptable. Let me make this change. Thanks.

> Alex
> 
Regards,
Yi Liu

> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_config.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_config.c
> > b/drivers/vfio/pci/vfio_pci_config.c
> > index f0891bd..1b3e6e5 100644
> > --- a/drivers/vfio/pci/vfio_pci_config.c
> > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > @@ -992,11 +992,17 @@ static int __init init_pci_ext_cap_pwr_perm(struct
> perm_bits *perm)
> >  	return 0;
> >  }
> >
> > +/* Track the user number of the cap/ecap perm_bits */ atomic_t
> > +vfio_pci_perm_bits_users = ATOMIC_INIT(0);
> > +
> >  /*
> >   * Initialize the shared permission tables
> >   */
> >  void vfio_pci_uninit_perm_bits(void)
> >  {
> > +	if (atomic_dec_return(&vfio_pci_perm_bits_users))
> > +		return;
> > +
> >  	free_perm_bits(&cap_perms[PCI_CAP_ID_BASIC]);
> >
> >  	free_perm_bits(&cap_perms[PCI_CAP_ID_PM]);
> > @@ -1013,6 +1019,9 @@ int __init vfio_pci_init_perm_bits(void)  {
> >  	int ret;
> >
> > +	if (atomic_inc_return(&vfio_pci_perm_bits_users) != 1)
> > +		return 0;
> > +
> >  	/* Basic config space */
> >  	ret = init_pci_cap_basic_perm(&cap_perms[PCI_CAP_ID_BASIC]);
> >


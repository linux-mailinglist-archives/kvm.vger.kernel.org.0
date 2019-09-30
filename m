Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF56C20BE
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 14:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbfI3MlC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 30 Sep 2019 08:41:02 -0400
Received: from mga05.intel.com ([192.55.52.43]:13543 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730476AbfI3MlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 08:41:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 05:41:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,567,1559545200"; 
   d="scan'208";a="220638333"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga002.fm.intel.com with ESMTP; 30 Sep 2019 05:41:01 -0700
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Sep 2019 05:41:01 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 FMSMSX155.amr.corp.intel.com (10.18.116.71) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Sep 2019 05:41:01 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.166]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.119]) with mapi id 14.03.0439.000;
 Mon, 30 Sep 2019 20:40:59 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>
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
Subject: Re: [PATCH v2 12/13] vfio/type1: use iommu_attach_group() for
 wrapping PF/VF as mdev
Thread-Topic: [PATCH v2 12/13] vfio/type1: use iommu_attach_group() for
 wrapping PF/VF as mdev
Thread-Index: AdV3XcoHPpL9XVW+S8y7jXS50//64Q==
Date:   Mon, 30 Sep 2019 12:40:59 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0B5600@SHSMSX104.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMTJjNTE5NWQtYTM0Yy00Yjg2LWJlOGMtMjlmNmQ0NjM4YmNkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoieFhKK3BFdlwvdEtPT0FoT1U4RW1sSHNaRVprQnNMMVpQMnk3ZEZXdmhaOVcwMVwvM0lJRVwvVTIxWnFveUw2eGlFZCJ9
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
> Sent: Thursday, September 26, 2019 10:37 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v2 12/13] vfio/type1: use iommu_attach_group() for wrapping
> PF/VF as mdev
> 
> On Thu,  5 Sep 2019 15:59:29 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > This patch uses iommu_attach_group() to do group attach when it is for
> > the case of wrapping a PF/VF as a mdev. iommu_attach_device() doesn't
> > support non-singleton iommu group attach. With this change, wrapping
> > PF/VF as mdev can work on non-singleton iommu groups.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 22 ++++++++++++++++++----
> >  1 file changed, 18 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index 054391f..317430d 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -1312,13 +1312,20 @@ static int vfio_mdev_attach_domain(struct
> > device *dev, void *data)  {
> >  	struct iommu_domain *domain = data;
> >  	struct device *iommu_device;
> > +	struct iommu_group *group;
> >
> >  	iommu_device = vfio_mdev_get_iommu_device(dev);
> >  	if (iommu_device) {
> >  		if (iommu_dev_feature_enabled(iommu_device,
> IOMMU_DEV_FEAT_AUX))
> >  			return iommu_aux_attach_device(domain, iommu_device);
> > -		else
> > -			return iommu_attach_device(domain, iommu_device);
> > +		else {
> > +			group = iommu_group_get(iommu_device);
> > +			if (!group) {
> > +				WARN_ON(1);
> 
> What's the value of the WARN_ON here and below?

Let me remove it.

> iommu_group_get() increments the kobject reference, looks like it's leaked.  Thanks,

Oops, yes, should use dev->iommu_group. Let me fix it.

> 
> Alex

Thanks,
Yi Liu


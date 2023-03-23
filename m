Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B528A6C64BB
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjCWKWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjCWKV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:21:58 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614881ADC5;
        Thu, 23 Mar 2023 03:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679566913; x=1711102913;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0KSYPjaYgsq05RpDxI1HkW338rso8V/fJtCACzYZTRI=;
  b=RYwbYAmSLEnHaBLM9vpQ8xO2Q1PygPG3Bhi89mL+R9oxcI6ILaI/QSMb
   wKWVw8dflh1GBpdtxAlQFKpPuMiecss4M+V22FDupFDuuLyxTLKl4USfx
   hZ++r2WBWcv9SgE9eEBdbYaGWS45RoGGfPzwQgfGT4uN2BjhsE6eXjq0m
   iQpw5DV1GXhl15AXd50VW016zghvRxwWV7HHotdy/Nap0SRYJEj2zI7Dq
   /Ez6LFuGq0bBQ9CZK8UZ0BDgfAHxkzmOqjMU1sThU6oJ0b+dzk2+ac7WE
   tNTUJan79RhXvDInbOSdqS9tSh8KfUF8uCpty+NtZ/sjeumWdXva8fwVM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="425727198"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="425727198"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 03:21:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="659546469"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="659546469"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 23 Mar 2023 03:21:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 03:21:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 03:21:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 03:21:51 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 23 Mar 2023 03:21:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZNoZjtO2XM/cgdy1DnA4hRq3P5TFSO+hqNFZH3gEC67C27w7+uVEHAoDIq6Ir2Hr8RXuzWnD5fAIjxNyuUsvGL2e1XvKe88RseyxND+hfFj46PtkmU5oMHUMEXTXCTFJ5faPfM0ZyA1laZ1HBLk7OC9JyDVH4R2L/+STjTV8A+CWmPzvLKjCgSqw+D9hE2KkQss+rBQETE+NtBxKHzbPey1mZ34LpZGE35psJLrBoGHNCinbUvzK/AiFvKh2sc5ddtXJvONBGRF/rVK1s19e/CoNNt7gk+HGXt2RuzsHyp/LTKaQ1aF1Zs7Q5X1lAe4QiSEDxfBnBErAQf5g6q4cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=96wLyYMwc9zDlxHqN4ilS/fU0oWar4d1YWVNjz4OtKY=;
 b=meBVYCh0vT6/jk7kfpgOyZvf++fgNhZyqDu9SaWpHF72kHchKILb/oGADI2EXqT9GepcBHS0Z0CYbhfyjh+ORwcq0lvRgyEmkgYPIrm+hGyG06uXWoMQT7Y9d8nhnV+G34JYbh/zgKlhsOhCRHUnM+9nwXDd0EvqYTHIeiztbPhowcCJ4PZ0JSmJ26ZboZ5I5jsQKaccdTk75BWUtTYGI7DwahoMJUuDtG9wBsgSjR2O7OcY2C7ZTSeVuQ6QLVYjH+QxDj7F7E8dqhV1WF6gM1uKm3eCSH5WJeXL4GRBORZ2w0BbPg88nCmyxhnJKwzsQWTolg4pN6go0LSqWVGXoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6147.namprd11.prod.outlook.com (2603:10b6:208:3ed::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 10:21:49 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 10:21:48 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH 3/7] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH 3/7] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZW16W2KaKbKQCqkm3cOjep6LVWq8IKlCA
Date:   Thu, 23 Mar 2023 10:21:48 +0000
Message-ID: <DS0PR11MB7529A977D2E82247AAF53264C3879@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
 <20230316124156.12064-4-yi.l.liu@intel.com> <ZBit0rBhEtUx7y0c@nvidia.com>
In-Reply-To: <ZBit0rBhEtUx7y0c@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6147:EE_
x-ms-office365-filtering-correlation-id: 5e445d4e-87d2-4cd3-5e29-08db2b886974
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H6gT3lJA7Kcc7mIctVoZJD6XnpQRhT/Ln9AtQwUjlsiY97Foux3M1sMr5FCoLDSyse0acFTw1aB4Ci7Va68WPyAkavowNoLGFPe0wJscajsqx60XhKJ5pKs3nv26++wJKVTMDNvWnrLC0W41johkz5OgLiIU0L0GbHnHf16xihhDEZiQpCugxdqL6ZI20ZPZrGYlYp/7+4ckW6rLDOIDBU2t5HESJalLXhiHDALAs6r6gkNhb+pqbGh63d/FLP2mSiLrxyUEAT7nk19+pyhVR3BizDp4O0aop3/sRn6HhYSnbDKMkm7lKEBuobcc23KgGUd9nG5+x8k9E/dB5YISdMBBSBWJYYU5y4xMKhR6fl3dLDBZR/eYSIB/x93z5fMJWAZN/o6b2FcX8G2GlxbcGRAXbpVSXe2JSiH6EgUTpFTUC/3+zciRpKbzpHkcLEuCx3SDJRXihzHyZQ7zchse0sEpDu4IolYaPFr3bnhiqH7zax69uGpex0DIU3mGTfsqfqn/UDmCenm2u7H/XBpOHQLeWNNN6cYPi1lvaAw4uVa7m4tDvFdNWtfszXPn/mOnT1eNOpzjZUD0394O6WCPXCYZW1F36FKrsUgvCLk0vV1WmkENM7Tp1Dww2yc4A9ahCzH939jxX6YY/DovKZir9WxNs3nGYWJTKBZZqTd/fFDGVcxsnzUdflj/TNRZbC4R8qb3Ce7jwD4zFIqx1myIAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199018)(4326008)(6916009)(76116006)(66556008)(66476007)(66446008)(64756008)(8676002)(66946007)(316002)(54906003)(5660300002)(7416002)(122000001)(82960400001)(41300700001)(8936002)(52536014)(26005)(6506007)(186003)(9686003)(71200400001)(83380400001)(478600001)(33656002)(86362001)(7696005)(55016003)(38070700005)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OSMcE7WcJOfNz/VBwNFDYhu6RPXnUPsEEgBugxAo1/6bTcooOCxpY0KT0v+5?=
 =?us-ascii?Q?rKWyoD7CSD9ZTK5efxBspJmihdHYky1xzGiSCfkQYFgcgeL7j6uAVcm6Wwe7?=
 =?us-ascii?Q?RaEVvyh2xj4Oc04tMrYB9GTIlOlA2CcN7irbuU3bYc+71ZsRXwFPW7hJFHsx?=
 =?us-ascii?Q?P00iuTnhRmblif57kO1P7Voc6TIzT6MiFRuRdRVn/Wzy90eYSMJCCtIWajEm?=
 =?us-ascii?Q?PftHh1QAbyYxtNPLw9DXfILD6VRONdI5+HLQsJIXMwlafOH7MlZVO5DNOK5f?=
 =?us-ascii?Q?7mg/7gfueWie6VP4TVJmmxpaGZyxhtBQ+BVY0paG45K+r6ku3PMsArQDYpUB?=
 =?us-ascii?Q?z4MzzqAx5kCaNofPWF3/g3LpkBGG/u35HF3tEx2s9oDAWbXU445BiKHobYw5?=
 =?us-ascii?Q?seqp0ziFERFKXIr0WS6XZT5pe0ux1OW8+Y31d6kb8QhERuE4x7tvArCDi6jM?=
 =?us-ascii?Q?vjCcGyjYkZPqAmnMkJz2OpuoUj9xx1YWQek09QaIOFw+g0s87F4YIhKhnwNQ?=
 =?us-ascii?Q?I+HsHZp4iA3we5aUU87AbZT0tM8n2Z9qKaeWkaRszKrcEZwS/xrC8+INiYPy?=
 =?us-ascii?Q?mlXLtU7w9BD3wCTERBBnmDkNfduBjJcOVu57ZuO3dgsV7qHtBZ5dByO38sWU?=
 =?us-ascii?Q?eWBsx7iUt3SsWRgRhz5XnwOU7FKuHUfcHjf1udR3KOt/U+jdrMDwwQn5v/se?=
 =?us-ascii?Q?/oTada/Hn9ZknqntIja0exSfRKhm2Z38FtUyCZqSgimhUo6ztZPpTaOJvBx7?=
 =?us-ascii?Q?yI6uUQ/dTcykfoNJS+hinH0kfo9ZNB5MFRYCwKcswtD/fB4CUNnQDk2z+7z7?=
 =?us-ascii?Q?gnevctSl3wc0oQS4kfLofn7hQqDGztnSo2RnI9KBXklOKGscFdokFLnaURTU?=
 =?us-ascii?Q?/sWUoHCHEBBs5CMMA9rTpjAoBzOKjJ6+FpXBn/fy6bt3oeoRL/8Y0vItxzFG?=
 =?us-ascii?Q?75+O6bot4+XyrgYtdv2pcvwgHOCZb0ZaAYmTovXzSFlEN79ib1+dtDAySIEi?=
 =?us-ascii?Q?TkalkcKJqXtXLh/qzTsXk7YcddT34yDNzq+NoyPxWkKw5PGe20Sgz2GRsQLp?=
 =?us-ascii?Q?UfgQOFmxmtkYHI5DZmbCd+AZqpica6NzG5Z9CjJEu1ItMDipLRkhagk+1oji?=
 =?us-ascii?Q?IlsY6GQi3nnxuwtBeURKA4keFOtC4vSnpzbuHbsT3KDDwTEa9mIz884CWtw4?=
 =?us-ascii?Q?3vSLype+T6CNwgPmc3NGHSy7q7zKzg4pqw1ZxeJzyptkByXFlh/PWI0vs7cN?=
 =?us-ascii?Q?TXgOQwNGc00kmUZYuvHTqjtiudVF5S72kad/CiwwGpKL39dXyXRgsFyLT6Gn?=
 =?us-ascii?Q?ZBZZ3x0VoGJ/+FEuanVtOhmVn3aofFTlt/Vky/RGr402HyLow7nAUPqo4Dt3?=
 =?us-ascii?Q?JMV8G7fLMLsZux+WLWEwTdPBUrpMnAiKxLE4+zkNwVRUjCC6mkZ8w5MmRBKF?=
 =?us-ascii?Q?u41VeCzvv14PfFZwcm/rX4+mtwW+6EqJB9zggoJRlsGV1Z9Rc2cF7m7JrjAo?=
 =?us-ascii?Q?QSdbo6aNpX8uEnG51SY8tKL8XfsvFP8qIbuuTC1AvLh+CM/q4U5IK/t16sA1?=
 =?us-ascii?Q?x3tUi5aVxflBCV5B7bXa49cJBC+cc03ERmtfcxs/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e445d4e-87d2-4cd3-5e29-08db2b886974
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 10:21:48.7212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AqbT4x9PeHcqXOE3Kj+frdxgC9xAAn4hN2QXLv+eUst2BtyvWxQwl/30vH7cCfDcGIlybq7cFLs1utuhURtaDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6147
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, March 21, 2023 3:03 AM
> On Thu, Mar 16, 2023 at 05:41:52AM -0700, Yi Liu wrote:
> > as an alternative method for ownership check when iommufd is used. In
> > this case all opened devices in the affected dev_set are verified to
> > be bound to a same valid iommufd value to allow reset. It's simpler
> > and faster as user does not need to pass a set of fds and kernel no
> > need to search the device within the given fds.
> >
> > a device in noiommu mode doesn't have a valid iommufd, so this method
> > should not be used in a dev_set which contains multiple devices and one
> > of them is in noiommu. The only allowed noiommu scenario is that the
> > calling device is noiommu and it's in a singleton dev_set.
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/iommu/iommufd/device.c   |  6 ++
> >  drivers/vfio/iommufd.c           |  8 +++
> >  drivers/vfio/pci/vfio_pci_core.c | 94 +++++++++++++++++++++++---------
> >  include/linux/iommufd.h          |  1 +
> >  include/linux/vfio.h             |  3 +
> >  include/uapi/linux/vfio.h        |  9 ++-
> >  6 files changed, 93 insertions(+), 28 deletions(-)
>=20
> This could probably be split to two or three patches
>=20
> > -static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *v=
dev,
> > -					struct vfio_pci_hot_reset __user
> *arg)
> > +static int
> > +vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
> > +				    struct vfio_pci_hot_reset *hdr,
> > +				    bool slot,
> > +				    struct vfio_pci_hot_reset __user *arg)
> >  {
>=20
> At least this mechanical re-organization should be in its own patch

Sure.=20

> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 3188d8a374bd..f0a5ff317b20 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -116,6 +116,7 @@ struct vfio_device_ops {
> >  int vfio_iommufd_physical_bind(struct vfio_device *vdev,
> >  			       struct iommufd_ctx *ictx, u32 *out_device_id);
> >  void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
> > +struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device
> *vdev);
> >  int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32
> *pt_id);
> >  int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
> >  			       struct iommufd_ctx *ictx, u32 *out_device_id);
> > @@ -127,6 +128,8 @@ int vfio_iommufd_emulated_attach_ioas(struct
> vfio_device *vdev, u32 *pt_id);
> >  		  u32 *out_device_id)) NULL)
> >  #define vfio_iommufd_physical_unbind \
> >  	((void (*)(struct vfio_device *vdev)) NULL)
> > +#define vfio_iommufd_physical_ictx \
> > +	((struct iommufd_ctx * (*)(struct vfio_device *vdev)) NULL)
>=20
> ??
>=20
> This should just be a normal static inline?? It won't compile like
> this.

Yes. in the case of !CONFIG_IOMMUFD, just return NULL.

>=20
> It would also be a nice touch to include a new vfio_pci_hot_reset_info
> that returns the dev_id's of the other devices in the reset group
> instead of a BDF. It would be alot easier for userspace to work with.

Yeah, just as we are chatting in another thread. Btw. Do we expect the
new _INFO ioctl that return dev_ids work for the legacy group path under
compat mode? If no, then I may need to organize this series after cdev
series since dev_id is returned to user in cdev series.

Regards,
Yi Liu

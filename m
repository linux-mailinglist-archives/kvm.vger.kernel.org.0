Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DC56EA461
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 09:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjDUHMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 03:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjDUHMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 03:12:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFE45FE9;
        Fri, 21 Apr 2023 00:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682061124; x=1713597124;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RjHhErYzJ/AP7/PytsUBMH0CIs+xuhG4hlUXyiUWsT4=;
  b=UeXQ9F+9UsI+XWIj8qC8cTjqJEDW/8PWDYxTWU712WKBXzschupCxKfw
   TydmqMMbfnrS4Mey3Ha3vhaU92L/kMp2z4fS2a7euwjoAeiMaMXrtO3j4
   tKNyu34U40MHM2aqholuWkAm003mlh+ff50kSuc7rrd92u2zrwoZ+K3kX
   te5/YktCkvrhQRNOOQVnpvlA8FRiIvrhpDItcgZ1aLP7KnmVKgJ6KuoOC
   g2wL5huN1rRjFUWAfIDuZbOOgP0N1IWggPeAIOV7J8KNVWeTqC73wGc81
   vB0Qq75D8e+iSzOz+TJ0VTvK69mKJQqvSkXuE1Ds3ZMsRYP+b5WemF/ni
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="373856785"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="373856785"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:12:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="1021829456"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="1021829456"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 21 Apr 2023 00:12:03 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 00:12:03 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 00:12:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 00:12:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 00:12:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpIBJ8+yUwJZtWyGz9DxC4xncOpCtU6iiOKzIamzeHTTVkrfjVZF4ij9yiQF1cIb7eNs/ZcF+St/+0mLfkD9rUIY4ZVrliSyxVsKcfiblL1jCBhEZ5TUs+Zmn3ynG8jrSqDvCMJKX9ZE7IjD9qTadcNwBa0ihQm9qtllLiQ9XOXCo5MDuxRJUByWVoJo274GWNV7LP0YjJQXKEGfcJ5j6NuebBNooWpd6MaAJts5VAIo3J0mFreiRkxmizqBtNDdcQY+AJxYW/UecmGcdsYHoE6V5PV44FT+aMFWxT/xm7ySTWACbXpo+ezTAqRIqmgFsK58EBuOGjZ2xQXSxZNmSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YldM7vCmNEzkKWiXYVWvzlzCw3mtxl/Jj++xAbzTCb4=;
 b=mO7QpIpeU5W+YPIOiuVv/jLE6LmQtnIUdvuDYieLwklQXe2PbTb5jz3OLATzHKR4Ui81cReu+jZOi2ISsgmYPvFNUGTauhlNm7xMwAyIu8t+YRChdW1Rt5f99kmI3seZ93NzfORJflUP7KF5968itbXam4TS2/CCBL4q2qiZ+kVQ52M5/Cuhcp9CcQKi7CLTlCa8J3LR7ZwO/3JYt4O5yJFx2ioNXepeBAA2vVUWt3908aPVqty5QAjqwEcQsuj8f+mtrLVij6cHhS5BsMGGbu4x9hjI0zolRpaC27P6L2riIysnLYaydObZt4aqgP9JvB1NuXPUeP+CIy49yGDIOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB6933.namprd11.prod.outlook.com (2603:10b6:303:22a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Fri, 21 Apr
 2023 07:11:59 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%5]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 07:11:59 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 04/12] vfio-iommufd: Add helper to retrieve iommufd_ctx
 and devid for vfio_device
Thread-Topic: [PATCH v3 04/12] vfio-iommufd: Add helper to retrieve
 iommufd_ctx and devid for vfio_device
Thread-Index: AQHZZKh7XW5rfiEnjEGb8E4kRoS67K8bSvIAgABqPQCAGcFl4A==
Date:   Fri, 21 Apr 2023 07:11:58 +0000
Message-ID: <DS0PR11MB7529C42C7AC41B8EEAFB87E9C3609@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-5-yi.l.liu@intel.com>
        <702c2883-1d51-b609-1e99-337295e6e307@redhat.com>
 <20230404154854.4d9a95f0.alex.williamson@redhat.com>
In-Reply-To: <20230404154854.4d9a95f0.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW4PR11MB6933:EE_
x-ms-office365-filtering-correlation-id: a3c26389-b52b-42cb-6751-08db4237b282
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: csJEMvXq/IfJj6yMqMJsnj7ARn6jC+X3qqZDK30fcAHsYspx3TLjYmgAQtuwCLLVooDgFo72gtR4NJxRZ5095vvi10pdf+STWp4147DpQAUA3UEoVlJL7L6/Wo7lEaDkOtUxLiuNhAMIfgyQ3XqbgM15x6QELprtXi5u5hqCfFik0lARGyH/zA8pHwBVM1v32LXs7AXePcl96HieMmFzKMladeZEpvbp9iVPG2PvpcFQWxgRiVk41tyw8isxQX/BlwLxXlaiUwXmWfT2iwyKU9UBxBUHzauCGFiI2BkiY6pNeH8MaDHFto1/gsrVPcmECbc8TheRNCyKamIXjZjj0nNy2dr8C35ejO6BzwO8b9xDgGH7qDJhcmH7xVNhoreyhB7U3JsYiLJS+8LUwLDVHDdweGzNj0elB/erH/vRLs4QS57Vyk4bYr5dTRXwZStW08VKnY63Pfajvbl4N4vFfiqI5PbD+rq6FjlSdEGh0wG3FBddEtH81lRA84f8TRqePtoPNd/lBQIGY5TliL3IuTlREgPrg3eLD9Dq1+tm8P8t7bsBIQnd0Zf5lGNgW89FZsfOz9KBvoQqUBX2WlXqSuJFMOYAdA0ywHlkwC8D4rt2b7sPf5twwij9gajjFep6JlrrMMC0PtbcINngi/qqVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(346002)(366004)(136003)(451199021)(66476007)(478600001)(71200400001)(8936002)(8676002)(316002)(66446008)(82960400001)(41300700001)(55016003)(4326008)(66946007)(66556008)(76116006)(54906003)(122000001)(110136005)(38100700002)(186003)(53546011)(2906002)(38070700005)(26005)(64756008)(83380400001)(6506007)(9686003)(33656002)(5660300002)(86362001)(52536014)(7696005)(7416002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a9A+wdd52/CdySFpsQnlH0IQNtetV3Td4qmOSaYOa4LiV/nm7OVF5i9y4Hx2?=
 =?us-ascii?Q?A1BIL5e7rT4vgw+5De4uSoAnw83MSdfs2RoNO7zPF7sNJfSEAWs4Kdoe3D8Z?=
 =?us-ascii?Q?sDiIUbtDGVSRN+GEkX0aqtkSqb4GOH6egKwbcXWVcy+7tec1jLZaoyzovZQy?=
 =?us-ascii?Q?OaeN0fbIUkG+1Pp3jeM4AydFbl9H2fed0ITWe0b5vvyPy4RtFERi490L1Qmq?=
 =?us-ascii?Q?7urcE8xCE11AAt2xqYqqgyC83pELJZ+01SVn2/NAMTj/EJs5vbRdOm/fo+cK?=
 =?us-ascii?Q?n4+rib2Q7Yv9xSaJoxjUpGR+nPZpFEzhgLRS2MyjTijaQ4YuzxtqO3WcJpjr?=
 =?us-ascii?Q?G3nUegop9UVFEtQeehq4XWjYv9uIFVAeQXtQqw0835lWoH5kzEnQX92JHXp5?=
 =?us-ascii?Q?tTBdRkwhXeKXa4o4LynWuMwClHCDGx0aAFybMrIa/NHV7/5H9f5g/KKOeLHk?=
 =?us-ascii?Q?gX4T+zvxeW33yps8nR7z2RF5ovlQ4r4Uj/qkksJ6ZIs4oicCL76g7A/SnxiW?=
 =?us-ascii?Q?uyda101NZj5zIyiaYYrZ6KeBUXSuHpdbZiEBSvEvubPc7zMmRM1NKQDgmFWG?=
 =?us-ascii?Q?aWbWu+43c0PFuMrJAJtgqP+gRYqvXRXoKO6wAGxzbJlsekXQhBlgVLU+Y/3e?=
 =?us-ascii?Q?5vnWHavLblgnka893CVbY18YcSF3iU9F+IRQdkDAb6G1E8tyvBySvf//iFLa?=
 =?us-ascii?Q?tG5OGQ5KGAb479oUtWxJhlIGeClmjyuj0YsMAp3no/pzh6dAxDyF5NoMEEy4?=
 =?us-ascii?Q?esfN4HRDLKw5Jo+DGqVT/7PTpFO1TrQCPIapmvWP0ANzVr9Ezqr9n9f1Ba7B?=
 =?us-ascii?Q?T7CxdnYND1bjK3rZykKitpTweLHcrAmQjSpsx9tciOT05F5V0OTryuMQ7V6u?=
 =?us-ascii?Q?X8krnJmR9WYly6kHzNUtx8Mgo2kfPSKxyjH1+LYK4KTbDW4PwkV/9uPIHGjg?=
 =?us-ascii?Q?49G8BfIxCpcF4wFBizsLHvQMm+CoLFVWda++9/L9SM2mZzYvL98ig/w74EOV?=
 =?us-ascii?Q?SZeaq+7a1kE+iIS1Effy+PyMid7/kP1o79CCoMSZ5fXL0b/ElRltbtHuQhYc?=
 =?us-ascii?Q?GCoTJIs7HUAgUYrcBVQLOYNbtZiMTNVgG9imKKnxa68saAVmRk8tBH8cfWKu?=
 =?us-ascii?Q?b8kC19t103CGGT5ZL0HA20jPWVAorEcBCavEdu+axAFYgzaHG1ibRRPaOg60?=
 =?us-ascii?Q?A25/aDyhUbUtsew4x1hTQaU0hIJT5Q0F93EmbGJxVNcfTZ5aQGkOH4dD/L/5?=
 =?us-ascii?Q?oqg1eIcUM42pO2VuPnVZlpyS1+xJX+OUBSV/gYDmAojRaZOQzqxFdmeyUFBq?=
 =?us-ascii?Q?PcKI/sdNoRlyrjDe9qSUVioTVJ4dZ9rZJFDlX2+sPzSoa9C5+Jtcg96OH2jj?=
 =?us-ascii?Q?NLu3JUGDaL4XoQ+4ys1w55czcwhQKiyEigsCyQA7QNTdXR/gIXT1Jf0FGPoo?=
 =?us-ascii?Q?O1mJo7IICykQ3NREsYYnQs7+0pqSqNyRoDolJMvP7mcwaytvhB7CbJZ8YT9l?=
 =?us-ascii?Q?0/95nlqAHgLDDJrzYfpXi0lc4zXwBItYpr9NJg0/Mi8HR1Yq0Zymemc7CZzc?=
 =?us-ascii?Q?KYqlX8raFg4fuIb5Zk4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3c26389-b52b-42cb-6751-08db4237b282
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 07:11:58.8138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xes9HI8xFodVR7uYb7GvEQXtwgsihQ39QwTLQ78S2FijseoOR5OQ5yPuo4y5gAFPv+fUdw7vVEj3251fK8Lgdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6933
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, April 5, 2023 5:49 AM
> On Tue, 4 Apr 2023 17:28:40 +0200
> Eric Auger <eric.auger@redhat.com> wrote:
>=20
> > Hi,
> >
> > On 4/1/23 16:44, Yi Liu wrote:
> > > This is needed by the vfio-pci driver to report affected devices in t=
he
> > > hot reset for a given device.
> > >
> > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/iommu/iommufd/device.c | 12 ++++++++++++
> > >  drivers/vfio/iommufd.c         | 14 ++++++++++++++
> > >  include/linux/iommufd.h        |  3 +++
> > >  include/linux/vfio.h           | 13 +++++++++++++
> > >  4 files changed, 42 insertions(+)
> > >
> > > diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/d=
evice.c
> > > index 25115d401d8f..04a57aa1ae2c 100644
> > > --- a/drivers/iommu/iommufd/device.c
> > > +++ b/drivers/iommu/iommufd/device.c
> > > @@ -131,6 +131,18 @@ void iommufd_device_unbind(struct iommufd_device
> *idev)
> > >  }
> > >  EXPORT_SYMBOL_NS_GPL(iommufd_device_unbind, IOMMUFD);
> > >
> > > +struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *id=
ev)
> > > +{
> > > +	return idev->ictx;
> > > +}
> > > +EXPORT_SYMBOL_NS_GPL(iommufd_device_to_ictx, IOMMUFD);
> > > +
> > > +u32 iommufd_device_to_id(struct iommufd_device *idev)
> > > +{
> > > +	return idev->obj.id;
> > > +}
> > > +EXPORT_SYMBOL_NS_GPL(iommufd_device_to_id, IOMMUFD);
> > > +
> > >  static int iommufd_device_setup_msi(struct iommufd_device *idev,
> > >  				    struct iommufd_hw_pagetable *hwpt,
> > >  				    phys_addr_t sw_msi_start)
> > > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > > index 88b00c501015..809f2dd73b9e 100644
> > > --- a/drivers/vfio/iommufd.c
> > > +++ b/drivers/vfio/iommufd.c
> > > @@ -66,6 +66,20 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
> > >  		vdev->ops->unbind_iommufd(vdev);
> > >  }
> > >
> > > +struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *v=
dev)
> > > +{
> > > +	if (!vdev->iommufd_device)
> > > +		return NULL;
> > > +	return iommufd_device_to_ictx(vdev->iommufd_device);
> > > +}
> > > +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_ictx);
> > > +
> > > +void vfio_iommufd_physical_devid(struct vfio_device *vdev, u32 *id)
> > > +{
> > > +	if (vdev->iommufd_device)
> > > +		*id =3D iommufd_device_to_id(vdev->iommufd_device);
> > since there is no return value, may be worth to add at least a WARN_ON
> > in case of !vdev->iommufd_device

This may be a user-triggerable warning if the input device is not bound
to iommufd.

> Yeah, this is bizarre and makes the one caller of this interface very
> awkward.  We later go on to define IOMMUFD_INVALID_ID, so this should
> simply return that in the case of no iommufd_device and skip this
> unnecessary pointer passing.  Thanks,

Ok. then it can return invalid id when !CONFIG_IOMMUFD. Also
Needs to wait for the decision in the thread that is talking errr-code.

Regards,
Yi Liu

> Alex
>=20
> > > +}
> > > +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_devid);
> > >  /*
> > >   * The physical standard ops mean that the iommufd_device is bound t=
o the
> > >   * physical device vdev->dev that was provided to vfio_init_group_de=
v(). Drivers
> > > diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> > > index 1129a36a74c4..ac96df406833 100644
> > > --- a/include/linux/iommufd.h
> > > +++ b/include/linux/iommufd.h
> > > @@ -24,6 +24,9 @@ void iommufd_device_unbind(struct iommufd_device *i=
dev);
> > >  int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id);
> > >  void iommufd_device_detach(struct iommufd_device *idev);
> > >
> > > +struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *id=
ev);
> > > +u32 iommufd_device_to_id(struct iommufd_device *idev);
> > > +
> > >  struct iommufd_access_ops {
> > >  	u8 needs_pin_pages : 1;
> > >  	void (*unmap)(void *data, unsigned long iova, unsigned long length)=
;
> > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > index 3188d8a374bd..97a1174b922f 100644
> > > --- a/include/linux/vfio.h
> > > +++ b/include/linux/vfio.h
> > > @@ -113,6 +113,8 @@ struct vfio_device_ops {
> > >  };
> > >
> > >  #if IS_ENABLED(CONFIG_IOMMUFD)
> > > +struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *v=
dev);
> > > +void vfio_iommufd_physical_devid(struct vfio_device *vdev, u32 *id);
> > >  int vfio_iommufd_physical_bind(struct vfio_device *vdev,
> > >  			       struct iommufd_ctx *ictx, u32 *out_device_id);
> > >  void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
> > > @@ -122,6 +124,17 @@ int vfio_iommufd_emulated_bind(struct vfio_devic=
e
> *vdev,
> > >  void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
> > >  int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 =
*pt_id);
> > >  #else
> > > +static inline struct iommufd_ctx *
> > > +vfio_iommufd_physical_ictx(struct vfio_device *vdev)
> > > +{
> > > +	return NULL;
> > > +}
> > > +
> > > +static inline void
> > > +vfio_iommufd_physical_devid(struct vfio_device *vdev, u32 *id)
> > > +{
> > > +}
> > > +
> > >  #define vfio_iommufd_physical_bind                                  =
    \
> > >  	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
> > >  		  u32 *out_device_id)) NULL)
> > besides
> >
> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> >
> > Eric
> >


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CA070829E
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 15:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjERN0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 09:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbjERN0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 09:26:07 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EBFE1;
        Thu, 18 May 2023 06:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684416363; x=1715952363;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6lwikTWca6D3JT/4TuCSSPIc2vv6SWBowQOOAGgPCcg=;
  b=JgYiVkERIySMr7E9CARWvxAxzshPCex6Uncy3loghLIxnx3oNn8/zX2C
   3/hJueRM9vzN9fJmp9gZZlI/dvQ303Exhb5JpswEnlQg7fU1nltvCO/6n
   /4S4ryfPAnXA415G7yIRnRjnH9syvOXS/Ot8ke9JwkhGY4M5bgzlhs0Xj
   t8/wAuDwMckTXypPksu+Wujr3GHq6AbmLqfPBfDxInWsVHHWNtwthgxZz
   ycuHYojAVhswuCMsEttcWwPOmP2BuybAf1zj2E2TPVv5XnZbQS5py5fmw
   Z1cGOuqFRFY+M6EJyMtQOq34XtBQsLDayurkvhZUrN/XQxUxlUT4502VP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="380270181"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="380270181"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 06:26:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="679672888"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="679672888"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 18 May 2023 06:26:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 06:26:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 06:26:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 06:26:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 06:26:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqdJa42D8oWKJcrdqRXz9KGnf7YcOo42QEwmYI8btoHyg8HDIdwcvF59xTpIpOLRHN+7200qACWooWFNyfN3vs6jE6Jg4qEeIcEXsuKGuCN/8Ah9kuGsx1Z4fAJe1Kfij66G0ab8fzoQai7+e6EbJrqHSBlwKq0Qsfz0ZVW5XDs0Cm59IfPVHpoxGMhoo8Bq/obsI33HfjwfwmV1sALZvKjt9dfS97dZ66LIjuxg13sEesl2xqeUjja/bwyqlGhyUg+Bse0mxLNIg7ZFMR4LB2SEO9ZYca/CP4d5hOSvunHOIaA4iNGS9y1MjkW3zhEhwNbJB3wq8bPYArsx7gP7rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NAl+jynXPJc9/hRfMPSU1Caona29ulOaRO/GSv5FvCA=;
 b=I7HbHl1WID0HjODc6m+Dw9LlFFnfsGRuTjNwAWZl4ZTShn7RmGVm0frtluc6YQwyx7Le7ffcmYSDc3/kgKkFZOkioYWOrfArGW35Iduqh3hIIGhKRhdfe7GUCdKRsLrZV1OB5R04daBuqx3zNth/ln0+gAIBW0eP1ICh9ZqcY99IPLZq8At8gNJnMeQzYVso3U6IpKu6eSodnSGGFbjyP73GzH8oT40KVw989T6iAFf3aBa8wm/N/2h1Efl1/pWo9UafIOwSz0qdQUjqDUB567g2bMPKipDUNMNVbRCyUYCvF4yVZpNjQloZMNdX5+V18a1tfiwUp5sD0R3o9zDoMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7623.namprd11.prod.outlook.com (2603:10b6:8:142::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Thu, 18 May
 2023 13:25:59 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.017; Thu, 18 May 2023
 13:25:59 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v5 06/10] vfio-iommufd: Add helper to retrieve iommufd_ctx
 and devid for vfio_device
Thread-Topic: [PATCH v5 06/10] vfio-iommufd: Add helper to retrieve
 iommufd_ctx and devid for vfio_device
Thread-Index: AQHZhZ3imW5iE0+xik+NjE75YmRXi69ey9SAgAFBH2A=
Date:   Thu, 18 May 2023 13:25:59 +0000
Message-ID: <DS0PR11MB752963E14A652AEE1A1C2699C37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
        <20230513132136.15021-7-yi.l.liu@intel.com>
 <20230517121517.4b7ceb52.alex.williamson@redhat.com>
In-Reply-To: <20230517121517.4b7ceb52.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB7623:EE_
x-ms-office365-filtering-correlation-id: 965aff9f-edad-4749-4433-08db57a36b2e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PD1kuLjTc3sNvL4dIJbbbtuD/CrzJfKjIRTP+99mNL5YEsp51Y8pArq/lGeDGryBFX1JonI1bPBlzX2y8PkbJWFx1dogUky4i+g8yu6a+t2PiMbiRlBwCLNUR4WQhBok7H4cOlDUoIzJ0M6oWLZLtSnYN3MXBweRqqYKrRnGpRH9vt8qZQ3sDvQ4bzy4wWs+Cn0EjzYpq3RDfd9WcYPLVHXeaGB8H883RSrSPe8b2mQjkTs3LIh2IciGon8gbMRRLCnr1zp6HiGd6U2XNCCbCsAlJVHRGWr6LlzFLUTGyLk0mbT+Rvqm9MUqWDqfSHLNovFrrRRDS7pKGagg2RAqgChS3VmDjVVlfgrrvN038iSZXnExTmyxq01ms2GsHmwpC9aE/L284KSsSlyI70RswT0oTMueW/XJN9cUfbDxjAQu9FpKuh4a/G7kTW+g2gdOTbOfgZ12CT75cXHzecZIjoksu6C+yBqJ2Yb/yYqGKCaf38rA9fWEGDqEKL1/n6ES3wRTd5IlRDzRuJa1DtWXMFMYhKrWfUci+hO+QeIg+N9iSJMRwzYkOu9z9rAfPIRblVDhwtYz/rWFZB+He2oxljMKXRGs30s6h8xKMfiwTsm2JbnmkJRVx5f2RFatFjJq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199021)(9686003)(6506007)(26005)(186003)(7416002)(66476007)(83380400001)(5660300002)(64756008)(66446008)(66556008)(52536014)(316002)(66946007)(76116006)(41300700001)(4326008)(8936002)(8676002)(6916009)(7696005)(71200400001)(54906003)(2906002)(55016003)(33656002)(86362001)(478600001)(38070700005)(82960400001)(122000001)(38100700002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nMlqVL/1DyVvIYMVre4cw6Nz5byY8VcwndBaLBeDq4wjuNJOJliiK7Z/YCpQ?=
 =?us-ascii?Q?Y98i28EueLyQZE+6XupGlo9WXpBaTNtktsZd/6MrDAlL2m+5iDn3mREr8Ym3?=
 =?us-ascii?Q?DCB7vA4tc5zqtHMAUXRejfU4t913gTwe2xZfcdmZFjXNpTjgqCXaYzq/LC+L?=
 =?us-ascii?Q?QFL3FgmXUQddknXa/g3WpLgotgkanpsu3e9PmvZclaML+GtyIg0kWEtcRbBU?=
 =?us-ascii?Q?JZpKZZbRRqB8XOgBVg02LuICOG6mBLpHHcWDpazqE3wFKGMNDkcO6IjLDH26?=
 =?us-ascii?Q?58y/YdVl/B2gLqIgOeRHkFoZrm+jnqJfe7rCYCu+i6q1/TZFpCgU26lhRVZz?=
 =?us-ascii?Q?EsCUZKp+ZFM8D9TRefxQFoYQznEifF6lJQcWmKIFmg0JU8QMypsB4gHU3Chi?=
 =?us-ascii?Q?Cj+IlbpLQWyPJdhrgLO2SZd0W6keCtBL48SK5UWGXwy8vbSedCcsYkzWBNYS?=
 =?us-ascii?Q?aLK082JSUP/7Dle0/UN27KNatf3T9GtvdguKdtdp6lFAIUUrAY9S+ki8Lh0Z?=
 =?us-ascii?Q?8RD3exInYfaoY6kRPoNplB03hpIeuH5T4kTZeiXAv/1K1Yw20e3RePaHTZ8o?=
 =?us-ascii?Q?XHLg/No5fnbpponeITfLrm74+JL6Tnl/EToNhFNqm1KwcAINY5A8swatmmV+?=
 =?us-ascii?Q?l2d3WC8dRCWjj3nINvov3A2aF/p8/7uf8zyiE+FZQo2YwMgu/+h29zbbNhTY?=
 =?us-ascii?Q?oB3fGGVa2tZN9oC4fMxglWkTTzTWPuwNGfRh//KB35/rq/2yWnLzVWRh0vcy?=
 =?us-ascii?Q?ekoyxfi8Y7LjsXviFDr/Eu3K/o5biCr+tnWWXz7NXUkM+GRs3r6mleY/i2iV?=
 =?us-ascii?Q?jNLPtzCloYRVSriKGsVbjTkqj0NAARGKX4SWjfTRPYR4VuXe3ms9riFykS2y?=
 =?us-ascii?Q?QUbdNf9iJvJF0DywXk3e1cTYdRaQNBJu9P/IoDSOVsynvIJMODvK9ATtMTKB?=
 =?us-ascii?Q?5DMQTsJ5oV6aezJB6HdGjp0vmSph3jpyPMq3WAGi3xPty1/CP27Lag+9QaoJ?=
 =?us-ascii?Q?+vViqeQd47Vllkflnajvafjus1f0uC323GArenfm8N6OzIjbreFXteFxQDQZ?=
 =?us-ascii?Q?HfMZ4ASDX2+NI7x0BXsKXpSJb+iOwEA/ikzOe5m9U7SFvbjAK5HLmN3GzkXE?=
 =?us-ascii?Q?OVjsIc3FYVyyQAcFirjA1B5F9mcnRZ+52J5FZsXtc8J2lKZlmlqhrxVVp/31?=
 =?us-ascii?Q?z5DCHV9h/cqRaACgfPs72n/GBlshDJW7uTancPRrJx2ZhxPWZ/pdwD9r7d5+?=
 =?us-ascii?Q?VsIgti3eYJwBt4grQq4rd7dAdrK7kBymDOd6B7jXRxMS4kO+Gc5vML9yAYv8?=
 =?us-ascii?Q?wo3Sz1q4k8Imbe+faMiKjAqsiM23yrWKSCpqEkKOa8ijadv8NuNcEgwRC9Pl?=
 =?us-ascii?Q?DTSdVzF/LXmENEUy96SkLLkhNGqHQnuitCui3ExfPMGGblTaBzjLe8C8OLE0?=
 =?us-ascii?Q?AphUADA2NcxzAotoVrPq3ehlFrTTIoIql5KSYcWTbADrPvQsEFQBfWyUCBcA?=
 =?us-ascii?Q?V2s0bbCYLoHDBP8QKCeTuql9fFkhbqlDjrXITdz4Oen2f4U1R1npu2YDx7IX?=
 =?us-ascii?Q?Rf9UCVPSHNX5ePEDK1SXEgVv4YKnUecL9Wq/FNpJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 965aff9f-edad-4749-4433-08db57a36b2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 13:25:59.1961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +zrlDxGY1Xfcvo3enH+c/A0+Xe+GXrTKl0t1cEahXxlV2lRpdK4dVb6JKP4l8tD2SK597h7Ym2rGl7tmiry57w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7623
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, May 18, 2023 2:15 AM
>=20
> On Sat, 13 May 2023 06:21:32 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > This is needed by the vfio-pci driver to report affected devices in the
> > hot reset for a given device.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/iommu/iommufd/device.c | 24 ++++++++++++++++++++++++
> >  drivers/vfio/iommufd.c         | 20 ++++++++++++++++++++
> >  include/linux/iommufd.h        |  6 ++++++
> >  include/linux/vfio.h           | 14 ++++++++++++++
> >  4 files changed, 64 insertions(+)
> >
> > diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/dev=
ice.c
> > index 4f9b2142274c..81466b97023f 100644
> > --- a/drivers/iommu/iommufd/device.c
> > +++ b/drivers/iommu/iommufd/device.c
> > @@ -116,6 +116,18 @@ void iommufd_device_unbind(struct iommufd_device *=
idev)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(iommufd_device_unbind, IOMMUFD);
> >
> > +struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev=
)
> > +{
> > +	return idev->ictx;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(iommufd_device_to_ictx, IOMMUFD);
> > +
> > +u32 iommufd_device_to_id(struct iommufd_device *idev)
> > +{
> > +	return idev->obj.id;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(iommufd_device_to_id, IOMMUFD);
> > +
> >  static int iommufd_device_setup_msi(struct iommufd_device *idev,
> >  				    struct iommufd_hw_pagetable *hwpt,
> >  				    phys_addr_t sw_msi_start)
> > @@ -463,6 +475,18 @@ void iommufd_access_destroy(struct iommufd_access
> *access)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(iommufd_access_destroy, IOMMUFD);
> >
> > +struct iommufd_ctx *iommufd_access_to_ictx(struct iommufd_access *acce=
ss)
> > +{
> > +	return access->ictx;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(iommufd_access_to_ictx, IOMMUFD);
> > +
> > +u32 iommufd_access_to_id(struct iommufd_access *access)
> > +{
> > +	return access->obj.id;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(iommufd_access_to_id, IOMMUFD);
> > +
> >  int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id)
> >  {
> >  	struct iommufd_ioas *new_ioas;
> > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > index c1379e826052..a18e920be164 100644
> > --- a/drivers/vfio/iommufd.c
> > +++ b/drivers/vfio/iommufd.c
> > @@ -105,6 +105,26 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
> >  		vdev->ops->unbind_iommufd(vdev);
> >  }
> >
> > +struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vde=
v)
> > +{
> > +	if (vdev->iommufd_device)
> > +		return iommufd_device_to_ictx(vdev->iommufd_device);
> > +	if (vdev->noiommu_access)
> > +		return iommufd_access_to_ictx(vdev->noiommu_access);
> > +	return NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_ictx);
> > +
> > +int vfio_iommufd_physical_devid(struct vfio_device *vdev)
> > +{
> > +	if (vdev->iommufd_device)
> > +		return iommufd_device_to_id(vdev->iommufd_device);
> > +	if (vdev->noiommu_access)
> > +		return iommufd_access_to_id(vdev->noiommu_access);
> > +	return -EINVAL;
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_devid);
>=20
> I think these exemplify that it would be better if both emulated and
> noiommu use the same iommufd_access pointer.  Thanks,

Sure. Then I shall rename this helper. vfio_iommufd_device_devid()
What about your opinion?

Regards,
Yi Liu

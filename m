Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485256F0125
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 08:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242984AbjD0G7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 02:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242974AbjD0G72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 02:59:28 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD64469F;
        Wed, 26 Apr 2023 23:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682578767; x=1714114767;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YdnOSkbRR+BvXJefn7o5pIpXGEBCI8Hzx3c8PwcCnCw=;
  b=bUjFjS1BooCFucJUmWmNxrYKGhocGFXCLDvzIex6NnWL/YtuAAaOiydl
   6eq7rwIRdCoPMkPHxu10G1Qc8Z5Jn73dvXujAdx7AQ4Kk20zzdYPehcjP
   fwf0oUkOMrjgjVfRvzShWalkVihuIi2e9Klgwd5UPy/Rj8Zh1XDXR3aPg
   2rkiXbsCN+38y4RS38wAxPsbIVQxv3YeY1f/0VeL+kW/nwDFHB7erqGUp
   O5/nxJm9DmiegtziGD3l/1IN2e95ncO5N42383D4OKQD0aMvQa8uPiO55
   LIvmnkOjS6M6iB7V/zoKcG0EBeyd8OVgx68ckNDw+Wz1ASJPVt8F9AyOC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="412681960"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="412681960"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 23:59:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="724764237"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="724764237"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 26 Apr 2023 23:59:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 23:59:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 23:59:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 23:59:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 23:59:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahgP0lvopZl8mzr9WjolI+5vQzOd0lZQCydSD0OnU8CFgaub1djcGDLfWUT2xvWIyXqUvXwxrL2LFfH5Cq9eJbLLLMP/jIbellgMf83DonlmjVAXxfPPpBdQg17aT5GqT4bWcpQa7aNH/wojJbzppOE7sKmHDz5AdWFBQSltMvQSPHM4nvCyEVLiEfBO0QihkCfmv0Ugo4asb+4+bsmwMf/84rSMOadbYhOROgQmTp7fSrWczPFP4qlVOwwAQZA4vqX1yKvWV3Lbf33KhxmV0FGKzTQZQiDbGIKRWrO2aXYjhiY2ZE4JuUILU8N2U/NcevXsoMTGZYGsebSXnPuT5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvJSOcKyZvMnBcfkAIfTD2EcBV7JxR523n0CZVQu+Ec=;
 b=amheYk3Abx/ZHjfSgivfoexY/pJn6+Ad8SpUI5JgcKPWNVw9e/mCgyV/a5zeNf9WitbMontQf2Kc44sElDlXR81d0NkwPm3rTtnLOYAp/2SRSI/g9SGmjPb3snNIWRC7uW2ceIn7d/RoC8bKnW2yEQQ7El72lfIhYFklu2aWOUP0I8hF6tIA8HkNRgX8pQ7aM3MAsSS6uONzO5seDmS45QCE+fCfCoG+LIErXsAin0jVuB9JBSBkX+g8l4nP+L41b7YcLSAsYaJh71oveXiEf7CIkXX79QLQqYnLkdp9Sp3MILMKhXymcbmRYG1Qyz+SG6ifd4OQ4XuSDjDOKJ99Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB6657.namprd11.prod.outlook.com (2603:10b6:510:1c0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Thu, 27 Apr
 2023 06:59:18 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6340.021; Thu, 27 Apr 2023
 06:59:18 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Thread-Topic: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Thread-Index: AQHZeE8IlpbqU+0d80ea2xcAM3D0DK8+tVeAgAAAlEA=
Date:   Thu, 27 Apr 2023 06:59:17 +0000
Message-ID: <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-3-yi.l.liu@intel.com>
 <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH8PR11MB6657:EE_
x-ms-office365-filtering-correlation-id: 5c8be28e-9109-4684-f331-08db46eceb26
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OTrlOWcYteU/BYPFD6z8yMu9bqDODj+OViapNvWw46kqimHE6a7EUB3UXp6PawAVyJ5rDRrFn3hqY74G76ad5GdWpcv9eGtL17si4OUCK7Quj8fRk4yJGNYidkp0oGwx5JZ+lp83JdfY5+oJeuqqGVMUyBuoe3I9HJqQXvTlKXlGI8VIRrv8X63l3xstUEPAelleUTOpRRYo9OU+J2FQ6g9tIc37NW601VbpnwdogiDcpbya0zMtc4d+odLSNAfo5g/QYRyCzHVTuQ9WMKp4jiEs4bRRgP7Sc//0JkRvvt4Zw8Sy5DXXGiDIdSbrD/ifMUAZUHxM0Bhli9LJpibvxB5unnjgPxh2WCaesaWUoriJO1Ur7XHc235BCyUIk6YNB3NAmQoGOiV98PwclYsdrP47nTMWoDgIfXvdzeJynRPseXU0Xyghf898paNeIcUwWyzb6Cd6q24mH6UN0IitYeT1DjjwG08HXZL30PwFfm82QsL0awBys5HP76V2BEfswqbnZKcR7DC3ShzhLVOaEe3DRxnl3vWIMpI7cj46K81HtEJ+3f8TU4hVGC1WjpOuIDYqekdoAqvxK3Pdsa4GDKTDlubyqydF7T/gl28QHudyfaMZouFYI1KGBkfwd+ts
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(136003)(396003)(39860400002)(451199021)(52536014)(86362001)(7416002)(8676002)(8936002)(38070700005)(76116006)(2906002)(64756008)(66446008)(66476007)(66946007)(316002)(4326008)(66556008)(5660300002)(82960400001)(41300700001)(38100700002)(478600001)(110136005)(54906003)(122000001)(7696005)(83380400001)(55016003)(9686003)(26005)(6506007)(186003)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QgO4LXBZj1wkPGtOLdDJU8qA619qUteN9DIFMy8+Zzd3hBeaauvIO6VK1dua?=
 =?us-ascii?Q?HRsX8ESWNvaWOkBkRbpuBMx3e1QBaJTIebB1f2P4aQWajvYttAycwtWH86JI?=
 =?us-ascii?Q?7rxp7F1xDCZYwP0YOsymCZed6nG9tUr+4g3RUMW5LugMv0Gljy797/BoTey+?=
 =?us-ascii?Q?Va1qwUdFRLJShTWJIOZ1GZwo8iSHLVEytINVH21a+H6ffp0mCMnSOeqNPt7K?=
 =?us-ascii?Q?IYc7tFd6R0u2neYBdofH4TdbtTZsw/JsOQlCZYxbyLQbnn8+gj6qrHyzc7YF?=
 =?us-ascii?Q?qonRjPRYYAzw06VQwJb9ow3NgFJ8X/MjihcAdnq1UWy9KRdkj/2/L2mUHnRY?=
 =?us-ascii?Q?IzUjiNclqZc/nJyaTj9t27QTt/BkmPxWxLDaRcEliiywTlNYif5PYIwdUJyD?=
 =?us-ascii?Q?9AX01PB1x9uWffs1KF9CTlb3CxhzmccGa+mJUQjs3Wll6ompgh/3PMj2Sd/J?=
 =?us-ascii?Q?XXN2gwdwgl8JunrlsAHcj0VXu/Sj9naf2NsOldrds/4GLc3kEO1e8ItbWwl6?=
 =?us-ascii?Q?idPpuFvCmeAS4I9FQM3l+r7qPJOs6WYJqSLYwI15t2tLE44AEeoIFkJ+fKoV?=
 =?us-ascii?Q?qXgtauGi1Nnbr8YaDI7igNWnOYJPgS/8DXoVJ/WHoqE8UQ1v6q4xyXHq/y2G?=
 =?us-ascii?Q?n5uMFGMQPc94ndxRt3ooqfJxBLXrIlR+Ik/gKOCFgGZKGCM5IhwgbA1doWPX?=
 =?us-ascii?Q?9JSWBq1S8q5r8IJXhv0nom0TW1XRK2ClBvtV95WJIxjWHogy2y9HG3V2jeR5?=
 =?us-ascii?Q?04QFo3b/1xRH8ctGJ/pzRnBX6S78cq3SnBGTC5Zzl9oD883aRai0rKF/nQot?=
 =?us-ascii?Q?cFDeN3ScHVOniRAkLbg5rgueSLFePl+wUStJgr+9zn5fOF4Hk29hwXAlWEjy?=
 =?us-ascii?Q?ps4A3ojXdtmcZrRUAhvAcFJiOcZmyFwEOEou3pRCvFZI1+BKN38pogn2ieFW?=
 =?us-ascii?Q?GMeZCjsZSJcDPfuJSfAbs/4r9HHIwZea/djzL4QBr036Hv9YGGIH9kDBgp8c?=
 =?us-ascii?Q?GAVCWIXStnni+asmZhQ+a7v8+EkWcInh18PrgB2/lBBJejx8P6J8Lq3NLmNM?=
 =?us-ascii?Q?22KgtZbI1KhBsHLoxuv5LGZY/ykxPEKBUE8zxrQ2VqxRxT0VXzQXpWnwF+sv?=
 =?us-ascii?Q?L3VH4N5M5ywRdxoVgb+0eq2PIFYCQb1xhn48ag8ahDVItOnU5qcARrlerUKY?=
 =?us-ascii?Q?Fa8EehZosKmJSXjt01h1pCj74JbELVhbqANj0SUF4c8tDpoyrznTj622/uJj?=
 =?us-ascii?Q?8MSeuC/7o6cqBA9RRjCFvGYs3Wg4oF4FW+VT2p9JjdTvNIS7o7VKJx95uk0g?=
 =?us-ascii?Q?yGLQK4BGZ1OwVCVK58MvOUIlg7WtbCn8MnRpIswpuyI9iQCUAprIHBuS8cPC?=
 =?us-ascii?Q?h9j1X/aMUSABv30+CVrYrxtdlCyhMTFOM4upBqlId6NUykUbQ5ssWPpQp3nh?=
 =?us-ascii?Q?eNhIK3eLixTVC2IRrLU+Dd5R8Y08+fqn4LAYzo0TxJcjIrCJ623OoVHCbqI8?=
 =?us-ascii?Q?zVN3jR/wnFtQ3DQIYxSNAP6dDtWOi0e5sVNh9oEX9WzKbwNi1Hn1474YRRIy?=
 =?us-ascii?Q?3oirNfD8T9X+8yXJw9dPg+JJKPGJL406j4aI7CHD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8be28e-9109-4684-f331-08db46eceb26
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 06:59:17.3966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o27SFOa1Qp/WcA+urWjclBRqYjzVJsP4S1bJ6uSsi7qofaW8vzXxNW36oqg7L+F7R3j3duMVT9p8GA4RSbBs/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6657
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Thursday, April 27, 2023 2:39 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, April 26, 2023 10:54 PM
> > @@ -121,7 +128,8 @@ static void vfio_emulated_unmap(void *data,
> > unsigned long iova,
> >  {
> >  	struct vfio_device *vdev =3D data;
> >
> > -	if (vdev->ops->dma_unmap)
> > +	/* noiommu devices cannot do map/unmap */
> > +	if (vdev->noiommu && vdev->ops->dma_unmap)
> >  		vdev->ops->dma_unmap(vdev, iova, length);
>=20
> Is it necessary? All mdev devices implementing @dma_unmap won't
> set noiommu flag.

Hmmm. Yes, and all the devices set noiommu is not implementing @dma_unmap
as far as I see. Maybe this noiommu check can be removed.

>=20
> Instead in the future if we allow noiommu userspace to pin pages
> we'd need similar logic too.

I'm not quite sure about it so far. For mdev devices, the device driver
may use vfio_pin_pages/vfio_dma_rw () to pin page. Hence such drivers
need to listen to dma_unmap() event. But for noiommu users, does the
device driver also participate in the page pin? At least for vfio-pci drive=
r,
it does not, or maybe it will in the future when enabling noiommu
userspace to pin pages. It looks to me such userspace should order
the DMA before calling ioctl to unpin page instead of letting device
driver listen to unmap.

Regards,
Yi Liu

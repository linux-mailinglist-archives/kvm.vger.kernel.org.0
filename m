Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CB46D15DA
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 05:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCaDLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 23:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCaDLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 23:11:01 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978311207F;
        Thu, 30 Mar 2023 20:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680232259; x=1711768259;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=91467VDRzHrUNQcrtIymj4eK/swSc8zLh4lqhJA++HI=;
  b=KoStZ04RSAQUxeyv1sQbO23PFzyVZAzNdJPH0aVJenaf6VWi1gtQwsT0
   5/YkLVzaZ01EKIMvi1/uD3GeCCUs5CFhwDsfu6M2kYKLwpeOVqmGhItCC
   zTYo5Dz/1u42XJfULF0sK7IOAEROJJ6nSvjqORcc4D+s9xD57kZRJJNd3
   11o7OWGk36TWLJmb6QOq45hIvBu+iMGbcRtnGWET7uw+WK0AsBiDUwvds
   4bol+zIHphkdMXw/RAit/QY2XeYGXbqY6P9JLC66/dBKavfFAmp+36E4r
   eAN0MrFfxFJaIo4RcZLjr2etaXGV3rSc2EVAXqVfEVSRKVOoxLsZJU+Qa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="427617001"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="427617001"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 20:10:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="754249632"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="754249632"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 30 Mar 2023 20:10:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 20:10:58 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 20:10:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 20:10:58 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 20:10:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ao0VH+WL6kaODf1MaRVjVO2SeXZiz1gaMzuUTMP2xDSa8oCn7OxeIvLncgwaAIZgM7C/ywixUbZ8uf4EVMlp3TDDEPVEJz187y10O7vt24ZTFheaQ3QRUujPwsplwr0NVxv2IId/XY/wgX3kRRbqunFLGITAdreKQZ7IjX0OmvIIUPH7BYn2ATTCBbtqODLDK3ndUBOJqNgtcc3ntPClOzYBNYfHRtYFnzWwPrtsJp9z779oRd+x21oH7ZEfZtdxrMbPKCZ/0NYIh2J8uQXx4o8jSiIhrlpWOzIVBA9SURZVBvsc7PDVSFlipO30GkM1y/DfBk2VHOVPw0oprBH0dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91467VDRzHrUNQcrtIymj4eK/swSc8zLh4lqhJA++HI=;
 b=bsfoxDRvTkMs6mAq+qEuYq5FxaFp4FFzsDSfNczjZrcIGfZaOj8kJkW0HLByzDj+wg41h6wTyUd2JziUjUfDbbu81WeEWriMQ8Po5n8Y4NTYKIk+vMTimJNw06yEyPfx/8Omau/k715A8wy0gvchXx+uSp3fADGnl6WpQe9xrnAdbkocbgIUt0+dHpct2tvuFr/fTJdKGQ6fS8kYIfWZWNZRv+dqVxv2DdxLTiabXzJ1DqHl79TxZuEtK7sQFtdLuyWR4aFY9l6lud27LLVljjYP+PTyYKtKrfrL+0ZlNT2BmsdogBGOBxXTi2RpPxqLs/nAqEvMpeTwxBs68gXQZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7)
 by IA0PR11MB7356.namprd11.prod.outlook.com (2603:10b6:208:432::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Fri, 31 Mar
 2023 03:10:49 +0000
Received: from MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::c4e:6c7:e9f7:7222]) by MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::c4e:6c7:e9f7:7222%7]) with mapi id 15.20.6222.035; Fri, 31 Mar 2023
 03:10:49 +0000
From:   "Jiang, Yanting" <yanting.jiang@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v8 00/24] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v8 00/24] Add vfio_device cdev for iommufd support
Thread-Index: AQHZYJA9pBM5UV0gsEGCaT5PZWWhNa8UNuHA
Date:   Fri, 31 Mar 2023 03:10:48 +0000
Message-ID: <MW4PR11MB67639B35859D579574F36B2EE88F9@MW4PR11MB6763.namprd11.prod.outlook.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
In-Reply-To: <20230327094047.47215-1-yi.l.liu@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6763:EE_|IA0PR11MB7356:EE_
x-ms-office365-filtering-correlation-id: 1678fb34-c480-49c4-224e-08db319586f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4h2yPXbzoZuTWZiXCPy0/ZWXIaRyPl51+kLsD/I0MQkT1nbuQX5XT5lBkBYbdAjqfYRpehc0x0TDF+eB90+YpDEa8gfGGO6yJPZ49RQD9bGrnhUqmE8chYsv65oqrztCy4uIFUs8ZrbdoS9af45aPUPrJlxi0SuK3Dz3yy8mRVgzsB1XRi4kopsUcoze/sFmC7/QYWlSdT2uBPP1xHbsitTE1ugdJpyIZUnqMgA7/QzMis9PcN7HVcvzQzVVdkLTY1fpzne5KkfziJK3LGHIub57BpXtgGBiYfJrMYfKOXO2asoGZvY2NRgOPP/Dpn+Q17aFk+4yCgA3qJbeHsYDCmD2yighVCTSuTmdkX9x8lm6EJVjsk9IbFFkFLK+kKz0Ta9K5kCwPxOF/f8ZCMsywRxCO2kC+l+UjHbdx3kywJQeTNOmHkZySL/vu7bD3vN8Xq5Jqh0Ql7jhPORtz7gs524D7JDGUgdnD3OH26uyjcMHCrzsOt5H06YwIOAsi0lOuuPPF8S6xGtehYX36Tv4V25y1OYKYImR8XxteQC11FBzE2kG/KdJShVTBLEiT003ixvRQoAwKwyLBeXcabgID4mlCVKnnjU8bouYOBZZEtY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6763.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(136003)(396003)(39860400002)(451199021)(8676002)(9686003)(71200400001)(966005)(186003)(66446008)(66556008)(26005)(478600001)(54906003)(110136005)(316002)(83380400001)(66476007)(86362001)(8936002)(38070700005)(33656002)(55016003)(4326008)(2906002)(82960400001)(6636002)(38100700002)(7416002)(64756008)(7696005)(53546011)(5660300002)(6506007)(66946007)(76116006)(41300700001)(122000001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wNV0n5Q1FLECgApLNbaW++A4+tXgbc00XGce4F+6lZhm1qXso10YHyeLCVuh?=
 =?us-ascii?Q?TkVFN16ibdymRT6KHMMh5d7GYQoQuxVUyOz1allFb5hZad/+fTwN+UjsrYVv?=
 =?us-ascii?Q?1SQEyEKN/CPMeJz8Wg4eRr47AXhKnltwNGcHtNiPBVH2ADImQi+YPz1oWiA+?=
 =?us-ascii?Q?U9eYxkXKkXI4H7O6eNlRteX3DlyaUqiHpey1sXm4DBFQqer28lpTMwpnLAge?=
 =?us-ascii?Q?A+37xINi9XjEJSD2AaXX7T6wiIgZxeOxzOe3srPRzqFo/lEtHu/vzeDPjQLF?=
 =?us-ascii?Q?NyvCZq/t6+kf3qpk/35L2qiIrRHmgPE4n57u8NIarQWu5iJNNwRl7vSHzERO?=
 =?us-ascii?Q?7WCHR111SIoeGlzpAzf2v/kv/IinhyJUGpv0gHuPWS8xgLkPZxpLbqgua/s0?=
 =?us-ascii?Q?4TWjU9aoxWxTLfSNJT0dmazlO6JyI5UCi/cgT/FGmLmM3qWSHsSg+MbY7Zmg?=
 =?us-ascii?Q?4fFenUA57u3dXKo2wmSWbEfKfQKSsU6a3uF3GxFgkDgC2j9o/LTHl5W7NpTz?=
 =?us-ascii?Q?KQgJE6xM0gMY5DP37qkhxROmTndbBIasp9dhsZkQ79tF80Y+u/gd0PltErpa?=
 =?us-ascii?Q?9JnPdNoyTgL0GOa0fy1dSl2ojJa8jyBQc/rMIXEwc3DFAECkA8Z+MdpcH4P8?=
 =?us-ascii?Q?EEcCruNnPB6OHk7jBZQ2ovL1VVM2e+CVcS/fUaczLJGqspOEkQ/HUvaJnqgA?=
 =?us-ascii?Q?e76w8UJMAtPb2jm4i5Dc5rLkBLTTfOyrB4RxHyH4MDAMeG1f1ptUtq9uyFXq?=
 =?us-ascii?Q?OhY+iuijLILqzUQChNyz08mlPzbJP/TwzuN369tbEuDKzJb4lL9QESDXuqWh?=
 =?us-ascii?Q?R4JjurTlvzTHVb2ESUCVO+dIcA4vS0868m4Xo6gJ53ctoxqryqh/4LiykAGK?=
 =?us-ascii?Q?85v5plaVYK8VnrvLMGy1MFgAgCfhWaSdErLDYfy6qjNhbMcu+RjD2MaCdhvk?=
 =?us-ascii?Q?HlAIDbr5A86uick1NA2HVFd2qtO+0uL9rkqiTPGBNbYAAX1nHuFu0I/3Av8U?=
 =?us-ascii?Q?StfpMVmlqwoj7vCOBrB3V3KA3FFHM704+iDe2ZW+Bp7i+KRAJrqx5g1TCPlF?=
 =?us-ascii?Q?5Ho/qR7sTK47UJ6LBd3Idr+ULAeyD7uuVZXXCEN+kauQvm6AfbhPbZOa899C?=
 =?us-ascii?Q?/SNztOFQ6/AUvORjCc3JybFaSqh/0GA0KKjFAafD2fycbIF3tH7pW0dE+mXw?=
 =?us-ascii?Q?tUBp13ed3apX6OuxiD3z6T77/czC1TF20ulpcIGaiTiux1KDPxbbxNYs8tLV?=
 =?us-ascii?Q?ahU/7XuQpoFA+ULLm0+u6qsfTW4gOYPB8K7x2RNldz4O9xQGPrO/Zk9kgJSc?=
 =?us-ascii?Q?HmFG0ojvyZW/oiOilaUPpEPfLxR2dPxKRmdHJD/GAsvO8SFj6+A9hV8rIONy?=
 =?us-ascii?Q?jgIEBnuPXBjkacoZQHOhEn2TFHfRM7B+/LN9rX4uqo/YQn4FvT6pRjdlX0CF?=
 =?us-ascii?Q?zjlu9mgq23qsV9M42753kd3ZzZEWRMy3s5OvrdmA91W0ePIkj/6Z/hz7yGFm?=
 =?us-ascii?Q?9DDApek+ARse9JJ8fOCL4LORd/MX1G+xOHPSTHCSUth4MCRDsldBHapXy/xN?=
 =?us-ascii?Q?/fnKN41ERcxGmm8Z/svIqnTHfzVSq0Wp64XPs7Pp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6763.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1678fb34-c480-49c4-224e-08db319586f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 03:10:48.6768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hQ+rln54HJJgkVqXa5OQTHBCZkrpJCT4VD7QhlJfuvioBeW/Sqa4OyzdjIZolG7cLKIYEBjADKdr7tHtr6tnsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7356
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On 2023/3/27 02:40, Yi Liu wrote:
> Existing VFIO provides group-centric user APIs for userspace. Userspace o=
pens
> the /dev/vfio/$group_id first before getting device fd and hence getting =
access
> to device. This is not the desired model for iommufd. Per the conclusion =
of
> community discussion[1], iommufd provides device-centric kAPIs and requir=
es its
> consumer (like VFIO) to be device-centric user APIs. Such user APIs are u=
sed to
> associate device with iommufd and also the I/O address spaces managed by =
the
> iommufd.
>=20
> This series first introduces a per device file structure to be prepared f=
or further
> enhancement and refactors the kvm-vfio code to be prepared for accepting
> device file from userspace. Afte this, adds a mechanism for blocking devi=
ce
> access before iommufd bind. Then refactors the vfio to be able to handle =
cdev
> path (e.g. iommufd binding, no-iommufd, [de]attach ioas).
> This refactor includes making the device_open exclusive between group and
> cdev path, only allow single device open in cdev path; vfio-iommufd code =
is also
> refactored to support cdev. e.g. split the vfio_iommufd_bind() into two s=
teps.
> Eventually, adds the cdev support for vfio device and the new ioctls, the=
n makes
> group infrastructure optional as it is not needed when vfio device cdev i=
s
> compiled.
>=20
> This series is based on some preparation works done to vfio emulated devi=
ces[2]
> and vfio pci hot reset enhancements[3].
>=20
> This series is a prerequisite for iommu nesting for vfio device[4] [5].
>=20
> The complete code can be found in below branch, simple tests done to the
> legacy group path and the cdev path. Draft QEMU branch can be found at[6]
>=20
> https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v8
> (config CONFIG_IOMMUFD=3Dy CONFIG_VFIO_DEVICE_CDEV=3Dy)
>=20

Tested NIC passthrough on Intel platform with above branch (commit id: 9464=
af85d280511639f8a3e27b6c2a2c5535fa4c).
Result looks good hence,=20
Tested by: Jiang, Yanting <yanting.jiang@intel.com>

Thanks,
Yanting


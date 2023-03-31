Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87A96D168E
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 07:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjCaFBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 01:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjCaFBQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 01:01:16 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577DEB767;
        Thu, 30 Mar 2023 22:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680238872; x=1711774872;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H9Cqkx7LOorGVfLt9Or6X/MmDeLJJwNBdhrWpndAsV4=;
  b=jDQsMepKwCeL/g93WZw64R1Hk/6x/Gh9B/EtAcyfyXgaVgoiGilw6F0O
   sStzb41DaynSEA9I4MWyfTk/TYK+HPOp3wxNNuBWsSe616megKZ5ndXnJ
   m53RRsOZZvOQWtgldozv1WKbnq0TAeNPTAbSs4xI0LWZ71LRgzBO27bsj
   Jn+pavMquvKn56/URlSdm+At+ECDB2spM8HspDz+Uir79buchQbWixSJB
   QTN45GR9rWBQsrbbHeb895AAPnwNFE3H9eO52+7kDR7fWgyKggju2NFVq
   vQEiDir8ItNCMS/Vu5rb61ADQi5BM6rNMb9Bsnr8YT6FdGdVOg9b8XYAE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="427636472"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="427636472"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 22:01:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="635160169"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="635160169"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 30 Mar 2023 22:01:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 22:01:11 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 22:01:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 22:01:11 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 22:01:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyqlxzvHuEJvJKuLqa4Re3a2gxxH5n5Q3tNnMCNo+iMfdgrDzh2Na1qPXvVk3+/ASBEWvuh30FVF5DJLcqwjGL9j/t4+kfxRL0zluAM7jkLz7O5oiKFmT/dYygQJue1BI0wozWf+QM2nfexc1GDSTK7ddFEqCP5Ch0OXhLoBe5SJdIyQvME6okIy6sf749SR0IwjMZRyiAtBtWFNhhtOOlIe5z1Y/N2wfZaRNKnN9f0LqFXmcWy4UZYnER5s4dtWCU5ZjuUueg+QVEgRcO7tBdazXr9a6WxuAiKVUUa0wiXcbC2iVW6qRpmE1QlDNkfqp19ZE6bV/lpVuVZnKQWDuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H9Cqkx7LOorGVfLt9Or6X/MmDeLJJwNBdhrWpndAsV4=;
 b=WONDr+cxfs/0/T32z9PPZi+H94UqQWcSIOn4PeiYF7uJoCn3Fi5Y6j2nTfnQDOQlZ5xKv5OkgloJDHlYFE4j/4OPZcfKVfzzcAxu/UhjZ+TfVeCryf/u1QrW4oQ2vF8QlQLS2MDL9v+BLtGKTYpealiJHjzSPzNd0hh9sOE2yjzuhnky9FLaV/ycYHcux8yAiOh3kEtr+eK6Vp+xgtj1mqWHVudhKzSmXzg6uhSMFOS42Ztsz50BJIvXrxIkDfFmhYuwWND+SaxWvmqGlKGLvWCYU64XrxsMcq30qwsxqatUnTcX+kS1DPFFx9sPdssA/Lkwm8N2kndgSAvko/TyjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7)
 by PH0PR11MB5610.namprd11.prod.outlook.com (2603:10b6:510:e9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Fri, 31 Mar
 2023 05:01:09 +0000
Received: from MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::c4e:6c7:e9f7:7222]) by MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::c4e:6c7:e9f7:7222%7]) with mapi id 15.20.6222.035; Fri, 31 Mar 2023
 05:01:09 +0000
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
Subject: RE: [PATCH v2 00/10] Introduce new methods for verifying ownership in
 vfio PCI hot reset
Thread-Topic: [PATCH v2 00/10] Introduce new methods for verifying ownership
 in vfio PCI hot reset
Thread-Index: AQHZYI9oL669gEM9E0+QMvpJm73ZX68UWj3A
Date:   Fri, 31 Mar 2023 05:01:08 +0000
Message-ID: <MW4PR11MB6763C2E322D2F87D6B7B764CE88F9@MW4PR11MB6763.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
In-Reply-To: <20230327093458.44939-1-yi.l.liu@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6763:EE_|PH0PR11MB5610:EE_
x-ms-office365-filtering-correlation-id: f464bb68-51a9-4c20-3fe7-08db31a4f0c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LByI4FXgsmmtGK3BlgmSYK0rox176eWMviMi1X7WhQLvnjd7yMC6YZ0e6nw/3+aWKkjfr49lp26ABuaj5gyhg2JKLGJG50dKg/8Lvn/8jEYke5UxVOer0Ari4bpH+liu6+XjupkGZQnZZYnAt4t+2cpUvztZTXAU+4PgUm6laIPobCZwAEY1C1qgzw8M+m2cchCtkMrh/x5EotLIqbYGSl4bFVVv4LhAm2/mdiZHtQyVxCnsZ8rJvQEsy5xd+LmZcNfaRH0BTcLLk8ghtUEDWj1eDC3yhf58SkVcLB/DcgJtsWKPqmwb4HMZHfYOc9BxKSWw5TjECtbD7tNw+c7IwA5nTKNv8CvqIqlhotDOICNImJzdCXAV8cLy5HYc9JzQnsxJ9sVIG2HY9scymiKdZTn9oN7+oCFEUprOI4xATvjbRAdFsAN0fyCrXZC82aGuzGaXt6p51zLRLQ4mXxSRYCbuFM2MdYhxIjRgtzOYDfRrKQkQqw9PhHbil2wFqPtTuFN0XMr0qyJlO68Yei1Hbr2B1xEIcDYPnqwHqPDlZuIyute2zp7ZMEbVoL14WjJsGN/ICmmJCPUREGaHtL8xsv1drjiPymku9qLDQmKF/zzEYZc0b7YliXg6asRVQpso
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6763.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199021)(186003)(9686003)(6506007)(83380400001)(26005)(52536014)(41300700001)(110136005)(54906003)(66476007)(66556008)(478600001)(76116006)(316002)(66946007)(6636002)(64756008)(71200400001)(7696005)(8676002)(66446008)(38100700002)(4326008)(2906002)(82960400001)(122000001)(33656002)(38070700005)(86362001)(7416002)(5660300002)(15650500001)(8936002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HsAaIXgR+rKFjOtgXZZudd5TBZ9OB6pIOALqK+jAu0kzHgB5LLnUA1s3SD6i?=
 =?us-ascii?Q?FEHSVEr10F0wexTOK28Rlkkrtb+lLwvxKSLWjrc8bZLitMbxSbLqYepIWKzu?=
 =?us-ascii?Q?VdX1W+YSkO6VGGzjL8gwSjbOsm6mcWOFpbTlKZnix1rcOwm0dkeO525kRLBB?=
 =?us-ascii?Q?FfeSFKJDwMe2C5wFq28gK+MONSaaT8zyHoD5YA573tljIdhhJYUhFAzzO+jE?=
 =?us-ascii?Q?KPCOSRUtBSMEagSeXlwoYaPs7gMx4UcVT5tElUYLM3OlXi5nsJGIKxK/Q+PS?=
 =?us-ascii?Q?flsY/Kvd2inKsXdv3RfAFjFbchBIaSfqzvTaWSy/pNpngBfVyx1FYMP2lFbG?=
 =?us-ascii?Q?hCSiwXqmKfZF/wM80//+OzhPK4Q6uozvPm9a2S0p+Nmli0leMMagdc+DYKNs?=
 =?us-ascii?Q?4EZ3Emn5Y55xP8A/WjXTvp2cTeDjy89x3EZaZwN+kDRt4uJmGwVknYtzU+wF?=
 =?us-ascii?Q?gRMLzRH1gExGbRE0ek1R880+vRTetin5do0X7br17BGBL7btPAGgLTTacH2h?=
 =?us-ascii?Q?6k3gvDJVXfcAk2p+bbJTqoFLCOdeL/7MgpCbQn1QVQIvF89au/LwzKqAtd0+?=
 =?us-ascii?Q?JcSyqZtM+aB5XRPOZacSrNrqLPwS/gX2FExBe6fXm5KX+6Z2rt/hyQryFwO6?=
 =?us-ascii?Q?bT4u/FE1r+tvFWGVGCbQzw5PFfw8mLxdltNRBQmYbNdGFBLjJt8w3tT0W0Zj?=
 =?us-ascii?Q?RBixO4XiBKz1RJpOw2ZH5q1DdKX49HeC9uyh+vwyEAiKSSe9SVMefSuG/QeP?=
 =?us-ascii?Q?F8AVr4/oxbIeY/9mIFWmhZ1Nh7o+kKUn9HTnMw+XYPBg+PCxHqTWMSYZ2HhG?=
 =?us-ascii?Q?lHa95Hw/WGThCVZljD7xzu2hZFC3fOXkXc70cYiwgZPxko2d8YtAqoj/g/bf?=
 =?us-ascii?Q?8KB0pVZWg3xg73kzoVlO9s6k7lY/T49N+qIWZpmYWElxKycgi1xMhm2dk/OI?=
 =?us-ascii?Q?HLMZbUETc6UC3Rad+oJCkjO/3w3HRh5xUjEVQBkqu5OkMK9ZtAUJAza8+FbI?=
 =?us-ascii?Q?SS+Txhba+tgMryogRVt/YGozvxj69gBuJmecBfOZXLTyLQizza+8vzbNAVPy?=
 =?us-ascii?Q?t7fAYUL86A7jOPF6Mgi5s5tIIxG0HdCcYu5z/Li7S+MhpnzPFMCX6YotDw0z?=
 =?us-ascii?Q?akE1rdQVBVJJJiE1g5UITgyFTmqMxd4ngCMa06XanZYwV8oNofWEGbJgL5h6?=
 =?us-ascii?Q?43QpZIj1cComH0DfWL/5VnDo7qg+zZ3WAjSsrWcV4An4QXYjij1qawfyuZDn?=
 =?us-ascii?Q?PDUuKzBfMEpqB1m678vwaZd3G6c3mRoMWTdM4PbtOwYiQTS+YeGUvp7qJ4lW?=
 =?us-ascii?Q?HjKOpgwjOzU/OTOFRiZKPZayo/EnSDSjIMe2qyQib9mDsgiIlF3/tI5IuGVt?=
 =?us-ascii?Q?a/q5PlIIRZrj/i5m+dnq/zFUEzpQTUEFt5wFErea+CFwMC6w+w0DkZq8SNWd?=
 =?us-ascii?Q?HQeXn8+wcpNLh0F18dl61x9AOripm9L1K+Klqr4fEh/DtJzDJl353UzeTxgr?=
 =?us-ascii?Q?14czqkMTm27ksCRpJ8zqWqswz8R7i6wVHMER8gsEiDqKaiBnaFmRvtIpjx0x?=
 =?us-ascii?Q?uSzkMQcjD5fPlrosNcf3OP269I2fr1TKGRj/DLRs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6763.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f464bb68-51a9-4c20-3fe7-08db31a4f0c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 05:01:08.6547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iRXTZ6lF7N4ZNStDV1Qw/F81u/WrShvZZp8rg/qWBWUJ9XTP61aWwJzBuG3XKZMY67dLLfsjkf9zshtNJZadow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5610
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> VFIO_DEVICE_PCI_HOT_RESET requires user to pass an array of group fds to
> prove that it owns all devices affected by resetting the calling device. =
This series
> introduces several extensions to allow the ownership check better aligned=
 with
> iommufd and coming vfio device cdev support.
>=20
> First, resetting an unopened device is always safe given nobody is using =
it. So
> relax the check to allow such devices not covered by group fd array. [1]
>=20
> When iommufd is used we can simply verify that all affected devices are b=
ound
> to a same iommufd then no need for the user to provide extra fd informati=
on.
> This is enabled by the user passing a zero-length fd array and moving for=
ward
> this should be the preferred way for hot reset. [2]
>=20
> However the iommufd method has difficulty working with noiommu devices
> since those devices don't have a valid iommufd, unless the noiommu device=
 is in
> a singleton dev_set hence no ownership check is required. [3]
>=20
> For noiommu backward compatibility a 3rd method is introduced by allowing=
 the
> user to pass an array of device fds to prove ownership. [4]
>=20
> As suggested by Jason [5], we have this series to introduce the above stu=
ffs to
> the vfio PCI hot reset. Per the dicussion in [6], this series also adds a=
 new _INFO
> ioctl to get hot reset scope for given device.
>=20

Tested-by: Yanting Jiang <yanting.jiang@intel.com>

Thanks,
Yanting

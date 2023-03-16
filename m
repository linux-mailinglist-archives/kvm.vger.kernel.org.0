Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8CF6BD0B7
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 14:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCPNXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 09:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjCPNXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 09:23:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1495F12BC8;
        Thu, 16 Mar 2023 06:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678972985; x=1710508985;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Aox63ikOBK1hBQ6TdyKQqkT4/WelcH71CDHkbWlsnLU=;
  b=fgoD/OpxfzJiQaxp6jr8jWIDB2ucbpo20VhFHKeknLH38qtMI1+TBypO
   EJAU3RrP1rrmrqNEE4NslJLZLEyu+TulbpSmHG3BFpFtsiWD+nSY4hDA3
   5GyGNVetBMAkDb/XUd9/HY+k6lkXSAJ5wM2w1LLpB1LvSw5XI/n7Tp5YR
   qH23qdUuzom7XvgBlwwfEsJbXpPH3m9ipeCnczkZTwjYRHUIRM2caKIUr
   jtHhndMVyyjFGxxIeGz6bxVS/m1bdy3IPZVedrRU7zv70fKIPMVNp5Osz
   r93BypGfkqB+7XlSH8BuojSpm6Q8Wz6xR0EcwZ+xPa+v6QXpWixoECklA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="338002789"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="338002789"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 06:23:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="710107359"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="710107359"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 16 Mar 2023 06:23:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 06:23:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 06:23:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 06:23:02 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 06:23:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWej60SrbQFWx5gW/JVUGc68iC7FExo9mRJN0PypC42oi0JYwOa2MSTS07J+0StpHlzsIxNXsVa2Oiel7nov+1kWoU/D9lTCOROIbD65gCIaaWSSNh2KawKEFXhprBilAHy3ZExj3xqttj61+pUF7qNZbEdUyUWsGeWUpSZQ7iKM7mjwDG9eXecVKiiINNFyViuvtnyKvW8G6hjGRt1pRsdzU0akXrG6u/oUfaFX2oPJ456A/zDLFPWBwDKIp2WftLAuQJ/znJVfY9U9HaNEhdXrlfhjT4e7+u+AhLvGWCF5A4h9A9m9wJ9nx7VvWq93ubtMsoMvOrzWv0z0CGsh0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVMRqAtkceSiwc440LIN1E7lVFejwxVHfy22DmNWEdE=;
 b=norS7tZ0jUYaT8Pp/dMt//d7n2OM5y1fns2zftqTzuRfj7ZNXKz4papKTSNRFbbBKVfhwRyBQSXuKDIpCWDC9U5Txee7EW8vCydh6Uafj718vWc5B+mvQ/hWRDmS2CmKZTuplHv7jdoKh+AhFQJy67Dg3cYS7hNgOXAfSXlvmlyHCLZK5t6IhhFtHBOFEROdKgMD3FQbyCVfYM0vdFo8yyxaxYzI9UAQw8q14O+M/dqxdVXO23GUwmhF5N5xuEzrwmNF37YD35hc2e0oBQhzBIuJHXc/RiTlDTRAR4GRg7n23AexqHQEyRH1CNb7XqghU5X0cAynIAsiqafMpUtBPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB6269.namprd11.prod.outlook.com (2603:10b6:8:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Thu, 16 Mar
 2023 13:22:59 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 13:22:59 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZV83ljxjAAYqHzEGGeM++m5XIpq787JlwgAAKmoCAAGuasA==
Date:   Thu, 16 Mar 2023 13:22:58 +0000
Message-ID: <DS0PR11MB752937BCFB81A6018CAB94D2C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-13-yi.l.liu@intel.com>
 <20230315165311.01f32bfe.alex.williamson@redhat.com>
 <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529C7D0409B47430D7412C5C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276ABE919C04E06A0326E8E8CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB75293503F92A24A716DDE2C6C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBK74xltWbaWlftV@Asurada-Nvidia>
In-Reply-To: <ZBK74xltWbaWlftV@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS7PR11MB6269:EE_
x-ms-office365-filtering-correlation-id: 5a44b677-35c7-4cb7-5136-08db26218f90
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xSCu38RR4i/x6QWNnXJ9skOLHfujVzSNqSyZcv7PZurkxGiYSuDFuPUo2uTVFGGj9ldDG9XDokrZsR53ByU3BQqbrdX+Jn6yNm10pew43zHZauvFEcA3g56QPQOoam1FN4OKvMjOL+yX1fUj4fSD9s8T6AdHB2nORAC0pcMMMaW58jtW8pcdElO1oakhY7T22vp38+dlSzJXth5w/fx2aZFp8vweoMaa/+xfmxLTzl+wVFKrvxvftljZj83k9eKdu9UfS4CZdZNBvuqtY4ituLs3KXjQbG8hJ22SwQvtrBkxXfRu9zUeJYoj5M+1q9/ZW4sAI+/yLtaU+SbEcJQolZ2WI+Y2k6esnqaee5ZTa61FN6rZyua8izyMN/UBndL9mhLGCUzRFdONdzTNPC3PNLyjY92RE7gDHhKrJ/5lk0MzDeMvFQjVRkBtc4DUR/tyldOm8EBGaRJXkbOoTktFCEHtlfsS6mh/txqUwcymfPAelg48MfCu3YaTVhjtJQARdPUY18fVNZVapFJr9hmsVQBybQPN9NNPH5d1XTYOZUECxEPC2FliQrNFXhtGfH2ZqioYRy3U15fDJfHf1r/9qw2YHyOzQJyGwaciDCNXTQqYFLjY7mQUwLGxAbV8GxDoQDteNkd0K/tvuMUoUsIHtbZpYQYytck9skOc4pICq916pQCAkFM31T2B+O3gKYsDqDJ3wNT3/DCkaRvN0/UnXBMTvQLGIFFlZQyxHGr4AyE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199018)(41300700001)(52536014)(5660300002)(8936002)(7416002)(2906002)(82960400001)(122000001)(38070700005)(33656002)(86362001)(38100700002)(7696005)(478600001)(71200400001)(66946007)(66556008)(66476007)(66446008)(64756008)(76116006)(8676002)(6916009)(966005)(55016003)(4326008)(83380400001)(54906003)(316002)(26005)(9686003)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sVU7Pa2hstvAH6tuzI0gnVwumQsZdnLelGjWsyiOM+pvHqr7n4+Gsyn62iLL?=
 =?us-ascii?Q?dc3Rd/5MGD+UQCDTshlkmzCPOS5qTIQydxothJ9Zoc3YaqYOnIHW5af6xo24?=
 =?us-ascii?Q?3FTx2kGzhfs+trwLVJ2dGUTlZLdZNszhVbi38l8YS/OEBg4AJO1iBDc4+HTU?=
 =?us-ascii?Q?oVfOXD8h7GvKMSTUCjz4Fbh7sGEETusZ6jmN7a5BiA4qfwKBP0BsaKOMxdIj?=
 =?us-ascii?Q?HRVO428jl71x1M+Yls39qnsJoxzsYtbOGVSQaojC1VpkZVvD0FT0bsHyQRaA?=
 =?us-ascii?Q?ff80P/kY+tclciPJNIod3U1p89NylGEdz84HFO9Ky1b4B7EOHKq1kGszMs7w?=
 =?us-ascii?Q?LQ4NKVV+qwIt+/1UNoD/NHMW+o89CZ7U92wuX50bUGwoWlPvooVGTNFeapLk?=
 =?us-ascii?Q?5rcqD3bHGiOQATMG5EspAf71NQYPV2ElPDzn/TG4NHFllwVV44SLP2BnGpjA?=
 =?us-ascii?Q?lR4WLWMsQlOEs1PCvFHV0aNKzzxC4oI7j4XtMkA34fJ55gFXCuO61MGW6HVM?=
 =?us-ascii?Q?VPMkIL1nhJDVVS9BiXRIWg2QXPeT8KHgBtYNdNDb5yTNZT1t+Vv/rqkBelhc?=
 =?us-ascii?Q?eo9u7djJtI4QvemFeCmZ90Xuh6cqKKP3PO5YmsK5fkv6VZIMU0BbxcObnHGS?=
 =?us-ascii?Q?325Lo+MYSx2Cp33K/EW2pAP7y3baM0i1Mw/CyBUoENaIgyAcBxb3AbP1IdwR?=
 =?us-ascii?Q?zE7CNI+QMcdHApBGR8WYlEu3olKJO+3y1cKXeqdYj2ktSycYaLrUwdU9oYyu?=
 =?us-ascii?Q?kaJ9AtdfBAHSZlVNLDn3zdnFo5nwSX+XIvxhGtLHKP6qqe6Vsa4vMff52HTm?=
 =?us-ascii?Q?Fm/Ed8TwCGvn6Xz9g/yflsL4hp+bC3H235lmonNmOxryuFxyN4QPk3XXu0Iw?=
 =?us-ascii?Q?UTgRxhTEbuqf/Ugxjl57e18zVMygOF4dqm8zbbHofSdGq5kxfmWurHN/NC6+?=
 =?us-ascii?Q?BIYR3sNPX1gJrwHsvNzDD5gIo+2Q4nL9dQkt5OmekuZXu42N2l0RxQ4k3EOQ?=
 =?us-ascii?Q?czIvbZ97y2SNYnL0QOty4KG7VSNkAolXDyvGpR1fJ2gaBFIv02wKe+CYjrTV?=
 =?us-ascii?Q?NbkvZkYgL5sbkIH65FPwHWYCXQoxvc8Pd7BDWXWPcTCpEVMEjyRxR05vKlT4?=
 =?us-ascii?Q?8rNjOUhnLqoUko2enLXiCGzy0bSPykGUvWC6HFBkYexPKxAjkjJKzpj/IJ2A?=
 =?us-ascii?Q?YKq0RILoayqGN6gsEHjcGoWystRLhi+Q4a/Mgjw2KU/7m8xhorQ9kHH+8Ivt?=
 =?us-ascii?Q?aTVNBPnHsf846AYxU8JPdqWh4s1LYzrIcoWrtMeAg6qTN86Lmd8HtIJCtPo0?=
 =?us-ascii?Q?GRd9XUBwMXHp/1JMH2bdyuIbp3PbCnzTdkPJXSQpahXS1w9C3Yi29/8/DeX1?=
 =?us-ascii?Q?XZbaDxb0Xk4Fa7haR5Dn/tH3Z9j7fRcE/m3hPHOavHvw+alWz4q8OoQGW7Lq?=
 =?us-ascii?Q?j8v5BhtDxzdjqSiY9Q/k/ku3u8z77tumrjTSPAcWECBlEazBVk/vkVw9HiSE?=
 =?us-ascii?Q?+ISHq055jrjReDX4viHZiJpjqCpi7SZdZqr2q08kFyWD99fWQYNG35hig3Oc?=
 =?us-ascii?Q?WdFEwFeunvij1XR0ZnzJ1ItbuzF4N6aIM612SV7f?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a44b677-35c7-4cb7-5136-08db26218f90
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 13:22:58.6808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MadIiqGo+0T+N9s0KNXFp7m81EpE/xdJ8jj5k+ql2Ldiun9/tOF2Ou+r8d7gTz6ZWJS51k+BNgba6oNnKkWPJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6269
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Thursday, March 16, 2023 2:49 PM
>=20
> On Thu, Mar 16, 2023 at 06:28:28AM +0000, Liu, Yi L wrote:
>=20
> > > Anyway let's not wait here. Send your v7 and we can have more
> > > focused discussion in your split series about hot reset.
> >
> > Sure. Once Nicolin's patch is updated, I can send v7 with the hot
> > reset series as well.
>=20
> I've updated three commits and pushed here:
> https://github.com/nicolinc/iommufd/commits/wip/iommufd_nesting-
> 03152023
>=20
> Please pull the following commit to the emulated series:
>   "iommufd: Create access in vfio_iommufd_emulated_bind()"
>=20
> https://github.com/nicolinc/iommufd/commit/6467e332584de62d1c4d5daa
> b404a8c8d5a90a2d
>=20
> Please pull the following commit to the cdev series or a place
> that you feel it'd be better -- it's required by the change of
> adding vfio_iommufd_emulated_detach_ioas():
>   "iommufd/device: Add iommufd_access_detach() API"
>=20
> https://github.com/nicolinc/iommufd/commit/86346b5d06100640037cbb4a
> 14bd249476072dec

Thanks, I've taken them. v7 was sent out.

> The other one adding replace() will go with the replace series.
>=20
> And regarding the new baseline for the replace series and the
> nesting series, it'd be nicer to have another one git-merging
> your cdev v7 branch on top of Jason's iommufd_hwpt branch. We
> could wait for him updating to 6.3-rc2, if that's necessary.

Yes. I cherry-pick his iommufd_hwpt to 6.3-rc2 and then try a
merge and then cherry-pick the replace and nesting series from
your above branch. Though the order between cdev and
iommufd_hwpt not perfect, we may use it as a wip baseline
when we try to address the comments w.r.t. nesting and
replace series.

https://github.com/yiliu1765/iommufd/tree/wip/iommufd_nesting-03162023

Regards,
Yi Liu

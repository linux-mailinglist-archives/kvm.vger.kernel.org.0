Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9376A15AD
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 04:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjBXD5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 22:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBXD5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 22:57:04 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63D23CE05;
        Thu, 23 Feb 2023 19:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677211022; x=1708747022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VJqrCuZpL/psTY0kud8Rh20HHe/dXeG9HkAkZvJijlQ=;
  b=KzWD/8/KH0kH8RVJKIvugJ3NaV9Nvocrjc+rk1xzjxOPu9tzTByMEqJ6
   CcGFkLmibPwZ1i77tTd+zJpzhJrwUlRtkc5GyCVV5PJAaYHb5cRXheDox
   rETwL5m8nd/5xo1n2URFR3nq2m58w4vqgaA0KtxxCtL5YT0TlAVEyiN4v
   ogudFq3v3eNuNVnLJ6gD+Futdw6m/uOmE3rn44PHqU+/FbHPCzR9keE0v
   5jxesrzkzE/Q9qgYEypxWqMq/eX16YtkdaJnkQBwFno9jiieoVTaJzFsG
   qmyIHqxCjgpMErASrOkjsbxxpUaCd3qcIArMROoBQIQhO6RMz0w/gxfzj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="360893130"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="360893130"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 19:56:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="782192063"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="782192063"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 23 Feb 2023 19:56:48 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 19:56:48 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 19:56:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 19:56:47 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 19:56:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hta0qztY51Xe45OjU5yraONh3IJwwEtz/+dnoAlNESeIRmqBiTdqaZHi8TsLUHg5YEVRH3/1vwIR+UEn60PlHcKR9BFUM1ALzI+m/sFNqfP+MK08f0qBbg6HkTvYog3Qcnkc93fSIJ+psZ8npzOnssCcVDmQb5Rm04eoPt41agNS+PU3ajZEtjzsu3Pn+SxnDkURSP8g2o2guZAvvcrFli1oZpIO5PcLBcB4zIdAR13yzKQ0uydU7GRV7gw3K02ijUGFu30wOvgWG/f76EUucVgcHGF4wmUoEle2d+MPY1ghYDqd6YPBlmX5tP1NVQMU/k6XjC+7z9/oQnZypzeVKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VJqrCuZpL/psTY0kud8Rh20HHe/dXeG9HkAkZvJijlQ=;
 b=NafLNaYvpbu+GSM74NUA+LRrDkLMIxQ/Vi0BJZNCVlyv/OXRC7mYiakgfZFcOgVwP2cPvrjNbr7qJqDIf6kdLVtfUq7dSHgQgJX3qo2mA7LAKIwuuYKopUx0W+IPT5SOY9WwvYWTJ2nQ97LOEZ26k1DmBB8YXTbXUVD1zYWUWVcyWxRpQ9VV1zeF+HkWPU+UhlGGj2cZB0/eFjNvIhwk29ey77p4n4ZdhnW52D1a2BT9qv5EjWuk/i1kq3Rw2BP5sxsbw7YRXan+igEc5q/EDszt8BgP4dFSzo+A/18s5zLLrw1dHqe4eBg9nOwcfJGj29zVQ7/Q17U+gJ0AW1Sp+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6321.namprd11.prod.outlook.com (2603:10b6:208:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Fri, 24 Feb
 2023 03:56:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 03:56:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: RE: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Topic: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Index: AQHZRade4YzkLtsVl0WRYDgmHuz0/q7akQpAgABomgCAAD40AIAA70ywgABhHoCAANlkIIAABIeAgAACvVCAABAhgIAAAHvw
Date:   Fri, 24 Feb 2023 03:56:45 +0000
Message-ID: <BN9PR11MB5276F25F9612B5080CC9B56C8CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-10-yi.l.liu@intel.com>
 <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529B33D098225CFAAA7D63FC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/ZOOClu8nXy2toX@nvidia.com>
 <BN9PR11MB52767915B9A5E509BC90E0888CAB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/dobS6gdSkxnPH7@nvidia.com>
 <BN9PR11MB5276C959AA31F8515002B6B48CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/gilafqe4Xm45jY@nvidia.com>
 <BN9PR11MB52767479FDC6F1CE16275B8D8CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529EC1C6A54BC57C1251154C3A89@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529EC1C6A54BC57C1251154C3A89@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6321:EE_
x-ms-office365-filtering-correlation-id: 29c1a05c-d129-4b3d-b842-08db161b25ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VSAveUL13UyrbOuiYruyq/pq/CmG5fV5Xrtx4yLtDShHhUBOYLILsLG5iOxqm/lZhr0C2sFEI0qLsVsCjHZqrJbX314/28HSl6bdbC4rfGqcsCrg+3K8EkbuGggttfAJBL1K1AUqyArh094j2CwBPDDK01hyZht3MNxuNzVVb6IuFgGiQ2eO8Ur/6y5no0cGLGimOc/q8LuzVN67csJ0HM94tyJyAQy+jck8NuVlyPjFDFg14FGKfj7K7jPEqlhcZ/UGDLHwFT1b5hqZHvfp1TX/x72A7rOFJaHEvxKPEazCcuBsREn+uBAVa0Kggirc4c0SLX9dBDJrZmW9IGlQfPRvqWzyd4uqbeKwQcubd0r0gyYrvsu1qv3393ZShTGKr0+SoZw/WjOvf75BdJPOJUAhWw3f0XfdftVYvREz/AuamBenYnBAbEOrdcktMmyARHsAHJA6LUaVIhyDe5EYAnUrDfDTFn3gj+3yzwGZc4mMPNKKqSmZk3m4II8JqsGM6/FMTB2kZhrccE3UyZ+jCl7SzElhCcZ6lU04+CCcbTkw5ESW7fldjqnIm7+IakIj4TQyNvB6ofYnBjJijsX57YugMcV6Ro/LF/Zj5uJHQRzqIZicQT3h9XWSJ6P0LeUVRVdXYIThPNBvgM90T7vVsRjTQFc89O9M+Rrr31XibHBJuv8SJWhaOrLSl9cBcHyfqEH4/s/z+1yBd3BR/E0vPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(52536014)(55016003)(41300700001)(66556008)(66446008)(76116006)(66476007)(64756008)(8676002)(26005)(4326008)(8936002)(33656002)(7696005)(86362001)(54906003)(7416002)(5660300002)(9686003)(82960400001)(122000001)(6506007)(478600001)(316002)(66946007)(110136005)(186003)(38100700002)(38070700005)(71200400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?weJnohtDQTlTlF2gKD40ZIWQCeQt9ZuMCWNgkdXtxrBH27iqRHTW7CkdTrQm?=
 =?us-ascii?Q?83/AhTDCKNoDUwajWP36+qd14HMwLChZbMfb8npN2HwpfO1aUHcgzluhb273?=
 =?us-ascii?Q?439/WMRJH+BKAeXKs1NckMSab/aGa2TY7iUdUucXppGCrEs0oiYRpUMtj7v7?=
 =?us-ascii?Q?muQB38miCQQNywNrGXY2YL1srSHYgYN27aWxG1aP7wcuA/1ebvQVxn/c280H?=
 =?us-ascii?Q?q2RQtda8K6+Vt5HfPsMSecgBfvv8jmPIh3ilR/9A7r73AANTXqy5gRExkKLl?=
 =?us-ascii?Q?QQq22N7QEyinNP7LquJzkcGlKeM6XpsviqOixCaddm/CbujWsCGIG2GGfjZh?=
 =?us-ascii?Q?XTlTSsgo58BBBiioMNhFhBXsNNPLJ5+4UUt7p7SXkjNaLrW2kthNlG4w5yQu?=
 =?us-ascii?Q?dnFqyMt9soj/kQ7nLbX+G/If6gbVjKsv/D8BLWOeAjLl3JEiSMsfBk4R0yZX?=
 =?us-ascii?Q?IieNH+kzevp0632V383/WTKN7E3ZkG8tIhCwC00TcFJMG+YMHz7VYkz7Fd3z?=
 =?us-ascii?Q?UvtnMXf0IzYk7nmqTxhMR7qU68d9IZx8RgSqys0CYIF4m6uyF/EdYimMKXPO?=
 =?us-ascii?Q?8w4CeFcarKsR1o/DfAxpx7IFClKBLO+IdMcRLLvW7i+pFuFDacqSoktysZMV?=
 =?us-ascii?Q?iXsacSU6mdeBRP2AtKa5gUG8LJvs0tMNthKNBuHsIVa0kCwQEqcq6KxQgrV4?=
 =?us-ascii?Q?bel+7xolJci3FOaR4fUZNHklGzTF2M8J4RNYl3SDpjrp4+J9tGsa76FBl3RQ?=
 =?us-ascii?Q?jy9NQUmWMqzUyGmuXs1KVuSNFSvLtRKvtBcpRVDfVbvdSh2QcFdBOs7nfc0g?=
 =?us-ascii?Q?a7M6PHBapA5nOe6xiCmluK00nPPz/bT9Yl1TtzyxL19tofVtyCc8yzhNp4pw?=
 =?us-ascii?Q?xXLMMTmW8u6o3ayN+5MwijCPtA9L9rugUQSETcHR+GUSrylXQ0csDgcUMaBg?=
 =?us-ascii?Q?a+U8ZSrbBveaZEOV879gXZNRqGtEFbjeP4mLehx8uPjBgunQalvNZMNJ0Edm?=
 =?us-ascii?Q?e1Gi6Xw+Qn6hRn0X0FGrDHURWcVcSuwIpuhIDfeLMZRFRqIkIBO7ZIucVLyX?=
 =?us-ascii?Q?blt50oC0JrKEB9TjGihIdsHy6HBH4dnmvg2WDcDfMm7Gn4tfmuZWgYdJOXZW?=
 =?us-ascii?Q?5zY2K3LX0ILjB4KNrpIDbHGz1kdSmWUsIEsnbpD3MkJ2r4NOHfmD8rsKx0ib?=
 =?us-ascii?Q?tJQkvXeCUaw4x9zEm2+aKQIQUSpJUiv7fG0E7f5fUNou6df3reLaUmHcLbDB?=
 =?us-ascii?Q?oaKqYrA/MI1fviC9CHXpKoAV6XHSef16n6PZtL8ZxkQ90bzAIzn6r6E3ldUk?=
 =?us-ascii?Q?XYxAXKGv7XnaZQkJQKtnrdvgezLEiCg7gzmWddpgLepWlZhgDr/KsFuGyA8l?=
 =?us-ascii?Q?LKQ+tAv4ULMt780sQY1At6d0CRvwJjtwNg1LZQjHyTQju7OfUF3z54bsagt4?=
 =?us-ascii?Q?nGJPQYVzdW+odXqjXZLfijX/r7aQCGTDVdvPQEz9B4RgVcGkOkzepOuVphlN?=
 =?us-ascii?Q?nri+Mnw17eq5PrVWTXWzCyKPdeIiUck0RYk7bj43Y2eCbIJZAT3JeZY1+94n?=
 =?us-ascii?Q?CsPDA1BPmQMf7q0gZRjIlmO7KRQ10gJrgCa6l/OO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c1a05c-d129-4b3d-b842-08db161b25ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 03:56:45.4567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Atl3UcxsYekgJVrBbA5b755eqfZuq8Y0RDXx7CnLBewcMEyQAdJs8/tST+H3rmQh9ouynMyZWwCG/JatU8aoPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6321
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, February 24, 2023 11:44 AM
> > > Upon reflection we can probably make it even simpler and just have a =
0
> > > length fd array mean to use the iommufd the vfio_device is already
> > > associated with
> > >
> > > And the check for correctness can be simplified to simply see if each
> > > vfio_device in the dev_set is attached to the same iommufd ctx
> > > pointer instead of searching the xarray.
>=20
> How about the hot reset info path? We can still keep reporting the
> current information to userspace. Isn't it?

No need to change that. It's already reported per device.

>=20
> another tricky question. If user passess iommufd down for reset
> in the vfio iommufd compatible mode, should we support it as
> well?
>=20

I don't see why we want to ban it. It does change the result from
error (vfio container) to success (iommufd vfio-compat) when using
the container fd/iommufd. But do we actually have a use case
relying on such error pattern?

On the other hand an user who knows the presence of vfio-compat
should be allowed to pass iommufd to reset even when it still uses
the legacy group/container interfaces.

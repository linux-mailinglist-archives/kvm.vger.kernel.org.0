Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689986BE5F9
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 10:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjCQJxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 05:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjCQJxa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 05:53:30 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A215C9F9;
        Fri, 17 Mar 2023 02:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679046802; x=1710582802;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6ascBtac+n0q8+oIm862fWbzWqnGWlkqMWxkrvXDHqo=;
  b=ji4HpCUkmI7iQymkozdeTHXqkgWyNn0sIXBcFMkcvA62+oVNndccsVeQ
   wLINWRUOqEFv8W/fKQk1EPv9yW2NJHWOPfylAZaH6mptplJ7TP5ZHkkSn
   XIspn8Wq4nq5J6Jrje/idLdogFrZOVYa/Ai/hD7cUS3Vk2rQqE4t3s/Ho
   h8NdO5fvLx3Im6sNENMdtnM9DsKoWgp3DH5aXqwboQ8YWR/A56Xte44n7
   wwcjFfFfi5uQXFS/gw0+LOwt9AWXARHwxHYZzy/h3r3kjRCm6pQe2TSES
   pQBOV4GUQJXbLvlyxe3X70A0HrLHh7vqIh0fGj8DAg3/vmdnrjUWEr/Hh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="336924473"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="336924473"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 02:53:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="749200490"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="749200490"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 17 Mar 2023 02:53:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 02:53:21 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 02:53:21 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 02:53:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 02:53:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDoV2eJLBFJPLgetzYCLL8L/bHdUISKibeJs/cYi6ihJMVkCz/2O0xfonXyH5CIdpUGCf/q9Kql1rbYFvhOIYPn+l46+hzccyUNLdEf7/4gYjGVWRu5uuE0Te1/iGbiitZiqasY3JQY9aPZGHj/9nipaBIprSruWD7ynCgZVAmOOF+NmAWYuhyQamp0tr/5Uyw04rVNRM4AKpPE2y4gujRbMxfP3k3NgSwW9UdT02I8IbJ/z1wDtmpfB+AQWsHlMmY3O5bIFNREx2GFGlz5kHBXM49wHY3iGcc7LEn0r6T4LsKQ45RKa4NXbeXsDVOUXn/91AeHWUmB3OFCGUTtFzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9G/degk0sQPQvFxSGyDysNWiz8OG/Eb5gsM89g5Cw4=;
 b=LUPw9tSQnPOwhAjabslT1zAsktPa9iiQrj/rVHDfKB1In1VagSVYzM6iKSe2G8fzF/kYsDgo5xIKiuGq1mKZvczCgHJ6SjOVyQvwnKnFzkOLB5fQy7JhErdVUZmKhY5Bm8wzChpyndmQZp8wWWkDnjGNaH/kj9JoXHOu9LY6gmUam/WlFmDyT60I6dshCiAphIK4N2O4q4WJVYxt5izMVIWPrhejiFclJ5YbVqNcNs29NCQ3VgGAnAqAUxwNOswu06Zb9VjBD/kgfACzxTso14gHYT2E+ynFWS3ceVDh6Qk+qAgQt21C3u9ler8JVpIQYdLtlpbc4TpEqf89wWWNkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB5873.namprd11.prod.outlook.com (2603:10b6:806:228::11)
 by BL1PR11MB5496.namprd11.prod.outlook.com (2603:10b6:208:314::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 09:53:18 +0000
Received: from SA1PR11MB5873.namprd11.prod.outlook.com
 ([fe80::8610:e88d:1718:d8fc]) by SA1PR11MB5873.namprd11.prod.outlook.com
 ([fe80::8610:e88d:1718:d8fc%8]) with mapi id 15.20.6178.031; Fri, 17 Mar 2023
 09:53:18 +0000
From:   "Xu, Terrence" <terrence.xu@intel.com>
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH v7 00/22] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v7 00/22] Add vfio_device cdev for iommufd support
Thread-Index: AQHZWAajlp3zjdPRyUiZt0ZLeI+9cK7+ugzA
Date:   Fri, 17 Mar 2023 09:53:18 +0000
Message-ID: <SA1PR11MB5873BB60E6AD328C303918ACF0BD9@SA1PR11MB5873.namprd11.prod.outlook.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
In-Reply-To: <20230316125534.17216-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB5873:EE_|BL1PR11MB5496:EE_
x-ms-office365-filtering-correlation-id: c602526e-d862-47f8-45c2-08db26cd6f49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RCa2/nq8TP6FXPXGiJnqnQ0iRTW34EFHDrlFt4HQxtvtHEsOb7rY6kKS8J2v2DvWhMDtnvdOZQAKAnmM6ggvtLeXafzZaK4PhDP1K7l1X4B2woMZ35dqKVm/HoCnoDxTIjambjaFoe6RmIxkmHtudL7XC8FttYUU3GYNDC62ywL0Omj9CZEwvJCNQ5/FrBWQiA/cIZxTqPe1XCNnfNXAqS59E5Ol2XkFCmBEcZ/H93vDHRZU9JDcIt8q04+Pql3A/jSwocUqjGEhYUEKBYfHkcBo6UdpEr/wMIHN+HliFMh0nR3Y5jCJODTWbaoYrRhSFVGipmN/t3Eu0NQl0QOvm7zEDqm25n0XPpzs2/RMRZVJcERRd6oFcim2Qs32v3NBmTJ3j66ZpfU5yzUsTHtnfw8GRKHNDHWvoU1B9x5p1gi8ynWTsn4/QNh/mlh+J3X5ASj325nPLOoEcwxtgtljH7MQDBPboBD2mKalQJSKjueodOp3AfATy4EM3ATG0vsGavji1EfMvckKcUDvZkD8PGotdCzsLuTpyTiE5n+bYhxi0FHNtpvk2xWpF+Zgo8LHOiD/czrAlfOwcImws6sEF1zE8V6DJu9nY8UmIh3YrIaHEUqw4h6Ammyxi5h2qP/JF5Z6CduB1ck0tbanW5tpLJ8Hm/p7DBFHcw5bnXKs5lfJT4f+irMgCckjjv4iohY0vKNxdlOEXSb3jTTxfi6NUTolDGXbA5eVTIHEtGAV5zQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5873.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(346002)(366004)(376002)(451199018)(33656002)(7696005)(7416002)(5660300002)(52536014)(41300700001)(8936002)(2906002)(38070700005)(38100700002)(86362001)(122000001)(82960400001)(71200400001)(45080400002)(66946007)(8676002)(66446008)(478600001)(66556008)(66476007)(76116006)(64756008)(966005)(4326008)(55016003)(54906003)(83380400001)(6636002)(110136005)(316002)(186003)(26005)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u3cYjA/zP1UghaNa94PJ08mnK5LHprHaDXxisWRqxnDF7/k3qMZVNvwMvO9M?=
 =?us-ascii?Q?jwh8x6VDKXoJ5rEOuOB12a0bMhDFKZ+4V4Rq4r4qAVZqgQ8fwF7i3Y6ZxL8k?=
 =?us-ascii?Q?p69SK1FPUiAGXcOFb7dYY5tNhQR+D/8DX7icPH1hf8P4+pxeHu9pNsat+rET?=
 =?us-ascii?Q?peXOhB7Fj12aJhZbbXX29QWWawyWesoKYGwuY35eeY7BgOWbpsZNlAkbZxBa?=
 =?us-ascii?Q?z7IZkCXh5MpIYBf0FnsuzHD7BRCwYsGi+ytE5APdgtMB6GvAiUy8542+1oEj?=
 =?us-ascii?Q?KQw4OOW2CMm8t0or37uqmUAIIEvN06KQryr6hi6rI7fkwkLD1xmmciizx7Mg?=
 =?us-ascii?Q?Dr3qeIjqh3ocIniWFO9CXLMKaDn6vV3G7cAnOn+d8cNsMtCkI7G+ERoX8APC?=
 =?us-ascii?Q?I2jRTScer5TnVdt7gMeM4VrwFW32o0da+LHIlbWxig+M1cCT1qUTsL0UuSZW?=
 =?us-ascii?Q?RPGnGZlkmqyU0tztFhRRGSUDM7z2xrhyZiJPaqMFsOv4r2iiSDqzC6O0ovzb?=
 =?us-ascii?Q?xrFr/RwD2ek0ekIojqW9xvJrBKs68M/lFP56nD/n5nKksWPMPDDb019pdn+H?=
 =?us-ascii?Q?+XjyX7eJMqGKXYo7/CRNgqgQQhqYs01BLUjRXPqXykP7BEIHzgaYj1cHAQBX?=
 =?us-ascii?Q?XbOMv55h+zz3Dm6xofMomDCoBp8kROCd+Stm+8sgk+MNHYMqsBFi7pBaJSsX?=
 =?us-ascii?Q?8WG+GUzcR7DwNGXINAF0mflxG5E0cZEjz5tQDN+iQwnyVayd6a3wLtrMLl2K?=
 =?us-ascii?Q?SWmUEnC/pxkYxUdDiOR3rQ4Qk4p1XuY2+xvnAnVpfD2U2jpFEtCxVmf/oHdu?=
 =?us-ascii?Q?ArN/6aF7F4SOVL5MeHRvkCYoK1wcLk8QmfW94h9ronucu68dkofm1P+QD4uh?=
 =?us-ascii?Q?JBE2TXpOWOVAxJoElUyqoWCOTripS4aMTs3dFRJzGsuAhUxM1lQ7gDjHP09h?=
 =?us-ascii?Q?J5iVA9hGdtLAvABDHG7CSxxCrpsPAJZ+SDQnpMaSAbwdGAY0BTFg7tFWrcEG?=
 =?us-ascii?Q?8d/RW9Ky+i9uGKMGysCXLEj56rTr3m9pHMlLoUwTFMGGleut9mKluT6HQTji?=
 =?us-ascii?Q?Exe/b00CJfjAqE4AutqYr79I3XPfLbwq6w/b0epPQQ5Bfrl3ns9iQiMboCCd?=
 =?us-ascii?Q?5+5G4wxm/TRM1qN1NQKUNNnr6Zy4kLxaZpejMGma2JRYOnnnImFweOb9wrxr?=
 =?us-ascii?Q?P6IdNetCanINTUlDYPklHf+SJ7kz0WPRjAhbgu46fBc0nWS97DcjXQ6VJ8k7?=
 =?us-ascii?Q?5vzHJI699GsqtKdSjAHW/dS1LYpzHtokI6u5cujknC+rPmBevljjP3XwC+FZ?=
 =?us-ascii?Q?1d35quUaQU7N9DYJsndFXAz5NUN/ZUaL7kGLMpv2fj9JEVkGiHxcI8wzxJiJ?=
 =?us-ascii?Q?YEZYF3T2mFnO3U9M+hk0U+H9MpkILlZ/P0J64DSi3w+NiU/8qaqbE1z1AwY2?=
 =?us-ascii?Q?x2FtEpLcvM25n8VzcddHmF8PmXWfXsy1mfYCC/eFl4SWZgOZXE8JPGIs3Y3e?=
 =?us-ascii?Q?o5Ysh8K62fhPUbXtiMJZyqnH6OUaCpPblpcm2yrgcI9Nd0I3lUhiIEZlIU7c?=
 =?us-ascii?Q?yf2Y03P6pHRi+HcAo6vDaQXHmtiefpnBaFZE6gYL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5873.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c602526e-d862-47f8-45c2-08db26cd6f49
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 09:53:18.0125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rqgcdleRPQ9cyen6sucOimoQ/hpilUbDxyStXImwJoShu3IWTJ8JaADxBIp0LV6P/aZE/F4mAsOL1Yeu4dulNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5496
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> -----Original Message-----
> From: Liu, Yi L <yi.l.liu@intel.com>
> Subject: [PATCH v7 00/22] Add vfio_device cdev for iommufd support
>=20
> Existing VFIO provides group-centric user APIs for userspace. Userspace
> opens the /dev/vfio/$group_id first before getting device fd and hence
> getting access to device. This is not the desired model for iommufd. Per =
the
> conclusion of community discussion[1], iommufd provides device-centric
> kAPIs and requires its consumer (like VFIO) to be device-centric user API=
s.
> Such user APIs are used to associate device with iommufd and also the I/O
> address spaces managed by the iommufd.
>=20
> This series first introduces a per device file structure to be prepared f=
or
> further enhancement and refactors the kvm-vfio code to be prepared for
> accepting device file from userspace. Afte this, adds a mechanism for
> blocking device access before iommufd bind. Then refactors the vfio to be
> able to handle cdev path (e.g. iommufd binding, no-iommufd, [de]attach
> ioas).
> This refactor includes making the device_open exclusive between group and
> cdev path, only allow single device open in cdev path; vfio-iommufd code =
is
> also refactored to support cdev. e.g. split the vfio_iommufd_bind() into =
two
> steps. Eventually, adds the cdev support for vfio device and the new ioct=
ls,
> then makes group infrastructure optional as it is not needed when vfio
> device cdev is compiled.
>=20
> This series is based on some preparation works done to vfio emulated
> devices[2] and vfio pci hot reset enhancements[3].
>=20
> This series is a prerequisite for iommu nesting for vfio device[4] [5].
>=20
> The complete code can be found in below branch, simple tests done to the
> legacy group path and the cdev path. Draft QEMU branch can be found at[6]
>=20
> https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v7
> (config CONFIG_IOMMUFD=3Dy CONFIG_VFIO_DEVICE_CDEV=3Dy)
>=20
> base-commit: d28283a0c30d2f3c82d78fbe27f258671b6dc535
>=20
> [1]
> https://lore.kernel.org/kvm/BN9PR11MB5433B1E4AE5B0480369F97178C189
> @BN9PR11MB5433.namprd11.prod.outlook.com/
> [2] https://lore.kernel.org/kvm/20230316121526.5644-1-yi.l.liu@intel.com/
> [3] https://lore.kernel.org/kvm/20230316124156.12064-1-yi.l.liu@intel.com=
/
> [4] https://lore.kernel.org/linux-iommu/20230309080910.607396-1-
> yi.l.liu@intel.com/
> [5] https://lore.kernel.org/linux-iommu/20230309082207.612346-1-
> yi.l.liu@intel.com/
> [6] https://github.com/yiliu1765/qemu/tree/iommufd_rfcv3 (it is based on
> Eric's
>     QEMU iommufd rfcv3
> (https://lore.kernel.org/kvm/20230131205305.2726330-1-
> eric.auger@redhat.com/)
>     plus commits to align with vfio_device_cdev v7)
>=20
> Change log:
>=20
> v7:
>  - Split the vfio-pci hot reset changes to be separate patch series (Jaso=
n,
> Kevin)
>  - More polish on no-iommufd support (patch 11 - 13) in cdev path (Kevin)
>  - iommufd_access_detach() in patch 16 is added by Nic for emulated devic=
es
> (Kevin, Jason)
>=20
> v6: https://lore.kernel.org/kvm/20230308132903.465159-1-
> yi.l.liu@intel.com/#t
>  - Add r-b from Jason on patch 01 - 08 and 13 in v5
>  - Based on the prerequisite mini-series which makes vfio emulated device=
s
>    be prepared to cdev (Jason)
>  - Add the approach to pass a set of device fds to do hot reset ownership
>    check, while the zero-length array approach is also kept. (Jason, Kevi=
n, Alex)
>  - Drop patch 10 of v5, it is reworked by patch 13 and 17 in v6 (Jason)
>  - Store vfio_group pointer in vfio_device_file to check if user is using
>    legacy vfio container (Jason)
>  - Drop the is_cdev_device flag (introduced in patch 14 of v5) as the gro=
up
>    pointer stored in vfio_device_file can cover it.
>  - Add iommu_group check in the cdev no-iommu path patch 24 (Kevin)
>  - Add t-b from Terrence, Nicolin and Matthew (thanks for the help, some
> patches
>    are new in this version, so I just added t-b to the patches that are a=
lso
>    in v5 and no big change, for others would add in this version).
>=20
> v5: https://lore.kernel.org/kvm/20230227111135.61728-1-yi.l.liu@intel.com=
/
>  - Add r-b from Kevin on patch 08, 13, 14, 15 and 17.
>  - Rename patch 02 to limit the change for KVM facing kAPIs. The vfio pci
>    hot reset path only accepts group file until patch 09. (Kevin)
>  - Update comment around smp_load_acquire(&df->access_granted) (Yan)
>  - Adopt Jason's suggestion on the vfio pci hot reset path, passing zero-=
length
>    fd array to indicate using bound iommufd_ctx as ownership check. (Jaso=
n,
> Kevin)
>  - Direct read df->access_granted value in vfio_device_cdev_close() (Kevi=
n,
> Yan, Jason)
>  - Wrap the iommufd get/put into a helper to refine the error path of
>    vfio_device_ioctl_bind_iommufd(). (Yan)
>=20
> v4: https://lore.kernel.org/kvm/20230221034812.138051-1-yi.l.liu@intel.co=
m/
>  - Add r-b from Kevin on patch 09/10
>  - Add a line in devices/vfio.rst to emphasize user should add group/devi=
ce to
>    KVM prior to invoke open_device op which may be called in the
> VFIO_GROUP_GET_DEVICE_FD
>    or VFIO_DEVICE_BIND_IOMMUFD ioctl.
>  - Modify VFIO_GROUP/VFIO_DEVICE_CDEV Kconfig dependency (Alex)
>  - Select VFIO_GROUP for SPAPR (Jason)
>  - Check device fully-opened in PCI hotreset path for device fd (Jason)
>  - Set df->access_granted in the caller of vfio_device_open() since
>    the caller may fail in other operations, but df->access_granted
>    does not allow a true to false change. So it should be set only when
>    the open path is really done successfully. (Yan, Kevin)
>  - Fix missing iommufd_ctx_put() in the cdev path (Yan)
>  - Fix an issue found in testing exclusion between group and cdev path.
>    vfio_device_cdev_close() should check df->access_granted before headin=
g
>    to other operations.
>  - Update vfio.rst for iommufd/cdev
>=20
> v3: https://lore.kernel.org/kvm/20230213151348.56451-1-yi.l.liu@intel.com=
/
>  - Add r-b from Kevin on patch 03, 06, 07, 08.
>  - Refine the group and cdev path exclusion. Remove
> vfio_device:single_open;
>    add vfio_group::cdev_device_open_cnt to achieve exlucsion between
> group
>    path and cdev path (Kevin, Jason)
>  - Fix a bug in the error handling path (Yan Zhao)
>  - Address misc remarks from Kevin
>=20
> v2: https://lore.kernel.org/kvm/20230206090532.95598-1-yi.l.liu@intel.com=
/
>  - Add r-b from Kevin and Eric on patch 01 02 04.
>  - "Split kvm/vfio: Provide struct kvm_device_ops::release() insted
> of ::destroy()"
>    from this series and got applied. (Alex, Kevin, Jason, Mathhew)
>  - Add kvm_ref_lock to protect vfio_device_file->kvm instead of reusing
>    dev_set->lock as dead-lock is observed with vfio-ap which would try to
>    acquire kvm_lock. This is opposite lock order with kvm_device_release(=
)
>    which holds kvm_lock first and then hold dev_set->lock. (Kevin)
>  - Use a separate ioctl for detaching IOAS. (Alex)
>  - Rename vfio_device_file::single_open to be is_cdev_device (Kevin, Alex=
)
>  - Move the vfio device cdev code into device_cdev.c and add a
> VFIO_DEVICE_CDEV
>    kconfig for it. (Kevin, Jason)
>=20
> v1: https://lore.kernel.org/kvm/20230117134942.101112-1-yi.l.liu@intel.co=
m/
>  - Fix the circular refcount between kvm struct and device file reference=
.
> (JasonG)
>  - Address comments from KevinT
>  - Remained the ioctl for detach, needs to Alex's taste
>=20
> (https://lore.kernel.org/kvm/BN9PR11MB5276BE9F4B0613EE859317028CFF9
> @BN9PR11MB5276.namprd11.prod.outlook.com/)
>=20
> rfc: https://lore.kernel.org/kvm/20221219084718.9342-1-yi.l.liu@intel.com=
/
>=20
> Thanks,
> 	Yi Liu
>=20
> Nicolin Chen (1):
>   iommufd/device: Add iommufd_access_detach() API
>=20
> Yi Liu (21):
>   vfio: Allocate per device file structure
>   vfio: Refine vfio file kAPIs for KVM
>   vfio: Remove vfio_file_is_group()
>   vfio: Accept vfio device file in the KVM facing kAPI
>   kvm/vfio: Rename kvm_vfio_group to prepare for accepting vfio device
>     fd
>   kvm/vfio: Accept vfio device file from userspace
>   vfio: Pass struct vfio_device_file * to vfio_device_open/close()
>   vfio: Block device access via device fd until device is opened
>   vfio: Add cdev_device_open_cnt to vfio_group
>   vfio: Make vfio_device_open() single open for device cdev path
>   vfio: Make vfio_device_first_open() to accept NULL iommufd for noiommu
>   vfio-iommufd: Move noiommu support out of vfio_iommufd_bind()
>   vfio-iommufd: Split bind/attach into two steps
>   vfio: Record devid in vfio_device_file
>   vfio-iommufd: Add detach_ioas support for physical VFIO devices
>   vfio-iommufd: Add detach_ioas support for emulated VFIO devices
>   vfio: Add cdev for vfio_device
>   vfio: Add VFIO_DEVICE_BIND_IOMMUFD
>   vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
>   vfio: Compile group optionally
>   docs: vfio: Add vfio device cdev description
>=20
>  Documentation/driver-api/vfio.rst             | 133 +++++++-
>  Documentation/virt/kvm/devices/vfio.rst       |  52 ++-
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |   1 +
>  drivers/iommu/iommufd/Kconfig                 |   4 +-
>  drivers/iommu/iommufd/device.c                |  75 ++++-
>  drivers/iommu/iommufd/iommufd_private.h       |   2 +
>  drivers/s390/cio/vfio_ccw_ops.c               |   1 +
>  drivers/s390/crypto/vfio_ap_ops.c             |   1 +
>  drivers/vfio/Kconfig                          |  27 +-
>  drivers/vfio/Makefile                         |   3 +-
>  drivers/vfio/device_cdev.c                    | 300 ++++++++++++++++++
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c             |   1 +
>  drivers/vfio/group.c                          | 154 ++++++---
>  drivers/vfio/iommufd.c                        | 104 +++---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   2 +
>  drivers/vfio/pci/mlx5/main.c                  |   1 +
>  drivers/vfio/pci/vfio_pci.c                   |   1 +
>  drivers/vfio/platform/vfio_amba.c             |   1 +
>  drivers/vfio/platform/vfio_platform.c         |   1 +
>  drivers/vfio/vfio.h                           | 237 +++++++++++++-
>  drivers/vfio/vfio_main.c                      | 227 ++++++++++---
>  include/linux/iommufd.h                       |   1 +
>  include/linux/vfio.h                          |  29 +-
>  include/uapi/linux/kvm.h                      |  16 +-
>  include/uapi/linux/vfio.h                     |  89 ++++++
>  samples/vfio-mdev/mbochs.c                    |   1 +
>  samples/vfio-mdev/mdpy.c                      |   1 +
>  samples/vfio-mdev/mtty.c                      |   1 +
>  virt/kvm/vfio.c                               | 141 ++++----
>  29 files changed, 1361 insertions(+), 246 deletions(-)  create mode 1006=
44
> drivers/vfio/device_cdev.c
>=20
> --
> 2.34.1

Tested GVT-g / GVT-d VFIO legacy mode / compat mode / cdev mode, including =
negative tests. No regression be introduced. =20

Tested-by: Terrence Xu <terrence.xu@intel.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921F76D5E7A
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 12:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbjDDK7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 06:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbjDDK71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 06:59:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8C77283;
        Tue,  4 Apr 2023 03:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680605816; x=1712141816;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=P5BhoZpd2UF+SowrAozb+tkTikx48AyNhuXfzbX1Yuw=;
  b=b4vi4kbgLjaiS/OJ+sYaDRbyPBlN9m8mf9FFG7NydQnSsRw9nImkleRC
   OACVTkifevz2r2YjKGHMzJX/7N5q1WgFi5FQKhZTIthCZ94jV3C9/jzo0
   0j2diZG4lXuqVlMtO2lb0byRqZljguPet+StlFMf/g45xhgPDH/rjbRt1
   ntx9hRpfm3Ue3AZ/Z90qycrU77Mj/tr288HxHFQVbPK+Oy5B52ZsCyuaC
   7h3LX6LHbDCaLF4YD5yfmNwmKxFZEOTfa3B9V1ua/zh2fU4dmBVnlVY88
   pJrEVGjXaCJ/7ZFCVExdyKaJbOo04qQ6VDAd1Zg/I3uNd067mx3qj0rIS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="404913749"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="404913749"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 03:55:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="688852653"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="688852653"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 04 Apr 2023 03:55:33 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 03:55:33 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 03:55:32 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 03:55:32 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 03:55:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQ6mZUW7jBHTh0wA2gMzJ/JUIRmH5xGmOGGGOw28iP8GtAuczlifzlVyQoDbhogKQVkgFpRIv18lsrXrvDehFa6ept7tCeuLxdpW4AEzn2cZvDsKxRqQfnKVm7l6+koGmj8cgKsK0tT6htxzo0PrWvDDsjmZmp2duMov1YeQeHpLhJIGsG5+rche+53wHZHb/u3CyAMJkWa+spESda7/KR/v4iW0pqKNVRc6H32p3WXEWv0IRAREOZqsoma7+oTHhms+6o4TwO5v8IlUYDA27J9ZGZToNNBZaVbSTGvK5n92FMVDzH78F/9wtGyDKAVxe2NXx1rzjrlkCctbObF4/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFq0o/3O8rWCCK2WoHss7xHUlxJOxeMGOAMyajb1mvA=;
 b=hwXgvUtv5iUM+nE7WtWUUlBvuajFdg8C8kmT5IqsaYsP/UjkZzVrThiG9+7WLFDt8D+Sht3wSmVUSuxWAsAAyi5EWhlm+93ymnZPDXFiSPI4Rk9aDVpOYmmylFoR+qHm1OOKD8y7eXTkxt2/yH2WEUdXh0U7xjHIZa8zs56XtnZL7CtPZNHnSDDRMYjqjpMRE7uqpsC0ZDsdO5fqdjWmmH7ZtmAba2CCR20R9cZRw9wZTkcbrI1W5TUjuBFShRHi7Si0Lk8RW04WO+jXhzP11g/iGY0aoeQWGnCcdkjtgWcBLcEaEY1R+yhQGtkr86gPZhhDT1RAXi0rFCdo5iQ7GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10)
 by IA1PR11MB6122.namprd11.prod.outlook.com (2603:10b6:208:3ee::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 10:55:30 +0000
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::da0a:8aab:d75b:55f1]) by SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::da0a:8aab:d75b:55f1%3]) with mapi id 15.20.6254.033; Tue, 4 Apr 2023
 10:55:30 +0000
From:   "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>
Subject: Re: [PATCH v3 00/12] Introduce new methods for verifying ownership in
 vfio PCI hot reset
Thread-Topic: Re: [PATCH v3 00/12] Introduce new methods for verifying
 ownership in vfio PCI hot reset
Thread-Index: Adlm3sEehLm8hnrOT/O7mqe62qp6xw==
Date:   Tue, 4 Apr 2023 10:55:29 +0000
Message-ID: <SJ0PR11MB6744E1F46B64AD449D86E71C92939@SJ0PR11MB6744.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB6744:EE_|IA1PR11MB6122:EE_
x-ms-office365-filtering-correlation-id: 93c63105-1b2a-49d0-1d52-08db34fb1afa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X39wNOnDWRT5xVmxQhXpPn2WqXfRPpf8jgSKTAvx70MOgO0+S3D0cfw4mYxI701YG3ECIGU7dU3i6LStcB9/RDWP3fG23Ys4edtrwgUtstkwshehl2IFnDR/DAHOVavYeG1dxifqqPFZiZ0O7F/YQMtbKHKgIjAURINtyknN9PU4YpSqLFQ0DTEw44TxYB7cQEvRsGFluyK3t71qo1Gc4d9CnqfUimatTdM//28A9CI2mXCLDA72ZlptKEPIM+8GjiEZQZIYRpQfv3ahgZxUJi2GxxWBDxqKqSO3BqUUZ6Aaj3wGQnUoGWDdwCV60xs8Yxu25XGr2XFFopuCmi2InzerseXZFb9NymltoyhJfcLJSomLwtIBsd7IMAziT38GqS1U/DjMkxjae1nm1FyNc2sc1H+o5cqdwg3HJTGoILzHZaZITannXdBwm2KE4CeXesGhRZgKNyQiEFEkYtXcLsm4y/DykXWKEHT4cbf50jh1WSS5nmLMnKgBPHNoTcmivxWqI5Wa14H5VD0RZUPltE1BN8pE4h8H1DVEoS4RcMCRMeIFYFChdzwF63iPqRKNT9HSdEoZQnAc/HrDRh8CXGpxYY6GvOLE6EsHZwvMxpc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(39860400002)(136003)(346002)(451199021)(7696005)(71200400001)(966005)(83380400001)(55016003)(38100700002)(86362001)(33656002)(38070700005)(82960400001)(53546011)(26005)(6506007)(9686003)(122000001)(186003)(15650500001)(316002)(54906003)(6636002)(2906002)(7416002)(5660300002)(8936002)(41300700001)(52536014)(6862004)(66946007)(4326008)(76116006)(66556008)(8676002)(64756008)(66476007)(66446008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ksGztI5VnJG75LPaFPGlFESSZYdAOaCr1d/rdgYJ6lfaPFJ4gd7VXvaOgiTc?=
 =?us-ascii?Q?ZzrPTd63/Ii3NMJGKbDviIYs2lgg5FQNY/IZ9QYjguCWK8vXtOKweF30mft/?=
 =?us-ascii?Q?ZnH+kgQN8I5Jbui+CmzT2+6PE0gOWUttD2FeEK7xykLWKq4xxP/6LKUp+lWu?=
 =?us-ascii?Q?XDp26L+hO/li/YLI1WxJV3CNHO8i6yqhMREH45X6f8UVlrPsbBrh0bU8DF2+?=
 =?us-ascii?Q?HwFMpSRepsV+sL25RHq99gTFD6UX0HykjBCpc0owC+nHCGFx0zRdBsHtyo5G?=
 =?us-ascii?Q?dSLjq0pLP+kytF6RkaxyKv3LDK3n9wkORHTxqM9r5bm78OUQ7NS/ACjkv6ph?=
 =?us-ascii?Q?2jHvvI/bySaMnn+JV5Zdq7+Eccyk5c2W/kYmOOqjEPRswglbne+1rEvV/Aak?=
 =?us-ascii?Q?cVoz10ld8igCaTSP1Rj9+l+rBe8xdf9GrFTdZ4PNBz4GGC63udLIOa6fxc4Z?=
 =?us-ascii?Q?AECf1yvGnWZHMTeiWxh7cOUGcYGoqixNrJg+AhGAewaFz8o4K8Xn1jtKvIGe?=
 =?us-ascii?Q?UhBDUhg4xMkyuQ+xpq15K39XBDCwaOJJMEw6jDpievQpkYnfXYQ7NCehjGZW?=
 =?us-ascii?Q?C9d4u9mk8xLHZvhfKwB6kNI5MIoGzeff+o5D6HovjJIXSMNI8sOHffLo4/tJ?=
 =?us-ascii?Q?pDoXKqAHsbjRclpe+txMOyWijC9NzN7pApXpSzIKq1rv43kZMtNu4+U5Yq9s?=
 =?us-ascii?Q?jO6XVOChRHbiJArg6j6wljWldF1P6ijhIXxvlxjutxqAUNK3du/qdWMCGjWC?=
 =?us-ascii?Q?38/5oJq0D0pDGXalki4mG5QJvWtBofqZi/+qa1LCAf8bQgRmgZxHJHSfm/S1?=
 =?us-ascii?Q?pS3I1MpNSdOTLLVpjhWptMG4YjU1Ieafh87pM32CTHpzGKt7U0orkr03WCbt?=
 =?us-ascii?Q?zdvGE4woADG34hdI1ustvpvgZgXX/GLoAM6X/yBny4UHxtYp7QaPGxQwCjFj?=
 =?us-ascii?Q?Av4xuexe/QlqUD7u1xXYkit0O5LRnVgoNc3dEWjUatevkkal6QpcxCd1U7XX?=
 =?us-ascii?Q?AbhPiYgv50dKFB0uCE4dUZlxPVwMber5CS1MQqb7sG1fT1gTYjtDnrgNFsvy?=
 =?us-ascii?Q?lfY8r4hCma2OCc2+fBaS1wapHASFNIheIBBkKi4DJdAbx8U2xAYGz5zSP4AO?=
 =?us-ascii?Q?ysZZvyvQLpfCaF/6R7APmqX37aFcEqddWxUckq7R9qU3oEd9CWY7YIUL59EQ?=
 =?us-ascii?Q?6AT3/cr3FWg/faTyNpYw41FRjQdOryOrEd9kKQ+9yEHHjolpFyoLeHx0YTkD?=
 =?us-ascii?Q?m5fPRUa7/mIJCetnhuXqQuQB2hedLh8XOD545hUW9YkWc9VG0QMOPCf30kyH?=
 =?us-ascii?Q?BYhBx/gHVKRH0UZZRLgYSG/Afp5k+HuFaIpHvl45aDXaS71Fp+Qya75PCTfb?=
 =?us-ascii?Q?H2mGzCoKeLAqHIacsmut04xaE8iX4t1ce50sn6rR4dz15QRm4cGJTsom49F3?=
 =?us-ascii?Q?VgJLCrRhyCeZ1X2uX1PmuNZZiW34TiCK9L81O7qjDfTjuUwuRH/vD6pe3FgX?=
 =?us-ascii?Q?SwfIe/kH31R9AurlUCFishvBuhKXJaUX9UpfMIbuCi2M9M8ehRSyR5JX7jII?=
 =?us-ascii?Q?ZZ7SD5ZvfT2aGE+z5E/EKl1IwCF4GUH1PrDAKKjS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB6744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c63105-1b2a-49d0-1d52-08db34fb1afa
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 10:55:29.6611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pM1kwaeejyFZaPqFpJnAw9Gwi2UdZcq8zjs/R1smam7vJiSJVJ5I7+MpH80VcLWLBrsV3gkStofZWNl60llfundzT1Xh9Gti0uzl5RHQQVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6122
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Liu, Yi L <mailto:yi.l.liu@intel.com>
> Sent: Saturday, April 1, 2023 10:44 PM
> Subject: [PATCH v3 00/12] Introduce new methods for verifying=20
> ownership in vfio PCI hot reset
>=20
> VFIO_DEVICE_PCI_HOT_RESET requires user to pass an array of group fds=20
> to prove that it owns all devices affected by resetting the calling=20
> device. This series introduces several extensions to allow the=20
> ownership check better aligned with iommufd and coming vfio device cdev s=
upport.
>=20
> First, resetting an unopened device is always safe given nobody is=20
> using it. So relax the check to allow such devices not covered by=20
> group fd array. [1]
>=20
> When iommufd is used we can simply verify that all affected devices=20
> are bound to a same iommufd then no need for the user to provide extra=20
> fd information. This is enabled by the user passing a zero-length fd=20
> array and moving forward this should be the preferred way for hot=20
> reset. [2]
>=20
> However the iommufd method has difficulty working with noiommu devices=20
> since those devices don't have a valid iommufd, unless the noiommu=20
> device is in a singleton dev_set hence no ownership check is required.=20
> [3]
>=20
> For noiommu backward compatibility a 3rd method is introduced by=20
> allowing the user to pass an array of device fds to prove ownership.=20
> [4]
>=20
> As suggested by Jason [5], we have this series to introduce the above=20
> stuffs to the vfio PCI hot reset. Per the dicussion in [6] [7], in the=20
> end of this series, the VFIO_DEVICE_GET_PCI_HOT_RESET_INFO is extended=20
> to report devid for the devices opened as cdev. This is goging to=20
> support the device fd passing usage.
>=20
> The new hot reset method and updated _INFO ioctl are tested with two=20
> test commits in below qemu:
>=20
> https://github.com/yiliu1765/qemu/commits/iommufd_rfcv3
> (requires to test with cdev kernel)

Test pass with qemu supporting new uAPI, played trick to bypass FLR and tri=
gger
hot reset intentionally. 81:00.0 and 81:00.1 are dependent devices from sam=
e slot
and passed to one VM, see below qemu trace for details.

vfio_pci_hot_reset  (0000:81:00.1) multi
vfio_intx_disable_kvm  (0000:81:00.1) KVM INTx accel disabled
vfio_region_mmaps_set_enabled Region 0000:81:00.1 BAR 0 mmaps enabled: 1
vfio_region_mmaps_set_enabled Region 0000:81:00.1 BAR 3 mmaps enabled: 1
vfio_intx_disable  (0000:81:00.1)
vfio_pci_read_config  (0000:81:00.1, @0x44, len=3D0x2) 0x2008
vfio_pci_read_config  (0000:81:00.1, @0x4, len=3D0x2) 0x142
vfio_pci_write_config  (0000:81:00.1, @0x4, 0x140, len=3D0x2)
vfio_pci_hot_reset_has_dep_devices 0000:81:00.1: hot reset dependent device=
s:
vfio_pci_hot_reset_dep_devices_iommufd  0000:81:00.0 devid 2
vfio_intx_disable_kvm  (0000:81:00.0) KVM INTx accel disabled
vfio_region_mmaps_set_enabled Region 0000:81:00.0 BAR 0 mmaps enabled: 1
vfio_region_mmaps_set_enabled Region 0000:81:00.0 BAR 3 mmaps enabled: 1
vfio_intx_disable  (0000:81:00.0)
vfio_pci_read_config  (0000:81:00.0, @0x44, len=3D0x2) 0x2008
vfio_pci_read_config  (0000:81:00.0, @0x4, len=3D0x2) 0x142
vfio_pci_write_config  (0000:81:00.0, @0x4, 0x140, len=3D0x2)
vfio_pci_hot_reset_dep_devices_iommufd  0000:81:00.1 devid 5
vfio_pci_hot_reset_result 0000:81:00.1 hot reset: Success
vfio_pci_read_config  (0000:81:00.0, @0x3d, len=3D0x1) 0x1
vfio_intx_enable_kvm  (0000:81:00.0) KVM INTx accel enabled
vfio_intx_enable  (0000:81:00.0)
vfio_pci_read_config  (0000:81:00.1, @0x3d, len=3D0x1) 0x1
vfio_intx_enable_kvm  (0000:81:00.1) KVM INTx accel enabled
vfio_intx_enable  (0000:81:00.1)
vfio_pci_hot_reset  (0000:81:00.0) multi
vfio_intx_disable_kvm  (0000:81:00.0) KVM INTx accel disabled
vfio_region_mmaps_set_enabled Region 0000:81:00.0 BAR 0 mmaps enabled: 1
vfio_region_mmaps_set_enabled Region 0000:81:00.0 BAR 3 mmaps enabled: 1
vfio_intx_disable  (0000:81:00.0)
vfio_pci_read_config  (0000:81:00.0, @0x44, len=3D0x2) 0x2008
vfio_pci_read_config  (0000:81:00.0, @0x4, len=3D0x2) 0x140
vfio_pci_write_config  (0000:81:00.0, @0x4, 0x140, len=3D0x2)
vfio_pci_hot_reset_has_dep_devices 0000:81:00.0: hot reset dependent device=
s:
vfio_pci_hot_reset_dep_devices_iommufd  0000:81:00.0 devid 2
vfio_pci_hot_reset_dep_devices_iommufd  0000:81:00.1 devid 5
vfio_intx_disable_kvm  (0000:81:00.1) KVM INTx accel disabled
vfio_region_mmaps_set_enabled Region 0000:81:00.1 BAR 0 mmaps enabled: 1
vfio_region_mmaps_set_enabled Region 0000:81:00.1 BAR 3 mmaps enabled: 1
vfio_intx_disable  (0000:81:00.1)
vfio_pci_read_config  (0000:81:00.1, @0x44, len=3D0x2) 0x2008
vfio_pci_read_config  (0000:81:00.1, @0x4, len=3D0x2) 0x140
vfio_pci_write_config  (0000:81:00.1, @0x4, 0x140, len=3D0x2)
vfio_pci_hot_reset_result 0000:81:00.0 hot reset: Success
vfio_pci_read_config  (0000:81:00.1, @0x3d, len=3D0x1) 0x1
vfio_intx_enable_kvm  (0000:81:00.1) KVM INTx accel enabled
vfio_intx_enable  (0000:81:00.1)
vfio_pci_read_config  (0000:81:00.0, @0x3d, len=3D0x1) 0x1
vfio_intx_enable_kvm  (0000:81:00.0) KVM INTx accel enabled
vfio_intx_enable  (0000:81:00.0)
......

vfio_pci_reset  (0000:81:00.1)
vfio_intx_disable_kvm  (0000:81:00.1) KVM INTx accel disabled
vfio_region_mmaps_set_enabled Region 0000:81:00.1 BAR 0 mmaps enabled: 1
vfio_region_mmaps_set_enabled Region 0000:81:00.1 BAR 3 mmaps enabled: 1
vfio_intx_disable  (0000:81:00.1)
vfio_pci_read_config  (0000:81:00.1, @0x44, len=3D0x2) 0x2008
vfio_pci_read_config  (0000:81:00.1, @0x4, len=3D0x2) 0x140
vfio_pci_write_config  (0000:81:00.1, @0x4, 0x140, len=3D0x2)
vfio_pci_hot_reset  (0000:81:00.1) one
vfio_pci_hot_reset_has_dep_devices 0000:81:00.1: hot reset dependent device=
s:
vfio_pci_hot_reset_dep_devices_iommufd  0000:81:00.0 devid 2
vfio_pci_read_config  (0000:81:00.1, @0x3d, len=3D0x1) 0x1
vfio_intx_enable_kvm  (0000:81:00.1) KVM INTx accel enabled
vfio_intx_enable  (0000:81:00.1)
vfio_pci_reset  (0000:81:00.0)
vfio_intx_disable_kvm  (0000:81:00.0) KVM INTx accel disabled
vfio_region_mmaps_set_enabled Region 0000:81:00.0 BAR 0 mmaps enabled: 1
vfio_region_mmaps_set_enabled Region 0000:81:00.0 BAR 3 mmaps enabled: 1
vfio_intx_disable  (0000:81:00.0)
vfio_pci_read_config  (0000:81:00.0, @0x44, len=3D0x2) 0x2008
vfio_pci_read_config  (0000:81:00.0, @0x4, len=3D0x2) 0x140
vfio_pci_write_config  (0000:81:00.0, @0x4, 0x140, len=3D0x2)
vfio_pci_hot_reset  (0000:81:00.0) one
vfio_pci_hot_reset_has_dep_devices 0000:81:00.0: hot reset dependent device=
s:
vfio_pci_hot_reset_dep_devices_iommufd  0000:81:00.0 devid 2
vfio_pci_hot_reset_dep_devices_iommufd  0000:81:00.1 devid 5
vfio_pci_read_config  (0000:81:00.0, @0x3d, len=3D0x1) 0x1
vfio_intx_enable_kvm  (0000:81:00.0) KVM INTx accel enabled
vfio_intx_enable  (0000:81:00.0)

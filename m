Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0169E6C5D19
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 04:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCWDP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 23:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCWDPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 23:15:25 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7EBEC53;
        Wed, 22 Mar 2023 20:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679541324; x=1711077324;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=beB8gH35cOGeCW5oqqwJxf2zGFt7cIM72AZaq+6unGo=;
  b=Oe/anVsCluyA7T/pCGvpI14/K2Y/9XHHCKg3rR8gMgjKfQgGP/bFLXly
   fuhcPbgZfjWiG/PxFROgBPHsXK7ofXPt3C+EZlCMC6psdpb8euLzlBmk6
   uIwnS+9iCfDkhCapjz4ySQ/9OcHJZaVhyEFSWSCbubv/VolcXRvOPUXd7
   BY5o9okJmEIL6f6cLLoRdWJWtTkiomrJgtwtePqD55Gbpn+38KWVLypwn
   A23USbaKk1YNBXrq4VmsXeVgTBmv4C3ivxvQx2yyVltqqPCPqlX3mYfT+
   Oo7/Ia+ch2ChC8iLi8LIRKuRC27Yf1Noa8I28ORzRzbnPFcxuAi9H4/yC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="367122396"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="367122396"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 20:15:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="684540433"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="684540433"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 22 Mar 2023 20:15:23 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 20:15:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 20:15:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 20:15:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 20:15:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwrXwshe9ARj7mJC8IrameIA7eT55Cs0tpVZHJWk1vhrcq3JAP/5GGyG2n000IklQIXL5EFxZGlxJL6fJJ4/+zv7rvcIVEMf3+vhk5zZQKCjjZ0tpzlkgZAojRSdPvtJgcka3UmP+VDuCOWiiLTPZjqWlQuQ8mC+PhhExMzh0k3I/9vFb8l7vMLP70kxDkr6F5TjJop0aNpwYZIAdXnUpZvE6GGZGU/dKgLmEPtuKjBYv1BlwSCDZEtpSv3iOOpyz7PYlmA2TvLi3N6jgUrqwjiabQ1x9h50A2o+5Df8gk3z4mwltfXwBFRyGGleKxE5JfhaG48jJe9M5HqwZmbN7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KMhijc1+78vKJVYQzR7FsLCgoe6pGO1kH7mUECmBsaU=;
 b=BL3qGYBxbuofe68cGHIeUOdLO0g6OTOdXtXMqkvUoQ8bTJKNZA2t3yYi0S3NnPUfhA99ZzCHW6uhPFKau2PitZOmoNvVfQowWcaGAO4GK4/KGgP6Tiw/2HahfbPOeYIuh6cTcHN5eUDgZF6iA2GvAHTlOcFEhsoTvjCKDZQw1dMknfpYe/CcifrJmAS/0kB12MkmYfjbZZnPIG8LNnmW4Ud2AqQ/VolJ//17pA6L1G92PUnA16OoPJk9i6OrHSg2FiU6zDeKFqBq/84tgFqRL8wahbyJsR/ap6O/5tmdLR1dTRiriY16Ny22VvOvWIWTAdk8xPS5rx5pEVh8pxodFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6322.namprd11.prod.outlook.com (2603:10b6:208:38a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 03:15:21 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 03:15:20 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZW095081R6kW/70aeRy5pC5KSt68ERp6AgAANFoCAAV3gAIAABT4AgACOijCAAHSzgIAAD3jAgAAIX4CAABLsgA==
Date:   Thu, 23 Mar 2023 03:15:20 +0000
Message-ID: <DS0PR11MB7529E2DEEB1CBBC9413A0480C3879@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230317091557.196638a6.alex.williamson@redhat.com>
 <ZBiUiEC8Xj9sOphr@nvidia.com>
 <20230320165217.5b1019a4.alex.williamson@redhat.com>
 <ZBjum1wQ1L2AIfhB@nvidia.com>
 <20230321143122.632f7e63.alex.williamson@redhat.com>
 <ZBoYgNq60eDpV9Un@nvidia.com>
 <DS0PR11MB7529B8A8712F737274298381C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBrx98kqNZs3jeWO@nvidia.com>
 <DS0PR11MB7529E4C6196C8581CD39A7C7C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBsF950laMs2ldFc@nvidia.com>
In-Reply-To: <ZBsF950laMs2ldFc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6322:EE_
x-ms-office365-filtering-correlation-id: 832d8452-eaaf-46f8-7604-08db2b4cd5c8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DDr4ITiHLSodau6UvAFjDDJgqa2gL2NQuhZ5c2Y9XDMa4JNrO0JlPxP61gAfN8iaTbGf2NWXkjk5rUoqmDkp/p6ZjiFZpz9mNhy6iUUbDTY8lH8AbkCvAjDQonoYXgCnAXD1YQ8ua3BmvFRTwSE8gJccstSNvfQB/KyMXOd565KE+Kbiqvp9VjuYFVd7Hro2nGeFtsGdu3DfZ//xhhGNlnKaHPri9jj0fTAZQAsQvAHm2ZGZbiGP47czD73ZEMctiT8yfMXwN4K2tyyB6bJeSyShfpXPOO9QfroLUxzgFTSp4sCNjBF3g+50X65nfZZeCNA/eSKjR2tjbLVxgSyOMj2jGy3QfoDtMvytJvQAGuOvuIpFbDgzyR5eJ3niSODkwaWZ2gY0NoX0YcO76Z1a3Z9PKjXPrkQbOCbc4c20TrfZdS1LvcJqFZ2choSbJxPB0JNq+/fuBy5BXCm1AhEMt/FtmA3NFv6uQ/ztMsPrz2Hqu3RVIKzsJmufwS2BmpaotGcj6FcxPur9m3ibt6nFVjH6nq821jbRqqPr3yMGJgHymb5nKigrnMGlvI0/FxmPJ5c2DlpBCwshtLlAvfgTkpLsW+AT1zSkufKInBOk3XMlbGHyPYFRqM3Wy02u/KGubO5C27vmks7BZEfZrT50U7mfJ0iNdTQVDVOrqV5PryH8EWSHw3Csy/Gxd4jQVgaT6zZrUazVUJQeo3CqjlKprg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(346002)(136003)(396003)(451199018)(2906002)(7416002)(5660300002)(55016003)(82960400001)(38070700005)(33656002)(86362001)(122000001)(38100700002)(83380400001)(64756008)(66446008)(6916009)(66476007)(8676002)(76116006)(66556008)(478600001)(71200400001)(316002)(54906003)(52536014)(4326008)(66946007)(9686003)(186003)(7696005)(8936002)(26005)(41300700001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pbLISY529ff8fWtQSzZ4avT4gOsJMygvwPlU381hNx12Mq9zK7mm0x3H5nYM?=
 =?us-ascii?Q?NzDNKAcbDST3jJ56ykCiPg1RTbdHXxFzwIHK5JdWJXs6alWzeL5S4fRmXxRg?=
 =?us-ascii?Q?ebDJM6sKPPS6By2TDiJiyQOvJrbw1HGmsVXTFhykk362XQlUiek64lyG6ItJ?=
 =?us-ascii?Q?Ezb+hSifxvLIEtZ2CF1eQMKqGxGKsedcZXKMhqC1J0EhwcBj7RnL7hpJHcY9?=
 =?us-ascii?Q?E+NmTBJTcFILkUDD6grceY6ncbMyUc4GSP1OwXo56wa/4qbgL+Fhd9t/R1vg?=
 =?us-ascii?Q?tut86PFS7yRL5P6RDA+u/DlqrCGIEIlFxrx3bsqyPzQ7cwjySW9G5LVGQp6z?=
 =?us-ascii?Q?Awu250NfBKZWdtGushCgU7925tMiJ8zCSWoxcOkSRysW7WuMgyvAB5HQV+3L?=
 =?us-ascii?Q?JYkRtY3LoPqHmbcV2fUBc+dbdqkSodYS+WdpGBEOyRDKpX2P5OSceNMCqRKW?=
 =?us-ascii?Q?mm7EPPfIf90cP76Kt24vK8jkEg2pp7ReRwYTKDsoBoyoZMgWgxSk1gQv89WJ?=
 =?us-ascii?Q?+qRlwQGCRrqeAkripxM+vZOyN8OVqDibC4kyjtkeplCklaFc5nTacLHnexU0?=
 =?us-ascii?Q?VeNrLxTQiPIEwxqOQYjucutg4b3YvU6c5V+KgqZM7slPrtZR7uVwT44cOSGt?=
 =?us-ascii?Q?vcA28/7tve8p61OC36qLBnDD1uV/bTRTd+3mDEUkHIvwEiCZOiLGXtjD6IXo?=
 =?us-ascii?Q?+9HrhIbXe6Z/gJc6TwPqPn3IkGolxpBoe+JLIyngY3RPOGeCNe8MEcJq60rS?=
 =?us-ascii?Q?mLAa/dh8j0PXnJi7Ykx4zgbLqc70ijEjgVv8Z/5tj3SqDDq+BK8z9EEJbjgD?=
 =?us-ascii?Q?hk6jviys3WnZ9ZRKVrd+WGaKVu1zgW2Ghe1oscsq2zaUWoCObo5NSQeFaREq?=
 =?us-ascii?Q?/4cacfGYOHuJhnBgMhbBZET4xR70WETJQTbitmfzvK9L/Oww3Ec59VTYIeeA?=
 =?us-ascii?Q?oim94YQo4UCZoot5oByxORe0xMckqKK3FUqCTzIsETeDwAOBSlXpm0P5G9ij?=
 =?us-ascii?Q?a+iRPri94S8meg0ZgTIt/dK0+3RIM2XlnKHcaD/77KjXcJTncXVdqNsfEpn4?=
 =?us-ascii?Q?SWXbWGkXeCsp3dH1OWpHsftL58t0tYEkT7gxjVzbUjdbuTDsO1n+CEakFpbi?=
 =?us-ascii?Q?DFlfyoHuWpruIakdYPVLbeOubANO9PcPPczMq5BEnkU8j94b1RfS0+KnmFW0?=
 =?us-ascii?Q?NnzydSBfQOSUvCskbSnDIB8PMvz3vfDggxYD9i8YVEHFCpgBcFnGvXsta25y?=
 =?us-ascii?Q?ydYKcphFvvOWXxID3bUixVeUujjZCsFy2qzcJcmBjo+vFyEkON9r+Ma0gGx6?=
 =?us-ascii?Q?1syliWWnt0sVPYjsteA0re4hi42u4/FTYk9owW1ioP9J0k2sOckh10KwvJXa?=
 =?us-ascii?Q?J5zT8YPDcMI6G0Za0BFrUtfnGgjYNFj5evNJrr/BvSLwGdyupA70CqqdFGg8?=
 =?us-ascii?Q?JfnnbsTtZVJ7DBosr/BLpsbQjvAQRyAglCPnX+SgK24wEVO7MlJgzAy6Iz6r?=
 =?us-ascii?Q?JkraNacbFrLXVdUWDjyl7+YU8ZiFKtDqNjKZrfykwa/l7V83yrQAX5VWkVIa?=
 =?us-ascii?Q?1LsgD6mlV0KbsPtJFZ8/ma2IUJqsee4wGg2JuFaw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 832d8452-eaaf-46f8-7604-08db2b4cd5c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 03:15:20.7094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rn9yqqTCeoMgjc8Rf6cDBGNgk3hDjJEJ4a7DdZ3Hi8LBtPa4Ee9eyNIT1nSa/uF2Qccb4kazLh7gpo3PrbPU8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6322
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 22, 2023 9:43 PM
>=20
> On Wed, Mar 22, 2023 at 01:33:09PM +0000, Liu, Yi L wrote:
>=20
> > Thanks. So this new _INFO only reports a limited scope instead of
> > the full list of affected devices. Also, it is not static scope since d=
evice
> > may be opened just after the _INFO returns.
>=20
> Yes, it would be simplest for qemu to do the query after it gains a
> new dev_id and then it can add the new dev_id with the correct reset
> group.

I see. QEMU can decide. For now, it seems like QEMU doesn't store
such the info return by the existing _INFO ioctl. It is used in the hot
reset helper and freed before it returns. Though, I'm not sure whether
QEMU will store the dev_id info returned by the new _INFO. Perhaps
Alex can give some guidance.

> > > I'd probably use similar logic as the reset path, if one of reset
> > > group devices is open and on a different iommufd_ctx then fail the
> > > IOCTL with EPERM.
> >
> > Say there are three devices in the dev_set. When the first device is
> > opened by the current qemu, this new _INFO would return one dev_id
> > to user. When the second device is opened, this new _INFO will return
> > two dev_ids to user.
>=20
> Yes
>=20
> > If the third device is opened by another qemu, then
> > the new _INFO would fail since the former two devices were opened and
> > have different iommufd_ctx with the third device.
>=20
> Yes
>=20
> qemu should refuse to use the device at this moment.

Yes. it is.

btw.  Another question about this new _INFO ioctl. If there are affected
devices that have not been bound to vfio driver yet, should this new _INFO
ioctl fail all the same with EPERM? Or it still just returns the dev_ids
of the devices that are already bound and opened. This seems to make sense
with two reasons:
 - for one, the new _INFO is not designed to give userspace an exact
   affected device list;
 - for two, reset shall fail when checking vfio_pci_dev_set_resettable();
Please feel free to correct me if this is wrong.

Regards,
Yi Liu

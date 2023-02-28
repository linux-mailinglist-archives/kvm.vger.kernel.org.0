Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6222E6A520A
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 04:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjB1DsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 22:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjB1Dr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 22:47:58 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E6E7AB4;
        Mon, 27 Feb 2023 19:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677556075; x=1709092075;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6wqbLT2CAzEkhxWRH425+CE26E5nXaSp5Lx5hQG6Dco=;
  b=dRc5MtSJRqszolO27C7fXMmkk/TR36aRxICPF1y9gHRKmhimaFoi8d3U
   OvWVsh1TrkJR6uPNWVZBzF4QkfZnv8jab0g24B/WM+CKPo0MwaHnzMQw3
   JUV0AuqDkE9JZcLqOHN1D7GKdrjgV8eluGSTOYMtHr1l38yGsgXjyFddU
   qEoS2k3QlKwfONET60IVfTno9mhorLJe+T9qNKbN61923uTEYYG/JrnpU
   Z+KBKiPw0Y8S8BjO56vKh3qh0LPjg5aNzoWsjV2Cl2hMspKuOlHNSO+L4
   LBF0BtFyYPr8F1F7tOnnNt4vMm7Kd+qSzyZbXr8vpFcK+n1+wvi5fTxFI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="317839325"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="317839325"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 19:47:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="673976146"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="673976146"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 27 Feb 2023 19:47:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 19:47:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 19:47:36 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 19:47:36 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 19:47:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSM6q/bPAC4od2m/lY8f0F5NTcbNSUTP6zL3AnXQdtj8YP+GWkt6/YCqiTWMGBW221vxcRgtOqrTywjFY+Gz7YKk7gEpIdE/lT2nBMW5o82jDLhC+Hf7mM6ptkxdUzeKVQFBq3z7dLOH5eBSAYgVDnFNYMPrUNSUXHDkphLk3rw0IGu4sZoFsttFWIZqQUjL/OEDl8Gdp6WLJ4QjY6RfHpvbyHJzNEFjo56IBYRm0sZS/LK0N2fHpxtIE50oF3696JMrjrK9Loh6L1GDqcd9FyFfI/ZE58JaDlZWMEWTx5g2HGhMKyUHavy71f/v2wS0NBpxe2+utX0cpFh0fdu64Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5EQYv8DIuayvflXtAyViHg67IyP9VaN7raWMdIlAKP4=;
 b=CYYaxQHPAU6NEXyqrt2Bf+BrpV3J/XefZrt7C9gW39NOOwTH+AxiAFk5e+BG5mYIB7kmEv+BHtYU7tvsRANAeNQKfwJOmsqflQvyA1nRUdMXOsci0k9zWAPEEUCxTCUqzA8N5R0qd6sl72FfPkMBNQPwZz4QtHQSpKzJF2RGx/0CS06MrRoHp+G9yzifYM4vYhZzIuMNPNRThVf+AF7G8wi0Qebqb63SlbnPrrSEnE1B6P0NCtsWbMAuxELQYm91uQdsjf+ozykNysTHMcUZbuIB2cJIQrtk0+wTgefi6tlvtu0J273tXeWVb9WvpIzjYeiWdn0uP7NeEYAOo4TBAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7797.namprd11.prod.outlook.com (2603:10b6:930:76::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 03:47:34 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 03:47:34 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 15/19] vfio: Add cdev for vfio_device
Thread-Topic: [PATCH v5 15/19] vfio: Add cdev for vfio_device
Thread-Index: AQHZSpxLneNk2Ja5KUyUQHIMf7QuLK7jJP2AgACSoIA=
Date:   Tue, 28 Feb 2023 03:47:33 +0000
Message-ID: <DS0PR11MB7529A1781B854D422B93B5FBC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-16-yi.l.liu@intel.com> <Y/z8tVo1ujcmHBSJ@nvidia.com>
In-Reply-To: <Y/z8tVo1ujcmHBSJ@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CY8PR11MB7797:EE_
x-ms-office365-filtering-correlation-id: d556875d-92a7-41a3-b1b3-08db193e8670
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rq2m/0caJir+9YGWYRcdGSnpBnUe2G31WT6Tfg8/ZBp35wbdMYGhcwOObW7dyxncNexgboW2lYv3X41AoeIu8ge25EIy6BsSbdm4zp5nEuvEPSaefJbaJ87W36MtQxvYHyWRJ72Qn5GqK0vj//r6yj4ApMGAk3IIYIzJNywzMdU881Cnf3oQl02JxySG4q6n1RroJyjzV71gpNkGGBWD83O1IHbb38pCbVFSAgBgKTEZbTJ5MrMO92ykG5Au5xfnfbG9pLEyPrgZ6i+ntMLYKjkRa0nw8Dd8hkw3TSyG82TzNEqGORahccTcqQ0J1ndiyIXibnmaf2VcilO+Fjw1xhIrB/hZb/moV0/kRg8ejrcJZtGwJrMJ7phtvvXp+GUbe24vZ9T5jAXVSmX6665uCJaGihulCILpVQ3Zh415VAspipPCC4UljY34r8EIFloLQXZ+lAg0tDcFhxweZ6uYv1vwpDlz+6Ci//PPITo3cGMxJlcL5/99MSEUOL+7mPWMpFFMphQqpr4qJz4aWyy0mx7K3WGsoVhbsaZgLTFULvcLYsVxIPMuiROG6dXoCDT/67+Jfq29udOsa/Y4Pmmu/zAKNiN/AEi1Ycme3GPyJ0ndxawXpc5dpqQJ1+X70IvI2uNosdkDjTj6QB60tfw8N6Uf4xWvRjStjmNL7k0ksvJmDpM1bHp6yM+L8g367ITIf/4MRV+ke5ailVQ8kYO3WA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199018)(86362001)(33656002)(55016003)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(5660300002)(7416002)(6916009)(4326008)(41300700001)(8936002)(2906002)(38100700002)(82960400001)(38070700005)(122000001)(7696005)(71200400001)(52536014)(478600001)(316002)(54906003)(76116006)(83380400001)(9686003)(186003)(26005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?W1pFQr1nfWW7iPL9HkXD48MaWZ+/iWY3g5o3AR7QlmdAtLIZ1I4pIFV0sELK?=
 =?us-ascii?Q?liAz+GDDcsT83qBY2OPJffyOd/oc9KD+ebRHLL4HFegw7a4NVHYzIaiR6SGo?=
 =?us-ascii?Q?wo+MBj5HyyhXfHkH3DpohjgXoXiCnLmsMc/YOS2pWxMYsJgs3Ko2O2pIlqtr?=
 =?us-ascii?Q?e9zj8poBFTtEx0AjXB9K65BFaiDHg5xPHW1Yq2FsjPP3YwogOje78gAi9k1R?=
 =?us-ascii?Q?H6bnqTcFCerlag6ZXzVtWFdGZ4J+ofSyFG4aKwJNNB5iLZdEOtU/P2E+HLP/?=
 =?us-ascii?Q?Fh4ydm/CF/lFaxvUK0meIPgdCHOihXxVS4WAO9iZMNVxEkV5+96pHUsk3ts0?=
 =?us-ascii?Q?BhzVwq/UrWYjEc2dFz0h73d/Z2dL3KWCg7k9ADql7OkCUgBMuBFfyAb81yqp?=
 =?us-ascii?Q?O7xGVuqbVHQSb87n7p1PEdlqpEZTXhkFtjSE8OrKfBItLYq1pCRPyYvi2jYq?=
 =?us-ascii?Q?HVlJTU2AgOF8JoTSRCXF3AtRJ6RT4yILYR0h51R5zi2B+lknGz6jb+w/xWVW?=
 =?us-ascii?Q?/Y4ls1DaDxU8KTpx44AYFdqddtgGr3sMX8ppS1bDNpVaky88jVY7pgEzve5J?=
 =?us-ascii?Q?4tatj4vA0LH+xY5YqnApIIEbOBLs5jRe3PYpuk0VLpkqxGHMQAjDeT2hjFc6?=
 =?us-ascii?Q?0HP+vB3uQLSwbT0RxQwAOlS8YO0CMw0Pn09Mwdxs19vWYmTavvHx7t3JSWvh?=
 =?us-ascii?Q?00Lve1NtrvagbIXrv4moCS2qu0yTX4vC8ibbG7K9IlzFSqe0GNRlxNnK8UDj?=
 =?us-ascii?Q?zAUi7qFZSsXuUEFCLXO1tE3WYVBifZ2pLf1OlO5hp2dZkBaEnOLR1KoJ6Q0c?=
 =?us-ascii?Q?uzDpQqiXaNc4kc+vfT3vCzf1w51NbVKxwxostqFxf2AaOBh/0Fv25a/9iAbF?=
 =?us-ascii?Q?A2YB6D1lId5n87cwb+TrJQ8WkzMhyMAoP2M/RygVgYoN8mezni8fffwVzHfg?=
 =?us-ascii?Q?adq50sv9gvCzAAJCYq3wdgsF4z5EGOY1Xp8nvkTRKcwersJ6Dq4L6XtQFDd4?=
 =?us-ascii?Q?50pVtO4psN/F9Bhx3LFzZNNHwmP7MALbKfBl3XJA8f9gRS5dot6SLdtphylm?=
 =?us-ascii?Q?qqxlWCLsvuM/h7eAKAUmUz29RREurq1YwH9qUz02pTTedSRFaGCme9qJ+49j?=
 =?us-ascii?Q?QzEtULgcrVIePvU9tROIrxKRblF0snsXrlI9ilYL0KLoiLfeUZJkDKLPDJFy?=
 =?us-ascii?Q?YYObYhVGlDYUHAoIQ3H6Wj5LGJMzw4fwrNsEmovEew0ne1yHAW1sli/4gAEx?=
 =?us-ascii?Q?lEBVoec1WBxi9RtpcrpDgvMPkikXuP3IcLxcjHFPPbfJmpIBraVpmj/bfoB6?=
 =?us-ascii?Q?/poQhGKb9VjSOm1P7YUXNAi+atxOkp6E3Fitm0KlJqjrLPhJCbqM7z3E8pXT?=
 =?us-ascii?Q?u/TtlK74KcZDVMxO6CpgIKvi3cOM/tLEV9MOIRHvoNS5LE+BbpAuzGLorK1q?=
 =?us-ascii?Q?FPko1RaSORjNmRQ1RKJ6IndEUB6HHUpmn49H6pPEhvvuPYZomRkD2/zQA5Xx?=
 =?us-ascii?Q?DqxrbEhtpuhppTaTXkD9ESsL03bdGEIS6pYEm0gIm6ry8C65meZT/KEBjbav?=
 =?us-ascii?Q?GzidgVGwMgMLA5dxo8LuyOWAL/xIJRLpp0UHPqX7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d556875d-92a7-41a3-b1b3-08db193e8670
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 03:47:33.6631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O+P0Ky+3mqRCgU9yCVynwtIZE/R/G4hZEmHJ7o31IYI0Farnc7347EP8bqKHUUFrt5tMp2iP/xWhIRYpIYPlmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7797
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 2:56 AM
>=20
> On Mon, Feb 27, 2023 at 03:11:31AM -0800, Yi Liu wrote:
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > index a8f544629467..169762316513 100644
> > --- a/drivers/vfio/Kconfig
> > +++ b/drivers/vfio/Kconfig
> > @@ -12,6 +12,18 @@ menuconfig VFIO
> >  	  If you don't know what to do here, say N.
> >
> >  if VFIO
> > +config VFIO_DEVICE_CDEV
> > +	bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
> > +	depends on IOMMUFD && (X86 || S390 || ARM || ARM64)
>=20
> We don't need to propogate this arch detection stuff, at worst it
> should be in iommufd kconfig if it is really needed.

Ok. this makes sense as cdev's real dependency is iommufd.

Btw. Also no need for the below stuff. Is it? just select CDEV if !VFIO_GRO=
UP.
right?

select VFIO_DEVICE_CDEV if !VFIO_GROUP && (X86 || S390 || ARM || ARM64)

> Also that other thread shows that vfio doesn't work on ARM because we
> can never take ownership of a device due to arm iommu

It's interesting. May you share the link of this thread?:-)

Regards,
Yi Liu

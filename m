Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C314368CD6B
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 04:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjBGDZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 22:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjBGDZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 22:25:27 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D56B0;
        Mon,  6 Feb 2023 19:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675740326; x=1707276326;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QQC31G1P9CUuWBf72odMx82ygK5uvFx3dQ615K3U3wA=;
  b=Vl7FoXyN+A+ltpne8NSiJi9ZHTXQlrRjGzW42mr+vzs9kXl5Lh2a2U06
   oRapBCYwBLEAZliKMqPlTXS97kxU08pi5qR8wSgKVgVZw3N1neTv3Of5Y
   x9VV97MmfRgfjg7kcHd/utbSRdTAc2b2RgzLiCHPv0Al1/IH0hbsgbMM7
   R8+nK+s84IZukHpRsMkFh4hld+FgdmcxymsvAxu5L7OelSuCTl9DswWjK
   cF1Rq6bbysXTlbPf36vbE+MOTGPs65on1DQUWz9TaXeBncmDqZnTuWLmN
   r13ylF7os97o7bqyGsz3KNUOm/FZyx0Roe+n1eB/8hjl9a5wAMlD2hS13
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="356758007"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="356758007"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 19:25:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="668636739"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="668636739"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 06 Feb 2023 19:25:25 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 19:25:24 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 19:25:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 19:25:24 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 19:25:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQ9ZSd+KzZBHLqkhJRc8G2YsOOnRkRHkLgQCIsX9zfoPSpJ2z0t9wlchmbhfpfo5s/fzTHp3YhUxaeinl77QzLMcz723+wOAn+Ix/p+Li96MMcueeFgrrRHxinZaLnbBVurbp4iDnWeSBYq7RAHM0dQ0giMPoqkDeKtGarqZoRkvK0N2BhJl8i42LY41IeLYEs5nli6b4NRVmR3KFr8vPBSS8BH59ykz1KkwQtcH6EfEI36zwiOP+4lhF4zKIOCjI0IhJpjZsC/22zR5qoZ2NmeYEt03sSCwDtw14BPcoGXNVzE6zofrKJ13cOOqCl3ssQ0c8qPN+fXynwJZ9RE+/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQC31G1P9CUuWBf72odMx82ygK5uvFx3dQ615K3U3wA=;
 b=AoToIqHFmnwQPqYAUHwp0XEzxHiMDXyACXBVvo+DcmhIs4Z0Mi/sr9G+7R7/iKk+0kGpAUkiOeyCihzL23uYYuwLRYODnvJLwr8+5dganVLTcPKwl8NKqfhDkpkcAdEuiP8fwO5Q24g75YW/VDmV6J4u6de5n0Vv4PW53c0t+d4tVaRWXGnFauUBLTA0jwBPIdxWhEI3Ulhidck9/a25/wVXdFJzVX+jFGw9VVJMYYYQCyWwVJirbhAegBgAN+G+kcf0p83yng3TWeZvsipgpXnHjgUXp3xvMtlLwLldleCh7emT+oRWiQ/RFkQApymPKXrtGPVTMmvu1lgSEq5fFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB8041.namprd11.prod.outlook.com (2603:10b6:806:2ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Tue, 7 Feb
 2023 03:25:17 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 03:25:17 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v2 03/14] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Topic: [PATCH v2 03/14] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Index: AQHZOgo008xv7p4OlUyVdUrCFkzTu67C02xg
Date:   Tue, 7 Feb 2023 03:25:17 +0000
Message-ID: <BN9PR11MB52766989CAD2B3DDA3B3021D8CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-4-yi.l.liu@intel.com>
In-Reply-To: <20230206090532.95598-4-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB8041:EE_
x-ms-office365-filtering-correlation-id: 60597574-06a9-4296-f85f-08db08baef34
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vl6jgxtMF8HBjB3VBSXyHgL3HYVn44I3KbExJQ1AFz4KeRvF9OqBcS1qGq0bMtVeOdLcIsSHmsDOhYIE/JubFYFqL87qJUtD6THfPhFly6fKkTGwE+DcHll81XR8KK8p/ZRfF01YqNEC6j9H3o7PHYJu7IarvYGnoQ9xQ46T0yI3n35rUkxqGfIZBEkDjgGDy6M/dAa7DoUah8TcOrzzWOjy7WBt7BM8yTVn7Lrx9eWhNFT/0ivKZ2896PbUnQqGul+wlkL7wxO7oEWwSLthhnKM1HbWwFg87QZupA8yyi7IR9+wVi62xbW1n1FVUOrI4CGJV+xdNJr6sch3/+TMXK7XmPSkPaIbJs7ZzyYablxANb+YtW0JwCdJxUKx70OX0MBZpBrsiWctLJcX99bry2RAWqMLxl/loc/gGEkTcwUiTyWFZNaWbQjT0ncBAzHwfgRQXBJ1zTSKxsvxK22itrTF16cO332yo1FqwBR0wT+Ho5Bqpm2RgDnAqaXsbHILvQXsyAR8pUfG0Kg0zeI5kN+sRdvfds2pDxXJ00pJiuN/Ui77jodPQAb7EO4pOIi9Qr65FPkpUwdQLXQkp8oJIwyRJQU2e0WCMaIkwFtK4JPZxOpnQSILIFfNxj6N1N5LtAZoHga9Swx/8TPjP9+8ZPxn3mxV8K2F9337bdfXkjxdbQmDfjA1VU2wzIqN2eLLuxzmAQFi4N45ju9fIOtENQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199018)(7696005)(26005)(478600001)(186003)(9686003)(71200400001)(6506007)(66556008)(110136005)(8676002)(54906003)(83380400001)(316002)(66446008)(66476007)(64756008)(4326008)(66946007)(76116006)(122000001)(38100700002)(82960400001)(86362001)(2906002)(55016003)(4744005)(52536014)(33656002)(41300700001)(38070700005)(7416002)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iUCP1B/nZoZ4CNDaFtOEFBLtcZspezRreHMt4TsydXu9hIN+smORgr/76+RZ?=
 =?us-ascii?Q?+dQafQpV8Rs67WwC6Ooqz9gwRY9bnu0gjffE9tCyeu5TvPmLRg5CnYq8rjjM?=
 =?us-ascii?Q?gLHhbcFjvsVPcal5tTGjrWfPiFmhYDh65nzXhxIJYKL0sSeAuc1GL5LrmLZy?=
 =?us-ascii?Q?xp5ynsyrZThtZ1Ui6xPXfeFbxO+Ij9i7sJkI+RnFuBE2al0HouXxcaqg0tfJ?=
 =?us-ascii?Q?6iF1R/7LOqaRIppMT5va9JY2zxrcGzzQJbaV0Dz5UzO30xLaSIzi7AqZSvfW?=
 =?us-ascii?Q?r0JRwvFM5jxpSt5K/kRMejxDA8I6rSyhBBrhorbHgVY5J1XE0aEAZqE/MYll?=
 =?us-ascii?Q?0eWksFMaW1intxH3c2Oq9yLlSB3v1RbT0eXf6jmBQq3qnFkSeblhBJHP+g41?=
 =?us-ascii?Q?7Usv8x52nXoob3bVjBtWvwzDUv//g3st0wqVCZZ7p6fJsuMX22DRBVxXE92a?=
 =?us-ascii?Q?a3cPILRR/ioKatmvCcgTbwytU/A3Jp2CQY7bwRL8kPcHC03TOKQwyV/qtGMT?=
 =?us-ascii?Q?YqtV6iOMe1QXCnIzcf720pVgOxd5NnKRvnljBDa+tcY1ESvdPcC/7aBofGCK?=
 =?us-ascii?Q?SJjvCB1yoACUkkIpHhKDWb2OI4t9qxjjpOzk5USbCm+/31/KGAU+Kgmwe9rg?=
 =?us-ascii?Q?tKqeWiu/pOvUj/WyuwsRB5v3bLtRM37Mxb7+VTjlwfgSDs0CkMGbibPh/CLS?=
 =?us-ascii?Q?/i0/+klaUvs61CCPskdDThViP8YqdJ0cyKR24bQ8dAad5EJlUy1BxOgUbcZk?=
 =?us-ascii?Q?wAiBWsbgDTizfLDHEr7vcjORKFCzjolBhZdQTQrZnQy/jLhEt5IrXjk4VJk9?=
 =?us-ascii?Q?FuF1rCgDP4amlTk0kxQU6mhmg4+0yA3YX7hZukAfJgSlffy5/l8uJ7pkZASZ?=
 =?us-ascii?Q?xkzfUO1pkKIw4eaV8UR+a0OQSLXAnTWarzSxMqQFBLqSLlBMqNKreCl6z3Gg?=
 =?us-ascii?Q?LwVVmtSUxXg1lKKZYfGhy5TNWhmE1ZbXrIeGKiY2xK8i5ULBtXExYyenep3P?=
 =?us-ascii?Q?IBAGYFSzDt0HID1vdYHGG/AJpgwUMYh58H7g84xTYSWC+kouJUX+B/2ESeyR?=
 =?us-ascii?Q?tsG0c3URgOfcKlpHt8LDqeWbRT5Wirv0XsXgMe3k0ExTozTSVMo97Th3vVHA?=
 =?us-ascii?Q?sj9K6Mc+UUhua3iPwUSxltMBm5liU1UbuU3+n0TwdLzoFXopYXxGpn9z8BKY?=
 =?us-ascii?Q?9uxaNDLvpIq4njp+IRBYIJBl58Vhdxb9tDewwJpfPPhh6C7pzecQ5kxvskF6?=
 =?us-ascii?Q?LAd59kiirEivVUgBG26g6RRHAjf7unKXqdInai+QTvKy37m5OqpMdKdL2NgF?=
 =?us-ascii?Q?ZeSyi1zADE2EksVtCizF32AiN6rLaWgluCpNozbSvkwZqusB9cAzJ2DUS0U2?=
 =?us-ascii?Q?9t2nqfvoQwzMkoE2rdYSgZVV8huWFvuwj/Az9rb3BnxzV2tdUupC+sP835E3?=
 =?us-ascii?Q?c9RLkIBqGy3oL7iqKvsWKz8FM0icR09hrvmw8Gh+R0EUGB0JEOxGUCx4nNsp?=
 =?us-ascii?Q?PYsNJ2hotDZY9ZZoTzhd4nanbp8HRwylVHCNeMOt/vlE7j6F8DXc77pvTKih?=
 =?us-ascii?Q?+CWpqD8QFKGd4T7N5CWQ73UyipCkTMt6aRDt34C5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60597574-06a9-4296-f85f-08db08baef34
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 03:25:17.3066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qncIhUh1KbWWil1oUj+NhUk9zVrAIYLHb1LjxlPAWMEWlIa2kOuNzndCFRQl5VS4N1gaF+q7351xEvN51ZokFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8041
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
> Sent: Monday, February 6, 2023 5:05 PM
>=20
> This makes the vfio file kAPIs to accepte vfio device files, also a
> preparation for vfio device cdev support.
>=20
> For the kvm set with vfio device file, kvm pointer is stored in struct
> vfio_device_file, and use kvm_ref_lock to protect kvm set and kvm
> pointer usage within VFIO. This kvm pointer will be set to vfio_device
> after device file is bound to iommufd in the cdev path.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

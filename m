Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EDC6D1683
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 06:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjCaE6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 00:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjCaE6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 00:58:20 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC52AD20;
        Thu, 30 Mar 2023 21:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680238699; x=1711774699;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2uHOseSnRrfaUYpuQh4JKHaBFirSEmD5xoj8Ga0/iuY=;
  b=h/5H/Rt4BJ0LON5SLafIMUksUvc+4Xsk3SMdIBac3ijSFYZNjOXLTFu2
   ORVe0DSxigDCVaQh1B40wkL2/O3sGucd6lZu04tt2PHlsdOBiUDo77pF4
   Jvi9dkKOLTYo089b5LpSFzReYCb6Yii42MN1wpxgGtInUN85jxR/PoS8d
   XlXtkZgpNXLFemoXV3VwksUj6ULiCgKDKuZzKuOe0f4A5hD9tn6AcPi4g
   /oQfKpGmsoSSe7UKAYVlYYtmYrvOA0mKI0skZaI4/NpwVKM00we5qIzlT
   HCr3XuQ0fhx1nsL9OMEYCtQ/38Yh793BHaxofdqB+8nwHJd669EElyibq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="404065916"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="404065916"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 21:58:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="859159392"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="859159392"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 30 Mar 2023 21:58:04 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 21:58:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 21:58:03 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 21:58:03 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 21:58:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEMLl6ju0sEhkL9VgmBsC3bxMdob1UgolrHCjpfx9Ypa8+VokDf4EA0/QyhBQ0quFYDheEix+cxtRE9cuKYa1fUV+27wiCocjPjOztF16gdvlRitkErqtId15tq2oME1uR2FdoAecq7QebHctlzFNTfMXE/Gca5L+WxIZ9tAnA6kA8dxfCmyLLu8ViMbDmH2malULBZd71KO3UBJvIIzynpwOB9vFFSvFB7sj9+xFxBemFbJLMR54K43op4dvGy7vlTno9tQIU+oL+ObGgW9mvZnQ/2SPVuI8eNYTR0ybNdN8r90/K3HrMuiYhH0ciwtG7xIGYvoFbZCFXVlZEjVRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uHOseSnRrfaUYpuQh4JKHaBFirSEmD5xoj8Ga0/iuY=;
 b=EaXiZb7F3vL1ii+HiZKmhTB4ihHaVklCW0Z8gOI2jMpYK/NBh7jHL0qn9WDLcXIm94H91EeVrVWIcR4yMOvGxyBwGop9cP6MgsC5IQnsfo4mVC3QPtpIH+Ok7T5i219bnLWt+5vcM8+DBdubJ0PlW8Nq6tVLpAW4RTDRBCR8lAK14nNzKuY3dQ5svD25ww7ZT88oOmYTG1A2KZaMndCxi4lPNNdiMJvxh9lB4uoT4EeoaUvQfHO+V3rsbUq8I7/H1T6sEyynjVr/RkwgLGQLBSRcq2JEojPJqcckAqPz1vqxIOeFvicjgvR20QuNaH1yZAyrp15juoFBQ4Hm2kpwiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7)
 by PH0PR11MB5610.namprd11.prod.outlook.com (2603:10b6:510:e9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Fri, 31 Mar
 2023 04:58:00 +0000
Received: from MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::c4e:6c7:e9f7:7222]) by MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::c4e:6c7:e9f7:7222%7]) with mapi id 15.20.6222.035; Fri, 31 Mar 2023
 04:58:00 +0000
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
Subject: RE: [PATCH v3 0/6] vfio: Make emulated devices prepared for vfio
 device cdev
Thread-Topic: [PATCH v3 0/6] vfio: Make emulated devices prepared for vfio
 device cdev
Thread-Index: AQHZYI9C9He+bKHK5Eun8edPS5e1Y68UWSNw
Date:   Fri, 31 Mar 2023 04:57:59 +0000
Message-ID: <MW4PR11MB676317497A61D6C391D9949EE88F9@MW4PR11MB6763.namprd11.prod.outlook.com>
References: <20230327093351.44505-1-yi.l.liu@intel.com>
In-Reply-To: <20230327093351.44505-1-yi.l.liu@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6763:EE_|PH0PR11MB5610:EE_
x-ms-office365-filtering-correlation-id: 2ab16f1d-e0f8-4890-fb22-08db31a48050
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NW2nE8SSFjjhvJEE4Tp1Ma5m1cwDXZKCMmwpp6zvzxgXuOKkLjY4nsNy+E44NjKkM1JL5SMGAlschTWBNS49RjgYe85D9x4r15gR/rQMAFYSFAe9LJj6dJFJh1TOQQL7LziGOVBpcQRCpNJ31oMZFZ9UXWnWhEjCgcC3cmwqg8XnVQSFU9TEpH7oxLO8A2rmzCDkGARH4rkfiD6hjZerGrCC3kdmWe1UCf5fdvys08w0Mj6MI779WQUE0YcKkazGTnIK4mLA5jI2QxJCbC6xxTpcschtGI5rh/H0NqXrCWVFSom4VYPQRznYEtSQuhDj7YSwQq5e+YlmN0UTKrv2zWBe8Yt1VoXptsFWFXAv6213tFOQvdVPo+IeEUWYCNi+YdQ4dW+6YqdYvGPPz0XMjw4p6/FVb3JjJWQvPL/sw2Gy5ciiZcfc/AR95qheawCtGajhWhzbK8SsWSDAhJchQG2L4RJTotAdLm9n6dHVwIJP4U8t1hqcdgw2/TEEov7aGVckqmfqw6M9PebHIgzYHJS7ULc4gRryZTjxBoAGEtQWsfHXziojaax4LyLsI7inOik2/h/mVgts4kQ3SabljZl5yGaogXLY+vPiwO83LBCYbqKeelx3miIHY4wxPzQZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6763.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199021)(186003)(9686003)(6506007)(83380400001)(26005)(52536014)(41300700001)(110136005)(54906003)(66476007)(66556008)(478600001)(76116006)(316002)(66946007)(6636002)(64756008)(71200400001)(7696005)(8676002)(66446008)(38100700002)(4326008)(2906002)(82960400001)(122000001)(33656002)(38070700005)(86362001)(7416002)(5660300002)(4744005)(8936002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gqg+8wpYQNE457Hg1GqnwTLiemPefjlZWHmC/dD6FNXbWACnex3Mz6lQIv/T?=
 =?us-ascii?Q?DVORnJ6+99GN6++eUmsk6CDsfpSFS9dzB6T5kUBOpxKz4nkSAmk0lRYGLtal?=
 =?us-ascii?Q?i0ufOwPU73YLGb6+/VDuqQb7nlUIv/m7hz+xxstExkRsG6pEA31RIkHhbJ8E?=
 =?us-ascii?Q?uja0noteEbGUZkkyiYT2wZlA63HJHNl+XLZSd2WJRWLdtkss95GamOzieQgM?=
 =?us-ascii?Q?HUklfEWOa625bGC+i9uHWSe3rlOz0bOv80+sikGlLuQ1m0rJgHEcxpmJ5OAO?=
 =?us-ascii?Q?s1OIMAXPNDZ1bk+qWIAalw5osdtDQ86BVfT9ht/FEFiMMzho8/7XJ5RqFU3L?=
 =?us-ascii?Q?TFegrgxFPiKCFXP0S263VRC8UYfxrXoHl1DeUymddR2LH+3aD2PwChq1Zhf8?=
 =?us-ascii?Q?/Ow+nj+uO2zP3QByuvOdBr4Ku37+quDB5nLKKfnua29ZhTCoEWu+EwR6Xoq2?=
 =?us-ascii?Q?CU1pdYfHOt0IkiwYBPyljVfd8sTGEgga/ZXiCytuHBnwNxdj0t4EGDenR0Zv?=
 =?us-ascii?Q?KcdOBxBsusk/DNgKp6xBI668wacM/zwWoPYnAVjZkmUFVk5YJkYbjd8+JyPw?=
 =?us-ascii?Q?ohnIpXDc04Y9Iecqn4oDAH4aB072wXV+wWa29ci8R5N+xuIlnxAuZYqJUxOx?=
 =?us-ascii?Q?U0FUL+qxTYZDkw2SLUuj2RaXF8lGT7Szjf/+pFIwOoB4MHZC/HcyQf1O0epJ?=
 =?us-ascii?Q?BU5gTGtI3VLR0FWcMdS25FO6BnEn8GPlH5s3oACSBD/zpFidEuDCUHot0y8x?=
 =?us-ascii?Q?lo7XEzEs3wsxsm+Cf6vD8USckPZWmMzf83gRVQDOW94/BPKE/xawpDq7Rqh7?=
 =?us-ascii?Q?8Tc//qD4A3tuA1ssPYoQDdUy9CKKsy7neo+jWV9D8U++jQ3ocGiyEaKXGQvA?=
 =?us-ascii?Q?hzxYv1E/oYo2w9K6wOZq9uoJtpdxvexXr7QUzgV2Jp+NofNAwk9QqpowlFcg?=
 =?us-ascii?Q?vtuISxZ6raNUnke5QEGuhX5+ilAed88GyWH3jxM1dbulEQnXYpy+6+IUo50p?=
 =?us-ascii?Q?9tOhRiW2qoJ0KqcwBhuVoSJP1kH+fUtLhy83yTl3ClKx8bUhCXInC6tPk5cH?=
 =?us-ascii?Q?bmQxlFvD6Az4Z2NISiPes+RsAlfxmo3/dAyKYvBQ31VD8IJbP/biomwvIQ/+?=
 =?us-ascii?Q?Dye50xDh6DNknCPMUudf2zigcT9bQcD9DNftJLOU0H2AvtTMUt934rCVmUqV?=
 =?us-ascii?Q?iKaCC85l/ucchCG6IbIAgYq2GNEJFxy4LjYFPOUlngdFvZCVgCI1BcnlGdHW?=
 =?us-ascii?Q?lCshwbVvij3rzxtlZ3+JsE82WWNAbXlWPXPQTWpSMquUzd0D9N8hu32u3qho?=
 =?us-ascii?Q?9ogeC1JtiUVUCuBpb6UdNvhEnv44UF80JoNDiy8BGEuEiL5htyCDmn4NiJNu?=
 =?us-ascii?Q?awmJs3TG9bF0q6+8DKXaH+jx7Dyi+M+b6V0ImHCLzSyUQw281ty3g6zcKlFX?=
 =?us-ascii?Q?kgTULJ9mTWWnH23TxoumKPG1oPg3mNyK7LfBOsBAcz8fCVTKxwV7QKL+NPHf?=
 =?us-ascii?Q?NULQRARQVPvbEyt+l6QjsrDa8BcqXnhlasGQyHfXqgO1cjaPuQYgciOFOJZR?=
 =?us-ascii?Q?Zu9S4e49rghIZfUkN9VtFjDHrYEDf3ppktEfGYN3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6763.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab16f1d-e0f8-4890-fb22-08db31a48050
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 04:58:00.0124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JvwZ86zAiXZLTfwnigifJ0ZyhM/CK0yeSu0M5zP1ILzSd+CaTUCNxf/wSk49O30DBUFf7fOzDiPDVQcM1rVBtQ==
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

> The .bind_iommufd op of vfio emulated devices are either empty or does
> nothing. This is different with the vfio physical devices, to add vfio de=
vice cdev,
> need to make them act the same.
>=20
> This series first makes the .bind_iommufd op of vfio emulated devices to =
create
> iommufd_access, this introduces a new iommufd API. Then let the driver th=
at
> does not provide .bind_iommufd op to use the vfio emulated iommufd op set=
.
> This makes all vfio device drivers have consistent iommufd operations, wh=
ich is
> good for adding new device uAPIs in the device cdev series.
>=20

Tested-by: Yanting Jiang <yanting.jiang@intel.com>

Thanks,
Yanting



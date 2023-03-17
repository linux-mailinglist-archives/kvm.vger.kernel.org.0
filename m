Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2F66BDE88
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 03:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjCQCRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 22:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjCQCRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 22:17:01 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430F5B1EE0;
        Thu, 16 Mar 2023 19:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679019420; x=1710555420;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F+HMbBMQXGJzOq2MgO5Vdtczf70IwEksl/3/3Iu0w2Q=;
  b=dPxzgQRgXI66ZwsjNmbzbsnCzAHrp8X64TCf3tJg+uuls3DmXG2vJ4Q8
   nBbXHmCxiYDOa8sexNQ/UroJWhFwFvOnZ3SW+GZsK/QyFisvwV8Z4Chps
   mCoLA3Q5zt0IeUPVkh09mKTlFKFeR2kGkPLMLZF38J6XY/C8GBHofkPVf
   kj9Bl1+2pSXwffMgVEqGbuYBhTTnE7ZTQehr/9yBc53MnAioi4IDChvZO
   lfoyGz+U/MPjF1gHH3qyp7F1bW1zPd9FE88YMVLQUoZqgEV7goR23cU35
   F8gfamtW2yQtB35VF1zvWdDLCEvpLu591J7wI77kWfAOyXUVgXyG109S1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="318556688"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="318556688"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 19:16:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="712582182"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="712582182"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 16 Mar 2023 19:16:48 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 19:16:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 19:16:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 19:16:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 19:16:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P3iKly0Ge0GgvfotMnTsI4Lu9G3O0pziSz34ZvvzqQY9n6efzdGNMXZG2PMGg7hmSQ9psoOSRw3tLZJb5D54oYV6PrCtGd24rm/hyXVZxaz+wQ+mY2xCO+w3OCZogs0d1+CSsSzPiTuYuXIzlofpdE5CuFPK4yOOUbkT+VxspXNAm+3/k+qRFCa7/tVCRtohOL+hetmCes88NKPWZ/G8ddGQVzyUDs3n0jRi+pDXO82WQAhqYSNmZC4pDd/020YJ89uBSj7rVilN9Yh1PTYV391sg3lZI+8WlTE6qsPAK7yL6YclN+MoIDTPEsOT3SNiq7zLP/kqqhKiJL26Ga0ywQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JTjgNWPBRCsQxFmPB5o+q4sERoYtZEqDvT/TtQ8/U5Q=;
 b=WSK/kTf30FhKlv3j4nODXGoKI1F6IdrVfVGaAFBmFwTZn3HRp/0gcbPhQ+ut/Xscfz3iI2Qtppyp8TgZqz7Kn/1h+8iIQ4LXgFw3Ri8nwS+mykutM0quK8o4ALFvKgo9plELYM+Vct5rMWobtr57cL483fOoWqmvxKqu5EYHje5h40731unutCGoszTh4i4GIV8juCBoZpgtOQZgqSgjQ/IQaMqFw0dHKSDS0yK5Q0XK0YYeDRIU108xLTrgpHiYEQx/V1+jQPmFwifDvCzF8t2pSNF1TbGU2fMJVu7gvFQTMX8RteWuvW53R4WMEDaGhb9musiKKyIyfQSF4OBjlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB4822.namprd11.prod.outlook.com (2603:10b6:510:39::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Fri, 17 Mar
 2023 02:16:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 02:16:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
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
Subject: RE: [PATCH v7 17/22] vfio-iommufd: Add detach_ioas support for
 emulated VFIO devices
Thread-Topic: [PATCH v7 17/22] vfio-iommufd: Add detach_ioas support for
 emulated VFIO devices
Thread-Index: AQHZWAarZ7FvU3ezNk23wQUADgrbR67+PLSQ
Date:   Fri, 17 Mar 2023 02:16:40 +0000
Message-ID: <BN9PR11MB5276CEB29137E1220689F97F8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
 <20230316125534.17216-18-yi.l.liu@intel.com>
In-Reply-To: <20230316125534.17216-18-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB4822:EE_
x-ms-office365-filtering-correlation-id: b5d72c12-438f-4981-4150-08db268da4ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lr/krLxccYZUAtSueR2C2Whv/tX0pSI41Ph6HrofiJTaIR8/1506D0UYvLvnN/6eWPq/LpChRjLSfO1HHgbFj39PNDZbz2fk2/GGIY3Fx7mNB+A6oOBxYbc5JrT7sVlImwEt0gEOOs3QMSU0LTbo5h/kLV47WhRDIOaPlrjESUs0KNkNdourduhRwV+yENtk5zILK0tq0DZ0mvb6SD+BlLlvcWGgZJ/E+ZFnIEEEKNQeBbpQPgYiVm3+RX6tcpoP5jZDoSML0IReQip+TmC3L3A4NfnPcUnDV2BvRj6rjYQpfOKYTVGplskXllWGnEKw0evUEbBQuzJEECtW6cV5hu562BPaklOjWxPTvh8BjcQddUPiviR3pHZeR/PxnYwe1Fhsn2VJtVbbkAByFD3IHM9f4h1ciZPZfc3rDQpbw9nio9QMFvf8qoc2mTiwAMjG+OPnvRTh829saPLc+z6AuS+1bqIbRfES0Jro7EIuFEUw2Ko5fX31iRmEI5A8WVlBFzSXhUvWuAO/QSeZkWxMq45l8j5x9hMdt+MUNJqC4rVq6g17sm81KnPXXL5nYxbhsFr+DEM7OcTvipOkbjpevvwmPo5VeHUw+xCyxpr+YD4BOxHTABaBSvfwuJeEcor7aI2rknjLBvnHIRLiePocx0j+uV+XiwvlT8mRI/Tjms4pozZeZdrk4PBHuDjM2auw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(366004)(39860400002)(136003)(396003)(451199018)(316002)(110136005)(54906003)(83380400001)(82960400001)(55016003)(33656002)(86362001)(38070700005)(38100700002)(122000001)(478600001)(7696005)(71200400001)(186003)(6506007)(9686003)(26005)(8936002)(5660300002)(52536014)(7416002)(41300700001)(2906002)(4744005)(4326008)(8676002)(64756008)(66946007)(76116006)(66446008)(66556008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KCQVqvPgISlf8OWpWeSc+SeDT+F5QWjfJTxjZhN1T+nMsm2JnU28nFiUlHLb?=
 =?us-ascii?Q?BhBdwAV9wD5PaES7/qcfZoo5Inq31F5PuztTSpubcxZIqjWCq58/gRAjGha+?=
 =?us-ascii?Q?PEXGfmT6FAsz2tlKpswzNxOp/2pW5QhZsNhS00eRTTTOTdv+3yFMkOUc0j83?=
 =?us-ascii?Q?a02rdwkSb1/T62JsmYAbq7LzElzLdY/2AI3GwVuNDLdpLTKktn1e3xOOYcGL?=
 =?us-ascii?Q?E5efaa0TnZ/kCMeoiY85qwKYOQGfxTZOFaO7bZUQ9OtQjvRv9K9qz8z2UsUA?=
 =?us-ascii?Q?PPv0kH6wp5DIF3t2xHNtkGXW4HMzNXNdF+DnQGUhXYDu/3HFGWOLXFetLkOx?=
 =?us-ascii?Q?1wSsJityiFZZjWh9i1hbtur93haDms0z3A+UGnmYAvk6TcGBXwUFo3d/NkPb?=
 =?us-ascii?Q?LC8ABl09d+pXqneMPzqJ2H8vOWA4UdwA90wF5ZJ5oaa0vbLe17HS6ZFHKPjp?=
 =?us-ascii?Q?YQkymlQ5GhFOAnel3PznpgSaYwJG8AvGAWkdTJfFeVWtTSGnpLoNOosAwNbl?=
 =?us-ascii?Q?KkDQbjWXhW96RIgDBK01rrj37HoB2RnwFqhVn0EFCl9R9d33xkO6VX1DTXY+?=
 =?us-ascii?Q?0ji+7xizD3JIGacGRoMhXJYgNEJ1baphakYLQOJ2Tljm6kgXR4EWeH6hjC6b?=
 =?us-ascii?Q?sHuYzGZkwEOk/nmGSWh+wQR6VYnnSJKelMuX0HDHcS9YDs9sqr2wu1SMPT9o?=
 =?us-ascii?Q?z135TgVBsQOyCF400DUfkKLAFUDovkRanKuFID9O6kjqTI9GKPtdJzY16qsU?=
 =?us-ascii?Q?M5zbVhojwmObGAOJtGn2obc5o3DT236/1R4KsszZTQl/xh1BpxlxZ4SyHJU3?=
 =?us-ascii?Q?0K2Q+JczfKlmp3W+YQikZJ4ULPK6SRwKqb2wDTgcFNSAg56W+THV8NXghA3M?=
 =?us-ascii?Q?IIxuW3CFn7mHsQJEXEf/twkc5eIlxNwSsbbBkBuzweSQEIEpq3to6ybaqBnP?=
 =?us-ascii?Q?+uHYS2E1Kh30q7KmjoQOpKUg2Sket/94CFlo9NNevJTyTroHEaWAoE1niVxc?=
 =?us-ascii?Q?W6CIXPeRk0EvgBNXECnORd1PlZDs5G1omjsAMJl3lEo+sYQY05m8Q/7cyMyn?=
 =?us-ascii?Q?8hh0Nszuwj580LwXAW+6W8t3bb1XsKaulMZmmNZBVtvse17vqs+0XxWoNI1E?=
 =?us-ascii?Q?fMmBpZP6AaniGeR+pt9P1Q2dajC21XX7psbri2JLhgnZBZvoa4HbNdJszysc?=
 =?us-ascii?Q?Cxxko4pjUM5R/MQXjmXE7LAw8g7cq1iUqCuctPavmHDdWIIg361TltmsJPxc?=
 =?us-ascii?Q?kEZqL3czkKmbI4C56wQ1UfVTwHPUhWS2CzuRV9NJ95pR7V5F49dtZbAN7mqA?=
 =?us-ascii?Q?gxq14EZ+ZnlJDa7A7leyi0c9TArt8sHcxagv1Hp+UajwfTUsuQ5E/dtKml/f?=
 =?us-ascii?Q?xj9hKnq8QvynX27KsEbZP+Cq1wtz6nkEnoYNrtlQwlzgyMnfV/Z5Z1SMDvi1?=
 =?us-ascii?Q?3j7WuKYKNLQnQjizSTIHChTAPeuGqZ2q5Ri7Jkcdy6ML1cWF9lBXBonN067S?=
 =?us-ascii?Q?U3fiLjupJnU5OwuLZY3seCRq+pWLOA7fGRnSxZljaj0Fg4KL97X9nqE+a+Sn?=
 =?us-ascii?Q?JWbTlt58pwZj1J+5hJEfQHa4emJNKFVe5sUh/Ix9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5d72c12-438f-4981-4150-08db268da4ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 02:16:40.3336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 297qy8lSLojjSuAXVy/ytgMwX1sKhxr/qYolupuoPTpr+RgYrphXdLJ3JbU4kcvOw5ucquyzn/SNZQcLziTLXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4822
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

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 8:55 PM
> +
> +void vfio_iommufd_emulated_detach_ioas(struct vfio_device *vdev)
> +{
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (WARN_ON(!vdev->iommufd_access) || !vdev->iommufd_attached)
> +		return;
> +

ditto the WANR_ON on the latter condition should be removed.

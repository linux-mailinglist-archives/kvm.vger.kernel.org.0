Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AEF68CF74
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 07:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjBGGZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 01:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjBGGZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 01:25:01 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BD610276;
        Mon,  6 Feb 2023 22:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675751100; x=1707287100;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kg6vHnpZ5YHax8ZXbKVgCkwCEg46ysEbS66kO2j6K4g=;
  b=bi704hPS6ybIeBU2tQFq8LmnH6oUtIf6009muKboP8EQj6QmNknfO4tW
   GpT/J8A6DHiHkgkbE5bbkgD6G1UHeSO4yfuFGT4JFAdv3SjsbK5AQRTzz
   DtyWTr7QfT8fobwnzi0fMd0OBQTbhM6gru6W5UDsPiw3/r0QBS278kYp/
   UHZgqkD5ZhJ9feqCp8+u62vK7NlCIfldsIAPiW5zNMWoyS5KHhxpZM4r2
   LoTOPotsNTQVzv2y5hc/JGFYUT/LgzSe+eYAAdq6w/wKp+e9RDxqKOc8o
   rCz1wjNnhC0vf4fKR8qJPTUhhFewCiFDPyDZdp73rpeSyy0Yjkv+MamzZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="309752914"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="309752914"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 22:25:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="912211686"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="912211686"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 06 Feb 2023 22:24:58 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 22:24:57 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 22:24:57 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 22:24:57 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 22:24:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMV4Ehc1AJjK6yx16CJmEj7yVFE5iLzl79TUJLnrK093I3iJV9DRYyLG474Qx4ZhfDCo1e02+Yw3Ciqp4Q/aHNUZkT+wy1DdTFtITbocuYe3/+8S1o2Q8WCqnkt2Jrj4wtAvIoBnKilCYsnLvTJ1xLWlgjoSRgQeVXCPbkZq6c5xuvVzaGqoK/yDQ+3NV8/5fYDZkds177LqjK9KpZ+6ijBdm+gPSBZhvtIxWeeKtlfT+/eNRZDoFyuj1x7206g2LHgXOikjdyj679QOv+N3gpwp6yrpCLEmuXv7rUuNMdEbMuk14yX8J07SLQwf3CfGWUuoUeW5910S3P7jlRLJaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bpu4P0Te7xVBC87TmFYSbSCcGOdHVSEQvq0e8d02e4=;
 b=Nqp9XGfRDBOHVRDRzQGje7Cuz9ouKCmXsVC/c0NNottgbEeuqRVMJF6/CtAVbYoZhxDC+pC2GDaWkYf2pi0n0UjG11S2ig0p39rg786/oDWM29SI+RsssrJjcnJgm2TI4730DdFS6E+f1iFDdeVkOblp725ZFJZ/cRnJDq+veE4fqG+WZLrVB1/iDiB80coaCiPbtT9HpOVpDAZBpvLVdPv3+IzFq6ch9utGKVHRvYh2B7L9LIYGTUnt7FPQDIM4wWH2y5wXI1MLoXihBgZio8wMm/4oYjZq6RMMKUpvQ2nk+nSd4DBivr55LwKpuUeCBCZzUp/OlrgLtUeCtgUEsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5149.namprd11.prod.outlook.com (2603:10b6:a03:2d1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Tue, 7 Feb
 2023 06:24:54 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 06:24:54 +0000
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
Subject: RE: [PATCH v2 11/14] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Topic: [PATCH v2 11/14] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Index: AQHZOgpBum+2XsDSRkm84tYt2roRMa7DBLFg
Date:   Tue, 7 Feb 2023 06:24:54 +0000
Message-ID: <BN9PR11MB52764ED1F43F717E04B8E3588CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-12-yi.l.liu@intel.com>
In-Reply-To: <20230206090532.95598-12-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5149:EE_
x-ms-office365-filtering-correlation-id: a6fa7605-bcab-4cea-1b13-08db08d406b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4/j/zUAENOXkN6zDNVZ0/AJnuCjXN6ncHSuhYTBfYUuYjkmidGl09m0SBvO5htURqz2qTN9hAxG5eEvh/IwcQ6QpLXq1pgEFZVMBYMShzwEiM6aGBOZtWNhXlTgqDPfgBN/v7Bp28sA7jzguOUr8aBSse6LL6w/SRdB2OBK1jqaWa8nT+Rr7kmQfy6aCPiWynBrbj2OMI2WktYO/1tcVQY7qwB2ECEX3Iuq6Zwao78CC7A6VyLJvQiZ9iJvJ/TyNYHZR61LMnAKs3c0BEZrnnnCpDm+sE8NshzfR1cQBa1xmZoed+hba5GruMU9DK8NAbVLdEVafW2vASZqojfVlM51zLG6gzXqB94f4+BuCnk0L16d8LW+iVRIDL6+cLTPY3zwqsqR9ckh25oBOeMdb3707npWk5p22ZvU4gfLtFvzr2bqUQEaOGJD1t1mcWXLdm6nC5RX8dEHWLt58b3HRay196yjN3TpgYuE7gRVoSIW3x6sHu/2QK2ebhMi2wxx47lyOUpjfePKfctjp/NYu5MRT/y72C/9xBAohq7+OUrcRb0Xi1t3fEljXoN+bCBbUKd5Q2O5wwrTL6QV96DPhiV7b/RuHiTMNRjGdVi8/Vv6ZrxTRbZ2uXOIuRcfhUw8+1f18ZzVywIGv+3i8e2Tcrsvy3kjjtyN+3VrLRhIoyTx29A0qWO2kaOnTNFVB6WpUEiSg8FeY2U1B9/H+W4s8Xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199018)(38070700005)(122000001)(55016003)(82960400001)(38100700002)(76116006)(8676002)(64756008)(71200400001)(66946007)(66556008)(66476007)(52536014)(41300700001)(8936002)(86362001)(7416002)(2906002)(5660300002)(4326008)(66446008)(478600001)(316002)(7696005)(6506007)(26005)(186003)(54906003)(33656002)(9686003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VtP9kmx7ElTf4ekvpgdykvxZtV0lLYKNz6m3V52oxadDiHgpOcdjDGcKS0LG?=
 =?us-ascii?Q?/PT4a1E3T+s3dv6sts4pg0QlZh89PTiRTlXqZrqsw46h/oAl/dflp0l9J1Vy?=
 =?us-ascii?Q?9yrVhlwYRp2X0mIs5Fkhn3hMc9LvE4HmLZDOqn40IzXmix04YgtFK37JbbWo?=
 =?us-ascii?Q?IMOj+FjB4juxX9zZkyLHgaS4X5/v6odS2N2CKlevNcuAWinjzgBw0EGKM07N?=
 =?us-ascii?Q?DuQOEOYGOcoskoomm7fjgZYMVyTHcRiP6YGRF2sPoEc1eDXWewVTXaWEXWd1?=
 =?us-ascii?Q?TD/62fjmh8NySDKDXg2fvCZDCkc7aRhv8TVxw6GwTWegtrBYA6CENitpipi9?=
 =?us-ascii?Q?J4UJGRMACOhkkWHFjeQQwyOnKxZSgBFqkOtGA3vo9vmYiiksVRRX+gYLN5gc?=
 =?us-ascii?Q?PzDnzLewdJsoouDKupW3lyc9KS74h6RoqDwFEtTDt6GN2wwapfMANi1s6xxk?=
 =?us-ascii?Q?4gUx7YprqQuEKbSmZx5/gSixsKF9ZMJPlfhaNSNc470KMiUv4OaccVzrO+Bv?=
 =?us-ascii?Q?ZP4vG1TkdD+rPVlKSKqqxUNiTrK43qC0N//Hwtm5pL4iP/uQc6EpC7/6Hfk6?=
 =?us-ascii?Q?H9Hf0pFJqoTUT6X7y068twnYlo06l/n8WCSWEhpdq5a2kf3j1FeHClhi7vMK?=
 =?us-ascii?Q?zMRGymoKKnHwDij8OIrFmXP55wi8lTXqKK6dpdCTTyjk95uPh6hoyYaBrofB?=
 =?us-ascii?Q?dL+PDct/L4cn68GbxKxUhADfoisVE99S/k0RMqOBqKbLlXmVKhccD9i07HCB?=
 =?us-ascii?Q?m+JWyEMsEBQwBk7B3WwuPMa4E3kugf003jQ+1Rel6Ue7SIJSOIpG/qXGV3qG?=
 =?us-ascii?Q?vF4Zu8z2JGU2E+UWwLIKNmiIG8kZEVZnZaqGRJFskcntBPHeDOcozv/sP5d/?=
 =?us-ascii?Q?EbWM/n0/zV8wC+Xkb7P1DGjLIUWtJuWpGAoLysNHhA5gNpLjhXwFVdK+JjQe?=
 =?us-ascii?Q?QQGoU8PBP+Gp5mMTAfRb7w2oOqSmOdgG92b+VQwaIcFRRToHHWN0N53ShRlG?=
 =?us-ascii?Q?f0TO2EWrtFhNn73DbV6Loo29rfhMr1XY0JQRdLVj0CZiQF/zsMybZ5hhpZJD?=
 =?us-ascii?Q?+GIO94gjOx5APVlaSWd80Ytwq8HlrtCrLlKC51U14CCUvX+xIUAaD41k3mue?=
 =?us-ascii?Q?Xdhx4wo6vpsZNwRZoT/9laVcql0amA4a+Oq7B2ekxPEpFc0EbTljiFx4EcEY?=
 =?us-ascii?Q?8WaLpJPdHJLWfnDjM7Q/QVmwhU37gu8Df4ZzfP2DyrPQyHhCg6E+86QseyKi?=
 =?us-ascii?Q?SyHPkZT+zRxBCcz4E3M1pr8Z7rqGMzR9zz0r43LhtlzJi5CQdiiFeuRlkCoA?=
 =?us-ascii?Q?k2tX1mnBFmy08Iwt8T41YpXVP+tq1+sIt5LsgmJSFHt7pwly2VKZfsagz8A3?=
 =?us-ascii?Q?PWnXVc5cFL9gSuu9Wf3pe6TNe29PhIkUIxNYevsb4k02T7tD7fGEph62Y9CX?=
 =?us-ascii?Q?MROk6NzY9IhNvxXr5wT6ZkDEZt7g2iusECbxBvB3EljZpLsrBD9xMlBEzMT6?=
 =?us-ascii?Q?4AfAwJj1jHtF0k/l+pdjGMWLX0thWMXiiK+270eUuZccj/uut+AUAzaT17bE?=
 =?us-ascii?Q?WTghDMC6boz7KzWpucJUGENbO3IimlyLT5JbQqtr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6fa7605-bcab-4cea-1b13-08db08d406b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 06:24:54.0987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jQrCSeJNkfRpYUtSNUm7stAoBKkqMat0pCIRN0nF1Xl1mb3Ru9WnlAg32RsTnH21y3lrcas/gWLkhlg2mXcRug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5149
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 6, 2023 5:05 PM
>=20
>  struct vfio_device_file *
> -vfio_allocate_device_file(struct vfio_device *device)
> +vfio_allocate_device_file(struct vfio_device *device, bool is_cdev_devic=
e)
>  {
>  	struct vfio_device_file *df;
>=20
> @@ -407,6 +407,7 @@ vfio_allocate_device_file(struct vfio_device *device)
>  		return ERR_PTR(-ENOMEM);
>=20
>  	df->device =3D device;
> +	df->is_cdev_device =3D is_cdev_device;

You missed Alex's comment that the one caller can open code the
assignment instead of introducing an unmemorable Boolean arg here.

>=20
> +	/*
> +	 * Device cdev path cannot support multiple device open since
> +	 * it doesn't have a secure way for it. So a second device
> +	 * open attempt should be failed if the caller is from a cdev
> +	 * path or the device has already been opened by a cdev path.
> +	 */
> +	if (device->open_count !=3D 0 &&
> +	    (df->is_cdev_device || device->single_open))
> +		return -EINVAL;
> +

If we are gonna handle the exclusive open via dma ownership, then
here we don't need a new single_open flag inside vfio_device since
only one interface (cdev or group) could be used to open this device.

Just preventing multi-open in cdev is sufficient here.

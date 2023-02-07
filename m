Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E16968D108
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 08:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjBGHyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 02:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjBGHyM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 02:54:12 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E052A243;
        Mon,  6 Feb 2023 23:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675756451; x=1707292451;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N01nmsJB/z9ABls1vBcEQ4F8ebUIb4UOEo3exZm4GJM=;
  b=eRnadb229+sdWI0hqRMYWRvfnsttasAoURwAtqHbYIdnRpjLMAN5Acb8
   rLfHyYtcEILKjUDlcEKrRyJRz9BbWijj4JWbEfFn0JaNkfz/w80AcQWlv
   EwoAuyRhJQoSkjHQyk1ISfgGFLxNfXFbrPdTZLotEEdZ699MdGLtV3drL
   NIjsSYJWfRCarVtOqM6iKgV8B0GPC4tbduPODlewnEHDxocm9CCh3/ISf
   NvS7VfhII+fNEI5zUdVo2tPS336aj6Xg1mUT8H+RHxinE7YZEUBjj+RQC
   QO2DIIbAVbNhOh+P2c5BfIp0hasEkpErNHIz+MO9kPHbWf9qGC3YHnvfA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="313084288"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="313084288"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 23:54:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="809423350"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="809423350"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 06 Feb 2023 23:54:10 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 23:54:10 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 23:54:09 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 23:54:09 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 23:54:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bo7gvF6rifeqIxLy62WKiVB8hlHUTTmVtzoQWnPfWZk+tc0RqDVQ8BuKLpOsgVgS7E2CX7BmzJvjRWW0K+lt/g33Q4nEsMXAiKa0Y4XFHmhE8jrXL6ch89LL1BhF2p/FW/3mIP3jTk+ZcMz9D7MLq04LO3W0tDKr1AjBJPHhSPtHpNbYOYBYrlDXqrFxCkfhRYFM0EMLPrCBeYqhhL4APy6yqjgtTbuh7KeHi03YfVOwPUMjPhjlHIisYJ+HTzp+grlnWv2QsFBqcLnpFWN9MXlcdjLcvdL73GZl1QjS7KdmDhsyo3ADCqYI+D72cstpC1YzwFXnttEeEOGAc451Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pbeP79ldBBE5H7nBf22WzP6K/zl+cY0g2vLYIwUk9bc=;
 b=nfuQ5F8Y/JgSOJ9uhRymwdN2hi5xtKlcACJbVuTQMruDlOBURlevDp8qYgf8XlKuFQxSap0D/s/t52CsptJX7pBmBfUPIwDKTwvMM7ktRIDqtEkNZP4tD8STVFRWK2kLFXkiQZxjxZ5qVcKK9fw2JMDgp7tqpsRpom22FGX0U/vLNy0/biN/g5zCooNEj+tuXBO5YPhpj2nx8rm4Y7nPOaO6pATCjcUHj4kecOxg9Tz46hfFhCP0Pbtq+SnsG0dRQG53ofFqwqWzYBt7QWKT7FvLIVRKZpmJ8XS5UFWESb6f5hirR9LWuB76Y+fN3xOKhiz2EfjDUdFvlg5dsYDg3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4760.namprd11.prod.outlook.com (2603:10b6:208:266::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 07:54:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 07:54:07 +0000
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>
Subject: RE: [PATCH v2 12/14] vfio: Add cdev for vfio_device
Thread-Topic: [PATCH v2 12/14] vfio: Add cdev for vfio_device
Thread-Index: AQHZOgpE7PZdngC1BkqJuLKfKdQ4lK7DHWfg
Date:   Tue, 7 Feb 2023 07:54:06 +0000
Message-ID: <BN9PR11MB5276C404F6183D97A503354D8CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-13-yi.l.liu@intel.com>
In-Reply-To: <20230206090532.95598-13-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4760:EE_
x-ms-office365-filtering-correlation-id: 272fd4a7-ec62-4086-59a2-08db08e07d39
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Za7A2P4Dpb97I6M9kMFdcmqU/8HNHGiGFso9gN3bahHAPrJJLjH7tsXWXCyHRULIKJo1mhiAlEqH21xenk10dlln5xMj7In1zXPag+IHTDH4zG4D67MXN3419M1e5GO0ysg22sUB3at6V80SBgYm46B2k3EO8FfmItY56LkcHZA2M62vZxGsKibWjenNgmhuK80NG6fca63QblgNcMcOu8xW4UfzNzjQYm1i5nbn+IIucW8v1+3O5vjI2rJD1S+fMF0PPd/KH1icOkYKmZn2lii0KnQfmlm7xxISMoHLZs1jcnRiNWEoiH9niP+de7PQwoTDAD3nmV82FEcdEAmvm+/PuRyPyn93JWwlD+UXnVH40QiZ53RTATW80yhJ5g71+g23ei4ACtSw3fyXNQxh2AQ+cikn+XrfOI3bb2E3utH1yuve/lHlWkDORMT3aqYAO2Hd6N78omCh3ktw3HvBFLG6FDYM3QfSmo1aIyLzCw7RfzoX1Pr62XcCwN81ZZkL7158gnK43SVfV9G5g5rEXP1wySaucxVhTSmuEWHjWjfSJJX9Q/JsBe3KDqdzlGDassYboEo1wuf7UccPKvGZELeUq79qAyOjrBdpegR0h+IwQuBSIVY2wMc4jQjY+/PIvEPAp3hChRQwQ5Y9UgLS4P7mWgHx0ir0DVE8T2GAvTuD/tTyKadwFLX3f30rKn2SB9o8GEdKTbHApT/4U8SK4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(39860400002)(376002)(366004)(396003)(451199018)(64756008)(66446008)(55016003)(478600001)(6506007)(8676002)(26005)(186003)(9686003)(4326008)(66556008)(316002)(76116006)(66476007)(110136005)(66946007)(7696005)(54906003)(71200400001)(38070700005)(122000001)(38100700002)(86362001)(33656002)(82960400001)(83380400001)(7416002)(5660300002)(41300700001)(52536014)(8936002)(4744005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fW8NuCrb3bo0zKKYzi/ezVZlkIZD63Div3+FOb/o6lk8H9R70WJxgj2fGpT7?=
 =?us-ascii?Q?bayWXE3ZHgLuVlMiDfb5kl+GGYBu5mmQcpyV4YljEb/fNItZlgBypcFqX0ln?=
 =?us-ascii?Q?jGEYT7bTP2xIWGK0/07W0Mhi1IcCKsmmbtVworJvqS/xytnc8orEE2z66UT/?=
 =?us-ascii?Q?FgjfG3s3GSHV3s9z+Lup6ztSi0xVTwNNG6e1ymudVI4n4V/uRmBRk8puWDZe?=
 =?us-ascii?Q?HKHrzGNzv321zJ5ZMo01WYbuC5ZVIm6gBgxWihBVIEpS+X4l6HCtBqirFZkO?=
 =?us-ascii?Q?2PMas9XRwtrHQI4oNJdsNfML2z/yM+16vsi2K4oV+To+pAiFLhBvEa2rc51v?=
 =?us-ascii?Q?VwsvLBFAiQoBoR5dyOuQ1FVKK34a3LbCWIig7ucS7ZvxleOvinp7xf7RGs3B?=
 =?us-ascii?Q?Tt/BAO1feb9mJkvo9owOb2+yBIlF6jGQ+kPIHnbavCu6flGcgCFgVPrmGL6I?=
 =?us-ascii?Q?eOc559bE9HkIFR03TVeTZMv2c065txAdCSI2NCNZWPYwsEk7+5ijd1OnGWGX?=
 =?us-ascii?Q?Yoidp7fxkZcYqyfjiBo2XZZ3h87m87t7ckJzxJq1aRPXvsGbLCRmlhr5/7e7?=
 =?us-ascii?Q?m8pIG5aF1A0eSNArxh0fY0d96Hc/3III3zxXPv7/ObnRiX2Hwjje+DnjzVKa?=
 =?us-ascii?Q?hTNX2A/zvHNJgH5CrW3GhWs2duTp+vSavwbAIE+XPsU5FY2VB/kpEzR2lmb2?=
 =?us-ascii?Q?lfRFRoQfxjcHK8grKBpXR0+69wv8NOtvzC5bGgTog6d2hAcJtzS8tLrr+QNp?=
 =?us-ascii?Q?ef+aMTZKAYklwfNTsoeZy1hEeB+ZcCwaoz1FNSA/iEipkhOp1WHtnoPCP2hv?=
 =?us-ascii?Q?BQU94M1rfLeB8OWHE4jpwQjNLfG1VYlTFCZtgNfw5jhPT94D4Zo5Uck4qzVa?=
 =?us-ascii?Q?4zj05AVbLOg7OQ86lKj7uQ8AKiGeQq5ZPVXpageDAkDf3BXS4Co6Z/PP53H3?=
 =?us-ascii?Q?1KCIMhBt/IgBpLWzuviskMQdmmHHZOm4bZPtRZy4m2TVX+WaiBA/XTL/eTk4?=
 =?us-ascii?Q?xW2lp9WM7nr8WlV59F62G1BJPp830ddl3O/5w3UYIOplKdxazttNWc9LNmYe?=
 =?us-ascii?Q?llceMLdfajRhxK4p6Uq0GZbRwU1nXbN9/j2UxQj0nYuosOxipv1jjTZF5XxQ?=
 =?us-ascii?Q?UaHI/BrTaGIlGPo8TwhWf9sHRL7MKU6OKjuSIx62tuMc4IKQiillnNmt+XK2?=
 =?us-ascii?Q?J4e/WDX6lf8mBHWnJkJBwEMwZyCFpLFeevlBaNNaQCFBNd92s75964l5g38+?=
 =?us-ascii?Q?9aM6PH5RnYK7GvbqY5qEUh+oqBYuPC2er3rjNA5Ka0ZI8o+Cb+ZioiIGaf77?=
 =?us-ascii?Q?R3Ny2ut/JMkrWdw1Qg2+MTlfvkP+AqDl9S4ku2dYHpAHWZXuRMf2cwe4gAbH?=
 =?us-ascii?Q?EvnBq2w3UPTH0Jfk5eejNL4G6EPcBy6unoi5fTtLSvSor1aWtcE0rGsXHVEb?=
 =?us-ascii?Q?DH8FQqcQxBeTK/cH3rJzNif/IBqaeOU/eLuyihfMSyXUpcaGsd0+l2LvrgnH?=
 =?us-ascii?Q?PXzgoBLVydy+Bpv9MYQuOljXoV72UkMGHlj+vjjQ6fARmmG9Cm0Vjr0i6W5Y?=
 =?us-ascii?Q?GShwCAITEK4L+78RnsTBbPECF5iodaxt+bZ9AbIP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 272fd4a7-ec62-4086-59a2-08db08e07d39
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 07:54:06.9351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9tr5uR74VKnxN2ur7bZdY6UjDNRSIWfEpW9XftwwPmi+OkdiphQBCwXKc9m9n+4IkUL6EbvSHxnaTv9yn9TFuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4760
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 6, 2023 5:06 PM
> +
> +static struct vfio {
> +	dev_t device_devt;
> +} vfio;

the structure is meaningless.

> +int vfio_device_fops_open(struct inode *inode, struct file *filep)
> +{
> +	struct vfio_device *device =3D container_of(inode->i_cdev,
> +						  struct vfio_device, cdev);
> +	struct vfio_device_file *df;
> +	int ret;
> +
> +	if (!vfio_device_try_get_registration(device))
> +		return -ENODEV;
> +
> +	/*
> +	 * device access is blocked until .open_device() is called
> +	 * in BIND_IOMMUFD.
> +	 */

this comment is more related to the whole function instead of the
following allocation code. Move it to be the function comment.

> @@ -51,6 +52,7 @@ struct vfio_device {
>  	/* Members below here are private, not for driver use */
>  	unsigned int index;
>  	struct device device;	/* device.kref covers object life circle */
> +	struct cdev cdev;

only if CDEV is configured.

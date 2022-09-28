Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546705ED3A6
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 05:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbiI1DvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 23:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbiI1DvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 23:51:07 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96EA101964
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 20:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664337065; x=1695873065;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nekHLZcbH9ieecuM7gbtbZqsZy2+5dMGZZjm9Q361vY=;
  b=L8aTotW5TwNWQeYbY06scTxrNzHUI2gDGkkrDkndreW0Ieh/J4m7s9KM
   Y+6FJ8PIKwDS6p0Crtgbnnbbp5MB2auxOCDViESscRcnGDWXlWWPiscHO
   EjXEXtyzPMc07twV6LpKdSjqMHMcArEkEdkOAREIm4YejDdCtnrLgPqsU
   JmXltVGmTZX4gPaID8Ug5J6WZC9hqU55d5AnXyltikAklYBLGnaWLalL9
   0LPlheYOn3s3CZga4yvUt+PRR0WxK876PnjTMlUfHIi7ZAnjyA69q54FV
   EKNKO7M8Mv+b4ImcaCRgPJLF+fof7QTP5QRs1MtzRZ/SaNgcqBCkiWv35
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="300214211"
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="300214211"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 20:51:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="623998615"
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="623998615"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 27 Sep 2022 20:51:05 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 20:51:05 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 20:51:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 27 Sep 2022 20:51:04 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 27 Sep 2022 20:51:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIKpUG3OMbzlq1mLFkDJyiwqRLjhek9tr20IUPyPnOrLVFtbKnMjid0BtrKh4diMSYgg23AZOTZmGC5PzbtPjA1M7KI9S4uZ/XAUo1oqONnPV6I9kFKYvvFYQ5jbaokXyL6FXyxc2fskArBsHrvz/HaWmWDDoYX+QTnUy1xtsvXu94TNiNpMvoUeKMq80XO5DQElMyU+tSUBAI1ogzGXi934ggEidvLHK1cUwNSSo3ItvYhRHUkVbH61sNrzcOPuEbG8l/pfe+5YF1mIdn5WJmFpjF5foraHF5McWF/uKaq4AjxaDqdriAsuYzVqKf3hpWLXiX5U0M0KGFbcrIIVRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94CLBdBh/k8RRgiMjFNY1nLPobZyr7xhtLgkx5Q0kKc=;
 b=XGlW1mQpWWOFelVaCSSa+ABwC4tfrN7TfsL0/Vc52dBLtYak3rT4g/JDLEFz3NH6/7yZDjgqKD1CEOfEU4jCL0D9UmhlOD+f3NYgHvvkfpfAkAW5rSfVwI13OhZQdueRR9za7nh88BqsUU+fnWecyXg3rXPLKP3d7cE5ZTqg2M22yho0H+yp+8GlssbL3yBINEu++FQ2deotazb2F6pcdtzqv7iTPJOb0/+fmP+kLl+9N+/7nijfuGs1bkd5eLmqop1zkZ/va3apMY1SlJXqMgmge72Fw9fNWpUkf3jOQpg5Uyh9WEsfcWbsfetHs6KLzkBMaKT2JIVoOCgrAwYLVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7113.namprd11.prod.outlook.com (2603:10b6:806:298::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Wed, 28 Sep
 2022 03:51:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ff76:db8b:f7e9:ac80]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ff76:db8b:f7e9:ac80%5]) with mapi id 15.20.5676.015; Wed, 28 Sep 2022
 03:51:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Qian Cai <cai@lca.pw>, "Rodel, Jorg" <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: RE: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Thread-Topic: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Thread-Index: AQHYzuBaWYUDg6E9Sk+I6S3tW6vjE630OQTA
Date:   Wed, 28 Sep 2022 03:51:01 +0000
Message-ID: <BN9PR11MB5276ED36A2F498D37A18DCF38C549@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
In-Reply-To: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7113:EE_
x-ms-office365-filtering-correlation-id: 0ed6cced-bf7e-48f8-fdde-08daa104a947
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F+CMGKJnq8/6SEwkAeSNsabac2Fsau8JAlDCz9eIdh+1h54DNybai/U4gMUlLwoRZAqoWv3/rN9EZ9Hevq6i2i39LxG9KdXkUQf6YCJt2Aw/kzwzLOaL1zyjQ0WcoXlXkj++gwUIBGaeFTwIuKrZbNqAlwaHm7F03LZy6S4UCDLugSFktqCOv0ZUQv+ENez5SkKq/p6s0JFE82LIrZoD2wfSTUZ1PyWuGywG8xrNcixiU4zWw/q6C3EK9XshlBm6+2Ae/T8z15g63ksvGVHW3+9NcgIUg73ace+XzJVlXaM2Jhxcg9cbUYpDSGIYMMO6gu1Wzl0xb2lBLPyc2oJh8A2A09o3E/njHBe7eVNZQ8hy8q4ukiQb9oEbZ+LaVlouvYCDH4Nq8kXsCLGdF2wjmuXa9XYPW7+7yNJRYcsDTLgnx3eqj2xSICiO1zzQGkxLfz23B+7Ljqgy5+aZQAjQBVIamQl4LQgGkEZ5fi1JAj4whJbyKPuzu84V/70+EafiLHjGC1+07UJ4uBTt4Do8608KJfKo68h5pgL8bu7MBzoQp3okwp80+LJB4fH948WD7lO0eenPfSxIkWPDCdaGzc3xCWGaQP4MXPFssn6Xu2l6L1s2O+AXpMas2zZ2QuPBP4A48XTqWxxM022fPn6nKAQ+c2h4HWaburOLJqJOHfGfLaf0aTEjbxiHWqg2mQFJfNc/TikIqSv5GpV81RtUL/El0p5A9pBlh9uEU7zyo0BT8eriBJNQZMWJqlkwtNTlxHsYk/DyfnI/vAnki27G6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(366004)(396003)(346002)(136003)(451199015)(316002)(8676002)(8936002)(26005)(86362001)(52536014)(110136005)(64756008)(33656002)(54906003)(5660300002)(66476007)(76116006)(66556008)(55016003)(41300700001)(122000001)(186003)(82960400001)(66946007)(38100700002)(83380400001)(4326008)(6506007)(7696005)(71200400001)(478600001)(66446008)(9686003)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MKG7UQ+CPyeGqnv077CMCMv3quch98U1ERTV1f76lqB5DOCkedFvvE5+pQrU?=
 =?us-ascii?Q?klZMYqcK9heYW1PvgtdGTB0YuyBdlUb/84mX4b7Yba2GQAhKaTpjTQbSnBW/?=
 =?us-ascii?Q?HSeoSBXt9ezf4rViD3daMAlReJIQxgxPerb6DBgwz5BtUxw7Qc1aXJubIv20?=
 =?us-ascii?Q?TJp/G8RzWiZORmmQ+kDV8qt/4WVrWnMkNpK9ZHQpv9uEnYB3joYGL32UO19p?=
 =?us-ascii?Q?CSNuD5QDtINb4sK/wBMNEH82GJpAVgXpLCS54f+MLTSZocCkHZ5zg0TACtaa?=
 =?us-ascii?Q?ltTC/cNjTEhV6CwZtZdAsBldsXnLTXLA2HVFX4corgH+ZmtPDHrLYnLZRKWi?=
 =?us-ascii?Q?ey2ApdeZQTpPIXh9a9SdBqb5OEDuXIVK61sIi8F75Bgaxp2DlCB2cwhZTcRv?=
 =?us-ascii?Q?bSliCuvICuqCnjxoRYjizDniQ0KGCeRfL2+QVXOQWBpxTEzwuGYf+7bdjein?=
 =?us-ascii?Q?ytxzoc8udKcqnHsMZLoy/NOK5EOCArnomu8vRLV4XK3cAGRKdjSvNGKZZcsj?=
 =?us-ascii?Q?/brRL/ruMh0IiJVaJraanmKPaR6QXjoWI4S/eOu3t3TFYTDYQfKmRM65YNMT?=
 =?us-ascii?Q?iPt0QrTwnMFJOvJD1biKY5ImOpHYk+TyG2mIGIBR0TrePuLh5UJE3hNKFCnq?=
 =?us-ascii?Q?UaldX/V40pzn2uL4nFFA5e6NU4N15opqD6os6nK0taIy9zdLgF37DG2aOUzs?=
 =?us-ascii?Q?m1B2uyCnDlsSwqeqJtVXNLrg3UFk5FnTy648JqYANeNUf7HwPH+8Fldo7aB+?=
 =?us-ascii?Q?w1HnDYxNwap+tYFwE5+zzrugHp9jY6QstCjFDtXeLDciTabEvPlXzvV14xUS?=
 =?us-ascii?Q?Uf9xI3iZnc9qZTM8smXKRlPIiyBPjkZweKd0tOczOQUahPacc4uXQ39tdbwx?=
 =?us-ascii?Q?DXAYj1raoIhh/vffCrifm5pKJxqVvGkWwIMLCA8jNKOexv93fyqiUWCq36Up?=
 =?us-ascii?Q?jyfOFdCPptFreZ6qwe6Kob2inACyI3BxxiC9jsFkyI+CR0G1ATKAPbiJP03Q?=
 =?us-ascii?Q?wMbhL4KncLDV9eB8ngy58CPIZ7y/wVWUl19zslsCJ5gNI+KbEjut9aHHwofE?=
 =?us-ascii?Q?jejf8ijofaOfwOE8MiG9N2/VSgb+pyUlhkXUyADL3dvxCx4Dy5rm8JjO8LsR?=
 =?us-ascii?Q?2tHVywZVSBNz0njyst+PoMHUo2U1vxBpNdOFs9Oa7RE6Ye60pd2AitVSzF/5?=
 =?us-ascii?Q?BWuBA7IIrWDCH4SP+NRWvuOqFAeofKXOlUXQUMrLLPuLkdlNeLpNdVhRr+qa?=
 =?us-ascii?Q?cOopQrHTW4B19rEgynaGGKlErXGvXCjl0869lvtfE+SCYmcxzpXRTAWcJ5df?=
 =?us-ascii?Q?eeapu4fqS3IE9/CFkr5xCqpXcRt12CAZ7VVVFEO5tUfUSQ4Xjl1t6X1II1oA?=
 =?us-ascii?Q?ZUwEWm5HIvgAnzf9HnC2JhS2kXJtj4k3OZchTM1NdNOf5PPHrHKr97UAGioM?=
 =?us-ascii?Q?sP7HGD5PkWKbuOrrxcFBcC7u/dlC1DjbMFbR78vkgPdnoXzjnPOaU37bYADB?=
 =?us-ascii?Q?X16Dlwp0zm1s7Qd1xpNm/RXYsdiEWyvinkYT92so7dwiCsBEd4O2osQLwfkC?=
 =?us-ascii?Q?JOjOdV4xWMPJvY6q2gmtiNvZ2o7rjSHrDHRKemPB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed6cced-bf7e-48f8-fdde-08daa104a947
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2022 03:51:01.7836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gjB1dYMRBhOqoL5MupvntW42DCFKo0xcnNhP4jc9qCAz5wpOIIqxGaOQPxieHBSk+hxcXSy6k9AsabokS3sU0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7113
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, September 23, 2022 8:06 AM
>
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 56fab31f8e0ff8..039e3208d286fa 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -41,7 +41,15 @@ enum vfio_group_type {
>  struct vfio_group {
>  	struct device 			dev;
>  	struct cdev			cdev;
> +	/*
> +	 * When drivers is non-zero a driver is attached to the struct device
> +	 * that provided the iommu_group and thus the iommu_group is a
> valid
> +	 * pointer. When drivers is 0 the driver is being detached. Once users
> +	 * reaches 0 then the iommu_group is invalid.
> +	 */
> +	refcount_t			drivers;

While I agree all this patch is doing, the notation of 'drivers' here sound=
s
a bit confusing IMHO. Given all the paths where 'drivers' are populated
are related to device registration/unregistration, isn't it clearer to rena=
me
it as 'devices' and make it clear that iommu_group is invalid once the last
device is unregistered from the group? This kind of makes sense to me
even without talking about the aspect of driver attach/detach...

>  	refcount_t			users;
> +	struct completion		users_comp;

Now the only place poking 'users' is when a group is opened/closed,
while group->opened_file already plays the guard role. From this
angle 'users' sounds redundant now?


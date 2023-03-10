Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612BB6B3422
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 03:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjCJCPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 21:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjCJCPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 21:15:38 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BA81009ED;
        Thu,  9 Mar 2023 18:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678414536; x=1709950536;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JBsY06RYtu8sHPHJRqU/pncbNtFAEciBTSgFEDyOKW8=;
  b=DTC3gr4aNKmpC1NAQz4eCq/HMWpfKnzyGZS11m8otB0mtTiYw6sBYv7/
   cGBDnRkfOThGVOsUSpqOfJoP8tpsZ4aLtD2AdC1m6Sw5C7J2FHOYY8BfR
   cKr7J90+/sSqL97aJrRzc2KCklSbGG7XltXc7XfQORZ+jq0RUd8jXaAce
   JN8WbOf95blOz+Dl9bWigsbcZvmiGPcZM4Cajxi/Ui5JYlovdVdY1sgha
   fdYFJ49y1y4sjGrN/WXln810AP+7W+KBPmWbiEBrNwvyeTt9m0E7iUMjL
   zwXUSIWEjTTZFGyC5rBWKqzvdRVFupJ2G5JOsTBt1xTwdlanRaHoRmhZv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="338988988"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="338988988"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 18:15:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="710099039"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="710099039"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 09 Mar 2023 18:15:35 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 18:15:35 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 18:15:35 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 18:15:35 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 18:15:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9euPvY65N53NMd4Pbpg3fDc7YWAFPmhvmI6ywu4xs6tRF8eeagI4ZYdvC8n215tvPu+ttPzoOVbZaHByVouv/emZYnifw7hXXQ4PjscRsc5o4VwjbcPHeRpcR/LUcUCwmUBd+am5zwbvk2ANKiaVyW4YmyqokmFyebq5Imn2wMn0eQiOhPr/hf8jPGIJz19NiJmaLOT+INHvf6ET8d/Rsv2HadiYdRkL79hoKwe0l4nl0iRQGZrKG+oJq6XjFUtHMmEXV2XPrc9aXMPv9GIkTEM1/3lPtc14pbNnoOCD9jsoaDmJe+7wzPfXEC6cWRe9AvkvuuaN8iCxg6ktgsFhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RHLfbmqhzGm70/p2bAYukudWF5pK77j5b1LyxRsjY3E=;
 b=neVdmspV2l7cSmZqWsG5Y2lb/z8tpKmi8R21v+XSuVzwOhIT3APmkaMGI6QzZ201GyU4iCLbJL5KoUhsVzUscoahHLWGIZ9r+onVjyHzJMXkm1awDwhHmQliRS0F+UDSf0gWSSHdh4dWm3GVtJmQKzi+FlYMOj6ZgTfDfvNXht8cYHQhrmrqUGJv81+IzaFF8F2FyOk2/tmXoBPWSRQnG58qA27csUXrRh50gTd65pGjggI/NPmkblXHDRZCWYDGn4iQYGz9T26fQoYc5Yx/iK7NfWXZDwWfd/5K+COjI2WqueYKOf7qLLeCkfmdnw8XC+ZEVapYzskkOK1i84HicA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7778.namprd11.prod.outlook.com (2603:10b6:930:76::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 02:15:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 02:15:33 +0000
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
Subject: RE: [PATCH v1 5/5] vfio: Check the presence for iommufd callbacks in
 __vfio_register_dev()
Thread-Topic: [PATCH v1 5/5] vfio: Check the presence for iommufd callbacks in
 __vfio_register_dev()
Thread-Index: AQHZUb/ZJ6hrFx1b1EiVQiMXNtKcfq7zR4xA
Date:   Fri, 10 Mar 2023 02:15:32 +0000
Message-ID: <BN9PR11MB5276BA4E1FF1345433FB8D338CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-6-yi.l.liu@intel.com>
In-Reply-To: <20230308131340.459224-6-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7778:EE_
x-ms-office365-filtering-correlation-id: 5abf7a29-e1a2-4824-4f03-08db210d53fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H0ZxJNtSEYYY1tMzsMMM21VawYvpq/LqjU40kIfJGiuMRKSDsCowVeKn/6ryl0zvCiXsDi+GkhiUOWx19GFMB1FEEK1dcucVKkr1RK+oCJGRYZfKYSaZTnl3LMBg34YZHSSzv3q41SrElL5dCYh6bgxuDa8F/8G30gHIIRtRuVQ2B3eNAImapogW+3cJbiU9xtmIbMTGrwCm1pO50OMKPatJpCH8kckskLwQt1XGCpuAmqxFxqUzp+uLSLGC/3wKiWk7OJykBErZFpBb2/t2s/AT4KzKVnDr1vKtbnzUyOungTwzeCzvNKNSnbo/ECIsesb1z7HuSJ3kUpG0zwMZUNZXGgR0hjZC/yV0Setjuz2+pfr3W543bSdww7/lCGsgKHbNTaTHR/AD8fjahZln0KrJDePqQzOkl94BhBjOXJHtt9xqcb1NvTYgA/PArTlNv7ASRYi96Fo6IdID+nuitLAwMCaTqTLGFUtGqIrxFsSYMJ/wC+RhZgPd/04XEuledqtOidTziwnVNvMq6UYJ25WhfMkwNGchNh2P6fXu7UHP9DMKN8HrRwlr2IisSZ7DCLWbhS2xcds9yLXio446sqvgGPWeqIuR0ENre29OOvd+btETbky7DqOHL6Lu+Z03EdmNF6KPhKL52GjT4PY+ta5PwEaU6gDzucuIpO2dyBh2JdEoIfcZA0qUnyQs9UG5jepYb5d+lMM/KmG56FxVgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199018)(38070700005)(33656002)(55016003)(86362001)(478600001)(83380400001)(7696005)(71200400001)(66556008)(66476007)(66446008)(64756008)(8676002)(66946007)(76116006)(110136005)(54906003)(186003)(316002)(9686003)(6506007)(26005)(2906002)(7416002)(38100700002)(82960400001)(122000001)(52536014)(8936002)(4326008)(41300700001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TtlhuLf7mcJ3Y2zr93OOlw+WxEj7KKSZ3kmctAjJwBOQhV1bVBft0v8z/cYe?=
 =?us-ascii?Q?IYZGCTYFLp9SG/MWBXTZoor5tEj8X9Ws1DpJY/cEYDLwgz0U0zBKy/2kYsBD?=
 =?us-ascii?Q?q06joHB9wpWo5e9sxkG+iCleEJq+sGzVa7AbGtQnzq9giB+FceISR9kQELmw?=
 =?us-ascii?Q?GcStDk5PI7vGq1E+l/nUmD/SLCJV1wcK1dn9ox3W/R/vwLSxxwqoL1qPhJY6?=
 =?us-ascii?Q?IKYucMajQkOiIPmDouZmanYN9RGuAfmq8EmAg5DkZlzKV/X8uOMZXhdtmwVU?=
 =?us-ascii?Q?WEXLocb4QTDQPCuq2v6iqM2+QFHCVsFWNyQ+1xJsrmUlxMcHZ5J5+mqptv77?=
 =?us-ascii?Q?9ZG1sLZUJw08YgqyUaqy+Db0SBPyTG80UDnQhrzZQS7EmiMH6agzXEC9TFOr?=
 =?us-ascii?Q?MxPpBqQzZoUo2w7ztoP9pi8ecFKlpv1B6NnSjNSYAA+qb7QhTMWjiCFirTDb?=
 =?us-ascii?Q?GVlTWgka88+WFJk/ylet4ZF+ILYgrAATR9pvU+kfmqvOriRz4a/j4MTm7Pyu?=
 =?us-ascii?Q?f7U0pGiRxX3VjdC1Eb0gTxL3DjXyQjWXWX7yVMv/fLIaCH+wrCxCkQMpMdln?=
 =?us-ascii?Q?L+qjBbknyWWxra0rtTLByJZ2vvGq/eeKpdzaHN76a8T1gJqhjbXD1RO3hOsl?=
 =?us-ascii?Q?Yw1sIqOlZr3yDW6Yc9NJfD75DteS8MnG6HYPGgNE5Bg8cV+Uwst3M3a5HRg3?=
 =?us-ascii?Q?iM5qDB7r4Vku3T6Qv3uA2VK/VtMIbnaFEWXCmod5hRg4AJt451LEVFcjLA5s?=
 =?us-ascii?Q?kYm0oP50+FfGHYDmcjH4EPv1+d4aFAJO61Ck60vXRuvXY9yRDmKPBRL2PJF1?=
 =?us-ascii?Q?IUi2uqtcUxrwhS6igdpOXm4ztdhjrAGwaFob3h2+PZIi4K0X1zNtHhhkIncm?=
 =?us-ascii?Q?Bt+FOQxFubcHogyacIj4d1LYBP105VQFK75a9ppE9QuHZznc7LH07Hrg9eod?=
 =?us-ascii?Q?2ZGflzF6A2US5E+ufoB9kP0tFDd9O/3maLT8TmLZyIqotSmUgdtIPVrrudtP?=
 =?us-ascii?Q?1ty1KOIvsAt7o62jTUh6/SYwrdBk0ODG7+eZ5iGWL2jxk3+lTOG46pleGsTc?=
 =?us-ascii?Q?SXQEYnoFzkczdCItkD9HpCsd0eI4vxGxWhhKyZMQ5Gp5JGIliafaA7KsuA6q?=
 =?us-ascii?Q?05vnC1PYWkZVpr8USaBdnCWgQvl/s08ehwILVaUfvojpnW52GudBQq6yczzO?=
 =?us-ascii?Q?p4dxAVWLmHAl/TIW7i7kkXI3ppohnX/8RhMVbFSkdsovO/u8BJoZTrpdI4h6?=
 =?us-ascii?Q?NzaPhI/A1bTUvyD52hKS2++caZ7LpV1mPyGsvQp+hVxSohoqIGCGcX/VlnMd?=
 =?us-ascii?Q?R2U9v1uoAF/TMRTMs0fQ4xymGqtqqp+EHZO/KujkZ94iOONNvMq+CxPF5qLq?=
 =?us-ascii?Q?lSq+KvWL8jPIHVbGF411LkqQUEXisHU/ZoRTNbvF+y+C4YLTnPjs4iVVH7b2?=
 =?us-ascii?Q?LKmyZcxaltq5Sl9Q1cADq/WLUIEJlJ695iL9QMCqKp0Bpy5P8db/tjNKgyLO?=
 =?us-ascii?Q?9DMvBFwuhoG/GexRaJzk4uiq082pAg/wmgOwBkBJV79H/75g8EexXiJHFsoJ?=
 =?us-ascii?Q?OaA5YRwGW6Pl7ReGZUQCojyJ3zlUTf6CaO91l3oQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5abf7a29-e1a2-4824-4f03-08db210d53fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 02:15:33.0133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fjDc/QcK5CtlQSoQEmDnUGtqpfSZcZldTDHR3tQBsp1qDXTYn9VXNdOtKSpxCspMbOVFL8eR46I3+hEmspQaew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7778
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
> Sent: Wednesday, March 8, 2023 9:14 PM
>=20
> After making the no-DMA drivers (samples/vfio-mdev) providing iommufd
> callbacks, __vfio_register_dev() should check the presence of the iommufd
> callbacks if CONFIG_IOMMUFD is enabled.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 43bd6b76e2b6..89497c933490 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -255,8 +255,9 @@ static int __vfio_register_dev(struct vfio_device
> *device,
>  {
>  	int ret;
>=20
> -	if (WARN_ON(device->ops->bind_iommufd &&
> -		    (!device->ops->unbind_iommufd ||
> +	if (WARN_ON(IS_ENABLED(CONFIG_IOMMUFD) &&
> +		    (!device->ops->bind_iommufd ||
> +		     !device->ops->unbind_iommufd ||
>  		     !device->ops->attach_ioas)))
>  		return -EINVAL;
>=20

I don't think IS_ENABLED() check is necessary. those ops are
defined in the driver side w/o a conditional CONFIG_IOMMUFD.

We should warn out lacking of those ops to the driver developer
as early as possible, instead of postponing it until someone
starts to build kernel with CONFIG_IOMMUFD.
